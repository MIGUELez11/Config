import inquirer from "inquirer";
import ora from "ora";

import supportedApps from "./config/supportedApps.js";
import supportedCLIs from "./config/supportedCLIs.js";
import supportedHelpers from "./config/supportedHelpers.js";
import installApps from "./installers/installApps.js";
import installCLIs from "./installers/installCLIs.js";
import installHelpers from "./installers/installHelpers.js";
import runScript from "./installers/runScript.js";

const questions = [
  {
    type: "confirm",
    name: "setupZsh",
    message: "Should we setup zsh?",
  },
  {
    type: "confirm",
    name: "setupVim",
    message: "Should we setup vim?",
  },
  {
    type: "confirm",
    name: "installApps",
    message: "Should we install apps?",
  },
  {
    type: "checkbox",
    name: "installAppsSelected",
    message: "Which apps do you want to install?",
    choices: supportedApps,
    default: supportedApps,
    when: (answers) => answers.installApps,
  },
  {
    type: "confirm",
    name: "installCLIs",
    message: "Should we install CLIs?",
  },
  {
    type: "checkbox",
    name: "installCLIsSelected",
    message: "Which CLIs do you want to install?",
    choices: Object.keys(supportedCLIs),
    when: (answers) => answers.installCLIs,
    default: Object.keys(supportedCLIs),
  },
  {
    type: "confirm",
    name: "installHelpers",
    message: "Should we install helpers?",
  },
  {
    type: "checkbox",
    name: "installHelpersSelected",
    message: "Which helpers do you want to install?",
    choices: Object.keys(supportedHelpers),
    when: (answers) => answers.installHelpers,
    default: Object.keys(supportedHelpers),
  },
];

const answers = await inquirer.prompt(questions);

console.clear();

if (answers.setupZsh) {
  const spinner = ora("- Configuring zsh").start();
  await runScript("../scripts/setupZsh.sh");
  spinner.succeed("- Zsh configured");
}

if (answers.setupVim) {
  const spinner = ora("- Setting up vim").start();
  await runScript("../scripts/setupVim.sh");
  spinner.succeed("- Vim configured");
}

if (answers.installAppsSelected?.length) {
  const spinner = ora("- Installing apps").start();
  await installApps(answers.installAppsSelected);
  spinner.succeed("- Apps installed");
}

if (answers.installCLIsSelected?.length) {
  const spinner = ora("- Installing CLIs").start();
  await installCLIs(answers.installCLIsSelected);
  spinner.succeed("- CLIs installed");
}

if (answers.installHelpersSelected?.length) {
  const spinner = ora("- Installing helpers").start();
  await installHelpers(answers.installHelpersSelected);
  spinner.succeed("- Helpers installed");
}
