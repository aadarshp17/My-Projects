open OUnit2
open TestUtils
open P4.Lexer
open P4.Parser
open P4.Types

(* sanity check *)
let test_nothing = (
  ";;",
  ([], NoOp),
  ([], None)
)

(* simple expression tests *)
let test_expr_add1 = (
  "let add1 = fun x -> x + 1 in add1 1",
  ([], Let ("add1", false, Fun ("x", Binop (Add, ID "x", (Int 1))), 
    App (ID "add1", (Int 1)))),
  Int 2
)

let test_expr_apply = (
  "let apply = fun x -> fun y -> x y in let add1 = fun z -> z + 1 in (apply add1) 5",
  ([], Let ("apply", false, Fun ("x", Fun ("y", App (ID "x", ID "y"))), 
    Let ("add1", false, Fun ("z", Binop (Add, ID "z", (Int 1))), 
      App (App (ID "apply", ID "add1"), (Int 5))))),
   Int 6
)

let test_expr_double_fun = (
  "((fun x -> fun y -> x + y) 5) 2" ,
  ([], App (App (Fun ("x", Fun ("y", Binop (Add, ID "x", ID "y"))), (Int 5)), (Int 2))),
  Int 7
)

let test_expr_let_if =  (
  "let sanity = if 1 = 1 then true else false in sanity",
  ([], Let ("sanity", false, 
    If (Binop (Equal, (Int 1), (Int 1)), (Bool true), 
      (Bool false)), 
    ID "sanity")),
  Bool true
)

let test_expr_let_fun = (
  "let abc = fun a -> a + 1 in abc 1",
  ([], Let ("abc", false, Fun ("a", Binop (Add, ID "a", (Int 1))), 
    App (ID "abc", (Int 1)))),
  Int 2
)

let test_expr_minus_one = (
  "let x = 1-1 in x",
  ([], Let ("x", false, Binop (Sub, (Int 1), (Int 1)), ID "x")),
  Int 0
)

let test_expr_nested_let =  (
  "let a = 1 in let b = 2 in let c = 3 in let d = 4 in let e = 5 in let f = 6 in let g = 7 in let h = 8 in let i = 9 in let j = 10 in a+b+c+d+e+f+g+h",
  ([], Let ("a", false, (Int 1),
   Let ("b", false, (Int 2), Let ("c", false, (Int 3),
     Let ("d", false, (Int 4),
      Let ("e", false, (Int 5),
       Let ("f", false, (Int 6),
        Let ("g", false, (Int 7),
         Let ("h", false, (Int 8),
          Let ("i", false, (Int 9),
           Let ("j", false, (Int 10),
            Binop (Add, ID "a",
             Binop (Add, ID "b",
              Binop (Add, ID "c",
               Binop (Add, ID "d",
                Binop (Add, ID "e",
                 Binop (Add, ID "f", Binop (Add, ID "g", ID "h")))))))))))))))))),
  Int 36
)
  
let test_expr_simple_equal = (
  "1 = 1",
  ([], Binop (Equal, (Int 1), (Int 1))),
  Bool true
)

let test_expr_simple_concat =  (
  "\"Hello\" ^ \" World!\"",
  ([], Binop (Concat, (String "Hello"), (String " World!"))),
  String "Hello World!"
)

let test_expr_simple_div =  (
  "15 / 3",
  ([], Binop (Div, (Int 15), (Int 3))) ,
  Int 5
 )
 
let test_expr_simple_mult = (
  "5 * 3",
  ([], Binop (Mult, (Int 5), (Int 3))),
  Int 15
)

let test_expr_simple_sub = (
  "3 - 2",
  ([], Binop (Sub, (Int 3), (Int 2))),
  Int 1
)

let test_expr_simple_sum = (
  "1 + 2",
  ([], Binop (Add, (Int 1), (Int 2))),
  Int 3
)
  
let test_expr_single_and = (
  "true && true",
  ([], Binop (And, (Bool true), (Bool true))),
  Bool true
 )
 
let test_expr_single_bool = (
  "false",
  ([], (Bool false)),
  Bool false
 )
 
let test_expr_single_fun = (
  "(fun x -> x + 1) 1",
  ([], App (Fun ("x", Binop (Add, ID "x", (Int 1))), (Int 1))),
  Int 2
)

let test_expr_single_if = (
  "if 1 = 2 then false else true",
  ([], If (Binop (Equal, (Int 1), (Int 2)), (Bool false), (Bool true))),
  Bool true
)

