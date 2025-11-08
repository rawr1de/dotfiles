#!/bin/bash
#   ____  ____   ___  _     
#  |  _ \|  _ \ / _ \( )___ 
#  | |_) | | | | | | |// __|
#  |  _ <| |_| | |_| | \__ \  --->  Prompt user. Loop script if answered wrong
#  |_| \_\____/ \___/  |___/        (Shell Script)
#                           

while true
do
  # (1) prompt user, and read command line argument
  read -p "Run the cron script now? " answer

  # (2) handle the input we were given
  case $answer in
   [yY]* ) ls -l   # /usr/bin/wget -O - -q -t 1 http://www.example.com/cron.php
           echo -e \\n"Okay, just ran the cron script."\\n
           break;;

   [nN]* ) exit;;

   * )     echo -e \\n"Dude, just enter Y or N, please."\\n;;
  esac
done
