package com.totaljerkface.game.particles
{
    import Box2D.Common.Math.b2Vec2;
    import Box2D.Dynamics.b2Body;
    import com.totaljerkface.game.Settings;
    
    public class SparkBurstPoint extends Emitter
    {
        protected var initialRange:int;
        
        protected var speedRange:int;
        
        protected var halfInitialRange:Number;
        
        protected var halfSpeedRange:Number;
        
        protected var offSet:b2Vec2;
        
        protected var targetBody:b2Body;
        
        protected var m_physScale:Number;
        
        protected var startVel:b2Vec2;
        
        protected var startPos:b2Vec2;
        
        public function SparkBurstPoint(param1:b2Vec2, param2:b2Vec2, param3:int, param4:int, param5:int = 100)
        {
            super(param5);
            this.initialRange = param3;
            this.halfInitialRange = param3 / 2;
            this.speedRange = param4;
            this.halfSpeedRange = param4 / 2;
            this.m_physScale = Settings.currentSession.m_physScale;
            this.startVel = param2;
            this.startPos = param1;
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
            var _loc1_:Number = this.startVel.x + Math.random() * (Math.random() * this.speedRange - this.halfSpeedRange);
            var _loc2_:Number = this.startVel.y + Math.random() * (Math.random() * this.speedRange - this.halfSpeedRange);
            var _loc3_:Spark = new Spark(_loc2_,_loc1_);
            this.addChildAt(_loc3_,0);
            _loc3_.x = this.startPos.x * this.m_physScale + Math.random() * this.initialRange - this.halfInitialRange;
            _loc3_.y = this.startPos.y * this.m_physScale + Math.random() * this.initialRange - this.halfInitialRange;
        }
        
        override public function step() : Boolean
        {
            var _loc3_:Spark = null;
            var _loc1_:int = numChildren;
            var _loc2_:int = 0;
            while(_loc2_ < _loc1_)
            {
                _loc3_ = getChildAt(_loc2_) as Spark;
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

