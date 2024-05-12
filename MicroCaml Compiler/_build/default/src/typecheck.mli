open Ast

val is_subtype : exptype -> exptype -> bool
val typecheck : exptype environment -> expr -> exptype
