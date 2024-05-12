(* lexer types *)
exception InvalidInputException of string

type token =
  | Tok_RParen
  | Tok_LParen
  | Tok_RCurly
  | Tok_LCurly
  | Tok_Dot
  | Tok_Equal
  | Tok_NotEqual
  | Tok_Greater
  | Tok_Less
  | Tok_GreaterEqual
  | Tok_LessEqual
  | Tok_Or
  | Tok_And
  | Tok_Not
  | Tok_If
  | Tok_Then
  | Tok_Else
  | Tok_Add
  | Tok_Sub
  | Tok_Mult
  | Tok_Div
  | Tok_Concat
  | Tok_Let
  | Tok_Rec
  | Tok_In
  | Tok_Def
  | Tok_Fun
  | Tok_Arrow
  | Tok_Int of int
  | Tok_Bool of bool
  | Tok_String of string
  | Tok_ID of string
  | Tok_DoubleSemi
  | Tok_Semi

(* parser & evaluator types *)
exception TypeError of string
exception DeclareError of string
exception SelectError of string
exception DivByZeroError

type op =
  | Add
  | Sub
  | Mult
  | Div
  | Concat
  | Greater
  | Less
  | GreaterEqual
  | LessEqual
  | Equal
  | NotEqual
  | Or
  | And

type var = string 
type label = Lab of var 

type expr =
  | Int of int
  | Bool of bool
  | String of string
  | ID of var
  | Fun of var * expr
  | Not of expr
  | Binop of op * expr * expr
  | If of expr * expr * expr
  | App of expr * expr
  | Let of var * bool * expr * expr
  | Closure of environment * var * expr
  | Record of (label * expr) list
  | Select of label * expr

and environment = (var * expr ref) list

type mutop = 
  | Def of var * expr 
  | Expr of expr 
  | NoOp
