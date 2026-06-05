import inquirer from "inquirer";
import ora from "ora";

import supportedApps from "./config/supportedApps.js";
import supportedCLIs from "./config/supportedCLIs.js";
import installApps from "./installers/installApps.js";
import installCLIs from "./installers/installCLIs.js";
import setupShell from "./installers/setupShell.js";
import setupVim from "./installers/setupVim.js";

const questions = [
  {
    type: "confirm",
    name: "setupFish",
    message: "Should we setup fish?",
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
];

const answers = await inquirer.prompt(questions);

console.clear();

if (answers.setupFish) {
  console.log("- Configuring fish");
  await setupShell();
}

if (answers.setupVim) {
  console.log("- Setting up vim");
  await setupVim();
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
