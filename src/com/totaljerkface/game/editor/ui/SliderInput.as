package com.totaljerkface.game.editor.ui
{
    import flash.display.*;
    import flash.events.KeyboardEvent;
    import flash.events.MouseEvent;
    import flash.text.*;

    [Embed(source="/_assets/assets.swf", symbol="symbol727")]
    public class SliderInput extends TextInput
    {
        public var sliderTab:Sprite;

        public var sliderLine:Sprite;

        public var sliderBG:Sprite;

        protected var min:Number;

        protected var max:Number;

        protected var divisions:Number;

        protected var step:Number;

        protected var valueStep:Number;

        protected var valueRange:Number;

        public function SliderInput(param1:String, param2:String, param3:int, param4:Boolean, param5:Number, param6:Number, param7:Number)
        {
            super(param1, param2, param3, param4);
            this.min = param5;
            this.max = param6;
            this.valueRange = param6 - param5;
            this.divisions = param7;
            this.step = 100 / param7;
            this.valueStep = this.valueRange / param7;
        }

        override protected function init():void
        {
            super.init();
            this.sliderLine.mouseEnabled = false;
            if (this.sliderBG)
            {
                this.sliderBG.addEventListener(MouseEvent.MOUSE_DOWN, this.mouseDownHandler);
            }
            this.sliderTab.addEventListener(MouseEvent.MOUSE_DOWN, this.mouseDownHandler);
        }

        override protected function keyDownHandler(param1:KeyboardEvent):void
        {
            var _loc2_:Number = NaN;
            if (param1.keyCode == 13)
            {
                _loc2_ = Number(inputText.text);
                if (isNaN(_loc2_))
                {
                    _loc2_ = this.min;
                }
                if (_loc2_ < this.min)
                {
                    _loc2_ = this.min;
                }
                if (_loc2_ > this.max)
                {
                    _loc2_ = this.max;
                }
                currentString = String(_loc2_);
                stage.focus = stage;
                dispatchEvent(new ValueEvent(ValueEvent.VALUE_CHANGE, this, currentString));
            }
            else if (param1.keyCode == 9 && !_ambiguous)
            {
                _loc2_ = Number(inputText.text);
                if (isNaN(_loc2_))
                {
                    _loc2_ = this.min;
                }
                if (_loc2_ < this.min)
                {
                    _loc2_ = this.min;
                }
                if (_loc2_ > this.max)
                {
                    _loc2_ = this.max;
                }
                currentString = String(_loc2_);
                dispatchEvent(new ValueEvent(ValueEvent.VALUE_CHANGE, this, currentString));
            }
        }

        protected function mouseDownHandler(param1:MouseEvent):void
        {
            stage.addEventListener(MouseEvent.MOUSE_UP, this.mouseUpHandler);
            stage.addEventListener(MouseEvent.MOUSE_MOVE, this.mouseTrack);
            this.mouseTrack(new MouseEvent(MouseEvent.MOUSE_DOWN));
        }

        protected function mouseUpHandler(param1:MouseEvent):void
        {
            stage.removeEventListener(MouseEvent.MOUSE_UP, this.mouseUpHandler);
            stage.removeEventListener(MouseEvent.MOUSE_MOVE, this.mouseTrack);
            currentString = inputText.text;
            dispatchEvent(new ValueEvent(ValueEvent.VALUE_CHANGE, this, currentString));
        }

        protected function mouseTrack(param1:MouseEvent):void
        {
            var _loc6_:String = null;
            var _loc7_:String = null;
            var _loc8_:Number = NaN;
            var _loc2_:int = Math.round((mouseX - this.sliderLine.x) / this.step);
            _loc2_ = _loc2_ < 0 ? 0 : _loc2_;
            _loc2_ = _loc2_ > this.divisions ? int(this.divisions) : _loc2_;
            var _loc3_:int = Math.round(_loc2_ * this.step);
            this.sliderTab.x = _loc3_ + this.sliderLine.x;
            this.sliderLine.width = _loc3_;
            var _loc4_:Number = this.min + _loc2_ * this.valueStep;
            var _loc5_:Array = _loc4_.toString().split(".");
            if (_loc5_[1])
            {
                _loc6_ = _loc5_[1];
                if (_loc6_.length > 2)
                {
                    _loc7_ = _loc6_.substr(0, 2) + "." + _loc6_.substr(2, 1);
                    _loc8_ = Math.round(Number(_loc7_));
                    _loc4_ = Number(_loc5_[0] + "." + _loc8_);
                }
            }
            text = _loc4_.toString();
        }

        override public function setValue(param1:*):void
        {
            var _loc3_:Number = NaN;
            super.setValue(param1);
            var _loc2_:Number = (param1 - this.min) / this.valueRange;
            _loc3_ = Math.round(_loc2_ * 100);
            this.sliderTab.x = _loc3_ + this.sliderLine.x;
            this.sliderLine.width = _loc3_;
        }

        override public function die():void
        {
            super.die();
            if (stage)
            {
                stage.removeEventListener(MouseEvent.MOUSE_UP, this.mouseUpHandler);
                stage.removeEventListener(MouseEvent.MOUSE_MOVE, this.mouseTrack);
            }
            this.sliderTab.removeEventListener(MouseEvent.MOUSE_DOWN, this.mouseDownHandler);
            if (this.sliderBG)
            {
                this.sliderBG.removeEventListener(MouseEvent.MOUSE_DOWN, this.mouseDownHandler);
            }
        }
    }
}
