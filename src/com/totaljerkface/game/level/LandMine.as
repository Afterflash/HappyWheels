package com.totaljerkface.game.level
{
    import Box2D.Collision.Shapes.*;
    import Box2D.Collision.b2AABB;
    import Box2D.Common.Math.b2Vec2;
    import Box2D.Dynamics.*;
    import com.totaljerkface.game.*;
    import com.totaljerkface.game.events.*;
    import com.totaljerkface.game.sound.SoundController;
    import flash.display.*;
    
    public class LandMine extends LevelItem
    {
        private var mc:MovieClip;
        
        private var id:String;
        
        private var body:b2Body;
        
        private var sensor:b2Shape;
        
        private var hit:Boolean;
        
        public function LandMine(param1:String)
        {
            super();
            this.id = param1;
            this.createBody();
            this.mc = Settings.currentSession.level.background[param1 + "mc"];
            this.mc.visible = true;
            Settings.currentSession.contactListener.registerListener(ContactEvent.RESULT,this.sensor,this.checkContact);
        }
        
        internal function createBody() : void
        {
            var _loc1_:b2BodyDef = null;
            var _loc2_:b2PolygonDef = null;
            _loc1_ = new b2BodyDef();
            _loc2_ = new b2PolygonDef();
            _loc2_.density = 1;
            _loc2_.friction = 1;
            _loc2_.restitution = 0.1;
            _loc2_.filter.categoryBits = 8;
            var _loc3_:MovieClip = Settings.currentSession.level.shapeGuide.getChildByName(this.id) as MovieClip;
            var _loc4_:Number = _loc3_.rotation * Math.PI / 180;
            _loc2_.SetAsBox(_loc3_.scaleX * 5 / m_physScale,_loc3_.scaleY * 5 / m_physScale);
            _loc1_.position.Set(_loc3_.x / m_physScale,_loc3_.y / m_physScale);
            _loc1_.angle = _loc4_;
            this.body = Settings.currentSession.m_world.CreateBody(_loc1_);
            this.sensor = this.body.CreateShape(_loc2_);
        }
        
        override public function paint() : void
        {
            var _loc1_:b2Vec2 = null;
            _loc1_ = this.body.GetWorldCenter();
            this.mc.x = _loc1_.x * m_physScale;
            this.mc.y = _loc1_.y * m_physScale;
            this.mc.rotation = this.body.GetAngle() * (180 / Math.PI);
        }
        
        override public function actions() : void
        {
            var _loc2_:Sprite = null;
            var _loc3_:MovieClip = null;
            var _loc13_:b2Shape = null;
            var _loc14_:b2Body = null;
            var _loc15_:b2Vec2 = null;
            var _loc16_:b2Vec2 = null;
            var _loc17_:Number = NaN;
            var _loc18_:Number = NaN;
            var _loc19_:Number = NaN;
            var _loc20_:Number = NaN;
            var _loc21_:Number = NaN;
            var _loc1_:b2World = Settings.currentSession.m_world;
            _loc2_ = Settings.currentSession.containerSprite;
            _loc1_.DestroyBody(this.body);
            this.mc.visible = false;
            _loc3_ = new Explosion();
            _loc3_.x = this.mc.x;
            _loc3_.y = this.mc.y;
            _loc3_.scaleX = _loc3_.scaleY = 0.5;
            _loc2_.addChildAt(_loc3_,1);
            var _loc4_:Array = new Array();
            var _loc5_:Number = 2;
            var _loc6_:b2AABB = new b2AABB();
            var _loc7_:b2Vec2 = this.body.GetWorldCenter();
            _loc6_.lowerBound.Set(_loc7_.x - _loc5_,_loc7_.y - _loc5_);
            _loc6_.upperBound.Set(_loc7_.x + _loc5_,_loc7_.y + _loc5_);
            var _loc8_:int = _loc1_.Query(_loc6_,_loc4_,30);
            var _loc9_:* = 8;
            var _loc10_:* = 8;
            var _loc11_:int = 0;
            while(_loc11_ < _loc4_.length)
            {
                _loc13_ = _loc4_[_loc11_];
                _loc14_ = _loc13_.GetBody();
                if(!_loc14_.IsStatic())
                {
                    _loc15_ = _loc14_.GetWorldCenter();
                    _loc16_ = new b2Vec2(_loc15_.x - _loc7_.x,_loc15_.y - _loc7_.y);
                    _loc17_ = _loc16_.Length();
                    _loc17_ = Math.min(_loc5_,_loc17_);
                    _loc18_ = 1 - _loc17_ / _loc5_;
                    _loc19_ = Math.atan2(_loc16_.y,_loc16_.x);
                    _loc20_ = Math.cos(_loc19_) * _loc18_ * _loc9_;
                    _loc21_ = Math.sin(_loc19_) * _loc18_ * _loc10_;
                    _loc14_.ApplyImpulse(new b2Vec2(_loc20_,_loc21_),_loc15_);
                }
                _loc11_++;
            }
            SoundController.instance.playAreaSoundInstance("MineExplosion",this.body);
            var _loc12_:LevelB2D = Settings.currentSession.level;
            _loc12_.removeFromActionsVector(this);
        }
        
        internal function checkContact(param1:ContactEvent) : void
        {
            Settings.currentSession.contactListener.deleteListener(ContactEvent.RESULT,this.sensor);
            Settings.currentSession.level.actionsVector.push(this);
        }
    }
}

