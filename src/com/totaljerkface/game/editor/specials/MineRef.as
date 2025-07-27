package com.totaljerkface.game.editor.specials
{
    import com.totaljerkface.game.editor.RefSprite;

    [Embed(source="/_assets/assets.swf", symbol="symbol2584")]
    public class MineRef extends Special
    {
        public function MineRef()
        {
            super();
            name = "landmine";
            rotatable = true;
            scalable = false;
            _triggerable = true;
            _triggers = new Array();
        }

        override public function setAttributes():void
        {
            _type = "MineRef";
            _shapesUsed = 2;
            _attributes = ["x", "y", "angle"];
        }

        override public function clone():RefSprite
        {
            var _loc1_:MineRef = null;
            _loc1_ = new MineRef();
            _loc1_.x = x;
            _loc1_.y = y;
            _loc1_.angle = angle;
            return _loc1_;
        }
    }
}
