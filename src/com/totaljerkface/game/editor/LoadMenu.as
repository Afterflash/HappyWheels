package com.totaljerkface.game.editor
{
    import com.totaljerkface.game.*;
    import com.totaljerkface.game.editor.ui.*;
    import com.totaljerkface.game.menus.*;
    import com.totaljerkface.game.utils.*;
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;
    import flash.text.*;

    [Embed(source="/_assets/assets.swf", symbol="symbol783")]
    public class LoadMenu extends Sprite
    {
        public static var levelDataArray:Array;

        public static const LOAD_SELECTED:String = "loadselected";

        public static const DELETE_SELECTED:String = "deleteselected";

        public static const IMPORT_DATA:String = "importdata";

        private static var windowX:Number = 30;

        private static var windowY:Number = 250;

        public var loaderText:TextField;

        public var errorText:TextField;

        public var listBg:Sprite;

        public var levelText:TextField;

        public var refreshButton:Sprite;

        private var loadButton:GenericButton;

        private var deleteButton:GenericButton;

        private var importButton:GenericButton;

        private var loader:URLLoader;

        private var levelList:Array;

        private var listMask:Sprite;

        private var listHolder:Sprite;

        private var list:Sprite;

        private var scroller:SpecialListScroller;

        private var disableSpin:Boolean;

        private var _leveldata:XML;

        private var _currentItem:LoadLevelItem;

        private var _window:Window;

        public function LoadMenu()
        {
            super();
            this.init();
        }

        private function init():void
        {
            this.loaderText.embedFonts = this.errorText.embedFonts = true;
            this.loadButton = new GenericButton("Load Level", 16613761, 200);
            this.loadButton.x = 20;
            this.loadButton.y = 260;
            addChild(this.loadButton);
            this.loadButton.addEventListener(MouseEvent.MOUSE_UP, this.loadSelected);
            this.deleteButton = new GenericButton("Delete Level", 16776805, 200, 0);
            this.deleteButton.x = 20;
            this.deleteButton.y = this.loadButton.y + 28;
            addChild(this.deleteButton);
            this.deleteButton.addEventListener(MouseEvent.MOUSE_UP, this.deleteSelected);
            this.importButton = new GenericButton("Import Level Data", 4032711, 200);
            this.importButton.x = 20;
            this.importButton.y = 408;
            addChild(this.importButton);
            this.importButton.addEventListener(MouseEvent.MOUSE_UP, this.importLevel);
            this.refreshButton.buttonMode = true;
            this.buildWindow();
            this._window.resize();
            if (levelDataArray)
            {
                this.refreshButton.addEventListener(MouseEvent.MOUSE_UP, this.loadLevels, false, 0, true);
                this.buildList();
            }
            else
            {
                this.loadLevels();
            }
        }

        public function loadLevels(param1:MouseEvent = null):void
        {
            this.clearList();
            this.refreshButton.removeEventListener(MouseEvent.MOUSE_UP, this.loadLevels);
            var _loc2_:URLRequest = new URLRequest(Settings.siteURL + "get_level.hw");
            _loc2_.method = URLRequestMethod.POST;
            var _loc3_:URLVariables = new URLVariables();
            _loc3_.action = "get_cmb_by_user";
            _loc2_.data = _loc3_;
            this.loader = new URLLoader();
            this.addLoaderListeners();
            this.loader.load(_loc2_);
            addEventListener(Event.ENTER_FRAME, this.spin, false, 0, true);
        }

        private function addLoaderListeners():void
        {
            this.loader.addEventListener(Event.COMPLETE, this.dataLoadComplete);
            this.loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.securityErrorHandler);
        }

        private function removeLoaderListeners():void
        {
            this.loader.removeEventListener(Event.COMPLETE, this.dataLoadComplete);
            this.loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, this.securityErrorHandler);
        }

        private function dataLoadComplete(param1:Event):void
        {
            var _loc2_:String = null;
            var _loc4_:PromptSprite = null;
            var _loc8_:int = 0;
            var _loc9_:Array = null;
            var _loc10_:Window = null;
            var _loc11_:XML = null;
            var _loc12_:LevelDataObject = null;
            this.removeLoaderListeners();
            this.disableSpin = true;
            _loc2_ = String(this.loader.data);
            var _loc3_:String = _loc2_.substr(0, 8);
            trace("dataString " + _loc3_);
            if (_loc3_.indexOf("<html>") > -1)
            {
                _loc4_ = new PromptSprite("There was an unexpected system Error", "oh");
            }
            else if (_loc3_.indexOf("failure") > -1)
            {
                _loc9_ = _loc2_.split(":");
                if (_loc9_[1] == "invalid_action")
                {
                    _loc4_ = new PromptSprite("An invalid action was passed (you really shouldn\'t ever be seeing this).", "ok");
                }
                else if (_loc9_[1] == "app_error")
                {
                    _loc4_ = new PromptSprite("Sorry, there was an application error. It was most likely database related. Please try again in a moment.", "ok");
                }
                else if (_loc9_[1] == "not_logged_in")
                {
                    _loc4_ = new PromptSprite("Sorry, you are no longer logged in.", "ok");
                }
                else
                {
                    _loc4_ = new PromptSprite("An unknown Error has occurred.", "oh");
                }
            }
            if (_loc4_)
            {
                _loc10_ = _loc4_.window;
                if (stage)
                {
                    stage.addChild(_loc10_);
                    _loc10_.center();
                }
                return;
            }
            _loc2_ = this.loader.data;
            var _loc5_:Array = _loc2_.split(":");
            if (_loc5_[0] == "failure")
            {
                trace("loading failure");
            }
            var _loc6_:XML = XML(this.loader.data);
            levelDataArray = new Array();
            var _loc7_:int = int(_loc6_.name_1.lvs.lv.length());
            trace("total private levels " + _loc7_);
            _loc8_ = 0;
            while (_loc8_ < _loc7_)
            {
                _loc11_ = _loc6_.name_1.lvs.lv[_loc8_];
                _loc12_ = new LevelDataObject(_loc11_.@id, _loc11_.@ln, _loc11_.@ui, _loc11_.@un, 0, 0, 0, _loc11_.@dc, _loc11_.uc, _loc11_.@pc, 0, 0, 0);
                levelDataArray.push(_loc12_);
                _loc8_++;
            }
            _loc7_ = int(_loc6_.published.lvs.lv.length());
            trace("total published levels " + _loc7_);
            _loc8_ = 0;
            while (_loc8_ < _loc7_)
            {
                _loc11_ = _loc6_.published.lvs.lv[_loc8_];
                _loc12_ = new LevelDataObject(_loc11_.@id, _loc11_.@ln, _loc11_.@ui, _loc11_.@un, 0, 0, 0, _loc11_.@dc, _loc11_.uc, _loc11_.@pc, 0, 0, 1);
                levelDataArray.push(_loc12_);
                _loc8_++;
            }
            this.loaderText.text = "" + levelDataArray.length + " total";
            this.buildList();
        }

        private function spin(param1:Event):void
        {
            this.refreshButton.rotation = (this.refreshButton.rotation + 15) % 360;
            if (this.refreshButton.rotation == 0 && this.disableSpin)
            {
                this.disableSpin = false;
                removeEventListener(Event.ENTER_FRAME, this.spin);
                this.refreshButton.addEventListener(MouseEvent.MOUSE_UP, this.loadLevels, false, 0, true);
            }
        }

        private function securityErrorHandler(param1:SecurityErrorEvent):void
        {
            trace(param1.text);
            this.removeLoaderListeners();
        }

        private function buildList():void
        {
            var _loc3_:LevelDataObject = null;
            var _loc4_:LoadLevelItem = null;
            this.levelList = new Array();
            this.list = new Sprite();
            this.listHolder = new Sprite();
            this.listMask = new Sprite();
            this.listMask.graphics.beginFill(16711680);
            this.listMask.graphics.drawRect(0, 0, this.listBg.width - 4, this.listBg.height - 4);
            this.listMask.graphics.endFill();
            this.listHolder.x = this.listMask.x = this.listBg.x + 2;
            this.listHolder.y = this.listMask.y = this.listBg.y + 2;
            this.listHolder.addChild(this.list);
            addChild(this.listHolder);
            addChild(this.listMask);
            this.listHolder.mask = this.listMask;
            var _loc1_:Number = 0;
            var _loc2_:int = 0;
            while (_loc2_ < levelDataArray.length)
            {
                _loc3_ = levelDataArray[_loc2_];
                _loc4_ = new LoadLevelItem(_loc3_.name);
                _loc4_.y = _loc1_;
                _loc1_ += _loc4_.height;
                this.list.addChild(_loc4_);
                this.levelList.push(_loc4_);
                _loc2_++;
            }
            this.list.addEventListener(MouseEvent.MOUSE_UP, this.mouseUpHandler);
            this.scroller = new SpecialListScroller(this.list, this.listMask, 22);
            addChild(this.scroller);
            this.scroller.y = this.listMask.y;
            this.scroller.x = this.listMask.x + this.listMask.width - 12;
        }

        private function clearList():void
        {
            if (this.list)
            {
                this.list.removeEventListener(MouseEvent.MOUSE_UP, this.mouseUpHandler);
            }
            if (this.listHolder)
            {
                removeChild(this.listHolder);
            }
            if (this.listMask)
            {
                removeChild(this.listMask);
            }
            if (this.scroller)
            {
                this.scroller.die();
                removeChild(this.scroller);
            }
            this._currentItem = null;
        }

        private function mouseUpHandler(param1:MouseEvent):void
        {
            var _loc2_:LoadLevelItem = null;
            if (param1.target is LoadLevelItem)
            {
                _loc2_ = param1.target as LoadLevelItem;
                this.currentItem = _loc2_;
            }
        }

        private function set currentItem(param1:LoadLevelItem):void
        {
            if (this._currentItem)
            {
                this._currentItem.selected = false;
            }
            this._currentItem = param1;
            this._currentItem.selected = true;
        }

        public function get currentLevelInfo():LevelDataObject
        {
            if (!this._currentItem)
            {
                return null;
            }
            var _loc1_:int = int(this.levelList.indexOf(this._currentItem));
            return levelDataArray[_loc1_];
        }

        private function loadSelected(param1:MouseEvent):void
        {
            if (!this._currentItem)
            {
                this.errorText.text = "Select a Level, you fool!";
                return;
            }
            dispatchEvent(new Event(LOAD_SELECTED));
        }

        private function deleteSelected(param1:MouseEvent):void
        {
            if (!this._currentItem)
            {
                this.errorText.text = "Select a Level, you fool!";
                return;
            }
            dispatchEvent(new Event(DELETE_SELECTED));
        }

        private function importLevel(param1:MouseEvent):void
        {
            this._leveldata = new XML(this.levelText.text);
            dispatchEvent(new Event(IMPORT_DATA));
        }

        public function get levelData():XML
        {
            return this._leveldata;
        }

        private function buildWindow():void
        {
            this._window = new Window(true, this, true);
            this._window.x = windowX;
            this._window.y = windowY;
            this._window.addEventListener(Window.WINDOW_CLOSED, this.windowClosed);
        }

        public function get window():Window
        {
            return this._window;
        }

        private function windowClosed(param1:Event):void
        {
            dispatchEvent(param1.clone());
        }

        public function die():void
        {
            this.loadButton.removeEventListener(MouseEvent.MOUSE_UP, this.loadSelected);
            this.importButton.removeEventListener(MouseEvent.MOUSE_UP, this.importLevel);
            this.refreshButton.removeEventListener(MouseEvent.MOUSE_UP, this.loadLevels);
            this.refreshButton.removeEventListener(Event.ENTER_FRAME, this.spin);
            if (this.list)
            {
                this.list.removeEventListener(MouseEvent.MOUSE_UP, this.mouseUpHandler);
            }
            this._window.removeEventListener(Window.WINDOW_CLOSED, this.windowClosed);
            this._window.closeWindow();
            if (this.loader)
            {
                this.removeLoaderListeners();
            }
            if (this.scroller)
            {
                this.scroller.die();
            }
        }
    }
}
