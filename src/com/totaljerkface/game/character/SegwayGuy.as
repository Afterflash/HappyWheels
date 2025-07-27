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
    import com.totaljerkface.game.sound.*;
    import flash.display.*;
    import flash.events.*;
    import flash.utils.*;
    
    public class SegwayGuy extends CharacterB2D
    {
        protected var ejected:Boolean;
        
        protected var helmetOn:Boolean;
        
        protected var wheelMaxSpeed:Number = 40;
        
        protected var wheelCurrentSpeed:Number;
        
        protected var wheelNewSpeed:Number;
        
        protected var accelStep:Number = 1;
        
        protected var maxTorque:Number = 20;
        
        protected var wheelContacts:Number = 0;
        
        protected var impulseMagnitude:Number = 3;
        
        protected var impulseOffset:Number = 1;
        
        protected var maxSpinAV:Number = 5;
        
        protected var helmetSmashLimit:Number = 2;
        
        protected var frameSmashLimit:Number = 20;
        
        protected var frameSmashed:Boolean;
        
        protected var jumpTranslation:Number;
        
        protected var charge:int = 0;
        
        protected var chargeMax:int = 15;
        
        protected var chargeMin:int = 5;
        
        protected var wheelLoop1:AreaSoundLoop;
        
        protected var wheelLoop2:AreaSoundLoop;
        
        protected var wheelLoop3:AreaSoundLoop;
        
        protected var motorSound:AreaSoundLoop;
        
        protected var handleAnchorPoint:b2Vec2;
        
        protected var footAnchorPoint:b2Vec2;
        
        protected var frameHand1JointDef:b2RevoluteJointDef;
        
        protected var frameHand2JointDef:b2RevoluteJointDef;
        
        protected var standFoot1JointDef:b2RevoluteJointDef;
        
        protected var standFoot2JointDef:b2RevoluteJointDef;
        
        internal var frameBody:b2Body;
        
        internal var shockBody:b2Body;
        
        internal var wheelBody:b2Body;
        
        internal var standBody:b2Body;
        
        internal var helmetBody:b2Body;
        
        internal var helmetShape:b2Shape;
        
        internal var frameShape:b2Shape;
        
        internal var wheelShape:b2Shape;
        
        internal var standShape:b2Shape;
        
        internal var frameMC:MovieClip;
        
        internal var wheelMC:MovieClip;
        
        internal var wheelCoverMC:MovieClip;
        
        internal var shockMC:Sprite;
        
        internal var helmetMC:MovieClip;
        
        internal var shockJoint:b2PrismaticJoint;
        
        internal var wheelJoint:b2RevoluteJoint;
        
        internal var standFrame:b2RevoluteJoint;
        
        internal var frameHand1:b2RevoluteJoint;
        
        internal var frameHand2:b2RevoluteJoint;
        
        internal var standFoot1:b2RevoluteJoint;
        
        internal var standFoot2:b2RevoluteJoint;
        
        public function SegwayGuy(param1:Number, param2:Number, param3:DisplayObject, param4:Session)
        {
            super(param1,param2,param3,param4,-1,"Char2");
            this.jumpTranslation = 30 / m_physScale;
        }
        
        override internal function leftPressedActions() : void
        {
            if(this.ejected)
            {
                currentPose = 1;
            }
            else
            {
                this.leanBackward();
            }
        }
        
        override internal function rightPressedActions() : void
        {
            if(this.ejected)
            {
                currentPose = 2;
            }
            else
            {
                this.leanForward();
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
            else
            {
                this.noLean();
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
                if(!this.wheelJoint.IsMotorEnabled())
                {
                    this.wheelJoint.EnableMotor(true);
                }
                this.wheelCurrentSpeed = this.wheelJoint.GetJointSpeed();
                this.wheelNewSpeed = this.wheelCurrentSpeed < this.wheelMaxSpeed ? this.wheelCurrentSpeed + this.accelStep : this.wheelCurrentSpeed;
                this.wheelJoint.SetMotorSpeed(this.wheelNewSpeed);
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
                if(!this.wheelJoint.IsMotorEnabled())
                {
                    this.wheelJoint.EnableMotor(true);
                }
                this.wheelCurrentSpeed = this.wheelJoint.GetJointSpeed();
                this.wheelNewSpeed = this.wheelCurrentSpeed > -this.wheelMaxSpeed ? this.wheelCurrentSpeed - this.accelStep : this.wheelCurrentSpeed;
                this.wheelJoint.SetMotorSpeed(this.wheelNewSpeed);
            }
        }
        
        override internal function upAndDownActions() : void
        {
            if(this.wheelJoint.IsMotorEnabled())
            {
                this.wheelJoint.EnableMotor(false);
            }
            if(_currentPose == 3 || _currentPose == 4)
            {
                currentPose = 0;
            }
        }
        
        override internal function spacePressedActions() : void
        {
            var _loc1_:Number = NaN;
            if(this.ejected)
            {
                startGrab();
            }
            else if(!this.shockJoint.IsMotorEnabled())
            {
                this.shockJoint.SetMotorSpeed(7);
                this.shockJoint.SetLimits(0,this.jumpTranslation);
                this.shockJoint.EnableMotor(true);
                SoundController.instance.playAreaSoundInstance("SegwayJump",this.wheelBody);
            }
            else
            {
                _loc1_ = this.shockJoint.GetMotorSpeed();
                if(_loc1_ > 0)
                {
                    if(this.shockJoint.GetJointTranslation() > this.jumpTranslation)
                    {
                        this.shockJoint.SetMotorSpeed(-1);
                    }
                }
                else if(_loc1_ < 0)
                {
                    if(this.shockJoint.GetJointTranslation() < 0)
                    {
                        this.shockJoint.EnableMotor(false);
                        this.shockJoint.SetLimits(0,0);
                        this.shockJoint.SetMotorSpeed(0);
                    }
                }
            }
        }
        
        override internal function spaceNullActions() : void
        {
            if(this.ejected)
            {
                releaseGrip();
            }
            else if(this.shockJoint.IsMotorEnabled())
            {
                if(this.shockJoint.GetMotorSpeed() > 0)
                {
                    if(this.shockJoint.GetJointTranslation() > this.jumpTranslation)
                    {
                        this.shockJoint.SetMotorSpeed(-1);
                    }
                }
                else if(this.shockJoint.GetMotorSpeed() < 0)
                {
                    if(this.shockJoint.GetJointTranslation() < 0)
                    {
                        this.shockJoint.EnableMotor(false);
                        this.shockJoint.SetLimits(0,0);
                        this.shockJoint.SetMotorSpeed(0);
                    }
                }
            }
        }
        
        override internal function shiftPressedActions() : void
        {
            if(this.ejected)
            {
                currentPose = 7;
            }
            else
            {
                currentPose = 5;
            }
        }
        
        override internal function shiftNullActions() : void
        {
            if(_currentPose == 5 || _currentPose == 7)
            {
                currentPose = 0;
            }
        }
        
        override internal function ctrlPressedActions() : void
        {
            if(this.ejected)
            {
                currentPose = 8;
            }
            else
            {
                currentPose = 6;
            }
        }
        
        override internal function ctrlNullActions() : void
        {
            if(_currentPose == 6 || _currentPose == 8)
            {
                currentPose = 0;
            }
        }
        
        override internal function zPressedActions() : void
        {
            this.eject();
        }
        
        override public function actions() : void
        {
            var _loc1_:Number = NaN;
            if(this.wheelContacts > 0)
            {
                _loc1_ = Math.abs(this.wheelBody.GetAngularVelocity());
                if(_loc1_ > 18)
                {
                    if(!this.wheelLoop3)
                    {
                        this.wheelLoop3 = SoundController.instance.playAreaSoundLoop("BikeLoop3",this.wheelBody,0);
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
                        this.wheelLoop2 = SoundController.instance.playAreaSoundLoop("BikeLoop2",this.wheelBody,0);
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
                        this.wheelLoop1 = SoundController.instance.playAreaSoundLoop("BikeLoop1",this.wheelBody,0);
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
                    this.straightLegPose();
                    break;
                case 6:
                    this.squatPose();
                    break;
                case 7:
                    this.fistPoseLeft();
                    break;
                case 8:
                    this.fistPoseRight();
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
            this.helmetOn = true;
            this.frameSmashed = false;
            this.ejected = false;
        }
        
        override public function die() : void
        {
            super.die();
            this.helmetBody = null;
        }
        
        override public function paint() : void
        {
            super.paint();
            var _loc1_:b2Vec2 = this.wheelBody.GetWorldCenter();
            this.wheelMC.x = _loc1_.x * m_physScale;
            this.wheelMC.y = _loc1_.y * m_physScale;
            this.wheelMC.inner.rotation = this.wheelBody.GetAngle() * (180 / Math.PI) % 360;
            _loc1_ = this.standBody.GetWorldCenter();
            var _loc2_:b2Vec2 = this.shockBody.GetWorldCenter();
            this.shockMC.graphics.clear();
            this.shockMC.graphics.lineStyle(3,13752544);
            this.shockMC.graphics.moveTo(_loc1_.x * m_physScale,_loc1_.y * m_physScale);
            this.shockMC.graphics.lineTo(_loc2_.x * m_physScale,_loc2_.y * m_physScale);
        }
        
        override internal function createBodies() : void
        {
            super.createBodies();
            var _loc1_:b2BodyDef = new b2BodyDef();
            var _loc2_:b2BodyDef = new b2BodyDef();
            var _loc3_:b2BodyDef = new b2BodyDef();
            var _loc4_:b2PolygonDef = new b2PolygonDef();
            var _loc5_:b2CircleDef = new b2CircleDef();
            _loc4_.density = 5;
            _loc4_.friction = 0.3;
            _loc4_.restitution = 0.1;
            _loc4_.filter.categoryBits = 514;
            _loc5_.density = 5;
            _loc5_.friction = 1;
            _loc5_.restitution = 0.3;
            _loc5_.filter.groupIndex = groupID;
            _loc5_.filter.categoryBits = 260;
            _loc5_.filter.maskBits = 268;
            var _loc6_:MovieClip = shapeGuide["frameShape"];
            var _loc7_:b2Vec2 = new b2Vec2(_startX + _loc6_.x / character_scale,_startY + _loc6_.y / character_scale);
            var _loc8_:Number = _loc6_.rotation / (180 / Math.PI);
            _loc4_.SetAsOrientedBox(_loc6_.scaleX * 5 / character_scale,_loc6_.scaleY * 5 / character_scale,_loc7_,_loc8_);
            this.frameBody = _session.m_world.CreateBody(_loc1_);
            this.frameShape = this.frameBody.CreateShape(_loc4_);
            _loc6_ = shapeGuide["handleShape"];
            _loc7_ = new b2Vec2(_startX + _loc6_.x / character_scale,_startY + _loc6_.y / character_scale);
            _loc8_ = _loc6_.rotation / (180 / Math.PI);
            _loc4_.SetAsOrientedBox(_loc6_.scaleX * 5 / character_scale,_loc6_.scaleY * 5 / character_scale,_loc7_,_loc8_);
            this.frameBody.CreateShape(_loc4_);
            this.frameBody.SetMassFromShapes();
            paintVector.push(this.frameBody);
            _session.contactListener.registerListener(ContactListener.RESULT,this.frameShape,contactResultHandler);
            _loc6_ = shapeGuide["standShape"];
            _loc3_.position.Set(_startX + _loc6_.x / character_scale,_startY + _loc6_.y / character_scale);
            _loc4_.SetAsBox(_loc6_.scaleX * 5 / character_scale,_loc6_.scaleY * 5 / character_scale);
            _loc4_.isSensor = true;
            _loc3_.fixedRotation = true;
            this.standBody = _session.m_world.CreateBody(_loc3_);
            this.standShape = this.standBody.CreateShape(_loc4_);
            this.standBody.SetMassFromShapes();
            paintVector.push(this.standBody);
            _session.contactListener.registerListener(ContactListener.ADD,this.standShape,contactAddHandler);
            this.shockBody = _session.m_world.CreateBody(_loc3_);
            this.shockBody.CreateShape(_loc4_);
            this.shockBody.SetMassFromShapes();
            _loc6_ = shapeGuide["wheelShape"];
            _loc2_.position.Set(_startX + _loc6_.x / character_scale,_startY + _loc6_.y / character_scale);
            _loc2_.angle = _loc6_.rotation / (180 / Math.PI);
            _loc5_.radius = _loc6_.width / 2 / character_scale;
            this.wheelBody = _session.m_world.CreateBody(_loc2_);
            this.wheelShape = this.wheelBody.CreateShape(_loc5_);
            this.wheelBody.SetMassFromShapes();
            _session.contactListener.registerListener(ContactListener.RESULT,this.wheelShape,contactResultHandler);
            _session.contactListener.registerListener(ContactListener.ADD,this.wheelShape,this.wheelContactAdd);
            _session.contactListener.registerListener(ContactListener.REMOVE,this.wheelShape,this.wheelContactRemove);
        }
        
        override internal function createMovieClips() : void
        {
            super.createMovieClips();
            this.shockMC = new Sprite();
            this.frameMC = sourceObject["frame"];
            var _loc5_:* = 1 / mc_scale;
            this.frameMC.scaleY = 1 / mc_scale;
            this.frameMC.scaleX = _loc5_;
            this.wheelMC = sourceObject["wheel"];
            _loc5_ = 1 / mc_scale;
            this.wheelMC.scaleY = 1 / mc_scale;
            this.wheelMC.scaleX = _loc5_;
            this.wheelCoverMC = sourceObject["wheelCover"];
            _loc5_ = 1 / mc_scale;
            this.wheelCoverMC.scaleY = 1 / mc_scale;
            this.wheelCoverMC.scaleX = _loc5_;
            this.helmetMC = sourceObject["helmet"];
            _loc5_ = 1 / mc_scale;
            this.helmetMC.scaleY = 1 / mc_scale;
            this.helmetMC.scaleX = _loc5_;
            this.helmetMC.visible = false;
            this.standBody.SetUserData(this.wheelCoverMC);
            var _loc1_:b2Vec2 = this.frameBody.GetLocalCenter();
            _loc1_ = new b2Vec2((_startX - _loc1_.x) * character_scale,(_startY - _loc1_.y) * character_scale);
            var _loc2_:MovieClip = shapeGuide["frameShape"];
            var _loc3_:b2Vec2 = new b2Vec2(_loc2_.x + _loc1_.x,_loc2_.y + _loc1_.y);
            this.frameMC.inner.x = _loc3_.x;
            this.frameMC.inner.y = _loc3_.y;
            this.frameBody.SetUserData(this.frameMC);
            var _loc4_:int = _session.containerSprite.getChildIndex(upperArm1MC);
            _session.containerSprite.addChildAt(this.wheelMC,_loc4_);
            _session.containerSprite.addChildAt(this.shockMC,_loc4_);
            _session.containerSprite.addChildAt(this.wheelCoverMC,_loc4_);
            _session.containerSprite.addChildAt(this.frameMC,_loc4_);
            _session.containerSprite.addChildAt(chestMC,_loc4_);
            _session.containerSprite.addChildAt(this.helmetMC,_session.containerSprite.getChildIndex(chestMC));
        }
        
        override internal function resetMovieClips() : void
        {
            super.resetMovieClips();
            this.frameBody.SetUserData(this.frameMC);
            this.standBody.SetUserData(this.wheelCoverMC);
            this.shockMC.graphics.clear();
            this.helmetMC.visible = false;
            head1MC.helmet.visible = true;
        }
        
        override internal function createDictionaries() : void
        {
            super.createDictionaries();
            this.helmetShape = head1Shape;
            contactImpulseDict[this.helmetShape] = this.helmetSmashLimit;
            contactImpulseDict[this.frameShape] = this.frameSmashLimit;
            contactAddSounds[this.wheelShape] = "TireHit1";
            contactAddSounds[this.standShape] = "Thud2";
        }
        
        override protected function handleContactResults() : void
        {
            var _loc1_:ContactEvent = null;
            if(contactResultBuffer[this.helmetShape])
            {
                _loc1_ = contactResultBuffer[this.helmetShape];
                this.helmetSmash(_loc1_.impulse);
                delete contactResultBuffer[head1Shape];
                delete contactAddBuffer[head1Shape];
            }
            super.handleContactResults();
            if(contactResultBuffer[this.frameShape])
            {
                _loc1_ = contactResultBuffer[this.frameShape];
                this.frameSmash(_loc1_.impulse);
                delete contactResultBuffer[this.frameShape];
            }
        }
        
        protected function wheelContactAdd(param1:b2ContactPoint) : void
        {
            if(param1.shape2.m_isSensor)
            {
                return;
            }
            this.wheelContacts += 1;
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
                contactAddBuffer[_loc2_] = _loc7_;
            }
        }
        
        protected function wheelContactRemove(param1:b2ContactPoint) : void
        {
            if(param1.shape2.m_isSensor)
            {
                return;
            }
            --this.wheelContacts;
        }
        
        override internal function createJoints() : void
        {
            var _loc1_:Number = NaN;
            var _loc2_:Number = NaN;
            var _loc3_:Number = NaN;
            super.createJoints();
            var _loc4_:Number = 180 / Math.PI;
            _loc1_ = upperLeg1Body.GetAngle() - pelvisBody.GetAngle();
            _loc2_ = -50 / _loc4_ - _loc1_;
            _loc3_ = 10 / _loc4_ - _loc1_;
            hipJoint1.SetLimits(_loc2_,_loc3_);
            _loc1_ = upperLeg2Body.GetAngle() - pelvisBody.GetAngle();
            _loc2_ = -50 / _loc4_ - _loc1_;
            _loc3_ = 10 / _loc4_ - _loc1_;
            hipJoint2.SetLimits(_loc2_,_loc3_);
            _loc1_ = lowerArm1Body.GetAngle() - upperArm1Body.GetAngle();
            _loc2_ = -60 / _loc4_ - _loc1_;
            _loc3_ = 0 / _loc4_ - _loc1_;
            elbowJoint1.SetLimits(_loc2_,_loc3_);
            _loc1_ = lowerArm2Body.GetAngle() - upperArm2Body.GetAngle();
            _loc2_ = -60 / _loc4_ - _loc1_;
            _loc3_ = 0 / _loc4_ - _loc1_;
            elbowJoint2.SetLimits(_loc2_,_loc3_);
            _loc1_ = head1Body.GetAngle() - chestBody.GetAngle();
            _loc2_ = 0 / _loc4_ - _loc1_;
            _loc3_ = 20 / _loc4_ - _loc1_;
            neckJoint.SetLimits(_loc2_,_loc3_);
            var _loc5_:b2PrismaticJointDef = new b2PrismaticJointDef();
            _loc5_.maxMotorForce = 1000;
            _loc5_.enableLimit = true;
            _loc5_.upperTranslation = 0;
            _loc5_.lowerTranslation = 0;
            var _loc6_:b2Vec2 = new b2Vec2();
            var _loc7_:MovieClip = shapeGuide["wheelShape"];
            _loc6_.Set(_startX + _loc7_.x / character_scale,_startY + _loc7_.y / character_scale);
            _loc5_.Initialize(this.standBody,this.shockBody,_loc6_,new b2Vec2(0,1));
            this.shockJoint = _session.m_world.CreateJoint(_loc5_) as b2PrismaticJoint;
            var _loc8_:b2RevoluteJointDef = new b2RevoluteJointDef();
            _loc8_.maxMotorTorque = this.maxTorque;
            _loc7_ = shapeGuide["wheelShape"];
            _loc6_.Set(_startX + _loc7_.x / character_scale,_startY + _loc7_.y / character_scale);
            _loc8_.Initialize(this.shockBody,this.wheelBody,_loc6_);
            this.wheelJoint = _session.m_world.CreateJoint(_loc8_) as b2RevoluteJoint;
            _loc7_ = shapeGuide["frameAnchor"];
            _loc6_.Set(_startX + _loc7_.x / character_scale,_startY + _loc7_.y / character_scale);
            _loc8_.enableLimit = true;
            _loc8_.lowerAngle = -15 / _loc4_;
            _loc8_.upperAngle = 15 / _loc4_;
            _loc8_.Initialize(this.standBody,this.frameBody,_loc6_);
            this.standFrame = _session.m_world.CreateJoint(_loc8_) as b2RevoluteJoint;
            _loc8_.lowerAngle = -100 / _loc4_;
            _loc8_.upperAngle = 10 / _loc4_;
            _loc7_ = shapeGuide["handleAnchor"];
            _loc6_.Set(_startX + _loc7_.x / character_scale,_startY + _loc7_.y / character_scale);
            _loc8_.Initialize(this.frameBody,lowerArm1Body,_loc6_);
            this.frameHand1 = _session.m_world.CreateJoint(_loc8_) as b2RevoluteJoint;
            this.frameHand1JointDef = _loc8_.clone();
            this.handleAnchorPoint = this.frameBody.GetLocalPoint(_loc6_);
            _loc8_.Initialize(this.frameBody,lowerArm2Body,_loc6_);
            this.frameHand2 = _session.m_world.CreateJoint(_loc8_) as b2RevoluteJoint;
            this.frameHand2JointDef = _loc8_.clone();
            _loc8_.lowerAngle = -10 / _loc4_;
            _loc8_.upperAngle = 10 / _loc4_;
            _loc7_ = shapeGuide["footAnchor"];
            _loc6_.Set(_startX + _loc7_.x / character_scale,_startY + _loc7_.y / character_scale);
            _loc8_.Initialize(this.frameBody,lowerLeg1Body,_loc6_);
            this.standFoot1 = _session.m_world.CreateJoint(_loc8_) as b2RevoluteJoint;
            this.standFoot1JointDef = _loc8_.clone();
            this.footAnchorPoint = this.frameBody.GetLocalPoint(_loc6_);
            _loc8_.Initialize(this.frameBody,lowerLeg2Body,_loc6_);
            this.standFoot2 = _session.m_world.CreateJoint(_loc8_) as b2RevoluteJoint;
            this.standFoot2JointDef = _loc8_.clone();
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
            var _loc1_:b2World = _session.m_world;
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
            if(this.standFoot1)
            {
                _loc1_.DestroyJoint(this.standFoot1);
                this.standFoot1 = null;
            }
            if(this.standFoot2)
            {
                _loc1_.DestroyJoint(this.standFoot2);
                this.standFoot2 = null;
            }
            this.shockJoint.EnableMotor(false);
            this.shockJoint.SetLimits(0,0);
            this.shockJoint.SetMotorSpeed(0);
            var _loc2_:b2FilterData = new b2FilterData();
            _loc2_.categoryBits = 260;
            _loc2_.groupIndex = -2;
            var _loc3_:b2Shape = this.frameBody.GetShapeList();
            while(_loc3_)
            {
                _loc3_.SetFilterData(_loc2_);
                _loc1_.Refilter(_loc3_);
                _loc3_ = _loc3_.m_next;
            }
            this.wheelBody.GetShapeList().SetFilterData(_loc2_);
            _loc1_.Refilter(this.wheelBody.GetShapeList());
            lowerArm1MC.hand.gotoAndStop(2);
            lowerArm2MC.hand.gotoAndStop(2);
        }
        
        protected function reAttach(param1:b2Body) : void
        {
            throw new Error("this must be called only in subclass");
        }
        
        public function reAttaching() : void
        {
            throw new Error("this must be called only in subclass");
        }
        
        override public function set dead(param1:Boolean) : void
        {
            _dead = param1;
            if(_dead)
            {
                removeAction(this.reAttaching);
                userVehicleEject();
                currentPose = 0;
                releaseGrip();
                this.wheelJoint.EnableMotor(false);
                if(voiceSound)
                {
                    voiceSound.stopSound();
                    voiceSound = null;
                }
            }
        }
        
        internal function frameSmash(param1:Number) : void
        {
            trace("frame impulse " + param1 + " -> " + _session.iteration);
            delete contactImpulseDict[this.frameShape];
            _session.contactListener.deleteListener(ContactListener.RESULT,this.frameShape);
            _session.contactListener.deleteListener(ContactListener.ADD,this.standShape);
            var _loc2_:b2World = _session.m_world;
            _loc2_.DestroyJoint(this.standFrame);
            this.standFrame = null;
            this.frameSmashed = true;
            this.eject();
            var _loc3_:b2Shape = this.frameBody.GetShapeList();
            while(_loc3_)
            {
                _loc3_.SetFilterData(zeroFilter);
                _loc2_.Refilter(_loc3_);
                _loc3_ = _loc3_.m_next;
            }
            this.wheelBody.GetShapeList().SetFilterData(zeroFilter);
            _loc2_.Refilter(this.wheelBody.GetShapeList());
        }
        
        internal function helmetSmash(param1:Number) : void
        {
            var _loc6_:MovieClip = null;
            trace("helmet impulse " + param1 + " -> " + _session.iteration);
            delete contactImpulseDict[this.helmetShape];
            head1Shape = this.helmetShape;
            contactImpulseDict[head1Shape] = headSmashLimit;
            this.helmetShape = null;
            this.helmetOn = false;
            var _loc2_:b2PolygonDef = new b2PolygonDef();
            var _loc3_:b2BodyDef = new b2BodyDef();
            _loc2_.density = 1;
            _loc2_.friction = 0.3;
            _loc2_.restitution = 0.1;
            _loc2_.filter = zeroFilter;
            var _loc4_:b2Vec2 = head1Body.GetPosition();
            _loc3_.position = _loc4_;
            _loc3_.angle = head1Body.GetAngle();
            _loc3_.userData = this.helmetMC;
            this.helmetMC.visible = true;
            head1MC.helmet.visible = false;
            _loc2_.vertexCount = 4;
            var _loc5_:int = 0;
            while(_loc5_ < 4)
            {
                _loc6_ = shapeGuide["helmetVert" + [_loc5_ + 1]];
                _loc2_.vertices[_loc5_] = new b2Vec2(_loc6_.x / character_scale,_loc6_.y / character_scale);
                _loc5_++;
            }
            this.helmetBody = _session.m_world.CreateBody(_loc3_);
            this.helmetBody.CreateShape(_loc2_);
            this.helmetBody.SetMassFromShapes();
            this.helmetBody.SetLinearVelocity(head1Body.GetLinearVelocity());
            this.helmetBody.SetAngularVelocity(head1Body.GetAngularVelocity());
            paintVector.push(this.helmetBody);
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
            this.eject();
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
                if(!this.frameHand2)
                {
                    this.eject();
                }
            }
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
                if(!this.frameHand1)
                {
                    this.eject();
                }
            }
        }
        
        override internal function kneeBreak1(param1:Number) : void
        {
            super.kneeBreak1(param1);
            if(this.ejected)
            {
                return;
            }
            if(this.standFoot1)
            {
                _session.m_world.DestroyJoint(this.standFoot1);
                this.standFoot1 = null;
            }
        }
        
        override internal function kneeBreak2(param1:Number) : void
        {
            super.kneeBreak2(param1);
            if(this.standFoot2)
            {
                _session.m_world.DestroyJoint(this.standFoot2);
                this.standFoot2 = null;
            }
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
        
        internal function squatPose() : void
        {
            setJoint(kneeJoint1,1.5,10);
            setJoint(kneeJoint2,1.5,10);
        }
        
        internal function straightLegPose() : void
        {
            setJoint(kneeJoint1,0,10);
            setJoint(kneeJoint2,0,10);
        }
        
        internal function leanForward() : void
        {
            setJoint(this.standFrame,0.52,20);
        }
        
        internal function leanBackward() : void
        {
            setJoint(this.standFrame,0,20);
        }
        
        internal function noLean() : void
        {
            setJoint(this.standFrame,0.26,20);
        }
        
        internal function fistPoseLeft() : void
        {
            setJoint(neckJoint,0.5,2);
            setJoint(hipJoint1,1.5,2);
            setJoint(hipJoint2,3.5,2);
            setJoint(kneeJoint1,1.7,10);
            setJoint(kneeJoint2,0,10);
            setJoint(shoulderJoint1,3,20);
            setJoint(shoulderJoint2,1,20);
            setJoint(elbowJoint1,1.5,15);
            setJoint(elbowJoint2,3,15);
        }
        
        internal function fistPoseRight() : void
        {
            setJoint(neckJoint,0.5,2);
            setJoint(hipJoint1,3.5,2);
            setJoint(hipJoint2,1.5,2);
            setJoint(kneeJoint1,0,10);
            setJoint(kneeJoint2,1.7,10);
            setJoint(shoulderJoint1,1,20);
            setJoint(shoulderJoint2,3,20);
            setJoint(elbowJoint1,3,15);
            setJoint(elbowJoint2,1.5,15);
        }
        
        override public function explodeShape(param1:b2Shape, param2:Number) : void
        {
            var _loc3_:Number = NaN;
            var _loc4_:Number = NaN;
            var _loc5_:Number = NaN;
            switch(param1)
            {
                case this.helmetShape:
                    if(param2 > 0.85)
                    {
                        this.helmetSmash(0);
                    }
                    break;
                case head1Shape:
                    if(param2 > 0.85)
                    {
                        this.headSmash1(0);
                    }
                    break;
                case chestShape:
                    _loc3_ = chestBody.GetMass() / DEF_CHEST_MASS;
                    _loc4_ = Math.max(1 - 0.15 * _loc3_,0.7);
                    trace("new chest ratio " + _loc4_);
                    if(param2 > _loc4_)
                    {
                        this.chestSmash(0);
                    }
                    break;
                case pelvisShape:
                    _loc5_ = pelvisBody.GetMass() / DEF_PELVIS_MASS;
                    _loc4_ = Math.max(1 - 0.15 * _loc5_,0.7);
                    trace("new pelvis ratio " + _loc4_);
                    if(param2 > _loc4_)
                    {
                        this.pelvisSmash(0);
                    }
            }
        }
    }
}

