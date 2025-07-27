package com.totaljerkface.game.level.userspecials
{
    import Box2D.Collision.Shapes.*;
    import Box2D.Collision.b2AABB;
    import Box2D.Common.Math.b2Vec2;
    import Box2D.Dynamics.*;
    import com.totaljerkface.game.*;
    import com.totaljerkface.game.editor.specials.*;
    import com.totaljerkface.game.events.*;
    import com.totaljerkface.game.level.*;
    import com.totaljerkface.game.sound.SoundController;
    import flash.display.*;
    
    public class Mine extends LevelItem
    {
        private var mc:MovieClip;
        
        private var body:b2Body;
        
        private var sensor:b2Shape;
        
        public function Mine(param1:Special)
        {
            super();
            var _loc2_:MineRef = param1 as MineRef;
            this.createBody(new b2Vec2(_loc2_.x,_loc2_.y),_loc2_.rotation * Math.PI / 180);
            this.mc = new MineMC();
            var _loc3_:Sprite = Settings.currentSession.level.background;
            _loc3_.addChild(this.mc);
            Settings.currentSession.contactListener.registerListener(ContactEvent.RESULT,this.sensor,this.checkContact);
        }
        
        internal function createBody(param1:b2Vec2, param2:Number) : void
        {
            var _loc3_:b2BodyDef = null;
            var _loc4_:b2PolygonDef = null;
            _loc3_ = new b2BodyDef();
            _loc4_ = new b2PolygonDef();
            _loc4_.density = 1;
            _loc4_.friction = 1;
            _loc4_.restitution = 0.1;
            _loc4_.filter.categoryBits = 8;
            _loc4_.SetAsBox(12.5 / m_physScale,1 / m_physScale);
            _loc3_.position.Set(param1.x / m_physScale,param1.y / m_physScale);
            _loc3_.angle = param2;
            this.body = Settings.currentSession.m_world.CreateBody(_loc3_);
            this.body.CreateShape(_loc4_);
            _loc4_.SetAsOrientedBox(1 / m_physScale,0.5 / m_physScale,new b2Vec2(0,-2.5 / m_physScale));
            this.sensor = this.body.CreateShape(_loc4_);
            Settings.currentSession.level.paintItemVector.push(this);
            this.body.SetMassFromShapes();
        }
        
        override public function paint() : void
        {
            var _loc1_:b2Vec2 = this.body.GetWorldCenter();
            this.mc.x = _loc1_.x * m_physScale;
            this.mc.y = _loc1_.y * m_physScale;
            this.mc.rotation = this.body.GetAngle() * oneEightyOverPI % 360;
        }
        
        override public function actions() : void
        {
            var _loc1_:MovieClip = null;
            var _loc11_:b2Shape = null;
            var _loc12_:b2Body = null;
            var _loc13_:b2Vec2 = null;
            var _loc14_:b2Vec2 = null;
            var _loc15_:Number = NaN;
            var _loc16_:Number = NaN;
            var _loc17_:Number = NaN;
            var _loc18_:Number = NaN;
            var _loc19_:Number = NaN;
            _loc1_ = new Explosion();
            _loc1_.x = this.mc.x;
            _loc1_.y = this.mc.y;
            _loc1_.scaleX = _loc1_.scaleY = 0.5;
            if(Math.random() > 0.5)
            {
                _loc1_.scaleX *= -1;
            }
            _loc1_.rotation = this.body.GetAngle() * 180 / Math.PI;
            Settings.currentSession.containerSprite.addChildAt(_loc1_,1);
            var _loc2_:b2World = Settings.currentSession.m_world;
            _loc2_.DestroyBody(this.body);
            this.mc.visible = false;
            var _loc3_:Array = new Array();
            var _loc4_:Number = 2;
            var _loc5_:b2AABB = new b2AABB();
            var _loc6_:b2Vec2 = this.body.GetWorldCenter();
            _loc5_.lowerBound.Set(_loc6_.x - _loc4_,_loc6_.y - _loc4_);
            _loc5_.upperBound.Set(_loc6_.x + _loc4_,_loc6_.y + _loc4_);
            var _loc7_:int = _loc2_.Query(_loc5_,_loc3_,30);
            var _loc8_:* = 10;
            var _loc9_:int = 0;
            while(_loc9_ < _loc3_.length)
            {
                _loc11_ = _loc3_[_loc9_];
                _loc12_ = _loc11_.GetBody();
                if(!_loc12_.IsStatic())
                {
                    _loc13_ = _loc12_.GetWorldCenter();
                    _loc14_ = new b2Vec2(_loc13_.x - _loc6_.x,_loc13_.y - _loc6_.y);
                    _loc15_ = _loc14_.Length();
                    _loc15_ = Math.min(_loc4_,_loc15_);
                    _loc16_ = 1 - _loc15_ / _loc4_;
                    _loc17_ = Math.atan2(_loc14_.y,_loc14_.x);
                    _loc18_ = Math.cos(_loc17_) * _loc16_ * _loc8_;
                    _loc19_ = Math.sin(_loc17_) * _loc16_ * _loc8_;
                    _loc12_.ApplyImpulse(new b2Vec2(_loc18_,_loc19_),_loc13_);
                }
                _loc9_++;
            }
            SoundController.instance.playAreaSoundInstance("MineExplosion",this.body);
            var _loc10_:LevelB2D = Settings.currentSession.level;
            _loc10_.removeFromActionsVector(this);
            _loc10_.removeFromPaintItemVector(this);
        }
        
        internal function checkContact(param1:ContactEvent) : void
        {
            Settings.currentSession.contactListener.deleteListener(ContactEvent.RESULT,this.sensor);
            Settings.currentSession.level.actionsVector.push(this);
            this.sensor = null;
        }
        
        override public function triggerSingleActivation(param1:Trigger, param2:String, param3:Array) : void
        {
            if(_triggered)
            {
                return;
            }
            _triggered = true;
            if(this.sensor)
            {
                Settings.currentSession.contactListener.deleteListener(ContactEvent.RESULT,this.sensor);
                this.sensor = null;
                this.actions();
            }
        }
        
        override public function get bodyList() : Array
        {
            if(this.body)
            {
                return [this.body];
            }
            return [];
        }
    }
}

