package com.totaljerkface.game.character
{
    import Box2D.Collision.Shapes.*;
    import Box2D.Common.Math.b2Vec2;
    import Box2D.Dynamics.*;
    import Box2D.Dynamics.Joints.*;
    import com.totaljerkface.game.*;
    import com.totaljerkface.game.events.ContactEvent;
    import com.totaljerkface.game.sound.SoundController;
    import flash.display.*;
    import flash.events.*;
    
    public class IMDaughter extends CharacterB2D
    {
        internal var mom:IrresponsibleMom;
        
        internal var ejected:Boolean;
        
        internal var detached:Boolean;
        
        internal var detachLimit:Number = 400;
        
        internal var maxTorque:Number = 20;
        
        internal var frameSmashLimit:Number = 50;
        
        private var wheelMaxSpeed:Number = 27.7;
        
        private var wheelCurrentSpeed:Number;
        
        private var wheelNewSpeed:Number;
        
        private var accelStep:Number = 1.385;
        
        internal var frameBody:b2Body;
        
        internal var wheelBody:b2Body;
        
        internal var gearBody:b2Body;
        
        internal var frameShape:b2Shape;
        
        internal var seatShape:b2Shape;
        
        internal var midShape:b2Shape;
        
        internal var endShape:b2Shape;
        
        internal var handleShape:b2Shape;
        
        internal var wheelShape:b2Shape;
        
        internal var frameMC:MovieClip;
        
        internal var wheelMC:MovieClip;
        
        internal var gearMC:MovieClip;
        
        internal var forkMC:MovieClip;
        
        internal var brokenFrameMC:MovieClip;
        
        internal var seatMC:MovieClip;
        
        internal var wheelJoint:b2RevoluteJoint;
        
        internal var framePelvis:b2RevoluteJoint;
        
        internal var frameHand1:b2RevoluteJoint;
        
        internal var frameHand2:b2RevoluteJoint;
        
        internal var gearFoot1:b2RevoluteJoint;
        
        internal var gearFoot2:b2RevoluteJoint;
        
        internal var frameGear:b2RevoluteJoint;
        
        internal var connectingJoint:b2RevoluteJoint;
        
        internal var gearJoint:b2GearJoint;
        
        internal var extraFilter:b2FilterData;
        
        public function IMDaughter(param1:Number, param2:Number, param3:DisplayObject, param4:Session, param5:int = -2, param6:String = "kid", param7:IrresponsibleMom = null)
        {
            super(param1,param2,param3,param4,param5,param6);
            shapeRefScale = 50;
            this.mom = param7;
        }
        
        override internal function leftPressedActions() : void
        {
            if(this.ejected)
            {
                currentPose = 1;
            }
        }
        
        override internal function rightPressedActions() : void
        {
            if(this.ejected)
            {
                currentPose = 2;
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
                if(!this.wheelJoint.IsMotorEnabled())
                {
                    this.wheelJoint.EnableMotor(true);
                }
                this.wheelCurrentSpeed = this.wheelJoint.GetJointSpeed();
                if(this.wheelCurrentSpeed < 0)
                {
                    this.wheelNewSpeed = 0;
                }
                else
                {
                    this.wheelNewSpeed = this.wheelCurrentSpeed < this.wheelMaxSpeed ? this.wheelCurrentSpeed + this.accelStep : this.wheelCurrentSpeed;
                }
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
                if(this.wheelCurrentSpeed > 0)
                {
                    this.wheelNewSpeed = 0;
                }
                else
                {
                    this.wheelNewSpeed = this.wheelCurrentSpeed > -this.wheelMaxSpeed ? this.wheelCurrentSpeed - this.accelStep : this.wheelCurrentSpeed;
                }
                this.wheelJoint.SetMotorSpeed(this.wheelNewSpeed);
            }
        }
        
        override internal function upAndDownActions() : void
        {
            if(this.wheelJoint.IsMotorEnabled())
            {
                this.wheelJoint.EnableMotor(false);
            }
            if(this.ejected)
            {
                if(_currentPose == 3 || _currentPose == 4)
                {
                    currentPose = 0;
                }
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
                if(!this.wheelJoint.IsMotorEnabled())
                {
                    this.wheelJoint.EnableMotor(true);
                }
                this.wheelJoint.SetMotorSpeed(0);
            }
        }
        
        override internal function spaceNullActions() : void
        {
            if(this.ejected)
            {
                releaseGrip();
            }
        }
        
        override internal function zPressedActions() : void
        {
            this.eject();
        }
        
        override internal function ctrlPressedActions() : void
        {
            this.eject();
        }
        
        override public function paint() : void
        {
            var _loc1_:b2Vec2 = null;
            super.paint();
            _loc1_ = this.wheelBody.GetWorldCenter();
            this.wheelMC.x = _loc1_.x * m_physScale;
            this.wheelMC.y = _loc1_.y * m_physScale;
            this.wheelMC.inner.rotation = this.wheelBody.GetAngle() * oneEightyOverPI % 360;
        }
        
        override internal function createFilters() : void
        {
            super.createFilters();
            this.extraFilter = new b2FilterData();
            this.extraFilter.groupIndex = groupID;
            this.extraFilter.categoryBits = 260;
        }
        
        override public function reset() : void
        {
            super.reset();
            this.ejected = false;
            this.detached = false;
        }
        
        override public function die() : void
        {
            super.die();
        }
        
        override internal function createDictionaries() : void
        {
            super.createDictionaries();
            contactImpulseDict[this.frameShape] = this.frameSmashLimit;
            contactAddSounds[this.wheelShape] = "TireHit1";
            contactAddSounds[this.frameShape] = "BikeHit3";
            contactAddSounds[this.midShape] = "BikeHit2";
            contactAddSounds[this.handleShape] = "BikeHit1";
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
            _loc4_.density = 2;
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
                _loc9_ = shapeGuide["seatVert" + [_loc6_ + 1]];
                _loc4_.vertices[_loc6_] = new b2Vec2(_startX + _loc9_.x / character_scale,_startY + _loc9_.y / character_scale);
                _loc6_++;
            }
            this.seatShape = this.frameBody.CreateShape(_loc4_);
            _session.contactListener.registerListener(ContactListener.RESULT,this.seatShape,this.contactFrameResultHandler);
            _loc4_.filter = zeroFilter;
            _loc6_ = 0;
            while(_loc6_ < 3)
            {
                _loc9_ = shapeGuide["frameVert" + [_loc6_ + 1]];
                _loc4_.vertices[_loc6_] = new b2Vec2(_startX + _loc9_.x / character_scale,_startY + _loc9_.y / character_scale);
                _loc6_++;
            }
            this.frameShape = this.frameBody.CreateShape(_loc4_);
            _session.contactListener.registerListener(ContactListener.RESULT,this.frameShape,this.contactFrameResultHandler);
            _session.contactListener.registerListener(ContactListener.ADD,this.frameShape,contactAddHandler);
            _loc6_ = 0;
            while(_loc6_ < 3)
            {
                _loc9_ = shapeGuide["handleVert" + [_loc6_ + 1]];
                _loc4_.vertices[_loc6_] = new b2Vec2(_startX + _loc9_.x / character_scale,_startY + _loc9_.y / character_scale);
                _loc6_++;
            }
            this.handleShape = this.frameBody.CreateShape(_loc4_);
            _session.contactListener.registerListener(ContactListener.RESULT,this.handleShape,this.contactFrameResultHandler);
            _session.contactListener.registerListener(ContactListener.ADD,this.handleShape,contactAddHandler);
            _loc4_.vertexCount = 4;
            _loc6_ = 0;
            while(_loc6_ < 4)
            {
                _loc9_ = shapeGuide["midVert" + [_loc6_ + 1]];
                _loc4_.vertices[_loc6_] = new b2Vec2(_startX + _loc9_.x / character_scale,_startY + _loc9_.y / character_scale);
                _loc6_++;
            }
            this.midShape = this.frameBody.CreateShape(_loc4_);
            _session.contactListener.registerListener(ContactListener.RESULT,this.midShape,this.contactFrameResultHandler);
            _session.contactListener.registerListener(ContactListener.ADD,this.midShape,contactAddHandler);
            _loc6_ = 0;
            while(_loc6_ < 4)
            {
                _loc9_ = shapeGuide["endVert" + [_loc6_ + 1]];
                _loc4_.vertices[_loc6_] = new b2Vec2(_startX + _loc9_.x / character_scale,_startY + _loc9_.y / character_scale);
                _loc6_++;
            }
            this.endShape = this.frameBody.CreateShape(_loc4_);
            _session.contactListener.registerListener(ContactListener.RESULT,this.endShape,this.contactFrameResultHandler);
            this.frameBody.SetMassFromShapes();
            paintVector.push(this.frameBody);
            var _loc7_:Sprite = shapeGuide["wheelShape"];
            _loc2_.position.Set(_startX + _loc7_.x / character_scale,_startY + _loc7_.y / character_scale);
            _loc2_.angle = _loc7_.rotation / oneEightyOverPI;
            _loc5_.radius = _loc7_.width / 2 / character_scale;
            this.wheelBody = _session.m_world.CreateBody(_loc2_);
            this.wheelShape = this.wheelBody.CreateShape(_loc5_);
            this.wheelBody.SetMassFromShapes();
            _session.contactListener.registerListener(ContactListener.ADD,this.wheelShape,contactAddHandler);
            _loc7_ = shapeGuide["gearShape"];
            _loc3_.position.Set(_startX + _loc7_.x / character_scale,_startY + _loc7_.y / character_scale);
            _loc3_.angle = _loc7_.rotation / oneEightyOverPI;
            _loc5_.radius = _loc7_.width / 2 / character_scale;
            this.gearBody = _session.m_world.CreateBody(_loc3_);
            this.gearBody.CreateShape(_loc5_);
            this.gearBody.SetMassFromShapes();
            paintVector.push(this.gearBody);
            var _loc8_:b2Shape = upperLeg1Body.GetShapeList();
            _loc8_.m_isSensor = true;
            _loc8_ = upperLeg2Body.GetShapeList();
            _loc8_.m_isSensor = true;
            _loc8_ = lowerLeg1Body.GetShapeList();
            _loc8_.m_isSensor = true;
            _loc8_ = lowerLeg2Body.GetShapeList();
            _loc8_.m_isSensor = true;
            this.endShape.m_isSensor = true;
        }
        
        override internal function createMovieClips() : void
        {
            super.createMovieClips();
            this.gearMC = sourceObject["gear"];
            var _loc4_:* = 1 / mc_scale;
            this.gearMC.scaleY = 1 / mc_scale;
            this.gearMC.scaleX = _loc4_;
            this.wheelMC = sourceObject["wheel"];
            _loc4_ = 1 / mc_scale;
            this.wheelMC.scaleY = 1 / mc_scale;
            this.wheelMC.scaleX = _loc4_;
            this.frameMC = sourceObject["frame"];
            _loc4_ = 1 / mc_scale;
            this.frameMC.scaleY = 1 / mc_scale;
            this.frameMC.scaleX = _loc4_;
            this.forkMC = sourceObject["fork"];
            _loc4_ = 1 / mc_scale;
            this.forkMC.scaleY = 1 / mc_scale;
            this.forkMC.scaleX = _loc4_;
            this.brokenFrameMC = sourceObject["brokenFrame"];
            _loc4_ = 1 / mc_scale;
            this.brokenFrameMC.scaleY = 1 / mc_scale;
            this.brokenFrameMC.scaleX = _loc4_;
            this.seatMC = sourceObject["seat"];
            _loc4_ = 1 / mc_scale;
            this.seatMC.scaleY = 1 / mc_scale;
            this.seatMC.scaleX = _loc4_;
            var _loc1_:b2Vec2 = this.frameBody.GetLocalCenter();
            _loc1_ = new b2Vec2((_startX - _loc1_.x) * character_scale,(_startY - _loc1_.y) * character_scale);
            var _loc2_:MovieClip = shapeGuide["frameVert1"];
            var _loc3_:b2Vec2 = new b2Vec2(_loc2_.x + _loc1_.x,_loc2_.y + _loc1_.y);
            this.frameMC.inner.x = _loc3_.x;
            this.frameMC.inner.y = _loc3_.y;
            this.forkMC.visible = false;
            this.brokenFrameMC.visible = false;
            this.seatMC.visible = false;
            this.frameBody.SetUserData(this.frameMC);
            this.gearBody.SetUserData(this.gearMC);
            this.wheelBody.SetUserData(this.wheelMC);
            _session.containerSprite.addChildAt(this.wheelMC,_session.containerSprite.getChildIndex(chestMC));
            _session.containerSprite.addChildAt(this.gearMC,_session.containerSprite.getChildIndex(chestMC));
            _session.containerSprite.addChildAt(this.frameMC,_session.containerSprite.getChildIndex(chestMC));
            _session.containerSprite.addChildAt(this.brokenFrameMC,_session.containerSprite.getChildIndex(chestMC));
            _session.containerSprite.addChildAt(this.seatMC,_session.containerSprite.getChildIndex(chestMC));
            _session.containerSprite.addChildAt(this.forkMC,_session.containerSprite.getChildIndex(chestMC));
        }
        
        override internal function resetMovieClips() : void
        {
            super.resetMovieClips();
            this.frameMC.visible = true;
            this.forkMC.visible = false;
            this.brokenFrameMC.visible = false;
            this.seatMC.visible = false;
            this.frameBody.SetUserData(this.frameMC);
            this.gearBody.SetUserData(this.gearMC);
            this.wheelBody.SetUserData(this.wheelMC);
        }
        
        override internal function createJoints() : void
        {
            var _loc1_:Number = NaN;
            var _loc2_:Number = NaN;
            var _loc3_:Number = NaN;
            super.createJoints();
            var _loc4_:Number = oneEightyOverPI;
            _loc1_ = lowerLeg1Body.GetAngle() - upperLeg1Body.GetAngle();
            _loc2_ = 10 / _loc4_ - _loc1_;
            _loc3_ = 150 / _loc4_ - _loc1_;
            _loc1_ = lowerLeg2Body.GetAngle() - upperLeg2Body.GetAngle();
            _loc2_ = 10 / _loc4_ - _loc1_;
            _loc3_ = 150 / _loc4_ - _loc1_;
            _loc1_ = upperLeg1Body.GetAngle() - pelvisBody.GetAngle();
            _loc2_ = -110 / _loc4_ - _loc1_;
            _loc3_ = 10 / _loc4_ - _loc1_;
            hipJoint1.SetLimits(_loc2_,_loc3_);
            _loc1_ = upperLeg2Body.GetAngle() - pelvisBody.GetAngle();
            _loc2_ = -110 / _loc4_ - _loc1_;
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
            _loc2_ = -20 / _loc4_ - _loc1_;
            _loc3_ = 0 / _loc4_ - _loc1_;
            neckJoint.SetLimits(_loc2_,_loc3_);
            var _loc5_:b2RevoluteJointDef = new b2RevoluteJointDef();
            _loc5_.maxMotorTorque = this.maxTorque;
            var _loc6_:b2Vec2 = new b2Vec2();
            var _loc7_:MovieClip = shapeGuide["wheelShape"];
            _loc6_.Set(_startX + _loc7_.x / character_scale,_startY + _loc7_.y / character_scale);
            _loc5_.Initialize(this.frameBody,this.wheelBody,_loc6_);
            this.wheelJoint = _session.m_world.CreateJoint(_loc5_) as b2RevoluteJoint;
            _loc6_.Set(pelvisBody.GetPosition().x,pelvisBody.GetPosition().y);
            _loc5_.Initialize(this.frameBody,pelvisBody,_loc6_);
            this.framePelvis = _session.m_world.CreateJoint(_loc5_) as b2RevoluteJoint;
            _loc7_ = shapeGuide["handleAnchor"];
            _loc6_.Set(_startX + _loc7_.x / character_scale,_startY + _loc7_.y / character_scale);
            _loc5_.Initialize(this.frameBody,lowerArm1Body,_loc6_);
            this.frameHand1 = _session.m_world.CreateJoint(_loc5_) as b2RevoluteJoint;
            _loc5_.Initialize(this.frameBody,lowerArm2Body,_loc6_);
            this.frameHand2 = _session.m_world.CreateJoint(_loc5_) as b2RevoluteJoint;
            _loc7_ = shapeGuide["gearShape"];
            _loc6_.Set(_startX + _loc7_.x / character_scale,_startY + _loc7_.y / character_scale);
            _loc5_.Initialize(this.frameBody,this.gearBody,_loc6_);
            this.frameGear = _session.m_world.CreateJoint(_loc5_) as b2RevoluteJoint;
            var _loc8_:b2GearJointDef = new b2GearJointDef();
            _loc8_.body1 = this.wheelBody;
            _loc8_.body2 = this.gearBody;
            _loc8_.joint1 = this.wheelJoint;
            _loc8_.joint2 = this.frameGear;
            this.gearJoint = _session.m_world.CreateJoint(_loc8_) as b2GearJoint;
            this.gearJoint.m_ratio *= -1;
            _loc7_ = shapeGuide["gearAnchor1"];
            _loc6_.Set(_startX + _loc7_.x / character_scale,_startY + _loc7_.y / character_scale);
            _loc5_.Initialize(this.gearBody,lowerLeg1Body,_loc6_);
            this.gearFoot1 = _session.m_world.CreateJoint(_loc5_) as b2RevoluteJoint;
            _loc7_ = shapeGuide["gearAnchor2"];
            _loc6_.Set(_startX + _loc7_.x / character_scale,_startY + _loc7_.y / character_scale);
            _loc5_.Initialize(this.gearBody,lowerLeg2Body,_loc6_);
            this.gearFoot2 = _session.m_world.CreateJoint(_loc5_) as b2RevoluteJoint;
            _loc7_ = shapeGuide["connectAnchor"];
            _loc6_.Set(_startX + _loc7_.x / character_scale,_startY + _loc7_.y / character_scale);
            _loc5_.Initialize(this.mom.frameBody,this.frameBody,_loc6_);
            _loc5_.enableLimit = true;
            _loc5_.lowerAngle = -35 / _loc4_;
            _loc5_.upperAngle = 35 / _loc4_;
            this.connectingJoint = _session.m_world.CreateJoint(_loc5_) as b2RevoluteJoint;
        }
        
        protected function contactFrameResultHandler(param1:ContactEvent) : void
        {
            var _loc2_:Number = param1.impulse;
            if(_loc2_ > contactImpulseDict[this.frameShape])
            {
                if(contactResultBuffer[this.frameShape])
                {
                    if(_loc2_ > contactResultBuffer[this.frameShape].impulse)
                    {
                        contactResultBuffer[this.frameShape] = param1;
                    }
                }
                else
                {
                    contactResultBuffer[this.frameShape] = param1;
                }
            }
        }
        
        override protected function handleContactResults() : void
        {
            var _loc1_:ContactEvent = null;
            super.handleContactResults();
            if(contactResultBuffer[this.frameShape])
            {
                _loc1_ = contactResultBuffer[this.frameShape];
                this.frameSmash(_loc1_.impulse,_loc1_.normal);
                delete contactResultBuffer[this.frameShape];
                delete contactAddBuffer[this.frameShape];
                delete contactAddBuffer[this.midShape];
                delete contactAddBuffer[this.handleShape];
            }
            if(contactResultBuffer[this.wheelShape])
            {
                _loc1_ = contactResultBuffer[this.wheelShape];
                delete contactResultBuffer[this.wheelShape];
                delete contactAddBuffer[this.wheelShape];
            }
        }
        
        override public function checkJoints() : void
        {
            super.checkJoints();
            if(!this.detached)
            {
                checkRevJoint(this.connectingJoint,this.detachLimit,this.detachFrame);
            }
        }
        
        internal function detachFrame(param1:Number) : void
        {
            trace("detach rear frame " + param1);
            if(this.detached)
            {
                return;
            }
            this.connectingJoint.broken = true;
            this.detached = true;
            _session.m_world.DestroyJoint(this.connectingJoint);
            this.refilterShit(head1Body.GetShapeList());
            this.refilterShit(pelvisBody.GetShapeList());
            this.refilterShit(chestBody.GetShapeList());
            this.refilterShit(upperArm1Body.GetShapeList());
            this.refilterShit(upperArm2Body.GetShapeList());
            this.refilterShit(lowerArm1Body.GetShapeList());
            this.refilterShit(lowerArm2Body.GetShapeList());
            this.endShape.m_isSensor = false;
            _session.m_world.Refilter(this.endShape);
            SoundController.instance.playAreaSoundInstance("StrapSnap1",this.frameBody);
        }
        
        override internal function eject() : void
        {
            if(this.ejected)
            {
                return;
            }
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
            if(this.gearFoot1)
            {
                _loc1_.DestroyJoint(this.gearFoot1);
                this.gearFoot1 = null;
            }
            if(this.gearFoot2)
            {
                _loc1_.DestroyJoint(this.gearFoot2);
                this.gearFoot2 = null;
            }
            this.wheelShape.SetFilterData(zeroFilter);
            _loc1_.Refilter(this.wheelShape);
            this.seatShape.SetFilterData(zeroFilter);
            _loc1_.Refilter(this.seatShape);
            this.frameShape.SetFilterData(zeroFilter);
            _loc1_.Refilter(this.frameShape);
            this.midShape.SetFilterData(zeroFilter);
            _loc1_.Refilter(this.midShape);
            this.handleShape.SetFilterData(zeroFilter);
            _loc1_.Refilter(this.handleShape);
            this.refilterShit(head1Body.GetShapeList());
            this.refilterShit(pelvisBody.GetShapeList());
            this.refilterShit(chestBody.GetShapeList());
            this.refilterShit(upperArm1Body.GetShapeList());
            this.refilterShit(upperArm2Body.GetShapeList());
            this.refilterShit(lowerArm1Body.GetShapeList());
            this.refilterShit(lowerArm2Body.GetShapeList());
            this.refilterShit(upperLeg1Body.GetShapeList());
            this.refilterShit(upperLeg2Body.GetShapeList());
            this.refilterShit(lowerLeg1Body.GetShapeList());
            this.refilterShit(lowerLeg2Body.GetShapeList());
            this.wheelJoint.EnableMotor(false);
        }
        
        internal function refilterShit(param1:b2Shape) : void
        {
            param1.m_isSensor = false;
            if(param1.m_filter.maskBits == defaultFilter.maskBits)
            {
                param1.m_filter = this.extraFilter;
            }
            _session.m_world.Refilter(param1);
        }
        
        override public function set dead(param1:Boolean) : void
        {
            if(_dead == param1)
            {
                return;
            }
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
            }
        }
        
        internal function checkEject() : void
        {
            if(!this.frameHand1 && !this.frameHand2 && !this.gearFoot1 && !this.gearFoot2)
            {
                this.eject();
            }
        }
        
        internal function frameSmash(param1:Number, param2:b2Vec2) : void
        {
            var _loc11_:Sprite = null;
            trace("daughter frame impulse " + param1);
            delete contactImpulseDict[this.frameShape];
            var _loc3_:ContactListener = _session.contactListener;
            _loc3_.deleteListener(ContactListener.RESULT,this.frameShape);
            _loc3_.deleteListener(ContactListener.RESULT,this.midShape);
            _loc3_.deleteListener(ContactListener.RESULT,this.handleShape);
            _loc3_.deleteListener(ContactListener.RESULT,this.seatShape);
            _loc3_.deleteListener(ContactListener.RESULT,this.endShape);
            _loc3_.deleteListener(ContactListener.ADD,this.frameShape);
            _loc3_.deleteListener(ContactListener.ADD,this.midShape);
            _loc3_.deleteListener(ContactListener.ADD,this.handleShape);
            _loc3_.deleteListener(ContactListener.ADD,this.wheelShape);
            _loc3_.deleteListener(ContactListener.REMOVE,this.wheelShape);
            this.eject();
            this.detached = true;
            this.forkMC.visible = true;
            this.brokenFrameMC.visible = true;
            this.seatMC.visible = true;
            this.frameMC.visible = false;
            _session.m_world.DestroyJoint(this.wheelJoint);
            _session.m_world.DestroyJoint(this.gearJoint);
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
            while(_loc12_ < 3)
            {
                _loc11_ = shapeGuide["broken2Vert" + [_loc12_ + 1]];
                _loc7_.vertices[_loc12_] = new b2Vec2(_startX + _loc11_.x / character_scale,_startY + _loc11_.y / character_scale);
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
            while(_loc12_ < 4)
            {
                _loc11_ = shapeGuide["brokenVert" + [_loc12_ + 1]];
                _loc7_.vertices[_loc12_] = new b2Vec2(_startX + _loc11_.x / character_scale,_startY + _loc11_.y / character_scale);
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
            while(_loc12_ < 3)
            {
                _loc11_ = shapeGuide["seatVert" + [_loc12_ + 1]];
                _loc7_.vertices[_loc12_] = new b2Vec2(_startX + _loc11_.x / character_scale,_startY + _loc11_.y / character_scale);
                _loc12_++;
            }
            var _loc15_:b2Shape = _loc10_.CreateShape(_loc7_);
            _loc10_.SetMassFromShapes();
            _loc10_.SetLinearVelocity(this.frameBody.GetLinearVelocity());
            _loc10_.SetAngularVelocity(this.frameBody.GetAngularVelocity());
            _loc10_.m_userData = this.seatMC;
            paintVector.push(_loc10_);
            _session.m_world.DestroyBody(this.frameBody);
            _session.contactListener.registerListener(ContactListener.ADD,_loc14_,contactAddHandler);
            contactAddSounds[_loc14_] = "BikeHit2";
            SoundController.instance.playAreaSoundInstance("BikeSmash1",_loc9_);
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
        
        override internal function kneeBreak1(param1:Number) : void
        {
            super.kneeBreak1(param1);
            if(this.ejected)
            {
                return;
            }
            if(this.gearFoot1)
            {
                _session.m_world.DestroyJoint(this.gearFoot1);
                this.gearFoot1 = null;
                if(this.gearFoot2 == null)
                {
                    _session.m_world.DestroyJoint(this.framePelvis);
                    this.framePelvis = null;
                }
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
            if(this.gearFoot2)
            {
                _session.m_world.DestroyJoint(this.gearFoot2);
                this.gearFoot2 = null;
                if(this.gearFoot1 == null)
                {
                    _session.m_world.DestroyJoint(this.framePelvis);
                    this.framePelvis = null;
                }
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
            if(!kneeJoint1.broken)
            {
                this.refilterShit(lowerLeg1Shape);
            }
            if(this.gearFoot1)
            {
                _session.m_world.DestroyJoint(this.gearFoot1);
                this.gearFoot1 = null;
                if(this.gearFoot2 == null)
                {
                    _session.m_world.DestroyJoint(this.framePelvis);
                    this.framePelvis = null;
                }
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
            if(!kneeJoint2.broken)
            {
                this.refilterShit(lowerLeg2Shape);
            }
            if(this.gearFoot2)
            {
                _session.m_world.DestroyJoint(this.gearFoot2);
                this.gearFoot2 = null;
                if(this.gearFoot1 == null)
                {
                    _session.m_world.DestroyJoint(this.framePelvis);
                    this.framePelvis = null;
                }
            }
            this.checkEject();
        }
    }
}

