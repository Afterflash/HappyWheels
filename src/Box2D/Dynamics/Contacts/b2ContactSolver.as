package Box2D.Dynamics.Contacts
{
    import Box2D.Collision.*;
    import Box2D.Common.*;
    import Box2D.Common.Math.*;
    import Box2D.Dynamics.*;
    
    public class b2ContactSolver
    {
        public var m_step:b2TimeStep;
        
        public var m_allocator:*;
        
        public var m_constraints:Array;
        
        public var m_constraintCount:int;
        
        public function b2ContactSolver(param1:b2TimeStep, param2:Array, param3:int, param4:*)
        {
            var _loc5_:b2Contact = null;
            var _loc6_:int = 0;
            var _loc7_:b2Vec2 = null;
            var _loc8_:b2Mat22 = null;
            var _loc10_:b2Body = null;
            var _loc11_:b2Body = null;
            var _loc12_:int = 0;
            var _loc13_:Array = null;
            var _loc14_:Number = NaN;
            var _loc15_:Number = NaN;
            var _loc16_:Number = NaN;
            var _loc17_:Number = NaN;
            var _loc18_:Number = NaN;
            var _loc19_:Number = NaN;
            var _loc20_:Number = NaN;
            var _loc21_:Number = NaN;
            var _loc22_:int = 0;
            var _loc23_:b2Manifold = null;
            var _loc24_:Number = NaN;
            var _loc25_:Number = NaN;
            var _loc26_:b2ContactConstraint = null;
            var _loc27_:Number = 0;
            var _loc28_:b2ManifoldPoint = null;
            var _loc29_:b2ContactConstraintPoint = null;
            var _loc30_:Number = NaN;
            var _loc31_:Number = NaN;
            var _loc32_:Number = NaN;
            var _loc33_:Number = NaN;
            var _loc34_:Number = NaN;
            var _loc35_:Number = NaN;
            var _loc36_:Number = NaN;
            var _loc37_:Number = NaN;
            var _loc38_:Number = NaN;
            var _loc39_:Number = NaN;
            var _loc40_:Number = NaN;
            var _loc41_:Number = NaN;
            var _loc42_:Number = NaN;
            var _loc43_:Number = NaN;
            var _loc44_:Number = NaN;
            var _loc45_:Number = NaN;
            var _loc46_:Number = NaN;
            var _loc47_:Number = NaN;
            this.m_step = new b2TimeStep();
            this.m_constraints = new Array();
            super();
            this.m_step.dt = param1.dt;
            this.m_step.inv_dt = param1.inv_dt;
            this.m_step.maxIterations = param1.maxIterations;
            this.m_allocator = param4;
            this.m_constraintCount = 0;
            _loc6_ = 0;
            while(_loc6_ < param3)
            {
                _loc5_ = param2[_loc6_];
                this.m_constraintCount += _loc5_.m_manifoldCount;
                _loc6_++;
            }
            _loc6_ = 0;
            while(_loc6_ < this.m_constraintCount)
            {
                this.m_constraints[_loc6_] = new b2ContactConstraint();
                _loc6_++;
            }
            var _loc9_:int = 0;
            _loc6_ = 0;
            while(_loc6_ < param3)
            {
                _loc5_ = param2[_loc6_];
                _loc10_ = _loc5_.m_shape1.m_body;
                _loc11_ = _loc5_.m_shape2.m_body;
                _loc12_ = _loc5_.m_manifoldCount;
                _loc13_ = _loc5_.GetManifolds();
                _loc14_ = _loc5_.m_friction;
                _loc15_ = _loc5_.m_restitution;
                _loc16_ = _loc10_.m_linearVelocity.x;
                _loc17_ = _loc10_.m_linearVelocity.y;
                _loc18_ = _loc11_.m_linearVelocity.x;
                _loc19_ = _loc11_.m_linearVelocity.y;
                _loc20_ = _loc10_.m_angularVelocity;
                _loc21_ = _loc11_.m_angularVelocity;
                _loc22_ = 0;
                while(_loc22_ < _loc12_)
                {
                    _loc23_ = _loc13_[_loc22_];
                    _loc24_ = _loc23_.normal.x;
                    _loc25_ = _loc23_.normal.y;
                    _loc26_ = this.m_constraints[_loc9_];
                    _loc26_.body1 = _loc10_;
                    _loc26_.body2 = _loc11_;
                    _loc26_.manifold = _loc23_;
                    _loc26_.normal.x = _loc24_;
                    _loc26_.normal.y = _loc25_;
                    _loc26_.pointCount = _loc23_.pointCount;
                    _loc26_.friction = _loc14_;
                    _loc26_.restitution = _loc15_;
                    _loc27_ = 0;
                    while(_loc27_ < _loc26_.pointCount)
                    {
                        _loc28_ = _loc23_.points[_loc27_];
                        _loc29_ = _loc26_.points[_loc27_];
                        _loc29_.normalImpulse = _loc28_.normalImpulse;
                        _loc29_.tangentImpulse = _loc28_.tangentImpulse;
                        _loc29_.separation = _loc28_.separation;
                        _loc29_.positionImpulse = 0;
                        _loc29_.localAnchor1.SetV(_loc28_.localPoint1);
                        _loc29_.localAnchor2.SetV(_loc28_.localPoint2);
                        _loc8_ = _loc10_.m_xf.R;
                        _loc32_ = _loc28_.localPoint1.x - _loc10_.m_sweep.localCenter.x;
                        _loc33_ = _loc28_.localPoint1.y - _loc10_.m_sweep.localCenter.y;
                        _loc30_ = _loc8_.col1.x * _loc32_ + _loc8_.col2.x * _loc33_;
                        _loc33_ = _loc8_.col1.y * _loc32_ + _loc8_.col2.y * _loc33_;
                        _loc32_ = _loc30_;
                        _loc29_.r1.Set(_loc32_,_loc33_);
                        _loc8_ = _loc11_.m_xf.R;
                        _loc34_ = _loc28_.localPoint2.x - _loc11_.m_sweep.localCenter.x;
                        _loc35_ = _loc28_.localPoint2.y - _loc11_.m_sweep.localCenter.y;
                        _loc30_ = _loc8_.col1.x * _loc34_ + _loc8_.col2.x * _loc35_;
                        _loc35_ = _loc8_.col1.y * _loc34_ + _loc8_.col2.y * _loc35_;
                        _loc34_ = _loc30_;
                        _loc29_.r2.Set(_loc34_,_loc35_);
                        _loc36_ = _loc32_ * _loc32_ + _loc33_ * _loc33_;
                        _loc37_ = _loc34_ * _loc34_ + _loc35_ * _loc35_;
                        _loc38_ = _loc32_ * _loc24_ + _loc33_ * _loc25_;
                        _loc39_ = _loc34_ * _loc24_ + _loc35_ * _loc25_;
                        _loc40_ = _loc10_.m_invMass + _loc11_.m_invMass;
                        _loc40_ = _loc40_ + (_loc10_.m_invI * (_loc36_ - _loc38_ * _loc38_) + _loc11_.m_invI * (_loc37_ - _loc39_ * _loc39_));
                        _loc29_.normalMass = 1 / _loc40_;
                        _loc41_ = _loc10_.m_mass * _loc10_.m_invMass + _loc11_.m_mass * _loc11_.m_invMass;
                        _loc41_ = _loc41_ + (_loc10_.m_mass * _loc10_.m_invI * (_loc36_ - _loc38_ * _loc38_) + _loc11_.m_mass * _loc11_.m_invI * (_loc37_ - _loc39_ * _loc39_));
                        _loc29_.equalizedMass = 1 / _loc41_;
                        _loc42_ = _loc25_;
                        _loc43_ = -_loc24_;
                        _loc44_ = _loc32_ * _loc42_ + _loc33_ * _loc43_;
                        _loc45_ = _loc34_ * _loc42_ + _loc35_ * _loc43_;
                        _loc46_ = _loc10_.m_invMass + _loc11_.m_invMass;
                        _loc46_ = _loc46_ + (_loc10_.m_invI * (_loc36_ - _loc44_ * _loc44_) + _loc11_.m_invI * (_loc37_ - _loc45_ * _loc45_));
                        _loc29_.tangentMass = 1 / _loc46_;
                        _loc29_.velocityBias = 0;
                        if(_loc29_.separation > 0)
                        {
                            _loc29_.velocityBias = -60 * _loc29_.separation;
                        }
                        _loc30_ = _loc18_ + -_loc21_ * _loc35_ - _loc16_ - -_loc20_ * _loc33_;
                        _loc31_ = _loc19_ + _loc21_ * _loc34_ - _loc17_ - _loc20_ * _loc32_;
                        _loc47_ = _loc26_.normal.x * _loc30_ + _loc26_.normal.y * _loc31_;
                        if(_loc47_ < -b2Settings.b2_velocityThreshold)
                        {
                            _loc29_.velocityBias += -_loc26_.restitution * _loc47_;
                        }
                        _loc27_++;
                    }
                    _loc9_++;
                    _loc22_++;
                }
                _loc6_++;
            }
        }
        
        public function InitVelocityConstraints(param1:b2TimeStep) : void
        {
            var _loc2_:b2Vec2 = null;
            var _loc3_:b2Vec2 = null;
            var _loc4_:b2Mat22 = null;
            var _loc6_:b2ContactConstraint = null;
            var _loc7_:b2Body = null;
            var _loc8_:b2Body = null;
            var _loc9_:Number = NaN;
            var _loc10_:Number = NaN;
            var _loc11_:Number = NaN;
            var _loc12_:Number = NaN;
            var _loc13_:Number = NaN;
            var _loc14_:Number = NaN;
            var _loc15_:Number = NaN;
            var _loc16_:Number = NaN;
            var _loc17_:Number = NaN;
            var _loc18_:int = 0;
            var _loc19_:int = 0;
            var _loc20_:b2ContactConstraintPoint = null;
            var _loc21_:Number = NaN;
            var _loc22_:Number = NaN;
            var _loc23_:b2ContactConstraintPoint = null;
            var _loc5_:int = 0;
            while(_loc5_ < this.m_constraintCount)
            {
                _loc6_ = this.m_constraints[_loc5_];
                _loc7_ = _loc6_.body1;
                _loc8_ = _loc6_.body2;
                _loc9_ = _loc7_.m_invMass;
                _loc10_ = _loc7_.m_invI;
                _loc11_ = _loc8_.m_invMass;
                _loc12_ = _loc8_.m_invI;
                _loc13_ = _loc6_.normal.x;
                _loc15_ = _loc14_ = _loc6_.normal.y;
                _loc16_ = -_loc13_;
                if(param1.warmStarting)
                {
                    _loc19_ = _loc6_.pointCount;
                    _loc18_ = 0;
                    while(_loc18_ < _loc19_)
                    {
                        _loc20_ = _loc6_.points[_loc18_];
                        _loc20_.normalImpulse *= param1.dtRatio;
                        _loc20_.tangentImpulse *= param1.dtRatio;
                        _loc21_ = _loc20_.normalImpulse * _loc13_ + _loc20_.tangentImpulse * _loc15_;
                        _loc22_ = _loc20_.normalImpulse * _loc14_ + _loc20_.tangentImpulse * _loc16_;
                        _loc7_.m_angularVelocity -= _loc10_ * (_loc20_.r1.x * _loc22_ - _loc20_.r1.y * _loc21_);
                        _loc7_.m_linearVelocity.x -= _loc9_ * _loc21_;
                        _loc7_.m_linearVelocity.y -= _loc9_ * _loc22_;
                        _loc8_.m_angularVelocity += _loc12_ * (_loc20_.r2.x * _loc22_ - _loc20_.r2.y * _loc21_);
                        _loc8_.m_linearVelocity.x += _loc11_ * _loc21_;
                        _loc8_.m_linearVelocity.y += _loc11_ * _loc22_;
                        _loc18_++;
                    }
                }
                else
                {
                    _loc19_ = _loc6_.pointCount;
                    _loc18_ = 0;
                    while(_loc18_ < _loc19_)
                    {
                        _loc23_ = _loc6_.points[_loc18_];
                        _loc23_.normalImpulse = 0;
                        _loc23_.tangentImpulse = 0;
                        _loc18_++;
                    }
                }
                _loc5_++;
            }
        }
        
        public function SolveVelocityConstraints() : void
        {
            var _loc1_:int = 0;
            var _loc2_:b2ContactConstraintPoint = null;
            var _loc3_:Number = NaN;
            var _loc4_:Number = NaN;
            var _loc5_:Number = NaN;
            var _loc6_:Number = NaN;
            var _loc7_:Number = NaN;
            var _loc8_:Number = NaN;
            var _loc9_:Number = NaN;
            var _loc10_:Number = NaN;
            var _loc11_:Number = NaN;
            var _loc12_:Number = NaN;
            var _loc13_:Number = NaN;
            var _loc14_:Number = NaN;
            var _loc15_:Number = NaN;
            var _loc16_:Number = NaN;
            var _loc17_:b2Mat22 = null;
            var _loc18_:b2Vec2 = null;
            var _loc20_:b2ContactConstraint = null;
            var _loc21_:b2Body = null;
            var _loc22_:b2Body = null;
            var _loc23_:Number = NaN;
            var _loc24_:Number = NaN;
            var _loc25_:b2Vec2 = null;
            var _loc26_:b2Vec2 = null;
            var _loc27_:Number = NaN;
            var _loc28_:Number = NaN;
            var _loc29_:Number = NaN;
            var _loc30_:Number = NaN;
            var _loc31_:Number = NaN;
            var _loc32_:Number = NaN;
            var _loc33_:Number = NaN;
            var _loc34_:Number = NaN;
            var _loc35_:Number = NaN;
            var _loc36_:Number = NaN;
            var _loc37_:int = 0;
            var _loc38_:Number = NaN;
            var _loc19_:int = 0;
            while(_loc19_ < this.m_constraintCount)
            {
                _loc20_ = this.m_constraints[_loc19_];
                _loc21_ = _loc20_.body1;
                _loc22_ = _loc20_.body2;
                _loc23_ = _loc21_.m_angularVelocity;
                _loc24_ = _loc22_.m_angularVelocity;
                _loc25_ = _loc21_.m_linearVelocity;
                _loc26_ = _loc22_.m_linearVelocity;
                _loc27_ = _loc21_.m_invMass;
                _loc28_ = _loc21_.m_invI;
                _loc29_ = _loc22_.m_invMass;
                _loc30_ = _loc22_.m_invI;
                _loc31_ = _loc20_.normal.x;
                _loc33_ = _loc32_ = _loc20_.normal.y;
                _loc34_ = -_loc31_;
                _loc35_ = _loc20_.friction;
                _loc37_ = _loc20_.pointCount;
                _loc1_ = 0;
                while(_loc1_ < _loc37_)
                {
                    _loc2_ = _loc20_.points[_loc1_];
                    _loc7_ = _loc26_.x + -_loc24_ * _loc2_.r2.y - _loc25_.x - -_loc23_ * _loc2_.r1.y;
                    _loc8_ = _loc26_.y + _loc24_ * _loc2_.r2.x - _loc25_.y - _loc23_ * _loc2_.r1.x;
                    _loc9_ = _loc7_ * _loc31_ + _loc8_ * _loc32_;
                    _loc11_ = -_loc2_.normalMass * (_loc9_ - _loc2_.velocityBias);
                    _loc10_ = _loc7_ * _loc33_ + _loc8_ * _loc34_;
                    _loc12_ = _loc2_.tangentMass * -_loc10_;
                    _loc13_ = b2Math.b2Max(_loc2_.normalImpulse + _loc11_,0);
                    _loc11_ = _loc13_ - _loc2_.normalImpulse;
                    _loc38_ = _loc35_ * _loc2_.normalImpulse;
                    _loc14_ = b2Math.b2Clamp(_loc2_.tangentImpulse + _loc12_,-_loc38_,_loc38_);
                    _loc12_ = _loc14_ - _loc2_.tangentImpulse;
                    _loc15_ = _loc11_ * _loc31_ + _loc12_ * _loc33_;
                    _loc16_ = _loc11_ * _loc32_ + _loc12_ * _loc34_;
                    _loc25_.x -= _loc27_ * _loc15_;
                    _loc25_.y -= _loc27_ * _loc16_;
                    _loc23_ -= _loc28_ * (_loc2_.r1.x * _loc16_ - _loc2_.r1.y * _loc15_);
                    _loc26_.x += _loc29_ * _loc15_;
                    _loc26_.y += _loc29_ * _loc16_;
                    _loc24_ += _loc30_ * (_loc2_.r2.x * _loc16_ - _loc2_.r2.y * _loc15_);
                    _loc2_.normalImpulse = _loc13_;
                    _loc2_.tangentImpulse = _loc14_;
                    _loc1_++;
                }
                _loc21_.m_angularVelocity = _loc23_;
                _loc22_.m_angularVelocity = _loc24_;
                _loc19_++;
            }
        }
        
        public function FinalizeVelocityConstraints() : void
        {
            var _loc2_:b2ContactConstraint = null;
            var _loc3_:b2Manifold = null;
            var _loc4_:int = 0;
            var _loc5_:b2ManifoldPoint = null;
            var _loc6_:b2ContactConstraintPoint = null;
            var _loc1_:int = 0;
            while(_loc1_ < this.m_constraintCount)
            {
                _loc2_ = this.m_constraints[_loc1_];
                _loc3_ = _loc2_.manifold;
                _loc4_ = 0;
                while(_loc4_ < _loc2_.pointCount)
                {
                    _loc5_ = _loc3_.points[_loc4_];
                    _loc6_ = _loc2_.points[_loc4_];
                    _loc5_.normalImpulse = _loc6_.normalImpulse;
                    _loc5_.tangentImpulse = _loc6_.tangentImpulse;
                    _loc4_++;
                }
                _loc1_++;
            }
        }
        
        public function SolvePositionConstraints(param1:Number) : Boolean
        {
            var _loc3_:b2Mat22 = null;
            var _loc4_:b2Vec2 = null;
            var _loc6_:b2ContactConstraint = null;
            var _loc7_:b2Body = null;
            var _loc8_:b2Body = null;
            var _loc9_:b2Vec2 = null;
            var _loc10_:Number = NaN;
            var _loc11_:b2Vec2 = null;
            var _loc12_:Number = NaN;
            var _loc13_:Number = NaN;
            var _loc14_:Number = NaN;
            var _loc15_:Number = NaN;
            var _loc16_:Number = NaN;
            var _loc17_:Number = NaN;
            var _loc18_:Number = NaN;
            var _loc19_:int = 0;
            var _loc20_:int = 0;
            var _loc21_:b2ContactConstraintPoint = null;
            var _loc22_:Number = NaN;
            var _loc23_:Number = NaN;
            var _loc24_:Number = NaN;
            var _loc25_:Number = NaN;
            var _loc26_:Number = NaN;
            var _loc27_:Number = NaN;
            var _loc28_:Number = NaN;
            var _loc29_:Number = NaN;
            var _loc30_:Number = NaN;
            var _loc31_:Number = NaN;
            var _loc32_:Number = NaN;
            var _loc33_:Number = NaN;
            var _loc34_:Number = NaN;
            var _loc35_:Number = NaN;
            var _loc36_:Number = NaN;
            var _loc37_:Number = NaN;
            var _loc38_:Number = NaN;
            var _loc2_:Number = 0;
            var _loc5_:int = 0;
            while(_loc5_ < this.m_constraintCount)
            {
                _loc6_ = this.m_constraints[_loc5_];
                _loc7_ = _loc6_.body1;
                _loc8_ = _loc6_.body2;
                _loc9_ = _loc7_.m_sweep.c;
                _loc10_ = _loc7_.m_sweep.a;
                _loc11_ = _loc8_.m_sweep.c;
                _loc12_ = _loc8_.m_sweep.a;
                _loc13_ = _loc7_.m_mass * _loc7_.m_invMass;
                _loc14_ = _loc7_.m_mass * _loc7_.m_invI;
                _loc15_ = _loc8_.m_mass * _loc8_.m_invMass;
                _loc16_ = _loc8_.m_mass * _loc8_.m_invI;
                _loc17_ = _loc6_.normal.x;
                _loc18_ = _loc6_.normal.y;
                _loc19_ = _loc6_.pointCount;
                _loc20_ = 0;
                while(_loc20_ < _loc19_)
                {
                    _loc21_ = _loc6_.points[_loc20_];
                    _loc3_ = _loc7_.m_xf.R;
                    _loc4_ = _loc7_.m_sweep.localCenter;
                    _loc22_ = _loc21_.localAnchor1.x - _loc4_.x;
                    _loc23_ = _loc21_.localAnchor1.y - _loc4_.y;
                    _loc26_ = _loc3_.col1.x * _loc22_ + _loc3_.col2.x * _loc23_;
                    _loc23_ = _loc3_.col1.y * _loc22_ + _loc3_.col2.y * _loc23_;
                    _loc22_ = _loc26_;
                    _loc3_ = _loc8_.m_xf.R;
                    _loc4_ = _loc8_.m_sweep.localCenter;
                    _loc24_ = _loc21_.localAnchor2.x - _loc4_.x;
                    _loc25_ = _loc21_.localAnchor2.y - _loc4_.y;
                    _loc26_ = _loc3_.col1.x * _loc24_ + _loc3_.col2.x * _loc25_;
                    _loc25_ = _loc3_.col1.y * _loc24_ + _loc3_.col2.y * _loc25_;
                    _loc24_ = _loc26_;
                    _loc27_ = _loc9_.x + _loc22_;
                    _loc28_ = _loc9_.y + _loc23_;
                    _loc29_ = _loc11_.x + _loc24_;
                    _loc30_ = _loc11_.y + _loc25_;
                    _loc31_ = _loc29_ - _loc27_;
                    _loc32_ = _loc30_ - _loc28_;
                    _loc33_ = _loc31_ * _loc17_ + _loc32_ * _loc18_ + _loc21_.separation;
                    _loc2_ = b2Math.b2Min(_loc2_,_loc33_);
                    _loc34_ = param1 * b2Math.b2Clamp(_loc33_ + b2Settings.b2_linearSlop,-b2Settings.b2_maxLinearCorrection,0);
                    _loc35_ = -_loc21_.equalizedMass * _loc34_;
                    _loc36_ = _loc21_.positionImpulse;
                    _loc21_.positionImpulse = b2Math.b2Max(_loc36_ + _loc35_,0);
                    _loc35_ = _loc21_.positionImpulse - _loc36_;
                    _loc37_ = _loc35_ * _loc17_;
                    _loc38_ = _loc35_ * _loc18_;
                    _loc9_.x -= _loc13_ * _loc37_;
                    _loc9_.y -= _loc13_ * _loc38_;
                    _loc10_ -= _loc14_ * (_loc22_ * _loc38_ - _loc23_ * _loc37_);
                    _loc7_.m_sweep.a = _loc10_;
                    _loc7_.SynchronizeTransform();
                    _loc11_.x += _loc15_ * _loc37_;
                    _loc11_.y += _loc15_ * _loc38_;
                    _loc12_ += _loc16_ * (_loc24_ * _loc38_ - _loc25_ * _loc37_);
                    _loc8_.m_sweep.a = _loc12_;
                    _loc8_.SynchronizeTransform();
                    _loc20_++;
                }
                _loc5_++;
            }
            return _loc2_ >= -1.5 * b2Settings.b2_linearSlop;
        }
    }
}

