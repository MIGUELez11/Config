import ora from "ora";
import supportedCLIs from "../config/supportedCLIs.js";
import path from "path";
import { execa } from "execa";
import { fileURLToPath } from "url";
import { dirname } from "path";
import os from "os";

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

const BIN_DIR = `${os.homedir()}/.config/bin`;

export default async function installCLIs(CLIs, { indent = 4 } = {}) {
  const clisCount = CLIs.length;

  await execa("mkdir", ["-p", BIN_DIR]);
  const dependencies = new Set();

  for (let i = 0; i < clisCount; i++) {
    const cli = supportedCLIs[CLIs[i]];
    if (cli.dependencies) {
      cli.dependencies.forEach((dependency) => {
        dependencies.add(dependency);
      });
    }
    let commands = [];

    const spinner = ora({ prefixText: "- [CLI] ", indent }).start(
      `Installing ${CLIs[i]} (${i + 1}/${clisCount})`
    );

    if (cli.provider === "homebrew") {
      commands = [["brew", "install", cli.name]];
    } else {
      commands = [
        ["cp", path.join(__dirname, "../../.config/bin", cli.name), BIN_DIR],
      ];

      if (cli.completion) {
        commands.push([
          "cp",
          path.join(__dirname, "../../.config/bin", cli.completion),
          BIN_DIR,
        ]);
      }
    }

    const response = await Promise.allSettled(
      commands.map((command) => execa(command[0], command.slice(1)))
    );

    if (response.every((r) => r.status === "fulfilled")) {
      spinner.succeed(`${CLIs[i]} installed`);
    } else {
      spinner.fail(`${CLIs[i]} failed to install`);
    }
  }

  const dependenciesToInstall = [...dependencies].filter((dependency) => {
    return !CLIs.includes(dependency);
  });

  if (dependenciesToInstall.length > 0) {
    const spinner = ora({ prefixText: "- [CLI] ", indent }).start(
      `Installing dependencies (${dependenciesToInstall.length})`
    );
    await installCLIs(dependenciesToInstall, { indent: indent + 4 });
    spinner.succeed(
      `Dependencies installed (${dependenciesToInstall.join(", ")})`
    );
  }
}
