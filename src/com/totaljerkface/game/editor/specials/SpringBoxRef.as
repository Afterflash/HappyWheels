package com.totaljerkface.game.editor.specials
{
    import com.totaljerkface.game.editor.RefSprite;

    [Embed(source="/_assets/assets.swf", symbol="symbol1002")]
    public class SpringBoxRef extends Special
    {
        private var minDelay:Number = 0;

        private var maxDelay:Number = 2;

        private var _springDelay:Number = 0;

        public function SpringBoxRef()
        {
            super();
            name = "spring platform";
            _shapesUsed = 4;
            _rotatable = true;
            _scalable = false;
        }

        override public function setAttributes():void
        {
            _type = "SpringBoxRef";
            _attributes = ["x", "y", "angle", "springDelay"];
        }

        override public function clone():RefSprite
        {
            var _loc1_:SpringBoxRef = null;
            _loc1_ = new SpringBoxRef();
            _loc1_.x = x;
            _loc1_.y = y;
            _loc1_.angle = angle;
            _loc1_.springDelay = this.springDelay;
            return _loc1_;
        }

        public function get springDelay():Number
        {
            return this._springDelay;
        }

        public function set springDelay(param1:Number):void
        {
            if (param1 < this.minDelay)
            {
                param1 = this.minDelay;
            }
            if (param1 > this.maxDelay)
            {
                param1 = this.maxDelay;
            }
            this._springDelay = param1;
        }
    }
}
