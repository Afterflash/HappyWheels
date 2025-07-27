package Box2D.Dynamics.Joints
{
    import Box2D.Common.Math.b2Vec2;
    import Box2D.Dynamics.b2Body;
    
    public class b2PrismaticJointDef extends b2JointDef
    {
        public var localAnchor1:b2Vec2 = new b2Vec2();
        
        public var localAnchor2:b2Vec2 = new b2Vec2();
        
        public var localAxis1:b2Vec2 = new b2Vec2();
        
        public var referenceAngle:Number;
        
        public var enableLimit:Boolean;
        
        public var lowerTranslation:Number;
        
        public var upperTranslation:Number;
        
        public var enableMotor:Boolean;
        
        public var maxMotorForce:Number;
        
        public var motorSpeed:Number;
        
        public function b2PrismaticJointDef()
        {
            super();
            type = b2Joint.e_prismaticJoint;
            this.localAxis1.Set(1,0);
            this.referenceAngle = 0;
            this.enableLimit = false;
            this.lowerTranslation = 0;
            this.upperTranslation = 0;
            this.enableMotor = false;
            this.maxMotorForce = 0;
            this.motorSpeed = 0;
        }
        
        public function Initialize(param1:b2Body, param2:b2Body, param3:b2Vec2, param4:b2Vec2) : void
        {
            body1 = param1;
            body2 = param2;
            this.localAnchor1 = body1.GetLocalPoint(param3);
            this.localAnchor2 = body2.GetLocalPoint(param3);
            this.localAxis1 = body1.GetLocalVector(param4);
            this.referenceAngle = body2.GetAngle() - body1.GetAngle();
        }
    }
}

