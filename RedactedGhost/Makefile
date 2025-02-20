.PHONY: all clean

all: redactedghost

redactedghost:
	scalac DiskCrypto.scala
	ghc -c DataCrypto.hs
	dmd -c ui_handler.d
	julia --compile=all main.jl

clean:
	rm -f *.o *.so *.hi *.class
