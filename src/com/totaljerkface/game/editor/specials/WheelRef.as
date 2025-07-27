package com.totaljerkface.game.editor.specials
{
    import com.totaljerkface.game.editor.RefSprite;
    import flash.display.MovieClip;
    
    public class WheelRef extends Special
    {
        public var inner:MovieClip;
        
        private var _wheelType:int = 1;
        
        public function WheelRef()
        {
            super();
            name = "wheel";
            _shapesUsed = 1;
        }
        
        override public function setAttributes() : void
        {
            _type = "WheelRef";
            _attributes = ["x","y","wheelType"];
        }
        
        public function set wheelType(param1:int) : void
        {
            trace("wheel type: " + param1);
            if(param1 < 1)
            {
                param1 = 1;
            }
            if(param1 > 10)
            {
                param1 = 10;
            }
            this._wheelType = param1;
        }
        
        public function get wheelType() : int
        {
            return this._wheelType;
        }
        
        override public function clone() : RefSprite
        {
            var _loc1_:WheelRef = null;
            _loc1_ = new WheelRef();
            _loc1_.x = x;
            _loc1_.y = y;
            _loc1_.wheelType = this.wheelType;
            return _loc1_;
        }
    }
}

