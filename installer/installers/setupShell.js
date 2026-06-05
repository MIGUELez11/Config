import { cp, mkdir } from "fs/promises";
import os from "os";
import path, { dirname } from "path";
import { fileURLToPath } from "url";

import { execa } from "execa";
import ora from "ora";

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

const REPO_ROOT = path.join(__dirname, "../..");
const FISH_SRC = path.join(REPO_ROOT, ".config/fish");
const STARSHIP_SRC = path.join(REPO_ROOT, ".config/starship.toml");

const CONFIG_DIR = path.join(os.homedir(), ".config");
const FISH_DEST = path.join(CONFIG_DIR, "fish");
const STARSHIP_DEST = path.join(CONFIG_DIR, "starship.toml");

// Tools the fish config depends on (see .config/fish/config.fish).
const BREW_PACKAGES = ["fish", "starship", "zoxide"];

async function step(message, indent, run) {
  const spinner = ora({ prefixText: "- [FISH] ", indent }).start(message);
  try {
    await run();
    spinner.succeed(message);
    return true;
  } catch (error) {
    spinner.fail(`${message} — ${error.shortMessage ?? error.message}`);
    return false;
  }
}

async function setDefaultShell(indent) {
  const prefix = `${" ".repeat(indent)}- [FISH] `;

  try {
    const { stdout: fishPath } = await execa("which", ["fish"]);

    // Register fish in /etc/shells (idempotent) so chsh accepts it.
    const { stdout: shells } = await execa("cat", ["/etc/shells"]);
    const needsRegister = !shells.split("\n").includes(fishPath);

    // sudo and chsh prompt for your password on the terminal. We don't run
    // these behind an ora spinner: stdio is inherited so the prompts are
    // visible and can read your input (otherwise it silently hangs).
    console.log(
      `${prefix}Setting fish as the default shell (may ask for your password)`
    );

    if (needsRegister) {
      await execa("sudo", ["sh", "-c", `echo '${fishPath}' >> /etc/shells`], {
        stdio: "inherit",
      });
    }

    await execa("chsh", ["-s", fishPath], { stdio: "inherit" });
    console.log(`${prefix}fish set as the default shell`);
  } catch (error) {
    // Changing the login shell needs a password / interactive auth, which is
    // not always available during an automated run. Don't fail the install.
    console.log(
      `${prefix}Could not set fish as default shell automatically. Run: chsh -s (which fish)`
    );
  }
}

export default async function setupShell({ indent = 4 } = {}) {
  await mkdir(CONFIG_DIR, { recursive: true });

  await step(
    `Installing ${BREW_PACKAGES.join(", ")} via Homebrew`,
    indent,
    () => execa("brew", ["install", ...BREW_PACKAGES])
  );

  // Persist Homebrew's bin on fish's PATH (the zsh setup used to write
  // brew shellenv to ~/.config/zsh/.zprofile).
  await step("Adding Homebrew to fish PATH", indent, async () => {
    const { stdout: brewPrefix } = await execa("brew", ["--prefix"]);
    await execa("fish", [
      "-c",
      `fish_add_path ${path.join(brewPrefix, "bin")} ${path.join(
        brewPrefix,
        "sbin"
      )}`,
    ]);
  });

  await step("Copying fish configuration to ~/.config/fish", indent, () =>
    cp(FISH_SRC, FISH_DEST, { recursive: true, force: true })
  );

  await step("Copying starship.toml to ~/.config", indent, () =>
    cp(STARSHIP_SRC, STARSHIP_DEST, { force: true })
  );

  await setDefaultShell(indent);
}
