package com.totaljerkface.game.menus
{
    import com.totaljerkface.game.Settings;
    import com.totaljerkface.game.sound.SoundController;
    import com.totaljerkface.game.utils.TextUtils;
    import com.totaljerkface.game.utils.Tracker;
    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.events.MouseEvent;
    import flash.net.URLRequest;
    import flash.net.navigateToURL;
    import flash.text.TextField;

    [Embed(source="/_assets/assets.swf", symbol="symbol2952")]
    public class ReplayListItem extends Sprite
    {
        public static const BG_HEIGHT:Number = 22;

        public static const FADE_VALUE:Number = 0.5;

        public var bg:MovieClip;

        public var userText:TextField;

        public var timeText:TextField;

        public var viewsText:TextField;

        public var createdText:TextField;

        public var characterFaces:MovieClip;

        public var voteStars:VoteStars;

        public var userBtn:Sprite;

        public var accurateMc:MovieClip;

        private var _selected:Boolean;

        private var _faded:Boolean;

        private var _accurate:Boolean;

        private var _hidden:Boolean;

        private var _replayDataObject:ReplayDataObject;

        public function ReplayListItem(param1:ReplayDataObject)
        {
            super();
            this._replayDataObject = param1;
            buttonMode = true;
            this.bg.mouseEnabled = this.timeText.mouseEnabled = this.userText.mouseEnabled = this.viewsText.mouseEnabled = this.createdText.mouseEnabled = this.accurateMc.mouseEnabled = false;
            this.voteStars.mouseEnabled = false;
            this.timeText.embedFonts = this.userText.embedFonts = this.viewsText.embedFonts = this.createdText.embedFonts = true;
            this.timeText.selectable = this.userText.selectable = this.viewsText.selectable = this.createdText.selectable = false;
            this.userText.text = this._replayDataObject.user_name;
            this.timeText.text = this._replayDataObject.timeFrames < Settings.maxReplayFrames ? "" + TextUtils.setToHundredths(this._replayDataObject.timeSeconds) + " seconds" : "---";
            this.viewsText.text = TextUtils.addIntegerCommas(this._replayDataObject.views);
            this.createdText.text = TextUtils.shortenDate(this._replayDataObject.created);
            this.voteStars.rating = this._replayDataObject.average_rating;
            this.characterFaces.gotoAndStop(this._replayDataObject.character);
            if (this._replayDataObject.character == 0)
            {
                this.characterFaces.gotoAndStop(Settings.totalCharacters + 1);
            }
            if (this._replayDataObject.architecture == Settings.architecture)
            {
                this.accurateMc.gotoAndStop(1);
                this._accurate = true;
            }
            else
            {
                this.accurateMc.gotoAndStop(2);
            }
            this.userBtn.width = this.userText.textWidth + 5;
            this.userBtn.visible = false;
            this.userBtn.addEventListener(MouseEvent.MOUSE_UP, this.userPress, false, 0, true);
            this.rollOut();
        }

        private function userPress(param1:MouseEvent):void
        {
            var _loc2_:URLRequest = new URLRequest("http://www.totaljerkface.com/profile.tjf?uid=" + this._replayDataObject.user_id);
            navigateToURL(_loc2_, "_blank");
            Tracker.trackEvent(Tracker.REPLAY_BROWSER, Tracker.GOTO_USER_PAGE, "userID_" + this._replayDataObject.user_id);
        }

        public function rollOver():void
        {
            this.bg.gotoAndStop(2);
            this.textColor = 4032711;
        }

        public function rollOut():void
        {
            if (this._selected)
            {
                this.rollOver();
                return;
            }
            this.bg.gotoAndStop(1);
            this.textColor = 8947848;
        }

        public function mouseDown():void
        {
            if (this._selected)
            {
                return;
            }
            this.bg.gotoAndStop(3);
            this.textColor = 16777215;
        }

        private function set textColor(param1:uint):void
        {
            this.timeText.textColor = this.userText.textColor = this.viewsText.textColor = this.createdText.textColor = param1;
        }

        public function get selected():Boolean
        {
            return this._selected;
        }

        public function set selected(param1:Boolean):void
        {
            this._selected = param1;
            if (this._selected)
            {
                this.userText.htmlText = "<u>" + this.userText.text + "</u>";
                this.rollOver();
                this.userBtn.visible = true;
                this.bg.alpha = 1;
                SoundController.instance.playSoundItem("MenuSelect2");
            }
            else
            {
                this.userText.htmlText = this.userText.text;
                this.rollOut();
                if (this._faded)
                {
                    this.bg.alpha = FADE_VALUE;
                }
                this.userBtn.visible = false;
            }
        }

        public function get faded():Boolean
        {
            return this._faded;
        }

        public function set faded(param1:Boolean):void
        {
            this._faded = param1;
            if (this._faded && !this._selected)
            {
                this.bg.alpha = FADE_VALUE;
            }
            else
            {
                this.bg.alpha = 1;
            }
        }

        public function get hidden():Boolean
        {
            return this._hidden;
        }

        public function set hidden(param1:Boolean):void
        {
            visible = !param1;
            this._hidden = param1;
        }

        public function get accurate():Boolean
        {
            return this._accurate;
        }

        override public function get height():Number
        {
            if (this._hidden)
            {
                return 0;
            }
            return BG_HEIGHT;
        }

        public function get replayDataObject():ReplayDataObject
        {
            return this._replayDataObject;
        }
    }
}
