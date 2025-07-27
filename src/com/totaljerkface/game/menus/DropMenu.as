package com.totaljerkface.game.menus
{
    import flash.display.*;
    import flash.events.*;
    import flash.filters.DropShadowFilter;
    import flash.text.*;

    [Embed(source="/_assets/assets.swf", symbol="symbol3035")]
    public class DropMenu extends Sprite
    {
        public static const ITEM_SELECTED:String = "itemselected";

        public var bg:Sprite;

        public var currText:TextField;

        public var labelText:TextField;

        public var arrow:Sprite;

        private var displayList:Array;

        private var valueList:Array;

        private var open:Boolean;

        private var holder:Sprite;

        private var menuSprite:Sprite;

        private var menuItems:Array;

        private var itemHeight:Number = 22;

        private var _currentIndex:int;

        private var _value:*;

        private var _display:String;

        public function DropMenu(param1:String, param2:Array, param3:Array, param4:int = -1, param5:uint = 13421772)
        {
            super();
            this.displayList = param2;
            this.valueList = param3;
            mouseEnabled = false;
            this.currText.mouseEnabled = false;
            this.arrow.mouseEnabled = false;
            this.bg.alpha = 0;
            this.labelText.autoSize = TextFieldAutoSize.RIGHT;
            this.currText.autoSize = TextFieldAutoSize.LEFT;
            this.currText.wordWrap = this.labelText.wordWrap = false;
            this.currText.embedFonts = this.labelText.embedFonts = true;
            this.currText.selectable = this.labelText.selectable = false;
            this.currText.multiline = this.labelText.multiline = false;
            var _loc6_:int = param4 != -1 ? param4 : int(this.displayList.length - 1);
            this.currentIndex = _loc6_;
            this.labelText.text = param1;
            this.labelText.textColor = param5;
            this.holder = new Sprite();
            addChildAt(this.holder, 0);
            this.menuSprite = new Sprite();
            this.holder.addChild(this.bg);
            this.holder.addChild(this.menuSprite);
            var _loc7_:DropShadowFilter = new DropShadowFilter(3, 45, 0, 0.25, 8, 8, 1, 3);
            this.menuSprite.filters = [_loc7_];
            this.holder.addEventListener(MouseEvent.ROLL_OVER, this.rollOverHandler);
            this.holder.addEventListener(MouseEvent.ROLL_OUT, this.rollOutHandler);
            this.holder.addEventListener(MouseEvent.MOUSE_OVER, this.mouseOverHandler);
            this.holder.addEventListener(MouseEvent.MOUSE_DOWN, this.mouseDownHandler);
            this.holder.addEventListener(MouseEvent.MOUSE_UP, this.mouseUpHandler);
        }

        private function rollOverHandler(param1:MouseEvent):void
        {
            if (!this.open)
            {
                this.open = true;
                this.createMenu();
            }
        }

        private function rollOutHandler(param1:MouseEvent):void
        {
            if (this.open)
            {
                this.open = false;
                this.removeAll();
            }
        }

        private function mouseOverHandler(param1:MouseEvent):void
        {
            var _loc2_:DropMenuItem = null;
            this.deselectAll();
            if (param1.target is DropMenuItem)
            {
                _loc2_ = param1.target as DropMenuItem;
                if (!param1.buttonDown)
                {
                    _loc2_.rollOver();
                }
                else
                {
                    _loc2_.mouseDown();
                }
            }
        }

        private function mouseDownHandler(param1:MouseEvent):void
        {
            var _loc2_:DropMenuItem = null;
            if (param1.target is DropMenuItem)
            {
                _loc2_ = param1.target as DropMenuItem;
                _loc2_.mouseDown();
            }
        }

        private function mouseUpHandler(param1:MouseEvent):void
        {
            var _loc2_:DropMenuItem = null;
            if (param1.target is DropMenuItem)
            {
                this.removeAll();
                _loc2_ = param1.target as DropMenuItem;
                if (this.currentIndex != _loc2_.index)
                {
                    this.currentIndex = _loc2_.index;
                    dispatchEvent(new Event(ITEM_SELECTED));
                }
            }
        }

        private function deselectAll():void
        {
            var _loc2_:DropMenuItem = null;
            var _loc1_:int = 0;
            while (_loc1_ < this.menuItems.length)
            {
                _loc2_ = this.menuItems[_loc1_];
                _loc2_.rollOut();
                _loc1_++;
            }
        }

        private function removeAll():void
        {
            var _loc2_:DropMenuItem = null;
            var _loc1_:int = 0;
            while (_loc1_ < this.menuItems.length)
            {
                _loc2_ = this.menuItems[_loc1_];
                this.menuSprite.removeChild(_loc2_);
                _loc1_++;
            }
            this.menuItems = new Array();
        }

        private function createMenu():void
        {
            var _loc4_:String = null;
            var _loc5_:DropMenuItem = null;
            this.menuItems = new Array();
            var _loc1_:Number = this.bg.height;
            var _loc2_:Number = 0;
            var _loc3_:int = 0;
            while (_loc3_ < this.displayList.length)
            {
                _loc4_ = this.displayList[_loc3_];
                _loc5_ = new DropMenuItem(_loc4_, _loc3_);
                this.menuSprite.addChild(_loc5_);
                _loc5_.y = _loc1_;
                this.menuItems.push(_loc5_);
                _loc2_ = Math.max(_loc2_, _loc5_.textWidth);
                _loc1_ += this.itemHeight;
                _loc3_++;
            }
            _loc3_ = 0;
            while (_loc3_ < this.menuItems.length)
            {
                _loc5_ = this.menuItems[_loc3_];
                _loc5_.bgWidth = _loc2_ + 20;
                _loc3_++;
            }
        }

        public function get display():String
        {
            return this._display;
        }

        public function set display(param1:String):*
        {
            this._display = param1;
            this.currText.text = param1;
            this.arrow.x = this.currText.textWidth + 7;
            this.bg.width = this.arrow.x + this.arrow.width;
            this._currentIndex = this.displayList.indexOf(param1);
        }

        public function get value():*
        {
            return this._value;
        }

        public function get currentIndex():int
        {
            return this._currentIndex;
        }

        public function set currentIndex(param1:int):void
        {
            this._currentIndex = param1;
            this.display = this.displayList[param1];
            this._value = this.valueList[param1];
        }

        public function valueIndex(param1:*):int
        {
            return this.valueList.indexOf(param1);
        }

        public function get xLeft():Number
        {
            return x - this.labelText.width;
        }

        public function set xLeft(param1:Number):void
        {
            x = param1 + this.labelText.width;
        }

        public function containsValue(param1:*):Boolean
        {
            var _loc2_:int = int(this.valueList.indexOf(param1));
            if (_loc2_ == -1)
            {
                return false;
            }
            return true;
        }

        public function addValue(param1:String, param2:*):void
        {
            if (this.containsValue(param2))
            {
                return;
            }
            this.displayList.push(param1);
            this.valueList.push(param2);
        }

        public function die():void
        {
            this.holder.removeEventListener(MouseEvent.ROLL_OVER, this.rollOverHandler);
            this.holder.removeEventListener(MouseEvent.ROLL_OUT, this.rollOutHandler);
            this.holder.removeEventListener(MouseEvent.MOUSE_OVER, this.mouseOverHandler);
            this.holder.removeEventListener(MouseEvent.MOUSE_DOWN, this.mouseDownHandler);
            this.holder.removeEventListener(MouseEvent.MOUSE_UP, this.mouseUpHandler);
        }
    }
}
