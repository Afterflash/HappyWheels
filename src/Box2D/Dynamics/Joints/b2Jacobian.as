package Box2D.Dynamics.Joints
{
    import Box2D.Common.Math.b2Vec2;
    
    public class b2Jacobian
    {
        public var linear1:b2Vec2 = new b2Vec2();
        
        public var angular1:Number;
        
        public var linear2:b2Vec2 = new b2Vec2();
        
        public var angular2:Number;
        
        public function b2Jacobian()
        {
            super();
        }
        
        public function SetZero() : void
        {
            this.linear1.SetZero();
            this.angular1 = 0;
            this.linear2.SetZero();
            this.angular2 = 0;
        }
        
        public function Set(param1:b2Vec2, param2:Number, param3:b2Vec2, param4:Number) : void
        {
            this.linear1.SetV(param1);
            this.angular1 = param2;
            this.linear2.SetV(param3);
            this.angular2 = param4;
        }
        
        public function Compute(param1:b2Vec2, param2:Number, param3:b2Vec2, param4:Number) : Number
        {
            return this.linear1.x * param1.x + this.linear1.y * param1.y + this.angular1 * param2 + (this.linear2.x * param3.x + this.linear2.y * param3.y) + this.angular2 * param4;
        }
    }
}

