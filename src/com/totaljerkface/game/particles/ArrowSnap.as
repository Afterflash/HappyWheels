package com.totaljerkface.game.particles
{
    import Box2D.Common.Math.b2Vec2;
    import Box2D.Dynamics.b2Body;
    import com.totaljerkface.game.Settings;
    
    public class ArrowSnap extends Emitter
    {
        private static const oneEightyOverPI:Number = 180 / Math.PI;
        
        protected var speedRange:int;
        
        protected var halfSpeedRange:Number;
        
        protected var targetBody:b2Body;
        
        protected var m_physScale:Number;
        
        protected var startVel:b2Vec2;
        
        protected var startPos:b2Vec2;
        
        protected var tip:Boolean;
        
        protected var arrowFrame:int;
        
        public function ArrowSnap(param1:b2Body, param2:int, param3:int = 10)
        {
            super(2);
            this.targetBody = param1;
            this.speedRange = param3;
            this.halfSpeedRange = param3 / 2;
            this.m_physScale = Settings.currentSession.m_physScale;
            this.arrowFrame = param2;
            this.createParticles();
        }
        
        private function createParticles() : void
        {
            var _loc1_:int = 0;
            while(_loc1_ < 2)
            {
                this.tip = _loc1_ < 1 ? true : false;
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
            var _loc3_:ArrowPiece = null;
            var _loc4_:b2Vec2 = null;
            if(this.tip)
            {
                _loc4_ = new b2Vec2(13.25 / this.m_physScale,0);
                this.startVel = this.targetBody.GetLinearVelocityFromLocalPoint(_loc4_);
                this.startPos = this.targetBody.GetWorldPoint(_loc4_);
            }
            else
            {
                _loc4_ = new b2Vec2(-13.25 / this.m_physScale,0);
                this.startVel = this.targetBody.GetLinearVelocityFromLocalPoint(_loc4_);
                this.startPos = this.targetBody.GetWorldPoint(_loc4_);
            }
            var _loc1_:Number = this.startVel.x + Math.random() * (Math.random() * this.speedRange - this.halfSpeedRange);
            var _loc2_:Number = this.startVel.y + Math.random() * (Math.random() * this.speedRange - this.halfSpeedRange);
            _loc3_ = new ArrowPiece(_loc2_,_loc1_,this.tip,this.arrowFrame);
            _loc3_.rotation = this.targetBody.GetAngle() * oneEightyOverPI % 360;
            this.addChildAt(_loc3_,0);
            _loc3_.x = this.startPos.x * this.m_physScale;
            _loc3_.y = this.startPos.y * this.m_physScale;
        }
        
        override public function step() : Boolean
        {
            var _loc3_:ArrowPiece = null;
            var _loc1_:int = numChildren;
            var _loc2_:int = 0;
            while(_loc2_ < _loc1_)
            {
                _loc3_ = getChildAt(_loc2_) as ArrowPiece;
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

