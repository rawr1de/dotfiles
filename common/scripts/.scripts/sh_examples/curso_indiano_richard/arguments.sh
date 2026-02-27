#!/bin/bash

IFS="."
echo "Script name: $0"
echo "First argum: $1"
echo "Second arg.: $2"
echo "All argum w/ \$@: $@"
echo "All argum w/ \$*: $*"
echo "Argum. count: $#"

#./arguments.sh 2 3 (2 3; 2.3; 2)
