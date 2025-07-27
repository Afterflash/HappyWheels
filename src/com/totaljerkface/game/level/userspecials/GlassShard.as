package com.totaljerkface.game.level.userspecials
{
    import Box2D.Collision.*;
    import Box2D.Collision.Shapes.*;
    import Box2D.Common.Math.b2Vec2;
    import Box2D.Dynamics.*;
    import Box2D.Dynamics.Joints.b2Joint;
    import Box2D.Dynamics.Joints.b2PrismaticJoint;
    import Box2D.Dynamics.Joints.b2PrismaticJointDef;
    import com.totaljerkface.game.*;
    import com.totaljerkface.game.character.CharacterB2D;
    import com.totaljerkface.game.editor.specials.*;
    import com.totaljerkface.game.events.*;
    import com.totaljerkface.game.level.*;
    import com.totaljerkface.game.sound.*;
    import flash.display.*;
    import flash.events.Event;
    import flash.geom.Matrix;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.utils.*;
    
    public class GlassShard extends LevelItem
    {
        protected var shatterImpulse:Number;
        
        protected var stabImpulse:Number;
        
        protected var soundSuffix:String;
        
        protected var glassParticles:int;
        
        protected var bloodParticles:int = 50;
        
        protected var shape:b2PolygonShape;
        
        protected var sensor:b2Shape;
        
        protected var body:b2Body;
        
        protected var sprite:Sprite;
        
        protected var maskSprite:Sprite;
        
        protected var previousBody:b2Body;
        
        protected var stab:Boolean;
        
        protected var shatter:Boolean;
        
        protected var add:Boolean;
        
        protected var remove:Boolean;
        
        protected var bodiesToAdd:Array;
        
        protected var bodiesToRemove:Array;
        
        protected var normals:Array;
        
        protected var bjDictionary:Dictionary;
        
        protected var countDictionary:Dictionary;
        
        protected var fleshSound:AreaSoundInstance;
        
        protected var bitmap:Bitmap;
        
        protected var bmd:BitmapData;
        
        protected var inSAA:Boolean;
        
        protected var fatal:Boolean;
        
        public function GlassShard(param1:b2Body, param2:Sprite, param3:Sprite)
        {
            super();
            this.body = param1;
            this.shape = param1.GetShapeList() as b2PolygonShape;
            this.sprite = param2;
            this.maskSprite = param3;
            this.setValues();
            this.bodiesToAdd = new Array();
            this.normals = new Array();
            this.bodiesToRemove = new Array();
            this.bjDictionary = new Dictionary();
            this.countDictionary = new Dictionary();
            var _loc4_:Session = Settings.currentSession;
            _loc4_.contactListener.registerListener(ContactListener.RESULT,this.shape,this.checkContact);
            _loc4_.level.paintItemVector.push(this);
        }
        
        protected function setValues() : void
        {
            var _loc1_:Number = this.body.GetMass();
            this.shatterImpulse = _loc1_ * 10;
            this.stabImpulse = _loc1_ * 2;
            if(_loc1_ >= 0.15)
            {
                this.fatal = true;
            }
            if(_loc1_ < 0.75)
            {
                this.soundSuffix = "Light";
                this.glassParticles = 50;
            }
            else if(_loc1_ < 4)
            {
                this.soundSuffix = "Mid";
                this.glassParticles = 100;
            }
            else
            {
                this.soundSuffix = "Heavy";
                this.glassParticles = 200;
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
                    this.createPrisJoint(this.bodiesToAdd[_loc1_],this.normals[_loc1_]);
                    _loc1_++;
                }
                this.bodiesToAdd = new Array();
                this.normals = new Array();
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
            var _loc5_:b2FilterData = null;
            var _loc6_:b2PolygonDef = null;
            var _loc7_:Number = NaN;
            var _loc1_:Session = Settings.currentSession;
            var _loc2_:LevelB2D = _loc1_.level;
            var _loc3_:b2World = _loc1_.m_world;
            var _loc4_:ContactListener = _loc1_.contactListener;
            this.inSAA = false;
            if(this.stab)
            {
                this.stab = false;
                _loc4_.deleteListener(ContactEvent.RESULT,this.shape);
                _loc5_ = this.shape.GetFilterData().Copy();
                _loc5_.maskBits = 8;
                this.shape.SetFilterData(_loc5_);
                _loc3_.Refilter(this.shape);
                _loc6_ = new b2PolygonDef();
                _loc6_.isSensor = true;
                _loc6_.filter.categoryBits = 8;
                _loc6_.filter.maskBits = 4;
                _loc6_.vertexCount = this.shape.GetVertexCount();
                _loc6_.vertices = this.shape.GetVertices();
                this.sensor = this.body.CreateShape(_loc6_);
                _loc2_.actionsVector.push(this);
                _loc4_.registerListener(ContactEvent.RESULT,this.shape,this.checkContact);
                _loc4_.registerListener(ContactListener.ADD,this.sensor,this.checkAdd);
                _loc4_.registerListener(ContactListener.REMOVE,this.sensor,this.checkRemove);
            }
            else
            {
                _loc2_.removeFromPaintItemVector(this);
                _loc2_.removeFromActionsVector(this);
                _loc7_ = Math.ceil(Math.random() * 2);
                _loc1_.particleController.createRectBurst("glass",10,this.body,this.glassParticles);
                SoundController.instance.playAreaSoundInstance("Glass" + this.soundSuffix + _loc7_,this.body);
                _loc3_.DestroyBody(this.body);
                this.sprite.parent.removeChild(this.sprite);
                _loc4_.deleteListener(ContactEvent.RESULT,this.shape);
                if(this.sensor)
                {
                    this.add = this.remove = false;
                    _loc4_.deleteListener(ContactListener.ADD,this.sensor);
                    _loc4_.deleteListener(ContactListener.REMOVE,this.sensor);
                    if(this.bmd)
                    {
                        this.bmd.dispose();
                    }
                }
            }
        }
        
        protected function checkContact(param1:ContactEvent) : void
        {
            var _loc2_:Vector.<LevelItem> = null;
            if(param1.impulse > this.stabImpulse)
            {
                _loc2_ = Settings.currentSession.level.singleActionVector;
                if(param1.impulse > this.shatterImpulse)
                {
                    this.stab = false;
                    Settings.currentSession.contactListener.deleteListener(ContactEvent.RESULT,this.shape);
                    if(!this.inSAA)
                    {
                        Settings.currentSession.level.singleActionVector.push(this);
                    }
                    this.inSAA = true;
                    return;
                }
                if(Boolean(param1.otherShape.m_material & 2) && !this.sensor)
                {
                    this.stab = true;
                    if(!this.inSAA)
                    {
                        Settings.currentSession.level.singleActionVector.push(this);
                    }
                    this.inSAA = true;
                }
            }
        }
        
        protected function checkAdd(param1:b2ContactPoint) : void
        {
            var _loc2_:b2Body = null;
            if(param1.shape2.m_material & 2)
            {
                _loc2_ = param1.shape2.GetBody();
                this.bodiesToAdd.push(_loc2_);
                this.normals.push(param1.normal);
                this.add = true;
            }
        }
        
        protected function checkRemove(param1:b2ContactPoint) : void
        {
            var _loc2_:b2Body = null;
            if(param1.shape2.m_material & 2)
            {
                _loc2_ = param1.shape2.GetBody();
                if(Boolean(this.bjDictionary[_loc2_]) || this.bodiesToAdd.indexOf(_loc2_) > -1)
                {
                    this.bodiesToRemove.push(_loc2_);
                    this.remove = true;
                }
            }
        }
        
        protected function createPrisJoint(param1:b2Body, param2:b2Vec2) : void
        {
            var _loc9_:int = 0;
            var _loc10_:CharacterB2D = null;
            var _loc11_:NPCharacter = null;
            var _loc12_:int = 0;
            if(this.bjDictionary[param1])
            {
                _loc9_ = int(this.countDictionary[param1]);
                this.countDictionary[param1] = _loc9_ + 1;
                return;
            }
            var _loc3_:Session = Settings.currentSession;
            var _loc4_:b2Shape = param1.GetShapeList();
            var _loc5_:* = _loc4_.GetUserData();
            if(_loc5_ is CharacterB2D)
            {
                _loc10_ = _loc5_ as CharacterB2D;
                _loc10_.shapeImpale(_loc4_,this.fatal);
            }
            else if(_loc5_ is NPCharacter)
            {
                _loc11_ = _loc5_ as NPCharacter;
                _loc11_.shapeImpale(_loc4_,this.fatal);
            }
            var _loc6_:b2PrismaticJointDef = new b2PrismaticJointDef();
            var _loc7_:b2Vec2 = param1.GetWorldCenter();
            var _loc8_:b2Body = this.body != null ? this.body : Settings.currentSession.level.levelBody;
            _loc6_.Initialize(_loc8_,param1,_loc7_,param2);
            _loc6_.collideConnected = true;
            _loc6_.enableMotor = true;
            _loc6_.maxMotorForce = 30;
            _loc6_.motorSpeed = 0;
            this.bjDictionary[param1] = _loc3_.m_world.CreateJoint(_loc6_) as b2PrismaticJoint;
            this.countDictionary[param1] = 1;
            if(param1 == this.previousBody)
            {
                return;
            }
            this.previousBody = param1;
            _loc3_.particleController.createPointBloodBurst(_loc7_.x * m_physScale,_loc7_.y * m_physScale,5,15,this.bloodParticles);
            this.paintBlood(_loc7_.x * m_physScale,_loc7_.y * m_physScale);
            if(!this.fleshSound)
            {
                _loc12_ = Math.ceil(Math.random() * 3);
                this.fleshSound = SoundController.instance.playAreaSoundInstance("ImpaleSpikes" + _loc12_,this.body);
                if(this.fleshSound)
                {
                    this.fleshSound.addEventListener(AreaSoundInstance.AREA_SOUND_STOP,this.fleshSoundStopped,false,0,true);
                }
            }
        }
        
        protected function removeJoint(param1:b2Body) : void
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
        
        protected function paintBlood(param1:Number, param2:Number) : *
        {
            var _loc6_:Rectangle = null;
            if(!this.bitmap)
            {
                _loc6_ = this.sprite.getBounds(this.sprite);
                this.bmd = new BitmapData(Math.ceil(_loc6_.width),Math.ceil(_loc6_.height),true,0);
                this.bitmap = new Bitmap(this.bmd);
                this.bitmap.smoothing = true;
                this.bitmap.x = _loc6_.x;
                this.bitmap.y = _loc6_.y;
                this.sprite.addChild(this.bitmap);
            }
            var _loc3_:Point = new Point(param1,param2);
            _loc3_ = Settings.currentSession.level.background.localToGlobal(_loc3_);
            _loc3_ = this.sprite.globalToLocal(_loc3_);
            var _loc4_:MovieClip = new GlassBloodMC();
            _loc4_.inner.x = _loc3_.x;
            _loc4_.inner.y = _loc3_.y;
            _loc4_.inner.rotation = Math.random() * 360;
            if(Math.random() > 0.5)
            {
                _loc4_.inner.scaleX = -1;
            }
            _loc4_.mask = this.maskSprite;
            var _loc5_:Matrix = new Matrix();
            _loc5_.translate(-this.bitmap.x,-this.bitmap.y);
            this.bmd.draw(_loc4_,_loc5_);
            _loc4_.mask = null;
        }
        
        protected function fleshSoundStopped(param1:Event) : void
        {
            this.fleshSound.removeEventListener(AreaSoundInstance.AREA_SOUND_STOP,this.fleshSoundStopped);
            this.fleshSound = null;
        }
        
        override public function paint() : void
        {
            var _loc1_:b2Vec2 = null;
            _loc1_ = this.body.GetPosition();
            this.sprite.x = _loc1_.x * m_physScale;
            this.sprite.y = _loc1_.y * m_physScale;
            this.sprite.rotation = this.body.GetAngle() * oneEightyOverPI % 360;
        }
    }
}

