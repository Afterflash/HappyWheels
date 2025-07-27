package com.totaljerkface.game.editor.specials
{
    import com.totaljerkface.game.editor.*;
    import flash.utils.Dictionary;

    [Embed(source="/_assets/assets.swf", symbol="symbol2588")]
    public class MeteorRef extends Special
    {
        protected var minDimension:Number = 0.5;

        protected var maxDimension:Number = 1.5;

        private var defWidth:Number = 400;

        private var defHeight:Number = 400;

        protected var _immovable2:Boolean;

        protected var _sleeping:Boolean;

        public function MeteorRef()
        {
            _triggerable = true;
            _triggers = new Array();
            _triggerActions = new Dictionary();
            _triggerActionList = ["wake from sleep", "apply impulse"];
            _triggerActionListProperties = [null, ["impulseX", "impulseY", "spin"]];
            super();
            _shapesUsed = 1;
            name = "meteor";
            rotatable = false;
            scalable = true;
            _keyedPropertyObject[_triggerString] = _triggerActions;
        }

        override public function setAttributes():void
        {
            _type = "MeteorRef";
            _attributes = ["x", "y", "shapeWidth", "shapeHeight", "immovable2", "sleeping"];
            addTriggerProperties();
        }

        override public function clone():RefSprite
        {
            var _loc1_:MeteorRef = null;
            _loc1_ = new MeteorRef();
            _loc1_.x = x;
            _loc1_.y = y;
            _loc1_.scaleX = scaleX;
            _loc1_.scaleY = scaleY;
            _loc1_._immovable2 = this.immovable2;
            _loc1_.sleeping = this.sleeping;
            transferKeyedProperties(_loc1_);
            return _loc1_;
        }

        override public function set scaleX(param1:Number):void
        {
            if (param1 < this.minDimension)
            {
                param1 = this.minDimension;
            }
            if (param1 > this.maxDimension)
            {
                param1 = this.maxDimension;
            }
            super.scaleX = param1;
        }

        override public function set scaleY(param1:Number):void
        {
            if (param1 < this.minDimension)
            {
                param1 = this.minDimension;
            }
            if (param1 > this.maxDimension)
            {
                param1 = this.maxDimension;
            }
            super.scaleY = param1;
        }

        override public function get shapeWidth():Number
        {
            return Math.round(scaleX * this.defWidth);
        }

        override public function set shapeWidth(param1:Number):void
        {
            this.scaleX = this.scaleY = param1 / this.defWidth;
        }

        override public function get shapeHeight():Number
        {
            return Math.round(scaleY * this.defHeight);
        }

        override public function set shapeHeight(param1:Number):void
        {
            this.scaleY = this.scaleX = param1 / this.defHeight;
        }

        public function get immovable2():Boolean
        {
            return this._immovable2;
        }

        public function set immovable2(param1:Boolean):void
        {
            this._immovable2 = param1;
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
