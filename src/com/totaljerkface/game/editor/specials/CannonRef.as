package com.totaljerkface.game.editor.specials
{
    import com.totaljerkface.game.editor.*;
    import flash.display.MovieClip;

    [Embed(source="/_assets/assets.swf", symbol="symbol2909")]
    public class CannonRef extends Special
    {
        public var muzzle:MovieClip;

        public var muzzleShadow:MovieClip;

        public var shapes:MovieClip;

        public var base:MovieClip;

        private var _startRotation:int = 0;

        private var _firingRotation:int = 0;

        private var _muzzleScale:int = 1;

        private var _power:int = 5;

        private var _delay:int = 1;

        private var _cannonType:int = 1;

        public function CannonRef()
        {
            super();
            name = "cannon";
            _scalable = false;
            this.base.gotoAndStop(1);
            this.muzzle.inner.gotoAndStop(1);
            this.muzzleShadow.inner.gotoAndStop(1);
            this.base.star.gotoAndStop(1);
            this.base.meter.removeChild(this.base.meter.bar);
            removeChild(this.shapes);
        }

        override public function setAttributes():void
        {
            _type = "CannonRef";
            _attributes = ["x", "y", "angle", "startRotation", "firingRotation", "cannonType", "cannonDelay", "muzzleScale", "cannonPower"];
        }

        override public function clone():RefSprite
        {
            var _loc1_:CannonRef = new CannonRef();
            _loc1_.x = x;
            _loc1_.y = y;
            _loc1_.angle = angle;
            _loc1_.startRotation = this.startRotation;
            _loc1_.firingRotation = this.firingRotation;
            _loc1_.muzzleScale = this.muzzleScale;
            _loc1_.cannonPower = this.cannonPower;
            _loc1_.cannonDelay = this.cannonDelay;
            _loc1_.cannonType = this.cannonType;
            return _loc1_;
        }

        public function get startRotation():int
        {
            return this._startRotation;
        }

        public function set startRotation(param1:int):void
        {
            if (param1 < -90)
            {
                param1 = -90;
            }
            if (param1 > 90)
            {
                param1 = 90;
            }
            this._startRotation = param1;
            this.muzzle.rotation = this._startRotation;
            if (_selected)
            {
                drawBoundingBox();
            }
        }

        public function get firingRotation():int
        {
            return this._firingRotation;
        }

        public function set firingRotation(param1:int):void
        {
            if (param1 < -90)
            {
                param1 = -90;
            }
            if (param1 > 90)
            {
                param1 = 90;
            }
            this._firingRotation = param1;
            this.muzzleShadow.rotation = this._firingRotation;
            if (_selected)
            {
                drawBoundingBox();
            }
        }

        public function get cannonPower():int
        {
            return this._power;
        }

        public function set cannonPower(param1:int):void
        {
            if (param1 < 1)
            {
                param1 = 1;
            }
            if (param1 > 10)
            {
                param1 = 10;
            }
            this._power = param1;
        }

        public function get cannonType():int
        {
            return this._cannonType;
        }

        public function set cannonType(param1:int):void
        {
            if (param1 < 1)
            {
                param1 = 1;
            }
            if (param1 > 2)
            {
                param1 = 2;
            }
            this._cannonType = param1;
            this.muzzle.inner.gotoAndStop(this._cannonType);
            this.muzzleShadow.inner.gotoAndStop(this._cannonType);
            this.base.gotoAndStop(this._cannonType);
            if (param1 == 1)
            {
                this.base.star.gotoAndStop(1);
            }
        }

        public function get cannonDelay():int
        {
            return this._delay;
        }

        public function set cannonDelay(param1:int):void
        {
            if (param1 < 1)
            {
                param1 = 1;
            }
            if (param1 > 10)
            {
                param1 = 10;
            }
            this._delay = param1;
        }

        public function get muzzleScale():int
        {
            return this._muzzleScale;
        }

        public function set muzzleScale(param1:int):void
        {
            if (param1 < 1)
            {
                param1 = 1;
            }
            if (param1 > 10)
            {
                param1 = 10;
            }
            this._muzzleScale = param1;
            var _loc2_:Number = 1 + param1 / 20;
            this.muzzle.scaleX = this.muzzle.scaleY = this.muzzleShadow.scaleX = this.muzzleShadow.scaleY = _loc2_;
            if (_selected)
            {
                drawBoundingBox();
            }
        }
    }
}
