package com.totaljerkface.game.particles
{
    import com.totaljerkface.game.Settings;
    import flash.display.DisplayObjectContainer;
    import flash.display.Sprite;
    import flash.geom.Point;
    
    public class BloodParticle
    {
        protected static const scaler:Number = 2.0833333333333335;
        
        protected static const gravityIncrement:Number = 0.6944444444444444;
        
        protected var minLineThickness:Number = 1.75;
        
        protected var currentPos:Point;
        
        protected var lastPos:Point;
        
        protected var _prev:BloodParticle;
        
        protected var _next:BloodParticle;
        
        protected var container:Sprite;
        
        public function BloodParticle(param1:*, param2:Number, param3:Number, param4:Number, param5:Number)
        {
            super();
            this.container = param1;
            param4 *= scaler;
            param5 *= scaler;
            this.currentPos = new Point(param2 + param4,param3 + param5);
            this.lastPos = new Point(param2,param3);
        }
        
        public function step(param1:Number, param2:Number, param3:Number, param4:Number) : Boolean
        {
            if(this.currentPos.x > param1 && this.currentPos.x < param2 && this.currentPos.y > param3 && this.currentPos.y < param4)
            {
                this.container.graphics.lineStyle(this.minLineThickness,10027008,1);
                this.container.graphics.moveTo(this.currentPos.x,this.currentPos.y);
                this.container.graphics.lineTo(this.lastPos.x,this.lastPos.y);
                ParticleController.drawnParticles = true;
            }
            var _loc5_:Number = this.currentPos.x - this.lastPos.x;
            var _loc6_:Number = this.currentPos.y - this.lastPos.y;
            this.lastPos.x = this.currentPos.x;
            this.lastPos.y = this.currentPos.y;
            this.currentPos.x += _loc5_;
            this.currentPos.y = this.currentPos.y + _loc6_ + gravityIncrement;
            if(this.lastPos.y > Settings.YParticleLimit)
            {
                return false;
            }
            return true;
        }
        
        public function get prev() : BloodParticle
        {
            return this._prev;
        }
        
        public function set prev(param1:BloodParticle) : void
        {
            this._prev = param1;
        }
        
        public function get next() : BloodParticle
        {
            return this._next;
        }
        
        public function set next(param1:BloodParticle) : void
        {
            this._next = param1;
        }
        
        public function removeFrom(param1:DisplayObjectContainer) : void
        {
            param1 = null;
        }
    }
}

