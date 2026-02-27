#!/usr/bin/env bash

#   ____  ____   ___  
#  |  _ \|  _ \ / _ \
#  | |_) | | | | | | |  -->  Post Instal Script
#  |  _ <| |_| | |_| |
#  |_| \_\____/ \___/ 
#  
NUMBER=5

#--let---
let RESULT=NUMBER+5
echo "let 5+5 = $RESULT"

#---(( ))---
RESULT=$(( NUMBER + 5 ))
echo "(( )) + 5 = $RESULT"

#---[ ]---
RESULT=$[ NUMBER + 5 ]
echo "[ ] + 5 = $RESULT"

#---expr---
RESULT=$(expr $NUMBER + 5)
RESULT=`expr $NUMBER + 5`
echo "expr + 5 = $RESULT"

#---bc--- NUMBER * 2.1
RESULT=`echo "$NUMBER * 2.1" | bc`
echo "BC 5 * 2.1 = $RESULT"
