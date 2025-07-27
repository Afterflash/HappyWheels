package com.totaljerkface.game.particles
{
    import com.totaljerkface.game.Settings;
    
    public class BloodParticleLine extends BloodParticle
    {
        private var lineThickness:Number = 1.5;
        
        public function BloodParticleLine(param1:*, param2:Number, param3:Number, param4:Number, param5:Number)
        {
            super(param1,param2,param3,param4,param5);
            minLineThickness = 1;
        }
        
        override public function step(param1:Number, param2:Number, param3:Number, param4:Number) : Boolean
        {
            if(currentPos.x > param1 && currentPos.x < param2 && currentPos.y > param3 && currentPos.y < param4)
            {
                container.graphics.lineStyle(this.lineThickness,10027008,1);
                container.graphics.moveTo(currentPos.x,currentPos.y);
                container.graphics.lineTo(lastPos.x,lastPos.y);
            }
            var _loc5_:Number = currentPos.x - lastPos.x;
            var _loc6_:Number = currentPos.y - lastPos.y;
            var _loc7_:Number = _loc5_ * _loc5_ + _loc6_ * _loc6_;
            this.lineThickness = Math.max((1 - _loc7_ * 0.005) * 2 + minLineThickness,minLineThickness);
            lastPos.x = currentPos.x;
            lastPos.y = currentPos.y;
            currentPos.x += _loc5_;
            currentPos.y = currentPos.y + _loc6_ + gravityIncrement;
            if(lastPos.y > Settings.YParticleLimit)
            {
                return false;
            }
            return true;
        }
    }
}

