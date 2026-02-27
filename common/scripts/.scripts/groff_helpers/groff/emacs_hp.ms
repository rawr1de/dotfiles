.\" compile document with:  groff -Kutf8 -ms emacs.ms -T pdf > emacs.pdf
.nr PO 2c
.nr HM 1c
.nr FM 0c
.ds CH
.ds RH -%-
.\"so Macros
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
Emacs
.
.
.
.NH
.UL "Linha de Comando"
.sp 0.6
.
.c4
-nw
.c5
roda o emacs no terminal
.sp 1
.
.NH
.UL "Arquivos de Configuração"
.sp 0.6
.
.LP
~/.emacs.d/init.el         configurações de inicialização principais
.sp 0
~/.emacs.d/config.org  configurações de inicialização organizadas
.sp 1
.
.
.NH
.UL "Comandos Extendidos"
.sp 0.6
.
.c1
visual-line-mode
.c5
Liga/Desl. a quebra automatica de linhas no documento
.I (word wrap)
.c3
.
.
.c1
global-visual-line-mode
.c5
Liga/Desl. a quebra automatica de linhas em todos os documentos
.I (word wrap)
.c3
.
.
.c1
toggle-truncate-lines
.c5
Liga/Desl. a truncação de linhas no documentos
.I (word wrap)
.sp 1
.
.
.
.NH
.UL "Teclas de Atalho"
.sp 0.6
.
.
.
.NH 2
.UL "Padrão do emacs"
.sp 1
.
.
.c1
C+g
.c2
\ Cancela qualquer ação
.I "(abortar comando)"
.c3
.
.
.c1
C+u
.c2
\ Insere argumento numérico ao comando
.I (repetição)
.c3
.
.
.c1
C+x
.c2
\ Executa ações
.c3
.
.
.c1
C+h
.c2
\ Menu de ajuda
.c3
.
.
.c1
C+o
.c2
\ Abrir arquivo
.c3
.
.
.c1
C+s
.c2
\ Buscar palavras (iSearch)
.c3
.
.
.c1
C+a
.c2
\ Seleciona todo o texto em tela
.c3
.
.
.c1
C+l
.c2
\ Move a tela entre baixo/meio/alto
.c3
.
.
.c1
M+c
.c2
\ Capitiliza a letra a direita do cursor 
.I (capitalize-word)
.c3
.
.
.c1
M+u
.c2
\ Capitaliza toda a palavra a direita do cursor 
.I (upcase-word)
.c3
.
.c1
C+x C+u
.c2
\ Capitaliza toda uma seleção
.I (upcase-region)
.c3
.
.
.c1
M+l
.c2
\ Descapitiliza a letra a direita do cursor
.I (downcase-word)
.c3
.
.
.c1
C+x C+l
.c2
\ Descapitaliza toda uma seleção 
.I (downcase-region)
.c3
.
.
.c1
M+!
.c2
\ Roda comando externo da Shell
.sp 0.2
\ \ \ \ \ \ \ \ \ \ \ \ \ \ \ C-u
.I antes
manda saída do comando pro buffer atual
.c3
.
.
.c1
M+|
.c2
\ Roda comando externo da Shell na região
.sp 0.2
\ \ \ \ \ \ \ \ \ \ \ \ \ C-u
.I antes
manda saída do comando pro buffer atual 
.c3
.
.
.c1
M+x
.c2
\ "Comando extendido" digitável no minibuffer (Meta = Alt)
.c3
.
.
.c1
C+x C+b
.c2
\ Vizualiza buffers \ 
.I "(Alterado pra iBuffer)"
.c3
.
.
.c1
C+x n n
.c2
\ Narrow to region, afunila a edição na região
.c3
.
.
.c1
C+x n w
.c2
\ Widen narrowed region, volta do comando anterior
.c3
.
.
.c1
Occur
.c2
\ Permite editar partes filtradas por regex (útil c/ macros)
.c3
.
.
.c1
C+x C+c
.c2
\ Fecha o emacs
.c3
.
.
.c1
A+c
.c2
\ Turn on case sensitive during search
.c3
.
.
.c1
A+e
.c2
\ Pula pra linha de edição do minibuffer
.c3
.
.
.c1
flush-lines
.c2
\ Remove linhas em branco (regex)
.c3
.
.
.c1
keep-lines
.c2
\ Mantém linhas (regex) e remove resto
.c3
.
.
.c1
isearch-forward-regexp
.c2
\ Incremental search forward for regex
.c3
.
.
.c1
C+c C+x \\
.c2
\ Display entidades como símbolos UTF-8
.c3
.sp 2
.
.
.
.bp
.NH 2
.UL "xah-fly-keys"
.sp 1.5
.
.
.LP
.BI "Fileira numérica"
.sp 1
.
.c1
`
.c2
\ VAZIO, NENHUMA FUNCAO ADICIONADA
.c3
.
.c1
1 2
.c2
\ PERFORMA SELECAO, HA MODIFICAR!!!!!
.c3
.
.c1
3
.c2
\ Adiciona janela horizontal abaixo (split-window-bellow)
.c3
.
.c1
4
.c2
\ Fecha todas as janelas extras mantendo somente a do cursor
.c3
.
.c1
5
.c2
\ Delete  (apaga um caractere pra direita)
.c3
.
.c1
6
.c2
\ Seleciona um paragrafo
.c3
.
.c1
7
.c2
\ Seleciona uma linha inteira
.c3
.
.c1
8
.c2
\ Seleciona uma palavra (novamente seleciona toda a linha)
.c3
.
.c1
9
.c2
\ Seleciona até o inicio de uma citação/parentesis/chave...
.c3
.
.c1
0
.c2
\ NAO INTENDI OQ FAZ,   REBINDAR!!!
.c3
.
.c1
-
.c2
\ MOVIENTO BASICO,   REBINDAR!!!
.c3
.
.c1
C+S+ +   
.c2
\ Aumenta o tomanho do texto
.c3
.
.c1
C+ -
.c2
\ Diminui o tamanho do texto
.c3
.
.
.sp 2
.LP
.BI "Fileira qwerty"
.sp 1
.
.c1
q
.c2
\ Reformata bloco/seleção
.c3
.
.c1
w
.c2
\ Insere um espaco entre palavras ou remove espacos extras entre palavras 
.c3
.
.c1
e
.c2
\ Cursor deleta uma palavra a esquerda
.c3
.
.c1
r
.c2
\ Cursor deleta uma palavra a direita
.c3
.
.c1
t
.c2
\ Inicia seleção de texto
.c3
.
.c1
y
.c2
\ Undo (Desfaz ultima ação)
.c3
.
.c1
y
.c2
\ Redo (Refaz ultima ação) necessário iniciar alguma função pra reiniciar o stack de ações 
.c3
.
.c1
u
.c2
\ Cursor se move uma palavra pra esquerda
.c3
.
.c1
j,i,k,l
.c2
\ Setas de movimentação estilo T invertido
.c3
.
.c1
o
.c2
\ Cursor se move uma palavra pra direita
.c3
.
.c1
p
.c2
\ Insere um espaco (SPC)
.c3
.
.c1
[
.c2
\ ANALIZAR!
.c3
.
.c1
]
.c2
\ ANALIZAR!
.c3
.
.c1
\(rs
.c2
\ A TESTAR!
.c3
.
.
.
.bp
.LP
.BI "Fileira asdf"
.sp 1.5
.
.c1
CapsLock
.c2
\ Modo Comando  (navegação)
.c3
.
.c1
a
.c2
\ Acessa o comando ALT+x no minibuffer
.c3
.
.c1
s
.c2
\ Pula uma linha sem mover o cursor
.c3
.
.c1
d
.c2
\ Backspace  (apaga um caractere pra esquerda)
.c3
.
.c1
f
.c2
\ Modo Inserir
.c3
.
.c1
g
.c2
\ Remove um paragrafo inteiro
.c3
.
.c1
h
.c2
\ Move o cursor pra esquerda (inicio da linha)
.c3
.
.c1
h
.c2
\ Move o cursor pra esquerda (inicio da linha)
.c3
.
.c1
;
.c2
\ Move o cursor pra direita (fim da linha)
.c3
.
.c1
'
.c2
\ Inserir - ou _ nos espaços em branco
.sp 3
.
.
.
.LP
.BI "Fileira zxcv"
.sp 1.5
.
.c1
z
.c2
\ Insere um comentário na linguagem detectada do arquivo
.c3
.
.c1
x
.c2
\ Recorta um bloco/seleção
.c3
.
.c1
c
.c2
\ Copia um bloco/seleção
.c3
.
.c1
v
.c2
\ Cola um bloco/seleção
.c3
.
.c1
b
.c2
\ A BINDAR!!!
.c3
.
.c1
n
.c2
.B \ iSearch
.I "(Incremental Search)"
.sp 0.1
\ \ \ \ \ \ \ \ \ setas cima/baixo move entre o histórico
.sp 0.1
\ \ \ \ \ \ \ \ \ setas esq/dir. busca pelo texto
.c3
.
.c1
m
.c2
\ Move o cursor até o próximo parentesis a esquerda
.c3
.
.c1
,
.c2
\ Pula entre janelas (splits)
.c3
.
.c1
.
.c2
\ Move o cursor até o próximo parentesis a direita
.c3
.
.c1
/
.c2
\ Vai para o paretesis  TALVEZ REBINDAR!!
.c3
.bp
.
.
.
Atalhos com
.B "Espaço (SPC)"
.sp 1.5
.
.c1
SPC ;
.c2
\ Save file/buffer
.c3
.
.c1
SPC \\
.c2
\ Mantem o modo de inserção
.c3
.
.c1
SPC a
.c2
\ Seleciona todo conteudo
.c3
.
.c1
SPC 6
.c2
\ Capitaliza a 1ª letra de uma palavra em um bloco/seleção
.c3
.
.c1
SPC 9
.c2
\ iSpell checker
.c3
.
.c1
SPC b
.c2
\ Alterna entre Maiúsculo/Minúsculo a letra à esquerda do cursor
.c3
.
.c1
SPC h
.c2
\ Move o cursor pro inicio do texto (HOME)
.c3
.
.c1
SPC n
.c2
\ Move o cursor pro final do texto (END)
.c3
.
.c1
SPC g
.c2
\ Deleta todo o conteúdo da linha partindo da posição do cursor
.c3
.
.c1
SPC c
.c2
\ Copia todo o conteúdo do buffer ou somente seleção
.c3
.
.c1
SPC f
.c2
\ Abre a lista de buffers \ 
.I "(iBuffer)"
.c3
.
.c1
SPC m
.c2
\ Abre o editor de diretórios (Dired) na diretório do arquivo ativo
.c3
.
.c1
SPC p
.c2
\ Re-centraliza o cursor entre top
.c3
.
.c1
SPC r
.c2
\  query-replace
.BI "(alterado por replace-string)"
.sp 0.2
\ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 
Substituir strings em região, ou na posição do cursor até última linha
.c3
.
.c1
SPC s
.c2
\ Abre um seleção entre o ponto atual do cursor e o ultimo ponto de seleção criada
.c3
.
.c1
SPC t
.c2
\ Mostra o kill ring (lista de deleção)
.c3
.
.c1
SPC u
.c2
\ Fecha o buffer onde o cursor está ativo
.c3
.
.c1
SPC v
.c2
\ Cola último registro ou registros anteriores
.c3
.
.
.c1
SPC TAB
.c2
\ Indentação, Abreviaturas...
.c3
.
.
.c1
SPC ,
.c2
\ Deleção, eval-buffer, Salvar e fechar buffers
.c3
.
.
.c1
SPC d
.c2
\ Inserção em geral..
.c3
.
.
.c1
SPC e
.c2
\ Prefix command (definition is a keymap associating keystrokes with commands).
.c3
.
.
.c1
SPC i
.c2
\ Abrir arquivos, último arquivo fechado, ibuffer, bookmarks...
.c3
.
.
.c1
SPC j
.c2
\ Apropos, describes, infos, man...
.c3
.
.
.c1
SPC k
.c2
\ Copias, colação, deleção, repetição, ir para linha...
.c3
.
.
.c1
SPC l
.c2
\ Calendário, calculadora emacs, shell, eshell, word wrap, whitespace mode, eww
.
.
.c1
SPC o
.c2
\ Macros, retangulos, converter espaços em novas linhas...
.c3
.
.
.c1
SPC w
.c2
\ xref-find-definitions , xref-pop-marker-stack
.sp 2
.
.
.
.B
Espaço Extendido - SPC l
.sp 1
.
.
.
.c1
whitespace-mode
.c2
\ SPC l SPC
.c3
.
.
.
.NH
.UL "Macros"
.sp 1
.
.c1
F3 / C+x (
.c2
\ 
.B Inicia 
.R
gravação de macro 
.I (teclado/mouse)
.c3
.
.
.c1
F4 / C+x )
.c2
\ 
.B Para
.R
gravação de macro / 
.B Executa
.R
macro gravada
.I (teclado/mouse)
.c3
.
.
.c1
C+u 5 C+x e
.c2
\ Executa a macro
.B "5 vezes"
.
.
.c1
M+x apply-macro-to-region-lines
.c2
\ Executa a macro no inicio de todas as linhas de uma região
.
.
.c1
M+x insert-kbd-macro
.c2
\ Insere a descrição da macro na tela (útil p/ criar funções)
.
.
.c1
F3
.c2
\ Insere o contador de macros (macro counter) durante a gravação de uma macro
.
.
.c1
M+x name-last-kbd-macro
.c2
\ Nomeia a ultima macro definida
.sp 1
.
.
.B NOTA
.sp 0.2
• Após definido uma macro, pode-se executá-la com
.B
Mx
.sp 0.2
.R
• Macros são definidas apenas na seção ativa do Emacs.
.
.
.sp 0.2
• Adicione ao arquivo de configuração para manter permanente.
.sp 0.3
.B
 \ ex:
.sp 0.2
.
.
.c5
 \ (global-set-key (kbd "C-c a") 'my-macro)
.sp 0.2
 \ Binda 
.BI "C+c a"
.R
 \ para executar
.I  \ my-macro
.sp 2
.
.
.
.NH
.B
.UL "Comandos/Funções/Variáveis úteis"
.sp 1
.
.
.NH 2
.UL "Comandos"
..
.
.c1
revert-buffer
.c2
\ Regenera buffer pro estado inicial (antes de salvar, não funciona no scratch buffer)
.
.
.c1
revert-region
.c2
\ regenera uma região do buffer pro estado inicial (antes de salvar)
.
.
.c1
try
.c2
\ permite "testar" pacotes (instala temporariamente) 
.sp 1
.
.
.
.NH 2
.UL "Variáveis"
.
.
.c1
enable-recursive-minibuffers
.c2
\ Run commands on top of another in minibuffer
.
.
.c1
minibuffer-depth-indicate-mode
.c2
\ Minibuffer resizes if needed (long output)
.sp 2
.
.
.
.NH
.UL "Customizadas"
.sp 1
.
.
.c1
C+x c
.c2
\ Simples calculadora no minibuffer
.
.
.c1
C+c e
.c2
\ Eval/Replace última expressão lisp
.
.
.c1
C+i
.c2
\ Rola a tela pra cima
.
.
.c1
C+k
.c2
\ Rola a tela pra baixo
.
.
.c1
C+S+i
.c2
\ Aumenta janela (split) pra cima
.
.
.c1
C+S+k
.c2
\ Diminui janela (split) pra baixo
.
.
.c1
C+S+j
.c2
\ Diminui janela (split) pra direita
.
.
.c1
C+S+l
.c2
\ Aumenta janela (split) pra esquerda
.
.
.c1
C+S+=
.c2
\ Iguala dimensões das janelas (splits)
.
.
.c1
C-S-c C-S-c
.c2
\ Ativa edição dos cursores multiplos
.
.
.c1
C->
.c2
\ Marca a proxima linha como a seleção atual
.I \ (mc/mark-next-like-this)
.
.
.c1
C-<
.c2
\ Marca a linha anterior como a seleção atual
.I \ (mc/mark-previous-like-this)
.
.
.c1
C-c C-<
.c2
\ Marca todas as linhas como a seleção atual
.I \ (mc/mark-all-like-this)
.sp 2
.
.
.
.NH
.B
.UL "How to's"
.sp 0.6
.
.
.
.NH 2
.UL "Find & Replace"
.sp 1
.
.
.R
query-replace
.B
\ \ (M+% \ 
SPC R)
.c5

.
.
query-replace-regexp
.I
(C+M+%)
.c5
.BI "Ambos pedem permissão para aplicar mudanças (query)"
.sp
.
.
.I "sendo:"
.c5
.c1
y
.c2
\ Confirma alteração campo-a-campo
.
.
.c1
n
.c2
\ Nega alteração pulando pro proximo campo
.
.
.c1
!
.c2
\ Faz alteração pra todos os campos restantes (sem mais perguntas)
.sp
.
.
replace-string \ 
.B "(SPC 5)"
.c5
replace-regexp
.c5
.BI "Ambos NÃO pedem permissão para aplicar mudanças"
.sp
.
.
.B
.UL "Inserção especial"
.c3
.
.
.R
.c1
C-q
.c2
\ quoted-insert (insere caractere digitado literalmente)
.c3
.
.
.c1
Insert Literal Tab
.c2
\ C+q C+tab
.c3
.
.
.c1
Insert a Newline
.c2
\ C+q return
.c3
.
.
.c1
Insert a Newline during "replace"
.c2
\ C+q C+j
.c3
.
.
.c1
Inserir "abc" em linhas vazias
.c2
\ query-replace \  → \  C+q C+j \  → \  abc C+q C+j
.sp
.
.
.
.NH 2
.UL "Editar com permissão ROOT"
.sp 1
.
.
.R
Abra um arquivo com o prefixo
.BI
\ /sudo:: \ 
.I
(executado por TRAMP)
.c5
.B ex:
.c5
/sudo::/etc/fstab
.I
\ (edita fstab com sudo)
.sp 2
.
.
.
.NH
.B
.UL "Emacs Regex"
.sp 0.2
.I 
 \ \ \ \ C-h \ r \ i \ regexp
.sp 1
.
.
.
.c1
$ ^ . ? * + [ \\
.c2
\ Chars especiais
.
.
.c1
$
.c2
\ Denota fim de linha
.
.
.c1
^
.c2
\ Denota
.I inicio
.R
de linha
.
.
.c1
\.
.c2
\ Match qualquer char ate parar (exceto newlinha ($))
.
.
.c1
? 
.c2
\ match termo anterior 0 ou *uma* vez mais
.
.
.c1
* 
.c2
\ match termo anterior 0 ou
.B quantas
.R
vezes necessário
.
.
.c1
+
.c2
\ match termo anterior 1 ou *mais* vez mais
.
.
.c1
]
.c2
\ Só é especial se terminar um char alternativo
.
.
.c1
-
.c2
\ É especial dentro de um char alternativo
.
.
.c1
\\
.c2
\ Escape (Faz char deixar de ser ordinário)
.
.
.c1
[ ]
.c2
\ Char sets \ ou \ ranges
.
. 
.c1
[A-Za-z]
.c2
\ Qualquer char de 'A até Z' em QUALQUER CASE
.
.
.c1
[A-Z0-9]
.c2
\ Qualquer char de 'A até Z ou 0 a 9' UPPER CASE
.
. 
.c1
\\(algo\\)
.c2
\ group matches, escapar cada parentesis
.
.
.c1
greedy
.c2
\ greedy = matches the longest possible (todos os Postfix são)
.
.
.c1
non-greedy
.c2
\ O postfix deve ser seguido de ?
.
.
.c1
\ .*
.c2
\ Repete chars quantas vezes possível (full greedy)
.
.
.c1
\\(a\\)\\(b\\)
.c2
\ grupo múltiplo
.
.
.c1
- \ . \ _
.c2
\ últimos items de um range p/ que a busca funcione   
.
.
.c1
[^SET]
.c2
\ excluir um set
.
.
.c1
\\1..\\2.. 
.c2
\ Permite alterar cada grupo específico no regex
.
.
.c1
|
.c2
\ Either match, qualquer resultado buscado em grupo
.
.
.c1
\\&
.c2
\ move o match pra frente e adiciona string
.I (Prepend)
.
.
.c1
\\,(FUNÇÃO)
.c2
\ executa funções elisp dentro de um grupo
.
.
