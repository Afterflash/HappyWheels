package com.totaljerkface.game.editor.specials
{
    import com.totaljerkface.game.editor.RefSprite;
    import flash.display.MovieClip;

    [Embed(source="/_assets/assets.swf", symbol="symbol912")]
    public class TokenRef extends Special
    {
        public var container:MovieClip;

        private var _tokenType:int = 1;

        public function TokenRef()
        {
            super();
            name = "token";
            _shapesUsed = 1;
            _scalable = false;
            _rotatable = false;
            _groupable = false;
            this.container.gotoAndStop(1);
            this.container.container.gotoAndStop(this._tokenType);
        }

        override public function setAttributes():void
        {
            _type = "TokenRef";
            _attributes = ["x", "y", "tokenType"];
        }

        override public function clone():RefSprite
        {
            var _loc1_:TokenRef = null;
            _loc1_ = new TokenRef();
            _loc1_.x = x;
            _loc1_.y = y;
            _loc1_.tokenType = this._tokenType;
            return _loc1_;
        }

        public function get tokenType():int
        {
            return this._tokenType;
        }

        public function set tokenType(param1:int):void
        {
            if (param1 > 6)
            {
                param1 = 6;
            }
            if (param1 < 1)
            {
                param1 = 1;
            }
            this.container.container.gotoAndStop(param1);
            this._tokenType = param1;
        }
    }
}
