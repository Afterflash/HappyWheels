package com.totaljerkface.game.particles
{
    import Box2D.Collision.Shapes.b2PolygonShape;
    import Box2D.Common.Math.b2Vec2;
    import Box2D.Dynamics.b2Body;
    import com.totaljerkface.game.*;
    import flash.display.*;
    
    public class BurstRect extends Burst
    {
        private var offSet:b2Vec2;
        
        private var targetBody:b2Body;
        
        private var m_physScale:Number;
        
        private var startVel:b2Vec2;
        
        private var startPos:b2Vec2;
        
        private var leftX:Number;
        
        private var topY:Number;
        
        private var rangeX:Number;
        
        private var rangeY:Number;
        
        public function BurstRect(param1:Array, param2:int, param3:b2Body, param4:int = 100)
        {
            var _loc13_:Number = NaN;
            var _loc14_:Number = NaN;
            this.targetBody = param3;
            this.m_physScale = Settings.currentSession.m_physScale;
            var _loc5_:b2PolygonShape = param3.GetShapeList() as b2PolygonShape;
            var _loc6_:Array = _loc5_.GetVertices();
            var _loc7_:Number = 10000;
            var _loc8_:Number = 10000;
            var _loc9_:Number = -10000;
            var _loc10_:Number = -10000;
            var _loc11_:int = _loc5_.GetVertexCount();
            var _loc12_:int = 0;
            while(_loc12_ < _loc11_)
            {
                _loc13_ = Number(_loc6_[_loc12_].x);
                if(_loc13_ < _loc7_)
                {
                    _loc7_ = _loc13_;
                }
                if(_loc13_ > _loc9_)
                {
                    _loc9_ = _loc13_;
                }
                _loc14_ = Number(_loc6_[_loc12_].y);
                if(_loc14_ < _loc8_)
                {
                    _loc8_ = _loc14_;
                }
                if(_loc14_ > _loc10_)
                {
                    _loc10_ = _loc14_;
                }
                _loc12_++;
            }
            this.leftX = _loc7_;
            this.topY = _loc8_;
            this.rangeX = _loc9_ - _loc7_;
            this.rangeY = _loc10_ - _loc8_;
            super(param1,0,0,initialRange,param2,param4);
        }
        
        override protected function createParticle() : void
        {
            var _loc5_:b2Vec2 = null;
            this.offSet = new b2Vec2(this.leftX + Math.random() * this.rangeX,this.topY + Math.random() * this.rangeY);
            this.startVel = this.targetBody.GetLinearVelocityFromLocalPoint(this.offSet);
            var _loc1_:Number = this.startVel.x + (Math.random() * speedRange - halfSpeedRange);
            var _loc2_:Number = this.startVel.y + (Math.random() * speedRange - halfSpeedRange);
            var _loc3_:int = Math.floor(Math.random() * bmdLength);
            var _loc4_:Particle = new Particle(_loc2_,_loc1_,bmdArray[_loc3_]);
            this.addChildAt(_loc4_,0);
            _loc5_ = this.targetBody.GetWorldPoint(this.offSet);
            _loc4_.x = _loc5_.x * this.m_physScale - _loc4_.width * 0.5;
            _loc4_.y = _loc5_.y * this.m_physScale - _loc4_.height * 0.5;
        }
    }
}

