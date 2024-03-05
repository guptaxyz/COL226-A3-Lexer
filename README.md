# COL226-PL A3

Hi ! I'm Aditya, a junior in Computer Science Department at IIT Delhi.
This repository shall be including the assignment-3 along with my submission, for the Programming Languages Course under Prof. Sanjiva Prasad in the Spring semester of 2024.

The objective of this assignment is to create a tokeniser in OCaml using lex.

## DESIGN DECISIONS:

Given Design attributes:
- Identifiers: These are alphanumeric strings that can also contain primes (*the single quote symbol*) and underscores, but no other symbols. Identifiers must start with a lower case letter or an underscore.
- Keywords: These are words reserved for the language and cannot be used as identifiers. You would have keywords corresponding to the operations defined in class (if-then-else and operations on tuples).
- Boolean operators and constants
- Arithmetic operators and integer constants (without leading zeroes) 
- Comparison operators 
- String operators and constants
- Parentheses and commas

### Extra Decisions undertaken:

- longest pattern mapped string to be taken as token.
  Ex - ifold : [IDENTIFIER "ifold"] - *note that, not "if" - keyword, "old" - identifier, as should happen in programming languages*

- only any kind of **emptyspaces, operations, Unexpected characters** will lead to the breaking of the string into **two independent tokens** 
    - Ex :
      - 1abc&True : [ERROR_INVALID_IDENTIFIER "1abc"; AND '&'; BOOL_CONSTANT true]
      - wor+Ld : [IDENTIFIER "wor"; PLUS_ARITHMETIC_OP '+'; ERROR_INVALID_IDENTIFIER "Ld"]
      - ab12$245 : [IDENTIFIER "ab12"; ERROR_UNIDENTIFIED_CHAR '$'; INT_CONSTANT 245]

- I have implemented that a Tokeniser not just divides into tokens but also computes and stores the **inherent value for all the constants**.
    - Ex :
      - True&00123 : [BOOL_CONSTANT true; AND '&'; INT_CONSTANT 123]
        - *Here, string "True"  has been computed as bool true and string "000123" the int 123.*
      - f=042.240 : [IDENTIFIER "f"; EQUAL_ASSIGN '='; FLOAT_CONSTANT 42.24]
        - *Here, the string "042.240" is returned as the token 42.24 of type Float.*
      - "\"even\"^\"odd\"" : [STRING_CONSTANT "even"; CONCAT_STRING_OP '^'; STRING_CONSTANT "odd"]
        - *Here, it computes and outputs the value of the strings as "even" and "odd", rather than "\"even\"" and "\"odd\"".*

### Justification :

- In languages such as python, cpp, OCaml and many others, 
    - For first, the policy of longest string pattern mapped is used
    - Second, continuous strings with multiple tokens are supported, however it is obsereved that, such tokens can only exist when they are seperated by operations (+,*,/,comma,and, or, etc.), however, the language we are defining being very limited about the variety of operations and characters it knows, I have also raised an error at Unexpected characters, and allowed them to follow the same notion, of seperating tokens.
    - Third, this is an add-on functionality implemented in my tokeniser for all constants.

The testcases have been documented in the testcases.txt file and the problem statement in A3.txt.
