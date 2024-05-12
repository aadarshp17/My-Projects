
(* The type of tokens. *)

type token = 
  | THEN
  | SEMI
  | RPAREN
  | REC
  | RCURLY
  | PLUS
  | OR
  | NOT
  | NE
  | MULT
  | MINUS
  | LT
  | LPAREN
  | LET
  | LE
  | LCURLY
  | INTTYPE
  | INT of (int)
  | IN
  | IF
  | IDENT of (string)
  | GT
  | GOESTO
  | GE
  | FUN
  | EQUALS
  | EOF
  | ELSE
  | DOT
  | DIV
  | COLON
  | BOOLTYPE
  | BOOL of (bool)
  | AND

(* This exception is raised by the monolithic API functions. *)

exception Error

(* The monolithic API. *)

val prog: (Lexing.lexbuf -> token) -> Lexing.lexbuf -> (Ast.expr)
