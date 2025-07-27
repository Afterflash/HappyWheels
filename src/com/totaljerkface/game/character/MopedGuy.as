package com.totaljerkface.game.character
{
    import Box2D.Collision.Shapes.*;
    import Box2D.Collision.b2ContactPoint;
    import Box2D.Common.Math.b2Math;
    import Box2D.Common.Math.b2Vec2;
    import Box2D.Dynamics.*;
    import Box2D.Dynamics.Joints.*;
    import com.totaljerkface.game.*;
    import com.totaljerkface.game.events.*;
    import com.totaljerkface.game.level.groups.Vehicle;
    import com.totaljerkface.game.sound.AreaSoundInstance;
    import com.totaljerkface.game.sound.AreaSoundLoop;
    import com.totaljerkface.game.sound.SoundController;
    import flash.display.*;
    import flash.events.*;
    
    public class MopedGuy extends CharacterB2D
    {
        internal var ejected:Boolean;
        
        private var wheelMaxSpeed:Number = 30;
        
        private var wheelCurrentSpeed:Number;
        
        private var wheelNewSpeed:Number;
        
        private var wheelContacts:Number = 0;
        
        private var backContacts:Number = 0;
        
        private var frontContacts:Number = 0;
        
        private var accelStep:Number = 0.5;
        
        private var maxTorque:Number = 30;
        
        private var prevSpeed:Number = 0;
        
        private var currSpeed:Number = 0;
        
        private var impulseMagnitude:Number = 0.75;
        
        private var impulseOffset:Number = 1;
        
        private var maxSpinAV:Number = 5;
        
        private var boostVal:Number = 0;
        
        private var boostMax:int = 50;
        
        private var boostStepUp:Number = 2;
        
        private var boostStepDown:Number = 0.5;
        
        private var boostMeter:Sprite;
        
        private var boostHolder:Sprite;
        
        private var boostImpulse:Number = 4;
        
        private var accelSound:AreaSoundInstance;
        
        private var steadySound:AreaSoundLoop;
        
        private var idleSound:AreaSoundLoop;
        
        private var wheelLoop1:AreaSoundLoop;
        
        private var wheelLoop2:AreaSoundLoop;
        
        private var wheelLoop3:AreaSoundLoop;
        
        internal var frameSmashLimit:Number = 200;
        
        internal var wheelSmashLimit:Number = 200;
        
        protected var frameSmashed:Boolean;
        
        protected var handleAnchorPoint:b2Vec2;
        
        protected var pelvisAnchorPoint:b2Vec2;
        
        protected var footAnchorPoint:b2Vec2;
        
        protected var framePelvisJointDef:b2RevoluteJointDef;
        
        protected var frameHand1JointDef:b2RevoluteJointDef;
        
        protected var frameHand2JointDef:b2RevoluteJointDef;
        
        protected var frameFoot1JointDef:b2RevoluteJointDef;
        
        protected var frameFoot2JointDef:b2RevoluteJointDef;
        
        protected var reAttachDistance:Number = 0.25;
        
        internal var frameBody:b2Body;
        
        internal var backWheelBody:b2Body;
        
        internal var frontWheelBody:b2Body;
        
        internal var backWheelShape:b2Shape;
        
        internal var frontWheelShape:b2Shape;
        
        internal var forkShape:b2PolygonShape;
        
        internal var tankShape:b2PolygonShape;
        
        internal var engineShape:b2PolygonShape;
        
        internal var middleShape:b2PolygonShape;
        
        internal var rearShape:b2PolygonShape;
        
        internal var seatShape:b2PolygonShape;
        
        internal var frameMC:MovieClip;
        
        internal var backWheelMC:MovieClip;
        
        internal var frontWheelMC:MovieClip;
        
        internal var gearMC:MovieClip;
        
        internal var brokenForkMC:MovieClip;
        
        internal var brokenTankMC:MovieClip;
        
        internal var brokenEngineMC:MovieClip;
        
        internal var brokenMiddleMC:MovieClip;
        
        internal var brokenRearMC:MovieClip;
        
        internal var brokenSeatMC:MovieClip;
        
        internal var backWheelJoint:b2RevoluteJoint;
        
        internal var frontWheelJoint:b2RevoluteJoint;
        
        internal var framePelvis:b2RevoluteJoint;
        
        internal var frameHand1:b2RevoluteJoint;
        
        internal var frameHand2:b2RevoluteJoint;
        
        internal var frameFoot1:b2RevoluteJoint;
        
        internal var frameFoot2:b2RevoluteJoint;
        
        public function MopedGuy(param1:Number, param2:Number, param3:DisplayObject, param4:Session)
        {
            super(param1,param2,param3,param4,-1,"Char8");
            this.impulseMagnitude = _session.version > 1.2 ? 1 : 0.75;
        }
        
        override internal function leftPressedActions() : void
        {
            var _loc1_:Number = NaN;
            var _loc2_:Number = NaN;
            var _loc3_:Number = NaN;
            var _loc4_:b2Vec2 = null;
            if(this.ejected)
            {
                currentPose = 1;
            }
            else
            {
                _loc1_ = this.frameBody.GetAngle();
                _loc2_ = Math.cos(_loc1_) * this.impulseMagnitude;
                _loc3_ = Math.sin(_loc1_) * this.impulseMagnitude;
                _loc4_ = this.frameBody.GetLocalCenter();
                this.frameBody.ApplyImpulse(new b2Vec2(_loc3_,-_loc2_),this.frameBody.GetWorldPoint(new b2Vec2(_loc4_.x + this.impulseOffset,_loc4_.y)));
            }
        }
        
        override internal function rightPressedActions() : void
        {
            var _loc1_:Number = NaN;
            var _loc2_:Number = NaN;
            var _loc3_:Number = NaN;
            var _loc4_:b2Vec2 = null;
            if(this.ejected)
            {
                currentPose = 2;
            }
            else
            {
                _loc1_ = this.frameBody.GetAngle();
                _loc2_ = Math.cos(_loc1_) * this.impulseMagnitude;
                _loc3_ = Math.sin(_loc1_) * this.impulseMagnitude;
                _loc4_ = this.frameBody.GetLocalCenter();
                this.frameBody.ApplyImpulse(new b2Vec2(_loc3_,-_loc2_),this.frameBody.GetWorldPoint(new b2Vec2(_loc4_.x - this.impulseOffset,_loc4_.y)));
            }
        }
        
        override internal function leftAndRightActions() : void
        {
            if(this.ejected)
            {
                if(_currentPose == 1 || _currentPose == 2)
                {
                    currentPose = 0;
                }
            }
        }
        
        override internal function upPressedActions() : void
        {
            if(this.ejected)
            {
                currentPose = 3;
            }
            else
            {
                this.backWheelJoint.EnableMotor(true);
                this.frontWheelJoint.EnableMotor(false);
                this.wheelCurrentSpeed = this.backWheelJoint.GetJointSpeed();
                if(this.wheelCurrentSpeed < 0)
                {
                    this.wheelNewSpeed = 0;
                }
                else
                {
                    this.wheelNewSpeed = this.wheelCurrentSpeed < this.wheelMaxSpeed ? this.wheelCurrentSpeed + this.accelStep : this.wheelCurrentSpeed;
                }
                this.backWheelJoint.SetMotorSpeed(this.wheelNewSpeed);
            }
        }
        
        private function accelComplete(param1:Event) : void
        {
            if(this.accelSound)
            {
                this.accelSound = null;
            }
            if(!this.steadySound)
            {
                this.steadySound = SoundController.instance.playAreaSoundInstance("MotoSteady",this.backWheelBody);
            }
        }
        
        override internal function downPressedActions() : void
        {
            if(this.ejected)
            {
                currentPose = 4;
            }
            else
            {
                this.backWheelJoint.EnableMotor(true);
                this.frontWheelJoint.EnableMotor(false);
                this.wheelCurrentSpeed = this.backWheelJoint.GetJointSpeed();
                if(this.wheelCurrentSpeed > 0)
                {
                    this.wheelNewSpeed = 0;
                }
                else
                {
                    this.wheelNewSpeed = this.wheelCurrentSpeed > -this.wheelMaxSpeed ? this.wheelCurrentSpeed - this.accelStep : this.wheelCurrentSpeed;
                }
                this.backWheelJoint.SetMotorSpeed(this.wheelNewSpeed);
            }
        }
        
        override internal function upAndDownActions() : void
        {
            this.backWheelJoint.EnableMotor(false);
            this.frontWheelJoint.EnableMotor(false);
            if(this.ejected)
            {
                if(_currentPose == 3 || _currentPose == 4)
                {
                    currentPose = 0;
                }
            }
            else
            {
                if(this.accelSound)
                {
                    trace("STOP SOUND");
                    this.accelSound.fadeOut(0.2);
                    this.accelSound = null;
                }
                if(this.steadySound)
                {
                    this.steadySound.fadeOut(0.2);
                    this.steadySound = null;
                }
                if(this.idleSound)
                {
                }
            }
        }
        
        override internal function spacePressedActions() : void
        {
            var _loc1_:Number = NaN;
            var _loc2_:Number = NaN;
            var _loc3_:Number = NaN;
            if(this.ejected)
            {
                startGrab();
            }
            else
            {
                this.boostVal += this.boostStepUp;
                this.boostVal = Math.min(this.boostMax,this.boostVal);
                if(this.boostVal < this.boostMax)
                {
                    _loc1_ = this.frameBody.GetAngle();
                    _loc2_ = Math.cos(_loc1_) * this.boostImpulse;
                    _loc3_ = Math.sin(_loc1_) * this.boostImpulse;
                    this.frameBody.ApplyImpulse(new b2Vec2(_loc2_,_loc3_),this.frameBody.GetWorldCenter());
                }
            }
        }
        
        override internal function spaceNullActions() : void
        {
            if(this.ejected)
            {
                releaseGrip();
            }
            this.boostVal -= this.boostStepDown;
            this.boostVal = Math.max(0,this.boostVal);
        }
        
        override internal function ctrlPressedActions() : void
        {
            if(!this.ejected)
            {
                this.backWheelJoint.EnableMotor(true);
                this.frontWheelJoint.EnableMotor(true);
                this.backWheelJoint.SetMotorSpeed(0);
                this.frontWheelJoint.SetMotorSpeed(0);
            }
        }
        
        override internal function ctrlNullActions() : void
        {
        }
        
        override internal function zPressedActions() : void
        {
            this.eject();
        }
        
        override public function actions() : void
        {
            var _loc1_:Number = NaN;
            this.boostMeter.scaleY = 1 - this.boostVal / this.boostMax;
            this.prevSpeed = this.currSpeed;
            this.currSpeed = this.backWheelJoint.GetJointSpeed();
            if(this.wheelContacts > 0)
            {
                _loc1_ = Math.abs(this.backWheelBody.GetAngularVelocity());
                if(_loc1_ > 18)
                {
                    if(!this.wheelLoop3)
                    {
                        this.wheelLoop3 = SoundController.instance.playAreaSoundLoop("BikeLoop3",this.backWheelBody,0);
                        this.wheelLoop3.fadeIn(0.2);
                    }
                    if(this.wheelLoop1)
                    {
                        this.wheelLoop1.fadeOut(0.2);
                        this.wheelLoop1 = null;
                    }
                    if(this.wheelLoop2)
                    {
                        this.wheelLoop2.fadeOut(0.2);
                        this.wheelLoop2 = null;
                    }
                }
                else if(_loc1_ > 9)
                {
                    if(!this.wheelLoop2)
                    {
                        this.wheelLoop2 = SoundController.instance.playAreaSoundLoop("BikeLoop2",this.backWheelBody,0);
                        this.wheelLoop2.fadeIn(0.2);
                    }
                    if(this.wheelLoop1)
                    {
                        this.wheelLoop1.fadeOut(0.2);
                        this.wheelLoop1 = null;
                    }
                    if(this.wheelLoop3)
                    {
                        this.wheelLoop3.fadeOut(0.2);
                        this.wheelLoop3 = null;
                    }
                }
                else if(_loc1_ > 1)
                {
                    if(!this.wheelLoop1)
                    {
                        this.wheelLoop1 = SoundController.instance.playAreaSoundLoop("BikeLoop1",this.backWheelBody,0);
                        this.wheelLoop1.fadeIn(0.2);
                    }
                    if(this.wheelLoop2)
                    {
                        this.wheelLoop2.fadeOut(0.2);
                        this.wheelLoop2 = null;
                    }
                    if(this.wheelLoop3)
                    {
                        this.wheelLoop3.fadeOut(0.2);
                        this.wheelLoop3 = null;
                    }
                }
                else
                {
                    if(this.wheelLoop1)
                    {
                        this.wheelLoop1.fadeOut(0.2);
                        this.wheelLoop1 = null;
                    }
                    if(this.wheelLoop2)
                    {
                        this.wheelLoop2.fadeOut(0.2);
                        this.wheelLoop2 = null;
                    }
                    if(this.wheelLoop3)
                    {
                        this.wheelLoop3.fadeOut(0.2);
                        this.wheelLoop3 = null;
                    }
                }
            }
            else
            {
                if(this.wheelLoop1)
                {
                    this.wheelLoop1.fadeOut(0.2);
                    this.wheelLoop1 = null;
                }
                if(this.wheelLoop2)
                {
                    this.wheelLoop2.fadeOut(0.2);
                    this.wheelLoop2 = null;
                }
                if(this.wheelLoop3)
                {
                    this.wheelLoop3.fadeOut(0.2);
                    this.wheelLoop3 = null;
                }
            }
            super.actions();
        }
        
        override protected function checkPose() : void
        {
            switch(_currentPose)
            {
                case 1:
                    archPose();
                    break;
                case 2:
                    pushupPose();
                    break;
                case 3:
                    supermanPose();
                    break;
                case 4:
                    tuckPose();
                    break;
                case 5:
                case 6:
                case 7:
                    break;
                case 10:
                    armsForwardPose();
                    break;
                case 11:
                    armsOverheadPose();
                    break;
                case 12:
                    holdPositionPose();
            }
        }
        
        override public function reset() : void
        {
            super.reset();
            this.ejected = false;
            this.wheelContacts = 0;
            this.frontContacts = 0;
            this.backContacts = 0;
            this.boostVal = 0;
            this.frameSmashed = false;
            this.impulseMagnitude = _session.version > 1.2 ? 1 : 0.75;
        }
        
        override public function paint() : void
        {
            super.paint();
            var _loc1_:b2Vec2 = this.frontWheelBody.GetWorldCenter();
            this.frontWheelMC.x = _loc1_.x * m_physScale;
            this.frontWheelMC.y = _loc1_.y * m_physScale;
            this.frontWheelMC.inner.rotation = this.frontWheelBody.GetAngle() * oneEightyOverPI % 360;
            this.frontWheelMC.rim.rotation = this.frameBody.GetAngle() * oneEightyOverPI % 360;
            _loc1_ = this.backWheelBody.GetWorldCenter();
            this.backWheelMC.x = _loc1_.x * m_physScale;
            this.backWheelMC.y = _loc1_.y * m_physScale;
            this.backWheelMC.inner.rotation = this.backWheelBody.GetAngle() * oneEightyOverPI % 360;
        }
        
        override internal function createDictionaries() : void
        {
            super.createDictionaries();
            contactImpulseDict[this.tankShape] = this.frameSmashLimit;
            contactImpulseDict[this.frontWheelShape] = this.wheelSmashLimit;
            contactImpulseDict[this.backWheelShape] = this.wheelSmashLimit;
            contactAddSounds[this.backWheelShape] = "TireHit1";
            contactAddSounds[this.frontWheelShape] = "TireHit2";
            contactAddSounds[this.tankShape] = "ChairHit1";
            contactAddSounds[this.forkShape] = "ChairHit1";
            contactAddSounds[this.engineShape] = "ChairHit2";
            contactAddSounds[this.rearShape] = "ChairHit3";
        }
        
        override internal function createBodies() : void
        {
            var _loc9_:MovieClip = null;
            super.createBodies();
            var _loc1_:b2BodyDef = new b2BodyDef();
            var _loc2_:b2BodyDef = new b2BodyDef();
            var _loc3_:b2BodyDef = new b2BodyDef();
            var _loc4_:b2PolygonDef = new b2PolygonDef();
            var _loc5_:b2CircleDef = new b2CircleDef();
            _loc4_.density = 3;
            _loc4_.friction = 0.3;
            _loc4_.restitution = 0.1;
            _loc4_.filter.categoryBits = 513;
            _loc5_.density = 5;
            _loc5_.friction = 1;
            _loc5_.restitution = 0.3;
            _loc5_.filter.categoryBits = 513;
            this.frameBody = _session.m_world.CreateBody(_loc1_);
            _loc4_.vertexCount = 3;
            var _loc6_:int = 0;
            while(_loc6_ < 3)
            {
                _loc9_ = shapeGuide["rearVert" + [_loc6_ + 1]];
                _loc4_.vertices[_loc6_] = new b2Vec2(_startX + _loc9_.x / character_scale,_startY + _loc9_.y / character_scale);
                _loc6_++;
            }
            this.rearShape = this.frameBody.CreateShape(_loc4_) as b2PolygonShape;
            _loc4_.vertexCount = 4;
            _loc6_ = 0;
            while(_loc6_ < 4)
            {
                _loc9_ = shapeGuide["middleVert" + [_loc6_ + 1]];
                _loc4_.vertices[_loc6_] = new b2Vec2(_startX + _loc9_.x / character_scale,_startY + _loc9_.y / character_scale);
                _loc6_++;
            }
            this.middleShape = this.frameBody.CreateShape(_loc4_) as b2PolygonShape;
            _loc4_.vertexCount = 5;
            _loc6_ = 0;
            while(_loc6_ < 5)
            {
                _loc9_ = shapeGuide["engineVert" + [_loc6_ + 1]];
                _loc4_.vertices[_loc6_] = new b2Vec2(_startX + _loc9_.x / character_scale,_startY + _loc9_.y / character_scale);
                _loc6_++;
            }
            this.engineShape = this.frameBody.CreateShape(_loc4_) as b2PolygonShape;
            _loc4_.filter = zeroFilter;
            _loc4_.vertexCount = 4;
            _loc6_ = 0;
            while(_loc6_ < 4)
            {
                _loc9_ = shapeGuide["seatVert" + [_loc6_ + 1]];
                _loc4_.vertices[_loc6_] = new b2Vec2(_startX + _loc9_.x / character_scale,_startY + _loc9_.y / character_scale);
                _loc6_++;
            }
            this.seatShape = this.frameBody.CreateShape(_loc4_) as b2PolygonShape;
            _loc4_.vertexCount = 5;
            _loc6_ = 0;
            while(_loc6_ < 5)
            {
                _loc9_ = shapeGuide["tankVert" + [_loc6_ + 1]];
                _loc4_.vertices[_loc6_] = new b2Vec2(_startX + _loc9_.x / character_scale,_startY + _loc9_.y / character_scale);
                _loc6_++;
            }
            this.tankShape = this.frameBody.CreateShape(_loc4_) as b2PolygonShape;
            _loc4_.vertexCount = 3;
            _loc6_ = 0;
            while(_loc6_ < 3)
            {
                _loc9_ = shapeGuide["forkVert" + [_loc6_ + 1]];
                _loc4_.vertices[_loc6_] = new b2Vec2(_startX + _loc9_.x / character_scale,_startY + _loc9_.y / character_scale);
                _loc6_++;
            }
            this.forkShape = this.frameBody.CreateShape(_loc4_) as b2PolygonShape;
            _session.contactListener.registerListener(ContactListener.RESULT,this.rearShape,this.contactFrameResultHandler);
            _session.contactListener.registerListener(ContactListener.RESULT,this.engineShape,this.contactFrameResultHandler);
            _session.contactListener.registerListener(ContactListener.RESULT,this.seatShape,this.contactFrameResultHandler);
            _session.contactListener.registerListener(ContactListener.RESULT,this.tankShape,this.contactFrameResultHandler);
            _session.contactListener.registerListener(ContactListener.RESULT,this.forkShape,this.contactFrameResultHandler);
            _session.contactListener.registerListener(ContactListener.ADD,this.rearShape,contactAddHandler);
            _session.contactListener.registerListener(ContactListener.ADD,this.engineShape,contactAddHandler);
            _session.contactListener.registerListener(ContactListener.ADD,this.tankShape,contactAddHandler);
            _session.contactListener.registerListener(ContactListener.ADD,this.forkShape,contactAddHandler);
            this.frameBody.SetMassFromShapes();
            paintVector.push(this.frameBody);
            _loc5_.filter = zeroFilter;
            var _loc7_:Sprite = shapeGuide["backWheelShape"];
            _loc2_.position.Set(_startX + _loc7_.x / character_scale,_startY + _loc7_.y / character_scale);
            _loc2_.angle = _loc7_.rotation / oneEightyOverPI;
            _loc5_.radius = _loc7_.width / 2 / character_scale;
            this.backWheelBody = _session.m_world.CreateBody(_loc2_);
            this.backWheelShape = this.backWheelBody.CreateShape(_loc5_);
            this.backWheelBody.SetMassFromShapes();
            _session.contactListener.registerListener(ContactListener.RESULT,this.backWheelShape,contactResultHandler);
            _session.contactListener.registerListener(ContactListener.ADD,this.backWheelShape,this.wheelContactAdd);
            _session.contactListener.registerListener(ContactListener.REMOVE,this.backWheelShape,this.wheelContactRemove);
            _loc7_ = shapeGuide["frontWheelShape"];
            _loc3_.position.Set(_startX + _loc7_.x / character_scale,_startY + _loc7_.y / character_scale);
            _loc3_.angle = _loc7_.rotation / oneEightyOverPI;
            _loc5_.radius = _loc7_.width / 2 / character_scale;
            this.frontWheelBody = _session.m_world.CreateBody(_loc3_);
            this.frontWheelShape = this.frontWheelBody.CreateShape(_loc5_);
            this.frontWheelBody.SetMassFromShapes();
            _session.contactListener.registerListener(ContactListener.RESULT,this.frontWheelShape,contactResultHandler);
            _session.contactListener.registerListener(ContactListener.ADD,this.frontWheelShape,this.wheelContactAdd);
            _session.contactListener.registerListener(ContactListener.REMOVE,this.frontWheelShape,this.wheelContactRemove);
            var _loc8_:b2Shape = upperLeg1Body.GetShapeList();
            _loc8_.m_isSensor = true;
            _loc8_ = upperLeg2Body.GetShapeList();
            _loc8_.m_isSensor = true;
        }
        
        override internal function createMovieClips() : void
        {
            super.createMovieClips();
            this.frameMC = sourceObject["frame"];
            var _loc2_:* = 1 / mc_scale;
            this.frameMC.scaleY = 1 / mc_scale;
            this.frameMC.scaleX = _loc2_;
            this.backWheelMC = sourceObject["backWheel"];
            _loc2_ = 1 / mc_scale;
            this.backWheelMC.scaleY = 1 / mc_scale;
            this.backWheelMC.scaleX = _loc2_;
            this.frontWheelMC = sourceObject["frontWheel"];
            _loc2_ = 1 / mc_scale;
            this.frontWheelMC.scaleY = 1 / mc_scale;
            this.frontWheelMC.scaleX = _loc2_;
            this.frontWheelMC.gotoAndStop(1);
            this.backWheelMC.gotoAndStop(1);
            this.frontWheelMC.inner.broken.visible = false;
            this.backWheelMC.inner.broken.visible = false;
            this.frameBody.SetUserData(this.frameMC);
            this.backWheelBody.SetUserData(this.backWheelMC);
            this.frontWheelBody.SetUserData(this.frontWheelMC);
            var _loc1_:b2Vec2 = this.frameBody.GetLocalCenter();
            _loc1_ = new b2Vec2((_startX - _loc1_.x) * character_scale,(_startY - _loc1_.y) * character_scale);
            this.frameMC.inner.x = _loc1_.x;
            this.frameMC.inner.y = _loc1_.y;
            this.brokenForkMC = sourceObject["fork"];
            _loc2_ = 1 / mc_scale;
            this.brokenForkMC.scaleY = 1 / mc_scale;
            this.brokenForkMC.scaleX = _loc2_;
            this.brokenForkMC.visible = false;
            this.brokenTankMC = sourceObject["tank"];
            _loc2_ = 1 / mc_scale;
            this.brokenTankMC.scaleY = 1 / mc_scale;
            this.brokenTankMC.scaleX = _loc2_;
            this.brokenTankMC.visible = false;
            this.brokenEngineMC = sourceObject["engine"];
            _loc2_ = 1 / mc_scale;
            this.brokenEngineMC.scaleY = 1 / mc_scale;
            this.brokenEngineMC.scaleX = _loc2_;
            this.brokenEngineMC.visible = false;
            this.brokenMiddleMC = sourceObject["middle"];
            _loc2_ = 1 / mc_scale;
            this.brokenMiddleMC.scaleY = 1 / mc_scale;
            this.brokenMiddleMC.scaleX = _loc2_;
            this.brokenMiddleMC.visible = false;
            this.brokenRearMC = sourceObject["rear"];
            _loc2_ = 1 / mc_scale;
            this.brokenRearMC.scaleY = 1 / mc_scale;
            this.brokenRearMC.scaleX = _loc2_;
            this.brokenRearMC.visible = false;
            this.brokenSeatMC = sourceObject["seat"];
            _loc2_ = 1 / mc_scale;
            this.brokenSeatMC.scaleY = 1 / mc_scale;
            this.brokenSeatMC.scaleX = _loc2_;
            this.brokenSeatMC.visible = false;
            _session.containerSprite.addChildAt(this.backWheelMC,_session.containerSprite.getChildIndex(chestMC));
            _session.containerSprite.addChildAt(this.frontWheelMC,_session.containerSprite.getChildIndex(chestMC));
            _session.containerSprite.addChildAt(this.frameMC,_session.containerSprite.getChildIndex(chestMC));
            _session.containerSprite.addChildAt(this.frameMC,_session.containerSprite.getChildIndex(chestMC));
            _session.containerSprite.addChildAt(this.brokenRearMC,_session.containerSprite.getChildIndex(chestMC));
            _session.containerSprite.addChildAt(this.brokenSeatMC,_session.containerSprite.getChildIndex(chestMC));
            _session.containerSprite.addChildAt(this.brokenEngineMC,_session.containerSprite.getChildIndex(chestMC));
            _session.containerSprite.addChildAt(this.brokenTankMC,_session.containerSprite.getChildIndex(chestMC));
            _session.containerSprite.addChildAt(this.brokenForkMC,_session.containerSprite.getChildIndex(chestMC));
            this.boostHolder = new Sprite();
            this.boostHolder.graphics.beginFill(13421772);
            this.boostHolder.graphics.drawRoundRect(-2,-52,10,54,4,4);
            this.boostHolder.graphics.endFill();
            this.boostHolder.graphics.beginFill(16613761);
            this.boostHolder.graphics.drawRect(0,0,6,-50);
            this.boostHolder.graphics.endFill();
            _session.addChild(this.boostHolder);
            this.boostHolder.y = 90;
            this.boostHolder.x = 870;
            this.boostMeter = new Sprite();
            this.boostMeter.graphics.beginFill(16776805);
            this.boostMeter.graphics.drawRect(0,0,6,-50);
            this.boostMeter.graphics.endFill();
            this.boostHolder.addChild(this.boostMeter);
            session.particleController.createBMDArray("jetshards",sourceObject["metalShards"]);
        }
        
        override internal function resetMovieClips() : void
        {
            super.resetMovieClips();
            this.frontWheelMC.gotoAndStop(1);
            this.backWheelMC.gotoAndStop(1);
            this.frameMC.visible = true;
            this.frontWheelMC.rim.visible = true;
            this.frontWheelMC.inner.broken.visible = false;
            this.backWheelMC.inner.broken.visible = false;
            this.frontWheelMC.inner.spokes.visible = true;
            this.backWheelMC.inner.spokes.visible = true;
            this.brokenForkMC.visible = false;
            this.brokenTankMC.visible = false;
            this.brokenEngineMC.visible = false;
            this.brokenMiddleMC.visible = false;
            this.brokenRearMC.visible = false;
            this.brokenSeatMC.visible = false;
            this.frameBody.SetUserData(this.frameMC);
            this.backWheelBody.SetUserData(this.backWheelMC);
            this.frontWheelBody.SetUserData(this.frontWheelMC);
            _session.addChild(this.boostHolder);
            session.particleController.createBMDArray("jetshards",sourceObject["metalShards"]);
        }
        
        override internal function createJoints() : void
        {
            var _loc1_:Number = NaN;
            var _loc2_:Number = NaN;
            var _loc3_:Number = NaN;
            super.createJoints();
            var _loc4_:Number = oneEightyOverPI;
            _loc1_ = upperLeg1Body.GetAngle() - pelvisBody.GetAngle();
            _loc2_ = -110 / _loc4_ - _loc1_;
            _loc3_ = 10 / _loc4_ - _loc1_;
            _loc1_ = upperLeg2Body.GetAngle() - pelvisBody.GetAngle();
            _loc2_ = -110 / _loc4_ - _loc1_;
            _loc3_ = 10 / _loc4_ - _loc1_;
            _loc1_ = lowerArm1Body.GetAngle() - upperArm1Body.GetAngle();
            _loc2_ = -90 / _loc4_ - _loc1_;
            _loc3_ = 0 / _loc4_ - _loc1_;
            elbowJoint1.SetLimits(_loc2_,_loc3_);
            _loc1_ = lowerArm2Body.GetAngle() - upperArm2Body.GetAngle();
            _loc2_ = -90 / _loc4_ - _loc1_;
            _loc3_ = 0 / _loc4_ - _loc1_;
            elbowJoint2.SetLimits(_loc2_,_loc3_);
            _loc1_ = head1Body.GetAngle() - chestBody.GetAngle();
            _loc2_ = -20 / _loc4_ - _loc1_;
            _loc3_ = 0 / _loc4_ - _loc1_;
            neckJoint.SetLimits(_loc2_,_loc3_);
            var _loc5_:b2RevoluteJointDef = new b2RevoluteJointDef();
            _loc5_.maxMotorTorque = this.maxTorque;
            var _loc6_:b2Vec2 = new b2Vec2();
            var _loc7_:MovieClip = shapeGuide["backWheelShape"];
            _loc6_.Set(_startX + _loc7_.x / character_scale,_startY + _loc7_.y / character_scale);
            _loc5_.Initialize(this.frameBody,this.backWheelBody,_loc6_);
            this.backWheelJoint = _session.m_world.CreateJoint(_loc5_) as b2RevoluteJoint;
            _loc7_ = shapeGuide["frontWheelShape"];
            _loc6_.Set(_startX + _loc7_.x / character_scale,_startY + _loc7_.y / character_scale);
            _loc5_.Initialize(this.frameBody,this.frontWheelBody,_loc6_);
            this.frontWheelJoint = _session.m_world.CreateJoint(_loc5_) as b2RevoluteJoint;
            _loc6_.Set(pelvisBody.GetPosition().x,pelvisBody.GetPosition().y);
            _loc5_.Initialize(this.frameBody,pelvisBody,_loc6_);
            this.framePelvis = _session.m_world.CreateJoint(_loc5_) as b2RevoluteJoint;
            this.framePelvisJointDef = _loc5_.clone();
            this.pelvisAnchorPoint = this.frameBody.GetLocalPoint(_loc6_);
            _loc7_ = shapeGuide["handleAnchor"];
            _loc6_.Set(_startX + _loc7_.x / character_scale,_startY + _loc7_.y / character_scale);
            _loc5_.Initialize(this.frameBody,lowerArm1Body,_loc6_);
            this.frameHand1 = _session.m_world.CreateJoint(_loc5_) as b2RevoluteJoint;
            this.frameHand1JointDef = _loc5_.clone();
            this.handleAnchorPoint = this.frameBody.GetLocalPoint(_loc6_);
            _loc5_.Initialize(this.frameBody,lowerArm2Body,_loc6_);
            this.frameHand2 = _session.m_world.CreateJoint(_loc5_) as b2RevoluteJoint;
            this.frameHand2JointDef = _loc5_.clone();
            _loc7_ = shapeGuide["footAnchor"];
            _loc6_.Set(_startX + _loc7_.x / character_scale,_startY + _loc7_.y / character_scale);
            _loc5_.Initialize(this.frameBody,lowerLeg1Body,_loc6_);
            this.frameFoot1 = _session.m_world.CreateJoint(_loc5_) as b2RevoluteJoint;
            this.frameFoot1JointDef = _loc5_.clone();
            this.footAnchorPoint = this.frameBody.GetLocalPoint(_loc6_);
            _loc5_.Initialize(this.frameBody,lowerLeg2Body,_loc6_);
            this.frameFoot2 = _session.m_world.CreateJoint(_loc5_) as b2RevoluteJoint;
            this.frameFoot2JointDef = _loc5_.clone();
        }
        
        protected function contactFrameResultHandler(param1:ContactEvent) : void
        {
            var _loc2_:Number = param1.impulse;
            if(_loc2_ > contactImpulseDict[this.tankShape])
            {
                if(contactResultBuffer[this.tankShape])
                {
                    if(_loc2_ > contactResultBuffer[this.tankShape].impulse)
                    {
                        contactResultBuffer[this.tankShape] = param1;
                    }
                }
                else
                {
                    contactResultBuffer[this.tankShape] = param1;
                }
            }
        }
        
        override protected function handleContactResults() : void
        {
            var _loc1_:ContactEvent = null;
            super.handleContactResults();
            if(contactResultBuffer[this.tankShape])
            {
                _loc1_ = contactResultBuffer[this.tankShape];
                this.frameSmash(_loc1_.impulse,_loc1_.normal);
                delete contactResultBuffer[this.tankShape];
                delete contactAddBuffer[this.tankShape];
                delete contactAddBuffer[this.forkShape];
                delete contactAddBuffer[this.engineShape];
                delete contactAddBuffer[this.rearShape];
            }
            if(contactResultBuffer[this.frontWheelShape])
            {
                _loc1_ = contactResultBuffer[this.frontWheelShape];
                this.frontWheelSmash(_loc1_.impulse,_loc1_.normal);
                delete contactResultBuffer[this.frontWheelShape];
                delete contactAddBuffer[this.frontWheelShape];
            }
            if(contactResultBuffer[this.backWheelShape])
            {
                _loc1_ = contactResultBuffer[this.backWheelShape];
                this.backWheelSmash(_loc1_.impulse,_loc1_.normal);
                delete contactResultBuffer[this.backWheelShape];
                delete contactAddBuffer[this.backWheelShape];
            }
        }
        
        protected function wheelContactAdd(param1:b2ContactPoint) : void
        {
            if(param1.shape2.m_isSensor)
            {
                return;
            }
            if(param1.shape1 == this.frontWheelShape)
            {
                this.frontContacts += 1;
            }
            else
            {
                this.backContacts += 1;
            }
            this.wheelContacts = this.frontContacts + this.backContacts;
            var _loc2_:b2Shape = param1.shape1;
            var _loc3_:b2Body = _loc2_.m_body;
            var _loc4_:b2Shape = param1.shape2;
            var _loc5_:b2Body = _loc4_.m_body;
            var _loc6_:Number = _loc5_.m_mass;
            if(contactAddBuffer[_loc2_])
            {
                return;
            }
            if(_loc6_ != 0 && _loc6_ < _loc3_.m_mass)
            {
                return;
            }
            var _loc7_:Number = b2Math.b2Dot(param1.velocity,param1.normal);
            _loc7_ = Math.abs(_loc7_);
            if(_loc7_ > 4)
            {
                contactAddBuffer[_loc2_] = "hit";
            }
        }
        
        protected function wheelContactRemove(param1:b2ContactPoint) : void
        {
            if(param1.shape2.m_isSensor)
            {
                return;
            }
            if(param1.shape1 == this.frontWheelShape)
            {
                --this.frontContacts;
            }
            else
            {
                --this.backContacts;
            }
            this.wheelContacts = this.frontContacts + this.backContacts;
        }
        
        override internal function eject() : void
        {
            if(this.ejected)
            {
                return;
            }
            removeAction(this.reAttaching);
            this.ejected = true;
            resetJointLimits();
            var _loc1_:b2World = session.m_world;
            if(this.framePelvis)
            {
                _loc1_.DestroyJoint(this.framePelvis);
                this.framePelvis = null;
            }
            if(this.frameHand1)
            {
                _loc1_.DestroyJoint(this.frameHand1);
                this.frameHand1 = null;
            }
            if(this.frameHand2)
            {
                _loc1_.DestroyJoint(this.frameHand2);
                this.frameHand2 = null;
            }
            if(this.frameFoot1)
            {
                _loc1_.DestroyJoint(this.frameFoot1);
                this.frameFoot1 = null;
            }
            if(this.frameFoot2)
            {
                _loc1_.DestroyJoint(this.frameFoot2);
                this.frameFoot2 = null;
            }
            var _loc2_:b2Shape = this.frameBody.GetShapeList();
            while(_loc2_)
            {
                _loc2_.SetFilterData(zeroFilter);
                _loc1_.Refilter(_loc2_);
                _loc2_ = _loc2_.m_next;
            }
            _loc2_ = upperLeg1Body.GetShapeList();
            _loc2_.m_isSensor = false;
            _loc1_.Refilter(_loc2_);
            _loc2_ = upperLeg2Body.GetShapeList();
            _loc2_.m_isSensor = false;
            _loc1_.Refilter(_loc2_);
            _loc2_ = lowerLeg1Body.GetShapeList();
            _loc2_.m_isSensor = false;
            _loc1_.Refilter(_loc2_);
            _loc2_ = lowerLeg2Body.GetShapeList();
            _loc2_.m_isSensor = false;
            _loc1_.Refilter(_loc2_);
        }
        
        override public function set dead(param1:Boolean) : void
        {
            _dead = param1;
            if(_dead)
            {
                userVehicleEject();
                currentPose = 0;
                releaseGrip();
                this.backWheelJoint.EnableMotor(false);
                this.frontWheelJoint.EnableMotor(false);
                if(voiceSound)
                {
                    voiceSound.stopSound();
                    voiceSound = null;
                }
            }
        }
        
        internal function frameSmash(param1:Number, param2:b2Vec2) : void
        {
            trace("frame impulse " + param1);
            delete contactImpulseDict[this.tankShape];
            var _loc3_:ContactListener = _session.contactListener;
            _loc3_.deleteListener(ContactListener.RESULT,this.rearShape);
            _loc3_.deleteListener(ContactListener.RESULT,this.engineShape);
            _loc3_.deleteListener(ContactListener.RESULT,this.seatShape);
            _loc3_.deleteListener(ContactListener.RESULT,this.tankShape);
            _loc3_.deleteListener(ContactListener.RESULT,this.forkShape);
            _loc3_.deleteListener(ContactListener.ADD,this.rearShape);
            _loc3_.deleteListener(ContactListener.ADD,this.engineShape);
            _loc3_.deleteListener(ContactListener.ADD,this.tankShape);
            _loc3_.deleteListener(ContactListener.ADD,this.forkShape);
            this.eject();
            this.frameSmashed = true;
            var _loc4_:b2World = _session.m_world;
            var _loc5_:b2Vec2 = this.frameBody.GetPosition();
            var _loc6_:Number = this.frameBody.GetAngle();
            var _loc7_:b2Vec2 = this.frameBody.GetLinearVelocity();
            var _loc8_:Number = this.frameBody.GetAngularVelocity();
            var _loc9_:b2BodyDef = new b2BodyDef();
            _loc9_.position = _loc5_;
            _loc9_.angle = _loc6_;
            var _loc10_:b2PolygonDef = new b2PolygonDef();
            _loc10_.density = 3;
            _loc10_.friction = 0.3;
            _loc10_.restitution = 0.1;
            _loc10_.filter = zeroFilter;
            var _loc11_:b2Body = _loc4_.CreateBody(_loc9_);
            _loc11_.SetLinearVelocity(_loc7_);
            _loc11_.SetAngularVelocity(_loc8_);
            var _loc12_:b2Body = _loc4_.CreateBody(_loc9_);
            _loc12_.SetLinearVelocity(_loc7_);
            _loc12_.SetAngularVelocity(_loc8_);
            var _loc13_:b2Body = _loc4_.CreateBody(_loc9_);
            _loc13_.SetLinearVelocity(_loc7_);
            _loc13_.SetAngularVelocity(_loc8_);
            var _loc14_:b2Body = _loc4_.CreateBody(_loc9_);
            _loc14_.SetLinearVelocity(_loc7_);
            _loc14_.SetAngularVelocity(_loc8_);
            var _loc15_:b2Body = _loc4_.CreateBody(_loc9_);
            _loc15_.SetLinearVelocity(_loc7_);
            _loc15_.SetAngularVelocity(_loc8_);
            var _loc16_:b2Body = _loc4_.CreateBody(_loc9_);
            _loc16_.SetLinearVelocity(_loc7_);
            _loc16_.SetAngularVelocity(_loc8_);
            var _loc17_:Array = this.rearShape.GetVertices();
            _loc10_.vertexCount = 3;
            _loc10_.vertices = _loc17_;
            _loc15_.CreateShape(_loc10_);
            _loc15_.SetMassFromShapes();
            _loc17_ = this.middleShape.GetVertices();
            _loc10_.vertexCount = 4;
            _loc10_.vertices = _loc17_;
            _loc14_.CreateShape(_loc10_);
            _loc14_.SetMassFromShapes();
            _loc17_ = this.engineShape.GetVertices();
            _loc10_.vertexCount = 5;
            _loc10_.vertices = _loc17_;
            _loc13_.CreateShape(_loc10_);
            _loc13_.SetMassFromShapes();
            _loc17_ = this.seatShape.GetVertices();
            _loc10_.vertexCount = 4;
            _loc10_.vertices = _loc17_;
            _loc16_.CreateShape(_loc10_);
            _loc16_.SetMassFromShapes();
            _loc17_ = this.tankShape.GetVertices();
            _loc10_.vertexCount = 5;
            _loc10_.vertices = _loc17_;
            _loc12_.CreateShape(_loc10_);
            _loc12_.SetMassFromShapes();
            _loc17_ = this.forkShape.GetVertices();
            _loc10_.vertexCount = 3;
            _loc10_.vertices = _loc17_;
            _loc11_.CreateShape(_loc10_);
            _loc11_.SetMassFromShapes();
            this.brokenRearMC.visible = true;
            _loc15_.SetUserData(this.brokenRearMC);
            paintVector.push(_loc15_);
            this.brokenMiddleMC.visible = true;
            _loc14_.SetUserData(this.brokenMiddleMC);
            paintVector.push(_loc14_);
            this.brokenEngineMC.visible = true;
            _loc13_.SetUserData(this.brokenEngineMC);
            paintVector.push(_loc13_);
            this.brokenSeatMC.visible = true;
            _loc16_.SetUserData(this.brokenSeatMC);
            paintVector.push(_loc16_);
            this.brokenTankMC.visible = true;
            _loc12_.SetUserData(this.brokenTankMC);
            paintVector.push(_loc12_);
            this.brokenForkMC.visible = true;
            _loc11_.SetUserData(this.brokenForkMC);
            paintVector.push(_loc11_);
            _loc4_.DestroyBody(this.frameBody);
            this.tankShape = null;
            session.particleController.createPointBurst("jetshards",_loc5_.x * m_physScale,_loc5_.y * m_physScale,5,50,50,_session.containerSprite.getChildIndex(this.frameMC));
            this.frameMC.visible = false;
            this.frontWheelMC.rim.visible = false;
            SoundController.instance.playAreaSoundInstance("MetalSmashHeavy",_loc12_);
        }
        
        internal function frontWheelSmash(param1:Number, param2:b2Vec2) : void
        {
            trace("front wheel impulse " + param1);
            this.frontWheelMC.gotoAndStop(2);
            this.frontWheelMC.inner.spokes.visible = false;
            this.frontWheelMC.inner.broken.visible = true;
            delete contactImpulseDict[this.frontWheelShape];
            _session.contactListener.deleteListener(ContactListener.RESULT,this.frontWheelShape);
            _session.contactListener.deleteListener(ContactListener.ADD,this.frontWheelShape);
            _session.contactListener.deleteListener(ContactListener.REMOVE,this.frontWheelShape);
            var _loc3_:b2Shape = this.frontWheelBody.GetShapeList();
            this.frontWheelBody.DestroyShape(_loc3_);
            var _loc4_:b2PolygonDef = new b2PolygonDef();
            _loc4_.density = 2;
            _loc4_.friction = 0.3;
            _loc4_.restitution = 0.1;
            if(this.ejected)
            {
                _loc4_.filter = zeroFilter;
            }
            else
            {
                _loc4_.filter.categoryBits = 513;
            }
            var _loc5_:Number = Math.atan2(param2.y,param2.x);
            var _loc6_:Number = _loc5_ - this.frontWheelBody.GetAngle();
            this.frontWheelMC.inner.broken.rotation = _loc6_ * oneEightyOverPI;
            _loc4_.SetAsOrientedBox(25 / character_scale,45 / character_scale,new b2Vec2(0,0),_loc6_);
            this.frontWheelBody.CreateShape(_loc4_);
            SoundController.instance.playAreaSoundInstance("BikeTireSmash1",this.frontWheelBody);
        }
        
        internal function backWheelSmash(param1:Number, param2:b2Vec2) : void
        {
            trace("back wheel impulse " + param1);
            this.backWheelMC.gotoAndStop(2);
            this.backWheelMC.inner.spokes.visible = false;
            this.backWheelMC.inner.broken.visible = true;
            delete contactImpulseDict[this.backWheelShape];
            _session.contactListener.deleteListener(ContactListener.RESULT,this.backWheelShape);
            _session.contactListener.deleteListener(ContactListener.ADD,this.backWheelShape);
            _session.contactListener.deleteListener(ContactListener.REMOVE,this.backWheelShape);
            var _loc3_:b2Shape = this.backWheelBody.GetShapeList();
            this.backWheelBody.DestroyShape(_loc3_);
            var _loc4_:b2PolygonDef = new b2PolygonDef();
            _loc4_.density = 2;
            _loc4_.friction = 0.3;
            _loc4_.restitution = 0.1;
            if(this.ejected)
            {
                _loc4_.filter = zeroFilter;
            }
            else
            {
                _loc4_.filter.categoryBits = 513;
            }
            var _loc5_:Number = Math.atan2(param2.y,param2.x);
            var _loc6_:Number = _loc5_ - this.backWheelBody.GetAngle();
            this.backWheelMC.inner.broken.rotation = _loc6_ * oneEightyOverPI;
            _loc4_.SetAsOrientedBox(25 / character_scale,45 / character_scale,new b2Vec2(0,0),_loc6_);
            this.backWheelBody.CreateShape(_loc4_);
            SoundController.instance.playAreaSoundInstance("BikeTireSmash1",this.backWheelBody);
        }
        
        internal function checkEject() : void
        {
            if(!this.frameHand1 && !this.frameHand2 && !this.frameFoot1 && !this.frameFoot2)
            {
                this.eject();
            }
        }
        
        override internal function headSmash1(param1:Number) : void
        {
            super.headSmash1(param1);
            this.eject();
        }
        
        override internal function chestSmash(param1:Number) : void
        {
            super.chestSmash(param1);
            this.eject();
        }
        
        override internal function pelvisSmash(param1:Number) : void
        {
            super.pelvisSmash(param1);
            this.eject();
        }
        
        override internal function torsoBreak(param1:Number, param2:Boolean = true, param3:Boolean = true) : void
        {
            super.torsoBreak(param1,param2,param3);
            this.eject();
        }
        
        override internal function neckBreak(param1:Number, param2:Boolean = true, param3:Boolean = true) : void
        {
            super.neckBreak(param1,param2,param3);
            if(this.frameHand1)
            {
                _session.m_world.DestroyJoint(this.frameHand1);
                this.frameHand1 = null;
            }
            if(this.frameHand2)
            {
                _session.m_world.DestroyJoint(this.frameHand2);
                this.frameHand2 = null;
            }
            this.checkEject();
        }
        
        override internal function elbowBreak1(param1:Number) : void
        {
            super.elbowBreak1(param1);
            if(this.ejected)
            {
                return;
            }
            if(this.frameHand1)
            {
                _session.m_world.DestroyJoint(this.frameHand1);
                this.frameHand1 = null;
            }
            this.checkEject();
        }
        
        override internal function elbowBreak2(param1:Number) : void
        {
            super.elbowBreak2(param1);
            if(this.ejected)
            {
                return;
            }
            if(this.frameHand2)
            {
                _session.m_world.DestroyJoint(this.frameHand2);
                this.frameHand2 = null;
            }
            this.checkEject();
        }
        
        override internal function shoulderBreak1(param1:Number, param2:Boolean = true) : void
        {
            super.shoulderBreak1(param1,param2);
            lowerArm1Shape.m_isSensor = false;
            _session.m_world.Refilter(lowerArm1Shape);
            if(this.ejected)
            {
                return;
            }
            if(this.frameHand1)
            {
                _session.m_world.DestroyJoint(this.frameHand1);
                this.frameHand1 = null;
            }
            this.checkEject();
        }
        
        override internal function shoulderBreak2(param1:Number, param2:Boolean = true) : void
        {
            super.shoulderBreak2(param1,param2);
            lowerArm2Shape.m_isSensor = false;
            _session.m_world.Refilter(lowerArm2Shape);
            if(this.ejected)
            {
                return;
            }
            if(this.frameHand2)
            {
                _session.m_world.DestroyJoint(this.frameHand2);
                this.frameHand2 = null;
            }
            this.checkEject();
        }
        
        override internal function hipBreak1(param1:Number, param2:Boolean = true) : void
        {
            super.hipBreak1(param1,param2);
            if(this.ejected)
            {
                return;
            }
            if(this.frameFoot1)
            {
                _session.m_world.DestroyJoint(this.frameFoot1);
                this.frameFoot1 = null;
            }
            this.checkEject();
        }
        
        override internal function hipBreak2(param1:Number, param2:Boolean = true) : void
        {
            super.hipBreak2(param1,param2);
            if(this.ejected)
            {
                return;
            }
            if(this.frameFoot2)
            {
                _session.m_world.DestroyJoint(this.frameFoot2);
                this.frameFoot2 = null;
            }
            this.checkEject();
        }
        
        override internal function kneeBreak1(param1:Number) : void
        {
            super.kneeBreak1(param1);
            if(this.ejected)
            {
                return;
            }
            if(this.frameFoot1)
            {
                _session.m_world.DestroyJoint(this.frameFoot1);
                this.frameFoot1 = null;
            }
            this.checkEject();
        }
        
        override internal function kneeBreak2(param1:Number) : void
        {
            super.kneeBreak2(param1);
            if(this.ejected)
            {
                return;
            }
            if(this.frameFoot2)
            {
                _session.m_world.DestroyJoint(this.frameFoot2);
                this.frameFoot2 = null;
            }
            this.checkEject();
        }
        
        internal function leanBackPose() : void
        {
            setJoint(neckJoint,0,2);
            setJoint(elbowJoint1,1.04,15);
            setJoint(elbowJoint2,1.04,15);
        }
        
        internal function leanForwardPose() : void
        {
            setJoint(neckJoint,1,1);
            setJoint(elbowJoint1,0,15);
            setJoint(elbowJoint2,0,15);
        }
        
        override internal function grabAction(param1:b2Body, param2:b2Shape, param3:b2Body) : void
        {
            var _loc7_:b2Vec2 = null;
            var _loc8_:Vehicle = null;
            var _loc4_:b2Shape = param1.GetShapeList();
            var _loc5_:b2Vec2 = param1.GetWorldPoint(new b2Vec2(0,(_loc4_ as b2PolygonShape).GetVertices()[2].y));
            if(!this.frameSmashed && !_dying && !userVehicle)
            {
                _loc7_ = this.frameBody.GetWorldPoint(this.handleAnchorPoint);
                if(Math.abs(_loc5_.x - _loc7_.x) < this.reAttachDistance && Math.abs(_loc5_.y - _loc7_.y) < this.reAttachDistance)
                {
                    this.reAttach(param1);
                    return;
                }
            }
            var _loc6_:b2RevoluteJointDef = new b2RevoluteJointDef();
            if(!param3.IsStatic())
            {
                _loc6_.enableLimit = true;
            }
            _loc6_.maxMotorTorque = 4;
            _loc6_.Initialize(param3,param1,_loc5_);
            if(param1 == lowerArm1Body)
            {
                lowerArm1MC.hand.gotoAndStop(1);
                _session.contactListener.deleteListener(ContactListener.RESULT,lowerArm1Shape);
                if(param2.GetUserData() is Vehicle)
                {
                    _loc8_ = param2.GetUserData();
                    if(Boolean(userVehicle) && _loc8_ != userVehicle)
                    {
                        gripJoint1 = _session.m_world.CreateJoint(_loc6_) as b2RevoluteJoint;
                    }
                    else
                    {
                        userVehicle = param2.GetUserData();
                        userVehicle.addCharacter(this);
                        vehicleArm1Joint = _session.m_world.CreateJoint(_loc6_) as b2RevoluteJoint;
                        currentPose = 0;
                        switch(userVehicle.characterPose)
                        {
                            case 0:
                                break;
                            case 1:
                                currentPose = 10;
                                break;
                            case 2:
                                currentPose = 11;
                                break;
                            case 3:
                                currentPose = 12;
                        }
                    }
                }
                else
                {
                    gripJoint1 = _session.m_world.CreateJoint(_loc6_) as b2RevoluteJoint;
                }
            }
            if(param1 == lowerArm2Body)
            {
                lowerArm2MC.hand.gotoAndStop(1);
                _session.contactListener.deleteListener(ContactListener.RESULT,lowerArm2Shape);
                if(param2.GetUserData() is Vehicle)
                {
                    _loc8_ = param2.GetUserData();
                    if(Boolean(userVehicle) && _loc8_ != userVehicle)
                    {
                        gripJoint2 = _session.m_world.CreateJoint(_loc6_) as b2RevoluteJoint;
                    }
                    else
                    {
                        userVehicle = param2.GetUserData();
                        userVehicle.addCharacter(this);
                        vehicleArm2Joint = _session.m_world.CreateJoint(_loc6_) as b2RevoluteJoint;
                        currentPose = 0;
                        switch(userVehicle.characterPose)
                        {
                            case 0:
                                break;
                            case 1:
                                currentPose = 10;
                                break;
                            case 2:
                                currentPose = 11;
                                break;
                            case 3:
                                currentPose = 12;
                        }
                    }
                }
                else
                {
                    gripJoint2 = _session.m_world.CreateJoint(_loc6_) as b2RevoluteJoint;
                }
            }
        }
        
        protected function reAttach(param1:b2Body) : void
        {
            var _loc2_:Number = NaN;
            var _loc3_:Number = NaN;
            var _loc4_:Number = NaN;
            trace("RE ATTACH");
            _session.contactListener.deleteListener(ContactListener.RESULT,lowerArm1Shape);
            _session.contactListener.deleteListener(ContactListener.RESULT,lowerArm2Shape);
            delete contactResultBuffer[lowerArm1Shape];
            delete contactResultBuffer[lowerArm2Shape];
            this.ejected = false;
            currentPose = 0;
            releaseGrip();
            var _loc5_:Number = 180 / Math.PI;
            _loc2_ = head1Body.GetAngle() - chestBody.GetAngle() - neckJoint.GetJointAngle();
            _loc3_ = -20 / _loc5_ - _loc2_;
            _loc4_ = 0 / _loc5_ - _loc2_;
            neckJoint.SetLimits(_loc3_,_loc4_);
            _loc2_ = lowerArm1Body.GetAngle() - upperArm1Body.GetAngle() - elbowJoint1.GetJointAngle();
            _loc3_ = -90 / _loc5_ - _loc2_;
            _loc4_ = 0 / _loc5_ - _loc2_;
            elbowJoint1.SetLimits(_loc3_,_loc4_);
            _loc2_ = lowerArm2Body.GetAngle() - upperArm2Body.GetAngle() - elbowJoint2.GetJointAngle();
            _loc3_ = -90 / _loc5_ - _loc2_;
            _loc4_ = 0 / _loc5_ - _loc2_;
            elbowJoint2.SetLimits(_loc3_,_loc4_);
            var _loc6_:b2World = _session.m_world;
            if(param1 == lowerArm1Body)
            {
                this.frameHand1 = _loc6_.CreateJoint(this.frameHand1JointDef) as b2RevoluteJoint;
                lowerArm1MC.hand.gotoAndStop(1);
            }
            else
            {
                this.frameHand2 = _loc6_.CreateJoint(this.frameHand2JointDef) as b2RevoluteJoint;
                lowerArm2MC.hand.gotoAndStop(1);
            }
            actionsVector.push(this.reAttaching);
        }
        
        public function reAttaching() : void
        {
            var _loc7_:b2Vec2 = null;
            var _loc8_:b2Vec2 = null;
            var _loc9_:b2Shape = null;
            var _loc1_:int = 0;
            var _loc2_:b2World = _session.m_world;
            if(!this.frameHand1 && !elbowJoint1.broken && !shoulderJoint1.broken)
            {
                _loc7_ = lowerArm1Body.GetWorldPoint(new b2Vec2(0,(lowerArm1Shape as b2PolygonShape).GetVertices()[2].y));
                _loc8_ = this.frameBody.GetWorldPoint(this.handleAnchorPoint);
                if(Math.abs(_loc7_.x - _loc8_.x) < this.reAttachDistance && Math.abs(_loc7_.y - _loc8_.y) < this.reAttachDistance)
                {
                    this.frameHand1 = _loc2_.CreateJoint(this.frameHand1JointDef) as b2RevoluteJoint;
                    lowerArm1MC.hand.gotoAndStop(1);
                    _loc1_ += 1;
                }
            }
            else
            {
                _loc1_ += 1;
            }
            if(!this.frameHand2 && !elbowJoint2.broken && !shoulderJoint2.broken)
            {
                _loc7_ = lowerArm2Body.GetWorldPoint(new b2Vec2(0,(lowerArm2Shape as b2PolygonShape).GetVertices()[2].y));
                _loc8_ = this.frameBody.GetWorldPoint(this.handleAnchorPoint);
                if(Math.abs(_loc7_.x - _loc8_.x) < this.reAttachDistance && Math.abs(_loc7_.y - _loc8_.y) < this.reAttachDistance)
                {
                    this.frameHand2 = _loc2_.CreateJoint(this.frameHand2JointDef) as b2RevoluteJoint;
                    lowerArm2MC.hand.gotoAndStop(1);
                    _loc1_ += 1;
                }
            }
            else
            {
                _loc1_ += 1;
            }
            var _loc3_:Number = -0.87;
            var _loc4_:Number = Number(hipJoint1.GetJointAngle());
            var _loc5_:Number = Number(hipJoint2.GetJointAngle());
            var _loc6_:Boolean = (_loc4_ < _loc3_ || Boolean(hipJoint1.broken)) && (_loc5_ < _loc3_ || Boolean(hipJoint2.broken)) ? true : false;
            if(!this.framePelvis)
            {
                _loc7_ = pelvisBody.GetPosition();
                _loc8_ = this.frameBody.GetWorldPoint(this.pelvisAnchorPoint);
                if(Math.abs(_loc7_.x - _loc8_.x) < this.reAttachDistance && Math.abs(_loc7_.y - _loc8_.y) < this.reAttachDistance && _loc6_)
                {
                    trace("frame PELVIS " + _loc4_ + " " + _loc5_);
                    this.framePelvis = _loc2_.CreateJoint(this.framePelvisJointDef) as b2RevoluteJoint;
                    _loc9_ = upperLeg1Body.GetShapeList();
                    _loc9_.m_isSensor = true;
                    _loc2_.Refilter(_loc9_);
                    _loc9_ = upperLeg2Body.GetShapeList();
                    _loc9_.m_isSensor = true;
                    _loc2_.Refilter(_loc9_);
                    _loc1_ += 1;
                }
            }
            else
            {
                _loc1_ += 1;
            }
            if(this.framePelvis)
            {
                if(!this.frameFoot1 && !kneeJoint1.broken && !hipJoint1.broken)
                {
                    _loc7_ = lowerLeg1Body.GetWorldPoint(new b2Vec2(0,(lowerLeg1Shape as b2PolygonShape).GetVertices()[2].y));
                    _loc8_ = this.frameBody.GetWorldPoint(this.footAnchorPoint);
                    if(Math.abs(_loc7_.x - _loc8_.x) < this.reAttachDistance && Math.abs(_loc7_.y - _loc8_.y) < this.reAttachDistance)
                    {
                        this.frameFoot1 = _loc2_.CreateJoint(this.frameFoot1JointDef) as b2RevoluteJoint;
                        _loc1_ += 1;
                    }
                }
                else
                {
                    _loc1_ += 1;
                }
                if(!this.frameFoot2 && !kneeJoint2.broken && !hipJoint2.broken)
                {
                    _loc7_ = lowerLeg2Body.GetWorldPoint(new b2Vec2(0,(lowerLeg2Shape as b2PolygonShape).GetVertices()[2].y));
                    _loc8_ = this.frameBody.GetWorldPoint(this.footAnchorPoint);
                    if(Math.abs(_loc7_.x - _loc8_.x) < this.reAttachDistance && Math.abs(_loc7_.y - _loc8_.y) < this.reAttachDistance)
                    {
                        this.frameFoot2 = _loc2_.CreateJoint(this.frameFoot2JointDef) as b2RevoluteJoint;
                        _loc1_ += 1;
                    }
                }
                else
                {
                    _loc1_ += 1;
                }
            }
            if(_loc1_ >= 5)
            {
                trace("ATTACH COMPLETE");
                trace("currpose " + _currentPose);
                removeAction(this.reAttaching);
            }
        }
    }
}

