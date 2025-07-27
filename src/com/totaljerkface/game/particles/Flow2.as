package com.totaljerkface.game.particles
{
    import Box2D.Common.Math.b2Vec2;
    import Box2D.Dynamics.b2Body;
    import com.totaljerkface.game.*;
    import flash.display.*;
    
    public class Flow2 extends Flow
    {
        protected var offSet:b2Vec2;
        
        protected var targetBody:b2Body;
        
        protected var m_physScale:Number;
        
        public function Flow2(param1:Array, param2:Number, param3:Number, param4:b2Body, param5:b2Vec2, param6:int, param7:int = 1000)
        {
            super(param1,0,0,param2,param3,param6,param7);
            this.offSet = param5;
            this.targetBody = param4;
            this.m_physScale = Settings.currentSession.m_physScale;
        }
        
        override protected function createParticle() : void
        {
            if(count > total)
            {
                finished = true;
                return;
            }
            ++count;
            ParticleController.totalParticles += 1;
            var _loc1_:Number = Math.random() * (yMaxSpeed - yMinSpeed) + yMinSpeed;
            var _loc2_:Number = this.targetBody.GetAngle() + rot;
            var _loc3_:b2Vec2 = this.targetBody.GetLinearVelocityFromLocalPoint(this.offSet);
            var _loc4_:Number = Math.cos(_loc2_) * _loc1_ + _loc3_.x;
            var _loc5_:Number = Math.sin(_loc2_) * _loc1_ + _loc3_.y;
            var _loc6_:int = Math.floor(Math.random() * bmdLength);
            var _loc7_:Particle = new Particle(_loc5_,_loc4_,bmdArray[_loc6_]);
            this.addChildAt(_loc7_,0);
            var _loc8_:b2Vec2 = this.targetBody.GetWorldPoint(this.offSet);
            _loc7_.x = _loc8_.x * this.m_physScale - _loc7_.width * 0.5;
            _loc7_.y = _loc8_.y * this.m_physScale - _loc7_.height * 0.5;
        }
    }
}

