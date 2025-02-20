#pragma once

struct MemoryPattern {
    std::vector<uint8_t> pattern;
    std::string description;
};

const std::vector<MemoryPattern> KNOWN_PATTERNS = {
    {{0x45, 0x4E, 0x43, 0x52, 0x59, 0x50, 0x54}, "Encryption Key Header"},
    {{0x50, 0x4B, 0x03, 0x04}, "ZIP File Signature"},
    {{0x52, 0x53, 0x41, 0x31}, "RSA Private Key"}
};
