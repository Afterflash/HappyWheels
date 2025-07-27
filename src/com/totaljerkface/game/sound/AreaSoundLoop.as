package com.totaljerkface.game.sound
{
    import Box2D.Common.Math.b2Vec2;
    import Box2D.Dynamics.b2Body;
    import flash.events.EventDispatcher;
    import flash.geom.Point;
    import flash.media.Sound;
    import flash.media.SoundChannel;
    import flash.media.SoundTransform;
    import gs.TweenLite;
    
    public class AreaSoundLoop extends EventDispatcher
    {
        protected static const xCutoff:int = 16;
        
        protected static const yCutoff:int = 8;
        
        protected var _sourceObject:b2Body;
        
        protected var _sound:Sound;
        
        protected var _soundChannel:SoundChannel;
        
        protected var _maxVolume:Number = 1;
        
        protected var _startTime:Number = 0;
        
        protected var _remove:Boolean;
        
        public function AreaSoundLoop(param1:Sound, param2:b2Body, param3:Number, param4:Number)
        {
            super();
            this._sourceObject = param2;
            this._sound = param1;
            this._maxVolume = param3;
            this._startTime = param4;
        }
        
        public function areaCheck(param1:Point) : void
        {
            var _loc2_:SoundTransform = this.calculateSoundTransform(param1);
            if(!_loc2_)
            {
                this.stopSound(false);
                return;
            }
            if(!this._soundChannel)
            {
                this._soundChannel = this._sound.play(this._startTime,10000,_loc2_);
            }
            else
            {
                this._soundChannel.soundTransform = _loc2_;
            }
        }
        
        protected function calculateSoundTransform(param1:Point) : SoundTransform
        {
            var _loc2_:b2Vec2 = this._sourceObject.GetWorldCenter();
            var _loc3_:Number = _loc2_.x - param1.x;
            var _loc4_:Number = _loc2_.y - param1.y;
            var _loc5_:Number = Math.abs(_loc3_);
            var _loc6_:Number = Math.abs(_loc4_);
            if(_loc5_ > xCutoff || _loc6_ > yCutoff || this._maxVolume == 0)
            {
                return null;
            }
            var _loc7_:Number = (1 - _loc5_ / xCutoff) * this._maxVolume;
            var _loc8_:Number = (1 - _loc6_ / yCutoff) * this._maxVolume;
            var _loc9_:Number = Math.min(_loc7_,_loc8_);
            var _loc10_:Number = _loc3_ / xCutoff;
            return new SoundTransform(_loc9_,_loc10_);
        }
        
        public function stopSound(param1:Boolean = true) : void
        {
            if(this._soundChannel)
            {
                this._soundChannel.stop();
                this._soundChannel = null;
                if(param1)
                {
                    this._remove = true;
                }
            }
            else if(param1)
            {
                this._remove = true;
            }
        }
        
        public function fadeIn(param1:Number) : void
        {
            TweenLite.killTweensOf(this);
            this._remove = false;
            TweenLite.to(this,param1,{
                "maxVolume":1,
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
                "maxVolume":0,
                "onComplete":this.fadeOutComplete
            });
        }
        
        private function fadeOutComplete() : void
        {
            this._remove = true;
        }
        
        public function fadeTo(param1:Number, param2:Number) : void
        {
            TweenLite.killTweensOf(this);
            this._remove = false;
            TweenLite.to(this,param2,{"maxVolume":param1});
        }
        
        public function get soundChannel() : SoundChannel
        {
            return this._soundChannel;
        }
        
        public function get sound() : Sound
        {
            return this._sound;
        }
        
        public function get maxVolume() : Number
        {
            return this._maxVolume;
        }
        
        public function set maxVolume(param1:Number) : void
        {
            this._maxVolume = param1;
        }
        
        public function get remove() : Boolean
        {
            return this._remove;
        }
    }
}

