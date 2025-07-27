package com.totaljerkface.game.menus
{
    import com.totaljerkface.game.*;
    import com.totaljerkface.game.editor.*;
    import com.totaljerkface.game.editor.ui.*;
    import com.totaljerkface.game.sound.SoundController;
    import com.totaljerkface.game.utils.*;
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;
    import flash.text.*;

    [Embed(source="/_assets/assets.swf", symbol="symbol102")]
    public class SessionMenu extends Sprite
    {
        public static const RESTART_LEVEL:String = "restartlevel";

        public static const CHOOSE_CHARACTER:String = "choosecharacter";

        public static const VIEW_REPLAY:String = "viewreplay";

        public static const SAVE_REPLAY:String = "savereplay";

        public static const ADD_LEVEL_TO_FAVORITES:String = "addleveltofavorites";

        public static const EXIT:String = "exit";

        public static const CANCEL:String = "cancel";

        public var levelNameText:TextField;

        public var authorText:TextField;

        private var _window:Window;

        private var levelDataObject:LevelDataObject;

        private var votingStars:VotingStars;

        private var restartButton:GenericButton;

        private var replayButton:GenericButton;

        private var saveButton:GenericButton;

        private var editFavoritesButton:GenericButton;

        private var characterButton:GenericButton;

        private var exitButton:GenericButton;

        private var cancelButton:GenericButton;

        private var muteButton:MovieClip;

        private var fullScreenButton:MovieClip;

        private var isFavorite:Boolean;

        private var _disableSave:Boolean;

        private var _disableKeys:Boolean;

        private var statusSprite:StatusSprite;

        private var promptSprite:PromptSprite;

        public function SessionMenu(param1:LevelDataObject, param2:Boolean = false)
        {
            super();
            this.levelDataObject = param1;
            this._disableSave = param2;
            this.buildWindow();
        }

        public function init():void
        {
            var _loc1_:Number = NaN;
            var _loc2_:Number = NaN;
            this.levelNameText.htmlText = "<b>" + this.levelDataObject.name + "</b>";
            this.authorText.text = this.levelDataObject.author_name;
            this.votingStars = new VotingStars(this.levelDataObject.average_rating);
            this.votingStars.x = 45;
            this.votingStars.y = 74;
            _loc1_ = 120;
            _loc2_ = (240 - _loc1_) / 2;
            this.restartButton = new GenericButton("restart level", 4032711, _loc1_);
            this.restartButton.x = _loc2_;
            this.restartButton.y = 114;
            addChild(this.restartButton);
            this.characterButton = new GenericButton("change character", 4032711, _loc1_);
            this.characterButton.x = _loc2_;
            this.characterButton.y = 144;
            addChild(this.characterButton);
            if (this.levelDataObject.forceChar)
            {
                this.characterButton.disabled = true;
            }
            this.replayButton = new GenericButton("view replay", 4032711, _loc1_);
            this.replayButton.x = _loc2_;
            this.replayButton.y = 174;
            addChild(this.replayButton);
            this.saveButton = new GenericButton("save replay", 4032711, _loc1_);
            this.saveButton.x = _loc2_;
            this.saveButton.y = 204;
            addChild(this.saveButton);
            this.disableSave = this._disableSave;
            this.isFavorite = Settings.favoriteLevelIds.indexOf(this.levelDataObject.id) > -1 ? true : false;
            var _loc3_:String = this.isFavorite ? "remove favorite" : "add to favorites";
            this.editFavoritesButton = new GenericButton(_loc3_, 16776805, _loc1_, 0);
            this.editFavoritesButton.x = _loc2_;
            this.editFavoritesButton.y = 234;
            addChild(this.editFavoritesButton);
            this.exitButton = new GenericButton("exit to menu", 16613761, _loc1_);
            this.exitButton.x = _loc2_;
            this.exitButton.y = 272;
            addChild(this.exitButton);
            this.cancelButton = new GenericButton("resume", 16613761, _loc1_);
            this.cancelButton.x = _loc2_;
            this.cancelButton.y = 303;
            addChild(this.cancelButton);
            this.muteButton = new MuteButton();
            if (SoundController.instance.isMuted)
            {
                this.muteButton.gotoAndStop(2);
            }
            else
            {
                this.muteButton.gotoAndStop(1);
            }
            this.muteButton.x = _loc2_ - 48;
            this.muteButton.y = 319;
            addChild(this.muteButton);
            this.muteButton.mouseChildren = false;
            this.muteButton.buttonMode = true;
            this.muteButton.tabEnabled = false;
            this.fullScreenButton = new FullScreenButton();
            if (stage.displayState == StageDisplayState.FULL_SCREEN_INTERACTIVE)
            {
                this.fullScreenButton.gotoAndStop(2);
            }
            else
            {
                this.fullScreenButton.gotoAndStop(1);
            }
            this.fullScreenButton.x = _loc2_ + 153;
            this.fullScreenButton.y = 316;
            addChild(this.fullScreenButton);
            this.fullScreenButton.mouseChildren = false;
            this.fullScreenButton.buttonMode = true;
            this.fullScreenButton.tabEnabled = false;
            addChild(this.votingStars);
            addEventListener(MouseEvent.MOUSE_OVER, this.rollOverHandler);
            addEventListener(MouseEvent.MOUSE_UP, this.mouseUpHandler);
            stage.addEventListener(KeyboardEvent.KEY_UP, this.keyDownHandler);
            this.votingStars.addEventListener(VotingStars.RATING_SELECTED, this.vote);
        }

        private function buildWindow():void
        {
            this._window = new Window(false, this, false);
        }

        public function get window():Window
        {
            return this._window;
        }

        public function set disableSave(param1:Boolean):void
        {
            this._disableSave = param1;
            if (param1)
            {
                this.saveButton.disabled = true;
            }
            else
            {
                this.saveButton.disabled = false;
            }
        }

        public function get disableKeys():Boolean
        {
            return this._disableKeys;
        }

        public function set disableKeys(param1:Boolean):void
        {
            this._disableKeys = param1;
        }

        private function mouseUpHandler(param1:MouseEvent):void
        {
            var _loc2_:Window = null;
            switch (param1.target)
            {
                case this.restartButton:
                    dispatchEvent(new Event(RESTART_LEVEL));
                    break;
                case this.characterButton:
                    Tracker.trackEvent(Tracker.LEVEL, Tracker.CHANGE_CHARACTER, "levelID_" + this.levelDataObject.id);
                    dispatchEvent(new Event(CHOOSE_CHARACTER));
                    break;
                case this.replayButton:
                    dispatchEvent(new Event(VIEW_REPLAY));
                    break;
                case this.saveButton:
                    if (Settings.user_id <= 0)
                    {
                        this.promptSprite = new PromptSprite("You must be logged in to save replays.  Login or register for free up there on the right.", "ok");
                        _loc2_ = this.promptSprite.window;
                        this._window.parent.addChild(_loc2_);
                        _loc2_.center();
                        return;
                    }
                    if (Settings.disableUpload)
                    {
                        this.promptSprite = new PromptSprite(Settings.disableMessage, "OH FINE");
                        _loc2_ = this.promptSprite.window;
                        this._window.parent.addChild(_loc2_);
                        _loc2_.center();
                        return;
                    }
                    dispatchEvent(new Event(SAVE_REPLAY));
                    break;
                case this.editFavoritesButton:
                    if (Settings.user_id <= 0)
                    {
                        this.promptSprite = new PromptSprite("You must be logged in to edit your favorite levels.  Login or register for free up there on the right.", "ok");
                        _loc2_ = this.promptSprite.window;
                        this._window.parent.addChild(_loc2_);
                        _loc2_.center();
                        return;
                    }
                    if (Settings.disableUpload)
                    {
                        this.promptSprite = new PromptSprite(Settings.disableMessage, "OH FINE");
                        _loc2_ = this.promptSprite.window;
                        this._window.parent.addChild(_loc2_);
                        _loc2_.center();
                        return;
                    }
                    this.editFavorites();
                    break;
                case this.exitButton:
                    dispatchEvent(new Event(EXIT));
                    break;
                case this.cancelButton:
                    dispatchEvent(new Event(CANCEL));
                    break;
                case this.muteButton:
                    if (this.muteButton.currentFrame == 1)
                    {
                        this.muteButton.gotoAndStop(2);
                        SoundController.instance.mute();
                        Tracker.trackEvent(Tracker.LEVEL, Tracker.MUTE);
                    }
                    else
                    {
                        this.muteButton.gotoAndStop(1);
                        SoundController.instance.unMute();
                        Tracker.trackEvent(Tracker.LEVEL, Tracker.UNMUTE);
                    }
                    break;
                case this.fullScreenButton:
                    if (stage.displayState == StageDisplayState.FULL_SCREEN_INTERACTIVE)
                    {
                        stage.displayState = StageDisplayState.NORMAL;
                        if (stage.displayState == StageDisplayState.NORMAL)
                        {
                            this.fullScreenButton.gotoAndStop(1);
                        }
                    }
                    else
                    {
                        stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
                        if (stage.displayState == StageDisplayState.FULL_SCREEN_INTERACTIVE)
                        {
                            this.fullScreenButton.gotoAndStop(2);
                        }
                    }
            }
        }

        private function rollOverHandler(param1:MouseEvent):void
        {
            switch (param1.target)
            {
                case this.restartButton:
                    MouseHelper.instance.show("(R)", this.restartButton);
                    break;
                case this.fullScreenButton:
                    MouseHelper.instance.show("Fullscreen", this.fullScreenButton);
                    break;
                case this.muteButton:
                    MouseHelper.instance.show("Mute / Unmute", this.muteButton);
            }
        }

        private function keyDownHandler(param1:KeyboardEvent):void
        {
            if (this._disableKeys)
            {
                return;
            }
            switch (param1.keyCode)
            {
                case 82:
                    dispatchEvent(new Event(RESTART_LEVEL));
            }
        }

        private function editFavorites():void
        {
            var _loc5_:String = null;
            var _loc1_:URLRequest = new URLRequest(Settings.siteURL + "user.hw");
            _loc1_.method = URLRequestMethod.POST;
            var _loc2_:URLVariables = new URLVariables();
            _loc2_.level_id = this.levelDataObject.id;
            _loc1_.data = _loc2_;
            if (!this.isFavorite)
            {
                trace("ADD TO FAVORITES");
                _loc5_ = "adding level to favorites...";
                _loc2_.action = "set_favorite";
            }
            else
            {
                trace("REMOVE FROM FAVORITES");
                _loc5_ = "removing level from favorites...";
                _loc2_.action = "delete_favorite";
            }
            this.statusSprite = new StatusSprite(_loc5_);
            var _loc3_:Window = this.statusSprite.window;
            this._window.parent.addChild(_loc3_);
            _loc3_.center();
            var _loc4_:URLLoader = new URLLoader();
            _loc4_.addEventListener(Event.COMPLETE, this.editFavoritesComplete);
            _loc4_.load(_loc1_);
        }

        private function editFavoritesComplete(param1:Event):void
        {
            var _loc7_:int = 0;
            trace("EDIT FAVORITES -- COMPLETE");
            this.statusSprite.die();
            var _loc2_:URLLoader = param1.target as URLLoader;
            _loc2_.removeEventListener(Event.COMPLETE, this.editFavoritesComplete);
            var _loc3_:String = String(_loc2_.data);
            var _loc4_:String = _loc3_.substr(0, 8);
            trace("dataString " + _loc4_);
            var _loc5_:Array = _loc3_.split(":");
            if (_loc4_.indexOf("<html>") > -1)
            {
                this.promptSprite = new PromptSprite("There was an unexpected system Error", "oh");
            }
            else if (_loc5_[0] == "failure")
            {
                if (_loc5_[1] == "not_logged_in")
                {
                    this.promptSprite = new PromptSprite("You must be logged in to edit your favorite levels.  Login or register for free up there on the right.", "ok");
                }
                else if (_loc5_[1] == "duplicate")
                {
                    this.promptSprite = new PromptSprite("This level is already one of your favorite levels.", "ok");
                }
                else if (_loc5_[1] == "invalid_action")
                {
                    this.promptSprite = new PromptSprite("An invalid action was passed (you really shouldn\'t ever be seeing this).", "ok");
                }
                else if (_loc5_[1] == "bad_param")
                {
                    this.promptSprite = new PromptSprite("A bad parameter was passed (you really shouldn\'t ever be seeing this).", "ok");
                }
                else if (_loc5_[1] == "app_error")
                {
                    this.promptSprite = new PromptSprite("Sorry, there was an application error. It was most likely database related. Please try again in a moment.", "ok");
                }
                else
                {
                    this.promptSprite = new PromptSprite("An unknown Error has occurred.", "oh");
                }
            }
            else if (_loc5_[0] == "success")
            {
                this.promptSprite = new PromptSprite("Favorites list updated.", "ok");
                _loc7_ = int(Settings.favoriteLevelIds.indexOf(this.levelDataObject.id));
                if (!this.isFavorite)
                {
                    Tracker.trackEvent(Tracker.LEVEL, Tracker.ADD_FAVORITE);
                    if (_loc7_ == -1)
                    {
                        Settings.favoriteLevelIds.push(this.levelDataObject.id);
                    }
                }
                else
                {
                    Tracker.trackEvent(Tracker.LEVEL, Tracker.REMOVE_FAVORITE);
                    if (_loc7_ > -1)
                    {
                        Settings.favoriteLevelIds.splice(_loc7_, 1);
                    }
                }
                this.editFavoritesButton.disabled = true;
            }
            else
            {
                this.promptSprite = new PromptSprite("Error: something dreadful has happened", "ok");
            }
            var _loc6_:Window = this.promptSprite.window;
            this._window.parent.addChild(_loc6_);
            _loc6_.center();
        }

        private function vote(param1:Event = null):void
        {
            var _loc6_:Window = null;
            if (Settings.user_id <= 0)
            {
                this.promptSprite = new PromptSprite("You must be logged in to vote.  Login or register for free up there on the right.", "ok");
                _loc6_ = this.promptSprite.window;
                this._window.parent.addChild(_loc6_);
                _loc6_.center();
                return;
            }
            if (Settings.disableUpload)
            {
                this.promptSprite = new PromptSprite(Settings.disableMessage, "OH FINE");
                _loc6_ = this.promptSprite.window;
                this._window.parent.addChild(_loc6_);
                _loc6_.center();
                return;
            }
            this.statusSprite = new StatusSprite("casting your vote...");
            var _loc2_:Window = this.statusSprite.window;
            this._window.parent.addChild(_loc2_);
            _loc2_.center();
            var _loc3_:URLRequest = new URLRequest(Settings.siteURL + "set_level.hw");
            _loc3_.method = URLRequestMethod.POST;
            var _loc4_:URLVariables = new URLVariables();
            _loc4_.level_id = this.levelDataObject.id;
            _loc4_.rating = this.votingStars.rating;
            _loc4_.action = "rate_level";
            _loc3_.data = _loc4_;
            var _loc5_:URLLoader = new URLLoader();
            _loc5_.addEventListener(Event.COMPLETE, this.voteComplete);
            _loc5_.load(_loc3_);
        }

        private function voteComplete(param1:Event):void
        {
            this.statusSprite.die();
            var _loc2_:URLLoader = param1.target as URLLoader;
            _loc2_.removeEventListener(Event.COMPLETE, this.voteComplete);
            trace("VOTE COMPLETE");
            trace(_loc2_.data);
            var _loc3_:String = String(_loc2_.data);
            var _loc4_:String = _loc3_.substr(0, 8);
            var _loc5_:Array = _loc3_.split(":");
            trace("dataString " + _loc4_);
            if (_loc4_.indexOf("<html>") > -1)
            {
                this.promptSprite = new PromptSprite("There was an unexpected system Error", "oh");
            }
            else if (_loc5_[0] == "failure")
            {
                if (_loc5_[1] == "invalid_action")
                {
                    this.promptSprite = new PromptSprite("An invalid action was passed (you really shouldn\'t ever be seeing this).", "ok");
                }
                else if (_loc5_[1] == "duplicate_rating")
                {
                    this.promptSprite = new PromptSprite("You\'ve already voted on this level.", "ok");
                }
                else if (_loc5_[1] == "illegal_argument")
                {
                    this.promptSprite = new PromptSprite("Rating must be between 0 and 5.", "ok");
                }
                else if (_loc5_[1] == "bad_param")
                {
                    this.promptSprite = new PromptSprite("A bad parameter was passed (you really shouldn\'t ever be seeing this).", "ok");
                }
                else if (_loc5_[1] == "app_error")
                {
                    this.promptSprite = new PromptSprite("Sorry, there was an application error. It was most likely database related. Please try again in a moment.", "ok");
                }
                else if (_loc5_[1] == "not_logged_in")
                {
                    this.promptSprite = new PromptSprite("You are not currently logged in.", "alright");
                }
                else
                {
                    this.promptSprite = new PromptSprite("An unknown Error has occurred.", "oh");
                }
            }
            else if (_loc5_[0] == "success")
            {
                Tracker.trackEvent(Tracker.LEVEL, Tracker.VOTE, "rating_" + this.votingStars.rating);
                this.promptSprite = new PromptSprite("You voted! Good job.", "thanks");
            }
            else
            {
                this.promptSprite = new PromptSprite("Error: something dreadful has happened", "ok");
            }
            var _loc6_:Window = this.promptSprite.window;
            this._window.parent.addChild(_loc6_);
            _loc6_.center();
        }

        public function die():void
        {
            this.votingStars.die();
            removeEventListener(MouseEvent.MOUSE_OVER, this.rollOverHandler);
            removeEventListener(MouseEvent.MOUSE_UP, this.mouseUpHandler);
            stage.removeEventListener(KeyboardEvent.KEY_UP, this.keyDownHandler);
            this.votingStars.removeEventListener(VotingStars.RATING_SELECTED, this.vote);
            this._window.closeWindow();
        }
    }
}
