package Box2D.Collision
{
    import Box2D.Common.*;
    import Box2D.Common.Math.*;
    
    public class b2Manifold
    {
        public var points:Array;
        
        public var normal:b2Vec2;
        
        public var pointCount:int = 0;
        
        public function b2Manifold()
        {
            super();
            this.points = new Array(b2Settings.b2_maxManifoldPoints);
            var _loc1_:int = 0;
            while(_loc1_ < b2Settings.b2_maxManifoldPoints)
            {
                this.points[_loc1_] = new b2ManifoldPoint();
                _loc1_++;
            }
            this.normal = new b2Vec2();
        }
        
        public function Reset() : void
        {
            var _loc1_:int = 0;
            while(_loc1_ < b2Settings.b2_maxManifoldPoints)
            {
                (this.points[_loc1_] as b2ManifoldPoint).Reset();
                _loc1_++;
            }
            this.normal.SetZero();
            this.pointCount = 0;
        }
        
        public function Set(param1:b2Manifold) : void
        {
            this.pointCount = param1.pointCount;
            var _loc2_:int = 0;
            while(_loc2_ < b2Settings.b2_maxManifoldPoints)
            {
                (this.points[_loc2_] as b2ManifoldPoint).Set(param1.points[_loc2_]);
                _loc2_++;
            }
            this.normal.SetV(param1.normal);
        }
    }
}

