import { execa } from "execa";
import ora from "ora";

// Installs fisher (fish plugin manager) only if it isn't already present.
const FISHER_BOOTSTRAP =
  "if not functions -q fisher; " +
  "curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source; " +
  "and fisher install jorgebucaran/fisher; " +
  "end";

// fisher/git/curl take a slow (or infinite) path when stdin isn't a TTY.
// Inheriting the terminal makes these behave exactly like a manual run.
const EXECA_OPTS = { stdin: "inherit" };

async function step(message, indent, run) {
  const spinner = ora({ prefixText: "- [NVM] ", indent }).start(message);
  try {
    await run();
    spinner.succeed(message);
    return true;
  } catch (error) {
    spinner.fail(`${message} — ${error.shortMessage ?? error.message}`);
    return false;
  }
}

export default async function setupNvm({ indent = 4 } = {}) {
  await step("Installing fisher (fish plugin manager)", indent, () =>
    execa("fish", ["-c", FISHER_BOOTSTRAP], EXECA_OPTS)
  );

  await step("Installing nvm.fish", indent, () =>
    execa("fish", ["-c", "fisher install jorgebucaran/nvm.fish"], EXECA_OPTS)
  );

  // config.fish sets nvm_default_version=lts; install it so it's ready to use.
  // This downloads a full Node release (~tens of MB), so stream its output
  // instead of hiding it behind a spinner — otherwise a slow download looks
  // identical to a hang.
  console.log(`${" ".repeat(indent)}- [NVM] Installing the latest LTS Node via nvm...`);
  try {
    await execa("fish", ["-c", "nvm install lts"], { stdio: "inherit" });
    console.log(`${" ".repeat(indent)}- [NVM] LTS Node installed`);
  } catch (error) {
    console.log(
      `${" ".repeat(indent)}- [NVM] Could not install LTS Node — ${
        error.shortMessage ?? error.message
      }`
    );
  }
}
