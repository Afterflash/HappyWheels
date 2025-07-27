package Box2D.Collision
{
    import Box2D.Common.Math.b2Vec2;
    
    public class b2AABB
    {
        public var lowerBound:b2Vec2 = new b2Vec2();
        
        public var upperBound:b2Vec2 = new b2Vec2();
        
        public function b2AABB()
        {
            super();
        }
        
        public function IsValid() : Boolean
        {
            var _loc1_:Number = this.upperBound.x - this.lowerBound.x;
            var _loc2_:Number = this.upperBound.y - this.lowerBound.y;
            var _loc3_:Boolean = _loc1_ >= 0 && _loc2_ >= 0;
            return _loc3_ && this.lowerBound.IsValid() && this.upperBound.IsValid();
        }
    }
}

