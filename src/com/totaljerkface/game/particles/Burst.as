package com.totaljerkface.game.particles
{
    import flash.display.*;
    
    public class Burst extends EmitterBitmap
    {
        protected var initialRange:int;
        
        protected var speedRange:int;
        
        protected var halfInitialRange:Number;
        
        protected var halfSpeedRange:Number;
        
        protected var threeQuarterSpeedRange:Number;
        
        public function Burst(param1:Array, param2:Number, param3:Number, param4:int, param5:int, param6:int = 100)
        {
            super(param1,param6);
            this.startX = param2;
            this.startY = param3;
            this.initialRange = param4;
            this.halfInitialRange = param4 / 2;
            this.speedRange = param5;
            this.halfSpeedRange = param5 / 2;
            this.threeQuarterSpeedRange = param5 * 3 / 4;
            this.createParticles();
        }
        
        private function createParticles() : void
        {
            var _loc1_:int = 0;
            while(_loc1_ < total)
            {
                if(ParticleController.totalParticles >= ParticleController.maxParticles)
                {
                    finished = true;
                    return;
                }
                this.createParticle();
                ParticleController.totalParticles += 1;
                _loc1_++;
            }
            finished = true;
        }
        
        override protected function createParticle() : void
        {
            var _loc4_:Particle = null;
            var _loc1_:Number = Math.random() * (Math.random() * this.speedRange - this.halfSpeedRange);
            var _loc2_:Number = Math.random() * (Math.random() * this.speedRange - this.threeQuarterSpeedRange);
            var _loc3_:int = Math.floor(Math.random() * bmdLength);
            _loc4_ = new Particle(_loc2_,_loc1_,bmdArray[_loc3_]);
            this.addChildAt(_loc4_,0);
            _loc4_.x = startX - _loc4_.width / 2 + Math.random() * this.initialRange - this.halfInitialRange;
            _loc4_.y = startY - _loc4_.height / 2 + Math.random() * this.initialRange - this.halfInitialRange;
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
            if(finished && _loc1_ == 0)
            {
                return false;
            }
            return true;
        }
    }
}

