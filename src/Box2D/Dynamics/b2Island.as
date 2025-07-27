package Box2D.Dynamics
{
    import Box2D.Collision.*;
    import Box2D.Common.*;
    import Box2D.Common.Math.*;
    import Box2D.Dynamics.Contacts.*;
    import Box2D.Dynamics.Joints.*;
    
    public class b2Island
    {
        private static var s_reportCR:b2ContactResult = new b2ContactResult();
        
        public var m_allocator:*;
        
        public var m_listener:b2ContactListener;
        
        public var m_bodies:Array;
        
        public var m_contacts:Array;
        
        public var m_joints:Array;
        
        public var m_bodyCount:int;
        
        public var m_jointCount:int;
        
        public var m_contactCount:int;
        
        public var m_bodyCapacity:int;
        
        public var m_contactCapacity:int;
        
        public var m_jointCapacity:int;
        
        public var m_positionIterationCount:int;
        
        public function b2Island(param1:int, param2:int, param3:int, param4:*, param5:b2ContactListener)
        {
            var _loc6_:int = 0;
            super();
            this.m_bodyCapacity = param1;
            this.m_contactCapacity = param2;
            this.m_jointCapacity = param3;
            this.m_bodyCount = 0;
            this.m_contactCount = 0;
            this.m_jointCount = 0;
            this.m_allocator = param4;
            this.m_listener = param5;
            this.m_bodies = new Array(param1);
            _loc6_ = 0;
            while(_loc6_ < param1)
            {
                this.m_bodies[_loc6_] = null;
                _loc6_++;
            }
            this.m_contacts = new Array(param2);
            _loc6_ = 0;
            while(_loc6_ < param2)
            {
                this.m_contacts[_loc6_] = null;
                _loc6_++;
            }
            this.m_joints = new Array(param3);
            _loc6_ = 0;
            while(_loc6_ < param3)
            {
                this.m_joints[_loc6_] = null;
                _loc6_++;
            }
            this.m_positionIterationCount = 0;
        }
        
        public function Clear() : void
        {
            this.m_bodyCount = 0;
            this.m_contactCount = 0;
            this.m_jointCount = 0;
        }
        
        public function Solve(param1:b2TimeStep, param2:b2Vec2, param3:Boolean, param4:Boolean) : void
        {
            var _loc5_:int = 0;
            var _loc6_:b2Body = null;
            var _loc7_:b2Joint = null;
            var _loc9_:int = 0;
            var _loc10_:Boolean = false;
            var _loc11_:Boolean = false;
            var _loc12_:Boolean = false;
            var _loc13_:Number = NaN;
            var _loc14_:Number = NaN;
            var _loc15_:Number = NaN;
            _loc5_ = 0;
            while(_loc5_ < this.m_bodyCount)
            {
                _loc6_ = this.m_bodies[_loc5_];
                if(!_loc6_.IsStatic())
                {
                    _loc6_.m_linearVelocity.x += param1.dt * (param2.x + _loc6_.m_invMass * _loc6_.m_force.x);
                    _loc6_.m_linearVelocity.y += param1.dt * (param2.y + _loc6_.m_invMass * _loc6_.m_force.y);
                    _loc6_.m_angularVelocity += param1.dt * _loc6_.m_invI * _loc6_.m_torque;
                    _loc6_.m_force.SetZero();
                    _loc6_.m_torque = 0;
                    _loc6_.m_linearVelocity.Multiply(b2Math.b2Clamp(1 - param1.dt * _loc6_.m_linearDamping,0,1));
                    _loc6_.m_angularVelocity *= b2Math.b2Clamp(1 - param1.dt * _loc6_.m_angularDamping,0,1);
                    if(_loc6_.m_linearVelocity.LengthSquared() > b2Settings.b2_maxLinearVelocitySquared)
                    {
                        _loc6_.m_linearVelocity.Normalize();
                        _loc6_.m_linearVelocity.x *= b2Settings.b2_maxLinearVelocity;
                        _loc6_.m_linearVelocity.y *= b2Settings.b2_maxLinearVelocity;
                    }
                    if(_loc6_.m_angularVelocity * _loc6_.m_angularVelocity > b2Settings.b2_maxAngularVelocitySquared)
                    {
                        if(_loc6_.m_angularVelocity < 0)
                        {
                            _loc6_.m_angularVelocity = -b2Settings.b2_maxAngularVelocity;
                        }
                        else
                        {
                            _loc6_.m_angularVelocity = b2Settings.b2_maxAngularVelocity;
                        }
                    }
                }
                _loc5_++;
            }
            var _loc8_:b2ContactSolver = new b2ContactSolver(param1,this.m_contacts,this.m_contactCount,this.m_allocator);
            _loc8_.InitVelocityConstraints(param1);
            _loc5_ = 0;
            while(_loc5_ < this.m_jointCount)
            {
                _loc7_ = this.m_joints[_loc5_];
                _loc7_.InitVelocityConstraints(param1);
                _loc5_++;
            }
            _loc5_ = 0;
            while(_loc5_ < param1.maxIterations)
            {
                _loc8_.SolveVelocityConstraints();
                _loc9_ = 0;
                while(_loc9_ < this.m_jointCount)
                {
                    _loc7_ = this.m_joints[_loc9_];
                    _loc7_.SolveVelocityConstraints(param1);
                    _loc9_++;
                }
                _loc5_++;
            }
            _loc8_.FinalizeVelocityConstraints();
            _loc5_ = 0;
            while(_loc5_ < this.m_bodyCount)
            {
                _loc6_ = this.m_bodies[_loc5_];
                if(!_loc6_.IsStatic())
                {
                    _loc6_.m_sweep.c0.SetV(_loc6_.m_sweep.c);
                    _loc6_.m_sweep.a0 = _loc6_.m_sweep.a;
                    _loc6_.m_sweep.c.x += param1.dt * _loc6_.m_linearVelocity.x;
                    _loc6_.m_sweep.c.y += param1.dt * _loc6_.m_linearVelocity.y;
                    _loc6_.m_sweep.a += param1.dt * _loc6_.m_angularVelocity;
                    _loc6_.SynchronizeTransform();
                }
                _loc5_++;
            }
            if(param3)
            {
                _loc5_ = 0;
                while(_loc5_ < this.m_jointCount)
                {
                    _loc7_ = this.m_joints[_loc5_];
                    _loc7_.InitPositionConstraints();
                    _loc5_++;
                }
                this.m_positionIterationCount = 0;
                while(this.m_positionIterationCount < param1.maxIterations)
                {
                    _loc10_ = _loc8_.SolvePositionConstraints(b2Settings.b2_contactBaumgarte);
                    _loc11_ = true;
                    _loc5_ = 0;
                    while(_loc5_ < this.m_jointCount)
                    {
                        _loc7_ = this.m_joints[_loc5_];
                        _loc12_ = _loc7_.SolvePositionConstraints();
                        _loc11_ &&= _loc12_;
                        _loc5_++;
                    }
                    if(_loc10_ && _loc11_)
                    {
                        break;
                    }
                    ++this.m_positionIterationCount;
                }
            }
            this.Report(_loc8_.m_constraints);
            if(param4)
            {
                _loc13_ = Number.MAX_VALUE;
                _loc14_ = b2Settings.b2_linearSleepTolerance * b2Settings.b2_linearSleepTolerance;
                _loc15_ = b2Settings.b2_angularSleepTolerance * b2Settings.b2_angularSleepTolerance;
                _loc5_ = 0;
                while(_loc5_ < this.m_bodyCount)
                {
                    _loc6_ = this.m_bodies[_loc5_];
                    if(_loc6_.m_invMass != 0)
                    {
                        if((_loc6_.m_flags & b2Body.e_allowSleepFlag) == 0)
                        {
                            _loc6_.m_sleepTime = 0;
                            _loc13_ = 0;
                        }
                        if((_loc6_.m_flags & b2Body.e_allowSleepFlag) == 0 || _loc6_.m_angularVelocity * _loc6_.m_angularVelocity > _loc15_ || b2Math.b2Dot(_loc6_.m_linearVelocity,_loc6_.m_linearVelocity) > _loc14_)
                        {
                            _loc6_.m_sleepTime = 0;
                            _loc13_ = 0;
                        }
                        else
                        {
                            _loc6_.m_sleepTime += param1.dt;
                            _loc13_ = b2Math.b2Min(_loc13_,_loc6_.m_sleepTime);
                        }
                    }
                    _loc5_++;
                }
                if(_loc13_ >= b2Settings.b2_timeToSleep)
                {
                    _loc5_ = 0;
                    while(_loc5_ < this.m_bodyCount)
                    {
                        _loc6_ = this.m_bodies[_loc5_];
                        _loc6_.m_flags |= b2Body.e_sleepFlag;
                        _loc6_.m_linearVelocity.SetZero();
                        _loc6_.m_angularVelocity = 0;
                        _loc5_++;
                    }
                }
            }
        }
        
        public function SolveTOI(param1:b2TimeStep) : void
        {
            var _loc2_:int = 0;
            var _loc5_:b2Body = null;
            var _loc6_:Boolean = false;
            var _loc3_:b2ContactSolver = new b2ContactSolver(param1,this.m_contacts,this.m_contactCount,this.m_allocator);
            _loc2_ = 0;
            while(_loc2_ < param1.maxIterations)
            {
                _loc3_.SolveVelocityConstraints();
                _loc2_++;
            }
            _loc2_ = 0;
            while(_loc2_ < this.m_bodyCount)
            {
                _loc5_ = this.m_bodies[_loc2_];
                if(!_loc5_.IsStatic())
                {
                    _loc5_.m_sweep.c0.SetV(_loc5_.m_sweep.c);
                    _loc5_.m_sweep.a0 = _loc5_.m_sweep.a;
                    _loc5_.m_sweep.c.x += param1.dt * _loc5_.m_linearVelocity.x;
                    _loc5_.m_sweep.c.y += param1.dt * _loc5_.m_linearVelocity.y;
                    _loc5_.m_sweep.a += param1.dt * _loc5_.m_angularVelocity;
                    _loc5_.SynchronizeTransform();
                }
                _loc2_++;
            }
            var _loc4_:Number = 0.75;
            _loc2_ = 0;
            while(_loc2_ < param1.maxIterations)
            {
                _loc6_ = _loc3_.SolvePositionConstraints(_loc4_);
                if(_loc6_)
                {
                    break;
                }
                _loc2_++;
            }
            this.Report(_loc3_.m_constraints);
        }
        
        public function Report(param1:Array) : void
        {
            var _loc2_:b2Mat22 = null;
            var _loc3_:b2Vec2 = null;
            var _loc5_:b2Contact = null;
            var _loc6_:b2ContactConstraint = null;
            var _loc7_:b2ContactResult = null;
            var _loc8_:b2Body = null;
            var _loc9_:int = 0;
            var _loc10_:Array = null;
            var _loc11_:int = 0;
            var _loc12_:b2Manifold = null;
            var _loc13_:int = 0;
            var _loc14_:b2ManifoldPoint = null;
            var _loc15_:b2ContactConstraintPoint = null;
            if(this.m_listener == null)
            {
                return;
            }
            var _loc4_:int = 0;
            while(_loc4_ < this.m_contactCount)
            {
                _loc5_ = this.m_contacts[_loc4_];
                _loc6_ = param1[_loc4_];
                _loc7_ = s_reportCR;
                _loc7_.shape1 = _loc5_.m_shape1;
                _loc7_.shape2 = _loc5_.m_shape2;
                _loc8_ = _loc7_.shape1.m_body;
                _loc9_ = _loc5_.m_manifoldCount;
                _loc10_ = _loc5_.GetManifolds();
                _loc11_ = 0;
                while(_loc11_ < _loc9_)
                {
                    _loc12_ = _loc10_[_loc11_];
                    _loc7_.normal.SetV(_loc12_.normal);
                    _loc13_ = 0;
                    while(_loc13_ < _loc12_.pointCount)
                    {
                        _loc14_ = _loc12_.points[_loc13_];
                        _loc15_ = _loc6_.points[_loc13_];
                        _loc7_.position = _loc8_.GetWorldPoint(_loc14_.localPoint1);
                        _loc7_.normalImpulse = _loc15_.normalImpulse;
                        _loc7_.tangentImpulse = _loc15_.tangentImpulse;
                        _loc7_.id.key = _loc14_.id.key;
                        this.m_listener.Result(_loc7_);
                        _loc13_++;
                    }
                    _loc11_++;
                }
                _loc4_++;
            }
        }
        
        public function AddBody(param1:b2Body) : void
        {
            var _loc2_:* = this.m_bodyCount++;
            this.m_bodies[_loc2_] = param1;
        }
        
        public function AddContact(param1:b2Contact) : void
        {
            var _loc2_:* = this.m_contactCount++;
            this.m_contacts[_loc2_] = param1;
        }
        
        public function AddJoint(param1:b2Joint) : void
        {
            var _loc2_:* = this.m_jointCount++;
            this.m_joints[_loc2_] = param1;
        }
    }
}

