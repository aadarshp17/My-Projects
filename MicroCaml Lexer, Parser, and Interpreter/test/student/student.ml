open OUnit2
open TestUtils
open P4.Lexer
open P4.Parser
open P4.Types

let student_test1 _ = assert_equal 42 42 ~msg:"student_test1 (1)"
let suite = "student" >::: [ "student_test1" >:: student_test1 ]
let _ = run_test_tt_main suite
