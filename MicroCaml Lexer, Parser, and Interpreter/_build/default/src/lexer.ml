open Str
open Types

(* Part 1: Lexer - Tokenize the input string *)

let tokenize input = 
  let rec keta zeta feta =
    if zeta >= String.length feta then [] (* Return an empty list if the end of the string is reached *)
    else
      (* Match the current substring against various regular expressions and return the corresponding token *)
      if string_match (regexp "*") feta zeta then
        Tok_Mult::keta (zeta + 1) feta (* Match multiplication symbol *)
      else if string_match (regexp "if") feta zeta then
        Tok_If::keta (zeta + 2) feta (* Match "if" keyword *)
      else if string_match (regexp "then") feta zeta then
        Tok_Then::keta (zeta + 4) feta (* Match "then" keyword *)
      else if string_match (regexp "else") feta zeta then
        Tok_Else::keta (zeta + 4) feta (* Match "else" keyword *)
      else if string_match (regexp "let") feta zeta then
        Tok_Let::keta (zeta + 3) feta (* Match "let" keyword *)
      else if string_match (regexp "def") feta zeta then
        Tok_Def::keta (zeta + 3) feta (* Match "def" keyword *)
      else if string_match (regexp "rec") feta zeta then
        Tok_Rec::keta (zeta + 3) feta (* Match "rec" keyword *)
      else if string_match (regexp "[0-9]+") feta zeta then
        let token = matched_string feta in
        Tok_Int (int_of_string token)::keta (zeta + String.length token) feta (* Match integers *)
      else if string_match (regexp "true") feta zeta then
        Tok_Bool true::keta (zeta + 4) feta (* Match boolean true *)
      else if string_match (regexp "false") feta zeta then
        Tok_Bool false::keta (zeta + 5) feta (* Match boolean false *)
      else if string_match (regexp ")") feta zeta then
        Tok_RParen::keta (zeta + 1) feta (* Match right parenthesis *)
      else if string_match (regexp "(") feta zeta then
        Tok_LParen::keta (zeta + 1) feta (* Match left parenthesis *)
      else if string_match (regexp "=") feta zeta then
        Tok_Equal::keta (zeta + 1) feta (* Match equal sign *)
      else if string_match (regexp "fun") feta zeta then
        Tok_Fun::keta (zeta + 3) feta (* Match "fun" keyword *)
      else if string_match (regexp ";;") feta zeta then
        Tok_DoubleSemi::keta (zeta + 2) feta (* Match double semicolon *)
      else if string_match (regexp "->") feta zeta then
        Tok_Arrow::keta (zeta + 2) feta (* Match arrow symbol *)
      else if string_match (regexp "-") feta zeta then
        Tok_Sub::keta (zeta + 1) feta (* Match subtraction symbol *)
      else if string_match (regexp ">=") feta zeta then
        Tok_GreaterEqual::keta (zeta + 2) feta (* Match greater than or equal symbol *)
      else if string_match (regexp "<=") feta zeta then
        Tok_LessEqual::keta (zeta + 2) feta (* Match less than or equal symbol *)
      else if string_match (regexp "<>") feta zeta then
        Tok_NotEqual::keta (zeta + 2) feta (* Match not equal symbol *)
      else if string_match (regexp ">") feta zeta then
        Tok_Greater::keta (zeta + 1) feta (* Match greater than symbol *)
      else if string_match (regexp "<") feta zeta then
        Tok_Less::keta (zeta + 1) feta (* Match less than symbol *)
      else if string_match (regexp "in") feta zeta then
        Tok_In::keta (zeta + 2) feta (* Match "in" keyword *)
      else if string_match (regexp "not") feta zeta then
        Tok_Not::keta (zeta + 3) feta (* Match "not" keyword *)
      else if string_match (regexp "[a-zA-Z][a-zA-Z0-9]*") feta zeta then
        let token = matched_string feta in
        Tok_ID token::keta (zeta + String.length token) feta (* Match identifiers *)
      else if string_match (regexp "+") feta zeta then
        Tok_Add::keta (zeta + 1) feta (* Match addition symbol *)
      else if string_match (regexp "{") feta zeta then
        Tok_LCurly::keta (zeta + 1) feta (* Match left curly brace *)
      else if string_match (regexp "}") feta zeta then
        Tok_RCurly::keta (zeta + 1) feta (* Match right curly brace *)
      else if string_match (regexp "||") feta zeta then
        Tok_Or::keta (zeta + 2) feta (* Match logical OR symbol *)
      else if string_match (regexp "&&") feta zeta then
        Tok_And::keta (zeta + 2) feta (* Match logical AND symbol *)
      else if string_match (regexp ";") feta zeta then
        Tok_Semi::keta (zeta + 1) feta (* Match semicolon *)
      else if string_match (regexp "\\^") feta zeta then
        Tok_Concat::keta (zeta + 1) feta (* Match concatenation symbol *)
      else if string_match (regexp "\"[^\"]*\"") feta zeta then
        let token = matched_string feta in
        let stripped_token = String.sub token 1 (String.length token - 2) in
        Tok_String stripped_token::keta (zeta + String.length token) feta (* Match strings *)
      else if string_match (regexp "/") feta zeta then
        Tok_Div::keta (zeta + 1) feta (* Match division symbol *)
      else if string_match (regexp "(-[0-9]+)") feta zeta then
        let theta = matched_string feta in
        Tok_Int (int_of_string (String.sub theta 1 (String.length theta - 2)))::keta (zeta + String.length theta) feta (* Match negative integers *)
      else if string_match (regexp "[ \t\n]") feta zeta then
        keta (zeta + String.length (matched_string feta)) feta (* Skip whitespace *)
      else
        raise (InvalidInputException "Invalid input") (* Raise exception for unrecognized input *)
  in
  keta 0 input
