open Ast
open Utils

(* Extend the environment with a new variable and its corresponding value. *)
let extend env x v = (x, v) :: env

(* Lookup a variable's value in the environment, return None if not found. *)
let rec lookup env x =
  match env with
  | [] -> None
  | (var, value) :: t -> if x = var then Some value else lookup t x

(* Recursively check if a variable is used within an expression. *)
let rec p3_helper var expr =
  match expr with
  | Record l -> List.exists (fun (_, v) -> p3_helper var v) l  (* Check all fields in a record. *)
  | Select (_, f) -> p3_helper var f  (* Check in the selected field of a record. *)
  | If (g, u, p) -> p3_helper var g || p3_helper var u || p3_helper var p  (* Check all branches of an if-expression. *)
  | Fun (_, _, f) -> p3_helper var f  (* Check within the function body. *)
  | Let (j, d, q) -> p3_helper var d || (j <> var && p3_helper var q)  (* Check in the initialization and body, skip if shadowed. *)
  | App (x, y) -> p3_helper var x || p3_helper var y  (* Check both function and argument in an application. *)
  | ID r -> r = var  (* Direct comparison for identifier. *)
  | Binop (_, y, z) -> p3_helper var y || p3_helper var z  (* Check both sides of a binary operation. *)
  | _ -> false  (* Base case, return false if no match found. *)

(* Optimize expressions by reducing unnecessary calculations and simplifying where possible. *)
let rec optimize env e =
  match e with
  | Select (b, expr) -> (
      let x = optimize env expr in
      match x with
      | Record lst -> ( try List.assoc b lst with Not_found -> Select (b, x))  (* Return the field value if found; otherwise, keep the select. *)
      | _ -> Select (b, x))
  | Fun (k, l, body) -> Fun (k, l, optimize env body)  (* Optimize the function body. *)
  | App (Fun (m, _, ID n), u) when m = n -> optimize env u  (* Simplify identity functions directly to the argument. *)
  | If (t, w, q) -> (
      let d = optimize env t in
      match d with
      | Bool true -> optimize env w
      | Bool false -> optimize env q
      | _ -> If (d, optimize env w, optimize env q))
  | App (z, r) -> (
      let f = optimize env z in
      let q = optimize env r in
      match f with
      | Fun (a, _, y) ->
          let new_env = extend env a q in
          optimize new_env y
      | _ -> App (f, q))
  | Record d -> Record (List.map (fun (h, p) -> (h, optimize env p)) d)  (* Optimize each field in a record. *)
  | Int _ | Bool _ -> e  (* Base cases for literals that do not require optimization. *)
  | ID x -> ( match lookup env x with Some j -> j | None -> e)  (* Replace ID with its value if found in the environment. *)
  | Let (e, c, n) ->
      let x = optimize env c in
      let y = optimize env n in
      if not (p3_helper e y) then y  (* If variable is not used in the body, return body only. *)
      else
        let new_env = extend env e x in
        let o = optimize new_env y in
        if x = o then x else Let (e, x, o)  (* Simplify the let if initial and optimized bodies are the same. *)
  | Binop (h, e1, e2) -> (
      let s = optimize env e1 in
      let i = optimize env e2 in
      match (h, s, i) with
      | Div, _, Int 0 -> raise DivByZeroError  (* Check for division by zero. *)
      | Equal, Int x, Int y -> Bool (x = y)
      | Div, Int a, Int b when b <> 0 -> Int (a / b)
      | And, Bool true, x | And, x, Bool true -> x
      | Mult, Int a, Int b -> Int (a * b)
      | And, Bool false, _ | And, _, Bool false -> Bool false
      | Sub, Int a, Int b -> Int (a - b)
      | Or, Bool true, _ | Or, _, Bool true -> Bool true
      | Add, Int a, Int b -> Int (a + b)
      | Or, Bool false, x | Or, x, Bool false -> x
      | Div, x, Int 1 -> x
      | Add, Int 0, x | Add, x, Int 0 -> x
      | Div, Int 0, _ -> Int 0
      | Mult, Int 1, x | Mult, x, Int 1 -> x
      | Sub, x, Int 0 -> x
      | Mult, Int 0, _ | Mult, _, Int 0 -> Int 0
      | _ -> Binop (h, s, i))
  | _ -> e  (* Default case for all other expressions. *)

(* Entry point to optimize a program given an environment and an expression. *)
let optimize_program env expr = optimize env expr
