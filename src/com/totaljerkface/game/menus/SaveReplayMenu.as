package com.totaljerkface.game.menus
{
    import com.hurlant.util.Base64;
    import com.totaljerkface.game.*;
    import com.totaljerkface.game.editor.*;
    import com.totaljerkface.game.editor.ui.*;
    import com.totaljerkface.game.utils.BadWords;
    import com.totaljerkface.game.utils.PostEncryption;
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;
    import flash.text.*;
    import flash.utils.*;

    [Embed(source="/_assets/assets.swf", symbol="symbol2925")]
    public class SaveReplayMenu extends Sprite
    {
        public static var SAVE_COMPLETE:String = "savecomplete";

        public static var GENERIC_ERROR:String = "genericerror";

        public var commentsText:TextField;

        public var cCharsText:TextField;

        private const APPLESAUCE:String = "7ab7657e5595b5c3486988c90728c6ae";

        private var maxCommentChars:int = 200;

        private var saveButton:GenericButton;

        private var _window:Window;

        private var loader:URLLoader;

        private var _byteArray:ByteArray;

        private var _completed:Boolean;

        private var _levelId:int;

        private var _character:int;

        private var _length:int;

        private var _errorMessage:String;

        private var _newReplayID:int;

        private var statusSprite:StatusSprite;

        private var errorPrompt:PromptSprite;

        public function SaveReplayMenu(param1:ReplayData, param2:int, param3:int)
        {
            super();
            this._byteArray = param1.byteArray;
            this._completed = param1.completed;
            this._length = param1.getLength();
            this._levelId = param2;
            this._character = param3;
            this.buildWindow();
            this.saveButton = new GenericButton("save", 16613761, 100);
            addChild(this.saveButton);
            this.saveButton.x = 70;
            this.saveButton.y = 153;
            this.saveButton.addEventListener(MouseEvent.MOUSE_UP, this.mouseUpHandler);
            this.commentsText.autoSize = TextFieldAutoSize.NONE;
            this.commentsText.selectable = true;
            this.cCharsText.selectable = false;
            this.commentsText.embedFonts = this.cCharsText.embedFonts = true;
            this.commentsText.wordWrap = true;
            this.commentsText.multiline = true;
            this.commentsText.maxChars = this.maxCommentChars;
            this.commentsText.restrict = "a-z A-Z 0-9 !@#$%\\^&*()_+\\-=;\'|?/,.<> \"";
            addEventListener(Event.ENTER_FRAME, this.setCharText);
        }

        private function setCharText(param1:Event):void
        {
            var _loc2_:int = this.maxCommentChars - this.commentsText.length;
            this.cCharsText.text = String(_loc2_) + " chars left";
        }

        private function mouseUpHandler(param1:MouseEvent):void
        {
            var _loc2_:Window = null;
            if (BadWords.containsBadWord(this.commentsText.text))
            {
                this.errorPrompt = new PromptSprite("Your replay comments contain some risky words. Please remove them. (sorry, I\'ve recently run the risk of losing advertising)", "ok");
                _loc2_ = this.errorPrompt.window;
                stage.addChild(_loc2_);
                _loc2_.center();
                return;
            }
            trace("no bad words found in comments");
            this.save();
        }

        private function createReplayQueryString(param1:int, param2:int, param3:String, param4:int, param5:Number, param6:String):String
        {
            param6 = escape(param6);
            return "id=" + param1 + "&pc=" + param2 + "&ar=" + param3 + "&ct=" + param4 + "&vr=" + param5 + "&uc=" + param6 + "&ui=" + Settings.user_id;
        }

        public function save():void
        {
            this.statusSprite = new StatusSprite("Saving Replay...");
            var _loc1_:Window = this.statusSprite.window;
            this._window.parent.addChild(_loc1_);
            _loc1_.center();
            var _loc2_:String = this.createReplayQueryString(this._levelId, this._character, Settings.architecture, this._completed ? this._length : Settings.maxReplayFrames, Settings.CURRENT_VERSION, this.commentsText.text);
            var _loc3_:PostEncryption = new PostEncryption(this.APPLESAUCE);
            var _loc4_:String = _loc3_.encrypt(_loc2_);
            var _loc5_:String = _loc3_.getIV();
            var _loc6_:ByteArray = new ByteArray();
            _loc6_.writeBytes(this._byteArray);
            var _loc7_:String = Base64.encodeByteArray(_loc6_);
            var _loc8_:* = Settings.siteURL + "replay.hw";
            var _loc9_:URLRequest = new URLRequest(_loc8_);
            _loc9_.method = URLRequestMethod.POST;
            var _loc10_:URLVariables = new URLVariables();
            _loc10_.action = "create";
            _loc10_.rr = _loc7_;
            _loc10_.em = _loc4_;
            _loc10_.ei = _loc5_;
            _loc9_.data = _loc10_;
            this.loader = new URLLoader();
            this.loader.addEventListener(Event.COMPLETE, this.replaySaved);
            this.loader.load(_loc9_);
        }

        private function replaySaved(param1:Event):void
        {
            trace("replay saved");
            this.statusSprite.die();
            this.loader.removeEventListener(Event.COMPLETE, this.replaySaved);
            var _loc2_:String = String(this.loader.data);
            var _loc3_:String = _loc2_.substr(0, 8);
            var _loc4_:Array = _loc2_.split(":");
            trace("dataString " + _loc2_);
            if (_loc3_.indexOf("<html>") > -1)
            {
                this._errorMessage = "There was an unexpected system Error";
                dispatchEvent(new Event(GENERIC_ERROR));
            }
            else if (_loc4_[0] == "failure")
            {
                if (_loc4_[1] == "invalid_action")
                {
                    this._errorMessage = "An invalid action was passed (you really shouldn\'t ever be seeing this).";
                }
                else if (_loc4_[1] == "time_lockout")
                {
                    this._errorMessage = "You saved a replay too recently. Please wait a moment and try again.";
                }
                else if (_loc4_[1] == "hi_comp_time")
                {
                    this._errorMessage = "Your replay is too long.";
                }
                else if (_loc4_[1] == "bad_param")
                {
                    this._errorMessage = "A bad parameter was passed (you really shouldn\'t ever be seeing this).";
                }
                else if (_loc4_[1] == "app_error")
                {
                    this._errorMessage = "Sorry, there was an application error. It was most likely database related. Please try again in a moment.";
                }
                else if (_loc4_[1] == "not_logged_in")
                {
                    this._errorMessage = "You are not currently logged in.";
                }
                else
                {
                    this._errorMessage = "An unknown Error has occurred.";
                }
                dispatchEvent(new Event(GENERIC_ERROR));
            }
            else if (_loc4_[0] == "success")
            {
                this._newReplayID = int(_loc4_[1]);
                dispatchEvent(new Event(SAVE_COMPLETE));
            }
            else
            {
                this._errorMessage = "Error: something dreadful has happened";
                dispatchEvent(new Event(GENERIC_ERROR));
            }
        }

        private function buildWindow():void
        {
            this._window = new Window(true, this, true);
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

        public function get errorMessage():String
        {
            return this._errorMessage;
        }

        public function get newReplayID():int
        {
            return this._newReplayID;
        }

        public function die():void
        {
            this._window.removeEventListener(Window.WINDOW_CLOSED, this.windowClosed);
            this._window.closeWindow();
            removeEventListener(Event.ENTER_FRAME, this.setCharText);
            this.saveButton.removeEventListener(MouseEvent.MOUSE_UP, this.mouseUpHandler);
        }
    }
}
