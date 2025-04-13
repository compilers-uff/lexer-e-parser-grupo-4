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

  /* Operators. */
    "+"                         { return symbol(ChocoPyTokens.PLUS); }
    "="                         { return symbol(ChocoPyTokens.ASSIGN); }
    ":"                         { return symbol(ChocoPyTokens.COLON); }
    "-"                         { return symbol(ChocoPyTokens.MINUS); }
    "*"                         { return symbol(ChocoPyTokens.TIMES); }
    "%"                         { return symbol(ChocoPyTokens.MOD); }
    "//"                        { return symbol(ChocoPyTokens.DIV); }
    "/"                         { return symbol(ChocoPyTokens.DIV); }
    "<="                        { return symbol(ChocoPyTokens.LEQ); }
    ">="                        { return symbol(ChocoPyTokens.GEQ); }
    "=="                        { return symbol(ChocoPyTokens.EQ); }
    "!="                        { return symbol(ChocoPyTokens.NEQ); }
    "["                        	{ return symbol(ChocoPyTokens.LBR); }
    "]"                        	{ return symbol(ChocoPyTokens.RBR); }

  	/* Logical Operators */
    "and"                       { return symbol(ChocoPyTokens.AND); }
  	"or"                        { return symbol(ChocoPyTokens.OR); }
  	"is"                        { return symbol(ChocoPyTokens.IS); }
  	"not"                       { return symbol(ChocoPyTokens.NOT); }

  	/* Reserved words */
  	"False"                     { return symbol(ChocoPyTokens.FALSE, Boolean.FALSE); }
  	"None"                      { return symbol(ChocoPyTokens.NONE); }
  	"True"                      { return symbol(ChocoPyTokens.TRUE, Boolean.TRUE); }
  	"as"                        { return symbol(ChocoPyTokens.AS); }
  	"assert"                    { return symbol(ChocoPyTokens.ASSERT); }
  	"async"                     { return symbol(ChocoPyTokens.ASYNC); }
  	"await"                     { return symbol(ChocoPyTokens.AWAIT); } /* error not supported */
  	"break"                     { return symbol(ChocoPyTokens.BREAK); } /* error not supported */
  	"class"                     { return symbol(ChocoPyTokens.CLASS); }
  	"continue"                  { return symbol(ChocoPyTokens.CONTINUE); }
  	"del"                       { return symbol(ChocoPyTokens.DEL); }
  	"elif"                      { return symbol(ChocoPyTokens.ELIF); }
  	"else"                      { return symbol(ChocoPyTokens.ELSE); }
  	"except"                    { return symbol(ChocoPyTokens.EXCEPT); }
  	"finally"                   { return symbol(ChocoPyTokens.FINALLY); }
  	"for"                       { return symbol(ChocoPyTokens.FOR); }
  	"from"                      { return symbol(ChocoPyTokens.FROM); }
  	"global"                    { return symbol(ChocoPyTokens.GLOBAL); }
  	"if"                        { return symbol(ChocoPyTokens.IF); }
  	"import"                    { return symbol(ChocoPyTokens.IMPORT); }
  	"in"                        { return symbol(ChocoPyTokens.IN); }
  	"lambda"                    { return symbol(ChocoPyTokens.LAMBDA); }
  	"nonlocal"                  { return symbol(ChocoPyTokens.NONLOCAL); }
  	"pass"                      { return symbol(ChocoPyTokens.PASS); }
  	"raise"                     { return symbol(ChocoPyTokens.RAISE); }
  	"try"                       { return symbol(ChocoPyTokens.TRY); }
  	"while"                     { return symbol(ChocoPyTokens.WHILE); }
  	"with"                      { return symbol(ChocoPyTokens.WITH); }
  	"yield"                     { return symbol(ChocoPyTokens.YIELD); }

  	/* Function */
  	"def"        								{ return symbol(ChocoPyTokens.DEF); }
    "return"     								{ return symbol(ChocoPyTokens.RETURN); }
    "->"         								{ return symbol(ChocoPyTokens.ARROW); }
    "("          								{ return symbol(ChocoPyTokens.LPAREN); }
    ")"          								{ return symbol(ChocoPyTokens.RPAREN); }
    ","          								{ return symbol(ChocoPyTokens.COMMA); }
    "."          								{ return symbol(ChocoPyTokens.DOT); }

    /* Literals. */
      {IntegerLiteral}            { return symbol(ChocoPyTokens.INTEGER,
                                                     Integer.parseInt(yytext())); }

     /* Identifiers. */
     {Identifier}                { return symbol(ChocoPyTokens.IDENTIFIER, yytext()); }

  /* Whitespace. */
  {WhiteSpace}                { ws++;
                                if(yyline==0 && yycolumn==0 ) {
                                    yypushback(yylength());
                                    yybegin(INDENTSTATE);
                                }
                              }

  /* Apóstrofo Simples */
  \'                          { /* ignore */ }

}

  <INDENTSTATE>{
    {WhiteSpace}+               {
                                  int col = 0;
                                  /* Indentation contains tabs */
                                  // If a '\t' is seen, then one need to replace
                                  // it with whitespaces such that the up until
                                  // now whitespaces have number be a multiple of
                                  // 8.
                                  for (int i = 0; i < yylength(); i++) {
                                      if(yycharat(i)==' '){
                                          col++;
                                      }else{
                                          col= (col==0) ? 8:((col+8)/8)*8;
                                      }
                                  }
                                  if(addIndent(col)){
                                     yybegin(YYINITIAL);
                                     return symbol(ChocoPyTokens.INDENT);
                                  }else{
                                     if (rmIndent(col)){
                                         // the indentation level in the current
                                         // line ("col") should be greater than the
                                         // indentation after DEDENT since
                                         // otherwise "col" will be a line that has
                                         // a invalid indentation level:
                                         // e.g.
                                         // for(1):
                                         //     x = 2
                                         //     for (2):
                                         //         y = 3
                                         //       z = 4 #this.indent=4; col=6;
                                         // for such case, we should not output
                                         // DEDENT instead of return an error.
                                         if(this.indent < col){
                                             return symbol(
                                                      ChocoPyTokens.UNRECOGNIZED,
                                                      "<bad indentation>");
                                         }else{
                                             yypushback(yylength());
                                             return symbol(ChocoPyTokens.DEDENT);
                                         }
                                     } else{
                                         yybegin(YYINITIAL);
                                     }
                                  }
                                }
    {WhiteSpace}*{LineBreak}    { /* ignore */ }
    {WhiteSpace}*{Comment}      { /* ignore */ }
    \S                          {
                                  /* NEWLINE follows with a non-{WhiteSpace} char*/
                                  // (1) pushback the buffer by 1
                                  // (2) check whether there are any dendentation
                                  //     that needs to do
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
