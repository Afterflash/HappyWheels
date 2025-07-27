package Box2D.Dynamics.Joints
{
    import Box2D.Dynamics.b2Body;
    
    public class b2JointDef
    {
        public var type:int;
        
        public var userData:*;
        
        public var body1:b2Body;
        
        public var body2:b2Body;
        
        public var collideConnected:Boolean;
        
        public function b2JointDef()
        {
            super();
            this.type = b2Joint.e_unknownJoint;
            this.userData = null;
            this.body1 = null;
            this.body2 = null;
            this.collideConnected = false;
        }
    }
}

