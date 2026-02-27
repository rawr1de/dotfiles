.\" compile document with:  groff -Kutf8 -ms ranger_hp.ms -T pdf > ranger_hp.pdf
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
Ranger
(terminal file manager)
.
.
.
.NH
.UL "Teclas de Atalho"
.sp 0.6
.
.NH 2
.UL "Navegação entre Folders"
.sp 1
.
.c1
g h
.c2
\  "Home" (pula pro diretório)
.c3
.
.c1
g l
.c2
\  "Desk" (pula pro diretório)
.c3
.
.c1
g d
.c2
\  "Docs" (pula pro diretório)
.c3
.
.c1
g w
.c2
\  "DLs" (pula pro diretório)
.c3
.
.c1
g m
.c2
\  "Musk" (pula pro diretório)
.c3
.
.c1
g p
.c2
\  "Pix" (pula pro diretório)
.c3
.
.c1
g v
.c2
\  "Vidz" (pula pro diretório)
.c3
.
.c1
g t
.c2
\  "tmp" (pula pro diretório)
.c3
.
.c1
g c
.c2
\  "~/.config/" (pula pro diretório)
.c3
.
.c1
g s
.c2
\  "/.scripts/" (pula pro diretório)
.c3
.
.c1
y n
.c2
\  "Copia o NOME do arquio" para seleção primária do X (yank name)
.sp 0.1
\             necessita do 
.B "xsel"
.
.c1
u q
.c2
\  Restaura a aba fechada
.c3
.
.c1
u t
.c2
\  Remove marcação da tag
.c3
.
.c1
u v
.c2
\  Desmarca todos os arquivos selecionados com
.I "espaço"
.c3
.
.c1
u d
.c2
\  Remove ultimo 
.I "recortar"
.R
ativo (uncut)
.c3
.
.c1
u y
.c2
\  Remove ultimo 
.I "copiar (yank)"
.R
ativo
.c3
.
.
.c1
da
.c2
\  Adiciona arquivos em pastas diferentes (tipo 'recortar')
.c3
.
.
.c1
:flat <numero>
.c2
\  "aperta" um diretório mostrando-o em uma unica lista
.c3
.
.
.c1
:filter
.c2
\  filtra arquivos
.c3
.
.
.c1
:map \ console filter -s%space
.c2
\  binda \(rs para filtrar rapidamente
.c3
.
.
.bp
.NH
.UL "Customização"
.sp 1.2
.
.
.NH 2
.BI "Adicionar icones"
.sp 0.5
.
.c5
$ git clone https://github.com/alexanderjeurissen/ranger_devicons ~/.config/ranger/plugins/ranger_devicons
.sp 0.5
add  "default_linemode devicons"  to  rc.conf
.sp 1
.
.NH 2
.BI "Arrastar arquivos com mouse (dragon-drag-and-drop [AUR])"
.sp 0.5
.
.c5
map <C-d> shell dragon -a -x %p \ em \ ~/.config/ranger/rc.conf
.sp 0.5
mapeia \ Ctrl+d \ em \ dragon -a -x %p
.sp 0.2
.B "man ranger"  \\ ( 
\ para aprender sobre %p)
.sp 1
ou
.sp 1
Adicione em  
.B "rifle.conf"
.sp 0.5
has dragon-drag-and-drop, X, flag f = dragon-drag-and-drop -a -x "$@"
.sp 0.5
.B r \ 
para mostrar a opção de arrastar no menu 

.NH 2
.BI "Disabilitar Previews (Melhora performance)"
.sp 0.5
.
.R
set preview_images false
.sp 0.2
set preview_directories false
.sp 0.2
set preview_files false
.sp 0.5
adicione em \ 
.B "~/.config/ranger/rc.conf"
.
.sp 1
.R
ou
.sp 1
.
Desligue no programa com: \ 
.B "zi  ,  zP  ,  zp"
