open Types

(* Provided functions - DO NOT MODIFY *)

(* Update the value of a variable in the environment *)
let rec update env x v =
  match env with
  | [] -> raise (DeclareError ("Unbound variable " ^ x))
  | (var, value) :: t -> if x = var then value := v else update t x v

(* Look up the value of a variable in the environment *)
let rec lookup env x =
  match env with
  | [] -> raise (DeclareError ("Unbound variable " ^ x))
  | (var, value) :: t -> if x = var then !value else lookup t x

(* Extend the environment with a new variable and its value *)
let extend env x v = (x, ref v) :: env

(* Extend the environment with a temporary placeholder for a variable *)
let extend_tmp env x = (x, ref (Int 0)) :: env

(* Part 1: Evaluating expressions *)

(* Check if two values are not equal *)
let equal_not x =
  match x with
  | String a, String b -> if a = b then Bool false else Bool true
  | Bool a, Bool b -> if a = b then Bool false else Bool true
  | Int a, Int b -> if a = b then Bool false else Bool true
  | _ -> raise (TypeError "nopee")

(* Check if one integer is less than or equal to another *)
let eq_lower x =
  match x with
  | Int a, Int b -> if a <= b then Bool true else Bool false
  | _ -> raise (TypeError "wrong type")

(* Multiply two integers *)
let n_times l =
  match l with
  | Int s, Int w -> Int (s * w)
  | _ -> raise (TypeError "wrong type")

(* Add two integers *)
let add_helper n =
  match n with
  | Int d, Int e -> Int (d + e)
  | _ -> raise (TypeError "wrong type")

(* Check if one integer is less than another *)
let lower x =
  match x with
  | Int a, Int b -> if a < b then Bool true else Bool false
  | _ -> raise (TypeError "wrong type")

(* Subtract one integer from another *)
let h_minus g =
  match g with
  | Int j, Int k -> Int (j - k)
  | _ -> raise (TypeError "wrong type")

(* Check if one integer is greater than or equal to another *)
let eq_greta x =
  match x with
  | Int a, Int b -> if a >= b then Bool true else Bool false
  | _ -> raise (TypeError "wrong type")

(* Negate a boolean value *)
let cancel a =
  match a with
  | Bool true -> Bool false
  | Bool false -> Bool true
  | _ -> raise (TypeError "wrong type")

(* Concatenate two strings *)
let join x =
  match x with
  | String a, String b -> String (a ^ b)
  | _ -> raise (TypeError "wrong type")

(* Divide one integer by another *)
let h_divi z =
  match z with
  | Int q, Int 0 -> raise DivByZeroError
  | Int r, Int f -> Int (r / f)
  | _ -> raise (TypeError "wrong type")

(* Check if two values are equal *)
let h_equal x =
  match x with
  | String a, String b -> if a = b then Bool true else Bool false
  | Int a, Int b -> if a = b then Bool true else Bool false
  | Bool a, Bool b -> if a = b then Bool true else Bool false
  | _ -> raise (TypeError "nope")

(* Check if one integer is greater than another *)
let more x =
  match x with
  | Int a, Int b -> if a > b then Bool true else Bool false
  | _ -> raise (TypeError "wrong type")

(* Evaluates MicroCaml expression [e] in environment [env],
   returning a value, or throwing an exception on error *)
