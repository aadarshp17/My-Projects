(* The first section of the lexer definition, called the *header*,
   is the part that appears below between { and }.  It is code
   that will simply be copied literally into the generated lexer.ml. *)

{
open Parser
}

(* The second section of the lexer definition defines *identifiers*
   that will be used later in the definition.  Each identifier is
   a *regular expression*.  We won't go into details on how regular
   expressions work.
   
   Below, we define regular expressions for 
     - whitespace (spaces and tabs),
     - digits (0 through 9)
     - integers (nonempty sequences of digits, optionally preceded by a minus sign)
     - letters (a through z, and A through Z), and
     - identifiers (nonempty sequences of letters).
     
   FYI, these aren't exactly the same as the OCaml definitions of integers and 
   identifiers. *)

let blank = [' ' '\t']+
let decimal_literal = ['0'-'9']+
let letter = ['a'-'z' 'A'-'Z']
let id = letter (letter |decimal_literal)*

(* The final section of the lexer definition defines how to parse a character
   stream into a token stream.  Each of the rules below has the form 
     | regexp { action }
   If the lexer sees the regular expression [regexp], it produces the token 
   specified by the [action].  We won't go into details on how the actions
   work.  *)

rule token = 
  parse
  | blank { token lexbuf }
  | "fun" { FUN }
  | "if"  { IF }
  | "then"  { THEN }
  | "else"    { ELSE }
  | "false"  { BOOL false }
  | "true"   { BOOL true }
  | "not"    { NOT }
  | "+"   { PLUS }
  | "-"   { MINUS }
  | "*"   { MULT }
  | "/"   { DIV }
  | "&&"   { AND }
  | "||"   { OR }
  | "<>" {NE}
  | ">" {GT}
  | "<" {LT}
  | ">=" {GE}
  | "<=" {LE}
  | "("   { LPAREN }
  | ")"   { RPAREN }
  | '{'   { LCURLY }
  | '}'   { RCURLY }
  | ';'   { SEMI }
  | '.'   { DOT }
  | "let" { LET }
  | "="   { EQUALS }
  | "->"  { GOESTO }
  | ':'   { COLON }
  | "in"  { IN }
  | "rec"  { REC }
  | "Int"  { INTTYPE }
  | "Bool"  { BOOLTYPE }
  | id    { IDENT (Lexing.lexeme lexbuf) }
  | decimal_literal   { INT (int_of_string (Lexing.lexeme lexbuf)) }
  | eof   { EOF }
	
(* And that's the end of the lexer definition. *)
