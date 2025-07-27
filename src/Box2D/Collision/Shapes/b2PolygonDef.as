package Box2D.Collision.Shapes
{
    import Box2D.Common.*;
    import Box2D.Common.Math.*;
    
    public class b2PolygonDef extends b2ShapeDef
    {
        private static var s_mat:b2Mat22 = new b2Mat22();
        
        public var vertices:Array = new Array(b2Settings.b2_maxPolygonVertices);
        
        public var vertexCount:int;
        
        public function b2PolygonDef()
        {
            super();
            type = b2Shape.e_polygonShape;
            this.vertexCount = 0;
            var _loc1_:int = 0;
            while(_loc1_ < b2Settings.b2_maxPolygonVertices)
            {
                this.vertices[_loc1_] = new b2Vec2();
                _loc1_++;
            }
        }
        
        public function SetAsBox(param1:Number, param2:Number) : void
        {
            this.vertexCount = 4;
            this.vertices[0].Set(-param1,-param2);
            this.vertices[1].Set(param1,-param2);
            this.vertices[2].Set(param1,param2);
            this.vertices[3].Set(-param1,param2);
        }
        
        public function SetAsOrientedBox(param1:Number, param2:Number, param3:b2Vec2 = null, param4:Number = 0) : void
        {
            var _loc5_:b2Vec2 = null;
            var _loc6_:b2Mat22 = null;
            var _loc7_:int = 0;
            this.vertexCount = 4;
            this.vertices[0].Set(-param1,-param2);
            this.vertices[1].Set(param1,-param2);
            this.vertices[2].Set(param1,param2);
            this.vertices[3].Set(-param1,param2);
            if(param3)
            {
                _loc5_ = param3;
                _loc6_ = s_mat;
                _loc6_.Set(param4);
                _loc7_ = 0;
                while(_loc7_ < this.vertexCount)
                {
                    param3 = this.vertices[_loc7_];
                    param1 = _loc5_.x + (_loc6_.col1.x * param3.x + _loc6_.col2.x * param3.y);
                    param3.y = _loc5_.y + (_loc6_.col1.y * param3.x + _loc6_.col2.y * param3.y);
                    param3.x = param1;
                    _loc7_++;
                }
            }
        }
    }
}

