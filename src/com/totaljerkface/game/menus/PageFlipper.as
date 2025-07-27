package com.totaljerkface.game.menus
{
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;

    [Embed(source="/_assets/assets.swf", symbol="symbol2992")]
    public class PageFlipper extends Sprite
    {
        public static const FLIP_PAGE:String = "flippage";

        public var textField:TextField;

        public var leftArrow:Sprite;

        public var rightArrow:Sprite;

        private const spacing:int = 5;

        private var _totalPages:int;

        private var _currentPage:int;

        private var _totalItems:int;

        private var _pageLength:int;

        public function PageFlipper(param1:int, param2:int, param3:int, param4:int)
        {
            super();
            this._currentPage = param1;
            this._totalPages = param2;
            this._pageLength = param3;
            this._totalItems = param4;
            this.textField.autoSize = TextFieldAutoSize.LEFT;
            this.textField.wordWrap = false;
            this.textField.multiline = false;
            this.setTextItems();
            this.leftArrow.buttonMode = this.rightArrow.buttonMode = true;
            addEventListener(MouseEvent.MOUSE_UP, this.mouseUpHandler);
        }

        private function setTextPages():void
        {
            this.textField.text = "page " + this._currentPage + " of " + this._totalPages;
            this.organize();
        }

        private function setTextItems():void
        {
            var _loc1_:int = (this._currentPage - 1) * this._pageLength + 1;
            var _loc2_:int = Math.min(this._currentPage * this._pageLength, this._totalItems);
            this.textField.text = "" + _loc1_ + " - " + _loc2_ + " of " + this._totalItems + " items";
            this.organize();
        }

        private function organize():void
        {
            this.leftArrow.x = this.rightArrow.x - this.spacing;
            this.textField.x = this.leftArrow.x - this.leftArrow.width - this.textField.width;
            if (this._currentPage == 1)
            {
                this.leftArrow.alpha = 0.3;
                this.leftArrow.mouseEnabled = false;
            }
            else
            {
                this.leftArrow.alpha = 1;
                this.leftArrow.mouseEnabled = true;
            }
            if (this._currentPage == this._totalPages)
            {
                this.rightArrow.alpha = 0.3;
                this.rightArrow.mouseEnabled = false;
            }
            else
            {
                this.rightArrow.alpha = 1;
                this.rightArrow.mouseEnabled = true;
            }
        }

        private function mouseUpHandler(param1:MouseEvent):void
        {
            switch (param1.target)
            {
                case this.leftArrow:
                    this.flipPage(-1);
                    break;
                case this.rightArrow:
                    this.flipPage(1);
            }
        }

        private function flipPage(param1:int):void
        {
            var _loc2_:int = this._currentPage + param1;
            if (_loc2_ <= this._totalPages && _loc2_ > 0)
            {
                this._currentPage = _loc2_;
                this.setTextItems();
                dispatchEvent(new Event(FLIP_PAGE));
            }
        }

        public function get currentPage():int
        {
            return this._currentPage;
        }

        public function die():void
        {
            removeEventListener(MouseEvent.MOUSE_UP, this.mouseUpHandler);
        }
    }
}
