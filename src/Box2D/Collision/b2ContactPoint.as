package Box2D.Collision
{
    import Box2D.Collision.Shapes.b2Shape;
    import Box2D.Common.Math.b2Vec2;
    
    public class b2ContactPoint
    {
        public var shape1:b2Shape;
        
        public var shape2:b2Shape;
        
        public var position:b2Vec2 = new b2Vec2();
        
        public var velocity:b2Vec2 = new b2Vec2();
        
        public var normal:b2Vec2 = new b2Vec2();
        
        public var separation:Number;
        
        public var friction:Number;
        
        public var restitution:Number;
        
        public var id:b2ContactID = new b2ContactID();
        
        public var swap:Boolean = false;
        
        public function b2ContactPoint()
        {
            super();
        }
        
        public function toString() : void
        {
            trace("position " + this.position.x + ", " + this.position.y);
            var _loc1_:b2Vec2 = this.shape1.GetBody().GetLocalPoint(this.position);
            trace("local_p1 " + _loc1_.x + ", " + _loc1_.y);
            var _loc2_:b2Vec2 = this.shape2.GetBody().GetLocalPoint(this.position);
            trace("local_p2 " + _loc2_.x + ", " + _loc2_.y);
            trace("normal " + this.normal.x + ", " + this.normal.y);
            trace("separation " + this.separation);
            trace("id.key " + this.id.key.toString(16));
            trace("flip " + this.id.features.flip);
            trace("swap " + this.swap);
        }
    }
}

