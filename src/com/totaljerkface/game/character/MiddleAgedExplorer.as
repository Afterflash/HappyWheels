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
    import flash.system.*;
    import flash.utils.*;
    
    public class MiddleAgedExplorer extends CharacterB2D
    {
        private static const GRAVITY_DISPLACEMENT:Number = -0.3333333333333333;
        
        internal static var piOverOneEighty:Number = Math.PI / 180;
        
        protected var ejected:Boolean;
        
        protected var hatOn:Boolean;
        
        protected var wheelMaxSpeed:Number = 1000;
        
        protected var wheelCurrentSpeed:Number;
        
        protected var wheelNewSpeed:Number;
        
        protected var accelStep:Number = 1;
        
        protected var prisAccelStep:Number = 0.5;
        
        protected var maxTorque:Number = 40;
        
        protected var wheelContacts:Number = 0;
        
        protected var impulseMagnitude:Number = 3;
        
        protected var impulseLeft:Number = 0.7;
        
        protected var impulseRight:Number = 0.7;
        
        protected var impulseOffset:Number = 1;
        
        protected var maxSpinAV:Number = 5;
        
        protected var hatSmashLimit:Number = 0.75;
        
        protected var frameSmashLimit:Number = 150;
        
        protected var wheelSparkLimit:Number = 8;
        
        protected var frameSmashed:Boolean;
        
        protected var wheelLoop1:AreaSoundLoop;
        
        protected var wheelLoop2:AreaSoundLoop;
        
        protected var wheelLoop3:AreaSoundLoop;
        
        protected var motorSound:AreaSoundLoop;
        
        protected var handleAnchorPoint:b2Vec2;
        
        protected var footAnchorPoint:b2Vec2;
        
        protected var frameHand1JointDef:b2RevoluteJointDef;
        
        protected var frameHand2JointDef:b2RevoluteJointDef;
        
        protected var cartFoot1JointDef:b2RevoluteJointDef;
        
        protected var cartFoot2JointDef:b2RevoluteJointDef;
        
        internal var frameBody:b2Body;
        
        internal var frontWheelBody:b2Body;
        
        internal var backWheelBody:b2Body;
        
        internal var hatBody:b2Body;
        
        internal var hatShape:b2Shape;
        
        internal var frameBottomShape:b2Shape;
        
        internal var frameLeftShape:b2Shape;
        
        internal var frameRightShape:b2Shape;
        
        internal var frontWheelShape:b2Shape;
        
        internal var backWheelShape:b2Shape;
        
        internal var frameMC:MovieClip;
        
        internal var frontWheelMC:MovieClip;
        
        internal var backWheelMC:MovieClip;
        
        internal var hatMC:MovieClip;
        
        internal var cartSmashedMC:MovieClip;
        
        internal var frameLeftSmashedMC:MovieClip;
        
        internal var frameRightSmashedMC:MovieClip;
        
        internal var frameBottomSmashedMC:MovieClip;
        
        internal var engineSmashedMC:MovieClip;
        
        internal var frontWheelJoint:b2RevoluteJoint;
        
        internal var backWheelJoint:b2RevoluteJoint;
        
        internal var frameHand1Joint:b2RevoluteJoint;
        
        internal var frameHand2Joint:b2RevoluteJoint;
        
        internal var cartFoot1Joint:b2RevoluteJoint;
        
        internal var cartFoot2Joint:b2RevoluteJoint;
        
        internal var frontDongleRailJoint:b2PrismaticJoint;
        
        internal var backDongleRailJoint:b2PrismaticJoint;
        
        internal var frontDongleRevJoint:b2RevoluteJoint;
        
        internal var backDongleRevJoint:b2RevoluteJoint;
        
        internal var connecting:Boolean = false;
        
        internal var frontWheelPos:b2Vec2;
        
        internal var backWheelPos:b2Vec2;
        
        internal var frontRailBody:b2Body;
        
        internal var backRailBody:b2Body;
        
        internal var newFrontWheelRailBody:b2Body;
        
        internal var newBackWheelRailBody:b2Body;
        
        internal var previousFrontRailBody:b2Body;
        
        internal var previousBackRailBody:b2Body;
        
        internal var frontDongleBody:b2Body;
        
        internal var backDongleBody:b2Body;
        
        internal var destroyFrontDongle:Boolean = false;
        
        internal var destroyBackDongle:Boolean = false;
        
        internal var railDistanceMin:int = 37;
        
        internal var railJointY:Number;
        
        internal var testSprite:Sprite;
        
        internal var frontWheelContactPoint:b2ContactPoint;
        
        internal var backWheelContactPoint:b2ContactPoint;
        
        internal var clickVolume:Number = 0.6;
        
        internal var oneDongleCounter:int = 0;
        
        internal var oneDongleMax:int = 35;
        
        internal var frontDongleRevJointStartAngle:Number;
        
        internal var backDongleRevJointStartAngle:Number;
        
        public function MiddleAgedExplorer(param1:Number, param2:Number, param3:DisplayObject, param4:Session)
        {
            param1 += 20;
            param2 -= 40;
            super(param1,param2,param3,param4,-1,"Char2");
            this.railJointY = -23 / m_physScale;
        }
        
        override internal function leftPressedActions() : void
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
                currentPose = 1;
            }
            else
            {
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
                _loc4_ = 0;
                _loc5_ = Math.cos(_loc1_) * (this.impulseLeft + _loc4_) * _loc3_;
                _loc6_ = Math.sin(_loc1_) * (this.impulseLeft + _loc4_) * _loc3_;
                _loc7_ = this.frameBody.GetLocalCenter();
                this.frameBody.ApplyImpulse(new b2Vec2(_loc6_,-_loc5_),this.frameBody.GetWorldPoint(new b2Vec2(_loc7_.x + this.impulseOffset,_loc7_.y)));
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
            var _loc7_:Number = NaN;
            var _loc8_:b2Vec2 = null;
            if(this.ejected)
            {
                currentPose = 2;
            }
            else
            {
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
                _loc4_ = 1;
                _loc5_ = 0;
                _loc6_ = Math.cos(_loc1_) * (this.impulseRight + _loc5_) * _loc3_;
                _loc7_ = Math.sin(_loc1_) * (this.impulseRight + _loc5_) * _loc3_;
                _loc8_ = this.frameBody.GetLocalCenter();
                this.frameBody.ApplyImpulse(new b2Vec2(_loc7_,-_loc6_),this.frameBody.GetWorldPoint(new b2Vec2(_loc8_.x - this.impulseOffset,_loc8_.y)));
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
                this.accelerateMotorSpeed(this.frontDongleBody,this.frontWheelJoint,this.frontDongleRailJoint);
                this.accelerateMotorSpeed(this.backDongleBody,this.backWheelJoint,this.backDongleRailJoint);
            }
        }
        
        internal function accelerateMotorSpeed(param1:b2Body, param2:b2RevoluteJoint, param3:b2PrismaticJoint) : *
        {
            if(param1)
            {
                if(param2.IsMotorEnabled())
                {
                    param2.EnableMotor(false);
                }
                param3.EnableMotor(true);
                this.acceleratePrisJoint(param3);
            }
            else
            {
                if(!param2.IsMotorEnabled())
                {
                    param2.EnableMotor(true);
                }
                this.accelerateRevoluteJoint(param2);
            }
        }
        
        internal function acceleratePrisJoint(param1:b2PrismaticJoint) : void
        {
            var _loc2_:Number = param1.GetJointSpeed();
            var _loc3_:Number = _loc2_ < this.wheelMaxSpeed ? _loc2_ + this.prisAccelStep : _loc2_;
            param1.SetMotorSpeed(_loc3_);
        }
        
        internal function accelerateRevoluteJoint(param1:b2RevoluteJoint) : void
        {
            var _loc2_:Number = param1.GetJointSpeed();
            var _loc3_:Number = _loc2_ < this.wheelMaxSpeed ? _loc2_ + this.accelStep : _loc2_;
            param1.SetMotorSpeed(_loc3_);
        }
        
        internal function decelerateRevoluteJoint(param1:b2RevoluteJoint) : void
        {
            var _loc3_:Number = NaN;
            var _loc2_:Number = param1.GetJointSpeed();
            if(_loc2_ > 0)
            {
                _loc3_ = 0;
            }
            else
            {
                _loc3_ = _loc2_ > -this.wheelMaxSpeed ? _loc2_ - this.accelStep : _loc2_;
            }
            param1.SetMotorSpeed(_loc3_);
        }
        
        internal function deceleratePrisJoint(param1:b2PrismaticJoint) : void
        {
            var _loc3_:Number = NaN;
            var _loc2_:Number = param1.GetJointSpeed();
            if(_loc2_ > 0)
            {
                _loc3_ = 0;
            }
            else
            {
                _loc3_ = _loc2_ > -this.wheelMaxSpeed ? _loc2_ - this.prisAccelStep : _loc2_;
            }
            param1.SetMotorSpeed(_loc3_);
        }
        
        internal function decelerateMotorSpeed(param1:b2Body, param2:b2RevoluteJoint, param3:b2PrismaticJoint) : *
        {
            if(param1)
            {
                if(!param2.IsMotorEnabled())
                {
                    param2.EnableMotor(false);
                }
                param3.EnableMotor(true);
                this.deceleratePrisJoint(param3);
            }
            else
            {
                if(!param2.IsMotorEnabled())
                {
                    param2.EnableMotor(true);
                }
                this.decelerateRevoluteJoint(param2);
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
                this.decelerateMotorSpeed(this.frontDongleBody,this.frontWheelJoint,this.frontDongleRailJoint);
                this.decelerateMotorSpeed(this.backDongleBody,this.backWheelJoint,this.backDongleRailJoint);
            }
        }
        
        override internal function upAndDownActions() : void
        {
            if(this.frontDongleBody)
            {
                this.frontDongleRailJoint.EnableMotor(false);
            }
            if(this.backDongleBody)
            {
                this.backDongleRailJoint.EnableMotor(false);
            }
            if(this.backWheelJoint.IsMotorEnabled())
            {
                this.backWheelJoint.EnableMotor(false);
                this.frontWheelJoint.EnableMotor(false);
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
                this.connecting = true;
            }
        }
        
        override internal function spaceNullActions() : void
        {
            if(this.ejected)
            {
                releaseGrip();
            }
            this.connecting = false;
            if(this.frontDongleBody)
            {
                this.removeFrontDongle();
            }
            if(this.backDongleBody)
            {
                this.removeBackDongle();
            }
        }
        
        override internal function shiftPressedActions() : void
        {
            if(this.ejected)
            {
                currentPose = 5;
            }
            else
            {
                currentPose = 8;
            }
        }
        
        override internal function shiftNullActions() : void
        {
            if(_currentPose == 5 || _currentPose == 8)
            {
                currentPose = 0;
            }
        }
        
        override internal function ctrlPressedActions() : void
        {
            if(this.ejected)
            {
                currentPose = 6;
            }
            else
            {
                currentPose = 7;
            }
        }
        
        override internal function ctrlNullActions() : void
        {
            if(_currentPose == 6 || _currentPose == 7)
            {
                currentPose = 0;
            }
        }
        
        override internal function zPressedActions() : void
        {
            this.eject();
        }
        
        internal function wheelIsCloseToRail(param1:b2Body, param2:b2Body) : Boolean
        {
            if(Math.abs(param2.GetLocalPoint(param1.GetPosition()).y * m_physScale) > this.railDistanceMin)
            {
                return false;
            }
            var _loc3_:b2PolygonShape = param2.GetShapeList() as b2PolygonShape;
            var _loc4_:b2CircleShape = param1.GetShapeList() as b2CircleShape;
            var _loc5_:Number = Math.abs(_loc3_.GetVertices()[0].x) + _loc4_.m_radius;
            if(Math.abs(param2.GetLocalPoint(param1.GetPosition()).x) > _loc5_)
            {
                return false;
            }
            return true;
        }
        
        internal function dongleRevJointIsCloseToOrigin(param1:b2RevoluteJoint) : Boolean
        {
            var _loc2_:* = param1.GetAnchor1();
            var _loc3_:* = param1.GetAnchor2();
            var _loc4_:Number = _loc3_.x - _loc2_.x;
            var _loc5_:Number = _loc3_.y - _loc2_.y;
            var _loc6_:Number = _loc4_ * _loc4_ + _loc5_ * _loc5_;
            if(_loc6_ > 0.1)
            {
                return false;
            }
            return true;
        }
        
        internal function removeFrontDongle() : *
        {
            _session.m_world.DestroyBody(this.frontDongleBody);
            this.frontDongleBody = null;
            this.frontRailBody = null;
            this.frontDongleRailJoint = null;
            this.oneDongleCounter = 0;
        }
        
        internal function removeBackDongle() : *
        {
            _session.m_world.DestroyBody(this.backDongleBody);
            this.backDongleBody = null;
            this.backRailBody = null;
            this.backDongleRailJoint = null;
            this.oneDongleCounter = 0;
        }
        
        internal function checkRemoveRailJoints() : *
        {
            var _loc1_:Boolean = false;
            if(!this.frontDongleBody && !this.backDongleBody)
            {
                return;
            }
            if(!this.connecting)
            {
                _loc1_ = false;
                if(this.frontDongleBody)
                {
                    this.removeFrontDongle();
                    _loc1_ = true;
                }
                if(this.backDongleBody)
                {
                    this.removeBackDongle();
                    _loc1_ = true;
                }
                if(_loc1_)
                {
                    SoundController.instance.playAreaSoundInstance("DoubleClickReverse",this.frameBody,this.clickVolume);
                }
                return;
            }
            if(this.frontDongleBody)
            {
                if(!this.wheelIsCloseToRail(this.frontWheelBody,this.frontRailBody) || !this.dongleRevJointIsCloseToOrigin(this.frontDongleRevJoint))
                {
                    this.removeFrontDongle();
                }
            }
            if(this.backDongleBody)
            {
                if(!this.wheelIsCloseToRail(this.backWheelBody,this.backRailBody) || !this.dongleRevJointIsCloseToOrigin(this.backDongleRevJoint))
                {
                    this.removeBackDongle();
                }
            }
        }
        
        internal function checkAddRailJoints() : *
        {
            var _loc1_:b2Body = null;
            var _loc2_:Boolean = false;
            var _loc3_:Boolean = false;
            if(this.newFrontWheelRailBody)
            {
                _loc2_ = false;
                if(this.frontDongleBody)
                {
                    _session.m_world.DestroyJoint(this.frontDongleRailJoint);
                }
                else
                {
                    this.frontDongleBody = this.createDongle(this.frontWheelBody,this.frontWheelPos,this.newFrontWheelRailBody);
                    this.frontDongleRevJoint = this.createDongleRevJoint(this.frontDongleBody,this.frontWheelPos);
                    _loc1_ = this.frontDongleBody;
                    _loc2_ = true;
                }
                this.frontDongleRailJoint = this.createPrisJoint(this.frontDongleBody,this.newFrontWheelRailBody,this.frontWheelBody,this.frontWheelPos);
                this.previousFrontRailBody = this.frontRailBody;
                this.frontRailBody = this.newFrontWheelRailBody;
                if(_loc2_)
                {
                    this.addSparkForAttachedWheel(this.frontWheelBody,this.frontRailBody);
                }
                this.newFrontWheelRailBody = null;
            }
            if(this.newBackWheelRailBody)
            {
                _loc3_ = false;
                if(this.backDongleBody)
                {
                    _session.m_world.DestroyJoint(this.backDongleRailJoint);
                }
                else
                {
                    this.backDongleBody = this.createDongle(this.backWheelBody,this.backWheelPos,this.newBackWheelRailBody);
                    this.backDongleRevJoint = this.createDongleRevJoint(this.backDongleBody,this.backWheelPos);
                    _loc1_ = this.backDongleBody;
                    _loc3_ = true;
                }
                this.backDongleRailJoint = this.createPrisJoint(this.backDongleBody,this.newBackWheelRailBody,this.backWheelBody,this.backWheelPos);
                this.previousBackRailBody = this.backRailBody;
                this.backRailBody = this.newBackWheelRailBody;
                if(_loc3_)
                {
                    this.addSparkForAttachedWheel(this.backWheelBody,this.backRailBody);
                }
                this.newBackWheelRailBody = null;
            }
            if(_loc1_)
            {
                SoundController.instance.playAreaSoundInstance("DoubleClick",_loc1_,this.clickVolume);
            }
        }
        
        internal function checkPrisJoint(param1:b2PrismaticJoint, param2:Number, param3:*) : void
        {
            var _loc4_:* = undefined;
            var _loc5_:* = undefined;
            var _loc6_:Number = NaN;
            var _loc7_:Number = NaN;
            var _loc8_:Number = NaN;
            if(Boolean(param1) && !param1.broken)
            {
                _loc4_ = param1.GetAnchor1();
                _loc5_ = param1.GetAnchor2();
                _loc6_ = _loc5_.x - _loc4_.x;
                _loc7_ = _loc5_.y - _loc4_.y;
                _loc8_ = Math.sqrt(_loc6_ * _loc6_ + _loc7_ * _loc7_);
                if(_loc8_ > 0.5)
                {
                    trace("pris joint break!");
                }
            }
        }
        
        override public function actions() : void
        {
            var _loc1_:Number = NaN;
            this.checkRemoveRailJoints();
            if(!this.ejected)
            {
                this.checkAddRailJoints();
            }
            if(this.frontDongleBody)
            {
                this.frontDongleBody.m_linearVelocity.y += GRAVITY_DISPLACEMENT;
            }
            if(this.backDongleBody)
            {
                this.backDongleBody.m_linearVelocity.y += GRAVITY_DISPLACEMENT;
            }
            if(Boolean(this.frontDongleBody) && !this.backDongleBody)
            {
                if(++this.oneDongleCounter == this.oneDongleMax)
                {
                    this.removeFrontDongle();
                }
            }
            if(Boolean(this.backDongleBody) && !this.frontDongleBody)
            {
                if(++this.oneDongleCounter == this.oneDongleMax)
                {
                    this.removeBackDongle();
                }
            }
            if(this.wheelContacts > 0)
            {
                _loc1_ = Math.abs(this.backWheelBody.GetAngularVelocity());
                if(_loc1_ > 50)
                {
                    if(!this.wheelLoop3)
                    {
                        this.wheelLoop3 = SoundController.instance.playAreaSoundLoop("ExplorerRoll3",this.backWheelBody,0);
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
                else if(_loc1_ > 25)
                {
                    if(!this.wheelLoop2)
                    {
                        this.wheelLoop2 = SoundController.instance.playAreaSoundLoop("ExplorerRoll2",this.backWheelBody,0);
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
                else if(_loc1_ > 5)
                {
                    if(!this.wheelLoop1)
                    {
                        this.wheelLoop1 = SoundController.instance.playAreaSoundLoop("ExplorerRoll1",this.backWheelBody,0);
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
            this.hatOn = true;
            this.frameSmashed = false;
            this.ejected = false;
            this.connecting = false;
            this.frontDongleBody = null;
            this.backDongleBody = null;
            this.newFrontWheelRailBody = null;
            this.newBackWheelRailBody = null;
            this.previousFrontRailBody = null;
            this.previousBackRailBody = null;
            this.oneDongleCounter = 0;
            this.destroyFrontDongle = false;
            this.destroyBackDongle = false;
            this.wheelContacts = 0;
        }
        
        override public function die() : void
        {
            super.die();
            this.hatBody = null;
        }
        
        override public function paint() : void
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
        
        override internal function createBodies() : void
        {
            var _loc10_:int = 0;
            var _loc11_:MovieClip = null;
            super.createBodies();
            var _loc1_:b2BodyDef = new b2BodyDef();
            var _loc2_:b2BodyDef = new b2BodyDef();
            var _loc3_:b2BodyDef = new b2BodyDef();
            var _loc4_:b2PolygonDef = new b2PolygonDef();
            var _loc5_:b2CircleDef = new b2CircleDef();
            _loc4_.density = 1.5;
            _loc4_.friction = 0.3;
            _loc4_.restitution = 0.1;
            _loc4_.filter.categoryBits = 514;
            _loc5_.density = 12;
            _loc5_.friction = 1;
            _loc5_.restitution = 0.3;
            _loc5_.filter.groupIndex = groupID;
            _loc5_.filter.categoryBits = 260;
            _loc5_.filter.maskBits = 268;
            this.frameBody = _session.m_world.CreateBody(_loc1_);
            var _loc6_:MovieClip = shapeGuide["frameBottomShape"];
            var _loc7_:b2Vec2 = new b2Vec2(_startX + _loc6_.x / character_scale,_startY + _loc6_.y / character_scale);
            var _loc8_:Number = _loc6_.rotation / oneEightyOverPI;
            _loc4_.SetAsOrientedBox(_loc6_.scaleX * 5 / character_scale,_loc6_.scaleY * 5 / character_scale,_loc7_,_loc8_);
            this.frameBottomShape = this.frameBody.CreateShape(_loc4_);
            _loc4_.vertexCount = 4;
            var _loc9_:Number = 0;
            while(_loc9_ < 2)
            {
                _loc10_ = 0;
                while(_loc10_ < _loc4_.vertexCount)
                {
                    _loc11_ = shapeGuide["sidePoint" + _loc9_ + "_" + _loc10_];
                    trace("x: " + _loc11_.x + " y: " + _loc11_.y);
                    _loc4_.vertices[_loc10_] = new b2Vec2(_startX + _loc11_.x / character_scale,_startY + _loc11_.y / character_scale);
                    _loc10_++;
                }
                if(_loc9_ == 0)
                {
                    this.frameLeftShape = this.frameBody.CreateShape(_loc4_);
                }
                if(_loc9_ == 1)
                {
                    this.frameRightShape = this.frameBody.CreateShape(_loc4_);
                }
                _loc9_++;
            }
            this.frameBody.SetMassFromShapes();
            paintVector.push(this.frameBody);
            _session.contactListener.registerListener(ContactListener.RESULT,this.frameBottomShape,contactResultHandler);
            _session.contactListener.registerListener(ContactListener.RESULT,this.frameLeftShape,contactResultHandler);
            _session.contactListener.registerListener(ContactListener.RESULT,this.frameRightShape,contactResultHandler);
            _loc6_ = shapeGuide["frontWheelShape"];
            this.frontWheelPos = new b2Vec2(_startX + _loc6_.x / character_scale,_startY + _loc6_.y / character_scale);
            _loc2_.position.Set(_startX + _loc6_.x / character_scale,_startY + _loc6_.y / character_scale);
            _loc2_.angle = _loc6_.rotation / oneEightyOverPI;
            _loc5_.radius = _loc6_.width / 2 / character_scale;
            this.frontWheelBody = _session.m_world.CreateBody(_loc2_);
            this.frontWheelShape = this.frontWheelBody.CreateShape(_loc5_);
            this.frontWheelBody.SetMassFromShapes();
            _session.contactListener.registerListener(ContactListener.ADD,this.frontWheelShape,this.wheelContactAdd);
            _session.contactListener.registerListener(ContactListener.REMOVE,this.frontWheelShape,this.wheelContactRemove);
            _session.contactListener.registerListener(ContactListener.RESULT,this.frontWheelShape,this.wheelContactResult);
            _loc6_ = shapeGuide["backWheelShape"];
            this.backWheelPos = new b2Vec2(_startX + _loc6_.x / character_scale,_startY + _loc6_.y / character_scale);
            _loc3_.position.Set(_startX + _loc6_.x / character_scale,_startY + _loc6_.y / character_scale);
            _loc3_.angle = _loc6_.rotation / oneEightyOverPI;
            _loc5_.radius = _loc6_.width / 2 / character_scale;
            this.backWheelBody = _session.m_world.CreateBody(_loc3_);
            this.backWheelShape = this.backWheelBody.CreateShape(_loc5_);
            this.backWheelBody.SetMassFromShapes();
            _session.contactListener.registerListener(ContactListener.ADD,this.backWheelShape,this.wheelContactAdd);
            _session.contactListener.registerListener(ContactListener.REMOVE,this.backWheelShape,this.wheelContactRemove);
            _session.contactListener.registerListener(ContactListener.RESULT,this.backWheelShape,this.wheelContactResult);
        }
        
        override internal function createMovieClips() : void
        {
            super.createMovieClips();
            var _loc1_:MovieClip = sourceObject["cartShards"];
            _session.particleController.createBMDArray("cartshards",_loc1_);
            lowerLeg1MC.visible = false;
            lowerLeg2MC.visible = false;
            this.frameMC = sourceObject["frame"];
            var _loc3_:* = 1 / mc_scale;
            this.frameMC.scaleY = 1 / mc_scale;
            this.frameMC.scaleX = _loc3_;
            this.frontWheelMC = sourceObject["frontWheel"];
            _loc3_ = 1 / mc_scale;
            this.frontWheelMC.scaleY = 1 / mc_scale;
            this.frontWheelMC.scaleX = _loc3_;
            this.backWheelMC = sourceObject["backWheel"];
            _loc3_ = 1 / mc_scale;
            this.backWheelMC.scaleY = 1 / mc_scale;
            this.backWheelMC.scaleX = _loc3_;
            this.hatMC = sourceObject["hat"];
            _loc3_ = 1 / mc_scale;
            this.hatMC.scaleY = 1 / mc_scale;
            this.hatMC.scaleX = _loc3_;
            this.hatMC.visible = false;
            this.cartSmashedMC = sourceObject["cartSmashed"];
            _loc3_ = 1 / mc_scale;
            this.cartSmashedMC.scaleY = 1 / mc_scale;
            this.cartSmashedMC.scaleX = _loc3_;
            this.cartSmashedMC.visible = false;
            this.frameLeftSmashedMC = sourceObject["frameLeftSmashed"];
            _loc3_ = 1 / mc_scale;
            this.frameLeftSmashedMC.scaleY = 1 / mc_scale;
            this.frameLeftSmashedMC.scaleX = _loc3_;
            this.frameLeftSmashedMC.visible = false;
            this.frameRightSmashedMC = sourceObject["frameRightSmashed"];
            _loc3_ = 1 / mc_scale;
            this.frameRightSmashedMC.scaleY = 1 / mc_scale;
            this.frameRightSmashedMC.scaleX = _loc3_;
            this.frameRightSmashedMC.visible = false;
            this.frameBottomSmashedMC = sourceObject["frameBottomSmashed"];
            _loc3_ = 1 / mc_scale;
            this.frameBottomSmashedMC.scaleY = 1 / mc_scale;
            this.frameBottomSmashedMC.scaleX = _loc3_;
            this.frameBottomSmashedMC.visible = false;
            this.engineSmashedMC = sourceObject["engineSmashed"];
            _loc3_ = 1 / mc_scale;
            this.engineSmashedMC.scaleY = 1 / mc_scale;
            this.engineSmashedMC.scaleX = _loc3_;
            this.engineSmashedMC.visible = false;
            this.frameBody.SetUserData(this.frameMC);
            var _loc2_:int = _session.containerSprite.getChildIndex(lowerArm1MC) + 1;
            _session.containerSprite.addChildAt(this.cartSmashedMC,_loc2_);
            _session.containerSprite.addChildAt(this.frontWheelMC,_loc2_);
            _session.containerSprite.addChildAt(this.backWheelMC,_loc2_);
            _session.containerSprite.addChildAt(this.frameMC,_loc2_);
            _session.containerSprite.addChildAt(this.frameLeftSmashedMC,_loc2_);
            _session.containerSprite.addChildAt(this.frameRightSmashedMC,_loc2_);
            _session.containerSprite.addChildAt(this.frameBottomSmashedMC,_loc2_);
            _session.containerSprite.addChildAt(this.engineSmashedMC,_loc2_);
            _session.containerSprite.addChildAt(this.hatMC,_session.containerSprite.getChildIndex(chestMC));
        }
        
        override internal function resetMovieClips() : void
        {
            super.resetMovieClips();
            this.frameBody.SetUserData(this.frameMC);
            this.hatMC.visible = false;
            head1MC.helmet.visible = true;
            this.frameMC.visible = true;
            this.frameLeftSmashedMC.visible = false;
            this.frameRightSmashedMC.visible = false;
            this.frameBottomSmashedMC.visible = false;
            this.cartSmashedMC.visible = false;
            lowerLeg1MC.visible = false;
            lowerLeg2MC.visible = false;
            this.engineSmashedMC.visible = false;
            var _loc1_:MovieClip = sourceObject["cartShards"];
            _session.particleController.createBMDArray("cartshards",_loc1_);
        }
        
        override internal function createDictionaries() : void
        {
            super.createDictionaries();
            this.hatShape = head1Shape;
            contactImpulseDict[this.hatShape] = this.hatSmashLimit;
            contactImpulseDict[this.frontWheelShape] = this.wheelSparkLimit;
            contactImpulseDict[this.backWheelShape] = this.wheelSparkLimit;
            contactImpulseDict[this.frameLeftShape] = contactImpulseDict[this.frameRightShape] = contactImpulseDict[this.frameBottomShape] = this.frameSmashLimit;
            contactAddSounds[this.backWheelShape] = "CarTire1";
            contactAddSounds[this.frontWheelShape] = "CarTire1";
        }
        
        override protected function handleContactResults() : void
        {
            var _loc1_:ContactEvent = null;
            if(contactResultBuffer[this.hatShape])
            {
                _loc1_ = contactResultBuffer[this.hatShape];
                this.hatSmash(_loc1_.impulse);
                delete contactResultBuffer[head1Shape];
                delete contactAddBuffer[head1Shape];
            }
            if(contactResultBuffer[this.frontWheelShape])
            {
                delete contactResultBuffer[this.frontWheelShape];
            }
            if(contactResultBuffer[this.backWheelShape])
            {
                delete contactResultBuffer[this.backWheelShape];
            }
            if(contactResultBuffer[this.frameBottomShape])
            {
                this.frameSmash(contactResultBuffer[this.frameBottomShape]);
            }
            if(contactResultBuffer[this.frameLeftShape])
            {
                this.frameSmash(contactResultBuffer[this.frameLeftShape]);
            }
            if(contactResultBuffer[this.frameRightShape])
            {
                this.frameSmash(contactResultBuffer[this.frameRightShape]);
            }
            super.handleContactResults();
        }
        
        protected function addSparkForAttachedWheel(param1:b2Body, param2:b2Body) : *
        {
            var _loc3_:Number = param2.GetAngle();
            var _loc4_:b2CircleShape = param1.GetShapeList() as b2CircleShape;
            var _loc5_:b2Vec2 = new b2Vec2(Math.sin(param1.GetAngle() - _loc3_) * _loc4_.m_radius,Math.cos(param1.GetAngle() - _loc3_) * _loc4_.m_radius);
            var _loc6_:b2Vec2 = param1.GetWorldPoint(_loc5_);
            _session.particleController.createSparkBurstPoint(_loc6_,new b2Vec2(0.5,0.5),0.25,25,20);
        }
        
        protected function addWheelSpark(param1:b2Shape) : void
        {
            var _loc2_:ContactEvent = contactResultBuffer[param1];
            var _loc3_:b2Vec2 = _loc2_.position;
            var _loc4_:Number = Math.min((_loc2_.impulse - this.wheelSparkLimit) / 20,1);
            _session.particleController.createSparkBurstPoint(_loc3_,new b2Vec2(3 * _loc4_,3 * _loc4_),1,50,20);
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
            if(_loc2_ == this.frontWheelShape)
            {
                this.frontWheelContactPoint = param1;
            }
            else
            {
                this.backWheelContactPoint = param1;
            }
        }
        
        protected function wheelContactRemove(param1:b2ContactPoint) : void
        {
            if(param1.shape2.m_isSensor)
            {
                return;
            }
            --this.wheelContacts;
            if(param1.shape2.GetMaterial() & 4)
            {
                if(param1.shape1 == this.frontWheelShape && param1.shape2.GetBody() == this.frontRailBody)
                {
                    this.destroyFrontDongle = true;
                }
                if(param1.shape1 == this.backWheelShape && param1.shape2.GetBody() == this.backRailBody)
                {
                    this.destroyBackDongle = true;
                }
            }
        }
        
        protected function wheelContactResult(param1:ContactEvent) : void
        {
            var _loc2_:b2Shape = param1.shape;
            var _loc3_:Number = param1.impulse;
            if(_loc3_ > contactImpulseDict[_loc2_])
            {
                if(contactResultBuffer[_loc2_])
                {
                    if(_loc3_ > contactResultBuffer[_loc2_].impulse)
                    {
                        contactResultBuffer[_loc2_] = param1;
                    }
                }
                else
                {
                    contactResultBuffer[_loc2_] = param1;
                }
            }
            if(this.connecting)
            {
                if(param1.otherShape.GetMaterial() & 4)
                {
                    if(param1.shape == this.frontWheelShape && !this.newFrontWheelRailBody && this.frontRailBody != param1.otherShape.GetBody())
                    {
                        this.newFrontWheelRailBody = param1.otherShape.GetBody();
                    }
                    if(param1.shape == this.backWheelShape && !this.newBackWheelRailBody && this.backRailBody != param1.otherShape.GetBody())
                    {
                        this.newBackWheelRailBody = param1.otherShape.GetBody();
                    }
                }
            }
        }
        
        private function createDongleRevJoint(param1:b2Body, param2:b2Vec2) : b2RevoluteJoint
        {
            var _loc3_:b2RevoluteJointDef = new b2RevoluteJointDef();
            _loc3_.collideConnected = false;
            _loc3_.Initialize(param1,this.frameBody,param1.GetPosition());
            _loc3_.localAnchor1 = new b2Vec2(0,0);
            _loc3_.localAnchor2 = param2;
            _loc3_.maxMotorTorque = 300;
            return _session.m_world.CreateJoint(_loc3_) as b2RevoluteJoint;
        }
        
        private function createDongle(param1:b2Body, param2:b2Vec2, param3:b2Body) : b2Body
        {
            var _loc4_:b2BodyDef = new b2BodyDef();
            _loc4_.position = this.frameBody.GetWorldPoint(param2);
            _loc4_.fixedRotation = true;
            _loc4_.angle = param3.GetAngle();
            var _loc5_:b2PolygonDef = new b2PolygonDef();
            _loc5_.SetAsBox(0.25,0.25);
            _loc5_.density = 375;
            _loc5_.isSensor = true;
            var _loc6_:b2Body = _session.m_world.CreateBody(_loc4_);
            _loc6_.CreateShape(_loc5_);
            _loc6_.SetMassFromShapes();
            return _loc6_;
        }
        
        private function getPrisJointSpeed(param1:b2Body, param2:b2Body, param3:b2Body) : Number
        {
            var _loc4_:Number = param2.GetAngle();
            var _loc5_:b2Vec2 = new b2Vec2(Math.cos(_loc4_),Math.sin(_loc4_));
            var _loc6_:b2Vec2 = param1.GetLinearVelocity();
            var _loc7_:Number = b2Math.b2Dot(_loc6_,_loc5_);
            _loc5_.Multiply(_loc7_);
            param3.SetLinearVelocity(_loc5_);
            return _loc7_;
        }
        
        private function createPrisJoint(param1:b2Body, param2:b2Body, param3:b2Body, param4:b2Vec2) : b2PrismaticJoint
        {
            var _loc7_:b2PrismaticJoint = null;
            var _loc5_:Number = param2.GetAngle();
            var _loc6_:Number = _loc5_ + Math.PI / 2;
            var _loc8_:b2PrismaticJointDef = new b2PrismaticJointDef();
            _loc8_.motorSpeed = this.getPrisJointSpeed(param3,param2,param1);
            _loc8_.enableMotor = true;
            _loc8_.maxMotorForce = 1000;
            var _loc9_:b2Vec2 = this.frameBody.GetWorldPoint(param4);
            var _loc10_:b2Vec2 = param2.GetLocalPoint(_loc9_);
            _loc10_.y = this.railJointY;
            var _loc11_:b2Vec2 = param1.GetWorldCenter();
            _loc8_.Initialize(param1,param2,param2.GetWorldPoint(_loc10_),new b2Vec2(-Math.sin(_loc6_),Math.cos(_loc6_)));
            _loc8_.enableMotor = false;
            _loc8_.localAnchor1 = new b2Vec2(0,0);
            _loc8_.localAnchor2 = _loc10_;
            return _session.m_world.CreateJoint(_loc8_) as b2PrismaticJoint;
        }
        
        override internal function createJoints() : void
        {
            var _loc1_:Number = NaN;
            var _loc2_:Number = NaN;
            var _loc3_:Number = NaN;
            var _loc7_:MovieClip = null;
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
            _loc5_.collideConnected = false;
            var _loc6_:b2Vec2 = new b2Vec2();
            _loc5_.upperTranslation = 0;
            _loc5_.lowerTranslation = -1.5;
            _loc5_.maxMotorForce = 600;
            _loc5_.enableMotor = true;
            _loc5_.motorSpeed = 0.75;
            var _loc8_:b2RevoluteJointDef = new b2RevoluteJointDef();
            _loc8_.maxMotorTorque = this.maxTorque;
            _loc7_ = shapeGuide["frontWheelShape"];
            _loc6_.Set(_startX + _loc7_.x / character_scale,_startY + _loc7_.y / character_scale);
            _loc8_.Initialize(this.frameBody,this.frontWheelBody,_loc6_);
            this.frontWheelJoint = _session.m_world.CreateJoint(_loc8_) as b2RevoluteJoint;
            _loc7_ = shapeGuide["backWheelShape"];
            _loc6_.Set(_startX + _loc7_.x / character_scale,_startY + _loc7_.y / character_scale);
            _loc8_.Initialize(this.frameBody,this.backWheelBody,_loc6_);
            this.backWheelJoint = _session.m_world.CreateJoint(_loc8_) as b2RevoluteJoint;
            _loc7_ = shapeGuide["footAnchor"];
            _loc6_.Set(_startX + _loc7_.x / character_scale,_startY + _loc7_.y / character_scale);
            _loc8_.enableLimit = true;
            _loc8_.lowerAngle = -15 / _loc4_;
            _loc8_.upperAngle = 15 / _loc4_;
            _loc8_.Initialize(lowerLeg1Body,this.frameBody,_loc6_);
            this.cartFoot1Joint = _session.m_world.CreateJoint(_loc8_) as b2RevoluteJoint;
            _loc8_.Initialize(lowerLeg2Body,this.frameBody,_loc6_);
            this.cartFoot2Joint = _session.m_world.CreateJoint(_loc8_) as b2RevoluteJoint;
            _loc7_ = shapeGuide["handAnchor"];
            _loc6_.Set(_startX + _loc7_.x / character_scale,_startY + _loc7_.y / character_scale);
            _loc8_.enableLimit = false;
            _loc8_.lowerAngle = -15 / _loc4_;
            _loc8_.upperAngle = 15 / _loc4_;
            _loc8_.Initialize(lowerArm1Body,this.frameBody,_loc6_);
            this.frameHand1Joint = _session.m_world.CreateJoint(_loc8_) as b2RevoluteJoint;
            _loc8_.Initialize(lowerArm2Body,this.frameBody,_loc6_);
            this.frameHand2Joint = _session.m_world.CreateJoint(_loc8_) as b2RevoluteJoint;
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
            if(this.frameHand1Joint)
            {
                _loc1_.DestroyJoint(this.frameHand1Joint);
                this.frameHand1Joint = null;
            }
            if(this.frameHand2Joint)
            {
                _loc1_.DestroyJoint(this.frameHand2Joint);
                this.frameHand2Joint = null;
            }
            if(this.cartFoot1Joint)
            {
                _loc1_.DestroyJoint(this.cartFoot1Joint);
                this.cartFoot1Joint = null;
            }
            if(this.cartFoot2Joint)
            {
                _loc1_.DestroyJoint(this.cartFoot2Joint);
                this.cartFoot2Joint = null;
            }
            var _loc2_:b2FilterData = zeroFilter.Copy();
            _loc2_.groupIndex = -2;
            _loc1_.Refilter(this.frontWheelBody.GetShapeList());
            _loc1_.Refilter(this.backWheelBody.GetShapeList());
            var _loc3_:b2Shape = this.frameBody.GetShapeList();
            while(_loc3_)
            {
                _loc3_.SetFilterData(_loc2_);
                _loc1_.Refilter(_loc3_);
                _loc3_ = _loc3_.m_next;
            }
            lowerArm1MC.hand.gotoAndStop(2);
            lowerArm2MC.hand.gotoAndStop(2);
            if(!lowerLeg1MC.visible)
            {
                lowerLeg1MC.visible = true;
            }
            if(!lowerLeg2MC.visible)
            {
                lowerLeg2MC.visible = true;
            }
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
                this.backWheelJoint.EnableMotor(false);
                this.frontWheelJoint.EnableMotor(false);
                if(voiceSound)
                {
                    voiceSound.stopSound();
                    voiceSound = null;
                }
            }
        }
        
        internal function frameSmash(param1:Number) : void
        {
            var _loc2_:b2Vec2 = null;
            var _loc14_:b2Body = null;
            var _loc15_:MovieClip = null;
            this.eject();
            trace("frame impulse " + param1 + " -> " + _session.iteration);
            delete contactResultBuffer[this.frameBottomShape];
            delete contactResultBuffer[this.frameLeftShape];
            delete contactResultBuffer[this.frameRightShape];
            this.frontWheelShape.SetFilterData(zeroFilter);
            this.backWheelShape.SetFilterData(zeroFilter);
            _session.contactListener.deleteListener(ContactListener.RESULT,this.frameBottomShape);
            _session.contactListener.deleteListener(ContactListener.RESULT,this.frameLeftShape);
            _session.contactListener.deleteListener(ContactListener.RESULT,this.frameRightShape);
            _session.contactListener.deleteListener(ContactListener.ADD,this.frontWheelShape);
            _session.contactListener.deleteListener(ContactListener.ADD,this.backWheelShape);
            if(this.frontDongleBody)
            {
                this.removeFrontDongle();
            }
            if(this.backDongleBody)
            {
                this.removeBackDongle();
            }
            var _loc3_:b2Vec2 = this.frameBody.GetPosition();
            var _loc4_:Number = this.frameBody.GetAngle();
            var _loc5_:Number = this.frameBody.GetAngularVelocity();
            var _loc6_:b2BodyDef = new b2BodyDef();
            _loc6_.position = _loc3_;
            _loc6_.angle = _loc4_;
            var _loc7_:b2PolygonDef = new b2PolygonDef();
            _loc7_.density = 1.5;
            _loc7_.friction = 0.3;
            _loc7_.restitution = 0.1;
            _loc7_.filter.categoryBits = 514;
            var _loc8_:Array = new Array();
            var _loc9_:b2Body = _session.m_world.CreateBody(_loc6_);
            _loc8_.push(_loc9_);
            var _loc10_:MovieClip = shapeGuide["cartBottomShape"];
            _loc2_ = new b2Vec2(_startX + _loc10_.x / character_scale,_startY + _loc10_.y / character_scale);
            var _loc11_:Number = _loc10_.rotation / oneEightyOverPI;
            _loc7_.SetAsOrientedBox(_loc10_.scaleX * 5 / character_scale,_loc10_.scaleY * 5 / character_scale,_loc2_,_loc11_);
            _loc9_.CreateShape(_loc7_);
            _loc10_ = shapeGuide["cartLeftShape"];
            _loc11_ = _loc10_.rotation / oneEightyOverPI;
            _loc2_ = new b2Vec2(_startX + _loc10_.x / character_scale,_startY + _loc10_.y / character_scale);
            _loc7_.SetAsOrientedBox(_loc10_.scaleX * 5 / character_scale,_loc10_.scaleY * 5 / character_scale,_loc2_,_loc11_);
            _loc9_.CreateShape(_loc7_);
            _loc10_ = shapeGuide["cartRightShape"];
            _loc11_ = _loc10_.rotation / oneEightyOverPI;
            _loc2_ = new b2Vec2(_startX + _loc10_.x / character_scale,_startY + _loc10_.y / character_scale);
            _loc7_.SetAsOrientedBox(_loc10_.scaleX * 5 / character_scale,_loc10_.scaleY * 5 / character_scale,_loc2_,_loc11_);
            _loc9_.CreateShape(_loc7_);
            _loc9_.SetMassFromShapes();
            _loc9_.SetLinearVelocity(this.frameBody.GetLinearVelocityFromLocalPoint(_loc9_.GetLocalCenter()));
            _loc9_.SetAngularVelocity(_loc5_);
            SoundController.instance.playAreaSoundInstance("MetalSmashHeavy",_loc9_);
            _loc9_ = _session.m_world.CreateBody(_loc6_);
            _loc8_.push(_loc9_);
            _loc10_ = shapeGuide["frameLeftShape"];
            _loc11_ = _loc10_.rotation / oneEightyOverPI;
            _loc2_ = new b2Vec2(_startX + _loc10_.x / character_scale,_startY + _loc10_.y / character_scale);
            _loc7_.SetAsOrientedBox(_loc10_.scaleX * 5 / character_scale,_loc10_.scaleY * 5 / character_scale,_loc2_,_loc11_);
            _loc9_.CreateShape(_loc7_);
            _loc9_.SetMassFromShapes();
            _loc9_.SetLinearVelocity(this.frameBody.GetLinearVelocityFromLocalPoint(_loc9_.GetLocalCenter()));
            _loc9_.SetAngularVelocity(_loc5_);
            _loc9_ = _session.m_world.CreateBody(_loc6_);
            _loc8_.push(_loc9_);
            _loc10_ = shapeGuide["frameRightShape"];
            _loc11_ = _loc10_.rotation / oneEightyOverPI;
            _loc2_ = new b2Vec2(_startX + _loc10_.x / character_scale,_startY + _loc10_.y / character_scale);
            _loc7_.SetAsOrientedBox(_loc10_.scaleX * 5 / character_scale,_loc10_.scaleY * 5 / character_scale,_loc2_,_loc11_);
            _loc9_.CreateShape(_loc7_);
            _loc9_.SetMassFromShapes();
            _loc9_.SetLinearVelocity(this.frameBody.GetLinearVelocityFromLocalPoint(_loc9_.GetLocalCenter()));
            _loc9_.SetAngularVelocity(_loc5_);
            _loc9_ = _session.m_world.CreateBody(_loc6_);
            _loc8_.push(_loc9_);
            _loc10_ = shapeGuide["frame2BottomShape"];
            _loc11_ = _loc10_.rotation / oneEightyOverPI;
            _loc2_ = new b2Vec2(_startX + _loc10_.x / character_scale,_startY + _loc10_.y / character_scale);
            _loc7_.SetAsOrientedBox(_loc10_.scaleX * 5 / character_scale,_loc10_.scaleY * 5 / character_scale,_loc2_,_loc11_);
            _loc9_.CreateShape(_loc7_);
            _loc9_.SetMassFromShapes();
            _loc9_.SetLinearVelocity(this.frameBody.GetLinearVelocityFromLocalPoint(_loc9_.GetLocalCenter()));
            _loc9_.SetAngularVelocity(_loc5_);
            _loc9_ = _session.m_world.CreateBody(_loc6_);
            _loc8_.push(_loc9_);
            _loc10_ = shapeGuide["engineShape"];
            _loc11_ = _loc10_.rotation / oneEightyOverPI;
            _loc2_ = new b2Vec2(_startX + _loc10_.x / character_scale,_startY + _loc10_.y / character_scale);
            _loc7_.SetAsOrientedBox(_loc10_.scaleX * 5 / character_scale,_loc10_.scaleY * 5 / character_scale,_loc2_,_loc11_);
            _loc9_.CreateShape(_loc7_);
            _loc9_.SetMassFromShapes();
            _loc9_.SetLinearVelocity(this.frameBody.GetLinearVelocityFromLocalPoint(_loc9_.GetLocalCenter()));
            _loc9_.SetAngularVelocity(_loc5_);
            _session.particleController.createBurst("cartshards",30,30,_loc9_,50);
            var _loc12_:Array = new Array(this.cartSmashedMC,this.frameLeftSmashedMC,this.frameRightSmashedMC,this.frameBottomSmashedMC,this.engineSmashedMC);
            var _loc13_:int = 0;
            while(_loc13_ < _loc12_.length)
            {
                _loc14_ = _loc8_[_loc13_];
                _loc15_ = _loc12_[_loc13_];
                _loc15_.visible = true;
                _loc14_.SetUserData(_loc15_);
                paintVector.push(_loc14_);
                _loc13_++;
            }
            _session.m_world.DestroyBody(this.frameBody);
            this.frameMC.visible = false;
        }
        
        internal function hatSmash(param1:Number) : void
        {
            var _loc6_:MovieClip = null;
            delete contactImpulseDict[this.hatShape];
            head1Shape = this.hatShape;
            contactImpulseDict[head1Shape] = headSmashLimit;
            this.hatShape = null;
            this.hatOn = false;
            var _loc2_:b2PolygonDef = new b2PolygonDef();
            var _loc3_:b2BodyDef = new b2BodyDef();
            _loc2_.density = 1;
            _loc2_.friction = 0.3;
            _loc2_.restitution = 0.1;
            _loc2_.filter = zeroFilter;
            var _loc4_:b2Vec2 = head1Body.GetPosition();
            _loc3_.position = _loc4_;
            _loc3_.angle = head1Body.GetAngle();
            _loc3_.userData = this.hatMC;
            this.hatMC.visible = true;
            head1MC.helmet.visible = false;
            _loc2_.vertexCount = 4;
            var _loc5_:int = 0;
            while(_loc5_ < 4)
            {
                _loc6_ = shapeGuide["helmetVert" + [_loc5_ + 1]];
                _loc2_.vertices[_loc5_] = new b2Vec2(_loc6_.x / character_scale,_loc6_.y / character_scale);
                _loc5_++;
            }
            this.hatBody = _session.m_world.CreateBody(_loc3_);
            this.hatBody.CreateShape(_loc2_);
            this.hatBody.SetMassFromShapes();
            this.hatBody.SetLinearVelocity(head1Body.GetLinearVelocity());
            this.hatBody.SetAngularVelocity(head1Body.GetAngularVelocity());
            paintVector.push(this.hatBody);
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
            if(this.frameHand1Joint)
            {
                _session.m_world.DestroyJoint(this.frameHand1Joint);
                this.frameHand1Joint = null;
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
            if(this.frameHand2Joint)
            {
                _session.m_world.DestroyJoint(this.frameHand2Joint);
                this.frameHand2Joint = null;
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
            if(this.cartFoot1Joint)
            {
                _session.m_world.DestroyJoint(this.cartFoot1Joint);
                this.cartFoot1Joint = null;
            }
            if(!lowerLeg1MC.visible)
            {
                lowerLeg1MC.visible = true;
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
            if(this.cartFoot2Joint)
            {
                _session.m_world.DestroyJoint(this.cartFoot2Joint);
                this.cartFoot2Joint = null;
            }
            if(!lowerLeg2MC.visible)
            {
                lowerLeg2MC.visible = true;
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
            if(this.frameHand1Joint)
            {
                trace("REMOVE FRAME HAND 1");
                _session.m_world.DestroyJoint(this.frameHand1Joint);
                this.frameHand1Joint = null;
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
            if(this.frameHand2Joint)
            {
                _session.m_world.DestroyJoint(this.frameHand2Joint);
                this.frameHand2Joint = null;
                this.checkEject();
            }
        }
        
        internal function checkEject() : void
        {
            if(!this.frameHand1Joint && !this.frameHand2Joint && !this.cartFoot1Joint && !this.cartFoot2Joint)
            {
                this.eject();
            }
        }
        
        override internal function kneeBreak1(param1:Number) : void
        {
            super.kneeBreak1(param1);
            if(this.ejected)
            {
                return;
            }
            if(this.cartFoot1Joint)
            {
                _session.m_world.DestroyJoint(this.cartFoot1Joint);
                this.cartFoot1Joint = null;
            }
            if(!lowerLeg1MC.visible)
            {
                lowerLeg1MC.visible = true;
            }
            this.checkEject();
        }
        
        override internal function kneeBreak2(param1:Number) : void
        {
            super.kneeBreak2(param1);
            if(this.cartFoot2Joint)
            {
                _session.m_world.DestroyJoint(this.cartFoot2Joint);
                this.cartFoot2Joint = null;
            }
            if(!lowerLeg2MC.visible)
            {
                lowerLeg2MC.visible = true;
            }
            this.checkEject();
        }
        
        internal function leanBackPose() : void
        {
            setJoint(kneeJoint1,45,10);
            setJoint(kneeJoint2,45,10);
            setJoint(hipJoint1,-45 / oneEightyOverPI,10);
            setJoint(hipJoint2,-45 / oneEightyOverPI,10);
        }
        
        internal function leanForwardPose() : void
        {
            setJoint(kneeJoint1,0 / oneEightyOverPI,10);
            setJoint(kneeJoint2,0 / oneEightyOverPI,10);
            setJoint(hipJoint1,0 / oneEightyOverPI,10);
            setJoint(hipJoint2,0 / oneEightyOverPI,10);
            setJoint(elbowJoint1,-15 / oneEightyOverPI,10);
            setJoint(elbowJoint2,-15 / oneEightyOverPI,10);
        }
        
        internal function squatPose() : void
        {
            setJoint(elbowJoint1,-90 / oneEightyOverPI,10);
            setJoint(elbowJoint2,-90 / oneEightyOverPI,10);
            setJoint(kneeJoint1,1.5,10);
            setJoint(kneeJoint2,1.5,10);
        }
        
        internal function straightLegPose() : void
        {
            setJoint(kneeJoint1,0,10);
            setJoint(kneeJoint2,0,10);
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
                case this.hatShape:
                    if(param2 > 0.85)
                    {
                        this.hatSmash(0);
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
                    if(param2 > _loc4_)
                    {
                        this.chestSmash(0);
                    }
                    break;
                case pelvisShape:
                    _loc5_ = pelvisBody.GetMass() / DEF_PELVIS_MASS;
                    _loc4_ = Math.max(1 - 0.15 * _loc5_,0.7);
                    if(param2 > _loc4_)
                    {
                        this.pelvisSmash(0);
                    }
            }
        }
    }
}

