package com.totaljerkface.game.particles
{
    import flash.display.Sprite;
    
    public class Emitter extends Sprite
    {
        protected var startX:Number;
        
        protected var startY:Number;
        
        protected var total:int;
        
        protected var count:int;
        
        protected var finished:Boolean;
        
        public function Emitter(param1:int = 1000)
        {
            super();
            this.total = param1;
            this.finished = false;
            this.count = 0;
        }
        
        protected function createParticle() : void
        {
        }
        
        public function step() : Boolean
        {
            return true;
        }
        
        public function stopSpewing() : void
        {
            this.total = this.count;
        }
        
        public function get isFinished() : Boolean
        {
            return this.finished;
        }
        
        public function die() : void
        {
        }
    }
}

