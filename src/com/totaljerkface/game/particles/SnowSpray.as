package com.totaljerkface.game.particles
{
    import Box2D.Common.Math.b2Vec2;
    import Box2D.Dynamics.b2Body;
    import flash.display.*;
    
    public class SnowSpray extends Spray
    {
        public function SnowSpray(param1:Array, param2:b2Body, param3:b2Vec2, param4:b2Vec2, param5:Number, param6:Number, param7:Number, param8:int, param9:int = 1000)
        {
            super(param1,param2,param3,param4,param5,param6,param7,param8,param9);
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
            var _loc1_:Number = Math.random();
            var _loc2_:b2Vec2 = new b2Vec2(startX + rangeX * _loc1_,startY + rangeY * _loc1_);
            var _loc3_:Number = Math.random() * (maxSpeed - minSpeed) + minSpeed;
            var _loc4_:Number = targetBody.GetAngle() + rot + angleRange * Math.random();
            var _loc5_:b2Vec2 = targetBody.GetLinearVelocityFromLocalPoint(_loc2_);
            var _loc6_:Number = Math.cos(_loc4_) * _loc3_ + _loc5_.x;
            var _loc7_:Number = Math.sin(_loc4_) * _loc3_ + _loc5_.y;
            var _loc8_:int = Math.floor(Math.random() * bmdLength);
            var _loc9_:SnowFlake = new SnowFlake(_loc7_,_loc6_,bmdArray[_loc8_]);
            this.addChildAt(_loc9_,0);
            var _loc10_:b2Vec2 = targetBody.GetWorldPoint(_loc2_);
            _loc9_.x = _loc10_.x * m_physScale - _loc9_.width * 0.5;
            _loc9_.y = _loc10_.y * m_physScale - _loc9_.height * 0.5;
        }
    }
}

