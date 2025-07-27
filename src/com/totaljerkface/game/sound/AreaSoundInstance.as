package com.totaljerkface.game.sound
{
    import Box2D.Dynamics.b2Body;
    import flash.events.Event;
    import flash.geom.Point;
    import flash.media.Sound;
    import flash.media.SoundTransform;
    
    public class AreaSoundInstance extends AreaSoundLoop
    {
        public static const AREA_SOUND_STOP:String = "areasoundstop";
        
        public function AreaSoundInstance(param1:Sound, param2:b2Body, param3:Number, param4:Number, param5:Point)
        {
            super(param1,param2,param3,param4);
            var _loc6_:SoundTransform = calculateSoundTransform(param5);
            if(_loc6_)
            {
                _soundChannel = _sound.play(_startTime,0,_loc6_);
                if(_soundChannel)
                {
                    _soundChannel.addEventListener(Event.SOUND_COMPLETE,this.soundComplete);
                }
            }
            else
            {
                dispatchEvent(new Event(AREA_SOUND_STOP));
            }
        }
        
        override public function areaCheck(param1:Point) : void
        {
            var _loc2_:SoundTransform = calculateSoundTransform(param1);
            if(!_loc2_)
            {
                this.stopSound();
                return;
            }
            _soundChannel.soundTransform = _loc2_;
        }
        
        private function soundComplete(param1:Event) : void
        {
            _soundChannel.removeEventListener(Event.SOUND_COMPLETE,this.soundComplete);
            _soundChannel = null;
            _remove = true;
            dispatchEvent(new Event(AREA_SOUND_STOP));
        }
        
        override public function stopSound(param1:Boolean = true) : void
        {
            if(_soundChannel)
            {
                _soundChannel.removeEventListener(Event.SOUND_COMPLETE,this.soundComplete);
                _soundChannel.stop();
                _soundChannel = null;
                if(param1)
                {
                    _remove = true;
                }
                dispatchEvent(new Event(AREA_SOUND_STOP));
            }
        }
    }
}

