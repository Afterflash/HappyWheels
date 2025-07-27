package com.totaljerkface.game.level.userspecials
{
    import Box2D.Collision.Shapes.*;
    import Box2D.Collision.b2ContactPoint;
    import Box2D.Common.Math.b2Mat22;
    import Box2D.Common.Math.b2Vec2;
    import Box2D.Dynamics.*;
    import Box2D.Dynamics.Joints.*;
    import com.totaljerkface.game.*;
    import com.totaljerkface.game.editor.specials.*;
    import com.totaljerkface.game.events.*;
    import com.totaljerkface.game.level.*;
    import com.totaljerkface.game.sound.AreaSoundLoopStatic;
    import com.totaljerkface.game.sound.SoundController;
    import flash.display.*;
    import flash.geom.Point;
    
    public class Fan extends LevelItem
    {
        private var mc:FanMC;
        
        private var sensor:b2Shape;
        
        private var bodies:Array;
        
        private var angle:Number;
        
        private var center:b2Vec2;
        
        private var sinVal:Number;
        
        private var cosVal:Number;
        
        private var fanSound:AreaSoundLoopStatic;
        
        private var fanVec:b2Vec2;
        
        public function Fan(param1:Special)
        {
            super();
            var _loc2_:FanRef = param1 as FanRef;
            this.angle = _loc2_.rotation * Math.PI / 180;
            this.sinVal = Math.sin(this.angle);
            this.cosVal = Math.cos(this.angle);
            this.createBodies(new b2Vec2(_loc2_.x,_loc2_.y),this.angle);
            this.mc = new FanMC();
            this.mc.x = _loc2_.x;
            this.mc.y = _loc2_.y;
            this.mc.rotation = _loc2_.rotation;
            var _loc3_:Sprite = Settings.currentSession.level.background;
            _loc3_.addChild(this.mc);
            this.bodies = new Array();
            Settings.currentSession.level.actionsVector.push(this);
            Settings.currentSession.contactListener.registerListener(ContactListener.PERSIST,this.sensor,this.checkPersist);
            this.fanVec = new b2Vec2(_loc2_.x / m_physScale,_loc2_.y / m_physScale);
            this.fanSound = SoundController.instance.playAreaSoundLoopStatic("SwooshFan",new Point(this.fanVec.x,this.fanVec.y));
        }
        
        internal function createBodies(param1:b2Vec2, param2:Number) : void
        {
            var _loc8_:b2Vec2 = null;
            var _loc3_:b2PolygonDef = new b2PolygonDef();
            _loc3_.isSensor = true;
            _loc3_.filter.categoryBits = 8;
            if(Settings.currentSession.version > 1.42)
            {
                _loc3_.filter.groupIndex = -20;
            }
            var _loc4_:b2Body = Settings.currentSession.level.levelBody;
            this.center = new b2Vec2((param1.x + Math.sin(param2) * 300) / m_physScale,(param1.y - Math.cos(param2) * 300) / m_physScale);
            _loc3_.SetAsOrientedBox(150 / m_physScale,250 / m_physScale,this.center,param2);
            this.sensor = _loc4_.CreateShape(_loc3_);
            _loc3_.isSensor = false;
            _loc3_.friction = 0.3;
            _loc3_.restitution = 0.1;
            _loc3_.filter.categoryBits = 8;
            _loc3_.filter.groupIndex = 0;
            _loc3_.SetAsOrientedBox(150 / m_physScale,25 / m_physScale,new b2Vec2((param1.x - Math.sin(param2) * -25) / m_physScale,(param1.y + Math.cos(param2) * -25) / m_physScale),param2);
            _loc4_.CreateShape(_loc3_);
            _loc3_.vertexCount = 7;
            _loc3_.vertices[0] = new b2Vec2(150 / m_physScale,0);
            _loc3_.vertices[1] = new b2Vec2(125 / m_physScale,84.5 / m_physScale);
            _loc3_.vertices[2] = new b2Vec2(65 / m_physScale,137 / m_physScale);
            _loc3_.vertices[3] = new b2Vec2(0,150 / m_physScale);
            _loc3_.vertices[4] = new b2Vec2(-65 / m_physScale,137 / m_physScale);
            _loc3_.vertices[5] = new b2Vec2(-125 / m_physScale,84.5 / m_physScale);
            _loc3_.vertices[6] = new b2Vec2(-150 / m_physScale,0);
            var _loc5_:b2Mat22 = new b2Mat22(this.angle);
            var _loc6_:b2Vec2 = new b2Vec2(param1.x / m_physScale,param1.y / m_physScale);
            var _loc7_:int = 0;
            while(_loc7_ < _loc3_.vertexCount)
            {
                _loc8_ = _loc3_.vertices[_loc7_];
                _loc8_.MulM(_loc5_);
                _loc8_.Add(_loc6_);
                _loc7_++;
            }
            _loc4_.CreateShape(_loc3_);
        }
        
        override public function actions() : void
        {
            var _loc2_:b2Body = null;
            var _loc3_:b2Vec2 = null;
            var _loc4_:b2Vec2 = null;
            var _loc5_:Number = NaN;
            var _loc6_:Number = NaN;
            var _loc7_:Number = NaN;
            if(this.bodies.length == 0)
            {
                return;
            }
            var _loc1_:int = 0;
            while(_loc1_ < this.bodies.length)
            {
                _loc2_ = this.bodies[_loc1_];
                _loc3_ = _loc2_.GetWorldCenter();
                _loc4_ = _loc3_.Copy();
                _loc4_.Subtract(this.center);
                _loc5_ = (_loc4_.x * -this.sinVal + _loc4_.y * this.cosVal) * m_physScale + 250;
                _loc5_ = Math.max(_loc5_,0);
                _loc5_ = Math.min(_loc5_,250);
                _loc6_ = _loc5_ / 250;
                _loc7_ = _loc6_ * _loc6_ * 15;
                _loc2_.ApplyForce(new b2Vec2(this.sinVal * _loc7_,this.cosVal * -_loc7_),_loc3_);
                _loc1_++;
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
            if(_triggered)
            {
                return;
            }
            _triggered = true;
            Settings.currentSession.level.actionsVector.push(this);
            Settings.currentSession.contactListener.registerListener(ContactListener.PERSIST,this.sensor,this.checkPersist);
            this.mc.blades.play();
            this.fanSound = SoundController.instance.playAreaSoundLoopStatic("SwooshFan",new Point(this.fanVec.x,this.fanVec.y));
        }
        
        override public function prepareForTrigger() : void
        {
            var _loc1_:Session = Settings.currentSession;
            var _loc2_:Vector.<LevelItem> = _loc1_.level.actionsVector;
            var _loc3_:int = int(_loc2_.indexOf(this));
            _loc2_.splice(_loc3_,1);
            _loc1_.contactListener.deleteListener(ContactListener.PERSIST,this.sensor);
            this.mc.blades.gotoAndStop(2);
            this.fanSound.stopSound(true);
        }
    }
}

