package com.totaljerkface.game.level.userspecials
{
    import Box2D.Collision.Shapes.b2PolygonDef;
    import Box2D.Collision.Shapes.b2Shape;
    import Box2D.Collision.b2ContactPoint;
    import Box2D.Common.Math.b2Vec2;
    import Box2D.Dynamics.Joints.b2Joint;
    import Box2D.Dynamics.Joints.b2PrismaticJoint;
    import Box2D.Dynamics.Joints.b2PrismaticJointDef;
    import Box2D.Dynamics.b2Body;
    import Box2D.Dynamics.b2BodyDef;
    import Box2D.Dynamics.b2World;
    import com.totaljerkface.game.ContactListener;
    import com.totaljerkface.game.Session;
    import com.totaljerkface.game.Settings;
    import com.totaljerkface.game.character.CharacterB2D;
    import com.totaljerkface.game.editor.specials.BladeWeaponRef;
    import com.totaljerkface.game.editor.specials.Special;
    import com.totaljerkface.game.level.LevelB2D;
    import com.totaljerkface.game.level.LevelItem;
    import com.totaljerkface.game.level.Trigger;
    import com.totaljerkface.game.sound.AreaSoundInstance;
    import com.totaljerkface.game.sound.SoundController;
    import flash.display.*;
    import flash.events.Event;
    import flash.geom.ColorTransform;
    import flash.geom.Matrix;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.utils.Dictionary;
    import flash.utils.getDefinitionByName;
    
    public class BladeWeapon extends LevelItem
    {
        public var mc:BladeWeaponMC;
        
        public var weaponBody:b2Body;
        
        private var sensorShape:b2Shape;
        
        private var solidShape:b2Shape;
        
        private var handleShape:b2Shape;
        
        private var previousBody:b2Body;
        
        private var add:Boolean;
        
        private var remove:Boolean;
        
        private var bodiesToAdd:Array;
        
        private var bodiesToRemove:Array;
        
        private var bjDictionary:Dictionary;
        
        private var countDictionary:Dictionary;
        
        private var bladeAngle:Number;
        
        private var fleshSound:AreaSoundInstance;
        
        private var solidSound:AreaSoundInstance;
        
        private var bloodOffset:b2Vec2;
        
        private var bladeOffset:b2Vec2;
        
        private var weaponPosOffset:b2Vec2;
        
        private var weaponAngleOffset:Number = 0;
        
        protected var maskSprite:Sprite;
        
        protected var bitmap:Bitmap;
        
        protected var bmd:BitmapData;
        
        public function BladeWeapon(param1:Special, param2:b2Body = null, param3:Point = null)
        {
            var _loc4_:BladeWeaponRef = null;
            var _loc5_:Class = null;
            this.bladeOffset = new b2Vec2(0,0);
            this.weaponPosOffset = new b2Vec2(0,0);
            super();
            _loc4_ = param1 as BladeWeaponRef;
            this.mc = new BladeWeaponMC();
            _loc5_ = getDefinitionByName("BladeMask" + _loc4_.bladeWeaponType) as Class;
            this.maskSprite = new _loc5_();
            this.mc.gotoAndStop(_loc4_.bladeWeaponType);
            this.mc.x = _loc4_.x;
            this.mc.y = _loc4_.y;
            this.mc.rotation = _loc4_.rotation;
            this.setupMC();
            if(_loc4_.reverse)
            {
                this.mc.scaleX *= -1;
            }
            var _loc6_:Sprite = Settings.currentSession.level.background;
            _loc6_.addChild(this.mc);
            if(!_loc4_.interactive)
            {
                return;
            }
            this.mc.visible = false;
            this.bloodOffset = new b2Vec2();
            if(param2)
            {
                this.weaponBody = param2;
            }
            var _loc7_:b2Vec2 = new b2Vec2(_loc4_.x,_loc4_.y);
            if(param3)
            {
                _loc7_.Add(new b2Vec2(param3.x,param3.y));
                this.bloodOffset = new b2Vec2(param3.x,param3.y);
            }
            this.createBody(_loc4_,_loc7_);
            this.bodiesToAdd = new Array();
            this.bodiesToRemove = new Array();
            this.bjDictionary = new Dictionary();
            this.countDictionary = new Dictionary();
            var _loc8_:ContactListener = Settings.currentSession.contactListener;
            _loc8_.registerListener(ContactListener.ADD,this.sensorShape,this.checkAdd);
            _loc8_.registerListener(ContactListener.REMOVE,this.sensorShape,this.checkRemove);
            var _loc9_:LevelB2D = Settings.currentSession.level;
            _loc9_.singleActionVector.push(this);
            _loc9_.actionsVector.push(this);
            if(!param2)
            {
                _loc9_.paintItemVector.push(this);
            }
        }
        
        private function setupMC() : void
        {
        }
        
        private function createBody(param1:BladeWeaponRef, param2:b2Vec2) : void
        {
            var _loc10_:Matrix = null;
            var _loc11_:Number = NaN;
            var _loc12_:b2BodyDef = null;
            var _loc3_:LevelB2D = Settings.currentSession.level;
            var _loc4_:b2World = Settings.currentSession.m_world;
            var _loc5_:Sprite = _loc3_.background;
            var _loc6_:Number = param1.rotation * Math.PI / 180;
            var _loc7_:MovieClip = new BladeWeaponShapesMC();
            _loc7_.gotoAndStop(param1.bladeWeaponType);
            var _loc8_:b2PolygonDef = new b2PolygonDef();
            _loc8_.friction = 0.75;
            _loc8_.restitution = 0.1;
            _loc8_.filter.categoryBits = 8;
            _loc8_.density = 0.5;
            _loc8_.isSensor = true;
            var _loc9_:int = param1.reverse ? -1 : 1;
            _loc7_.blade.x *= _loc9_;
            _loc7_.handle.x *= _loc9_;
            _loc7_.blade.rotation *= _loc9_;
            if(this.weaponBody)
            {
                _loc10_ = new Matrix();
                _loc10_.rotate(_loc7_.blade.rotation * Math.PI / 180);
                _loc10_.translate(_loc7_.blade.x / m_physScale,_loc7_.blade.y / m_physScale);
                _loc10_.rotate(_loc6_);
                _loc10_.translate(param2.x / m_physScale,param2.y / m_physScale);
                _loc11_ = (_loc7_.blade.rotation + param1.rotation) * Math.PI / 180;
                this.bladeOffset = new b2Vec2(_loc10_.tx,_loc10_.ty);
                _loc8_.SetAsOrientedBox(_loc7_.blade.scaleX * 100 / 2 / m_physScale,_loc7_.blade.scaleY * 100 / 2 / m_physScale,this.bladeOffset,_loc11_);
                this.sensorShape = this.weaponBody.CreateShape(_loc8_);
                _loc8_.filter.maskBits = 8;
                _loc8_.isSensor = false;
                this.solidShape = this.weaponBody.CreateShape(_loc8_);
                _loc8_.filter.maskBits = 65535;
                this.bladeAngle = this.weaponBody.GetAngle() + _loc11_;
                _loc10_ = new Matrix();
                _loc10_.rotate(_loc7_.handle.rotation * Math.PI / 180);
                _loc10_.translate(_loc7_.handle.x / m_physScale,_loc7_.handle.y / m_physScale);
                _loc10_.rotate(_loc6_);
                _loc10_.translate(param2.x / m_physScale,param2.y / m_physScale);
                _loc11_ = (_loc7_.handle.rotation + param1.rotation) * Math.PI / 180;
                this.weaponAngleOffset = _loc11_;
                this.weaponPosOffset = new b2Vec2(_loc10_.tx,_loc10_.ty);
                _loc8_.SetAsOrientedBox(_loc7_.handle.scaleX * 100 / 2 / m_physScale,_loc7_.handle.scaleY * 100 / 2 / m_physScale,new b2Vec2(_loc10_.tx,_loc10_.ty),_loc11_);
                this.handleShape = this.weaponBody.CreateShape(_loc8_);
            }
            else
            {
                _loc12_ = new b2BodyDef();
                _loc12_.position = new b2Vec2(param2.x / m_physScale,param2.y / m_physScale);
                _loc12_.angle = _loc6_;
                _loc12_.isSleeping = param1.sleeping;
                this.weaponBody = _loc4_.CreateBody(_loc12_);
                this.bladeOffset = new b2Vec2(_loc7_.blade.x / m_physScale,_loc7_.blade.y / m_physScale);
                _loc8_.SetAsOrientedBox(_loc7_.blade.scaleX * 100 / 2 / m_physScale,_loc7_.blade.scaleY * 100 / 2 / m_physScale,this.bladeOffset,_loc7_.blade.rotation * Math.PI / 180);
                this.sensorShape = this.weaponBody.CreateShape(_loc8_);
                _loc8_.filter.maskBits = 8;
                _loc8_.isSensor = false;
                this.solidShape = this.weaponBody.CreateShape(_loc8_);
                _loc8_.filter.maskBits = 65535;
                this.bladeAngle = _loc6_ + _loc7_.blade.rotation * Math.PI / 180;
                _loc8_.SetAsOrientedBox(_loc7_.handle.scaleX * 100 / 2 / m_physScale,_loc7_.handle.scaleY * 100 / 2 / m_physScale,new b2Vec2(_loc7_.handle.x / m_physScale,_loc7_.handle.y / m_physScale));
                this.handleShape = this.weaponBody.CreateShape(_loc8_);
                this.weaponBody.SetMassFromShapes();
                this.weaponBody.SetUserData(this.mc);
            }
        }
        
        private function checkAdd(param1:b2ContactPoint) : void
        {
            var _loc2_:b2Body = param1.shape2.GetBody();
            if(!(param1.shape2.GetMaterial() & 6) && _loc2_.GetMass() != 0)
            {
                return;
            }
            if(param1.shape2.IsSensor() || _loc2_.GetMass() == 0)
            {
                return;
            }
            this.bodiesToAdd.push(_loc2_);
            this.add = true;
        }
        
        private function checkRemove(param1:b2ContactPoint) : void
        {
            var _loc2_:b2Body = param1.shape2.GetBody();
            if(!(param1.shape2.GetMaterial() & 6) && _loc2_.GetMass() != 0)
            {
                return;
            }
            if(param1.shape2.IsSensor())
            {
                return;
            }
            if(Boolean(this.bjDictionary[_loc2_]) || this.bodiesToAdd.indexOf(_loc2_) > -1)
            {
                this.bodiesToRemove.push(_loc2_);
                this.remove = true;
            }
        }
        
        private function createPrisJoint(param1:b2Body) : void
        {
            var _loc3_:* = undefined;
            var _loc9_:CharacterB2D = null;
            var _loc10_:NPCharacter = null;
            var _loc11_:int = 0;
            var _loc12_:ContactListener = null;
            var _loc13_:String = null;
            var _loc14_:int = 0;
            var _loc15_:b2Vec2 = null;
            var _loc16_:FoodItem = null;
            var _loc17_:int = 0;
            var _loc18_:Number = NaN;
            var _loc2_:b2Shape = param1.GetShapeList();
            _loc3_ = _loc2_.GetUserData();
            if(_loc3_ is CharacterB2D)
            {
                _loc9_ = _loc3_ as CharacterB2D;
                _loc9_.shapeImpale(_loc2_);
            }
            else if(_loc3_ is NPCharacter)
            {
                _loc10_ = _loc3_ as NPCharacter;
                _loc10_.shapeImpale(_loc2_);
            }
            if(this.bjDictionary[param1])
            {
                _loc11_ = int(this.countDictionary[param1]);
                this.countDictionary[param1] = _loc11_ + 1;
                return;
            }
            var _loc4_:Session = Settings.currentSession;
            var _loc5_:b2PrismaticJointDef = new b2PrismaticJointDef();
            var _loc6_:b2Vec2 = this.weaponBody.GetWorldCenter();
            var _loc7_:Number = this.weaponBody.GetAngle() - this.bladeAngle + Math.PI / 2;
            var _loc8_:b2Vec2 = new b2Vec2(Math.cos(_loc7_),Math.sin(_loc7_));
            _loc5_.Initialize(this.weaponBody,param1,_loc6_,_loc8_);
            _loc5_.enableLimit = true;
            _loc5_.upperTranslation = 0;
            _loc5_.lowerTranslation = 0;
            _loc5_.collideConnected = true;
            _loc5_.enableMotor = true;
            _loc5_.maxMotorForce = 100000;
            _loc5_.motorSpeed = 0;
            this.bjDictionary[param1] = _loc4_.m_world.CreateJoint(_loc5_) as b2PrismaticJoint;
            this.countDictionary[param1] = 1;
            if(!this.previousBody)
            {
                _loc12_ = _loc4_.contactListener;
            }
            if(param1 == this.previousBody)
            {
                return;
            }
            this.previousBody = param1;
            if(_loc2_.GetMaterial() & 6)
            {
                _loc3_ = _loc2_.GetUserData();
                if(_loc3_ is CharacterB2D)
                {
                    _loc14_ = 50;
                    _loc9_ = _loc3_ as CharacterB2D;
                    _loc9_.shapeImpale(_loc2_,true,_loc6_,0.01);
                    _loc15_ = param1.GetWorldCenter();
                    _loc4_.particleController.createPointBloodBurst(_loc15_.x * m_physScale,_loc15_.y * m_physScale,5,15,_loc14_);
                }
                else if(_loc3_ is NPCharacter)
                {
                    _loc14_ = 50;
                    _loc10_ = _loc3_ as NPCharacter;
                    _loc10_.shapeImpale(_loc2_,true);
                    _loc15_ = param1.GetWorldCenter();
                    _loc4_.particleController.createPointBloodBurst(_loc15_.x * m_physScale,_loc15_.y * m_physScale,5,15,_loc14_);
                }
                else if(_loc3_ is FoodItem)
                {
                    _loc16_ = _loc3_ as FoodItem;
                    _loc13_ = _loc16_.particleType;
                    _loc14_ = 25;
                    _loc15_ = param1.GetWorldCenter();
                    _loc4_.particleController.createPointBurst(_loc13_,_loc15_.x * m_physScale,_loc15_.y * m_physScale,5,15,_loc14_);
                }
                this.paintBlood(_loc15_.x * m_physScale,_loc15_.y * m_physScale,_loc16_);
                if(!this.fleshSound)
                {
                    _loc17_ = Math.ceil(Math.random() * 3);
                    this.fleshSound = SoundController.instance.playAreaSoundInstance("BladeFlesh" + _loc17_,this.weaponBody);
                    if(this.fleshSound)
                    {
                        this.fleshSound.addEventListener(AreaSoundInstance.AREA_SOUND_STOP,this.fleshSoundStopped,false,0,true);
                    }
                }
            }
            else
            {
                _loc18_ = this.weaponBody.GetLinearVelocity().LengthSquared();
                if(!this.solidSound && _loc18_ > 9)
                {
                    _loc17_ = Math.ceil(Math.random() * 3);
                    this.solidSound = SoundController.instance.playAreaSoundInstance("BladeSolid" + _loc17_,this.weaponBody);
                    if(this.solidSound)
                    {
                        this.solidSound.addEventListener(AreaSoundInstance.AREA_SOUND_STOP,this.solidSoundStopped,false,0,true);
                    }
                }
            }
        }
        
        override public function actions() : void
        {
            var _loc1_:int = 0;
            if(this.add)
            {
                _loc1_ = 0;
                while(_loc1_ < this.bodiesToAdd.length)
                {
                    this.createPrisJoint(this.bodiesToAdd[_loc1_]);
                    _loc1_++;
                }
                this.bodiesToAdd = new Array();
                this.add = false;
            }
            if(this.remove)
            {
                _loc1_ = 0;
                while(_loc1_ < this.bodiesToRemove.length)
                {
                    this.removeJoint(this.bodiesToRemove[_loc1_]);
                    _loc1_++;
                }
                this.bodiesToRemove = new Array();
                this.remove = false;
            }
        }
        
        override public function singleAction() : void
        {
            if(!this.mc.visible)
            {
                this.mc.visible = true;
            }
        }
        
        private function fleshSoundStopped(param1:Event) : void
        {
            this.fleshSound.removeEventListener(AreaSoundInstance.AREA_SOUND_STOP,this.fleshSoundStopped);
            this.fleshSound = null;
        }
        
        private function solidSoundStopped(param1:Event) : void
        {
            this.solidSound.removeEventListener(AreaSoundInstance.AREA_SOUND_STOP,this.solidSoundStopped);
            this.solidSound = null;
        }
        
        private function removeJoint(param1:b2Body) : void
        {
            var _loc3_:b2Joint = null;
            var _loc2_:int = int(this.countDictionary[param1]);
            _loc2_--;
            if(_loc2_ == 0)
            {
                _loc3_ = this.bjDictionary[param1];
                Settings.currentSession.m_world.DestroyJoint(_loc3_);
                delete this.bjDictionary[param1];
                delete this.countDictionary[param1];
            }
            else
            {
                this.countDictionary[param1] = _loc2_;
            }
        }
        
        override public function die() : void
        {
            var _loc1_:Session = Settings.currentSession;
            if(this.fleshSound)
            {
                this.fleshSound.removeEventListener(AreaSoundInstance.AREA_SOUND_STOP,this.fleshSoundStopped);
                this.fleshSound = null;
            }
            if(this.solidSound)
            {
                this.solidSound.removeEventListener(AreaSoundInstance.AREA_SOUND_STOP,this.solidSoundStopped);
                this.solidSound = null;
            }
            this.add = false;
            this.remove = false;
            this.bodiesToAdd = null;
            this.bodiesToRemove = null;
            this.bjDictionary = null;
            this.countDictionary = null;
            _loc1_.contactListener.deleteListener(ContactListener.ADD,this.sensorShape);
            _loc1_.contactListener.deleteListener(ContactListener.REMOVE,this.sensorShape);
            _loc1_.contactListener.deleteListener(ContactListener.RESULT,this.handleShape);
        }
        
        override public function getJointBody(param1:b2Vec2 = null) : b2Body
        {
            return this.weaponBody;
        }
        
        override public function get groupDisplayObject() : DisplayObject
        {
            return this.mc;
        }
        
        protected function paintBlood(param1:Number, param2:Number, param3:FoodItem) : *
        {
            var _loc7_:Rectangle = null;
            var _loc8_:ColorTransform = null;
            if(!this.bitmap)
            {
                _loc7_ = this.mc.getBounds(this.mc);
                this.bmd = new BitmapData(Math.ceil(_loc7_.width),Math.ceil(_loc7_.height),true,0);
                this.bitmap = new Bitmap(this.bmd);
                this.bitmap.smoothing = true;
                this.bitmap.x = _loc7_.x;
                this.bitmap.y = _loc7_.y;
                this.mc.addChild(this.bitmap);
                this.bitmap.alpha = 0.85;
            }
            var _loc4_:Point = new Point(param1,param2);
            _loc4_ = Settings.currentSession.level.background.localToGlobal(_loc4_);
            _loc4_ = this.mc.globalToLocal(_loc4_);
            var _loc5_:MovieClip = new BladeBloodMC();
            _loc5_.inner.x = _loc4_.x;
            _loc5_.inner.y = _loc4_.y;
            _loc5_.inner.rotation = Math.random() * 360;
            if(Math.random() > 0.5)
            {
                _loc5_.inner.scaleX = -1;
            }
            _loc5_.mask = this.maskSprite;
            var _loc6_:Matrix = new Matrix();
            _loc6_.translate(-this.bitmap.x,-this.bitmap.y);
            if(param3)
            {
                _loc8_ = _loc5_.transform.colorTransform;
                _loc8_.color = param3.juiceColor;
                _loc8_.alphaMultiplier = 0.75;
                this.bmd.draw(_loc5_,_loc6_,_loc8_);
            }
            else
            {
                this.bmd.draw(_loc5_,_loc6_);
            }
        }
        
        override public function paint() : void
        {
            var _loc1_:b2Vec2 = this.weaponBody.GetWorldPoint(this.weaponPosOffset);
            this.mc.rotation = this.weaponBody.GetAngle() * oneEightyOverPI % 360 + this.weaponAngleOffset;
            this.mc.x = _loc1_.x * m_physScale;
            this.mc.y = _loc1_.y * m_physScale;
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
                if(this.weaponBody)
                {
                    this.weaponBody.WakeUp();
                }
            }
            else if(param2 == "apply impulse")
            {
                if(this.weaponBody)
                {
                    _loc4_ = Number(param3[0]);
                    _loc5_ = Number(param3[1]);
                    _loc6_ = this.weaponBody.GetMass();
                    this.weaponBody.ApplyImpulse(new b2Vec2(_loc4_ * _loc6_,_loc5_ * _loc6_),this.weaponBody.GetWorldCenter());
                    _loc7_ = Number(param3[2]);
                    _loc8_ = this.weaponBody.GetAngularVelocity();
                    this.weaponBody.SetAngularVelocity(_loc8_ + _loc7_);
                }
            }
        }
        
        override public function get bodyList() : Array
        {
            if(this.weaponBody)
            {
                return [this.weaponBody];
            }
            return [];
        }
    }
}

