package com.totaljerkface.game.editor
{
    import Box2D.Common.Math.b2Mat22;
    import Box2D.Common.Math.b2Vec2;
    import flash.display.*;
    import flash.events.*;
    import flash.utils.*;

    [Embed(source="/_assets/assets.swf", symbol="symbol751")]
    public class PrisJoint extends RefJoint
    {
        public var inner:Sprite;

        protected var _axisAngle:Number;

        protected var _limit:Boolean;

        protected var _motor:Boolean;

        protected var _speed:Number = 3;

        protected var _force:Number = 50;

        protected var _upperLimit:int = 100;

        protected var _lowerLimit:int = -100;

        protected var maxForce:Number = 100000;

        protected var maxSpeed:Number = 50;

        protected var maxLimit:Number = 8000;

        public function PrisJoint()
        {
            _triggers = new Array();
            _triggerActions = new Dictionary();
            _triggerActionList = ["disable motor", "change motor speed", "delete self", "disable limits", "change limits"];
            _triggerActionListProperties = [null, ["newMotorSpeedsPris", "motorSpeedTimes"], null, null, ["newUpperLimits", "newLowerLimits"]];
            super();
            name = "sliding joint";
            triggerable = true;
            _triggerString = "triggerActionsPrisJoint";
            _keyedPropertyObject[_triggerString] = _triggerActions;
            this.axisAngle = 90;
        }

        override public function setAttributes():void
        {
            _attributes = ["x", "y", "axisAngle", "limitPris", "motorPris", "collideSelf"];
            if (_vehicleAttached)
            {
                _attributes.push("vehicleControlled");
            }
            addTriggerProperties();
        }

        override public function drawArms():void
        {
            var _loc1_:b2Vec2 = null;
            var _loc2_:b2Vec2 = null;
            var _loc3_:b2Mat22 = null;
            var _loc4_:b2Vec2 = null;
            var _loc5_:Number = NaN;
            var _loc6_:b2Vec2 = null;
            var _loc7_:Number = NaN;
            var _loc8_:Number = NaN;
            var _loc9_:Number = NaN;
            var _loc10_:int = 0;
            var _loc11_:Number = NaN;
            var _loc12_:Number = NaN;
            var _loc13_:Number = NaN;
            var _loc14_:b2Vec2 = null;
            var _loc15_:b2Vec2 = null;
            var _loc16_:int = 0;
            graphics.clear();
            graphics.lineStyle(0, 16737792);
            if (_body1)
            {
                graphics.moveTo(0, 0);
                graphics.lineTo(body1.x - x, body1.y - y);
            }
            if (body2)
            {
                graphics.moveTo(0, 0);
                graphics.lineTo(body2.x - x, body2.y - y);
            }
            if (this._limit)
            {
                graphics.lineStyle(0, 16737792, 0.7);
                _loc1_ = new b2Vec2(-this._lowerLimit, 0);
                _loc2_ = new b2Vec2(-this._upperLimit, 0);
                _loc3_ = new b2Mat22(this.axisAngle * Math.PI / 180);
                _loc1_.MulM(_loc3_);
                _loc2_.MulM(_loc3_);
                _loc4_ = new b2Vec2(_loc2_.x - _loc1_.x, _loc2_.y - _loc1_.y);
                _loc5_ = _loc4_.Length();
                _loc6_ = new b2Vec2(_loc4_.x / _loc5_, _loc4_.y / _loc5_);
                _loc7_ = 6;
                _loc8_ = 6;
                _loc9_ = (_loc5_ - _loc7_) / (_loc7_ + _loc8_);
                _loc10_ = Math.ceil(_loc9_);
                _loc11_ = _loc9_ / _loc10_;
                _loc7_ *= _loc11_;
                _loc8_ *= _loc11_;
                _loc10_++;
                _loc12_ = _loc1_.x;
                _loc13_ = _loc1_.y;
                _loc14_ = new b2Vec2(-25, 0);
                _loc15_ = new b2Vec2(25 + _loc7_, 0);
                if (this.axisAngle < -90 || this._axisAngle > 90)
                {
                    _loc14_.x = _loc15_.x;
                    _loc15_.x = -25;
                }
                _loc14_.MulM(_loc3_);
                _loc15_.MulM(_loc3_);
                _loc16_ = 0;
                while (_loc16_ < _loc10_)
                {
                    if (_loc12_ < _loc14_.x || _loc12_ > _loc15_.x)
                    {
                        graphics.moveTo(_loc12_, _loc13_);
                        graphics.lineTo(_loc12_ + _loc6_.x * _loc7_, _loc13_ + _loc6_.y * _loc7_);
                    }
                    _loc12_ += _loc6_.x * (_loc7_ + _loc8_);
                    _loc13_ += _loc6_.y * (_loc7_ + _loc8_);
                    _loc16_++;
                }
                graphics.moveTo(_loc1_.x - _loc6_.y * 10, _loc1_.y + _loc6_.x * 10);
                graphics.lineTo(_loc1_.x + _loc6_.y * 10, _loc1_.y - _loc6_.x * 10);
                graphics.moveTo(_loc2_.x - _loc6_.y * 10, _loc2_.y + _loc6_.x * 10);
                graphics.lineTo(_loc2_.x + _loc6_.y * 10, _loc2_.y - _loc6_.x * 10);
            }
            if (selected)
            {
                drawBoundingBox();
            }
        }

        public function get axisAngle():int
        {
            return this._axisAngle;
        }

        public function set axisAngle(param1:int):void
        {
            if (param1 > 180)
            {
                param1 = 180;
            }
            if (param1 < -180)
            {
                param1 = -180;
            }
            this._axisAngle = param1;
            this.inner.rotation = this._axisAngle;
            this.drawArms();
        }

        public function set limit(param1:Boolean):void
        {
            this._limit = param1;
            this.drawArms();
        }

        public function get limit():Boolean
        {
            return this._limit;
        }

        public function set upperLimit(param1:int):void
        {
            if (param1 > this.maxLimit)
            {
                param1 = this.maxLimit;
            }
            if (param1 < 0)
            {
                param1 = 0;
            }
            this._upperLimit = param1;
            this.drawArms();
        }

        public function get upperLimit():int
        {
            return this._upperLimit;
        }

        public function set lowerLimit(param1:int):void
        {
            if (param1 > 0)
            {
                param1 = -param1;
            }
            if (param1 < -this.maxLimit)
            {
                param1 = -this.maxLimit;
            }
            this._lowerLimit = param1;
            this.drawArms();
        }

        public function get lowerLimit():int
        {
            return this._lowerLimit;
        }

        public function set motor(param1:Boolean):void
        {
            this._motor = param1;
        }

        public function get motor():Boolean
        {
            return this._motor;
        }

        public function set speed(param1:Number):void
        {
            if (param1 > this.maxSpeed)
            {
                param1 = this.maxSpeed;
            }
            if (param1 < -this.maxSpeed)
            {
                param1 = -this.maxSpeed;
            }
            this._speed = param1;
        }

        public function get speed():Number
        {
            return this._speed;
        }

        public function set force(param1:Number):void
        {
            if (param1 > this.maxForce)
            {
                param1 = this.maxForce;
            }
            this._force = param1;
        }

        public function get force():Number
        {
            return this._force;
        }

        override public function clone():RefSprite
        {
            var _loc1_:PrisJoint = new PrisJoint();
            _loc1_.axisAngle = this.axisAngle;
            _loc1_.limit = this.limit;
            _loc1_.upperLimit = this.upperLimit;
            _loc1_.lowerLimit = this.lowerLimit;
            _loc1_.motor = this.motor;
            _loc1_.speed = this.speed;
            _loc1_.force = this.force;
            _loc1_.collideSelf = collideSelf;
            _loc1_.vehicleControlled = vehicleControlled;
            _loc1_.x = x;
            _loc1_.y = y;
            transferKeyedProperties(_loc1_);
            return _loc1_;
        }

        public function get triggerActionsPrisJoint():Dictionary
        {
            return _triggerActions;
        }
    }
}
