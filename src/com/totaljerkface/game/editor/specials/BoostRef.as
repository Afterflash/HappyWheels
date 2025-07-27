package com.totaljerkface.game.editor.specials
{
    import com.totaljerkface.game.editor.RefSprite;
    import flash.display.DisplayObject;
    import flash.display.Sprite;

    [Embed(source="/_assets/assets.swf", symbol="symbol2805")]
    public class BoostRef extends Special
    {
        public static const MIN_POWER:int = 10;

        public static const MAX_POWER:int = 100;

        public var panels:Sprite;

        private var minPanels:int = 1;

        private var maxPanels:int = 6;

        private var _numPanels:int = 2;

        private var _boostPower:int = 20;

        public function BoostRef()
        {
            super();
            name = "boost";
            _shapesUsed = 1;
            _rotatable = true;
            _scalable = false;
            _triggerable = true;
            _triggers = new Array();
        }

        override public function setAttributes():void
        {
            _type = "BoostRef";
            _attributes = ["x", "y", "angle", "numPanels", "boostPower"];
        }

        override public function clone():RefSprite
        {
            var _loc1_:BoostRef = null;
            _loc1_ = new BoostRef();
            _loc1_.x = x;
            _loc1_.y = y;
            _loc1_.angle = angle;
            _loc1_.numPanels = this.numPanels;
            _loc1_.boostPower = this.boostPower;
            return _loc1_;
        }

        public function get numPanels():int
        {
            return this._numPanels;
        }

        public function set numPanels(param1:int):void
        {
            var _loc4_:int = 0;
            var _loc5_:DisplayObject = null;
            if (param1 < this.minPanels)
            {
                param1 = this.minPanels;
            }
            if (param1 > this.maxPanels)
            {
                param1 = this.maxPanels;
            }
            var _loc2_:int = param1 - this._numPanels;
            if (_loc2_ > 0)
            {
                _loc4_ = this._numPanels;
                while (_loc4_ < param1)
                {
                    _loc5_ = new BoostPanelFlat();
                    this.panels.addChild(_loc5_);
                    _loc4_++;
                }
            }
            else if (_loc2_ < 0)
            {
                _loc4_ = _loc2_;
                while (_loc4_ < 0)
                {
                    _loc5_ = this.panels.getChildAt(this.panels.numChildren - 1);
                    this.panels.removeChild(_loc5_);
                    _loc4_++;
                }
            }
            var _loc3_:int = this.panels.numChildren * -90;
            _loc4_ = 0;
            while (_loc4_ < this.panels.numChildren)
            {
                _loc5_ = this.panels.getChildAt(_loc4_);
                _loc5_.x = _loc3_;
                _loc3_ += 180;
                _loc4_++;
            }
            if (_selected)
            {
                drawBoundingBox();
            }
            x = x;
            y = y;
            trace(this.panels.numChildren);
            this._numPanels = param1;
        }

        public function get boostPower():int
        {
            return this._boostPower;
        }

        public function set boostPower(param1:int):*
        {
            if (param1 > MAX_POWER)
            {
                param1 = MAX_POWER;
            }
            if (param1 < MIN_POWER)
            {
                param1 = MIN_POWER;
            }
            this._boostPower = param1;
        }
    }
}
