package com.totaljerkface.game
{
    import com.totaljerkface.game.editor.*;
    import com.totaljerkface.game.menus.*;
    import com.totaljerkface.game.utils.*;
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;
    
    public class LevelLoader extends Sprite
    {
        public static const ID_NOT_FOUND:String = "idnotfound";
        
        public static const LEVEL_LOADED:String = "levelloaded";
        
        public static const LOAD_ERROR:String = "error";
        
        private var _errorString:String;
        
        private var statusSprite:StatusSprite;
        
        private var loader:URLLoader;
        
        private var _levelDataObject:LevelDataObject;
        
        public function LevelLoader()
        {
            super();
        }
        
        public function load(param1:int) : void
        {
            var _loc2_:URLRequest = new URLRequest(Settings.siteURL + "get_level.hw");
            _loc2_.method = URLRequestMethod.POST;
            var _loc3_:URLVariables = new URLVariables();
            _loc3_.level_id = param1;
            _loc3_.action = "get_level";
            _loc2_.data = _loc3_;
            this.loader = new URLLoader();
            this.loader.addEventListener(Event.COMPLETE,this.levelDataLoaded);
            this.loader.addEventListener(IOErrorEvent.IO_ERROR,this.IOErrorHandler);
            this.loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.securityErrorHandler);
            this.loader.load(_loc2_);
        }
        
        private function levelDataLoaded(param1:Event) : void
        {
            var _loc5_:Array = null;
            var _loc6_:XML = null;
            trace("LOAD COMPLETE");
            this.removeLoaderListeners();
            trace(this.loader.data);
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
            if(_loc4_.lv.length() > 0)
            {
                _loc6_ = _loc4_.lv[0];
                this._levelDataObject = new LevelDataObject(_loc6_.@id,_loc6_.@ln,_loc6_.@ui,_loc6_.@un,_loc6_.@rg,_loc6_.@vs,_loc6_.@ps,_loc6_.@dp,_loc6_.uc,_loc6_.@pc,"1","1","1",_loc6_.@dp);
                dispatchEvent(new Event(LEVEL_LOADED));
            }
            else
            {
                dispatchEvent(new Event(ID_NOT_FOUND));
            }
        }
        
        private function removeLoaderListeners() : void
        {
            this.loader.removeEventListener(Event.COMPLETE,this.levelDataLoaded);
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

