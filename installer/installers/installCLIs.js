import ora from "ora";
import { execa } from "execa";

import supportedCLIs from "../config/supportedCLIs.js";

export default async function installCLIs(CLIs, { indent = 4 } = {}) {
  const clisCount = CLIs.length;

  for (let i = 0; i < clisCount; i++) {
    const cli = supportedCLIs[CLIs[i]];

    const spinner = ora({ prefixText: "- [CLI] ", indent }).start(
      `Installing ${CLIs[i]} (${i + 1}/${clisCount})`
    );

    try {
      await execa("brew", ["install", cli.name]);
      spinner.succeed(`${CLIs[i]} installed`);
    } catch (error) {
      spinner.fail(`${CLIs[i]} failed to install`);
    }
  }
}
