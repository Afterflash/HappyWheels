package com.totaljerkface.game.editor.specials
{
    import com.totaljerkface.game.editor.RefSprite;

    [Embed(source="/_assets/assets.swf", symbol="symbol2613")]
    public class HomingMineRef extends Special
    {
        private var _seekSpeed:int = 1;

        private var _explosionDelay:int = 0;

        private var _seekStyle:int = 1;

        public function HomingMineRef()
        {
            super();
            name = "homing mine";
            rotatable = false;
            scalable = false;
            _triggers = new Array();
            _triggerable = true;
        }

        override public function setAttributes():void
        {
            _type = "HomingMineRef";
            _shapesUsed = 4;
            _attributes = ["x", "y", "seekSpeed", "explosionDelay"];
        }

        override public function clone():RefSprite
        {
            var _loc1_:HomingMineRef = new HomingMineRef();
            _loc1_.x = x;
            _loc1_.y = y;
            _loc1_.seekSpeed = this.seekSpeed;
            _loc1_.explosionDelay = this.explosionDelay;
            return _loc1_;
        }

        public function get seekSpeed():int
        {
            return this._seekSpeed;
        }

        public function set seekSpeed(param1:int):void
        {
            if (param1 > 10)
            {
                param1 = 10;
            }
            if (param1 < 1)
            {
                param1 = 1;
            }
            this._seekSpeed = param1;
        }

        public function get explosionDelay():int
        {
            return this._explosionDelay;
        }

        public function set explosionDelay(param1:int):void
        {
            if (param1 > 5)
            {
                param1 = 5;
            }
            if (param1 < 0)
            {
                param1 = 0;
            }
            this._explosionDelay = param1;
        }
    }
}
