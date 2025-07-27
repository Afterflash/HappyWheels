package com.totaljerkface.game
{
    import com.kumokairo.mousewheel.BlastedMouseWheelBlock;
    import com.totaljerkface.game.editor.*;
    import com.totaljerkface.game.events.*;
    import com.totaljerkface.game.menus.*;
    import com.totaljerkface.game.particles.*;
    import com.totaljerkface.game.utils.*;
    import flash.display.*;
    import flash.events.*;
    import flash.external.ExternalInterface;
    import flash.net.*;
    import flash.system.*;
    import flash.text.*;
    import flash.utils.Dictionary;
    import flash.utils.Timer;

    public class HappyWheels extends Sprite
    {
        private var architectureTest:ArchitectureTest;

        private var mainMenu:MainMenu;

        private var editor:Editor;

        private var sessionController:SessionController;

        private var mouseHelper:MouseHelper;

        private var memoryTest:MemoryTest;

        private var borderCover:Sprite;

        private var _replayID:int;

        private var _levelID:int = 1;

        private var _userID:int = 0;

        private var _userName:String;

        private var _potato:String;

        private var _isMac:Boolean;

        private var _readOnly:Boolean;

        private var _preloadTimer:Timer;

        public function HappyWheels()
        {
            super();
            trace("parent: " + parent);
            if (parent)
            {
                this.init();
            }
        }

        public function init():void
        {
            trace("init");
            trace("ExternalInterface.available " + ExternalInterface.available);
            trace(root.loaderInfo.url);
            var _loc1_:String = root.loaderInfo.url;

            Settings.siteURL = "http://localhost:8080/";
            Settings.pathPrefix = "./";
            if (ExternalInterface.available)
            {
                BlastedMouseWheelBlock.initialize(stage, "happyswf");
            }
            trace("readOnly " + this._readOnly);
            if (this._readOnly)
            {
                Settings.disableUpload = true;
            }
            this.createDebugText();
            this.createBorderCover();
            this.beginArchitectureTest();
            return;
        }

        public function get levelID():int
        {
            return this._levelID;
        }

        public function set levelID(param1:int):void
        {
            this._levelID = param1;
        }

        public function get replayID():int
        {
            return this._replayID;
        }

        public function set replayID(param1:int):void
        {
            this._replayID = param1;
        }

        public function get userID():int
        {
            return this._userID;
        }

        public function set userID(param1:int):void
        {
            this._userID = param1;
        }

        public function get userName():String
        {
            return this._userName;
        }

        public function set userName(param1:String):void
        {
            this._userName = param1;
        }

        public function get isMac():Boolean
        {
            return this._isMac;
        }

        public function set isMac(param1:Boolean):void
        {
            this._isMac = param1;
        }

        public function get readOnly():Boolean
        {
            return this._readOnly;
        }

        public function set readOnly(param1:Boolean):void
        {
            this._readOnly = param1;
        }

        public function get potato():String
        {
            return this._potato;
        }

        public function set potato(param1:String):void
        {
            this._potato = param1;
        }

        public function get preloadTimer():Timer
        {
            return this._preloadTimer;
        }

        public function set preloadTimer(param1:Timer):void
        {
            this._preloadTimer = param1;
        }

        private function beginArchitectureTest():void
        {
            this.architectureTest = new ArchitectureTest();
            this.architectureTest.addEventListener(Event.COMPLETE, this.testComplete);
            this.architectureTest.test();
        }

        private function testComplete(param1:Event):void
        {
            var _loc3_:* = undefined;
            trace("test result = " + this.architectureTest.result);
            Settings.architecture = this.architectureTest.result;
            var _loc2_:SharedObject = Settings.sharedObject = SharedObject.getLocal("options135");
            if (_loc2_.data["keyCodes"])
            {
                Settings.accelerateCode = _loc2_.data["keyCodes"]["accelerateCode"];
                Settings.decelerateCode = _loc2_.data["keyCodes"]["decelerateCode"];
                Settings.leanForwardCode = _loc2_.data["keyCodes"]["leanForwardCode"];
                Settings.leanBackCode = _loc2_.data["keyCodes"]["leanBackCode"];
                Settings.primaryActionCode = _loc2_.data["keyCodes"]["primaryActionCode"];
                Settings.secondaryAction1Code = _loc2_.data["keyCodes"]["secondaryAction1Code"];
                Settings.secondaryAction2Code = _loc2_.data["keyCodes"]["secondaryAction2Code"];
                Settings.ejectCode = _loc2_.data["keyCodes"]["ejectCode"];
                Settings.switchCameraCode = _loc2_.data["keyCodes"]["switchCameraCode"];
            }
            else
            {
                _loc2_.data["keyCodes"] = new Dictionary();
                _loc2_.data["keyCodes"]["accelerateCode"] = Settings.accelerateDefaultCode;
                _loc2_.data["keyCodes"]["decelerateCode"] = Settings.decelerateDefaultCode;
                _loc2_.data["keyCodes"]["leanForwardCode"] = Settings.leanForwardDefaultCode;
                _loc2_.data["keyCodes"]["leanBackCode"] = Settings.leanBackDefaultCode;
                _loc2_.data["keyCodes"]["primaryActionCode"] = Settings.primaryActionDefaultCode;
                _loc2_.data["keyCodes"]["secondaryAction1Code"] = Settings.secondaryAction1DefaultCode;
                _loc2_.data["keyCodes"]["secondaryAction2Code"] = Settings.secondaryAction2DefaultCode;
                _loc2_.data["keyCodes"]["ejectCode"] = Settings.ejectDefaultCode;
                _loc2_.data["keyCodes"]["switchCameraCode"] = Settings.switchCameraDefaultCode;
            }
            for (_loc3_ in _loc2_.data)
            {
                trace(_loc3_ + ": " + _loc2_.data[_loc3_]);
            }
            if (_loc2_.data["quality"] != undefined)
            {
                stage.quality = _loc2_.data["quality"];
            }
            if (_loc2_.data["smoothing"] != undefined)
            {
                Settings.smoothing = _loc2_.data["smoothing"];
            }
            if (_loc2_.data["compressed"] != undefined)
            {
                Settings.useCompressedTextures = _loc2_.data["compressed"];
            }
            if (_loc2_.data["maxParticles"] != undefined)
            {
                ParticleController.maxParticles = _loc2_.data["maxParticles"];
            }
            if (_loc2_.data["bloodSetting"] != undefined)
            {
                Settings.bloodSetting = _loc2_.data["bloodSetting"];
            }
            this.mouseHelper = new MouseHelper();
            addChild(this.mouseHelper);
            var _loc4_:BitmapManager = new BitmapManager();
            var _loc5_:MemoryTest = new MemoryTest();
            this.loadSounds();
        }

        private function createDebugText():void
        {
            var _loc1_:DebugText = Settings.debugText = new DebugText();
            addChild(_loc1_);
            if (Settings.hideHUD)
            {
                _loc1_.visible = false;
            }
        }

        private function createBorderCover():void
        {
            this.borderCover = new Sprite();
            stage.addChild(this.borderCover);
            var _loc1_:Vector.<int> = new Vector.<int>();
            var _loc2_:Vector.<Number> = new Vector.<Number>();
            this.borderCover.graphics.beginFill(0, 1);
            var _loc3_:int = 900;
            var _loc4_:int = 500;
            var _loc5_:int = 500;
            _loc2_.push(0 - _loc5_, 0 - _loc5_);
            _loc2_.push(_loc3_ + _loc5_, 0 - _loc5_);
            _loc2_.push(_loc3_ + _loc5_, _loc4_ + _loc5_);
            _loc2_.push(0 - _loc5_, _loc4_ + _loc5_);
            _loc2_.push(0 - _loc5_, 0 - _loc5_);
            _loc1_.push(GraphicsPathCommand.MOVE_TO);
            _loc1_.push(GraphicsPathCommand.LINE_TO);
            _loc1_.push(GraphicsPathCommand.LINE_TO);
            _loc1_.push(GraphicsPathCommand.LINE_TO);
            _loc1_.push(GraphicsPathCommand.LINE_TO);
            _loc2_.push(0, 0);
            _loc2_.push(0, _loc4_);
            _loc2_.push(_loc3_, _loc4_);
            _loc2_.push(_loc3_, 0);
            _loc2_.push(0, 0);
            _loc1_.push(GraphicsPathCommand.MOVE_TO);
            _loc1_.push(GraphicsPathCommand.LINE_TO);
            _loc1_.push(GraphicsPathCommand.LINE_TO);
            _loc1_.push(GraphicsPathCommand.LINE_TO);
            _loc1_.push(GraphicsPathCommand.LINE_TO);
            this.borderCover.graphics.drawPath(_loc1_, _loc2_, GraphicsPathWinding.NON_ZERO);
            this.borderCover.graphics.endFill();
        }

        private function loadSounds():void
        {
            trace("Loading Sound");
            var _loc1_:SoundLoader = new SoundLoader();
            addChild(_loc1_);
            _loc1_.addEventListener(Event.COMPLETE, this.soundLoaded);
            _loc1_.loadSound(this._potato);
        }

        private function soundLoaded(param1:Event):void
        {
            var _loc3_:LevelLoader = null;
            var _loc4_:ReplayLoader = null;
            trace("Sound Loaded");
            var _loc2_:SoundLoader = param1.target as SoundLoader;
            _loc2_.removeEventListener(Event.COMPLETE, this.soundLoaded);
            removeChild(_loc2_);
            if (this._userID > 0)
            {
                Settings.user_id = this._userID;
                Settings.username = this._userName;
            }
            trace("levelID = " + this._levelID);
            trace("replayID = " + this._replayID);
            if (this._preloadTimer)
            {
                Tracker.trackEvent(Tracker.PRELOADER, Tracker.LOAD_COMPLETE, "userID_" + this._userID, this.preloadTimer.currentCount);
                this._preloadTimer.stop();
                this._preloadTimer = null;
            }
            if (this._levelID)
            {
                _loc3_ = new LevelLoader();
                _loc3_.addEventListener(LevelLoader.LEVEL_LOADED, this.levelLoadComplete);
                _loc3_.addEventListener(LevelLoader.ID_NOT_FOUND, this.levelLoadComplete);
                _loc3_.addEventListener(LevelLoader.LOAD_ERROR, this.levelLoadComplete);
                _loc3_.load(this._levelID);
            }
            else if (this._replayID)
            {
                _loc4_ = new ReplayLoader();
                _loc4_.addEventListener(ReplayLoader.REPLAY_AND_LEVEL_LOADED, this.replayLoadComplete);
                _loc4_.addEventListener(ReplayLoader.ID_NOT_FOUND, this.replayLoadComplete);
                _loc4_.addEventListener(ReplayLoader.LOAD_ERROR, this.replayLoadComplete);
                _loc4_.load(this._replayID);
            }
            else
            {
                this.openMainMenu();
            }
        }

        private function levelLoadComplete(param1:Event):void
        {
            var _loc2_:LevelLoader = param1.target as LevelLoader;
            _loc2_.removeEventListener(LevelLoader.LEVEL_LOADED, this.levelLoadComplete);
            _loc2_.removeEventListener(LevelLoader.ID_NOT_FOUND, this.levelLoadComplete);
            _loc2_.removeEventListener(LevelLoader.LOAD_ERROR, this.levelLoadComplete);
            _loc2_.die();
            if (param1.type == LevelLoader.ID_NOT_FOUND || param1.type == LevelLoader.LOAD_ERROR)
            {
                this.openMainMenu();
            }
            else
            {
                MainMenu.setCurrentMenu(MainMenu.LEVEL_BROWSER);
                LevelBrowser.importLevelDataArray([_loc2_.levelDataObject]);
                this.openSessionController(_loc2_.levelDataObject, null);
            }
        }

        private function replayLoadComplete(param1:Event):void
        {
            var _loc2_:ReplayLoader = param1.target as ReplayLoader;
            _loc2_.removeEventListener(ReplayLoader.REPLAY_AND_LEVEL_LOADED, this.replayLoadComplete);
            _loc2_.removeEventListener(ReplayLoader.ID_NOT_FOUND, this.replayLoadComplete);
            _loc2_.removeEventListener(ReplayLoader.LOAD_ERROR, this.replayLoadComplete);
            _loc2_.die();
            if (param1.type == ReplayLoader.ID_NOT_FOUND)
            {
                this.openMainMenu();
            }
            else
            {
                MainMenu.setCurrentMenu(MainMenu.REPLAY_BROWSER);
                LevelBrowser.importLevelDataArray([_loc2_.levelDataObject]);
                ReplayBrowser.importReplayDataArray([_loc2_.replayDataObject], _loc2_.levelDataObject);
                this.openSessionController(_loc2_.levelDataObject, _loc2_.replayDataObject);
            }
        }

        private function openMainMenu():void
        {
            trace("OPEN MAIN MENU");
            this.mainMenu = new MainMenu();
            addChildAt(this.mainMenu, 0);
            this.mainMenu.init();
            this.mainMenu.addEventListener(NavigationEvent.EDITOR, this.openEditor);
            this.mainMenu.addEventListener(NavigationEvent.SESSION, this.receiveSessionFromMainMenu);
        }

        private function closeMainMenu():void
        {
            if (!this.mainMenu)
            {
                return;
            }
            this.mainMenu.die();
            removeChild(this.mainMenu);
            this.mainMenu.removeEventListener(NavigationEvent.EDITOR, this.openEditor);
            this.mainMenu.removeEventListener(NavigationEvent.SESSION, this.receiveSessionFromMainMenu);
            this.mainMenu = null;
        }

        private function openEditor(param1:NavigationEvent):void
        {
            var _loc2_:Object = null;
            var _loc3_:LevelDataObject = null;
            this.closeMainMenu();
            if (param1.levelDataObject)
            {
                _loc3_ = param1.levelDataObject;
            }
            this.editor = new Editor(_loc3_);
            addChildAt(this.editor, 0);
            this.editor.init();
            this.editor.addEventListener(NavigationEvent.MAIN_MENU, this.closeEditor);
        }

        private function closeEditor(param1:NavigationEvent):void
        {
            this.editor.die();
            removeChild(this.editor);
            this.editor.removeEventListener(NavigationEvent.MAIN_MENU, this.closeEditor);
            this.editor = null;
            this.openMainMenu();
        }

        private function openSessionController(param1:LevelDataObject, param2:ReplayDataObject = null):void
        {
            this.sessionController = new SessionController(this, param1, param2);
            this.sessionController.addEventListener(NavigationEvent.MAIN_MENU, this.closeSessionController);
            this.sessionController.begin();
        }

        private function closeSessionController(param1:NavigationEvent = null):void
        {
            this.sessionController.die();
            this.sessionController.removeEventListener(NavigationEvent.MAIN_MENU, this.closeSessionController);
            this.sessionController = null;
            this.openMainMenu();
        }

        private function receiveSessionFromMainMenu(param1:NavigationEvent):void
        {
            trace("session received");
            this.closeMainMenu();
            this.openSessionController(param1.levelDataObject, param1.replayDataObject);
        }
    }
}
