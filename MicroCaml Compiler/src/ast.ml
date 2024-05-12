(* The type of the abstract syntax tree (AST). *)
exception InvalidInputException of string

(* error types *)
exception TypeError of string
exception DeclareError of string
exception SelectError of string
exception DivByZeroError

type op =
  | Add
  | Sub
  | Mult
  | Div
  | Greater
  | Less
  | GreaterEqual
  | LessEqual
  | Equal
  | NotEqual
  | Or
  | And
[@@deriving show { with_path = false }]

type var = string [@@deriving show { with_path = false }]
type label = Lab of var [@@deriving show { with_path = false }]

type exptype =
  | TInt
  | TBool
  | TArrow of exptype * exptype
  | TRec of (label * exptype) list
  | TBottom
[@@deriving show { with_path = false }]

type expr =
  | Int of int
  | Bool of bool
  | ID of var
  | Binop of op * expr * expr
  | Not of expr
  | If of expr * expr * expr
  | Let of var * expr * expr
  | LetRec of var * exptype * expr * expr
  | Fun of var * exptype * expr
  | App of expr * expr
  | Record of (label * expr) list
  | Select of label * expr
[@@deriving show { with_path = false }]

type 'a environment = (var * 'a) list 