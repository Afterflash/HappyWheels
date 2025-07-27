package com.totaljerkface.game.utils
{
    import com.hurlant.crypto.Crypto;
    import com.hurlant.crypto.prng.Random;
    import com.hurlant.crypto.symmetric.ICipher;
    import com.hurlant.crypto.symmetric.IPad;
    import com.hurlant.crypto.symmetric.IVMode;
    import com.hurlant.crypto.symmetric.PKCS5;
    import com.hurlant.util.Base64;
    import com.hurlant.util.Hex;
    import flash.utils.ByteArray;
    
    public class PostEncryption
    {
        private const ALGORITHM:String = "aes-cbc";
        
        private const PADDING:IPad = new PKCS5();
        
        private var keyData:ByteArray;
        
        private var IV:String;
        
        public function PostEncryption(param1:String)
        {
            super();
            this.keyData = Hex.toArray(param1);
        }
        
        public function encrypt(param1:String) : String
        {
            var _loc2_:ByteArray = Hex.toArray(Hex.fromString(param1));
            var _loc3_:IPad = this.PADDING;
            var _loc4_:ICipher = Crypto.getCipher(this.ALGORITHM,this.keyData,_loc3_);
            _loc3_.setBlockSize(_loc4_.getBlockSize());
            _loc4_.encrypt(_loc2_);
            var _loc5_:IVMode = _loc4_ as IVMode;
            this.IV = Hex.fromArray(_loc5_.IV);
            return Base64.encodeByteArray(_loc2_);
        }
        
        public function getIV() : String
        {
            return this.IV;
        }
        
        private function genKey(param1:int) : String
        {
            var _loc2_:Random = new Random();
            var _loc3_:ByteArray = new ByteArray();
            _loc2_.nextBytes(_loc3_,param1 / 8);
            return Hex.fromArray(_loc3_);
        }
    }
}

