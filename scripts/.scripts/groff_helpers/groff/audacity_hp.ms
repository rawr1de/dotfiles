.\" compile document with:  groff -Kutf8 -ms audacity_hp.ms -T pdf > audacity_hp.pdf
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
.SH
.ce 3
.SH
.ce 3
.
.
.
.SH
.ce 3
Audacity
(edição de audio)
.
.NH
.UL "CONFIGURAÇÃO"
.sp 0.6
.
.c1
Modo noturno
.R
.c3
Edit > Preferences > Interface > Theme > Dark
.sp 1
.
.
.
.NH
.UL "KEYBINDS"
.c3
.
.c1
C+a
.c2
\ Seleciona toda a onda ativa
.c3
.
.c1
C+x
.c2
\ Recorta toda ou seleção de onda ativa
.c3
.
.c1
C+c
.c2
\ Copia toda ou seleção de onda ativa
.c3
.
.c1
C+v
.c2
\ Cola toda ou seleção de onda ativa
.c3
.
.c1
C+F6
.c2
\ Foca na barra de seleção (Inferior)
.sp 0.2
\                Navegue com:
.B "TAB  ,  Shift+TAB  ,  Left  ,  Right arrow"
.c3
.
.c1
C+Up / Down
.c2
\ Pula entre as 2 seções do layout, onda e menu de seleção inferior
.c3
.
.c1
S+Left / Right
.c2
\ Expanção externa da seleção da onda
.c3
.
.c1
C+S+Left / Right
.c2
\ Retração interna da seleção da onda
.c3
.
.c1
x
.c2
\ Para o cursor na posição do audio, cortando a seleção ativa
.c3
.
.c1
C+i
.c2
\ Quebra (Split) o clip de audio
.c3
.
.c1
A+,
.c2
\ Pula para Split anterior
.c3
.
.c1
A+.
.c2
\ Pula para Split próximo
.c3
.
.c1
C+S+Left / Right
.c2
\ Retração interna da seleção da onda
.c3
.
.
.
.NH 2
.UL "Custom Keys"
.c3
.c1
S+space
.c2
\ Normal-play-at-speed
.c5
\                    (toca audio c/ velocidade acelerada, após selecionar velocidade)
.
.
.
.bp
.NH
.UL "AÇÕES CUSTOMIZADAS"
.NH 2
.UL "Inverter Seleção"
.c3
.B
C+a
.R
\ (tocar o audio com seleção total ativa)
.
.c5
.B x
.R
\      (para o audio mantendo a seleção na posição)
.
.c5
.B
C+i
.R
\  (criar seleção [split] INICIAL)
.
.c5
.B
C+i
.R
\  (criar seleção [split] FINAL)
.
.c5
.B
A+,
.R
\  (2x p/ inverter seleção)
.
.c5
.B
C+k
.R
\  (recorta seleção)
.
.c5
.B
space
.R
\  (toca audio partindo do recorte)
.c5
.B
C+a
.R
\  (re-ativa a seleção total com o audio ativo)
