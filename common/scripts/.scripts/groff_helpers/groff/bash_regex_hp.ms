.\" compile document with:  groff -Kutf8 -ms audacity_hp.ms -T pdf > audacity_hp.pdf
.nr PO 2c
.nr HM 1c
.nr FM 0c
.ds CH
.ds RH -%-
.\"so macros
.SH
.ce 3
Bash Regular Expressions
(string manipulation)

.LP
.B "."
\   matches any character

.LP
.B "*"
\   repeats a character 0 or more times

.LP
.B "*?"
\   repeats a character 0 or more times (non-greedy)

.LP
.B "+"
\   repeats a character 1 or more times (excludes 0)

.LP
.B "+?"
\   repeats a character 1 or more times (non-greedy)

.LP
.B "$"
\   matches the end of a line

.LP
.B "^"
\   matches the beginning of a line

.LP
.B "?"
\   encontra um caracter qualquer (opcional)

.LP
.B "\s"
\   matches whitespace

.LP
.B "\S"
\   matches non-whitespace

.LP
.B \e
\   escape a character

.LP
.B "[0-9]" 
\   one digit from 0 to 9

.LP
.B "[0-9]+"
\   one ore more digits

.LP
.B "[a-z]" 
\   one letter

.LP
.B "[a-z]+"
\   one or more letters

.LP
.B "[A-Z]+"
\   one or more uppercase letters

.LP
.B "[aeiou]"
\   matches a single character in the listed set

.LP
.B "[^XYZ]"
\   matches a sigle character NOT in the listed set

.LP
.B "[a-z0-9]"
\   the set of characters can include a range

.LP
.B "("
\   indicates where a string extraction starts

.LP
.B ")"
\   Indicates where a string extractions stops

.LP
.B "/d"
\   digit

.LP
.B "/d/d/d"
\   '555'

.LP
.B "/d{3}"
\   '555'

.LP
.B "/d/d/d./d/d/d./d/d/d/d"
\   555-555-1212

.LP
.B "/d{3}[-.]?/d{3}"
\   555.555 or 555-555




.LP
.B Examples

.LP
.B "^X.*:"
\   line starts with 'X' followed by any character, many times, ending in colon

.LP
.B "^X-\S+:"
\   line starts with 'X-' followed by any non-whitespace character, one or more times, then ending in a colon

.LP
.B "^F.+:"
\   first character is an 'F', followed by one or more characters, ending in a colon

.LP
.B "^F.+?:"
\   this will return just the single word starting in 'F' and ending in ':'

.LP
.B "\S+@\S+"
\   at least one non-whitespace character in each direction from the '@' character

^From (\S+@\S+) -- Same as above, but line starts wth 'From' string

@([^ ]*) = find the '@' character, select the following more than one non-blank characters
# ^From .*@([^ ]*) = Starting and the beginning of the line, looking for the string 'From', 
# followed by a space, then followed by any number of characters, to an '@' character, 
# Start extracting after the '@' character until you reach whitespace
\$[0-9.]+ = '$' character followed by one or more digits or .

re.search('parameters_here') # this will search through lines until first instance of parameter
re.findall('parameters_here') # this will continue after first instance in a line
