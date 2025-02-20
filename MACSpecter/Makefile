CC=gcc
CFLAGS=-Wall -Wextra -fPIC
TARGET=mac_operations.so

$(TARGET): mac_operations.c
	$(CC) $(CFLAGS) -shared -o $(TARGET) mac_operations.c

clean:
	rm -f $(TARGET)
