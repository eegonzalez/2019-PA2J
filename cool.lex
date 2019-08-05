/*
 *  The scanner definition for COOL.
 */

import java_cup.runtime.Symbol;

%%

%{

/*  Stuff enclosed in %{ %} is copied verbatim to the lexer class
 *  definition, all the extra variables/functions you want to use in the
 *  lexer actions should go here.  Don't remove or modify anything that
 *  was there initially.  */

    // Max size of string constants
    static int MAX_STR_CONST = 1025;

    // For assembling string constants
    StringBuffer string_buf = new StringBuffer();
    private int curr_lineno = 1;
	private int open_comm_num =0;
    int get_curr_lineno() {
	return curr_lineno;
    }

    private AbstractSymbol filename;
	Symbol maxString(){
      if(string_buf.length() >= MAX_STR_CONST-1){
	return new Symbol(TokenConstants.ERROR,"MAX length excceeded");
      }else{
	return null;
      }
    }
    void set_filename(String fname) {
	filename = AbstractTable.stringtable.addString(fname);
    }

    AbstractSymbol curr_filename() {
	return filename;
    }
%}

%init{

/*  Stuff enclosed in %init{ %init} is copied verbatim to the lexer
 *  class constructor, all the extra initialization you want to do should
 *  go here.  Don't remove or modify anything that was there initially. */

    // empty for now
%init}

%eofval{

/*  Stuff enclosed in %eofval{ %eofval} specifies java code that is
 *  executed when end-of-file is reached.  If you use multiple lexical
 *  states and want to do something special if an EOF is encountered in
 *  one of those states, place your code in the switch statement.
 *  Ultimately, you should return the EOF symbol, or your lexer won't
 *  work.  */

    switch(yy_lexical_state) {
    case YYINITIAL:
	/* nothing special to do in the initial state */
		
	break;
	/* If necessary, add code for other states here, e.g:
	   case COMMENT:
	   ...
	   break;
	*/
	case STRING:
      yybegin(YYINITIAL);
      return new Symbol(TokenConstants.ERROR,"EOF in STRING");
    case COMMENT:
      yybegin(YYINITIAL);
      return new Symbol(TokenConstants.ERROR,"EOF in COMMENT");
    case STRING_FAIL:
      yybegin(YYINITIAL);
      return new Symbol(TokenConstants.ERROR,"EOF in STRING");
    }
    return new Symbol(TokenConstants.EOF);
%eofval}

%class CoolLexer
%cup


%state COMMENT
%state SIMPLE_COMMENT
%state STRING
%state STRING_FAIL

%%

<YYINITIAL>"=>"			{ /* Sample lexical rule for "=>" arrow.
                                     Further lexical rules should be defined
                                     here, after the last %% separator */
                                  return new Symbol(TokenConstants.DARROW); }



<YYINITIAL>"*"			{return new Symbol(TokenConstants.MULT);}

<YYINITIAL>"-"			{return new Symbol(TokenConstants.MINUS);}

<YYINITIAL>";"			{return new Symbol(TokenConstants.SEMI);}

<YYINITIAL>"("			{return new Symbol(TokenConstants.LPAREN);}

<YYINITIAL>")"			{return new Symbol(TokenConstants.RPAREN);}

<YYINITIAL>"<"			{return new Symbol(TokenConstants.LT);}

<YYINITIAL>"<="			{return new Symbol(TokenConstants.LE);}

<YYINITIAL>","			{return new Symbol(TokenConstants.COMMA);}

<YYINITIAL>"="			{return new Symbol(TokenConstants.EQ);}

<YYINITIAL>"."			{return new Symbol(TokenConstants.DOT);}

<YYINITIAL>"/"			{return new Symbol(TokenConstants.DIV);}

<YYINITIAL>"+"			{return new Symbol(TokenConstants.PLUS);}

<YYINITIAL>":"			{return new Symbol(TokenConstants.COLON);}

<YYINITIAL>"{"			{return new Symbol(TokenConstants.LBRACE);}

