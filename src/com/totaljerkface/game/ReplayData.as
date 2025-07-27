package com.totaljerkface.game
{
    import com.totaljerkface.game.level.MouseData;
    import flash.events.*;
    import flash.net.*;
    import flash.system.*;
    import flash.utils.*;
    
    public class ReplayData extends EventDispatcher
    {
        public static var REPLAY_LOADED:String = "replayloaded";
        
        private var _keyByteArray:ByteArray;
        
        private var _mouseByteArray:ByteArray;
        
        private var _completed:Boolean;
        
        public function ReplayData()
        {
            super();
            this._keyByteArray = new ByteArray();
            this._mouseByteArray = new ByteArray();
        }
        
        public function get byteArray() : ByteArray
        {
            var _loc1_:ByteArray = new ByteArray();
            _loc1_.writeBytes(this._keyByteArray,0,this._keyByteArray.length);
            if(this._mouseByteArray.length > 0)
            {
                _loc1_.writeByte(255);
                _loc1_.writeBytes(this._mouseByteArray,0,this._mouseByteArray.length);
            }
            return _loc1_;
        }
        
        public function set byteArray(param1:ByteArray) : void
        {
            this.parseByteArray(param1);
        }
        
        private function parseByteArray(param1:ByteArray) : void
        {
            var _loc2_:int = 0;
            var _loc4_:* = 0;
            var _loc3_:Number = 0;
            while(_loc3_ < param1.length)
            {
                _loc4_ = uint(param1[_loc3_]);
                if(_loc4_ == 255)
                {
                    _loc2_ = int(_loc3_);
                    break;
                }
                _loc3_++;
            }
            if(!_loc2_)
            {
                this._keyByteArray = param1;
                this._mouseByteArray = new ByteArray();
            }
            else
            {
                this._keyByteArray = new ByteArray();
                this._keyByteArray.writeBytes(param1,0,_loc2_);
                this._mouseByteArray = new ByteArray();
                this._mouseByteArray.writeBytes(param1,_loc2_ + 1,param1.length - (_loc2_ + 1));
            }
        }
        
        public function addKeyEntry(param1:String, param2:int) : void
        {
            var _loc3_:int = parseInt(param1,2);
            this._keyByteArray.writeByte(_loc3_);
        }
        
        public function getKeyEntry(param1:int) : String
        {
            var _loc2_:int = int(this._keyByteArray[param1]);
            var _loc3_:String = _loc2_.toString(2);
            return this.completeByte(_loc3_);
        }
        
        public function addMouseEntry(param1:int, param2:int, param3:int = 0) : void
        {
            var _loc4_:String = param1.toString(2);
            if(param1 > 32767)
            {
                param1 = 32767;
            }
            if(param2 > 65535)
            {
                param2 = 65535;
            }
            if(param3 > 0)
            {
                param1 += 32768;
                _loc4_ = param1.toString(2);
            }
            this._mouseByteArray.writeShort(param1);
            this._mouseByteArray.writeShort(param2);
        }
        
        public function getMouseClickMap() : Object
        {
            var _loc3_:int = 0;
            var _loc4_:int = 0;
            var _loc5_:Boolean = false;
            var _loc6_:Boolean = false;
            var _loc7_:String = null;
            var _loc8_:MouseData = null;
            var _loc1_:Object = new Object();
            this._mouseByteArray.position = 0;
            var _loc2_:int = int(this._mouseByteArray.length);
            while(this._mouseByteArray.position < _loc2_)
            {
                _loc3_ = int(this._mouseByteArray.readUnsignedShort());
                _loc4_ = int(this._mouseByteArray.readUnsignedShort());
                trace(_loc3_.toString(2));
                _loc5_ = false;
                _loc6_ = false;
                if(_loc3_ > 32767)
                {
                    _loc3_ -= 32768;
                    _loc6_ = true;
                }
                else
                {
                    _loc5_ = true;
                }
                _loc7_ = _loc3_.toString();
                if(_loc1_[_loc7_])
                {
                    _loc8_ = _loc1_[_loc7_];
                }
                else
                {
                    _loc8_ = new MouseData();
                    if(_loc6_)
                    {
                        _loc8_.first = 1;
                    }
                }
                if(_loc5_)
                {
                    _loc8_.click = _loc5_;
                    _loc8_.clickTriggerIndex = _loc4_;
                }
                else if(_loc6_)
                {
                    _loc8_.rollOut = _loc6_;
                    _loc8_.rollOutTriggerIndex = _loc4_;
                }
                _loc1_[_loc7_] = _loc8_;
            }
            this._mouseByteArray.position = 0;
            return _loc1_;
        }
        
        private function completeByte(param1:String, param2:int = 8) : String
        {
            while(param1.length < param2)
            {
                param1 = "0" + param1;
            }
            return param1;
        }
        
        public function resetPosition() : void
        {
            this._keyByteArray.position = 0;
            this._mouseByteArray.position = 0;
        }
        
        public function reset() : void
        {
            this._keyByteArray = new ByteArray();
            this._mouseByteArray = new ByteArray();
            this.resetPosition();
        }
        
        public function getLength() : int
        {
            return this._keyByteArray.length;
        }
        
        public function get completed() : Boolean
        {
            return this._completed;
        }
        
        public function set completed(param1:Boolean) : void
        {
            this._completed = param1;
        }
    }
}

