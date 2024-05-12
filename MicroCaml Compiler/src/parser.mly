(* The first section of the grammar definition, called the *header*,
   is the part that appears below between %{ and %}.  It is code
   that will simply be copied literally into the generated parser.ml. 
   Here we use it just to open the Ast module so that, later on
   in the grammar definition, we can write expressions like 
   [Int i] instead of [Ast.Int i]. *)

%{
open Ast
%}

(* The next section of the grammar definition, called the *declarations*,
   first declares all the lexical *tokens* of the language.  These are 
   all the kinds of tokens we can expect to read from the token stream.
   Note that each of these is just a descriptive name---nothing so far
   says that LPAREN really corresponds to '(', for example.  The tokens
   that have a <type> annotation appearing in them are declaring that
   they will carry some additional data along with them.  In the
   case of INT, that's an OCaml int.  In the case of ID, that's
   an OCaml string. *)
%token AND
%token DIV
%token DOT
%token <int> INT
%token <string> IDENT
%token <bool> BOOL
%token ELSE
%token FUN
%token GE
%token GT
%token IF
%token THEN
%token GOESTO
%token PLUS
%token LCURLY
%token MINUS
%token MULT
%token NOT
%token NE
%token LPAREN
%token LE
%token LT
%token OR
%token RPAREN
%token RCURLY
%token SEMI
%token LET
%token EQUALS
%token IN
%token REC
%token COLON
%token EOF

%token INTTYPE
%token BOOLTYPE


(* After declaring the tokens, we have to provide some additional information
   about precedence and associativity.  The following declarations say that
   PLUS is left associative, that IN is not associative, and that PLUS
   has higher precedence than IN (because PLUS appears on a line after IN).  
   
   Because PLUS is left associative, "1+2+3" will parse as "(1+2)+3"
   and not as "1+(2+3)".
   
   Because PLUS has higher precedence than IN, "let x=1 in x+2" will
   parse as "let x=1 in (x+2)" and not as "(let x=1 in x)+2". *)

%right prec_fun GOESTO                  /* function declaration, with clause */
%nonassoc IN
%right prec_if                          /* If ... Then ... Else */
%right OR                               /* Or */
%right AND                              /* And */
%left EQUALS,NE, GT,GE,LE,LT                             /* = */
%left PLUS MINUS                       /* + - * */
%left MULT  DIV                     /* *  / */
%right NOT                       /* !e, not e, ref e, etc. */


(* After declaring associativity and precedence, we need to declare what
   the starting point is for parsing the language.  The following
   declaration says to start with a rule (defined below) named [prog].
   The declaration also says that parsing a [prog] will return an OCaml
   value of type [Ast.expr]. *)

%start <Ast.expr> prog

(* The following %% ends the declarations section of the grammar definition. *)

%%

(* Now begins the *rules* section of the grammar definition.  This is a list
   of rules that are essentially in Backus-Naur Form (BNF), although where in 
   BNF we would write "::=" these rules simply write ":".
   
   The format of a rule is
   
     name:
       | production { action }
       | production { action }
       | etc.
       ;
       
    The *production* is the sequence of *symbols* that the rule matches. 
    A symbol is either a token or the name of another rule. 
    The *action* is the OCaml value to return if a match occurs. 
    Each production can *bind* the value carried by a symbol and use
    that value in its action.  This is perhaps best understood by example... *)
   

(* The first rule, named [prog], has just a single production.  It says
   that a [prog] is an [expr] followed by [EOF] (which stands for end-of-file).
   EOF is a token returned by the lexer when it reaches the end of the token stream.
   The first part of the production, [e=expr], says to match an [expr] and bind
   the resulting value to [e].  The action simply says to return that value [e]. *)
   
prog:
	| e = expr; EOF { e }
	;
	
