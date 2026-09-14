CC = gcc
FLEX = flex
TARGET = lexer

all: $(TARGET)

$(TARGET): lex.yy.c
	$(CC) lex.yy.c -o $(TARGET) -lfl

lex.yy.c: lexer.l
	$(FLEX) lexer.l

valid: $(TARGET)
	./$(TARGET) tests/valid_program.gcupl

invalid: $(TARGET)
	./$(TARGET) tests/invalid_program.gcupl; test $$? -eq 1

clean:
	rm -f lex.yy.c $(TARGET)
