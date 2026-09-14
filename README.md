# CST-405 Project 1 - Lexical Analyzer

This project is an updated version of my CST-301 lexical analyzer. It recognizes the tokens from the C-- grammar, prints the token and its kind and reports lexical errors with their line and column.

## Build
```bash
make
```

## Run the valid test
```bash
make valid
```

## Run the invalid test
```bash
make invalid
```

The valid test finishes with a message saying that there were no lexical errors. The invalid test shows each error and its exact location.
The invalid lexer run uses exit code 1 because errors were found, which is the expected result for that test.

## Files
- `lexer.l` - Flex rules and the main program
- `Makefile` - commands to build and run the lexer
