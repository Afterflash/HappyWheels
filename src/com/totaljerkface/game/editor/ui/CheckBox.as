package com.totaljerkface.game.editor.ui
{
    import flash.display.*;
    import flash.events.MouseEvent;
    import flash.text.*;

    [Embed(source="/_assets/assets.swf", symbol="symbol822")]
    public class CheckBox extends InputObject
    {
        public var labelText:TextField;

        public var box:Sprite;

        public var check:Sprite;

        public var dash:Sprite;

        private var _selected:Boolean;

        public var oppositeDependent:Boolean;

        public function CheckBox(param1:String, param2:String, param3:Boolean = true, param4:Boolean = true, param5:Boolean = false, param6:Object = null)
        {
            super();
            this.labelText.text = param1;
            if (param6)
            {
                this.labelText.textColor = uint(param6);
            }
            this.attribute = param2;
            childInputs = new Array();
            _editable = true;
            this.selected = param3;
            this.editable = param4;
            this.oppositeDependent = param5;
            this.init();
        }

        public function addChildInput(param1:InputObject):void
        {
            childInputs.push(param1);
            if (!this._selected)
            {
                param1.editable = this.oppositeDependent;
            }
            if (this._selected)
            {
                param1.editable = !this.oppositeDependent;
            }
            param1.addEventListener(ValueEvent.VALUE_CHANGE, this.childValueChange);
        }

        private function init():void
        {
            this.labelText.mouseEnabled = false;
            this.check.mouseEnabled = false;
            this.dash.mouseEnabled = false;
            this.labelText.autoSize = TextFieldAutoSize.LEFT;
            this.labelText.wordWrap = false;
            this.box.addEventListener(MouseEvent.MOUSE_DOWN, this.mouseDownHandler);
        }

        private function mouseDownHandler(param1:MouseEvent):void
        {
            if (this.selected == false)
            {
                this.selected = true;
            }
            else
            {
                this.selected = false;
            }
            dispatchEvent(new ValueEvent(ValueEvent.VALUE_CHANGE, this, this._selected));
        }

        private function childValueChange(param1:ValueEvent):void
        {
            dispatchEvent(param1.clone());
        }

        public function get selected():Boolean
        {
            return this._selected;
        }

        public function set selected(param1:Boolean):void
        {
            var _loc2_:int = 0;
            var _loc3_:InputObject = null;
            if (!_editable)
            {
                return;
            }
            this._selected = param1;
            _ambiguous = false;
            this.dash.visible = false;
            if (this._selected)
            {
                this.check.visible = true;
                _loc2_ = 0;
                while (_loc2_ < childInputs.length)
                {
                    _loc3_ = childInputs[_loc2_];
                    _loc3_.editable = !this.oppositeDependent;
                    _loc2_++;
                }
            }
            else
            {
                this.check.visible = false;
                _loc2_ = 0;
                while (_loc2_ < childInputs.length)
                {
                    _loc3_ = childInputs[_loc2_];
                    _loc3_.editable = this.oppositeDependent;
                    _loc2_++;
                }
            }
        }

        override public function set editable(param1:Boolean):void
        {
            _editable = param1;
            if (param1)
            {
                alpha = 1;
                mouseEnabled = true;
                this.dash.visible = false;
                if (this._selected)
                {
                    this.check.visible = true;
                }
            }
            else
            {
                alpha = 0.5;
                mouseEnabled = false;
                this.dash.visible = true;
                this.check.visible = false;
            }
        }

        override public function setToAmbiguous():void
        {
            var _loc2_:InputObject = null;
            this.dash.visible = true;
            this.check.visible = false;
            this._selected = false;
            _ambiguous = true;
            var _loc1_:int = 0;
            while (_loc1_ < childInputs.length)
            {
                _loc2_ = childInputs[_loc1_];
                _loc2_.editable = false;
                _loc1_++;
            }
        }

        override public function setValue(param1:*):void
        {
            this.selected = param1;
        }

        override public function die():void
        {
            var _loc2_:InputObject = null;
            super.die();
            this.box.removeEventListener(MouseEvent.MOUSE_DOWN, this.mouseDownHandler);
            var _loc1_:int = 0;
            while (_loc1_ < childInputs.length)
            {
                _loc2_ = childInputs[_loc1_];
                _loc2_.removeEventListener(ValueEvent.VALUE_CHANGE, this.childValueChange);
                _loc2_.die();
                _loc1_++;
            }
            childInputs = new Array();
        }
    }
}
