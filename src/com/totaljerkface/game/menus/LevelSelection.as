package com.totaljerkface.game.menus
{
    import com.totaljerkface.game.*;
    import com.totaljerkface.game.editor.MouseHelper;
    import com.totaljerkface.game.editor.ui.GenericButton;
    import com.totaljerkface.game.editor.ui.LibraryButton;
    import com.totaljerkface.game.events.BrowserEvent;
    import com.totaljerkface.game.events.NavigationEvent;
    import com.totaljerkface.game.utils.*;
    import flash.display.*;
    import flash.events.*;
    import flash.text.*;

    [Embed(source="/_assets/assets.swf", symbol="symbol3012")]
    public class LevelSelection extends Sprite
    {
        private static var flaggedLevels:Array = [];

        public var bg:Sprite;

        public var shadow:Sprite;

        public var maskSprite:Sprite;

        public var descriptionText:TextField;

        public var characterText:TextField;

        public var commentsText:TextField;

        public var avgRatingText:TextField;

        public var wtdRatingText:TextField;

        public var linkText:TextField;

        public var playButton:LibraryButton;

        private var comments:Sprite;

        private var viewReplaysButton:GenericButton;

        private var authorLevelsButton:GenericButton;

        private var flagButton:GenericButton;

        private var importButton:GenericButton;

        private var favoriteButton:GenericButton;

        private var _levelDataObject:LevelDataObject;

        public const fullHeight:Number = 154;

        public function LevelSelection(param1:LevelDataObject)
        {
            super();
            this._levelDataObject = param1;
            this.shadow.mouseEnabled = false;
            this.descriptionText.autoSize = TextFieldAutoSize.LEFT;
            this.descriptionText.wordWrap = true;
            this.descriptionText.text = this._levelDataObject.comments;
            if (this._levelDataObject.forceChar)
            {
                this.characterText.text = Settings.characterNames[this._levelDataObject.character - 1];
            }
            else
            {
                this.characterText.text = "all";
            }
            this.avgRatingText.text = "" + TextUtils.setToHundredths(this._levelDataObject.average_rating) + " / 5.00 (" + this._levelDataObject.votes + " votes)";
            this.wtdRatingText.text = "" + TextUtils.setToHundredths(this._levelDataObject.weighted_rating) + " / 5.00 (" + this._levelDataObject.votes + " votes)";
            this.linkText.text = "http://www.totaljerkface.com/happy_wheels.tjf?level_id=" + this._levelDataObject.id;
            this.viewReplaysButton = new GenericButton("view replays/records", 16613761, 166);
            addChild(this.viewReplaysButton);
            this.viewReplaysButton.x = 548;
            this.viewReplaysButton.y = 57;
            this.authorLevelsButton = new GenericButton("view levels by this author", 16613761, 166);
            addChild(this.authorLevelsButton);
            this.authorLevelsButton.x = 548;
            this.authorLevelsButton.y = 89;
            this.flagButton = new GenericButton("flag as inappropriate", 13421772, 166, 6312772);
            addChild(this.flagButton);
            this.flagButton.x = 548;
            this.flagButton.y = 121;
            this.flagButton.disabled = true;
            var _loc2_:Boolean = Settings.favoriteLevelIds.indexOf(param1.id) > -1 ? true : false;
            var _loc3_:String = _loc2_ ? "remove favorite" : "add to favorites";
            this.favoriteButton = new GenericButton(_loc3_, 16776805, 120, 6312772);
            addChild(this.favoriteButton);
            this.favoriteButton.x = 258;
            this.favoriteButton.y = 89;
            this.importButton = new GenericButton("<< open in editor", 13421772, 120, 6312772);
            this.importButton.x = 258;
            this.importButton.y = 57;
            if (!this._levelDataObject.importable)
            {
                this.importButton.visible = false;
            }
            else
            {
                this.importButton.addEventListener(MouseEvent.ROLL_OVER, this.importButtonRoll);
            }
            this.comments = new Sprite();
            addChild(this.comments);
            this.comments.addChild(this.descriptionText);
            this.comments.addChild(this.commentsText);
            this.comments.graphics.beginFill(15724527, 1);
            this.comments.graphics.drawRect(0, 0, 250, this.comments.height);
            this.comments.graphics.endFill();
            if (this.comments.height > this.fullHeight)
            {
                addEventListener(Event.ENTER_FRAME, this.scroll);
            }
            addChild(this.shadow);
            this.maskSprite = new Sprite();
            addChild(this.maskSprite);
            this.maskSprite.graphics.beginFill(16711680);
            this.maskSprite.graphics.drawRect(0, 0, this.shadow.width, this.shadow.height);
            this.maskSprite.graphics.endFill();
            this.mask = this.maskSprite;
            addEventListener(MouseEvent.MOUSE_UP, this.mouseUpHandler);
        }

        private function scroll(param1:Event):void
        {
            var _loc2_:Number = NaN;
            var _loc3_:Number = NaN;
            var _loc4_:Number = NaN;
            var _loc5_:Number = NaN;
            if (mouseX > 0 && mouseX < 250 && mouseY > 0 && mouseY < this.fullHeight)
            {
                _loc2_ = this.fullHeight / 2;
                _loc3_ = _loc2_ - mouseY;
                _loc4_ = _loc3_ / _loc2_;
                _loc5_ = _loc4_ * 10;
                this.comments.y += _loc5_;
                if (this.comments.y + this.comments.height < this.fullHeight)
                {
                    this.comments.y = this.fullHeight - this.comments.height;
                }
                if (this.comments.y > 0)
                {
                    this.comments.y = 0;
                }
            }
        }

        private function mouseUpHandler(param1:MouseEvent):void
        {
            var _loc2_:String = null;
            switch (param1.target)
            {
                case this.playButton:
                    Tracker.trackEvent(Tracker.LEVEL_BROWSER, Tracker.LOAD_LEVEL, "levelID_" + this._levelDataObject.id);
                    dispatchEvent(new NavigationEvent(NavigationEvent.SESSION, this._levelDataObject));
                    break;
                case this.authorLevelsButton:
                    Tracker.trackEvent(Tracker.LEVEL_BROWSER, Tracker.GET_LEVELS_BY_AUTHOR, "authorID_" + this._levelDataObject.author_id);
                    dispatchEvent(new BrowserEvent(BrowserEvent.USER, this._levelDataObject));
                    break;
                case this.viewReplaysButton:
                    Tracker.trackEvent(Tracker.LEVEL_BROWSER, Tracker.GOTO_REPLAY_BROWSER, "levelID_" + this._levelDataObject.id);
                    dispatchEvent(new NavigationEvent(NavigationEvent.REPLAY_BROWSER, this._levelDataObject));
                    break;
                case this.importButton:
                    break;
                case this.flagButton:
                    dispatchEvent(new BrowserEvent(BrowserEvent.FLAG, this._levelDataObject.id));
                    flaggedLevels.push(this._levelDataObject.id);
                    this.flagButton.disabled = true;
                    break;
                case this.favoriteButton:
                    if (Settings.favoriteLevelIds.indexOf(this._levelDataObject.id) > -1)
                    {
                        _loc2_ = BrowserEvent.REMOVE_FROM_FAVORITES;
                        Tracker.trackEvent(Tracker.LEVEL_BROWSER, Tracker.REMOVE_FAVORITE);
                    }
                    else
                    {
                        _loc2_ = BrowserEvent.ADD_TO_FAVORITES;
                        Tracker.trackEvent(Tracker.LEVEL_BROWSER, Tracker.ADD_FAVORITE);
                    }
                    dispatchEvent(new BrowserEvent(_loc2_, this._levelDataObject.id));
                    this.favoriteButton.disabled = true;
            }
        }

        private function importButtonRoll(param1:MouseEvent):void
        {
            MouseHelper.instance.show("Importing has been abused, so I\'m disabling it for a while to see if things get better.", this.importButton);
        }

        public function get levelDataObject():LevelDataObject
        {
            return this._levelDataObject;
        }

        public function get maskHeight():Number
        {
            return this.maskSprite.height;
        }

        public function set maskHeight(param1:Number):void
        {
            this.shadow.height = this.maskSprite.height = param1;
        }

        public function die():void
        {
            removeEventListener(Event.ENTER_FRAME, this.scroll);
            removeEventListener(MouseEvent.MOUSE_UP, this.mouseUpHandler);
            this.importButton.removeEventListener(MouseEvent.ROLL_OVER, this.importButtonRoll);
        }
    }
}
