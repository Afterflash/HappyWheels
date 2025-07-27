package Box2D.Dynamics.Joints
{
    public class b2GearJointDef extends b2JointDef
    {
        public var joint1:b2Joint;
        
        public var joint2:b2Joint;
        
        public var ratio:Number;
        
        public function b2GearJointDef()
        {
            super();
            type = b2Joint.e_gearJoint;
            this.joint1 = null;
            this.joint2 = null;
            this.ratio = 1;
        }
    }
}

