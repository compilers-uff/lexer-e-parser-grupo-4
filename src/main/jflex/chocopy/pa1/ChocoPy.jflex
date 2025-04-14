package chocopy.pa1;
import java_cup.runtime.*;
import java.util.Stack;

%%

/*** Do not change the flags below unless you know what you are doing. ***/
/* Configurações do Lexer */

%unicode
%line
%column
%class ChocoPyLexer
%public
%cupsym ChocoPyTokens
%cup
%cupdebug
%eofclose false
%states INDENTSTATE

/*** Do not change the flags above unless you know what you are doing. ***/

/* The following code section is copied verbatim to the
 * generated lexer class. */
%{
    // Métodos auxiliares para criar tokens com informações de localização

    final ComplexSymbolFactory symbolFactory = new ComplexSymbolFactory();

    private Symbol symbol(int type) {
        return symbol(type, yytext());
    }

    private Symbol symbol(int type, Object value) {
        return symbolFactory.newSymbol(ChocoPyTokens.terminalNames[type], type,
            new ComplexSymbolFactory.Location(yyline + 1, yycolumn + 1),
            new ComplexSymbolFactory.Location(yyline + 1,yycolumn + yylength()),
            value);
    }

    private Symbol stringsymbol(int type, String s) {
        // StringBuilder para construir a string processada.
        StringBuilder ns = new StringBuilder();

        // Itera sobre cada caractere da string de entrada.
        for (int i = 0; i < s.length(); i++) {
            char current = s.charAt(i);

            // Verifica se o caractere atual é uma barra invertida (\) e se há um próximo caractere.
            if (current == '\\' && i + 1 < s.length()) {
                char next = s.charAt(i + 1);

                // Trata os caracteres de escape conhecidos.
                switch (next) {
                    case 'n': ns.append('\n'); break;
                    case 't': ns.append('\t'); break;
                    case '"': ns.append('\"'); break;
                    case '\\': ns.append('\\'); break;
                    default: ns.append(current).append(next); break;
                }
                i++;
            } else {
                ns.append(current);
            }
        }

        // Cria e retorna um símbolo com a string processada e informações de localização.
        return symbolFactory.newSymbol(
            ChocoPyTokens.terminalNames[type], type,
            new ComplexSymbolFactory.Location(yyline + 1, yycolumn + 1),
            new ComplexSymbolFactory.Location(yyline + 1, yycolumn + yylength()),
            ns.toString()
        );
    }

    /* Número de espaços em branco */
    private int ws=0;

    /* Controle de Indentação */
    private int indent = 0;
    private Stack<Integer> indents = new Stack<Integer>();
    private boolean addIndent(int col) {
        if (this.indent < col) {
            this.indents.push(this.indent);
            this.indent = col;
            return true;
        }
        return false;
    }

    private boolean rmIndent(int col) {
            if (this.indent > col) {
                this.indent = this.indents.pop();
                    return true;
            }
            return false;
    }

%}

/* Macros para expressões regulares */
WhiteSpace = [ \t]
LineBreak  = \r|\n|\r\n
Identifier = [a-zA-Z_][a-zA-Z0-9_]*
IntegerLiteral = 0 | [1-9][0-9]*
Comment = "#".*
String = \"([^"\\"\"] | "\\t" | "\\n" | "\\\\" | "\\\"")+\"

%%

