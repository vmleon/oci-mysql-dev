#!/usr/bin/env zx

const shell = process.env.SHELL | "/bin/zsh";
$.shell = shell;
$.verbose = false;

const { c, _ } = argv;
const [action] = _;

if (c || action === "clean") {
  await cd("./terraform");
  await cleanInfra();
  await cd("../");
  process.exit(0);
}

await setenv();
await deploy();

async function setenv() {
  console.log("Set environment...");
  const tfvarsPath = "terraform/terraform.tfvars";
  try {
    const exists = await fs.pathExists(tfvarsPath);
    if (!exists) {
      console.log(chalk.red(`File ${tfvarsPath} is required but not found`));
      console.log(
        `Run ${chalk.yellow(`cp ${tfvarsPath}.template ${tfvarsPath}`)}`
      );
      console.log(
        chalk.yellow(`Edit ${tfvarsPath} file with your own values.`)
      );
      process.exit(1);
    }
  } catch (error) {
    console.error(chalk.red(error.toString().trim()));
    process.exit(1);
  }
}

async function deploy() {
  await cd("./terraform");
  await terraformInit();
  await terraformApply();
  await terraformOutput();
  await cd("../");
}

async function cleanInfra() {
  console.log("Clean deployment...");
  try {
    const { stderr, exitCode } = await $`terraform destroy -auto-approve`;
    if (exitCode !== 0) {
      console.error(chalk.red(stderr.trim()));
    }
  } catch (error) {
    console.error(chalk.red(error.toString().trim()));
    process.exit(1);
  }
}

async function terraformInit() {
  console.log("Terraform init...");
  try {
    const { stderr, exitCode } = await $`terraform init`;
    if (exitCode !== 0) {
      console.error(chalk.red(stderr.trim()));
    }
  } catch (error) {
    console.error(chalk.red(error.toString().trim()));
    process.exit(1);
  }
}

async function terraformApply() {
  console.log("Terraform apply...");
  try {
    const { stderr, exitCode } = await $`terraform apply -auto-approve`;
    if (exitCode !== 0) {
      console.error(chalk.red(stderr.trim()));
    }
  } catch (error) {
    console.error(chalk.red(error.toString().trim()));
    process.exit(1);
  }
}

async function terraformOutput() {
  console.log("Terraform output...");
  try {
    const ipOutput = await $`terraform output mysql_ip_address`;
    if (ipOutput.exitCode !== 0) {
      console.log(chalk.red(ipOutput.stderr.trim()));
    }
    const ipAddress = ipOutput.stdout.trim();
    console.log(`MySQL IP address: ${chalk.yellow(ipAddress)}`);

    const userOutput = await $`terraform output mysql_user`;
    if (userOutput.exitCode !== 0) {
      console.log(chalk.red(userOutput.stderr.trim()));
    }
    const mysqlUser = userOutput.stdout.trim();
    console.log(`MySQL User: ${chalk.yellow(mysqlUser)}`);

    const passwordOutput = await $`terraform output mysql_password`;
    if (passwordOutput.exitCode !== 0) {
      console.log(chalk.red(passwordOutput.stderr.trim()));
    }
    const mysqlPassword = passwordOutput.stdout.trim();
    console.log(`MySQL Password: ${chalk.yellow(mysqlPassword)}`);

    const shapeOutput = await $`terraform output mysql_shape`;
    if (shapeOutput.exitCode !== 0) {
      console.log(chalk.red(shapeOutput.stderr.trim()));
    }
    const mysqlShape = shapeOutput.stdout.trim();
    console.log(`MySQL Shape: ${chalk.yellow(mysqlShape)}`);

    const commandOutput = await $`terraform output bastion_ssh_command`;
    if (commandOutput.exitCode !== 0) {
      console.log(chalk.red(commandOutput.stderr.trim()));
    }
    const command = commandOutput.stdout.trim();
    console.log(`SSH Bastion command: ${chalk.yellow(command)}`);
  } catch (error) {
    console.error(chalk.red(error.toString().trim()));
    process.exit(1);
  }
}
