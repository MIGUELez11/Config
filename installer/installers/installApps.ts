import { execa } from "execa";
import ora from "ora";

export default async function installApps(apps: string[]): Promise<void> {
  const appsLength = apps.length;

  for (let i = 0; i < appsLength; i++) {
    const app = apps[i]!;
    const appName = app.substring(0, 1).toUpperCase() + app.substring(1);

    const spinner = ora({ prefixText: "- [APPS] ", indent: 4 }).start(
      `Installing ${appName} (${i + 1}/${appsLength})`
    );

    const subprocess = execa("brew", ["install", "--cask", app]);

    try {
      await subprocess;
      spinner.succeed(`${appName} installed`);
    } catch {
      spinner.fail(`${appName} failed to install`);
    }
  }
}
