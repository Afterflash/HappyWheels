package com.totaljerkface.game
{
    import com.totaljerkface.game.utils.LevelEncryptor;
    import flash.events.*;
    import flash.net.*;
    import flash.utils.*;
    
    public class RecordLoader extends UserLevelLoader
    {
        protected var replayId:int;
        
        protected var _replayByteArray:ByteArray;
        
        public function RecordLoader(param1:int, param2:int, param3:int)
        {
            this.replayId = param1;
            super(param2,param3,false);
        }
        
        override public function loadData() : void
        {
            var _loc3_:* = undefined;
            var _loc4_:URLLoader = null;
            var _loc1_:URLRequest = new URLRequest(Settings.siteURL + "replay.hw");
            _loc1_.method = URLRequestMethod.POST;
            var _loc2_:URLVariables = new URLVariables();
            _loc2_.replay_id = this.replayId;
            _loc2_.level_id = levelId;
            _loc2_.action = "get_cmb_records";
            _loc1_.data = _loc2_;
            trace("LOAD COMBINED RECORD");
            for(_loc3_ in _loc2_)
            {
                trace("urlVariables." + _loc3_ + " = " + _loc2_[_loc3_]);
            }
            _loc4_ = new URLLoader();
            _loc4_.dataFormat = URLLoaderDataFormat.BINARY;
            _loc4_.addEventListener(Event.COMPLETE,this.loadComplete);
            _loc4_.addEventListener(IOErrorEvent.IO_ERROR,IOErrorHandler);
            _loc4_.load(_loc1_);
        }
        
        override protected function loadComplete(param1:Event) : void
        {
            var _loc9_:Array = null;
            var _loc2_:URLLoader = param1.target as URLLoader;
            _loc2_.removeEventListener(Event.COMPLETE,this.loadComplete);
            _loc2_.removeEventListener(IOErrorEvent.IO_ERROR,IOErrorHandler);
            var _loc3_:String = String(_loc2_.data);
            var _loc4_:String = _loc3_.substr(0,8);
            trace("dataString " + _loc4_);
            if(_loc4_.indexOf("<html>") > -1)
            {
                _errorString = "system_error";
                dispatchEvent(new ErrorEvent(ErrorEvent.ERROR));
                return;
            }
            if(_loc4_.indexOf("failure") > -1)
            {
                _loc9_ = _loc3_.split(":");
                _errorString = _loc9_[1];
                dispatchEvent(new ErrorEvent(ErrorEvent.ERROR));
                return;
            }
            var _loc5_:ByteArray = _loc2_.data;
            var _loc6_:int = _loc5_.readInt();
            this._replayByteArray = new ByteArray();
            _loc5_.readBytes(this._replayByteArray,0,_loc6_);
            var _loc7_:ByteArray = new ByteArray();
            _loc5_.readBytes(_loc7_,0,0);
            LevelEncryptor.decryptByteArray(_loc7_,"eatshit" + authorId);
            _loc7_.uncompress();
            var _loc8_:* = _loc7_.readUTFBytes(_loc7_.length);
            _levelXML = new XML(_loc8_);
            dispatchEvent(new Event(Event.COMPLETE));
        }
        
        public function get replayByteArray() : ByteArray
        {
            return this._replayByteArray;
        }
    }
}

