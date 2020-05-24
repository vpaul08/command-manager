# Command-manager
## Introduction
A shell script developed for quick lookup and execution of useful commands.

There is a predefined list of commands and their categories, which can be extended to support more commands and their categories for easy lookup and execution.

## Usage
You can run the script from within the source folder by running `./my-cli.sh` or you can add the path to your terminal's path either in `.bashrc` or `.bash_profile` and execute this from anywhere by running `my-cli.sh`

## Extension
### Current command categories
* System 
  - Commands required for building your app, spinning instances, running watchers, etc.
* Test
  - Commands required for executing tests
* Container
  - Commands dealing with managing your containers (Basically docker and kubctl)

### Adding new commands (existing category)
If you would like to add more commands in the above mentioned categories, please append to the existing arrays, e.g for adding a new system command, just append to `sysOpLabels` with command description and `sysOpCmds` with the actual command.

Lets say that you want to add npm's build script that runs `npm build`, you can add the following lines to code:
```shell script
sysOpLabels+=("Npm Build")
sysOpCmds+=("npm build")
```

This command will be available under the system category, once you execute this script.

### Adding new commands (new category)
To add a new category, just create a new array for labels and commands, as below:
```shell script
newOpLabels=()
newOpCmds=()
```

And then add the command with description as mentioned in the above section.

### Coloring
There is an available list of color constants. You can play around with the color settings yourself to see what suits best for your terminal's theme.
