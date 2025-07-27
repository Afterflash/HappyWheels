package Box2D.Dynamics.Contacts
{
    import Box2D.Collision.*;
    import Box2D.Collision.Shapes.*;
    import Box2D.Common.*;
    import Box2D.Common.Math.*;
    import Box2D.Dynamics.*;
    
    public class b2Contact
    {
        public static var s_registers:Array;
        
        public static var e_nonSolidFlag:uint = 1;
        
        public static var e_slowFlag:uint = 2;
        
        public static var e_islandFlag:uint = 4;
        
        public static var e_toiFlag:uint = 8;
        
        public static var s_initialized:Boolean = false;
        
        public var m_flags:uint;
        
        public var m_prev:b2Contact;
        
        public var m_next:b2Contact;
        
        public var m_node1:b2ContactEdge = new b2ContactEdge();
        
        public var m_node2:b2ContactEdge = new b2ContactEdge();
        
        public var m_shape1:b2Shape;
        
        public var m_shape2:b2Shape;
        
        public var m_manifoldCount:int;
        
        public var m_friction:Number;
        
        public var m_restitution:Number;
        
        public var m_toi:Number;
        
        public function b2Contact(param1:b2Shape = null, param2:b2Shape = null)
        {
            super();
            this.m_flags = 0;
            if(!param1 || !param2)
            {
                this.m_shape1 = null;
                this.m_shape2 = null;
                return;
            }
            if(param1.IsSensor() || param2.IsSensor())
            {
                this.m_flags |= e_nonSolidFlag;
            }
            this.m_shape1 = param1;
            this.m_shape2 = param2;
            this.m_manifoldCount = 0;
            this.m_friction = Math.sqrt(this.m_shape1.m_friction * this.m_shape2.m_friction);
            this.m_restitution = b2Math.b2Max(this.m_shape1.m_restitution,this.m_shape2.m_restitution);
            this.m_prev = null;
            this.m_next = null;
            this.m_node1.contact = null;
            this.m_node1.prev = null;
            this.m_node1.next = null;
            this.m_node1.other = null;
            this.m_node2.contact = null;
            this.m_node2.prev = null;
            this.m_node2.next = null;
            this.m_node2.other = null;
        }
        
        public static function AddType(param1:Function, param2:Function, param3:int, param4:int) : void
        {
            s_registers[param3][param4].createFcn = param1;
            s_registers[param3][param4].destroyFcn = param2;
            s_registers[param3][param4].primary = true;
            if(param3 != param4)
            {
                s_registers[param4][param3].createFcn = param1;
                s_registers[param4][param3].destroyFcn = param2;
                s_registers[param4][param3].primary = false;
            }
        }
        
        public static function InitializeRegisters() : void
        {
            var _loc2_:int = 0;
            s_registers = new Array(b2Shape.e_shapeTypeCount);
            var _loc1_:int = 0;
            while(_loc1_ < b2Shape.e_shapeTypeCount)
            {
                s_registers[_loc1_] = new Array(b2Shape.e_shapeTypeCount);
                _loc2_ = 0;
                while(_loc2_ < b2Shape.e_shapeTypeCount)
                {
                    s_registers[_loc1_][_loc2_] = new b2ContactRegister();
                    _loc2_++;
                }
                _loc1_++;
            }
            AddType(b2CircleContact.Create,b2CircleContact.Destroy,b2Shape.e_circleShape,b2Shape.e_circleShape);
            AddType(b2PolyAndCircleContact.Create,b2PolyAndCircleContact.Destroy,b2Shape.e_polygonShape,b2Shape.e_circleShape);
            AddType(b2PolygonContact.Create,b2PolygonContact.Destroy,b2Shape.e_polygonShape,b2Shape.e_polygonShape);
        }
        
        public static function Create(param1:b2Shape, param2:b2Shape, param3:*) : b2Contact
        {
            var _loc8_:b2Contact = null;
            var _loc9_:int = 0;
            var _loc10_:b2Manifold = null;
            if(s_initialized == false)
            {
                InitializeRegisters();
                s_initialized = true;
            }
            var _loc4_:int = param1.m_type;
            var _loc5_:int = param2.m_type;
            var _loc6_:b2ContactRegister = s_registers[_loc4_][_loc5_];
            var _loc7_:Function = _loc6_.createFcn;
            if(_loc7_ != null)
            {
                if(_loc6_.primary)
                {
                    return _loc7_(param1,param2,param3);
                }
                _loc8_ = _loc7_(param2,param1,param3);
                _loc9_ = 0;
                while(_loc9_ < _loc8_.m_manifoldCount)
                {
                    _loc10_ = _loc8_.GetManifolds()[_loc9_];
                    _loc10_.normal = _loc10_.normal.Negative();
                    _loc9_++;
                }
                return _loc8_;
            }
            return null;
        }
        
        public static function Destroy(param1:b2Contact, param2:*) : void
        {
            if(param1.m_manifoldCount > 0)
            {
                param1.m_shape1.m_body.WakeUp();
                param1.m_shape2.m_body.WakeUp();
            }
            var _loc3_:int = param1.m_shape1.m_type;
            var _loc4_:int = param1.m_shape2.m_type;
            var _loc5_:b2ContactRegister = s_registers[_loc3_][_loc4_];
            var _loc6_:Function = _loc5_.destroyFcn;
            _loc6_(param1,param2);
        }
        
        public function GetManifolds() : Array
        {
            return null;
        }
        
        public function GetManifoldCount() : int
        {
            return this.m_manifoldCount;
        }
        
        public function IsSolid() : Boolean
        {
            return (this.m_flags & e_nonSolidFlag) == 0;
        }
        
        public function GetNext() : b2Contact
        {
            return this.m_next;
        }
        
        public function GetShape1() : b2Shape
        {
            return this.m_shape1;
        }
        
        public function GetShape2() : b2Shape
        {
            return this.m_shape2;
        }
        
        public function Update(param1:b2ContactListener) : void
        {
            var _loc2_:int = this.m_manifoldCount;
            this.Evaluate(param1);
            var _loc3_:int = this.m_manifoldCount;
            var _loc4_:b2Body = this.m_shape1.m_body;
            var _loc5_:b2Body = this.m_shape2.m_body;
            if(_loc3_ == 0 && _loc2_ > 0)
            {
                _loc4_.WakeUp();
                _loc5_.WakeUp();
            }
            if(_loc4_.IsStatic() || _loc4_.IsBullet() || _loc5_.IsStatic() || _loc5_.IsBullet())
            {
                this.m_flags &= ~e_slowFlag;
            }
            else
            {
                this.m_flags |= e_slowFlag;
            }
        }
        
        public function Evaluate(param1:b2ContactListener) : void
        {
        }
    }
}

