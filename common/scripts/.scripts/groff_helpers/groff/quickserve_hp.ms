.\" compile document with:  groff -Kutf8 -ms quickserve_hp.ms -T pdf > quickserve_hp.pdf
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
Quickserve
(roda um servidor html localmente)
.c3
.
.NH
Linha de Comando
.LP
.B "ex:"
\ $ quickserve --root ~/Docs/
.c3
.
.c1
 --root <directory path>
.c2
trata o diretorio como raiz do servidor ignorando todos os outros demais
.c3
.
.c1
 --show-hidden
.c2
Compartilha arquivos/diretorios invisiveis (hidden)
.c3
.
.c1
 --tar {none,gz,bz2,xz} [{none,gz,bz2,xz} ...]
.c2
Diretorios serao transferidos como arquivos comprimidos em .tar (especificar os tipos de compressao a usar)

.c1
 --upload <filepath>
.c2
Habilita o upload de arquivos salvando-os no diretorio especificado

.c1
 --allow-overwrite
.c2
Permite que arquivos enviados (upload) sobrescrevam outro de mesmo nome

.c1
.B --motd <filepath>
.c2
A mensagem do dia (MOTD) é mostrada no server (o arquivo é recarregado se atualizado)