let rec eval_expr neta beta =
  match beta with
  | Binop (Less, a, b) -> lower (eval_expr neta a, eval_expr neta b) (* Evaluate less than expression *)
  | Binop (GreaterEqual, a, b) -> eq_greta (eval_expr neta a, eval_expr neta b) (* Evaluate greater than or equal expression *)
  | App (x, y) -> ( (* Evaluate function application *)
      let a = eval_expr neta x in
      match a with
      | Closure (i, j, k) -> (* If it's a closure, apply the function *)
          let b = eval_expr neta y in
          let env2 = extend i j b in
          eval_expr env2 k
      | _ -> raise (TypeError "rong typo"))
      | Binop (LessEqual, a, b) -> eq_lower (eval_expr neta a, eval_expr neta b)
      (* Evaluate the less than or equal to binary operation *)
    
    | Binop (Concat, a, b) -> join (eval_expr neta a, eval_expr neta b)
      (* Evaluate the string concatenation binary operation *)
    
    | Let (a, false, peta, ieta) ->
        let b = eval_expr neta peta in
        eval_expr (extend neta a b) ieta
      (* Evaluate a non-recursive let expression *)
    
    | Fun (qeta, peta) -> Closure (neta, qeta, peta)
      (* Evaluate a function definition, resulting in a closure *)
    
    | Binop (Equal, a, b) ->
        let x = eval_expr neta a in
        let y = eval_expr neta b in
        h_equal (x, y)
      (* Evaluate the equality binary operation *)
    
    | Binop (NotEqual, x, y) ->
        let a = eval_expr neta x in
        let b = eval_expr neta y in
        equal_not (a, b)
      (* Evaluate the not equal binary operation *)
    
    | Binop (Or, a, b) -> (
        let x = eval_expr neta a in
        let y = eval_expr neta b in
        match x with
        | Bool i -> (
            match y with
            | Bool j -> if i || j then Bool true else Bool false
            | _ -> raise (TypeError "error"))
        | _ -> raise (TypeError "error"))
      (* Evaluate the logical OR binary operation *)
    
    | Binop (And, a, b) -> (
        let y = eval_expr neta b in
        let x = eval_expr neta a in
        match x with
        | Bool i -> (
            match y with
            | Bool j -> if i && j then Bool true else Bool false
            | _ -> raise (TypeError "error"))
        | _ -> raise (TypeError "error"))
      (* Evaluate the logical AND binary operation *)
    
    | If (a, b, c) -> (
        let f = eval_expr neta a in
        match f with
        | Bool false -> eval_expr neta c
        | Bool true -> eval_expr neta b
        | _ -> raise (TypeError "error"))
      (* Evaluate an if-then-else expression *)
    
    | Let (x, true, init, body) ->
        let veta2 = extend_tmp neta x in
        let v = eval_expr veta2 init in
        update veta2 x v;
        eval_expr veta2 body
      (* Evaluate a recursive let expression *)
    
    | String a -> String a
      (* Evaluate a string literal *)
    
    | ID a -> lookup neta a
      (* Evaluate an identifier *)
    
    | Int a -> Int a
      (* Evaluate an integer literal *)
    
    | Bool a -> Bool a
      (* Evaluate a boolean literal *)
    
    | Not a ->
        let veta = eval_expr neta a in
        cancel veta
      (* Evaluate a logical NOT expression *)
    
    | Record feta ->
        let ef =
          List.map (fun (leta, expr) -> (leta, eval_expr neta expr)) feta
        in
        Record ef
      (* Evaluate a record expression *)
    
    | Binop (Mult, a, b) -> n_times (eval_expr neta a, eval_expr neta b)
      (* Evaluate the multiplication binary operation *)
    
    | Binop (Div, x, y) -> h_divi (eval_expr neta x, eval_expr neta y)
      (* Evaluate the division binary operation *)
    
    | Binop (Greater, x, y) -> more (eval_expr neta x, eval_expr neta y)
      (* Evaluate the greater than binary operation *)
    
    | Binop (Add, a, b) -> add_helper (eval_expr neta a, eval_expr neta b)
      (* Evaluate the addition binary operation *)
    
    | Binop (Sub, a, b) -> h_minus (eval_expr neta a, eval_expr neta b)
      (* Evaluate the subtraction binary operation *)
    
    | Select (leta, expr) -> (
        let record_expr = eval_expr neta expr in
        match record_expr with
        | Record feta -> (
            try
              let _, value =
                List.find (fun (field_label, _) -> field_label = leta) feta
              in
              value
            with Not_found -> raise (SelectError "404 not found"))
        | _ -> raise (TypeError "wrong type"))
      (* Evaluate a field selection from a record *)
    
    | Closure (_, _, _) -> raise (TypeError "check back later...")
      (* Placeholder for direct evaluation of a closure, which is not supported *)
    
    | Record _ -> raise (TypeError "functionality not addded yet")
      (* Placeholder for direct evaluation of a record, which is not supported *)
    
    | Select (_, _) ->
        raise (TypeError "exp select not available")
      (* Placeholder for direct evaluation of a select expression, which is not supported *)
    
    (* Part 2: Evaluating mutop directive *)
    
    let eval_mutop weta delta =
      match delta with
      | Expr jeta ->
          let heta = eval_expr weta jeta in
          (weta, Some heta)
      (* Evaluate an expression mutop *)
    
    | Def (a, b) ->
        let reta = extend_tmp weta a in
        let ceta = eval_expr reta b in
        ([ (a, { contents = ceta }) ], Some ceta)
      (* Evaluate a definition mutop *)
    
    | NoOp -> (weta, None)
      (* Evaluate a NoOp mutop *)
    