package com.totaljerkface.game.utils
{
    public class TextUtils
    {
        public function TextUtils()
        {
            super();
        }
        
        public static function addIntegerCommas(param1:int) : String
        {
            var _loc2_:String = String(param1);
            var _loc3_:int = Math.floor((_loc2_.length - 1) / 3);
            if(_loc3_ == 0)
            {
                return _loc2_;
            }
            var _loc4_:int = _loc2_.length % 3;
            if(_loc4_ == 0)
            {
                _loc4_ = 3;
            }
            var _loc5_:String = _loc2_.substr(0,_loc4_);
            var _loc6_:int = 0;
            while(_loc6_ < _loc3_)
            {
                _loc5_ = _loc5_ + "," + _loc2_.substr(_loc4_,3);
                _loc4_ += 3;
                _loc6_++;
            }
            return _loc5_;
        }
        
        public static function shortenDate(param1:Date) : String
        {
            var _loc2_:String = String(param1.month + 1);
            var _loc3_:String = String(param1.date);
            var _loc4_:String = String(param1.fullYear).substr(2,2);
            return "" + _loc2_ + "/" + _loc3_ + "/" + _loc4_;
        }
        
        public static function setToHundredths(param1:Object) : String
        {
            var _loc2_:Number = Math.round(Number(param1) * 100);
            if(_loc2_ == 0)
            {
                return "0.00";
            }
            var _loc3_:String = String(_loc2_);
            var _loc4_:int = _loc3_.length - 2;
            var _loc5_:String = _loc4_ <= 0 ? "0" : _loc3_.substr(0,_loc4_);
            var _loc6_:String = _loc3_.substr(_loc4_,2);
            if(_loc4_ < 0)
            {
                _loc6_ = "0" + _loc6_;
            }
            return "" + _loc5_ + "." + _loc6_;
        }
        
        public static function removeSlashes(param1:String) : String
        {
            var _loc2_:RegExp = /\\/g;
            return param1.replace(_loc2_,"");
        }
        
        public static function randomNumString(param1:int, param2:int, param3:Boolean) : String
        {
            var _loc4_:int = Math.round(Math.random() * (param2 - param1) + param1) - 1;
            var _loc5_:String = "";
            var _loc6_:int = Math.round(Math.random() * 8 + 1);
            _loc5_ += _loc6_;
            var _loc7_:int = 1;
            while(_loc7_ < _loc4_)
            {
                _loc6_ = Math.round(Math.random() * 9);
                _loc5_ += _loc6_;
                _loc7_++;
            }
            _loc6_ = Math.round(Math.random() * 4) * 2;
            if(param3)
            {
                _loc6_ += 1;
            }
            return _loc5_ + _loc6_;
        }
        
        public static function trimWhitespace(param1:String) : String
        {
            while(param1.charAt(0) == " ")
            {
                param1 = param1.substr(1,param1.length);
            }
            while(param1.charAt(param1.length - 1) == " ")
            {
                param1 = param1.substr(0,param1.length - 1);
            }
            return param1;
        }
    }
}

