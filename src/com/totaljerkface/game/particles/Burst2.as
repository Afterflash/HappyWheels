package com.totaljerkface.game.particles
{
    import Box2D.Common.Math.b2Vec2;
    import Box2D.Dynamics.b2Body;
    import com.totaljerkface.game.*;
    import flash.display.*;
    
    public class Burst2 extends Burst
    {
        private var offSet:b2Vec2;
        
        private var targetBody:b2Body;
        
        private var m_physScale:Number = Settings.currentSession.m_physScale;
        
        private var startVel:b2Vec2;
        
        private var startPos:b2Vec2;
        
        public function Burst2(param1:Array, param2:int, param3:int, param4:b2Body, param5:b2Vec2, param6:int = 100)
        {
            this.targetBody = param4;
            this.offSet = param5;
            var _loc7_:b2Vec2 = param4.GetWorldCenter();
            this.startPos = new b2Vec2(_loc7_.x + param5.x,_loc7_.y + param5.y);
            _loc7_ = param4.GetLocalCenter().Copy();
            _loc7_.Add(param5);
            this.startVel = param4.GetLinearVelocityFromLocalPoint(_loc7_);
            super(param1,0,0,param2,param3,param6);
        }
        
        override protected function createParticle() : void
        {
            var _loc1_:Number = this.startVel.x + Math.random() * (Math.random() * speedRange - halfSpeedRange);
            var _loc2_:Number = this.startVel.y + Math.random() * (Math.random() * speedRange - threeQuarterSpeedRange);
            var _loc3_:int = Math.floor(Math.random() * bmdLength);
            var _loc4_:Particle = new Particle(_loc2_,_loc1_,bmdArray[_loc3_]);
            this.addChildAt(_loc4_,0);
            _loc4_.x = this.startPos.x * this.m_physScale - _loc4_.width * 0.5 + Math.random() * initialRange - halfInitialRange;
            _loc4_.y = this.startPos.y * this.m_physScale - _loc4_.height * 0.5 + Math.random() * initialRange - halfInitialRange;
        }
    }
}

