package com.totaljerkface.game.level.userspecials
{
    import Box2D.Collision.Shapes.*;
    import Box2D.Collision.b2AABB;
    import Box2D.Common.Math.b2Vec2;
    import Box2D.Dynamics.*;
    import com.totaljerkface.game.*;
    import com.totaljerkface.game.character.CharacterB2D;
    import com.totaljerkface.game.editor.specials.*;
    import com.totaljerkface.game.events.*;
    import com.totaljerkface.game.level.*;
    import com.totaljerkface.game.sound.AreaSoundLoop;
    import com.totaljerkface.game.sound.SoundController;
    import flash.display.*;
    import flash.filters.BevelFilter;
    
    public class Jet extends LevelItem
    {
        private var smash_impulse:int;
        
        private var mc:MovieClip;
        
        private var body:b2Body;
        
        private var jetShape:b2Shape;
        
        private var power:Number;
        
        private var accelScaler:Number;
        
        private var accelStep:Number;
        
        private var firing:Boolean;
        
        private var fireCount:Number = 0;
        
        private var fireTotal:Number;
        
        private var _firingAllowed:Boolean = true;
        
        private var soundLoop:AreaSoundLoop;
        
        private var fadeTime:Number = 0;
        
        public function Jet(param1:Special)
        {
            super();
            var _loc2_:JetRef = param1 as JetRef;
            this.createBody(_loc2_);
            this.mc = new JetMC();
            var _loc3_:Number = JetRef.MAX_POWER - JetRef.MIN_POWER;
            var _loc4_:Number = (_loc2_.power - JetRef.MIN_POWER) / _loc3_;
            this.mc.scaleX = this.mc.scaleY = 1 + _loc4_;
            var _loc5_:Sprite = Settings.currentSession.level.background;
            _loc5_.addChild(this.mc);
            this.power = _loc2_.power;
            if(_loc2_.accelTime > 0)
            {
                this.accelScaler = 0;
                this.accelStep = 1 / (_loc2_.accelTime * 30);
                this.fadeTime = _loc2_.accelTime;
            }
            else
            {
                this.accelScaler = 1;
                this.accelStep = 0;
            }
            if(_loc2_.fireTime > 0)
            {
                this.fireTotal = _loc2_.fireTime * 30;
            }
            else
            {
                this.fireTotal = Infinity;
            }
            var _loc6_:BevelFilter = new BevelFilter(5,90,16777215,1,0,1,5,5,1,3,"inner");
            Settings.currentSession.particleController.createBMDArray("metalpieces",new MetalPiecesMC(),[_loc6_]);
            Settings.currentSession.level.actionsVector.push(this);
            Settings.currentSession.contactListener.registerListener(ContactEvent.RESULT,this.jetShape,this.checkContact);
            if(!_loc2_.sleeping)
            {
                this.fireEngine();
            }
            else
            {
                this.mc.flames.visible = this.mc.lights.visible = false;
            }
        }
        
        internal function createBody(param1:JetRef) : void
        {
            var _loc2_:b2Vec2 = new b2Vec2(param1.x,param1.y);
            var _loc3_:Number = param1.rotation * Math.PI / 180;
            var _loc4_:b2BodyDef = new b2BodyDef();
            _loc4_.isSleeping = param1.sleeping;
            _loc4_.fixedRotation = param1.fixedRotation;
            var _loc5_:b2PolygonDef = new b2PolygonDef();
            _loc5_.density = 3;
            _loc5_.friction = 0.5;
            _loc5_.restitution = 0.1;
            _loc5_.filter.categoryBits = 8;
            var _loc6_:Number = 15.5;
            var _loc7_:Number = 19;
            var _loc8_:Number = JetRef.MAX_POWER - JetRef.MIN_POWER;
            var _loc9_:Number = (param1.power - JetRef.MIN_POWER) / _loc8_;
            _loc6_ += _loc6_ * _loc9_;
            _loc7_ += _loc7_ * _loc9_;
            _loc5_.SetAsBox(_loc6_ * 0.5 / m_physScale,_loc7_ * 0.5 / m_physScale);
            _loc4_.position.Set(_loc2_.x / m_physScale,_loc2_.y / m_physScale);
            _loc4_.angle = _loc3_;
            this.body = Settings.currentSession.m_world.CreateBody(_loc4_);
            this.jetShape = this.body.CreateShape(_loc5_);
            Settings.currentSession.level.paintItemVector.push(this);
            this.body.SetMassFromShapes();
            this.smash_impulse = Math.round(100 * this.body.GetMass());
        }
        
        override public function paint() : void
        {
            var _loc1_:b2Vec2 = null;
            _loc1_ = this.body.GetWorldCenter();
            this.mc.x = _loc1_.x * m_physScale;
            this.mc.y = _loc1_.y * m_physScale;
            this.mc.rotation = this.body.GetAngle() * oneEightyOverPI % 360;
            var _loc2_:* = 0.95 * this.accelScaler + Math.random() * 0.1;
            this.mc.flames.scaleY = 0.95 * this.accelScaler + Math.random() * 0.1;
            this.mc.flames.scaleX = _loc2_;
        }
        
        override public function actions() : void
        {
            var _loc1_:Number = NaN;
            var _loc2_:Number = NaN;
            var _loc3_:Number = NaN;
            var _loc4_:Number = NaN;
            if(!this.body.IsSleeping())
            {
                if(this._firingAllowed)
                {
                    if(!this.firing)
                    {
                        this.fireEngine();
                    }
                    _loc1_ = this.body.GetAngle();
                    this.accelScaler += this.accelStep;
                    this.accelScaler = Math.min(1,this.accelScaler);
                    _loc2_ = this.power * this.accelScaler;
                    _loc3_ = Math.sin(_loc1_) * _loc2_;
                    _loc4_ = -Math.cos(_loc1_) * _loc2_;
                    this.body.ApplyImpulse(new b2Vec2(_loc3_,_loc4_),this.body.GetWorldCenter());
                    this.fireCount += 1;
                    if(this.fireCount > this.fireTotal)
                    {
                        this.mc.flames.visible = this.mc.lights.visible = false;
                        Settings.currentSession.level.removeFromActionsVector(this);
                        this.soundLoop.stopSound();
                    }
                }
                else
                {
                    if(this.firing)
                    {
                        this.firing = false;
                        this.mc.flames.visible = this.mc.lights.visible = false;
                        this.soundLoop.stopSound();
                    }
                    if(this.accelStep != 0)
                    {
                        this.accelScaler = Math.max(0,this.accelScaler - this.accelStep);
                    }
                }
            }
        }
        
        override public function getJointBody(param1:b2Vec2 = null) : b2Body
        {
            return this.body;
        }
        
        public function fireEngine() : void
        {
            var _loc1_:int = 0;
            this.firing = true;
            this.mc.flames.visible = this.mc.lights.visible = true;
            if(this.power < 4)
            {
                _loc1_ = 1;
            }
            else if(this.power < 8)
            {
                _loc1_ = 2;
            }
            else
            {
                _loc1_ = 3;
            }
            this.soundLoop = SoundController.instance.playAreaSoundLoop("Jet" + _loc1_,this.body,0,Math.random() * 1000);
            if(this.fadeTime > 0)
            {
                this.soundLoop.fadeIn(this.fadeTime);
            }
            else
            {
                this.soundLoop.maxVolume = 1;
            }
        }
        
        override public function singleAction() : void
        {
            var _loc1_:* = Settings.currentSession.level.actionsVector;
            var _loc2_:int = int(_loc1_.indexOf(this));
            if(_loc2_ > -1)
            {
                _loc1_.splice(_loc2_,1);
            }
            this.explode();
        }
        
        private function explode() : void
        {
            var _loc13_:b2Shape = null;
            var _loc14_:b2Body = null;
            var _loc15_:b2Vec2 = null;
            var _loc16_:b2Vec2 = null;
            var _loc17_:Number = NaN;
            var _loc18_:Number = NaN;
            var _loc19_:Number = NaN;
            var _loc20_:Number = NaN;
            var _loc21_:Number = NaN;
            var _loc22_:CharacterB2D = null;
            var _loc23_:NPCharacter = null;
            var _loc1_:Session = Settings.currentSession;
            var _loc2_:b2World = _loc1_.m_world;
            var _loc3_:MovieClip = new Explosion2();
            _loc3_.x = this.mc.x;
            _loc3_.y = this.mc.y;
            _loc3_.scaleX = _loc3_.scaleY = 0.5;
            if(Math.random() > 0.5)
            {
                _loc3_.scaleX *= -1;
            }
            _loc3_.rotation = this.body.GetAngle() * 180 / Math.PI;
            _loc1_.containerSprite.addChildAt(_loc3_,1);
            var _loc4_:ContactListener = _loc1_.contactListener;
            _loc2_.DestroyBody(this.body);
            this.mc.visible = false;
            var _loc5_:Array = new Array();
            var _loc6_:Number = 2.6;
            var _loc7_:b2AABB = new b2AABB();
            var _loc8_:b2Vec2 = this.body.GetWorldCenter();
            _loc7_.lowerBound.Set(_loc8_.x - _loc6_,_loc8_.y - _loc6_);
            _loc7_.upperBound.Set(_loc8_.x + _loc6_,_loc8_.y + _loc6_);
            var _loc9_:int = _loc2_.Query(_loc7_,_loc5_,30);
            var _loc10_:* = 5;
            var _loc11_:int = 0;
            while(_loc11_ < _loc5_.length)
            {
                _loc13_ = _loc5_[_loc11_];
                _loc14_ = _loc13_.GetBody();
                if(!_loc14_.IsStatic())
                {
                    _loc15_ = _loc14_.GetWorldCenter();
                    _loc16_ = new b2Vec2(_loc15_.x - _loc8_.x,_loc15_.y - _loc8_.y);
                    _loc17_ = _loc16_.Length();
                    _loc17_ = Math.min(_loc6_,_loc17_);
                    _loc18_ = 1 - _loc17_ / _loc6_;
                    _loc19_ = Math.atan2(_loc16_.y,_loc16_.x);
                    _loc20_ = Math.cos(_loc19_) * _loc18_ * _loc10_;
                    _loc21_ = Math.sin(_loc19_) * _loc18_ * _loc10_;
                    _loc14_.ApplyImpulse(new b2Vec2(_loc20_,_loc21_),_loc15_);
                    if(_loc13_.m_userData is CharacterB2D)
                    {
                        _loc22_ = _loc13_.m_userData as CharacterB2D;
                        _loc22_.explodeShape(_loc13_,_loc18_);
                    }
                    else if(_loc13_.m_userData is NPCharacter)
                    {
                        _loc23_ = _loc13_.m_userData as NPCharacter;
                        _loc23_.explodeShape(_loc13_,_loc18_);
                    }
                }
                _loc11_++;
            }
            if(this.soundLoop)
            {
                this.soundLoop.stopSound();
            }
            SoundController.instance.playAreaSoundInstance("MineExplosion",this.body);
            _loc1_.particleController.createBurst("metalpieces",10,50,this.body,25);
            var _loc12_:LevelB2D = _loc1_.level;
            _loc12_.removeFromPaintItemVector(this);
        }
        
        public function checkContact(param1:ContactEvent) : void
        {
            var _loc2_:LevelB2D = null;
            var _loc3_:ContactListener = null;
            if(param1.impulse > this.smash_impulse)
            {
                trace("jet impulse " + param1.impulse);
                _loc2_ = Settings.currentSession.level;
                _loc2_.singleActionVector.push(this);
                _loc3_ = Settings.currentSession.contactListener;
                _loc3_.deleteListener(ContactListener.RESULT,this.jetShape);
            }
        }
        
        public function get firingAllowed() : Boolean
        {
            return this._firingAllowed;
        }
        
        public function set firingAllowed(param1:Boolean) : void
        {
            this._firingAllowed = param1;
        }
        
        override public function triggerSingleActivation(param1:Trigger, param2:String, param3:Array) : void
        {
            if(this.body)
            {
                this.body.WakeUp();
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

