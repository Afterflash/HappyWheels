package com.totaljerkface.game.character
{
    import Box2D.Collision.Shapes.*;
    import Box2D.Collision.b2ContactPoint;
    import Box2D.Common.Math.b2Math;
    import Box2D.Common.Math.b2Vec2;
    import Box2D.Dynamics.*;
    import Box2D.Dynamics.Joints.*;
    import com.totaljerkface.game.*;
    import com.totaljerkface.game.events.ContactEvent;
    import com.totaljerkface.game.particles.SnowSpray;
    import com.totaljerkface.game.sound.AreaSoundLoop;
    import com.totaljerkface.game.sound.SoundController;
    import flash.display.*;
    import flash.events.*;
    import flash.filters.BevelFilter;
    
    public class SantaClaus extends CharacterB2D
    {
        protected var elf1:SleighElf;
        
        protected var elf2:SleighElf;
        
        protected var ejected:Boolean;
        
        protected var ejectImpulse:Number = 0;
        
        protected var frontContacts:int = 0;
        
        protected var backContacts:int = 0;
        
        internal const wheelMaxSpeed:Number = 30;
        
        internal const accelStep:Number = 1.25;
        
        internal const maxTorque:Number = 100000;
        
        internal const gravityDisplacement:Number = -0.3333333333333333;
        
        protected const helmetSmashLimit:Number = 2;
        
        protected const sleighSmashLimit:Number = 200;
        
        protected var impulseLeft:Number = 1.3;
        
        protected var impulseRight:Number = 1.7;
        
        protected var impulseOffset:Number = 1;
        
        protected var maxSpinAV:Number = 3.5;
        
        protected var pumpCounter:Number = 0;
        
        internal var wheelRadius:Number;
        
        protected var wheelMultiplier:Number;
        
        protected var wheelCurrentSpeed:Number;
        
        protected var wheelNewSpeed:Number;
        
        protected var pelvisAnchorPoint:b2Vec2;
        
        protected var leg1AnchorPoint:b2Vec2;
        
        protected var leg2AnchorPoint:b2Vec2;
        
        internal var antiGravArray:Array;
        
        private var boostVal:Number = 0;
        
        private var boostMax:int = 50;
        
        private var boostStepUp:Number = 0.5;
        
        private var boostStepDown:Number = 0.5;
        
        private var boostMeter:Sprite;
        
        private var boostHolder:Sprite;
        
        protected var snowSpray:SnowSpray;
        
        public var sleighBody:b2Body;
        
        protected var frontWheelBody:b2Body;
        
        protected var midWheel1Body:b2Body;
        
        protected var midWheel2Body:b2Body;
        
        protected var backWheelBody:b2Body;
        
        protected var reignsBody:b2Body;
        
        protected var helmetBody:b2Body;
        
        protected var boxBodies:Array;
        
        protected var helmetShape:b2Shape;
        
        protected var rearShape:b2PolygonShape;
        
        protected var backShape:b2PolygonShape;
        
        protected var skiShape:b2PolygonShape;
        
        protected var seatShape:b2PolygonShape;
        
        protected var frontShape:b2PolygonShape;
        
        protected var bumperShape:b2CircleShape;
        
        protected var baseShape:b2PolygonShape;
        
        protected var stem1Shape:b2PolygonShape;
        
        protected var stem2Shape:b2PolygonShape;
        
        protected var stem3Shape:b2PolygonShape;
        
        protected var backWheelShape:b2Shape;
        
        protected var midWheel1Shape:b2Shape;
        
        protected var midWheel2Shape:b2Shape;
        
        protected var frontWheelShape:b2Shape;
        
        protected var helmetMC:MovieClip;
        
        protected var sleighMC:MovieClip;
        
        protected var strapsSprite:Sprite;
        
        protected var brokenSleighMCs:Array;
        
        protected var brokenSkiMCs:Array;
        
        protected var boxMCs:Array;
        
        protected var bells:Array;
        
        protected var stemMC:MovieClip;
        
        protected var sleighPelvis:b2RevoluteJoint;
        
        protected var sleighFoot1:b2RevoluteJoint;
        
        protected var sleighFoot2:b2RevoluteJoint;
        
        protected var sleighReigns:b2PrismaticJoint;
        
        protected var reignsHand1:b2RevoluteJoint;
        
        protected var reignsHand2:b2RevoluteJoint;
        
        protected var frontWheelJoint:b2RevoluteJoint;
        
        protected var midWheel1Joint:b2RevoluteJoint;
        
        protected var midWheel2Joint:b2RevoluteJoint;
        
        protected var backWheelJoint:b2RevoluteJoint;
        
        protected var strapHeadJoints:Array;
        
        protected var strapChest1Joints:Array;
        
        protected var strapChest2Joints:Array;
        
        protected var vertsBrokenSleigh:Array;
        
        protected var vertsBrokenSki:Array;
        
        protected var vertsBrokenStem:Array;
        
        protected var newBaseVerts:Array;
        
        protected var skiLoop:AreaSoundLoop;
        
        protected var sleighBellLoop:AreaSoundLoop;
        
        public function SantaClaus(param1:Number, param2:Number, param3:DisplayObject, param4:Session)
        {
            super(param1,param2,param3,param4,-1,"Santa");
            shapeRefScale = 50;
            this.elf1 = new SleighElf(param1,param2,param3["elf1"],param4,-2,"Elf1",this,35);
            this.elf2 = new SleighElf(param1,param2,param3["elf2"],param4,-4,"Elf1",this,70);
        }
        
        override public function set session(param1:Session) : void
        {
            _session = param1;
            if(this.elf1)
            {
                this.elf1.session = _session;
            }
            if(this.elf2)
            {
                this.elf2.session = _session;
            }
        }
        
        override public function checkKeyStates() : void
        {
            super.checkKeyStates();
            this.checkElfKeys(this.elf1);
            this.checkElfKeys(this.elf2);
        }
        
        private function checkElfKeys(param1:SleighElf) : void
        {
            if(!param1.dead)
            {
                if(param1.userVehicle)
                {
                    param1.userVehicle.operateKeys(_session.iteration,leftPressed,rightPressed,upPressed,downPressed,spacePressed,shiftPressed,ctrlPressed,zPressed);
                }
                else
                {
                    if(leftPressed)
                    {
                        if(rightPressed)
                        {
                            param1.leftAndRightActions();
                        }
                        else
                        {
                            param1.leftPressedActions();
                        }
                    }
                    else if(rightPressed)
                    {
                        param1.rightPressedActions();
                    }
                    else
                    {
                        param1.leftAndRightActions();
                    }
                    if(upPressed)
                    {
                        if(downPressed)
                        {
                            param1.upAndDownActions();
                        }
                        else
                        {
                            param1.upPressedActions();
                        }
                    }
                    else if(downPressed)
                    {
                        param1.downPressedActions();
                    }
                    else
                    {
                        param1.upAndDownActions();
                    }
                    if(spacePressed)
                    {
                        param1.spacePressedActions();
                    }
                    else
                    {
                        param1.spaceNullActions();
                    }
                    if(shiftPressed)
                    {
                        param1.shiftPressedActions();
                    }
                    else
                    {
                        param1.shiftNullActions();
                    }
                    if(ctrlPressed)
                    {
                        param1.ctrlPressedActions();
                    }
                    else
                    {
                        param1.ctrlNullActions();
                    }
                    if(zPressed)
                    {
                        param1.zPressedActions();
                    }
                    else
                    {
                        param1.zNullActions();
                    }
                }
            }
        }
        
        override public function checkReplayData(param1:KeyDisplay, param2:String) : void
        {
            super.checkReplayData(param1,param2);
            this.checkElfReplayData(param1,param2,this.elf1);
            this.checkElfReplayData(param1,param2,this.elf2);
        }
        
        private function checkElfReplayData(param1:KeyDisplay, param2:String, param3:SleighElf) : void
        {
            if(!param3.dead)
            {
                if(param3.userVehicle)
                {
                    param3.userVehicle.operateReplayData(_session.iteration,param2);
                }
                else
                {
                    if(param2.charAt(0) == "1")
                    {
                        if(param2.charAt(1) == "1")
                        {
                            param3.leftAndRightActions();
                        }
                        else
                        {
                            param3.leftPressedActions();
                        }
                    }
                    else if(param2.charAt(1) == "1")
                    {
                        param3.rightPressedActions();
                    }
                    else
                    {
                        param3.leftAndRightActions();
                    }
                    if(param2.charAt(2) == "1")
                    {
                        if(param2.charAt(3) == "1")
                        {
                            param3.upAndDownActions();
                        }
                        else
                        {
                            param3.upPressedActions();
                        }
                    }
                    else if(param2.charAt(3) == "1")
                    {
                        param3.downPressedActions();
                    }
                    else
                    {
                        param3.upAndDownActions();
                    }
                    if(param2.charAt(4) == "1")
                    {
                        param3.spacePressedActions();
                    }
                    else
                    {
                        param3.spaceNullActions();
                    }
                    if(param2.charAt(5) == "1")
                    {
                        param3.shiftPressedActions();
                    }
                    else
                    {
                        param3.shiftNullActions();
                    }
                    if(param2.charAt(6) == "1")
                    {
                        param3.ctrlPressedActions();
                    }
                    else
                    {
                        param3.ctrlNullActions();
                    }
                    if(param2.charAt(7) == "1")
                    {
                        param3.zPressedActions();
                    }
                    else
                    {
                        param3.zNullActions();
                    }
                }
            }
        }
        
        override protected function switchCamera() : void
        {
            if(_session.camera.focus == cameraFocus)
            {
                _session.camera.focus = this.elf1.cameraFocus;
            }
            else if(_session.camera.focus == this.elf1.cameraFocus)
            {
                _session.camera.focus = this.elf2.cameraFocus;
            }
            else
            {
                _session.camera.focus = cameraFocus;
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
                _loc1_ = this.sleighBody.GetAngle();
                _loc2_ = this.sleighBody.GetAngularVelocity();
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
                _loc6_ = this.sleighBody.GetLocalCenter();
                this.sleighBody.ApplyImpulse(new b2Vec2(_loc5_,-_loc4_),this.sleighBody.GetWorldPoint(new b2Vec2(_loc6_.x + this.impulseOffset,_loc6_.y)));
                this.sleighBody.ApplyImpulse(new b2Vec2(-_loc5_,_loc4_),this.sleighBody.GetWorldPoint(new b2Vec2(_loc6_.x - this.impulseOffset,_loc6_.y)));
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
                _loc1_ = this.sleighBody.GetAngle();
                _loc2_ = this.sleighBody.GetAngularVelocity();
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
                _loc7_ = this.sleighBody.GetLocalCenter();
                this.sleighBody.ApplyImpulse(new b2Vec2(-_loc6_,_loc5_),this.sleighBody.GetWorldPoint(new b2Vec2(_loc7_.x + this.impulseOffset,_loc7_.y)));
                this.sleighBody.ApplyImpulse(new b2Vec2(_loc6_,-_loc5_),this.sleighBody.GetWorldPoint(new b2Vec2(_loc7_.x - this.impulseOffset,_loc7_.y)));
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
                    this.midWheel1Joint.EnableMotor(true);
                    this.midWheel2Joint.EnableMotor(true);
                    this.frontWheelJoint.EnableMotor(true);
                    if(this.sleighReigns)
                    {
                        this.sleighReigns.EnableMotor(true);
                        this.pumpCounter = 0;
                    }
                }
                this.wheelCurrentSpeed = this.midWheel1Joint.GetJointSpeed();
                if(this.wheelCurrentSpeed < 0)
                {
                    this.wheelNewSpeed = 0;
                }
                else
                {
                    this.wheelNewSpeed = this.wheelCurrentSpeed < this.wheelMaxSpeed ? this.wheelCurrentSpeed + this.accelStep : this.wheelCurrentSpeed;
                }
                this.backWheelJoint.SetMotorSpeed(this.wheelNewSpeed);
                this.midWheel1Joint.SetMotorSpeed(this.wheelNewSpeed);
                this.midWheel2Joint.SetMotorSpeed(this.wheelNewSpeed);
                this.frontWheelJoint.SetMotorSpeed(this.wheelNewSpeed);
                if(this.sleighReigns)
                {
                    this.sleighReigns.SetMotorSpeed(Math.sin(this.pumpCounter) * 6);
                    this.pumpCounter += 0.6;
                }
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
                    this.midWheel1Joint.EnableMotor(true);
                    this.midWheel2Joint.EnableMotor(true);
                    this.frontWheelJoint.EnableMotor(true);
                    if(this.sleighReigns)
                    {
                        this.sleighReigns.EnableMotor(true);
                        this.pumpCounter = 0;
                    }
                }
                this.wheelCurrentSpeed = this.midWheel2Joint.GetJointSpeed();
                if(this.wheelCurrentSpeed > 0)
                {
                    this.wheelNewSpeed = 0;
                }
                else
                {
                    this.wheelNewSpeed = this.wheelCurrentSpeed > -this.wheelMaxSpeed ? this.wheelCurrentSpeed - this.accelStep : this.wheelCurrentSpeed;
                }
                this.backWheelJoint.SetMotorSpeed(this.wheelNewSpeed);
                this.midWheel1Joint.SetMotorSpeed(this.wheelNewSpeed);
                this.midWheel2Joint.SetMotorSpeed(this.wheelNewSpeed);
                this.frontWheelJoint.SetMotorSpeed(this.wheelNewSpeed);
                if(this.sleighReigns)
                {
                    this.sleighReigns.SetMotorSpeed(Math.sin(this.pumpCounter) * 6);
                    this.pumpCounter += 0.6;
                }
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
            else if(this.backWheelJoint.IsMotorEnabled())
            {
                this.backWheelJoint.EnableMotor(false);
                this.midWheel1Joint.EnableMotor(false);
                this.midWheel2Joint.EnableMotor(false);
                this.frontWheelJoint.EnableMotor(false);
                if(this.sleighReigns)
                {
                    this.sleighReigns.EnableMotor(false);
                }
            }
        }
        
        override internal function spacePressedActions() : void
        {
            var _loc1_:int = 0;
            var _loc2_:int = 0;
            var _loc3_:Array = null;
            var _loc4_:b2Body = null;
            var _loc5_:b2Vec2 = null;
            var _loc6_:b2Vec2 = null;
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
                    _loc1_ = int(this.antiGravArray.length);
                    _loc2_ = 0;
                    while(_loc2_ < _loc1_)
                    {
                        _loc4_ = this.antiGravArray[_loc2_];
                        if(!_loc4_.IsSleeping())
                        {
                            _loc4_.m_linearVelocity.y += this.gravityDisplacement;
                        }
                        _loc2_++;
                    }
                    _loc3_ = this.elf1.antiGravArray;
                    _loc1_ = int(_loc3_.length);
                    _loc2_ = 0;
                    while(_loc2_ < _loc1_)
                    {
                        _loc4_ = _loc3_[_loc2_];
                        if(!_loc4_.IsSleeping())
                        {
                            _loc4_.m_linearVelocity.y += this.gravityDisplacement;
                        }
                        _loc2_++;
                    }
                    _loc3_ = this.elf2.antiGravArray;
                    _loc1_ = int(_loc3_.length);
                    _loc2_ = 0;
                    while(_loc2_ < _loc1_)
                    {
                        _loc4_ = _loc3_[_loc2_];
                        if(!_loc4_.IsSleeping())
                        {
                            _loc4_.m_linearVelocity.y += this.gravityDisplacement;
                        }
                        _loc2_++;
                    }
                    if(!this.snowSpray)
                    {
                        _loc5_ = new b2Vec2(_startX - 143 / character_scale,_startY + 178 / character_scale);
                        _loc6_ = new b2Vec2(_startX + 107 / character_scale,_startY + 178 / character_scale);
                        this.snowSpray = _session.particleController.createSnowSpray("snowflakes",this.sleighBody,_loc5_,_loc6_,0,0,180,5,5000,_session.containerSprite);
                        this.sleighBellLoop = SoundController.instance.playAreaSoundLoop("SleighBellLoop",this.sleighBody,0,0);
                        this.sleighBellLoop.fadeIn(0.5);
                    }
                }
                else if(this.snowSpray)
                {
                    this.snowSpray.stopSpewing();
                    this.snowSpray = null;
                    this.sleighBellLoop.fadeOut(0.5);
                    this.sleighBellLoop = null;
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
            if(this.snowSpray)
            {
                this.snowSpray.stopSpewing();
                this.snowSpray = null;
                this.sleighBellLoop.fadeOut(0.5);
                this.sleighBellLoop = null;
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
                if(!this.elf1.legsOk)
                {
                    this.elf1.eject();
                }
                if(!this.elf2.legsOk)
                {
                    this.elf2.eject();
                }
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
            if(this.ejected)
            {
                this.elf1.eject();
                this.elf2.eject();
            }
            else
            {
                this.ejectImpulse = 5;
                this.eject();
            }
        }
        
        override public function actions() : void
        {
            var _loc2_:Number = NaN;
            this.boostMeter.scaleY = 1 - this.boostVal / this.boostMax;
            var _loc1_:int = this.frontContacts + this.backContacts;
            if(_loc1_ > 0)
            {
                _loc2_ = Math.abs(this.backWheelBody.GetAngularVelocity());
                if(_loc2_ > 12)
                {
                    if(!this.skiLoop)
                    {
                        this.skiLoop = SoundController.instance.playAreaSoundLoop("SkiLoop",this.sleighBody,0,Math.random() * 5000);
                        this.skiLoop.fadeIn(0.2);
                    }
                }
                else if(this.skiLoop)
                {
                    this.skiLoop.fadeOut(0.2);
                    this.skiLoop = null;
                }
            }
            else if(this.skiLoop)
            {
                this.skiLoop.fadeOut(0.2);
                this.skiLoop = null;
            }
            super.actions();
            this.elf1.actions();
            this.elf2.actions();
        }
        
        protected function floatElves() : void
        {
            var _loc4_:b2Body = null;
            var _loc1_:Array = this.elf1.antiGravArray;
            var _loc2_:int = int(_loc1_.length);
            var _loc3_:int = 0;
            while(_loc3_ < _loc2_)
            {
                _loc4_ = _loc1_[_loc3_];
                if(!_loc4_.IsSleeping())
                {
                    _loc4_.m_linearVelocity.y += this.gravityDisplacement;
                }
                _loc3_++;
            }
            _loc1_ = this.elf2.antiGravArray;
            _loc2_ = int(_loc1_.length);
            _loc3_ = 0;
            while(_loc3_ < _loc2_)
            {
                _loc4_ = _loc1_[_loc3_];
                if(!_loc4_.IsSleeping())
                {
                    _loc4_.m_linearVelocity.y += this.gravityDisplacement;
                }
                _loc3_++;
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
                case 6:
                case 7:
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
        
        override public function create() : void
        {
            createFilters();
            this.createBodies();
            this.createJoints();
            this.createMovieClips();
            setLimits();
            this.createDictionaries();
            this.elf1.create();
            this.elf2.create();
            _session.containerSprite.addChild(this.sleighMC);
            _session.containerSprite.addChild(this.strapsSprite);
            this.createStraps();
            if(_session is SessionCharacterMenu)
            {
                actionsVector.push(this.floatElves);
            }
            dispatchEvent(new Event(Event.COMPLETE));
        }
        
        override public function reset() : void
        {
            super.reset();
            this.ejected = false;
            this.frontContacts = 0;
            this.backContacts = 0;
            this.pumpCounter = 0;
            this.boostVal = 0;
            this.elf1.reset();
            this.elf2.reset();
            this.createStraps();
        }
        
        override public function die() : void
        {
            var _loc2_:Sprite = null;
            super.die();
            this.helmetBody = null;
            this.snowSpray = null;
            this.skiLoop = null;
            this.sleighBellLoop = null;
            this.antiGravArray = new Array();
            var _loc1_:int = 0;
            while(_loc1_ < this.bells.length)
            {
                _loc2_ = this.bells[_loc1_];
                _loc2_.parent.removeChild(_loc2_);
                _loc1_++;
            }
            this.bells = null;
            this.elf1.die();
            this.elf2.die();
        }
        
        override public function paint() : void
        {
            super.paint();
            this.elf1.paint();
            this.elf2.paint();
            this.strapsSprite.graphics.clear();
            this.strapsSprite.graphics.lineStyle(1,3355443);
            var _loc1_:b2DistanceJoint = this.strapHeadJoints[0] as b2DistanceJoint;
            var _loc2_:b2Vec2 = _loc1_.GetAnchor1();
            var _loc3_:b2Vec2 = _loc1_.GetAnchor2();
            this.strapsSprite.graphics.moveTo(_loc2_.x * m_physScale,_loc2_.y * m_physScale);
            this.strapsSprite.graphics.lineTo(_loc3_.x * m_physScale,_loc3_.y * m_physScale);
            var _loc4_:int = int(this.strapHeadJoints.length);
            var _loc5_:int = 1;
            while(_loc5_ < _loc4_)
            {
                _loc1_ = this.strapHeadJoints[_loc5_];
                _loc2_ = _loc1_.GetAnchor1();
                _loc3_ = _loc1_.GetAnchor2();
                this.strapsSprite.graphics.lineTo(_loc3_.x * m_physScale,_loc3_.y * m_physScale);
                _loc5_++;
            }
            this.strapsSprite.graphics.lineStyle(1.5,3355443);
            _loc1_ = this.strapChest1Joints[0] as b2DistanceJoint;
            _loc2_ = _loc1_.GetAnchor1();
            _loc3_ = _loc1_.GetAnchor2();
            this.strapsSprite.graphics.moveTo(_loc2_.x * m_physScale,_loc2_.y * m_physScale);
            this.strapsSprite.graphics.lineTo(_loc3_.x * m_physScale,_loc3_.y * m_physScale);
            _loc4_ = int(this.strapChest1Joints.length);
            _loc5_ = 1;
            while(_loc5_ < _loc4_)
            {
                _loc1_ = this.strapChest1Joints[_loc5_];
                _loc2_ = _loc1_.GetAnchor1();
                _loc3_ = _loc1_.GetAnchor2();
                this.strapsSprite.graphics.lineTo(_loc3_.x * m_physScale,_loc3_.y * m_physScale);
                _loc5_++;
            }
            _loc1_ = this.strapChest2Joints[0] as b2DistanceJoint;
            _loc2_ = _loc1_.GetAnchor1();
            _loc3_ = _loc1_.GetAnchor2();
            this.strapsSprite.graphics.moveTo(_loc2_.x * m_physScale,_loc2_.y * m_physScale);
            this.strapsSprite.graphics.lineTo(_loc3_.x * m_physScale,_loc3_.y * m_physScale);
            _loc4_ = int(this.strapChest2Joints.length);
            _loc5_ = 1;
            while(_loc5_ < _loc4_)
            {
                _loc1_ = this.strapChest2Joints[_loc5_];
                _loc2_ = _loc1_.GetAnchor1();
                _loc3_ = _loc1_.GetAnchor2();
                this.strapsSprite.graphics.lineTo(_loc3_.x * m_physScale,_loc3_.y * m_physScale);
                _loc5_++;
            }
        }
        
        override internal function createDictionaries() : void
        {
            super.createDictionaries();
            this.helmetShape = head1Shape;
            contactImpulseDict[this.helmetShape] = this.helmetSmashLimit;
            contactImpulseDict[this.frontShape] = this.sleighSmashLimit;
            contactImpulseDict[this.skiShape] = this.sleighSmashLimit;
            contactImpulseDict[this.stem3Shape] = this.sleighSmashLimit;
            contactAddSounds[this.backWheelShape] = "SkiImpact1";
            contactAddSounds[this.frontWheelShape] = "SkiImpact2";
            contactAddSounds[this.frontShape] = "SleighImpact1";
            contactAddSounds[this.bumperShape] = "SleighImpact2";
            contactAddSounds[this.stem1Shape] = "SleighImpact2";
            contactAddSounds[this.stem2Shape] = "SleighImpact1";
            contactAddSounds[this.stem3Shape] = "SleighImpact1";
            contactAddSounds[this.rearShape] = "SleighImpact3";
        }
        
        override internal function createBodies() : void
        {
            var _loc9_:Array = null;
            var _loc10_:b2Vec2 = null;
            var _loc11_:MovieClip = null;
            var _loc12_:int = 0;
            var _loc13_:b2BodyDef = null;
            var _loc14_:b2Body = null;
            var _loc15_:* = undefined;
            super.createBodies();
            this.antiGravArray = new Array();
            var _loc1_:b2PolygonDef = new b2PolygonDef();
            var _loc2_:b2CircleDef = new b2CircleDef();
            var _loc3_:b2BodyDef = new b2BodyDef();
            var _loc4_:b2BodyDef = new b2BodyDef();
            _loc1_.density = 1;
            _loc1_.friction = 0.3;
            _loc1_.restitution = 0.1;
            _loc1_.filter = defaultFilter;
            paintVector.splice(paintVector.indexOf(chestBody),1);
            paintVector.splice(paintVector.indexOf(pelvisBody),1);
            _session.m_world.DestroyBody(chestBody);
            _session.m_world.DestroyBody(pelvisBody);
            var _loc5_:MovieClip = shapeGuide["chestShape"];
            _loc3_.position.Set(_startX + _loc5_.x / character_scale,_startY + _loc5_.y / character_scale);
            _loc3_.angle = _loc5_.rotation / (180 / Math.PI);
            chestBody = _session.m_world.CreateBody(_loc3_);
            _loc1_.vertexCount = 6;
            var _loc6_:int = 0;
            while(_loc6_ < 6)
            {
                _loc11_ = shapeGuide["chestVert" + [_loc6_]];
                _loc1_.vertices[_loc6_] = new b2Vec2(_loc11_.x / character_scale,_loc11_.y / character_scale);
                _loc6_++;
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
            _loc5_ = shapeGuide["pelvisShape"];
            _loc4_.position.Set(_startX + _loc5_.x / character_scale,_startY + _loc5_.y / character_scale);
            _loc4_.angle = _loc5_.rotation / (180 / Math.PI);
            pelvisBody = _session.m_world.CreateBody(_loc4_);
            _loc1_.vertexCount = 5;
            _loc6_ = 0;
            while(_loc6_ < 5)
            {
                _loc11_ = shapeGuide["pelvisVert" + [_loc6_]];
                _loc1_.vertices[_loc6_] = new b2Vec2(_loc11_.x / character_scale,_loc11_.y / character_scale);
                _loc6_++;
            }
            pelvisShape = pelvisBody.CreateShape(_loc1_);
            pelvisShape.SetMaterial(2);
            pelvisShape.SetUserData(this);
            _session.contactListener.registerListener(ContactListener.RESULT,pelvisShape,contactResultHandler);
            _session.contactListener.registerListener(ContactListener.ADD,pelvisShape,contactAddHandler);
            pelvisBody.SetMassFromShapes();
            pelvisBody.AllowSleeping(false);
            paintVector.push(pelvisBody);
            var _loc7_:b2BodyDef = new b2BodyDef();
            var _loc8_:b2BodyDef = new b2BodyDef();
            _loc1_ = new b2PolygonDef();
            _loc2_ = new b2CircleDef();
            _loc1_.density = 3;
            _loc1_.friction = 0.3;
            _loc1_.restitution = 0.3;
            _loc2_.density = 3;
            _loc2_.friction = 1;
            _loc2_.restitution = 0.1;
            if(_session.version > 1.51)
            {
                _loc1_.filter = defaultFilter.Copy();
                _loc2_.filter = defaultFilter.Copy();
                _loc12_ = defaultFilter.groupIndex;
            }
            else
            {
                _loc1_.filter.categoryBits = 520;
                _loc2_.filter.categoryBits = 520;
                _loc12_ = 0;
            }
            this.sleighBody = _session.m_world.CreateBody(_loc7_);
            _loc1_.vertexCount = 5;
            _loc6_ = 0;
            while(_loc6_ < 5)
            {
                _loc11_ = shapeGuide["rear_" + [_loc6_ + 1]];
                _loc1_.vertices[_loc6_] = new b2Vec2(_startX + _loc11_.x / character_scale,_startY + _loc11_.y / character_scale);
                _loc6_++;
            }
            this.rearShape = this.sleighBody.CreateShape(_loc1_) as b2PolygonShape;
            _session.contactListener.registerListener(ContactListener.RESULT,this.rearShape,this.contactSleighResultHandler);
            _session.contactListener.registerListener(ContactListener.ADD,this.rearShape,contactAddHandler);
            _loc1_.vertexCount = 6;
            _loc6_ = 0;
            while(_loc6_ < 6)
            {
                _loc11_ = shapeGuide["base_" + [_loc6_ + 1]];
                _loc1_.vertices[_loc6_] = new b2Vec2(_startX + _loc11_.x / character_scale,_startY + _loc11_.y / character_scale);
                _loc6_++;
            }
            this.skiShape = this.sleighBody.CreateShape(_loc1_) as b2PolygonShape;
            _session.contactListener.registerListener(ContactListener.RESULT,this.skiShape,contactResultHandler);
            _loc1_.filter.groupIndex = -1;
            _loc1_.vertexCount = 4;
            _loc6_ = 0;
            while(_loc6_ < 4)
            {
                _loc11_ = shapeGuide["back_" + [_loc6_ + 1]];
                _loc1_.vertices[_loc6_] = new b2Vec2(_startX + _loc11_.x / character_scale,_startY + _loc11_.y / character_scale);
                _loc6_++;
            }
            this.backShape = this.sleighBody.CreateShape(_loc1_) as b2PolygonShape;
            _loc1_.vertexCount = 5;
            _loc6_ = 0;
            while(_loc6_ < 5)
            {
                _loc11_ = shapeGuide["seat_" + [_loc6_ + 1]];
                _loc1_.vertices[_loc6_] = new b2Vec2(_startX + _loc11_.x / character_scale,_startY + _loc11_.y / character_scale);
                _loc6_++;
            }
            this.seatShape = this.sleighBody.CreateShape(_loc1_) as b2PolygonShape;
            _loc1_.filter.groupIndex = _loc12_;
            _loc1_.vertexCount = 5;
            _loc6_ = 0;
            while(_loc6_ < 5)
            {
                _loc11_ = shapeGuide["front_" + [_loc6_ + 1]];
                _loc1_.vertices[_loc6_] = new b2Vec2(_startX + _loc11_.x / character_scale,_startY + _loc11_.y / character_scale);
                _loc6_++;
            }
            this.frontShape = this.sleighBody.CreateShape(_loc1_) as b2PolygonShape;
            _session.contactListener.registerListener(ContactListener.RESULT,this.frontShape,this.contactSleighResultHandler);
            _session.contactListener.registerListener(ContactListener.ADD,this.frontShape,contactAddHandler);
            _loc1_.filter.groupIndex = -2;
            this.vertsBrokenStem = new Array();
            _loc9_ = new Array();
            _loc1_.vertexCount = 4;
            _loc6_ = 0;
            while(_loc6_ < 4)
            {
                _loc11_ = shapeGuide["stem1_" + [_loc6_ + 1]];
                _loc10_ = new b2Vec2(_startX + _loc11_.x / character_scale,_startY + _loc11_.y / character_scale);
                _loc1_.vertices[_loc6_] = _loc10_;
                _loc9_.push(_loc10_.Copy());
                _loc6_++;
            }
            this.vertsBrokenStem.push(_loc9_);
            this.stem1Shape = this.sleighBody.CreateShape(_loc1_) as b2PolygonShape;
            _session.contactListener.registerListener(ContactListener.RESULT,this.stem1Shape,this.contactStemResultHandler);
            _session.contactListener.registerListener(ContactListener.ADD,this.stem1Shape,contactAddHandler);
            _loc9_ = new Array();
            _loc6_ = 0;
            while(_loc6_ < 4)
            {
                _loc11_ = shapeGuide["stem2_" + [_loc6_ + 1]];
                _loc10_ = new b2Vec2(_startX + _loc11_.x / character_scale,_startY + _loc11_.y / character_scale);
                _loc1_.vertices[_loc6_] = _loc10_;
                _loc9_.push(_loc10_.Copy());
                _loc6_++;
            }
            this.vertsBrokenStem.push(_loc9_);
            this.stem2Shape = this.sleighBody.CreateShape(_loc1_) as b2PolygonShape;
            _session.contactListener.registerListener(ContactListener.RESULT,this.stem2Shape,this.contactStemResultHandler);
            _session.contactListener.registerListener(ContactListener.ADD,this.stem2Shape,contactAddHandler);
            _loc9_ = new Array();
            _loc6_ = 0;
            while(_loc6_ < 4)
            {
                _loc11_ = shapeGuide["stem3_" + [_loc6_ + 1]];
                _loc10_ = new b2Vec2(_startX + _loc11_.x / character_scale,_startY + _loc11_.y / character_scale);
                _loc1_.vertices[_loc6_] = _loc10_;
                _loc9_.push(_loc10_.Copy());
                _loc6_++;
            }
            this.vertsBrokenStem.push(_loc9_);
            this.stem3Shape = this.sleighBody.CreateShape(_loc1_) as b2PolygonShape;
            _session.contactListener.registerListener(ContactListener.RESULT,this.stem3Shape,this.contactStemResultHandler);
            _session.contactListener.registerListener(ContactListener.ADD,this.stem3Shape,contactAddHandler);
            _loc1_.filter.groupIndex = _loc12_;
            this.newBaseVerts = new Array();
            _loc6_ = 0;
            while(_loc6_ < 5)
            {
                _loc11_ = shapeGuide["newbase_" + [_loc6_ + 1]];
                _loc10_ = new b2Vec2(_startX + _loc11_.x / character_scale,_startY + _loc11_.y / character_scale);
                this.newBaseVerts.push(_loc10_);
                _loc6_++;
            }
            _loc5_ = shapeGuide["handAnchor"];
            _loc7_.position.Set(_startX + _loc5_.x / character_scale,_startY + _loc5_.y / character_scale);
            _loc1_.vertexCount = 4;
            _loc1_.SetAsBox(0.1,0.1);
            _loc1_.isSensor = true;
            this.reignsBody = _session.m_world.CreateBody(_loc7_);
            this.reignsBody.CreateShape(_loc1_);
            this.reignsBody.SetMassFromShapes();
            _loc5_ = shapeGuide["bumper"];
            _loc2_.radius = _loc5_.width / 2 / character_scale;
            _loc2_.localPosition = new b2Vec2(_startX + _loc5_.x / character_scale,_startY + _loc5_.y / character_scale);
            this.bumperShape = this.sleighBody.CreateShape(_loc2_) as b2CircleShape;
            _session.contactListener.registerListener(ContactListener.RESULT,this.bumperShape,this.contactSleighResultHandler);
            _session.contactListener.registerListener(ContactListener.ADD,this.bumperShape,contactAddHandler);
            this.sleighBody.SetMassFromShapes();
            paintVector.push(this.sleighBody);
            _loc1_.density = 0.25;
            _loc1_.isSensor = false;
            _loc1_.filter.groupIndex = 0;
            this.boxBodies = new Array();
            _loc6_ = 0;
            while(_loc6_ < 8)
            {
                _loc13_ = new b2BodyDef();
                _loc5_ = shapeGuide["box" + (_loc6_ + 1)];
                _loc13_.position.Set(_startX + _loc5_.x / character_scale,_startY + _loc5_.y / character_scale);
                _loc13_.angle = _loc5_.rotation / (180 / Math.PI);
                _loc1_.SetAsBox(_loc5_.scaleX * shapeRefScale / character_scale,_loc5_.scaleY * shapeRefScale / character_scale);
                _loc14_ = _session.m_world.CreateBody(_loc13_);
                _loc14_.CreateShape(_loc1_);
                _loc14_.SetMassFromShapes();
                paintVector.push(_loc14_);
                this.boxBodies.push(_loc14_);
                this.antiGravArray.push(_loc14_);
                _loc6_++;
            }
            _loc2_.localPosition = new b2Vec2();
            _loc2_.filter.groupIndex = 0;
            _loc5_ = shapeGuide["backWheel"];
            _loc8_.position.Set(_startX + _loc5_.x / character_scale,_startY + _loc5_.y / character_scale);
            _loc8_.angle = _loc5_.rotation / oneEightyOverPI;
            _loc2_.radius = _loc5_.width / 2 / character_scale;
            this.wheelRadius = _loc5_.width * 0.5;
            this.backWheelBody = _session.m_world.CreateBody(_loc8_);
            this.backWheelShape = this.backWheelBody.CreateShape(_loc2_);
            this.backWheelBody.SetMassFromShapes();
            _session.contactListener.registerListener(ContactListener.ADD,this.backWheelShape,this.wheelContactAdd);
            _session.contactListener.registerListener(ContactListener.REMOVE,this.backWheelShape,this.wheelContactRemove);
            _loc5_ = shapeGuide["midWheel1"];
            _loc8_.position.Set(_startX + _loc5_.x / character_scale,_startY + _loc5_.y / character_scale);
            _loc8_.angle = _loc5_.rotation / oneEightyOverPI;
            _loc2_.radius = _loc5_.width / 2 / character_scale;
            this.midWheel1Body = _session.m_world.CreateBody(_loc8_);
            this.midWheel1Shape = this.midWheel1Body.CreateShape(_loc2_);
            this.midWheel1Body.SetMassFromShapes();
            _loc5_ = shapeGuide["midWheel2"];
            _loc2_.filter.groupIndex = -1;
            _loc8_.position.Set(_startX + _loc5_.x / character_scale,_startY + _loc5_.y / character_scale);
            _loc8_.angle = _loc5_.rotation / oneEightyOverPI;
            _loc2_.radius = _loc5_.width / 2 / character_scale;
            this.midWheel2Body = _session.m_world.CreateBody(_loc8_);
            this.midWheel2Shape = this.midWheel2Body.CreateShape(_loc2_);
            this.midWheel2Body.SetMassFromShapes();
            _loc2_.filter.groupIndex = 0;
            _loc5_ = shapeGuide["frontWheel"];
            _loc8_.position.Set(_startX + _loc5_.x / character_scale,_startY + _loc5_.y / character_scale);
            _loc8_.angle = _loc5_.rotation / oneEightyOverPI;
            _loc2_.radius = _loc5_.width / 2 / character_scale;
            this.frontWheelBody = _session.m_world.CreateBody(_loc8_);
            this.frontWheelShape = this.frontWheelBody.CreateShape(_loc2_);
            this.frontWheelBody.SetMassFromShapes();
            this.wheelMultiplier = this.wheelRadius / (_loc5_.width * 0.5);
            _session.contactListener.registerListener(ContactListener.ADD,this.frontWheelShape,this.wheelContactAdd);
            _session.contactListener.registerListener(ContactListener.REMOVE,this.frontWheelShape,this.wheelContactRemove);
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
            this.antiGravArray.push(this.sleighBody);
            this.antiGravArray.push(this.reignsBody);
            this.antiGravArray.push(this.backWheelBody);
            this.antiGravArray.push(this.midWheel1Body);
            this.antiGravArray.push(this.midWheel2Body);
            this.antiGravArray.push(this.frontWheelBody);
            this.vertsBrokenSleigh = new Array();
            _loc6_ = 0;
            while(_loc6_ < 7)
            {
                _loc9_ = new Array();
                _loc15_ = 0;
                while(_loc15_ < 6)
                {
                    _loc5_ = shapeGuide["broken_" + (_loc6_ + 1) + "_" + (_loc15_ + 1)];
                    if(_loc5_)
                    {
                        _loc9_.push(new b2Vec2(_startX + _loc5_.x / character_scale,_startY + _loc5_.y / character_scale));
                    }
                    _loc15_++;
                }
                this.vertsBrokenSleigh.push(_loc9_);
                _loc6_++;
            }
            this.vertsBrokenSki = new Array();
            _loc6_ = 0;
            while(_loc6_ < 3)
            {
                _loc9_ = new Array();
                _loc15_ = 0;
                while(_loc15_ < 6)
                {
                    _loc5_ = shapeGuide["ski_" + (_loc6_ + 1) + "_" + (_loc15_ + 1)];
                    if(_loc5_)
                    {
                        _loc9_.push(new b2Vec2(_startX + _loc5_.x / character_scale,_startY + _loc5_.y / character_scale));
                    }
                    _loc15_++;
                }
                this.vertsBrokenSki.push(_loc9_);
                _loc6_++;
            }
        }
        
        override internal function createMovieClips() : void
        {
            var _loc8_:MovieClip = null;
            var _loc10_:MovieClip = null;
            var _loc11_:b2Body = null;
            super.createMovieClips();
            var _loc1_:MovieClip = sourceObject["sleighShards"];
            _session.particleController.createBMDArray("sleighShards",_loc1_);
            var _loc2_:MovieClip = sourceObject["snowflakes"];
            var _loc3_:BevelFilter = new BevelFilter(1,90,16777215,1,0,1,2.5,2.5,0.7,3);
            _session.particleController.createBMDArray("snowflakes",_loc2_,[_loc3_]);
            _session.containerSprite.addChildAt(chestMC,_session.containerSprite.getChildIndex(lowerLeg1MC));
            this.sleighMC = sourceObject["sleigh"];
            var _loc12_:* = 1 / mc_scale;
            this.sleighMC.scaleY = 1 / mc_scale;
            this.sleighMC.scaleX = _loc12_;
            this.helmetMC = sourceObject["helmet"];
            _loc12_ = 1 / mc_scale;
            this.helmetMC.scaleY = 1 / mc_scale;
            this.helmetMC.scaleX = _loc12_;
            this.helmetMC.visible = false;
            _session.containerSprite.addChildAt(this.helmetMC,_session.containerSprite.getChildIndex(chestMC));
            var _loc4_:b2Vec2 = chestBody.GetLocalCenter();
            trace("chest center " + _loc4_.x * character_scale + ", " + _loc4_.y * character_scale);
            _loc4_ = pelvisBody.GetLocalCenter();
            trace("pelvis center " + _loc4_.x * character_scale + ", " + _loc4_.y * character_scale);
            var _loc5_:b2Vec2 = this.sleighBody.GetLocalCenter();
            _loc5_ = new b2Vec2((_startX - _loc5_.x) * character_scale,(_startY - _loc5_.y) * character_scale);
            var _loc6_:MovieClip = shapeGuide["rear_1"];
            var _loc7_:b2Vec2 = new b2Vec2(_loc6_.x + _loc5_.x,_loc6_.y + _loc5_.y);
            this.sleighMC.inner.x = _loc7_.x;
            this.sleighMC.inner.y = _loc7_.y;
            this.sleighBody.SetUserData(this.sleighMC);
            _session.containerSprite.addChild(this.sleighMC);
            this.strapsSprite = new Sprite();
            _session.containerSprite.addChild(this.strapsSprite);
            this.brokenSleighMCs = new Array();
            var _loc9_:int = 1;
            while(_loc9_ < 8)
            {
                _loc8_ = sourceObject["sleigh" + _loc9_];
                _loc12_ = 1 / mc_scale;
                _loc8_.scaleY = 1 / mc_scale;
                _loc8_.scaleX = _loc12_;
                _loc8_.visible = false;
                this.brokenSleighMCs.push(_loc8_);
                _session.containerSprite.addChild(_loc8_);
                _loc9_++;
            }
            _loc8_ = sourceObject["stem"];
            _loc12_ = 1 / mc_scale;
            _loc8_.scaleY = 1 / mc_scale;
            _loc8_.scaleX = _loc12_;
            _loc8_.visible = false;
            this.stemMC = _loc8_;
            _session.containerSprite.addChild(_loc8_);
            this.brokenSkiMCs = new Array();
            _loc9_ = 1;
            while(_loc9_ < 4)
            {
                _loc8_ = sourceObject["ski" + _loc9_];
                _loc12_ = 1 / mc_scale;
                _loc8_.scaleY = 1 / mc_scale;
                _loc8_.scaleX = _loc12_;
                _loc8_.visible = false;
                this.brokenSkiMCs.push(_loc8_);
                _session.containerSprite.addChild(_loc8_);
                _loc9_++;
            }
            this.boxMCs = new Array();
            _loc9_ = 0;
            while(_loc9_ < 8)
            {
                _loc10_ = sourceObject["box" + (_loc9_ + 1)];
                _loc12_ = 1 / mc_scale;
                _loc10_.scaleY = 1 / mc_scale;
                _loc10_.scaleX = _loc12_;
                _loc11_ = this.boxBodies[_loc9_];
                _loc11_.SetUserData(_loc10_);
                this.boxMCs.push(_loc10_);
                _session.containerSprite.addChildAt(_loc10_,_session.containerSprite.getChildIndex(this.sleighMC));
                _loc9_++;
            }
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
        }
        
        override internal function createJoints() : void
        {
            var _loc1_:Number = NaN;
            var _loc2_:Number = NaN;
            var _loc3_:Number = NaN;
            var _loc8_:MovieClip = null;
            super.createJoints();
            var _loc4_:Number = 180 / Math.PI;
            _loc1_ = head1Body.GetAngle() - chestBody.GetAngle();
            _loc2_ = -5 / _loc4_ - _loc1_;
            _loc3_ = 5 / _loc4_ - _loc1_;
            neckJoint.SetLimits(_loc2_,_loc3_);
            var _loc5_:b2Vec2 = new b2Vec2();
            var _loc6_:b2PrismaticJointDef = new b2PrismaticJointDef();
            _loc8_ = shapeGuide["handAnchor"];
            _loc5_.Set(_startX + _loc8_.x / character_scale,_startY + _loc8_.y / character_scale);
            _loc6_.Initialize(this.sleighBody,this.reignsBody,_loc5_,new b2Vec2(0,1));
            _loc6_.enableLimit = true;
            _loc6_.maxMotorForce = 1000;
            _loc6_.upperTranslation = 15 / m_physScale;
            _loc6_.lowerTranslation = -100 / m_physScale;
            this.sleighReigns = _session.m_world.CreateJoint(_loc6_) as b2PrismaticJoint;
            var _loc7_:b2RevoluteJointDef = new b2RevoluteJointDef();
            _loc7_.maxMotorTorque = this.maxTorque;
            _loc7_.enableLimit = false;
            _loc7_.lowerAngle = 0;
            _loc7_.upperAngle = 0;
            _loc7_.Initialize(this.reignsBody,lowerArm1Body,_loc5_);
            this.reignsHand1 = _session.m_world.CreateJoint(_loc7_) as b2RevoluteJoint;
            _loc7_.Initialize(this.reignsBody,lowerArm2Body,_loc5_);
            this.reignsHand2 = _session.m_world.CreateJoint(_loc7_) as b2RevoluteJoint;
            _loc5_.Set(pelvisBody.GetWorldCenter().x,pelvisBody.GetWorldCenter().y);
            _loc7_.Initialize(this.sleighBody,pelvisBody,_loc5_);
            _loc7_.enableLimit = true;
            this.sleighPelvis = _session.m_world.CreateJoint(_loc7_) as b2RevoluteJoint;
            _loc7_.enableLimit = false;
            this.pelvisAnchorPoint = this.sleighBody.GetLocalPoint(_loc5_);
            _loc8_ = shapeGuide["backWheel"];
            _loc5_.Set(_startX + _loc8_.x / character_scale,_startY + _loc8_.y / character_scale);
            _loc7_.Initialize(this.sleighBody,this.backWheelBody,_loc5_);
            this.backWheelJoint = _session.m_world.CreateJoint(_loc7_) as b2RevoluteJoint;
            _loc8_ = shapeGuide["midWheel1"];
            _loc5_.Set(_startX + _loc8_.x / character_scale,_startY + _loc8_.y / character_scale);
            _loc7_.Initialize(this.sleighBody,this.midWheel1Body,_loc5_);
            this.midWheel1Joint = _session.m_world.CreateJoint(_loc7_) as b2RevoluteJoint;
            _loc8_ = shapeGuide["midWheel2"];
            _loc5_.Set(_startX + _loc8_.x / character_scale,_startY + _loc8_.y / character_scale);
            _loc7_.Initialize(this.sleighBody,this.midWheel2Body,_loc5_);
            this.midWheel2Joint = _session.m_world.CreateJoint(_loc7_) as b2RevoluteJoint;
            _loc8_ = shapeGuide["frontWheel"];
            _loc5_.Set(_startX + _loc8_.x / character_scale,_startY + _loc8_.y / character_scale);
            _loc7_.Initialize(this.sleighBody,this.frontWheelBody,_loc5_);
            this.frontWheelJoint = _session.m_world.CreateJoint(_loc7_) as b2RevoluteJoint;
            _loc8_ = shapeGuide["footAnchor"];
            _loc5_.Set(_startX + _loc8_.x / character_scale,_startY + _loc8_.y / character_scale);
            _loc7_.Initialize(this.sleighBody,lowerLeg1Body,_loc5_);
            this.sleighFoot1 = _session.m_world.CreateJoint(_loc7_) as b2RevoluteJoint;
            this.leg1AnchorPoint = this.sleighBody.GetLocalPoint(_loc5_);
            _loc7_.Initialize(this.sleighBody,lowerLeg2Body,_loc5_);
            this.sleighFoot2 = _session.m_world.CreateJoint(_loc7_) as b2RevoluteJoint;
            this.leg2AnchorPoint = this.sleighBody.GetLocalPoint(_loc5_);
        }
        
        protected function createStraps() : void
        {
            var _loc9_:b2Vec2 = null;
            var _loc10_:b2Vec2 = null;
            var _loc12_:b2Body = null;
            var _loc16_:b2DistanceJoint = null;
            var _loc17_:ChristmasBellMC = null;
            this.strapHeadJoints = new Array();
            this.strapChest1Joints = new Array();
            this.strapChest2Joints = new Array();
            var _loc1_:b2DistanceJointDef = new b2DistanceJointDef();
            var _loc2_:b2BodyDef = new b2BodyDef();
            var _loc3_:b2CircleDef = new b2CircleDef();
            var _loc4_:int = 8;
            _loc3_.density = 0.25;
            _loc3_.friction = 1;
            _loc3_.restitution = 0.1;
            _loc3_.filter.categoryBits = 0;
            _loc3_.filter.maskBits = 0;
            _loc3_.radius = 3 / m_physScale;
            var _loc5_:b2Vec2 = this.reignsBody.GetPosition();
            var _loc6_:b2Vec2 = this.elf1.head1Body.GetWorldPoint(new b2Vec2(-18 / character_scale,4 / character_scale));
            var _loc7_:Number = (_loc6_.x - _loc5_.x) / _loc4_;
            var _loc8_:Number = (_loc6_.y - _loc5_.y) / _loc4_;
            _loc9_ = _loc5_.Copy();
            var _loc11_:b2Body = this.reignsBody;
            var _loc13_:int = 0;
            while(_loc13_ < _loc4_)
            {
                _loc2_.position.Set(_loc5_.x + _loc7_ * (_loc13_ + 1),_loc5_.y + _loc8_ * (_loc13_ + 1));
                if(_loc13_ < _loc4_ - 1)
                {
                    _loc12_ = _session.m_world.CreateBody(_loc2_);
                    _loc12_.CreateShape(_loc3_);
                    _loc12_.SetMassFromShapes();
                    _loc10_ = _loc12_.GetPosition();
                    this.antiGravArray.push(_loc12_);
                }
                else
                {
                    _loc12_ = this.elf1.head1Body;
                    _loc10_ = _loc6_;
                }
                _loc1_.Initialize(_loc11_,_loc12_,_loc9_,_loc10_);
                _loc16_ = _session.m_world.CreateJoint(_loc1_) as b2DistanceJoint;
                this.strapHeadJoints.push(_loc16_);
                _loc11_ = _loc12_;
                _loc9_ = _loc10_;
                _loc13_++;
            }
            _loc4_ = 4;
            _loc5_ = _loc6_;
            _loc6_ = this.elf2.head1Body.GetWorldPoint(new b2Vec2(-18 / character_scale,4 / character_scale));
            _loc7_ = (_loc6_.x - _loc5_.x) / _loc4_;
            _loc8_ = (_loc6_.y - _loc5_.y) / _loc4_;
            _loc9_ = _loc5_.Copy();
            _loc13_ = 0;
            while(_loc13_ < _loc4_)
            {
                _loc2_.position.Set(_loc5_.x + _loc7_ * (_loc13_ + 1),_loc5_.y + _loc8_ * (_loc13_ + 1));
                if(_loc13_ < _loc4_ - 1)
                {
                    _loc12_ = _session.m_world.CreateBody(_loc2_);
                    _loc12_.CreateShape(_loc3_);
                    _loc12_.SetMassFromShapes();
                    _loc10_ = _loc12_.GetPosition();
                    this.antiGravArray.push(_loc12_);
                }
                else
                {
                    _loc12_ = this.elf2.head1Body;
                    _loc10_ = _loc6_;
                }
                _loc1_.Initialize(_loc11_,_loc12_,_loc9_,_loc10_);
                _loc16_ = _session.m_world.CreateJoint(_loc1_) as b2DistanceJoint;
                this.strapHeadJoints.push(_loc16_);
                _loc11_ = _loc12_;
                _loc9_ = _loc10_;
                _loc13_++;
            }
            _loc4_ = 3;
            var _loc14_:MovieClip = shapeGuide["strap1Anchor"];
            _loc5_.Set(_startX + _loc14_.x / character_scale,_startY + _loc14_.y / character_scale);
            _loc6_ = this.elf1.chestBody.GetWorldPoint(new b2Vec2(0,20 / character_scale));
            _loc7_ = (_loc6_.x - _loc5_.x) / _loc4_;
            _loc8_ = (_loc6_.y - _loc5_.y) / _loc4_;
            _loc9_ = _loc5_.Copy();
            _loc11_ = this.sleighBody;
            _loc13_ = 0;
            while(_loc13_ < _loc4_)
            {
                _loc2_.position.Set(_loc5_.x + _loc7_ * (_loc13_ + 1),_loc5_.y + _loc8_ * (_loc13_ + 1));
                if(_loc13_ < _loc4_ - 1)
                {
                    _loc12_ = _session.m_world.CreateBody(_loc2_);
                    _loc12_.CreateShape(_loc3_);
                    _loc12_.SetMassFromShapes();
                    _loc10_ = _loc12_.GetPosition();
                    this.antiGravArray.push(_loc12_);
                }
                else
                {
                    _loc12_ = this.elf1.chestBody;
                    _loc10_ = _loc6_;
                }
                _loc1_.Initialize(_loc11_,_loc12_,_loc9_,_loc10_);
                _loc16_ = _session.m_world.CreateJoint(_loc1_) as b2DistanceJoint;
                this.strapChest1Joints.push(_loc16_);
                _loc11_ = _loc12_;
                _loc9_ = _loc10_;
                _loc13_++;
            }
            _loc4_ = 5;
            _loc14_ = shapeGuide["strap2Anchor"];
            _loc5_.Set(_startX + _loc14_.x / character_scale,_startY + _loc14_.y / character_scale);
            _loc6_ = this.elf2.chestBody.GetWorldPoint(new b2Vec2(0,20 / character_scale));
            _loc7_ = (_loc6_.x - _loc5_.x) / _loc4_;
            _loc8_ = (_loc6_.y - _loc5_.y) / _loc4_;
            _loc9_ = _loc5_.Copy();
            _loc11_ = this.sleighBody;
            this.bells = new Array();
            var _loc15_:int = _session.containerSprite.getChildIndex(this.strapsSprite) + 1;
            _loc13_ = 0;
            while(_loc13_ < _loc4_)
            {
                _loc2_.position.Set(_loc5_.x + _loc7_ * (_loc13_ + 1),_loc5_.y + _loc8_ * (_loc13_ + 1));
                if(_loc13_ < _loc4_ - 1)
                {
                    _loc12_ = _session.m_world.CreateBody(_loc2_);
                    _loc12_.CreateShape(_loc3_);
                    _loc12_.SetMassFromShapes();
                    _loc17_ = new ChristmasBellMC();
                    this.bells.push(_loc17_);
                    _session.containerSprite.addChildAt(_loc17_,_loc15_);
                    _loc12_.SetUserData(_loc17_);
                    paintVector.push(_loc12_);
                    _loc10_ = _loc12_.GetWorldPoint(new b2Vec2(0,-1 / m_physScale));
                    this.antiGravArray.push(_loc12_);
                }
                else
                {
                    _loc12_ = this.elf2.chestBody;
                    _loc10_ = _loc6_;
                }
                _loc1_.Initialize(_loc11_,_loc12_,_loc9_,_loc10_);
                _loc16_ = _session.m_world.CreateJoint(_loc1_) as b2DistanceJoint;
                this.strapChest2Joints.push(_loc16_);
                _loc11_ = _loc12_;
                _loc9_ = _loc10_;
                _loc13_++;
            }
        }
        
        override internal function resetMovieClips() : void
        {
            var _loc8_:DisplayObject = null;
            var _loc9_:MovieClip = null;
            var _loc10_:b2Body = null;
            super.resetMovieClips();
            var _loc1_:int = 0;
            while(_loc1_ < this.brokenSleighMCs.length)
            {
                _loc8_ = this.brokenSleighMCs[_loc1_];
                _loc8_.visible = false;
                _loc1_++;
            }
            _loc1_ = 0;
            while(_loc1_ < this.brokenSkiMCs.length)
            {
                _loc8_ = this.brokenSkiMCs[_loc1_];
                _loc8_.visible = false;
                _loc1_++;
            }
            this.stemMC.visible = false;
            this.helmetMC.visible = false;
            head1MC.helmet.visible = true;
            this.sleighMC.visible = true;
            this.sleighMC.inner.stem.visible = true;
            this.sleighMC.inner.ski.visible = true;
            this.strapsSprite.graphics.clear();
            var _loc2_:b2Vec2 = this.sleighBody.GetLocalCenter();
            _loc2_ = new b2Vec2((_startX - _loc2_.x) * character_scale,(_startY - _loc2_.y) * character_scale);
            var _loc3_:MovieClip = shapeGuide["rear_1"];
            var _loc4_:b2Vec2 = new b2Vec2(_loc3_.x + _loc2_.x,_loc3_.y + _loc2_.y);
            this.sleighMC.inner.x = _loc4_.x;
            this.sleighMC.inner.y = _loc4_.y;
            this.sleighBody.SetUserData(this.sleighMC);
            _loc1_ = 0;
            while(_loc1_ < 8)
            {
                _loc9_ = this.boxMCs[_loc1_];
                _loc10_ = this.boxBodies[_loc1_];
                _loc10_.SetUserData(_loc9_);
                _loc1_++;
            }
            var _loc5_:MovieClip = sourceObject["sleighShards"];
            _session.particleController.createBMDArray("sleighShards",_loc5_);
            var _loc6_:MovieClip = sourceObject["snowflakes"];
            var _loc7_:BevelFilter = new BevelFilter(1,90,16777215,1,0,1,2.5,2.5,0.7,3);
            _session.particleController.createBMDArray("snowflakes",_loc6_,[_loc7_]);
            _session.addChild(this.boostHolder);
        }
        
        protected function contactSleighResultHandler(param1:ContactEvent) : void
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
        
        protected function contactStemResultHandler(param1:ContactEvent) : void
        {
            var _loc2_:Number = param1.impulse;
            if(_loc2_ > contactImpulseDict[this.stem3Shape])
            {
                if(contactResultBuffer[this.stem3Shape])
                {
                    if(_loc2_ > contactResultBuffer[this.stem3Shape].impulse)
                    {
                        contactResultBuffer[this.stem3Shape] = param1;
                    }
                }
                else
                {
                    contactResultBuffer[this.stem3Shape] = param1;
                }
            }
        }
        
        override public function handleContactBuffer() : void
        {
            super.handleContactBuffer();
            this.elf1.handleContactBuffer();
            this.elf2.handleContactBuffer();
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
            if(contactResultBuffer[this.frontShape])
            {
                _loc1_ = contactResultBuffer[this.frontShape];
                this.sleighSmash(_loc1_.impulse);
                delete contactResultBuffer[this.frontShape];
                delete contactResultBuffer[this.skiShape];
                delete contactResultBuffer[this.stem3Shape];
                delete contactAddBuffer[this.rearShape];
                delete contactAddBuffer[this.frontShape];
                delete contactAddBuffer[this.bumperShape];
                delete contactAddBuffer[this.baseShape];
                delete contactAddBuffer[this.stem3Shape];
                delete contactAddBuffer[this.stem2Shape];
                delete contactAddBuffer[this.stem1Shape];
                delete contactAddBuffer[this.frontWheelShape];
                delete contactAddBuffer[this.backWheelShape];
            }
            if(contactResultBuffer[this.skiShape])
            {
                _loc1_ = contactResultBuffer[this.skiShape];
                this.skiSmash(_loc1_.impulse);
                delete contactResultBuffer[this.skiShape];
                delete contactAddBuffer[this.frontWheelShape];
                delete contactAddBuffer[this.backWheelShape];
            }
            if(contactResultBuffer[this.stem3Shape])
            {
                _loc1_ = contactResultBuffer[this.stem3Shape];
                this.stemSmash(_loc1_.impulse);
                delete contactResultBuffer[this.stem3Shape];
                delete contactAddBuffer[this.stem3Shape];
                delete contactAddBuffer[this.stem2Shape];
                delete contactAddBuffer[this.stem1Shape];
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
        }
        
        override public function checkJoints() : void
        {
            var _loc1_:b2DistanceJoint = null;
            var _loc2_:Number = NaN;
            super.checkJoints();
            if(this.elf1.strappedIn)
            {
                _loc1_ = this.strapChest1Joints[0];
                _loc2_ = Math.abs(_loc1_.m_impulse);
                if(_loc2_ > 0.4)
                {
                    this.breakStrap(this.elf1);
                }
            }
            if(this.elf2.strappedIn)
            {
                _loc1_ = this.strapChest2Joints[0];
                _loc2_ = Math.abs(_loc1_.m_impulse);
                if(_loc2_ > 0.4)
                {
                    this.breakStrap(this.elf2);
                }
            }
            this.elf1.checkJoints();
            this.elf2.checkJoints();
        }
        
        override internal function eject() : void
        {
            var _loc5_:b2Shape = null;
            var _loc6_:int = 0;
            if(this.ejected)
            {
                return;
            }
            this.ejected = true;
            resetJointLimits();
            var _loc1_:b2World = _session.m_world;
            if(this.sleighFoot1)
            {
                _session.m_world.DestroyJoint(this.sleighFoot1);
                this.sleighFoot1 = null;
            }
            if(this.sleighFoot2)
            {
                _session.m_world.DestroyJoint(this.sleighFoot2);
                this.sleighFoot2 = null;
            }
            if(this.sleighPelvis)
            {
                _session.m_world.DestroyJoint(this.sleighPelvis);
                this.sleighPelvis = null;
            }
            if(this.reignsHand1)
            {
                _session.m_world.DestroyJoint(this.reignsHand1);
                this.reignsHand1 = null;
                this.checkReigns();
            }
            if(this.reignsHand2)
            {
                _session.m_world.DestroyJoint(this.reignsHand2);
                this.reignsHand2 = null;
                this.checkReigns();
            }
            if(_session.version > 1.51)
            {
                _loc5_ = this.sleighBody.GetShapeList();
                while(_loc5_)
                {
                    _loc6_ = _loc5_.m_filter.groupIndex;
                    if(_loc6_ == -1)
                    {
                        _loc5_.m_filter.groupIndex = 0;
                        _loc1_.Refilter(_loc5_);
                    }
                    _loc5_ = _loc5_.m_next;
                }
                this.midWheel2Shape.m_filter.groupIndex = 0;
                _loc1_.Refilter(this.midWheel2Shape);
            }
            else
            {
                this.seatShape.m_filter.groupIndex = 0;
                this.backShape.m_filter.groupIndex = 0;
                _loc1_.Refilter(this.seatShape);
                _loc1_.Refilter(this.backShape);
            }
            lowerArm1MC.hand.gotoAndStop(2);
            lowerArm2MC.hand.gotoAndStop(2);
            var _loc2_:Number = this.sleighBody.GetAngle() - Math.PI / 2;
            var _loc3_:Number = Math.cos(_loc2_) * this.ejectImpulse;
            var _loc4_:Number = Math.sin(_loc2_) * this.ejectImpulse;
            chestBody.ApplyImpulse(new b2Vec2(_loc3_,_loc4_),chestBody.GetWorldCenter());
            pelvisBody.ApplyImpulse(new b2Vec2(_loc3_,_loc4_),pelvisBody.GetWorldCenter());
            if(this.backWheelJoint.IsMotorEnabled())
            {
                this.backWheelJoint.EnableMotor(false);
                this.midWheel1Joint.EnableMotor(false);
                this.midWheel2Joint.EnableMotor(false);
                this.frontWheelJoint.EnableMotor(false);
            }
            if(this.snowSpray)
            {
                this.snowSpray.stopSpewing();
                this.snowSpray = null;
                this.sleighBellLoop.fadeOut(0.5);
                this.sleighBellLoop = null;
            }
        }
        
        internal function checkEject() : void
        {
            if(!this.reignsHand1 && !this.reignsHand2 && !this.sleighFoot1 && !this.sleighFoot2)
            {
                this.eject();
            }
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
        
        protected function sleighSmash(param1:Number) : void
        {
            var _loc13_:b2Body = null;
            var _loc14_:Array = null;
            var _loc15_:Sprite = null;
            trace(tag + " sleigh impulse " + param1 + " -> " + _session.iteration);
            delete contactImpulseDict[this.frontShape];
            var _loc2_:ContactListener = _session.contactListener;
            _loc2_.deleteListener(ContactListener.RESULT,this.rearShape);
            _loc2_.deleteListener(ContactListener.RESULT,this.frontShape);
            _loc2_.deleteListener(ContactListener.RESULT,this.bumperShape);
            _loc2_.deleteListener(ContactListener.ADD,this.rearShape);
            _loc2_.deleteListener(ContactListener.ADD,this.frontShape);
            _loc2_.deleteListener(ContactListener.ADD,this.bumperShape);
            if(this.baseShape)
            {
                _loc2_.deleteListener(ContactListener.RESULT,this.baseShape);
                _loc2_.deleteListener(ContactListener.ADD,this.baseShape);
            }
            var _loc3_:b2Vec2 = this.sleighBody.GetLocalCenter();
            _session.particleController.createPointBurst("sleighShards",_loc3_.x * m_physScale,_loc3_.y * m_physScale,100,30,20);
            this.eject();
            if(this.snowSpray)
            {
                this.snowSpray.stopSpewing();
                this.snowSpray = null;
                this.sleighBellLoop.fadeOut(0.5);
                this.sleighBellLoop = null;
            }
            var _loc4_:b2World = _session.m_world;
            var _loc5_:b2Vec2 = this.sleighBody.GetPosition();
            var _loc6_:Number = this.sleighBody.GetAngle();
            var _loc7_:b2Vec2 = this.sleighBody.GetLinearVelocity();
            var _loc8_:Number = this.sleighBody.GetAngularVelocity();
            _loc4_.DestroyBody(this.sleighBody);
            this.sleighMC.visible = false;
            var _loc9_:b2BodyDef = new b2BodyDef();
            _loc9_.position = _loc5_;
            _loc9_.angle = _loc6_;
            var _loc10_:b2PolygonDef = new b2PolygonDef();
            _loc10_.density = 3;
            _loc10_.friction = 0.3;
            _loc10_.restitution = 0.3;
            _loc10_.filter = zeroFilter;
            var _loc11_:int = int(this.vertsBrokenSleigh.length);
            var _loc12_:int = 0;
            while(_loc12_ < _loc11_)
            {
                _loc13_ = _loc4_.CreateBody(_loc9_);
                _loc14_ = this.vertsBrokenSleigh[_loc12_];
                _loc15_ = this.brokenSleighMCs[_loc12_];
                _loc10_.vertexCount = _loc14_.length;
                _loc10_.vertices = _loc14_;
                _loc13_.CreateShape(_loc10_);
                _loc13_.SetMassFromShapes();
                _loc13_.SetAngularVelocity(_loc8_);
                _loc13_.SetLinearVelocity(this.sleighBody.GetLinearVelocityFromLocalPoint(_loc13_.GetLocalCenter()));
                _loc13_.SetUserData(_loc15_);
                _loc15_.visible = true;
                paintVector.push(_loc13_);
                _loc12_++;
            }
            if(this.sleighMC.inner.ski.visible == true)
            {
                this.skiSmash(0);
            }
            if(this.sleighMC.inner.stem.visible == true)
            {
                this.stemSmash(0,false);
            }
            if(this.elf1.strappedIn)
            {
                this.breakStrap(this.elf1);
            }
            if(this.elf2.strappedIn)
            {
                this.breakStrap(this.elf2);
            }
            this.elf1.eject();
            this.elf2.eject();
            SoundController.instance.playAreaSoundInstance("SleighSmash",this.sleighBody);
        }
        
        protected function skiSmash(param1:Number) : void
        {
            var _loc13_:b2Body = null;
            var _loc14_:Array = null;
            var _loc15_:Sprite = null;
            var _loc16_:b2Vec2 = null;
            var _loc17_:MovieClip = null;
            var _loc18_:b2Vec2 = null;
            trace(tag + " ski impulse " + param1 + " -> " + _session.iteration);
            delete contactImpulseDict[this.skiShape];
            var _loc2_:ContactListener = _session.contactListener;
            _loc2_.deleteListener(ContactListener.RESULT,this.skiShape);
            _loc2_.deleteListener(ContactListener.ADD,this.frontWheelShape);
            _loc2_.deleteListener(ContactListener.ADD,this.backWheelShape);
            _loc2_.deleteListener(ContactListener.REMOVE,this.frontWheelShape);
            _loc2_.deleteListener(ContactListener.REMOVE,this.backWheelShape);
            var _loc3_:b2World = _session.m_world;
            var _loc4_:b2Vec2 = this.sleighBody.GetPosition();
            var _loc5_:Number = this.sleighBody.GetAngle();
            var _loc6_:b2Vec2 = this.sleighBody.GetLinearVelocity();
            var _loc7_:Number = this.sleighBody.GetAngularVelocity();
            _loc3_.DestroyBody(this.backWheelBody);
            _loc3_.DestroyBody(this.midWheel1Body);
            _loc3_.DestroyBody(this.midWheel2Body);
            _loc3_.DestroyBody(this.frontWheelBody);
            if(this.skiLoop)
            {
                this.skiLoop.stopSound();
            }
            this.frontContacts = 0;
            this.backContacts = 0;
            var _loc8_:b2BodyDef = new b2BodyDef();
            _loc8_.position = _loc4_;
            _loc8_.angle = _loc5_;
            var _loc9_:b2PolygonDef = new b2PolygonDef();
            _loc9_.density = 3;
            _loc9_.friction = 0.3;
            _loc9_.restitution = 0.3;
            _loc9_.filter = zeroFilter;
            var _loc10_:Array = new Array();
            var _loc11_:int = int(this.vertsBrokenSki.length);
            var _loc12_:int = 0;
            while(_loc12_ < _loc11_)
            {
                _loc13_ = _loc3_.CreateBody(_loc8_);
                _loc14_ = this.vertsBrokenSki[_loc12_];
                _loc15_ = this.brokenSkiMCs[_loc12_];
                _loc9_.vertexCount = _loc14_.length;
                _loc9_.vertices = _loc14_;
                _loc13_.CreateShape(_loc9_);
                _loc13_.SetMassFromShapes();
                _loc13_.SetAngularVelocity(_loc7_);
                _loc13_.SetLinearVelocity(this.sleighBody.GetLinearVelocityFromLocalPoint(_loc13_.GetLocalCenter()));
                _loc13_.SetUserData(_loc15_);
                _loc15_.visible = true;
                paintVector.push(_loc13_);
                _loc10_.push(_loc13_);
                _loc12_++;
            }
            if(this.sleighMC.visible)
            {
                this.sleighMC.inner.ski.visible = false;
                this.sleighBody.DestroyShape(this.skiShape);
                _loc9_.vertexCount = this.newBaseVerts.length;
                _loc9_.vertices = this.newBaseVerts;
                this.baseShape = this.sleighBody.CreateShape(_loc9_) as b2PolygonShape;
                contactAddSounds[this.baseShape] = "SleighImpact1";
                _session.contactListener.registerListener(ContactListener.RESULT,this.baseShape,this.contactSleighResultHandler);
                _session.contactListener.registerListener(ContactListener.ADD,this.baseShape,contactAddHandler);
                this.sleighBody.SetMassFromShapes();
                _loc16_ = this.sleighBody.GetLocalCenter();
                _loc16_ = new b2Vec2((_startX - _loc16_.x) * character_scale,(_startY - _loc16_.y) * character_scale);
                _loc17_ = shapeGuide["rear_1"];
                _loc18_ = new b2Vec2(_loc17_.x + _loc16_.x,_loc17_.y + _loc16_.y);
                this.sleighMC.inner.x = _loc18_.x;
                this.sleighMC.inner.y = _loc18_.y;
                _loc11_ = int(_loc10_.length);
                _loc12_ = 0;
                while(_loc12_ < _loc11_)
                {
                    this.antiGravArray.push(_loc10_[_loc12_]);
                    _loc12_++;
                }
            }
            SoundController.instance.playAreaSoundInstance("SkiSmash",this.sleighBody);
        }
        
        protected function stemSmash(param1:Number, param2:Boolean = true) : void
        {
            var _loc14_:Array = null;
            var _loc15_:b2Vec2 = null;
            var _loc16_:MovieClip = null;
            var _loc17_:b2Vec2 = null;
            var _loc18_:b2DistanceJoint = null;
            var _loc19_:b2DistanceJointDef = null;
            var _loc20_:b2DistanceJoint = null;
            trace(tag + " stem impulse " + param1 + " -> " + _session.iteration);
            delete contactImpulseDict[this.stem3Shape];
            var _loc3_:ContactListener = _session.contactListener;
            _loc3_.deleteListener(ContactListener.RESULT,this.stem1Shape);
            _loc3_.deleteListener(ContactListener.RESULT,this.stem2Shape);
            _loc3_.deleteListener(ContactListener.RESULT,this.stem3Shape);
            _loc3_.deleteListener(ContactListener.ADD,this.stem1Shape);
            _loc3_.deleteListener(ContactListener.ADD,this.stem2Shape);
            _loc3_.deleteListener(ContactListener.ADD,this.stem3Shape);
            var _loc4_:b2World = _session.m_world;
            var _loc5_:b2Vec2 = this.sleighBody.GetPosition();
            var _loc6_:Number = this.sleighBody.GetAngle();
            var _loc7_:b2Vec2 = this.sleighBody.GetLinearVelocity();
            var _loc8_:Number = this.sleighBody.GetAngularVelocity();
            var _loc9_:b2BodyDef = new b2BodyDef();
            _loc9_.position = _loc5_;
            _loc9_.angle = _loc6_;
            var _loc10_:b2PolygonDef = new b2PolygonDef();
            _loc10_.density = 3;
            _loc10_.friction = 0.3;
            _loc10_.restitution = 0.3;
            _loc10_.filter = zeroFilter;
            var _loc11_:int = int(this.vertsBrokenStem.length);
            var _loc12_:b2Body = _loc4_.CreateBody(_loc9_);
            var _loc13_:int = 0;
            while(_loc13_ < _loc11_)
            {
                _loc14_ = this.vertsBrokenStem[_loc13_];
                _loc10_.vertexCount = _loc14_.length;
                _loc10_.vertices = _loc14_;
                _loc12_.CreateShape(_loc10_);
                _loc13_++;
            }
            _loc12_.SetMassFromShapes();
            _loc12_.SetAngularVelocity(_loc8_);
            _loc12_.SetLinearVelocity(this.sleighBody.GetLinearVelocityFromLocalPoint(_loc12_.GetLocalCenter()));
            _loc12_.SetUserData(this.stemMC);
            this.stemMC.visible = true;
            paintVector.push(_loc12_);
            if(this.sleighMC.visible)
            {
                this.sleighMC.inner.stem.visible = false;
                this.sleighBody.DestroyShape(this.stem1Shape);
                this.sleighBody.DestroyShape(this.stem2Shape);
                this.sleighBody.DestroyShape(this.stem3Shape);
                this.sleighBody.SetMassFromShapes();
                _loc15_ = this.sleighBody.GetLocalCenter();
                _loc15_ = new b2Vec2((_startX - _loc15_.x) * character_scale,(_startY - _loc15_.y) * character_scale);
                _loc16_ = shapeGuide["rear_1"];
                _loc17_ = new b2Vec2(_loc16_.x + _loc15_.x,_loc16_.y + _loc15_.y);
                this.sleighMC.inner.x = _loc17_.x;
                this.sleighMC.inner.y = _loc17_.y;
                if(this.elf1.strappedIn)
                {
                    _loc18_ = this.strapChest1Joints[0];
                    _loc19_ = new b2DistanceJointDef();
                    _loc19_.body1 = _loc12_;
                    _loc19_.body2 = _loc18_.m_body2;
                    _loc19_.localAnchor1 = _loc18_.m_localAnchor1;
                    _loc19_.localAnchor2 = _loc18_.m_localAnchor2;
                    _loc19_.length = _loc18_.m_length;
                    _loc20_ = _loc4_.CreateJoint(_loc19_) as b2DistanceJoint;
                    _loc4_.DestroyJoint(_loc18_);
                    this.strapChest1Joints[0] = _loc20_;
                }
                if(this.elf2.strappedIn)
                {
                    _loc18_ = this.strapChest2Joints[0];
                    _loc19_ = new b2DistanceJointDef();
                    _loc19_.body1 = _loc12_;
                    _loc19_.body2 = _loc18_.m_body2;
                    _loc19_.localAnchor1 = _loc18_.m_localAnchor1;
                    _loc19_.localAnchor2 = _loc18_.m_localAnchor2;
                    _loc19_.length = _loc18_.m_length;
                    _loc20_ = _loc4_.CreateJoint(_loc19_) as b2DistanceJoint;
                    _loc4_.DestroyJoint(_loc18_);
                    this.strapChest2Joints[0] = _loc20_;
                }
                this.antiGravArray.push(_loc12_);
            }
            if(param2)
            {
                SoundController.instance.playAreaSoundInstance("StemSnap",this.sleighBody);
            }
        }
        
        internal function helmetSmash(param1:Number) : void
        {
            var _loc6_:MovieClip = null;
            trace("helmet impulse " + param1 + " -> " + _session.iteration);
            delete contactImpulseDict[this.helmetShape];
            head1Shape = this.helmetShape;
            contactImpulseDict[head1Shape] = headSmashLimit;
            this.helmetShape = null;
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
        }
        
        override internal function pelvisSmash(param1:Number) : void
        {
            super.pelvisSmash(param1);
        }
        
        override internal function neckBreak(param1:Number, param2:Boolean = true, param3:Boolean = true) : void
        {
            super.neckBreak(param1,param2,param3);
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
            if(this.reignsHand1)
            {
                _session.m_world.DestroyJoint(this.reignsHand1);
                this.reignsHand1 = null;
                this.checkReigns();
            }
        }
        
        override internal function elbowBreak2(param1:Number) : void
        {
            super.elbowBreak2(param1);
            if(this.ejected)
            {
                return;
            }
            if(this.reignsHand2)
            {
                _session.m_world.DestroyJoint(this.reignsHand2);
                this.reignsHand2 = null;
                this.checkReigns();
            }
        }
        
        override internal function kneeBreak1(param1:Number) : void
        {
            super.kneeBreak1(param1);
            if(this.ejected)
            {
                return;
            }
            if(this.sleighFoot1)
            {
                _session.m_world.DestroyJoint(this.sleighFoot1);
                this.sleighFoot1 = null;
                this.checkEject();
            }
        }
        
        override internal function kneeBreak2(param1:Number) : void
        {
            super.kneeBreak2(param1);
            if(this.ejected)
            {
                return;
            }
            if(this.sleighFoot2)
            {
                _session.m_world.DestroyJoint(this.sleighFoot2);
                this.sleighFoot2 = null;
                this.checkEject();
            }
        }
        
        override internal function shoulderBreak1(param1:Number, param2:Boolean = true) : void
        {
            super.shoulderBreak1(param1,param2);
            if(this.ejected)
            {
                return;
            }
            if(this.reignsHand1)
            {
                _session.m_world.DestroyJoint(this.reignsHand1);
                this.reignsHand1 = null;
                this.checkReigns();
            }
            if(upperArm3Body)
            {
                this.antiGravArray.push(upperArm3Body);
            }
        }
        
        override internal function shoulderBreak2(param1:Number, param2:Boolean = true) : void
        {
            super.shoulderBreak2(param1,param2);
            if(this.ejected)
            {
                return;
            }
            if(this.reignsHand2)
            {
                _session.m_world.DestroyJoint(this.reignsHand2);
                this.reignsHand2 = null;
                this.checkReigns();
            }
            if(upperArm4Body)
            {
                this.antiGravArray.push(upperArm4Body);
            }
        }
        
        override internal function hipBreak1(param1:Number, param2:Boolean = true) : void
        {
            super.hipBreak1(param1,param2);
            if(this.ejected)
            {
                return;
            }
            if(this.sleighFoot1)
            {
                _session.m_world.DestroyJoint(this.sleighFoot1);
                this.sleighFoot1 = null;
                this.checkEject();
            }
            if(upperLeg3Body)
            {
                this.antiGravArray.push(upperLeg3Body);
            }
        }
        
        override internal function hipBreak2(param1:Number, param2:Boolean = true) : void
        {
            super.hipBreak2(param1,param2);
            if(this.ejected)
            {
                return;
            }
            if(this.sleighFoot2)
            {
                _session.m_world.DestroyJoint(this.sleighFoot2);
                this.sleighFoot2 = null;
                this.checkEject();
            }
            if(upperLeg4Body)
            {
                this.antiGravArray.push(upperLeg4Body);
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
            this.antiGravArray.push(foot1Body);
        }
        
        private function checkReigns() : void
        {
            var _loc1_:b2BodyDef = null;
            var _loc2_:b2CircleDef = null;
            var _loc3_:b2DistanceJoint = null;
            var _loc4_:b2Vec2 = null;
            var _loc5_:b2Body = null;
            var _loc6_:b2DistanceJointDef = null;
            var _loc7_:b2DistanceJoint = null;
            if(this.reignsHand1 == null && this.reignsHand2 == null)
            {
                _session.m_world.DestroyJoint(this.sleighReigns);
                this.sleighReigns = null;
                _loc1_ = new b2BodyDef();
                _loc2_ = new b2CircleDef();
                _loc2_.density = 0.25;
                _loc2_.friction = 1;
                _loc2_.restitution = 0.1;
                _loc2_.filter.categoryBits = 0;
                _loc2_.filter.maskBits = 0;
                _loc2_.radius = 0.048;
                _loc3_ = this.strapHeadJoints[0];
                _loc4_ = _loc3_.GetAnchor1();
                _loc1_.position.SetV(_loc4_);
                _loc5_ = _session.m_world.CreateBody(_loc1_);
                _loc5_.CreateShape(_loc2_);
                _loc5_.SetMassFromShapes();
                _loc5_.SetLinearVelocity(this.reignsBody.GetLinearVelocity());
                this.antiGravArray.push(_loc5_);
                _loc6_ = new b2DistanceJointDef();
                _loc6_.Initialize(_loc5_,_loc3_.m_body2,_loc4_,_loc3_.m_body2.GetPosition());
                _loc6_.length = _loc3_.m_length;
                _loc7_ = _session.m_world.CreateJoint(_loc6_) as b2DistanceJoint;
                _session.m_world.DestroyJoint(_loc3_);
                this.strapHeadJoints[0] = _loc7_;
                _session.m_world.DestroyBody(this.reignsBody);
                this.reignsBody = null;
                this.checkEject();
            }
        }
        
        private function breakStrap(param1:SleighElf) : void
        {
            var _loc9_:Array = null;
            var _loc10_:b2Vec2 = null;
            var _loc11_:String = null;
            param1.strappedIn = false;
            var _loc2_:b2BodyDef = new b2BodyDef();
            var _loc3_:b2CircleDef = new b2CircleDef();
            _loc3_.density = 0.25;
            _loc3_.friction = 1;
            _loc3_.restitution = 0.1;
            _loc3_.filter.categoryBits = 0;
            _loc3_.filter.maskBits = 0;
            _loc3_.radius = 0.048;
            if(param1 == this.elf1)
            {
                _loc9_ = this.strapChest1Joints;
                _loc10_ = new b2Vec2();
                _loc11_ = "StrapSnap1";
            }
            else
            {
                _loc9_ = this.strapChest2Joints;
                _loc10_ = new b2Vec2(0,-0.016);
                _loc11_ = "StrapSnap2";
            }
            var _loc4_:b2DistanceJoint = _loc9_[0];
            var _loc5_:b2Vec2 = _loc4_.GetAnchor1();
            _loc2_.position.SetV(_loc5_);
            var _loc6_:b2Body = _session.m_world.CreateBody(_loc2_);
            _loc6_.CreateShape(_loc3_);
            _loc6_.SetMassFromShapes();
            _loc6_.SetLinearVelocity(this.sleighBody.GetLinearVelocityFromWorldPoint(_loc5_));
            this.antiGravArray.push(_loc6_);
            var _loc7_:b2DistanceJointDef = new b2DistanceJointDef();
            _loc7_.Initialize(_loc6_,_loc4_.m_body2,_loc5_,_loc4_.m_body2.GetWorldPoint(_loc10_));
            _loc7_.length = _loc4_.m_length;
            var _loc8_:b2DistanceJoint = _session.m_world.CreateJoint(_loc7_) as b2DistanceJoint;
            _session.m_world.DestroyJoint(_loc4_);
            _loc9_[0] = _loc8_;
            SoundController.instance.playAreaSoundInstance(_loc11_,_loc6_);
        }
        
        public function elfHeadRemove(param1:SleighElf, param2:Boolean) : void
        {
            var _loc7_:int = 0;
            var _loc8_:b2DistanceJoint = null;
            var _loc9_:b2DistanceJoint = null;
            var _loc10_:b2DistanceJoint = null;
            if(!param1.headAttached)
            {
                return;
            }
            param1.headAttached = false;
            var _loc3_:b2BodyDef = new b2BodyDef();
            var _loc4_:b2CircleDef = new b2CircleDef();
            _loc4_.density = 0.25;
            _loc4_.friction = 1;
            _loc4_.restitution = 0.1;
            _loc4_.filter.categoryBits = 0;
            _loc4_.filter.maskBits = 0;
            _loc4_.radius = 0.048;
            _loc3_.position = param1.head1Body.GetWorldPoint(new b2Vec2(-0.288,0.064));
            var _loc5_:b2Body = _session.m_world.CreateBody(_loc3_);
            _loc5_.CreateShape(_loc4_);
            _loc5_.SetMassFromShapes();
            _loc5_.SetLinearVelocity(param1.head1Body.GetLinearVelocity());
            this.antiGravArray.push(_loc5_);
            var _loc6_:b2DistanceJointDef = new b2DistanceJointDef();
            if(param1 == this.elf1)
            {
                _loc7_ = 7;
                _loc8_ = this.strapHeadJoints[_loc7_];
                _loc6_.Initialize(_loc8_.m_body1,_loc5_,_loc8_.m_body1.GetPosition(),_loc3_.position);
                _loc6_.length = _loc8_.m_length;
                _loc9_ = _session.m_world.CreateJoint(_loc6_) as b2DistanceJoint;
                this.strapHeadJoints[_loc7_] = _loc9_;
                _loc7_ += 1;
                _loc10_ = this.strapHeadJoints[_loc7_];
                _loc6_.Initialize(_loc5_,_loc10_.m_body2,_loc3_.position,_loc10_.m_body2.GetPosition());
                _loc6_.length = _loc8_.m_length;
                _loc9_ = _session.m_world.CreateJoint(_loc6_) as b2DistanceJoint;
                this.strapHeadJoints[_loc7_] = _loc9_;
                if(!param2)
                {
                    _session.m_world.DestroyJoint(_loc8_);
                    _session.m_world.DestroyJoint(_loc10_);
                }
            }
            else
            {
                _loc7_ = int(this.strapHeadJoints.length - 1);
                _loc8_ = this.strapHeadJoints[_loc7_];
                _loc6_.Initialize(_loc8_.m_body1,_loc5_,_loc8_.m_body1.GetPosition(),_loc3_.position);
                _loc6_.length = _loc8_.m_length;
                _loc9_ = _session.m_world.CreateJoint(_loc6_) as b2DistanceJoint;
                this.strapHeadJoints[_loc7_] = _loc9_;
                if(!param2)
                {
                    _session.m_world.DestroyJoint(_loc8_);
                }
            }
        }
        
        public function elfChestRemove(param1:SleighElf, param2:Boolean) : void
        {
            var _loc7_:int = 0;
            var _loc8_:b2DistanceJoint = null;
            var _loc9_:b2DistanceJoint = null;
            if(!param1.chestAttached)
            {
                return;
            }
            param1.chestAttached = false;
            var _loc3_:b2BodyDef = new b2BodyDef();
            var _loc4_:b2CircleDef = new b2CircleDef();
            _loc4_.density = 0.25;
            _loc4_.friction = 1;
            _loc4_.restitution = 0.1;
            _loc4_.filter.categoryBits = 0;
            _loc4_.filter.maskBits = 0;
            _loc4_.radius = 0.048;
            _loc3_.position = param1.chestBody.GetWorldPoint(new b2Vec2(0,0.16));
            var _loc5_:b2Body = _session.m_world.CreateBody(_loc3_);
            _loc5_.CreateShape(_loc4_);
            _loc5_.SetMassFromShapes();
            _loc5_.SetLinearVelocity(param1.chestBody.GetLinearVelocity());
            this.antiGravArray.push(_loc5_);
            var _loc6_:b2DistanceJointDef = new b2DistanceJointDef();
            if(param1 == this.elf1)
            {
                _loc7_ = int(this.strapChest1Joints.length - 1);
                _loc8_ = this.strapChest1Joints[_loc7_];
                _loc6_.Initialize(_loc8_.m_body1,_loc5_,_loc8_.m_body1.GetWorldPoint(new b2Vec2(0,-0.016)),_loc3_.position);
                _loc6_.length = _loc8_.m_length;
                _loc9_ = _session.m_world.CreateJoint(_loc6_) as b2DistanceJoint;
                this.strapChest1Joints[_loc7_] = _loc9_;
            }
            else
            {
                _loc7_ = int(this.strapChest2Joints.length - 1);
                _loc8_ = this.strapChest2Joints[_loc7_];
                _loc6_.Initialize(_loc8_.m_body1,_loc5_,_loc8_.m_body1.GetWorldPoint(new b2Vec2(0,-0.016)),_loc3_.position);
                _loc6_.length = _loc8_.m_length;
                _loc9_ = _session.m_world.CreateJoint(_loc6_) as b2DistanceJoint;
                this.strapChest2Joints[_loc7_] = _loc9_;
            }
            if(!headSmashed)
            {
                _session.m_world.DestroyJoint(_loc8_);
            }
        }
        
        public function mourn(param1:SleighElf) : void
        {
            if(!_dead)
            {
                if(param1 == this.elf1)
                {
                    addVocals("Mourn2",3);
                }
                if(param1 == this.elf2)
                {
                    addVocals("Mourn1",3);
                }
            }
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

