package Box2D.Collision.Shapes
{
    import Box2D.Collision.b2AABB;
    import Box2D.Collision.b2BroadPhase;
    import Box2D.Collision.b2Pair;
    import Box2D.Collision.b2Segment;
    import Box2D.Common.Math.b2Vec2;
    import Box2D.Common.Math.b2XForm;
    import Box2D.Dynamics.b2Body;
    
    public class b2Shape
    {
        private static var s_proxyAABB:b2AABB = new b2AABB();
        
        private static var s_syncAABB:b2AABB = new b2AABB();
        
        private static var s_resetAABB:b2AABB = new b2AABB();
        
        public static const e_unknownShape:int = -1;
        
        public static const e_circleShape:int = 0;
        
        public static const e_polygonShape:int = 1;
        
        public static const e_shapeTypeCount:int = 2;
        
        public var m_type:int;
        
        public var m_next:b2Shape;
        
        public var m_body:b2Body;
        
        public var m_sweepRadius:Number;
        
        public var m_density:Number;
        
        public var m_friction:Number;
        
        public var m_restitution:Number;
        
        public var m_proxyId:uint;
        
        public var m_filter:b2FilterData;
        
        public var m_isSensor:Boolean;
        
        public var m_userData:*;
        
        public var m_material:uint;
        
        public function b2Shape(param1:b2ShapeDef)
        {
            super();
            this.m_userData = param1.userData;
            this.m_friction = param1.friction;
            this.m_restitution = param1.restitution;
            this.m_density = param1.density;
            this.m_body = null;
            this.m_sweepRadius = 0;
            this.m_next = null;
            this.m_proxyId = b2Pair.b2_nullProxy;
            this.m_filter = param1.filter.Copy();
            this.m_isSensor = param1.isSensor;
        }
        
        public static function Create(param1:b2ShapeDef, param2:*) : b2Shape
        {
            switch(param1.type)
            {
                case e_circleShape:
                    return new b2CircleShape(param1);
                case e_polygonShape:
                    return new b2PolygonShape(param1);
                default:
                    return null;
            }
        }
        
        public static function Destroy(param1:b2Shape, param2:*) : void
        {
        }
        
        public function GetType() : int
        {
            return this.m_type;
        }
        
        public function IsSensor() : Boolean
        {
            return this.m_isSensor;
        }
        
        public function SetFilterData(param1:b2FilterData) : void
        {
            this.m_filter = param1.Copy();
        }
        
        public function GetFilterData() : b2FilterData
        {
            return this.m_filter.Copy();
        }
        
        public function GetBody() : b2Body
        {
            return this.m_body;
        }
        
        public function GetNext() : b2Shape
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
        
        public function GetMaterial() : uint
        {
            return this.m_material;
        }
        
        public function SetMaterial(param1:uint) : void
        {
            this.m_material = param1;
        }
        
        public function TestPoint(param1:b2XForm, param2:b2Vec2) : Boolean
        {
            return false;
        }
        
        public function TestSegment(param1:b2XForm, param2:Array, param3:b2Vec2, param4:b2Segment, param5:Number) : Boolean
        {
            return false;
        }
        
        public function ComputeAABB(param1:b2AABB, param2:b2XForm) : void
        {
        }
        
        public function ComputeSweptAABB(param1:b2AABB, param2:b2XForm, param3:b2XForm) : void
        {
        }
        
        public function ComputeMass(param1:b2MassData) : void
        {
        }
        
        public function GetSweepRadius() : Number
        {
            return this.m_sweepRadius;
        }
        
        public function GetFriction() : Number
        {
            return this.m_friction;
        }
        
        public function GetRestitution() : Number
        {
            return this.m_restitution;
        }
        
        public function CreateProxy(param1:b2BroadPhase, param2:b2XForm) : void
        {
            var _loc3_:b2AABB = s_proxyAABB;
            this.ComputeAABB(_loc3_,param2);
            var _loc4_:Boolean = param1.InRange(_loc3_);
            if(_loc4_)
            {
                this.m_proxyId = param1.CreateProxy(_loc3_,this);
            }
            else
            {
                this.m_proxyId = b2Pair.b2_nullProxy;
            }
        }
        
        public function DestroyProxy(param1:b2BroadPhase) : void
        {
            if(this.m_proxyId != b2Pair.b2_nullProxy)
            {
                param1.DestroyProxy(this.m_proxyId);
                this.m_proxyId = b2Pair.b2_nullProxy;
            }
        }
        
        public function Synchronize(param1:b2BroadPhase, param2:b2XForm, param3:b2XForm) : Boolean
        {
            if(this.m_proxyId == b2Pair.b2_nullProxy)
            {
                return false;
            }
            var _loc4_:b2AABB = s_syncAABB;
            this.ComputeSweptAABB(_loc4_,param2,param3);
            if(param1.InRange(_loc4_))
            {
                param1.MoveProxy(this.m_proxyId,_loc4_);
                return true;
            }
            return false;
        }
        
        public function RefilterProxy(param1:b2BroadPhase, param2:b2XForm) : void
        {
            if(this.m_proxyId == b2Pair.b2_nullProxy)
            {
                return;
            }
            param1.DestroyProxy(this.m_proxyId);
            var _loc3_:b2AABB = s_resetAABB;
            this.ComputeAABB(_loc3_,param2);
            var _loc4_:Boolean = param1.InRange(_loc3_);
            if(_loc4_)
            {
                this.m_proxyId = param1.CreateProxy(_loc3_,this);
            }
            else
            {
                this.m_proxyId = b2Pair.b2_nullProxy;
            }
        }
        
        public function UpdateSweepRadius(param1:b2Vec2) : void
        {
        }
    }
}

