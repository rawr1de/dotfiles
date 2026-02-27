#!/usr/bin/bash
#   ____  ____   ___  _     
#  |  _ \|  _ \ / _ \( )___ 
#  | |_) | | | | | | |// __|
#  |  _ <| |_| | |_| | \__ \  --->  Resize images from 3264x2448 to 800x600
#  |_| \_\____/ \___/  |___/        (Shell Script)
#
echo
echo
echo "   ##############################################"
echo "   ##                                          ##"
echo "   ##  Altera tamanho das fotos para 800x600   ##"
echo "   ##                  e                       ##"
echo "   ##  Rotaciona imagens de acordo com EXIF    ##"
echo "   ##                                          ##"
echo "   ##  (1) Rodar script dentro da pasta        ##"
echo "   ##      que contem as fotos                 ##"
echo "   ##                                          ##"
echo "   ##############################################"
echo
echo

while true
do
  # (1) prompt user, and read command line argument
  read -p "Converter todas as fotos?  [y/n] " answer

  # (2) handle the input we were given
  case $answer in
      [yY]* )

	  # Lista arquivos a serem convertidos
	  ls | grep .. > abc.txt 

	  # Cria diretorio NEW para arquivos que serao convertidos
	  mkdir NEW

	  # Resize fotos para 800x600
	  cat abc.txt | xargs -t -I {} sh -c 'magick convert -resize 800x600 {} NEW/{}'

    # Auto orienta (Rotaciona 90º) as imagens de acordo com a metadata (EXIF)
	  mogrify -auto-orient NEW/*
	  
	  # Deleta arquivo com a lista de conversoes
	  rm -rf abc.txt

           break;;

   [nN]* ) exit;;

   * )     echo -e \\n"Digite Y para sim, N para não"\\n;;
  esac
done
