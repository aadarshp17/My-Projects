open Ast
open Utils

(* Extend the environment with a new variable and type binding. *)
let extend env x v = (x, v) :: env

(* Lookup a variable's type in the environment, raising an error if not found. *)
let rec lookup env x =
  match env with
  | [] -> raise (DeclareError ("Unbound type for " ^ x))
  | (var, value) :: t -> if x = var then value else lookup t x

(* Typecheck function that dispatches based on the type of expression. *)
let rec typecheck gamma e =
  match e with
  | Record g ->
      (* Construct a record type by recursively typechecking each field. *)
      TRec (List.map (fun (Lab l, expr) -> (Lab l, typecheck gamma expr)) g)
  | If (p3, p4, p5) ->
      (* Typecheck the condition and both branches of the if-statement. *)
      let a2 = typecheck gamma p3 in
      let a3 = typecheck gamma p4 in
      let a4 = typecheck gamma p5 in
      (* Ensure the condition is boolean and both branches are of the same type. *)
      if a2 = TBool then
        if a3 = a4 then a3
        else raise (TypeError "expressions must be same type")
      else raise (TypeError "need boolean")
  | Select (Lab l, e) -> (
      (* Typecheck the expression and ensure it's a record before selecting a field. *)
      match typecheck gamma e with
      | TRec fields -> (
          try List.assoc (Lab l) fields
          with Not_found -> raise (TypeError "unknown label"))
      | _ -> raise (SelectError "failed operation"))
  | Binop (p1, g6, i5) -> (
      (* Typecheck both operands of the binary operation. *)
      let r4 = typecheck gamma g6 in
      let l9 = typecheck gamma i5 in
      (* Ensure operands are of correct types based on the operator. *)
      match p1 with
      | (Mult | Div | Add | Sub) when r4 = TInt && l9 = TInt -> TInt
      | (GreaterEqual | LessEqual | Greater | Less) when r4 = TInt && l9 = TInt -> TBool
      | (Equal | NotEqual) when r4 = l9 -> TBool
      | (And | Or) when r4 = TBool && l9 = TBool -> TBool
      | _ -> raise (TypeError "type error"))
  | Fun (h, g, f) ->
      (* Extend environment with function parameter and typecheck the body. *)
      let c = extend gamma h g in
      let d = typecheck c f in
      (* Return a function type. *)
      TArrow (g, d)
  | Not e ->
      (* Typecheck the operand of the not operation, expecting a boolean. *)
      let g7 = typecheck gamma e in
      if g7 = TBool then TBool else raise (TypeError "need boolean")
  | Let (w, q, z) ->
      (* Typecheck the expression bound to the variable and typecheck the body in the extended environment. *)
      let p3 = typecheck gamma q in
      let p4 = extend gamma w p3 in
      typecheck p4 z
  | App (x, r8) -> (
      (* Typecheck the function and the argument, ensuring the function's parameter type matches the argument's type. *)
      let p = typecheck gamma x in
      let q = typecheck gamma r8 in
      match p with
      | TArrow (b, y) when b = q -> y
      | _ -> raise (TypeError "type mismatch"))
  | LetRec (e, p, s, v) ->
      (* Extend environment with recursive binding, typecheck the body and the rest of the expression. *)
      let m = extend gamma e p in
      let t1 = typecheck m s in
      if t1 = p then typecheck m v else raise (TypeError "type mismatch")
  | ID x -> lookup gamma x  (* Retrieve the type of an identifier. *)
  | Bool _ -> TBool  (* Return type Boolean for boolean literals. *)
  | Int _ -> TInt  (* Return type Integer for integer literals. *)

(* Subtyping function to determine if one type is a subtype of another. *)
let rec is_subtype t1 t2 =
  match (t1, t2) with
  | TRec h9, TRec h0 ->
      (* Check if all fields in the second record type are present in the first with a matching or subtype field type. *)
      List.for_all
        (fun (Lab o, t2) ->
          match List.find_opt (fun (Lab b, _) -> b = o) h9 with
          | Some (_, t1) -> is_subtype t1 t2
          | None -> false)
        h0
  | TArrow (k5, t6), TArrow (e3, j8) -> is_subtype e3 k5 && is_subtype t6 j8
  | _, _ -> false  (* Return false for different base types. *)
  | TInt, TInt -> true  (* Int is a subtype of Int. *)
  | TBool, TBool -> true  (* Bool is a subtype of Bool. *)
