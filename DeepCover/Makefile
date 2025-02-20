CXX=g++
ASM=nasm
CXXFLAGS=-std=c++17 -Wall -O3
ASMFLAGS=-f elf64

TARGET=deepcover
SOURCES=deepcover.cpp ram_ops.o
HEADERS=memory_patterns.hpp

$(TARGET): $(SOURCES) $(HEADERS)
	$(CXX) $(CXXFLAGS) $(SOURCES) -o $(TARGET)

ram_ops.o: ram_ops.asm
	$(ASM) $(ASMFLAGS) ram_ops.asm

clean:
	rm -f $(TARGET) *.o
