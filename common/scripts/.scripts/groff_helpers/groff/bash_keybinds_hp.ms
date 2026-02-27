.\" compile document with:  groff -Kutf8 -ms bash_keybinds_hp.ms -T pdf > bash_keybinds_hp.pdf
.nr PO 2c
.nr HM 1c
.nr FM 0c
.ds CH
.ds RH -%-
.\"so macros
.de c1
.LP
.B
..
.
.de c2
.R
\ =
..
.
.de c3
.sp 0.4
..
.
.de c4
.LP
.BI
..
.
.de c5
.sp 0.2
.R
..
.
.de c6
.sp 0.6
.R
..
.
.
.
.SH
.ce 3
Bash (Shell) - Keybinds
.sp 2
.
.
.
.LP
.B "READLINE" 
é o programa que implementa os atalhos na shell. Veja o manual para uma lista completa de comandos.
.sp 0.6
.
.NH
.UL "Teclas de Atalho"
.sp 0.6
.c1
A+.
.c2
\ Copia o último argumento do último comando
.c3
.
.c1
C+a
.c2
\ Pula para o ínicio da linha 
.I (Home)
.c3
.
.c1
C+e
.c2
\ Pula para o fim da linha 
.I (End)
.c3
.
.c1
C+r
.c2
\ Busca reversa no histórico de comandos 
.I (useful)
.c3
.
.c1
A+t
.c2
\ Inverte os argumentos do comando digitado
.sp 1
.
.
.
.NH
.UL "Comandos"
.NH 2
.UL "GNU/Linux"
.sp 0.6
.
.c1
du -sh *
.c2
\ Lista os maiores diretorios na pasta em execução
.c3
.
.c1
df -h
.c2
\ Lista o resumo de espaços em disco
.c3
.
.c1
df -ih
.c2
\ Lista o resumo dos inodes disponiveis
.c3
.
.c1
pushd / popd
.c2
Retorna ao dir. anterior quando utilizado
.I 'popd'
.c3
.
.c1
updatedb 
.c2
update the search database for 
.I 'mlocate'
.c3
.
.c1
mandb 
.c2
update the man database for the 
.I man pages
.c3
.
.
.c1
Add to $PATH
.c5
export PATH="$HOME/pasta/a/exportar:$PATH"
.c3
.
.c1
Pulseaudio echo cancelation module (use when mic echoing)
.c5
pactl load-module module-echo-cancel
.sp 1
.
.
.
.NH 2
.UL "Mount / Format"
.sp 0.6
.
.c1
Mount 
.BI " device or .iso"
.c5
mount -o loop /caminho/.iso /mnt/iso
.I "(criar dir, se não existir)"
.c3
.
.
.c1
Verify mounted devices
.c5
mount
.c5
df -H
.c5
ls -l /mnt/iso
.c5
lsblk
.c3
.
.
.c1
Formating devices
.c5
mkfs.ext3 -L label_name /dev/sdX
.c3
.
.
.c1
Auto mounting
.c5
install 
.I "udiskie / udisks"
.c3
.
.c1
allow non-root user to mount/rw external devices
.I "(if aumouting fails)"
.c5
add to 
.I /etc/fstab: \ 
.BI "/dev/sdxY    /mnt/some_folder  [vfat]   user,rw"
.sp 1
.
.
.c1
Writing bootable .iso files to USB sticks
.c5
.B "# cat"
path/to/file.iso > /dev/sdx
.sp 0.2
.
.B "# cp"
path/to/file.iso /dev/sdx
.
.sp 0.2
.B "# tee"
< path/to/archlinux.iso > /dev/sdx
.sp 0.2
.
.B "# dd"
bs=4M if=path/to/file.iso of=/dev/sdX oflag=sync
.c3
.
.
.
.NH 2
.UL "File Compression"
.sp 0.6
.
.
.c1
tar -c..
.c2
create archive
.ce
.
.
.c1
tar -v..
.c2
extract archive
.c3
.
.
.c1
tar.bz2 
.BI " (bzip2)"
.c5
tar -xvjf file.tar.bz2
.c3
.
.
.c1
tar.gz
.BI " (gzip)"
.c5
tar -xvgf file.tar.gz
.c3
.
.
.c1
tar.xz
.BI " (xzip)"
.c5
tar -xvJf file.tar.xz
.sp 0.6
.
.
.c1
creates a tar excluding an especific directory
.c5
tar -pcvf a.tar --exclude 
.I \[lq]dir/to/exclude\[rq] 
dir/to/compress
.sp 0.6
.
.
.
.NH 2
.UL "Compiling Source Code"
.sp 0.6
.
.B cd
.R
dir/to/compile/source
.c3
.B "cmake -DCMAKE_BUILD_TYPE=Release .."
.c3
.B make 
desired_build_name
.c3
.I "compiled file have a"
.B ".so" 
.I extension
.sp 0.6
.
.
.
.NH 2
.UL "Set a program as default file opener"
.sp 0.6
.
.c1
check present .desktop files with
.c5
.B ls
.R
/usr/share/applications/
.c3
.
.c1
Display the default application for opening a specific file
.c5
xdg-mime query default $(xdg-mime query filetype 
.I "path/to/file")
.c3
.
.c1
Set zathura as the default application for opening PDF files
.c5
xdg-mime default org.pwmt.zathura-pdf-poppler.desktop application/pdf
.sp 1
.
.
.
.bp
.NH 2
.UL "Sound Files"
.c6
.
.c1
Convert mp4 > mp3 \ 
.I (FFMPEG)
.c5
$ ffmpeg -i FILE.mp4 -q:a 0 -map a FILE.mp3
.sp 1
.
.
.c1
Create mp3 audio files \ 
.I (LAME)
.c5
.BI
Extreme Quality
.c5
lame --preset extreme -v -b 192 -q 0 file.mp3/.wav/.*
.sp 0.5
.
.c5
.BI
Standard Quality
.c5
lame --preset standard -v -b 128 -q 0 file.mp3/.wav/.*
.sp 1
.
.
.c1
Create mpc audio files \ 
.I "(Muse Pack)"
.c5
.BI
Extreme quality
.c5
mpcenc --extreme file.wav file.mpc
.sp 0.5
.
.c5
.BI
Insane quality
.c5
mpcenc --insane file.wav file.mpc
.sp 1
.
.
.c1
split\ 
.BI ".cue / .flac"
\ in multiple .flac files with correct file names\ 
.I "(cuetools / shntool)"
.c5
shnsplit -f cue_file.cue -t "%p-%a_-_%n_-_%t" -o flac audio_file.flac
.sp 0.2
https://wiki.archlinux.org/index.php/CUE_Splitting
.sp 1
.
.
.c1
copy the metadata from a CUE sheet to the split files\ 
.I "(cuetools / id3v2 / glibc)"
.c5
cuetag.sh cue_file.cue *.mp3
.sp 0.5
.B "cuetag.sh supports id3 tags for .mp3 / .ogg / .flac"
.sp 1
.
.
.
.NH 2
.UL "Image Files"
.sp 0.6
.
.c1
read image metadata, use -verbose for in-depth info
.I "(requires imagemagick)"
.c5
identify [-verbose] image.png
.c3
.
.c1
change the image's creation date
.I "(requires exif)"
.c5
exiv2 -T rename image.jpg
.c3
.
.c1
mogrify: resize, blur, crop, flip, join.. and many more to an image. overwrites the original file
.c5
mogrify -auto-orient image.jpg
.c3
.
.c1
convert: just like mogrify but don't overwrite the original file, write a new one
.c5
convert -auto-orient image.jpg
.sp 1
.
.
.
.NH 2
.UL "Pacman Contrib (scripts)"
.sp 0.6
.
.c1
list pending updates but don't update the system sync databases
.I "(for safety on rolling release distros)"
.c5
$ checkupdates
.c3
.
.c1
flexible package cache cleaning utility (allows greater control over which packages are removed)
.c5
$ paccache
.c3
.
.c1
simple pacnew/pacsave updater for /etc/ 
.c5
$ pacdiff
.c3
.
.c1
list all packages installed from a given repository
Useful for seeing which packages you may have installed from the testing repository, for instance
.c5
$ paclist
.c3
.
.c1
lists currently installed packages based pacman's log.
.c5
# paclog-pkglist
.c3
.
.c1
tries to print out the {pre,post}_{install,remove,upgrade} scripts of a given package
.c5
# pacscripts
.c3
.
.c1
colorized search combining 
.I -Ss
and 
.I -Qs
(online and local respectively)
.br
lists both online/local packages, installed packages are flagged with 
.I [installed]
.c5
# pacsearch
.c3
.
.c1
ranks pacman mirrors by their connection and opening speed
.c5
# rankmirrors
.c3
.
.c1
 performs an in-place update of the checksums in a PKGBUILD
