package Box2D.Dynamics.Contacts
{
    import Box2D.Collision.*;
    import Box2D.Common.*;
    import Box2D.Common.Math.*;
    import Box2D.Dynamics.*;
    
    public class b2ContactConstraint
    {
        public var points:Array;
        
        public var normal:b2Vec2 = new b2Vec2();
        
        public var manifold:b2Manifold;
        
        public var body1:b2Body;
        
        public var body2:b2Body;
        
        public var friction:Number;
        
        public var restitution:Number;
        
        public var pointCount:int;
        
        public function b2ContactConstraint()
        {
            super();
            this.points = new Array(b2Settings.b2_maxManifoldPoints);
            var _loc1_:int = 0;
            while(_loc1_ < b2Settings.b2_maxManifoldPoints)
            {
                this.points[_loc1_] = new b2ContactConstraintPoint();
                _loc1_++;
            }
        }
    }
}

