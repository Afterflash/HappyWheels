package com.totaljerkface.game.level.userspecials
{
    import Box2D.Collision.Shapes.*;
    import Box2D.Collision.b2ContactPoint;
    import Box2D.Common.Math.b2Vec2;
    import Box2D.Dynamics.*;
    import Box2D.Dynamics.Joints.*;
    import com.totaljerkface.game.*;
    import com.totaljerkface.game.editor.specials.*;
    import com.totaljerkface.game.events.*;
    import com.totaljerkface.game.level.*;
    import com.totaljerkface.game.sound.*;
    import flash.display.*;
    
    public class Boost extends LevelItem
    {
        private var mc:Sprite;
        
        private var sensor:b2Shape;
        
        private var bodies:Array;
        
        private var angle:Number;
        
        private var sinVal:Number;
        
        private var cosVal:Number;
        
        private var power:Number = 20;
        
        private var sound:AreaSoundLoop;
        
        private var soundBody:b2Body;
        
        private var numPanels:int;
        
        public function Boost(param1:Special)
        {
            super();
            var _loc2_:BoostRef = param1 as BoostRef;
            this.power = _loc2_.boostPower;
            this.angle = (_loc2_.rotation + 90) * Math.PI / 180;
            this.sinVal = Math.sin(this.angle);
            this.cosVal = Math.cos(this.angle);
            this.createBodies(new b2Vec2(_loc2_.x,_loc2_.y),_loc2_.rotation * Math.PI / 180,_loc2_.numPanels);
            this.mc = new Sprite();
            this.mc.x = _loc2_.x;
            this.mc.y = _loc2_.y;
            this.mc.rotation = _loc2_.rotation;
            this.numPanels = _loc2_.numPanels;
            this.setupMC();
            var _loc3_:Sprite = Settings.currentSession.level.foreground;
            _loc3_.addChild(this.mc);
            this.bodies = new Array();
            Settings.currentSession.level.actionsVector.push(this);
            Settings.currentSession.contactListener.registerListener(ContactListener.PERSIST,this.sensor,this.checkPersist);
        }
        
        private function setupMC() : void
        {
            var _loc2_:int = 0;
            var _loc4_:MovieClip = null;
            var _loc1_:Number = this.numPanels * -90;
            _loc2_ = 1;
            var _loc3_:int = 0;
            while(_loc3_ < this.numPanels)
            {
                _loc4_ = new BoostPanelMC();
                this.mc.addChild(_loc4_);
                _loc4_.x = _loc1_;
                _loc1_ += 180;
                _loc4_.gotoAndPlay(_loc2_);
                _loc2_ -= 4;
                if(_loc2_ <= 0)
                {
                    _loc2_ = 18 + _loc2_;
                }
                _loc3_++;
            }
        }
        
        internal function createBodies(param1:b2Vec2, param2:Number, param3:int) : void
        {
            var _loc4_:b2PolygonDef = new b2PolygonDef();
            _loc4_.filter.categoryBits = 8;
            if(Settings.currentSession.version > 1.42)
            {
                _loc4_.filter.groupIndex = -20;
            }
            _loc4_.isSensor = true;
            _loc4_.SetAsOrientedBox(90 * param3 / m_physScale,90 / m_physScale,new b2Vec2(param1.x / m_physScale,param1.y / m_physScale),param2);
            this.sensor = Settings.currentSession.level.levelBody.CreateShape(_loc4_);
        }
        
        override public function actions() : void
        {
            var _loc3_:b2Body = null;
            var _loc4_:b2Vec2 = null;
            var _loc5_:Number = NaN;
            if(this.bodies.length == 0)
            {
                if(this.sound)
                {
                    this.sound.fadeOut(0.2);
                    this.sound = null;
                }
                return;
            }
            var _loc1_:Boolean = this.bodies.indexOf(this.soundBody) > -1 ? true : false;
            var _loc2_:int = 0;
            while(_loc2_ < this.bodies.length)
            {
                _loc3_ = this.bodies[_loc2_];
                _loc4_ = _loc3_.GetWorldCenter();
                _loc5_ = this.power * _loc3_.GetMass();
                _loc3_.ApplyForce(new b2Vec2(this.sinVal * _loc5_,this.cosVal * -_loc5_),_loc4_);
                _loc2_++;
            }
            if(!_loc1_)
            {
                if(this.sound)
                {
                    this.sound.fadeOut(0.2);
                    this.sound = null;
                    this.soundBody = null;
                }
                this.soundBody = this.bodies[0];
                this.sound = SoundController.instance.playAreaSoundLoop("BoostLoop",this.soundBody,0);
                this.sound.fadeIn(0.2);
            }
            this.bodies = new Array();
        }
        
        private function checkPersist(param1:b2ContactPoint) : void
        {
            var _loc2_:b2Body = param1.shape2.GetBody();
            if(this.bodies.indexOf(_loc2_) > -1)
            {
                return;
            }
            this.bodies.push(_loc2_);
        }
        
        override public function triggerSingleActivation(param1:Trigger, param2:String, param3:Array) : void
        {
            var _loc4_:DisplayObject = null;
            if(_triggered)
            {
                return;
            }
            _triggered = true;
            Settings.currentSession.level.actionsVector.push(this);
            Settings.currentSession.contactListener.registerListener(ContactListener.PERSIST,this.sensor,this.checkPersist);
            while(this.mc.numChildren > 0)
            {
                _loc4_ = this.mc.getChildAt(0);
                this.mc.removeChild(_loc4_);
            }
            this.setupMC();
        }
        
        override public function prepareForTrigger() : void
        {
            var _loc6_:DisplayObject = null;
            var _loc7_:MovieClip = null;
            var _loc1_:Session = Settings.currentSession;
            var _loc2_:Vector.<LevelItem> = _loc1_.level.actionsVector;
            var _loc3_:int = int(_loc2_.indexOf(this));
            _loc2_.splice(_loc3_,1);
            _loc1_.contactListener.deleteListener(ContactListener.PERSIST,this.sensor);
            while(this.mc.numChildren > 0)
            {
                _loc6_ = this.mc.getChildAt(0);
                this.mc.removeChild(_loc6_);
            }
            var _loc4_:Number = this.numPanels * -90;
            var _loc5_:int = 0;
            while(_loc5_ < this.numPanels)
            {
                _loc7_ = new BoostPanelOffMC();
                this.mc.addChild(_loc7_);
                _loc7_.x = _loc4_;
                _loc4_ += 180;
                _loc5_++;
            }
        }
    }
}

