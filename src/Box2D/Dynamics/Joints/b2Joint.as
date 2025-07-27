package Box2D.Dynamics.Joints
{
    import Box2D.Common.Math.b2Vec2;
    import Box2D.Dynamics.b2Body;
    import Box2D.Dynamics.b2TimeStep;
    
    public class b2Joint
    {
        public static const e_unknownJoint:int = 0;
        
        public static const e_revoluteJoint:int = 1;
        
        public static const e_prismaticJoint:int = 2;
        
        public static const e_distanceJoint:int = 3;
        
        public static const e_pulleyJoint:int = 4;
        
        public static const e_mouseJoint:int = 5;
        
        public static const e_gearJoint:int = 6;
        
        public static const e_ropeJoint:int = 7;
        
        public static const e_inactiveLimit:int = 0;
        
        public static const e_atLowerLimit:int = 1;
        
        public static const e_atUpperLimit:int = 2;
        
        public static const e_equalLimits:int = 3;
        
        public var m_type:int;
        
        public var m_prev:b2Joint;
        
        public var m_next:b2Joint;
        
        public var m_node1:b2JointEdge = new b2JointEdge();
        
        public var m_node2:b2JointEdge = new b2JointEdge();
        
        public var m_body1:b2Body;
        
        public var m_body2:b2Body;
        
        public var m_inv_dt:Number;
        
        public var m_islandFlag:Boolean;
        
        public var m_collideConnected:Boolean;
        
        public var m_userData:*;
        
        public var broken:Boolean;
        
        public function b2Joint(param1:b2JointDef)
        {
            super();
            this.m_type = param1.type;
            this.m_prev = null;
            this.m_next = null;
            this.m_body1 = param1.body1;
            this.m_body2 = param1.body2;
            this.m_collideConnected = param1.collideConnected;
            this.m_islandFlag = false;
            this.m_userData = param1.userData;
        }
        
        public static function Create(param1:b2JointDef, param2:*) : b2Joint
        {
            var _loc3_:b2Joint = null;
            switch(param1.type)
            {
                case e_distanceJoint:
                    _loc3_ = new b2DistanceJoint(param1 as b2DistanceJointDef);
                    break;
                case e_mouseJoint:
                    _loc3_ = new b2MouseJoint(param1 as b2MouseJointDef);
                    break;
                case e_prismaticJoint:
                    _loc3_ = new b2PrismaticJoint(param1 as b2PrismaticJointDef);
                    break;
                case e_revoluteJoint:
                    _loc3_ = new b2RevoluteJoint(param1 as b2RevoluteJointDef);
                    break;
                case e_pulleyJoint:
                    _loc3_ = new b2PulleyJoint(param1 as b2PulleyJointDef);
                    break;
                case e_gearJoint:
                    _loc3_ = new b2GearJoint(param1 as b2GearJointDef);
                    break;
                case e_ropeJoint:
                    _loc3_ = new b2RopeJoint(param1 as b2RopeJointDef);
            }
            return _loc3_;
        }
        
        public static function Destroy(param1:b2Joint, param2:*) : void
        {
        }
        
        public function GetType() : int
        {
            return this.m_type;
        }
        
        public function GetAnchor1() : b2Vec2
        {
            return null;
        }
        
        public function GetAnchor2() : b2Vec2
        {
            return null;
        }
        
        public function GetReactionForce() : b2Vec2
        {
            return null;
        }
        
        public function GetReactionTorque() : Number
        {
            return 0;
        }
        
        public function GetBody1() : b2Body
        {
            return this.m_body1;
        }
        
        public function GetBody2() : b2Body
        {
            return this.m_body2;
        }
        
        public function GetNext() : b2Joint
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
        
        public function InitVelocityConstraints(param1:b2TimeStep) : void
        {
        }
        
        public function SolveVelocityConstraints(param1:b2TimeStep) : void
        {
        }
        
        public function InitPositionConstraints() : void
        {
        }
        
        public function SolvePositionConstraints() : Boolean
        {
            return false;
        }
    }
}

