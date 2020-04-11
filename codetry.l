%{
#define lists				strcat(buffer, yytext)
#define token(t)			{lists; if (T_Opt) printf("<%s>\n", #t);}
#define Char_token(t)		{lists; if (T_Opt) printf("<%s>\n", (t));}
#define Integer_token(t, i)	{lists; if (T_Opt) printf("<%s: %d>\n", #t, (i));}
#define String_token(t, s)	{lists; if (T_Opt) printf("<%s: %s>\n", #t, (s));}
#define SString_token(s, len){lists; int i; if (T_Opt) { printf("<string: "); for( i=1; i<len-1; i++ ){ printf("%c", s[i]); if( s[i]==34 ) i++; }	printf(">\n"); } }
#define KEYWORDS_token(t)		{lists; if (T_Opt) printf("<KEYWORD--%s>\n", t);}
#define S_open()				{lists; S_Opt = 1;}
#define S_close()			{lists; S_Opt = 0;}
#define T_open()				{lists; T_Opt = 1;}
#define T_close()			{lists; T_Opt = 0;}

#define MAXI      256

int S_Opt = 1;
int T_Opt = 1;
int lno = 1;
char buffer[MAXI];
%}

%Start COMMENT

SYMBOLS	[,;:\(\)\[\]]
ARITHMETIC_OPERATORS	[\+\-\*/]|mod
ASSIGNMENT_OPERATORS	:=
RELATIONAL_OPERATORS	<|<=|<>|>=|>|=
LOGICAL_OPERATORS		and|or|not
KEYWORDS		array|begin|boolean|def|do|else|end|false|for|integer|if|of|print|read|real|string|then|to|true|return|var|while
IDENTIFIERS	[a-zA-Z][a-zA-Z0-9]*
integer		[1-9][0-9]*|0
octinteger	0[0-7]+
float		{integer}\.[0-9]*
SCIENTIFIC	({integer}|{octinteger}|{float})[Ee][\+\-]?({integer}|{octinteger})
string		\"([^\n\"]|\"\")*\"
TAB		[ \t]

%%

<INITIAL>{SYMBOLS}	{ Char_token(yytext); }
<INITIAL>{ARITHMETIC_OPERATORS}	{ Char_token(yytext); }
<INITIAL>{ASSIGNMENT_OPERATORS}	{ Char_token(yytext); }
<INITIAL>{RELATIONAL_OPERATORS}		{ Char_token(yytext); }
<INITIAL>{LOGICAL_OPERATORS}		{ Char_token(yytext); }
<INITIAL>{KEYWORDS}		{ KEYWORDS_token(yytext); }
<INITIAL>{IDENTIFIERS}	{ String_token(id, yytext); }
<INITIAL>{integer}		{ String_token(integer, yytext); }
<INITIAL>{octinteger}	{ String_token(oct_integer, yytext); }
<INITIAL>{SCIENTIFIC}	{ String_token(SCIENTIFIC, yytext); }
<INITIAL>{float}		{ String_token(float, yytext); }
<INITIAL>{string}		{ SString_token(yytext, yyleng); }
<INITIAL>{TAB}		{ lists; }

<INITIAL>\/\/\&T\+.*	{ T_open(); }
<INITIAL>\/\/\&T\-.*	{ T_close(); }
<INITIAL>\/\/\&S\+.*	{ S_open(); }
<INITIAL>\/\/\&S\-.*	{ S_close(); }
<INITIAL>\/\/.*			{ lists; }
<INITIAL>\/\*			{ lists; BEGIN COMMENT; }

<COMMENT>.*\*\/			{ lists; BEGIN INITIAL; }
<COMMENT>.*				{ lists; }

\n				{	
					lists;
					if (S_Opt)
						printf("%d: %s", lno, buffer);
					lno++;
					buffer[0] = '\0';
				}

%%
int main( int argc, char **argv )
{ printf("\n------------------- Compiler Project By Rohini.R------------------------\n"); 
  printf("\n \t\t\tIdentifying the \n\t1)lexemes,\n\t2)keywords,\n\t3)arithmetic,Relatinal and logical operators,\n\t4)Identifiers,\n\t5)Integer,Floating-Point Constants,\n\t6)Scientific Notations,\n\t7)String Constants\t from the pseudocode\n");
  if( argc != 2 ) {
    fprintf( stderr, "Usage is: ./scanner [filename]\n" );
    exit(0);
  }
	
  FILE *fp = fopen( argv[1], "r" );
  if( fp == NULL ) {
    fprintf( stderr, "Error in opening file\n" );
    exit(-1);
  }
  yyin = fp;

  yylex();

  exit(0);
}
