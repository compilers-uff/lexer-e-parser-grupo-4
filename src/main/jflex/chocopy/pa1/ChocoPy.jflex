package chocopy.pa1;
import java_cup.runtime.*;

%%

/*** Do not change the flags below unless you know what you are doing. ***/

%unicode
%line
%column

%class ChocoPyLexer
%public

%cupsym ChocoPyTokens
%cup
%cupdebug

%eofclose false

/*** Do not change the flags above unless you know what you are doing. ***/

/* The following code section is copied verbatim to the
 * generated lexer class. */
%{
    /* The code below includes some convenience methods to create tokens
     * of a given type and optionally a value that the CUP parser can
     * understand. Specifically, a lot of the logic below deals with
     * embedded information about where in the source code a given token
     * was recognized, so that the parser can report errors accurately.
     * (It need not be modified for this project.) */

    /** Producer of token-related values for the parser. */
    final ComplexSymbolFactory symbolFactory = new ComplexSymbolFactory();

    /** Return a terminal symbol of syntactic category TYPE and no
     *  semantic value at the current source location. */
    private Symbol symbol(int type) {
        return symbol(type, yytext());
    }

    /** Return a terminal symbol of syntactic category TYPE and semantic
     *  value VALUE at the current source location. */
    private Symbol symbol(int type, Object value) {
        return symbolFactory.newSymbol(ChocoPyTokens.terminalNames[type], type,
            new ComplexSymbolFactory.Location(yyline + 1, yycolumn + 1),
            new ComplexSymbolFactory.Location(yyline + 1,yycolumn + yylength()),
            value);
    }

%}

/* Macros (regexes used in rules below) */

WhiteSpace = [ \t]
LineBreak  = \r|\n|\r\n

Identifier = [a-zA-Z_][a-zA-Z0-9_]*
IntegerLiteral = 0 | [1-9][0-9]*

%%


<YYINITIAL> {

  /* Delimiters. */
  {LineBreak}                 { return symbol(ChocoPyTokens.NEWLINE); }

  /* Literals. */
  {IntegerLiteral}            { return symbol(ChocoPyTokens.INTEGER,
                                                 Integer.parseInt(yytext())); }

 /* Identifiers. */
 {Identifier}                { return symbol(ChocoPyTokens.IDENTIFIER, yytext()); }

  /* Operators. */
  "+"                         { return symbol(ChocoPyTokens.PLUS, yytext()); }
  "="                         { return symbol(ChocoPyTokens.EQ); }
  ":"                         { return symbol(ChocoPyTokens.COLON); }

  /* Whitespace. */
  {WhiteSpace}                { /* ignore */ }

  /* Apóstrofo Simples */
  \'                          { /* ignore */ }

  "def"        { return symbol(ChocoPyTokens.DEF); }
  "return"     { return symbol(ChocoPyTokens.RETURN); }
  "->"         { return symbol(ChocoPyTokens.ARROW); }
  "("          { return symbol(ChocoPyTokens.LPAREN); }
  ")"          { return symbol(ChocoPyTokens.RPAREN); }
  ","          { return symbol(ChocoPyTokens.COMMA); }

}

<<EOF>>                       { return symbol(ChocoPyTokens.EOF); }

/* Error fallback. */
[^]                           { return symbol(ChocoPyTokens.UNRECOGNIZED); }
