package Box2D.Dynamics.Joints
{
    import Box2D.Common.Math.b2Mat22;
    import Box2D.Common.Math.b2Vec2;
    import Box2D.Common.b2Settings;
    import Box2D.Dynamics.b2Body;
    import Box2D.Dynamics.b2TimeStep;
    
    public class b2MouseJoint extends b2Joint
    {
        private var K:b2Mat22;
        
        private var K1:b2Mat22;
        
        private var K2:b2Mat22;
        
        public var m_localAnchor:b2Vec2;
        
        public var m_target:b2Vec2;
        
        public var m_impulse:b2Vec2;
        
        public var m_mass:b2Mat22;
        
        public var m_C:b2Vec2;
        
        public var m_maxForce:Number;
        
        public var m_beta:Number;
        
        public var m_gamma:Number;
        
        public function b2MouseJoint(param1:b2MouseJointDef)
        {
            var _loc3_:Number = NaN;
            this.K = new b2Mat22();
            this.K1 = new b2Mat22();
            this.K2 = new b2Mat22();
            this.m_localAnchor = new b2Vec2();
            this.m_target = new b2Vec2();
            this.m_impulse = new b2Vec2();
            this.m_mass = new b2Mat22();
            this.m_C = new b2Vec2();
            super(param1);
            this.m_target.SetV(param1.target);
            var _loc2_:Number = this.m_target.x - m_body2.m_xf.position.x;
            _loc3_ = this.m_target.y - m_body2.m_xf.position.y;
            var _loc4_:b2Mat22 = m_body2.m_xf.R;
            this.m_localAnchor.x = _loc2_ * _loc4_.col1.x + _loc3_ * _loc4_.col1.y;
            this.m_localAnchor.y = _loc2_ * _loc4_.col2.x + _loc3_ * _loc4_.col2.y;
            this.m_maxForce = param1.maxForce;
            this.m_impulse.SetZero();
            var _loc5_:Number = m_body2.m_mass;
            var _loc6_:Number = 2 * b2Settings.b2_pi * param1.frequencyHz;
            var _loc7_:Number = 2 * _loc5_ * param1.dampingRatio * _loc6_;
            var _loc8_:Number = param1.timeStep * _loc5_ * (_loc6_ * _loc6_);
            this.m_gamma = 1 / (_loc7_ + _loc8_);
            this.m_beta = _loc8_ / (_loc7_ + _loc8_);
        }
        
        override public function GetAnchor1() : b2Vec2
        {
            return this.m_target;
        }
        
        override public function GetAnchor2() : b2Vec2
        {
            return m_body2.GetWorldPoint(this.m_localAnchor);
        }
        
        override public function GetReactionForce() : b2Vec2
        {
            return this.m_impulse;
        }
        
        override public function GetReactionTorque() : Number
        {
            return 0;
        }
        
        public function SetTarget(param1:b2Vec2) : void
        {
            if(m_body2.IsSleeping())
            {
                m_body2.WakeUp();
            }
            this.m_target = param1;
        }
        
        override public function InitVelocityConstraints(param1:b2TimeStep) : void
        {
            var _loc2_:b2Body = null;
            var _loc3_:b2Mat22 = null;
            var _loc4_:Number = NaN;
            var _loc5_:Number = NaN;
            var _loc7_:Number = NaN;
            var _loc8_:Number = NaN;
            _loc2_ = m_body2;
            _loc3_ = _loc2_.m_xf.R;
            _loc4_ = this.m_localAnchor.x - _loc2_.m_sweep.localCenter.x;
            _loc5_ = this.m_localAnchor.y - _loc2_.m_sweep.localCenter.y;
            var _loc6_:Number = _loc3_.col1.x * _loc4_ + _loc3_.col2.x * _loc5_;
            _loc5_ = _loc3_.col1.y * _loc4_ + _loc3_.col2.y * _loc5_;
            _loc4_ = _loc6_;
            _loc7_ = _loc2_.m_invMass;
            _loc8_ = _loc2_.m_invI;
            this.K1.col1.x = _loc7_;
            this.K1.col2.x = 0;
            this.K1.col1.y = 0;
            this.K1.col2.y = _loc7_;
            this.K2.col1.x = _loc8_ * _loc5_ * _loc5_;
            this.K2.col2.x = -_loc8_ * _loc4_ * _loc5_;
            this.K2.col1.y = -_loc8_ * _loc4_ * _loc5_;
            this.K2.col2.y = _loc8_ * _loc4_ * _loc4_;
            this.K.SetM(this.K1);
            this.K.AddM(this.K2);
            this.K.col1.x += this.m_gamma;
            this.K.col2.y += this.m_gamma;
            this.K.Invert(this.m_mass);
            this.m_C.x = _loc2_.m_sweep.c.x + _loc4_ - this.m_target.x;
            this.m_C.y = _loc2_.m_sweep.c.y + _loc5_ - this.m_target.y;
            _loc2_.m_angularVelocity *= 0.98;
            var _loc9_:Number = param1.dt * this.m_impulse.x;
            var _loc10_:Number = param1.dt * this.m_impulse.y;
            _loc2_.m_linearVelocity.x += _loc7_ * _loc9_;
            _loc2_.m_linearVelocity.y += _loc7_ * _loc10_;
            _loc2_.m_angularVelocity += _loc8_ * (_loc4_ * _loc10_ - _loc5_ * _loc9_);
        }
        
        override public function SolveVelocityConstraints(param1:b2TimeStep) : void
        {
            var _loc3_:b2Mat22 = null;
            var _loc4_:Number = NaN;
            var _loc5_:Number = NaN;
            var _loc2_:b2Body = m_body2;
            _loc3_ = _loc2_.m_xf.R;
            var _loc6_:Number = this.m_localAnchor.x - _loc2_.m_sweep.localCenter.x;
            var _loc7_:Number = this.m_localAnchor.y - _loc2_.m_sweep.localCenter.y;
            _loc4_ = _loc3_.col1.x * _loc6_ + _loc3_.col2.x * _loc7_;
            _loc7_ = _loc3_.col1.y * _loc6_ + _loc3_.col2.y * _loc7_;
            _loc6_ = _loc4_;
            var _loc8_:Number = _loc2_.m_linearVelocity.x + -_loc2_.m_angularVelocity * _loc7_;
            var _loc9_:Number = _loc2_.m_linearVelocity.y + _loc2_.m_angularVelocity * _loc6_;
            _loc3_ = this.m_mass;
            _loc4_ = _loc8_ + this.m_beta * param1.inv_dt * this.m_C.x + this.m_gamma * param1.dt * this.m_impulse.x;
            _loc5_ = _loc9_ + this.m_beta * param1.inv_dt * this.m_C.y + this.m_gamma * param1.dt * this.m_impulse.y;
            var _loc10_:Number = -param1.inv_dt * (_loc3_.col1.x * _loc4_ + _loc3_.col2.x * _loc5_);
            var _loc11_:Number = -param1.inv_dt * (_loc3_.col1.y * _loc4_ + _loc3_.col2.y * _loc5_);
            var _loc12_:Number = this.m_impulse.x;
            var _loc13_:Number = this.m_impulse.y;
            this.m_impulse.x += _loc10_;
            this.m_impulse.y += _loc11_;
            var _loc14_:Number = this.m_impulse.Length();
            if(_loc14_ > this.m_maxForce)
            {
                this.m_impulse.Multiply(this.m_maxForce / _loc14_);
            }
            _loc10_ = this.m_impulse.x - _loc12_;
            _loc11_ = this.m_impulse.y - _loc13_;
            var _loc15_:Number = param1.dt * _loc10_;
            var _loc16_:Number = param1.dt * _loc11_;
            _loc2_.m_linearVelocity.x += _loc2_.m_invMass * _loc15_;
            _loc2_.m_linearVelocity.y += _loc2_.m_invMass * _loc16_;
            _loc2_.m_angularVelocity += _loc2_.m_invI * (_loc6_ * _loc16_ - _loc7_ * _loc15_);
        }
        
        override public function SolvePositionConstraints() : Boolean
        {
            return true;
        }
    }
}

