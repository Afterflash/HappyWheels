package com.totaljerkface.game.editor.specials
{
    import com.totaljerkface.game.editor.*;
    import flash.display.MovieClip;

    [Embed(source="/_assets/assets.swf", symbol="symbol1078")]
    public class PaddleRef extends Special
    {
        public var paddle:MovieClip;

        private var minDelay:Number = 0;

        private var maxDelay:Number = 2;

        private var _springDelay:Number = 0;

        private var _reverse:Boolean = false;

        private var _paddleAngle:Number = 90;

        private var _paddleSpeed:Number = 10;

        public function PaddleRef()
        {
            super();
            name = "paddle platform";
            _shapesUsed = 3;
            _rotatable = true;
            _scalable = false;
        }

        override public function setAttributes():void
        {
            _type = "PaddleRef";
            _attributes = ["x", "y", "angle", "springDelay", "reverse", "paddleAngle", "paddleSpeed"];
        }

        override public function clone():RefSprite
        {
            var _loc1_:PaddleRef = new PaddleRef();
            _loc1_.x = x;
            _loc1_.y = y;
            _loc1_.angle = angle;
            _loc1_.springDelay = this.springDelay;
            _loc1_.reverse = this.reverse;
            _loc1_.paddleAngle = this.paddleAngle;
            _loc1_.paddleSpeed = this.paddleSpeed;
            return _loc1_;
        }

        public function get reverse():Boolean
        {
            return this._reverse;
        }

        public function set reverse(param1:Boolean):void
        {
            if (this._reverse != param1)
            {
                this.paddle.timer.x *= -1;
                this.paddle.nub.x *= -1;
                this.paddle.arrow.x *= -1;
            }
            this._reverse = param1;
        }

        public function get paddleAngle():Number
        {
            return this._paddleAngle;
        }

        public function set paddleAngle(param1:Number):void
        {
            if (param1 > 90)
            {
                param1 = 90;
            }
            if (param1 < 15)
            {
                param1 = 15;
            }
            this._paddleAngle = param1;
        }

        public function get paddleSpeed():Number
        {
            return this._paddleSpeed;
        }

        public function set paddleSpeed(param1:Number):void
        {
            if (param1 > 10)
            {
                param1 = 10;
            }
            if (param1 < 1)
            {
                param1 = 1;
            }
            this._paddleSpeed = param1;
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
