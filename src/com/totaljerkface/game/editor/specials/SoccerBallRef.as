package com.totaljerkface.game.editor.specials
{
    import com.totaljerkface.game.editor.RefSprite;

    [Embed(source="/_assets/assets.swf", symbol="symbol1038")]
    public class SoccerBallRef extends Special
    {
        public function SoccerBallRef()
        {
            super();
            name = "soccer ball";
            _shapesUsed = 1;
            _rotatable = false;
            _scalable = false;
        }

        override public function setAttributes():void
        {
            _type = "SoccerBallRef";
            _attributes = ["x", "y"];
        }

        override public function clone():RefSprite
        {
            var _loc1_:SoccerBallRef = null;
            _loc1_ = new SoccerBallRef();
            _loc1_.x = x;
            _loc1_.y = y;
            return _loc1_;
        }
    }
}
