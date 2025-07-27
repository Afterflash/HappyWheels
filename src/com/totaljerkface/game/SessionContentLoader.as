package com.totaljerkface.game
{
    import com.totaljerkface.game.editor.*;
    import com.totaljerkface.game.editor.specials.*;
    import com.totaljerkface.game.menus.LevelDataObject;
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;
    import flash.system.*;
    import flash.utils.*;
    
    public class SessionContentLoader extends EventDispatcher
    {
        private var userLevelLoader:UserLevelLoader;
        
        private var characterLoader:SwfLoader;
        
        private var levelLoader:SwfLoader;
        
        private var _replayData:ReplayData;
        
        private var _levelData:Sprite;
        
        private var _levelVersion:Number;
        
        private var _characterData:Sprite;
        
        private var _errorString:String;
        
        private var levelDataObject:LevelDataObject;
        
        private var replayId:int;
        
        private var characterIndex:int;
        
        private var incrementPlays:Boolean;
        
        public function SessionContentLoader(param1:LevelDataObject, param2:int, param3:int = -1, param4:Boolean = false)
        {
            super();
            this.levelDataObject = param1;
            this.replayId = param3;
            this.characterIndex = param2;
            this.incrementPlays = param4;
        }
        
        public function load() : void
        {
            this.loadData();
        }
        
        private function loadData() : void
        {
            if(this.replayId > 0)
            {
                this.userLevelLoader = new RecordLoader(this.replayId,this.levelDataObject.id,this.levelDataObject.author_id);
            }
            else
            {
                trace("loading level " + this.levelDataObject.id + " playcount = " + this.incrementPlays);
                this.userLevelLoader = new UserLevelLoader(this.levelDataObject.id,this.levelDataObject.author_id,this.incrementPlays);
            }
            this.userLevelLoader.addEventListener(Event.COMPLETE,this.dataLoaded);
            this.userLevelLoader.addEventListener(IOErrorEvent.IO_ERROR,this.IOErrorHandler);
            this.userLevelLoader.addEventListener(ErrorEvent.ERROR,this.loadErrorHandler);
            this.userLevelLoader.loadData();
        }
        
        private function dataLoaded(param1:Event) : void
        {
            var _loc2_:RecordLoader = null;
            var _loc3_:String = null;
            var _loc4_:* = null;
            this.userLevelLoader.removeEventListener(Event.COMPLETE,this.dataLoaded);
            this.userLevelLoader.removeEventListener(IOErrorEvent.IO_ERROR,this.IOErrorHandler);
            this.userLevelLoader.removeEventListener(ErrorEvent.ERROR,this.loadErrorHandler);
            if(this.userLevelLoader is RecordLoader)
            {
                _loc2_ = this.userLevelLoader as RecordLoader;
                this._replayData = new ReplayData();
                this._replayData.byteArray = _loc2_.replayByteArray;
            }
            if(this.levelDataObject.id != 1)
            {
                this._levelData = this.userLevelLoader.buildLevelSourceObject();
                this._levelVersion = this.userLevelLoader.levelVersion;
                this.loadCharacter();
            }
            else
            {
                Settings.hideVehicle = false;
                _loc3_ = Settings.useCompressedTextures ? "_cmp" : "";
                _loc4_ = Settings.pathPrefix + Settings.levelPath + "level" + this.levelDataObject.id + _loc3_ + ".swf";
                this.levelLoader = new SwfLoader(_loc4_);
                this.levelLoader.addEventListener(Event.COMPLETE,this.levelLoaded);
                this.levelLoader.loadSWF();
            }
        }
        
        private function IOErrorHandler(param1:Event) : void
        {
            trace("user level IO error");
            this.userLevelLoader.removeEventListener(Event.COMPLETE,this.dataLoaded);
            this.userLevelLoader.removeEventListener(IOErrorEvent.IO_ERROR,this.IOErrorHandler);
            this.userLevelLoader.removeEventListener(ErrorEvent.ERROR,this.loadErrorHandler);
            dispatchEvent(new Event(IOErrorEvent.IO_ERROR));
        }
        
        private function loadErrorHandler(param1:Event) : void
        {
            trace("user level load error");
            this.userLevelLoader.removeEventListener(Event.COMPLETE,this.dataLoaded);
            this.userLevelLoader.removeEventListener(IOErrorEvent.IO_ERROR,this.IOErrorHandler);
            this.userLevelLoader.removeEventListener(ErrorEvent.ERROR,this.loadErrorHandler);
            this._errorString = this.userLevelLoader.errorString;
            dispatchEvent(new Event(ErrorEvent.ERROR));
        }
        
        private function levelLoaded(param1:Event) : void
        {
            this.levelLoader.removeEventListener(Event.COMPLETE,this.levelLoaded);
            this.levelLoader.removeEventListener(IOErrorEvent.IO_ERROR,this.IOErrorHandler);
            this._levelData = this.levelLoader.swfContent["levelData"];
            this.levelLoader.unLoadSwf();
            this.loadCharacter();
        }
        
        private function loadCharacter() : void
        {
            trace("char index " + this.characterIndex);
            var _loc1_:* = Settings.pathPrefix + Settings.characterPath + "character" + this.characterIndex + ".swf";
            this.characterLoader = new SwfLoader(_loc1_);
            this.characterLoader.addEventListener(Event.COMPLETE,this.characterLoaded);
            this.characterLoader.addEventListener(IOErrorEvent.IO_ERROR,this.SWFIOErrorHandler);
            this.characterLoader.loadSWF();
        }
        
        private function SWFIOErrorHandler(param1:Event) : void
        {
            this.characterLoader.removeEventListener(Event.COMPLETE,this.characterLoaded);
            this.characterLoader.removeEventListener(IOErrorEvent.IO_ERROR,this.SWFIOErrorHandler);
            dispatchEvent(new Event(IOErrorEvent.IO_ERROR));
        }
        
        private function characterLoaded(param1:Event) : void
        {
            this.characterLoader.removeEventListener(Event.COMPLETE,this.characterLoaded);
            this._characterData = this.characterLoader.swfContent as Sprite;
            this.characterLoader.unLoadSwf();
            dispatchEvent(new Event(Event.COMPLETE));
        }
        
        public function get replayData() : ReplayData
        {
            return this._replayData;
        }
        
        public function get levelData() : Sprite
        {
            return this._levelData;
        }
        
        public function get levelVersion() : Number
        {
            return this._levelVersion;
        }
        
        public function get characterData() : Sprite
        {
            return this._characterData;
        }
        
        public function get errorString() : String
        {
            return this._errorString;
        }
    }
}

