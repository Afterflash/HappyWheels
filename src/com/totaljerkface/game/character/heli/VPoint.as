package com.totaljerkface.game.character.heli
{
    import Box2D.Common.Math.b2Vec2;
    
    public class VPoint
    {
        private static const gravityIncrement:Number = 0.3333333333333333;
        
        public var currPos:b2Vec2;
        
        public var prevPos:b2Vec2;
        
        public var mass:Number;
        
        public var invMass:Number;
        
        public function VPoint(param1:b2Vec2, param2:Boolean)
        {
            super();
            this.currPos = new b2Vec2(param1.x,param1.y);
            this.prevPos = new b2Vec2(param1.x,param1.y);
            this.mass = param2 ? 0 : 1;
            this.invMass = param2 ? 0 : 1 / this.mass;
        }
        
        public function step() : void
        {
            var _loc1_:b2Vec2 = null;
            if(this.mass > 0)
            {
                _loc1_ = new b2Vec2(this.currPos.x - this.prevPos.x,this.currPos.y - this.prevPos.y);
                this.prevPos.Set(this.currPos.x,this.currPos.y);
                this.currPos.x += _loc1_.x;
                this.currPos.y += _loc1_.y + gravityIncrement * 1 / 30;
            }
        }
        
        public function setPosition(param1:b2Vec2) : void
        {
            this.currPos.Set(param1.x,param1.y);
            this.prevPos.Set(param1.x,param1.y);
        }
        
        public function set fixed(param1:Boolean) : void
        {
            this.mass = param1 ? 0 : 1;
            this.invMass = param1 ? 0 : 1 / this.mass;
        }
    }
}

