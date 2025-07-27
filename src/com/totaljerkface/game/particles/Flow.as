package com.totaljerkface.game.particles
{
    import flash.display.*;
    
    public class Flow extends EmitterBitmap
    {
        protected var yMinSpeed:int;
        
        protected var yMaxSpeed:int;
        
        protected var rot:Number;
        
        public function Flow(param1:Array, param2:Number, param3:Number, param4:Number, param5:Number, param6:int, param7:int = 1000)
        {
            super(param1,param7);
            this.startX = param2;
            this.startY = param3;
            this.yMinSpeed = param4;
            this.yMaxSpeed = param5;
            this.rot = param6 * Math.PI / 180;
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
            var _loc1_:Number = Math.random() * (this.yMaxSpeed - this.yMinSpeed) + this.yMinSpeed;
            var _loc2_:Number = Math.cos(this.rot) * _loc1_;
            var _loc3_:Number = Math.sin(this.rot) * _loc1_;
            var _loc4_:int = Math.floor(Math.random() * bmdLength);
            var _loc5_:Particle = new Particle(_loc3_,_loc2_,bmdArray[_loc4_]);
            this.addChildAt(_loc5_,0);
            _loc5_.x = startX - _loc5_.width / 2;
            _loc5_.y = startY - _loc5_.height / 2;
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
                this.createParticle();
            }
            if(finished && _loc1_ == 0)
            {
                return false;
            }
            return true;
        }
    }
}

