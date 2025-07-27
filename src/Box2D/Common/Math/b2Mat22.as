package Box2D.Common.Math
{
    public class b2Mat22
    {
        public var col1:b2Vec2;
        
        public var col2:b2Vec2;
        
        public function b2Mat22(param1:Number = 0, param2:b2Vec2 = null, param3:b2Vec2 = null)
        {
            var _loc4_:Number = NaN;
            var _loc5_:Number = NaN;
            this.col1 = new b2Vec2();
            this.col2 = new b2Vec2();
            super();
            if(param2 != null && param3 != null)
            {
                this.col1.SetV(param2);
                this.col2.SetV(param3);
            }
            else
            {
                _loc4_ = Math.cos(param1);
                _loc5_ = Math.sin(param1);
                this.col1.x = _loc4_;
                this.col2.x = -_loc5_;
                this.col1.y = _loc5_;
                this.col2.y = _loc4_;
            }
        }
        
        public function Set(param1:Number) : void
        {
            var _loc2_:Number = NaN;
            _loc2_ = Math.cos(param1);
            var _loc3_:Number = Math.sin(param1);
            this.col1.x = _loc2_;
            this.col2.x = -_loc3_;
            this.col1.y = _loc3_;
            this.col2.y = _loc2_;
        }
        
        public function SetVV(param1:b2Vec2, param2:b2Vec2) : void
        {
            this.col1.SetV(param1);
            this.col2.SetV(param2);
        }
        
        public function Copy() : b2Mat22
        {
            return new b2Mat22(0,this.col1,this.col2);
        }
        
        public function SetM(param1:b2Mat22) : void
        {
            this.col1.SetV(param1.col1);
            this.col2.SetV(param1.col2);
        }
        
        public function AddM(param1:b2Mat22) : void
        {
            this.col1.x += param1.col1.x;
            this.col1.y += param1.col1.y;
            this.col2.x += param1.col2.x;
            this.col2.y += param1.col2.y;
        }
        
        public function SetIdentity() : void
        {
            this.col1.x = 1;
            this.col2.x = 0;
            this.col1.y = 0;
            this.col2.y = 1;
        }
        
        public function SetZero() : void
        {
            this.col1.x = 0;
            this.col2.x = 0;
            this.col1.y = 0;
            this.col2.y = 0;
        }
        
        public function GetAngle() : Number
        {
            return Math.atan2(this.col1.y,this.col1.x);
        }
        
        public function Invert(param1:b2Mat22) : b2Mat22
        {
            var _loc2_:Number = NaN;
            var _loc4_:Number = NaN;
            var _loc6_:Number = NaN;
            _loc2_ = this.col1.x;
            var _loc3_:Number = this.col2.x;
            _loc4_ = this.col1.y;
            var _loc5_:Number = this.col2.y;
            _loc6_ = _loc2_ * _loc5_ - _loc3_ * _loc4_;
            if(_loc6_ == 0)
            {
                return null;
            }
            _loc6_ = 1 / _loc6_;
            param1.col1.x = _loc6_ * _loc5_;
            param1.col2.x = -_loc6_ * _loc3_;
            param1.col1.y = -_loc6_ * _loc4_;
            param1.col2.y = _loc6_ * _loc2_;
            return param1;
        }
        
        public function GetDeterminant() : Number
        {
            var _loc1_:Number = this.col1.x;
            var _loc2_:Number = this.col2.x;
            var _loc3_:Number = this.col1.y;
            var _loc4_:Number = this.col2.y;
            return _loc1_ * _loc4_ - _loc2_ * _loc3_;
        }
        
        public function Solve(param1:b2Vec2, param2:Number, param3:Number) : b2Vec2
        {
            var _loc4_:Number = this.col1.x;
            var _loc5_:Number = this.col2.x;
            var _loc6_:Number = this.col1.y;
            var _loc7_:Number = this.col2.y;
            var _loc8_:Number = _loc4_ * _loc7_ - _loc5_ * _loc6_;
            _loc8_ = 1 / _loc8_;
            param1.x = _loc8_ * (_loc7_ * param2 - _loc5_ * param3);
            param1.y = _loc8_ * (_loc4_ * param3 - _loc6_ * param2);
            return param1;
        }
        
        public function Abs() : void
        {
            this.col1.Abs();
            this.col2.Abs();
        }
    }
}

