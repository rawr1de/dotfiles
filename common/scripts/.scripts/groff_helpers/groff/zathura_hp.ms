.\" compile document with:  groff -Kutf8 -ms zathura_hp.ms -T pdf > zathura_hp.pdf
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
Zathura  
(ver pdf's e outros)
.c3
.
.
.
.NH
.UL "Teclas de Atalho"
.sp 0.6
.
.NH 2
.UL "Navegação Geral"
.sp 1
.
.
.c1
gg , Home
.c2
\  Vai para o ínicio do documento
.c3
.
.
.c1
G , End
.c2
\  Vai para o fim do documento
.c3
.
.
.c1
nG
.c2
\  Vai para pagina
.I "número"
.c3
.
.
.c1
j,k,i,l
.c2
\  Movimenta-se pelo documento:  j=esquerda  k=baixo  i=cima  l=direita
.c3
.
.
.c1
C + j,k,i,l
.c2
\  Movimenta-se 5 linhas com rolagem suavizada.
.c3
.
.
.c1
P
.c2
\  Centraliza no início da pagina atual
.c3
.
.
.c1
u
.c2
\  Inverter cores (pseudo modo noturno)
.c3
.
.
.c1
a
.c2
\  Ajusta o documento a tela inteira (100%)
.c3
.
.
.c1
s
.c2
\  Ajusta o documento a largura da tela
.c3
.
.
.c1
d
.c2
\  Vizualiza duas paginas por vez (lado-a-lado)
.c3
.
.
.c1
r
.c2
\  Rotaciona as paginas do documento
.c3
.
.
.c1
R
.c2
\  Recarrega o documento (reload)
.c3
.
.
.c1
p
.c2
\  Mostra o menu de impressão
.c3
.
.
.c1
=
.c2
\  fixa o zoom em 100%
.c3
.
.
.c1
+
.c2
\  aumenta o zoom
.c3
.
.
.c1
-
.c2
\  reduz o zoom
.c3
.
.
.c1
f
.c2
\  destaca todos os links e enumera-os, digite o número do link para segui-lo
.c3
.
.
.c1
F
.c2
\  somente a localização do link é mostrada na barra de status
.c3
.
.
.c1
:X  
.c2
\  pula pra página "X"
.c3
.
.
.c1
mX  
.c2
\  favorita uma letra/número em "X"
.c3
.
.
.c1
\'X  
.c2
\  vai até a letra/número favoritado
.c3
.
.
.c1
tab     
.c2
\  mostra o índice do .pdf
.I "(se houver)"
.c3
.
.
.c1
:
.c2
\  executa comandos internos do zathura manualmente
.c3
.
.
.c1
exec
.c2
\  executa comandos externos manualmente
.c3
.
.
.c1
bmark
.c2
\  gera uma entrada no bookmarks
.BI "(favorita a pagina no documento aberto)"
.c3
.
.
.c1
bdel
.c2
\  deleta uma entrada do bookmarks
.BI "(precisa estar com o documento aberto)"
.c3
.
.
.c1
blist
.c2
\  lista entradas geradas em um documento
.BI "(precisa estar com o documento aberto)"
.c3
.
.
.
.bp
.NH
Config. File Options
.
.LP
Set keybindings:
.
.c4
map [mode] <binding> <shortcut function> <argument>
.
.LP
.B ex:
.R [fullscreen] ctrl+r recolor
.
.PP
.B
Modos disponíveis:
.PP
fullscreen, presentation, index
.
.
.
.NH
Command Line options:
.
.PP
.BI -d,--data-dir=path
.PP
Path to the data directory

.PP
.BI -p,--plugins-dir=path
.PP
Path to the directory containing plugins

.PP
.BI -w,--password=password
.PP
The  documents  password.  If multiple documents are opened at once, the password will be used for the first one and zathura will ask for the passwords of the remaining files if needed.

.PP
.BI --mode=mode
.PP
Select starting mode

.PP
.BI "man zathura"
.PP
Program manual

.PP
.BI "man zathurarc"
.PP
Config file manual
