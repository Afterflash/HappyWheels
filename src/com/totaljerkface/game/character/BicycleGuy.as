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
    import com.totaljerkface.game.sound.AreaSoundLoop;
    import com.totaljerkface.game.sound.SoundController;
    import flash.display.*;
    import flash.events.*;

    public class BicycleGuy extends CharacterB2D
    {
        internal var ejected:Boolean;

        private var wheelMaxSpeed:Number = 20;

        private var wheelCurrentSpeed:Number;

        private var wheelNewSpeed:Number;

        private var wheelContacts:Number = 0;

        private var backContacts:Number = 0;

        private var frontContacts:Number = 0;

        private var accelStep:Number = 1;

        private var maxTorque:Number = 20;

        private var impulseMagnitude:Number = 3;

        private var impulseOffset:Number = 1;

        private var maxSpinAV:Number = 5;

        private var wheelLoop1:AreaSoundLoop;

        private var wheelLoop2:AreaSoundLoop;

        private var wheelLoop3:AreaSoundLoop;

        internal var frameSmashLimit:Number = 200;

        internal var wheelSmashLimit:Number = 200;

        internal var frameBody:b2Body;

        internal var backWheelBody:b2Body;

        internal var frontWheelBody:b2Body;

        internal var gearBody:b2Body;

        internal var backWheelShape:b2Shape;

        internal var frontWheelShape:b2Shape;

        internal var frameShape1:b2Shape;

        internal var frameShape2:b2Shape;

        internal var frameShape3:b2Shape;

        internal var frameMC:MovieClip;

        internal var backWheelMC:MovieClip;

        internal var frontWheelMC:MovieClip;

        internal var gearMC:MovieClip;

        internal var forkMC:MovieClip;

        internal var brokenFrameMC:MovieClip;

        internal var seatMC:MovieClip;

        internal var backWheelJoint:b2RevoluteJoint;

        internal var frontWheelJoint:b2RevoluteJoint;

        internal var framePelvis:b2RevoluteJoint;

        internal var frameHand1:b2RevoluteJoint;

        internal var frameHand2:b2RevoluteJoint;

        internal var gearFoot1:b2RevoluteJoint;

        internal var gearFoot2:b2RevoluteJoint;

        internal var frameGear:b2RevoluteJoint;

        internal var gearJoint:b2GearJoint;

        public function BicycleGuy(param1:Number, param2:Number, param3:DisplayObject, param4:Session, param5:int = -1, param6:String = "Char3")
        {
            super(param1, param2, param3, param4, param5, param6);
        }

        override internal function leftPressedActions():void
        {
            var _loc1_:Number = NaN;
            var _loc2_:Number = NaN;
            var _loc3_:Number = NaN;
            var _loc4_:Number = NaN;
            var _loc5_:Number = NaN;
            var _loc6_:b2Vec2 = null;
            if (this.ejected)
            {
                currentPose = 1;
            }
            else
            {
                _loc1_ = this.frameBody.GetAngle();
                _loc2_ = this.frameBody.GetAngularVelocity();
                _loc3_ = (_loc2_ + this.maxSpinAV) / this.maxSpinAV;
                if (_loc3_ < 0)
                {
                    _loc3_ = 0;
                }
                if (_loc3_ > 1)
                {
                    _loc3_ = 1;
                }
                _loc4_ = Math.cos(_loc1_) * this.impulseMagnitude * _loc3_;
                _loc5_ = Math.sin(_loc1_) * this.impulseMagnitude * _loc3_;
                _loc6_ = this.frameBody.GetLocalCenter();
                this.frameBody.ApplyImpulse(new b2Vec2(_loc5_, -_loc4_), this.frameBody.GetWorldPoint(new b2Vec2(_loc6_.x + this.impulseOffset, _loc6_.y)));
                this.leanBackPose();
            }
        }

        override internal function rightPressedActions():void
        {
            var _loc1_:Number = NaN;
            var _loc2_:Number = NaN;
            var _loc3_:Number = NaN;
            var _loc4_:Number = NaN;
            var _loc5_:Number = NaN;
            var _loc6_:Number = NaN;
            var _loc7_:b2Vec2 = null;
            if (this.ejected)
            {
                currentPose = 2;
            }
            else
            {
                _loc1_ = this.frameBody.GetAngle();
                _loc2_ = this.frameBody.GetAngularVelocity();
                _loc3_ = (_loc2_ - this.maxSpinAV) / -this.maxSpinAV;
                if (_loc3_ < 0)
                {
                    _loc3_ = 0;
                }
                if (_loc3_ > 1)
                {
                    _loc3_ = 1;
                }
                _loc4_ = 1;
                _loc5_ = Math.cos(_loc1_) * this.impulseMagnitude * _loc3_;
                _loc6_ = Math.sin(_loc1_) * this.impulseMagnitude * _loc3_;
                _loc7_ = this.frameBody.GetLocalCenter();
                this.frameBody.ApplyImpulse(new b2Vec2(_loc6_, -_loc5_), this.frameBody.GetWorldPoint(new b2Vec2(_loc7_.x - this.impulseOffset, _loc7_.y)));
                this.leanForwardPose();
            }
        }

        override internal function leftAndRightActions():void
        {
            if (this.ejected)
            {
                if (_currentPose == 1 || _currentPose == 2)
                {
                    currentPose = 0;
                }
            }
        }

        override internal function upPressedActions():void
        {
            if (this.ejected)
            {
                currentPose = 3;
            }
            else
            {
                if (!this.backWheelJoint.IsMotorEnabled())
                {
                    this.backWheelJoint.EnableMotor(true);
                    this.frontWheelJoint.EnableMotor(true);
                }
                this.wheelCurrentSpeed = this.backWheelJoint.GetJointSpeed();
                if (this.wheelCurrentSpeed < 0)
                {
                    this.wheelNewSpeed = 0;
                }
                else
                {
                    this.wheelNewSpeed = this.wheelCurrentSpeed < this.wheelMaxSpeed ? this.wheelCurrentSpeed + this.accelStep : this.wheelCurrentSpeed;
                }
                this.backWheelJoint.SetMotorSpeed(this.wheelNewSpeed);
                this.frontWheelJoint.SetMotorSpeed(this.wheelNewSpeed);
            }
        }

        override internal function downPressedActions():void
        {
            if (this.ejected)
            {
                currentPose = 4;
            }
            else
            {
                if (!this.backWheelJoint.IsMotorEnabled())
                {
                    this.backWheelJoint.EnableMotor(true);
                    this.frontWheelJoint.EnableMotor(true);
                }
                this.wheelCurrentSpeed = this.backWheelJoint.GetJointSpeed();
                if (this.wheelCurrentSpeed > 0)
                {
                    this.wheelNewSpeed = 0;
                }
                else
                {
                    this.wheelNewSpeed = this.wheelCurrentSpeed > -this.wheelMaxSpeed ? this.wheelCurrentSpeed - this.accelStep : this.wheelCurrentSpeed;
                }
                this.backWheelJoint.SetMotorSpeed(this.wheelNewSpeed);
                this.frontWheelJoint.SetMotorSpeed(this.wheelNewSpeed);
            }
        }

        override internal function upAndDownActions():void
        {
            if (this.backWheelJoint.IsMotorEnabled())
            {
                this.backWheelJoint.EnableMotor(false);
                this.frontWheelJoint.EnableMotor(false);
            }
            if (this.ejected)
            {
                if (_currentPose == 3 || _currentPose == 4)
                {
                    currentPose = 0;
                }
            }
        }

        override internal function spacePressedActions():void
        {
            if (this.ejected)
            {
                startGrab();
            }
            else
            {
                if (!this.backWheelJoint.IsMotorEnabled())
                {
                    this.backWheelJoint.EnableMotor(true);
                    this.frontWheelJoint.EnableMotor(true);
                }
                this.backWheelJoint.SetMotorSpeed(0);
                this.frontWheelJoint.SetMotorSpeed(0);
            }
        }

        override internal function spaceNullActions():void
        {
            if (this.ejected)
            {
                releaseGrip();
            }
        }

        override internal function zPressedActions():void
        {
            this.eject();
        }

        override public function actions():void
        {
            var _loc1_:Number = NaN;
            if (this.wheelContacts > 0)
            {
                _loc1_ = Math.abs(this.backWheelBody.GetAngularVelocity());
                if (_loc1_ > 18)
                {
                    if (!this.wheelLoop3)
                    {
                        this.wheelLoop3 = SoundController.instance.playAreaSoundLoop("BikeLoop3", this.backWheelBody, 0);
                        this.wheelLoop3.fadeIn(0.2);
                    }
                    if (this.wheelLoop1)
                    {
                        this.wheelLoop1.fadeOut(0.2);
                        this.wheelLoop1 = null;
                    }
                    if (this.wheelLoop2)
                    {
                        this.wheelLoop2.fadeOut(0.2);
                        this.wheelLoop2 = null;
                    }
                }
                else if (_loc1_ > 9)
                {
                    if (!this.wheelLoop2)
                    {
                        this.wheelLoop2 = SoundController.instance.playAreaSoundLoop("BikeLoop2", this.backWheelBody, 0);
                        this.wheelLoop2.fadeIn(0.2);
                    }
                    if (this.wheelLoop1)
                    {
                        this.wheelLoop1.fadeOut(0.2);
                        this.wheelLoop1 = null;
                    }
                    if (this.wheelLoop3)
                    {
                        this.wheelLoop3.fadeOut(0.2);
                        this.wheelLoop3 = null;
                    }
                }
                else if (_loc1_ > 1)
                {
                    if (!this.wheelLoop1)
                    {
                        this.wheelLoop1 = SoundController.instance.playAreaSoundLoop("BikeLoop1", this.backWheelBody, 0);
                        this.wheelLoop1.fadeIn(0.2);
                    }
                    if (this.wheelLoop2)
                    {
                        this.wheelLoop2.fadeOut(0.2);
                        this.wheelLoop2 = null;
                    }
                    if (this.wheelLoop3)
                    {
                        this.wheelLoop3.fadeOut(0.2);
                        this.wheelLoop3 = null;
                    }
                }
                else
                {
                    if (this.wheelLoop1)
                    {
                        this.wheelLoop1.fadeOut(0.2);
                        this.wheelLoop1 = null;
                    }
                    if (this.wheelLoop2)
                    {
                        this.wheelLoop2.fadeOut(0.2);
                        this.wheelLoop2 = null;
                    }
                    if (this.wheelLoop3)
                    {
                        this.wheelLoop3.fadeOut(0.2);
                        this.wheelLoop3 = null;
                    }
                }
            }
            else
            {
                if (this.wheelLoop1)
                {
                    this.wheelLoop1.fadeOut(0.2);
                    this.wheelLoop1 = null;
                }
                if (this.wheelLoop2)
                {
                    this.wheelLoop2.fadeOut(0.2);
                    this.wheelLoop2 = null;
                }
                if (this.wheelLoop3)
                {
                    this.wheelLoop3.fadeOut(0.2);
                    this.wheelLoop3 = null;
                }
            }
            super.actions();
        }

        override protected function checkPose():void
        {
            switch (_currentPose)
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

        override public function reset():void
        {
            super.reset();
            this.ejected = false;
            this.wheelContacts = 0;
            this.frontContacts = 0;
            this.backContacts = 0;
        }

        override public function paint():void
        {
            super.paint();
            var _loc1_:b2Vec2 = this.frontWheelBody.GetWorldCenter();
            this.frontWheelMC.x = _loc1_.x * m_physScale;
            this.frontWheelMC.y = _loc1_.y * m_physScale;
            this.frontWheelMC.inner.rotation = this.frontWheelBody.GetAngle() * oneEightyOverPI % 360;
            _loc1_ = this.backWheelBody.GetWorldCenter();
            this.backWheelMC.x = _loc1_.x * m_physScale;
            this.backWheelMC.y = _loc1_.y * m_physScale;
            this.backWheelMC.inner.rotation = this.backWheelBody.GetAngle() * oneEightyOverPI % 360;
        }

        override internal function createDictionaries():void
        {
            super.createDictionaries();
            contactImpulseDict[this.frameShape1] = this.frameSmashLimit;
            contactImpulseDict[this.frontWheelShape] = this.wheelSmashLimit;
            contactImpulseDict[this.backWheelShape] = this.wheelSmashLimit;
            contactAddSounds[this.backWheelShape] = "TireHit1";
            contactAddSounds[this.frontWheelShape] = "TireHit2";
            contactAddSounds[this.frameShape1] = "BikeHit3";
            contactAddSounds[this.frameShape2] = "BikeHit2";
            contactAddSounds[this.frameShape3] = "BikeHit1";
        }

        override internal function createBodies():void
        {
            var _loc10_:MovieClip = null;
            super.createBodies();
            var _loc1_:b2BodyDef = new b2BodyDef();
            var _loc2_:b2BodyDef = new b2BodyDef();
            var _loc3_:b2BodyDef = new b2BodyDef();
            var _loc4_:b2BodyDef = new b2BodyDef();
            var _loc5_:b2PolygonDef = new b2PolygonDef();
            var _loc6_:b2CircleDef = new b2CircleDef();
            _loc5_.density = 2;
            _loc5_.friction = 0.3;
            _loc5_.restitution = 0.1;
            _loc5_.filter.categoryBits = 513;
            _loc6_.density = 5;
            _loc6_.friction = 1;
            _loc6_.restitution = 0.3;
            _loc6_.filter.categoryBits = 513;
            this.frameBody = _session.m_world.CreateBody(_loc1_);
            _loc5_.vertexCount = 3;
            var _loc7_:int = 0;
            while (_loc7_ < 3)
            {
                _loc10_ = shapeGuide["seatVert" + [_loc7_ + 1]];
                _loc5_.vertices[_loc7_] = new b2Vec2(_startX + _loc10_.x / character_scale, _startY + _loc10_.y / character_scale);
                _loc7_++;
            }
            this.frameShape1 = this.frameBody.CreateShape(_loc5_);
            _session.contactListener.registerListener(ContactListener.RESULT, this.frameShape1, this.contactFrameResultHandler);
            _session.contactListener.registerListener(ContactListener.ADD, this.frameShape1, contactAddHandler);
            _loc5_.filter = zeroFilter;
            _loc5_.vertexCount = 4;
            _loc7_ = 0;
            while (_loc7_ < 4)
            {
                _loc10_ = shapeGuide["frameVert" + [_loc7_ + 1]];
                _loc5_.vertices[_loc7_] = new b2Vec2(_startX + _loc10_.x / character_scale, _startY + _loc10_.y / character_scale);
                _loc7_++;
            }
            this.frameShape2 = this.frameBody.CreateShape(_loc5_);
            _session.contactListener.registerListener(ContactListener.RESULT, this.frameShape2, this.contactFrameResultHandler);
            _session.contactListener.registerListener(ContactListener.ADD, this.frameShape2, contactAddHandler);
            _loc5_.vertexCount = 3;
            _loc7_ = 0;
            while (_loc7_ < 3)
            {
                _loc10_ = shapeGuide["forkVert" + [_loc7_ + 1]];
                _loc5_.vertices[_loc7_] = new b2Vec2(_startX + _loc10_.x / character_scale, _startY + _loc10_.y / character_scale);
                _loc7_++;
            }
            this.frameShape3 = this.frameBody.CreateShape(_loc5_);
            _session.contactListener.registerListener(ContactListener.RESULT, this.frameShape3, this.contactFrameResultHandler);
            _session.contactListener.registerListener(ContactListener.ADD, this.frameShape3, contactAddHandler);
            this.frameBody.SetMassFromShapes();
            paintVector.push(this.frameBody);
            var _loc8_:Sprite = shapeGuide["backWheelShape"];
            _loc2_.position.Set(_startX + _loc8_.x / character_scale, _startY + _loc8_.y / character_scale);
            _loc2_.angle = _loc8_.rotation / oneEightyOverPI;
            _loc6_.radius = _loc8_.width / 2 / character_scale;
            this.backWheelBody = _session.m_world.CreateBody(_loc2_);
            this.backWheelShape = this.backWheelBody.CreateShape(_loc6_);
            this.backWheelBody.SetMassFromShapes();
            _session.contactListener.registerListener(ContactListener.RESULT, this.backWheelShape, contactResultHandler);
            _session.contactListener.registerListener(ContactListener.ADD, this.backWheelShape, this.wheelContactAdd);
            _session.contactListener.registerListener(ContactListener.REMOVE, this.backWheelShape, this.wheelContactRemove);
            _loc8_ = shapeGuide["frontWheelShape"];
            _loc3_.position.Set(_startX + _loc8_.x / character_scale, _startY + _loc8_.y / character_scale);
            _loc3_.angle = _loc8_.rotation / oneEightyOverPI;
            _loc6_.radius = _loc8_.width / 2 / character_scale;
            this.frontWheelBody = _session.m_world.CreateBody(_loc3_);
            this.frontWheelShape = this.frontWheelBody.CreateShape(_loc6_);
            this.frontWheelBody.SetMassFromShapes();
            _session.contactListener.registerListener(ContactListener.RESULT, this.frontWheelShape, contactResultHandler);
            _session.contactListener.registerListener(ContactListener.ADD, this.frontWheelShape, this.wheelContactAdd);
            _session.contactListener.registerListener(ContactListener.REMOVE, this.frontWheelShape, this.wheelContactRemove);
            _loc8_ = shapeGuide["gearShape"];
            _loc4_.position.Set(_startX + _loc8_.x / character_scale, _startY + _loc8_.y / character_scale);
            _loc4_.angle = _loc8_.rotation / oneEightyOverPI;
            _loc6_.radius = _loc8_.width / 2 / character_scale;
            this.gearBody = _session.m_world.CreateBody(_loc4_);
            this.gearBody.CreateShape(_loc6_);
            this.gearBody.SetMassFromShapes();
            paintVector.push(this.gearBody);
            var _loc9_:b2Shape = upperLeg1Body.GetShapeList();
            _loc9_.m_isSensor = true;
            _loc9_ = upperLeg2Body.GetShapeList();
            _loc9_.m_isSensor = true;
            _loc9_ = lowerLeg1Body.GetShapeList();
            _loc9_.m_isSensor = true;
            _loc9_ = lowerLeg2Body.GetShapeList();
            _loc9_.m_isSensor = true;
        }

        override internal function createMovieClips():void
        {
            super.createMovieClips();
            this.frameMC = sourceObject["frame"];
            var _loc1_:* = 1 / mc_scale;
            this.frameMC.scaleY = 1 / mc_scale;
            this.frameMC.scaleX = _loc1_;
            this.backWheelMC = sourceObject["backWheel"];
            _loc1_ = 1 / mc_scale;
            this.backWheelMC.scaleY = 1 / mc_scale;
            this.backWheelMC.scaleX = _loc1_;
            this.frontWheelMC = sourceObject["frontWheel"];
            _loc1_ = 1 / mc_scale;
            this.frontWheelMC.scaleY = 1 / mc_scale;
            this.frontWheelMC.scaleX = _loc1_;
            this.gearMC = sourceObject["gear"];
            _loc1_ = 1 / mc_scale;
            this.gearMC.scaleY = 1 / mc_scale;
            this.gearMC.scaleX = _loc1_;
            this.forkMC = sourceObject["fork"];
            _loc1_ = 1 / mc_scale;
            this.forkMC.scaleY = 1 / mc_scale;
            this.forkMC.scaleX = _loc1_;
            this.brokenFrameMC = sourceObject["brokenFrame"];
            _loc1_ = 1 / mc_scale;
            this.brokenFrameMC.scaleY = 1 / mc_scale;
            this.brokenFrameMC.scaleX = _loc1_;
            this.seatMC = sourceObject["seat"];
            _loc1_ = 1 / mc_scale;
            this.seatMC.scaleY = 1 / mc_scale;
            this.seatMC.scaleX = _loc1_;
            this.frontWheelMC.gotoAndStop(1);
            this.backWheelMC.gotoAndStop(1);
            this.frontWheelMC.inner.broken.visible = false;
            this.backWheelMC.inner.broken.visible = false;
            this.forkMC.visible = false;
            this.brokenFrameMC.visible = false;
            this.seatMC.visible = false;
            this.frameBody.SetUserData(this.frameMC);
            this.backWheelBody.SetUserData(this.backWheelMC);
            this.frontWheelBody.SetUserData(this.frontWheelMC);
            this.gearBody.SetUserData(this.gearMC);
            _session.containerSprite.addChildAt(this.backWheelMC, _session.containerSprite.getChildIndex(chestMC));
            _session.containerSprite.addChildAt(this.frontWheelMC, _session.containerSprite.getChildIndex(chestMC));
            _session.containerSprite.addChildAt(this.gearMC, _session.containerSprite.getChildIndex(chestMC));
            _session.containerSprite.addChildAt(this.frameMC, _session.containerSprite.getChildIndex(chestMC));
            _session.containerSprite.addChildAt(this.brokenFrameMC, _session.containerSprite.getChildIndex(chestMC));
            _session.containerSprite.addChildAt(this.seatMC, _session.containerSprite.getChildIndex(chestMC));
            _session.containerSprite.addChildAt(this.forkMC, _session.containerSprite.getChildIndex(chestMC));
        }

        override internal function resetMovieClips():void
        {
            super.resetMovieClips();
            this.frontWheelMC.gotoAndStop(1);
            this.backWheelMC.gotoAndStop(1);
            this.frameMC.visible = true;
            this.frontWheelMC.inner.broken.visible = false;
            this.backWheelMC.inner.broken.visible = false;
            this.frontWheelMC.inner.spokes.visible = true;
            this.backWheelMC.inner.spokes.visible = true;
            this.forkMC.visible = false;
            this.brokenFrameMC.visible = false;
            this.seatMC.visible = false;
            this.frameBody.SetUserData(this.frameMC);
            this.backWheelBody.SetUserData(this.backWheelMC);
            this.frontWheelBody.SetUserData(this.frontWheelMC);
            this.gearBody.SetUserData(this.gearMC);
        }

        override internal function createJoints():void
        {
            var _loc1_:Number = NaN;
            var _loc2_:Number = NaN;
            var _loc3_:Number = NaN;
            super.createJoints();
            var _loc4_:Number = oneEightyOverPI;
            _loc1_ = upperLeg1Body.GetAngle() - pelvisBody.GetAngle();
            _loc2_ = -110 / _loc4_ - _loc1_;
            _loc3_ = 10 / _loc4_ - _loc1_;
            hipJoint1.SetLimits(_loc2_, _loc3_);
            _loc1_ = upperLeg2Body.GetAngle() - pelvisBody.GetAngle();
            _loc2_ = -110 / _loc4_ - _loc1_;
            _loc3_ = 10 / _loc4_ - _loc1_;
            hipJoint2.SetLimits(_loc2_, _loc3_);
            _loc1_ = lowerArm1Body.GetAngle() - upperArm1Body.GetAngle();
            _loc2_ = -60 / _loc4_ - _loc1_;
            _loc3_ = 0 / _loc4_ - _loc1_;
            elbowJoint1.SetLimits(_loc2_, _loc3_);
            _loc1_ = lowerArm2Body.GetAngle() - upperArm2Body.GetAngle();
            _loc2_ = -60 / _loc4_ - _loc1_;
            _loc3_ = 0 / _loc4_ - _loc1_;
            elbowJoint2.SetLimits(_loc2_, _loc3_);
            _loc1_ = head1Body.GetAngle() - chestBody.GetAngle();
            _loc2_ = -20 / _loc4_ - _loc1_;
            _loc3_ = 0 / _loc4_ - _loc1_;
            neckJoint.SetLimits(_loc2_, _loc3_);
            var _loc5_:b2RevoluteJointDef = new b2RevoluteJointDef();
            _loc5_.maxMotorTorque = this.maxTorque;
            var _loc6_:b2Vec2 = new b2Vec2();
            var _loc7_:MovieClip = shapeGuide["backWheelShape"];
            _loc6_.Set(_startX + _loc7_.x / character_scale, _startY + _loc7_.y / character_scale);
            _loc5_.Initialize(this.frameBody, this.backWheelBody, _loc6_);
            this.backWheelJoint = _session.m_world.CreateJoint(_loc5_) as b2RevoluteJoint;
            _loc7_ = shapeGuide["frontWheelShape"];
            _loc6_.Set(_startX + _loc7_.x / character_scale, _startY + _loc7_.y / character_scale);
            _loc5_.Initialize(this.frameBody, this.frontWheelBody, _loc6_);
            this.frontWheelJoint = _session.m_world.CreateJoint(_loc5_) as b2RevoluteJoint;
            var _loc8_:b2DistanceJointDef = new b2DistanceJointDef();
            _loc8_.Initialize(this.frameBody, pelvisBody, pelvisBody.GetPosition(), pelvisBody.GetPosition());
            _loc6_.Set(pelvisBody.GetPosition().x, pelvisBody.GetPosition().y);
            _loc5_.Initialize(this.frameBody, pelvisBody, _loc6_);
            this.framePelvis = _session.m_world.CreateJoint(_loc5_) as b2RevoluteJoint;
            _loc7_ = shapeGuide["handleAnchor"];
            _loc6_.Set(_startX + _loc7_.x / character_scale, _startY + _loc7_.y / character_scale);
            _loc5_.Initialize(this.frameBody, lowerArm1Body, _loc6_);
            this.frameHand1 = _session.m_world.CreateJoint(_loc5_) as b2RevoluteJoint;
            _loc5_.Initialize(this.frameBody, lowerArm2Body, _loc6_);
            this.frameHand2 = _session.m_world.CreateJoint(_loc5_) as b2RevoluteJoint;
            _loc7_ = shapeGuide["gearShape"];
            _loc6_.Set(_startX + _loc7_.x / character_scale, _startY + _loc7_.y / character_scale);
            _loc5_.Initialize(this.frameBody, this.gearBody, _loc6_);
            this.frameGear = _session.m_world.CreateJoint(_loc5_) as b2RevoluteJoint;
            var _loc9_:b2GearJointDef = new b2GearJointDef();
            _loc9_.body1 = this.backWheelBody;
            _loc9_.body2 = this.gearBody;
            _loc9_.joint1 = this.backWheelJoint;
            _loc9_.joint2 = this.frameGear;
            this.gearJoint = _session.m_world.CreateJoint(_loc9_) as b2GearJoint;
            this.gearJoint.m_ratio *= -1;
            _loc7_ = shapeGuide["gearAnchor1"];
            _loc6_.Set(_startX + _loc7_.x / character_scale, _startY + _loc7_.y / character_scale);
            _loc5_.Initialize(this.gearBody, lowerLeg1Body, _loc6_);
            this.gearFoot1 = _session.m_world.CreateJoint(_loc5_) as b2RevoluteJoint;
            _loc7_ = shapeGuide["gearAnchor2"];
            _loc6_.Set(_startX + _loc7_.x / character_scale, _startY + _loc7_.y / character_scale);
            _loc5_.Initialize(this.gearBody, lowerLeg2Body, _loc6_);
            this.gearFoot2 = _session.m_world.CreateJoint(_loc5_) as b2RevoluteJoint;
        }

        protected function contactFrameResultHandler(param1:ContactEvent):void
        {
            var _loc2_:Number = param1.impulse;
            if (_loc2_ > contactImpulseDict[this.frameShape1])
            {
                if (contactResultBuffer[this.frameShape1])
                {
                    if (_loc2_ > contactResultBuffer[this.frameShape1].impulse)
                    {
                        contactResultBuffer[this.frameShape1] = param1;
                    }
                }
                else
                {
                    contactResultBuffer[this.frameShape1] = param1;
                }
            }
        }

        override protected function handleContactResults():void
        {
            var _loc1_:ContactEvent = null;
            super.handleContactResults();
            if (contactResultBuffer[this.frameShape1])
            {
                _loc1_ = contactResultBuffer[this.frameShape1];
                this.frameSmash(_loc1_.impulse, _loc1_.normal);
                delete contactResultBuffer[this.frameShape1];
                delete contactAddBuffer[this.frameShape1];
                delete contactAddBuffer[this.frameShape2];
                delete contactAddBuffer[this.frameShape3];
            }
            if (contactResultBuffer[this.frontWheelShape])
            {
                _loc1_ = contactResultBuffer[this.frontWheelShape];
                this.frontWheelSmash(_loc1_.impulse, _loc1_.normal);
                delete contactResultBuffer[this.frontWheelShape];
                delete contactAddBuffer[this.frontWheelShape];
            }
            if (contactResultBuffer[this.backWheelShape])
            {
                _loc1_ = contactResultBuffer[this.backWheelShape];
                this.backWheelSmash(_loc1_.impulse, _loc1_.normal);
                delete contactResultBuffer[this.backWheelShape];
                delete contactAddBuffer[this.backWheelShape];
            }
        }

        protected function wheelContactAdd(param1:b2ContactPoint):void
        {
            if (param1.shape2.m_isSensor)
            {
                return;
            }
            if (param1.shape1 == this.frontWheelShape)
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
            if (contactAddBuffer[_loc2_])
            {
                return;
            }
            if (_loc6_ != 0 && _loc6_ < _loc3_.m_mass)
            {
                return;
            }
            var _loc7_:Number = b2Math.b2Dot(param1.velocity, param1.normal);
            _loc7_ = Math.abs(_loc7_);
            if (_loc7_ > 4)
            {
                contactAddBuffer[_loc2_] = "hit";
            }
        }

        protected function wheelContactRemove(param1:b2ContactPoint):void
        {
            if (param1.shape2.m_isSensor)
            {
                return;
            }
            if (param1.shape1 == this.frontWheelShape)
            {
                --this.frontContacts;
            }
            else
            {
                --this.backContacts;
            }
            this.wheelContacts = this.frontContacts + this.backContacts;
        }

        override internal function eject():void
        {
            if (this.ejected)
            {
                return;
            }
            this.ejected = true;
            resetJointLimits();
            var _loc1_:b2World = session.m_world;
            if (this.framePelvis)
            {
                _loc1_.DestroyJoint(this.framePelvis);
                this.framePelvis = null;
            }
            if (this.frameHand1)
            {
                _loc1_.DestroyJoint(this.frameHand1);
                this.frameHand1 = null;
            }
            if (this.frameHand2)
            {
                _loc1_.DestroyJoint(this.frameHand2);
                this.frameHand2 = null;
            }
            if (this.gearFoot1)
            {
                _loc1_.DestroyJoint(this.gearFoot1);
                this.gearFoot1 = null;
            }
            if (this.gearFoot2)
            {
                _loc1_.DestroyJoint(this.gearFoot2);
                this.gearFoot2 = null;
            }
            this.frontWheelBody.GetShapeList().SetFilterData(zeroFilter);
            this.backWheelBody.GetShapeList().SetFilterData(zeroFilter);
            _loc1_.Refilter(this.frontWheelBody.GetShapeList());
            _loc1_.Refilter(this.backWheelBody.GetShapeList());
            var _loc2_:b2Shape = this.frameBody.GetShapeList();
            while (_loc2_)
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

        override public function set dead(param1:Boolean):void
        {
            _dead = param1;
            if (_dead)
            {
                userVehicleEject();
                currentPose = 0;
                releaseGrip();
                this.backWheelJoint.EnableMotor(false);
                this.frontWheelJoint.EnableMotor(false);
                if (voiceSound)
                {
                    voiceSound.stopSound();
                    voiceSound = null;
                }
            }
        }

        internal function frameSmash(param1:Number, param2:b2Vec2):void
        {
            var _loc11_:Sprite = null;
            trace("frame impulse " + param1);
            delete contactImpulseDict[this.frameShape1];
            var _loc3_:ContactListener = _session.contactListener;
            _loc3_.deleteListener(ContactListener.RESULT, this.frameShape1);
            _loc3_.deleteListener(ContactListener.RESULT, this.frameShape2);
            _loc3_.deleteListener(ContactListener.RESULT, this.frameShape3);
            _loc3_.deleteListener(ContactListener.ADD, this.frameShape1);
            _loc3_.deleteListener(ContactListener.ADD, this.frameShape2);
            _loc3_.deleteListener(ContactListener.ADD, this.frameShape3);
            _loc3_.deleteListener(ContactListener.ADD, this.frontWheelShape);
            _loc3_.deleteListener(ContactListener.REMOVE, this.frontWheelShape);
            _loc3_.deleteListener(ContactListener.ADD, this.backWheelShape);
            _loc3_.deleteListener(ContactListener.REMOVE, this.backWheelShape);
            this.eject();
            this.frameMC.gotoAndStop(2);
            this.forkMC.visible = true;
            this.brokenFrameMC.visible = true;
            this.seatMC.visible = true;
            this.frameMC.visible = false;
            _session.m_world.DestroyJoint(this.frontWheelJoint);
            _session.m_world.DestroyJoint(this.backWheelJoint);
            if (_session.version > 1.69)
            {
                _session.m_world.DestroyJoint(this.gearJoint);
            }
            var _loc4_:b2BodyDef = new b2BodyDef();
            var _loc5_:b2BodyDef = new b2BodyDef();
            var _loc6_:b2BodyDef = new b2BodyDef();
            var _loc7_:b2PolygonDef = new b2PolygonDef();
            _loc7_.density = 2;
            _loc7_.friction = 0.3;
            _loc7_.restitution = 0.1;
            _loc7_.filter = zeroFilter;
            _loc4_.position = _loc5_.position = _loc6_.position = this.frameBody.GetPosition();
            _loc4_.angle = _loc5_.angle = _loc6_.angle = this.frameBody.GetAngle();
            var _loc8_:b2Body = _session.m_world.CreateBody(_loc4_);
            var _loc9_:b2Body = _session.m_world.CreateBody(_loc5_);
            var _loc10_:b2Body = _session.m_world.CreateBody(_loc6_);
            _loc7_.vertexCount = 3;
            var _loc12_:int = 0;
            while (_loc12_ < 3)
            {
                _loc11_ = shapeGuide["forkVert" + [_loc12_ + 1]];
                _loc7_.vertices[_loc12_] = new b2Vec2(_startX + _loc11_.x / character_scale, _startY + _loc11_.y / character_scale);
                _loc12_++;
            }
            var _loc13_:b2Shape = _loc8_.CreateShape(_loc7_);
            _loc8_.SetMassFromShapes();
            _loc8_.SetLinearVelocity(this.frameBody.GetLinearVelocity());
            _loc8_.SetAngularVelocity(this.frameBody.GetAngularVelocity());
            _loc8_.m_userData = this.forkMC;
            paintVector.push(_loc8_);
            _loc7_.vertexCount = 4;
            _loc12_ = 0;
            while (_loc12_ < 4)
            {
                _loc11_ = shapeGuide["brokenVert" + [_loc12_ + 1]];
                _loc7_.vertices[_loc12_] = new b2Vec2(_startX + _loc11_.x / character_scale, _startY + _loc11_.y / character_scale);
                _loc12_++;
            }
            var _loc14_:b2Shape = _loc9_.CreateShape(_loc7_);
            _loc9_.SetMassFromShapes();
            _loc9_.SetLinearVelocity(this.frameBody.GetLinearVelocity());
            _loc9_.SetAngularVelocity(this.frameBody.GetAngularVelocity());
            _loc9_.m_userData = this.brokenFrameMC;
            paintVector.push(_loc9_);
            _loc7_.vertexCount = 3;
            _loc12_ = 0;
            while (_loc12_ < 3)
            {
                _loc11_ = shapeGuide["seatVert" + [_loc12_ + 1]];
                _loc7_.vertices[_loc12_] = new b2Vec2(_startX + _loc11_.x / character_scale, _startY + _loc11_.y / character_scale);
                _loc12_++;
            }
            var _loc15_:b2Shape = _loc10_.CreateShape(_loc7_);
            _loc10_.SetMassFromShapes();
            _loc10_.SetLinearVelocity(this.frameBody.GetLinearVelocity());
            _loc10_.SetAngularVelocity(this.frameBody.GetAngularVelocity());
            _loc10_.m_userData = this.seatMC;
            paintVector.push(_loc10_);
            _session.m_world.DestroyBody(this.frameBody);
            _session.contactListener.registerListener(ContactListener.ADD, _loc14_, contactAddHandler);
            contactAddSounds[_loc14_] = "BikeHit2";
            SoundController.instance.playAreaSoundInstance("BikeSmash1", _loc9_);
        }

        internal function frontWheelSmash(param1:Number, param2:b2Vec2):void
        {
            trace("front wheel impulse " + param1);
            trace("wheel angle " + Math.atan2(param2.y, param2.x));
            this.frontWheelMC.gotoAndStop(2);
            this.frontWheelMC.inner.spokes.visible = false;
            this.frontWheelMC.inner.broken.visible = true;
            delete contactImpulseDict[this.frontWheelShape];
            _session.contactListener.deleteListener(ContactListener.RESULT, this.frontWheelShape);
            _session.contactListener.deleteListener(ContactListener.ADD, this.frontWheelShape);
            _session.contactListener.deleteListener(ContactListener.REMOVE, this.frontWheelShape);
            var _loc3_:b2Shape = this.frontWheelBody.GetShapeList();
            this.frontWheelBody.DestroyShape(_loc3_);
            var _loc4_:b2PolygonDef = new b2PolygonDef();
            _loc4_.density = 2;
            _loc4_.friction = 0.3;
            _loc4_.restitution = 0.1;
            if (this.ejected)
            {
                _loc4_.filter = zeroFilter;
            }
            else
            {
                _loc4_.filter.categoryBits = 513;
            }
            var _loc5_:Number = Math.atan2(param2.y, param2.x);
            var _loc6_:Number = _loc5_ - this.frontWheelBody.GetAngle();
            this.frontWheelMC.inner.broken.rotation = _loc6_ * oneEightyOverPI;
            _loc4_.SetAsOrientedBox(25 / character_scale, 50 / character_scale, new b2Vec2(0, 0), _loc6_);
            this.frontWheelBody.CreateShape(_loc4_);
            SoundController.instance.playAreaSoundInstance("BikeTireSmash1", this.frontWheelBody);
        }

        internal function backWheelSmash(param1:Number, param2:b2Vec2):void
        {
            trace("back wheel impulse " + param1);
            trace("wheel angle " + Math.atan2(param2.y, param2.x));
            this.backWheelMC.gotoAndStop(2);
            this.backWheelMC.inner.spokes.visible = false;
            this.backWheelMC.inner.broken.visible = true;
            delete contactImpulseDict[this.backWheelShape];
            _session.contactListener.deleteListener(ContactListener.RESULT, this.backWheelShape);
            _session.contactListener.deleteListener(ContactListener.ADD, this.backWheelShape);
            _session.contactListener.deleteListener(ContactListener.REMOVE, this.backWheelShape);
            var _loc3_:b2Shape = this.backWheelBody.GetShapeList();
            this.backWheelBody.DestroyShape(_loc3_);
            var _loc4_:b2PolygonDef = new b2PolygonDef();
            _loc4_.density = 2;
            _loc4_.friction = 0.3;
            _loc4_.restitution = 0.1;
            if (this.ejected)
            {
                _loc4_.filter = zeroFilter;
            }
            else
            {
                _loc4_.filter.categoryBits = 513;
            }
            var _loc5_:Number = Math.atan2(param2.y, param2.x);
            var _loc6_:Number = _loc5_ - this.backWheelBody.GetAngle();
            this.backWheelMC.inner.broken.rotation = _loc6_ * oneEightyOverPI;
            _loc4_.SetAsOrientedBox(25 / character_scale, 50 / character_scale, new b2Vec2(0, 0), _loc6_);
            this.backWheelBody.CreateShape(_loc4_);
            SoundController.instance.playAreaSoundInstance("BikeTireSmash1", this.backWheelBody);
        }

        internal function checkEject():void
        {
            if (!this.frameHand1 && !this.frameHand2 && !this.gearFoot1 && !this.gearFoot2)
            {
                this.eject();
            }
        }

        override internal function headSmash1(param1:Number):void
        {
            super.headSmash1(param1);
            this.eject();
        }

        override internal function chestSmash(param1:Number):void
        {
            super.chestSmash(param1);
            this.eject();
        }

        override internal function pelvisSmash(param1:Number):void
        {
            super.pelvisSmash(param1);
            this.eject();
        }

        override internal function torsoBreak(param1:Number, param2:Boolean = true, param3:Boolean = true):void
        {
            super.torsoBreak(param1, param2, param3);
            this.eject();
        }

        override internal function neckBreak(param1:Number, param2:Boolean = true, param3:Boolean = true):void
        {
            super.neckBreak(param1, param2, param3);
            this.eject();
        }

        override internal function elbowBreak1(param1:Number):void
        {
            super.elbowBreak1(param1);
            if (this.ejected)
            {
                return;
            }
            if (this.frameHand1)
            {
                _session.m_world.DestroyJoint(this.frameHand1);
                this.frameHand1 = null;
            }
            this.checkEject();
        }

        override internal function elbowBreak2(param1:Number):void
        {
            super.elbowBreak2(param1);
            if (this.ejected)
            {
                return;
            }
            if (this.frameHand2)
            {
                _session.m_world.DestroyJoint(this.frameHand2);
                this.frameHand2 = null;
            }
            this.checkEject();
        }

        override internal function kneeBreak1(param1:Number):void
        {
            super.kneeBreak1(param1);
            if (this.ejected)
            {
                return;
            }
            if (this.gearFoot1)
            {
                _session.m_world.DestroyJoint(this.gearFoot1);
                this.gearFoot1 = null;
            }
            this.checkEject();
        }

        override internal function kneeBreak2(param1:Number):void
        {
            super.kneeBreak2(param1);
            if (this.ejected)
            {
                return;
            }
            if (this.gearFoot2)
            {
                _session.m_world.DestroyJoint(this.gearFoot2);
                this.gearFoot2 = null;
            }
            this.checkEject();
        }

        internal function leanBackPose():void
        {
            setJoint(neckJoint, 0, 2);
            setJoint(elbowJoint1, 1.04, 15);
            setJoint(elbowJoint2, 1.04, 15);
        }

        internal function leanForwardPose():void
        {
            setJoint(neckJoint, 1, 1);
            setJoint(elbowJoint1, 0, 15);
            setJoint(elbowJoint2, 0, 15);
        }
    }
}
