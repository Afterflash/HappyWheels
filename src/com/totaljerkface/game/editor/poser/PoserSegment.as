package com.totaljerkface.game.editor.poser
{
    import Box2D.Common.Math.b2Mat22;
    import Box2D.Common.Math.b2Vec2;
    import flash.display.*;
    
    public class PoserSegment extends Sprite
    {
        private static const PI_OVER_ONEEIGHTY:Number = Math.PI / 180;
        
        private static const ONEEIGHTY_OVER_PI:Number = 180 / Math.PI;
        
        private var _parentSegment:PoserSegment;
        
        public var _childSegments:Array;
        
        private var _length:Number;
        
        private var _invLength:Number;
        
        private var _minAngle:Number;
        
        private var _maxAngle:Number;
        
        private var _angle:Number;
        
        private var _referenceAngle:Number;
        
        private var _vector:b2Vec2;
        
        private var _normal:b2Vec2;
        
        private var _modelOffsetAngle:Number;
        
        private var _modelDifference:Number;
        
        private var _sprite:Sprite;
        
        public function PoserSegment(param1:Sprite, param2:b2Vec2, param3:Number = 90, param4:Number = -90, param5:Number = 90, param6:PoserSegment = null)
        {
            var _loc7_:b2Vec2 = null;
            super();
            this._sprite = param1;
            _loc7_ = new b2Vec2(param1.x,param1.y);
            x = _loc7_.x;
            y = _loc7_.y;
            var _loc8_:b2Vec2 = new b2Vec2(param2.x - _loc7_.x,param2.y - _loc7_.y);
            this._angle = this._referenceAngle = Math.atan2(_loc8_.y,_loc8_.x);
            this._length = _loc8_.Length();
            this._invLength = 1 / this._length;
            this._childSegments = new Array();
            this._modelOffsetAngle = param3 * PI_OVER_ONEEIGHTY;
            this._modelDifference = this._modelOffsetAngle - this._referenceAngle;
            this._minAngle = param4 * PI_OVER_ONEEIGHTY;
            this._maxAngle = param5 * PI_OVER_ONEEIGHTY;
            this.parentSegment = param6;
            this.calculateVector();
            this.drawSegment();
        }
        
        public function get parentSegment() : PoserSegment
        {
            return this._parentSegment;
        }
        
        public function set parentSegment(param1:PoserSegment) : void
        {
            this._parentSegment = param1;
            if(this._parentSegment)
            {
                this._parentSegment.addChildSegment(this);
            }
        }
        
        public function addChildSegment(param1:PoserSegment) : void
        {
            this._childSegments.push(param1);
        }
        
        public function drawSegment() : void
        {
            var _loc2_:PoserSegment = null;
            graphics.clear();
            graphics.lineStyle(1,0,1,false);
            graphics.moveTo(0,0);
            graphics.lineTo(this._vector.x,this._vector.y);
            this._sprite.x = x;
            this._sprite.y = y;
            this._sprite.rotation = Math.round((this._angle + this._modelDifference - this._modelOffsetAngle) * ONEEIGHTY_OVER_PI);
            var _loc1_:int = 0;
            while(_loc1_ < this._childSegments.length)
            {
                _loc2_ = this._childSegments[_loc1_];
                _loc2_.drawSegment();
                _loc1_++;
            }
        }
        
        public function calculateVector() : void
        {
            this._vector = new b2Vec2(this._length,0);
            var _loc1_:b2Mat22 = new b2Mat22(this.angle);
            this._vector.MulM(_loc1_);
            this._normal = new b2Vec2(this._vector.x * this._invLength,this._vector.y * this._invLength);
        }
        
        public function get endPoint() : b2Vec2
        {
            return new b2Vec2(this._vector.x + x,this._vector.y + y);
        }
        
        public function get length() : Number
        {
            return this._length;
        }
        
        public function get angle() : Number
        {
            return this._angle;
        }
        
        public function get angleDegrees() : Number
        {
            return this._angle * ONEEIGHTY_OVER_PI;
        }
        
        public function set angle(param1:Number) : void
        {
            var _loc2_:Number = NaN;
            var _loc3_:b2Vec2 = null;
            var _loc5_:Number = NaN;
            var _loc6_:Number = NaN;
            var _loc7_:Number = NaN;
            var _loc8_:PoserSegment = null;
            if(this._parentSegment)
            {
                _loc5_ = this._parentSegment.angle + this._parentSegment.modelDifference;
                _loc6_ = param1 - _loc5_;
                if(_loc6_ < this._minAngle)
                {
                    param1 = _loc5_ + this._minAngle;
                }
                if(_loc6_ > this._maxAngle)
                {
                    param1 = _loc5_ + this._maxAngle;
                }
            }
            else
            {
                _loc7_ = param1 - this._referenceAngle;
                if(_loc7_ < this._minAngle)
                {
                    param1 = this._referenceAngle + this._minAngle;
                }
                if(_loc7_ > this._maxAngle)
                {
                    param1 = this._referenceAngle + this._maxAngle;
                }
            }
            _loc2_ = this._angle - param1;
            this._angle = param1;
            this.calculateVector();
            _loc3_ = this.endPoint;
            var _loc4_:int = 0;
            while(_loc4_ < this._childSegments.length)
            {
                _loc8_ = this._childSegments[_loc4_];
                _loc8_.x = _loc3_.x;
                _loc8_.y = _loc3_.y;
                _loc8_.angle -= _loc2_;
                _loc4_++;
            }
        }
        
        public function get modelAngle() : Number
        {
            if(this._parentSegment)
            {
                return this._angle - this._parentSegment.angle - this._parentSegment.modelDifference;
            }
            return this._angle + this._modelDifference - this._modelOffsetAngle;
        }
        
        public function set modelAngle(param1:Number) : void
        {
            if(this._parentSegment)
            {
                param1 = param1 + this._parentSegment.angle + this._parentSegment.modelDifference;
            }
            else
            {
                param1 += this._referenceAngle;
            }
            this.angle = param1;
            this.drawSegment();
        }
        
        public function get modelAngleDegrees() : Number
        {
            return this.modelAngle * ONEEIGHTY_OVER_PI;
        }
        
        public function set modelAngleDegrees(param1:Number) : void
        {
            param1 *= PI_OVER_ONEEIGHTY;
            this.modelAngle = param1;
        }
        
        public function get relativeAngle() : Number
        {
            if(this._parentSegment)
            {
                return this._angle - this._parentSegment.angle;
            }
            return this.angle;
        }
        
        public function get relativeAngleDegrees() : Number
        {
            return this.relativeAngle * ONEEIGHTY_OVER_PI;
        }
        
        public function get modelDifference() : Number
        {
            return this._modelDifference;
        }
        
        public function get sprite() : Sprite
        {
            return this._sprite;
        }
    }
}

