package com.totaljerkface.game.sound
{
    import flash.geom.Point;
    import flash.media.Sound;
    import flash.media.SoundTransform;
    
    public class AreaSoundLoopStatic extends AreaSoundLoop
    {
        protected var _coordinates:Point;
        
        public function AreaSoundLoopStatic(param1:Sound, param2:Point, param3:Number, param4:Number)
        {
            super(param1,null,param3,param4);
            this._coordinates = param2;
        }
        
        override protected function calculateSoundTransform(param1:Point) : SoundTransform
        {
            var _loc2_:Number = this._coordinates.x - param1.x;
            var _loc3_:Number = this._coordinates.y - param1.y;
            var _loc4_:Number = Math.abs(_loc2_);
            var _loc5_:Number = Math.abs(_loc3_);
            if(_loc4_ > xCutoff || _loc5_ > yCutoff || _maxVolume == 0)
            {
                return null;
            }
            var _loc6_:Number = (1 - _loc4_ / xCutoff) * _maxVolume;
            var _loc7_:Number = (1 - _loc5_ / yCutoff) * _maxVolume;
            var _loc8_:Number = Math.min(_loc6_,_loc7_);
            var _loc9_:Number = _loc2_ / xCutoff;
            return new SoundTransform(_loc8_,_loc9_);
        }
    }
}

