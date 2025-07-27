package Box2D.Collision
{
    public class b2Bound
    {
        public var value:uint;
        
        public var proxyId:uint;
        
        public var stabbingCount:uint;
        
        public function b2Bound()
        {
            super();
        }
        
        public function IsLower() : Boolean
        {
            return (this.value & 1) == 0;
        }
        
        public function IsUpper() : Boolean
        {
            return (this.value & 1) == 1;
        }
        
        public function Swap(param1:b2Bound) : void
        {
            var _loc2_:uint = this.value;
            var _loc3_:uint = this.proxyId;
            var _loc4_:uint = this.stabbingCount;
            this.value = param1.value;
            this.proxyId = param1.proxyId;
            this.stabbingCount = param1.stabbingCount;
            param1.value = _loc2_;
            param1.proxyId = _loc3_;
            param1.stabbingCount = _loc4_;
        }
    }
}

