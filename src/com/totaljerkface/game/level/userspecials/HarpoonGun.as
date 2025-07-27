package com.totaljerkface.game.level.userspecials
{
    import Box2D.Collision.Shapes.*;
    import Box2D.Collision.b2ContactPoint;
    import Box2D.Collision.b2Segment;
    import Box2D.Common.Math.b2Vec2;
    import Box2D.Dynamics.*;
    import Box2D.Dynamics.Joints.*;
    import com.totaljerkface.game.*;
    import com.totaljerkface.game.editor.specials.*;
    import com.totaljerkface.game.events.*;
    import com.totaljerkface.game.level.*;
    import com.totaljerkface.game.sound.SoundController;
    import flash.display.*;
    import flash.events.Event;
    import flash.geom.Point;
    import flash.utils.Dictionary;
    
    public class HarpoonGun extends LevelItem
    {
        private var mc:HarpoonGunMC;
        
        private var harpoon:Harpoon;
        
        private var laserSprite:Sprite;
        
        private var laserColor:uint;
        
        private var useAnchor:Boolean;
        
        private var anchorSprite:Sprite;
        
        private var fixedTurret:Boolean;
        
        private var turretAngle:Number;
        
        private var triggerFiring:Boolean;
        
        private var rangeSensor:b2Shape;
        
        private var targetSensor:b2Shape;
        
        private var targetAngle:Number;
        
        private var targetLength:Number;
        
        private var baseBody:b2Body;
        
        private var turretBody:b2Body;
        
        private var turretJoint:b2RevoluteJoint;
        
        private var targetBody:b2Body;
        
        private var targetDictionary:Dictionary;
        
        private var pathClear:Boolean;
        
        private var aligned:Boolean;
        
        private var anchorJoints:Array;
        
        private var disabled:Boolean;
        
        public function HarpoonGun(param1:Special, param2:b2Body = null, param3:Point = null)
        {
            super();
            var _loc4_:HarpoonGunRef = param1 as HarpoonGunRef;
            this.fixedTurret = _loc4_.fixedAngleTurret;
            this.turretAngle = _loc4_.turretAngle;
            this.triggerFiring = _loc4_.triggerFiring;
            this.disabled = _loc4_.startDeactivated;
            this.useAnchor = _loc4_.useAnchor;
            if(param2)
            {
                this.baseBody = param2;
            }
            var _loc5_:b2Vec2 = new b2Vec2(_loc4_.x,_loc4_.y);
            if(param3)
            {
                _loc5_.Add(new b2Vec2(param3.x,param3.y));
            }
            this.createBody(_loc5_,_loc4_.rotation * Math.PI / 180);
            this.mc = new HarpoonGunMC();
            this.mc.x = _loc4_.x;
            this.mc.y = _loc4_.y;
            this.mc.rotation = _loc4_.rotation;
            var _loc6_:Sprite = Settings.currentSession.level.background;
            this.anchorSprite = new Sprite();
            _loc6_.addChild(this.anchorSprite);
            _loc6_.addChild(this.mc);
            this.setLight();
            this.targetDictionary = new Dictionary();
            Settings.currentSession.level.paintItemVector.push(this);
        }
        
        private function createBody(param1:b2Vec2, param2:Number) : void
        {
            var _loc10_:ContactListener = null;
            var _loc3_:b2PolygonDef = new b2PolygonDef();
            _loc3_.friction = 0.5;
            _loc3_.restitution = 0.1;
            _loc3_.filter.categoryBits = 8;
            _loc3_.filter.groupIndex = -20;
            var _loc4_:Session = Settings.currentSession;
            _loc3_.SetAsOrientedBox(25 / m_physScale,16 / m_physScale,new b2Vec2(param1.x / m_physScale,param1.y / m_physScale),param2);
            _loc4_.level.levelBody.CreateShape(_loc3_) as b2PolygonShape;
            _loc3_.isSensor = true;
            _loc3_.SetAsOrientedBox(400 / m_physScale,200 / m_physScale,new b2Vec2((param1.x - Math.sin(param2) * -200) / m_physScale,(param1.y + Math.cos(param2) * -200) / m_physScale),param2);
            this.rangeSensor = _loc4_.level.levelBody.CreateShape(_loc3_);
            var _loc5_:b2Vec2 = (this.rangeSensor as b2PolygonShape).m_vertices[0];
            var _loc6_:b2BodyDef = new b2BodyDef();
            var _loc7_:b2Vec2 = new b2Vec2((param1.x - Math.sin(param2) * -35) / m_physScale,(param1.y + Math.cos(param2) * -35) / m_physScale);
            _loc6_.position = _loc7_;
            _loc6_.angle = param2;
            this.turretBody = _loc4_.m_world.CreateBody(_loc6_);
            var _loc8_:b2Vec2 = new b2Vec2(_loc5_.x - _loc7_.x,_loc5_.y - _loc7_.y);
            this.targetLength = _loc8_.Length() + 0.5;
            var _loc9_:b2RevoluteJointDef = new b2RevoluteJointDef();
            _loc9_.maxMotorTorque = 10000;
            _loc9_.collideConnected = true;
            _loc9_.Initialize(this.turretBody,_loc4_.level.levelBody,_loc7_);
            this.turretJoint = _loc4_.m_world.CreateJoint(_loc9_) as b2RevoluteJoint;
            if(this.useAnchor)
            {
                this.createAnchor();
            }
            if(this.fixedTurret)
            {
                _loc4_.level.levelBody.DestroyShape(this.rangeSensor);
                this.rangeSensor = null;
                this.turretBody.SetXForm(this.turretBody.GetPosition(),param2 + this.turretAngle / oneEightyOverPI);
                if(!this.triggerFiring)
                {
                    this.createTargetSensor(this.targetLength);
                    this.aligned = true;
                    this.pathClear = true;
                    Settings.currentSession.level.actionsVector.push(this);
                }
            }
            else
            {
                _loc10_ = Settings.currentSession.contactListener;
                _loc10_.registerListener(ContactListener.ADD,this.rangeSensor,this.targetAdd);
                _loc10_.registerListener(ContactListener.REMOVE,this.rangeSensor,this.targetRemove);
                Settings.currentSession.level.actionsVector.push(this);
            }
        }
        
        override public function actions() : void
        {
            var _loc2_:ContactListener = null;
            var _loc3_:b2Vec2 = null;
            var _loc4_:b2Vec2 = null;
            var _loc5_:Number = NaN;
            var _loc6_:Number = NaN;
            var _loc7_:Number = NaN;
            var _loc8_:Number = NaN;
            if(this.disabled)
            {
                return;
            }
            var _loc1_:b2Vec2 = this.turretBody.GetPosition();
            if(!this.targetBody)
            {
                if(Boolean(this.targetSensor) && !this.fixedTurret)
                {
                    this.removeTargetSensor();
                }
                this.findClosestTarget(_loc1_);
            }
            if(this.targetBody)
            {
                if(this.pathClear && this.aligned && !this.triggerFiring)
                {
                    _loc2_ = Settings.currentSession.contactListener;
                    if(this.fixedTurret)
                    {
                        this.fireHarpoon2();
                        _loc2_.deleteListener(ContactListener.REMOVE,this.targetSensor);
                    }
                    else
                    {
                        this.fireHarpoon();
                        _loc2_.deleteListener(ContactListener.ADD,this.rangeSensor);
                        _loc2_.deleteListener(ContactListener.REMOVE,this.rangeSensor);
                        Settings.currentSession.level.levelBody.DestroyShape(this.rangeSensor);
                    }
                    this.removeTargetSensor();
                    Settings.currentSession.level.removeFromActionsVector(this);
                }
                if(!this.fixedTurret)
                {
                    _loc3_ = this.targetBody.GetWorldCenter();
                    _loc4_ = new b2Vec2(_loc3_.x - _loc1_.x,_loc3_.y - _loc1_.y);
                    _loc5_ = Math.atan2(_loc4_.y,_loc4_.x) + Math.PI * 0.5;
                    this.aligned = false;
                    _loc6_ = this.turretBody.GetAngle();
                    _loc7_ = _loc6_ - _loc5_;
                    _loc8_ = Math.PI * 2;
                    if(_loc7_ > Math.PI)
                    {
                        _loc7_ -= _loc8_;
                    }
                    if(_loc7_ < -Math.PI)
                    {
                        _loc7_ += _loc8_;
                    }
                    if(Math.abs(_loc7_) > 0.52)
                    {
                        _loc5_ += _loc7_ * 0.5;
                    }
                    else
                    {
                        this.aligned = true;
                    }
                    this.turretBody.SetXForm(_loc1_,_loc5_);
                    this.turretBody.SetAngularVelocity(0);
                    this.turretBody.SetLinearVelocity(new b2Vec2(0,0));
                }
            }
            this.pathClear = true;
        }
        
        private function findClosestTarget(param1:b2Vec2) : void
        {
            var _loc3_:* = undefined;
            var _loc4_:b2Body = null;
            var _loc5_:b2Vec2 = null;
            var _loc6_:b2Vec2 = null;
            var _loc7_:Number = NaN;
            var _loc2_:Number = 1000000;
            for(_loc3_ in this.targetDictionary)
            {
                _loc4_ = _loc3_ as b2Body;
                _loc5_ = _loc4_.GetWorldCenter();
                _loc6_ = new b2Vec2(_loc5_.x - param1.x,_loc5_.y - param1.y);
                _loc7_ = _loc6_.LengthSquared();
                if(_loc7_ < _loc2_)
                {
                    _loc2_ = _loc7_;
                    this.targetBody = _loc4_;
                }
            }
            if(Boolean(this.targetBody) && !this.fixedTurret)
            {
                this.createTargetSensor(this.targetLength);
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
        
        private function targetAdd2(param1:b2ContactPoint) : void
        {
            this.targetAdd(param1);
            this.checkAdd(param1);
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
                        if(this.targetBody)
                        {
                            if(_loc2_ == this.targetBody)
                            {
                                this.targetBody = null;
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
        
        private function createTargetSensor(param1:Number) : void
        {
            var _loc2_:b2PolygonDef = new b2PolygonDef();
            _loc2_.isSensor = true;
            _loc2_.density = 1;
            _loc2_.filter.categoryBits = 8;
            _loc2_.filter.groupIndex = -20;
            var _loc3_:Number = param1 * 0.5;
            _loc2_.SetAsOrientedBox(2 / m_physScale,_loc3_,new b2Vec2(0,-_loc3_),0);
            this.targetSensor = this.turretBody.CreateShape(_loc2_);
            var _loc4_:ContactListener = Settings.currentSession.contactListener;
            if(this.fixedTurret)
            {
                _loc4_.registerListener(ContactListener.ADD,this.targetSensor,this.targetAdd2);
                _loc4_.registerListener(ContactListener.REMOVE,this.targetSensor,this.targetRemove);
                _loc4_.registerListener(ContactListener.PERSIST,this.targetSensor,this.checkPersist);
            }
            else
            {
                this.turretBody.SetMassFromShapes();
                _loc4_.registerListener(ContactListener.ADD,this.targetSensor,this.checkAdd);
                _loc4_.registerListener(ContactListener.PERSIST,this.targetSensor,this.checkPersist);
            }
            this.pathClear = false;
            this.turretJoint.EnableMotor(false);
        }
        
        private function removeTargetSensor() : void
        {
            var _loc1_:ContactListener = Settings.currentSession.contactListener;
            _loc1_.deleteListener(ContactListener.ADD,this.targetSensor);
            _loc1_.deleteListener(ContactListener.PERSIST,this.targetSensor);
            this.turretBody.DestroyShape(this.targetSensor);
            this.targetSensor = null;
            this.turretJoint.SetMotorSpeed(0);
            this.turretJoint.EnableMotor(true);
        }
        
        private function checkAdd(param1:b2ContactPoint) : void
        {
            if(!this.targetBody)
            {
                if(!this.fixedTurret)
                {
                    this.pathClear = false;
                }
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
            var _loc6_:b2Vec2 = this.turretBody.GetPosition();
            var _loc7_:b2Vec2 = this.targetBody.GetWorldCenter();
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
            if(!this.targetBody)
            {
                if(!this.fixedTurret)
                {
                    this.pathClear = false;
                }
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
            var _loc6_:b2Vec2 = this.turretBody.GetPosition();
            var _loc7_:b2Vec2 = this.targetBody.GetWorldCenter();
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
        
        private function fireHarpoon() : void
        {
            trace("FIRE HARPOON");
            var _loc1_:Number = 2000 / m_physScale;
            var _loc2_:b2Vec2 = this.targetBody.GetLinearVelocity();
            var _loc3_:b2Vec2 = this.targetBody.GetWorldCenter();
            var _loc4_:b2Vec2 = this.turretBody.GetPosition();
            var _loc5_:Number = Math.pow(_loc2_.x,2) + Math.pow(_loc2_.y,2) - Math.pow(_loc1_,2);
            var _loc6_:Number = 2 * (_loc2_.x * (_loc3_.x - _loc4_.x) + _loc2_.y * (_loc3_.y - _loc4_.y));
            var _loc7_:Number = Math.pow(_loc3_.x - _loc4_.x,2) + Math.pow(_loc3_.y - _loc4_.y,2);
            var _loc8_:Number = Math.pow(_loc6_,2) - 4 * _loc5_ * _loc7_;
            if(_loc8_ < 0)
            {
                return;
            }
            var _loc9_:Number = (-_loc6_ + Math.sqrt(_loc8_)) / (2 * _loc5_);
            var _loc10_:Number = (-_loc6_ - Math.sqrt(_loc8_)) / (2 * _loc5_);
            _loc9_ = _loc9_ < 0 ? 10000 : _loc9_;
            _loc10_ = _loc10_ < 0 ? 10000 : _loc10_;
            var _loc11_:Number = Math.min(_loc9_,_loc10_);
            if(_loc11_ == 10000)
            {
                trace("t " + _loc11_);
            }
            var _loc12_:Number = _loc11_ * _loc2_.x + _loc3_.x;
            var _loc13_:Number = _loc11_ * _loc2_.y + _loc3_.y;
            var _loc14_:b2Vec2 = this.targetBody.GetWorldCenter();
            var _loc15_:b2Vec2 = new b2Vec2(_loc12_ - _loc4_.x,_loc13_ - _loc4_.y);
            var _loc16_:Number = Math.atan2(_loc15_.y,_loc15_.x);
            var _loc17_:b2Vec2 = new b2Vec2(_loc1_ * Math.cos(_loc16_),_loc1_ * Math.sin(_loc16_));
            this.mc.turret.harpoon.visible = false;
            this.harpoon = new Harpoon(_loc4_,_loc16_,_loc17_);
            SoundController.instance.playAreaSoundInstance("HarpoonFire",this.harpoon.harpoonBody);
            if(!this.useAnchor)
            {
                return;
            }
            var _loc18_:b2DistanceJoint = this.anchorJoints[this.anchorJoints.length - 1];
            _loc18_.m_localAnchor2 = new b2Vec2(-20 / m_physScale,0);
            _loc18_.m_body2 = this.harpoon.harpoonBody;
            this.harpoon.addEventListener(Harpoon.HIT,this.harpoonHit,false,0,true);
        }
        
        private function fireHarpoon2() : void
        {
            trace("FIRE HARPOON 2");
            var _loc1_:Number = 2000 / m_physScale;
            var _loc2_:b2Vec2 = this.turretBody.GetPosition();
            var _loc3_:b2Vec2 = this.turretBody.GetWorldPoint(new b2Vec2(0,-10));
            var _loc4_:b2Vec2 = new b2Vec2(_loc3_.x - _loc2_.x,_loc3_.y - _loc2_.y);
            var _loc5_:Number = Math.atan2(_loc4_.y,_loc4_.x);
            var _loc6_:b2Vec2 = new b2Vec2(_loc1_ * Math.cos(_loc5_),_loc1_ * Math.sin(_loc5_));
            this.mc.turret.harpoon.visible = false;
            this.harpoon = new Harpoon(_loc2_,_loc5_,_loc6_,this.fixedTurret);
            SoundController.instance.playAreaSoundInstance("HarpoonFire",this.harpoon.harpoonBody);
            this.targetDictionary = new Dictionary();
            this.targetBody = null;
            if(!this.useAnchor)
            {
                return;
            }
            var _loc7_:b2DistanceJoint = this.anchorJoints[this.anchorJoints.length - 1];
            _loc7_.m_localAnchor2 = new b2Vec2(-20 / m_physScale,0);
            _loc7_.m_body2 = this.harpoon.harpoonBody;
            this.harpoon.addEventListener(Harpoon.HIT,this.harpoonHit,false,0,true);
        }
        
        private function createAnchor() : void
        {
            var _loc11_:b2Body = null;
            var _loc12_:b2Body = null;
            var _loc13_:b2Vec2 = null;
            var _loc14_:b2Vec2 = null;
            var _loc17_:b2DistanceJoint = null;
            var _loc1_:b2Vec2 = this.turretBody.GetWorldPoint(new b2Vec2(0,-50 / m_physScale));
            var _loc2_:b2Vec2 = this.turretBody.GetWorldPoint(new b2Vec2(-21.5 / m_physScale,17 / m_physScale));
            var _loc3_:b2BodyDef = new b2BodyDef();
            var _loc4_:b2CircleDef = new b2CircleDef();
            _loc4_.friction = 0.5;
            _loc4_.restitution = 0.1;
            _loc4_.filter.categoryBits = 8;
            _loc4_.filter.groupIndex = -20;
            _loc4_.density = 0.25;
            _loc4_.radius = 2.5 / m_physScale;
            var _loc5_:b2World = Settings.currentSession.m_world;
            var _loc6_:int = 8;
            var _loc7_:Number = new b2Vec2(_loc1_.x - _loc2_.x,_loc1_.y - _loc2_.y).Length();
            var _loc8_:Number = _loc7_ * 1.25 / _loc6_;
            var _loc9_:Number = (_loc1_.x - _loc2_.x) / _loc6_;
            var _loc10_:Number = (_loc1_.y - _loc2_.y) / _loc6_;
            var _loc15_:b2DistanceJointDef = new b2DistanceJointDef();
            this.anchorJoints = new Array();
            var _loc16_:int = 0;
            while(_loc16_ < _loc6_)
            {
                _loc11_ = _loc16_ == 0 ? Settings.currentSession.level.levelBody : _loc12_;
                if(_loc16_ == 0)
                {
                    _loc11_ = Settings.currentSession.level.levelBody;
                    _loc13_ = _loc2_.Copy();
                }
                else
                {
                    _loc11_ = _loc12_;
                    _loc13_ = _loc11_.GetWorldCenter();
                }
                if(_loc16_ < _loc6_ - 1)
                {
                    _loc2_.Add(new b2Vec2(_loc9_,_loc10_));
                    _loc3_.position = _loc2_;
                    _loc12_ = _loc5_.CreateBody(_loc3_);
                    _loc12_.CreateShape(_loc4_);
                    _loc12_.SetMassFromShapes();
                    _loc14_ = _loc2_.Copy();
                }
                else
                {
                    _loc12_ = this.turretBody;
                    _loc14_ = _loc1_;
                }
                _loc15_.Initialize(_loc11_,_loc12_,_loc13_,_loc14_);
                _loc15_.length = _loc8_;
                _loc17_ = _loc5_.CreateJoint(_loc15_) as b2DistanceJoint;
                this.anchorJoints.push(_loc17_);
                _loc16_++;
            }
        }
        
        private function harpoonHit(param1:Event) : void
        {
            var _loc4_:b2DistanceJoint = null;
            this.harpoon.removeEventListener(Harpoon.HIT,this.harpoonHit);
            var _loc2_:int = int(this.anchorJoints.length);
            var _loc3_:int = 0;
            while(_loc3_ < this.anchorJoints.length - 1)
            {
                _loc4_ = this.anchorJoints[_loc3_];
                _loc4_.m_body2.m_shapeList.m_density = 10;
                _loc4_.m_body2.SetMassFromShapes();
                _loc3_++;
            }
        }
        
        override public function paint() : void
        {
            var _loc1_:int = 0;
            var _loc2_:b2DistanceJoint = null;
            var _loc3_:b2Vec2 = null;
            var _loc4_:int = 0;
            this.mc.turret.rotation = this.turretBody.GetAngle() * 180 / Math.PI - this.mc.rotation;
            if(this.anchorJoints)
            {
                _loc1_ = int(this.anchorJoints.length);
                this.anchorSprite.graphics.clear();
                this.anchorSprite.graphics.lineStyle(1);
                _loc2_ = this.anchorJoints[0];
                _loc3_ = _loc2_.GetAnchor1();
                this.anchorSprite.graphics.moveTo(_loc3_.x * m_physScale,_loc3_.y * m_physScale);
                _loc4_ = 0;
                while(_loc4_ < _loc1_)
                {
                    _loc2_ = this.anchorJoints[_loc4_];
                    _loc3_ = _loc2_.GetAnchor2();
                    this.anchorSprite.graphics.lineTo(_loc3_.x * m_physScale,_loc3_.y * m_physScale);
                    _loc4_++;
                }
            }
        }
        
        override public function triggerSingleActivation(param1:Trigger, param2:String, param3:Array) : void
        {
            var _loc4_:ContactListener = null;
            if(param2 == "fire harpoon")
            {
                if(!this.harpoon && !this.disabled)
                {
                    this.fireHarpoon2();
                    _loc4_ = Settings.currentSession.contactListener;
                    if(this.targetSensor)
                    {
                        _loc4_.deleteListener(ContactListener.REMOVE,this.targetSensor);
                        this.removeTargetSensor();
                    }
                    if(this.rangeSensor)
                    {
                        _loc4_.deleteListener(ContactListener.ADD,this.rangeSensor);
                        _loc4_.deleteListener(ContactListener.REMOVE,this.rangeSensor);
                        Settings.currentSession.level.levelBody.DestroyShape(this.rangeSensor);
                    }
                    Settings.currentSession.level.removeFromActionsVector(this);
                }
            }
            else if(param2 == "deactivate")
            {
                this.disabled = true;
                this.setLight();
            }
            else if(param2 == "activate")
            {
                this.disabled = false;
                this.setLight();
            }
        }
        
        private function setLight() : void
        {
            if(this.disabled)
            {
                this.mc.turret.light.gotoAndStop(4);
            }
            else if(this.triggerFiring)
            {
                this.mc.turret.light.gotoAndStop(3);
            }
            else if(this.fixedTurret)
            {
                this.mc.turret.light.gotoAndStop(2);
            }
            else
            {
                this.mc.turret.light.gotoAndStop(1);
            }
        }
    }
}

