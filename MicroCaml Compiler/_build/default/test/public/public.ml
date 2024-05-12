open OUnit2
open TestUtils
open P5.Ast
open P5.Utils
open P5.Optimize


let test_sanity_add = ("1 + 2", Int 3, TInt)
(* NOTE: The following tests are only checked for 
   optimization, since they cannot be typechecked. *)
let test_identity_add = ("0 + x", ID "x", TBottom)
let test_identity_mult = ("1 * x", ID "x", TBottom)
let test_identity_div = ("x / 1", ID "x", TBottom)
let test_zero_mult = ("(4 - 3 - 1) * x", Int 0, TBottom)
let test_zero_div = ("(4 - 3 - 1) / x", Int 0, TBottom)
let test_err_div_by_zero _ =
  div_by_zero_ex_handler (fun () -> optimize [] (parse_expr "x / 0"))
(* END NOTE *)

let test_simple_and = ("true && (true || false)", Bool true, TBool)
let test_simple_equal = ("1 = 0", Bool false, TBool)
let test_simple_if = ("if true then 1 else 2", Int 1, TInt)
let test_simple_fun = ("(fun x:Int->x) 1", Int 1, TInt)
let test_simple_let = ("let x = 42 in x", Int 42, TInt)

let test_nested_fun =
  ( "(fun x:Int->(fun y:Int->x+y)) 1",
    parse_expr "fun y:Int->1+y",
    TArrow (TInt, TInt) )

let test_let_fun =
  ( "let x = 5 in (fun x:Int -> x)",
    parse_expr "fun x:Int -> x",
    TArrow (TInt, TInt) )

let test_fun_fun =
  ( "fun y:(Int->Int)->y 1",
    parse_expr "fun y:(Int->Int)->y 1",
    TArrow (TArrow (TInt, TInt), TInt) )

let test_shadow =
  ("let x = 20 in let f = fun x:Int -> x + 22 in f x", Int 42, TInt)

let test_factorial =
  ( "let rec fact:(Int->Int) = fun x:Int -> if x = 1 then (0 + 1) else x * fact (x - 1) in fact (4 - 1)", parse_expr
    "let rec fact:(Int->Int) = fun x:Int -> if x = 1 then 1 else x * fact (x - 1) in fact 3", 
    TInt )

let test_record1 =
  ( "{length=18}",
    Record [ (Lab "length", Int 18) ],
    TRec [ (Lab "length", TInt) ] )

let test_record2 =
  ( "{length=7; height=255}",
    Record [ (Lab "length", Int 7); (Lab "height", Int 255) ],
    TRec [ (Lab "length", TInt); (Lab "height", TInt) ] )

let test_record3 =
  ( "{length=7; height=255; square=false}",
    Record
      [
        (Lab "length", Int 7); (Lab "height", Int 255); (Lab "square", Bool false);
      ],
    TRec [ (Lab "length", TInt); (Lab "height", TInt); (Lab "square", TBool) ] )

let test_record_select = ("{length=7; height=255}.length", Int 7, TInt)

let test_record_select_let = ("let x = {a=10; b=20} in x.a + x.b", Int 30, TInt)

let suite = "public" >::: [
  (* optimizer tests *)
  "public_optimize_sanity_add"          >::  run_test  ~mode:Optimize   test_sanity_add;
  "public_optimize_identity_add"        >::  run_test  ~mode:Optimize   test_identity_add;
  "public_optimize_identity_mult"       >::  run_test  ~mode:Optimize   test_identity_mult;
  "public_optimize_identity_div"        >::  run_test  ~mode:Optimize   test_identity_div;
  "public_optimize_zero_mult"           >::  run_test  ~mode:Optimize   test_zero_mult;
  "public_optimize_zero_div"            >::  run_test  ~mode:Optimize   test_zero_div;
  "public_optimize_simple_and"          >::  run_test  ~mode:Optimize   test_simple_and;
  "public_optimize_simple_equal"        >::  run_test  ~mode:Optimize   test_simple_equal;
  "public_optimize_simple_if"           >::  run_test  ~mode:Optimize   test_simple_if;
  "public_optimize_simple_fun"          >::  run_test  ~mode:Optimize   test_simple_fun;
  "public_optimize_simple_let"          >::  run_test  ~mode:Optimize   test_simple_let;
  "public_optimize_nested_fun"          >::  run_test  ~mode:Optimize   test_nested_fun;
  "public_optimize_let_fun"             >::  run_test  ~mode:Optimize   test_let_fun;
  "public_optimize_fun_fun"             >::  run_test  ~mode:Optimize   test_fun_fun;
  "public_optimize_shadow"              >::  run_test  ~mode:Optimize   test_shadow;
  "public_optimize_factorial"           >::  run_test  ~mode:Optimize   test_factorial;
  "public_optimize_record1"             >::  run_test  ~mode:Optimize   test_record1;
  "public_optimize_record2"             >::  run_test  ~mode:Optimize   test_record2;
  "public_optimize_record3"             >::  run_test  ~mode:Optimize   test_record3;
  "public_optimize_record_select"       >::  run_test  ~mode:Optimize   test_record_select;
  "public_optimize_record_select_let"   >::  run_test  ~mode:Optimize   test_record_select_let;

  (* typechecker tests *)
  "public_typecheck_sanity_add"         >::  run_test  ~mode:Typecheck  test_sanity_add;
  "public_typecheck_simple_and"         >::  run_test  ~mode:Typecheck  test_simple_and;
  "public_typecheck_simple_equal"       >::  run_test  ~mode:Typecheck  test_simple_equal;
  "public_typecheck_simple_if"          >::  run_test  ~mode:Typecheck  test_simple_if;
  "public_typecheck_simple_fun"         >::  run_test  ~mode:Typecheck  test_simple_fun;
  "public_typecheck_simple_let"         >::  run_test  ~mode:Typecheck  test_simple_let;
  "public_typecheck_nested_fun"         >::  run_test  ~mode:Typecheck  test_nested_fun;
  "public_typecheck_let_fun"            >::  run_test  ~mode:Typecheck  test_let_fun;
  "public_typecheck_fun_fun"            >::  run_test  ~mode:Typecheck  test_fun_fun;
  "public_typecheck_shadow"             >::  run_test  ~mode:Typecheck  test_shadow;
  "public_typecheck_factorial"          >::  run_test  ~mode:Typecheck  test_factorial;
  "public_typecheck_record1"            >::  run_test  ~mode:Typecheck  test_record1;
  "public_typecheck_record2"            >::  run_test  ~mode:Typecheck  test_record2;
  "public_typecheck_record3"            >::  run_test  ~mode:Typecheck  test_record3;
  "public_typecheck_record_select"      >::  run_test  ~mode:Typecheck  test_record_select;
  "public_typecheck_record_select_let"  >::  run_test  ~mode:Typecheck  test_record_select_let;

  (* misc tests *)
  "public_err_div_by_zero" >:: test_err_div_by_zero;
]

let _ = run_test_tt_main suite
