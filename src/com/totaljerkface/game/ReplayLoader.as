package com.totaljerkface.game
{
    import com.totaljerkface.game.editor.*;
    import com.totaljerkface.game.menus.*;
    import com.totaljerkface.game.utils.*;
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;
    
    public class ReplayLoader extends Sprite
    {
        public static const ID_NOT_FOUND:String = "idnotfound";
        
        public static const REPLAY_LOADED:String = "replayloaded";
        
        public static const REPLAY_AND_LEVEL_LOADED:String = "replayandlevelloaded";
        
        public static const LOAD_ERROR:String = "error";
        
        private var _errorString:String;
        
        private var statusSprite:StatusSprite;
        
        private var loader:URLLoader;
        
        private var _replayDataObject:ReplayDataObject;
        
        private var _levelDataObject:LevelDataObject;
        
        public function ReplayLoader()
        {
            super();
        }
        
        public function load(param1:int) : void
        {
            var _loc2_:URLRequest = new URLRequest(Settings.siteURL + "replay.hw");
            _loc2_.method = URLRequestMethod.POST;
            var _loc3_:URLVariables = new URLVariables();
            _loc3_.replay_id = param1;
            _loc3_.action = "get_combined";
            _loc2_.data = _loc3_;
            this.loader = new URLLoader();
            this.loader.addEventListener(Event.COMPLETE,this.replayDataLoaded);
            this.loader.addEventListener(IOErrorEvent.IO_ERROR,this.IOErrorHandler);
            this.loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.securityErrorHandler);
            this.loader.load(_loc2_);
        }
        
        private function replayDataLoaded(param1:Event) : void
        {
            var _loc5_:Array = null;
            var _loc6_:XML = null;
            var _loc7_:XML = null;
            trace("REPLAY LOAD COMPLETE");
            this.removeLoaderListeners();
            var _loc2_:String = String(this.loader.data);
            var _loc3_:String = _loc2_.substr(0,8);
            trace("dataString " + _loc3_);
            if(_loc3_.indexOf("<html>") > -1)
            {
                this._errorString = "system_error";
                dispatchEvent(new Event(LOAD_ERROR));
                return;
            }
            if(_loc3_.indexOf("failure") > -1)
            {
                _loc5_ = _loc2_.split(":");
                this._errorString = _loc5_[1];
                dispatchEvent(new Event(LOAD_ERROR));
                return;
            }
            var _loc4_:XML = XML(this.loader.data);
            trace(_loc4_.toXMLString());
            if(_loc4_.lv.length() > 0 && _loc4_.rp.length() > 0)
            {
                _loc6_ = _loc4_.lv[0];
                this._levelDataObject = new LevelDataObject(_loc6_.@id,_loc6_.@ln,_loc6_.@ui,_loc6_.@un,_loc6_.@rg,_loc6_.@vs,_loc6_.@ps,_loc6_.@dp,_loc6_.uc,_loc6_.@pc,"1","1","1",_loc6_.@dp);
                _loc7_ = _loc4_.rp[0];
                this._replayDataObject = new ReplayDataObject(_loc7_.@id,_loc7_.@li,_loc7_.@ui,_loc7_.@un,_loc7_.@rg,_loc7_.@vs,_loc7_.@vw,_loc7_.@dc,_loc7_.uc,_loc7_.@pc,_loc7_.@ct,_loc7_.@ar,_loc7_.@vr);
                dispatchEvent(new Event(REPLAY_AND_LEVEL_LOADED));
            }
            else
            {
                dispatchEvent(new Event(ID_NOT_FOUND));
            }
        }
        
        private function removeLoaderListeners() : void
        {
            this.loader.removeEventListener(Event.COMPLETE,this.replayDataLoaded);
            this.loader.removeEventListener(IOErrorEvent.IO_ERROR,this.IOErrorHandler);
            this.loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.securityErrorHandler);
        }
        
        private function IOErrorHandler(param1:IOErrorEvent) : void
        {
            trace(param1.text);
            this.removeLoaderListeners();
            this._errorString = "io_error";
            dispatchEvent(new Event(LOAD_ERROR));
        }
        
        private function securityErrorHandler(param1:SecurityErrorEvent) : void
        {
            trace(param1.text);
            this.removeLoaderListeners();
            this._errorString = "security_error";
            dispatchEvent(new Event(LOAD_ERROR));
        }
        
        public function get replayDataObject() : ReplayDataObject
        {
            return this._replayDataObject;
        }
        
        public function get levelDataObject() : LevelDataObject
        {
            return this._levelDataObject;
        }
        
        public function get errorString() : String
        {
            return this._errorString;
        }
        
        public function die() : void
        {
            this.removeLoaderListeners();
        }
    }
}

