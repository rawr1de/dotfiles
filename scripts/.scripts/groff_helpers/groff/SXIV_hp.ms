.\" compile document with:  groff -Kutf8 -ms SXIV_hp.ms -T pdf > SXIV_hp.pdf
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
SXIV
(vizualizador de imagens)
.
.
.NH
.UL "TECLAS DE ATALHO"
.sp 0.6
.
.NH 2
.UL "GERAL (Modo Imagem/Thumbnail)"
.sp 1
.
.c1
n
.c2
\  Proxima imagem (next)
.c3
.
.c1
p
.c2
\  Imagem anterior (previous)
.c3
.
.c1
"h,j,k,l"
.c2
\  Movimenta-se pelo imagem:  h=esquerda  j=baixo  k=cima  l=direita
.c3
.
.c1
0-9
.c2
\  Prefixa o proximo comando com um número
.I "(contagem)"
.c3
.
.c1
q
.c2
\  Fecha o SXIV (quit)
.c3
.
.c1
ENTER
.c2
\  Alterna entre modo de thumbnail/imagem
.sp 0.2
\                     Abre a imagem selecionada na tela
.c3
.
.c1
f
.c2
\  Tela cheia (fullscreen)
.c3
.
.c1
b
.c2
\  Liga/Desl. visibilidade da status bar (barra preta na parte inferior da janela)
.c3
.
.c1
g
.c2
\  Vai para a primeira imagem do diretorio
.c3
.
.c1
G
.c2
\  Vai para a ultima imagem do diretorio  ou  imagem de numero tal
.c3
.
.c1
r
.c2
\  Recarrega a imagem
.c3
.
.c1
D
.c2
\  Remove imagem da lista de arquivos e vai para a proxima (não deleta a imagem)
.c3
.
.c1
+
.c2
\  Aumenta o zoom
.c3
.
.c1
-
.c2
\  Reduz o zoom
.c3
.
.c1
m
.c2
\  Marca/Desmarca a imagem atual
.c3
.
.c1
M
.c2
\  Inverte todas as marcações das imagens
.c3
.
.c1
C-m
.c2
\  Remove todas as marcações das imagens
.c3
.
.c1
C-M
.c2
\  Repete a ultima ação marcada em todas as imagens, dá ultima marcada/desmarcada até a atual
.c3
.
.c1
N
.c2
\  Vai
.I "contagem"
de imagens adiante
.c3
.
.c1
P
.c2
\  Vai
.I "contagem"
de imagens pra traz
.c3
.
.c1
{
.c2
\  Reduz a correção de gamma por
.I "contagem"
.c3
.
.c1
}
.c2
\  Aumenta a correção de gamma por
.I "contagem"
.c3
.
.c1
C-g
.c2
\  Reseta a correção de gamma
.c3
.
.
.
.bp
.NH 2
.UL "MODO IMAGEM"
.sp 1
.
.NH 3
.UL "Navega na lista de imagens"
.sp 1
.
.c1
n / Space
.c2
\  Vai
.I "contagem"
de vezes, imagem adiante
.c3
.
.c1
p / Backspace
.c2
\  Vai
.I "contagem"
de vezes, imagem p/ traz
.c3
.
.c1
[
.c2
\  Vai
.I "contagem"
x10 imagens p/ traz
.c3
.
.c1
]
.c2
\  Vai
.I "contagem"
x10 imagens p/ frente
.c3
.
.
.
.NH 3
.UL "Manuseia animações (imagens de múltiplas frames)"
.sp 1
.
.c1
C-n
.c2
\  Vai
.I "contagem"
de vezes, frames de uma animação adiante
.c3
.
.c1
C-p
.c2
\  Vai
.I "contagem"
de vezes, frames de uma animação p/ traz
.c3
.
.c1
C-space
.c2
\  Toca/Pausa animações
.c3
.
.
.
.NH 3
.UL "Zoom"
.sp 1
.
.c1
=
.c2
\  Seta o zoom em 100% ou
.I "contagem"
de vezes
.c3
.
.c1
w
.c2
\  Seta o zoom em 100% enquadrando imagem na tela (útil p/ imagens grandes)
.c3
.
.c1
W
.c2
\  Enquadra imagem na tela (útil p/ imagens pequenas)
.c3
.
.c1
e
.c2
\  Expande imagem ao comprimento da tela
.c3
.
.c1
E
.c2
\  Expande imagem a altura da tela
.c3
.
.
.
.NH 3
.UL "Rotação"
.sp 1
.
.c1
<
.c2
\  Rotaciona a imagem no sentido anti-horário em 90º graus
.c3
.
.c1
>
.c2
\  Rotaciona a imagem no sentido horário em 90º graus
.c3
.
.c1
?
.c2
\  Rotaciona a imagem no em 180º graus
.c3
.
.
.
.NH 3
.UL "Flipping"
.sp 1
.
.c1
|
.c2
\  Flip imagem horizontalmente
.c3
.
.c1
_
.c2
\  Flip imagem verticalmente
.c3
.
.
.
.NH 3
.UL "Miscelânea"
.sp 1
.
.c1
a
.c2
\  Liga/Desl. o anti-aliasing
.c3
.
.c1
A
.c2
\  Liga/Desl. o canal alpha (transparência da imagem)
.c3
.
.c1
s
.c2
\  Liga/Desl. o modo de slideshow e/ou seta o delay entre imagens
.I "contagem"
em segundos
.c3
.
.
.
.pb
.NH 2
.UL "MODO THUMBNAIL"
.sp 1
.
.c1
h / Left
.c2
\  Move a seleção p/ esquerda 
.I "contagem"
de vezes
.c3
.
.c1
j / Down
.c2
\  Move a seleção p/ baixo 
.I "contagem"
de vezes
.c3
.
.c1
k / Up
.c2
\  Move a seleção p/ cima 
.I "contagem"
de vezes
.c3
.
.c1
l / Right
.c2
\  Move a seleção p/ direita
.I "contagem"
de vezes
.c3
.
.c1
R
.c2
\  Recarrega todos os thumbnails
.sp 1
.
.
.
.NH 2
.UL "Keyhandler (Ctrl+x)"
.sp 0.6
.
.
.c1
C+x \ z
.c2
feh --bg-center
.c3
.
.c1
C+x \ x
.c2
feh --bg-max
.c3
.
.c1
C+x \ c
.c2
feh --bg-center
.c3
.
.c1
C+x \ v
.c2
feh --bg-scale
.c3
.
.
.
.c1
C+x \ C+d
.c2
.I Trash
marked images to
.I \ ~/.Trash/
.c3
.
.c1
C+x \ C+y
.c2
.I Copy
marked images to
.I \ ~/IMAGES_COPIED
.c3
.
.c1
C+x \ C+m
.c2
.I Move
marked images to 
.I \ ~/IMAGES_CUTTED
.c3
.
.c1
C+x \ C+f
.c2
.I Clean
cache+trash \ (~/.cache/sxiv \ & \ ~/.Trash/)
.c3
.
.c1
C+x \ C+r
.c2
Rotate image 90 degree
.c3
.
.c1
C+x \ C+c
.c2
Copy image name
.c3
