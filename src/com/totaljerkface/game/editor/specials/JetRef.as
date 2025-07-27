package com.totaljerkface.game.editor.specials
{
    import com.totaljerkface.game.editor.RefSprite;

    [Embed(source="/_assets/assets.swf", symbol="symbol2598")]
    public class JetRef extends Special
    {
        public static const MAX_POWER:int = 10;

        public static const MIN_POWER:int = 1;

        public static const MAX_ACCEL_TIME:int = 5;

        public static const MIN_ACCEL_TIME:int = 0;

        public static const MAX_FIRE_TIME:int = 50;

        public static const MIN_FIRE_TIME:int = 0;

        private var _power:int = 1;

        private var _fixedRotation:Boolean = false;

        private var _sleeping:Boolean = false;

        private var _accelTime:int = 0;

        private var _fireTime:int = 0;

        public function JetRef()
        {
            super();
            name = "jet";
            joinable = true;
            scalable = false;
            _joints = new Array();
            _triggers = new Array();
        }

        override public function setAttributes():void
        {
            _type = "JetRef";
            _shapesUsed = 1;
            _attributes = ["x", "y", "angle", "sleeping", "power", "fireTime", "accelTime", "fixedRotation"];
        }

        override public function clone():RefSprite
        {
            var _loc1_:JetRef = null;
            _loc1_ = new JetRef();
            _loc1_.x = x;
            _loc1_.y = y;
            _loc1_.angle = angle;
            _loc1_.sleeping = this.sleeping;
            _loc1_.power = this.power;
            _loc1_.accelTime = this.accelTime;
            _loc1_.fireTime = this.fireTime;
            _loc1_.fixedRotation = this.fixedRotation;
            return _loc1_;
        }

        public function get power():int
        {
            return this._power;
        }

        public function set power(param1:int):void
        {
            if (param1 > MAX_POWER)
            {
                param1 = MAX_POWER;
            }
            if (param1 < MIN_POWER)
            {
                param1 = MIN_POWER;
            }
            this._power = param1;
            var _loc2_:Number = MAX_POWER - MIN_POWER;
            var _loc3_:Number = (this._power - MIN_POWER) / _loc2_;
            scaleX = scaleY = 1 + _loc3_;
            if (_selected)
            {
                drawBoundingBox();
            }
            x = x;
            y = y;
        }

        public function get fireTime():int
        {
            return this._fireTime;
        }

        public function set fireTime(param1:int):void
        {
            if (param1 > MAX_FIRE_TIME)
            {
                param1 = MAX_FIRE_TIME;
            }
            if (param1 < MIN_FIRE_TIME)
            {
                param1 = MIN_FIRE_TIME;
            }
            this._fireTime = param1;
        }

        public function get accelTime():int
        {
            return this._accelTime;
        }

        public function set accelTime(param1:int):void
        {
            if (param1 > MAX_ACCEL_TIME)
            {
                param1 = MAX_ACCEL_TIME;
            }
            if (param1 < MIN_ACCEL_TIME)
            {
                param1 = MIN_ACCEL_TIME;
            }
            this._accelTime = param1;
        }

        public function get fixedRotation():Boolean
        {
            return this._fixedRotation;
        }

        public function set fixedRotation(param1:Boolean):void
        {
            this._fixedRotation = param1;
        }

        public function get sleeping():Boolean
        {
            return this._sleeping;
        }

        public function set sleeping(param1:Boolean):void
        {
            this._sleeping = param1;
        }

        override public function get triggerable():Boolean
        {
            if (this._sleeping)
            {
                return true;
            }
            return _triggerable;
        }
    }
}
