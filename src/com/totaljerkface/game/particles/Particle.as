package com.totaljerkface.game.particles
{
    import com.totaljerkface.game.Settings;
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    
    public class Particle extends Bitmap
    {
        protected static const scaler:Number = 2.0833333333333335;
        
        protected static const gravityIncrement:Number = 0.6944444444444444;
        
        public var speedY:Number;
        
        public var speedX:Number;
        
        public var bitmap:Bitmap;
        
        public function Particle(param1:Number, param2:Number, param3:BitmapData)
        {
            super(param3);
            this.speedY = param1 * scaler;
            this.speedX = param2 * scaler;
        }
        
        public function step() : Boolean
        {
            y += this.speedY;
            x += this.speedX;
            this.speedY += gravityIncrement;
            if(y > Settings.YParticleLimit)
            {
                return false;
            }
            return true;
        }
    }
}

