package com.totaljerkface.game.editor.specials
{
    import com.totaljerkface.game.editor.RefSprite;

    [Embed(source="/_assets/assets.swf", symbol="symbol2674")]
    public class FanRef extends Special
    {
        public function FanRef()
        {
            super();
            _shapesUsed = 3;
            name = "fan";
            rotatable = true;
            scalable = false;
            _triggerable = true;
            _triggers = new Array();
        }

        override public function setAttributes():void
        {
            _type = "FanRef";
            _attributes = ["x", "y", "angle"];
        }

        override public function clone():RefSprite
        {
            var _loc1_:FanRef = null;
            _loc1_ = new FanRef();
            _loc1_.x = x;
            _loc1_.y = y;
            _loc1_.angle = angle;
            return _loc1_;
        }
    }
}
