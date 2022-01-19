#!/bin/bash

# Color Codes
RESET_COLOR='\033[0m'          # Text Reset
C='\033[0;36m'                  # Default color setting
CB='\033[0;1m'                 # Default color setting and bright a little bit
CYAN='\033[0;36m'              # Cyan
YELLOW='\033[0;33m'            # Yellow
B_HI_WHITE='\033[0;1m'        # White

mainOpLabels=()

sysOpLabels=()
sysOpCmds=()
dbOpLabels=()
dbOpCmds=()
testOpLabels=()
testOpCmds=()
containerOpLabels=()
containerOpCmds=()
slackOpLabels=()
slackOpCmds=()
allOpLabels=()
allOpCmds=()
quickOpLabels=()
quickOpCmds=()

sysOpLabels+=("Launch Sandbox")
sysOpCmds+=("make -C /vidyard/DevTools/sandbox bundle all")

sysOpLabels+=("Setup Sandbox for local Development")
sysOpCmds+=("(cd ~/vidyard/DevTools/sandbox/skaffold; skaffold dev -f dashboard.yaml --cache-artifacts=true)")

sysOpLabels+=("Start dashboard CLI")
sysOpCmds+=("vy-exec dashboard -c web bash")

sysOpLabels+=("Start dashboard rails console")
sysOpCmds+=("vy-exec dashboard -c web -- bundle exec rails c")

sysOpLabels+=("Show all routes")
sysOpCmds+=("vy-exec dashboard -c web -- bundle exec rails routes")

containerOpLabels+=("Force stop all Docker containers")
containerOpCmds+=("docker stop $(docker ps -a -q)")

containerOpLabels+=("Force remove all Docker containers")
containerOpCmds+=("docker rm -f $(docker ps -a -q)")

containerOpLabels+=("Get Pods")
containerOpCmds+=("kubectl get pods")

containerOpLabels+=("Watch Pods")
containerOpCmds+=("watch -n 3 kubectl get pods")

testOpLabels+=("Run front-end unit tests")
testOpCmds+=("vy-exec dashboard -c test -- npm t")

testOpLabels+=("Run back-end unit tests")
testOpCmds+=("vy-exec dashboard -c test -- rspec")

testOpLabels+=("Run specific back-end test suite")
testOpCmds+=("vy-exec dashboard -c test -- bundle exec rspec <relative-path-to-test-file>")

testOpLabels+=("Run specific back-end unit test")
testOpCmds+=("vy-exec dashboard -c test -- bundle exec rspec <relative-path-to-test-file>:<line-number>")

testOpLabels+=("Run Guard")
testOpCmds+=("vy-exec dashboard -c test -- bundle exec guard")

testOpLabels+=("Run Rubocop")
testOpCmds+=("vy-exec dashboard -c test -- bundle exec rubocop")

testOpLabels+=("Run Linter")
testOpCmds+=("vy-exec dashboard -c test -- yarn lint")

dbOpLabels+=("Run migrations")
dbOpCmds+=("vy-exec dashboard -c web -- bundle exec rails db:migrate")

dbOpLabels+=("Rollback migration")
dbOpCmds+=("vy-exec dashboard -c web -- bundle exec rails db:rollback")

dbOpLabels+=("Migration status")
dbOpCmds+=("vy-exec dashboard -c web -- bundle exec rails db:migrate:status")

slackOpLabels+=("Check named staging availability")
slackOpCmds+=("bs list")

slackOpLabels+=("Book named staging")
slackOpCmds+=("bs book hulk 8 HOT-2713")

slackOpLabels+=("Deploy on named staging")
slackOpCmds+=("/staging_ecs_deploy staging staging-hulk-dashboard VidyardDashboard HOT-2713 --skip-drone")

slackOpLabels+=("Deploy pusheen on prod")
slackOpCmds+=("/ecs_deploy cpu production-pusheen Pusheen master")

slackOpLabels+=("Deploy pusheen on staging")
slackOpCmds+=("/staging_ecs_deploy staging-cpu staging-pusheen pusheen HOT-2713-bugfix --skip-drone")

allOpLabels=( "${sysOpLabels[@]}" "${dbOpLabels[@]}" "${testOpLabels[@]}" "${containerOpLabels[@]}" "${slackOpLabels[@]}" )
allOpCmds=( "${sysOpCmds[@]}" "${dbOpCmds[@]}" "${testOpCmds[@]}" "${containerOpCmds[@]}" "${slackOpCmds[@]}" )

mainOpLabels+=("System")
mainOpLabels+=("Database")
mainOpLabels+=("Test")
mainOpLabels+=("Container")
mainOpLabels+=("Slack")
mainOpLabels+=("All")

