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

    [Embed(source="/_assets/assets.swf", symbol="symbol3019")]
    public class LevelListItem extends Sprite
    {
        public static const BG_HEIGHT:Number = 22;

        public static const FADE_VALUE:Number = 0.5;

        public var bg:MovieClip;

        public var titleText:TextField;

        public var authorText:TextField;

        public var playsText:TextField;

        public var createdText:TextField;

        public var characterFaces:MovieClip;

        public var voteStars:VoteStars;

        public var authorBtn:Sprite;

        private var _selected:Boolean;

        private var _faded:Boolean;

        private var _levelDataObject:LevelDataObject;

        public function LevelListItem(param1:LevelDataObject)
        {
            super();
            this._levelDataObject = param1;
            buttonMode = true;
            this.bg.mouseEnabled = this.titleText.mouseEnabled = this.authorText.mouseEnabled = this.playsText.mouseEnabled = this.createdText.mouseEnabled = this.voteStars.mouseEnabled = false;
            this.titleText.embedFonts = this.authorText.embedFonts = this.playsText.embedFonts = this.createdText.embedFonts = true;
            this.titleText.selectable = this.authorText.selectable = this.playsText.selectable = this.createdText.selectable = false;
            this.titleText.text = this._levelDataObject.name;
            this.authorText.text = this._levelDataObject.author_name;
            this.playsText.text = TextUtils.addIntegerCommas(this._levelDataObject.plays);
            this.createdText.text = TextUtils.shortenDate(this._levelDataObject.created);
            this.voteStars.rating = this._levelDataObject.average_rating;
            this.characterFaces.gotoAndStop(this._levelDataObject.character);
            if (this._levelDataObject.character == 0)
            {
                this.characterFaces.gotoAndStop(Settings.totalCharacters + 1);
            }
            this.authorBtn.width = this.authorText.textWidth + 5;
            this.authorBtn.visible = false;
            this.authorBtn.addEventListener(MouseEvent.MOUSE_UP, this.authorPress, false, 0, true);
            this.rollOut();
        }

        private function authorPress(param1:MouseEvent):void
        {
            var _loc2_:URLRequest = new URLRequest("http://www.totaljerkface.com/profile.tjf?uid=" + this._levelDataObject.author_id);
            navigateToURL(_loc2_, "_blank");
            Tracker.trackEvent(Tracker.LEVEL_BROWSER, Tracker.GOTO_USER_PAGE, "userID_" + this._levelDataObject.author_id);
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
            this.titleText.textColor = this.authorText.textColor = this.playsText.textColor = this.createdText.textColor = param1;
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
                this.authorText.htmlText = "<u>" + this.authorText.text + "</u>";
                this.rollOver();
                this.authorBtn.visible = true;
                this.bg.alpha = 1;
                SoundController.instance.playSoundItem("MenuSelect2");
            }
            else
            {
                this.authorText.htmlText = this.authorText.text;
                this.rollOut();
                if (this._faded)
                {
                    this.bg.alpha = FADE_VALUE;
                }
                this.authorBtn.visible = false;
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

        public function get levelDataObject():LevelDataObject
        {
            return this._levelDataObject;
        }
    }
}
