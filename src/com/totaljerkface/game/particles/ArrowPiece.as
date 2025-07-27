package com.totaljerkface.game.particles
{
    import com.totaljerkface.game.Settings;
    import flash.display.MovieClip;

    [Embed(source="/_assets/assets.swf", symbol="symbol2836")]
    public class ArrowPiece extends MovieClip
    {
        protected static const scaler:Number = 2.0833333333333335;

        protected static const gravityIncrement:Number = 0.6944444444444444;

        protected var speedY:Number;

        protected var speedX:Number;

        protected var rotSpeed:Number;

        protected var gravitySpeed:Number = 0;

        public function ArrowPiece(param1:Number, param2:Number, param3:Boolean, param4:int)
        {
            super();
            this.speedY = param1 * scaler;
            this.speedX = param2 * scaler;
            if (param3)
            {
                gotoAndStop(param4);
            }
            else
            {
                gotoAndStop(param4 + 6);
            }
            this.rotSpeed = 100 - Math.random() * 200;
        }

        public function step():Boolean
        {
            y += this.speedY;
            x += this.speedX;
            this.speedY += gravityIncrement;
            rotation += this.rotSpeed;
            if (y > Settings.YParticleLimit)
            {
                return false;
            }
            return true;
        }
    }
}
