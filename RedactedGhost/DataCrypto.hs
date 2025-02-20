module DataCrypto where

import qualified Data.ByteString as BS
import qualified Crypto.Cipher.AES as AES
import qualified Crypto.Hash.SHA256 as SHA256
import System.IO
import Foreign.C.String

foreign export ccall init_data_crypto :: IO ()
foreign export ccall encrypt_data :: CString -> CString -> IO CString
foreign export ccall decrypt_data :: CString -> CString -> IO CString

init_data_crypto :: IO ()
init_data_crypto = return ()

encrypt_data :: CString -> CString -> IO CString
encrypt_data dataPtr keyPtr = do
    data <- peekCString dataPtr
    key <- peekCString keyPtr
    let ctx = AES.initAES $ SHA256.hash $ BS.pack $ map (fromIntegral . fromEnum) key
    let encrypted = AES.encryptECB ctx $ BS.pack $ map (fromIntegral . fromEnum) data
    newCString $ map (toEnum . fromIntegral) $ BS.unpack encrypted

decrypt_data :: CString -> CString -> IO CString
decrypt_data dataPtr keyPtr = do
    data <- peekCString dataPtr
    key <- peekCString keyPtr
    let ctx = AES.initAES $ SHA256.hash $ BS.pack $ map (fromIntegral . fromEnum) key
    let decrypted = AES.decryptECB ctx $ BS.pack $ map (fromIntegral . fromEnum) data
    newCString $ map (toEnum . fromIntegral) $ BS.unpack decrypted