source /vidyard/DevTools/.vidyard_bashrc

function showMainOptions() {
  opLabelGroup=("${!1}")
  echo -e "------------------------------------------------"
  echo -e "${B_HI_WHITE} #ID \t| Menu${RESET_COLOR}"
  echo -e "------------------------------------------------"
  for index in ${!opLabelGroup[@]}; do
    COLOR_CODE=""
    if [[ $((index%2)) -ne 0 ]]; then
      COLOR_CODE="${C}"
    else
      COLOR_CODE="${CB}"
    fi
    echo -e " ${COLOR_CODE}$((index+1)) \t${RESET_COLOR}|${COLOR_CODE} ${opLabelGroup[index]}${RESET_COLOR}"
  done
  echo -e "------------------------------------------------"

  echo ""
  echo -e "Enter the ${B_HI_WHITE}Menu #ID${RESET_COLOR} to see the list of operations: "
  read opIndex

  if [ -z "${opIndex}" ] ; then
    echo -e "Exiting...\n"
    exit 1
  fi

  if [[ $((opIndex)) -le ${#opLabelGroup[@]} ]]; then
    case $((opIndex)) in
      1)
        showSubOptions sysOpLabels[@] sysOpCmds[@]
        ;;
      2)
        showSubOptions dbOpLabels[@] dbOpCmds[@]
        ;;
      3)
        showSubOptions testOpLabels[@] testOpCmds[@]
        ;;
      4)
        showSubOptions containerOpLabels[@] containerOpCmds[@]
        ;;
      5)
        showSubOptions slackOpLabels[@] slackOpCmds[@]
        ;;
      6)
        showSubOptions allOpLabels[@] allOpCmds[@]
        ;;
      *)
        echo "Please enter a valid input"
        ;;
    esac
  else
    echo "Please enter a valid input"
  fi
}

function showSubOptions() {
  opLabelGroup=("${!1}")
  opCmdGroup=("${!2}")
  echo -e "------------------------------------------------"
  echo -e "${B_HI_WHITE} #ID \t| Operation${RESET_COLOR}"
  echo -e "------------------------------------------------"
  for index in ${!opLabelGroup[@]}; do
    COLOR_CODE=""
    if [[ $((index%2)) -ne 0 ]]; then
      COLOR_CODE="${C}"
    else
      COLOR_CODE="${CB}"
    fi
    echo -e " ${COLOR_CODE}$((index+1)) \t${RESET_COLOR}|${COLOR_CODE} ${opLabelGroup[index]}${RESET_COLOR}"
  done
  echo -e " ${YELLOW}0 \t${RESET_COLOR}|${YELLOW} Goto Main Menu ${RESET_COLOR}"
  echo -e "------------------------------------------------"

  echo ""
  echo -e "Enter the ${B_HI_WHITE}Operation #ID${RESET_COLOR} to execute the operation: "
  read opIndex

  if [ -z "${opIndex}" ] ; then
    echo -e "Exiting...\n"
    exit 1
  fi

  if [ $((opIndex)) == 0 ]; then
    bootCli
  elif [[ $((opIndex)) -le ${#opCmdGroup[@]} ]] && [[ $((opIndex)) -gt 0 ]]; then
    echo -e "\nOperation: \n - ${CYAN}${opLabelGroup[$((opIndex-1))]}${RESET_COLOR}"
    echo -e "\nCommand: \n - ${B_HI_WHITE}${opCmdGroup[$((opIndex-1))]}${RESET_COLOR}\n"
    read -p "Would you like to execute or copy the above command [Y/y/C/c]?: " confirmChoice
    if [[ $confirmChoice ==  "Y" || $confirmChoice ==  "y" ]]; then
      output="${opCmdGroup[$((opIndex-1))]}"
      eval "$output"
    fi
    if [[ $confirmChoice ==  "C" || $confirmChoice ==  "c" ]]; then
      output="${opCmdGroup[$((opIndex-1))]}"
      echo "$output" | pbcopy
    fi
  else
    echo "Please enter a valid input"
  fi
}

# Generated by figlet
function showBanner() {
  echo -e "\n ${RESET_COLOR}
     __  __              ____ _ _
    |  \/  |_   _       / ___| (_)
    | |\/| | | | |_____| |   | | |
    | |  | | |_| |_____| |___| | |
    |_|  |_|\__, |      \____|_|_|
            |___/
  ${RESET_COLOR}"
}

function bootCli() {
  clear
  showBanner
  showMainOptions mainOpLabels[@]
}

bootCli