.c5
# updpkgsums
.sp 1
.
.
.
.bp
.NH 2
.UL "Rofi Calculator"
.sp 0.6
.
.c1
copy result to clipboard
.c5
ctrl + enter
.c3
.
.c1
disable persistent history with the flag
.I -no-persist-history
.c5
rofi -show calc -modi calc -no-show-match -no-sort -no-persist-history
.c3
.
.c1
disable history entirely with the flag
.I -no-history
(won't save history upon quitting)
.c5
rofi -show calc -modi calc -no-show-match -no-sort -no-history -lines 0
.c3
.
.c1
separador de milhar (6,000 invés de 6000) add to config
.I ~/.config/qalculate/qalc.cfg
.c5
.BI "separar por , "\  
.I digit_grouping=2
.sp 0
.BI "separar por 'espaço' "\  
.I digit_grouping=1
.c3
.
.
.
.NH 2
.UL "Gerenciamento de Pacotes"
.sp 0.6
.
.c1
# pacman -S <pkg1> <pkg1> <..>
.c5
Install N packages
.c3
.
.c1
# pacman -Syyy
.c5
update repositories 
.I "(do before system updating)"
.c3
.
.c1
# pacman -Syu
.c5
perform a full system update
.c3
.
.c1
# pacman -Q
.c5
list installed packages
.c3
.
.c1
# pacman -Qs
.c5
search installed packages
.I (local)
.c3
.
.c1
# pacman -Ss
.c5
search packages
.I (web)
.c3
.
.c1
$ pacman -Qdtq
.c5
list orphan packages dependencies
.I "(no longer needed by others)"
.c3
.
.c1
# pacman -R $(pacman -Qdtq)
.c5
remove pkgs that don't depend on others
.I (orphans)
.c3
.
.c1
# pacman -Sc
.c5
remove packages from cache 
.I "(good to free up space)"
.c3
.
.c1
$ pacman -Ps
.c5
print system statistics
.c3
.
.c1
$ pacman -Yc
.c5
clean up all unwanted dependencie
.c3
.
.c1
Falha ao atualizar o sistema por "Erro de Chaves PGP"
.c5
Reinstalar o pacote,
.B archlinux-keyring
.c3
.
.c1
pacman logs
.c5
/var/log/pacman.log
.c3
.
.
.
.NH 2
.UL "Programas Úteis"
.sp 0.6
.
.c1
autrace (strace)
.c2
audita programas em execução
.c3
.
.
.c1
pdftk (pdf tool kit)
.c2
utilitário pra manipular pdf's
.c3
.BI "remover password de um .pdf"
.c5
$ pdftk /path/to/doc.pdf input_pw "pwd" output /path/to/new_doc.pdf
