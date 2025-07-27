package com.totaljerkface.game.particles
{
    public class EmitterBitmap extends Emitter
    {
        protected var bmdArray:Array;
        
        protected var bmdLength:int;
        
        public function EmitterBitmap(param1:Array, param2:int = 1000)
        {
            this.bmdArray = param1;
            this.bmdLength = param1.length;
            super(param2);
        }
    }
}

