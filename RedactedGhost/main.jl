#!/usr/bin/env julia

module RedactedGhost

export CryptoManager

using Base64

__author__ = "Jashin L."

struct CryptoManager
    function init()
        ccall((:init_disk_crypto, "./disk_crypto.so"), Void, ())
        ccall((:init_data_crypto, "./data_crypto.so"), Void, ())
        ccall((:init_ui, "./ui_handler.so"), Void, ())
    end

    function encrypt_disk(path::String, key::String)
        ccall((:encrypt_disk, "./disk_crypto.so"), Int32, (Cstring, Cstring), path, key)
    end

    function decrypt_disk(path::String, key::String)
        ccall((:decrypt_disk, "./disk_crypto.so"), Int32, (Cstring, Cstring), path, key)
    end

    function encrypt_data(data::String, key::String)
        ccall((:encrypt_data, "./data_crypto.so"), Cstring, (Cstring, Cstring), data, key)
    end

    function decrypt_data(data::String, key::String)
        ccall((:decrypt_data, "./data_crypto.so"), Cstring, (Cstring, Cstring), data, key)
    end
end

end
