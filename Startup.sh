#!/usr/bin/env bash
# bash script to run the specified python scirpt,
# independent of the PWD this bash script is run from.

# move working directory to the projecct folder
echo ">>> cd to the multivisor directory..."
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
# echo $SCRIPT_DIR
cd "$SCRIPT_DIR"
echo "<<< Working directory set to: ${PWD}"
echo

# load .env if any
if [ -f ./.env ]; then
  echo ">>> Loading .env file..."
  export $(cat ./.env | xargs)
  echo "<<< .env file loaded"
fi

# activate venv
echo ">>> venv activating..."
venv_path="./.venv/bin/activate"
source "$venv_path"
echo "<<< venv activated: $venv_path"
echo
echo

# run multivisor
echo ">>> Starting multivisor..."
echo
exec multivisor -c ./multivisor.conf
echo
echo "<<< End of the script"
