package com.totaljerkface.game.utils
{
    import com.hurlant.crypto.symmetric.ButtHoleKey;
    import com.hurlant.crypto.symmetric.CBCMode;
    import com.hurlant.crypto.symmetric.ICipher;
    import com.hurlant.crypto.symmetric.IPad;
    import com.hurlant.crypto.symmetric.PKCS5;
    import com.hurlant.util.Base64;
    import flash.utils.ByteArray;
    
    public class LevelEncryptor
    {
        public function LevelEncryptor()
        {
            super();
        }
        
        public static function encryptString(param1:String, param2:String = "") : String
        {
            var _loc3_:ByteArray = new ByteArray();
            _loc3_.writeUTFBytes(param1);
            var _loc4_:IPad = new PKCS5();
            var _loc5_:ICipher = getCipher(param2,_loc4_);
            _loc4_.setBlockSize(_loc5_.getBlockSize());
            _loc5_.encrypt(_loc3_);
            _loc5_.dispose();
            return Base64.encodeByteArray(_loc3_);
        }
        
        public static function decryptString(param1:String, param2:String = "") : String
        {
            var _loc3_:ByteArray = Base64.decodeToByteArray(param1);
            var _loc4_:IPad = new PKCS5();
            var _loc5_:ICipher = getCipher(param2,_loc4_);
            _loc4_.setBlockSize(_loc5_.getBlockSize());
            _loc5_.decrypt(_loc3_);
            _loc5_.dispose();
            _loc3_.position = 0;
            return _loc3_.readUTFBytes(_loc3_.length);
        }
        
        public static function encryptByteArray(param1:ByteArray, param2:String = "") : void
        {
            var _loc3_:IPad = new PKCS5();
            var _loc4_:ICipher = getCipher(param2,_loc3_);
            _loc3_.setBlockSize(_loc4_.getBlockSize());
            _loc4_.encrypt(param1);
            param1.position = 0;
        }
        
        public static function decryptByteArray(param1:ByteArray, param2:String = "") : void
        {
            var _loc3_:IPad = new PKCS5();
            var _loc4_:ICipher = getCipher(param2,_loc3_);
            _loc3_.setBlockSize(_loc4_.getBlockSize());
            _loc4_.decrypt(param1);
            param1.position = 0;
        }
        
        private static function getCipher(param1:String, param2:IPad) : ICipher
        {
            var _loc3_:ByteArray = new ByteArray();
            _loc3_.writeUTFBytes(param1);
            var _loc4_:CBCMode = new CBCMode(new ButtHoleKey(_loc3_),param2);
            var _loc5_:ByteArray = new ByteArray();
            _loc5_.writeUTFBytes("abcd1234");
            _loc4_.IV = _loc5_;
            return _loc4_;
        }
    }
}

