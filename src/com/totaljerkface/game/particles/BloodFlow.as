package com.totaljerkface.game.particles
{
    import Box2D.Common.Math.b2Vec2;
    import Box2D.Dynamics.b2Body;
    import com.totaljerkface.game.Settings;
    import flash.display.Sprite;
    import flash.geom.Rectangle;
    import flash.utils.getDefinitionByName;
    
    public class BloodFlow extends Emitter
    {
        private var angle:Number;
        
        private var minSpeed:Number;
        
        private var maxSpeed:Number;
        
        private var speedRange:Number;
        
        private var m_physScale:Number;
        
        private var offSet:b2Vec2;
        
        private var targetBody:b2Body;
        
        private var _container:Sprite;
        
        private var particleClass:Class;
        
        private var particleList:BloodParticle;
        
        private var particleList2:BloodParticleLine;
        
        public function BloodFlow(param1:Sprite, param2:b2Body, param3:b2Vec2, param4:int, param5:Number, param6:Number, param7:int = 1000)
        {
            super(param7);
            this.targetBody = param2;
            this.offSet = param3;
            this.angle = param4 * Math.PI / 180;
            this.minSpeed = param5;
            this.maxSpeed = param6;
            this.speedRange = param6 - param5;
            this.m_physScale = Settings.currentSession.m_physScale;
            if(param1)
            {
                this._container = param1;
            }
            else
            {
                this._container = this;
            }
            var _loc8_:String = Settings.bloodSetting == 2 ? "BloodParticleLine" : "BloodParticle";
            this.particleClass = getDefinitionByName("com.totaljerkface.game.particles." + _loc8_) as Class;
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
            var _loc1_:Number = Math.random() * this.speedRange + this.minSpeed;
            var _loc2_:Number = this.targetBody.GetAngle() + this.angle;
            var _loc3_:b2Vec2 = this.targetBody.GetLinearVelocityFromLocalPoint(this.offSet);
            var _loc4_:Number = Math.cos(_loc2_) * _loc1_ + _loc3_.x;
            var _loc5_:Number = Math.sin(_loc2_) * _loc1_ + _loc3_.y;
            var _loc6_:b2Vec2 = this.targetBody.GetWorldPoint(this.offSet);
            var _loc7_:BloodParticle = new this.particleClass(this._container,_loc6_.x * this.m_physScale,_loc6_.y * this.m_physScale,_loc4_,_loc5_);
            _loc7_.next = this.particleList;
            if(this.particleList)
            {
                this.particleList.prev = _loc7_;
            }
            this.particleList = _loc7_;
        }
        
        override public function step() : Boolean
        {
            var _loc1_:int = 0;
            if(this._container == this)
            {
                this._container.graphics.clear();
            }
            var _loc2_:Rectangle = Settings.currentSession.camera.screenBounds;
            var _loc3_:Number = _loc2_.x - 50;
            var _loc4_:Number = _loc2_.x + 950;
            var _loc5_:Number = _loc2_.y - 50;
            var _loc6_:Number = _loc2_.y + 550;
            var _loc7_:BloodParticle = this.particleList;
            while(_loc7_)
            {
                _loc1_ += 1;
                if(_loc7_.step(_loc3_,_loc4_,_loc5_,_loc6_) == false)
                {
                    if(_loc7_.prev)
                    {
                        _loc7_.prev.next = _loc7_.next;
                    }
                    if(_loc7_.next)
                    {
                        _loc7_.next.prev = _loc7_.prev;
                    }
                    if(_loc7_ == this.particleList)
                    {
                        this.particleList = _loc7_.next;
                    }
                    _loc7_.removeFrom(this._container);
                    --ParticleController.totalParticles;
                    _loc1_--;
                }
                _loc7_ = _loc7_.next;
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
        
        public function get container() : Sprite
        {
            return this._container;
        }
        
        override public function die() : void
        {
            if(this._container == this)
            {
                this._container.graphics.clear();
            }
        }
    }
}

