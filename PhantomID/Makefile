.PHONY: all clean

all: phantomid

phantomid:
	nim c -d:release --app:lib vpn_handler.nim
	go build -o phantomid main.go

clean:
	rm -f phantomid
	rm -f *.so
