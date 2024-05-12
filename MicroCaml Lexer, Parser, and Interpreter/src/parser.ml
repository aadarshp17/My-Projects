open Types
open Utils

(* Provided functions - DO NOT MODIFY *)

(* Matches the next token in the list, throwing an error if it doesn't match the expected token *)
let match_token (toks : token list) (tok : token) =
  match toks with
  | [] -> raise (InvalidInputException (string_of_token tok))
  | h :: t when h = tok -> t
  | h :: _ ->
      raise
        (InvalidInputException
           (Printf.sprintf "Expected %s from input %s, got %s"
              (string_of_token tok)
              (string_of_list string_of_token toks)
              (string_of_token h)))

(* Matches a sequence of tokens given as the second list in the order in which they appear, throwing an error if they don't match *)
let match_many (toks : token list) (to_match : token list) =
  List.fold_left match_token toks to_match

(* Return the next token in the token list as an option *)
let lookahead (toks : token list) =
  match toks with [] -> None | h :: t -> Some h

(* Return the token at the nth index in the token list as an option*)
let rec lookahead_many (toks : token list) (n : int) =
  match (toks, n) with
  | h :: _, 0 -> Some h
  | _ :: t, n when n > 0 -> lookahead_many t (n - 1)
  | _ -> None

(* Part 2: Parsing expressions *)
(* Main function to parse expressions, dispatching to specific functions based on the lookahead token *)
let rec ohp toks = 
  let opt = lookahead toks in
  if opt = Some Tok_Let then letta_expr toks
  else if opt = Some Tok_If then ieta_expr toks
  else if opt = Some Tok_Fun then feta_expr toks
  else oeta_expr toks

(* Parses a let expression *)
and letta_expr toks =
  let teter = match_token toks Tok_Let in
  let (berca, eta) = rep teter in
  let (yeti, keta) = blam eta in
  let alpha = match_token keta Tok_Equal in
  let (skkod, glee) = ohp alpha in
  let ace1 = match_token glee Tok_In in
  let (x5, rl) = ohp ace1 in
  match yeti with
  | ID a -> (Let (a, berca, skkod, x5), rl)
  | _ -> raise (InvalidInputException("form, horrible!"))

(* Parses a recursive flag for let expressions *)
and rep toks = let j = lookahead toks in match j with
  | Some Tok_Rec -> (true, match_token toks Tok_Rec)
  | _ -> (false, toks)

(* Parses an if expression *)
and ieta_expr toks =
  let pt = match_token toks Tok_If in
  let (p3, khed) = ohp pt in
  let gq = match_token khed Tok_Then in
  let (p4, yup) = ohp gq in
  let jp = match_token yup Tok_Else in
  let (o5, kizy) = ohp jp in
  (If (p3,p4,o5), kizy)

(* Parses a function expression *)
and feta_expr toks =
  let kop = match_token toks Tok_Fun in
  let (ed, gq) = blam kop in
  let lst3 = match_token gq Tok_Arrow in
  let (exp, kizy) = ohp lst3 in
  match ed with
  | ID x -> (Fun (x, exp), kizy)
  | _ -> raise (InvalidInputException("invalido!"))

(* Parses an or expression *)
and oeta_expr toks =
  let (bef, kop) = rote toks in
  let (bret, exp2, gq) = met kop in
  if bret = false then (bef, gq)
  else (Binop (Or, bef, exp2), gq)

(* Helper function for parsing or expressions *)
and met toks =
  if lookahead toks = Some Tok_Or then
    let kop = match_token toks Tok_Or in
    let (exp, kizy) = oeta_expr kop in
    (true, exp, kizy)
  else (false, Bool true, toks)

(* Parses an and expression *)
and rote toks =
  let (bef, kop) = parse_qual_expr toks in
  let (bret, exp2, gq) = parse_and_helper kop in
  if bret = false then (bef, gq)
  else (Binop (And, bef, exp2), gq)

(* Helper function for parsing and expressions *)
and parse_and_helper toks =
  if lookahead toks = Some Tok_And then
    let kop = match_token toks Tok_And in
    let (exp, kizy) = rote kop in
    (true, exp, kizy)
  else (false, Bool true, toks)

(* Parses a quality (equality or inequality) expression *)
and parse_qual_expr toks =
  let (bef, kop) = ler_expr toks in
  let (b58, exp2, gq) = c63 kop in
  if b58 = 0 then (bef, gq)
  else if b58 = 1 then (Binop (Equal, bef, exp2), gq)
  else (Binop (NotEqual, bef, exp2), gq)

(* Helper function for parsing quality expressions *)
and c63 toks = 
  if lookahead toks = Some Tok_Equal then
    let kop = match_token toks Tok_Equal in
    let (exp, kizy) = parse_qual_expr kop in
    (1, exp, kizy)
  else if lookahead toks = Some Tok_NotEqual then
    let kop = match_token toks Tok_NotEqual in
    let (exp, kizy) = parse_qual_expr kop in
    (2, exp, kizy)
  else (0, Bool true, toks)

(* Parses a relational expression (less than, greater than, etc.) *)
and ler_expr toks =
  let (bef, kop) = seid toks in
  let (b58, exp2, gq) = tri kop in
  if b58 = 0 then (bef, gq)
  else if b58 = 1 then (Binop (Less, bef, exp2), gq)
  else if b58 = 2 then (Binop (Greater, bef, exp2), gq)
  else if b58 = 3 then (Binop (LessEqual, bef, exp2), gq)
  else (Binop (GreaterEqual, bef, exp2), gq)

(* Helper function for parsing relational expressions *)
and tri toks = 
  if lookahead toks = Some Tok_Less then
    let kop = match_token toks Tok_Less in
    let (exp, kizy) = ler_expr kop in
    (1, exp, kizy)
  else if lookahead toks = Some Tok_Greater then
    let kop = match_token toks Tok_Greater in
    let (exp, kizy) = ler_expr kop in
    (2, exp, kizy)
  else if lookahead toks = Some Tok_LessEqual then
    let kop = match_token toks Tok_LessEqual in
    let (exp, kizy) = ler_expr kop in
    (3, exp, kizy)
  else if lookahead toks = Some Tok_GreaterEqual then
    let kop = match_token toks Tok_GreaterEqual in
    let (exp, kizy) = ler_expr kop in
    (4, exp, kizy)
  else (0, Bool true, toks)

(* Parses an addition or subtraction expression *)
and seid toks =
  let (bef, kop) = jhn_expr toks in
  let (b58, hlp, gq) = jhu kop in
  if b58 = 0 then (bef, gq)
  else if b58 = 1 then (Binop (Add, bef, hlp), gq)
  else (Binop (Sub, bef, hlp), gq)

(* Helper function for parsing addition or subtraction expressions *)
and jhu toks = 
  if lookahead toks = Some Tok_Add then
    let kop = match_token toks Tok_Add in
    let (exp, kizy) = seid kop in
    (1, exp, kizy)
  else if lookahead toks = Some Tok_Sub then
    let kop = match_token toks Tok_Sub in
    let (exp, kizy) = seid kop in
    (2, exp, kizy)
  else (0, Bool true, toks)

(* Parses a multiplication or division expression *)
and jhn_expr toks =
  let (bef, kop) = mula toks in
  let (b58, cmu, gq) = parse_mul_helper kop in
  if b58=0 then (bef, gq)
  else if b58=1 then (Binop (Mult, bef, cmu), gq)
  else (Binop (Div, bef, cmu), gq)
and parse_mul_helper toks = 
  if lookahead toks=Some Tok_Mult then
    let kop = match_token toks Tok_Mult in
    let (iops, kizy
) = jhn_expr kop in
    (1, iops, kizy
)
  else if lookahead toks=Some Tok_Div then
    let kop = match_token toks Tok_Div in
    let (ps, kizy
) = jhn_expr kop in
    (2, ps, kizy
)
  else (0, Bool true, toks)

(* Parses a multiplicaiton expression*)
and mula toks =
  let (bef, kop) = brotha_exprr toks in
  let (bret, exp2, gq) = vix kop in
  if bret=false then (bef, gq)
  else (Binop (Concat, bef, exp2), gq)
and vix toks =
  if lookahead toks=Some Tok_Concat then
    let kop = match_token toks Tok_Concat in
    let (exp, kizy
) = mula kop in
    (true, exp, kizy
)
  else (false, Bool true, toks)

  (* Parses an expression with a potential unary operator (Not) *)
and brotha_exprr toks = 
  match toks with
  | Tok_Not::t -> let gq = (match_token toks Tok_Not) in
    let (j8, u4) = (brotha_exprr gq) in (Not (j8), u4)
  | _ -> (utop toks)

  (* Parses a function application or a primary expression *)
and utop toks =
  let (bool1, b58, kop) = funner toks in
  if bool1=false then raise (InvalidInputException(Printf.sprintf "bad call to fun_call.. tok_list: %s" (string_of_list string_of_token kop)))
  else let (bret, exp, gq) = funner kop in
  if bret=false then (b58, gq)
  else (App (b58, exp), gq)
and funner toks =
  match toks with
  | [] -> (false, Bool true, toks)
  | h::t -> match h with
            | Tok_String(x) -> let (exp, kop) = blam toks in (true, exp, kop)
            | Tok_ID(x) -> let (exp, kop) = blam toks in (true, exp, kop)
            | Tok_Bool(false) -> let (exp, kop) = blam toks in (true, exp, kop)
            | Tok_Int(x) -> let (exp, kop) = blam toks in (true, exp, kop)
            | Tok_Bool(true) -> let (exp, kop) = blam toks in (true, exp, kop)
            | Tok_LParen -> let (exp, kop) = blam toks in (true, exp, kop)
            | _ -> (false, Bool true, toks)

(* Parses a primary expression *)
and blam toks =
  match toks with
  | [] -> raise (InvalidInputException("no more tokens"))
  | h::t -> match h with
            | Tok_Int(x) -> let gq = match_token toks (Tok_Int(x)) in (Int x, gq)
            | Tok_Bool(true) -> let gq = match_token toks (Tok_Bool(true)) in (Bool true, gq)
            | Tok_Bool(false) -> let gq = match_token toks (Tok_Bool(false)) in (Bool false, gq)
            | Tok_String(x) -> let gq = match_token toks (Tok_String(x)) in (String x, gq)
            | Tok_ID(x) -> let gq = match_token toks (Tok_ID(x)) in (ID x, gq)
            | Tok_LParen -> let gq = match_token toks Tok_LParen in 
                            let (e2, lst3) = (ohp gq) in
                            let a = lookahead lst3 in
                            if a=Some Tok_RParen then (e2, match_token lst3 Tok_RParen)
                            else raise (InvalidInputException("Right Paren not found"))
            | _ -> raise (InvalidInputException("invalid prim expr call"))
            
;;

let rec parse_expr toks = let (b,a) = ohp toks in (a,b);;

(* Part 3: Parsing mutop *)

(* Main function for parsing mutop directives *)
let rec parse_mutop toks = match toks with
  | Tok_DoubleSemi::t -> if lookahead t=None then ([], NoOp) else raise (InvalidInputException("invalid input"))
  | Tok_Def::t -> let (falsp, ux) = (hson toks) in
                  if lookahead ux!=None then raise (InvalidInputException("input is invalid"))
                  else
                    (ux, falsp)
  | _ -> let (falsep, stp) = etop toks in
         if lookahead stp!=None then raise (InvalidInputException("invalid"))
         else
           (stp, falsep)

  (* Parses a definition mutop *)
and hson toks =
  let kop = match_token toks Tok_Def in
  match kop with
  | Tok_ID(x)::t -> let string_of_ID = x in
                    let gq = match_token t Tok_Equal in
                    let (lst3, expr) = parse_expr gq in
                    let lst4 = match_token lst3 Tok_DoubleSemi in
                    (Def(string_of_ID,expr), lst4)
  | _ -> raise (InvalidInputException("input is invalid"))

  (* Parses an expression mutop *)
and etop toks =
  let (kop, expr) = parse_expr toks in
  let gq = match_token kop Tok_DoubleSemi in (Expr (expr), gq)
;;
