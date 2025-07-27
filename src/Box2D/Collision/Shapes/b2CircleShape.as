package Box2D.Collision.Shapes
{
    import Box2D.Collision.*;
    import Box2D.Common.*;
    import Box2D.Common.Math.*;
    import Box2D.Dynamics.*;
    
    public class b2CircleShape extends b2Shape
    {
        public var m_localPosition:b2Vec2 = new b2Vec2();
        
        public var m_radius:Number;
        
        public function b2CircleShape(param1:b2ShapeDef)
        {
            super(param1);
            var _loc2_:b2CircleDef = param1 as b2CircleDef;
            m_type = e_circleShape;
            this.m_localPosition.SetV(_loc2_.localPosition);
            this.m_radius = _loc2_.radius;
        }
        
        override public function TestPoint(param1:b2XForm, param2:b2Vec2) : Boolean
        {
            var _loc3_:b2Mat22 = param1.R;
            var _loc4_:Number = param1.position.x + (_loc3_.col1.x * this.m_localPosition.x + _loc3_.col2.x * this.m_localPosition.y);
            var _loc5_:Number = param1.position.y + (_loc3_.col1.y * this.m_localPosition.x + _loc3_.col2.y * this.m_localPosition.y);
            _loc4_ = param2.x - _loc4_;
            _loc5_ = param2.y - _loc5_;
            return _loc4_ * _loc4_ + _loc5_ * _loc5_ <= this.m_radius * this.m_radius;
        }
        
        override public function TestSegment(param1:b2XForm, param2:Array, param3:b2Vec2, param4:b2Segment, param5:Number) : Boolean
        {
            var _loc10_:Number = NaN;
            var _loc6_:b2Mat22 = param1.R;
            var _loc7_:Number = param1.position.x + (_loc6_.col1.x * this.m_localPosition.x + _loc6_.col2.x * this.m_localPosition.y);
            var _loc8_:Number = param1.position.x + (_loc6_.col1.y * this.m_localPosition.x + _loc6_.col2.y * this.m_localPosition.y);
            var _loc9_:Number = param4.p1.x - _loc7_;
            _loc10_ = param4.p1.y - _loc8_;
            var _loc11_:Number = _loc9_ * _loc9_ + _loc10_ * _loc10_ - this.m_radius * this.m_radius;
            if(_loc11_ < 0)
            {
                return false;
            }
            var _loc12_:Number = param4.p2.x - param4.p1.x;
            var _loc13_:Number = param4.p2.y - param4.p1.y;
            var _loc14_:Number = _loc9_ * _loc12_ + _loc10_ * _loc13_;
            var _loc15_:Number = _loc12_ * _loc12_ + _loc13_ * _loc13_;
            var _loc16_:Number = _loc14_ * _loc14_ - _loc15_ * _loc11_;
            if(_loc16_ < 0 || _loc15_ < Number.MIN_VALUE)
            {
                return false;
            }
            var _loc17_:Number = -(_loc14_ + Math.sqrt(_loc16_));
            if(0 <= _loc17_ && _loc17_ <= param5 * _loc15_)
            {
                _loc17_ /= _loc15_;
                param2[0] = _loc17_;
                param3.x = _loc9_ + _loc17_ * _loc12_;
                param3.y = _loc10_ + _loc17_ * _loc13_;
                param3.Normalize();
                return true;
            }
            return false;
        }
        
        override public function ComputeAABB(param1:b2AABB, param2:b2XForm) : void
        {
            var _loc3_:b2Mat22 = param2.R;
            var _loc4_:Number = param2.position.x + (_loc3_.col1.x * this.m_localPosition.x + _loc3_.col2.x * this.m_localPosition.y);
            var _loc5_:Number = param2.position.y + (_loc3_.col1.y * this.m_localPosition.x + _loc3_.col2.y * this.m_localPosition.y);
            param1.lowerBound.Set(_loc4_ - this.m_radius,_loc5_ - this.m_radius);
            param1.upperBound.Set(_loc4_ + this.m_radius,_loc5_ + this.m_radius);
        }
        
        override public function ComputeSweptAABB(param1:b2AABB, param2:b2XForm, param3:b2XForm) : void
        {
            var _loc4_:b2Mat22 = null;
            _loc4_ = param2.R;
            var _loc5_:Number = param2.position.x + (_loc4_.col1.x * this.m_localPosition.x + _loc4_.col2.x * this.m_localPosition.y);
            var _loc6_:Number = param2.position.y + (_loc4_.col1.y * this.m_localPosition.x + _loc4_.col2.y * this.m_localPosition.y);
            _loc4_ = param3.R;
            var _loc7_:Number = param3.position.x + (_loc4_.col1.x * this.m_localPosition.x + _loc4_.col2.x * this.m_localPosition.y);
            var _loc8_:Number = param3.position.y + (_loc4_.col1.y * this.m_localPosition.x + _loc4_.col2.y * this.m_localPosition.y);
            param1.lowerBound.Set((_loc5_ < _loc7_ ? _loc5_ : _loc7_) - this.m_radius,(_loc6_ < _loc8_ ? _loc6_ : _loc8_) - this.m_radius);
            param1.upperBound.Set((_loc5_ > _loc7_ ? _loc5_ : _loc7_) + this.m_radius,(_loc6_ > _loc8_ ? _loc6_ : _loc8_) + this.m_radius);
        }
        
        override public function ComputeMass(param1:b2MassData) : void
        {
            param1.mass = m_density * b2Settings.b2_pi * this.m_radius * this.m_radius;
            param1.center.SetV(this.m_localPosition);
            param1.I = param1.mass * (0.5 * this.m_radius * this.m_radius + (this.m_localPosition.x * this.m_localPosition.x + this.m_localPosition.y * this.m_localPosition.y));
        }
        
        public function GetLocalPosition() : b2Vec2
        {
            return this.m_localPosition;
        }
        
        public function GetRadius() : Number
        {
            return this.m_radius;
        }
        
        override public function UpdateSweepRadius(param1:b2Vec2) : void
        {
            var _loc2_:Number = this.m_localPosition.x - param1.x;
            var _loc3_:Number = this.m_localPosition.y - param1.y;
            _loc2_ = Math.sqrt(_loc2_ * _loc2_ + _loc3_ * _loc3_);
            m_sweepRadius = _loc2_ + this.m_radius - b2Settings.b2_toiSlop;
        }
    }
}