let test_expr_single_let = (
  "let x = 42 in x",
  ([], Let ("x", false, (Int 42), ID "x")),
  Int 42
)

let test_expr_single_notequal = (
  "1 <> 2",
  ([], Binop (NotEqual, (Int 1), (Int 2))),
  Bool true
)

let test_expr_single_not = (
  "not true",
  ([], Not ((Bool true))),
  Bool false
)

let test_expr_single_number = (
  "42",
  ([], (Int 42)),
  Int 42
 )
 
let test_expr_single_or = (
  "true || false",
  ([], Binop (Or, (Bool true), (Bool false))),
  Bool true
 )
 
let test_expr_single_string = (
  "\"Hello World!\"",
  ([], (String "Hello World!")),
  String "Hello World!"
)

let test_expr_shadow =  (
  "let x = 20 in let f = fun x -> x + 22 in f x",
  ([], Let ("x", false, (Int 20), Let ("f", false, Fun ("x", Binop (Add, ID "x", (Int 22))), App (ID "f", ID "x")))),
  Int 42
)

(* record expression tests *)
let test_expr_record_empty = (
  "{}",
  ([], Record []),
  Record []
)

let test_expr_record1 = (
  "{length=18}",
  ([], Record [ (Lab "length", Int 18) ]),
  Record [ (Lab "length", Int 18) ]
)

let test_expr_record2 = (
  "{length=7; height=255}",
  ([], Record [ (Lab "length", Int 7); (Lab "height", Int 255) ]),
  Record [ (Lab "length", Int 7); (Lab "height", Int 255) ]
)

let test_expr_record3 = (
  "{length=7; height=255; color=\"Red\"}",
  ([], Record [ (Lab "length", Int 7); (Lab "height", Int 255); (Lab "color", String "Red"); ] ),
  Record [ (Lab "length", Int 7); (Lab "height", Int 255); (Lab "color", String "Red"); ]
)
let test_expr_record_select = (
  "{length=7; height=255}.length",
  ([], Select (Lab "length", Record [ (Lab "length", Int 7); (Lab "height", Int 255) ])),
  Int 7 
)

let test_expr_record_select_let = (
  "let x = {length=7; height=255; color=\"Red\"} in x.color",
  ([], Let ( "x", false, Record [
    (Lab "length", Int 7);
    (Lab "height", Int 255);
    (Lab "color", String "Red"); ],
  Select (Lab "color", ID "x"))),
  String "Red" 
)

let public_expr_select_expr _ =
  let result = ([], Select (Lab "type", ID "e")) in
  let record = "e.type" |> tokenize |> parse_expr in
  assert_equal record result ~msg:"public_record"

(* mutop tests *)
let test_mutop_pi_def =  (
  "def pi = 31416;;",
  ([], Def ("pi", (Int 31416))),
  ([("pi", {contents = Int 31416})], Some (Int 31416))
)

let test_mutop_simple_def_and_let = (
  "def x = let y = (123 + 456) in y + 1;;",
  ([], Def ("x", Let ("y", false, Binop (Add, (Int 123), (Int 456)), 
    Binop (Add, ID "y", (Int 1))))),
  ([("x", {contents = Int 580})], Some (Int 580))
)

let test_mutop_factorial = (
  "let rec fact = fun x -> if x = 1 then 1 else x * fact (x - 1) in fact 3;;",
  ([], Expr (Let ("fact", true, Fun ("x", 
    If (Binop (Equal, ID "x", (Int 1)), (Int 1), 
      Binop (Mult, ID "x", 
        App (ID "fact", Binop (Sub, ID "x", (Int 1)))))), 
      App (ID "fact", (Int 3))))),
  ([], Some (Int 6))
)

(* error / misc tests *)
let public_mutop_nonempty_env _ = 
  let ast = ([], Expr
  (Let ("a", false, (Int 1),
    Let ("b", false, (Int 2),
     Binop (Add, ID "a", Binop (Add, ID "b", Binop (Add, ID "c", ID "d"))))))) in
  let result = ([("c", {contents = Int 3}); ("d", {contents = Int 4})], Some (Int 10)) in
  let student = eval_mutop_ast [("c", {contents = Int 3}); ("d", {contents = Int 4})] ast in
  assert_equal student result ~msg:"public_mutop_nonempty_env"

