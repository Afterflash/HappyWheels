package com.totaljerkface.game.editor
{
    import flash.display.*;
    import flash.events.*;
    import flash.utils.*;

    [Embed(source="/_assets/assets.swf", symbol="symbol755")]
    public class PinJoint extends RefJoint
    {
        protected var _limit:Boolean;

        protected var _motor:Boolean;

        protected var _speed:Number = 3;

        protected var _torque:Number = 50;

        protected var _upperAngle:int = 90;

        protected var _lowerAngle:int = -90;

        protected var maxTorque:Number = 100000;

        protected var maxSpeed:Number = 20;

        protected var maxAngle:Number = 180;

        public function PinJoint()
        {
            _triggers = new Array();
            _triggerActions = new Dictionary();
            _triggerActionList = ["disable motor", "change motor speed", "delete self", "disable limits", "change limits"];
            _triggerActionListProperties = [null, ["newMotorSpeeds", "motorSpeedTimes"], null, null, ["newUpperAngles", "newLowerAngles"]];
            super();
            name = "pin joint";
            triggerable = true;
            _triggerString = "triggerActionsPinJoint";
            _keyedPropertyObject[_triggerString] = _triggerActions;
        }

        override public function setAttributes():void
        {
            _attributes = ["x", "y", "limit", "motor", "collideSelf"];
            if (_vehicleAttached)
            {
                _attributes.push("vehicleControlled");
            }
            addTriggerProperties();
        }

        public function set limit(param1:Boolean):void
        {
            this._limit = param1;
        }

        public function get limit():Boolean
        {
            return this._limit;
        }

        public function set upperAngle(param1:int):void
        {
            if (param1 > this.maxAngle)
            {
                param1 = this.maxAngle;
            }
            if (param1 < 0)
            {
                param1 = 0;
            }
            this._upperAngle = param1;
        }

        public function get upperAngle():int
        {
            return this._upperAngle;
        }

        public function set lowerAngle(param1:int):void
        {
            if (param1 > 0)
            {
                param1 = -param1;
            }
            if (param1 < -this.maxAngle)
            {
                param1 = -this.maxAngle;
            }
            this._lowerAngle = param1;
        }

        public function get lowerAngle():int
        {
            return this._lowerAngle;
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

        public function set torque(param1:Number):void
        {
            if (param1 > this.maxTorque)
            {
                param1 = this.maxTorque;
            }
            this._torque = param1;
        }

        public function get torque():Number
        {
            return this._torque;
        }

        override public function clone():RefSprite
        {
            var _loc1_:PinJoint = null;
            _loc1_ = new PinJoint();
            _loc1_.limit = this.limit;
            _loc1_.upperAngle = this.upperAngle;
            _loc1_.lowerAngle = this.lowerAngle;
            _loc1_.motor = this.motor;
            _loc1_.speed = this.speed;
            _loc1_.torque = this.torque;
            _loc1_.collideSelf = collideSelf;
            _loc1_.vehicleControlled = vehicleControlled;
            _loc1_.x = x;
            _loc1_.y = y;
            transferKeyedProperties(_loc1_);
            return _loc1_;
        }

        public function get triggerActionsPinJoint():Dictionary
        {
            return _triggerActions;
        }
    }
}
