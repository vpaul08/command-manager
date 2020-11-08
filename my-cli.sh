#!/bin/bash

# Color Codes
RESET_COLOR='\033[0m'          # Text Reset

BROWN='\033[0;1m'              # Brown
BLACK='\033[0;30m'             # Black
RED='\033[0;31m'               # Red
GREEN='\033[0;32m'             # Green
YELLOW='\033[0;33m'            # Yellow
BLUE='\033[0;34m'              # Blue
PINK='\033[0;35m'              # Pink
CYAN='\033[0;36m'              # Cyan
WHITE='\033[0;37m'             # White
BLINK_BLUE='\033[5;34m'        # Blue blinking

INVALID_INPUT_MSG='Please enter a valid input.'

mainOpLabels=()

sysOpLabels=()
sysOpCmds=()
dbOpLabels=()
dbOpCmds=()
testOpLabels=()
testOpCmds=()
containerOpLabels=()
containerOpCmds=()
allOpLabels=()
allOpCmds=()
quickOpLabels=()
quickOpCmds=()

sysOpLabels+=("Build")
sysOpCmds+=("make")

sysOpLabels+=("Build & Watch")
sysOpCmds+=("make dev")

containerOpLabels+=("Force stop all Docker containers")
containerOpCmds+=("docker stop $(docker ps -a -q)")

containerOpLabels+=("Force remove all Docker containers")
containerOpCmds+=("docker rm -f $(docker ps -a -q)")

containerOpLabels+=("Prune docker (aggressive)")
containerOpCmds+=("docker system prune -a")

containerOpLabels+=("Get Pods")
containerOpCmds+=("kubectl get pods")

containerOpLabels+=("Describe Service")
containerOpCmds+=("kubectl logs service/{service_name} {container_name}")

containerOpLabels+=("Describe Pods")
containerOpCmds+=("kubectl describe pods {pod_name}-{pod_uuid} | less")

testOpLabels+=("Run front-end unit tests")
testOpCmds+=("npm t")

testOpLabels+=("Run back-end unit tests")
testOpCmds+=("rspec")

testOpLabels+=("Run Linter")
testOpCmds+=("yarn lint")

allOpLabels=( "${sysOpLabels[@]}" "${testOpLabels[@]}" "${containerOpLabels[@]}" )
allOpCmds=( "${sysOpCmds[@]}" "${testOpCmds[@]}" "${containerOpCmds[@]}" )

mainOpLabels+=("System")
mainOpLabels+=("Test")
mainOpLabels+=("Container")
mainOpLabels+=("All")

# Add any includes here
# source /path-for-your-includes-or-dependencies

function showMainOptions() {
  opLabelGroup=("${!1}")
  echo -e "------------------------------------------------"
  echo -e "${BLUE} #ID \t| Menu${RESET_COLOR}"
  echo -e "------------------------------------------------"
  for index in ${!opLabelGroup[@]}; do
    COLOR_CODE=""
    if [[ $((index%2)) -ne 0 ]]; then
      COLOR_CODE="${CYAN}"
    else
      COLOR_CODE="${RESET_COLOR}"
    fi
    echo -e " ${COLOR_CODE}$((index+1)) \t${RESET_COLOR}|${COLOR_CODE} ${opLabelGroup[index]}${RESET_COLOR}"
  done
  echo -e "------------------------------------------------"

  echo ""
  echo -e "Enter the ${BROWN}Menu #ID${RESET_COLOR} to see the list of operations. To exit, just hit enter without entering any option: "
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
        showSubOptions testOpLabels[@] testOpCmds[@]
        ;;
      3)
        showSubOptions containerOpLabels[@] containerOpCmds[@]
        ;;
      4)
        showSubOptions allOpLabels[@] allOpCmds[@]
        ;;
      *)
        printError
        ;;
    esac
  else
    printError
  fi
}

function showSubOptions() {
  opLabelGroup=("${!1}")
  opCmdGroup=("${!2}")
  echo -e "------------------------------------------------"
  echo -e "${BLUE} #ID \t| Operation${RESET_COLOR}"
  echo -e "------------------------------------------------"
  for index in ${!opLabelGroup[@]}; do
    COLOR_CODE=""
    if [[ $((index%2)) -ne 0 ]]; then
      COLOR_CODE="${CYAN}"
    else
      COLOR_CODE="${RESET_COLOR}"
    fi
    echo -e " ${COLOR_CODE}$((index+1)) \t${RESET_COLOR}|${COLOR_CODE} ${opLabelGroup[index]}${RESET_COLOR}"
  done
  echo -e "${RED} 0 \t| Go Back${RESET_COLOR}"
  echo -e "------------------------------------------------"

  echo ""
  echo -e "Enter the ${BROWN}Operation #ID${RESET_COLOR} to execute the operation: "
  read opIndex

  if [ -z "${opIndex}" ] ; then
    echo -e "Exiting...\n"
    exit 1
  fi

  if [ $((opIndex)) == 0 ]; then
    bootCli
  elif [[ $((opIndex)) -le ${#opCmdGroup[@]} ]] && [[ $((opIndex)) -gt 0 ]]; then
    echo -e "\nOperation: \n - ${CYAN}${opLabelGroup[$((opIndex-1))]}${RESET_COLOR}"
    echo -e "\nCommand: \n - ${BROWN}${opCmdGroup[$((opIndex-1))]}${RESET_COLOR}\n"
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
    printError
  fi
}

function printError() {
  echo -e "\n$INVALID_INPUT_MSG"
  echo -e "Exiting...\n"
}

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
