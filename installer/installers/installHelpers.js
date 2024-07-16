import ora from "ora";
import supportedHelpers from "../config/supportedHelpers.js";
import path, { dirname } from "path";
import { execa } from "execa";
import { fileURLToPath } from "url";
import os from "os";

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

const HELPERS_DIR = `${os.homedir()}/.config/helpers`;

export default async function installHelpers(helpers) {
  const helpersCount = helpers.length;

  await execa("mkdir", ["-p", HELPERS_DIR]);

  for (let i = 0; i < helpersCount; i++) {
    const helper = supportedHelpers[helpers[i]];

    const spinner = ora({ prefixText: "- [HELPERS] ", indent: 4 }).start(
      `Installing ${helpers[i]} (${i + 1}/${helpersCount})`
    );

    const command = execa("cp", [
      path.join(__dirname, "../../.config/bin", helper),
      HELPERS_DIR,
    ]);

    try {
      await command;
      spinner.succeed(`${helpers[i]} installed`);
    } catch (error) {
      spinner.fail(`${helpers[i]} failed to install`);
    }
  }
}
