package Box2D.Common.Math
{
    public class b2Vec2
    {
        public var x:Number;
        
        public var y:Number;
        
        public function b2Vec2(param1:Number = 0, param2:Number = 0)
        {
            super();
            this.x = param1;
            this.y = param2;
        }
        
        public static function Make(param1:Number, param2:Number) : b2Vec2
        {
            return new b2Vec2(param1,param2);
        }
        
        public function SetZero() : void
        {
            this.x = 0;
            this.y = 0;
        }
        
        public function Set(param1:Number = 0, param2:Number = 0) : void
        {
            this.x = param1;
            this.y = param2;
        }
        
        public function SetV(param1:b2Vec2) : void
        {
            this.x = param1.x;
            this.y = param1.y;
        }
        
        public function Negative() : b2Vec2
        {
            return new b2Vec2(-this.x,-this.y);
        }
        
        public function Copy() : b2Vec2
        {
            return new b2Vec2(this.x,this.y);
        }
        
        public function Add(param1:b2Vec2) : void
        {
            this.x += param1.x;
            this.y += param1.y;
        }
        
        public function Subtract(param1:b2Vec2) : void
        {
            this.x -= param1.x;
            this.y -= param1.y;
        }
        
        public function Multiply(param1:Number) : void
        {
            this.x *= param1;
            this.y *= param1;
        }
        
        public function MulM(param1:b2Mat22) : void
        {
            var _loc2_:Number = this.x;
            this.x = param1.col1.x * _loc2_ + param1.col2.x * this.y;
            this.y = param1.col1.y * _loc2_ + param1.col2.y * this.y;
        }
        
        public function MulTM(param1:b2Mat22) : void
        {
            var _loc2_:Number = b2Math.b2Dot(this,param1.col1);
            this.y = b2Math.b2Dot(this,param1.col2);
            this.x = _loc2_;
        }
        
        public function CrossVF(param1:Number) : void
        {
            var _loc2_:Number = this.x;
            this.x = param1 * this.y;
            this.y = -param1 * _loc2_;
        }
        
        public function CrossFV(param1:Number) : void
        {
            var _loc2_:Number = this.x;
            this.x = -param1 * this.y;
            this.y = param1 * _loc2_;
        }
        
        public function MinV(param1:b2Vec2) : void
        {
            this.x = this.x < param1.x ? this.x : param1.x;
            this.y = this.y < param1.y ? this.y : param1.y;
        }
        
        public function MaxV(param1:b2Vec2) : void
        {
            this.x = this.x > param1.x ? this.x : param1.x;
            this.y = this.y > param1.y ? this.y : param1.y;
        }
        
        public function Abs() : void
        {
            if(this.x < 0)
            {
                this.x = -this.x;
            }
            if(this.y < 0)
            {
                this.y = -this.y;
            }
        }
        
        public function Length() : Number
        {
            return Math.sqrt(this.x * this.x + this.y * this.y);
        }
        
        public function LengthSquared() : Number
        {
            return this.x * this.x + this.y * this.y;
        }
        
        public function Normalize() : Number
        {
            var _loc1_:Number = Math.sqrt(this.x * this.x + this.y * this.y);
            if(_loc1_ < Number.MIN_VALUE)
            {
                return 0;
            }
            var _loc2_:Number = 1 / _loc1_;
            this.x *= _loc2_;
            this.y *= _loc2_;
            return _loc1_;
        }
        
        public function IsValid() : Boolean
        {
            return b2Math.b2IsValid(this.x) && b2Math.b2IsValid(this.y);
        }
    }
}

