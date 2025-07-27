package com.totaljerkface.game.level.userspecials
{
    import Box2D.Collision.Shapes.*;
    import Box2D.Collision.b2AABB;
    import Box2D.Collision.b2ContactPoint;
    import Box2D.Collision.b2Segment;
    import Box2D.Common.Math.b2Math;
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
    import flash.utils.Dictionary;
    
    public class HomingMine extends LevelItem
    {
        private static const SENSOR_RADIUS:int = 600;
        
        private static const SLOWING_FACTOR:Number = 0.05;
        
        private static const EXPLOSION_DISTANCE:Number = Math.pow(0.48,2);
        
        private static const SMASH_IMPULSE:Number = 3;
        
        private static const GRAVITY_DISPLACEMENT:Number = -0.3333333333333333;
        
        private var laserSprite:Sprite;
        
        private var laserColor:uint;
        
        private var mc:HomingMineMC;
        
        private var mineBody:b2Body;
        
        private var targetingBody:b2Body;
        
        private var mineShape:b2Shape;
        
        private var rangeSensor:b2Shape;
        
        private var targetingSensor:b2Shape;
        
        private var target:b2Body;
        
        private var targetDictionary:Dictionary;
        
        private var pathClear:Boolean;
        
        private var inContact:Boolean;
        
        private var countingDown:Boolean;
        
        private var counter:int;
        
        private var retargetCount:int = 0;
        
        private var seekSpeed:Number;
        
        private var totalImpulseVector:b2Vec2;
        
        private var hoverLoop:AreaSoundLoop;
        
        private var beepLoop:AreaSoundLoop;
        
        public function HomingMine(param1:Special)
        {
            super();
            var _loc2_:HomingMineRef = param1 as HomingMineRef;
            this.createBodies(new b2Vec2(_loc2_.x,_loc2_.y));
            this.mc = new HomingMineMC();
            var _loc3_:Sprite = Settings.currentSession.level.background;
            _loc3_.addChild(this.mc);
            this.laserSprite = new Sprite();
            _loc3_.addChild(this.laserSprite);
            this.seekSpeed = _loc2_.seekSpeed * 0.01;
            this.counter = _loc2_.explosionDelay * 30;
            this.targetDictionary = new Dictionary();
            this.totalImpulseVector = new b2Vec2();
            var _loc4_:ContactListener = Settings.currentSession.contactListener;
            _loc4_.registerListener(ContactListener.ADD,this.rangeSensor,this.targetAdd);
            _loc4_.registerListener(ContactListener.REMOVE,this.rangeSensor,this.targetRemove);
            _loc4_.registerListener(ContactListener.RESULT,this.mineShape,this.mineResult);
            Settings.currentSession.level.paintItemVector.push(this);
            Settings.currentSession.level.actionsVector.push(this);
            var _loc5_:BevelFilter = new BevelFilter(5,90,16777215,1,0,1,5,5,1,3,"inner");
            Settings.currentSession.particleController.createBMDArray("metalpieces",new MetalPiecesMC(),[_loc5_]);
        }
        
        internal function createBodies(param1:b2Vec2) : void
        {
            var _loc2_:b2BodyDef = new b2BodyDef();
            _loc2_.allowSleep = false;
            _loc2_.position = new b2Vec2(param1.x / m_physScale,param1.y / m_physScale);
            var _loc3_:b2CircleDef = new b2CircleDef();
            _loc3_.density = 1;
            _loc3_.friction = 1;
            _loc3_.restitution = 0.1;
            _loc3_.filter.categoryBits = 8;
            _loc3_.radius = 10 / m_physScale;
            this.mineBody = Settings.currentSession.m_world.CreateBody(_loc2_);
            this.mineShape = this.mineBody.CreateShape(_loc3_);
            this.mineBody.SetMassFromShapes();
            _loc3_.filter.groupIndex = -20;
            _loc3_.isSensor = true;
            _loc3_.radius = SENSOR_RADIUS / m_physScale;
            this.rangeSensor = this.mineBody.CreateShape(_loc3_);
            this.targetingBody = Settings.currentSession.m_world.CreateBody(_loc2_);
            var _loc4_:b2PolygonDef = new b2PolygonDef();
            _loc4_.isSensor = true;
            _loc4_.density = 1;
            _loc4_.filter.categoryBits = 8;
            _loc4_.filter.groupIndex = -20;
            var _loc5_:Number = _loc3_.radius * 0.5;
            _loc4_.SetAsOrientedBox(2 / m_physScale,_loc5_,new b2Vec2(0,-_loc5_),0);
            this.targetingSensor = this.targetingBody.CreateShape(_loc4_);
            this.targetingBody.SetMassFromShapes();
            this.targetingBody.DestroyShape(this.targetingSensor);
            this.targetingSensor = null;
            this.mineBody.m_linearVelocity.y += -0.3333333333333333;
            this.targetingBody.m_linearVelocity.y += -0.3333333333333333;
        }
        
        override public function paint() : void
        {
            var _loc1_:b2Vec2 = this.mineBody.GetWorldCenter();
            this.mc.x = _loc1_.x * m_physScale;
            this.mc.y = _loc1_.y * m_physScale;
            var _loc2_:Number = this.mineBody.GetAngle();
            this.mc.rotation = _loc2_ * oneEightyOverPI % 360;
            var _loc3_:Number = this.totalImpulseVector.x * Math.cos(_loc2_) + this.totalImpulseVector.y * Math.sin(_loc2_);
            var _loc4_:Number = this.totalImpulseVector.x * Math.sin(_loc2_) - this.totalImpulseVector.y * Math.cos(_loc2_);
            _loc3_ += (Math.random() * _loc3_ - _loc3_ * 0.5) * 0.5;
            _loc4_ += (Math.random() * _loc4_ - _loc4_ * 0.5) * 0.5;
            this.mc.jet1.scaleX = this.mc.jet1.scaleY = _loc4_ < 0 ? Math.min(-_loc4_ / this.seekSpeed,2) : 0;
            this.mc.jet2.scaleX = this.mc.jet2.scaleY = _loc3_ < 0 ? Math.min(-_loc3_ / this.seekSpeed,2) : 0;
            this.mc.jet3.scaleX = this.mc.jet3.scaleY = _loc4_ > 0 ? Math.min(_loc4_ / this.seekSpeed,2) : 0;
            this.mc.jet4.scaleX = this.mc.jet4.scaleY = _loc3_ > 0 ? Math.min(_loc3_ / this.seekSpeed,2) : 0;
        }
        
        override public function actions() : void
        {
            var _loc5_:b2Vec2 = null;
            var _loc6_:b2Vec2 = null;
            var _loc7_:Number = NaN;
            var _loc8_:Number = NaN;
            var _loc9_:Number = NaN;
            var _loc10_:Number = NaN;
            var _loc11_:b2Vec2 = null;
            var _loc12_:b2Vec2 = null;
            var _loc13_:Number = NaN;
            var _loc14_:b2Vec2 = null;
            var _loc15_:Number = NaN;
            var _loc16_:Number = NaN;
            var _loc17_:Number = NaN;
            var _loc18_:Number = NaN;
            var _loc19_:Number = NaN;
            var _loc20_:b2Vec2 = null;
            if(this.countingDown)
            {
                --this.counter;
                if(this.counter <= 0)
                {
                    this.explode();
                    return;
                }
            }
            var _loc1_:b2Vec2 = this.mineBody.GetPosition();
            var _loc2_:b2Vec2 = this.mineBody.GetLinearVelocity();
            var _loc3_:Number = this.mineBody.GetAngularVelocity();
            if(!this.target)
            {
                if(this.targetingSensor)
                {
                    this.removeTargetingSensor();
                }
                this.findClosestTarget();
            }
            if(this.target)
            {
                _loc5_ = this.target.GetWorldCenter();
                _loc6_ = new b2Vec2(_loc5_.x - _loc1_.x,_loc5_.y - _loc1_.y);
                _loc7_ = _loc6_.LengthSquared();
                if(!this.countingDown && (_loc7_ < EXPLOSION_DISTANCE || this.inContact))
                {
                    if(this.counter <= 0)
                    {
                        this.explode();
                        return;
                    }
                    this.mc.light.gotoAndPlay(5);
                    this.countingDown = true;
                    this.beepLoop = SoundController.instance.playAreaSoundLoop("HomingMineBeep",this.mineBody);
                }
                _loc8_ = Math.atan2(_loc6_.y,_loc6_.x) + Math.PI * 0.5;
                this.targetingBody.SetXForm(_loc1_,_loc8_);
                if(this.pathClear)
                {
                    if(!this.countingDown)
                    {
                        this.mc.light.gotoAndStop(3);
                    }
                    if(!this.hoverLoop)
                    {
                        this.hoverLoop = SoundController.instance.playAreaSoundLoop("MineHover",this.mineBody);
                        SoundController.instance.playAreaSoundInstance("HomingMineFind",this.mineBody);
                    }
                    _loc11_ = _loc2_.Copy();
                    _loc11_.Multiply(0.03333333333333333);
                    _loc12_ = _loc6_.Copy();
                    _loc12_.Normalize();
                    _loc13_ = b2Math.b2Dot(_loc11_,_loc12_);
                    _loc14_ = new b2Vec2(-_loc12_.y,_loc12_.x);
                    _loc15_ = b2Math.b2Dot(_loc11_,_loc14_);
                    if(Math.abs(_loc15_) > this.seekSpeed)
                    {
                        if(_loc15_ > 0)
                        {
                            _loc9_ = _loc14_.x * -this.seekSpeed;
                            _loc10_ = _loc14_.y * -this.seekSpeed;
                        }
                        else
                        {
                            _loc9_ = _loc14_.x * this.seekSpeed;
                            _loc10_ = _loc14_.y * this.seekSpeed;
                        }
                    }
                    else
                    {
                        _loc16_ = _loc15_;
                        _loc17_ = this.seekSpeed;
                        _loc18_ = _loc16_ * _loc16_ + _loc17_ * _loc17_;
                        _loc19_ = Math.sqrt(_loc18_);
                        _loc20_ = _loc14_.Copy();
                        _loc20_.Multiply(-_loc16_);
                        _loc12_.Multiply(_loc19_);
                        _loc20_.Add(_loc12_);
                        _loc9_ = _loc20_.x;
                        _loc10_ = _loc20_.y;
                    }
                }
                else
                {
                    _loc9_ = -_loc2_.x * SLOWING_FACTOR / this.mineBody.m_invMass;
                    _loc10_ = -_loc2_.y * SLOWING_FACTOR / this.mineBody.m_invMass;
                    if(!this.countingDown)
                    {
                        this.mc.light.gotoAndStop(2);
                    }
                    if(this.hoverLoop)
                    {
                        this.hoverLoop.fadeOut(0.5);
                        this.hoverLoop = null;
                        SoundController.instance.playAreaSoundInstance("HomingMineLose",this.mineBody);
                    }
                }
                this.retargetCount += 1;
                if(this.retargetCount == 5)
                {
                    this.findClosestTarget();
                }
            }
            else
            {
                _loc9_ = -_loc2_.x * SLOWING_FACTOR / this.mineBody.m_invMass;
                _loc10_ = -_loc2_.y * SLOWING_FACTOR / this.mineBody.m_invMass;
                if(this.hoverLoop)
                {
                    this.hoverLoop.fadeOut(0.5);
                    this.hoverLoop = null;
                    SoundController.instance.playAreaSoundInstance("HomingMineLose",this.mineBody);
                }
            }
            this.pathClear = true;
            var _loc4_:Number = -_loc3_ * SLOWING_FACTOR / this.mineBody.m_invI;
            this.mineBody.m_linearVelocity.x += this.mineBody.m_invMass * _loc9_;
            this.mineBody.m_linearVelocity.y += this.mineBody.m_invMass * _loc10_;
            this.mineBody.m_angularVelocity += this.mineBody.m_invI * _loc4_;
            this.mineBody.m_linearVelocity.y += GRAVITY_DISPLACEMENT;
            this.targetingBody.m_linearVelocity.y += GRAVITY_DISPLACEMENT;
            this.totalImpulseVector.Set(_loc9_,_loc10_ - this.seekSpeed * 0.5);
        }
        
        override public function singleAction() : void
        {
            trace("SINGLE ACTION FUCK");
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
            var _loc22_:CharacterB2D = null;
            var _loc23_:NPCharacter = null;
            var _loc1_:Session = Settings.currentSession;
            var _loc2_:b2World = _loc1_.m_world;
            _loc3_ = new Explosion2();
            _loc3_.x = this.mc.x;
            _loc3_.y = this.mc.y;
            _loc3_.scaleX = _loc3_.scaleY = 0.5;
            if(Math.random() > 0.5)
            {
                _loc3_.scaleX *= -1;
            }
            _loc3_.rotation = this.mineBody.GetAngle() * 180 / Math.PI;
            _loc1_.containerSprite.addChildAt(_loc3_,1);
            if(this.targetingSensor)
            {
                this.removeTargetingSensor();
            }
            var _loc4_:ContactListener = _loc1_.contactListener;
            _loc4_.deleteListener(ContactListener.ADD,this.rangeSensor);
            _loc4_.deleteListener(ContactListener.REMOVE,this.rangeSensor);
            _loc4_.deleteListener(ContactListener.ADD,this.mineShape);
            _loc4_.deleteListener(ContactListener.RESULT,this.mineShape);
            _loc2_.DestroyBody(this.mineBody);
            _loc2_.DestroyBody(this.targetingBody);
            this.mc.visible = false;
            this.mc.light.gotoAndStop(1);
            var _loc5_:Array = new Array();
            var _loc6_:Number = 2.6;
            var _loc7_:b2AABB = new b2AABB();
            var _loc8_:b2Vec2 = this.mineBody.GetWorldCenter();
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
            if(this.hoverLoop)
            {
                this.hoverLoop.stopSound();
            }
            if(this.beepLoop)
            {
                this.beepLoop.stopSound();
            }
            SoundController.instance.playAreaSoundInstance("MineExplosion",this.mineBody);
            _loc1_.particleController.createBurst("metalpieces",10,50,this.mineBody,25);
            this.mineBody = null;
            var _loc12_:LevelB2D = _loc1_.level;
            _loc12_.removeFromPaintItemVector(this);
            _loc12_.removeFromActionsVector(this);
        }
        
        private function findClosestTarget() : void
        {
            var _loc3_:* = undefined;
            var _loc4_:b2Body = null;
            var _loc5_:b2Vec2 = null;
            var _loc6_:b2Vec2 = null;
            var _loc7_:Number = NaN;
            this.retargetCount = 0;
            var _loc1_:Number = 1000000;
            var _loc2_:b2Vec2 = this.mineBody.GetPosition();
            for(_loc3_ in this.targetDictionary)
            {
                _loc4_ = _loc3_ as b2Body;
                _loc5_ = _loc4_.GetWorldCenter();
                _loc6_ = new b2Vec2(_loc5_.x - _loc2_.x,_loc5_.y - _loc2_.y);
                _loc7_ = _loc6_.LengthSquared();
                if(_loc7_ < _loc1_)
                {
                    _loc1_ = _loc7_;
                    this.target = _loc4_;
                }
            }
            if(Boolean(this.target) && !this.targetingSensor)
            {
                this.createTargetSensor();
            }
        }
        
        private function mineResult(param1:ContactEvent) : void
        {
            var _loc2_:LevelB2D = null;
            var _loc3_:ContactListener = null;
            if(param1.impulse > SMASH_IMPULSE)
            {
                trace("homing mine impulse " + param1.impulse);
                _loc2_ = Settings.currentSession.level;
                _loc2_.singleActionVector.push(this);
                _loc3_ = Settings.currentSession.contactListener;
                _loc3_.deleteListener(ContactListener.ADD,this.mineShape);
                _loc3_.deleteListener(ContactListener.RESULT,this.mineShape);
            }
            else if(param1.otherShape.GetMaterial() & 2)
            {
                this.inContact = true;
            }
        }
        
        private function targetAdd(param1:b2ContactPoint) : void
        {
            var _loc2_:b2Body = null;
            var _loc3_:int = 0;
            if(param1.shape2.GetMaterial() & 2)
            {
                _loc2_ = param1.shape2.GetBody();
                if(this.targetDictionary[_loc2_])
                {
                    _loc3_ = int(this.targetDictionary[_loc2_]);
                    this.targetDictionary[_loc2_] = _loc3_ + 1;
                }
                else
                {
                    this.targetDictionary[_loc2_] = 1;
                }
            }
        }
        
        private function targetRemove(param1:b2ContactPoint) : void
        {
            var _loc2_:b2Body = null;
            var _loc3_:int = 0;
            if(param1.shape2.GetMaterial() & 2)
            {
                _loc2_ = param1.shape2.GetBody();
                if(this.targetDictionary[_loc2_])
                {
                    _loc3_ = int(this.targetDictionary[_loc2_]);
                    _loc3_--;
                    if(_loc3_ == 0)
                    {
                        delete this.targetDictionary[_loc2_];
                        if(this.target)
                        {
                            if(_loc2_ == this.target)
                            {
                                this.target = null;
                                if(!this.countingDown)
                                {
                                    this.mc.light.gotoAndStop(1);
                                }
                            }
                        }
                    }
                    else
                    {
                        this.targetDictionary[_loc2_] = _loc3_;
                    }
                }
            }
        }
        
        private function createTargetSensor() : void
        {
            var _loc1_:b2PolygonDef = new b2PolygonDef();
            _loc1_.isSensor = true;
            _loc1_.density = 1;
            _loc1_.filter.categoryBits = 8;
            _loc1_.filter.groupIndex = -20;
            var _loc2_:Number = SENSOR_RADIUS * 0.5 / m_physScale;
            _loc1_.SetAsOrientedBox(2 / m_physScale,_loc2_,new b2Vec2(0,-_loc2_),0);
            this.targetingSensor = this.targetingBody.CreateShape(_loc1_);
            var _loc3_:ContactListener = Settings.currentSession.contactListener;
            _loc3_.registerListener(ContactListener.ADD,this.targetingSensor,this.checkAdd);
            _loc3_.registerListener(ContactListener.PERSIST,this.targetingSensor,this.checkPersist);
            this.pathClear = false;
        }
        
        private function removeTargetingSensor() : void
        {
            var _loc1_:ContactListener = Settings.currentSession.contactListener;
            _loc1_.deleteListener(ContactListener.ADD,this.targetingSensor);
            _loc1_.deleteListener(ContactListener.PERSIST,this.targetingSensor);
            this.targetingBody.DestroyShape(this.targetingSensor);
            this.targetingSensor = null;
        }
        
        private function checkAdd(param1:b2ContactPoint) : void
        {
            if(!this.target)
            {
                this.pathClear = false;
                return;
            }
            var _loc2_:b2Shape = param1.shape2;
            var _loc3_:b2Body = _loc2_.m_body;
            var _loc4_:Number = _loc3_.GetMass();
            var _loc5_:Number = _loc2_.m_density;
            if(_loc2_.IsSensor())
            {
                return;
            }
            if(_loc4_ > 0 && _loc5_ < 10)
            {
                return;
            }
            var _loc6_:b2Vec2 = this.targetingBody.GetPosition();
            var _loc7_:b2Vec2 = this.target.GetWorldCenter();
            var _loc8_:b2Segment = new b2Segment();
            _loc8_.p1 = _loc6_;
            _loc8_.p2 = _loc7_;
            var _loc9_:Array = [];
            var _loc10_:b2Vec2 = new b2Vec2();
            var _loc11_:Boolean = _loc2_.TestSegment(_loc3_.m_xf,_loc9_,_loc10_,_loc8_,1);
            if(_loc11_)
            {
                this.pathClear = false;
            }
        }
        
        private function checkPersist(param1:b2ContactPoint) : void
        {
            if(!this.target)
            {
                this.pathClear = false;
                return;
            }
            var _loc2_:b2Shape = param1.shape2;
            var _loc3_:b2Body = _loc2_.m_body;
            var _loc4_:Number = _loc3_.GetMass();
            var _loc5_:Number = _loc2_.m_density;
            if(_loc2_.IsSensor())
            {
                return;
            }
            if(_loc4_ > 0 && _loc5_ < 10)
            {
                return;
            }
            var _loc6_:b2Vec2 = this.targetingBody.GetPosition();
            var _loc7_:b2Vec2 = this.target.GetWorldCenter();
            var _loc8_:b2Segment = new b2Segment();
            _loc8_.p1 = _loc6_;
            _loc8_.p2 = _loc7_;
            var _loc9_:Array = [];
            var _loc10_:b2Vec2 = new b2Vec2();
            var _loc11_:Boolean = _loc2_.TestSegment(_loc3_.m_xf,_loc9_,_loc10_,_loc8_,1);
            if(_loc11_)
            {
                this.pathClear = false;
            }
        }
        
        override public function triggerSingleActivation(param1:Trigger, param2:String, param3:Array) : void
        {
            var _loc4_:Vector.<LevelItem> = null;
            var _loc5_:int = 0;
            if(_triggered)
            {
                return;
            }
            _triggered = true;
            if(this.mineBody)
            {
                _loc4_ = Settings.currentSession.level.singleActionVector;
                _loc5_ = int(_loc4_.indexOf(this));
                if(_loc5_ > -1)
                {
                    return;
                }
                this.singleAction();
            }
        }
        
        override public function get bodyList() : Array
        {
            if(this.mineBody)
            {
                return [this.mineBody];
            }
            return [];
        }
    }
}

