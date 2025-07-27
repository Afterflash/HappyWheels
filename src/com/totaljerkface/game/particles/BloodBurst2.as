package com.totaljerkface.game.particles
{
    import Box2D.Common.Math.b2Vec2;
    import Box2D.Dynamics.b2Body;
    import com.totaljerkface.game.Settings;
    import flash.display.Sprite;
    
    public class BloodBurst2 extends BloodBurst
    {
        private var offSet:b2Vec2;
        
        private var targetBody:b2Body;
        
        private var m_physScale:Number = Settings.currentSession.m_physScale;
        
        private var startVel:b2Vec2;
        
        private var startPos:b2Vec2;
        
        public function BloodBurst2(param1:Sprite, param2:int, param3:int, param4:b2Body, param5:b2Vec2, param6:int = 100)
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
            var _loc3_:Number = this.startPos.x * this.m_physScale + Math.random() * initialRange - halfInitialRange;
            var _loc4_:Number = this.startPos.y * this.m_physScale + Math.random() * initialRange - halfInitialRange;
            var _loc5_:BloodParticle = new particleClass(_container,_loc3_,_loc4_,_loc1_,_loc2_);
            _loc5_.next = particleList;
            if(particleList)
            {
                particleList.prev = _loc5_;
            }
            particleList = _loc5_;
        }
    }
}

