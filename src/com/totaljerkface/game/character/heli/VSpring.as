package com.totaljerkface.game.character.heli
{
    import Box2D.Common.Math.b2Math;
    import Box2D.Common.Math.b2Vec2;
    
    public class VSpring
    {
        public var p1:VPoint;
        
        public var p2:VPoint;
        
        public var length:Number;
        
        public function VSpring(param1:VPoint, param2:VPoint)
        {
            super();
            this.p1 = param1;
            this.p2 = param2;
            this.length = b2Math.b2Distance(param1.currPos,param2.currPos);
        }
        
        public function resolve() : void
        {
            var _loc1_:b2Vec2 = new b2Vec2(this.p2.currPos.x - this.p1.currPos.x,this.p2.currPos.y - this.p1.currPos.y);
            var _loc2_:Number = Math.sqrt(_loc1_.x * _loc1_.x + _loc1_.y * _loc1_.y);
            var _loc3_:Number = (_loc2_ - this.length) / _loc2_;
            var _loc4_:b2Vec2 = _loc1_.Copy();
            _loc4_.Multiply(_loc3_);
            var _loc5_:Number = this.p1.invMass + this.p2.invMass;
            var _loc6_:b2Vec2 = _loc4_.Copy();
            _loc6_.Multiply(this.p1.invMass / _loc5_);
            this.p1.currPos.Add(_loc6_);
            _loc6_ = _loc4_.Copy();
            _loc6_.Multiply(this.p2.invMass / _loc5_);
            this.p2.currPos.Subtract(_loc6_);
        }
    }
}

