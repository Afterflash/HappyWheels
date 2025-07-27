package com.totaljerkface.game.menus
{
    import flash.display.*;
    import flash.events.*;
    import flash.filters.*;
    import flash.text.*;

    [Embed(source="/_assets/assets.swf", symbol="symbol97")]
    public class VotingStars extends Sprite
    {
        public static const RATING_SELECTED:String = "ratingselected";

        public var starMask:Sprite;

        public var publicFiller:Sprite;

        private var filler:Sprite;

        private var hitBox:Sprite;

        private var textField:TextField;

        private var textBg:Sprite;

        private var textBox:Sprite;

        private var _publicRating:Number;

        private var _rating:int;

        private var maxRating:Number = 5;

        private var starWidth:int = 30;

        private var fullWidth:int = 150;

        private var levelRatings:Array = ["0 - godawful", "1 - shitty", "2 - meh", "3 - good", "4 - pretty great", "5 - superb!"];

        public function VotingStars(param1:Number = 0, param2:Array = null, param3:uint = 16777062)
        {
            super();
            this.publicRating = param1;
            if (param2)
            {
                this.levelRatings = param2;
            }
            this.buildHitBox();
            this.createFiller(param3);
            this.rollOutHandler();
            mouseChildren = false;
            buttonMode = true;
            tabEnabled = false;
            addEventListener(MouseEvent.ROLL_OUT, this.rollOutHandler);
            addEventListener(MouseEvent.ROLL_OVER, this.rollOverHandler);
            addEventListener(MouseEvent.MOUSE_MOVE, this.mouseMoveHandler);
            addEventListener(MouseEvent.MOUSE_UP, this.mouseUpHandler);
        }

        private function createFiller(param1:uint):void
        {
            this.filler = new Sprite();
            addChild(this.filler);
            this.filler.graphics.beginFill(param1, 1);
            this.filler.graphics.drawRect(0, 0, 150, 30);
            this.filler.graphics.endFill();
            this.filler.mask = this.starMask;
        }

        private function addTextBox():void
        {
            var _loc1_:TextFormat = new TextFormat("HelveticaNeueLT Std Med", 12, 16777215, null, null, null, null, null, TextFormatAlign.LEFT);
            this.textField = new TextField();
            this.textField.defaultTextFormat = _loc1_;
            this.textField.autoSize = TextFieldAutoSize.LEFT;
            this.textField.width = 20;
            this.textField.height = 20;
            this.textField.x = 3;
            this.textField.y = 3;
            this.textField.multiline = false;
            this.textField.selectable = false;
            this.textField.embedFonts = true;
            this.textField.antiAliasType = AntiAliasType.ADVANCED;
            this.textBg = new Sprite();
            this.textBox = new Sprite();
            addChild(this.textBox);
            this.textBox.addChild(this.textBg);
            this.textBox.addChild(this.textField);
            var _loc2_:DropShadowFilter = new DropShadowFilter(10, 90, 0, 1, 7, 7, 0.2, 3);
            this.textBox.filters = [_loc2_];
        }

        private function removeTextBox():void
        {
            removeChild(this.textBox);
            this.textBox = null;
        }

        private function drawBg():void
        {
            this.textBg.graphics.clear();
            this.textBg.graphics.lineStyle(1, 10066329, 1, true);
            this.textBg.graphics.beginFill(13421772, 1);
            this.textBg.graphics.drawRect(0, 0, Math.ceil(this.textField.width) + 5, Math.ceil(this.textField.height) + 5);
            this.textBg.graphics.endFill();
        }

        public function setText():void
        {
            this.textField.htmlText = this.levelRatings[this._rating];
            this.textField.width = 10;
            this.textField.autoSize = TextFieldAutoSize.LEFT;
            this.textField.wordWrap = false;
            this.drawBg();
        }

        private function buildHitBox():void
        {
            this.hitBox = new Sprite();
            this.hitBox.graphics.beginFill(0);
            this.hitBox.graphics.drawRect(-20, 0, 190, 29);
            this.hitBox.graphics.endFill();
            addChild(this.hitBox);
            hitArea = this.hitBox;
            this.hitBox.visible = false;
        }

        private function mouseMoveHandler(param1:MouseEvent):void
        {
            var _loc2_:Number = Math.max(Math.min(Math.ceil(mouseX / this.starWidth), 5), 0);
            this.rating = _loc2_;
            if (this.textBox)
            {
                this.setText();
                this.drawBg();
                this.textBox.x = mouseX + 20;
                this.textBox.y = mouseY + 10;
            }
        }

        private function rollOutHandler(param1:MouseEvent = null):void
        {
            this._rating = -1;
            this.filler.scaleX = 0;
            if (this.textBox)
            {
                this.removeTextBox();
            }
        }

        private function rollOverHandler(param1:MouseEvent):void
        {
            if (!this.textBox)
            {
                this.addTextBox();
            }
        }

        private function mouseUpHandler(param1:MouseEvent):void
        {
            buttonMode = false;
            if (this.textBox)
            {
                this.removeTextBox();
            }
            removeEventListener(MouseEvent.ROLL_OUT, this.rollOutHandler);
            removeEventListener(MouseEvent.ROLL_OVER, this.rollOverHandler);
            removeEventListener(MouseEvent.MOUSE_MOVE, this.mouseMoveHandler);
            removeEventListener(MouseEvent.MOUSE_UP, this.mouseUpHandler);
            dispatchEvent(new Event(RATING_SELECTED));
        }

        public function get publicRating():Number
        {
            return this._publicRating;
        }

        public function set publicRating(param1:Number):void
        {
            this._publicRating = param1;
            this.publicFiller.scaleX = param1 / this.maxRating;
        }

        public function get rating():int
        {
            return this._rating;
        }

        public function set rating(param1:int):void
        {
            this._rating = param1;
            this.filler.scaleX = Math.max(0, this._rating) / this.maxRating;
        }

        private function setCaption():void
        {
            if (this._rating > -1)
            {
                this.textField.text = this.levelRatings[this._rating];
            }
        }

        public function die():void
        {
            removeEventListener(MouseEvent.ROLL_OUT, this.rollOutHandler);
            removeEventListener(MouseEvent.ROLL_OVER, this.rollOverHandler);
            removeEventListener(MouseEvent.MOUSE_MOVE, this.mouseMoveHandler);
            removeEventListener(MouseEvent.MOUSE_UP, this.mouseUpHandler);
        }
    }
}
