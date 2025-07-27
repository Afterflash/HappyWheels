package com.totaljerkface.game.character
{
    import Box2D.Collision.*;
    import Box2D.Collision.Shapes.*;
    import Box2D.Common.Math.*;
    import Box2D.Dynamics.*;
    import Box2D.Dynamics.Joints.*;
    import com.totaljerkface.game.*;
    import com.totaljerkface.game.events.*;
    import com.totaljerkface.game.level.userspecials.FoodItem;
    import com.totaljerkface.game.level.userspecials.NPCharacter;
    import com.totaljerkface.game.particles.Emitter;
    import com.totaljerkface.game.sound.*;
    import flash.display.*;
    import flash.events.*;
    import flash.utils.Dictionary;
    
    public class LawnMowerMan extends CharacterB2D
    {
        protected var ejected:Boolean;
        
        protected var wheelMaxSpeed:Number = 15;
        
        protected var wheelCurrentSpeed:Number;
        
        protected var wheelNewSpeed:Number;
        
        protected var accelStep:Number = 3;
        
        protected var maxTorque:Number = 100000;
        
        protected var impulseLeft:Number = 2.4;
        
        protected var impulseRight:Number = 2.8;
        
        protected var impulseOffset:Number = 1;
        
        protected var maxSpinAV:Number = 3.5;
        
        protected var wheelLoop1:AreaSoundLoop;
        
        protected var wheelLoop2:AreaSoundLoop;
        
        protected var wheelLoop3:AreaSoundLoop;
        
        protected var mowerLoop:AreaSoundLoop;
        
        protected var grindLoop:AreaSoundLoop;
        
        protected var mowerImpactSound:AreaSoundInstance;
        
        protected var mowerSmashLimit:Number = 100000;
        
        protected var frontRearSmashLimit:Number = 150;
        
        protected var reAttachDistance:Number = 0.25;
        
        protected var ejectImpulse:Number = 5;
        
        protected var mowerSmashed:Boolean;
        
        protected var verticalTranslation:Number;
        
        protected var handleAnchorPoint:b2Vec2;
        
        protected var pelvisAnchorPoint:b2Vec2;
        
        protected var leg1AnchorPoint:b2Vec2;
        
        protected var leg2AnchorPoint:b2Vec2;
        
        protected var mowerPelvisJointDef:b2RevoluteJointDef;
        
        protected var mowerHand1JointDef:b2RevoluteJointDef;
        
        protected var mowerHand2JointDef:b2RevoluteJointDef;
        
        protected var mowerFoot1JointDef:b2RevoluteJointDef;
        
        protected var mowerFoot2JointDef:b2RevoluteJointDef;
        
        protected var frontShape:b2PolygonShape;
        
        protected var shaftShape:b2PolygonShape;
        
        protected var handleShape:b2PolygonShape;
        
        protected var rearShape:b2PolygonShape;
        
        protected var topShape:b2PolygonShape;
        
        protected var baseShape:b2PolygonShape;
        
        protected var bladeShape:b2PolygonShape;
        
        protected var seatShape1:b2PolygonShape;
        
        protected var seatShape2:b2PolygonShape;
        
        protected var backWheelShape:b2Shape;
        
        protected var frontWheelShape:b2Shape;
        
        protected var brokenFrontShape:b2PolygonShape;
        
        protected var brokenRearShape:b2PolygonShape;
        
        internal var mowerBody:b2Body;
        
        internal var frontShockBody:b2Body;
        
        internal var backShockBody:b2Body;
        
        internal var backWheelBody:b2Body;
        
        internal var frontWheelBody:b2Body;
        
        internal var frontBody:b2Body;
        
        internal var rearBody:b2Body;
        
        internal var shockMC:Sprite;
        
        internal var bladeCoverMC:MovieClip;
        
        internal var mowerMC:MovieClip;
        
        internal var backWheelMC:MovieClip;
        
        internal var frontWheelMC:MovieClip;
        
        protected var frontMC:Sprite;
        
        protected var rearMC:Sprite;
        
        protected var front1MC:Sprite;
        
        protected var front2MC:Sprite;
        
        protected var front3MC:Sprite;
        
        protected var front4MC:Sprite;
        
        protected var front5MC:Sprite;
        
        protected var rear1MC:Sprite;
        
        protected var rear2MC:Sprite;
        
        protected var rear3MC:Sprite;
        
        protected var rear4MC:Sprite;
        
        protected var cartMC:Sprite;
        
        protected var backShockJoint:b2PrismaticJoint;
        
        protected var frontShockJoint:b2PrismaticJoint;
        
        protected var backWheelJoint:b2RevoluteJoint;
        
        protected var frontWheelJoint:b2RevoluteJoint;
        
        protected var mowerPelvis:b2RevoluteJoint;
        
        protected var mowerHand1:b2RevoluteJoint;
        
        protected var mowerHand2:b2RevoluteJoint;
        
        protected var mowerFoot1:b2RevoluteJoint;
        
        protected var mowerFoot2:b2RevoluteJoint;
        
        protected var bladeContactArray:Array;
        
        protected var bladeShapeArray:Array;
        
        protected var bladeX:Number;
        
        protected var bladeLeftX:Number;
        
        protected var bladeRightX:Number;
        
        protected var bladeY:Number;
        
        protected var bladeCenter:b2Vec2;
        
        protected var mowerMass:Number;
        
        protected var targetBodies:Array;
        
        protected var risingBodies:Array;
        
        protected var grindSounds:Array;
        
        protected var addedJointsArray:Array;
        
        protected var clearanceShape:b2PolygonShape;
        
        protected var contactCount:Dictionary;
        
        protected var targetMaskHolder:Sprite;
        
        protected var grindingMass:Number = 0;
        
        protected var soundDelay:int = 10;
        
        protected var soundDelayCount:int = 0;
        
        protected var testSprite:Sprite;
        
        public function LawnMowerMan(param1:Number, param2:Number, param3:DisplayObject, param4:Session)
        {
            super(param1,param2,param3,param4,-1,"Char11");
            this.verticalTranslation = 20 / m_physScale;
            this.bladeContactArray = new Array();
            this.bladeShapeArray = new Array();
            this.targetBodies = new Array();
            this.risingBodies = new Array();
            this.grindSounds = new Array();
            this.addedJointsArray = new Array();
            this.contactCount = new Dictionary();
            if(param4.version > 1.4)
            {
                this.mowerSmashLimit = 200;
            }
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
                _loc1_ = this.mowerBody.GetAngle();
                _loc2_ = this.mowerBody.GetAngularVelocity();
                _loc3_ = (_loc2_ + this.maxSpinAV) / this.maxSpinAV;
                if(_loc3_ < 0)
                {
                    _loc3_ = 0;
                }
                if(_loc3_ > 1)
                {
                    _loc3_ = 1;
                }
                _loc4_ = Math.cos(_loc1_) * this.impulseLeft * _loc3_;
                _loc5_ = Math.sin(_loc1_) * this.impulseLeft * _loc3_;
                _loc6_ = this.mowerBody.GetLocalCenter();
                this.mowerBody.ApplyImpulse(new b2Vec2(_loc5_,-_loc4_),this.mowerBody.GetWorldPoint(new b2Vec2(_loc6_.x + this.impulseOffset,_loc6_.y)));
                this.mowerBody.ApplyImpulse(new b2Vec2(-_loc5_,_loc4_),this.mowerBody.GetWorldPoint(new b2Vec2(_loc6_.x - this.impulseOffset,_loc6_.y)));
                currentPose = 7;
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
                _loc1_ = this.mowerBody.GetAngle();
                _loc2_ = this.mowerBody.GetAngularVelocity();
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
                _loc5_ = Math.cos(_loc1_) * this.impulseRight * _loc3_;
                _loc6_ = Math.sin(_loc1_) * this.impulseRight * _loc3_;
                _loc7_ = this.mowerBody.GetLocalCenter();
                this.mowerBody.ApplyImpulse(new b2Vec2(-_loc6_,_loc5_),this.mowerBody.GetWorldPoint(new b2Vec2(_loc7_.x + this.impulseOffset,_loc7_.y)));
                this.mowerBody.ApplyImpulse(new b2Vec2(_loc6_,-_loc5_),this.mowerBody.GetWorldPoint(new b2Vec2(_loc7_.x - this.impulseOffset,_loc7_.y)));
                currentPose = 8;
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
                if(!this.backWheelJoint.IsMotorEnabled())
                {
                    this.backWheelJoint.EnableMotor(true);
                    this.frontWheelJoint.EnableMotor(true);
                    this.mowerLoop.fadeTo(1,0.25);
                }
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
                this.frontWheelJoint.SetMotorSpeed(this.wheelNewSpeed * 1.76);
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
                if(!this.backWheelJoint.IsMotorEnabled())
                {
                    this.backWheelJoint.EnableMotor(true);
                    this.frontWheelJoint.EnableMotor(true);
                    this.mowerLoop.fadeTo(1,0.25);
                }
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
                this.frontWheelJoint.SetMotorSpeed(this.wheelNewSpeed * 1.76);
            }
        }
        
        override internal function upAndDownActions() : void
        {
            if(this.backWheelJoint.IsMotorEnabled())
            {
                this.backWheelJoint.EnableMotor(false);
                this.frontWheelJoint.EnableMotor(false);
                if(this.mowerLoop)
                {
                    this.mowerLoop.fadeTo(0.5,0.25);
                }
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
            else if(!this.backShockJoint.IsMotorEnabled())
            {
                if(this.backShockJoint.GetUpperLimit() != this.verticalTranslation)
                {
                    this.frontShockJoint.SetMotorSpeed(2.5);
                    this.backShockJoint.SetMotorSpeed(2.5);
                    this.frontShockJoint.SetLimits(0,this.verticalTranslation);
                    this.backShockJoint.SetLimits(0,this.verticalTranslation);
                    this.frontShockJoint.EnableMotor(true);
                    this.backShockJoint.EnableMotor(true);
                    SoundController.instance.playAreaSoundInstance("SegwayJump",this.backWheelBody);
                }
            }
            else if(this.backShockJoint.GetMotorSpeed() > 0)
            {
                if(this.backShockJoint.GetJointTranslation() > this.verticalTranslation)
                {
                    this.frontShockJoint.EnableMotor(false);
                    this.backShockJoint.EnableMotor(false);
                    this.frontShockJoint.SetLimits(this.verticalTranslation - 0.01,this.verticalTranslation);
                    this.backShockJoint.SetLimits(this.verticalTranslation - 0.01,this.verticalTranslation);
                    this.frontShockJoint.SetMotorSpeed(0);
                    this.backShockJoint.SetMotorSpeed(0);
                }
            }
            else if(this.backShockJoint.GetMotorSpeed() < 0)
            {
                if(this.backShockJoint.GetJointTranslation() < 0)
                {
                    this.frontShockJoint.EnableMotor(false);
                    this.backShockJoint.EnableMotor(false);
                    this.frontShockJoint.SetLimits(0,0);
                    this.backShockJoint.SetLimits(0,0);
                    this.frontShockJoint.SetMotorSpeed(0);
                    this.backShockJoint.SetMotorSpeed(0);
                }
            }
        }
        
        override internal function spaceNullActions() : void
        {
            if(this.ejected)
            {
                releaseGrip();
            }
            else if(this.backShockJoint.IsMotorEnabled())
            {
                if(this.backShockJoint.GetMotorSpeed() > 0)
                {
                    if(this.frontShockJoint.GetJointTranslation() > this.verticalTranslation)
                    {
                        this.frontShockJoint.SetMotorSpeed(-1);
                        this.backShockJoint.SetMotorSpeed(-1);
                    }
                }
                else if(this.backShockJoint.GetMotorSpeed() < 0)
                {
                    if(this.backShockJoint.GetJointTranslation() < 0)
                    {
                        this.frontShockJoint.EnableMotor(false);
                        this.backShockJoint.EnableMotor(false);
                        this.frontShockJoint.SetLimits(0,0);
                        this.backShockJoint.SetLimits(0,0);
                        this.frontShockJoint.SetMotorSpeed(0);
                        this.backShockJoint.SetMotorSpeed(0);
                    }
                }
            }
            else if(this.backShockJoint.GetUpperLimit() != 0)
            {
                this.frontShockJoint.SetMotorSpeed(-1);
                this.backShockJoint.SetMotorSpeed(-1);
                this.frontShockJoint.SetLimits(0,this.verticalTranslation);
                this.backShockJoint.SetLimits(0,this.verticalTranslation);
                this.frontShockJoint.EnableMotor(true);
                this.backShockJoint.EnableMotor(true);
            }
        }
        
        override internal function shiftPressedActions() : void
        {
            if(this.ejected)
            {
                currentPose = 6;
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
            var _loc2_:b2Body = null;
            var _loc3_:int = 0;
            var _loc4_:Number = NaN;
            var _loc5_:b2Shape = null;
            var _loc6_:b2Body = null;
            var _loc7_:Emitter = null;
            var _loc8_:Sprite = null;
            var _loc9_:NPCharacter = null;
            var _loc10_:CharacterB2D = null;
            var _loc11_:DisplayObject = null;
            var _loc12_:b2RevoluteJoint = null;
            super.actions();
            var _loc1_:int = int(this.targetBodies.length - 1);
            while(_loc1_ > -1)
            {
                _loc2_ = this.targetBodies[_loc1_];
                _loc3_ = int(this.contactCount[_loc2_]);
                if(_loc3_ == 0)
                {
                    _loc4_ = _loc2_.GetMass();
                    this.grindingMass -= _loc4_;
                    _loc5_ = _loc2_.GetShapeList();
                    if(_loc5_.m_userData is NPCharacter)
                    {
                        _loc9_ = _loc5_.m_userData as NPCharacter;
                        _loc9_.removeBody(_loc2_);
                    }
                    else if(_loc5_.m_userData is CharacterB2D)
                    {
                        _loc10_ = _loc5_.m_userData as CharacterB2D;
                        _loc10_.removeBody(_loc2_);
                    }
                    _loc6_ = this.risingBodies[_loc1_];
                    _loc7_ = _loc6_.GetUserData();
                    _loc7_.stopSpewing();
                    session.m_world.DestroyBody(_loc2_);
                    session.m_world.DestroyBody(_loc6_);
                    _loc8_ = _loc2_.m_userData;
                    if(_loc8_.mask != null)
                    {
                        _loc11_ = _loc8_.mask;
                        _loc8_.mask = null;
                        this.targetMaskHolder.removeChild(_loc11_);
                    }
                    _loc8_.visible = false;
                    this.targetBodies.splice(_loc1_,1);
                    this.risingBodies.splice(_loc1_,1);
                    if(this.targetBodies.length == 0)
                    {
                        this.grindLoop.fadeOut(0.3);
                        this.grindLoop = null;
                    }
                }
                _loc1_--;
            }
            _loc1_ = 0;
            while(_loc1_ < this.addedJointsArray.length)
            {
                _loc12_ = this.addedJointsArray[_loc1_];
                _loc6_ = _loc12_.GetBody1();
                this.risingBodies.push(_loc6_);
                _loc2_ = _loc12_.GetBody2();
                this.targetBodies.push(_loc2_);
                _loc1_++;
            }
            this.addedJointsArray = new Array();
            if(this.mowerImpactSound)
            {
                this.soundDelayCount += 1;
                if(this.soundDelayCount >= this.soundDelay)
                {
                    this.mowerImpactSound = null;
                    this.soundDelayCount = 0;
                    this.soundDelay = Math.round(Math.random() * 20) + 5;
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
                    break;
                case 6:
                    this.lungePoseLeft();
                    break;
                case 7:
                    this.leanBackPose();
                    break;
                case 8:
                    this.leanForwardPose();
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
            this.mowerSmashed = false;
            this.bladeContactArray = new Array();
            this.bladeShapeArray = new Array();
            this.addedJointsArray = new Array();
            this.targetBodies = new Array();
            this.risingBodies = new Array();
            this.grindSounds = new Array();
            this.contactCount = new Dictionary();
            this.grindingMass = 0;
            this.soundDelayCount = 0;
            this.soundDelay = 10;
            if(session.version > 1.4)
            {
                this.mowerSmashLimit = 200;
            }
        }
        
        override public function die() : void
        {
            var _loc2_:b2Body = null;
            var _loc3_:Sprite = null;
            var _loc4_:DisplayObject = null;
            var _loc5_:DisplayObject = null;
            super.die();
            var _loc1_:int = 0;
            while(_loc1_ < this.targetBodies.length)
            {
                _loc2_ = this.targetBodies[_loc1_];
                _loc3_ = _loc2_.m_userData;
                if(_loc3_.mask != null)
                {
                    _loc4_ = _loc3_.mask;
                    _loc3_.mask = null;
                    this.targetMaskHolder.removeChild(_loc4_);
                }
                _loc3_.visible = false;
                _loc1_++;
            }
            _loc1_ = this.targetMaskHolder.numChildren - 1;
            while(_loc1_ > -1)
            {
                _loc5_ = this.targetMaskHolder.getChildAt(_loc1_);
                this.targetMaskHolder.removeChild(_loc5_);
                _loc1_--;
            }
            if(this.mowerLoop)
            {
                this.mowerLoop.stopSound();
                this.mowerLoop = null;
            }
        }
        
        override public function paint() : void
        {
            var _loc1_:b2Vec2 = null;
            var _loc2_:b2Vec2 = null;
            super.paint();
            _loc1_ = this.frontWheelBody.GetWorldCenter();
            this.frontWheelMC.x = _loc1_.x * m_physScale;
            this.frontWheelMC.y = _loc1_.y * m_physScale;
            this.frontWheelMC.inner.rotation = this.frontWheelBody.GetAngle() * (180 / Math.PI) % 360;
            _loc1_ = this.backWheelBody.GetWorldCenter();
            this.backWheelMC.x = _loc1_.x * m_physScale;
            this.backWheelMC.y = _loc1_.y * m_physScale;
            this.backWheelMC.inner.rotation = this.backWheelBody.GetAngle() * (180 / Math.PI) % 360;
            this.targetMaskHolder.x = this.bladeCoverMC.x = this.mowerMC.x;
            this.targetMaskHolder.y = this.bladeCoverMC.y = this.mowerMC.y;
            this.targetMaskHolder.rotation = this.bladeCoverMC.rotation = this.mowerMC.rotation;
            if(!this.mowerSmashed)
            {
                _loc1_ = this.frontShockJoint.GetAnchor1();
                _loc2_ = this.frontShockBody.GetWorldCenter();
                this.shockMC.graphics.clear();
                this.shockMC.graphics.lineStyle(3,1513239);
                this.shockMC.graphics.moveTo(_loc1_.x * m_physScale,_loc1_.y * m_physScale);
                this.shockMC.graphics.lineTo(_loc2_.x * m_physScale,_loc2_.y * m_physScale);
                _loc1_ = this.backShockJoint.GetAnchor1();
                _loc2_ = this.backShockBody.GetWorldCenter();
                this.shockMC.graphics.moveTo(_loc1_.x * m_physScale,_loc1_.y * m_physScale);
                this.shockMC.graphics.lineTo(_loc2_.x * m_physScale,_loc2_.y * m_physScale);
            }
        }
        
        override internal function createDictionaries() : void
        {
            super.createDictionaries();
            contactImpulseDict[this.frontShape] = this.mowerSmashLimit;
            contactAddSounds[this.backWheelShape] = "CarTire1";
            contactAddSounds[this.frontWheelShape] = "CarTire1";
            contactAddSounds[this.frontShape] = "ChairHit3";
            contactAddSounds[this.topShape] = "ChairHit2";
            contactAddSounds[this.seatShape1] = "BikeHit3";
        }
        
        override internal function createBodies() : void
        {
            var _loc3_:b2Shape = null;
            var _loc16_:b2PolygonDef = null;
            var _loc17_:b2Vec2 = null;
            var _loc18_:Number = NaN;
            var _loc21_:MovieClip = null;
            super.createBodies();
            var _loc1_:b2PolygonDef = new b2PolygonDef();
            var _loc2_:b2CircleDef = new b2CircleDef();
            _loc3_ = upperLeg1Body.GetShapeList();
            _loc3_.m_isSensor = true;
            _session.m_world.Refilter(_loc3_);
            _loc3_ = upperLeg2Body.GetShapeList();
            _loc3_.m_isSensor = true;
            _session.m_world.Refilter(_loc3_);
            _loc3_ = lowerLeg1Body.GetShapeList();
            _loc3_.m_isSensor = true;
            _session.m_world.Refilter(_loc3_);
            _loc3_ = lowerLeg2Body.GetShapeList();
            _loc3_.m_isSensor = true;
            _session.m_world.Refilter(_loc3_);
            var _loc4_:b2BodyDef = new b2BodyDef();
            var _loc5_:b2BodyDef = new b2BodyDef();
            _loc1_.density = 1;
            _loc1_.friction = 0.3;
            _loc1_.restitution = 0.1;
            _loc1_.filter = defaultFilter;
            paintVector.splice(paintVector.indexOf(chestBody),1);
            paintVector.splice(paintVector.indexOf(pelvisBody),1);
            _session.m_world.DestroyBody(chestBody);
            _session.m_world.DestroyBody(pelvisBody);
            var _loc6_:MovieClip = shapeGuide["chestShape"];
            _loc4_.position.Set(_startX + _loc6_.x / character_scale,_startY + _loc6_.y / character_scale);
            _loc4_.angle = _loc6_.rotation / (180 / Math.PI);
            chestBody = _session.m_world.CreateBody(_loc4_);
            _loc1_.vertexCount = 6;
            var _loc7_:int = 0;
            while(_loc7_ < 6)
            {
                _loc21_ = shapeGuide["chestVert" + [_loc7_]];
                _loc1_.vertices[_loc7_] = new b2Vec2(_loc21_.x / character_scale,_loc21_.y / character_scale);
                _loc7_++;
            }
            chestShape = chestBody.CreateShape(_loc1_);
            chestShape.SetMaterial(2);
            chestShape.SetUserData(this);
            _session.contactListener.registerListener(ContactListener.RESULT,chestShape,contactResultHandler);
            _session.contactListener.registerListener(ContactListener.ADD,chestShape,contactAddHandler);
            chestBody.SetMassFromShapes();
            chestBody.AllowSleeping(false);
            paintVector.push(chestBody);
            cameraFocus = chestBody;
            _loc6_ = shapeGuide["pelvisShape"];
            _loc5_.position.Set(_startX + _loc6_.x / character_scale,_startY + _loc6_.y / character_scale);
            _loc5_.angle = _loc6_.rotation / (180 / Math.PI);
            pelvisBody = _session.m_world.CreateBody(_loc5_);
            _loc1_.vertexCount = 5;
            _loc7_ = 0;
            while(_loc7_ < 5)
            {
                _loc21_ = shapeGuide["pelvisVert" + [_loc7_]];
                _loc1_.vertices[_loc7_] = new b2Vec2(_loc21_.x / character_scale,_loc21_.y / character_scale);
                _loc7_++;
            }
            pelvisShape = pelvisBody.CreateShape(_loc1_);
            pelvisShape.SetMaterial(2);
            pelvisShape.SetUserData(this);
            _session.contactListener.registerListener(ContactListener.RESULT,pelvisShape,contactResultHandler);
            _session.contactListener.registerListener(ContactListener.ADD,pelvisShape,contactAddHandler);
            pelvisBody.SetMassFromShapes();
            pelvisBody.AllowSleeping(false);
            paintVector.push(pelvisBody);
            var _loc8_:b2BodyDef = new b2BodyDef();
            var _loc9_:b2BodyDef = new b2BodyDef();
            var _loc10_:b2BodyDef = new b2BodyDef();
            var _loc11_:b2BodyDef = new b2BodyDef();
            var _loc12_:b2BodyDef = new b2BodyDef();
            var _loc13_:b2PolygonDef = new b2PolygonDef();
            var _loc14_:b2PolygonDef = new b2PolygonDef();
            var _loc15_:b2PolygonDef = new b2PolygonDef();
            _loc1_.density = 4;
            _loc1_.friction = 0.3;
            _loc1_.restitution = 0.1;
            _loc1_.filter = zeroFilter.Copy();
            _loc1_.filter.groupIndex = -2;
            this.mowerBody = _session.m_world.CreateBody(_loc8_);
            _loc1_.vertexCount = 4;
            _loc7_ = 0;
            while(_loc7_ < 4)
            {
                _loc21_ = shapeGuide["handleVert" + [_loc7_ + 1]];
                _loc1_.vertices[_loc7_] = new b2Vec2(_startX + _loc21_.x / character_scale,_startY + _loc21_.y / character_scale);
                _loc7_++;
            }
            this.handleShape = this.mowerBody.CreateShape(_loc1_) as b2PolygonShape;
            _loc6_ = shapeGuide["shaftShape"];
            _loc17_ = new b2Vec2(_startX + _loc6_.x / character_scale,_startY + _loc6_.y / character_scale);
            _loc18_ = _loc6_.rotation / (180 / Math.PI);
            _loc1_.SetAsOrientedBox(_loc6_.scaleX * 5 / character_scale,_loc6_.scaleY * 5 / character_scale,_loc17_,_loc18_);
            this.shaftShape = this.mowerBody.CreateShape(_loc1_) as b2PolygonShape;
            _loc1_.vertexCount = 6;
            _loc7_ = 0;
            while(_loc7_ < 6)
            {
                _loc21_ = shapeGuide["frontVert" + [_loc7_ + 1]];
                _loc1_.vertices[_loc7_] = new b2Vec2(_startX + _loc21_.x / character_scale,_startY + _loc21_.y / character_scale);
                _loc7_++;
            }
            this.frontShape = this.mowerBody.CreateShape(_loc1_) as b2PolygonShape;
            _session.contactListener.registerListener(ContactListener.RESULT,this.frontShape,this.contactMowerResultHandler);
            _session.contactListener.registerListener(ContactListener.ADD,this.frontShape,contactAddHandler);
            _loc6_ = shapeGuide["baseShape"];
            _loc17_ = new b2Vec2(_startX + _loc6_.x / character_scale,_startY + _loc6_.y / character_scale);
            _loc18_ = _loc6_.rotation / (180 / Math.PI);
            _loc1_.SetAsOrientedBox(_loc6_.scaleX * 5 / character_scale,_loc6_.scaleY * 5 / character_scale,_loc17_,_loc18_);
            this.baseShape = this.mowerBody.CreateShape(_loc1_) as b2PolygonShape;
            _loc6_ = shapeGuide["bladeShape"];
            _loc17_ = new b2Vec2(_startX + _loc6_.x / character_scale,_startY + _loc6_.y / character_scale);
            _loc18_ = _loc6_.rotation / (180 / Math.PI);
            _loc1_.SetAsOrientedBox(_loc6_.scaleX * 5 / character_scale,_loc6_.scaleY * 5 / character_scale,_loc17_,_loc18_);
            this.bladeX = _loc6_.scaleX * 5 / character_scale;
            this.bladeY = _loc6_.scaleY * 5 / character_scale;
            this.bladeCenter = _loc17_;
            this.bladeShape = this.mowerBody.CreateShape(_loc1_) as b2PolygonShape;
            this.bladeLeftX = this.bladeShape.GetVertices()[0].x;
            this.bladeRightX = this.bladeShape.GetVertices()[1].x;
            _session.contactListener.registerListener(ContactListener.RESULT,this.bladeShape,this.contactBladeResultHandler);
            _loc1_.vertexCount = 5;
            _loc7_ = 0;
            while(_loc7_ < 5)
            {
                _loc21_ = shapeGuide["rearVert" + [_loc7_ + 1]];
                _loc1_.vertices[_loc7_] = new b2Vec2(_startX + _loc21_.x / character_scale,_startY + _loc21_.y / character_scale);
                _loc7_++;
            }
            this.rearShape = this.mowerBody.CreateShape(_loc1_) as b2PolygonShape;
            _session.contactListener.registerListener(ContactListener.RESULT,this.rearShape,this.contactMowerResultHandler);
            _loc7_ = 0;
            while(_loc7_ < 5)
            {
                _loc21_ = shapeGuide["topVert" + [_loc7_ + 1]];
                _loc1_.vertices[_loc7_] = new b2Vec2(_startX + _loc21_.x / character_scale,_startY + _loc21_.y / character_scale);
                _loc7_++;
            }
            this.topShape = this.mowerBody.CreateShape(_loc1_) as b2PolygonShape;
            _session.contactListener.registerListener(ContactListener.RESULT,this.topShape,this.contactMowerResultHandler);
            _session.contactListener.registerListener(ContactListener.ADD,this.topShape,contactAddHandler);
            _loc1_.vertexCount = 4;
            _loc7_ = 0;
            while(_loc7_ < 4)
            {
                _loc21_ = shapeGuide["backVert" + [_loc7_ + 1]];
                _loc1_.vertices[_loc7_] = new b2Vec2(_startX + _loc21_.x / character_scale,_startY + _loc21_.y / character_scale);
                _loc7_++;
            }
            this.seatShape1 = this.mowerBody.CreateShape(_loc1_) as b2PolygonShape;
            _session.contactListener.registerListener(ContactListener.RESULT,this.seatShape1,this.contactMowerResultHandler);
            _session.contactListener.registerListener(ContactListener.ADD,this.seatShape1,contactAddHandler);
            _loc7_ = 0;
            while(_loc7_ < 4)
            {
                _loc21_ = shapeGuide["seatVert" + [_loc7_ + 1]];
                _loc1_.vertices[_loc7_] = new b2Vec2(_startX + _loc21_.x / character_scale,_startY + _loc21_.y / character_scale);
                _loc7_++;
            }
            this.seatShape2 = this.mowerBody.CreateShape(_loc1_) as b2PolygonShape;
            this.mowerBody.DestroyShape(this.seatShape2);
            var _loc19_:b2FilterData = new b2FilterData();
            _loc19_.maskBits = 1;
            _loc19_.categoryBits = 1;
            _loc1_.filter = _loc19_;
            _loc1_.friction = 0.01;
            _loc1_.density = 0.01;
            _loc6_ = shapeGuide["alignShape1"];
            _loc17_ = new b2Vec2(_startX + _loc6_.x / character_scale,_startY + _loc6_.y / character_scale);
            _loc18_ = _loc6_.rotation / (180 / Math.PI);
            _loc1_.SetAsOrientedBox(_loc6_.scaleX * 5 / character_scale,_loc6_.scaleY * 5 / character_scale,_loc17_,_loc18_);
            this.mowerBody.CreateShape(_loc1_);
            _loc6_ = shapeGuide["alignShape2"];
            _loc17_ = new b2Vec2(_startX + _loc6_.x / character_scale,_startY + _loc6_.y / character_scale);
            _loc18_ = _loc6_.rotation / (180 / Math.PI);
            _loc1_.SetAsOrientedBox(_loc6_.scaleX * 5 / character_scale,_loc6_.scaleY * 5 / character_scale,_loc17_,_loc18_);
            this.mowerBody.CreateShape(_loc1_);
            _loc1_.isSensor = true;
            _loc6_ = shapeGuide["clearanceShape"];
            _loc17_ = new b2Vec2(_startX + _loc6_.x / character_scale,_startY + _loc6_.y / character_scale);
            _loc18_ = _loc6_.rotation / (180 / Math.PI);
            _loc1_.SetAsOrientedBox(_loc6_.scaleX * 5 / character_scale,_loc6_.scaleY * 5 / character_scale,_loc17_,_loc18_);
            this.clearanceShape = this.mowerBody.CreateShape(_loc1_) as b2PolygonShape;
            session.contactListener.registerListener(ContactListener.ADD,this.clearanceShape,this.clearanceContactAdd);
            session.contactListener.registerListener(ContactListener.REMOVE,this.clearanceShape,this.clearanceContactRemove);
            this.mowerBody.SetMassFromShapes();
            this.mowerMass = this.mowerBody.GetMass();
            paintVector.push(this.mowerBody);
            _loc2_.density = 5;
            _loc2_.friction = 1;
            _loc2_.restitution = 0.3;
            _loc2_.filter = zeroFilter.Copy();
            _loc2_.filter.groupIndex = -2;
            _loc6_ = shapeGuide["backWheelShape"];
            _loc9_.position.Set(_startX + _loc6_.x / character_scale,_startY + _loc6_.y / character_scale);
            _loc9_.angle = _loc6_.rotation / (180 / Math.PI);
            _loc2_.localPosition.Set(0,0);
            _loc2_.radius = _loc6_.width / 2 / character_scale;
            this.backWheelBody = _session.m_world.CreateBody(_loc9_);
            this.backWheelShape = this.backWheelBody.CreateShape(_loc2_);
            this.backWheelBody.SetMassFromShapes();
            _session.contactListener.registerListener(ContactListener.ADD,this.backWheelShape,contactAddHandler);
            _loc6_ = shapeGuide["frontWheelShape"];
            _loc10_.position.Set(_startX + _loc6_.x / character_scale,_startY + _loc6_.y / character_scale);
            _loc10_.angle = _loc6_.rotation / (180 / Math.PI);
            _loc2_.radius = _loc6_.width / 2 / character_scale;
            this.frontWheelBody = _session.m_world.CreateBody(_loc10_);
            this.frontWheelShape = this.frontWheelBody.CreateShape(_loc2_);
            this.frontWheelBody.SetMassFromShapes();
            _session.contactListener.registerListener(ContactListener.ADD,this.frontWheelShape,contactAddHandler);
            _loc1_.density = 4;
            _loc1_.friction = 0.3;
            _loc1_.restitution = 0.1;
            _loc1_.filter = zeroFilter.Copy();
            _loc1_.filter.groupIndex = -2;
            _loc1_.isSensor = false;
            var _loc20_:Number = 12 / character_scale;
            _loc1_.SetAsOrientedBox(_loc20_,_loc20_,_loc10_.position);
            this.frontShockBody = _session.m_world.CreateBody(_loc11_);
            this.frontShockBody.CreateShape(_loc1_);
            this.frontShockBody.SetMassFromShapes();
            _loc1_.SetAsOrientedBox(_loc20_,_loc20_,_loc9_.position);
            this.backShockBody = _session.m_world.CreateBody(_loc12_);
            this.backShockBody.CreateShape(_loc1_);
            this.backShockBody.SetMassFromShapes();
            this.mowerLoop = SoundController.instance.playAreaSoundLoop("MowerLoop",this.mowerBody,0);
            this.mowerLoop.fadeTo(0.5,1);
        }
        
        override internal function createMovieClips() : void
        {
            super.createMovieClips();
            _session.containerSprite.addChildAt(pelvisMC,_session.containerSprite.getChildIndex(chestMC));
            var _loc1_:MovieClip = sourceObject["mowerShards"];
            _session.particleController.createBMDArray("mowershards",_loc1_);
            this.shockMC = new Sprite();
            this.mowerMC = sourceObject["mower"];
            var _loc5_:* = 1 / mc_scale;
            this.mowerMC.scaleY = 1 / mc_scale;
            this.mowerMC.scaleX = _loc5_;
            this.bladeCoverMC = sourceObject["bladecover"];
            _loc5_ = 1 / mc_scale;
            this.bladeCoverMC.scaleY = 1 / mc_scale;
            this.bladeCoverMC.scaleX = _loc5_;
            this.backWheelMC = sourceObject["backWheel"];
            _loc5_ = 1 / mc_scale;
            this.backWheelMC.scaleY = 1 / mc_scale;
            this.backWheelMC.scaleX = _loc5_;
            this.frontWheelMC = sourceObject["frontWheel"];
            _loc5_ = 1 / mc_scale;
            this.frontWheelMC.scaleY = 1 / mc_scale;
            this.frontWheelMC.scaleX = _loc5_;
            this.frontMC = sourceObject["mowerFront"];
            _loc5_ = 1 / mc_scale;
            this.frontMC.scaleY = 1 / mc_scale;
            this.frontMC.scaleX = _loc5_;
            this.frontMC.visible = false;
            this.rearMC = sourceObject["mowerRear"];
            _loc5_ = 1 / mc_scale;
            this.rearMC.scaleY = 1 / mc_scale;
            this.rearMC.scaleX = _loc5_;
            this.rearMC.visible = false;
            this.front1MC = sourceObject["front1"];
            _loc5_ = 1 / mc_scale;
            this.front1MC.scaleY = 1 / mc_scale;
            this.front1MC.scaleX = _loc5_;
            this.front1MC.visible = false;
            this.front2MC = sourceObject["front2"];
            _loc5_ = 1 / mc_scale;
            this.front2MC.scaleY = 1 / mc_scale;
            this.front2MC.scaleX = _loc5_;
            this.front2MC.visible = false;
            this.front3MC = sourceObject["front3"];
            _loc5_ = 1 / mc_scale;
            this.front3MC.scaleY = 1 / mc_scale;
            this.front3MC.scaleX = _loc5_;
            this.front3MC.visible = false;
            this.front4MC = sourceObject["front4"];
            _loc5_ = 1 / mc_scale;
            this.front4MC.scaleY = 1 / mc_scale;
            this.front4MC.scaleX = _loc5_;
            this.front4MC.visible = false;
            this.front5MC = sourceObject["front5"];
            _loc5_ = 1 / mc_scale;
            this.front5MC.scaleY = 1 / mc_scale;
            this.front5MC.scaleX = _loc5_;
            this.front5MC.visible = false;
            this.rear1MC = sourceObject["rear1"];
            _loc5_ = 1 / mc_scale;
            this.rear1MC.scaleY = 1 / mc_scale;
            this.rear1MC.scaleX = _loc5_;
            this.rear1MC.visible = false;
            this.rear2MC = sourceObject["rear2"];
            _loc5_ = 1 / mc_scale;
            this.rear2MC.scaleY = 1 / mc_scale;
            this.rear2MC.scaleX = _loc5_;
            this.rear2MC.visible = false;
            this.rear3MC = sourceObject["rear3"];
            _loc5_ = 1 / mc_scale;
            this.rear3MC.scaleY = 1 / mc_scale;
            this.rear3MC.scaleX = _loc5_;
            this.rear3MC.visible = false;
            this.rear4MC = sourceObject["rear4"];
            _loc5_ = 1 / mc_scale;
            this.rear4MC.scaleY = 1 / mc_scale;
            this.rear4MC.scaleX = _loc5_;
            this.rear4MC.visible = false;
            var _loc2_:b2Vec2 = this.mowerBody.GetLocalCenter();
            _loc2_ = new b2Vec2((_startX - _loc2_.x) * character_scale,(_startY - _loc2_.y) * character_scale);
            var _loc3_:MovieClip = shapeGuide["rearVert5"];
            var _loc4_:b2Vec2 = new b2Vec2(_loc3_.x + _loc2_.x,_loc3_.y + _loc2_.y);
            this.mowerMC.inner.x = this.bladeCoverMC.inner.x = _loc4_.x;
            this.mowerMC.inner.y = this.bladeCoverMC.inner.y = _loc4_.y;
            this.mowerBody.SetUserData(this.mowerMC);
            this.backWheelBody.SetUserData(this.backWheelMC);
            this.frontWheelBody.SetUserData(this.frontWheelMC);
            _session.containerSprite.addChildAt(this.shockMC,_session.containerSprite.getChildIndex(pelvisMC));
            _session.containerSprite.addChildAt(this.mowerMC,_session.containerSprite.getChildIndex(pelvisMC));
            _session.containerSprite.addChildAt(this.frontMC,_session.containerSprite.getChildIndex(pelvisMC));
            _session.containerSprite.addChildAt(this.rearMC,_session.containerSprite.getChildIndex(pelvisMC));
            _session.containerSprite.addChildAt(this.backWheelMC,_session.containerSprite.getChildIndex(pelvisMC));
            _session.containerSprite.addChildAt(this.frontWheelMC,_session.containerSprite.getChildIndex(pelvisMC));
            _session.containerSprite.addChildAt(this.bladeCoverMC,_session.containerSprite.getChildIndex(lowerArm1MC));
            this.targetMaskHolder = new Sprite();
            _session.containerSprite.addChild(this.targetMaskHolder);
            this.testSprite = new Sprite();
            _session.containerSprite.addChild(this.testSprite);
            _session.containerSprite.addChildAt(this.front1MC,_session.containerSprite.getChildIndex(pelvisMC));
            _session.containerSprite.addChildAt(this.front2MC,_session.containerSprite.getChildIndex(pelvisMC));
            _session.containerSprite.addChildAt(this.front4MC,_session.containerSprite.getChildIndex(pelvisMC));
            _session.containerSprite.addChildAt(this.front3MC,_session.containerSprite.getChildIndex(pelvisMC));
            _session.containerSprite.addChildAt(this.front5MC,_session.containerSprite.getChildIndex(pelvisMC));
            _session.containerSprite.addChildAt(this.rear1MC,_session.containerSprite.getChildIndex(pelvisMC));
            _session.containerSprite.addChildAt(this.rear2MC,_session.containerSprite.getChildIndex(pelvisMC));
            _session.containerSprite.addChildAt(this.rear3MC,_session.containerSprite.getChildIndex(pelvisMC));
            _session.containerSprite.addChildAt(this.rear4MC,_session.containerSprite.getChildIndex(pelvisMC));
        }
        
        override internal function resetMovieClips() : void
        {
            super.resetMovieClips();
            trace("chest visible = " + chestMC.visible);
            this.testSprite.graphics.clear();
            this.mowerMC.visible = true;
            this.shockMC.visible = true;
            this.bladeCoverMC.visible = true;
            this.frontMC.visible = false;
            this.front1MC.visible = false;
            this.front2MC.visible = false;
            this.front3MC.visible = false;
            this.front4MC.visible = false;
            this.front5MC.visible = false;
            this.rearMC.visible = false;
            this.rear1MC.visible = false;
            this.rear2MC.visible = false;
            this.rear3MC.visible = false;
            this.rear4MC.visible = false;
            this.mowerBody.SetUserData(this.mowerMC);
            this.backWheelBody.SetUserData(this.backWheelMC);
            this.frontWheelBody.SetUserData(this.frontWheelMC);
            this.shockMC.graphics.clear();
            var _loc1_:MovieClip = sourceObject["mowerShards"];
            _session.particleController.createBMDArray("mowershards",_loc1_);
        }
        
        override internal function createJoints() : void
        {
            var _loc1_:Number = NaN;
            var _loc2_:Number = NaN;
            var _loc3_:Number = NaN;
            super.createJoints();
            var _loc4_:Number = 180 / Math.PI;
            _loc1_ = head1Body.GetAngle() - chestBody.GetAngle();
            _loc2_ = -10 / _loc4_ - _loc1_;
            _loc3_ = 10 / _loc4_ - _loc1_;
            neckJoint.SetLimits(_loc2_,_loc3_);
            var _loc5_:b2PrismaticJointDef = new b2PrismaticJointDef();
            _loc5_.maxMotorForce = 1000;
            _loc5_.enableLimit = true;
            _loc5_.upperTranslation = 0;
            _loc5_.lowerTranslation = 0;
            var _loc6_:b2Vec2 = new b2Vec2();
            var _loc7_:MovieClip = shapeGuide["frontWheelShape"];
            _loc6_.Set(_startX + _loc7_.x / character_scale,_startY + _loc7_.y / character_scale);
            _loc5_.Initialize(this.mowerBody,this.frontShockBody,_loc6_,new b2Vec2(0,1));
            this.frontShockJoint = _session.m_world.CreateJoint(_loc5_) as b2PrismaticJoint;
            _loc7_ = shapeGuide["backWheelShape"];
            _loc6_.Set(_startX + _loc7_.x / character_scale,_startY + _loc7_.y / character_scale);
            _loc5_.Initialize(this.mowerBody,this.backShockBody,_loc6_,new b2Vec2(0,1));
            this.backShockJoint = _session.m_world.CreateJoint(_loc5_) as b2PrismaticJoint;
            var _loc8_:b2RevoluteJointDef = new b2RevoluteJointDef();
            _loc8_.maxMotorTorque = this.maxTorque;
            _loc8_.enableLimit = false;
            _loc8_.lowerAngle = 0;
            _loc8_.upperAngle = 0;
            _loc6_ = new b2Vec2();
            _loc6_.Set(pelvisBody.GetWorldCenter().x,pelvisBody.GetWorldCenter().y);
            _loc8_.Initialize(this.mowerBody,pelvisBody,_loc6_);
            this.mowerPelvis = _session.m_world.CreateJoint(_loc8_) as b2RevoluteJoint;
            this.mowerPelvisJointDef = _loc8_.clone();
            this.pelvisAnchorPoint = this.mowerBody.GetLocalPoint(_loc6_);
            _loc7_ = shapeGuide["backWheelShape"];
            _loc6_.Set(_startX + _loc7_.x / character_scale,_startY + _loc7_.y / character_scale);
            _loc8_.Initialize(this.backShockBody,this.backWheelBody,_loc6_);
            this.backWheelJoint = _session.m_world.CreateJoint(_loc8_) as b2RevoluteJoint;
            _loc7_ = shapeGuide["frontWheelShape"];
            _loc6_.Set(_startX + _loc7_.x / character_scale,_startY + _loc7_.y / character_scale);
            _loc8_.Initialize(this.frontShockBody,this.frontWheelBody,_loc6_);
            this.frontWheelJoint = _session.m_world.CreateJoint(_loc8_) as b2RevoluteJoint;
            _loc7_ = shapeGuide["handleAnchor"];
            _loc6_.Set(_startX + _loc7_.x / character_scale,_startY + _loc7_.y / character_scale);
            _loc8_.Initialize(this.mowerBody,lowerArm1Body,_loc6_);
            this.mowerHand1 = _session.m_world.CreateJoint(_loc8_) as b2RevoluteJoint;
            this.mowerHand1JointDef = _loc8_.clone();
            this.handleAnchorPoint = this.mowerBody.GetLocalPoint(_loc6_);
            _loc8_.Initialize(this.mowerBody,lowerArm2Body,_loc6_);
            this.mowerHand2 = _session.m_world.CreateJoint(_loc8_) as b2RevoluteJoint;
            this.mowerHand2JointDef = _loc8_.clone();
            _loc7_ = shapeGuide["footAnchor"];
            _loc6_.Set(_startX + _loc7_.x / character_scale,_startY + _loc7_.y / character_scale);
            _loc8_.Initialize(this.mowerBody,lowerLeg1Body,_loc6_);
            this.mowerFoot1 = _session.m_world.CreateJoint(_loc8_) as b2RevoluteJoint;
            this.mowerFoot1JointDef = _loc8_.clone();
            this.leg1AnchorPoint = this.mowerBody.GetLocalPoint(_loc6_);
            _loc8_.Initialize(this.mowerBody,lowerLeg2Body,_loc6_);
            this.mowerFoot2 = _session.m_world.CreateJoint(_loc8_) as b2RevoluteJoint;
            this.mowerFoot2JointDef = _loc8_.clone();
            this.leg2AnchorPoint = this.mowerBody.GetLocalPoint(_loc6_);
        }
        
        protected function contactMowerResultHandler(param1:ContactEvent) : void
        {
            var _loc2_:Number = param1.impulse;
            if(_loc2_ > contactImpulseDict[this.frontShape])
            {
                if(contactResultBuffer[this.frontShape])
                {
                    if(_loc2_ > contactResultBuffer[this.frontShape].impulse)
                    {
                        contactResultBuffer[this.frontShape] = param1;
                    }
                }
                else
                {
                    contactResultBuffer[this.frontShape] = param1;
                }
            }
        }
        
        protected function contactFrontResultHandler(param1:ContactEvent) : void
        {
            var _loc2_:Number = param1.impulse;
            if(_loc2_ > contactImpulseDict[this.brokenFrontShape])
            {
                if(contactResultBuffer[this.brokenFrontShape])
                {
                    if(_loc2_ > contactResultBuffer[this.brokenFrontShape].impulse)
                    {
                        contactResultBuffer[this.brokenFrontShape] = param1;
                    }
                }
                else
                {
                    contactResultBuffer[this.brokenFrontShape] = param1;
                }
            }
        }
        
        protected function contactRearResultHandler(param1:ContactEvent) : void
        {
            var _loc2_:Number = param1.impulse;
            if(_loc2_ > contactImpulseDict[this.brokenRearShape])
            {
                if(contactResultBuffer[this.brokenRearShape])
                {
                    if(_loc2_ > contactResultBuffer[this.brokenRearShape].impulse)
                    {
                        contactResultBuffer[this.brokenRearShape] = param1;
                    }
                }
                else
                {
                    contactResultBuffer[this.brokenRearShape] = param1;
                }
            }
        }
        
        protected function contactBladeResultHandler(param1:ContactEvent) : void
        {
            var _loc5_:ContactEvent = null;
            var _loc2_:Number = param1.impulse;
            var _loc3_:b2Shape = param1.otherShape;
            if(_loc3_.m_density == 0)
            {
                return;
            }
            var _loc4_:int = int(this.bladeShapeArray.indexOf(_loc3_));
            if(_loc4_ > -1)
            {
                _loc5_ = this.bladeContactArray[_loc4_];
                if(param1.impulse > _loc5_.impulse)
                {
                    this.bladeContactArray[_loc4_] = param1;
                }
            }
            else
            {
                this.bladeShapeArray.push(_loc3_);
                this.bladeContactArray.push(param1);
            }
        }
        
        override protected function handleContactResults() : void
        {
            var _loc1_:ContactEvent = null;
            super.handleContactResults();
            if(contactResultBuffer[this.frontShape])
            {
                _loc1_ = contactResultBuffer[this.frontShape];
                this.mowerSmash(_loc1_.impulse);
                delete contactResultBuffer[this.frontShape];
                delete contactAddBuffer[this.frontShape];
                delete contactAddBuffer[this.topShape];
                delete contactAddBuffer[this.seatShape1];
            }
            if(contactResultBuffer[this.brokenFrontShape])
            {
                _loc1_ = contactResultBuffer[this.brokenFrontShape];
                this.frontSmash(_loc1_.impulse);
                delete contactResultBuffer[this.brokenFrontShape];
                delete contactAddBuffer[this.brokenFrontShape];
            }
            if(contactResultBuffer[this.brokenRearShape])
            {
                _loc1_ = contactResultBuffer[this.brokenRearShape];
                this.rearSmash(_loc1_.impulse);
                delete contactResultBuffer[this.brokenRearShape];
                delete contactAddBuffer[this.brokenRearShape];
                delete contactAddBuffer[this.baseShape];
                delete contactAddBuffer[this.bladeShape];
                delete contactAddBuffer[this.topShape];
                delete contactAddBuffer[this.seatShape1];
            }
            this.handleBladeContacts();
        }
        
        protected function handleBladeContacts() : void
        {
            var _loc2_:ContactEvent = null;
            var _loc3_:b2Shape = null;
            var _loc4_:b2Body = null;
            var _loc5_:b2Vec2 = null;
            var _loc6_:Number = NaN;
            var _loc7_:b2Vec2 = null;
            var _loc8_:Number = NaN;
            var _loc9_:b2World = null;
            var _loc10_:b2FilterData = null;
            var _loc11_:b2Body = null;
            var _loc12_:Number = NaN;
            var _loc13_:Number = NaN;
            var _loc14_:Number = NaN;
            var _loc15_:Number = NaN;
            var _loc16_:Number = NaN;
            var _loc17_:Number = NaN;
            var _loc18_:Array = null;
            var _loc19_:Number = NaN;
            var _loc20_:b2Vec2 = null;
            var _loc21_:b2Vec2 = null;
            var _loc22_:int = 0;
            var _loc23_:String = null;
            var _loc24_:b2BodyDef = null;
            var _loc25_:b2Body = null;
            var _loc26_:b2PolygonDef = null;
            var _loc27_:b2PrismaticJointDef = null;
            var _loc28_:b2PrismaticJoint = null;
            var _loc29_:b2RevoluteJointDef = null;
            var _loc30_:b2RevoluteJoint = null;
            var _loc31_:NPCharacter = null;
            var _loc32_:CharacterB2D = null;
            var _loc33_:FoodItem = null;
            var _loc34_:Sprite = null;
            var _loc35_:Sprite = null;
            var _loc36_:b2Vec2 = null;
            var _loc37_:FoodItem = null;
            var _loc38_:Emitter = null;
            var _loc39_:int = 0;
            var _loc40_:int = 0;
            var _loc41_:int = 0;
            var _loc42_:Number = NaN;
            var _loc43_:Number = NaN;
            var _loc44_:Number = NaN;
            var _loc45_:Number = NaN;
            var _loc46_:Number = NaN;
            var _loc47_:Number = NaN;
            var _loc48_:Number = NaN;
            var _loc49_:String = null;
            var _loc50_:Number = NaN;
            var _loc51_:Number = NaN;
            var _loc52_:b2Vec2 = null;
            var _loc1_:int = 0;
            while(_loc1_ < this.bladeContactArray.length)
            {
                _loc2_ = this.bladeContactArray[_loc1_];
                _loc3_ = _loc2_.otherShape;
                _loc4_ = _loc3_.GetBody();
                _loc5_ = _loc2_.position;
                _loc6_ = _loc4_.GetMass();
                _loc7_ = this.mowerBody.GetLocalPoint(_loc5_);
                _loc7_.Subtract(this.bladeCenter);
                _loc8_ = -_loc7_.x / this.bladeX;
                if(Boolean(_loc3_.m_material & 7) && Math.abs(_loc8_) < 0.5)
                {
                    this.grindingMass += _loc6_;
                    _loc9_ = session.m_world;
                    _loc10_ = new b2FilterData();
                    _loc10_.categoryBits = 1;
                    _loc10_.maskBits = 9;
                    _loc10_.groupIndex = -3;
                    _loc3_.SetFilterData(_loc10_);
                    _loc9_.Refilter(_loc3_);
                    _loc3_.SetMaterial(0);
                    if(_loc3_.m_userData is NPCharacter)
                    {
                        _loc31_ = _loc3_.m_userData as NPCharacter;
                        _loc31_.grindShape(_loc3_);
                    }
                    else if(_loc3_.m_userData is CharacterB2D)
                    {
                        _loc32_ = _loc3_.m_userData as CharacterB2D;
                        _loc32_.grindShape(_loc3_);
                    }
                    else if(_loc3_.m_userData is FoodItem)
                    {
                        _loc33_ = _loc3_.m_userData as FoodItem;
                        _loc33_.grindShape(_loc3_);
                    }
                    _loc11_ = _loc4_;
                    this.contactCount[_loc11_] = 0;
                    if(_loc6_ > 0.1)
                    {
                        _loc34_ = _loc11_.GetUserData() as Sprite;
                        _loc35_ = new Sprite();
                        this.targetMaskHolder.addChild(_loc35_);
                        _loc36_ = this.clearanceShape.m_vertices[0].Copy();
                        _loc36_.Subtract(this.mowerBody.GetLocalCenter());
                        _loc35_.graphics.beginFill(0,0);
                        _loc35_.graphics.drawRect(-100,_loc36_.y * m_physScale,200,100);
                        _loc35_.graphics.endFill();
                        _loc34_.mask = _loc35_;
                    }
                    _loc12_ = Math.min(1,_loc6_ / 0.4);
                    _loc13_ = 1.12 * _loc12_;
                    _loc14_ = _loc13_ * 0.5;
                    _loc15_ = this.mowerBody.GetLocalPoint(_loc5_).x;
                    _loc16_ = Math.max(this.bladeLeftX,_loc15_ - _loc14_);
                    _loc17_ = Math.min(this.bladeRightX,_loc15_ + _loc14_);
                    _loc18_ = this.bladeShape.GetVertices();
                    _loc19_ = Number(this.bladeShape.GetVertices()[2].y);
                    _loc20_ = new b2Vec2(_loc16_,_loc19_);
                    _loc21_ = new b2Vec2(_loc17_,_loc19_);
                    _loc22_ = session.containerSprite.getChildIndex(this.bladeCoverMC);
                    if(_loc3_.GetUserData() is FoodItem)
                    {
                        _loc37_ = _loc3_.GetUserData() as FoodItem;
                        _loc23_ = _loc37_.particleType;
                        _loc38_ = session.particleController.createSpray(_loc23_,this.mowerBody,_loc20_,_loc21_,0,5,180,Math.round(20 * _loc12_),5000,session.containerSprite,_loc22_);
                    }
                    else
                    {
                        _loc39_ = 0;
                        _loc40_ = 5;
                        _loc41_ = 20;
                        if(Settings.bloodSetting > 1)
                        {
                            _loc39_ = 3;
                            _loc40_ = 10;
                            _loc41_ = 20;
                        }
                        _loc38_ = session.particleController.createBloodSpray(this.mowerBody,_loc20_,_loc21_,_loc39_,_loc40_,180,Math.round(_loc41_ * _loc12_),5000,session.containerSprite,_loc22_);
                    }
                    _loc24_ = new b2BodyDef();
                    _loc24_.position.Set(_loc5_.x,_loc5_.y);
                    _loc24_.angle = this.mowerBody.GetAngle();
                    _loc25_ = _loc9_.CreateBody(_loc24_);
                    _loc26_ = new b2PolygonDef();
                    _loc26_.density = 5;
                    _loc26_.restitution = 0.1;
                    _loc26_.friction = 0.1;
                    _loc26_.SetAsBox(10 / m_physScale,10 / m_physScale);
                    _loc26_.isSensor = true;
                    _loc25_.CreateShape(_loc26_);
                    _loc25_.SetMassFromShapes();
                    _loc25_.SetUserData(_loc38_);
                    _loc27_ = new b2PrismaticJointDef();
                    _loc27_.enableLimit = true;
                    _loc27_.upperTranslation = 0;
                    _loc27_.lowerTranslation = -10;
                    _loc27_.maxMotorForce = 100000;
                    _loc27_.enableMotor = true;
                    _loc27_.motorSpeed = -0.5;
                    _loc43_ = this.mowerBody.GetAngle();
                    _loc27_.Initialize(this.mowerBody,_loc25_,_loc5_,new b2Vec2(-Math.sin(_loc43_),Math.cos(_loc43_)));
                    _loc28_ = _loc9_.CreateJoint(_loc27_) as b2PrismaticJoint;
                    _loc29_ = new b2RevoluteJointDef();
                    _loc29_.enableMotor = true;
                    _loc29_.motorSpeed = 0;
                    _loc29_.maxMotorTorque = 5;
                    _loc29_.Initialize(_loc25_,_loc11_,_loc5_);
                    _loc30_ = _loc9_.CreateJoint(_loc29_) as b2RevoluteJoint;
                    this.addedJointsArray.push(_loc30_);
                    if(!this.grindLoop)
                    {
                        this.grindLoop = SoundController.instance.playAreaSoundLoop("GrindLoop2",this.mowerBody,0,Math.random() * 10000);
                        this.grindLoop.fadeIn(0.2);
                    }
                }
                else
                {
                    _loc42_ = _loc8_ * 1.2217 - 1.5708;
                    _loc42_ = _loc42_ + this.mowerBody.GetAngle();
                    _loc43_ = _loc42_ - Math.PI;
                    _loc44_ = 3;
                    if(_loc6_ > 0)
                    {
                        _loc45_ = _loc6_ / (_loc6_ + this.mowerMass);
                        _loc46_ = 1 - _loc45_;
                        _loc47_ = Math.cos(_loc42_) * _loc44_ * _loc45_;
                        _loc48_ = Math.sin(_loc42_) * _loc44_ * _loc45_;
                        this.mowerBody.ApplyImpulse(new b2Vec2(_loc47_,_loc48_),_loc5_);
                        _loc47_ = Math.cos(_loc43_) * _loc44_ * _loc46_;
                        _loc48_ = Math.sin(_loc43_) * _loc44_ * _loc46_;
                        _loc4_.ApplyImpulse(new b2Vec2(_loc47_,_loc48_),_loc5_);
                        if(!this.mowerImpactSound && this.targetBodies.length == 0)
                        {
                            _loc49_ = "MowerImpact" + Math.ceil(Math.random() * 3);
                            this.mowerImpactSound = SoundController.instance.playAreaSoundInstance(_loc49_,_loc4_);
                            _loc50_ = this.mowerBody.GetLocalPoint(_loc5_).x;
                            _loc51_ = Number(this.bladeShape.GetVertices()[2].y);
                            _loc52_ = this.mowerBody.GetWorldPoint(new b2Vec2(_loc50_,_loc51_));
                            session.particleController.createSparkBurstPoint(_loc52_,new b2Vec2(_loc47_ * 5,_loc48_ * 5),5,50,20);
                        }
                    }
                    else
                    {
                        _loc47_ = Math.cos(_loc42_) * _loc44_;
                        _loc48_ = Math.sin(_loc42_) * _loc44_;
                        this.mowerBody.ApplyImpulse(new b2Vec2(_loc47_,_loc48_),_loc5_);
                        if(!this.mowerImpactSound && this.targetBodies.length == 0)
                        {
                            _loc49_ = "MowerImpact" + Math.ceil(Math.random() * 3);
                            this.mowerImpactSound = SoundController.instance.playAreaSoundInstance(_loc49_,this.mowerBody,0.4);
                            _loc50_ = this.mowerBody.GetLocalPoint(_loc5_).x;
                            _loc51_ = Number(this.bladeShape.GetVertices()[2].y);
                            _loc52_ = this.mowerBody.GetWorldPoint(new b2Vec2(_loc50_,_loc51_));
                            session.particleController.createSparkBurstPoint(_loc52_,new b2Vec2(-_loc47_ * 5,-_loc48_ * 5),5,50,20);
                        }
                    }
                }
                _loc1_++;
            }
            this.bladeContactArray = new Array();
            this.bladeShapeArray = new Array();
        }
        
        protected function clearanceContactAdd(param1:b2ContactPoint) : void
        {
            var _loc2_:b2Body = param1.shape2.m_body;
            if(this.contactCount[_loc2_] == undefined)
            {
                throw new Error("contact count not defined");
            }
            var _loc3_:int = int(this.contactCount[_loc2_]);
            this.contactCount[_loc2_] = _loc3_ + 1;
        }
        
        protected function clearanceContactRemove(param1:b2ContactPoint) : void
        {
            var _loc2_:b2Body = param1.shape2.m_body;
            var _loc3_:int = int(this.contactCount[_loc2_]);
            this.contactCount[_loc2_] = _loc3_ - 1;
        }
        
        override internal function eject() : void
        {
            if(this.ejected)
            {
                return;
            }
            this.ejected = true;
            resetJointLimits();
            var _loc1_:b2World = _session.m_world;
            if(this.mowerPelvis)
            {
                _loc1_.DestroyJoint(this.mowerPelvis);
                this.mowerPelvis = null;
            }
            if(this.mowerHand1)
            {
                _loc1_.DestroyJoint(this.mowerHand1);
                this.mowerHand1 = null;
            }
            if(this.mowerHand2)
            {
                _loc1_.DestroyJoint(this.mowerHand2);
                this.mowerHand2 = null;
            }
            if(this.mowerFoot1)
            {
                _loc1_.DestroyJoint(this.mowerFoot1);
                this.mowerFoot1 = null;
            }
            if(this.mowerFoot2)
            {
                _loc1_.DestroyJoint(this.mowerFoot2);
                this.mowerFoot2 = null;
            }
            var _loc2_:b2Shape = upperLeg1Body.GetShapeList();
            _loc2_.m_isSensor = false;
            _loc1_.Refilter(_loc2_);
            _loc2_ = upperLeg2Body.GetShapeList();
            _loc2_.m_isSensor = false;
            _loc1_.Refilter(_loc2_);
            lowerLeg1Shape.m_isSensor = false;
            _loc1_.Refilter(lowerLeg1Shape);
            lowerLeg2Shape.m_isSensor = false;
            _loc1_.Refilter(lowerLeg2Shape);
            this.frontShockJoint.EnableMotor(false);
            this.frontShockJoint.SetLimits(0,0);
            this.frontShockJoint.SetMotorSpeed(0);
            this.backShockJoint.EnableMotor(false);
            this.backShockJoint.SetLimits(0,0);
            this.backShockJoint.SetMotorSpeed(0);
            lowerArm1MC.hand.gotoAndStop(2);
            lowerArm2MC.hand.gotoAndStop(2);
            var _loc3_:Number = this.mowerBody.GetAngle() - Math.PI / 2;
            var _loc4_:Number = Math.cos(_loc3_) * this.ejectImpulse;
            var _loc5_:Number = Math.sin(_loc3_) * this.ejectImpulse;
            chestBody.ApplyImpulse(new b2Vec2(_loc4_,_loc5_),chestBody.GetWorldCenter());
            pelvisBody.ApplyImpulse(new b2Vec2(_loc4_,_loc5_),pelvisBody.GetWorldCenter());
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
            }
        }
        
        internal function checkEject() : void
        {
            if(!this.mowerHand1 && !this.mowerHand2 && !this.mowerFoot1 && !this.mowerFoot2)
            {
                this.eject();
            }
        }
        
        protected function mowerSmash(param1:Number) : void
        {
            var _loc14_:b2Body = null;
            var _loc15_:b2Shape = null;
            var _loc16_:b2Body = null;
            var _loc17_:Emitter = null;
            var _loc18_:Sprite = null;
            var _loc19_:NPCharacter = null;
            var _loc20_:CharacterB2D = null;
            var _loc21_:DisplayObject = null;
            trace(tag + " mower impulse " + param1 + " -> " + _session.iteration);
            delete contactImpulseDict[this.frontShape];
            var _loc2_:ContactListener = _session.contactListener;
            _loc2_.deleteListener(ContactListener.RESULT,this.frontShape);
            _loc2_.deleteListener(ContactListener.RESULT,this.topShape);
            _loc2_.deleteListener(ContactListener.RESULT,this.rearShape);
            _loc2_.deleteListener(ContactListener.RESULT,this.seatShape1);
            _loc2_.deleteListener(ContactListener.RESULT,this.bladeShape);
            _loc2_.deleteListener(ContactListener.ADD,this.frontShape);
            _loc2_.deleteListener(ContactListener.ADD,this.topShape);
            _loc2_.deleteListener(ContactListener.ADD,this.seatShape1);
            var _loc3_:b2World = _session.m_world;
            this.bladeShapeArray = new Array();
            this.bladeContactArray = new Array();
            var _loc4_:int = int(this.targetBodies.length);
            var _loc5_:int = 0;
            while(_loc5_ < _loc4_)
            {
                _loc14_ = this.targetBodies[_loc5_];
                _loc15_ = _loc14_.GetShapeList();
                if(_loc15_.m_userData is NPCharacter)
                {
                    _loc19_ = _loc15_.m_userData as NPCharacter;
                    _loc19_.removeBody(_loc14_);
                }
                else if(_loc15_.m_userData is CharacterB2D)
                {
                    _loc20_ = _loc15_.m_userData as CharacterB2D;
                    _loc20_.removeBody(_loc14_);
                }
                _loc16_ = this.risingBodies[_loc5_];
                _loc17_ = _loc16_.GetUserData();
                _loc17_.stopSpewing();
                _loc3_.DestroyBody(_loc14_);
                _loc3_.DestroyBody(_loc16_);
                _loc18_ = _loc14_.m_userData;
                if(_loc18_.mask != null)
                {
                    _loc21_ = _loc18_.mask;
                    _loc18_.mask = null;
                    this.targetMaskHolder.removeChild(_loc21_);
                }
                _loc18_.visible = false;
                _loc5_++;
            }
            if(this.grindLoop)
            {
                this.grindLoop.stopSound();
                this.grindLoop = null;
            }
            this.mowerLoop.stopSound();
            this.mowerLoop = null;
            this.addedJointsArray = new Array();
            this.targetBodies = new Array();
            this.risingBodies = new Array();
            this.eject();
            this.mowerSmashed = true;
            var _loc6_:b2Vec2 = this.mowerBody.GetPosition();
            var _loc7_:Number = this.mowerBody.GetAngle();
            var _loc8_:b2Vec2 = this.mowerBody.GetLinearVelocity();
            var _loc9_:Number = this.mowerBody.GetAngularVelocity();
            var _loc10_:b2BodyDef = new b2BodyDef();
            _loc10_.position = _loc6_;
            _loc10_.angle = _loc7_;
            var _loc11_:b2PolygonDef = new b2PolygonDef();
            _loc11_.density = 4;
            _loc11_.friction = 0.3;
            _loc11_.restitution = 0.1;
            _loc11_.filter = zeroFilter;
            this.frontBody = _loc3_.CreateBody(_loc10_);
            this.frontBody.SetAngularVelocity(_loc9_);
            this.rearBody = _loc3_.CreateBody(_loc10_);
            this.rearBody.SetAngularVelocity(_loc9_);
            _loc11_.vertexCount = 4;
            _loc11_.vertices = this.handleShape.GetVertices();
            this.handleShape = this.frontBody.CreateShape(_loc11_) as b2PolygonShape;
            _loc2_.registerListener(ContactListener.RESULT,this.handleShape,this.contactFrontResultHandler);
            _loc11_.vertices = this.shaftShape.GetVertices();
            this.frontBody.CreateShape(_loc11_);
            _loc11_.vertexCount = 6;
            _loc11_.vertices = this.frontShape.GetVertices();
            this.brokenFrontShape = this.frontBody.CreateShape(_loc11_) as b2PolygonShape;
            _loc2_.registerListener(ContactListener.RESULT,this.brokenFrontShape,this.contactFrontResultHandler);
            _loc2_.registerListener(ContactListener.ADD,this.brokenFrontShape,contactAddHandler);
            this.frontBody.SetMassFromShapes();
            this.frontBody.SetLinearVelocity(this.mowerBody.GetLinearVelocityFromLocalPoint(this.frontBody.GetLocalCenter()));
            contactImpulseDict[this.brokenFrontShape] = this.frontRearSmashLimit;
            contactAddSounds[this.brokenFrontShape] = "ChairHit3";
            _loc11_.vertexCount = 4;
            _loc11_.vertices = this.baseShape.GetVertices();
            this.baseShape = this.rearBody.CreateShape(_loc11_) as b2PolygonShape;
            _loc2_.registerListener(ContactListener.RESULT,this.baseShape,this.contactRearResultHandler);
            _loc2_.registerListener(ContactListener.ADD,this.baseShape,contactAddHandler);
            _loc11_.vertices = this.bladeShape.GetVertices();
            this.bladeShape = this.rearBody.CreateShape(_loc11_) as b2PolygonShape;
            _loc2_.registerListener(ContactListener.RESULT,this.bladeShape,this.contactRearResultHandler);
            _loc2_.registerListener(ContactListener.ADD,this.bladeShape,contactAddHandler);
            _loc11_.vertexCount = 5;
            _loc11_.vertices = this.rearShape.GetVertices();
            this.brokenRearShape = this.rearBody.CreateShape(_loc11_) as b2PolygonShape;
            _loc2_.registerListener(ContactListener.RESULT,this.brokenRearShape,this.contactRearResultHandler);
            _loc2_.registerListener(ContactListener.ADD,this.brokenRearShape,contactAddHandler);
            _loc11_.vertices = this.topShape.GetVertices();
            this.topShape = this.rearBody.CreateShape(_loc11_) as b2PolygonShape;
            _loc2_.registerListener(ContactListener.RESULT,this.topShape,this.contactRearResultHandler);
            _loc2_.registerListener(ContactListener.ADD,this.topShape,contactAddHandler);
            _loc11_.vertexCount = 4;
            _loc11_.vertices = this.seatShape1.GetVertices();
            this.seatShape1 = this.rearBody.CreateShape(_loc11_) as b2PolygonShape;
            _loc2_.registerListener(ContactListener.RESULT,this.seatShape1,this.contactRearResultHandler);
            _loc2_.registerListener(ContactListener.ADD,this.seatShape1,contactAddHandler);
            _loc11_.vertices = this.seatShape2.GetVertices();
            this.seatShape2 = this.rearBody.CreateShape(_loc11_) as b2PolygonShape;
            this.rearBody.SetMassFromShapes();
            this.rearBody.SetLinearVelocity(this.mowerBody.GetLinearVelocityFromLocalPoint(this.rearBody.GetLocalCenter()));
            contactImpulseDict[this.brokenRearShape] = this.frontRearSmashLimit;
            contactAddSounds[this.bladeShape] = "BikeHit1";
            contactAddSounds[this.baseShape] = "ChairHit2";
            contactAddSounds[this.topShape] = "ChairHit2";
            contactAddSounds[this.brokenRearShape] = "ChairHit3";
            contactAddSounds[this.seatShape1] = "BikeHit3";
            var _loc12_:b2Vec2 = this.mowerBody.GetWorldCenter();
            _session.particleController.createPointBurst("mowershards",_loc12_.x * m_physScale,_loc12_.y * m_physScale,30,30,70);
            _loc3_.DestroyBody(this.mowerBody);
            _loc3_.DestroyBody(this.frontShockBody);
            _loc3_.DestroyBody(this.backShockBody);
            this.mowerMC.visible = this.bladeCoverMC.visible = false;
            this.frontMC.visible = true;
            this.frontBody.SetUserData(this.frontMC);
            paintVector.push(this.frontBody);
            this.rearMC.visible = true;
            this.rearBody.SetUserData(this.rearMC);
            paintVector.push(this.rearBody);
            var _loc13_:b2RevoluteJointDef = new b2RevoluteJointDef();
            _loc13_.maxMotorTorque = this.maxTorque;
            _loc13_.enableLimit = false;
            _loc13_.lowerAngle = 0;
            _loc13_.upperAngle = 0;
            _loc13_.body1 = this.frontBody;
            _loc13_.body2 = this.frontWheelBody;
            _loc13_.localAnchor1 = this.frontShockJoint.m_localAnchor1;
            _loc13_.localAnchor2 = this.frontWheelJoint.m_localAnchor2;
            _loc3_.DestroyJoint(this.frontWheelJoint);
            this.frontWheelJoint = _loc3_.CreateJoint(_loc13_) as b2RevoluteJoint;
            _loc13_.body1 = this.rearBody;
            _loc13_.body2 = this.backWheelBody;
            _loc13_.localAnchor1 = this.backShockJoint.m_localAnchor1;
            _loc13_.localAnchor2 = this.backWheelJoint.m_localAnchor2;
            _loc3_.DestroyJoint(this.backWheelJoint);
            this.backWheelJoint = _loc3_.CreateJoint(_loc13_) as b2RevoluteJoint;
            this.shockMC.visible = false;
            SoundController.instance.playAreaSoundInstance("MetalSmashHeavy3",this.mowerBody);
        }
        
        internal function frontSmash(param1:Number) : void
        {
            var _loc16_:MovieClip = null;
            trace(tag + " front impulse " + param1 + " -> " + _session.iteration);
            delete contactImpulseDict[this.brokenFrontShape];
            var _loc2_:ContactListener = _session.contactListener;
            _loc2_.deleteListener(ContactListener.RESULT,this.brokenFrontShape);
            _loc2_.deleteListener(ContactListener.RESULT,this.handleShape);
            _loc2_.deleteListener(ContactListener.ADD,this.brokenFrontShape);
            var _loc3_:b2World = _session.m_world;
            var _loc4_:b2Vec2 = this.frontBody.GetPosition();
            var _loc5_:Number = this.frontBody.GetAngle();
            var _loc6_:b2Vec2 = this.frontBody.GetLinearVelocity();
            var _loc7_:Number = this.frontBody.GetAngularVelocity();
            var _loc8_:b2BodyDef = new b2BodyDef();
            _loc8_.position = _loc4_;
            _loc8_.angle = _loc5_;
            var _loc9_:b2PolygonDef = new b2PolygonDef();
            _loc9_.density = 4;
            _loc9_.friction = 0.3;
            _loc9_.restitution = 0.1;
            _loc9_.filter = zeroFilter;
            var _loc10_:b2Body = _loc3_.CreateBody(_loc8_);
            _loc10_.SetAngularVelocity(_loc7_);
            var _loc11_:b2Body = _loc3_.CreateBody(_loc8_);
            _loc11_.SetAngularVelocity(_loc7_);
            var _loc12_:b2Body = _loc3_.CreateBody(_loc8_);
            _loc12_.SetAngularVelocity(_loc7_);
            var _loc13_:b2Body = _loc3_.CreateBody(_loc8_);
            _loc13_.SetAngularVelocity(_loc7_);
            var _loc14_:b2Body = _loc3_.CreateBody(_loc8_);
            _loc14_.SetAngularVelocity(_loc7_);
            _loc9_.vertexCount = 4;
            _loc9_.vertices = this.handleShape.GetVertices();
            _loc10_.CreateShape(_loc9_);
            var _loc15_:int = 0;
            while(_loc15_ < 4)
            {
                _loc16_ = shapeGuide["f1vert" + [_loc15_ + 1]];
                _loc9_.vertices[_loc15_] = new b2Vec2(_startX + _loc16_.x / character_scale,_startY + _loc16_.y / character_scale);
                _loc15_++;
            }
            _loc10_.CreateShape(_loc9_);
            _loc10_.SetMassFromShapes();
            _loc10_.SetLinearVelocity(this.frontBody.GetLinearVelocityFromLocalPoint(_loc10_.GetLocalCenter()));
            _loc10_.SetUserData(this.front1MC);
            this.front1MC.visible = true;
            paintVector.push(_loc10_);
            _loc15_ = 0;
            while(_loc15_ < 4)
            {
                _loc16_ = shapeGuide["f2vert" + [_loc15_ + 1]];
                _loc9_.vertices[_loc15_] = new b2Vec2(_startX + _loc16_.x / character_scale,_startY + _loc16_.y / character_scale);
                _loc15_++;
            }
            _loc11_.CreateShape(_loc9_);
            _loc11_.SetMassFromShapes();
            _loc11_.SetLinearVelocity(this.frontBody.GetLinearVelocityFromLocalPoint(_loc11_.GetLocalCenter()));
            _loc11_.SetUserData(this.front2MC);
            this.front2MC.visible = true;
            paintVector.push(_loc11_);
            _loc15_ = 0;
            while(_loc15_ < 4)
            {
                _loc16_ = shapeGuide["f3vert" + [_loc15_ + 1]];
                _loc9_.vertices[_loc15_] = new b2Vec2(_startX + _loc16_.x / character_scale,_startY + _loc16_.y / character_scale);
                _loc15_++;
            }
            _loc12_.CreateShape(_loc9_);
            _loc12_.SetMassFromShapes();
            _loc12_.SetLinearVelocity(this.frontBody.GetLinearVelocityFromLocalPoint(_loc12_.GetLocalCenter()));
            _loc12_.SetUserData(this.front3MC);
            this.front3MC.visible = true;
            paintVector.push(_loc12_);
            _loc15_ = 0;
            while(_loc15_ < 4)
            {
                _loc16_ = shapeGuide["f4vert" + [_loc15_ + 1]];
                _loc9_.vertices[_loc15_] = new b2Vec2(_startX + _loc16_.x / character_scale,_startY + _loc16_.y / character_scale);
                _loc15_++;
            }
            _loc13_.CreateShape(_loc9_);
            _loc13_.SetMassFromShapes();
            _loc13_.SetLinearVelocity(this.frontBody.GetLinearVelocityFromLocalPoint(_loc13_.GetLocalCenter()));
            _loc13_.SetUserData(this.front4MC);
            this.front4MC.visible = true;
            paintVector.push(_loc13_);
            _loc15_ = 0;
            while(_loc15_ < 4)
            {
                _loc16_ = shapeGuide["f5vert" + [_loc15_ + 1]];
                _loc9_.vertices[_loc15_] = new b2Vec2(_startX + _loc16_.x / character_scale,_startY + _loc16_.y / character_scale);
                _loc15_++;
            }
            _loc14_.CreateShape(_loc9_);
            _loc14_.SetMassFromShapes();
            _loc14_.SetLinearVelocity(this.frontBody.GetLinearVelocityFromLocalPoint(_loc14_.GetLocalCenter()));
            _loc14_.SetUserData(this.front5MC);
            this.front5MC.visible = true;
            paintVector.push(_loc14_);
            _session.particleController.createBurst("mowershards",30,30,this.frontBody,50);
            _loc3_.DestroyBody(this.frontBody);
            this.frontMC.visible = false;
            _loc3_.DestroyJoint(this.frontWheelJoint);
            SoundController.instance.playAreaSoundInstance("MetalSmashHeavy2",this.frontBody);
        }
        
        internal function rearSmash(param1:Number) : void
        {
            var _loc16_:MovieClip = null;
            trace(tag + " rear impulse " + param1 + " -> " + _session.iteration);
            delete contactImpulseDict[this.brokenRearShape];
            var _loc2_:ContactListener = _session.contactListener;
            _loc2_.deleteListener(ContactListener.RESULT,this.baseShape);
            _loc2_.deleteListener(ContactListener.RESULT,this.bladeShape);
            _loc2_.deleteListener(ContactListener.RESULT,this.brokenRearShape);
            _loc2_.deleteListener(ContactListener.RESULT,this.topShape);
            _loc2_.deleteListener(ContactListener.RESULT,this.seatShape1);
            _loc2_.deleteListener(ContactListener.ADD,this.baseShape);
            _loc2_.deleteListener(ContactListener.ADD,this.bladeShape);
            _loc2_.deleteListener(ContactListener.ADD,this.brokenRearShape);
            _loc2_.deleteListener(ContactListener.ADD,this.topShape);
            _loc2_.deleteListener(ContactListener.ADD,this.seatShape1);
            var _loc3_:b2World = _session.m_world;
            var _loc4_:b2Vec2 = this.rearBody.GetPosition();
            var _loc5_:Number = this.rearBody.GetAngle();
            var _loc6_:b2Vec2 = this.rearBody.GetLinearVelocity();
            var _loc7_:Number = this.rearBody.GetAngularVelocity();
            var _loc8_:b2BodyDef = new b2BodyDef();
            _loc8_.position = _loc4_;
            _loc8_.angle = _loc5_;
            var _loc9_:b2PolygonDef = new b2PolygonDef();
            _loc9_.density = 4;
            _loc9_.friction = 0.3;
            _loc9_.restitution = 0.1;
            _loc9_.filter = zeroFilter;
            var _loc10_:b2Body = _loc3_.CreateBody(_loc8_);
            _loc10_.SetAngularVelocity(_loc7_);
            var _loc11_:b2Body = _loc3_.CreateBody(_loc8_);
            _loc11_.SetAngularVelocity(_loc7_);
            var _loc12_:b2Body = _loc3_.CreateBody(_loc8_);
            _loc12_.SetAngularVelocity(_loc7_);
            var _loc13_:b2Body = _loc3_.CreateBody(_loc8_);
            _loc13_.SetAngularVelocity(_loc7_);
            var _loc14_:b2Body = _loc3_.CreateBody(_loc8_);
            _loc14_.SetAngularVelocity(_loc7_);
            _loc9_.vertexCount = this.baseShape.m_vertexCount;
            _loc9_.vertices = this.baseShape.GetVertices();
            _loc10_.CreateShape(_loc9_);
            _loc10_.SetMassFromShapes();
            _loc10_.SetLinearVelocity(this.rearBody.GetLinearVelocityFromLocalPoint(_loc10_.GetLocalCenter()));
            _loc10_.SetUserData(this.rear3MC);
            this.rear3MC.visible = true;
            paintVector.push(_loc10_);
            var _loc15_:int = 0;
            while(_loc15_ < 4)
            {
                _loc16_ = shapeGuide["r1vert" + [_loc15_]];
                _loc9_.vertices[_loc15_] = new b2Vec2(_startX + _loc16_.x / character_scale,_startY + _loc16_.y / character_scale);
                _loc15_++;
            }
            _loc11_.CreateShape(_loc9_);
            _loc11_.SetMassFromShapes();
            _loc11_.SetLinearVelocity(this.rearBody.GetLinearVelocityFromLocalPoint(_loc11_.GetLocalCenter()));
            _loc11_.SetUserData(this.rear4MC);
            this.rear4MC.visible = true;
            paintVector.push(_loc11_);
            _loc9_.vertexCount = this.brokenRearShape.m_vertexCount;
            _loc9_.vertices = this.brokenRearShape.GetVertices();
            _loc12_.CreateShape(_loc9_);
            _loc9_.vertexCount = this.topShape.m_vertexCount;
            _loc9_.vertices = this.topShape.GetVertices();
            _loc12_.CreateShape(_loc9_);
            _loc12_.SetMassFromShapes();
            _loc12_.SetLinearVelocity(this.rearBody.GetLinearVelocityFromLocalPoint(_loc12_.GetLocalCenter()));
            _loc12_.SetUserData(this.rear2MC);
            this.rear2MC.visible = true;
            paintVector.push(_loc12_);
            _loc9_.vertexCount = this.seatShape1.m_vertexCount;
            _loc9_.vertices = this.seatShape1.GetVertices();
            _loc13_.CreateShape(_loc9_);
            _loc9_.vertexCount = this.seatShape2.m_vertexCount;
            _loc9_.vertices = this.seatShape2.GetVertices();
            _loc13_.CreateShape(_loc9_);
            _loc13_.SetMassFromShapes();
            _loc13_.SetLinearVelocity(this.rearBody.GetLinearVelocityFromLocalPoint(_loc13_.GetLocalCenter()));
            _loc13_.SetUserData(this.rear1MC);
            this.rear1MC.visible = true;
            paintVector.push(_loc13_);
            _session.particleController.createBurst("mowershards",30,30,this.rearBody,50);
            _loc3_.DestroyBody(this.rearBody);
            this.rearMC.visible = false;
            _loc3_.DestroyJoint(this.backWheelJoint);
            SoundController.instance.playAreaSoundInstance("MetalSmashHeavy",this.rearBody);
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
            if(this.mowerHand1)
            {
                _session.m_world.DestroyJoint(this.mowerHand1);
                this.mowerHand1 = null;
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
            if(this.mowerHand2)
            {
                _session.m_world.DestroyJoint(this.mowerHand2);
                this.mowerHand2 = null;
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
            if(this.mowerHand1)
            {
                _session.m_world.DestroyJoint(this.mowerHand1);
                this.mowerHand1 = null;
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
            if(this.mowerHand2)
            {
                _session.m_world.DestroyJoint(this.mowerHand2);
                this.mowerHand2 = null;
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
            if(this.mowerFoot1)
            {
                _session.m_world.DestroyJoint(this.mowerFoot1);
                this.mowerFoot1 = null;
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
            if(this.mowerFoot2)
            {
                _session.m_world.DestroyJoint(this.mowerFoot2);
                this.mowerFoot2 = null;
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
            if(this.mowerFoot1)
            {
                _session.m_world.DestroyJoint(this.mowerFoot1);
                this.mowerFoot1 = null;
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
            if(this.mowerFoot2)
            {
                _session.m_world.DestroyJoint(this.mowerFoot2);
                this.mowerFoot2 = null;
            }
            this.checkEject();
        }
        
        internal function leanBackPose() : void
        {
            setJoint(neckJoint,0,2);
            setJoint(elbowJoint1,2.5,15);
            setJoint(elbowJoint2,2.5,15);
        }
        
        internal function leanForwardPose() : void
        {
            setJoint(neckJoint,1,1);
            setJoint(elbowJoint1,0,15);
            setJoint(elbowJoint2,0,15);
        }
        
        internal function lungePoseLeft() : void
        {
            setJoint(neckJoint,0.5,2);
            setJoint(hipJoint1,3.5,2);
            setJoint(hipJoint2,0,2);
            setJoint(kneeJoint1,0,10);
            setJoint(kneeJoint2,2,10);
            setJoint(shoulderJoint1,3,20);
            setJoint(shoulderJoint2,1,20);
            setJoint(elbowJoint1,1.5,15);
            setJoint(elbowJoint2,3,15);
        }
        
        internal function lungePoseRight() : void
        {
            setJoint(neckJoint,0.5,2);
            setJoint(hipJoint1,0,2);
            setJoint(hipJoint2,3.5,2);
            setJoint(kneeJoint1,2,10);
            setJoint(kneeJoint2,0,10);
            setJoint(shoulderJoint1,1,20);
            setJoint(shoulderJoint2,3,20);
            setJoint(elbowJoint1,3,15);
            setJoint(elbowJoint2,1.5,15);
        }
    }
}

