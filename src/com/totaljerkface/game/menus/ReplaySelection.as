package com.totaljerkface.game.menus
{
    import com.totaljerkface.game.*;
    import com.totaljerkface.game.editor.ui.*;
    import com.totaljerkface.game.events.*;
    import com.totaljerkface.game.utils.*;
    import flash.display.*;
    import flash.events.*;
    import flash.text.*;

    [Embed(source="/_assets/assets.swf", symbol="symbol2971")]
    public class ReplaySelection extends Sprite
    {
        private static var flaggedReplays:Array = [];

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

        private var flagButton:GenericButton;

        private var _replayDataObject:ReplayDataObject;

        public const fullHeight:Number = 110;

        public function ReplaySelection(param1:ReplayDataObject)
        {
            super();
            this._replayDataObject = param1;
            this.shadow.mouseEnabled = false;
            this.descriptionText.autoSize = TextFieldAutoSize.LEFT;
            this.descriptionText.wordWrap = true;
            this.descriptionText.text = this._replayDataObject.comments;
            this.characterText.text = Settings.characterNames[this._replayDataObject.character - 1];
            this.avgRatingText.text = "" + TextUtils.setToHundredths(this._replayDataObject.average_rating) + " / 5.00 (" + this._replayDataObject.votes + " votes)";
            this.wtdRatingText.text = "" + TextUtils.setToHundredths(this._replayDataObject.weighted_rating) + " / 5.00 (" + this._replayDataObject.votes + " votes)";
            this.linkText.text = "http://www.totaljerkface.com/happy_wheels.tjf?replay_id=" + this._replayDataObject.id;
            this.flagButton = new GenericButton("flag as inappropriate", 13421772, 188, 6312772);
            this.flagButton.x = 535;
            this.flagButton.y = 77;
            if (flaggedReplays.indexOf(param1.id) > -1)
            {
                this.flagButton.disabled = true;
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
            switch (param1.target)
            {
                case this.playButton:
                    Tracker.trackEvent(Tracker.REPLAY_BROWSER, Tracker.LOAD_REPLAY, "replayID_" + this._replayDataObject.id);
                    dispatchEvent(new NavigationEvent(NavigationEvent.SESSION, null, this._replayDataObject));
                    break;
                case this.flagButton:
                    dispatchEvent(new BrowserEvent(BrowserEvent.FLAG, this._replayDataObject.id));
                    flaggedReplays.push(this._replayDataObject.id);
                    this.flagButton.disabled = true;
            }
        }

        public function get replayDataObject():ReplayDataObject
        {
            return this._replayDataObject;
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
        }
    }
}