<YYINITIAL>"}"			{return new Symbol(TokenConstants.RBRACE);}

<YYINITIAL>"@"			{return new Symbol(TokenConstants.AT);}

<YYINITIAL>"<-"			{return new Symbol(TokenConstants.ASSIGN);}

<YYINITIAL>"~"			{return new Symbol(TokenConstants.NEG);}

<YYINITIAL>_                               { return new Symbol(TokenConstants.ERROR,"_");}

<YYINITIAL>#                               { return new Symbol(TokenConstants.ERROR,"#");}

<YYINITIAL>!                               { return new Symbol(TokenConstants.ERROR,"!"); }

<YYINITIAL>\$                              { return new Symbol(TokenConstants.ERROR,"$"); }

<YYINITIAL>%                               { return new Symbol(TokenConstants.ERROR,"%"); }

<YYINITIAL>"^"                             { return new Symbol(TokenConstants.ERROR,"^"); }

<YYINITIAL>&                               { return new Symbol(TokenConstants.ERROR,"&"); }

<YYINITIAL>>                               { return new Symbol(TokenConstants.ERROR,">"); }

<YYINITIAL>"?"                             { return new Symbol(TokenConstants.ERROR,"?"); }

<YYINITIAL>`                               { return new Symbol(TokenConstants.ERROR,"`"); }

<YYINITIAL>"["                             { return new Symbol(TokenConstants.ERROR,"["); }

<YYINITIAL>"]"                             { return new Symbol(TokenConstants.ERROR,"]"); }

<YYINITIAL>\\                              { return new Symbol(TokenConstants.ERROR,"\\"); }

<YYINITIAL>\|                              { return new Symbol(TokenConstants.ERROR,"|"); }

<YYINITIAL>[0-9]+		{	IntTable newi = new IntTable();
							return new Symbol(TokenConstants.INT_CONST,newi.addString(yytext()));}

<YYINITIAL>(I|i)(N|n)(H|h)(E|e)(R|r)(I|i)(T|t)(S|s)			{return new Symbol(TokenConstants.INHERITS);}

<YYINITIAL>(N|n)(O|o)(T|t) 									{return new Symbol(TokenConstants.NOT);}

<YYINITIAL>(P|p)(O|o)(O|o)(L|l)				{return new Symbol(TokenConstants.POOL);}

<YYINITIAL>(L|l)(O|o)(O|o)(P|p)				{return new Symbol(TokenConstants.LOOP);}

<YYINITIAL>(C|c)(A|a)(S|s)(E|e)				{return new Symbol(TokenConstants.CASE);}

<YYINITIAL>(C|c)(L|l)(A|a)(S|s)(S|s)		{return new Symbol(TokenConstants.CLASS);}

<YYINITIAL>(I|i)(F|f)						{return new Symbol(TokenConstants.IF);}

<YYINITIAL>(I|i)(N|n)						{return new Symbol(TokenConstants.IN);}

<YYINITIAL>(O|o)(F|f)						{return new Symbol(TokenConstants.OF);}

<YYINITIAL>(F|f)(I|i)						{return new Symbol(TokenConstants.FI);}

<YYINITIAL>(W|w)(H|h)(I|i)(L|l)(E|e)		{return new Symbol(TokenConstants.WHILE);}

<YYINITIAL>(L|l)(E|e)(T|t)					{return new Symbol(TokenConstants.LET);}

<YYINITIAL>(T|t)(H|h)(E|e)(N|n)					{return new Symbol(TokenConstants.THEN);}

<YYINITIAL>(E|e)(L|l)(S|s)(E|e)				{return new Symbol(TokenConstants.ELSE);}

<YYINITIAL>(E|e)(S|s)(A|a)(C|c)				{return new Symbol(TokenConstants.ESAC);}

<YYINITIAL>(I|i)(S|s)(V|v)(O|o)(I|i)(D|d)				{return new Symbol(TokenConstants.ISVOID);}

