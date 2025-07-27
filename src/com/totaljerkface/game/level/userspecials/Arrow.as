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
    import flash.utils.Dictionary;
    
    public class Arrow extends LevelItem
    {
        public var mc:ArrowMC;
        
        public var arrowBody:b2Body;
        
        private var sensorShape:b2Shape;
        
        private var solidShape:b2Shape;
        
        private var previousBody:b2Body;
        
        private var add:Boolean;
        
        private var remove:Boolean;
        
        private var bodiesToAdd:Array;
        
        private var bodiesToRemove:Array;
        
        private var bjDictionary:Dictionary;
        
        private var countDictionary:Dictionary;
        
        private var fleshSound:AreaSoundInstance;
        
        private var solidSound:AreaSoundInstance;
        
        private var broken:Boolean;
        
        public function Arrow(param1:b2Vec2, param2:Number, param3:b2Vec2, param4:int)
        {
            super();
            this.mc = new ArrowMC();
            this.mc.gotoAndStop(1);
            this.mc.x = param1.x * m_physScale;
            this.mc.y = param1.y * m_physScale;
            this.mc.rotation = param2 * 180 / Math.PI;
            this.mc.visible = false;
            var _loc5_:Sprite = Settings.currentSession.level.background;
            _loc5_.addChildAt(this.mc,param4);
            this.createBody(param1,param2,param3);
            this.arrowBody.SetUserData(this.mc);
            this.bodiesToAdd = new Array();
            this.bodiesToRemove = new Array();
            this.bjDictionary = new Dictionary();
            this.countDictionary = new Dictionary();
            var _loc6_:ContactListener = Settings.currentSession.contactListener;
            _loc6_.registerListener(ContactListener.ADD,this.sensorShape,this.checkAdd);
            _loc6_.registerListener(ContactListener.REMOVE,this.sensorShape,this.checkRemove);
            var _loc7_:LevelB2D = Settings.currentSession.level;
            _loc7_.singleActionVector.push(this);
            _loc7_.actionsVector.push(this);
            _loc7_.paintBodyVector.push(this.arrowBody);
            MemoryTest.instance.addEntry("arrow_",this);
        }
        
        private function createBody(param1:b2Vec2, param2:Number, param3:b2Vec2) : void
        {
            var _loc4_:Session = Settings.currentSession;
            var _loc5_:b2BodyDef = new b2BodyDef();
            _loc5_.position = param1;
            _loc5_.angle = param2;
            this.arrowBody = _loc4_.m_world.CreateBody(_loc5_);
            var _loc6_:b2PolygonDef = new b2PolygonDef();
            _loc6_.SetAsOrientedBox(10 / m_physScale,1 / m_physScale,new b2Vec2(16.5 / m_physScale,0));
            _loc6_.isSensor = true;
            _loc6_.density = 1;
            _loc6_.filter.categoryBits = 8;
            _loc6_.filter.groupIndex = -21;
            this.sensorShape = this.arrowBody.CreateShape(_loc6_);
            _loc6_.SetAsOrientedBox(16.5 / m_physScale,1 / m_physScale,new b2Vec2(-10 / m_physScale,0));
            _loc6_.isSensor = false;
            _loc6_.filter.groupIndex = 0;
            this.solidShape = this.arrowBody.CreateShape(_loc6_);
            this.arrowBody.SetMassFromShapes();
            this.arrowBody.SetLinearVelocity(param3);
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
            var _loc1_:Sprite = null;
            var _loc2_:int = 0;
            if(!this.mc.visible)
            {
                this.mc.visible = true;
            }
            else
            {
                this.broken = true;
                Settings.currentSession.m_world.DestroyBody(this.arrowBody);
                this.mc.visible = false;
                _loc1_ = this.mc.parent as Sprite;
                Settings.currentSession.particleController.createArrowSnap(this.arrowBody,this.mc.currentFrame,_loc1_,_loc1_.getChildIndex(this.mc));
                _loc1_.removeChild(this.mc);
                _loc2_ = Math.ceil(Math.random() * 2);
                SoundController.instance.playAreaSoundInstance("ArrowSnap" + _loc2_,this.arrowBody);
                this.arrowBody = null;
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
            var _loc9_:ContactListener = null;
            var _loc10_:String = null;
            var _loc11_:* = undefined;
            var _loc12_:CharacterB2D = null;
            var _loc13_:NPCharacter = null;
            var _loc14_:FoodItem = null;
            var _loc15_:int = 0;
            var _loc16_:Number = NaN;
            var _loc2_:b2Shape = param1.GetShapeList();
            if(this.bjDictionary[param1])
            {
                _loc8_ = int(this.countDictionary[param1]);
                this.countDictionary[param1] = _loc8_ + 1;
                return;
            }
            var _loc3_:Session = Settings.currentSession;
            var _loc4_:b2PrismaticJointDef = new b2PrismaticJointDef();
            var _loc5_:b2Vec2 = this.arrowBody.GetWorldPoint(new b2Vec2(13.25 / m_physScale,0));
            var _loc6_:Number = this.arrowBody.GetAngle();
            var _loc7_:b2Vec2 = new b2Vec2(Math.cos(_loc6_),Math.sin(_loc6_));
            _loc4_.Initialize(this.arrowBody,param1,_loc5_,_loc7_);
            _loc4_.enableLimit = true;
            _loc4_.upperTranslation = 0;
            _loc4_.lowerTranslation = 0;
            _loc4_.collideConnected = true;
            _loc4_.enableMotor = true;
            _loc4_.maxMotorForce = 100000;
            _loc4_.motorSpeed = 0;
            this.bjDictionary[param1] = _loc3_.m_world.CreateJoint(_loc4_) as b2PrismaticJoint;
            this.countDictionary[param1] = 1;
            if(!this.previousBody)
            {
                _loc9_ = _loc3_.contactListener;
                _loc9_.registerListener(ContactEvent.RESULT,this.solidShape,this.arrowResultHandler);
            }
            if(param1 == this.previousBody)
            {
                return;
            }
            this.previousBody = param1;
            if(_loc2_.GetMaterial() & 6)
            {
                _loc11_ = _loc2_.GetUserData();
                if(_loc11_ is CharacterB2D)
                {
                    _loc12_ = _loc11_ as CharacterB2D;
                    _loc12_.shapeImpale(_loc2_,true,_loc5_,0.01);
                    _loc3_.particleController.createPointBloodBurst(_loc5_.x * m_physScale,_loc5_.y * m_physScale,5,15,20);
                    this.mc.gotoAndStop(Math.ceil(Math.random() * 5) + 1);
                }
                else if(_loc11_ is NPCharacter)
                {
                    _loc13_ = _loc11_ as NPCharacter;
                    _loc13_.shapeImpale(_loc2_,true);
                    _loc3_.particleController.createPointBloodBurst(_loc5_.x * m_physScale,_loc5_.y * m_physScale,5,15,20);
                    this.mc.gotoAndStop(Math.ceil(Math.random() * 5) + 1);
                }
                else if(_loc11_ is FoodItem)
                {
                    _loc14_ = _loc11_ as FoodItem;
                    _loc10_ = _loc14_.particleType;
                    _loc3_.particleController.createPointBurst(_loc10_,_loc5_.x * m_physScale,_loc5_.y * m_physScale,5,15,20);
                }
                if(!this.fleshSound)
                {
                    _loc15_ = Math.ceil(Math.random() * 3);
                    this.fleshSound = SoundController.instance.playAreaSoundInstance("ArrowFlesh" + _loc15_,this.arrowBody);
                    if(this.fleshSound)
                    {
                        this.fleshSound.addEventListener(AreaSoundInstance.AREA_SOUND_STOP,this.fleshSoundStopped,false,0,true);
                    }
                }
            }
            else
            {
                _loc16_ = this.arrowBody.GetLinearVelocity().LengthSquared();
                if(!this.solidSound && _loc16_ > 9)
                {
                    _loc15_ = Math.ceil(Math.random() * 2);
                    this.solidSound = SoundController.instance.playAreaSoundInstance("ArrowSolid" + _loc15_,this.arrowBody);
                    if(this.solidSound)
                    {
                        this.solidSound.addEventListener(AreaSoundInstance.AREA_SOUND_STOP,this.solidSoundStopped,false,0,true);
                    }
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
        
        private function arrowResultHandler(param1:ContactEvent) : void
        {
            var _loc2_:Session = null;
            if(param1.impulse > 1)
            {
                this.die();
                _loc2_ = Settings.currentSession;
                _loc2_.level.removeFromPaintBodyVector(this.arrowBody);
                _loc2_.level.removeFromActionsVector(this);
                _loc2_.level.singleActionVector.push(this);
            }
        }
        
        public function remoteBreak() : void
        {
            if(this.broken)
            {
                return;
            }
            this.broken = true;
            this.die();
            var _loc1_:Session = Settings.currentSession;
            _loc1_.level.removeFromPaintBodyVector(this.arrowBody);
            _loc1_.level.removeFromActionsVector(this);
            var _loc2_:Vector.<LevelItem> = _loc1_.level.singleActionVector;
            var _loc3_:int = int(_loc2_.indexOf(this));
            if(_loc3_ > -1)
            {
                _loc2_.splice(_loc3_,1);
            }
            Settings.currentSession.m_world.DestroyBody(this.arrowBody);
            this.mc.visible = false;
            var _loc4_:Sprite = this.mc.parent as Sprite;
            Settings.currentSession.particleController.createArrowSnap(this.arrowBody,this.mc.currentFrame,_loc4_,_loc4_.getChildIndex(this.mc));
            var _loc5_:int = Math.ceil(Math.random() * 2);
            SoundController.instance.playAreaSoundInstance("ArrowSnap" + _loc5_,this.arrowBody);
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
            _loc1_.contactListener.deleteListener(ContactListener.RESULT,this.solidShape);
        }
    }
}

