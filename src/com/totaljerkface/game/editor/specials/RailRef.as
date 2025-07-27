package com.totaljerkface.game.editor.specials
{
    import com.totaljerkface.game.editor.RefSprite;
    import flash.display.Sprite;

    [Embed(source="/_assets/assets.swf", symbol="symbol1063")]
    public class RailRef extends Special
    {
        public var inner:Sprite;

        protected var minXDimension:Number = 1;

        protected var maxXDimension:Number = 20;

        protected var minYDimension:Number = 1;

        protected var maxYDimension:Number = 1;

        public function RailRef()
        {
            super();
            name = "rail";
            _shapesUsed = 2;
            _rotatable = true;
            _scalable = true;
            _joinable = false;
            _groupable = false;
            this.shapeWidth = 250;
        }

        override public function setAttributes():void
        {
            _type = "RailRef";
            _attributes = ["x", "y", "shapeWidth", "shapeHeight", "angle"];
        }

        override public function clone():RefSprite
        {
            var _loc1_:RailRef = null;
            _loc1_ = new RailRef();
            _loc1_.x = x;
            _loc1_.y = y;
            _loc1_.angle = angle;
            _loc1_.scaleX = scaleX;
            _loc1_.scaleY = scaleY;
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
            return Math.round(scaleX * 100);
        }

        override public function set shapeWidth(param1:Number):void
        {
            this.scaleX = param1 / 100;
        }

        override public function get shapeHeight():Number
        {
            return 18;
        }

        override public function set shapeHeight(param1:Number):void
        {
            this.scaleY = 1;
        }
    }
}