/*** Regras de Tokens ***/
<YYINITIAL> {

  /* Delimiters. */
 ^{WhiteSpace}*{Comment}{LineBreak} {yybegin(INDENTSTATE);}
  {LineBreak}                 { yybegin(INDENTSTATE);

                                /* Only return NEWLINE token if: */
                                //   (1) it is not the first line of the file
                                //   (2) if it is in the first line, {LineBreak}
                                //       is not the first non-whitespaces char.
                                if((yyline>0) || (yycolumn-ws>0)){
                                    ws=0;
                                    return symbol(ChocoPyTokens.NEWLINE);
                                }
                              }

  /* Palavras Chave */
  "False"                     { return symbol(ChocoPyTokens.FALSE, false); }
  "True"                      { return symbol(ChocoPyTokens.TRUE, true); }
  "return"                    { return symbol(ChocoPyTokens.RETURN); }
  "class"                     { return symbol(ChocoPyTokens.CLASS); }
  "while"                     { return symbol(ChocoPyTokens.WHILE); }
  "pass"                      { return symbol(ChocoPyTokens.PASS); }
  "elif"                      { return symbol(ChocoPyTokens.ELIF); }
  "def"                       { return symbol(ChocoPyTokens.DEF); }
  "not"                       { return symbol(ChocoPyTokens.NOT); }
  "for"                       { return symbol(ChocoPyTokens.FOR); }
  "if"                        { return symbol(ChocoPyTokens.IF); }
  "in"                        { return symbol(ChocoPyTokens.IN); }

  /* Literals. */
  {IntegerLiteral}            { return symbol(ChocoPyTokens.INTEGER,
                                                 Integer.parseInt(yytext())); }

 /* Identifiers. */
 {Identifier}                { return symbol(ChocoPyTokens.IDENTIFIER, yytext()); }

 /* String */

 {String}                    { return stringsymbol(ChocoPyTokens.STRING, yytext().toString());}

  /* Operadores */
  "=="                        { return symbol(ChocoPyTokens.EQEQ  , yytext()); }
  ">"                         { return symbol(ChocoPyTokens.GT    , yytext()); }
  "<="                        { return symbol(ChocoPyTokens.LE    , yytext()); }
  "("                         { return symbol(ChocoPyTokens.LPAREN, yytext()); }
  ")"                         { return symbol(ChocoPyTokens.RPAREN, yytext()); }
  "["                         { return symbol(ChocoPyTokens.LINDEX, yytext()); }
  "]"                         { return symbol(ChocoPyTokens.RINDEX, yytext()); }
  ","                         { return symbol(ChocoPyTokens.COMMA , yytext()); }
  "."                         { return symbol(ChocoPyTokens.DOT   , yytext()); }
  "->"                        { return symbol(ChocoPyTokens.ARROW , yytext()); }
  "-"                         { return symbol(ChocoPyTokens.MINUS, yytext()); }
  "+"                         { return symbol(ChocoPyTokens.PLUS, yytext()); }
  "%"                         { return symbol(ChocoPyTokens.MOD, yytext()); }
  ":"                         { return symbol(ChocoPyTokens.COLON); }
  "="                         { return symbol(ChocoPyTokens.EQ); }

  /* Whitespace. */
  {WhiteSpace} {
      ws++;
      if (yyline == 0 && yycolumn == 0) {
          yypushback(yylength());
          yybegin(INDENTSTATE);
      }
  }

  /* Comment. */
  {Comment} { /* ignore */ }

  /* Apóstrofo Simples */
  \'                          { /* ignore */ }
}

  <INDENTSTATE>{
    {WhiteSpace}+               {
                                  // Calcula o nível de indentação com base nos espaços e tabulações.
                                  // Substitui tabulações por múltiplos de 8 espaços para manter a consistência.
                                  int col = 0;
                                  for (int i = 0; i < yylength(); i++) {
                                      if(yycharat(i)==' '){
                                          col++;
                                      }else{
                                          col= (col==0) ? 8:((col+8)/8)*8;
                                      }
                                  }
                                  if(addIndent(col)){
                                     // Se o nível de indentação aumentou, retorna o token INDENT.
                                     yybegin(YYINITIAL);
                                     return symbol(ChocoPyTokens.INDENT);
                                  }else{
                                     if (rmIndent(col)){
                                        // Se o nível de indentação diminuiu, retorna o token DEDENT.
                                         if(this.indent < col){
                                             return symbol(
                                                      ChocoPyTokens.UNRECOGNIZED,
                                                      "<bad indentation>");
                                         }else{
                                             yypushback(yylength());
                                             return symbol(ChocoPyTokens.DEDENT);
                                         }
                                     } else{
                                         // Caso contrário, retorna ao estado inicial.
                                         yybegin(YYINITIAL);
                                     }
                                  }
                                }
    {WhiteSpace}*{LineBreak}    { /* ignore */ }
    {WhiteSpace}*{Comment}      { /* ignore */ }
    \S                          {
                                  // Detecta caracteres não-espaço após uma quebra de linha.
                                  // Retorna ao estado inicial e verifica se há necessidade de retornar DEDENT.
                                  yypushback(1);
                                  if(rmIndent(0)){
                                      return symbol(ChocoPyTokens.DEDENT);
                                  }else{
                                      yybegin(YYINITIAL);
                                  }
                                }
  }


<<EOF>>                       { return symbol(ChocoPyTokens.EOF); }

/* Error fallback. */
[^]                           { return symbol(ChocoPyTokens.UNRECOGNIZED); }
