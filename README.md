## Submission writeup

Membro 1: Thales Mendonça Moreira Pinto 

Membro 2: Daniel José de Macedo Santos

Membro 3: Caio Henrique Velloso Paranhos

# Estratégia de indentação
    Nós utilizamos uma Stack para guardar e manipular os valores de indentação, após cada linebreak o lexer vai para o estado INDENTSTATE e sempre que um caracter ou white-space não seguido de comment ou linebreak é indentificado é realizada uma contagem de indentação, em seguida esse valor é comparado com o ultimo valor guardado na Stack, se o valor for maior então um token INDENT é emitido, mas se o valor for menor então um token DEDENT é emitido, caso for igual o lexer apenas volta para o estado inicial. Ao final do programa (<EOF>) tokens DEDENT adicionais são emitidos caso necessário.

    A lógica da Stack pode ser encontrada em ChocoPy.jflex entre as linhas 77 e 97.
    O INDENTSTATE pode ser encontrado em ChocoPy.jflex entre as linhas 203 e 244.

# NEWLINE/INDENT/DEDENT
    Tokens NEWLINE são emitidos somente se 
    *Caso 1: Não está na primeira linha do arquivo.
    *Caso 2: Está na primeira linha do arquivo mas não é o primeiro caracter não white-space. 