let public_err_div_by_zero _ =
  let ast = ([], Let ("x", false, Binop (Div, (Int 1), (Int 0)), ID "x")) in
  div_by_zero_ex_handler (fun () -> eval_expr_ast [] ast)

let public_err_def_not_top_level _ = 
  input_handler (fun () -> "let x = 5 in let y = 3 in def z = 33;;" |> tokenize |> parse_mutop) 

let public_err_mutop_nested_def _ = 
  input_handler (fun () -> "def x = def y = 5;;" |> tokenize |> parse_mutop)


let suite =
  "public" >::: [
    (* lexer + parser *)
    "public_parser_nothing"                   >::  run_test_eval  ~mode:Parser  test_nothing;
    "public_parser_expr_add1"                 >::  run_test_expr  ~mode:Parser  test_expr_add1;
    "public_parser_expr_apply"                >::  run_test_expr  ~mode:Parser  test_expr_apply;
    "public_parser_expr_double_fun"           >::  run_test_expr  ~mode:Parser  test_expr_double_fun;
    "public_parser_expr_let_if"               >::  run_test_expr  ~mode:Parser  test_expr_let_if;
    "public_parser_expr_let_fun"              >::  run_test_expr  ~mode:Parser  test_expr_let_fun;
    "public_parser_expr_minus_one"            >::  run_test_expr  ~mode:Parser  test_expr_minus_one;
    "public_parser_expr_nested_let"           >::  run_test_expr  ~mode:Parser  test_expr_nested_let;
    "public_parser_expr_simple_equal"         >::  run_test_expr  ~mode:Parser  test_expr_simple_equal;
    "public_parser_expr_simple_concat"        >::  run_test_expr  ~mode:Parser  test_expr_simple_concat;
    "public_parser_expr_simple_div"           >::  run_test_expr  ~mode:Parser  test_expr_simple_div;
    "public_parser_expr_simple_mult"          >::  run_test_expr  ~mode:Parser  test_expr_simple_mult;
    "public_parser_expr_simple_sub"           >::  run_test_expr  ~mode:Parser  test_expr_simple_sub;
    "public_parser_expr_simple_sum"           >::  run_test_expr  ~mode:Parser  test_expr_simple_sum;
    "public_parser_expr_single_and"           >::  run_test_expr  ~mode:Parser  test_expr_single_and;
    "public_parser_expr_single_bool"          >::  run_test_expr  ~mode:Parser  test_expr_single_bool;
    "public_parser_expr_single_fun"           >::  run_test_expr  ~mode:Parser  test_expr_single_fun;
    "public_parser_expr_single_if"            >::  run_test_expr  ~mode:Parser  test_expr_single_if;
    "public_parser_expr_single_let"           >::  run_test_expr  ~mode:Parser  test_expr_single_let;
    "public_parser_expr_single_notequal"      >::  run_test_expr  ~mode:Parser  test_expr_single_notequal;
    "public_parser_expr_single_not"           >::  run_test_expr  ~mode:Parser  test_expr_single_not;
    "public_parser_expr_single_number"        >::  run_test_expr  ~mode:Parser  test_expr_single_number;
    "public_parser_expr_single_or"            >::  run_test_expr  ~mode:Parser  test_expr_single_or;
    "public_parser_expr_single_string"        >::  run_test_expr  ~mode:Parser  test_expr_single_string;
    "public_parser_expr_shadow"               >::  run_test_expr  ~mode:Parser  test_expr_shadow;
    "public_parser_expr_record_empty"         >::  run_test_expr  ~mode:Parser  test_expr_record_empty;
    "public_parser_expr_record1"              >::  run_test_expr  ~mode:Parser  test_expr_record1;
    "public_parser_expr_record2"              >::  run_test_expr  ~mode:Parser  test_expr_record2;
    "public_parser_expr_record3"              >::  run_test_expr  ~mode:Parser  test_expr_record3;
    "public_parser_expr_record_select"        >::  run_test_expr  ~mode:Parser  test_expr_record_select;
    "public_parser_expr_record_select_let"    >::  run_test_expr  ~mode:Parser  test_expr_record_select_let;
    "public_parser_mutop_pi_def"              >::  run_test_eval  ~mode:Parser  test_mutop_pi_def;
    "public_parser_mutop_simple_def_and_let"  >::  run_test_eval  ~mode:Parser  test_mutop_simple_def_and_let;
    "public_parser_mutop_factorial"           >::  run_test_eval  ~mode:Parser  test_mutop_factorial;

    (* lexer + parser + eval *)
    "public_eval_nothing"                   >::  run_test_eval  ~mode:Eval  test_nothing;
    "public_eval_expr_add1"                 >::  run_test_expr  ~mode:Eval  test_expr_add1;
    "public_eval_expr_apply"                >::  run_test_expr  ~mode:Eval  test_expr_apply;
    "public_eval_expr_double_fun"           >::  run_test_expr  ~mode:Eval  test_expr_double_fun;
    "public_eval_expr_let_if"               >::  run_test_expr  ~mode:Eval  test_expr_let_if;
    "public_eval_expr_let_fun"              >::  run_test_expr  ~mode:Eval  test_expr_let_fun;
    "public_eval_expr_minus_one"            >::  run_test_expr  ~mode:Eval  test_expr_minus_one;
    "public_eval_expr_nested_let"           >::  run_test_expr  ~mode:Eval  test_expr_nested_let;
    "public_eval_expr_simple_equal"         >::  run_test_expr  ~mode:Eval  test_expr_simple_equal;
    "public_eval_expr_simple_concat"        >::  run_test_expr  ~mode:Eval  test_expr_simple_concat;
    "public_eval_expr_simple_div"           >::  run_test_expr  ~mode:Eval  test_expr_simple_div;
    "public_eval_expr_simple_mult"          >::  run_test_expr  ~mode:Eval  test_expr_simple_mult;
    "public_eval_expr_simple_sub"           >::  run_test_expr  ~mode:Eval  test_expr_simple_sub;
    "public_eval_expr_simple_sum"           >::  run_test_expr  ~mode:Eval  test_expr_simple_sum;
    "public_eval_expr_single_and"           >::  run_test_expr  ~mode:Eval  test_expr_single_and;
    "public_eval_expr_single_bool"          >::  run_test_expr  ~mode:Eval  test_expr_single_bool;
    "public_eval_expr_single_fun"           >::  run_test_expr  ~mode:Eval  test_expr_single_fun;
    "public_eval_expr_single_if"            >::  run_test_expr  ~mode:Eval  test_expr_single_if;
    "public_eval_expr_single_let"           >::  run_test_expr  ~mode:Eval  test_expr_single_let;
    "public_eval_expr_single_notequal"      >::  run_test_expr  ~mode:Eval  test_expr_single_notequal;
    "public_eval_expr_single_not"           >::  run_test_expr  ~mode:Eval  test_expr_single_not;
    "public_eval_expr_single_number"        >::  run_test_expr  ~mode:Eval  test_expr_single_number;
    "public_eval_expr_single_or"            >::  run_test_expr  ~mode:Eval  test_expr_single_or;
    "public_eval_expr_single_string"        >::  run_test_expr  ~mode:Eval  test_expr_single_string;
    "public_eval_expr_shadow"               >::  run_test_expr  ~mode:Eval  test_expr_shadow;
    "public_eval_expr_record_empty"         >::  run_test_expr  ~mode:Eval  test_expr_record_empty;
    "public_eval_expr_record1"              >::  run_test_expr  ~mode:Eval  test_expr_record1;
    "public_eval_expr_record2"              >::  run_test_expr  ~mode:Eval  test_expr_record2;
    "public_eval_expr_record3"              >::  run_test_expr  ~mode:Eval  test_expr_record3;
    "public_eval_expr_record_select"        >::  run_test_expr  ~mode:Eval  test_expr_record_select;
    "public_eval_expr_record_select_let"    >::  run_test_expr  ~mode:Eval  test_expr_record_select_let;
    "public_eval_mutop_pi_def"              >::  run_test_eval  ~mode:Eval  test_mutop_pi_def;
    "public_eval_mutop_simple_def_and_let"  >::  run_test_eval  ~mode:Eval  test_mutop_simple_def_and_let;
    "public_eval_mutop_factorial"           >::  run_test_eval  ~mode:Eval  test_mutop_factorial;
  
    (* misc *)
    "public_expr_select_expr"       >::  public_expr_select_expr;
    "public_mutop_nonempty_env"     >::  public_mutop_nonempty_env;
    "public_err_div_by_zero"        >::  public_err_div_by_zero;
    "public_err_def_not_top_level"  >::  public_err_def_not_top_level;
    "public_err_mutop_nested_def"   >::  public_err_mutop_nested_def;
  ]

let _ = run_test_tt_main suite
