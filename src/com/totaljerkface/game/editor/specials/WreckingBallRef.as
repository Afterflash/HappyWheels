package com.totaljerkface.game.editor.specials
{
    import com.totaljerkface.game.editor.RefSprite;
    import flash.display.Sprite;

    [Embed(source="/_assets/assets.swf", symbol="symbol655")]
    public class WreckingBallRef extends Special
    {
        public var ball:Sprite;

        public var arrows:Sprite;

        public var rope:Sprite;

        protected var minLength:Number = 200;

        protected var maxLength:Number = 1000;

        protected var minSpeed:int = 0;

        protected var maxSpeed:int = 7;

        private var _ropeLength:int = 350;

        private var _ballSpeed:int = 4;

        public function WreckingBallRef()
        {
            super();
            name = "wrecking ball";
            _shapesUsed = 3;
            _rotatable = false;
            _scalable = false;
            _triggerable = true;
            _triggers = new Array();
            mouseChildren = false;
        }

        override public function setAttributes():void
        {
            _type = "WreckingBallRef";
            _attributes = ["x", "y", "ropeLength"];
        }

        override public function clone():RefSprite
        {
            var _loc1_:WreckingBallRef = null;
            _loc1_ = new WreckingBallRef();
            _loc1_.x = x;
            _loc1_.y = y;
            _loc1_.ropeLength = this._ropeLength;
            return _loc1_;
        }

        public function get ropeLength():int
        {
            return this._ropeLength;
        }

        public function set ropeLength(param1:int):void
        {
            if (param1 < this.minLength)
            {
                param1 = this.minLength;
            }
            if (param1 > this.maxLength)
            {
                param1 = this.maxLength;
            }
            this._ropeLength = param1;
            this.rope.height = param1;
            this.ball.y = this._ropeLength;
            this.arrows.width = this.ball.y * 2 + 150;
            this.arrows.scaleY = this.arrows.scaleX;
            if (_selected)
            {
                drawBoundingBox();
            }
            x = x;
            y = y;
        }

        public function get ballSpeed():int
        {
            return this._ballSpeed;
        }

        public function set ballSpeed(param1:int):void
        {
            if (param1 < this.minSpeed)
            {
                param1 = this.minSpeed;
            }
            if (param1 > this.maxSpeed)
            {
                param1 = this.maxSpeed;
            }
            this._ballSpeed = param1;
        }
    }
}
