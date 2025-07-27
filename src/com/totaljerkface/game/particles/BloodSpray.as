package com.totaljerkface.game.particles
{
    import Box2D.Common.Math.b2Vec2;
    import Box2D.Dynamics.b2Body;
    import com.totaljerkface.game.Settings;
    import flash.display.Sprite;
    import flash.geom.Rectangle;
    import flash.utils.getDefinitionByName;
    
    public class BloodSpray extends Emitter
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
        
        protected var _container:Sprite;
        
        protected var particleClass:Class;
        
        protected var particleList:BloodParticle;
        
        protected var particleList2:BloodParticleLine;
        
        public function BloodSpray(param1:Sprite, param2:b2Body, param3:b2Vec2, param4:b2Vec2, param5:Number, param6:Number, param7:Number, param8:int, param9:int = 1000)
        {
            super(param9);
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
            if(param1)
            {
                this._container = param1;
            }
            else
            {
                this._container = this;
            }
            var _loc12_:String = Settings.bloodSetting == 2 ? "BloodParticleLine" : "BloodParticle";
            this.particleClass = getDefinitionByName("com.totaljerkface.game.particles." + _loc12_) as Class;
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
            var _loc2_:b2Vec2 = new b2Vec2(startX + this.rangeX * _loc1_,startY + this.rangeY * _loc1_);
            var _loc3_:Number = Math.random() * (this.maxSpeed - this.minSpeed) + this.minSpeed;
            var _loc4_:Number = this.targetBody.GetAngle() + this.rot + this.angleRange * Math.random();
            var _loc5_:b2Vec2 = this.targetBody.GetLinearVelocityFromLocalPoint(_loc2_);
            var _loc6_:Number = Math.cos(_loc4_) * _loc3_ + _loc5_.x;
            var _loc7_:Number = Math.sin(_loc4_) * _loc3_ + _loc5_.y;
            var _loc8_:b2Vec2 = this.targetBody.GetWorldPoint(_loc2_);
            var _loc9_:BloodParticle = new this.particleClass(this._container,_loc8_.x * this.m_physScale,_loc8_.y * this.m_physScale,_loc6_,_loc7_);
            _loc9_.next = this.particleList;
            if(this.particleList)
            {
                this.particleList.prev = _loc9_;
            }
            this.particleList = _loc9_;
        }
        
        override public function step() : Boolean
        {
            var _loc8_:int = 0;
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
                _loc8_ = 0;
                while(_loc8_ < this.perFrame)
                {
                    this.createParticle();
                    _loc8_++;
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

