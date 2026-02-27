.\" compile document with:  groff -Kutf8 -ms kitty_hp.ms -T pdf > kitty_hp.pdf
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
Kitty
(virtual termial emulator)
.
.NH
.UL "Keybinds"
.sp 0.6
.
.c1
C+S
.c2
\ Atalhos de "kittens"
.c3
.
.c1
C+S+c
.c2
\ Copia o texto selecionado
.c3
.
.c1
C+S+v
.c2
\ Cola o texto selecionado \ (S+INSERT também funciona)
.c3
.
.c1
C+S+t
.c2
\ Abre nova aba
.c3
.
.c1
C+S+→
.c2
\ Pula para próxima aba a direita
.c3
.
.c1
C+S+l
.c2
\ Pula para próxima aba a direita
.c3
.
.c1
C+S+←
.c2
\ Pula para próxima aba a esquerda
.c3
.
.c1
C+S+j
.c2
\ Pula para próxima aba a esquerda
.c3
.
.c1
C+S+o
.c2
\ Move a posição da aba para esquerda
.c3
.
.c1
C+S+u
.c2
\ Move a posição da aba para direita
.c3
.
.c1
C+S+w
.c2
\ Fecha aba
.c3
.
.c1
C+S+↑
.c2
\ Rola o scroll do terminal pra cima
.c3
.
.c1
C+S+i
.c2
\ Rola o scroll do terminal pra cima
.c3
.
.c1
C+S+↓
.c2
\ Move-se pra baixo no terminal
.c3
.
.c1
C+S+k
.c2
\ Rola o scroll do terminal pra baixo
.c3
.
.c1
C+S+[
.c2
\ Diminui opacidade da janela
.c3
.
.c1
C+S+]
.c2
\ Aumenta opacidade da janela
.c3
.
.c1
C+S+n
.c2
\ Invoca um novo terminal
.c3
.
.c1
C+S+DEL
.c2
\ Limpa e reseta o terminal
.c3
.
.c1
C+S+ENTER
.c2
\ Abre um novo terminal dividido em paineis
.c3
.
.c1
C+A+ENTER
.c2
\ Abre um terminal (em painel) no atual diretório
.c3
.

\" map kitty_mod+page_up   scroll_page_up
\" map kitty_mod+page_down scroll_page_down
\"  map kitty_mod+home      scroll_home
\" map kitty_mod+end       scroll_end
\"  map kitty_mod+h         show_scrollback
