package com.totaljerkface.game.level.userspecials
{
    import Box2D.Collision.Shapes.*;
    import Box2D.Collision.b2ContactPoint;
    import Box2D.Common.Math.b2Vec2;
    import Box2D.Dynamics.*;
    import Box2D.Dynamics.Joints.*;
    import com.totaljerkface.game.*;
    import com.totaljerkface.game.character.CharacterB2D;
    import com.totaljerkface.game.editor.specials.*;
    import com.totaljerkface.game.events.*;
    import com.totaljerkface.game.level.*;
    import com.totaljerkface.game.sound.AreaSoundInstance;
    import com.totaljerkface.game.sound.SoundController;
    import flash.display.*;
    import flash.events.Event;
    import flash.geom.ColorTransform;
    import flash.utils.Dictionary;
    
    public class Harpoon extends LevelItem
    {
        public static const HIT:String = "hit";
        
        private var mc:HarpoonMC;
        
        private var bitmap:Bitmap;
        
        private var bmd:BitmapData;
        
        public var harpoonBody:b2Body;
        
        private var sensorShape:b2Shape;
        
        private var previousBody:b2Body;
        
        private var add:Boolean;
        
        private var remove:Boolean;
        
        private var bodiesToAdd:Array;
        
        private var bodiesToRemove:Array;
        
        private var bjDictionary:Dictionary;
        
        private var countDictionary:Dictionary;
        
        private var fleshSound:AreaSoundInstance;
        
        private var solidSound:AreaSoundInstance;
        
        private var fixedTurret:Boolean;
        
        public function Harpoon(param1:b2Vec2, param2:Number, param3:b2Vec2, param4:Boolean = false)
        {
            super();
            this.fixedTurret = param4;
            this.mc = new HarpoonMC();
            this.mc.x = param1.x * m_physScale;
            this.mc.y = param1.y * m_physScale;
            this.mc.rotation = param2 * 180 / Math.PI;
            var _loc5_:Sprite = Settings.currentSession.level.background;
            _loc5_.addChild(this.mc);
            this.bmd = new BitmapData(106,16,true,0);
            this.bitmap = new Bitmap(this.bmd);
            this.bitmap.smoothing = true;
            this.bitmap.x = -53;
            this.bitmap.y = -8;
            this.mc.addChild(this.bitmap);
            this.createBody(param1,param2,param3);
            this.harpoonBody.SetUserData(this.mc);
            this.bodiesToAdd = new Array();
            this.bodiesToRemove = new Array();
            this.bjDictionary = new Dictionary();
            this.countDictionary = new Dictionary();
            var _loc6_:ContactListener = Settings.currentSession.contactListener;
            _loc6_.registerListener(ContactListener.ADD,this.sensorShape,this.checkAdd);
            _loc6_.registerListener(ContactListener.REMOVE,this.sensorShape,this.checkRemove);
            Settings.currentSession.level.actionsVector.push(this);
            Settings.currentSession.level.paintBodyVector.push(this.harpoonBody);
        }
        
        private function createBody(param1:b2Vec2, param2:Number, param3:b2Vec2) : void
        {
            var _loc7_:b2Vec2 = null;
            var _loc4_:Session = Settings.currentSession;
            var _loc5_:b2BodyDef = new b2BodyDef();
            _loc5_.position = param1;
            _loc5_.angle = param2;
            this.harpoonBody = _loc4_.m_world.CreateBody(_loc5_);
            var _loc6_:b2PolygonDef = new b2PolygonDef();
            _loc6_.SetAsOrientedBox(26.25 / m_physScale,2.5 / m_physScale,new b2Vec2(26.25 / m_physScale,0));
            _loc6_.isSensor = true;
            _loc6_.density = 3;
            _loc6_.filter.categoryBits = 8;
            _loc6_.filter.groupIndex = _loc4_.version > 1.42 ? -21 : -20;
            this.sensorShape = this.harpoonBody.CreateShape(_loc6_);
            _loc6_.SetAsOrientedBox(26.25 / m_physScale,2.5 / m_physScale,new b2Vec2(-26.25 / m_physScale,0));
            _loc6_.isSensor = false;
            this.harpoonBody.CreateShape(_loc6_);
            if(this.fixedTurret)
            {
                _loc7_ = this.harpoonBody.GetWorldPoint(new b2Vec2(52.5 / m_physScale,0));
                this.harpoonBody.SetXForm(_loc7_,param2);
            }
            this.harpoonBody.SetMassFromShapes();
            this.harpoonBody.SetLinearVelocity(param3);
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
        
        private function checkAdd(param1:b2ContactPoint) : void
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
            var _loc8_:int = 0;
            var _loc9_:String = null;
            var _loc10_:int = 0;
            var _loc11_:FoodItem = null;
            var _loc12_:* = undefined;
            var _loc13_:MovieClip = null;
            var _loc14_:CharacterB2D = null;
            var _loc15_:NPCharacter = null;
            var _loc16_:ColorTransform = null;
            var _loc17_:int = 0;
            var _loc2_:b2Shape = param1.GetShapeList();
            if(this.bjDictionary[param1])
            {
                _loc8_ = int(this.countDictionary[param1]);
                this.countDictionary[param1] = _loc8_ + 1;
                return;
            }
            var _loc3_:Session = Settings.currentSession;
            var _loc4_:b2PrismaticJointDef = new b2PrismaticJointDef();
            var _loc5_:b2Vec2 = this.harpoonBody.GetWorldPoint(new b2Vec2(26.25 / m_physScale,0));
            var _loc6_:Number = this.harpoonBody.GetAngle();
            var _loc7_:b2Vec2 = new b2Vec2(Math.cos(_loc6_),Math.sin(_loc6_));
            _loc4_.Initialize(this.harpoonBody,param1,_loc5_,_loc7_);
            _loc4_.enableLimit = true;
            _loc4_.upperTranslation = 0;
            _loc4_.lowerTranslation = 0;
            _loc4_.collideConnected = true;
            _loc4_.enableMotor = true;
            _loc4_.maxMotorForce = 100000;
            _loc4_.motorSpeed = 0;
            this.bjDictionary[param1] = _loc3_.m_world.CreateJoint(_loc4_) as b2PrismaticJoint;
            this.countDictionary[param1] = 1;
            dispatchEvent(new Event(HIT));
            if(param1 == this.previousBody)
            {
                return;
            }
            this.previousBody = param1;
            if(_loc2_.GetMaterial() & 6)
            {
                _loc12_ = _loc2_.GetUserData();
                if(_loc12_ is CharacterB2D)
                {
                    _loc10_ = 50;
                    _loc14_ = _loc12_ as CharacterB2D;
                    _loc14_.shapeImpale(_loc2_,true);
                    _loc3_.particleController.createPointBloodBurst(_loc5_.x * m_physScale,_loc5_.y * m_physScale,5,15,_loc10_);
                }
                else if(_loc12_ is NPCharacter)
                {
                    _loc10_ = 50;
                    _loc15_ = _loc12_ as NPCharacter;
                    _loc3_.particleController.createPointBloodBurst(_loc5_.x * m_physScale,_loc5_.y * m_physScale,5,15,_loc10_);
                    _loc15_.shapeImpale(_loc2_,true);
                }
                else if(_loc12_ is FoodItem)
                {
                    _loc11_ = _loc12_ as FoodItem;
                    _loc9_ = _loc11_.particleType;
                    _loc10_ = 25;
                    _loc3_.particleController.createPointBurst(_loc9_,_loc5_.x * m_physScale,_loc5_.y * m_physScale,5,15,_loc10_);
                }
                _loc13_ = new HarpoonBloodMC();
                _loc13_.gotoAndStop(Math.ceil(Math.random() * 5));
                if(_loc11_)
                {
                    _loc16_ = _loc13_.transform.colorTransform;
                    _loc16_.color = _loc11_.juiceColor;
                    _loc16_.alphaMultiplier = 0.75;
                    this.bmd.draw(_loc13_,null,_loc16_);
                }
                else
                {
                    this.bmd.draw(_loc13_);
                }
                if(!this.fleshSound)
                {
                    _loc17_ = Math.ceil(Math.random() * 2);
                    this.fleshSound = SoundController.instance.playAreaSoundInstance("HarpoonFlesh" + _loc17_,this.harpoonBody);
                    if(this.fleshSound)
                    {
                        this.fleshSound.addEventListener(AreaSoundInstance.AREA_SOUND_STOP,this.fleshSoundStopped,false,0,true);
                    }
                }
            }
            else if(!this.solidSound)
            {
                _loc17_ = Math.ceil(Math.random() * 2);
                this.solidSound = SoundController.instance.playAreaSoundInstance("HarpoonSolid" + _loc17_,this.harpoonBody);
                if(this.solidSound)
                {
                    this.solidSound.addEventListener(AreaSoundInstance.AREA_SOUND_STOP,this.solidSoundStopped,false,0,true);
                }
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
    }
}