<YYINITIAL>(N|n)(E|e)(W|w)					{return new Symbol(TokenConstants.NEW);}

<YYINITIAL>(t)(r|R)(u|U)(e|E)	{return new Symbol(TokenConstants.BOOL_CONST, new Boolean (yytext()));}

<YYINITIAL>(f)(a|A)(l|L)(s|S)(e|E)	{return new Symbol(TokenConstants.BOOL_CONST, new Boolean (yytext()));}

<YYINITIAL>[A-Z]([A-Za-z0-9]|"_")*		{	IdTable newidT = new IdTable();
													return new Symbol(TokenConstants.TYPEID,newidT.addString(yytext()));}

<YYINITIAL>[a-z]([A-Za-z0-9]|"_")*		{	StringTable newobjT = new StringTable();
													return new Symbol(TokenConstants.OBJECTID,newobjT.addString(yytext()));}

<YYINITIAL>"\""                            {string_buf.setLength(0); yybegin(STRING); }

<YYINITIAL> "--"                           {yybegin(SIMPLE_COMMENT);}

<YYINITIAL, COMMENT> "(*"                  {open_comm_num ++;yybegin(COMMENT);}

<YYINITIAL> "*)"                           {return new Symbol(TokenConstants.ERROR,"Unmatched *)");}

<COMMENT>"*)"                              {open_comm_num--;if(open_comm_num == 0){yybegin(YYINITIAL);}}

<COMMENT,SIMPLE_COMMENT>[^\n]         {	}

<COMMENT>\n                                {curr_lineno++;}

<SIMPLE_COMMENT>\n                    {yybegin(YYINITIAL);curr_lineno++;}

<STRING>\"                                 {yybegin(YYINITIAL); 
											StringTable strT = new StringTable();
                                            return new Symbol(TokenConstants.STR_CONST,strT.addString(string_buf.toString())); }

<STRING>"\n"|\\n					{if(maxString()!=null){yybegin(STRING_FAIL);return maxString();}
												else{string_buf.append("\n");curr_lineno++;}}
 
<STRING>"\t"|\\t					{if(maxString()!=null){yybegin(STRING_FAIL);return maxString();}
												else{string_buf.append("\t");}}

<STRING>"\f"|\\f					{if(maxString()!=null){yybegin(STRING_FAIL);return maxString();}else{string_buf.append("\f");}}

<STRING>"\b"|\\b					{if(maxString()!=null){yybegin(STRING_FAIL);return maxString();}
												else{string_buf.append("\b");}}

<STRING>\x0D                               {if(maxString()!=null){yybegin(STRING_FAIL);return maxString();}
												else{string_buf.append("\015");}}

<STRING>\x1B                               {if(maxString()!=null){yybegin(STRING_FAIL);return maxString();}
												else{string_buf.append("\033");}}

<STRING>\n 							{yybegin(YYINITIAL); return new Symbol(TokenConstants.ERROR,"Line not Closed");}	

<STRING>\0                                 {yybegin(STRING_FAIL);return new Symbol(TokenConstants.ERROR, "Null in String");}

<STRING>\\[^\0]                            {if(maxString()!=null){yybegin(STRING_FAIL);return maxString();}
												else{string_buf.append(yytext().substring(1)); }}

<STRING>.                                  {if(maxString()!=null){yybegin(STRING_FAIL);return maxString();}else{ string_buf.append(yytext());} }

<STRING_FAIL> \n|\"                       {yybegin(YYINITIAL);}

<STRING_FAIL>.                            {	}

\n 	{curr_lineno++;}

<YYINITIAL>[ \t\r\n\f\x0B]			{	}

<YYINITIAL>.  {return new Symbol(TokenConstants.ERROR, yytext());}

.                               { /* This rule should be the very last
                                     in your lexical specification and
                                     will match match everything not
                                     matched by other lexical rules. */
                                  System.err.println("LEXER BUG - UNMATCHED: " + yytext()); }

