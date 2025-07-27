package com.totaljerkface.game.particles
{
    import com.totaljerkface.game.Settings;
    import flash.display.Sprite;
    import flash.geom.Rectangle;
    import flash.utils.getDefinitionByName;
    
    public class BloodBurst extends Emitter
    {
        protected var initialRange:int;
        
        protected var speedRange:int;
        
        protected var halfInitialRange:Number;
        
        protected var halfSpeedRange:Number;
        
        protected var threeQuarterSpeedRange:Number;
        
        protected var _container:Sprite;
        
        protected var particleClass:Class;
        
        protected var particleList:BloodParticle;
        
        public function BloodBurst(param1:Sprite, param2:Number, param3:Number, param4:int, param5:int, param6:int = 100)
        {
            super(param6);
            this.startX = param2;
            this.startY = param3;
            this.initialRange = param4;
            this.halfInitialRange = param4 / 2;
            this.speedRange = param5;
            this.halfSpeedRange = param5 / 2;
            this.threeQuarterSpeedRange = param5 * 3 / 4;
            if(param1)
            {
                this._container = param1;
            }
            else
            {
                this._container = this;
            }
            var _loc7_:String = Settings.bloodSetting == 2 ? "BloodParticleLine" : "BloodParticle";
            this.particleClass = getDefinitionByName("com.totaljerkface.game.particles." + _loc7_) as Class;
            this.createParticles();
        }
        
        protected function createParticles() : void
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
            var _loc1_:Number = Math.random() * (Math.random() * this.speedRange - this.halfSpeedRange);
            var _loc2_:Number = Math.random() * (Math.random() * this.speedRange - this.threeQuarterSpeedRange);
            var _loc3_:Number = this.startX + Math.random() * this.initialRange - this.halfInitialRange;
            var _loc4_:Number = this.startY + Math.random() * this.initialRange - this.halfInitialRange;
            var _loc5_:BloodParticle = new this.particleClass(this._container,_loc3_,_loc4_,_loc1_,_loc2_);
            _loc5_.next = this.particleList;
            if(this.particleList)
            {
                this.particleList.prev = _loc5_;
            }
            this.particleList = _loc5_;
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
                if(!_loc7_.step(_loc3_,_loc4_,_loc5_,_loc6_))
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

