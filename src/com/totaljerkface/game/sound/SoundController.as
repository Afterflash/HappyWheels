package com.totaljerkface.game.sound
{
    import Box2D.Common.Math.b2Vec2;
    import Box2D.Dynamics.b2Body;
    import com.totaljerkface.game.Settings;
    import flash.events.*;
    import flash.geom.Point;
    import flash.media.*;
    import flash.utils.*;
    
    public class SoundController extends EventDispatcher
    {
        private static var _instance:SoundController;
        
        public static const SOUND_PATH:String = "com.totaljerkface.game.sound.";
        
        private var _soundList:Object = new Object();
        
        private var _areaSounds:Vector.<AreaSoundLoop> = new Vector.<AreaSoundLoop>();
        
        private var _center:Point = new Point();
        
        private var _soundOff:Boolean;
        
        private var _muted:Boolean = false;
        
        private var _systemMuted:Boolean = false;
        
        public function SoundController(param1:SingletonEnforcer)
        {
            super();
            if(Settings.sharedObject.data["muted"] == true)
            {
                this.mute();
            }
        }
        
        public static function get instance() : SoundController
        {
            if(_instance == null)
            {
                _instance = new SoundController(new SingletonEnforcer());
            }
            return _instance;
        }
        
        public function playSoundItem(param1:String, param2:Number = 0, param3:int = 0, param4:SoundTransform = null) : SoundItem
        {
            var _loc5_:Class = getDefinitionByName(SOUND_PATH + param1) as Class;
            var _loc6_:Sound = new _loc5_();
            return new SoundItem(_loc6_,param2,param3,param4);
        }
        
        public function playSoundLoop(param1:String, param2:Number = 0, param3:int = 10000, param4:SoundTransform = null) : SoundChannel
        {
            var _loc5_:Class = getDefinitionByName(SOUND_PATH + param1) as Class;
            var _loc6_:Sound = new _loc5_();
            return _loc6_.play(param2,param3,param4);
        }
        
        public function playSoundInstance(param1:String, param2:Number = 0, param3:int = 0, param4:SoundTransform = null) : SoundChannel
        {
            var _loc5_:Class = getDefinitionByName(SOUND_PATH + param1) as Class;
            var _loc6_:Sound = new _loc5_();
            return _loc6_.play(param2,param3,param4);
        }
        
        public function playPointSoundInstance(param1:String, param2:b2Vec2, param3:Number = 1, param4:Number = 0) : PointSoundInstance
        {
            var _loc5_:Class = getDefinitionByName(SOUND_PATH + param1) as Class;
            var _loc6_:Sound = new _loc5_();
            var _loc7_:PointSoundInstance = new PointSoundInstance(_loc6_,param2,param3,param4,this._center);
            if(_loc7_.soundChannel)
            {
                this._areaSounds.push(_loc7_);
                return _loc7_;
            }
            return null;
        }
        
        public function playAreaSoundInstance(param1:String, param2:b2Body, param3:Number = 1, param4:Number = 0) : AreaSoundInstance
        {
            var _loc5_:Class = getDefinitionByName(SOUND_PATH + param1) as Class;
            var _loc6_:Sound = new _loc5_();
            var _loc7_:AreaSoundInstance = new AreaSoundInstance(_loc6_,param2,param3,param4,this._center);
            if(_loc7_.soundChannel)
            {
                this._areaSounds.push(_loc7_);
                return _loc7_;
            }
            return null;
        }
        
        public function playAreaSoundLoop(param1:String, param2:b2Body, param3:Number = 1, param4:Number = 0) : AreaSoundLoop
        {
            var _loc5_:Class = getDefinitionByName(SOUND_PATH + param1) as Class;
            var _loc6_:Sound = new _loc5_();
            var _loc7_:AreaSoundLoop = new AreaSoundLoop(_loc6_,param2,param3,param4);
            this._areaSounds.push(_loc7_);
            return _loc7_;
        }
        
        public function playAreaSoundLoopStatic(param1:String, param2:Point, param3:Number = 1, param4:Number = 0) : AreaSoundLoopStatic
        {
            var _loc5_:Class = getDefinitionByName(SOUND_PATH + param1) as Class;
            var _loc6_:Sound = new _loc5_();
            var _loc7_:AreaSoundLoopStatic = new AreaSoundLoopStatic(_loc6_,param2,param3,param4);
            this._areaSounds.push(_loc7_);
            return _loc7_;
        }
        
        public function step() : void
        {
            var _loc2_:AreaSoundLoop = null;
            this._center = Settings.currentSession.camera.midScreenPoint;
            var _loc1_:int = 0;
            while(_loc1_ < this._areaSounds.length)
            {
                _loc2_ = this._areaSounds[_loc1_];
                if(_loc2_.remove)
                {
                    _loc2_.stopSound();
                    this._areaSounds.splice(_loc1_,1);
                    _loc1_--;
                }
                else
                {
                    _loc2_.areaCheck(this._center);
                }
                _loc1_++;
            }
        }
        
        public function getSound(param1:String) : SoundChannel
        {
            return this._soundList[param1];
        }
        
        public function systemMute() : void
        {
            trace("system mute");
            this._systemMuted = true;
            var _loc1_:SoundTransform = new SoundTransform(0,0);
            SoundMixer.soundTransform = _loc1_;
        }
        
        public function systemUnMute() : void
        {
            var _loc1_:SoundTransform = null;
            trace("system unmute");
            this._systemMuted = false;
            if(!this._muted)
            {
                _loc1_ = new SoundTransform(1,0);
                SoundMixer.soundTransform = _loc1_;
            }
        }
        
        public function mute() : void
        {
            trace("USER mute");
            this._muted = Settings.sharedObject.data["muted"] = true;
            var _loc1_:SoundTransform = new SoundTransform(0,0);
            SoundMixer.soundTransform = _loc1_;
        }
        
        public function unMute() : void
        {
            var _loc1_:SoundTransform = null;
            trace("USER unmute");
            this._muted = Settings.sharedObject.data["muted"] = false;
            if(!this._systemMuted)
            {
                _loc1_ = new SoundTransform(1,0);
                SoundMixer.soundTransform = _loc1_;
            }
        }
        
        public function get isMuted() : Boolean
        {
            return this._muted;
        }
        
        public function stopAllSounds() : void
        {
            var _loc2_:AreaSoundLoop = null;
            var _loc1_:int = 0;
            while(_loc1_ < this._areaSounds.length)
            {
                _loc2_ = this._areaSounds[_loc1_];
                _loc2_.stopSound();
                _loc1_++;
            }
            this._areaSounds = new Vector.<AreaSoundLoop>();
            SoundMixer.stopAll();
        }
    }
}

class SingletonEnforcer
{
    public function SingletonEnforcer()
    {
        super();
    }
}
