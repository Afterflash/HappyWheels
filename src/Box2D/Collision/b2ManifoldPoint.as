package Box2D.Collision
{
    import Box2D.Common.Math.b2Vec2;
    
    public class b2ManifoldPoint
    {
        public var localPoint1:b2Vec2 = new b2Vec2();
        
        public var localPoint2:b2Vec2 = new b2Vec2();
        
        public var separation:Number;
        
        public var normalImpulse:Number;
        
        public var tangentImpulse:Number;
        
        public var id:b2ContactID = new b2ContactID();
        
        public function b2ManifoldPoint()
        {
            super();
        }
        
        public function Reset() : void
        {
            this.localPoint1.SetZero();
            this.localPoint2.SetZero();
            this.separation = 0;
            this.normalImpulse = 0;
            this.tangentImpulse = 0;
            this.id.key = 0;
        }
        
        public function Set(param1:b2ManifoldPoint) : void
        {
            this.localPoint1.SetV(param1.localPoint1);
            this.localPoint2.SetV(param1.localPoint2);
            this.separation = param1.separation;
            this.normalImpulse = param1.normalImpulse;
            this.tangentImpulse = param1.tangentImpulse;
            this.id.key = param1.id.key;
        }
    }
}

