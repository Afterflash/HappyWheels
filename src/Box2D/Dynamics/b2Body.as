package Box2D.Dynamics
{
    import Box2D.Collision.Shapes.b2MassData;
    import Box2D.Collision.Shapes.b2Shape;
    import Box2D.Collision.Shapes.b2ShapeDef;
    import Box2D.Common.Math.b2Mat22;
    import Box2D.Common.Math.b2Math;
    import Box2D.Common.Math.b2Sweep;
    import Box2D.Common.Math.b2Vec2;
    import Box2D.Common.Math.b2XForm;
    import Box2D.Dynamics.Contacts.b2ContactEdge;
    import Box2D.Dynamics.Joints.b2JointEdge;
    
    public class b2Body
    {
        private static var s_massData:b2MassData = new b2MassData();
        
        private static var s_xf1:b2XForm = new b2XForm();
        
        public static var e_frozenFlag:uint = 2;
        
        public static var e_islandFlag:uint = 4;
        
        public static var e_sleepFlag:uint = 8;
        
        public static var e_allowSleepFlag:uint = 16;
        
        public static var e_bulletFlag:uint = 32;
        
        public static var e_fixedRotationFlag:uint = 64;
        
        public static var e_staticType:uint = 1;
        
        public static var e_dynamicType:uint = 2;
        
        public static var e_maxTypes:uint = 3;
        
        public var m_flags:uint;
        
        public var m_type:int;
        
        public var m_xf:b2XForm = new b2XForm();
        
        public var m_sweep:b2Sweep = new b2Sweep();
        
        public var m_linearVelocity:b2Vec2 = new b2Vec2();
        
        public var m_angularVelocity:Number;
        
        public var m_force:b2Vec2 = new b2Vec2();
        
        public var m_torque:Number;
        
        public var m_world:b2World;
        
        public var m_prev:b2Body;
        
        public var m_next:b2Body;
        
        public var m_shapeList:b2Shape;
        
        public var m_shapeCount:int;
        
        public var m_jointList:b2JointEdge;
        
        public var m_contactList:b2ContactEdge;
        
        public var m_mass:Number;
        
        public var m_invMass:Number;
        
        public var m_I:Number;
        
        public var m_invI:Number;
        
        public var m_linearDamping:Number;
        
        public var m_angularDamping:Number;
        
        public var m_sleepTime:Number;
        
        public var m_userData:*;
        
        public var destroyed:Boolean;
        
        public function b2Body(param1:b2BodyDef, param2:b2World)
        {
            super();
            this.m_flags = 0;
            if(param1.isBullet)
            {
                this.m_flags |= e_bulletFlag;
            }
            if(param1.fixedRotation)
            {
                this.m_flags |= e_fixedRotationFlag;
            }
            if(param1.allowSleep)
            {
                this.m_flags |= e_allowSleepFlag;
            }
            if(param1.isSleeping)
            {
                this.m_flags |= e_sleepFlag;
            }
            this.m_world = param2;
            this.m_xf.position.SetV(param1.position);
            this.m_xf.R.Set(param1.angle);
            this.m_sweep.localCenter.SetV(param1.massData.center);
            this.m_sweep.t0 = 1;
            this.m_sweep.a0 = this.m_sweep.a = param1.angle;
            var _loc3_:b2Mat22 = this.m_xf.R;
            var _loc4_:b2Vec2 = this.m_sweep.localCenter;
            this.m_sweep.c.x = _loc3_.col1.x * _loc4_.x + _loc3_.col2.x * _loc4_.y;
            this.m_sweep.c.y = _loc3_.col1.y * _loc4_.x + _loc3_.col2.y * _loc4_.y;
            this.m_sweep.c.x += this.m_xf.position.x;
            this.m_sweep.c.y += this.m_xf.position.y;
            this.m_sweep.c0.SetV(this.m_sweep.c);
            this.m_jointList = null;
            this.m_contactList = null;
            this.m_prev = null;
            this.m_next = null;
            this.m_linearDamping = param1.linearDamping;
            this.m_angularDamping = param1.angularDamping;
            this.m_force.Set(0,0);
            this.m_torque = 0;
            this.m_linearVelocity.SetZero();
            this.m_angularVelocity = 0;
            this.m_sleepTime = 0;
            this.m_invMass = 0;
            this.m_I = 0;
            this.m_invI = 0;
            this.m_mass = param1.massData.mass;
            if(this.m_mass > 0)
            {
                this.m_invMass = 1 / this.m_mass;
            }
            if((this.m_flags & b2Body.e_fixedRotationFlag) == 0)
            {
                this.m_I = param1.massData.I;
            }
            if(this.m_I > 0)
            {
                this.m_invI = 1 / this.m_I;
            }
            if(this.m_invMass == 0 && this.m_invI == 0)
            {
                this.m_type = e_staticType;
            }
            else
            {
                this.m_type = e_dynamicType;
            }
            this.m_userData = param1.userData;
            this.m_shapeList = null;
            this.m_shapeCount = 0;
        }
        
        public function CreateShape(param1:b2ShapeDef) : b2Shape
        {
            if(this.m_world.m_lock == true)
            {
                return null;
            }
            var _loc2_:b2Shape = b2Shape.Create(param1,this.m_world.m_blockAllocator);
            _loc2_.m_next = this.m_shapeList;
            this.m_shapeList = _loc2_;
            ++this.m_shapeCount;
            _loc2_.m_body = this;
            _loc2_.CreateProxy(this.m_world.m_broadPhase,this.m_xf);
            _loc2_.UpdateSweepRadius(this.m_sweep.localCenter);
            return _loc2_;
        }
        
        public function DestroyShape(param1:b2Shape) : void
        {
            if(this.m_world.m_lock == true)
            {
                return;
            }
            param1.DestroyProxy(this.m_world.m_broadPhase);
            var _loc2_:b2Shape = this.m_shapeList;
            var _loc3_:b2Shape = null;
            var _loc4_:Boolean = false;
            while(_loc2_ != null)
            {
                if(_loc2_ == param1)
                {
                    if(_loc3_)
                    {
                        _loc3_.m_next = param1.m_next;
                    }
                    else
                    {
                        this.m_shapeList = param1.m_next;
                    }
                    _loc4_ = true;
                    break;
                }
                _loc3_ = _loc2_;
                _loc2_ = _loc2_.m_next;
            }
            param1.m_body = null;
            param1.m_next = null;
            --this.m_shapeCount;
            b2Shape.Destroy(param1,this.m_world.m_blockAllocator);
        }
        
        public function SetMass(param1:b2MassData) : void
        {
            var _loc2_:b2Shape = null;
            if(this.m_world.m_lock == true)
            {
                return;
            }
            this.m_invMass = 0;
            this.m_I = 0;
            this.m_invI = 0;
            this.m_mass = param1.mass;
            if(this.m_mass > 0)
            {
                this.m_invMass = 1 / this.m_mass;
            }
            if((this.m_flags & b2Body.e_fixedRotationFlag) == 0)
            {
                this.m_I = param1.I;
            }
            if(this.m_I > 0)
            {
                this.m_invI = 1 / this.m_I;
            }
            this.m_sweep.localCenter.SetV(param1.center);
            var _loc3_:b2Mat22 = this.m_xf.R;
            var _loc4_:b2Vec2 = this.m_sweep.localCenter;
            this.m_sweep.c.x = _loc3_.col1.x * _loc4_.x + _loc3_.col2.x * _loc4_.y;
            this.m_sweep.c.y = _loc3_.col1.y * _loc4_.x + _loc3_.col2.y * _loc4_.y;
            this.m_sweep.c.x += this.m_xf.position.x;
            this.m_sweep.c.y += this.m_xf.position.y;
            this.m_sweep.c0.SetV(this.m_sweep.c);
            _loc2_ = this.m_shapeList;
            while(_loc2_)
            {
                _loc2_.UpdateSweepRadius(this.m_sweep.localCenter);
                _loc2_ = _loc2_.m_next;
            }
            var _loc5_:int = this.m_type;
            if(this.m_invMass == 0 && this.m_invI == 0)
            {
                this.m_type = e_staticType;
            }
            else
            {
                this.m_type = e_dynamicType;
            }
            if(_loc5_ != this.m_type)
            {
                _loc2_ = this.m_shapeList;
                while(_loc2_)
                {
                    _loc2_.RefilterProxy(this.m_world.m_broadPhase,this.m_xf);
                    _loc2_ = _loc2_.m_next;
                }
            }
        }
        
        public function SetMassFromShapes() : void
        {
            var _loc1_:b2Shape = null;
            if(this.m_world.m_lock == true)
            {
                return;
            }
            this.m_mass = 0;
            this.m_invMass = 0;
            this.m_I = 0;
            this.m_invI = 0;
            var _loc2_:Number = 0;
            var _loc3_:Number = 0;
            var _loc4_:b2MassData = s_massData;
            _loc1_ = this.m_shapeList;
            while(_loc1_)
            {
                _loc1_.ComputeMass(_loc4_);
                this.m_mass += _loc4_.mass;
                _loc2_ += _loc4_.mass * _loc4_.center.x;
                _loc3_ += _loc4_.mass * _loc4_.center.y;
                this.m_I += _loc4_.I;
                _loc1_ = _loc1_.m_next;
            }
            if(this.m_mass > 0)
            {
                this.m_invMass = 1 / this.m_mass;
                _loc2_ *= this.m_invMass;
                _loc3_ *= this.m_invMass;
            }
            if(this.m_I > 0 && (this.m_flags & e_fixedRotationFlag) == 0)
            {
                this.m_I -= this.m_mass * (_loc2_ * _loc2_ + _loc3_ * _loc3_);
                this.m_invI = 1 / this.m_I;
            }
            else
            {
                this.m_I = 0;
                this.m_invI = 0;
            }
            this.m_sweep.localCenter.Set(_loc2_,_loc3_);
            var _loc5_:b2Mat22 = this.m_xf.R;
            var _loc6_:b2Vec2 = this.m_sweep.localCenter;
            this.m_sweep.c.x = _loc5_.col1.x * _loc6_.x + _loc5_.col2.x * _loc6_.y;
            this.m_sweep.c.y = _loc5_.col1.y * _loc6_.x + _loc5_.col2.y * _loc6_.y;
            this.m_sweep.c.x += this.m_xf.position.x;
            this.m_sweep.c.y += this.m_xf.position.y;
            this.m_sweep.c0.SetV(this.m_sweep.c);
            _loc1_ = this.m_shapeList;
            while(_loc1_)
            {
                _loc1_.UpdateSweepRadius(this.m_sweep.localCenter);
                _loc1_ = _loc1_.m_next;
            }
            var _loc7_:int = this.m_type;
            if(this.m_invMass == 0 && this.m_invI == 0)
            {
                this.m_type = e_staticType;
            }
            else
            {
                this.m_type = e_dynamicType;
            }
            if(_loc7_ != this.m_type)
            {
                _loc1_ = this.m_shapeList;
                while(_loc1_)
                {
                    _loc1_.RefilterProxy(this.m_world.m_broadPhase,this.m_xf);
                    _loc1_ = _loc1_.m_next;
                }
            }
        }
        
        public function SetXForm(param1:b2Vec2, param2:Number) : Boolean
        {
            var _loc3_:b2Shape = null;
            var _loc7_:Boolean = false;
            if(this.m_world.m_lock == true)
            {
                return true;
            }
            if(this.IsFrozen())
            {
                return false;
            }
            this.m_xf.R.Set(param2);
            this.m_xf.position.SetV(param1);
            var _loc4_:b2Mat22 = this.m_xf.R;
            var _loc5_:b2Vec2 = this.m_sweep.localCenter;
            this.m_sweep.c.x = _loc4_.col1.x * _loc5_.x + _loc4_.col2.x * _loc5_.y;
            this.m_sweep.c.y = _loc4_.col1.y * _loc5_.x + _loc4_.col2.y * _loc5_.y;
            this.m_sweep.c.x += this.m_xf.position.x;
            this.m_sweep.c.y += this.m_xf.position.y;
            this.m_sweep.c0.SetV(this.m_sweep.c);
            this.m_sweep.a0 = this.m_sweep.a = param2;
            var _loc6_:Boolean = false;
            _loc3_ = this.m_shapeList;
            while(_loc3_)
            {
                _loc7_ = _loc3_.Synchronize(this.m_world.m_broadPhase,this.m_xf,this.m_xf);
                if(_loc7_ == false)
                {
                    _loc6_ = true;
                    break;
                }
                _loc3_ = _loc3_.m_next;
            }
            if(_loc6_ == true)
            {
                this.m_flags |= e_frozenFlag;
                this.m_linearVelocity.SetZero();
                this.m_angularVelocity = 0;
                _loc3_ = this.m_shapeList;
                while(_loc3_)
                {
                    _loc3_.DestroyProxy(this.m_world.m_broadPhase);
                    _loc3_ = _loc3_.m_next;
                }
                return false;
            }
            this.m_world.m_broadPhase.Commit();
            return true;
        }
        
        public function GetXForm() : b2XForm
        {
            return this.m_xf;
        }
        
        public function GetPosition() : b2Vec2
        {
            return this.m_xf.position;
        }
        
        public function GetAngle() : Number
        {
            return this.m_sweep.a;
        }
        
        public function GetWorldCenter() : b2Vec2
        {
            return this.m_sweep.c;
        }
        
        public function GetLocalCenter() : b2Vec2
        {
            return this.m_sweep.localCenter;
        }
        
        public function SetLinearVelocity(param1:b2Vec2) : void
        {
            this.m_linearVelocity.SetV(param1);
        }
        
        public function GetLinearVelocity() : b2Vec2
        {
            return this.m_linearVelocity;
        }
        
        public function SetAngularVelocity(param1:Number) : void
        {
            this.m_angularVelocity = param1;
        }
        
        public function GetAngularVelocity() : Number
        {
            return this.m_angularVelocity;
        }
        
        public function ApplyForce(param1:b2Vec2, param2:b2Vec2) : void
        {
            if(this.IsSleeping())
            {
                this.WakeUp();
            }
            this.m_force.x += param1.x;
            this.m_force.y += param1.y;
            this.m_torque += (param2.x - this.m_sweep.c.x) * param1.y - (param2.y - this.m_sweep.c.y) * param1.x;
        }
        
        public function ApplyTorque(param1:Number) : void
        {
            if(this.IsSleeping())
            {
                this.WakeUp();
            }
            this.m_torque += param1;
        }
        
        public function ApplyImpulse(param1:b2Vec2, param2:b2Vec2) : void
        {
            if(this.IsSleeping())
            {
                this.WakeUp();
            }
            this.m_linearVelocity.x += this.m_invMass * param1.x;
            this.m_linearVelocity.y += this.m_invMass * param1.y;
            this.m_angularVelocity += this.m_invI * ((param2.x - this.m_sweep.c.x) * param1.y - (param2.y - this.m_sweep.c.y) * param1.x);
        }
        
        public function GetMass() : Number
        {
            return this.m_mass;
        }
        
        public function GetInertia() : Number
        {
            return this.m_I;
        }
        
        public function GetWorldPoint(param1:b2Vec2) : b2Vec2
        {
            var _loc2_:b2Mat22 = this.m_xf.R;
            var _loc3_:b2Vec2 = new b2Vec2(_loc2_.col1.x * param1.x + _loc2_.col2.x * param1.y,_loc2_.col1.y * param1.x + _loc2_.col2.y * param1.y);
            _loc3_.x += this.m_xf.position.x;
            _loc3_.y += this.m_xf.position.y;
            return _loc3_;
        }
        
        public function GetWorldVector(param1:b2Vec2) : b2Vec2
        {
            return b2Math.b2MulMV(this.m_xf.R,param1);
        }
        
        public function GetLocalPoint(param1:b2Vec2) : b2Vec2
        {
            return b2Math.b2MulXT(this.m_xf,param1);
        }
        
        public function GetLocalVector(param1:b2Vec2) : b2Vec2
        {
            return b2Math.b2MulTMV(this.m_xf.R,param1);
        }
        
        public function GetLinearVelocityFromWorldPoint(param1:b2Vec2) : b2Vec2
        {
            return new b2Vec2(this.m_linearVelocity.x + this.m_angularVelocity * (param1.y - this.m_sweep.c.y),this.m_linearVelocity.y - this.m_angularVelocity * (param1.x - this.m_sweep.c.x));
        }
        
        public function GetLinearVelocityFromLocalPoint(param1:b2Vec2) : b2Vec2
        {
            var _loc2_:b2Mat22 = this.m_xf.R;
            var _loc3_:b2Vec2 = new b2Vec2(_loc2_.col1.x * param1.x + _loc2_.col2.x * param1.y,_loc2_.col1.y * param1.x + _loc2_.col2.y * param1.y);
            _loc3_.x += this.m_xf.position.x;
            _loc3_.y += this.m_xf.position.y;
            return new b2Vec2(this.m_linearVelocity.x + this.m_angularVelocity * (_loc3_.y - this.m_sweep.c.y),this.m_linearVelocity.y - this.m_angularVelocity * (_loc3_.x - this.m_sweep.c.x));
        }
        
        public function IsBullet() : Boolean
        {
            return (this.m_flags & e_bulletFlag) == e_bulletFlag;
        }
        
        public function SetBullet(param1:Boolean) : void
        {
            if(param1)
            {
                this.m_flags |= e_bulletFlag;
            }
            else
            {
                this.m_flags &= ~e_bulletFlag;
            }
        }
        
        public function IsStatic() : Boolean
        {
            return this.m_type == e_staticType;
        }
        
        public function IsDynamic() : Boolean
        {
            return this.m_type == e_dynamicType;
        }
        
        public function IsFrozen() : Boolean
        {
            return (this.m_flags & e_frozenFlag) == e_frozenFlag;
        }
        
        public function IsSleeping() : Boolean
        {
            return (this.m_flags & e_sleepFlag) == e_sleepFlag;
        }
        
        public function AllowSleeping(param1:Boolean) : void
        {
            if(param1)
            {
                this.m_flags |= e_allowSleepFlag;
            }
            else
            {
                this.m_flags &= ~e_allowSleepFlag;
                this.WakeUp();
            }
        }
        
        public function WakeUp() : void
        {
            this.m_flags &= ~e_sleepFlag;
            this.m_sleepTime = 0;
        }
        
        public function PutToSleep() : void
        {
            this.m_flags |= e_sleepFlag;
            this.m_sleepTime = 0;
            this.m_linearVelocity.SetZero();
            this.m_angularVelocity = 0;
            this.m_force.SetZero();
            this.m_torque = 0;
        }
        
        public function GetShapeList() : b2Shape
        {
            return this.m_shapeList;
        }
        
        public function GetJointList() : b2JointEdge
        {
            return this.m_jointList;
        }
        
        public function GetNext() : b2Body
        {
            return this.m_next;
        }
        
        public function GetUserData() : *
        {
            return this.m_userData;
        }
        
        public function SetUserData(param1:*) : void
        {
            this.m_userData = param1;
        }
        
        public function GetWorld() : b2World
        {
            return this.m_world;
        }
        
        public function SynchronizeShapes() : Boolean
        {
            var _loc4_:b2Shape = null;
            var _loc1_:b2XForm = s_xf1;
            _loc1_.R.Set(this.m_sweep.a0);
            var _loc2_:b2Mat22 = _loc1_.R;
            var _loc3_:b2Vec2 = this.m_sweep.localCenter;
            _loc1_.position.x = this.m_sweep.c0.x - (_loc2_.col1.x * _loc3_.x + _loc2_.col2.x * _loc3_.y);
            _loc1_.position.y = this.m_sweep.c0.y - (_loc2_.col1.y * _loc3_.x + _loc2_.col2.y * _loc3_.y);
            var _loc5_:Boolean = true;
            _loc4_ = this.m_shapeList;
            while(_loc4_)
            {
                _loc5_ = _loc4_.Synchronize(this.m_world.m_broadPhase,_loc1_,this.m_xf);
                if(_loc5_ == false)
                {
                    break;
                }
                _loc4_ = _loc4_.m_next;
            }
            if(_loc5_ == false)
            {
                this.m_flags |= e_frozenFlag;
                this.m_linearVelocity.SetZero();
                this.m_angularVelocity = 0;
                _loc4_ = this.m_shapeList;
                while(_loc4_)
                {
                    _loc4_.DestroyProxy(this.m_world.m_broadPhase);
                    _loc4_ = _loc4_.m_next;
                }
                return false;
            }
            return true;
        }
        
        public function SynchronizeTransform() : void
        {
            this.m_xf.R.Set(this.m_sweep.a);
            var _loc1_:b2Mat22 = this.m_xf.R;
            var _loc2_:b2Vec2 = this.m_sweep.localCenter;
            this.m_xf.position.x = this.m_sweep.c.x - (_loc1_.col1.x * _loc2_.x + _loc1_.col2.x * _loc2_.y);
            this.m_xf.position.y = this.m_sweep.c.y - (_loc1_.col1.y * _loc2_.x + _loc1_.col2.y * _loc2_.y);
        }
        
        public function IsConnected(param1:b2Body) : Boolean
        {
            var _loc2_:b2JointEdge = this.m_jointList;
            while(_loc2_)
            {
                if(_loc2_.other == param1)
                {
                    return _loc2_.joint.m_collideConnected == false;
                }
                _loc2_ = _loc2_.next;
            }
            return false;
        }
        
        public function Advance(param1:Number) : void
        {
            this.m_sweep.Advance(param1);
            this.m_sweep.c.SetV(this.m_sweep.c0);
            this.m_sweep.a = this.m_sweep.a0;
            this.SynchronizeTransform();
        }
    }
}

