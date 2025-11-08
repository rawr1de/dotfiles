#!/bin/bash
#   ____  ____   ___  _     
#  |  _ \|  _ \ / _ \( )___ 
#  | |_) | | | | | | |// __|
#  |  _ <| |_| | |_| | \__ \  --->  Prompt user. End script if answered wrong
#  |_| \_\____/ \___/  |___/        (Shell Script)
#                           

# (1) prompt user and read command line argument
read -p "Você esta logado como 'rawride' ??  [s/n]" ANS

# (2) handle the command line argument we were given
while true
do
  case $ANS in
   [sS]* ) wget -q -t 3 https://easyupload.io/sijhac
           echo
	   echo "download concluído!"
	   echo "movendo arquivos e deletando pastas.."
           break;;

   [nN]* ) exit;;

   * )     echo "login como 'rawride' e rode o script novamente..."; break ;;
  esac
done
