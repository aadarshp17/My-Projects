open OUnit2
open P5
open Ast
open Typecheck
open Optimize
open Utils

type run_test_mode = Optimize | Typecheck

(* Assertion wrappers for convenience and readability *)
let assert_true b = assert_equal true b
let assert_false b = assert_equal false b
let assert_succeed () = assert_true true

let input_handler f =
  try
    let _ = f () in
    assert_failure "Expected InvalidInputException, none received"
  with
  | InvalidInputException _ -> assert_succeed ()
  | ex ->
      assert_failure
        ("Got " ^ Printexc.to_string ex ^ ", expected InvalidInputException")

let div_by_zero_ex_handler f =
  try
    let _ = f () in
    assert_failure "Expected DivByZeroError, none received"
  with
  | DivByZeroError -> assert_succeed ()
  | ex ->
      assert_failure
        ("Got " ^ Printexc.to_string ex ^ ", expected DivByZeroError")

let type_error_ex_handler f =
  try
    let _ = f () in
    assert_failure "Expected TypeError, none received"
  with
  | TypeError _ -> assert_succeed ()
  | ex ->
      assert_failure ("Got " ^ Printexc.to_string ex ^ ", expected TypeError")

let run_test ~mode (input, our_optimize, our_type) _ =
  match mode with
  | Optimize ->
      let student = input |> parse_expr |> optimize [] in
      assert_equal student our_optimize
        ~msg:
          ("Optimize error:\nexpected: " ^ show_expr our_optimize
         ^ "\nstudent:  " ^ show_expr student)
  | Typecheck ->
      let student = input |> parse_expr |> typecheck [] in
      assert_equal student our_type
        ~msg:
          ("Type error:\nexpected: " ^ show_exptype our_type ^ "\nstudent:  "
         ^ show_exptype student)
