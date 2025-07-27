package com.totaljerkface.game.editor.specials
{
    import com.totaljerkface.game.editor.RefSprite;
    import flash.display.MovieClip;

    [Embed(source="/_assets/assets.swf", symbol="symbol1058")]
    public class SignPostRef extends Special
    {
        public static const TOTAL_SIGN_TYPES:int = 13;

        public var container:MovieClip;

        private var _sleeping:Boolean = false;

        private var _signPostType:int = 1;

        private var _hasPost:Boolean;

        private var _postMC:MovieClip;

        public function SignPostRef()
        {
            super();
            name = "sign";
            _shapesUsed = 0;
            _artUsed = 1;
            _rotatable = true;
            _scalable = false;
            _joinable = false;
            _groupable = true;
            this.signPost = true;
            this.container.gotoAndStop(1);
        }

        override public function setAttributes():void
        {
            _type = "SignPostRef";
            _attributes = ["x", "y", "angle", "signPostType", "signPost"];
        }

        override public function clone():RefSprite
        {
            var _loc1_:SignPostRef = new SignPostRef();
            _loc1_.x = x;
            _loc1_.y = y;
            _loc1_.angle = angle;
            _loc1_.groupable = _groupable;
            _loc1_.signPostType = this._signPostType;
            _loc1_.signPost = this._hasPost;
            return _loc1_;
        }

        public function get signPost():Boolean
        {
            return this._hasPost;
        }

        public function set signPost(param1:Boolean):void
        {
            if (this._hasPost == param1)
            {
                return;
            }
            if (param1)
            {
                this._postMC = new PostMC();
                this.container.addChildAt(this._postMC, 0);
            }
            else
            {
                this._postMC.parent.removeChild(this._postMC);
            }
            if (_selected)
            {
                drawBoundingBox();
            }
            this._hasPost = param1;
        }

        public function get signPostType():int
        {
            return this._signPostType;
        }

        public function set signPostType(param1:int):void
        {
            if (param1 < 1)
            {
                param1 = 1;
            }
            if (param1 > TOTAL_SIGN_TYPES)
            {
                param1 = TOTAL_SIGN_TYPES;
            }
            this.container.gotoAndStop(param1);
            if (_selected)
            {
                drawBoundingBox();
            }
            this._signPostType = param1;
        }
    }
}
