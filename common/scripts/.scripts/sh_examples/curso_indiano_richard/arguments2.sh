#!/bin/bash

#assign arguments value to a variable
FIRST=$1
SECOND=$2 

let RESULT=FIRST+SECOND
echo "$FIRST + $SECOND = $RESULT"

#./arguments2.sh 2 5 (=7)
