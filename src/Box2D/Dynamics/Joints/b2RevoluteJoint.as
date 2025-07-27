package Box2D.Dynamics.Joints
{
    import Box2D.Common.Math.b2Mat22;
    import Box2D.Common.Math.b2Math;
    import Box2D.Common.Math.b2Vec2;
    import Box2D.Common.b2Settings;
    import Box2D.Dynamics.b2Body;
    import Box2D.Dynamics.b2TimeStep;
    
    public class b2RevoluteJoint extends b2Joint
    {
        public static var tImpulse:b2Vec2 = new b2Vec2();
        
        private var K:b2Mat22 = new b2Mat22();
        
        private var K1:b2Mat22 = new b2Mat22();
        
        private var K2:b2Mat22 = new b2Mat22();
        
        private var K3:b2Mat22 = new b2Mat22();
        
        public var m_localAnchor1:b2Vec2 = new b2Vec2();
        
        public var m_localAnchor2:b2Vec2 = new b2Vec2();
        
        public var m_pivotForce:b2Vec2 = new b2Vec2();
        
        public var m_motorForce:Number;
        
        public var m_limitForce:Number;
        
        public var m_limitPositionImpulse:Number;
        
        public var m_pivotMass:b2Mat22 = new b2Mat22();
        
        public var m_motorMass:Number;
        
        public var m_enableMotor:Boolean;
        
        public var m_maxMotorTorque:Number;
        
        public var m_motorSpeed:Number;
        
        public var m_enableLimit:Boolean;
        
        public var m_referenceAngle:Number;
        
        public var m_lowerAngle:Number;
        
        public var m_upperAngle:Number;
        
        public var m_limitState:int;
        
        public function b2RevoluteJoint(param1:b2RevoluteJointDef)
        {
            super(param1);
            this.m_localAnchor1.SetV(param1.localAnchor1);
            this.m_localAnchor2.SetV(param1.localAnchor2);
            this.m_referenceAngle = param1.referenceAngle;
            this.m_pivotForce.Set(0,0);
            this.m_motorForce = 0;
            this.m_limitForce = 0;
            this.m_limitPositionImpulse = 0;
            this.m_lowerAngle = param1.lowerAngle;
            this.m_upperAngle = param1.upperAngle;
            this.m_maxMotorTorque = param1.maxMotorTorque;
            this.m_motorSpeed = param1.motorSpeed;
            this.m_enableLimit = param1.enableLimit;
            this.m_enableMotor = param1.enableMotor;
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
            return this.m_pivotForce;
        }
        
        override public function GetReactionTorque() : Number
        {
            return this.m_limitForce;
        }
        
        public function GetJointAngle() : Number
        {
            return m_body2.m_sweep.a - m_body1.m_sweep.a - this.m_referenceAngle;
        }
        
        public function GetJointSpeed() : Number
        {
            return m_body2.m_angularVelocity - m_body1.m_angularVelocity;
        }
        
        public function IsLimitEnabled() : Boolean
        {
            return this.m_enableLimit;
        }
        
        public function EnableLimit(param1:Boolean) : void
        {
            this.m_enableLimit = param1;
        }
        
        public function GetLowerLimit() : Number
        {
            return this.m_lowerAngle;
        }
        
        public function GetUpperLimit() : Number
        {
            return this.m_upperAngle;
        }
        
        public function SetLimits(param1:Number, param2:Number) : void
        {
            this.m_lowerAngle = param1;
            this.m_upperAngle = param2;
        }
        
        public function IsMotorEnabled() : Boolean
        {
            return this.m_enableMotor;
        }
        
        public function EnableMotor(param1:Boolean) : void
        {
            this.m_enableMotor = param1;
        }
        
        public function SetMotorSpeed(param1:Number) : void
        {
            this.m_motorSpeed = param1;
        }
        
        public function GetMotorSpeed() : Number
        {
            return this.m_motorSpeed;
        }
        
        public function SetMaxMotorTorque(param1:Number) : void
        {
            this.m_maxMotorTorque = param1;
        }
        
        public function GetMotorTorque() : Number
        {
            return this.m_motorForce;
        }
        
        override public function InitVelocityConstraints(param1:b2TimeStep) : void
        {
            var _loc2_:b2Body = null;
            var _loc3_:b2Body = null;
            var _loc4_:b2Mat22 = null;
            var _loc5_:Number = NaN;
            var _loc7_:Number = NaN;
            var _loc14_:Number = NaN;
            _loc2_ = m_body1;
            _loc3_ = m_body2;
            _loc4_ = _loc2_.m_xf.R;
            var _loc6_:Number = this.m_localAnchor1.x - _loc2_.m_sweep.localCenter.x;
            _loc7_ = this.m_localAnchor1.y - _loc2_.m_sweep.localCenter.y;
            _loc5_ = _loc4_.col1.x * _loc6_ + _loc4_.col2.x * _loc7_;
            _loc7_ = _loc4_.col1.y * _loc6_ + _loc4_.col2.y * _loc7_;
            _loc6_ = _loc5_;
            _loc4_ = _loc3_.m_xf.R;
            var _loc8_:Number = this.m_localAnchor2.x - _loc3_.m_sweep.localCenter.x;
            var _loc9_:Number = this.m_localAnchor2.y - _loc3_.m_sweep.localCenter.y;
            _loc5_ = _loc4_.col1.x * _loc8_ + _loc4_.col2.x * _loc9_;
            _loc9_ = _loc4_.col1.y * _loc8_ + _loc4_.col2.y * _loc9_;
            _loc8_ = _loc5_;
            var _loc10_:Number = _loc2_.m_invMass;
            var _loc11_:Number = _loc3_.m_invMass;
            var _loc12_:Number = _loc2_.m_invI;
            var _loc13_:Number = _loc3_.m_invI;
            this.K1.col1.x = _loc10_ + _loc11_;
            this.K1.col2.x = 0;
            this.K1.col1.y = 0;
            this.K1.col2.y = _loc10_ + _loc11_;
            this.K2.col1.x = _loc12_ * _loc7_ * _loc7_;
            this.K2.col2.x = -_loc12_ * _loc6_ * _loc7_;
            this.K2.col1.y = -_loc12_ * _loc6_ * _loc7_;
            this.K2.col2.y = _loc12_ * _loc6_ * _loc6_;
            this.K3.col1.x = _loc13_ * _loc9_ * _loc9_;
            this.K3.col2.x = -_loc13_ * _loc8_ * _loc9_;
            this.K3.col1.y = -_loc13_ * _loc8_ * _loc9_;
            this.K3.col2.y = _loc13_ * _loc8_ * _loc8_;
            this.K.SetM(this.K1);
            this.K.AddM(this.K2);
            this.K.AddM(this.K3);
            this.K.Invert(this.m_pivotMass);
            this.m_motorMass = 1 / (_loc12_ + _loc13_);
            if(this.m_enableMotor == false)
            {
                this.m_motorForce = 0;
            }
            if(this.m_enableLimit)
            {
                _loc14_ = _loc3_.m_sweep.a - _loc2_.m_sweep.a - this.m_referenceAngle;
                if(b2Math.b2Abs(this.m_upperAngle - this.m_lowerAngle) < 2 * b2Settings.b2_angularSlop)
                {
                    this.m_limitState = e_equalLimits;
                }
                else if(_loc14_ <= this.m_lowerAngle)
                {
                    if(this.m_limitState != e_atLowerLimit)
                    {
                        this.m_limitForce = 0;
                    }
                    this.m_limitState = e_atLowerLimit;
                }
                else if(_loc14_ >= this.m_upperAngle)
                {
                    if(this.m_limitState != e_atUpperLimit)
                    {
                        this.m_limitForce = 0;
                    }
                    this.m_limitState = e_atUpperLimit;
                }
                else
                {
                    this.m_limitState = e_inactiveLimit;
                    this.m_limitForce = 0;
                }
            }
            else
            {
                this.m_limitForce = 0;
            }
            if(param1.warmStarting)
            {
                _loc2_.m_linearVelocity.x -= param1.dt * _loc10_ * this.m_pivotForce.x;
                _loc2_.m_linearVelocity.y -= param1.dt * _loc10_ * this.m_pivotForce.y;
                _loc2_.m_angularVelocity -= param1.dt * _loc12_ * (_loc6_ * this.m_pivotForce.y - _loc7_ * this.m_pivotForce.x + this.m_motorForce + this.m_limitForce);
                _loc3_.m_linearVelocity.x += param1.dt * _loc11_ * this.m_pivotForce.x;
                _loc3_.m_linearVelocity.y += param1.dt * _loc11_ * this.m_pivotForce.y;
                _loc3_.m_angularVelocity += param1.dt * _loc13_ * (_loc8_ * this.m_pivotForce.y - _loc9_ * this.m_pivotForce.x + this.m_motorForce + this.m_limitForce);
            }
            else
            {
                this.m_pivotForce.SetZero();
                this.m_motorForce = 0;
                this.m_limitForce = 0;
            }
            this.m_limitPositionImpulse = 0;
        }
        
        override public function SolveVelocityConstraints(param1:b2TimeStep) : void
        {
            var _loc4_:b2Mat22 = null;
            var _loc5_:Number = NaN;
            var _loc10_:Number = NaN;
            var _loc16_:Number = NaN;
            var _loc17_:Number = NaN;
            var _loc18_:Number = NaN;
            var _loc19_:Number = NaN;
            var _loc20_:Number = NaN;
            var _loc21_:Number = NaN;
            var _loc2_:b2Body = m_body1;
            var _loc3_:b2Body = m_body2;
            _loc4_ = _loc2_.m_xf.R;
            var _loc6_:Number = this.m_localAnchor1.x - _loc2_.m_sweep.localCenter.x;
            var _loc7_:Number = this.m_localAnchor1.y - _loc2_.m_sweep.localCenter.y;
            _loc5_ = _loc4_.col1.x * _loc6_ + _loc4_.col2.x * _loc7_;
            _loc7_ = _loc4_.col1.y * _loc6_ + _loc4_.col2.y * _loc7_;
            _loc6_ = _loc5_;
            _loc4_ = _loc3_.m_xf.R;
            var _loc8_:Number = this.m_localAnchor2.x - _loc3_.m_sweep.localCenter.x;
            var _loc9_:Number = this.m_localAnchor2.y - _loc3_.m_sweep.localCenter.y;
            _loc5_ = _loc4_.col1.x * _loc8_ + _loc4_.col2.x * _loc9_;
            _loc9_ = _loc4_.col1.y * _loc8_ + _loc4_.col2.y * _loc9_;
            _loc8_ = _loc5_;
            var _loc11_:Number = _loc3_.m_linearVelocity.x + -_loc3_.m_angularVelocity * _loc9_ - _loc2_.m_linearVelocity.x - -_loc2_.m_angularVelocity * _loc7_;
            var _loc12_:Number = _loc3_.m_linearVelocity.y + _loc3_.m_angularVelocity * _loc8_ - _loc2_.m_linearVelocity.y - _loc2_.m_angularVelocity * _loc6_;
            var _loc13_:Number = -param1.inv_dt * (this.m_pivotMass.col1.x * _loc11_ + this.m_pivotMass.col2.x * _loc12_);
            var _loc14_:Number = -param1.inv_dt * (this.m_pivotMass.col1.y * _loc11_ + this.m_pivotMass.col2.y * _loc12_);
            this.m_pivotForce.x += _loc13_;
            this.m_pivotForce.y += _loc14_;
            var _loc15_:Number = param1.dt * _loc13_;
            _loc16_ = param1.dt * _loc14_;
            _loc2_.m_linearVelocity.x -= _loc2_.m_invMass * _loc15_;
            _loc2_.m_linearVelocity.y -= _loc2_.m_invMass * _loc16_;
            _loc2_.m_angularVelocity -= _loc2_.m_invI * (_loc6_ * _loc16_ - _loc7_ * _loc15_);
            _loc3_.m_linearVelocity.x += _loc3_.m_invMass * _loc15_;
            _loc3_.m_linearVelocity.y += _loc3_.m_invMass * _loc16_;
            _loc3_.m_angularVelocity += _loc3_.m_invI * (_loc8_ * _loc16_ - _loc9_ * _loc15_);
            if(this.m_enableMotor && this.m_limitState != e_equalLimits)
            {
                _loc17_ = _loc3_.m_angularVelocity - _loc2_.m_angularVelocity - this.m_motorSpeed;
                _loc18_ = -param1.inv_dt * this.m_motorMass * _loc17_;
                _loc19_ = this.m_motorForce;
                this.m_motorForce = b2Math.b2Clamp(this.m_motorForce + _loc18_,-this.m_maxMotorTorque,this.m_maxMotorTorque);
                _loc18_ = this.m_motorForce - _loc19_;
                _loc2_.m_angularVelocity -= _loc2_.m_invI * param1.dt * _loc18_;
                _loc3_.m_angularVelocity += _loc3_.m_invI * param1.dt * _loc18_;
            }
            if(this.m_enableLimit && this.m_limitState != e_inactiveLimit)
            {
                _loc20_ = _loc3_.m_angularVelocity - _loc2_.m_angularVelocity;
                _loc21_ = -param1.inv_dt * this.m_motorMass * _loc20_;
                if(this.m_limitState == e_equalLimits)
                {
                    this.m_limitForce += _loc21_;
                }
                else if(this.m_limitState == e_atLowerLimit)
                {
                    _loc10_ = this.m_limitForce;
                    this.m_limitForce = b2Math.b2Max(this.m_limitForce + _loc21_,0);
                    _loc21_ = this.m_limitForce - _loc10_;
                }
                else if(this.m_limitState == e_atUpperLimit)
                {
                    _loc10_ = this.m_limitForce;
                    this.m_limitForce = b2Math.b2Min(this.m_limitForce + _loc21_,0);
                    _loc21_ = this.m_limitForce - _loc10_;
                }
                _loc2_.m_angularVelocity -= _loc2_.m_invI * param1.dt * _loc21_;
                _loc3_.m_angularVelocity += _loc3_.m_invI * param1.dt * _loc21_;
            }
        }
        
        override public function SolvePositionConstraints() : Boolean
        {
            var _loc1_:Number = NaN;
            var _loc2_:Number = NaN;
            var _loc6_:b2Mat22 = null;
            var _loc25_:Number = NaN;
            var _loc26_:Number = NaN;
            var _loc3_:b2Body = m_body1;
            var _loc4_:b2Body = m_body2;
            var _loc5_:Number = 0;
            _loc6_ = _loc3_.m_xf.R;
            var _loc7_:Number = this.m_localAnchor1.x - _loc3_.m_sweep.localCenter.x;
            var _loc8_:Number = this.m_localAnchor1.y - _loc3_.m_sweep.localCenter.y;
            var _loc9_:Number = _loc6_.col1.x * _loc7_ + _loc6_.col2.x * _loc8_;
            _loc8_ = _loc6_.col1.y * _loc7_ + _loc6_.col2.y * _loc8_;
            _loc7_ = _loc9_;
            _loc6_ = _loc4_.m_xf.R;
            var _loc10_:Number = this.m_localAnchor2.x - _loc4_.m_sweep.localCenter.x;
            var _loc11_:Number = this.m_localAnchor2.y - _loc4_.m_sweep.localCenter.y;
            _loc9_ = _loc6_.col1.x * _loc10_ + _loc6_.col2.x * _loc11_;
            _loc11_ = _loc6_.col1.y * _loc10_ + _loc6_.col2.y * _loc11_;
            _loc10_ = _loc9_;
            var _loc12_:Number = _loc3_.m_sweep.c.x + _loc7_;
            var _loc13_:Number = _loc3_.m_sweep.c.y + _loc8_;
            var _loc14_:Number = _loc4_.m_sweep.c.x + _loc10_;
            var _loc15_:Number = _loc4_.m_sweep.c.y + _loc11_;
            var _loc16_:Number = _loc14_ - _loc12_;
            var _loc17_:Number = _loc15_ - _loc13_;
            _loc5_ = Math.sqrt(_loc16_ * _loc16_ + _loc17_ * _loc17_);
            var _loc18_:Number = _loc3_.m_invMass;
            var _loc19_:Number = _loc4_.m_invMass;
            var _loc20_:Number = _loc3_.m_invI;
            var _loc21_:Number = _loc4_.m_invI;
            this.K1.col1.x = _loc18_ + _loc19_;
            this.K1.col2.x = 0;
            this.K1.col1.y = 0;
            this.K1.col2.y = _loc18_ + _loc19_;
            this.K2.col1.x = _loc20_ * _loc8_ * _loc8_;
            this.K2.col2.x = -_loc20_ * _loc7_ * _loc8_;
            this.K2.col1.y = -_loc20_ * _loc7_ * _loc8_;
            this.K2.col2.y = _loc20_ * _loc7_ * _loc7_;
            this.K3.col1.x = _loc21_ * _loc11_ * _loc11_;
            this.K3.col2.x = -_loc21_ * _loc10_ * _loc11_;
            this.K3.col1.y = -_loc21_ * _loc10_ * _loc11_;
            this.K3.col2.y = _loc21_ * _loc10_ * _loc10_;
            this.K.SetM(this.K1);
            this.K.AddM(this.K2);
            this.K.AddM(this.K3);
            this.K.Solve(tImpulse,-_loc16_,-_loc17_);
            var _loc22_:Number = tImpulse.x;
            var _loc23_:Number = tImpulse.y;
            _loc3_.m_sweep.c.x -= _loc3_.m_invMass * _loc22_;
            _loc3_.m_sweep.c.y -= _loc3_.m_invMass * _loc23_;
            _loc3_.m_sweep.a -= _loc3_.m_invI * (_loc7_ * _loc23_ - _loc8_ * _loc22_);
            _loc4_.m_sweep.c.x += _loc4_.m_invMass * _loc22_;
            _loc4_.m_sweep.c.y += _loc4_.m_invMass * _loc23_;
            _loc4_.m_sweep.a += _loc4_.m_invI * (_loc10_ * _loc23_ - _loc11_ * _loc22_);
            _loc3_.SynchronizeTransform();
            _loc4_.SynchronizeTransform();
            var _loc24_:Number = 0;
            if(this.m_enableLimit && this.m_limitState != e_inactiveLimit)
            {
                _loc25_ = _loc4_.m_sweep.a - _loc3_.m_sweep.a - this.m_referenceAngle;
                _loc26_ = 0;
                if(this.m_limitState == e_equalLimits)
                {
                    _loc2_ = b2Math.b2Clamp(_loc25_,-b2Settings.b2_maxAngularCorrection,b2Settings.b2_maxAngularCorrection);
                    _loc26_ = -this.m_motorMass * _loc2_;
                    _loc24_ = b2Math.b2Abs(_loc2_);
                }
                else if(this.m_limitState == e_atLowerLimit)
                {
                    _loc2_ = _loc25_ - this.m_lowerAngle;
                    _loc24_ = b2Math.b2Max(0,-_loc2_);
                    _loc2_ = b2Math.b2Clamp(_loc2_ + b2Settings.b2_angularSlop,-b2Settings.b2_maxAngularCorrection,0);
                    _loc26_ = -this.m_motorMass * _loc2_;
                    _loc1_ = this.m_limitPositionImpulse;
                    this.m_limitPositionImpulse = b2Math.b2Max(this.m_limitPositionImpulse + _loc26_,0);
                    _loc26_ = this.m_limitPositionImpulse - _loc1_;
                }
                else if(this.m_limitState == e_atUpperLimit)
                {
                    _loc2_ = _loc25_ - this.m_upperAngle;
                    _loc24_ = b2Math.b2Max(0,_loc2_);
                    _loc2_ = b2Math.b2Clamp(_loc2_ - b2Settings.b2_angularSlop,0,b2Settings.b2_maxAngularCorrection);
                    _loc26_ = -this.m_motorMass * _loc2_;
                    _loc1_ = this.m_limitPositionImpulse;
                    this.m_limitPositionImpulse = b2Math.b2Min(this.m_limitPositionImpulse + _loc26_,0);
                    _loc26_ = this.m_limitPositionImpulse - _loc1_;
                }
                _loc3_.m_sweep.a -= _loc3_.m_invI * _loc26_;
                _loc4_.m_sweep.a += _loc4_.m_invI * _loc26_;
                _loc3_.SynchronizeTransform();
                _loc4_.SynchronizeTransform();
            }
            return _loc5_ <= b2Settings.b2_linearSlop && _loc24_ <= b2Settings.b2_angularSlop;
        }
    }
}

