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
    import com.totaljerkface.game.sound.*;
    import flash.display.*;
    import flash.events.*;
    import flash.utils.*;
    
    public class PogoStickMan extends CharacterB2D
    {
        protected var ejected:Boolean;
        
        protected var helmetOn:Boolean;
        
        protected const impulseMagnitude:Number = 0.5;
        
        protected const impulseOffset:Number = 1;
        
        protected const maxSpinAV:Number = 5;
        
        protected const reAttachDistance:Number = 0.25;
        
        protected const bounceSpeed:Number = 6;
        
        protected const bounceTranslation:Number = -30;
        
        protected const jumpTranslation:Number = -40;
        
        protected const verticalVelocityThreshold:Number = 0.25;
        
        protected const retractSpeed:Number = -0.5;
        
        protected var nubContacts:int = 0;
        
        protected var charging:Boolean;
        
        protected var jumpFrames:int = 0;
        
        protected var jumpFramesMax:int = 5;
        
        protected var airLean:Boolean;
        
        protected const uprightAngle:Number = -Math.PI * 0.5;
        
        protected const forwardAngle:Number = -Math.PI * 0.45;
        
        protected const reverseAngle:Number = -Math.PI * 0.6;
        
        protected var targetAngle:Number = -Math.PI * 0.5;
        
        protected var helmetSmashLimit:Number = 2;
        
        protected var frameSmashLimit:Number = 40;
        
        protected var frameSmashed:Boolean;
        
        protected var handleAnchorPoint:b2Vec2;
        
        protected var footAnchorPoint:b2Vec2;
        
        protected var frameHand1JointDef:b2RevoluteJointDef;
        
        protected var frameHand2JointDef:b2RevoluteJointDef;
        
        protected var frameFoot1JointDef:b2RevoluteJointDef;
        
        protected var frameFoot2JointDef:b2RevoluteJointDef;
        
        internal var frameBody:b2Body;
        
        internal var rodBody:b2Body;
        
        internal var helmetBody:b2Body;
        
        internal var helmetShape:b2Shape;
        
        internal var frameShape:b2Shape;
        
        internal var rodShape:b2Shape;
        
        internal var nubShape:b2Shape;
        
        internal var stopperShape:b2Shape;
        
        internal var frameMC:MovieClip;
        
        internal var rodMC:MovieClip;
        
        internal var helmetMC:MovieClip;
        
        internal var brokenFrame1MC:MovieClip;
        
        internal var brokenFrame2MC:MovieClip;
        
        internal var springMC:MovieClip;
        
        internal var pogoJoint:b2PrismaticJoint;
        
        internal var frameHand1:b2RevoluteJoint;
        
        internal var frameHand2:b2RevoluteJoint;
        
        internal var frameFoot1:b2RevoluteJoint;
        
        internal var frameFoot2:b2RevoluteJoint;
        
        private var COMArray:Array;
        
        private var currCOM:b2Vec2;
        
        private var prevCOM:b2Vec2;
        
        private var velocityCOM:b2Vec2;
        
        private var velocityAngle:Number;
        
        private var pivotDirection:b2Vec2;
        
        private var pivotAngle:Number;
        
        internal var tempElbowBreakLimit:int;
        
        internal var tempElbowLigamentLimit:int;
        
        internal var tempKneeBreakLimit:int;
        
        internal var tempKneeLigamentLimit:int;
        
        public function PogoStickMan(param1:Number, param2:Number, param3:DisplayObject, param4:Session)
        {
            super(param1,param2,param3,param4,-1,"Char12");
            shapeRefScale = 50;
            currentPose = 9;
            this.COMArray = new Array();
        }
        
        override internal function leftPressedActions() : void
        {
            var _loc1_:Number = NaN;
            var _loc2_:Number = NaN;
            var _loc3_:Number = NaN;
            var _loc4_:Number = NaN;
            var _loc5_:Number = NaN;
            var _loc6_:b2Vec2 = null;
            var _loc7_:b2Vec2 = null;
            var _loc8_:b2Vec2 = null;
            var _loc9_:Number = NaN;
            if(this.ejected)
            {
                currentPose = 1;
            }
            else
            {
                if(this.nubContacts == 0)
                {
                    this.airLean = true;
                }
                _loc1_ = this.frameBody.GetAngle();
                _loc2_ = this.frameBody.GetAngularVelocity();
                _loc3_ = (_loc2_ + this.maxSpinAV) / this.maxSpinAV;
                if(_loc3_ < 0)
                {
                    _loc3_ = 0;
                }
                if(_loc3_ > 1)
                {
                    _loc3_ = 1;
                }
                _loc4_ = Math.cos(_loc1_) * this.impulseMagnitude * _loc3_;
                _loc5_ = Math.sin(_loc1_) * this.impulseMagnitude * _loc3_;
                _loc6_ = this.frameBody.GetLocalCenter();
                _loc7_ = this.frameBody.GetWorldPoint(new b2Vec2(_loc6_.x,_loc6_.y - this.impulseOffset));
                _loc8_ = this.frameBody.GetWorldPoint(new b2Vec2(_loc6_.x,_loc6_.y + this.impulseOffset));
                this.frameBody.ApplyImpulse(new b2Vec2(-_loc4_,-_loc5_),_loc7_);
                this.frameBody.ApplyImpulse(new b2Vec2(_loc4_,_loc5_),_loc8_);
                _loc9_ = 100;
            }
        }
        
        override internal function rightPressedActions() : void
        {
            var _loc1_:Number = NaN;
            var _loc2_:Number = NaN;
            var _loc3_:Number = NaN;
            var _loc4_:Number = NaN;
            var _loc5_:Number = NaN;
            var _loc6_:b2Vec2 = null;
            var _loc7_:b2Vec2 = null;
            var _loc8_:b2Vec2 = null;
            var _loc9_:Number = NaN;
            if(this.ejected)
            {
                currentPose = 2;
            }
            else
            {
                if(this.nubContacts == 0)
                {
                    this.airLean = true;
                }
                _loc1_ = this.frameBody.GetAngle();
                _loc2_ = this.frameBody.GetAngularVelocity();
                _loc3_ = (_loc2_ - this.maxSpinAV) / -this.maxSpinAV;
                if(_loc3_ < 0)
                {
                    _loc3_ = 0;
                }
                if(_loc3_ > 1)
                {
                    _loc3_ = 1;
                }
                _loc4_ = Math.cos(_loc1_) * this.impulseMagnitude * _loc3_;
                _loc5_ = Math.sin(_loc1_) * this.impulseMagnitude * _loc3_;
                _loc6_ = this.frameBody.GetLocalCenter();
                _loc7_ = this.frameBody.GetWorldPoint(new b2Vec2(_loc6_.x,_loc6_.y - this.impulseOffset));
                _loc8_ = this.frameBody.GetWorldPoint(new b2Vec2(_loc6_.x,_loc6_.y + this.impulseOffset));
                this.frameBody.ApplyImpulse(new b2Vec2(_loc4_,_loc5_),_loc7_);
                this.frameBody.ApplyImpulse(new b2Vec2(-_loc4_,-_loc5_),_loc8_);
                _loc9_ = 100;
            }
        }
        
        override internal function leftAndRightActions() : void
        {
            var _loc1_:Number = NaN;
            var _loc2_:Number = NaN;
            var _loc3_:Number = NaN;
            var _loc4_:Number = NaN;
            var _loc5_:Number = NaN;
            var _loc6_:Number = NaN;
            var _loc7_:Number = NaN;
            if(this.ejected)
            {
                if(_currentPose == 1 || _currentPose == 2)
                {
                    currentPose = 0;
                }
            }
            else
            {
                this.updateCOMValues();
                if(this.airLean)
                {
                    return;
                }
                if(this.velocityCOM.y > 0)
                {
                    _loc6_ = this.velocityCOM.y / this.verticalVelocityThreshold;
                    _loc6_ = Math.min(1,_loc6_);
                    _loc7_ = this.targetAngle * (1 - _loc6_) + (this.velocityAngle - Math.PI) * _loc6_;
                }
                else
                {
                    _loc6_ = -this.velocityCOM.y / this.verticalVelocityThreshold;
                    _loc6_ = Math.min(1,_loc6_);
                    _loc7_ = this.targetAngle * (1 - _loc6_) + this.velocityAngle * _loc6_;
                }
                _loc1_ = this.frameBody.GetAngularVelocity();
                _loc2_ = _loc1_ / 30;
                _loc3_ = _loc7_ - this.pivotAngle;
                if(_loc3_ > Math.PI)
                {
                    _loc3_ -= Math.PI * 2;
                }
                if(_loc3_ < -Math.PI)
                {
                    _loc3_ += Math.PI * 2;
                }
                _loc4_ = _loc3_ * 30 - _loc1_;
                _loc5_ = _loc3_ * 30;
                if(_loc5_ < -this.maxSpinAV * 2)
                {
                    _loc5_ = -this.maxSpinAV * 2;
                }
                if(_loc5_ > this.maxSpinAV * 2)
                {
                    _loc5_ = this.maxSpinAV * 2;
                }
                this.frameBody.SetAngularVelocity(_loc5_);
            }
        }
        
        override internal function upPressedActions() : void
        {
            var _loc1_:Number = NaN;
            var _loc2_:Number = NaN;
            var _loc3_:Number = NaN;
            if(this.ejected)
            {
                currentPose = 3;
            }
            else
            {
                this.targetAngle = this.forwardAngle;
                this.airLean = false;
                if(!this.charging)
                {
                    _loc1_ = this.pogoJoint.GetJointTranslation();
                    _loc2_ = this.pogoJoint.GetMotorSpeed();
                    if(this.nubContacts > 0 && this.jumpFrames == 0)
                    {
                        if(this.pogoJoint.m_lowerTranslation == 0)
                        {
                            this.pogoJoint.m_lowerTranslation = this.bounceTranslation / character_scale;
                            this.pogoJoint.SetMotorSpeed(this.retractSpeed);
                        }
                        else if(_loc2_ == this.retractSpeed)
                        {
                            if(_loc1_ <= this.bounceTranslation / character_scale && this.pivotAngle > this.targetAngle && this.pivotAngle < this.targetAngle + Math.PI * 0.15)
                            {
                                this.pogoJoint.SetMotorSpeed(this.bounceSpeed);
                                this.jumpFrames = this.jumpFramesMax;
                                _loc3_ = Math.min(1,Math.max(-_loc1_ * m_physScale / 40,0));
                                SoundController.instance.playAreaSoundInstance("PogoRelease",this.frameBody,_loc3_);
                            }
                        }
                    }
                    if(_loc2_ > 0 && _loc1_ >= 0)
                    {
                        this.pogoJoint.m_lowerTranslation = 0;
                        this.pogoJoint.SetMotorSpeed(0);
                    }
                }
            }
        }
        
        override internal function downPressedActions() : void
        {
            var _loc1_:Number = NaN;
            var _loc2_:Number = NaN;
            var _loc3_:Number = NaN;
            if(this.ejected)
            {
                currentPose = 4;
            }
            else
            {
                this.targetAngle = this.reverseAngle;
                this.airLean = false;
                if(!this.charging)
                {
                    _loc1_ = this.pogoJoint.GetJointTranslation();
                    _loc2_ = this.pogoJoint.GetMotorSpeed();
                    if(this.nubContacts > 0 && this.jumpFrames == 0)
                    {
                        if(this.pogoJoint.m_lowerTranslation == 0)
                        {
                            this.pogoJoint.m_lowerTranslation = this.bounceTranslation / character_scale;
                            this.pogoJoint.SetMotorSpeed(this.retractSpeed);
                        }
                        else if(_loc2_ == this.retractSpeed)
                        {
                            if(_loc1_ <= this.bounceTranslation / character_scale && this.pivotAngle < this.targetAngle && this.pivotAngle > this.targetAngle - Math.PI * 0.15)
                            {
                                this.pogoJoint.SetMotorSpeed(this.bounceSpeed);
                                this.jumpFrames = this.jumpFramesMax;
                                _loc3_ = Math.min(1,Math.max(-_loc1_ * m_physScale / 40,0));
                                SoundController.instance.playAreaSoundInstance("PogoRelease2",this.frameBody,_loc3_);
                            }
                        }
                    }
                    if(_loc2_ > 0 && _loc1_ >= 0)
                    {
                        this.pogoJoint.m_lowerTranslation = 0;
                        this.pogoJoint.SetMotorSpeed(0);
                    }
                }
            }
        }
        
        override internal function upAndDownActions() : void
        {
            var _loc1_:Number = NaN;
            if(this.ejected)
            {
                if(_currentPose == 3 || _currentPose == 4)
                {
                    currentPose = 0;
                }
            }
            else
            {
                this.targetAngle = this.uprightAngle;
                if(!this.charging)
                {
                    _loc1_ = this.pogoJoint.GetJointTranslation();
                    if(this.pogoJoint.m_lowerTranslation != 0)
                    {
                        if(_loc1_ < 0)
                        {
                            this.pogoJoint.SetMotorSpeed(0.5);
                        }
                        else
                        {
                            this.pogoJoint.SetMotorSpeed(0);
                            this.pogoJoint.m_lowerTranslation = 0;
                        }
                    }
                }
            }
        }
        
        override internal function spacePressedActions() : void
        {
            var _loc1_:Number = NaN;
            if(this.ejected)
            {
                startGrab();
            }
            else
            {
                this.charging = true;
                if(this.pogoJoint.m_lowerTranslation != this.jumpTranslation / character_scale)
                {
                    this.pogoJoint.m_lowerTranslation = this.jumpTranslation / character_scale;
                }
                _loc1_ = this.pogoJoint.GetJointTranslation();
                if(_loc1_ > this.pogoJoint.m_lowerTranslation)
                {
                    this.pogoJoint.SetMotorSpeed(this.retractSpeed);
                }
                else
                {
                    this.pogoJoint.SetMotorSpeed(0);
                }
            }
        }
        
        override internal function spaceNullActions() : void
        {
            var _loc1_:Number = NaN;
            var _loc2_:Number = NaN;
            var _loc3_:Number = NaN;
            var _loc4_:Number = NaN;
            if(this.ejected)
            {
                releaseGrip();
            }
            else if(this.charging)
            {
                _loc1_ = this.pogoJoint.GetJointTranslation();
                _loc2_ = _loc1_ * -70;
                if(_loc1_ < 0)
                {
                    _loc3_ = this.pogoJoint.GetMotorSpeed();
                    if(_loc2_ > _loc3_)
                    {
                        _loc4_ = Math.min(1,Math.max(-_loc1_ * m_physScale / 20,0));
                        SoundController.instance.playAreaSoundInstance("PogoRelease",this.frameBody,_loc4_);
                    }
                    this.pogoJoint.SetMotorSpeed(_loc2_);
                }
                else
                {
                    this.pogoJoint.SetMotorSpeed(0);
                    this.pogoJoint.m_lowerTranslation = 0;
                    this.charging = false;
                    this.jumpFrames = this.jumpFramesMax;
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
            if(this.ejected)
            {
                if(_currentPose == 7)
                {
                    currentPose = 0;
                }
            }
            else if(_currentPose == 5)
            {
                currentPose = 9;
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
            if(this.ejected)
            {
                if(_currentPose == 8)
                {
                    currentPose = 0;
                }
            }
            else if(_currentPose == 6)
            {
                currentPose = 9;
            }
        }
        
        override internal function zPressedActions() : void
        {
            this.eject();
        }
        
        override public function actions() : void
        {
            super.actions();
            if(this.jumpFrames > 0)
            {
                --this.jumpFrames;
            }
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
                case 9:
                    this.pogoPose();
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
        
        override internal function setLimits() : void
        {
            super.setLimits();
            this.tempElbowBreakLimit = elbowBreakLimit;
            this.tempElbowLigamentLimit = elbowLigamentLimit;
            this.tempKneeBreakLimit = kneeBreakLimit;
            this.tempKneeLigamentLimit = kneeLigamentLimit;
            elbowBreakLimit = 90;
            elbowLigamentLimit = 110;
            kneeBreakLimit = 120;
            kneeLigamentLimit = 140;
        }
        
        override public function reset() : void
        {
            super.reset();
            this.helmetOn = true;
            this.frameSmashed = false;
            this.ejected = false;
            this.nubContacts = 0;
            this.charging = false;
            this.jumpFrames = 0;
            this.airLean = false;
            this.targetAngle = this.uprightAngle;
            elbowBreakLimit = 90;
            elbowLigamentLimit = 110;
            kneeBreakLimit = 120;
            kneeLigamentLimit = 140;
            currentPose = 9;
        }
        
        override public function die() : void
        {
            super.die();
            this.helmetBody = null;
        }
        
        override public function paint() : void
        {
            var _loc1_:DisplayObject = null;
            var _loc2_:Number = NaN;
            var _loc3_:Number = NaN;
            super.paint();
            if(!this.frameSmashed)
            {
                _loc1_ = this.frameMC.getChildByName("spring");
                _loc2_ = this.pogoJoint.GetJointTranslation() * m_physScale;
                _loc3_ = _loc2_ / -20;
                _loc3_ = Math.max(Math.min(1,_loc3_),0);
                _loc1_.scaleY = (1 - _loc3_) * 0.55 + 0.45;
            }
        }
        
        override internal function createBodies() : void
        {
            super.createBodies();
            var _loc1_:b2BodyDef = new b2BodyDef();
            var _loc2_:b2PolygonDef = new b2PolygonDef();
            var _loc3_:b2CircleDef = new b2CircleDef();
            _loc2_.density = 5;
            _loc2_.friction = 1;
            _loc2_.restitution = 0.1;
            _loc2_.filter = defaultFilter;
            _loc3_.density = 5;
            _loc3_.friction = 1;
            _loc3_.restitution = 0.3;
            _loc3_.filter.categoryBits = 260;
            _loc3_.filter.maskBits = 270;
            var _loc4_:MovieClip = shapeGuide["frameShape"];
            var _loc5_:b2Vec2 = new b2Vec2(_startX + _loc4_.x / character_scale,_startY + _loc4_.y / character_scale);
            var _loc6_:Number = _loc4_.rotation / oneEightyOverPI;
            _loc1_.position.Set(_loc5_.x,_loc5_.y);
            _loc1_.angle = _loc6_;
            this.frameBody = _session.m_world.CreateBody(_loc1_);
            _loc2_.SetAsBox(_loc4_.scaleX * shapeRefScale / character_scale,_loc4_.scaleY * shapeRefScale / character_scale);
            this.frameShape = this.frameBody.CreateShape(_loc2_);
            this.frameBody.SetMassFromShapes();
            paintVector.push(this.frameBody);
            _session.contactListener.registerListener(ContactListener.RESULT,this.frameShape,contactResultHandler);
            _session.contactListener.registerListener(ContactListener.ADD,this.frameShape,contactAddHandler);
            _loc3_.radius = 10 / character_scale;
            _loc3_.localPosition.Set(0,-(_loc4_.scaleY * shapeRefScale) / character_scale);
            _loc4_ = shapeGuide["rodShape"];
            _loc5_ = new b2Vec2(_startX + _loc4_.x / character_scale,_startY + _loc4_.y / character_scale);
            _loc6_ = _loc4_.rotation / oneEightyOverPI;
            _loc1_.position.Set(_loc5_.x,_loc5_.y);
            _loc1_.angle = _loc6_;
            _loc2_.SetAsBox(_loc4_.scaleX * shapeRefScale / character_scale,_loc4_.scaleY * shapeRefScale / character_scale);
            this.rodBody = _session.m_world.CreateBody(_loc1_);
            this.rodShape = this.rodBody.CreateShape(_loc2_);
            this.rodBody.SetMassFromShapes();
            paintVector.push(this.rodBody);
            _loc3_.radius = 7 / character_scale;
            _loc3_.filter = defaultFilter;
            _loc3_.localPosition.Set(0,_loc4_.scaleY * shapeRefScale / character_scale);
            this.nubShape = this.rodBody.CreateShape(_loc3_);
            _session.contactListener.registerListener(ContactListener.ADD,this.nubShape,this.nubContactAdd);
            _session.contactListener.registerListener(ContactListener.REMOVE,this.nubShape,this.nubContactRemove);
            this.COMArray = [this.frameBody,this.rodBody,head1Body,chestBody,pelvisBody,upperArm1Body,lowerArm1Body,upperArm2Body,lowerArm2Body,upperLeg1Body,lowerLeg1Body,upperLeg2Body,lowerLeg2Body];
            this.prevCOM = this.getCenterOfMass();
        }
        
        override internal function createJoints() : void
        {
            var _loc1_:Number = NaN;
            var _loc2_:Number = NaN;
            var _loc3_:Number = NaN;
            super.createJoints();
            _loc1_ = upperLeg1Body.GetAngle() - pelvisBody.GetAngle();
            _loc2_ = -100 / oneEightyOverPI - _loc1_;
            _loc3_ = 0 / oneEightyOverPI - _loc1_;
            hipJoint1.SetLimits(_loc2_,_loc3_);
            _loc1_ = upperLeg2Body.GetAngle() - pelvisBody.GetAngle();
            _loc2_ = -100 / oneEightyOverPI - _loc1_;
            _loc3_ = 0 / oneEightyOverPI - _loc1_;
            hipJoint2.SetLimits(_loc2_,_loc3_);
            _loc1_ = upperArm1Body.GetAngle() - chestBody.GetAngle();
            _loc2_ = -120 / oneEightyOverPI - _loc1_;
            _loc3_ = 0 / oneEightyOverPI - _loc1_;
            shoulderJoint1.SetLimits(_loc2_,_loc3_);
            _loc1_ = upperArm2Body.GetAngle() - chestBody.GetAngle();
            _loc2_ = -120 / oneEightyOverPI - _loc1_;
            _loc3_ = 0 / oneEightyOverPI - _loc1_;
            shoulderJoint2.SetLimits(_loc2_,_loc3_);
            _loc1_ = lowerArm1Body.GetAngle() - upperArm1Body.GetAngle();
            _loc2_ = -60 / oneEightyOverPI - _loc1_;
            _loc3_ = 0 / oneEightyOverPI - _loc1_;
            elbowJoint1.SetLimits(_loc2_,_loc3_);
            _loc1_ = lowerArm2Body.GetAngle() - upperArm2Body.GetAngle();
            _loc2_ = -60 / oneEightyOverPI - _loc1_;
            _loc3_ = 0 / oneEightyOverPI - _loc1_;
            elbowJoint2.SetLimits(_loc2_,_loc3_);
            _loc1_ = head1Body.GetAngle() - chestBody.GetAngle();
            _loc2_ = 0 / oneEightyOverPI - _loc1_;
            _loc3_ = 5 / oneEightyOverPI - _loc1_;
            neckJoint.SetLimits(_loc2_,_loc3_);
            var _loc4_:b2PrismaticJointDef = new b2PrismaticJointDef();
            _loc4_.maxMotorForce = 10000;
            _loc4_.enableLimit = true;
            _loc4_.lowerTranslation = 0;
            _loc4_.upperTranslation = 0 / character_scale;
            _loc4_.enableMotor = true;
            _loc4_.motorSpeed = 0;
            var _loc5_:b2Vec2 = new b2Vec2();
            var _loc6_:MovieClip = shapeGuide["frameShape"];
            var _loc7_:Number = this.frameBody.GetAngle();
            _loc5_.Set(_startX + _loc6_.x / character_scale,_startY + _loc6_.y / character_scale);
            _loc4_.Initialize(this.frameBody,this.rodBody,_loc5_,new b2Vec2(-Math.sin(_loc7_),Math.cos(_loc7_)));
            this.pogoJoint = _session.m_world.CreateJoint(_loc4_) as b2PrismaticJoint;
            var _loc8_:b2RevoluteJointDef = new b2RevoluteJointDef();
            _loc8_.enableLimit = true;
            _loc8_.lowerAngle = -100 / oneEightyOverPI;
            _loc8_.upperAngle = 10 / oneEightyOverPI;
            _loc6_ = shapeGuide["handleAnchor"];
            _loc5_.Set(_startX + _loc6_.x / character_scale,_startY + _loc6_.y / character_scale);
            _loc8_.Initialize(this.frameBody,lowerArm1Body,_loc5_);
            this.frameHand1 = _session.m_world.CreateJoint(_loc8_) as b2RevoluteJoint;
            this.frameHand1JointDef = _loc8_.clone();
            this.handleAnchorPoint = this.frameBody.GetLocalPoint(_loc5_);
            _loc8_.Initialize(this.frameBody,lowerArm2Body,_loc5_);
            this.frameHand2 = _session.m_world.CreateJoint(_loc8_) as b2RevoluteJoint;
            this.frameHand2JointDef = _loc8_.clone();
            _loc8_.lowerAngle = -10 / oneEightyOverPI;
            _loc8_.upperAngle = 10 / oneEightyOverPI;
            _loc6_ = shapeGuide["footAnchor"];
            _loc5_.Set(_startX + _loc6_.x / character_scale,_startY + _loc6_.y / character_scale);
            _loc8_.Initialize(this.frameBody,lowerLeg1Body,_loc5_);
            this.frameFoot1 = _session.m_world.CreateJoint(_loc8_) as b2RevoluteJoint;
            this.frameFoot1JointDef = _loc8_.clone();
            this.footAnchorPoint = this.frameBody.GetLocalPoint(_loc5_);
            _loc8_.Initialize(this.frameBody,lowerLeg2Body,_loc5_);
            this.frameFoot2 = _session.m_world.CreateJoint(_loc8_) as b2RevoluteJoint;
            this.frameFoot2JointDef = _loc8_.clone();
        }
        
        override internal function createMovieClips() : void
        {
            super.createMovieClips();
            this.frameMC = sourceObject["frame"];
            var _loc2_:* = 1 / mc_scale;
            this.frameMC.scaleY = 1 / mc_scale;
            this.frameMC.scaleX = _loc2_;
            this.brokenFrame1MC = sourceObject["brokenframe1"];
            _loc2_ = 1 / mc_scale;
            this.brokenFrame1MC.scaleY = 1 / mc_scale;
            this.brokenFrame1MC.scaleX = _loc2_;
            this.brokenFrame2MC = sourceObject["brokenframe2"];
            _loc2_ = 1 / mc_scale;
            this.brokenFrame2MC.scaleY = 1 / mc_scale;
            this.brokenFrame2MC.scaleX = _loc2_;
            this.rodMC = sourceObject["rod"];
            _loc2_ = 1 / mc_scale;
            this.rodMC.scaleY = 1 / mc_scale;
            this.rodMC.scaleX = _loc2_;
            this.springMC = sourceObject["spring"];
            _loc2_ = 1 / mc_scale;
            this.springMC.scaleY = 1 / mc_scale;
            this.springMC.scaleX = _loc2_;
            this.helmetMC = sourceObject["helmet"];
            _loc2_ = 1 / mc_scale;
            this.helmetMC.scaleY = 1 / mc_scale;
            this.helmetMC.scaleX = _loc2_;
            this.helmetMC.visible = false;
            this.frameBody.SetUserData(this.frameMC);
            this.rodBody.SetUserData(this.rodMC);
            var _loc1_:int = _session.containerSprite.getChildIndex(upperLeg1MC);
            _session.containerSprite.addChildAt(this.frameMC,_loc1_);
            _session.containerSprite.addChildAt(this.brokenFrame1MC,_loc1_);
            _session.containerSprite.addChildAt(this.brokenFrame2MC,_loc1_);
            _session.containerSprite.addChildAt(this.springMC,_loc1_);
            _session.containerSprite.addChildAt(this.rodMC,_loc1_);
            _session.containerSprite.addChildAt(this.helmetMC,_session.containerSprite.getChildIndex(chestMC));
            this.rodMC.gotoAndStop(1);
            this.brokenFrame1MC.visible = false;
            this.brokenFrame2MC.visible = false;
            this.springMC.visible = false;
        }
        
        override internal function resetMovieClips() : void
        {
            super.resetMovieClips();
            this.frameBody.SetUserData(this.frameMC);
            this.rodBody.SetUserData(this.rodMC);
            this.frameMC.visible = true;
            this.brokenFrame1MC.visible = false;
            this.brokenFrame2MC.visible = false;
            this.springMC.visible = false;
            this.rodMC.gotoAndStop(1);
            this.helmetMC.visible = false;
            head1MC.helmet.visible = true;
        }
        
        override internal function createDictionaries() : void
        {
            super.createDictionaries();
            this.helmetShape = head1Shape;
            contactImpulseDict[this.helmetShape] = this.helmetSmashLimit;
            contactImpulseDict[this.frameShape] = this.frameSmashLimit;
            contactAddSounds[this.frameShape] = "Thud1";
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
                delete contactAddBuffer[this.frameShape];
            }
        }
        
        protected function nubContactAdd(param1:b2ContactPoint) : void
        {
            if(param1.shape2.m_isSensor)
            {
                return;
            }
            var _loc2_:b2Shape = param1.shape1;
            var _loc3_:b2Body = _loc2_.m_body;
            var _loc4_:b2Shape = param1.shape2;
            var _loc5_:b2Body = _loc4_.m_body;
            var _loc6_:Number = _loc5_.m_mass;
            if(_loc6_ != 0 && _loc6_ < _loc3_.m_mass)
            {
                return;
            }
            this.airLean = false;
            this.nubContacts += 1;
            if(contactAddBuffer[_loc2_])
            {
                return;
            }
            var _loc7_:Number = b2Math.b2Dot(param1.velocity,param1.normal);
            _loc7_ = Math.abs(_loc7_);
            if(_loc7_ > 4)
            {
            }
        }
        
        protected function nubContactRemove(param1:b2ContactPoint) : void
        {
            if(param1.shape2.m_isSensor)
            {
                return;
            }
            var _loc2_:b2Shape = param1.shape1;
            var _loc3_:b2Body = _loc2_.m_body;
            var _loc4_:b2Shape = param1.shape2;
            var _loc5_:b2Body = _loc4_.m_body;
            var _loc6_:Number = _loc5_.m_mass;
            if(_loc6_ != 0 && _loc6_ < _loc3_.m_mass)
            {
                return;
            }
            --this.nubContacts;
        }
        
        override internal function eject() : void
        {
            if(this.ejected)
            {
                return;
            }
            removeAction(this.reAttaching);
            actionsVector.push(this.relaxPogo);
            this.ejected = true;
            this.pogoJoint.SetMotorSpeed(0);
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
            this.frameShape.SetFilterData(zeroFilter);
            this.rodShape.SetFilterData(zeroFilter);
            _session.m_world.Refilter(this.frameShape);
            _session.m_world.Refilter(this.rodShape);
            elbowBreakLimit = this.tempElbowBreakLimit;
            elbowLigamentLimit = this.tempElbowLigamentLimit;
            kneeBreakLimit = this.tempKneeBreakLimit;
            kneeLigamentLimit = this.tempKneeLigamentLimit;
            lowerArm1MC.hand.gotoAndStop(2);
            lowerArm2MC.hand.gotoAndStop(2);
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
            _session.contactListener.deleteListener(ContactListener.ADD,this.frameShape);
            var _loc2_:b2World = _session.m_world;
            _loc2_.DestroyJoint(this.pogoJoint);
            this.frameSmashed = true;
            this.eject();
            var _loc3_:Number = this.frameBody.GetAngularVelocity();
            var _loc4_:b2BodyDef = new b2BodyDef();
            _loc4_.position = this.frameBody.GetPosition();
            _loc4_.angle = this.frameBody.GetAngle();
            var _loc5_:b2PolygonDef = new b2PolygonDef();
            _loc5_.density = 5;
            _loc5_.friction = 1;
            _loc5_.restitution = 0.1;
            _loc5_.filter = zeroFilter;
            var _loc6_:Number = 31.25 / character_scale;
            var _loc7_:b2Body = _loc2_.CreateBody(_loc4_);
            _loc5_.SetAsOrientedBox(10 / character_scale,_loc6_,new b2Vec2(0,-_loc6_),0);
            _loc7_.CreateShape(_loc5_);
            _loc7_.SetMassFromShapes();
            _loc7_.SetAngularVelocity(_loc3_);
            _loc7_.SetLinearVelocity(this.frameBody.GetLinearVelocityFromLocalPoint(new b2Vec2(0,-_loc6_)));
            _loc7_.SetUserData(this.brokenFrame1MC);
            paintVector.push(_loc7_);
            _loc7_ = _loc2_.CreateBody(_loc4_);
            _loc5_.SetAsOrientedBox(10 / character_scale,_loc6_,new b2Vec2(0,_loc6_),0);
            _loc7_.CreateShape(_loc5_);
            _loc7_.SetMassFromShapes();
            _loc7_.SetAngularVelocity(_loc3_);
            _loc7_.SetLinearVelocity(this.frameBody.GetLinearVelocityFromLocalPoint(new b2Vec2(0,_loc6_)));
            _loc7_.SetUserData(this.brokenFrame2MC);
            paintVector.push(_loc7_);
            _loc7_ = _loc2_.CreateBody(_loc4_);
            _loc5_.SetAsOrientedBox(4 / character_scale,_loc6_,new b2Vec2(0,0),0);
            _loc5_.density = 0.5;
            _loc7_.CreateShape(_loc5_);
            _loc7_.SetMassFromShapes();
            _loc7_.SetAngularVelocity(_loc3_);
            _loc7_.SetLinearVelocity(this.frameBody.GetLinearVelocity());
            _loc7_.SetUserData(this.springMC);
            paintVector.push(_loc7_);
            this.frameMC.visible = false;
            this.brokenFrame1MC.visible = true;
            this.brokenFrame2MC.visible = true;
            this.springMC.visible = true;
            this.rodMC.gotoAndStop(2);
            _loc2_.DestroyBody(this.frameBody);
            SoundController.instance.playAreaSoundInstance("PogoFrameSmash",_loc7_);
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
        
        override internal function shoulderBreak1(param1:Number, param2:Boolean = true) : void
        {
            super.shoulderBreak1(param1,param2);
            if(this.ejected)
            {
                return;
            }
            this.removeFromCOMArray(upperArm1Body);
            this.removeFromCOMArray(lowerArm1Body);
            if(upperArm3Body)
            {
                this.COMArray.push(upperArm3Body);
            }
            if(this.frameHand1)
            {
                _session.m_world.DestroyJoint(this.frameHand1);
                this.frameHand1 = null;
                this.checkEject();
            }
        }
        
        override internal function shoulderBreak2(param1:Number, param2:Boolean = true) : void
        {
            super.shoulderBreak2(param1,param2);
            if(this.ejected)
            {
                return;
            }
            this.removeFromCOMArray(upperArm2Body);
            this.removeFromCOMArray(lowerArm2Body);
            if(upperArm4Body)
            {
                this.COMArray.push(upperArm4Body);
            }
            if(this.frameHand2)
            {
                _session.m_world.DestroyJoint(this.frameHand2);
                this.frameHand2 = null;
                this.checkEject();
            }
        }
        
        override internal function elbowBreak1(param1:Number) : void
        {
            super.elbowBreak1(param1);
            if(this.ejected)
            {
                return;
            }
            this.removeFromCOMArray(lowerArm1Body);
            if(this.frameHand1)
            {
                _session.m_world.DestroyJoint(this.frameHand1);
                this.frameHand1 = null;
                this.checkEject();
            }
        }
        
        override internal function elbowBreak2(param1:Number) : void
        {
            super.elbowBreak2(param1);
            if(this.ejected)
            {
                return;
            }
            this.removeFromCOMArray(lowerArm2Body);
            if(this.frameHand2)
            {
                _session.m_world.DestroyJoint(this.frameHand2);
                this.frameHand2 = null;
                this.checkEject();
            }
        }
        
        override internal function hipBreak1(param1:Number, param2:Boolean = true) : void
        {
            super.hipBreak1(param1,param2);
            if(this.ejected)
            {
                return;
            }
            this.removeFromCOMArray(upperLeg1Body);
            this.removeFromCOMArray(lowerLeg1Body);
            if(upperLeg3Body)
            {
                this.COMArray.push(upperLeg3Body);
            }
            if(this.frameFoot1)
            {
                _session.m_world.DestroyJoint(this.frameFoot1);
                this.frameFoot1 = null;
                this.checkLegsBroken();
            }
        }
        
        override internal function hipBreak2(param1:Number, param2:Boolean = true) : void
        {
            super.hipBreak2(param1,param2);
            if(this.ejected)
            {
                return;
            }
            this.removeFromCOMArray(upperLeg2Body);
            this.removeFromCOMArray(lowerLeg2Body);
            if(upperLeg4Body)
            {
                this.COMArray.push(upperLeg4Body);
            }
            if(this.frameFoot2)
            {
                _session.m_world.DestroyJoint(this.frameFoot2);
                this.frameFoot2 = null;
                this.checkLegsBroken();
            }
        }
        
        override internal function kneeBreak1(param1:Number) : void
        {
            super.kneeBreak1(param1);
            if(this.ejected)
            {
                return;
            }
            this.removeFromCOMArray(lowerLeg1Body);
            if(this.frameFoot1)
            {
                _session.m_world.DestroyJoint(this.frameFoot1);
                this.frameFoot1 = null;
                this.checkLegsBroken();
            }
        }
        
        override internal function kneeBreak2(param1:Number) : void
        {
            super.kneeBreak2(param1);
            if(this.ejected)
            {
                return;
            }
            this.removeFromCOMArray(lowerLeg2Body);
            if(this.frameFoot2)
            {
                _session.m_world.DestroyJoint(this.frameFoot2);
                this.frameFoot2 = null;
                this.checkLegsBroken();
            }
        }
        
        internal function pogoPose() : void
        {
            setJoint(kneeJoint1,1.2,10);
            setJoint(kneeJoint2,1.2,10);
        }
        
        internal function squatPose() : void
        {
            setJoint(kneeJoint1,2.5,10);
            setJoint(kneeJoint2,2.5,10);
        }
        
        internal function straightLegPose() : void
        {
            setJoint(kneeJoint1,0.25,10);
            setJoint(kneeJoint2,0.25,10);
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
        
        protected function getCenterOfMass() : b2Vec2
        {
            var _loc5_:b2Body = null;
            var _loc6_:b2Vec2 = null;
            var _loc7_:Number = NaN;
            var _loc1_:b2Vec2 = new b2Vec2();
            var _loc2_:Number = 0;
            var _loc3_:int = int(this.COMArray.length);
            var _loc4_:int = 0;
            while(_loc4_ < _loc3_)
            {
                _loc5_ = this.COMArray[_loc4_];
                _loc6_ = _loc5_.GetWorldCenter();
                _loc7_ = _loc5_.GetMass();
                _loc1_.x += _loc6_.x * _loc7_;
                _loc1_.y += _loc6_.y * _loc7_;
                _loc2_ += _loc7_;
                _loc4_++;
            }
            _loc1_.Multiply(1 / _loc2_);
            return _loc1_;
        }
        
        protected function removeFromCOMArray(param1:b2Body) : void
        {
            var _loc2_:int = int(this.COMArray.indexOf(param1));
            if(_loc2_ > -1)
            {
                this.COMArray.splice(_loc2_,1);
            }
        }
        
        protected function updateCOMValues() : void
        {
            this.currCOM = this.getCenterOfMass();
            this.velocityCOM = new b2Vec2(this.currCOM.x - this.prevCOM.x,this.currCOM.y - this.prevCOM.y);
            this.prevCOM = this.currCOM;
            this.velocityAngle = Math.atan2(this.velocityCOM.y,this.velocityCOM.x);
            var _loc1_:b2Vec2 = this.rodBody.GetWorldPoint(new b2Vec2(0,62.5 / character_scale));
            this.pivotDirection = new b2Vec2(this.currCOM.x - _loc1_.x,this.currCOM.y - _loc1_.y);
            this.pivotAngle = Math.atan2(this.pivotDirection.y,this.pivotDirection.x);
        }
        
        internal function checkEject() : void
        {
            if(!this.frameHand1 && !this.frameHand2)
            {
                this.eject();
            }
        }
        
        internal function checkLegsBroken() : void
        {
            var _loc1_:b2FilterData = null;
            if((Boolean(hipJoint1.broken) || Boolean(kneeJoint1.broken)) && (Boolean(hipJoint2.broken) || Boolean(kneeJoint2.broken)))
            {
                _loc1_ = defaultFilter.Copy();
                _loc1_.groupIndex = 0;
                this.frameShape.SetFilterData(_loc1_);
                this.nubShape.SetFilterData(_loc1_);
                _session.m_world.Refilter(this.frameShape);
                _session.m_world.Refilter(this.nubShape);
            }
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
            removeAction(this.relaxPogo);
            this.ejected = false;
            currentPose = 0;
            releaseGrip();
            elbowBreakLimit = 90;
            elbowLigamentLimit = 110;
            kneeBreakLimit = 120;
            kneeLigamentLimit = 140;
            _loc2_ = hipJoint1.m_body2.GetAngle() - hipJoint1.m_body1.GetAngle() - hipJoint1.GetJointAngle();
            _loc3_ = -100 / oneEightyOverPI - _loc2_;
            _loc4_ = 0 / oneEightyOverPI - _loc2_;
            hipJoint1.SetLimits(_loc3_,_loc4_);
            _loc2_ = hipJoint2.m_body2.GetAngle() - hipJoint2.m_body1.GetAngle() - hipJoint2.GetJointAngle();
            _loc3_ = -100 / oneEightyOverPI - _loc2_;
            _loc4_ = 0 / oneEightyOverPI - _loc2_;
            hipJoint2.SetLimits(_loc3_,_loc4_);
            _loc2_ = shoulderJoint1.m_body2.GetAngle() - shoulderJoint1.m_body1.GetAngle() - shoulderJoint1.GetJointAngle();
            _loc3_ = -120 / oneEightyOverPI - _loc2_;
            _loc4_ = 0 / oneEightyOverPI - _loc2_;
            shoulderJoint1.SetLimits(_loc3_,_loc4_);
            _loc2_ = shoulderJoint2.m_body2.GetAngle() - shoulderJoint2.m_body1.GetAngle() - shoulderJoint2.GetJointAngle();
            _loc3_ = -120 / oneEightyOverPI - _loc2_;
            _loc4_ = 0 / oneEightyOverPI - _loc2_;
            shoulderJoint2.SetLimits(_loc3_,_loc4_);
            _loc2_ = lowerArm1Body.GetAngle() - upperArm1Body.GetAngle() - elbowJoint1.GetJointAngle();
            _loc3_ = -60 / oneEightyOverPI - _loc2_;
            _loc4_ = 0 / oneEightyOverPI - _loc2_;
            elbowJoint1.SetLimits(_loc3_,_loc4_);
            _loc2_ = lowerArm2Body.GetAngle() - upperArm2Body.GetAngle() - elbowJoint2.GetJointAngle();
            _loc3_ = -60 / oneEightyOverPI - _loc2_;
            _loc4_ = 0 / oneEightyOverPI - _loc2_;
            elbowJoint2.SetLimits(_loc3_,_loc4_);
            _loc2_ = head1Body.GetAngle() - chestBody.GetAngle() - neckJoint.GetJointAngle();
            _loc3_ = 0 / oneEightyOverPI - _loc2_;
            _loc4_ = 5 / oneEightyOverPI - _loc2_;
            neckJoint.SetLimits(_loc3_,_loc4_);
            var _loc5_:b2World = _session.m_world;
            this.frameShape.SetFilterData(defaultFilter);
            this.rodShape.SetFilterData(defaultFilter);
            _loc5_.Refilter(this.frameShape);
            _loc5_.Refilter(this.rodShape);
            this.checkLegsBroken();
            if(param1 == lowerArm1Body)
            {
                this.frameHand1 = _loc5_.CreateJoint(this.frameHand1JointDef) as b2RevoluteJoint;
                lowerArm1MC.hand.gotoAndStop(1);
            }
            else
            {
                this.frameHand2 = _loc5_.CreateJoint(this.frameHand2JointDef) as b2RevoluteJoint;
                lowerArm2MC.hand.gotoAndStop(1);
            }
            actionsVector.push(this.reAttaching);
        }
        
        public function reAttaching() : void
        {
            var _loc3_:b2Vec2 = null;
            var _loc4_:b2Vec2 = null;
            var _loc1_:int = 0;
            var _loc2_:b2World = _session.m_world;
            if(!this.frameHand1 && !elbowJoint1.broken && !shoulderJoint1.broken)
            {
                _loc3_ = lowerArm1Body.GetWorldPoint(new b2Vec2(0,(lowerArm1Shape as b2PolygonShape).GetVertices()[2].y));
                _loc4_ = this.frameBody.GetWorldPoint(this.handleAnchorPoint);
                if(Math.abs(_loc3_.x - _loc4_.x) < this.reAttachDistance && Math.abs(_loc3_.y - _loc4_.y) < this.reAttachDistance)
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
                _loc3_ = lowerArm2Body.GetWorldPoint(new b2Vec2(0,(lowerArm2Shape as b2PolygonShape).GetVertices()[2].y));
                _loc4_ = this.frameBody.GetWorldPoint(this.handleAnchorPoint);
                if(Math.abs(_loc3_.x - _loc4_.x) < this.reAttachDistance && Math.abs(_loc3_.y - _loc4_.y) < this.reAttachDistance)
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
            if(!this.frameFoot1 && !kneeJoint1.broken && !hipJoint1.broken)
            {
                _loc3_ = lowerLeg1Body.GetWorldPoint(new b2Vec2(0,(lowerLeg1Shape as b2PolygonShape).GetVertices()[2].y));
                _loc4_ = this.frameBody.GetWorldPoint(this.footAnchorPoint);
                if(Math.abs(_loc3_.x - _loc4_.x) < 0.2 && Math.abs(_loc3_.y - _loc4_.y) < 0.2)
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
                _loc3_ = lowerLeg2Body.GetWorldPoint(new b2Vec2(0,(lowerLeg2Shape as b2PolygonShape).GetVertices()[2].y));
                _loc4_ = this.frameBody.GetWorldPoint(this.footAnchorPoint);
                if(Math.abs(_loc3_.x - _loc4_.x) < 0.2 && Math.abs(_loc3_.y - _loc4_.y) < 0.2)
                {
                    this.frameFoot2 = _loc2_.CreateJoint(this.frameFoot2JointDef) as b2RevoluteJoint;
                    _loc1_ += 1;
                }
            }
            else
            {
                _loc1_ += 1;
            }
            if(_loc1_ >= 4)
            {
                trace("ATTACH COMPLETE");
                removeAction(this.reAttaching);
                currentPose = 9;
            }
        }
        
        protected function relaxPogo() : void
        {
            trace("RELAX POGO");
            var _loc1_:Number = this.pogoJoint.GetJointTranslation();
            var _loc2_:Number = _loc1_ * -70;
            if(_loc1_ < 0)
            {
                this.pogoJoint.SetMotorSpeed(_loc2_);
            }
            else
            {
                trace("RELAXED");
                this.pogoJoint.SetMotorSpeed(0);
                this.pogoJoint.m_lowerTranslation = 0;
                this.jumpFrames = this.jumpFramesMax;
                removeAction(this.relaxPogo);
            }
        }
    }
}

