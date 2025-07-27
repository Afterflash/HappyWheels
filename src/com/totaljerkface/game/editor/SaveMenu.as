package com.totaljerkface.game.editor
{
    import com.totaljerkface.game.Settings;
    import com.totaljerkface.game.editor.ui.*;
    import com.totaljerkface.game.menus.CreditsLink;
    import com.totaljerkface.game.menus.LevelDataObject;
    import com.totaljerkface.game.utils.BadWords;
    import com.totaljerkface.game.utils.TextUtils;
    import com.totaljerkface.game.utils.Tracker;
    import flash.display.*;
    import flash.events.*;
    import flash.geom.ColorTransform;
    import flash.system.*;
    import flash.text.*;

    [Embed(source="/_assets/assets.swf", symbol="symbol744")]
    public class SaveMenu extends Sprite
    {
        public static const SAVE_NEW:String = "savenew";

        public static const SAVE_OVER:String = "saveover";

        private static var windowX:Number = 30;

        private static var windowY:Number = 250;

        public var nameText:TextField;

        public var commentsText:TextField;

        public var nCharsText:TextField;

        public var cCharsText:TextField;

        public var levelText:TextField;

        private var saveNewButton:GenericButton;

        private var saveOverwriteButton:GenericButton;

        private var copyLevelButton:GenericButton;

        private var _window:Window;

        private var maxNameChars:int = 20;

        private var minNameChars:int = 4;

        private var maxCommentChars:int = 255;

        private var levelDataObject:LevelDataObject;

        private var errorPrompt:PromptSprite;

        private var rulesSprite:Sprite;

        private var _allowPublishing:Boolean;

        public function SaveMenu(param1:LevelDataObject = null)
        {
            super();
            this.levelDataObject = param1;
            this.init();
        }

        private function init():void
        {
            var _loc2_:TextField = null;
            this.nameText.autoSize = this.commentsText.autoSize = TextFieldAutoSize.NONE;
            this.nameText.selectable = this.commentsText.selectable = true;
            this.nCharsText.selectable = this.cCharsText.selectable = false;
            this.nameText.embedFonts = this.commentsText.embedFonts = this.nCharsText.embedFonts = this.cCharsText.embedFonts = true;
            this.commentsText.wordWrap = true;
            this.nameText.multiline = false;
            this.commentsText.multiline = true;
            this.nameText.maxChars = this.maxNameChars;
            this.commentsText.maxChars = this.maxCommentChars;
            this.commentsText.restrict = this.nameText.restrict = "a-z A-Z 0-9 !@#$%\\^&*()_+\\-=;\'|?/,.<> \"";
            addEventListener(Event.ENTER_FRAME, this.setCharText);
            var _loc1_:TextFormat = new TextFormat("HelveticaNeueLT Std", 11, 4032711, null, null, null, null, null, TextFormatAlign.LEFT);
            _loc2_ = new TextField();
            _loc2_.defaultTextFormat = _loc1_;
            _loc2_.maxChars = 6;
            _loc2_.width = 196;
            _loc2_.height = 20;
            _loc2_.multiline = false;
            _loc2_.selectable = false;
            _loc2_.embedFonts = true;
            _loc2_.antiAliasType = AntiAliasType.ADVANCED;
            _loc2_.text = "Read these rules and follow them!";
            this.rulesSprite = new Sprite();
            this.rulesSprite.buttonMode = true;
            this.rulesSprite.x = 20;
            this.rulesSprite.y = 190;
            this.rulesSprite.addChild(_loc2_);
            addChild(this.rulesSprite);
            var _loc3_:CreditsLink = new CreditsLink(this.rulesSprite, "level_rules.php");
            _loc3_.colorTransform = new ColorTransform(0.71, 0.71, 0.71, 1, 0, 0, 0, 0);
            this.saveNewButton = new GenericButton("Save New Level", 16613761, 200);
            this.saveNewButton.x = 20;
            this.saveNewButton.y = 215;
            addChild(this.saveNewButton);
            this.saveNewButton.addEventListener(MouseEvent.MOUSE_UP, this.savePressHandler);
            this.saveNewButton.addEventListener(MouseEvent.ROLL_OVER, this.rollOverHandler);
            if (this.levelDataObject)
            {
                if (!this.levelDataObject.isPublic)
                {
                    this.saveOverwriteButton = new GenericButton("Overwrite Current Level", 16613761, 200);
                    this.saveOverwriteButton.x = 20;
                    this.saveOverwriteButton.y = this.saveNewButton.y + 28;
                    addChild(this.saveOverwriteButton);
                    this.saveOverwriteButton.addEventListener(MouseEvent.MOUSE_UP, this.savePressHandler);
                    this.saveOverwriteButton.addEventListener(MouseEvent.ROLL_OVER, this.rollOverHandler);
                    this.levelName = this.levelDataObject.name;
                    this.comments = this.levelDataObject.comments;
                }
            }
            this.copyLevelButton = new GenericButton("Copy Leveldata to Clipboard", 4032711, 200);
            this.copyLevelButton.x = 20;
            this.copyLevelButton.y = this.levelText.y + 58;
            addChild(this.copyLevelButton);
            this.copyLevelButton.addEventListener(MouseEvent.MOUSE_UP, this.copyLevelText);
            this.copyLevelButton.addEventListener(MouseEvent.ROLL_OVER, this.rollOverHandler);
            this.levelText.text = SaverLoader.instance.createXML(true).toXMLString();
            this.levelText.addEventListener(MouseEvent.MOUSE_DOWN, this.mouseDownTextHandler);
            this.buildWindow();
            this._window.resize();
        }

        private function buildWindow():void
        {
            this._window = new Window(true, this, true);
            this._window.x = windowX;
            this._window.y = windowY;
            this._window.addEventListener(Window.WINDOW_CLOSED, this.windowClosed);
        }

        private function inputValueChange(param1:ValueEvent):void
        {
            var _loc2_:InputObject = param1.inputObject;
            var _loc3_:String = _loc2_.attribute;
            this[_loc3_] = param1.value;
        }

        public function get window():Window
        {
            return this._window;
        }

        private function windowClosed(param1:Event):void
        {
            dispatchEvent(param1.clone());
        }

        public function get levelName():String
        {
            return this.nameText.text;
        }

        public function set levelName(param1:String):void
        {
            this.nameText.text = param1;
        }

        public function get comments():String
        {
            return this.commentsText.text;
        }

        public function set comments(param1:String):void
        {
            this.commentsText.text = param1;
        }

        private function setCharText(param1:Event):void
        {
            var _loc2_:int = this.maxNameChars - this.nameText.length;
            this.nCharsText.text = String(_loc2_) + " chars left";
            _loc2_ = this.maxCommentChars - this.commentsText.length;
            this.cCharsText.text = String(_loc2_) + " chars left";
        }

        private function rollOverHandler(param1:MouseEvent):void
        {
            switch (param1.target)
            {
                case this.saveNewButton:
                    MouseHelper.instance.show("Your saved levels can only be accessed by you until you publish them.<br><br>You must save a level before publishing it.", this.saveNewButton);
                    break;
                case this.saveOverwriteButton:
                    MouseHelper.instance.show("You may only overwrite non-published levels. If you\'d like to alter a published level, you must load it in the editor and save it as a new level.", this.saveOverwriteButton);
                    break;
                case this.copyLevelButton:
                    MouseHelper.instance.show("Copy your level as text, and paste it in a text file or email.  This way, if the site is running like shit and fails to save, you can have a local copy of your level and try saving it again later.  You can import this data into the editor through the load menu.", this.copyLevelButton);
            }
        }

        private function savePressHandler(param1:MouseEvent):void
        {
            var _loc2_:Event = null;
            var _loc3_:Window = null;
            switch (param1.target)
            {
                case this.saveNewButton:
                    if (this.levelDataObject)
                    {
                        if (this.levelName == this.levelDataObject.name)
                        {
                            this.errorPrompt = new PromptSprite("You should save your new level with a new name.", "ok");
                            _loc3_ = this.errorPrompt.window;
                            stage.addChild(_loc3_);
                            _loc3_.center();
                            return;
                        }
                    }
                    this.levelName = TextUtils.trimWhitespace(this.levelName);
                    if (this.levelName.length < this.minNameChars)
                    {
                        this.errorPrompt = new PromptSprite("Level name must be at least 4 characters.", "ok");
                        _loc3_ = this.errorPrompt.window;
                        stage.addChild(_loc3_);
                        _loc3_.center();
                        return;
                    }
                    _loc2_ = new Event(SAVE_NEW);
                    break;
                case this.saveOverwriteButton:
                    _loc2_ = new Event(SAVE_OVER);
                    break;
                default:
                    return;
            }
            if (Settings.disableUpload)
            {
                this.errorPrompt = new PromptSprite(Settings.disableMessage, "OH FINE");
                _loc3_ = this.errorPrompt.window;
                stage.addChild(_loc3_);
                _loc3_.center();
                return;
            }
            if (this.levelName.length == 0)
            {
                this.errorPrompt = new PromptSprite("Enter a name for your level.", "ok");
                _loc3_ = this.errorPrompt.window;
                stage.addChild(_loc3_);
                _loc3_.center();
                return;
            }
            if (BadWords.containsBadWord(this.levelName))
            {
                this.errorPrompt = new PromptSprite("Your level name contains some risky words. Please remove them. (sorry, I\'ve recently run the risk of losing advertising)", "ok");
                _loc3_ = this.errorPrompt.window;
                stage.addChild(_loc3_);
                _loc3_.center();
                return;
            }
            trace("no bad words found in level name");
            if (BadWords.containsBadWord(this.comments))
            {
                this.errorPrompt = new PromptSprite("Your level comments contain some risky words. Please remove them. (sorry, I\'ve recently run the risk of losing advertising)", "ok");
                _loc3_ = this.errorPrompt.window;
                stage.addChild(_loc3_);
                _loc3_.center();
                return;
            }
            trace("no bad words found in comments");
            dispatchEvent(_loc2_);
        }

        private function copyLevelText(param1:MouseEvent):void
        {
            System.setClipboard(SaverLoader.instance.createXML(true).toXMLString());
            Tracker.trackEvent(Tracker.EDITOR, Tracker.COPY_LEVELDATA, "authorID_" + Settings.user_id);
        }

        private function mouseDownTextHandler(param1:MouseEvent):void
        {
            this.levelText.setSelection(0, this.levelText.length);
        }

        public function die():void
        {
            this._window.removeEventListener(Window.WINDOW_CLOSED, this.windowClosed);
            this._window.closeWindow();
            this.saveNewButton.removeEventListener(MouseEvent.MOUSE_UP, this.savePressHandler);
            this.saveNewButton.removeEventListener(MouseEvent.ROLL_OVER, this.rollOverHandler);
            if (this.saveOverwriteButton)
            {
                this.saveOverwriteButton.removeEventListener(MouseEvent.MOUSE_UP, this.savePressHandler);
                this.saveOverwriteButton.removeEventListener(MouseEvent.ROLL_OVER, this.rollOverHandler);
            }
            this.copyLevelButton.removeEventListener(MouseEvent.MOUSE_UP, this.copyLevelText);
            this.copyLevelButton.removeEventListener(MouseEvent.ROLL_OVER, this.rollOverHandler);
            this.levelText.removeEventListener(MouseEvent.MOUSE_DOWN, this.mouseDownTextHandler);
            removeEventListener(Event.ENTER_FRAME, this.setCharText);
        }
    }
}
