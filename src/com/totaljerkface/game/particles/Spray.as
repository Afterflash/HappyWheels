package com.totaljerkface.game.particles
{
    import Box2D.Common.Math.b2Vec2;
    import Box2D.Dynamics.b2Body;
    import com.totaljerkface.game.Settings;
    import flash.display.*;
    
    public class Spray extends EmitterBitmap
    {
        protected var minSpeed:int;
        
        protected var maxSpeed:int;
        
        protected var rangeX:Number;
        
        protected var rangeY:Number;
        
        protected var perFrame:int;
        
        protected var defaultAngle:Number;
        
        protected var rot:Number;
        
        protected var angleRange:Number;
        
        protected var targetBody:b2Body;
        
        protected var m_physScale:Number;
        
        public function Spray(param1:Array, param2:b2Body, param3:b2Vec2, param4:b2Vec2, param5:Number, param6:Number, param7:Number, param8:int, param9:int = 1000)
        {
            super(param1,param9);
            this.targetBody = param2;
            this.minSpeed = param5;
            this.maxSpeed = param6;
            this.perFrame = param8;
            startX = param3.x;
            startY = param3.y;
            var _loc10_:b2Vec2 = new b2Vec2(param4.x - param3.x,param4.y - param3.y);
            this.rangeX = _loc10_.x;
            this.rangeY = _loc10_.y;
            this.angleRange = param7 * Math.PI / 180;
            var _loc11_:Number = Math.atan2(_loc10_.y,_loc10_.x);
            this.rot = _loc11_ + (Math.PI * 0.5 - this.angleRange * 0.5);
            this.m_physScale = Settings.currentSession.m_physScale;
        }
        
        override protected function createParticle() : void
        {
            var _loc9_:Particle = null;
            if(count > total)
            {
                finished = true;
                return;
            }
            ++count;
            ParticleController.totalParticles += 1;
            var _loc1_:Number = Math.random();
            var _loc2_:b2Vec2 = new b2Vec2(startX + this.rangeX * _loc1_,startY + this.rangeY * _loc1_);
            var _loc3_:Number = Math.random() * (this.maxSpeed - this.minSpeed) + this.minSpeed;
            var _loc4_:Number = this.targetBody.GetAngle() + this.rot + this.angleRange * Math.random();
            var _loc5_:b2Vec2 = this.targetBody.GetLinearVelocityFromLocalPoint(_loc2_);
            var _loc6_:Number = Math.cos(_loc4_) * _loc3_ + _loc5_.x;
            var _loc7_:Number = Math.sin(_loc4_) * _loc3_ + _loc5_.y;
            var _loc8_:int = Math.floor(Math.random() * bmdLength);
            _loc9_ = new Particle(_loc7_,_loc6_,bmdArray[_loc8_]);
            this.addChildAt(_loc9_,0);
            var _loc10_:b2Vec2 = this.targetBody.GetWorldPoint(_loc2_);
            _loc9_.x = _loc10_.x * this.m_physScale - _loc9_.width * 0.5;
            _loc9_.y = _loc10_.y * this.m_physScale - _loc9_.height * 0.5;
        }
        
        override public function step() : Boolean
        {
            var _loc3_:Particle = null;
            var _loc1_:int = numChildren;
            var _loc2_:int = 0;
            while(_loc2_ < _loc1_)
            {
                _loc3_ = getChildAt(_loc2_) as Particle;
                if(_loc3_.step() == false)
                {
                    _loc2_--;
                    _loc1_--;
                    --ParticleController.totalParticles;
                    removeChild(_loc3_);
                }
                _loc2_++;
            }
            if(ParticleController.totalParticles < ParticleController.maxParticles)
            {
                _loc2_ = 0;
                while(_loc2_ < this.perFrame)
                {
                    this.createParticle();
                    _loc2_++;
                }
            }
            if(finished && _loc1_ == 0)
            {
                return false;
            }
            return true;
        }
    }
}

