package com.totaljerkface.game.menus
{
    import com.totaljerkface.game.*;
    import com.totaljerkface.game.editor.*;
    import com.totaljerkface.game.editor.ui.*;
    import com.totaljerkface.game.utils.*;
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;
    import flash.text.*;

    [Embed(source="/_assets/assets.swf", symbol="symbol92")]
    public class SessionReplayMenu extends Sprite
    {
        public static const RESTART_REPLAY:String = "restartreplay";

        public static const CHOOSE_CHARACTER:String = "choosecharacter";

        public static const PLAY_LEVEL:String = "playlevel";

        public static const EXIT:String = "exit";

        public static const CANCEL:String = "cancel";

        public var userText:TextField;

        private var _window:Window;

        private var replayDataObject:ReplayDataObject;

        private var votingStars:VotingStars;

        private var restartButton:GenericButton;

        private var playButton:GenericButton;

        private var exitButton:GenericButton;

        private var cancelButton:GenericButton;

        private var statusSprite:StatusSprite;

        private var promptSprite:PromptSprite;

        public function SessionReplayMenu(param1:ReplayDataObject)
        {
            super();
            this.replayDataObject = param1;
            this.init();
        }

        private function init():void
        {
            this.buildWindow();
            this.userText.text = this.replayDataObject.user_name;
            this.votingStars = new VotingStars(this.replayDataObject.average_rating);
            this.votingStars.x = 45;
            this.votingStars.y = 65;
            var _loc1_:Number = 120;
            var _loc2_:Number = (240 - _loc1_) / 2;
            this.restartButton = new GenericButton("view replay again", 4032711, _loc1_);
            this.restartButton.x = _loc2_;
            this.restartButton.y = 107;
            addChild(this.restartButton);
            this.playButton = new GenericButton("play this level", 4032711, _loc1_);
            this.playButton.x = _loc2_;
            this.playButton.y = 137;
            addChild(this.playButton);
            this.exitButton = new GenericButton("exit to menu", 16613761, _loc1_);
            this.exitButton.x = _loc2_;
            this.exitButton.y = 177;
            addChild(this.exitButton);
            this.cancelButton = new GenericButton("resume", 16613761, _loc1_);
            this.cancelButton.x = _loc2_;
            this.cancelButton.y = 207;
            addChild(this.cancelButton);
            addChild(this.votingStars);
            addEventListener(MouseEvent.MOUSE_UP, this.mouseUpHandler);
            this.votingStars.addEventListener(VotingStars.RATING_SELECTED, this.ratingSelected);
        }

        private function ratingSelected(param1:Event):void
        {
            if (this.votingStars.rating > -1)
            {
                this.vote();
            }
        }

        private function buildWindow():void
        {
            this._window = new Window(false, this, false);
        }

        public function get window():Window
        {
            return this._window;
        }

        private function mouseUpHandler(param1:MouseEvent):void
        {
            switch (param1.target)
            {
                case this.restartButton:
                    dispatchEvent(new Event(RESTART_REPLAY));
                    break;
                case this.playButton:
                    if (this.replayDataObject.version != Settings.CURRENT_VERSION)
                    {
                        dispatchEvent(new Event(CHOOSE_CHARACTER));
                    }
                    else
                    {
                        dispatchEvent(new Event(PLAY_LEVEL));
                    }
                    break;
                case this.exitButton:
                    dispatchEvent(new Event(EXIT));
                    break;
                case this.cancelButton:
                    dispatchEvent(new Event(CANCEL));
            }
        }

        private function vote():void
        {
            var _loc5_:Window = null;
            if (Settings.user_id <= 0)
            {
                this.promptSprite = new PromptSprite("You must be logged in to vote.  Login or register for free up there on the right.", "ok");
                _loc5_ = this.promptSprite.window;
                this._window.parent.addChild(_loc5_);
                _loc5_.center();
                return;
            }
            if (Settings.disableUpload)
            {
                this.promptSprite = new PromptSprite(Settings.disableMessage, "OH FINE");
                _loc5_ = this.promptSprite.window;
                this._window.parent.addChild(_loc5_);
                _loc5_.center();
                return;
            }
            if (this.replayDataObject.architecture != Settings.architecture)
            {
                this.promptSprite = new PromptSprite("You may only vote on replays you can see 100% accurately.", "ok");
                _loc5_ = this.promptSprite.window;
                this._window.parent.addChild(_loc5_);
                _loc5_.center();
                return;
            }
            this.statusSprite = new StatusSprite("casting your vote...");
            var _loc1_:Window = this.statusSprite.window;
            this._window.parent.addChild(_loc1_);
            _loc1_.center();
            var _loc2_:URLRequest = new URLRequest(Settings.siteURL + "replay.hw");
            _loc2_.method = URLRequestMethod.POST;
            var _loc3_:URLVariables = new URLVariables();
            _loc3_.replay_id = this.replayDataObject.id;
            _loc3_.rating = this.votingStars.rating;
            _loc3_.action = "rate_replay";
            _loc2_.data = _loc3_;
            var _loc4_:URLLoader = new URLLoader();
            _loc4_.addEventListener(Event.COMPLETE, this.voteComplete);
            _loc4_.load(_loc2_);
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
                Tracker.trackEvent(Tracker.REPLAY, Tracker.VOTE, "rating_" + this.votingStars.rating);
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
            this._window.closeWindow();
            this.votingStars.die();
            this.votingStars.removeEventListener(VotingStars.RATING_SELECTED, this.ratingSelected);
            removeEventListener(MouseEvent.MOUSE_UP, this.mouseUpHandler);
        }
    }
}
