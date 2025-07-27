package com.totaljerkface.game.level.userspecials
{
    import Box2D.Collision.*;
    import Box2D.Collision.Shapes.*;
    import Box2D.Common.Math.b2Math;
    import Box2D.Common.Math.b2Vec2;
    import Box2D.Dynamics.*;
    import com.totaljerkface.game.*;
    import com.totaljerkface.game.editor.specials.*;
    import com.totaljerkface.game.events.*;
    import com.totaljerkface.game.level.*;
    import com.totaljerkface.game.sound.*;
    import flash.display.*;
    import flash.geom.Point;
    
    public class Boombox extends LevelItem
    {
        private var _shape:b2Shape;
        
        private var _body:b2Body;
        
        private var _interactive:Boolean;
        
        private var _crackImpulse:int = 6;
        
        private var _shatterImpulse:int = 17;
        
        private var _break:Boolean = false;
        
        private var mc:MovieClip;
        
        public function Boombox(param1:Special, param2:b2Body = null, param3:Point = null)
        {
            super();
            this.createBody(param1);
        }
        
        internal function createBody(param1:Special) : void
        {
            var _loc2_:LevelB2D = null;
            _loc2_ = Settings.currentSession.level;
            var _loc3_:Sprite = _loc2_.background;
            var _loc4_:BoomboxRef = param1 as BoomboxRef;
            _loc4_ = _loc4_.clone() as BoomboxRef;
            var _loc5_:MovieClip = new BoomboxShardsMC();
            Settings.currentSession.particleController.createBMDArray("boomboxshards",_loc5_);
            this._interactive = _loc4_.interactive;
            this.mc = new BoomboxMC();
            this.mc.gotoAndStop(1);
            _loc3_.addChild(this.mc);
            this.mc.x = param1.x;
            this.mc.y = param1.y;
            this.mc.rotation = param1.rotation;
            if(!this._interactive)
            {
                return;
            }
            var _loc6_:b2Vec2 = new b2Vec2(_loc4_.x,_loc4_.y);
            var _loc7_:Number = _loc4_.rotation;
            var _loc8_:b2BodyDef = new b2BodyDef();
            var _loc9_:b2PolygonDef = new b2PolygonDef();
            _loc9_.density = 2;
            _loc9_.friction = 0.3;
            _loc9_.filter.categoryBits = 8;
            _loc9_.restitution = 0.1;
            _loc9_.SetAsBox(24 / m_physScale,14 / m_physScale);
            _loc8_.position.Set(_loc6_.x / m_physScale,_loc6_.y / m_physScale);
            _loc8_.angle = _loc7_ * Math.PI / 180;
            _loc8_.isSleeping = _loc4_.sleeping;
            var _loc10_:b2Body = this._body = Settings.currentSession.m_world.CreateBody(_loc8_);
            this._shape = _loc10_.CreateShape(_loc9_) as b2PolygonShape;
            _loc10_.SetMassFromShapes();
            _loc2_.paintBodyVector.push(_loc10_);
            _loc10_.SetUserData(this.mc);
            Settings.currentSession.contactListener.registerListener(ContactListener.RESULT,this._shape,this.checkContact);
            Settings.currentSession.contactListener.registerListener(ContactListener.ADD,this._shape,this.checkAdd);
        }
        
        private function checkContact(param1:ContactEvent) : void
        {
            if(param1.impulse > this._crackImpulse)
            {
                if(param1.impulse > this._shatterImpulse)
                {
                    Settings.currentSession.contactListener.deleteListener(ContactListener.ADD,this._shape);
                    this._break = true;
                }
                this._crackImpulse = this._shatterImpulse;
                Settings.currentSession.contactListener.deleteListener(ContactEvent.RESULT,this._shape);
                Settings.currentSession.level.singleActionVector.push(this);
            }
        }
        
        override public function singleAction() : void
        {
            var _loc3_:Number = NaN;
            var _loc1_:LevelB2D = Settings.currentSession.level;
            var _loc2_:Sprite = _loc1_.background;
            if(!this._break)
            {
                _loc3_ = Math.ceil(Math.random() * 2);
                Settings.currentSession.contactListener.registerListener(ContactListener.RESULT,this._shape,this.checkContact);
                SoundController.instance.playAreaSoundInstance("BoomboxCrush1",this._body);
                Settings.currentSession.particleController.createRectBurst("boomboxshards",8,this._body,15);
                _loc3_ = 1 + Math.ceil(Math.random() * 3);
                this.mc.gotoAndStop(_loc3_);
                this._break = true;
                return;
            }
            this.shatter();
        }
        
        override public function getJointBody(param1:b2Vec2 = null) : b2Body
        {
            return this._body;
        }
        
        private function shatter() : void
        {
            var _loc1_:Session = Settings.currentSession;
            var _loc2_:LevelB2D = _loc1_.level;
            var _loc3_:b2World = _loc1_.m_world;
            Settings.currentSession.particleController.createRectBurst("boomboxshards",10,this._body,30);
            var _loc4_:Number = Math.ceil(Math.random() * 2);
            SoundController.instance.playAreaSoundInstance("BoomboxSmash" + _loc4_,this._body);
            _loc2_.removeFromPaintBodyVector(this._body);
            var _loc5_:b2Vec2 = this._body.GetWorldCenter();
            var _loc6_:b2Vec2 = this._body.GetLinearVelocity();
            var _loc7_:Number = this._body.GetAngularVelocity();
            _loc3_.DestroyBody(this._body);
            var _loc8_:Number = this._body.GetAngle();
            var _loc9_:int = _loc2_.background.getChildIndex(this.mc);
            var _loc10_:Sprite = new BoomboxPiece1MC();
            var _loc11_:Sprite = new BoomboxPiece2MC();
            _loc2_.background.addChildAt(_loc10_,_loc9_);
            _loc2_.background.addChildAt(_loc11_,_loc9_);
            var _loc12_:b2BodyDef = new b2BodyDef();
            _loc12_.angle = _loc8_;
            var _loc13_:b2Vec2 = new b2Vec2(-13.6 / m_physScale,1.8 / m_physScale);
            _loc12_.position = this._body.GetWorldPoint(_loc13_);
            var _loc14_:b2PolygonDef = new b2PolygonDef();
            _loc14_.density = 2;
            _loc14_.friction = 0.3;
            _loc14_.restitution = 0.1;
            _loc14_.filter.categoryBits = 8;
            _loc14_.vertexCount = 3;
            _loc14_.SetAsBox(10.5 / m_physScale,14 / m_physScale);
            var _loc15_:b2Body = _loc3_.CreateBody(_loc12_);
            _loc15_.CreateShape(_loc14_);
            _loc15_.SetMassFromShapes();
            var _loc16_:b2Vec2 = _loc15_.GetLocalCenter();
            _loc15_.SetAngularVelocity(_loc7_);
            _loc15_.SetLinearVelocity(this._body.GetLinearVelocityFromLocalPoint(_loc16_));
            _loc15_.SetUserData(_loc10_);
            _loc2_.paintBodyVector.push(_loc15_);
            _loc13_ = new b2Vec2(13.55 / m_physScale,1.8 / m_physScale);
            _loc12_.position = this._body.GetWorldPoint(_loc13_);
            _loc15_ = _loc3_.CreateBody(_loc12_);
            _loc15_.CreateShape(_loc14_);
            _loc15_.SetMassFromShapes();
            _loc16_ = _loc15_.GetLocalCenter();
            _loc15_.SetAngularVelocity(_loc7_);
            _loc15_.SetLinearVelocity(this._body.GetLinearVelocityFromLocalPoint(_loc16_));
            _loc15_.SetUserData(_loc11_);
            _loc2_.paintBodyVector.push(_loc15_);
            this.mc.parent.removeChild(this.mc);
            this._body = null;
        }
        
        private function checkAdd(param1:b2ContactPoint) : void
        {
            if(param1.shape2.m_isSensor)
            {
                return;
            }
            var _loc2_:Number = param1.shape2.m_body.m_mass;
            if(_loc2_ != 0 && _loc2_ < this._body.m_mass)
            {
                return;
            }
            var _loc3_:Number = b2Math.b2Dot(param1.velocity,param1.normal);
            _loc3_ = Math.abs(_loc3_);
            if(_loc3_ > 4)
            {
                SoundController.instance.playAreaSoundInstance("BoomboxHit",this._body);
            }
        }
        
        override public function get groupDisplayObject() : DisplayObject
        {
            return this.mc;
        }
        
        override public function die() : void
        {
            var _loc1_:ContactListener = Settings.currentSession.contactListener;
        }
        
        override public function triggerSingleActivation(param1:Trigger, param2:String, param3:Array) : void
        {
            var _loc4_:Number = NaN;
            var _loc5_:Number = NaN;
            var _loc6_:Number = NaN;
            var _loc7_:Number = NaN;
            var _loc8_:Number = NaN;
            if(param2 == "wake from sleep")
            {
                if(this._body)
                {
                    this._body.WakeUp();
                }
            }
            else if(param2 == "apply impulse")
            {
                if(this._body)
                {
                    _loc4_ = Number(param3[0]);
                    _loc5_ = Number(param3[1]);
                    _loc6_ = this._body.GetMass();
                    this._body.ApplyImpulse(new b2Vec2(_loc4_ * _loc6_,_loc5_ * _loc6_),this._body.GetWorldCenter());
                    _loc7_ = Number(param3[2]);
                    _loc8_ = this._body.GetAngularVelocity();
                    this._body.SetAngularVelocity(_loc8_ + _loc7_);
                }
            }
        }
        
        override public function get bodyList() : Array
        {
            if(this._body)
            {
                return [this._body];
            }
            return [];
        }
    }
}

