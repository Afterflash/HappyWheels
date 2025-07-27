package com.totaljerkface.game.character
{
    import Box2D.Collision.Shapes.*;
    import Box2D.Collision.b2AABB;
    import Box2D.Collision.b2ContactPoint;
    import Box2D.Common.Math.b2Math;
    import Box2D.Common.Math.b2Vec2;
    import Box2D.Dynamics.*;
    import Box2D.Dynamics.Joints.*;
    import com.totaljerkface.game.*;
    import com.totaljerkface.game.events.*;
    import com.totaljerkface.game.sound.AreaSoundLoop;
    import com.totaljerkface.game.sound.SoundController;
    import flash.display.*;
    import flash.events.*;
    
    public class WheelChairGuy extends CharacterB2D
    {
        private var firing:Boolean;
        
        private var ejected:Boolean;
        
        private var chairSmashed:Boolean;
        
        private var wheelMaxSpeed:Number = 20;
        
        private var wheelCurrentSpeed:Number;
        
        private var wheelNewSpeed:Number;
        
        private var wheelContacts:Number = 0;
        
        private var accelStep:Number = 0.2;
        
        private var maxTorque:Number = 20;
        
        private var impulseMagnitude:Number = 0.5;
        
        private var impulseOffset:Number = 1;
        
        private var maxSpinAV:Number = 5;
        
        private var jetImpulse:Number = 2;
        
        private var jetAngle:Number = 0;
        
        private var jetSound:AreaSoundLoop;
        
        private var wheelSound:AreaSoundLoop;
        
        internal var chairSmashLimit:Number = 200;
        
        internal var wheelSmashLimit:Number = 200;
        
        internal var jetSmashLimit:Number = 30;
        
        internal var fueltankSmashLimit:Number = 30;
        
        internal var chairBody:b2Body;
        
        internal var bigWheelBody:b2Body;
        
        internal var smallWheelBody:b2Body;
        
        internal var jetBody:b2Body;
        
        internal var fueltankBody:b2Body;
        
        internal var jetShape:b2Shape;
        
        internal var fueltankShape:b2Shape;
        
        internal var bigWheelShape:b2Shape;
        
        internal var chairShape1:b2Shape;
        
        internal var chairShape2:b2Shape;
        
        internal var chairShape3:b2Shape;
        
        internal var chairMC:MovieClip;
        
        internal var bigWheelMC:MovieClip;
        
        internal var smallWheelMC:MovieClip;
        
        internal var jetMC:MovieClip;
        
        internal var handleMC:MovieClip;
        
        internal var fueltankMC:MovieClip;
        
        internal var bigWheelJoint:b2RevoluteJoint;
        
        internal var smallWheelJoint:b2RevoluteJoint;
        
        internal var chairPelvis:b2RevoluteJoint;
        
        internal var chairChest:b2RevoluteJoint;
        
        internal var chairLeg1:b2RevoluteJoint;
        
        internal var chairLeg2:b2RevoluteJoint;
        
        public function WheelChairGuy(param1:Number, param2:Number, param3:DisplayObject, param4:Session)
        {
            super(param1,param2,param3,param4);
        }
        
        override internal function leftPressedActions() : void
        {
            var _loc1_:Number = NaN;
            var _loc2_:Number = NaN;
            var _loc3_:Number = NaN;
            var _loc4_:Number = NaN;
            var _loc5_:Number = NaN;
            var _loc6_:b2Vec2 = null;
            if(this.ejected)
            {
                currentPose = 1;
            }
            else
            {
                _loc1_ = this.chairBody.GetAngle();
                _loc2_ = this.chairBody.GetAngularVelocity();
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
                _loc6_ = this.chairBody.GetLocalCenter();
                this.chairBody.ApplyImpulse(new b2Vec2(_loc5_,-_loc4_),this.chairBody.GetWorldPoint(new b2Vec2(_loc6_.x + this.impulseOffset,_loc6_.y)));
            }
        }
        
        override internal function rightPressedActions() : void
        {
            var _loc1_:Number = NaN;
            var _loc2_:Number = NaN;
            var _loc3_:Number = NaN;
            var _loc4_:Number = NaN;
            var _loc5_:Number = NaN;
            var _loc6_:Number = NaN;
            var _loc7_:b2Vec2 = null;
            if(this.ejected)
            {
                currentPose = 2;
            }
            else
            {
                _loc1_ = this.chairBody.GetAngle();
                _loc2_ = this.chairBody.GetAngularVelocity();
                _loc3_ = (_loc2_ - this.maxSpinAV) / -this.maxSpinAV;
                if(_loc3_ < 0)
                {
                    _loc3_ = 0;
                }
                if(_loc3_ > 1)
                {
                    _loc3_ = 1;
                }
                _loc4_ = 1;
                _loc5_ = Math.cos(_loc1_) * this.impulseMagnitude * _loc3_;
                _loc6_ = Math.sin(_loc1_) * this.impulseMagnitude * _loc3_;
                _loc7_ = this.chairBody.GetLocalCenter();
                this.chairBody.ApplyImpulse(new b2Vec2(_loc6_,-_loc5_),this.chairBody.GetWorldPoint(new b2Vec2(_loc7_.x - this.impulseOffset,_loc7_.y)));
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
                if(!this.bigWheelJoint.IsMotorEnabled())
                {
                    this.bigWheelJoint.EnableMotor(true);
                }
                this.wheelCurrentSpeed = this.bigWheelJoint.GetJointSpeed();
                if(this.wheelCurrentSpeed < 0)
                {
                    this.wheelNewSpeed = 0;
                }
                else
                {
                    this.wheelNewSpeed = this.wheelCurrentSpeed < this.wheelMaxSpeed ? this.wheelCurrentSpeed + this.accelStep : this.wheelCurrentSpeed;
                }
                this.bigWheelJoint.SetMotorSpeed(this.wheelNewSpeed);
                currentPose = 5;
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
                if(!this.bigWheelJoint.IsMotorEnabled())
                {
                    this.bigWheelJoint.EnableMotor(true);
                }
                this.wheelCurrentSpeed = this.bigWheelJoint.GetJointSpeed();
                if(this.wheelCurrentSpeed > 0)
                {
                    this.wheelNewSpeed = 0;
                }
                else
                {
                    this.wheelNewSpeed = this.wheelCurrentSpeed > -this.wheelMaxSpeed ? this.wheelCurrentSpeed - this.accelStep : this.wheelCurrentSpeed;
                }
                this.bigWheelJoint.SetMotorSpeed(this.wheelNewSpeed);
                currentPose = 5;
            }
        }
        
        override internal function upAndDownActions() : void
        {
            if(this.bigWheelJoint.IsMotorEnabled())
            {
                this.bigWheelJoint.EnableMotor(false);
            }
            if(this.ejected)
            {
                if(_currentPose == 3 || _currentPose == 4)
                {
                    currentPose = 0;
                }
            }
            else if(_currentPose == 5)
            {
                currentPose = 0;
            }
        }
        
        override internal function spacePressedActions() : void
        {
            if(this.ejected)
            {
                startGrab();
            }
            else
            {
                if(this.chairSmashed)
                {
                    return;
                }
                if(!this.firing)
                {
                    this.firing = true;
                    this.jetMC.inner.turbine.play();
                    this.jetMC.flames.visible = true;
                    if(!this.jetSound)
                    {
                        this.jetSound = SoundController.instance.playAreaSoundLoop("JetBlast",this.bigWheelBody,0);
                        this.jetSound.fadeIn(0.2);
                    }
                    else
                    {
                        this.jetSound.fadeIn(0.2);
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
            else if(this.firing)
            {
                this.firing = false;
                this.jetMC.inner.turbine.stop();
                this.jetMC.flames.visible = false;
                this.jetSound.fadeOut(0.2);
                this.jetSound = null;
            }
        }
        
        override internal function shiftPressedActions() : void
        {
            if(this.ejected)
            {
                currentPose = 6;
            }
            else
            {
                this.jetAngle += 0.1;
            }
        }
        
        override internal function shiftNullActions() : void
        {
            if(_currentPose == 6)
            {
                currentPose = 0;
            }
        }
        
        override internal function ctrlPressedActions() : void
        {
            if(this.ejected)
            {
                currentPose = 7;
            }
            else
            {
                this.jetAngle -= 0.1;
            }
        }
        
        override internal function ctrlNullActions() : void
        {
            if(_currentPose == 7)
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
            var _loc2_:Number = NaN;
            var _loc3_:Number = NaN;
            if(this.firing)
            {
                _loc1_ = this.chairBody.GetAngle() + this.jetAngle;
                _loc2_ = Math.cos(_loc1_) * this.jetImpulse;
                _loc3_ = Math.sin(_loc1_) * this.jetImpulse;
                this.bigWheelBody.ApplyImpulse(new b2Vec2(_loc2_,_loc3_),this.chairBody.GetWorldCenter());
            }
            if(this.wheelContacts > 0)
            {
                if(Math.abs(this.bigWheelBody.GetAngularVelocity()) > 1)
                {
                    if(!this.wheelSound)
                    {
                        this.wheelSound = SoundController.instance.playAreaSoundLoop("BikeLoop1",this.bigWheelBody,0);
                        this.wheelSound.fadeIn(0.2);
                    }
                }
                else if(this.wheelSound)
                {
                    this.wheelSound.fadeOut(0.2);
                    this.wheelSound = null;
                }
            }
            else if(this.wheelSound)
            {
                this.wheelSound.fadeOut(0.2);
                this.wheelSound = null;
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
                    this.seatPose();
                    break;
                case 6:
                    this.wheelPoseLeft();
                    break;
                case 7:
                    this.wheelPoseRight();
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
            this.firing = false;
            this.chairSmashed = false;
            this.jetAngle = 0;
            this.jetMC.inner.rotation = 0;
            this.jetMC.inner.turbine.stop();
            this.jetMC.flames.visible = false;
            this.jetSound = null;
            this.wheelContacts = 0;
        }
        
        override public function paint() : void
        {
            super.paint();
            if(this.chairSmashed)
            {
                return;
            }
            var _loc1_:b2Vec2 = this.bigWheelBody.GetWorldCenter();
            this.jetMC.x = _loc1_.x * m_physScale;
            this.jetMC.y = _loc1_.y * m_physScale;
            this.jetMC.rotation = (this.chairBody.GetAngle() + this.jetAngle) * oneEightyOverPI % 360;
        }
        
        override internal function createDictionaries() : void
        {
            super.createDictionaries();
            contactImpulseDict[this.chairShape1] = this.chairSmashLimit;
            contactImpulseDict[this.bigWheelShape] = this.wheelSmashLimit;
            contactAddSounds[this.chairShape1] = "ChairHit1";
            contactAddSounds[this.chairShape2] = "ChairHit2";
            contactAddSounds[this.chairShape3] = "ChairHit3";
            contactAddSounds[this.bigWheelShape] = "TireHit1";
        }
        
        override internal function createBodies() : void
        {
            super.createBodies();
            var _loc1_:b2World = session.m_world;
            var _loc2_:b2BodyDef = new b2BodyDef();
            var _loc3_:b2BodyDef = new b2BodyDef();
            var _loc4_:b2BodyDef = new b2BodyDef();
            var _loc5_:b2PolygonDef = new b2PolygonDef();
            var _loc6_:b2CircleDef = new b2CircleDef();
            _loc5_.density = 2;
            _loc5_.friction = 0.3;
            _loc5_.restitution = 0.1;
            _loc5_.filter.categoryBits = 1025;
            _loc6_.density = 5;
            _loc6_.friction = 1;
            _loc6_.restitution = 0.1;
            _loc6_.filter.categoryBits = 1025;
            var _loc7_:MovieClip = shapeGuide["chair1Shape"];
            var _loc8_:b2Vec2 = new b2Vec2(_startX + _loc7_.x / character_scale,_startY + _loc7_.y / character_scale);
            _loc5_.SetAsOrientedBox(_loc7_.width / 2 / character_scale,_loc7_.height / 2 / character_scale,_loc8_);
            this.chairBody = _loc1_.CreateBody(_loc2_);
            this.chairShape1 = this.chairBody.CreateShape(_loc5_);
            _session.contactListener.registerListener(ContactListener.RESULT,this.chairShape1,this.contactChairResultHandler);
            _session.contactListener.registerListener(ContactListener.ADD,this.chairShape1,contactAddHandler);
            _loc7_ = shapeGuide["chair2Shape"];
            _loc8_.Set(_startX + _loc7_.x / character_scale,_startY + _loc7_.y / character_scale);
            _loc5_.SetAsOrientedBox(_loc7_.width / 2 / character_scale,_loc7_.height / 2 / character_scale,_loc8_);
            this.chairShape2 = this.chairBody.CreateShape(_loc5_);
            _session.contactListener.registerListener(ContactListener.RESULT,this.chairShape2,this.contactChairResultHandler);
            _session.contactListener.registerListener(ContactListener.ADD,this.chairShape2,contactAddHandler);
            _loc7_ = shapeGuide["chair3Shape"];
            _loc8_.Set(_startX + _loc7_.x / character_scale,_startY + _loc7_.y / character_scale);
            _loc5_.SetAsOrientedBox(_loc7_.width / 2 / character_scale,_loc7_.height / 2 / character_scale,_loc8_);
            this.chairShape3 = this.chairBody.CreateShape(_loc5_);
            _session.contactListener.registerListener(ContactListener.RESULT,this.chairShape3,this.contactChairResultHandler);
            _session.contactListener.registerListener(ContactListener.ADD,this.chairShape3,contactAddHandler);
            this.chairBody.SetMassFromShapes();
            paintVector.push(this.chairBody);
            _loc7_ = shapeGuide["bigWheelShape"];
            _loc3_.position.Set(_startX + _loc7_.x / character_scale,_startY + _loc7_.y / character_scale);
            _loc3_.angle = _loc7_.rotation / oneEightyOverPI;
            _loc6_.radius = _loc7_.width / 2 / character_scale;
            this.bigWheelBody = _loc1_.CreateBody(_loc3_);
            this.bigWheelShape = this.bigWheelBody.CreateShape(_loc6_);
            _session.contactListener.registerListener(ContactListener.RESULT,this.bigWheelShape,contactResultHandler);
            _session.contactListener.registerListener(ContactListener.ADD,this.bigWheelShape,this.wheelContactAdd);
            _session.contactListener.registerListener(ContactListener.REMOVE,this.bigWheelShape,this.wheelContactRemove);
            this.bigWheelBody.SetMassFromShapes();
            paintVector.push(this.bigWheelBody);
            _loc7_ = shapeGuide["smallWheelShape"];
            _loc4_.position.Set(_startX + _loc7_.x / character_scale,_startY + _loc7_.y / character_scale);
            _loc4_.angle = _loc7_.rotation / oneEightyOverPI;
            _loc6_.radius = _loc7_.width / 2 / character_scale;
            this.smallWheelBody = _loc1_.CreateBody(_loc4_);
            this.smallWheelBody.CreateShape(_loc6_);
            this.smallWheelBody.SetMassFromShapes();
            paintVector.push(this.smallWheelBody);
            var _loc9_:b2FilterData = new b2FilterData();
            _loc9_.categoryBits = 516;
            _loc9_.groupIndex = groupID;
            _loc9_.maskBits = 520;
            lowerArm1Shape.SetFilterData(_loc9_);
            _loc1_.Refilter(lowerArm1Shape);
            lowerArm2Shape.SetFilterData(_loc9_);
            _loc1_.Refilter(lowerArm2Shape);
        }
        
        override internal function createMovieClips() : void
        {
            super.createMovieClips();
            this.chairMC = sourceObject["chair"];
            var _loc2_:* = 1 / mc_scale;
            this.chairMC.scaleY = 1 / mc_scale;
            this.chairMC.scaleX = _loc2_;
            this.bigWheelMC = sourceObject["bigWheel"];
            _loc2_ = 1 / mc_scale;
            this.bigWheelMC.scaleY = 1 / mc_scale;
            this.bigWheelMC.scaleX = _loc2_;
            this.smallWheelMC = sourceObject["smallWheel"];
            _loc2_ = 1 / mc_scale;
            this.smallWheelMC.scaleY = 1 / mc_scale;
            this.smallWheelMC.scaleX = _loc2_;
            this.jetMC = sourceObject["jet"];
            _loc2_ = 1 / mc_scale;
            this.jetMC.scaleY = 1 / mc_scale;
            this.jetMC.scaleX = _loc2_;
            this.handleMC = sourceObject["handle"];
            _loc2_ = 1 / mc_scale;
            this.handleMC.scaleY = 1 / mc_scale;
            this.handleMC.scaleX = _loc2_;
            this.fueltankMC = sourceObject["fueltank"];
            _loc2_ = 1 / mc_scale;
            this.fueltankMC.scaleY = 1 / mc_scale;
            this.fueltankMC.scaleX = _loc2_;
            this.chairBody.SetUserData(this.chairMC);
            this.bigWheelBody.SetUserData(this.bigWheelMC);
            this.smallWheelBody.SetUserData(this.smallWheelMC);
            var _loc1_:Sprite = session.containerSprite;
            _loc1_.addChildAt(this.fueltankMC,_loc1_.getChildIndex(upperArm1MC));
            _loc1_.addChildAt(this.chairMC,_loc1_.getChildIndex(upperArm1MC));
            _loc1_.addChildAt(this.bigWheelMC,_loc1_.getChildIndex(upperArm1MC));
            _loc1_.addChildAt(this.smallWheelMC,_loc1_.getChildIndex(upperArm1MC));
            _loc1_.addChildAt(this.handleMC,_loc1_.getChildIndex(upperArm1MC));
            _loc1_.addChildAt(this.jetMC,_loc1_.getChildIndex(upperArm1MC));
            this.jetMC.inner.turbine.stop();
            this.jetMC.flames.visible = false;
            this.bigWheelMC.stop();
            this.bigWheelMC["inner"].visible = false;
            this.handleMC.visible = false;
            this.fueltankMC.visible = false;
            this.chairMC.stop();
            session.particleController.createBMDArray("jetshards",sourceObject["metalShards"]);
        }
        
        override internal function resetMovieClips() : void
        {
            super.resetMovieClips();
            this.chairBody.SetUserData(this.chairMC);
            this.bigWheelBody.SetUserData(this.bigWheelMC);
            this.smallWheelBody.SetUserData(this.smallWheelMC);
            this.bigWheelMC.gotoAndStop(1);
            this.bigWheelMC["inner"].visible = false;
            this.chairMC.gotoAndStop(1);
            this.jetMC.visible = true;
            this.handleMC.visible = false;
            this.fueltankMC.visible = false;
            session.particleController.createBMDArray("jetshards",sourceObject["metalShards"]);
        }
        
        override internal function createJoints() : void
        {
            var _loc2_:Number = NaN;
            var _loc3_:Number = NaN;
            var _loc4_:Number = NaN;
            super.createJoints();
            var _loc1_:b2World = session.m_world;
            var _loc5_:Number = oneEightyOverPI;
            _loc2_ = upperLeg1Body.GetAngle() - pelvisBody.GetAngle();
            _loc3_ = -110 / _loc5_ - _loc2_;
            _loc4_ = -90 / _loc5_ - _loc2_;
            hipJoint1.SetLimits(_loc3_,_loc4_);
            _loc2_ = upperLeg2Body.GetAngle() - pelvisBody.GetAngle();
            _loc3_ = -110 / _loc5_ - _loc2_;
            _loc4_ = -90 / _loc5_ - _loc2_;
            hipJoint2.SetLimits(_loc3_,_loc4_);
            var _loc6_:b2RevoluteJointDef = new b2RevoluteJointDef();
            _loc6_.maxMotorTorque = this.maxTorque;
            var _loc7_:b2Vec2 = new b2Vec2();
            var _loc8_:MovieClip = shapeGuide["bigWheelShape"];
            _loc7_.Set(_startX + _loc8_.x / character_scale,_startY + _loc8_.y / character_scale);
            _loc6_.Initialize(this.chairBody,this.bigWheelBody,_loc7_);
            this.bigWheelJoint = _loc1_.CreateJoint(_loc6_) as b2RevoluteJoint;
            _loc8_ = shapeGuide["smallWheelShape"];
            _loc7_.Set(_startX + _loc8_.x / character_scale,_startY + _loc8_.y / character_scale);
            _loc6_.Initialize(this.chairBody,this.smallWheelBody,_loc7_);
            this.smallWheelJoint = _loc1_.CreateJoint(_loc6_) as b2RevoluteJoint;
            var _loc9_:b2DistanceJointDef = new b2DistanceJointDef();
            _loc9_.Initialize(this.chairBody,pelvisBody,pelvisBody.GetPosition(),pelvisBody.GetPosition());
            _loc7_.Set(chestBody.GetPosition().x,chestBody.GetPosition().y);
            _loc6_.Initialize(this.chairBody,chestBody,_loc7_);
            this.chairChest = _loc1_.CreateJoint(_loc6_) as b2RevoluteJoint;
            _loc7_.Set(pelvisBody.GetPosition().x,pelvisBody.GetPosition().y);
            _loc6_.Initialize(this.chairBody,pelvisBody,_loc7_);
            this.chairPelvis = _loc1_.CreateJoint(_loc6_) as b2RevoluteJoint;
            _loc7_.Set(upperLeg1Body.GetPosition().x,upperLeg1Body.GetPosition().y);
            _loc6_.Initialize(this.chairBody,upperLeg1Body,_loc7_);
            this.chairLeg1 = _loc1_.CreateJoint(_loc6_) as b2RevoluteJoint;
            _loc7_.Set(upperLeg2Body.GetPosition().x,upperLeg2Body.GetPosition().y);
            _loc6_.Initialize(this.chairBody,upperLeg2Body,_loc7_);
            this.chairLeg2 = _loc1_.CreateJoint(_loc6_) as b2RevoluteJoint;
        }
        
        protected function contactChairResultHandler(param1:ContactEvent) : void
        {
            var _loc2_:Number = param1.impulse;
            if(_loc2_ > contactImpulseDict[this.chairShape1])
            {
                if(contactResultBuffer[this.chairShape1])
                {
                    if(_loc2_ > contactResultBuffer[this.chairShape1].impulse)
                    {
                        contactResultBuffer[this.chairShape1] = param1;
                    }
                }
                else
                {
                    contactResultBuffer[this.chairShape1] = param1;
                }
            }
        }
        
        override protected function handleContactResults() : void
        {
            var _loc1_:ContactEvent = null;
            super.handleContactResults();
            if(contactResultBuffer[this.chairShape1])
            {
                _loc1_ = contactResultBuffer[this.chairShape1];
                this.chairSmash(_loc1_.impulse,_loc1_.normal);
                delete contactResultBuffer[this.chairShape1];
                delete contactAddBuffer[this.chairShape1];
                delete contactAddBuffer[this.chairShape2];
                delete contactAddBuffer[this.chairShape3];
            }
            if(contactResultBuffer[this.bigWheelShape])
            {
                _loc1_ = contactResultBuffer[this.bigWheelShape];
                this.wheelSmash(_loc1_.impulse,_loc1_.normal);
                delete contactResultBuffer[this.bigWheelShape];
                delete contactAddBuffer[this.bigWheelShape];
            }
            if(contactResultBuffer[this.jetShape])
            {
                _loc1_ = contactResultBuffer[this.jetShape];
                this.jetSmash(_loc1_.impulse);
                delete contactResultBuffer[this.jetShape];
                delete contactAddBuffer[this.jetShape];
            }
            if(contactResultBuffer[this.fueltankShape])
            {
                _loc1_ = contactResultBuffer[this.fueltankShape];
                this.fueltankSmash(_loc1_.impulse);
                delete contactResultBuffer[this.fueltankShape];
                delete contactAddBuffer[this.fueltankShape];
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
        
        override internal function eject() : void
        {
            if(this.ejected)
            {
                return;
            }
            this.ejected = true;
            var _loc1_:b2World = session.m_world;
            resetJointLimits();
            _loc1_.DestroyJoint(this.chairPelvis);
            this.chairPelvis = null;
            _loc1_.DestroyJoint(this.chairChest);
            this.chairChest = null;
            if(this.chairLeg1)
            {
                _loc1_.DestroyJoint(this.chairLeg1);
                this.chairLeg1 = null;
            }
            if(this.chairLeg2)
            {
                _loc1_.DestroyJoint(this.chairLeg2);
                this.chairLeg2 = null;
            }
            var _loc2_:b2World = _loc1_;
            this.smallWheelBody.GetShapeList().SetFilterData(zeroFilter);
            this.bigWheelBody.GetShapeList().SetFilterData(zeroFilter);
            _loc2_.Refilter(this.smallWheelBody.GetShapeList());
            _loc2_.Refilter(this.bigWheelBody.GetShapeList());
            var _loc3_:b2Shape = this.chairBody.GetShapeList();
            while(_loc3_)
            {
                _loc3_.SetFilterData(zeroFilter);
                _loc2_.Refilter(_loc3_);
                _loc3_ = _loc3_.m_next;
            }
            _loc3_ = lowerArm1Body.GetShapeList();
            if(_loc3_.GetFilterData().maskBits == 520)
            {
                trace("refilter arm 1");
                _loc3_.SetFilterData(defaultFilter);
                _loc2_.Refilter(_loc3_);
            }
            _loc3_ = lowerArm2Body.GetShapeList();
            if(_loc3_.GetFilterData().maskBits == 520)
            {
                trace("refilter arm 2");
                _loc3_.SetFilterData(defaultFilter);
                _loc2_.Refilter(_loc3_);
            }
            lowerArm1MC.hand.gotoAndStop(2);
            lowerArm2MC.hand.gotoAndStop(2);
        }
        
        override public function set dead(param1:Boolean) : void
        {
            _dead = param1;
            if(_dead)
            {
                userVehicleEject();
                currentPose = 0;
                releaseGrip();
                if(voiceSound)
                {
                    voiceSound.stopSound();
                    voiceSound = null;
                }
                this.bigWheelJoint.EnableMotor(false);
            }
        }
        
        internal function chairSmash(param1:Number, param2:b2Vec2) : void
        {
            trace("chair impulse " + param1);
            delete contactImpulseDict[this.chairShape1];
            var _loc3_:ContactListener = _session.contactListener;
            _loc3_.deleteListener(ContactListener.RESULT,this.chairShape1);
            _loc3_.deleteListener(ContactListener.RESULT,this.chairShape2);
            _loc3_.deleteListener(ContactListener.RESULT,this.chairShape3);
            _loc3_.deleteListener(ContactListener.ADD,this.chairShape1);
            _loc3_.deleteListener(ContactListener.ADD,this.chairShape2);
            _loc3_.deleteListener(ContactListener.ADD,this.chairShape3);
            this.chairSmashed = true;
            var _loc4_:b2World = session.m_world;
            this.chairMC.gotoAndStop(2);
            _loc4_.DestroyJoint(this.bigWheelJoint);
            _loc4_.DestroyJoint(this.smallWheelJoint);
            var _loc5_:b2Shape = this.chairBody.GetShapeList();
            while(_loc5_)
            {
                this.chairBody.DestroyShape(_loc5_);
                _loc5_ = this.chairBody.GetShapeList();
            }
            var _loc6_:b2PolygonDef = new b2PolygonDef();
            _loc6_.density = 2;
            _loc6_.friction = 0.3;
            _loc6_.restitution = 0.1;
            _loc6_.filter = zeroFilter;
            var _loc7_:b2Vec2 = this.chairBody.GetLocalCenter();
            _loc6_.SetAsOrientedBox(40 / character_scale,45 / character_scale,new b2Vec2(_loc7_.x + 8 / character_scale,_loc7_.y + 2 / character_scale),0);
            var _loc8_:b2Shape = this.chairBody.CreateShape(_loc6_);
            contactAddSounds[_loc8_] = "ChairHit3";
            _session.contactListener.registerListener(ContactListener.ADD,_loc8_,contactAddHandler);
            var _loc9_:b2BodyDef = new b2BodyDef();
            var _loc10_:b2Body = _loc4_.CreateBody(_loc9_);
            var _loc11_:Number = this.chairBody.GetAngle();
            _loc6_.SetAsOrientedBox(5 / character_scale,35 / character_scale,this.chairBody.GetWorldPoint(new b2Vec2(_loc7_.x - 30 / character_scale,_loc7_.y - 55 / character_scale)),_loc11_);
            _loc10_.CreateShape(_loc6_);
            _loc10_.SetMassFromShapes();
            _loc10_.SetUserData(this.handleMC);
            this.handleMC.visible = true;
            this.handleMC.inner.rotation = _loc11_ * oneEightyOverPI;
            paintVector.push(_loc10_);
            var _loc12_:b2Vec2 = this.chairBody.GetLinearVelocity();
            var _loc13_:Number = this.chairBody.GetAngularVelocity();
            _loc10_.SetAngularVelocity(_loc13_);
            _loc10_.SetLinearVelocity(_loc12_);
            _loc9_.position = this.chairBody.GetWorldPoint(new b2Vec2(_loc7_.x + 8 / character_scale,_loc7_.y + 14 / character_scale));
            _loc9_.angle = _loc11_;
            this.fueltankBody = _loc4_.CreateBody(_loc9_);
            _loc6_.SetAsBox(30 / character_scale,9 / character_scale);
            this.fueltankShape = this.fueltankBody.CreateShape(_loc6_);
            _loc3_.registerListener(ContactListener.RESULT,this.fueltankShape,contactResultHandler);
            _loc3_.registerListener(ContactListener.ADD,this.fueltankShape,contactAddHandler);
            contactAddSounds[this.fueltankShape] = "ChairHit1";
            this.fueltankBody.SetMassFromShapes();
            this.fueltankBody.SetUserData(this.fueltankMC);
            this.fueltankMC.visible = true;
            paintVector.push(this.fueltankBody);
            this.fueltankBody.SetAngularVelocity(_loc13_);
            this.fueltankBody.SetLinearVelocity(_loc12_);
            contactImpulseDict[this.fueltankShape] = this.fueltankSmashLimit;
            _loc9_ = new b2BodyDef();
            this.jetBody = _loc4_.CreateBody(_loc9_);
            _loc11_ = this.chairBody.GetAngle() + this.jetAngle;
            _loc6_.SetAsOrientedBox(21 / character_scale,16.5 / character_scale,this.bigWheelBody.GetWorldCenter(),_loc11_);
            this.jetShape = this.jetBody.CreateShape(_loc6_);
            _loc3_.registerListener(ContactListener.RESULT,this.jetShape,contactResultHandler);
            _loc3_.registerListener(ContactListener.ADD,this.jetShape,contactAddHandler);
            contactAddSounds[this.jetShape] = "ChairHit2";
            this.jetBody.SetMassFromShapes();
            this.jetBody.SetUserData(this.jetMC);
            this.jetMC.inner.rotation = _loc11_ * oneEightyOverPI;
            paintVector.push(this.jetBody);
            this.jetBody.SetAngularVelocity(_loc13_);
            this.jetBody.SetLinearVelocity(_loc12_);
            contactImpulseDict[this.jetShape] = this.jetSmashLimit;
            SoundController.instance.playAreaSoundInstance("MetalSmashMedium",this.chairBody);
            if(this.firing)
            {
                this.firing = false;
                this.jetMC.inner.turbine.stop();
                this.jetMC.flames.visible = false;
                this.jetSound.fadeOut(0.2);
                this.jetSound = null;
            }
            this.eject();
        }
        
        internal function wheelSmash(param1:Number, param2:b2Vec2) : void
        {
            trace("wheel impulse " + param1);
            trace("wheel angle " + Math.atan2(param2.y,param2.x));
            this.bigWheelMC.gotoAndStop(2);
            this.bigWheelMC["inner"].visible = true;
            delete contactImpulseDict[this.bigWheelShape];
            _session.contactListener.deleteListener(ContactListener.RESULT,this.bigWheelShape);
            _session.contactListener.deleteListener(ContactListener.ADD,this.bigWheelShape);
            _session.contactListener.deleteListener(ContactListener.REMOVE,this.bigWheelShape);
            var _loc3_:b2Shape = this.bigWheelBody.GetShapeList();
            this.bigWheelBody.DestroyShape(_loc3_);
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
                _loc4_.filter.categoryBits = 1025;
            }
            var _loc5_:Number = Math.atan2(param2.y,param2.x);
            var _loc6_:Number = _loc5_ - this.bigWheelBody.GetAngle();
            this.bigWheelMC["inner"].rotation = _loc6_ * oneEightyOverPI;
            _loc4_.SetAsOrientedBox(15 / character_scale,50 / character_scale,new b2Vec2(0,0),_loc6_);
            this.bigWheelBody.CreateShape(_loc4_);
            this.wheelCurrentSpeed = 0;
        }
        
        internal function fueltankSmash(param1:Number) : void
        {
            var _loc12_:b2Shape = null;
            var _loc13_:b2Body = null;
            var _loc14_:b2Vec2 = null;
            var _loc15_:b2Vec2 = null;
            var _loc16_:Number = NaN;
            var _loc17_:Number = NaN;
            var _loc18_:Number = NaN;
            var _loc19_:Number = NaN;
            var _loc20_:Number = NaN;
            trace("fuel impulse " + param1);
            delete contactImpulseDict[this.fueltankShape];
            _session.contactListener.deleteListener(ContactListener.RESULT,this.fueltankShape);
            _session.contactListener.deleteListener(ContactListener.ADD,this.fueltankShape);
            var _loc2_:MovieClip = new Explosion();
            _loc2_.x = this.fueltankMC.x;
            _loc2_.y = this.fueltankMC.y;
            _loc2_.scaleX = _loc2_.scaleY = 0.5;
            var _loc3_:Sprite = session.containerSprite;
            _loc3_.addChildAt(_loc2_,_loc3_.getChildIndex(lowerArm1MC));
            var _loc4_:Array = new Array();
            var _loc5_:Number = 2;
            var _loc6_:b2AABB = new b2AABB();
            var _loc7_:b2Vec2 = this.fueltankBody.GetWorldCenter();
            _loc6_.lowerBound.Set(_loc7_.x - _loc5_,_loc7_.y - _loc5_);
            _loc6_.upperBound.Set(_loc7_.x + _loc5_,_loc7_.y + _loc5_);
            var _loc8_:b2World = session.m_world;
            var _loc9_:int = _loc8_.Query(_loc6_,_loc4_,30);
            trace("tot intersects " + _loc9_);
            var _loc10_:* = 10;
            var _loc11_:int = 0;
            while(_loc11_ < _loc4_.length)
            {
                _loc12_ = _loc4_[_loc11_];
                _loc13_ = _loc12_.GetBody();
                if(!_loc13_.IsStatic())
                {
                    _loc14_ = _loc13_.GetWorldCenter();
                    _loc15_ = new b2Vec2(_loc14_.x - _loc7_.x,_loc14_.y - _loc7_.y);
                    _loc16_ = _loc15_.Length();
                    _loc16_ = Math.min(_loc5_,_loc16_);
                    _loc17_ = 1 - _loc16_ / _loc5_;
                    _loc18_ = Math.atan2(_loc15_.y,_loc15_.x);
                    _loc19_ = Math.cos(_loc18_) * _loc17_ * _loc10_;
                    _loc20_ = Math.sin(_loc18_) * _loc17_ * _loc10_;
                    _loc13_.ApplyImpulse(new b2Vec2(_loc19_,_loc20_),_loc14_);
                }
                _loc11_++;
            }
            this.fueltankMC.visible = false;
            session.particleController.createPointBurst("jetshards",_loc7_.x * m_physScale,_loc7_.y * m_physScale,5,50,50,_loc3_.getChildIndex(this.fueltankMC));
            _loc8_.DestroyBody(this.fueltankBody);
            SoundController.instance.playAreaSoundInstance("MineExplosion",this.fueltankBody);
        }
        
        internal function jetSmash(param1:Number) : void
        {
            trace("jet impulse " + param1);
            delete contactImpulseDict[this.jetShape];
            _session.contactListener.deleteListener(ContactListener.RESULT,this.jetShape);
            _session.contactListener.deleteListener(ContactListener.ADD,this.jetShape);
            var _loc2_:b2Vec2 = this.jetBody.GetWorldCenter();
            this.jetMC.visible = false;
            session.particleController.createPointBurst("jetshards",_loc2_.x * m_physScale,_loc2_.y * m_physScale,5,50,50,session.containerSprite.getChildIndex(this.jetMC));
            session.m_world.DestroyBody(this.jetBody);
            SoundController.instance.playAreaSoundInstance("MetalSmashLight",this.jetBody);
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
        
        override internal function hipBreak1(param1:Number, param2:Boolean = true) : void
        {
            super.hipBreak1(param1,param2);
            if(this.chairLeg1)
            {
                session.m_world.DestroyJoint(this.chairLeg1);
                this.chairLeg1 = null;
            }
        }
        
        override internal function hipBreak2(param1:Number, param2:Boolean = true) : void
        {
            super.hipBreak2(param1,param2);
            if(this.chairLeg2)
            {
                session.m_world.DestroyJoint(this.chairLeg2);
                this.chairLeg2 = null;
            }
        }
        
        internal function seatPose() : void
        {
            setJoint(neckJoint,0.5,2);
            setJoint(hipJoint1,0.5,5);
            setJoint(hipJoint2,0.5,5);
            setJoint(kneeJoint1,1,10);
            setJoint(kneeJoint2,1,10);
            setJoint(shoulderJoint1,3,20);
            setJoint(shoulderJoint2,3,20);
            setJoint(elbowJoint1,1.4,15);
            setJoint(elbowJoint2,1.4,15);
        }
        
        internal function wheelPoseLeft() : void
        {
            setJoint(neckJoint,0.5,2);
            setJoint(hipJoint1,3.5,2);
            setJoint(hipJoint2,1.5,2);
            setJoint(kneeJoint1,0,10);
            setJoint(kneeJoint2,0,10);
            setJoint(shoulderJoint1,-0.5,20);
            setJoint(shoulderJoint2,1,20);
            setJoint(elbowJoint1,3,15);
            setJoint(elbowJoint2,3,15);
        }
        
        internal function wheelPoseRight() : void
        {
            setJoint(neckJoint,0.5,2);
            setJoint(hipJoint1,1.5,2);
            setJoint(hipJoint2,3.5,2);
            setJoint(kneeJoint1,0,10);
            setJoint(kneeJoint2,0,10);
            setJoint(shoulderJoint1,1,20);
            setJoint(shoulderJoint2,-0.5,20);
            setJoint(elbowJoint1,3,15);
            setJoint(elbowJoint2,3,15);
        }
    }
}

