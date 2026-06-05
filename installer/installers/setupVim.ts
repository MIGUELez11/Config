import { cp, mkdir } from "node:fs/promises";
import os from "node:os";
import path from "node:path";

import { execa } from "execa";
import ora from "ora";

import { errorMessage } from "../utils/errors.ts";

const VIM_SRC = path.join(import.meta.dir, "../../.config/vim");
const VIM_DEST = path.join(os.homedir(), ".config/vim");

const VIMINIT = "source $HOME/.config/vim/.vimrc";

async function step(
  message: string,
  indent: number,
  run: () => Promise<unknown>
): Promise<boolean> {
  const spinner = ora({ prefixText: "- [VIM] ", indent }).start(message);
  try {
    await run();
    spinner.succeed(message);
    return true;
  } catch (error) {
    spinner.fail(`${message} — ${errorMessage(error)}`);
    return false;
  }
}

export default async function setupVim({ indent = 4 }: { indent?: number } = {}): Promise<void> {
  await mkdir(VIM_DEST, { recursive: true });

  // Copy the whole directory recursively. The previous shell version used
  // `cp -rf .../vim/.*` which globs `.` and `..` and fails; fs.cp copies
  // dotfiles (.vimrc, .vimconfig, .vim) cleanly without that footgun.
  await step("Copying vim configuration to ~/.config/vim", indent, () =>
    cp(VIM_SRC, VIM_DEST, { recursive: true, force: true })
  );

  // The zsh setup exported VIMINIT via ~/.zshenv. Under fish we persist it as
  // a universal, exported variable instead.
  await step("Setting VIMINIT for fish", indent, () =>
    execa("fish", ["-c", `set -Ux VIMINIT '${VIMINIT}'`])
  );
}
