(*

COL226 : Assignment-03

ADITYA GUPTA
2021CS10554

The problem description can be found in the file named "A3.txt", 
while the design decisions and the testcases have been documented in the file named "Design_Decisions.md" and testcase.txt respectively.

*)

{
type token =
   ABS_ARITHMETIC_OP of string   (* unary operator, "abs" *)
|  PLUS_ARITHMETIC_OP of char    (* arithmetic plus, "+" *)
|  MINUS_ARITHMETIC_OP of char   (* arithmetic minus, "-" *)
|  MUL_ARITHMETIC_OP of char     (* arithmetic multiply, "*" *)
|  DIV_ARITHMETIC_OP of char     (* arithmetic divide, "/" *)
|  MOD_ARITHMETIC_OP of string   (* modulo, "mod" *)
|  LEFTPAREN of char             (* left paren, "(" *)
|  RIGHTPAREN of char            (* right paren, ")" *)
|  NOT of string                 (* boolean NOT, "not" *)
|  AND of string                 (* boolean AND, "&" *)
|  OR of string                  (* boolean OR, "|" *)
|  NOT_EQUAL_TO of string        (* not equal to *)
|  EQUAL_ASSIGN of char          (* can be used as either equal_to or is_equal in OCaml, "=" *)
|  EQUAL_COMPARE of string       (* used as is_equal comparasion, "==" *)
|  GREATER_THAN of char          (* greater than, ">" *)
|  LESS_THAN of char             (* less than, "<" *)
|  GREATER_THAN_EQUAL of string  (* greater than/equal to, ">=" *)
|  LESS_THAN_EQUAL of string     (* less than/equal to, "<=" *)
|  REFRENCE of string            (* used to refrence a function, "->"*)
|  KEYWORD of string             (* pre-defined keywords for the language, "if" | "then" | "else" | "let" | "in" | "match" | "with" | "type" *)
|  IDENTIFIER of string          (* variable identifier, alphanumeric strings with first char lowercase/underscore *)
|  INT_CONSTANT of int           (* integer constants,  w/o leading zeros *)
|  STRING_CONSTANT of string
|  BOOL_CONSTANT of bool         (* boolean constant of type bool - true/false *)
|  FLOAT_CONSTANT of float
|  CHAR_CONSTANT of char       
|  CONCAT_STRING_OP of char
|  STRING_OP of string
|  DELIMITER_OCAML of string     (* delimiter used in OCaml, ";;" *)
|  DELIMITER_CPP of char         (* delimiter used in CPP, ";" *)
|  COMMA of char                 (* comma used , ","*)
|  ERROR_UNIDENTIFIED_CHAR of char
|  ERROR_INVALID_IDENTIFIER of string;;

(*To convert the true and false string to bool*)
let string_to_bool str =
  match String.lowercase_ascii str with
  | "true"  -> true
  | "false" -> false
}

let letters = ['a'-'z']
let digit_string = ['0'-'9']
let cap_letters = ['A'-'Z']
let non_zero_digit = ['1'-'9']
let prime = '\''
let underscore = '_'
let identifiers = (letters|underscore)(letters|cap_letters|digit_string|prime|underscore)*
let invalid_identifier = (prime|cap_letters|digit_string)(letters|cap_letters|digit_string|prime|underscore)* 
let integer_constants = (digit_string+)
let string_constants = '"' [^'"']* '"'     (*defines strings by giving any expression (without double quote) which is bounded by double quotes as a string_constant*)
let emptyspaces = ' '|'\n'|'\r'|'\t'       (* emptyspaces/whitespaces to be removed while extracting tokens from input*)
let bool_constants = "true"|"false"|"True" |"False" (* Although, OCaml only supports true, however, True as a design decision has also been used as bool*)
let float_constants = (digit_string+)"."(digit_string+)  (*Floats have been assumed to be of the format "int+ . int+" *)
let character_constants = '''[^''']'''     (*covers the char constants - i.e. singleton elements defined under single quotations '_' *)
let keywords = "type" | "if" | "then" | "else" | "let" | "in" | "match" | "with" | "fun" | "first" | "second" | "pair"
let string_op = "length" | "::" | "append" (*"^": concatenation has been handled seperately, as it was a char*)
let tuple_op = "first" | "second" | "pair" (*Although no such operations exist in OCaml however, in the toy language discussed in class, we had used such operations*)

rule read = parse
|    emptyspaces              {read lexbuf }
|    "abs"                    {ABS_ARITHMETIC_OP ("abs")::read lexbuf}
|    '+'                      {PLUS_ARITHMETIC_OP ('+')::read lexbuf}
|    '-'                      {MINUS_ARITHMETIC_OP ('-')::read lexbuf}
|    '*'                      {MUL_ARITHMETIC_OP ('*')::read lexbuf}
|    "/"                      {DIV_ARITHMETIC_OP ('/')::read lexbuf}
|    "mod"                    {MOD_ARITHMETIC_OP ("mod")::read lexbuf}
|    '('|'['|'{' as lp        {LEFTPAREN (lp) ::read lexbuf}
|    ')'|']'|'}' as rp        {RIGHTPAREN (rp) ::read lexbuf}
|    "not" as n               {NOT (n)::read lexbuf}
|    "&&" | "and" as a        {AND (a)::read lexbuf}
|    "||" | "or" as x         {OR (x)::read lexbuf}
|    '=' as eq                {EQUAL_ASSIGN (eq):: read lexbuf}   (*Equal acts as both comparision and assignment in OCaml, however, have implemented both "=" and "==" to ensure consistency*)
|    "==" as e                {EQUAL_COMPARE (e) :: read lexbuf}
|    "<>" | "!=" as neq       {NOT_EQUAL_TO (neq)::read lexbuf}
|    '<' as lt                {LESS_THAN (lt)::read lexbuf}
|    '>' as gt                {GREATER_THAN (gt)::read lexbuf}
|    ">=" as gte              {GREATER_THAN_EQUAL (gte)::read lexbuf}
|    "<=" as lte              {LESS_THAN_EQUAL (lte)::read lexbuf}
|    "->" as r                {REFRENCE (r) :: read lexbuf}
|    keywords as k            {KEYWORD (k)::read lexbuf}
|    integer_constants as x   {INT_CONSTANT (int_of_string x)::read lexbuf }
|    float_constants as f     {FLOAT_CONSTANT (float_of_string f)::read lexbuf }
|    bool_constants as b      {BOOL_CONSTANT (string_to_bool b) ::read lexbuf}
|    string_constants as s    {STRING_CONSTANT (String.sub s 1 (String.length s - 2)) :: read lexbuf}
|    character_constants as c {CHAR_CONSTANT (c.[1]) :: read lexbuf}
|    '^' as c                 {CONCAT_STRING_OP (c):: read lexbuf}
|    string_op as s           {STRING_OP (s):: read lexbuf}
|    identifiers as x         {IDENTIFIER (x):: read lexbuf}
|    ";;"                     {DELIMITER_OCAML (";;")::read lexbuf}
|    ';'                      {DELIMITER_CPP (';'):: read lexbuf}
|    ','                      {COMMA (','):: read lexbuf}
|    invalid_identifier as x  {ERROR_INVALID_IDENTIFIER (x) :: read lexbuf}
|    _ as e                   {ERROR_UNIDENTIFIED_CHAR (e) :: read lexbuf}
|    eof                      {[]}

{
    let tokenize s = read (Lexing.from_string s) 
}