(* The second rule, named [expr], has productions for integers, variables, 
   addition expressions, let expressions, and parenthesized expressions.
   
   - The first production, [i = INT], says to match an [INT] token, bind the
     resulting OCaml [int] value to [i], and return AST node [Int i].
   
   - The second production, [x = ID], says to match an [ID] token, bind the
     resulting OCaml [string] value to [x], and return AST node [Var x].	
   
   - The third production, [e1 = expr; PLUS; e2 = expr], says to match
     an [expr] followed by a [PLUS] token followed by another [expr].
     The first [expr] is bound to [e1] and the second to [e2].  The AST
     node returned is [Add(e1,e2)].
   
   - The fourth production, [LET; x = ID; EQUALS; e1 = expr; IN; e2 = expr],
     says to match a [LET] token followed by an [ID] token followed by
     an [EQUALS] token followed by an [expr] followed by an [IN] token
     followed by another [expr].  The string carried by the [ID] is bound
     to [x], and the two expressions are bound to [e1] and [e2].  The AST
     node returned is [Let(x,e1,e2)].
     
   - The fifth production, [LPAREN; e = expr; RPAREN] says to match an
     [LPAREN] token followed by an [expr] followed by an [RPAREN].  The
     expression is bound to [e] and returned. *)
          
expr:
  | e = appl_expr  { e }

	| e1 = expr; PLUS; e2 = expr { Binop(Add, e1,e2) }
  | e1 = expr; MINUS; e2 = expr { Binop(Sub, e1,e2) }
  | e1 = expr; MULT; e2 = expr { Binop(Mult, e1,e2) }
  | e1 = expr; DIV; e2 = expr { Binop(Div, e1,e2) }
  | e1 = expr; AND; e2 = expr { Binop(And, e1,e2) }
  | e1 = expr; OR; e2 = expr { Binop(Or, e1,e2) }
  | e1 = expr;NE; e2 = expr { Binop(NotEqual, e1,e2) }
  | e1 = expr; EQUALS; e2 = expr { Binop(Equal, e1,e2) }
  | e1 = expr; GT; e2 = expr { Binop(Greater, e1,e2) }
  | e1 = expr; GE; e2 = expr { Binop(GreaterEqual, e1,e2) }
  | e1 = expr; LT; e2 = expr { Binop(Less, e1,e2) }
  | e1 = expr; LE; e2 = expr { Binop(LessEqual, e1,e2) }
  | NOT e=expr { Not e }
  | IF e1=expr; THEN; e2=expr; ELSE; e3=expr %prec prec_if { If(e1, e2, e3) }
  | LET; REC; x = IDENT; COLON;t=type_decl; EQUALS; e1 = expr; IN; e2 = expr { LetRec(x,t, e1,e2) }
	| LET; x = IDENT; EQUALS; e1 = expr; IN; e2 = expr { Let(x,e1,e2) }
  | FUN; x = IDENT; COLON; t=type_decl; GOESTO; e1=expr %prec prec_fun  { Fun(x, t, e1) }
	
	;
	
appl_expr:
    e = simple_expr { e }
  | e1 = appl_expr e2 = simple_expr  { App(e1,e2) }
;
  
 simple_expr:
 | i = INT { Int i }
 | b = BOOL { Bool b }
 | LPAREN; e = expr; RPAREN { e }
 | x = IDENT { ID x }
 
  | LCURLY record_body RCURLY
      { Record $2 }
  | LCURLY RCURLY
      { Record [] }
  | simple_expr DOT label
      { Select($3, $1) }

record_body:
  l=label EQUALS e=expr  { [(l, e)] }
  | l=label EQUALS e=expr SEMI r=record_body
      { (l, e)::r }
;

label:
    IDENT
      { Lab $1 }

type_decl:
    INTTYPE
      { TInt }
  | BOOLTYPE
      { TBool }
  | type_decl GOESTO type_decl %prec prec_fun
      { TArrow($1, $3) }
  | LCURLY record_type RCURLY
      { TRec $2 }
  | LPAREN type_decl RPAREN
      { $2 }
(* And that's the end of the grammar definition. *)

record_type:
    l=label; COLON; t= type_decl
      { [(l, t)] }
  | l=label COLON t=type_decl SEMI r=record_type
      { (l, t)::r }
;