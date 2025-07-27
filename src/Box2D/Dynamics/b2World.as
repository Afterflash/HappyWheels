package Box2D.Dynamics
{
    import Box2D.Collision.*;
    import Box2D.Collision.Shapes.*;
    import Box2D.Common.*;
    import Box2D.Common.Math.*;
    import Box2D.Dynamics.Contacts.*;
    import Box2D.Dynamics.Joints.*;
    
    public class b2World
    {
        public static var m_positionCorrection:Boolean;
        
        public static var m_warmStarting:Boolean;
        
        public static var m_continuousPhysics:Boolean;
        
        private static var s_jointColor:b2Color = new b2Color(0.5,0.8,0.8);
        
        private static var s_coreColor:b2Color = new b2Color(0.9,0.6,0.6);
        
        private static var s_xf:b2XForm = new b2XForm();
        
        public var m_blockAllocator:*;
        
        public var m_stackAllocator:*;
        
        public var m_lock:Boolean;
        
        public var m_broadPhase:b2BroadPhase;
        
        public var m_contactManager:b2ContactManager = new b2ContactManager();
        
        public var m_bodyList:b2Body;
        
        public var m_jointList:b2Joint;
        
        public var m_contactList:b2Contact;
        
        public var m_bodyCount:int;
        
        public var m_contactCount:int;
        
        public var m_jointCount:int;
        
        public var m_gravity:b2Vec2;
        
        public var m_allowSleep:Boolean;
        
        public var m_groundBody:b2Body;
        
        public var m_destructionListener:b2DestructionListener;
        
        public var m_boundaryListener:b2BoundaryListener;
        
        public var m_contactFilter:b2ContactFilter;
        
        public var m_contactListener:b2ContactListener;
        
        public var m_debugDraw:b2DebugDraw;
        
        public var m_inv_dt0:Number;
        
        public var m_positionIterationCount:int;
        
        public function b2World(param1:b2AABB, param2:b2Vec2, param3:Boolean)
        {
            super();
            this.m_destructionListener = null;
            this.m_boundaryListener = null;
            this.m_contactFilter = b2ContactFilter.b2_defaultFilter;
            this.m_contactListener = null;
            this.m_debugDraw = null;
            this.m_bodyList = null;
            this.m_contactList = null;
            this.m_jointList = null;
            this.m_bodyCount = 0;
            this.m_contactCount = 0;
            this.m_jointCount = 0;
            m_positionCorrection = true;
            m_warmStarting = true;
            m_continuousPhysics = true;
            this.m_allowSleep = param3;
            this.m_gravity = param2;
            this.m_lock = false;
            this.m_inv_dt0 = 0;
            this.m_contactManager.m_world = this;
            this.m_broadPhase = new b2BroadPhase(param1,this.m_contactManager);
            var _loc4_:b2BodyDef = new b2BodyDef();
            this.m_groundBody = this.CreateBody(_loc4_);
        }
        
        public function SetDestructionListener(param1:b2DestructionListener) : void
        {
            this.m_destructionListener = param1;
        }
        
        public function SetBoundaryListener(param1:b2BoundaryListener) : void
        {
            this.m_boundaryListener = param1;
        }
        
        public function SetContactFilter(param1:b2ContactFilter) : void
        {
            this.m_contactFilter = param1;
        }
        
        public function SetContactListener(param1:b2ContactListener) : void
        {
            this.m_contactListener = param1;
        }
        
        public function SetDebugDraw(param1:b2DebugDraw) : void
        {
            this.m_debugDraw = param1;
        }
        
        public function Validate() : void
        {
            this.m_broadPhase.Validate();
        }
        
        public function GetProxyCount() : int
        {
            return this.m_broadPhase.m_proxyCount;
        }
        
        public function GetPairCount() : int
        {
            return this.m_broadPhase.m_pairManager.m_pairCount;
        }
        
        public function CreateBody(param1:b2BodyDef) : b2Body
        {
            if(this.m_lock == true)
            {
                return null;
            }
            var _loc2_:b2Body = new b2Body(param1,this);
            _loc2_.m_prev = null;
            _loc2_.m_next = this.m_bodyList;
            if(this.m_bodyList)
            {
                this.m_bodyList.m_prev = _loc2_;
            }
            this.m_bodyList = _loc2_;
            ++this.m_bodyCount;
            return _loc2_;
        }
        
        public function DestroyBody(param1:b2Body) : void
        {
            var _loc4_:b2JointEdge = null;
            var _loc5_:b2Shape = null;
            if(this.m_lock == true)
            {
                return;
            }
            var _loc2_:b2JointEdge = param1.m_jointList;
            while(_loc2_)
            {
                _loc4_ = _loc2_;
                _loc2_ = _loc2_.next;
                if(this.m_destructionListener)
                {
                    this.m_destructionListener.SayGoodbyeJoint(_loc4_.joint);
                }
                this.DestroyJoint(_loc4_.joint);
            }
            var _loc3_:b2Shape = param1.m_shapeList;
            while(_loc3_)
            {
                _loc5_ = _loc3_;
                _loc3_ = _loc3_.m_next;
                if(this.m_destructionListener)
                {
                    this.m_destructionListener.SayGoodbyeShape(_loc5_);
                }
                _loc5_.DestroyProxy(this.m_broadPhase);
                b2Shape.Destroy(_loc5_,this.m_blockAllocator);
            }
            if(param1.m_prev)
            {
                param1.m_prev.m_next = param1.m_next;
            }
            if(param1.m_next)
            {
                param1.m_next.m_prev = param1.m_prev;
            }
            if(param1 == this.m_bodyList)
            {
                this.m_bodyList = param1.m_next;
            }
            --this.m_bodyCount;
            param1.destroyed = true;
        }
        
        public function CreateJoint(param1:b2JointDef) : b2Joint
        {
            var _loc3_:b2Body = null;
            var _loc4_:b2Shape = null;
            var _loc2_:b2Joint = b2Joint.Create(param1,this.m_blockAllocator);
            _loc2_.m_prev = null;
            _loc2_.m_next = this.m_jointList;
            if(this.m_jointList)
            {
                this.m_jointList.m_prev = _loc2_;
            }
            this.m_jointList = _loc2_;
            ++this.m_jointCount;
            _loc2_.m_node1.joint = _loc2_;
            _loc2_.m_node1.other = _loc2_.m_body2;
            _loc2_.m_node1.prev = null;
            _loc2_.m_node1.next = _loc2_.m_body1.m_jointList;
            if(_loc2_.m_body1.m_jointList)
            {
                _loc2_.m_body1.m_jointList.prev = _loc2_.m_node1;
            }
            _loc2_.m_body1.m_jointList = _loc2_.m_node1;
            _loc2_.m_node2.joint = _loc2_;
            _loc2_.m_node2.other = _loc2_.m_body1;
            _loc2_.m_node2.prev = null;
            _loc2_.m_node2.next = _loc2_.m_body2.m_jointList;
            if(_loc2_.m_body2.m_jointList)
            {
                _loc2_.m_body2.m_jointList.prev = _loc2_.m_node2;
            }
            _loc2_.m_body2.m_jointList = _loc2_.m_node2;
            if(param1.collideConnected == false)
            {
                _loc3_ = param1.body1.m_shapeCount < param1.body2.m_shapeCount ? param1.body1 : param1.body2;
                _loc4_ = _loc3_.m_shapeList;
                while(_loc4_)
                {
                    _loc4_.RefilterProxy(this.m_broadPhase,_loc3_.m_xf);
                    _loc4_ = _loc4_.m_next;
                }
            }
            return _loc2_;
        }
        
        public function DestroyJoint(param1:b2Joint) : void
        {
            var _loc5_:b2Body = null;
            var _loc6_:b2Shape = null;
            var _loc2_:Boolean = param1.m_collideConnected;
            if(param1.m_prev)
            {
                param1.m_prev.m_next = param1.m_next;
            }
            if(param1.m_next)
            {
                param1.m_next.m_prev = param1.m_prev;
            }
            if(param1 == this.m_jointList)
            {
                this.m_jointList = param1.m_next;
            }
            var _loc3_:b2Body = param1.m_body1;
            var _loc4_:b2Body = param1.m_body2;
            _loc3_.WakeUp();
            _loc4_.WakeUp();
            if(param1.m_node1.prev)
            {
                param1.m_node1.prev.next = param1.m_node1.next;
            }
            if(param1.m_node1.next)
            {
                param1.m_node1.next.prev = param1.m_node1.prev;
            }
            if(param1.m_node1 == _loc3_.m_jointList)
            {
                _loc3_.m_jointList = param1.m_node1.next;
            }
            param1.m_node1.prev = null;
            param1.m_node1.next = null;
            if(param1.m_node2.prev)
            {
                param1.m_node2.prev.next = param1.m_node2.next;
            }
            if(param1.m_node2.next)
            {
                param1.m_node2.next.prev = param1.m_node2.prev;
            }
            if(param1.m_node2 == _loc4_.m_jointList)
            {
                _loc4_.m_jointList = param1.m_node2.next;
            }
            param1.m_node2.prev = null;
            param1.m_node2.next = null;
            b2Joint.Destroy(param1,this.m_blockAllocator);
            --this.m_jointCount;
            if(_loc2_ == false)
            {
                _loc5_ = _loc3_.m_shapeCount < _loc4_.m_shapeCount ? _loc3_ : _loc4_;
                _loc6_ = _loc5_.m_shapeList;
                while(_loc6_)
                {
                    _loc6_.RefilterProxy(this.m_broadPhase,_loc5_.m_xf);
                    _loc6_ = _loc6_.m_next;
                }
            }
        }
        
        public function Refilter(param1:b2Shape) : void
        {
            param1.RefilterProxy(this.m_broadPhase,param1.m_body.m_xf);
        }
        
        public function SetWarmStarting(param1:Boolean) : void
        {
            m_warmStarting = param1;
        }
        
        public function SetPositionCorrection(param1:Boolean) : void
        {
            m_positionCorrection = param1;
        }
        
        public function SetContinuousPhysics(param1:Boolean) : void
        {
            m_continuousPhysics = param1;
        }
        
        public function GetBodyCount() : int
        {
            return this.m_bodyCount;
        }
        
        public function GetJointCount() : int
        {
            return this.m_jointCount;
        }
        
        public function GetContactCount() : int
        {
            return this.m_contactCount;
        }
        
        public function SetGravity(param1:b2Vec2) : void
        {
            this.m_gravity = param1;
        }
        
        public function GetGroundBody() : b2Body
        {
            return this.m_groundBody;
        }
        
        public function Step(param1:Number, param2:int) : void
        {
            this.m_lock = true;
            var _loc3_:b2TimeStep = new b2TimeStep();
            _loc3_.dt = param1;
            _loc3_.maxIterations = param2;
            if(param1 > 0)
            {
                _loc3_.inv_dt = 1 / param1;
            }
            else
            {
                _loc3_.inv_dt = 0;
            }
            _loc3_.dtRatio = this.m_inv_dt0 * param1;
            _loc3_.positionCorrection = m_positionCorrection;
            _loc3_.warmStarting = m_warmStarting;
            this.m_contactManager.Collide();
            if(_loc3_.dt > 0)
            {
                this.Solve(_loc3_);
            }
            if(m_continuousPhysics && _loc3_.dt > 0)
            {
                this.SolveTOI(_loc3_);
            }
            this.DrawDebugData();
            this.m_inv_dt0 = _loc3_.inv_dt;
            this.m_lock = false;
        }
        
        public function Query(param1:b2AABB, param2:Array, param3:int) : int
        {
            var _loc4_:Array = new Array(param3);
            var _loc5_:int = this.m_broadPhase.QueryAABB(param1,_loc4_,param3);
            var _loc6_:int = 0;
            while(_loc6_ < _loc5_)
            {
                param2[_loc6_] = _loc4_[_loc6_];
                _loc6_++;
            }
            return _loc5_;
        }
        
        public function GetBodyList() : b2Body
        {
            return this.m_bodyList;
        }
        
        public function GetJointList() : b2Joint
        {
            return this.m_jointList;
        }
        
        public function Solve(param1:b2TimeStep) : void
        {
            var _loc2_:b2Body = null;
            var _loc9_:int = 0;
            var _loc10_:int = 0;
            var _loc11_:b2Body = null;
            var _loc12_:b2ContactEdge = null;
            var _loc13_:b2JointEdge = null;
            var _loc14_:Boolean = false;
            this.m_positionIterationCount = 0;
            var _loc3_:b2Island = new b2Island(this.m_bodyCount,this.m_contactCount,this.m_jointCount,this.m_stackAllocator,this.m_contactListener);
            _loc2_ = this.m_bodyList;
            while(_loc2_)
            {
                _loc2_.m_flags &= ~b2Body.e_islandFlag;
                _loc2_ = _loc2_.m_next;
            }
            var _loc4_:b2Contact = this.m_contactList;
            while(_loc4_)
            {
                _loc4_.m_flags &= ~b2Contact.e_islandFlag;
                _loc4_ = _loc4_.m_next;
            }
            var _loc5_:b2Joint = this.m_jointList;
            while(_loc5_)
            {
                _loc5_.m_islandFlag = false;
                _loc5_ = _loc5_.m_next;
            }
            var _loc6_:int = this.m_bodyCount;
            var _loc7_:Array = new Array(_loc6_);
            var _loc8_:b2Body = this.m_bodyList;
            while(_loc8_)
            {
                if(!(_loc8_.m_flags & (b2Body.e_islandFlag | b2Body.e_sleepFlag | b2Body.e_frozenFlag)))
                {
                    if(!_loc8_.IsStatic())
                    {
                        _loc3_.Clear();
                        _loc9_ = 0;
                        var _loc15_:*;
                        _loc7_[_loc15_ = _loc9_++] = _loc8_;
                        _loc8_.m_flags |= b2Body.e_islandFlag;
                        while(_loc9_ > 0)
                        {
                            _loc2_ = _loc7_[--_loc9_];
                            _loc3_.AddBody(_loc2_);
                            _loc2_.m_flags &= ~b2Body.e_sleepFlag;
                            if(!_loc2_.IsStatic())
                            {
                                _loc12_ = _loc2_.m_contactList;
                                while(_loc12_)
                                {
                                    if(!(_loc12_.contact.m_flags & (b2Contact.e_islandFlag | b2Contact.e_nonSolidFlag)))
                                    {
                                        if(_loc12_.contact.m_manifoldCount != 0)
                                        {
                                            _loc3_.AddContact(_loc12_.contact);
                                            _loc12_.contact.m_flags |= b2Contact.e_islandFlag;
                                            _loc11_ = _loc12_.other;
                                            if(!(_loc11_.m_flags & b2Body.e_islandFlag))
                                            {
                                                var _loc16_:*;
                                                _loc7_[_loc16_ = _loc9_++] = _loc11_;
                                                _loc11_.m_flags |= b2Body.e_islandFlag;
                                            }
                                        }
                                    }
                                    _loc12_ = _loc12_.next;
                                }
                                _loc13_ = _loc2_.m_jointList;
                                while(_loc13_)
                                {
                                    if(_loc13_.joint.m_islandFlag != true)
                                    {
                                        _loc3_.AddJoint(_loc13_.joint);
                                        _loc13_.joint.m_islandFlag = true;
                                        _loc11_ = _loc13_.other;
                                        if(!(_loc11_.m_flags & b2Body.e_islandFlag))
                                        {
                                            _loc7_[_loc16_ = _loc9_++] = _loc11_;
                                            _loc11_.m_flags |= b2Body.e_islandFlag;
                                        }
                                    }
                                    _loc13_ = _loc13_.next;
                                }
                            }
                        }
                        _loc3_.Solve(param1,this.m_gravity,m_positionCorrection,this.m_allowSleep);
                        if(_loc3_.m_positionIterationCount > this.m_positionIterationCount)
                        {
                            this.m_positionIterationCount = _loc3_.m_positionIterationCount;
                        }
                        _loc10_ = 0;
                        while(_loc10_ < _loc3_.m_bodyCount)
                        {
                            _loc2_ = _loc3_.m_bodies[_loc10_];
                            if(_loc2_.IsStatic())
                            {
                                _loc2_.m_flags &= ~b2Body.e_islandFlag;
                            }
                            _loc10_++;
                        }
                    }
                }
                _loc8_ = _loc8_.m_next;
            }
            _loc2_ = this.m_bodyList;
            while(_loc2_)
            {
                if(!(_loc2_.m_flags & (b2Body.e_sleepFlag | b2Body.e_frozenFlag)))
                {
                    if(!_loc2_.IsStatic())
                    {
                        _loc14_ = _loc2_.SynchronizeShapes();
                        if(_loc14_ == false && this.m_boundaryListener != null)
                        {
                            this.m_boundaryListener.Violation(_loc2_);
                        }
                    }
                }
                _loc2_ = _loc2_.m_next;
            }
            this.m_broadPhase.Commit();
        }
        
        public function SolveTOI(param1:b2TimeStep) : void
        {
            var _loc2_:b2Body = null;
            var _loc3_:b2Shape = null;
            var _loc4_:b2Shape = null;
            var _loc5_:b2Body = null;
            var _loc6_:b2Body = null;
            var _loc7_:b2ContactEdge = null;
            var _loc11_:b2Contact = null;
            var _loc12_:b2Contact = null;
            var _loc13_:Number = NaN;
            var _loc14_:b2Body = null;
            var _loc15_:int = 0;
            var _loc16_:b2TimeStep = null;
            var _loc17_:int = 0;
            var _loc18_:Number = NaN;
            var _loc19_:Number = NaN;
            var _loc20_:b2Body = null;
            var _loc21_:Boolean = false;
            var _loc8_:b2Island = new b2Island(this.m_bodyCount,b2Settings.b2_maxTOIContactsPerIsland,0,this.m_stackAllocator,this.m_contactListener);
            var _loc9_:int = this.m_bodyCount;
            var _loc10_:Array = new Array(_loc9_);
            _loc2_ = this.m_bodyList;
            while(_loc2_)
            {
                _loc2_.m_flags &= ~b2Body.e_islandFlag;
                _loc2_.m_sweep.t0 = 0;
                _loc2_ = _loc2_.m_next;
            }
            _loc11_ = this.m_contactList;
            while(_loc11_)
            {
                _loc11_.m_flags &= ~(b2Contact.e_toiFlag | b2Contact.e_islandFlag);
                _loc11_ = _loc11_.m_next;
            }
            while(true)
            {
                _loc12_ = null;
                _loc13_ = 1;
                _loc11_ = this.m_contactList;
                for(; _loc11_; _loc11_ = _loc11_.m_next)
                {
                    if(!(_loc11_.m_flags & (b2Contact.e_slowFlag | b2Contact.e_nonSolidFlag)))
                    {
                        _loc18_ = 1;
                        if(_loc11_.m_flags & b2Contact.e_toiFlag)
                        {
                            _loc18_ = _loc11_.m_toi;
                        }
                        else
                        {
                            _loc3_ = _loc11_.m_shape1;
                            _loc4_ = _loc11_.m_shape2;
                            _loc5_ = _loc3_.m_body;
                            _loc6_ = _loc4_.m_body;
                            if((_loc5_.IsStatic() || _loc5_.IsSleeping()) && (_loc6_.IsStatic() || _loc6_.IsSleeping()))
                            {
                                continue;
                            }
                            _loc19_ = _loc5_.m_sweep.t0;
                            if(_loc5_.m_sweep.t0 < _loc6_.m_sweep.t0)
                            {
                                _loc19_ = _loc6_.m_sweep.t0;
                                _loc5_.m_sweep.Advance(_loc19_);
                            }
                            else if(_loc6_.m_sweep.t0 < _loc5_.m_sweep.t0)
                            {
                                _loc19_ = _loc5_.m_sweep.t0;
                                _loc6_.m_sweep.Advance(_loc19_);
                            }
                            _loc18_ = b2TimeOfImpact.TimeOfImpact(_loc11_.m_shape1,_loc5_.m_sweep,_loc11_.m_shape2,_loc6_.m_sweep);
                            if(_loc18_ > 0 && _loc18_ < 1)
                            {
                                _loc18_ = (1 - _loc18_) * _loc19_ + _loc18_;
                                if(_loc18_ > 1)
                                {
                                    _loc18_ = 1;
                                }
                            }
                            _loc11_.m_toi = _loc18_;
                            _loc11_.m_flags |= b2Contact.e_toiFlag;
                        }
                        if(Number.MIN_VALUE < _loc18_ && _loc18_ < _loc13_)
                        {
                            _loc12_ = _loc11_;
                            _loc13_ = _loc18_;
                        }
                    }
                }
                if(_loc12_ == null || 1 - 100 * Number.MIN_VALUE < _loc13_)
                {
                    break;
                }
                _loc3_ = _loc12_.m_shape1;
                _loc4_ = _loc12_.m_shape2;
                _loc5_ = _loc3_.m_body;
                _loc6_ = _loc4_.m_body;
                _loc5_.Advance(_loc13_);
                _loc6_.Advance(_loc13_);
                _loc12_.Update(this.m_contactListener);
                _loc12_.m_flags &= ~b2Contact.e_toiFlag;
                if(_loc12_.m_manifoldCount != 0)
                {
                    _loc14_ = _loc5_;
                    if(_loc14_.IsStatic())
                    {
                        _loc14_ = _loc6_;
                    }
                    _loc8_.Clear();
                    _loc15_ = 0;
                    var _loc22_:*;
                    _loc10_[_loc22_ = _loc15_++] = _loc14_;
                    _loc14_.m_flags |= b2Body.e_islandFlag;
                    while(_loc15_ > 0)
                    {
                        _loc2_ = _loc10_[--_loc15_];
                        _loc8_.AddBody(_loc2_);
                        _loc2_.m_flags &= ~b2Body.e_sleepFlag;
                        if(!_loc2_.IsStatic())
                        {
                            _loc7_ = _loc2_.m_contactList;
                            while(_loc7_)
                            {
                                if(_loc8_.m_contactCount != _loc8_.m_contactCapacity)
                                {
                                    if(!(_loc7_.contact.m_flags & (b2Contact.e_islandFlag | b2Contact.e_slowFlag | b2Contact.e_nonSolidFlag)))
                                    {
                                        if(_loc7_.contact.m_manifoldCount != 0)
                                        {
                                            _loc8_.AddContact(_loc7_.contact);
                                            _loc7_.contact.m_flags |= b2Contact.e_islandFlag;
                                            _loc20_ = _loc7_.other;
                                            if(!(_loc20_.m_flags & b2Body.e_islandFlag))
                                            {
                                                if(_loc20_.IsStatic() == false)
                                                {
                                                    _loc20_.Advance(_loc13_);
                                                    _loc20_.WakeUp();
                                                }
                                                var _loc23_:*;
                                                _loc10_[_loc23_ = _loc15_++] = _loc20_;
                                                _loc20_.m_flags |= b2Body.e_islandFlag;
                                            }
                                        }
                                    }
                                }
                                _loc7_ = _loc7_.next;
                            }
                        }
                    }
                    _loc16_ = new b2TimeStep();
                    _loc16_.dt = (1 - _loc13_) * param1.dt;
                    _loc16_.inv_dt = 1 / _loc16_.dt;
                    _loc16_.maxIterations = param1.maxIterations;
                    _loc8_.SolveTOI(_loc16_);
                    _loc17_ = 0;
                    while(_loc17_ < _loc8_.m_bodyCount)
                    {
                        _loc2_ = _loc8_.m_bodies[_loc17_];
                        _loc2_.m_flags &= ~b2Body.e_islandFlag;
                        if(!(_loc2_.m_flags & (b2Body.e_sleepFlag | b2Body.e_frozenFlag)))
                        {
                            if(!_loc2_.IsStatic())
                            {
                                _loc21_ = _loc2_.SynchronizeShapes();
                                if(_loc21_ == false && this.m_boundaryListener != null)
                                {
                                    this.m_boundaryListener.Violation(_loc2_);
                                }
                                _loc7_ = _loc2_.m_contactList;
                                while(_loc7_)
                                {
                                    _loc7_.contact.m_flags &= ~b2Contact.e_toiFlag;
                                    _loc7_ = _loc7_.next;
                                }
                            }
                        }
                        _loc17_++;
                    }
                    _loc17_ = 0;
                    while(_loc17_ < _loc8_.m_contactCount)
                    {
                        _loc11_ = _loc8_.m_contacts[_loc17_];
                        _loc11_.m_flags &= ~(b2Contact.e_toiFlag | b2Contact.e_islandFlag);
                        _loc17_++;
                    }
                    this.m_broadPhase.Commit();
                }
            }
        }
        
        public function DrawJoint(param1:b2Joint) : void
        {
            var _loc13_:b2PulleyJoint = null;
            var _loc14_:b2Vec2 = null;
            var _loc15_:b2Vec2 = null;
            var _loc2_:b2Body = param1.m_body1;
            var _loc3_:b2Body = param1.m_body2;
            var _loc4_:b2XForm = _loc2_.m_xf;
            var _loc5_:b2XForm = _loc3_.m_xf;
            var _loc6_:b2Vec2 = _loc4_.position;
            var _loc7_:b2Vec2 = _loc5_.position;
            var _loc8_:b2Vec2 = _loc2_.m_sweep.c;
            var _loc9_:b2Vec2 = _loc3_.m_sweep.c;
            var _loc10_:b2Vec2 = param1.GetAnchor1();
            var _loc11_:b2Vec2 = param1.GetAnchor2();
            var _loc12_:b2Color = s_jointColor;
            switch(param1.m_type)
            {
                case b2Joint.e_distanceJoint:
                    this.m_debugDraw.DrawSegment(_loc10_,_loc11_,_loc12_);
                    break;
                case b2Joint.e_pulleyJoint:
                    _loc13_ = param1 as b2PulleyJoint;
                    _loc14_ = _loc13_.GetGroundAnchor1();
                    _loc15_ = _loc13_.GetGroundAnchor2();
                    this.m_debugDraw.DrawSegment(_loc14_,_loc10_,_loc12_);
                    this.m_debugDraw.DrawSegment(_loc15_,_loc11_,_loc12_);
                    this.m_debugDraw.DrawSegment(_loc14_,_loc15_,_loc12_);
                    break;
                case b2Joint.e_mouseJoint:
                    this.m_debugDraw.DrawSegment(_loc10_,_loc11_,_loc12_);
                    break;
                default:
                    if(_loc2_ != this.m_groundBody)
                    {
                        this.m_debugDraw.DrawSegment(_loc8_,_loc10_,_loc12_);
                    }
                    this.m_debugDraw.DrawSegment(_loc10_,_loc11_,_loc12_);
                    if(_loc3_ != this.m_groundBody)
                    {
                        this.m_debugDraw.DrawSegment(_loc9_,_loc11_,_loc12_);
                    }
            }
        }
        
        public function DrawShape(param1:b2Shape, param2:b2XForm, param3:b2Color, param4:Boolean) : void
        {
            var _loc6_:b2CircleShape = null;
            var _loc7_:b2Vec2 = null;
            var _loc8_:Number = NaN;
            var _loc9_:b2Vec2 = null;
            var _loc10_:int = 0;
            var _loc11_:b2PolygonShape = null;
            var _loc12_:int = 0;
            var _loc13_:Array = null;
            var _loc14_:Array = null;
            var _loc15_:Array = null;
            var _loc5_:b2Color = s_coreColor;
            switch(param1.m_type)
            {
                case b2Shape.e_circleShape:
                    _loc6_ = param1 as b2CircleShape;
                    _loc7_ = b2Math.b2MulX(param2,_loc6_.m_localPosition);
                    _loc8_ = _loc6_.m_radius;
                    _loc9_ = param2.R.col1;
                    this.m_debugDraw.DrawSolidCircle(_loc7_,_loc8_,_loc9_,param3);
                    if(param4)
                    {
                        this.m_debugDraw.DrawCircle(_loc7_,_loc8_ - b2Settings.b2_toiSlop,_loc5_);
                    }
                    break;
                case b2Shape.e_polygonShape:
                    _loc11_ = param1 as b2PolygonShape;
                    _loc12_ = _loc11_.GetVertexCount();
                    _loc13_ = _loc11_.GetVertices();
                    _loc14_ = new Array(b2Settings.b2_maxPolygonVertices);
                    _loc10_ = 0;
                    while(_loc10_ < _loc12_)
                    {
                        _loc14_[_loc10_] = b2Math.b2MulX(param2,_loc13_[_loc10_]);
                        _loc10_++;
                    }
                    this.m_debugDraw.DrawSolidPolygon(_loc14_,_loc12_,param3);
                    if(param4)
                    {
                        _loc15_ = _loc11_.GetCoreVertices();
                        _loc10_ = 0;
                        while(_loc10_ < _loc12_)
                        {
                            _loc14_[_loc10_] = b2Math.b2MulX(param2,_loc15_[_loc10_]);
                            _loc10_++;
                        }
                        this.m_debugDraw.DrawPolygon(_loc14_,_loc12_,_loc5_);
                    }
            }
        }
        
        public function DrawDebugData() : void
        {
            var _loc2_:int = 0;
            var _loc3_:b2Body = null;
            var _loc4_:b2Shape = null;
            var _loc5_:b2Joint = null;
            var _loc6_:b2BroadPhase = null;
            var _loc11_:b2XForm = null;
            var _loc15_:* = false;
            var _loc16_:* = 0;
            var _loc17_:b2Pair = null;
            var _loc18_:b2Proxy = null;
            var _loc19_:b2Proxy = null;
            var _loc20_:b2Vec2 = null;
            var _loc21_:b2Vec2 = null;
            var _loc22_:b2Proxy = null;
            var _loc23_:b2PolygonShape = null;
            var _loc24_:b2OBB = null;
            var _loc25_:b2Vec2 = null;
            var _loc26_:b2Mat22 = null;
            var _loc27_:b2Vec2 = null;
            var _loc28_:Number = NaN;
            if(this.m_debugDraw == null)
            {
                return;
            }
            this.m_debugDraw.m_sprite.graphics.clear();
            var _loc1_:uint = this.m_debugDraw.GetFlags();
            var _loc7_:b2Vec2 = new b2Vec2();
            var _loc8_:b2Vec2 = new b2Vec2();
            var _loc9_:b2Vec2 = new b2Vec2();
            var _loc10_:b2Color = new b2Color(0,0,0);
            var _loc12_:b2AABB = new b2AABB();
            var _loc13_:b2AABB = new b2AABB();
            var _loc14_:Array = [new b2Vec2(),new b2Vec2(),new b2Vec2(),new b2Vec2()];
            if(_loc1_ & b2DebugDraw.e_shapeBit)
            {
                _loc15_ = (_loc1_ & b2DebugDraw.e_coreShapeBit) == b2DebugDraw.e_coreShapeBit;
                _loc3_ = this.m_bodyList;
                while(_loc3_)
                {
                    _loc11_ = _loc3_.m_xf;
                    _loc4_ = _loc3_.GetShapeList();
                    while(_loc4_)
                    {
                        if(_loc3_.IsStatic())
                        {
                            this.DrawShape(_loc4_,_loc11_,new b2Color(0.5,0.9,0.5),_loc15_);
                        }
                        else if(_loc3_.IsSleeping())
                        {
                            this.DrawShape(_loc4_,_loc11_,new b2Color(0.5,0.5,0.9),_loc15_);
                        }
                        else
                        {
                            this.DrawShape(_loc4_,_loc11_,new b2Color(0.9,0.9,0.9),_loc15_);
                        }
                        _loc4_ = _loc4_.m_next;
                    }
                    _loc3_ = _loc3_.m_next;
                }
            }
            if(_loc1_ & b2DebugDraw.e_jointBit)
            {
                _loc5_ = this.m_jointList;
                while(_loc5_)
                {
                    this.DrawJoint(_loc5_);
                    _loc5_ = _loc5_.m_next;
                }
            }
            if(_loc1_ & b2DebugDraw.e_pairBit)
            {
                _loc6_ = this.m_broadPhase;
                _loc7_.Set(1 / _loc6_.m_quantizationFactor.x,1 / _loc6_.m_quantizationFactor.y);
                _loc10_.Set(0.9,0.9,0.3);
                _loc2_ = 0;
                while(_loc2_ < b2Pair.b2_tableCapacity)
                {
                    _loc16_ = uint(_loc6_.m_pairManager.m_hashTable[_loc2_]);
                    while(_loc16_ != b2Pair.b2_nullPair)
                    {
                        _loc17_ = _loc6_.m_pairManager.m_pairs[_loc16_];
                        _loc18_ = _loc6_.m_proxyPool[_loc17_.proxyId1];
                        _loc19_ = _loc6_.m_proxyPool[_loc17_.proxyId2];
                        _loc12_.lowerBound.x = _loc6_.m_worldAABB.lowerBound.x + _loc7_.x * _loc6_.m_bounds[0][_loc18_.lowerBounds[0]].value;
                        _loc12_.lowerBound.y = _loc6_.m_worldAABB.lowerBound.y + _loc7_.y * _loc6_.m_bounds[1][_loc18_.lowerBounds[1]].value;
                        _loc12_.upperBound.x = _loc6_.m_worldAABB.lowerBound.x + _loc7_.x * _loc6_.m_bounds[0][_loc18_.upperBounds[0]].value;
                        _loc12_.upperBound.y = _loc6_.m_worldAABB.lowerBound.y + _loc7_.y * _loc6_.m_bounds[1][_loc18_.upperBounds[1]].value;
                        _loc13_.lowerBound.x = _loc6_.m_worldAABB.lowerBound.x + _loc7_.x * _loc6_.m_bounds[0][_loc19_.lowerBounds[0]].value;
                        _loc13_.lowerBound.y = _loc6_.m_worldAABB.lowerBound.y + _loc7_.y * _loc6_.m_bounds[1][_loc19_.lowerBounds[1]].value;
                        _loc13_.upperBound.x = _loc6_.m_worldAABB.lowerBound.x + _loc7_.x * _loc6_.m_bounds[0][_loc19_.upperBounds[0]].value;
                        _loc13_.upperBound.y = _loc6_.m_worldAABB.lowerBound.y + _loc7_.y * _loc6_.m_bounds[1][_loc19_.upperBounds[1]].value;
                        _loc8_.x = 0.5 * (_loc12_.lowerBound.x + _loc12_.upperBound.x);
                        _loc8_.y = 0.5 * (_loc12_.lowerBound.y + _loc12_.upperBound.y);
                        _loc9_.x = 0.5 * (_loc13_.lowerBound.x + _loc13_.upperBound.x);
                        _loc9_.y = 0.5 * (_loc13_.lowerBound.y + _loc13_.upperBound.y);
                        this.m_debugDraw.DrawSegment(_loc8_,_loc9_,_loc10_);
                        _loc16_ = _loc17_.next;
                    }
                    _loc2_++;
                }
            }
            if(_loc1_ & b2DebugDraw.e_aabbBit)
            {
                _loc6_ = this.m_broadPhase;
                _loc20_ = _loc6_.m_worldAABB.lowerBound;
                _loc21_ = _loc6_.m_worldAABB.upperBound;
                _loc7_.Set(1 / _loc6_.m_quantizationFactor.x,1 / _loc6_.m_quantizationFactor.y);
                _loc10_.Set(0.9,0.3,0.9);
                _loc2_ = 0;
                while(_loc2_ < b2Settings.b2_maxProxies)
                {
                    _loc22_ = _loc6_.m_proxyPool[_loc2_];
                    if(_loc22_.IsValid() != false)
                    {
                        _loc12_.lowerBound.x = _loc20_.x + _loc7_.x * _loc6_.m_bounds[0][_loc22_.lowerBounds[0]].value;
                        _loc12_.lowerBound.y = _loc20_.y + _loc7_.y * _loc6_.m_bounds[1][_loc22_.lowerBounds[1]].value;
                        _loc12_.upperBound.x = _loc20_.x + _loc7_.x * _loc6_.m_bounds[0][_loc22_.upperBounds[0]].value;
                        _loc12_.upperBound.y = _loc20_.y + _loc7_.y * _loc6_.m_bounds[1][_loc22_.upperBounds[1]].value;
                        _loc14_[0].Set(_loc12_.lowerBound.x,_loc12_.lowerBound.y);
                        _loc14_[1].Set(_loc12_.upperBound.x,_loc12_.lowerBound.y);
                        _loc14_[2].Set(_loc12_.upperBound.x,_loc12_.upperBound.y);
                        _loc14_[3].Set(_loc12_.lowerBound.x,_loc12_.upperBound.y);
                        this.m_debugDraw.DrawPolygon(_loc14_,4,_loc10_);
                    }
                    _loc2_++;
                }
                _loc14_[0].Set(_loc20_.x,_loc20_.y);
                _loc14_[1].Set(_loc21_.x,_loc20_.y);
                _loc14_[2].Set(_loc21_.x,_loc21_.y);
                _loc14_[3].Set(_loc20_.x,_loc21_.y);
                this.m_debugDraw.DrawPolygon(_loc14_,4,new b2Color(0.3,0.9,0.9));
            }
            if(_loc1_ & b2DebugDraw.e_obbBit)
            {
                _loc10_.Set(0.5,0.3,0.5);
                _loc3_ = this.m_bodyList;
                while(_loc3_)
                {
                    _loc11_ = _loc3_.m_xf;
                    _loc4_ = _loc3_.GetShapeList();
                    while(_loc4_)
                    {
                        if(_loc4_.m_type == b2Shape.e_polygonShape)
                        {
                            _loc23_ = _loc4_ as b2PolygonShape;
                            _loc24_ = _loc23_.GetOBB();
                            _loc25_ = _loc24_.extents;
                            _loc14_[0].Set(-_loc25_.x,-_loc25_.y);
                            _loc14_[1].Set(_loc25_.x,-_loc25_.y);
                            _loc14_[2].Set(_loc25_.x,_loc25_.y);
                            _loc14_[3].Set(-_loc25_.x,_loc25_.y);
                            _loc2_ = 0;
                            while(_loc2_ < 4)
                            {
                                _loc26_ = _loc24_.R;
                                _loc27_ = _loc14_[_loc2_];
                                _loc28_ = _loc24_.center.x + (_loc26_.col1.x * _loc27_.x + _loc26_.col2.x * _loc27_.y);
                                _loc14_[_loc2_].y = _loc24_.center.y + (_loc26_.col1.y * _loc27_.x + _loc26_.col2.y * _loc27_.y);
                                _loc14_[_loc2_].x = _loc28_;
                                _loc26_ = _loc11_.R;
                                _loc28_ = _loc11_.position.x + (_loc26_.col1.x * _loc27_.x + _loc26_.col2.x * _loc27_.y);
                                _loc14_[_loc2_].y = _loc11_.position.y + (_loc26_.col1.y * _loc27_.x + _loc26_.col2.y * _loc27_.y);
                                _loc14_[_loc2_].x = _loc28_;
                                _loc2_++;
                            }
                            this.m_debugDraw.DrawPolygon(_loc14_,4,_loc10_);
                        }
                        _loc4_ = _loc4_.m_next;
                    }
                    _loc3_ = _loc3_.m_next;
                }
            }
            if(_loc1_ & b2DebugDraw.e_centerOfMassBit)
            {
                _loc3_ = this.m_bodyList;
                while(_loc3_)
                {
                    _loc11_ = s_xf;
                    _loc11_.R = _loc3_.m_xf.R;
                    _loc11_.position = _loc3_.GetWorldCenter();
                    this.m_debugDraw.DrawXForm(_loc11_);
                    _loc3_ = _loc3_.m_next;
                }
            }
        }
    }
}

