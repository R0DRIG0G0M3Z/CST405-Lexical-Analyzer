# CST-405 Project 1 - Lexical Analyzer

This project contains my lexical analyzer for CST-405 Project 1. It reads a `.cm` source file and prints the token kind, category, text, line, and column. Comments and whitespace are ignored, but they are still counted so later token locations stay correct.

The project is separated into a few files because the scanner will connect to a Bison parser in the next project:

- `scanner.l` contains the Flex patterns.
- `tokens.h` contains the token kinds shared with the driver.
- `main.c` prints the tokens and the final result.
- `tests` contains the six class tests and one additional test I wrote.
- `CONTRIBUTIONS.md` lists the part of the project I completed.

Build and run everything with:

```bash
make
make test
```

To see the complete token table for one file:

```bash
./lexer tests/01_all_tokens.cm
```

The `-c` option gives a shorter count and summary:

```bash
./lexer tests/01_all_tokens.cm -c
echo $?
```

A clean file exits with status 0. A file with lexical errors prints every error found and exits with status 1.

This project only checks the vocabulary of the language. It does not decide if the tokens make a valid statement or expression because that will be the parser's job. Strings, characters, and floating-point numbers are also not part of the required language.
