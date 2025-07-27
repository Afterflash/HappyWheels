package Box2D.Dynamics
{
    import Box2D.Collision.Shapes.b2MassData;
    import Box2D.Common.Math.b2Vec2;
    
    public class b2BodyDef
    {
        public var massData:b2MassData = new b2MassData();
        
        public var userData:*;
        
        public var position:b2Vec2 = new b2Vec2();
        
        public var angle:Number;
        
        public var linearDamping:Number;
        
        public var angularDamping:Number;
        
        public var allowSleep:Boolean;
        
        public var isSleeping:Boolean;
        
        public var isHull:Boolean;
        
        public var fixedRotation:Boolean;
        
        public var isBullet:Boolean;
        
        public function b2BodyDef()
        {
            super();
            this.massData.center.SetZero();
            this.massData.mass = 0;
            this.massData.I = 0;
            this.userData = null;
            this.position.Set(0,0);
            this.angle = 0;
            this.linearDamping = 0;
            this.angularDamping = 0;
            this.allowSleep = true;
            this.isSleeping = false;
            this.fixedRotation = false;
            this.isBullet = false;
        }
    }
}

