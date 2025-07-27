package Box2D.Common.Math
{
    public class b2Sweep
    {
        public var localCenter:b2Vec2 = new b2Vec2();
        
        public var c0:b2Vec2 = new b2Vec2();
        
        public var c:b2Vec2 = new b2Vec2();
        
        public var a0:Number;
        
        public var a:Number;
        
        public var t0:Number;
        
        public function b2Sweep()
        {
            super();
        }
        
        public function GetXForm(param1:b2XForm, param2:Number) : void
        {
            var _loc4_:Number = NaN;
            var _loc5_:Number = NaN;
            if(1 - this.t0 > Number.MIN_VALUE)
            {
                _loc4_ = (param2 - this.t0) / (1 - this.t0);
                param1.position.x = (1 - _loc4_) * this.c0.x + _loc4_ * this.c.x;
                param1.position.y = (1 - _loc4_) * this.c0.y + _loc4_ * this.c.y;
                _loc5_ = (1 - _loc4_) * this.a0 + _loc4_ * this.a;
                param1.R.Set(_loc5_);
            }
            else
            {
                param1.position.SetV(this.c);
                param1.R.Set(this.a);
            }
            var _loc3_:b2Mat22 = param1.R;
            param1.position.x -= _loc3_.col1.x * this.localCenter.x + _loc3_.col2.x * this.localCenter.y;
            param1.position.y -= _loc3_.col1.y * this.localCenter.x + _loc3_.col2.y * this.localCenter.y;
        }
        
        public function Advance(param1:Number) : void
        {
            var _loc2_:Number = NaN;
            if(this.t0 < param1 && 1 - this.t0 > Number.MIN_VALUE)
            {
                _loc2_ = (param1 - this.t0) / (1 - this.t0);
                this.c0.x = (1 - _loc2_) * this.c0.x + _loc2_ * this.c.x;
                this.c0.y = (1 - _loc2_) * this.c0.y + _loc2_ * this.c.y;
                this.a0 = (1 - _loc2_) * this.a0 + _loc2_ * this.a;
                this.t0 = param1;
            }
        }
    }
}

