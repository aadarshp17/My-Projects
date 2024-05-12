open Types

val eval_expr : environment -> expr -> expr
val eval_mutop : environment -> mutop -> environment * expr option
