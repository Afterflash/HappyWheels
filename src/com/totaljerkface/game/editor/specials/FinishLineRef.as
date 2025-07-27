package com.totaljerkface.game.editor.specials
{
    import com.totaljerkface.game.editor.RefSprite;

    [Embed(source="/_assets/assets.swf", symbol="symbol2647")]
    public class FinishLineRef extends Special
    {
        public function FinishLineRef()
        {
            super();
            name = "finish line";
            _shapesUsed = 1;
            _rotatable = false;
            _scalable = false;
        }

        override public function setAttributes():void
        {
            _type = "FinishLineRef";
            _attributes = ["x", "y"];
        }

        override public function clone():RefSprite
        {
            var _loc1_:FinishLineRef = null;
            _loc1_ = new FinishLineRef();
            _loc1_.x = x;
            _loc1_.y = y;
            return _loc1_;
        }
    }
}
