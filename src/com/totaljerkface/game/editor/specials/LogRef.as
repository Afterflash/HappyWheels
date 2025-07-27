package com.totaljerkface.game.editor.specials
{
    import com.totaljerkface.game.editor.*;
    import flash.utils.Dictionary;

    [Embed(source="/_assets/assets.swf", symbol="symbol2591")]
    public class LogRef extends Special
    {
        protected var minXDimension:Number = 1;

        protected var maxXDimension:Number = 1.5;

        protected var minYDimension:Number = 0.5;

        protected var maxYDimension:Number = 1.5;

        protected var _immovable2:Boolean;

        protected var _sleeping:Boolean;

        public function LogRef()
        {
            _triggerable = true;
            _triggers = new Array();
            _triggerActions = new Dictionary();
            _triggerActionList = ["wake from sleep", "apply impulse"];
            _triggerActionListProperties = [null, ["impulseX", "impulseY", "spin"]];
            super();
            name = "log";
            _shapesUsed = 2;
            _rotatable = true;
            _scalable = true;
            _joinable = true;
            _joints = new Array();
            _keyedPropertyObject[_triggerString] = _triggerActions;
        }

        override public function setAttributes():void
        {
            _type = "LogRef";
            _attributes = ["x", "y", "shapeWidth", "shapeHeight", "angle", "immovable2", "sleeping"];
            addTriggerProperties();
        }

        override public function clone():RefSprite
        {
            var _loc1_:LogRef = null;
            _loc1_ = new LogRef();
            _loc1_.x = x;
            _loc1_.y = y;
            _loc1_.angle = angle;
            _loc1_.scaleX = scaleX;
            _loc1_.scaleY = scaleY;
            _loc1_._immovable2 = this.immovable2;
            _loc1_.sleeping = this.sleeping;
            transferKeyedProperties(_loc1_);
            return _loc1_;
        }

        override public function set scaleX(param1:Number):void
        {
            if (param1 < this.minXDimension)
            {
                param1 = this.minXDimension;
            }
            if (param1 > this.maxXDimension)
            {
                param1 = this.maxXDimension;
            }
            super.scaleX = param1;
        }

        override public function set scaleY(param1:Number):void
        {
            if (param1 < this.minYDimension)
            {
                param1 = this.minYDimension;
            }
            if (param1 > this.maxYDimension)
            {
                param1 = this.maxYDimension;
            }
            super.scaleY = param1;
        }

        override public function get shapeWidth():Number
        {
            return Math.round(scaleX * 36);
        }

        override public function set shapeWidth(param1:Number):void
        {
            this.scaleX = param1 / 36;
        }

        override public function get shapeHeight():Number
        {
            return Math.round(scaleY * 400);
        }

        override public function set shapeHeight(param1:Number):void
        {
            this.scaleY = param1 / 400;
        }

        public function get immovable2():Boolean
        {
            return this._immovable2;
        }

        public function set immovable2(param1:Boolean):void
        {
            this._immovable2 = param1;
        }

        override public function get joinable():Boolean
        {
            if (this._immovable2)
            {
                return false;
            }
            return _joinable;
        }

        public function get sleeping():Boolean
        {
            return this._sleeping;
        }

        public function set sleeping(param1:Boolean):void
        {
            this._sleeping = param1;
        }
    }
}
