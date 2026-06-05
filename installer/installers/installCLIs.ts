import { execa } from "execa";
import ora from "ora";

import supportedCLIs from "../config/supportedCLIs.ts";

export default async function installCLIs(
  CLIs: string[],
  { indent = 4 }: { indent?: number } = {}
): Promise<void> {
  const clisCount = CLIs.length;

  for (let i = 0; i < clisCount; i++) {
    const cli = supportedCLIs[CLIs[i]!]!;

    const spinner = ora({ prefixText: "- [CLI] ", indent }).start(
      `Installing ${CLIs[i]} (${i + 1}/${clisCount})`
    );

    try {
      await execa("brew", ["install", cli.name]);
      spinner.succeed(`${CLIs[i]} installed`);
    } catch {
      spinner.fail(`${CLIs[i]} failed to install`);
    }
  }
}
