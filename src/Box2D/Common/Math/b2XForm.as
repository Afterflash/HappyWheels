package Box2D.Common.Math
{
    public class b2XForm
    {
        public var position:b2Vec2 = new b2Vec2();
        
        public var R:b2Mat22 = new b2Mat22();
        
        public function b2XForm(param1:b2Vec2 = null, param2:b2Mat22 = null)
        {
            super();
            if(param1)
            {
                this.position.SetV(param1);
                this.R.SetM(param2);
            }
        }
        
        public function Initialize(param1:b2Vec2, param2:b2Mat22) : void
        {
            this.position.SetV(param1);
            this.R.SetM(param2);
        }
        
        public function SetIdentity() : void
        {
            this.position.SetZero();
            this.R.SetIdentity();
        }
        
        public function Set(param1:b2XForm) : void
        {
            this.position.SetV(param1.position);
            this.R.SetM(param1.R);
        }
        
        public function GetAngle() : Number
        {
            return Math.atan2(this.R.col1.y,this.R.col1.x);
        }
    }
}

