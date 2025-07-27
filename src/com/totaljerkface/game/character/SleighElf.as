package com.totaljerkface.game.character
{
    import Box2D.Collision.Shapes.*;
    import Box2D.Collision.b2ContactPoint;
    import Box2D.Common.Math.b2Vec2;
    import Box2D.Dynamics.*;
    import Box2D.Dynamics.Joints.*;
    import com.totaljerkface.game.*;
    import com.totaljerkface.game.sound.SoundController;
    import flash.display.*;
    import flash.events.*;
    
    public class SleighElf extends CharacterB2D
    {
        internal var santa:SantaClaus;
        
        internal const gravityDisplacement:Number = -0.3333333333333333;
        
        protected var wheelCurrentSpeed:Number;
        
        protected var wheelNewSpeed:Number;
        
        protected var wheelMaxSpeed:Number;
        
        protected var accelStep:Number;
        
        protected var wheelMultiplier:Number;
        
        protected var verticalOffset:Number;
        
        protected var stemBody:b2Body;
        
        protected var wheelBody:b2Body;
        
        protected var wheelShape:b2Shape;
        
        protected var wheelContacts:int = 0;
        
        protected var sleighStemJoint:b2PrismaticJoint;
        
        protected var stemWheelJoint:b2RevoluteJoint;
        
        protected var stemChestJoint:b2RevoluteJoint;
        
        protected var wheelFoot1Joint:b2RevoluteJoint;
        
        protected var wheelFoot2Joint:b2RevoluteJoint;
        
        internal var legsOk:Boolean = true;
        
        internal var headAttached:Boolean = true;
        
        internal var chestAttached:Boolean = true;
        
        internal var strappedIn:Boolean = true;
        
        internal var ejected:Boolean;
        
        internal var extraFilter:b2FilterData;
        
        internal var antiGravArray:Array;
        
        protected var minCos:Number = 0.9396;
        
        protected var sign:Boolean;
        
        public function SleighElf(param1:Number, param2:Number, param3:DisplayObject, param4:Session, param5:int = -2, param6:String = "Elf1", param7:SantaClaus = null, param8:Number = 50)
        {
            super(param1,param2,param3,param4,param5,param6);
            shapeRefScale = 50;
            this.santa = param7;
            this.verticalOffset = param8;
        }
        
        override internal function leftPressedActions() : void
        {
            var _loc1_:Number = NaN;
            var _loc2_:Number = NaN;
            var _loc3_:Number = NaN;
            var _loc4_:Number = NaN;
            var _loc5_:b2Vec2 = null;
            if(this.ejected)
            {
                currentPose = 1;
            }
            else if(this.legsOk)
            {
                _loc1_ = this.stemBody.GetAngle();
                _loc2_ = 1;
                _loc3_ = Math.cos(_loc1_) * _loc2_;
                _loc4_ = Math.sin(_loc1_) * _loc2_;
                _loc5_ = this.stemBody.GetLocalCenter();
            }
        }
        
        override internal function rightPressedActions() : void
        {
            var _loc1_:Number = NaN;
            var _loc2_:Number = NaN;
            var _loc3_:Number = NaN;
            var _loc4_:Number = NaN;
            var _loc5_:b2Vec2 = null;
            if(this.ejected)
            {
                currentPose = 2;
            }
            else if(this.legsOk)
            {
                _loc1_ = this.stemBody.GetAngle();
                _loc2_ = 1;
                _loc3_ = Math.cos(_loc1_) * _loc2_;
                _loc4_ = Math.sin(_loc1_) * _loc2_;
                _loc5_ = this.stemBody.GetLocalCenter();
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
            else if(this.legsOk)
            {
                if(!this.stemWheelJoint.IsMotorEnabled())
                {
                    this.stemWheelJoint.EnableMotor(true);
                }
                this.wheelCurrentSpeed = this.stemWheelJoint.GetJointSpeed();
                this.wheelNewSpeed = this.wheelCurrentSpeed < this.wheelMaxSpeed ? this.wheelCurrentSpeed + this.accelStep : this.wheelCurrentSpeed;
                this.stemWheelJoint.SetMotorSpeed(this.wheelNewSpeed);
                currentPose = 5;
            }
        }
        
        override internal function downPressedActions() : void
        {
            if(this.ejected)
            {
                currentPose = 4;
            }
            else if(this.legsOk)
            {
                if(!this.stemWheelJoint.IsMotorEnabled())
                {
                    this.stemWheelJoint.EnableMotor(true);
                }
                this.wheelCurrentSpeed = this.stemWheelJoint.GetJointSpeed();
                this.wheelNewSpeed = this.wheelCurrentSpeed > -this.wheelMaxSpeed ? this.wheelCurrentSpeed - this.accelStep : this.wheelCurrentSpeed;
                this.stemWheelJoint.SetMotorSpeed(this.wheelNewSpeed);
                currentPose = 6;
            }
        }
        
        override internal function upAndDownActions() : void
        {
            if(this.ejected)
            {
                if(_currentPose == 3 || _currentPose == 4)
                {
                    currentPose = 0;
                }
            }
            else if(this.legsOk)
            {
                if(this.stemWheelJoint.IsMotorEnabled())
                {
                    this.stemWheelJoint.EnableMotor(false);
                }
                currentPose = 0;
            }
        }
        
        override internal function spacePressedActions() : void
        {
            if(this.ejected)
            {
                startGrab();
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
            if(this.santa.dead)
            {
                this.eject();
            }
        }
        
        override public function actions() : void
        {
            var _loc1_:Number = NaN;
            var _loc2_:Number = NaN;
            var _loc3_:int = 0;
            super.actions();
            if(this.wheelContacts > 0)
            {
                if(Math.abs(this.wheelBody.m_angularVelocity) > 5)
                {
                    _loc1_ = this.wheelBody.GetAngle();
                    _loc2_ = Math.cos(_loc1_);
                    if(!this.sign)
                    {
                        if(_loc2_ > this.minCos)
                        {
                            this.sign = true;
                            if(this.wheelFoot2Joint)
                            {
                                _loc3_ = Math.ceil(Math.random() * 5) * 2;
                                SoundController.instance.playAreaSoundInstance("Step" + _loc3_,this.wheelBody);
                            }
                        }
                    }
                    else if(_loc2_ < -this.minCos)
                    {
                        this.sign = false;
                        if(this.wheelFoot1Joint)
                        {
                            _loc3_ = Math.ceil(Math.random() * 5) * 2 - 1;
                            SoundController.instance.playAreaSoundInstance("Step" + _loc3_,this.wheelBody);
                        }
                    }
                }
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
                    this.runForwardPose();
                    break;
                case 6:
                    this.runBackwardPose();
                    break;
                case 7:
                    this.armsDownPose();
                    break;
                case 8:
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
            this.legsOk = true;
            this.sign = true;
            this.wheelContacts = 0;
            this.headAttached = true;
            this.chestAttached = true;
            this.strappedIn = true;
        }
        
        override public function die() : void
        {
            super.die();
        }
        
        override public function paint() : void
        {
            var _loc1_:Number = NaN;
            var _loc2_:b2Vec2 = null;
            var _loc3_:b2Vec2 = null;
            var _loc4_:b2Vec2 = null;
            var _loc5_:Number = NaN;
            var _loc6_:Number = NaN;
            var _loc7_:Number = NaN;
            super.paint();
            _loc1_ = Math.abs(this.wheelBody.GetAngularVelocity()) / 5;
            _loc1_ = Math.max(_loc1_,0);
            _loc1_ = Math.min(_loc1_,1);
            _loc1_ = 1 - _loc1_;
            if(this.wheelFoot1Joint)
            {
                _loc2_ = lowerLeg1Body.GetWorldCenter();
                _loc3_ = this.stemBody.GetWorldPoint(new b2Vec2(0.115,0.5702));
                _loc4_ = new b2Vec2(_loc2_.x - _loc3_.x,_loc2_.y - _loc3_.y);
                _loc5_ = Number(lowerLeg1Body.GetAngle());
                _loc6_ = this.stemBody.GetAngle() + 0.305;
                _loc7_ = _loc5_ - _loc6_;
                _loc3_ = new b2Vec2(_loc2_.x - _loc4_.x * _loc1_,_loc2_.y - _loc4_.y * _loc1_);
                lowerLeg1MC.x = _loc3_.x * m_physScale;
                lowerLeg1MC.y = _loc3_.y * m_physScale;
                lowerLeg1MC.rotation = (_loc5_ - _loc7_ * _loc1_) * oneEightyOverPI % 360;
                _loc2_ = upperLeg1Body.GetWorldCenter();
                _loc3_ = this.stemBody.GetWorldPoint(new b2Vec2(0.1553,0.1994));
                _loc4_ = new b2Vec2(_loc2_.x - _loc3_.x,_loc2_.y - _loc3_.y);
                _loc5_ = Number(upperLeg1Body.GetAngle());
                _loc6_ = this.stemBody.GetAngle() - 0.1952;
                _loc7_ = _loc5_ - _loc6_;
                _loc3_ = new b2Vec2(_loc2_.x - _loc4_.x * _loc1_,_loc2_.y - _loc4_.y * _loc1_);
                upperLeg1MC.x = _loc3_.x * m_physScale;
                upperLeg1MC.y = _loc3_.y * m_physScale;
                upperLeg1MC.rotation = (_loc5_ - _loc7_ * _loc1_) * oneEightyOverPI % 360;
            }
            if(this.wheelFoot2Joint)
            {
                _loc2_ = lowerLeg2Body.GetWorldCenter();
                _loc3_ = this.stemBody.GetWorldPoint(new b2Vec2(0.115,0.5702));
                _loc4_ = new b2Vec2(_loc2_.x - _loc3_.x,_loc2_.y - _loc3_.y);
                _loc5_ = Number(lowerLeg2Body.GetAngle());
                _loc6_ = this.stemBody.GetAngle() + 0.305;
                _loc7_ = _loc5_ - _loc6_;
                _loc3_ = new b2Vec2(_loc2_.x - _loc4_.x * _loc1_,_loc2_.y - _loc4_.y * _loc1_);
                lowerLeg2MC.x = _loc3_.x * m_physScale;
                lowerLeg2MC.y = _loc3_.y * m_physScale;
                lowerLeg2MC.rotation = (_loc5_ - _loc7_ * _loc1_) * oneEightyOverPI % 360;
                _loc2_ = upperLeg2Body.GetWorldCenter();
                _loc3_ = this.stemBody.GetWorldPoint(new b2Vec2(0.1553,0.1994));
                _loc4_ = new b2Vec2(_loc2_.x - _loc3_.x,_loc2_.y - _loc3_.y);
                _loc5_ = Number(upperLeg2Body.GetAngle());
                _loc6_ = this.stemBody.GetAngle() - 0.1952;
                _loc7_ = _loc5_ - _loc6_;
                _loc3_ = new b2Vec2(_loc2_.x - _loc4_.x * _loc1_,_loc2_.y - _loc4_.y * _loc1_);
                upperLeg2MC.x = _loc3_.x * m_physScale;
                upperLeg2MC.y = _loc3_.y * m_physScale;
                upperLeg2MC.rotation = (_loc5_ - _loc7_ * _loc1_) * oneEightyOverPI % 360;
            }
        }
        
        override internal function createBodies() : void
        {
            super.createBodies();
            _session.contactListener.deleteListener(ContactListener.RESULT,lowerLeg1Shape);
            _session.contactListener.deleteListener(ContactListener.RESULT,lowerLeg2Shape);
            var _loc1_:b2PolygonDef = new b2PolygonDef();
            var _loc2_:b2CircleDef = new b2CircleDef();
            var _loc3_:b2BodyDef = new b2BodyDef();
            var _loc4_:b2BodyDef = new b2BodyDef();
            _loc1_ = new b2PolygonDef();
            _loc2_ = new b2CircleDef();
            _loc1_.density = 4;
            _loc1_.friction = 0.3;
            _loc1_.restitution = 0.3;
            _loc1_.filter.categoryBits = 0;
            _loc1_.filter.maskBits = 0;
            _loc2_.density = 6;
            _loc2_.friction = 1;
            _loc2_.restitution = 0.1;
            _loc2_.filter.categoryBits = 62464;
            _loc2_.filter.maskBits = 520;
            _loc2_.filter.groupIndex = groupID;
            var _loc5_:MovieClip = shapeGuide["stem"];
            _loc3_.position.Set(_startX + _loc5_.x / character_scale,_startY + _loc5_.y / character_scale);
            _loc3_.angle = _loc5_.rotation / oneEightyOverPI;
            _loc1_.SetAsBox(_loc5_.scaleX * shapeRefScale / character_scale,_loc5_.scaleY * shapeRefScale / character_scale);
            this.stemBody = _session.m_world.CreateBody(_loc3_);
            this.stemBody.CreateShape(_loc1_);
            this.stemBody.SetMassFromShapes();
            _loc5_ = shapeGuide["wheel"];
            _loc4_.position.Set(_startX + _loc5_.x / character_scale,_startY + _loc5_.y / character_scale);
            _loc4_.angle = _loc5_.rotation / oneEightyOverPI;
            _loc2_.radius = _loc5_.width / 2 / character_scale;
            this.wheelBody = _session.m_world.CreateBody(_loc4_);
            this.wheelShape = this.wheelBody.CreateShape(_loc2_);
            this.wheelBody.SetMassFromShapes();
            _session.contactListener.registerListener(ContactListener.ADD,this.wheelShape,this.wheelContactAdd);
            _session.contactListener.registerListener(ContactListener.REMOVE,this.wheelShape,this.wheelContactRemove);
            this.wheelMultiplier = this.santa.wheelRadius / (_loc5_.width * 0.5);
            this.wheelMaxSpeed = this.santa.wheelMaxSpeed * this.wheelMultiplier;
            this.accelStep = this.santa.accelStep * this.wheelMultiplier;
            this.antiGravArray = new Array();
            this.antiGravArray.push(head1Body);
            this.antiGravArray.push(chestBody);
            this.antiGravArray.push(pelvisBody);
            this.antiGravArray.push(upperArm1Body);
            this.antiGravArray.push(upperArm2Body);
            this.antiGravArray.push(lowerArm1Body);
            this.antiGravArray.push(lowerArm2Body);
            this.antiGravArray.push(upperLeg1Body);
            this.antiGravArray.push(upperLeg2Body);
            this.antiGravArray.push(lowerLeg1Body);
            this.antiGravArray.push(lowerLeg2Body);
            this.antiGravArray.push(this.stemBody);
            this.antiGravArray.push(this.wheelBody);
        }
        
        override internal function createMovieClips() : void
        {
            super.createMovieClips();
            _session.containerSprite.addChildAt(chestMC,_session.containerSprite.getChildIndex(lowerLeg1MC));
        }
        
        override internal function createJoints() : void
        {
            var _loc1_:Number = NaN;
            var _loc2_:Number = NaN;
            var _loc3_:Number = NaN;
            super.createJoints();
            var _loc4_:Number = oneEightyOverPI;
            _loc1_ = lowerArm1Body.GetAngle() - upperArm1Body.GetAngle();
            _loc2_ = -90 / _loc4_ - _loc1_;
            _loc3_ = 0 / _loc4_ - _loc1_;
            elbowJoint1.SetLimits(_loc2_,_loc3_);
            _loc1_ = lowerArm2Body.GetAngle() - upperArm2Body.GetAngle();
            _loc2_ = -90 / _loc4_ - _loc1_;
            _loc3_ = 0 / _loc4_ - _loc1_;
            elbowJoint2.SetLimits(_loc2_,_loc3_);
            _loc1_ = shoulderJoint1.m_body2.GetAngle() - shoulderJoint1.m_body1.GetAngle();
            _loc2_ = -170 / _loc4_ - _loc1_;
            _loc3_ = 0 / _loc4_ - _loc1_;
            shoulderJoint1.SetLimits(_loc2_,_loc3_);
            _loc1_ = shoulderJoint2.m_body2.GetAngle() - shoulderJoint2.m_body1.GetAngle();
            _loc2_ = -170 / _loc4_ - _loc1_;
            _loc3_ = 0 / _loc4_ - _loc1_;
            shoulderJoint2.SetLimits(_loc2_,_loc3_);
            _loc1_ = head1Body.GetAngle() - chestBody.GetAngle();
            _loc2_ = -10 / _loc4_ - _loc1_;
            _loc3_ = 0 / _loc4_ - _loc1_;
            neckJoint.SetLimits(_loc2_,_loc3_);
            var _loc5_:b2PrismaticJointDef = new b2PrismaticJointDef();
            var _loc6_:b2RevoluteJointDef = new b2RevoluteJointDef();
            var _loc7_:b2Vec2 = new b2Vec2();
            _loc7_.Set(this.stemBody.GetPosition().x,this.stemBody.GetPosition().y);
            _loc5_.Initialize(this.santa.sleighBody,this.stemBody,_loc7_,new b2Vec2(0,1));
            _loc5_.enableLimit = true;
            _loc5_.upperTranslation = this.verticalOffset / m_physScale;
            _loc5_.lowerTranslation = -this.verticalOffset / m_physScale;
            this.sleighStemJoint = _session.m_world.CreateJoint(_loc5_) as b2PrismaticJoint;
            _loc6_.maxMotorTorque = this.santa.maxTorque;
            _loc7_.Set(this.wheelBody.GetPosition().x,this.wheelBody.GetPosition().y);
            _loc6_.Initialize(this.stemBody,this.wheelBody,_loc7_);
            this.stemWheelJoint = _session.m_world.CreateJoint(_loc6_) as b2RevoluteJoint;
            _loc6_.maxMotorTorque = 0;
            var _loc8_:MovieClip = shapeGuide["foot1Anchor"];
            _loc7_.Set(_startX + _loc8_.x / character_scale,_startY + _loc8_.y / character_scale);
            _loc6_.Initialize(this.wheelBody,lowerLeg1Body,_loc7_);
            this.wheelFoot1Joint = _session.m_world.CreateJoint(_loc6_) as b2RevoluteJoint;
            _loc8_ = shapeGuide["foot2Anchor"];
            _loc7_.Set(_startX + _loc8_.x / character_scale,_startY + _loc8_.y / character_scale);
            _loc6_.Initialize(this.wheelBody,lowerLeg2Body,_loc7_);
            this.wheelFoot2Joint = _session.m_world.CreateJoint(_loc6_) as b2RevoluteJoint;
            _loc7_.Set(chestBody.GetPosition().x,chestBody.GetPosition().y);
            _loc6_.Initialize(this.stemBody,chestBody,_loc7_);
            _loc6_.enableLimit = true;
            _loc6_.lowerAngle = 0;
            _loc6_.upperAngle = 20 / _loc4_;
            this.stemChestJoint = _session.m_world.CreateJoint(_loc6_) as b2RevoluteJoint;
        }
        
        override internal function eject() : void
        {
            if(this.ejected)
            {
                return;
            }
            this.ejected = true;
            if(_session.version > 1.51)
            {
                resetJointLimits();
            }
            this.disableRunning();
            this.santa.elfHeadRemove(this,false);
            this.santa.elfChestRemove(this,false);
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
                this.santa.mourn(this);
                this.disableRunning();
            }
        }
        
        protected function wheelContactAdd(param1:b2ContactPoint) : void
        {
            if(param1.shape2.m_isSensor)
            {
                return;
            }
            this.wheelContacts += 1;
        }
        
        protected function wheelContactRemove(param1:b2ContactPoint) : void
        {
            if(param1.shape2.m_isSensor)
            {
                return;
            }
            --this.wheelContacts;
        }
        
        override internal function headSmash1(param1:Number) : void
        {
            super.headSmash1(param1);
            var _loc2_:int = int(paintVector.length);
            var _loc3_:int = _loc2_ - 5;
            while(_loc3_ < _loc2_)
            {
                this.antiGravArray.push(paintVector[_loc3_]);
                _loc3_++;
            }
            if(this.ejected)
            {
                return;
            }
            this.santa.elfHeadRemove(this,true);
        }
        
        override internal function chestSmash(param1:Number) : void
        {
            super.chestSmash(param1);
            var _loc2_:int = int(paintVector.length);
            var _loc3_:int = _loc2_ - 5;
            while(_loc3_ < _loc2_)
            {
                this.antiGravArray.push(paintVector[_loc3_]);
                _loc3_++;
            }
            if(this.ejected)
            {
                return;
            }
            this.santa.elfChestRemove(this,true);
        }
        
        override internal function pelvisSmash(param1:Number) : void
        {
            super.pelvisSmash(param1);
            var _loc2_:int = int(paintVector.length);
            var _loc3_:int = _loc2_ - 3;
            while(_loc3_ < _loc2_)
            {
                this.antiGravArray.push(paintVector[_loc3_]);
                _loc3_++;
            }
        }
        
        override internal function torsoBreak(param1:Number, param2:Boolean = true, param3:Boolean = true) : void
        {
            super.torsoBreak(param1,param2,param3);
            this.disableRunning();
        }
        
        override internal function kneeBreak1(param1:Number) : void
        {
            super.kneeBreak1(param1);
            if(this.ejected)
            {
                return;
            }
            if(this.wheelFoot1Joint)
            {
                _session.m_world.DestroyJoint(this.wheelFoot1Joint);
                this.wheelFoot1Joint = null;
                _session.contactListener.registerListener(ContactListener.RESULT,lowerLeg1Shape,contactResultHandler);
                this.checkLegsOk();
            }
        }
        
        override internal function kneeBreak2(param1:Number) : void
        {
            super.kneeBreak2(param1);
            if(this.ejected)
            {
                return;
            }
            if(this.wheelFoot2Joint)
            {
                _session.m_world.DestroyJoint(this.wheelFoot2Joint);
                this.wheelFoot2Joint = null;
                _session.contactListener.registerListener(ContactListener.RESULT,lowerLeg2Shape,contactResultHandler);
                this.checkLegsOk();
            }
        }
        
        override internal function shoulderBreak1(param1:Number, param2:Boolean = true) : void
        {
            super.shoulderBreak1(param1,param2);
            if(upperArm3Body)
            {
                this.antiGravArray.push(upperArm3Body);
            }
        }
        
        override internal function shoulderBreak2(param1:Number, param2:Boolean = true) : void
        {
            super.shoulderBreak2(param1,param2);
            if(upperArm4Body)
            {
                this.antiGravArray.push(upperArm4Body);
            }
        }
        
        override internal function hipBreak1(param1:Number, param2:Boolean = true) : void
        {
            super.hipBreak1(param1,param2);
            if(upperLeg3Body)
            {
                this.antiGravArray.push(upperLeg3Body);
            }
            if(this.ejected)
            {
                return;
            }
            if(this.wheelFoot1Joint)
            {
                _session.m_world.DestroyJoint(this.wheelFoot1Joint);
                this.wheelFoot1Joint = null;
                _session.contactListener.registerListener(ContactListener.RESULT,lowerLeg1Shape,contactResultHandler);
                this.checkLegsOk();
            }
        }
        
        override internal function hipBreak2(param1:Number, param2:Boolean = true) : void
        {
            super.hipBreak2(param1,param2);
            if(upperLeg4Body)
            {
                this.antiGravArray.push(upperLeg4Body);
            }
            if(this.ejected)
            {
                return;
            }
            if(this.wheelFoot2Joint)
            {
                _session.m_world.DestroyJoint(this.wheelFoot2Joint);
                this.wheelFoot2Joint = null;
                _session.contactListener.registerListener(ContactListener.RESULT,lowerLeg2Shape,contactResultHandler);
                this.checkLegsOk();
            }
        }
        
        override internal function footSmash1(param1:Number) : void
        {
            super.footSmash1(param1);
            this.antiGravArray.push(foot1Body);
        }
        
        override internal function footSmash2(param1:Number) : void
        {
            super.footSmash2(param1);
            this.antiGravArray.push(foot2Body);
        }
        
        internal function disableRunning() : void
        {
            if(this.wheelFoot1Joint)
            {
                _session.m_world.DestroyJoint(this.wheelFoot1Joint);
                this.wheelFoot1Joint = null;
                _session.contactListener.registerListener(ContactListener.RESULT,lowerLeg1Shape,contactResultHandler);
            }
            if(this.wheelFoot2Joint)
            {
                _session.m_world.DestroyJoint(this.wheelFoot2Joint);
                this.wheelFoot2Joint = null;
                _session.contactListener.registerListener(ContactListener.RESULT,lowerLeg2Shape,contactResultHandler);
            }
            this.checkLegsOk();
        }
        
        protected function checkLegsOk() : void
        {
            if(this.wheelFoot1Joint == null && this.wheelFoot2Joint == null)
            {
                this.wheelContacts = 0;
                _session.contactListener.deleteListener(ContactListener.ADD,this.wheelShape);
                _session.contactListener.deleteListener(ContactListener.REMOVE,this.wheelShape);
                _session.m_world.DestroyBody(this.wheelBody);
                this.stemWheelJoint = null;
                _session.m_world.DestroyBody(this.stemBody);
                this.sleighStemJoint = null;
                this.stemChestJoint = null;
                this.legsOk = false;
            }
            currentPose = 0;
        }
        
        protected function runForwardPose() : void
        {
            var _loc1_:Number = NaN;
            var _loc2_:Number = NaN;
            if(this.wheelFoot1Joint)
            {
                _loc1_ = kneeJoint1.GetJointAngle() - kneeJoint1.m_lowerAngle;
                _loc2_ = _loc1_ / (150 / oneEightyOverPI);
                setJoint(elbowJoint2,1 * _loc2_,15);
                _loc1_ = hipJoint1.GetJointAngle() - hipJoint1.m_lowerAngle;
                _loc2_ = _loc1_ / (160 / oneEightyOverPI);
                setJoint(shoulderJoint2,3 * _loc2_,15);
            }
            if(this.wheelFoot2Joint)
            {
                _loc1_ = kneeJoint2.GetJointAngle() - kneeJoint2.m_lowerAngle;
                _loc2_ = _loc1_ / (150 / oneEightyOverPI);
                setJoint(elbowJoint1,1 * _loc2_,15);
                _loc1_ = hipJoint2.GetJointAngle() - hipJoint2.m_lowerAngle;
                _loc2_ = _loc1_ / (160 / oneEightyOverPI);
                setJoint(shoulderJoint1,3 * _loc2_,15);
            }
        }
        
        protected function runBackwardPose() : void
        {
            var _loc1_:Number = NaN;
            var _loc2_:Number = NaN;
            if(this.wheelFoot1Joint)
            {
                _loc1_ = kneeJoint1.GetJointAngle() - kneeJoint1.m_lowerAngle;
                _loc2_ = _loc1_ / (150 / oneEightyOverPI);
                setJoint(elbowJoint2,2.6 * _loc2_,15);
                _loc1_ = hipJoint1.GetJointAngle() - hipJoint1.m_lowerAngle;
                _loc2_ = _loc1_ / (160 / oneEightyOverPI);
                setJoint(shoulderJoint2,4.18 * _loc2_,15);
            }
            if(this.wheelFoot2Joint)
            {
                _loc1_ = kneeJoint2.GetJointAngle() - kneeJoint2.m_lowerAngle;
                _loc2_ = _loc1_ / (150 / oneEightyOverPI);
                setJoint(elbowJoint1,2.6 * _loc2_,15);
                _loc1_ = hipJoint2.GetJointAngle() - hipJoint2.m_lowerAngle;
                _loc2_ = _loc1_ / (160 / oneEightyOverPI);
                setJoint(shoulderJoint1,4.18 * _loc2_,15);
            }
        }
        
        protected function armsDownPose() : void
        {
            setJoint(elbowJoint1,2.4,5,2);
            setJoint(elbowJoint2,2.4,5,2);
            setJoint(shoulderJoint1,3,10,2);
            setJoint(shoulderJoint2,3,10,2);
        }
    }
}

