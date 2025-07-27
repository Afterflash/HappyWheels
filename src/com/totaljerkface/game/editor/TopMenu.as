package com.totaljerkface.game.editor
{
    import com.totaljerkface.game.Settings;
    import com.totaljerkface.game.editor.ui.CheckBox;
    import com.totaljerkface.game.editor.ui.GenericButton;
    import com.totaljerkface.game.editor.ui.ValueEvent;
    import com.totaljerkface.game.editor.ui.Window;
    import com.totaljerkface.game.menus.LevelDataObject;
    import flash.display.Sprite;
    import flash.display.StageDisplayState;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import gs.TweenLite;
    import gs.easing.Strong;

    [Embed(source="/_assets/assets.swf", symbol="symbol773")]
    public class TopMenu extends Sprite
    {
        public static const MENU_BUSY:String = "menubusy";

        public static const MENU_IDLE:String = "menuidle";

        public static const TEST_LEVEL:String = "testlevel";

        public static const CLEAR_STAGE:String = "clearstage";

        public static const GO_MAIN_MENU:String = "gomainmenu";

        public var bg:Sprite;

        public var menuText:Sprite;

        private var mainMenuButton:GenericButton;

        private var optionsButton:GenericButton;

        private var saveButton:GenericButton;

        private var loadButton:GenericButton;

        private var clearButton:GenericButton;

        private var testButton:GenericButton;

        private var helpCheck:CheckBox;

        private var debugCheck:CheckBox;

        private var fullScreenCheck:CheckBox;

        private var _help:Boolean;

        private var _useDebugDraw:Boolean;

        private var _useFullScreen:Boolean;

        private var bgWidth:int;

        private var bgHeight:int;

        private var hiddenY:int;

        private var edgePixels:int = 20;

        private var tweenTime:Number = 0.5;

        private var saveMenu:SaveMenu;

        private var loadMenu:LoadMenu;

        private var levelOptionsMenu:LevelOptionsMenu;

        private var promptSprite:PromptSprite;

        private var currentLevelDataObject:LevelDataObject;

        public var levelTested:Boolean;

        public function TopMenu()
        {
            super();
        }

        public function init():void
        {
            var _loc1_:int = 0;
            this._useFullScreen = stage.displayState == StageDisplayState.FULL_SCREEN_INTERACTIVE ? true : false;
            _loc1_ = 10;
            this.testButton = new GenericButton("Test Level >>", 16776805, 90, 0);
            this.testButton.x = 10;
            this.testButton.y = _loc1_;
            addChild(this.testButton);
            _loc1_ += 40;
            this.optionsButton = new GenericButton("Level Options", 16613761, 90);
            this.optionsButton.x = 10;
            this.optionsButton.y = _loc1_;
            addChild(this.optionsButton);
            _loc1_ += 30;
            this.saveButton = new GenericButton("Save Level", 4032711, 90);
            this.saveButton.x = 10;
            this.saveButton.y = _loc1_;
            addChild(this.saveButton);
            _loc1_ += 30;
            this.loadButton = new GenericButton("Load Level", 4032711, 90);
            this.loadButton.x = 10;
            this.loadButton.y = _loc1_;
            addChild(this.loadButton);
            _loc1_ += 30;
            this.clearButton = new GenericButton("New Level", 4032711, 90);
            this.clearButton.x = 10;
            this.clearButton.y = _loc1_;
            addChild(this.clearButton);
            _loc1_ += 30;
            this.helpCheck = new CheckBox("show help", "help");
            this.helpCheck.x = 10;
            this.helpCheck.y = _loc1_;
            addChild(this.helpCheck);
            _loc1_ += 25;
            this.debugCheck = new CheckBox("debug draw", "useDebugDraw", false);
            this.debugCheck.x = 10;
            this.debugCheck.y = _loc1_;
            this.debugCheck.helpCaption = "Debug draw shows all physics shapes and joints when testing your level.";
            addChild(this.debugCheck);
            _loc1_ += 25;
            this.fullScreenCheck = new CheckBox("fullscreen", "useFullScreen", this._useFullScreen);
            this.fullScreenCheck.x = 10;
            this.fullScreenCheck.y = _loc1_;
            this.fullScreenCheck.helpCaption = "Fullscreen mode may not function with older flash plugins. Performance may be greatly reduced when using fullscreen mode. Non-vector graphics will appear pixelated due to scaling up. The only blood setting that will look as intended will be setting 2, which is rendered in vector. Press escape at any time to exit fullscreen mode.";
            addChild(this.fullScreenCheck);
            _loc1_ += 30;
            this.mainMenuButton = new GenericButton("<< Main Menu", 16613761, 90);
            this.mainMenuButton.x = 10;
            this.mainMenuButton.y = _loc1_;
            addChild(this.mainMenuButton);
            this.bgWidth = this.bg.width;
            this.bgHeight = this.bg.height;
            this.hiddenY = this.edgePixels - this.bgHeight;
            x = 10;
            y = this.hiddenY;
            addEventListener(MouseEvent.ROLL_OVER, this.rollOverHandler);
            addEventListener(MouseEvent.ROLL_OUT, this.rollOutHandler);
            this.testButton.addEventListener(MouseEvent.MOUSE_UP, this.testLevel);
            this.mainMenuButton.addEventListener(MouseEvent.MOUSE_UP, this.mainMenuPress);
            this.clearButton.addEventListener(MouseEvent.MOUSE_UP, this.clearPress);
            this.optionsButton.addEventListener(MouseEvent.MOUSE_UP, this.openOptionsMenu);
            this.helpCheck.addEventListener(ValueEvent.VALUE_CHANGE, this.helpToggle);
            this.debugCheck.addEventListener(ValueEvent.VALUE_CHANGE, this.debugToggle);
            this.fullScreenCheck.addEventListener(ValueEvent.VALUE_CHANGE, this.fullScreenToggle);
            HelpWindow.instance.addEventListener(Window.WINDOW_CLOSED, this.helpClosed);
            if (Settings.user_id > 0)
            {
                this.saveButton.addEventListener(MouseEvent.MOUSE_UP, this.openSaveMenu);
                this.loadButton.addEventListener(MouseEvent.MOUSE_UP, this.openLoadMenu);
            }
            else
            {
                this.saveButton.addEventListener(MouseEvent.MOUSE_UP, this.openLoginWarning);
                this.loadButton.addEventListener(MouseEvent.MOUSE_UP, this.openLoginWarning);
            }
        }

        private function rollOverHandler(param1:MouseEvent):void
        {
            if (parent)
            {
                parent.addChild(this);
            }
            TweenLite.to(this, this.tweenTime, {
                        "y": 0,
                        "ease": Strong.easeInOut
                    });
            TweenLite.to(this.menuText, this.tweenTime, {
                        "alpha": 0,
                        "ease": Strong.easeInOut
                    });
        }

        private function rollOutHandler(param1:MouseEvent):void
        {
            TweenLite.to(this, this.tweenTime, {
                        "y": this.hiddenY,
                        "ease": Strong.easeInOut
                    });
            TweenLite.to(this.menuText, this.tweenTime, {
                        "alpha": 1,
                        "ease": Strong.easeInOut
                    });
        }

        private function get help():Boolean
        {
            return this._help;
        }

        private function set help(param1:Boolean):void
        {
            this._help = param1;
        }

        private function get useDebugDraw():Boolean
        {
            return this._useDebugDraw;
        }

        private function set useFullScreen(param1:Boolean):void
        {
            this._useFullScreen = param1;
            if (param1)
            {
                stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
            }
            else
            {
                stage.displayState = StageDisplayState.NORMAL;
            }
        }

        private function get useFullScreen():Boolean
        {
            return this._useFullScreen;
        }

        private function set useDebugDraw(param1:Boolean):void
        {
            this._useDebugDraw = param1;
        }

        private function testLevel(param1:MouseEvent):void
        {
            dispatchEvent(new Event(TEST_LEVEL));
        }

        private function openLoginWarning(param1:MouseEvent):void
        {
            this.openPrompt("WHAT THE HELL<br>ARE YOU DOING?<br>You must be logged in to save and load levels.", "oh ok");
        }

        private function openPrompt(param1:String, param2:String):void
        {
            dispatchEvent(new Event(MENU_BUSY));
            this.promptSprite = new PromptSprite(param1, param2);
            var _loc3_:Window = this.promptSprite.window;
            parent.addChild(_loc3_);
            _loc3_.center();
            this.promptSprite.addEventListener(PromptSprite.BUTTON_PRESSED, this.promptSpriteClosed);
        }

        private function promptSpriteClosed(param1:Event):void
        {
            this.promptSprite.removeEventListener(PromptSprite.BUTTON_PRESSED, this.promptSpriteClosed);
            this.promptSprite = null;
            dispatchEvent(new Event(MENU_IDLE));
        }

        private function openOptionsMenu(param1:MouseEvent):void
        {
            if (this.levelOptionsMenu)
            {
                return;
            }
            this.levelOptionsMenu = new LevelOptionsMenu();
            var _loc2_:Window = this.levelOptionsMenu.window;
            parent.addChild(_loc2_);
            _loc2_.center();
            this.levelOptionsMenu.addEventListener(Window.WINDOW_CLOSED, this.closeOptionsMenu);
        }

        private function closeOptionsMenu(param1:Event = null):void
        {
            this.levelOptionsMenu.removeEventListener(Window.WINDOW_CLOSED, this.closeOptionsMenu);
            this.levelOptionsMenu.die();
            this.levelOptionsMenu = null;
        }

        private function openSaveMenu(param1:MouseEvent):void
        {
            if (!this.levelTested)
            {
                this.openPrompt("Please test your level before saving.", "ok");
                return;
            }
            if (this.saveMenu)
            {
                return;
            }
            if (this.loadMenu)
            {
                this.closeLoadMenu();
            }
            dispatchEvent(new Event(MENU_BUSY));
            this.saveMenu = new SaveMenu(this.currentLevelDataObject);
            var _loc2_:Window = this.saveMenu.window;
            parent.addChild(_loc2_);
            _loc2_.center();
            this.saveMenu.addEventListener(SaveMenu.SAVE_NEW, this.saveNewLevel);
            this.saveMenu.addEventListener(SaveMenu.SAVE_OVER, this.saveOverLevel);
            this.saveMenu.addEventListener(Window.WINDOW_CLOSED, this.closeSaveMenu);
        }

        private function openLoadMenu(param1:MouseEvent):void
        {
            if (this.loadMenu)
            {
                return;
            }
            if (this.saveMenu)
            {
                this.closeSaveMenu();
            }
            dispatchEvent(new Event(MENU_BUSY));
            this.loadMenu = new LoadMenu();
            var _loc2_:Window = this.loadMenu.window;
            parent.addChild(_loc2_);
            _loc2_.center();
            this.loadMenu.addEventListener(LoadMenu.LOAD_SELECTED, this.loadLevel);
            this.loadMenu.addEventListener(LoadMenu.DELETE_SELECTED, this.deleteCheck);
            this.loadMenu.addEventListener(LoadMenu.IMPORT_DATA, this.importData);
            this.loadMenu.addEventListener(Window.WINDOW_CLOSED, this.closeLoadMenu);
        }

        private function closeSaveMenu(param1:Event = null):void
        {
            this.saveMenu.removeEventListener(SaveMenu.SAVE_NEW, this.saveNewLevel);
            this.saveMenu.removeEventListener(SaveMenu.SAVE_OVER, this.saveOverLevel);
            this.saveMenu.removeEventListener(Window.WINDOW_CLOSED, this.closeSaveMenu);
            this.saveMenu.die();
            this.saveMenu = null;
            dispatchEvent(new Event(MENU_IDLE));
        }

        private function closeLoadMenu(param1:Event = null):void
        {
            this.loadMenu.removeEventListener(LoadMenu.LOAD_SELECTED, this.loadLevel);
            this.loadMenu.removeEventListener(LoadMenu.DELETE_SELECTED, this.deleteCheck);
            this.loadMenu.removeEventListener(LoadMenu.IMPORT_DATA, this.importData);
            this.loadMenu.removeEventListener(Window.WINDOW_CLOSED, this.closeLoadMenu);
            this.loadMenu.die();
            this.loadMenu = null;
            dispatchEvent(new Event(MENU_IDLE));
        }

        private function saveNewLevel(param1:Event):void
        {
            trace("save new level");
            var _loc2_:String = this.saveMenu.levelName;
            var _loc3_:String = this.saveMenu.comments;
            this.closeSaveMenu();
            dispatchEvent(new Event(MENU_BUSY));
            var _loc4_:SaverLoader = SaverLoader.instance;
            _loc4_.addEventListener(SaverLoader.SAVE_COMPLETE, this.saveComplete);
            _loc4_.addEventListener(SaverLoader.GENERIC_ERROR, this.saveComplete);
            _loc4_.saveNewLevel(_loc2_, _loc3_);
        }

        private function saveOverLevel(param1:Event):void
        {
            trace("save over level");
            var _loc2_:String = this.saveMenu.levelName;
            var _loc3_:String = this.saveMenu.comments;
            this.closeSaveMenu();
            dispatchEvent(new Event(MENU_BUSY));
            var _loc4_:SaverLoader = SaverLoader.instance;
            _loc4_.addEventListener(SaverLoader.SAVE_COMPLETE, this.saveComplete);
            _loc4_.addEventListener(SaverLoader.GENERIC_ERROR, this.saveComplete);
            _loc4_.saveOverLevel(this.currentLevelDataObject.id, _loc2_, _loc3_);
        }

        private function saveComplete(param1:Event = null):void
        {
            var _loc3_:String = null;
            var _loc4_:ChoiceSprite = null;
            var _loc5_:Window = null;
            var _loc2_:SaverLoader = SaverLoader.instance;
            _loc2_.removeEventListener(SaverLoader.SAVE_COMPLETE, this.saveComplete);
            _loc2_.removeEventListener(SaverLoader.GENERIC_ERROR, this.saveComplete);
            if (param1.type == SaverLoader.SAVE_COMPLETE)
            {
                this.currentLevelDataObject = _loc2_.lastSavedData;
                _loc3_ = "Your level saved successfully.<br><br>Would you like to publish<br>your level now?<br><br>";
                _loc4_ = new ChoiceSprite(_loc3_, ">> Publish Level <<", "Not Yet!", true, 280, 120, 5162061, 16613761, 0);
                _loc5_ = _loc4_.window;
                parent.addChild(_loc5_);
                _loc5_.center();
                LoadMenu.levelDataArray = null;
                _loc4_.addEventListener(ChoiceSprite.ANSWER_CHOSEN, this.publishChoiceSelected, false, 0, true);
                _loc4_.answer1Btn.helpString = "When published, a level will be submitted to the public user level browser. Once a level is published, its contents cannot be altered, so make sure everything is exactly as you\'d like it before hitting this button. You may publish one level per 24 hours.";
                return;
            }
            dispatchEvent(new Event(MENU_IDLE));
        }

        private function publishChoiceSelected(param1:Event):void
        {
            var _loc4_:SaverLoader = null;
            var _loc2_:ChoiceSprite = param1.target as ChoiceSprite;
            _loc2_.removeEventListener(ChoiceSprite.ANSWER_CHOSEN, this.publishChoiceSelected);
            var _loc3_:int = _loc2_.index;
            _loc2_.die();
            if (_loc3_ == 0)
            {
                _loc4_ = SaverLoader.instance;
                _loc4_.addEventListener(SaverLoader.PUBLISH_COMPLETE, this.publishComplete);
                _loc4_.addEventListener(SaverLoader.GENERIC_ERROR, this.publishComplete);
                _loc4_.publishLevel(this.currentLevelDataObject.id);
                return;
            }
            dispatchEvent(new Event(MENU_IDLE));
        }

        private function publishComplete(param1:Event):void
        {
            var _loc2_:SaverLoader = SaverLoader.instance;
            _loc2_.removeEventListener(SaverLoader.PUBLISH_COMPLETE, this.publishComplete);
            _loc2_.removeEventListener(SaverLoader.GENERIC_ERROR, this.publishComplete);
            if (param1.type == SaverLoader.PUBLISH_COMPLETE)
            {
                this.openPrompt("Your level was successfully published. It should appear in the user level browser momentarily.", "ok");
                LoadMenu.levelDataArray = null;
                return;
            }
            dispatchEvent(new Event(MENU_IDLE));
        }

        private function loadLevel(param1:Event):void
        {
            trace("load level");
            this.currentLevelDataObject = this.loadMenu.currentLevelInfo;
            var _loc2_:int = this.currentLevelDataObject.id;
            this.closeLoadMenu();
            dispatchEvent(new Event(MENU_BUSY));
            var _loc3_:SaverLoader = SaverLoader.instance;
            _loc3_.addEventListener(SaverLoader.LOAD_COMPLETE, this.loadComplete);
            _loc3_.addEventListener(SaverLoader.GENERIC_ERROR, this.loadComplete);
            _loc3_.loadLevel(_loc2_);
        }

        public function importData(param1:Event):void
        {
            trace("load level");
            this.currentLevelDataObject = null;
            var _loc2_:XML = this.loadMenu.levelData;
            this.closeLoadMenu();
            var _loc3_:SaverLoader = SaverLoader.instance;
            if (_loc3_.checkStolen(_loc2_))
            {
                this.openPrompt("Invalid data.", "oh, ok");
            }
            else
            {
                _loc3_.importLevelData(_loc2_);
            }
        }

        public function importLevel(param1:int, param2:int):void
        {
            trace("importing level");
            dispatchEvent(new Event(MENU_BUSY));
            var _loc3_:SaverLoader = SaverLoader.instance;
            _loc3_.addEventListener(SaverLoader.LOAD_COMPLETE, this.loadComplete);
            _loc3_.addEventListener(SaverLoader.GENERIC_ERROR, this.loadComplete);
            _loc3_.loadLevel(param1, param2);
        }

        private function loadComplete(param1:Event):void
        {
            var _loc2_:SaverLoader = SaverLoader.instance;
            _loc2_.removeEventListener(SaverLoader.LOAD_COMPLETE, this.loadComplete);
            _loc2_.removeEventListener(SaverLoader.GENERIC_ERROR, this.loadComplete);
            if (param1.type != SaverLoader.LOAD_COMPLETE)
            {
                this.currentLevelDataObject = null;
            }
            dispatchEvent(new Event(MENU_IDLE));
        }

        private function deleteCheck(param1:Event):void
        {
            var _loc2_:ChoiceSprite = new ChoiceSprite("Are you sure you\'d like to delete this level?", "yes", "no");
            var _loc3_:Window = _loc2_.window;
            parent.addChild(_loc3_);
            _loc3_.center();
            _loc2_.addEventListener(ChoiceSprite.ANSWER_CHOSEN, this.deleteLevel, false, 0, true);
        }

        private function deleteLevel(param1:Event):void
        {
            var _loc2_:ChoiceSprite = param1.target as ChoiceSprite;
            _loc2_.removeEventListener(ChoiceSprite.ANSWER_CHOSEN, this.deleteLevel);
            var _loc3_:int = _loc2_.index;
            _loc2_.die();
            if (_loc3_ != 0)
            {
                return;
            }
            trace("delete level");
            this.currentLevelDataObject = this.loadMenu.currentLevelInfo;
            var _loc4_:int = this.currentLevelDataObject.id;
            var _loc5_:SaverLoader = SaverLoader.instance;
            _loc5_.addEventListener(SaverLoader.DELETE_COMPLETE, this.deleteComplete);
            _loc5_.addEventListener(SaverLoader.GENERIC_ERROR, this.deleteComplete);
            _loc5_.deleteLevel(_loc4_, this.currentLevelDataObject.isPublic);
        }

        private function deleteComplete(param1:Event):void
        {
            var _loc2_:SaverLoader = SaverLoader.instance;
            _loc2_.removeEventListener(SaverLoader.DELETE_COMPLETE, this.deleteComplete);
            _loc2_.removeEventListener(SaverLoader.GENERIC_ERROR, this.deleteComplete);
            if (param1.type == SaverLoader.DELETE_COMPLETE)
            {
                this.openPrompt("Your level was deleted.", "ok");
                this.loadMenu.loadLevels();
                return;
            }
        }

        private function mainMenuPress(param1:MouseEvent):void
        {
            var _loc2_:ChoiceSprite = new ChoiceSprite("Are you sure you\'d like to exit to the main menu?<br>Unsaved work will be lost<br>FOREVER.", "yes", "no");
            var _loc3_:Window = _loc2_.window;
            parent.addChild(_loc3_);
            _loc3_.center();
            _loc2_.addEventListener(ChoiceSprite.ANSWER_CHOSEN, this.mainMenuResult, false, 0, true);
            dispatchEvent(new Event(MENU_BUSY));
        }

        private function mainMenuResult(param1:Event):void
        {
            var _loc2_:ChoiceSprite = param1.target as ChoiceSprite;
            _loc2_.removeEventListener(ChoiceSprite.ANSWER_CHOSEN, this.mainMenuResult);
            var _loc3_:int = _loc2_.index;
            _loc2_.die();
            if (_loc3_ == 0)
            {
                dispatchEvent(new Event(GO_MAIN_MENU));
            }
            dispatchEvent(new Event(MENU_IDLE));
        }

        private function clearPress(param1:MouseEvent):void
        {
            var _loc2_:ChoiceSprite = new ChoiceSprite("Are you sure you\'d like to clear the stage?<br>This cannot be undone.", "yes", "no");
            var _loc3_:Window = _loc2_.window;
            parent.addChild(_loc3_);
            _loc3_.center();
            _loc2_.addEventListener(ChoiceSprite.ANSWER_CHOSEN, this.clearResult, false, 0, true);
            dispatchEvent(new Event(MENU_BUSY));
        }

        private function clearResult(param1:Event):void
        {
            var _loc2_:ChoiceSprite = param1.target as ChoiceSprite;
            _loc2_.removeEventListener(ChoiceSprite.ANSWER_CHOSEN, this.clearResult);
            var _loc3_:int = _loc2_.index;
            _loc2_.die();
            if (_loc3_ == 0)
            {
                this.currentLevelDataObject = null;
                dispatchEvent(new Event(CLEAR_STAGE));
            }
            dispatchEvent(new Event(MENU_IDLE));
        }

        private function helpToggle(param1:ValueEvent):void
        {
            if (HelpWindow.instance.window)
            {
                HelpWindow.instance.closeWindow();
            }
            else
            {
                HelpWindow.instance.createWindow();
                parent.addChild(HelpWindow.instance.window);
            }
        }

        private function helpClosed(param1:Event):void
        {
            this.helpCheck.setValue(false);
        }

        private function debugToggle(param1:ValueEvent):void
        {
            Settings.editorDebugDraw = param1.value;
            trace(this._useDebugDraw);
        }

        private function fullScreenToggle(param1:ValueEvent):void
        {
            this.useFullScreen = param1.value;
        }

        public function die():void
        {
            removeEventListener(MouseEvent.ROLL_OVER, this.rollOverHandler);
            removeEventListener(MouseEvent.ROLL_OUT, this.rollOutHandler);
            if (this.levelOptionsMenu)
            {
                this.closeOptionsMenu();
            }
            this.testButton.removeEventListener(MouseEvent.MOUSE_UP, this.testLevel);
            this.optionsButton.removeEventListener(MouseEvent.MOUSE_UP, this.openOptionsMenu);
            this.saveButton.removeEventListener(MouseEvent.MOUSE_UP, this.openSaveMenu);
            this.loadButton.removeEventListener(MouseEvent.MOUSE_UP, this.openLoadMenu);
            this.clearButton.removeEventListener(MouseEvent.MOUSE_UP, this.clearPress);
            this.mainMenuButton.removeEventListener(MouseEvent.MOUSE_UP, this.mainMenuPress);
            this.helpCheck.removeEventListener(ValueEvent.VALUE_CHANGE, this.helpToggle);
            HelpWindow.instance.removeEventListener(Window.WINDOW_CLOSED, this.helpClosed);
            this.saveButton.removeEventListener(MouseEvent.MOUSE_UP, this.openLoginWarning);
            this.loadButton.removeEventListener(MouseEvent.MOUSE_UP, this.openLoginWarning);
        }
    }
}
