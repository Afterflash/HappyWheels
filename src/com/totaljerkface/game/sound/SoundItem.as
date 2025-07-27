package com.totaljerkface.game.sound
{
    import flash.events.EventDispatcher;
    import flash.media.Sound;
    import flash.media.SoundChannel;
    import flash.media.SoundTransform;
    import gs.TweenLite;
    
    public class SoundItem extends EventDispatcher
    {
        protected var _sound:Sound;
        
        protected var _soundChannel:SoundChannel;
        
        protected var _volume:Number = 1;
        
        public function SoundItem(param1:Sound, param2:Number = 0, param3:int = 0, param4:SoundTransform = null)
        {
            super();
            this._sound = param1;
            this._soundChannel = this._sound.play(param2,param3,param4);
        }
        
        public function stopSound() : void
        {
            this._soundChannel.stop();
        }
        
        public function fadeIn(param1:Number) : void
        {
            TweenLite.killTweensOf(this);
            TweenLite.to(this,param1,{
                "volume":1,
                "onComplete":this.fadeInComplete
            });
        }
        
        private function fadeInComplete() : void
        {
        }
        
        public function fadeOut(param1:Number) : void
        {
            TweenLite.killTweensOf(this);
            TweenLite.to(this,param1,{
                "volume":0,
                "onComplete":this.fadeOutComplete
            });
        }
        
        private function fadeOutComplete() : void
        {
        }
        
        public function get soundChannel() : SoundChannel
        {
            return this._soundChannel;
        }
        
        public function get sound() : Sound
        {
            return this._sound;
        }
        
        public function get volume() : Number
        {
            return this._volume;
        }
        
        public function set volume(param1:Number) : void
        {
            this._volume = param1;
            this._soundChannel.soundTransform = new SoundTransform(this._volume,0);
        }
    }
}

