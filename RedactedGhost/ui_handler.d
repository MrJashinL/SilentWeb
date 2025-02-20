module ui_handler;

import std.stdio;
import std.string;
import std.process;
import core.stdc.stdlib;

extern (C++) {
    void init_ui() {
        writeln("RedactedGhost - Advanced Data & Disk Encryption");
        writeln("Author: Jashin L.");
    }

    void show_menu() {
        writeln("1. Encrypt Disk");
        writeln("2. Decrypt Disk");
        writeln("3. Encrypt Data");
        writeln("4. Decrypt Data");
        writeln("5. Exit");
    }

    int handle_input(string input) {
        switch(input) {
            case "1":
                write("Enter disk path: ");
                string path = readln().strip();
                write("Enter key: ");
                string key = readln().strip();
                return encrypt_disk(path.ptr, key.ptr);
            case "2":
                write("Enter disk path: ");
                string path = readln().strip();
                write("Enter key: ");
                string key = readln().strip();
                return decrypt_disk(path.ptr, key.ptr);
            case "3":
                write("Enter data: ");
                string data = readln().strip();
                write("Enter key: ");
                string key = readln().strip();
                return encrypt_data(data.ptr, key.ptr);
            case "4":
                write("Enter data: ");
                string data = readln().strip();
                write("Enter key: ");
                string key = readln().strip();
                return decrypt_data(data.ptr, key.ptr);
            case "5":
                exit(0);
            default:
                return -1;
        }
    }
}
