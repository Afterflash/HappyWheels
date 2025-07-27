package Box2D.Dynamics.Joints
{
    import Box2D.Common.Math.b2Mat22;
    import Box2D.Common.Math.b2Math;
    import Box2D.Common.Math.b2Vec2;
    import Box2D.Common.b2Settings;
    import Box2D.Dynamics.b2Body;
    import Box2D.Dynamics.b2TimeStep;
    
    public class b2DistanceJoint extends b2Joint
    {
        public var m_localAnchor1:b2Vec2;
        
        public var m_localAnchor2:b2Vec2;
        
        public var m_u:b2Vec2;
        
        public var m_frequencyHz:Number;
        
        public var m_dampingRatio:Number;
        
        public var m_gamma:Number;
        
        public var m_bias:Number;
        
        public var m_impulse:Number;
        
        public var m_mass:Number;
        
        public var m_length:Number;
        
        public function b2DistanceJoint(param1:b2DistanceJointDef)
        {
            var _loc2_:b2Mat22 = null;
            var _loc3_:Number = NaN;
            var _loc4_:Number = NaN;
            this.m_localAnchor1 = new b2Vec2();
            this.m_localAnchor2 = new b2Vec2();
            this.m_u = new b2Vec2();
            super(param1);
            this.m_localAnchor1.SetV(param1.localAnchor1);
            this.m_localAnchor2.SetV(param1.localAnchor2);
            this.m_length = param1.length;
            this.m_frequencyHz = param1.frequencyHz;
            this.m_dampingRatio = param1.dampingRatio;
            this.m_impulse = 0;
            this.m_gamma = 0;
            this.m_bias = 0;
            m_inv_dt = 0;
        }
        
        override public function InitVelocityConstraints(param1:b2TimeStep) : void
        {
            var _loc2_:b2Mat22 = null;
            var _loc3_:Number = NaN;
            var _loc4_:b2Body = null;
            var _loc5_:b2Body = null;
            var _loc6_:Number = NaN;
            var _loc8_:Number = NaN;
            var _loc14_:Number = NaN;
            var _loc15_:Number = NaN;
            var _loc16_:Number = NaN;
            var _loc17_:Number = NaN;
            var _loc18_:Number = NaN;
            var _loc19_:Number = NaN;
            m_inv_dt = param1.inv_dt;
            _loc4_ = m_body1;
            _loc5_ = m_body2;
            _loc2_ = _loc4_.m_xf.R;
            _loc6_ = this.m_localAnchor1.x - _loc4_.m_sweep.localCenter.x;
            var _loc7_:Number = this.m_localAnchor1.y - _loc4_.m_sweep.localCenter.y;
            _loc3_ = _loc2_.col1.x * _loc6_ + _loc2_.col2.x * _loc7_;
            _loc7_ = _loc2_.col1.y * _loc6_ + _loc2_.col2.y * _loc7_;
            _loc6_ = _loc3_;
            _loc2_ = _loc5_.m_xf.R;
            _loc8_ = this.m_localAnchor2.x - _loc5_.m_sweep.localCenter.x;
            var _loc9_:Number = this.m_localAnchor2.y - _loc5_.m_sweep.localCenter.y;
            _loc3_ = _loc2_.col1.x * _loc8_ + _loc2_.col2.x * _loc9_;
            _loc9_ = _loc2_.col1.y * _loc8_ + _loc2_.col2.y * _loc9_;
            _loc8_ = _loc3_;
            this.m_u.x = _loc5_.m_sweep.c.x + _loc8_ - _loc4_.m_sweep.c.x - _loc6_;
            this.m_u.y = _loc5_.m_sweep.c.y + _loc9_ - _loc4_.m_sweep.c.y - _loc7_;
            var _loc10_:Number = Math.sqrt(this.m_u.x * this.m_u.x + this.m_u.y * this.m_u.y);
            if(_loc10_ > b2Settings.b2_linearSlop)
            {
                this.m_u.Multiply(1 / _loc10_);
            }
            else
            {
                this.m_u.SetZero();
            }
            var _loc11_:Number = _loc6_ * this.m_u.y - _loc7_ * this.m_u.x;
            var _loc12_:Number = _loc8_ * this.m_u.y - _loc9_ * this.m_u.x;
            var _loc13_:Number = _loc4_.m_invMass + _loc4_.m_invI * _loc11_ * _loc11_ + _loc5_.m_invMass + _loc5_.m_invI * _loc12_ * _loc12_;
            this.m_mass = 1 / _loc13_;
            if(this.m_frequencyHz > 0)
            {
                _loc14_ = _loc10_ - this.m_length;
                _loc15_ = 2 * Math.PI * this.m_frequencyHz;
                _loc16_ = 2 * this.m_mass * this.m_dampingRatio * _loc15_;
                _loc17_ = this.m_mass * _loc15_ * _loc15_;
                this.m_gamma = 1 / (param1.dt * (_loc16_ + param1.dt * _loc17_));
                this.m_bias = _loc14_ * param1.dt * _loc17_ * this.m_gamma;
                this.m_mass = 1 / (_loc13_ + this.m_gamma);
            }
            if(param1.warmStarting)
            {
                this.m_impulse *= param1.dtRatio;
                _loc18_ = this.m_impulse * this.m_u.x;
                _loc19_ = this.m_impulse * this.m_u.y;
                _loc4_.m_linearVelocity.x -= _loc4_.m_invMass * _loc18_;
                _loc4_.m_linearVelocity.y -= _loc4_.m_invMass * _loc19_;
                _loc4_.m_angularVelocity -= _loc4_.m_invI * (_loc6_ * _loc19_ - _loc7_ * _loc18_);
                _loc5_.m_linearVelocity.x += _loc5_.m_invMass * _loc18_;
                _loc5_.m_linearVelocity.y += _loc5_.m_invMass * _loc19_;
                _loc5_.m_angularVelocity += _loc5_.m_invI * (_loc8_ * _loc19_ - _loc9_ * _loc18_);
            }
            else
            {
                this.m_impulse = 0;
            }
        }
        
        override public function SolveVelocityConstraints(param1:b2TimeStep) : void
        {
            var _loc2_:b2Mat22 = null;
            var _loc3_:b2Body = m_body1;
            var _loc4_:b2Body = m_body2;
            _loc2_ = _loc3_.m_xf.R;
            var _loc5_:Number = this.m_localAnchor1.x - _loc3_.m_sweep.localCenter.x;
            var _loc6_:Number = this.m_localAnchor1.y - _loc3_.m_sweep.localCenter.y;
            var _loc7_:Number = _loc2_.col1.x * _loc5_ + _loc2_.col2.x * _loc6_;
            _loc6_ = _loc2_.col1.y * _loc5_ + _loc2_.col2.y * _loc6_;
            _loc5_ = _loc7_;
            _loc2_ = _loc4_.m_xf.R;
            var _loc8_:Number = this.m_localAnchor2.x - _loc4_.m_sweep.localCenter.x;
            var _loc9_:Number = this.m_localAnchor2.y - _loc4_.m_sweep.localCenter.y;
            _loc7_ = _loc2_.col1.x * _loc8_ + _loc2_.col2.x * _loc9_;
            _loc9_ = _loc2_.col1.y * _loc8_ + _loc2_.col2.y * _loc9_;
            _loc8_ = _loc7_;
            var _loc10_:Number = _loc3_.m_linearVelocity.x + -_loc3_.m_angularVelocity * _loc6_;
            var _loc11_:Number = _loc3_.m_linearVelocity.y + _loc3_.m_angularVelocity * _loc5_;
            var _loc12_:Number = _loc4_.m_linearVelocity.x + -_loc4_.m_angularVelocity * _loc9_;
            var _loc13_:Number = _loc4_.m_linearVelocity.y + _loc4_.m_angularVelocity * _loc8_;
            var _loc14_:Number = this.m_u.x * (_loc12_ - _loc10_) + this.m_u.y * (_loc13_ - _loc11_);
            var _loc15_:Number = -this.m_mass * (_loc14_ + this.m_bias + this.m_gamma * this.m_impulse);
            this.m_impulse += _loc15_;
            var _loc16_:Number = _loc15_ * this.m_u.x;
            var _loc17_:Number = _loc15_ * this.m_u.y;
            _loc3_.m_linearVelocity.x -= _loc3_.m_invMass * _loc16_;
            _loc3_.m_linearVelocity.y -= _loc3_.m_invMass * _loc17_;
            _loc3_.m_angularVelocity -= _loc3_.m_invI * (_loc5_ * _loc17_ - _loc6_ * _loc16_);
            _loc4_.m_linearVelocity.x += _loc4_.m_invMass * _loc16_;
            _loc4_.m_linearVelocity.y += _loc4_.m_invMass * _loc17_;
            _loc4_.m_angularVelocity += _loc4_.m_invI * (_loc8_ * _loc17_ - _loc9_ * _loc16_);
        }
        
        override public function SolvePositionConstraints() : Boolean
        {
            var _loc1_:b2Mat22 = null;
            if(this.m_frequencyHz > 0)
            {
                return true;
            }
            var _loc2_:b2Body = m_body1;
            var _loc3_:b2Body = m_body2;
            _loc1_ = _loc2_.m_xf.R;
            var _loc4_:Number = this.m_localAnchor1.x - _loc2_.m_sweep.localCenter.x;
            var _loc5_:Number = this.m_localAnchor1.y - _loc2_.m_sweep.localCenter.y;
            var _loc6_:Number = _loc1_.col1.x * _loc4_ + _loc1_.col2.x * _loc5_;
            _loc5_ = _loc1_.col1.y * _loc4_ + _loc1_.col2.y * _loc5_;
            _loc4_ = _loc6_;
            _loc1_ = _loc3_.m_xf.R;
            var _loc7_:Number = this.m_localAnchor2.x - _loc3_.m_sweep.localCenter.x;
            var _loc8_:Number = this.m_localAnchor2.y - _loc3_.m_sweep.localCenter.y;
            _loc6_ = _loc1_.col1.x * _loc7_ + _loc1_.col2.x * _loc8_;
            _loc8_ = _loc1_.col1.y * _loc7_ + _loc1_.col2.y * _loc8_;
            _loc7_ = _loc6_;
            var _loc9_:Number = _loc3_.m_sweep.c.x + _loc7_ - _loc2_.m_sweep.c.x - _loc4_;
            var _loc10_:Number = _loc3_.m_sweep.c.y + _loc8_ - _loc2_.m_sweep.c.y - _loc5_;
            var _loc11_:Number = Math.sqrt(_loc9_ * _loc9_ + _loc10_ * _loc10_);
            _loc9_ /= _loc11_;
            _loc10_ /= _loc11_;
            var _loc12_:Number = _loc11_ - this.m_length;
            _loc12_ = b2Math.b2Clamp(_loc12_,-b2Settings.b2_maxLinearCorrection,b2Settings.b2_maxLinearCorrection);
            var _loc13_:Number = -this.m_mass * _loc12_;
            this.m_u.Set(_loc9_,_loc10_);
            var _loc14_:Number = _loc13_ * this.m_u.x;
            var _loc15_:Number = _loc13_ * this.m_u.y;
            _loc2_.m_sweep.c.x -= _loc2_.m_invMass * _loc14_;
            _loc2_.m_sweep.c.y -= _loc2_.m_invMass * _loc15_;
            _loc2_.m_sweep.a -= _loc2_.m_invI * (_loc4_ * _loc15_ - _loc5_ * _loc14_);
            _loc3_.m_sweep.c.x += _loc3_.m_invMass * _loc14_;
            _loc3_.m_sweep.c.y += _loc3_.m_invMass * _loc15_;
            _loc3_.m_sweep.a += _loc3_.m_invI * (_loc7_ * _loc15_ - _loc8_ * _loc14_);
            _loc2_.SynchronizeTransform();
            _loc3_.SynchronizeTransform();
            return b2Math.b2Abs(_loc12_) < b2Settings.b2_linearSlop;
        }
        
        override public function GetAnchor1() : b2Vec2
        {
            return m_body1.GetWorldPoint(this.m_localAnchor1);
        }
        
        override public function GetAnchor2() : b2Vec2
        {
            return m_body2.GetWorldPoint(this.m_localAnchor2);
        }
        
        override public function GetReactionForce() : b2Vec2
        {
            var _loc1_:b2Vec2 = new b2Vec2();
            _loc1_.SetV(this.m_u);
            _loc1_.Multiply(m_inv_dt * this.m_impulse);
            return _loc1_;
        }
        
        override public function GetReactionTorque() : Number
        {
            return 0;
        }
    }
}

