BIN = iss

CFLAGS  = -std=c11 -O3 -pipe -Wall -Wextra -Wpedantic
LDFLAGS = -framework ApplicationServices -framework CoreFoundation

$(BIN): iss.c
	$(CC) $(CFLAGS) -o $@ $< $(LDFLAGS)
	codesign -fs - $@

clean:
	rm -f $(BIN)

.PHONY: clean
