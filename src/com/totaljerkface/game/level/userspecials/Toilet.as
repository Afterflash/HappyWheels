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
    import com.totaljerkface.game.particles.Spray;
    import com.totaljerkface.game.sound.*;
    import flash.display.*;
    import flash.events.Event;
    import flash.filters.BevelFilter;
    import flash.geom.Point;
    
    public class Toilet extends LevelItem
    {
        private var _backShape:b2Shape;
        
        private var _bowlShape:b2Shape;
        
        private var _baseShape:b2Shape;
        
        private var _body:b2Body;
        
        private var _interactive:Boolean;
        
        private var _impulseMin:int = 12;
        
        private var _breakBack:Boolean = false;
        
        private var _breakBase:Boolean = false;
        
        private var _inSingleActionArray:* = false;
        
        private var _sound:AreaSoundInstance;
        
        private var _hitSound:AreaSoundInstance;
        
        private var mc:ToiletMC;
        
        private var _sign:int;
        
        private var _polyDef:b2PolygonDef;
        
        public function Toilet(param1:Special, param2:b2Body = null, param3:Point = null)
        {
            super();
            this.createBody(param1);
        }
        
        internal function createBody(param1:Special) : void
        {
            var _loc2_:LevelB2D = null;
            var _loc14_:b2Vec2 = null;
            _loc2_ = Settings.currentSession.level;
            var _loc3_:Sprite = _loc2_.background;
            var _loc4_:ToiletRef = param1 as ToiletRef;
            _loc4_ = _loc4_.clone() as ToiletRef;
            this._sign = _loc4_.reverse ? -1 : 1;
            var _loc5_:BevelFilter = new BevelFilter(1,90,16752029,1,5308416,1,0,0);
            var _loc6_:MovieClip = new WaterMC();
            var _loc7_:MovieClip = new ToiletParticlesMC();
            var _loc8_:Array = [_loc5_];
            Settings.currentSession.particleController.createBMDArray("water",_loc6_,_loc8_);
            Settings.currentSession.particleController.createBMDArray("toiletParticles",_loc7_);
            this._interactive = _loc4_.interactive;
            this.mc = new ToiletMC();
            this.mc.container.gotoAndStop(1);
            this.mc.container.scaleX *= this._sign;
            _loc3_.addChild(this.mc);
            this.mc.x = param1.x;
            this.mc.y = param1.y;
            this.mc.rotation = param1.rotation;
            if(!this._interactive)
            {
                return;
            }
            var _loc9_:b2Vec2 = new b2Vec2(_loc4_.x,_loc4_.y);
            var _loc10_:Number = _loc4_.rotation;
            var _loc11_:b2BodyDef = new b2BodyDef();
            var _loc12_:b2PolygonDef = new b2PolygonDef();
            _loc12_.density = 2;
            _loc12_.friction = 0.3;
            _loc12_.filter.categoryBits = 8;
            _loc12_.restitution = 0.1;
            _loc12_.SetAsOrientedBox(10 / m_physScale,23.5 / m_physScale,new b2Vec2(this._sign * -21 / m_physScale,-16 / m_physScale),0);
            _loc11_.position.Set(_loc9_.x / m_physScale,_loc9_.y / m_physScale);
            _loc11_.angle = _loc10_ * Math.PI / 180;
            _loc11_.isSleeping = _loc4_.sleeping;
            var _loc13_:b2Body = this._body = Settings.currentSession.m_world.CreateBody(_loc11_);
            this._backShape = _loc13_.CreateShape(_loc12_) as b2PolygonShape;
            _loc12_.density = 4;
            _loc12_.SetAsOrientedBox(10.5 / m_physScale,7.5 / m_physScale,new b2Vec2(this._sign * 3 / m_physScale,31.5 / m_physScale),0);
            this._baseShape = _loc13_.CreateShape(_loc12_);
            this._polyDef = _loc12_;
            _loc12_.density = 2;
            _loc12_ = this.addBowlShapeToPolyDef(_loc12_);
            this._bowlShape = _loc13_.CreateShape(_loc12_);
            _loc13_.SetMassFromShapes();
            _loc2_.paintBodyVector.push(_loc13_);
            _loc13_.SetUserData(this.mc);
            _loc13_.SetMassFromShapes();
            _loc14_ = _loc13_.GetLocalCenter();
            this.mc.container.x = -_loc14_.x * m_physScale;
            this.mc.container.y = -_loc14_.y * m_physScale;
            Settings.currentSession.contactListener.registerListener(ContactListener.RESULT,this._backShape,this.checkBackContact);
            Settings.currentSession.contactListener.registerListener(ContactListener.RESULT,this._bowlShape,this.checkBaseContact);
            Settings.currentSession.contactListener.registerListener(ContactListener.RESULT,this._baseShape,this.checkBaseContact);
            Settings.currentSession.contactListener.registerListener(ContactListener.ADD,this._backShape,this.checkAdd);
            Settings.currentSession.contactListener.registerListener(ContactListener.ADD,this._bowlShape,this.checkAdd);
            Settings.currentSession.contactListener.registerListener(ContactListener.ADD,this._baseShape,this.checkAdd);
        }
        
        private function addBowlShapeToPolyDef(param1:b2PolygonDef) : b2PolygonDef
        {
            var _loc2_:Array = null;
            param1.vertexCount = 5;
            param1.vertices[0] = new b2Vec2(this._sign * -25 / m_physScale,4.5 / m_physScale);
            if(this._breakBase)
            {
                param1.vertices[1] = new b2Vec2(this._sign * 2 / m_physScale,4.5 / m_physScale);
                param1.vertices[2] = new b2Vec2(this._sign * 17 / m_physScale,25 / m_physScale);
            }
            else
            {
                param1.vertices[1] = new b2Vec2(this._sign * 31 / m_physScale,4.5 / m_physScale);
                param1.vertices[2] = new b2Vec2(this._sign * 25 / m_physScale,20 / m_physScale);
            }
            param1.vertices[3] = new b2Vec2(this._sign * 3.5 / m_physScale,30.5 / m_physScale);
            param1.vertices[4] = new b2Vec2(this._sign * -22 / m_physScale,17 / m_physScale);
            if(this._sign == -1)
            {
                _loc2_ = new Array();
                _loc2_[0] = param1.vertices[1];
                _loc2_[1] = param1.vertices[0];
                _loc2_[3] = param1.vertices[3];
                _loc2_[2] = param1.vertices[4];
                _loc2_[4] = param1.vertices[2];
                param1.vertices = _loc2_;
            }
            return param1;
        }
        
        private function checkBackContact(param1:ContactEvent) : void
        {
            if(param1.impulse > this._impulseMin)
            {
                this._breakBack = true;
                Settings.currentSession.contactListener.deleteListener(ContactEvent.RESULT,this._backShape);
                this.addToSingleActionArray();
            }
        }
        
        private function checkBaseContact(param1:ContactEvent) : void
        {
            if(param1.impulse > this._impulseMin)
            {
                this._breakBase = true;
                Settings.currentSession.contactListener.deleteListener(ContactEvent.RESULT,this._bowlShape);
                Settings.currentSession.contactListener.deleteListener(ContactEvent.RESULT,this._baseShape);
                this.addToSingleActionArray();
            }
        }
        
        private function addToSingleActionArray() : void
        {
            if(!this._inSingleActionArray)
            {
                this._inSingleActionArray = true;
                Settings.currentSession.level.singleActionVector.push(this);
            }
        }
        
        override public function singleAction() : void
        {
            var _loc10_:Sprite = null;
            var _loc12_:b2Body = null;
            var _loc13_:int = 0;
            var _loc14_:b2Vec2 = null;
            var _loc15_:b2Vec2 = null;
            var _loc16_:Spray = null;
            var _loc17_:b2Vec2 = null;
            var _loc18_:b2Vec2 = null;
            var _loc19_:b2Vec2 = null;
            var _loc20_:b2Vec2 = null;
            this._inSingleActionArray = false;
            var _loc1_:Session = Settings.currentSession;
            var _loc2_:LevelB2D = _loc1_.level;
            var _loc3_:b2World = _loc1_.m_world;
            var _loc4_:Sprite = _loc2_.background;
            var _loc5_:b2Vec2 = this._body.GetWorldCenter();
            var _loc6_:b2Vec2 = this._body.GetLinearVelocity();
            var _loc7_:Number = this._body.GetAngularVelocity();
            var _loc8_:Number = this._body.GetAngle();
            var _loc9_:b2BodyDef = new b2BodyDef();
            _loc9_.angle = _loc8_;
            _loc9_.position = _loc5_;
            if(this._breakBase && Boolean(this._baseShape))
            {
                this._body.DestroyShape(this._baseShape);
                this._body.DestroyShape(this._bowlShape);
                this._baseShape = null;
                Settings.currentSession.contactListener.deleteListener(ContactEvent.ADD,this._baseShape);
                _loc10_ = new ToiletBasePiece1MC();
                _loc10_.scaleX *= this._sign;
                _loc4_.addChild(_loc10_);
                _loc12_ = _loc3_.CreateBody(_loc9_);
                _loc12_.SetAngularVelocity(_loc7_);
                _loc12_.SetLinearVelocity(_loc6_);
                this._polyDef.SetAsOrientedBox(10.5 / m_physScale,7.5 / m_physScale,new b2Vec2(this._sign * 3 / m_physScale,31.5 / m_physScale),0);
                _loc12_.CreateShape(this._polyDef);
                _loc12_.SetUserData(_loc10_);
                _loc2_.paintBodyVector.push(_loc12_);
                this._polyDef = this.addBowlShapeToPolyDef(this._polyDef);
                _loc12_.CreateShape(this._polyDef);
                _loc12_.SetMassFromShapes();
                _loc12_.SetAngularVelocity(_loc7_);
                _loc12_.SetLinearVelocity(_loc6_);
                _loc13_ = _loc4_.getChildIndex(_loc10_);
                _loc14_ = this._sign == 1 ? new b2Vec2(11 / m_physScale,22 / m_physScale) : new b2Vec2(-1 / m_physScale,13 / m_physScale);
                _loc15_ = this._sign == 1 ? new b2Vec2(1 / m_physScale,13 / m_physScale) : new b2Vec2(-11 / m_physScale,22 / m_physScale);
                Settings.currentSession.particleController.createRectBurst("toiletParticles",20,_loc12_,30);
                _loc16_ = _loc1_.particleController.createSpray("water",_loc12_,_loc14_,_loc15_,0,2,15,3,95,_loc4_,_loc13_);
                _loc10_ = new ToiletBasePiece2MC();
                _loc10_.scaleX *= this._sign;
                _loc4_.addChild(_loc10_);
                _loc12_ = _loc3_.CreateBody(_loc9_);
                _loc12_.SetUserData(_loc10_);
                _loc2_.paintBodyVector.push(_loc12_);
                this._polyDef.vertexCount = 4;
                _loc17_ = new b2Vec2(this._sign * 8 / m_physScale,4.5 / m_physScale);
                _loc18_ = new b2Vec2(this._sign * 31 / m_physScale,4.5 / m_physScale);
                _loc19_ = new b2Vec2(this._sign * 25 / m_physScale,20 / m_physScale);
                _loc20_ = new b2Vec2(this._sign * 17 / m_physScale,25 / m_physScale);
                if(this._sign == 1)
                {
                    this._polyDef.vertices[0] = _loc17_;
                    this._polyDef.vertices[1] = _loc18_;
                    this._polyDef.vertices[2] = _loc19_;
                    this._polyDef.vertices[3] = _loc20_;
                }
                else
                {
                    this._polyDef.vertices[0] = _loc18_;
                    this._polyDef.vertices[1] = _loc17_;
                    this._polyDef.vertices[2] = _loc20_;
                    this._polyDef.vertices[3] = _loc19_;
                }
                _loc12_.CreateShape(this._polyDef);
                _loc12_.SetMassFromShapes();
                _loc12_.SetAngularVelocity(_loc7_);
                _loc12_.SetLinearVelocity(_loc6_);
                this.mc.container.base.visible = false;
                this.playSound(_loc12_);
            }
            if(this._breakBack && Boolean(this._backShape))
            {
                this._body.DestroyShape(this._backShape);
                this._backShape = null;
                Settings.currentSession.contactListener.deleteListener(ContactEvent.ADD,this._backShape);
                this._polyDef.SetAsOrientedBox(10 / m_physScale,12.5 / m_physScale,new b2Vec2(this._sign * -14 / m_physScale,-31 / m_physScale),0);
                _loc10_ = new ToiletBackPiece1MC();
                _loc10_.scaleX *= this._sign;
                _loc4_.addChild(_loc10_);
                _loc12_ = _loc3_.CreateBody(_loc9_);
                _loc12_.CreateShape(this._polyDef);
                _loc12_.SetMassFromShapes();
                _loc12_.SetAngularVelocity(_loc7_);
                _loc12_.SetLinearVelocity(_loc6_);
                _loc12_.SetUserData(_loc10_);
                _loc2_.paintBodyVector.push(_loc12_);
                this._polyDef.SetAsOrientedBox(10 / m_physScale,11 / m_physScale,new b2Vec2(this._sign * -14 / m_physScale,-7 / m_physScale),0);
                _loc10_ = new ToiletBackPiece2MC();
                _loc10_.scaleX *= this._sign;
                _loc4_.addChild(_loc10_);
                _loc12_ = _loc3_.CreateBody(_loc9_);
                _loc12_.CreateShape(this._polyDef);
                _loc12_.SetUserData(_loc10_);
                _loc2_.paintBodyVector.push(_loc12_);
                _loc12_.SetMassFromShapes();
                _loc12_.SetAngularVelocity(_loc7_);
                _loc12_.SetLinearVelocity(_loc6_);
                this.mc.container.back.visible = false;
                _loc13_ = _loc4_.getChildIndex(_loc10_);
                _loc14_ = this._sign == 1 ? new b2Vec2(-7 / m_physScale,-14 / m_physScale) : new b2Vec2(23 / m_physScale,-13 / m_physScale);
                _loc15_ = this._sign == 1 ? new b2Vec2(-23 / m_physScale,-13 / m_physScale) : new b2Vec2(7 / m_physScale,-14 / m_physScale);
                _loc1_.particleController.createRectBurst("toiletParticles",20,_loc12_,30);
                _loc1_.particleController.createSpray("water",_loc12_,_loc14_,_loc15_,0,1,15,3,80,_loc4_,_loc13_);
                this.playSound(_loc12_);
            }
            if(this._breakBase && this._breakBack)
            {
                Settings.currentSession.contactListener.deleteListener(ContactEvent.ADD,this._bowlShape);
                _loc3_.DestroyBody(this._body);
                _loc4_.removeChild(this.mc);
                return;
            }
            this._body.SetMassFromShapes();
            var _loc11_:b2Vec2 = this._body.GetLocalCenter();
            this.mc.container.x = -_loc11_.x * m_physScale;
            this.mc.container.y = -_loc11_.y * m_physScale;
        }
        
        private function checkAdd(param1:b2ContactPoint) : void
        {
            var _loc4_:Number = NaN;
            if(param1.shape2.m_isSensor)
            {
                return;
            }
            if(this._hitSound)
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
                _loc4_ = Math.ceil(Math.random() * 2);
                if(!this._hitSound)
                {
                    this._hitSound = SoundController.instance.playAreaSoundInstance("ToiletHit" + _loc4_,this._body);
                }
                if(this._hitSound)
                {
                    this._hitSound.addEventListener(AreaSoundInstance.AREA_SOUND_STOP,this.hitSoundComplete,false,0,true);
                }
            }
        }
        
        private function playSound(param1:b2Body) : *
        {
            var _loc2_:Number = Math.ceil(Math.random() * 3);
            if(!this._sound)
            {
                this._sound = SoundController.instance.playAreaSoundInstance("ToiletSmash" + _loc2_,param1);
            }
            if(this._sound)
            {
                this._sound.addEventListener(AreaSoundInstance.AREA_SOUND_STOP,this.soundComplete,false,0,true);
            }
        }
        
        private function soundComplete(param1:Event) : *
        {
            this._sound.removeEventListener(AreaSoundInstance.AREA_SOUND_STOP,this.soundComplete);
            this._sound = null;
        }
        
        private function hitSoundComplete(param1:Event) : *
        {
            this._hitSound.removeEventListener(AreaSoundInstance.AREA_SOUND_STOP,this.hitSoundComplete);
            this._hitSound = null;
        }
        
        override public function getJointBody(param1:b2Vec2 = null) : b2Body
        {
            return this._body;
        }
        
        override public function get groupDisplayObject() : DisplayObject
        {
            return this.mc;
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

