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
    
    public class MotorCart extends CharacterB2D
    {
        internal var ejected:Boolean;
        
        protected var wheelMaxSpeed:Number = 50;
        
        protected var wheelCurrentSpeed:Number;
        
        protected var wheelNewSpeed:Number;
        
        protected var wheelContacts:Number = 0;
        
        protected var backContacts:Number = 0;
        
        protected var frontContacts:Number = 0;
        
        protected var accelStep:Number = 2;
        
        protected var maxTorque:Number = 100000;
        
        protected var impulseMagnitude:Number = 1.25;
        
        protected var impulseOffset:Number = 1;
        
        protected var maxSpinAV:Number = 5;
        
        protected var wheelLoop1:AreaSoundLoop;
        
        protected var wheelLoop2:AreaSoundLoop;
        
        protected var wheelLoop3:AreaSoundLoop;
        
        protected var motorSound:AreaSoundLoop;
        
        internal var cartSmashLimit:Number = 100;
        
        internal var mainSmashLimit:Number = 200;
        
        internal var crackerSmashLimit:Number = 1;
        
        internal var mainSmashed:Boolean;
        
        protected var jumpTranslation:Number;
        
        protected var handleAnchorPoint:b2Vec2;
        
        protected var pelvisAnchorPoint:b2Vec2;
        
        protected var leg1AnchorPoint:b2Vec2;
        
        protected var leg2AnchorPoint:b2Vec2;
        
        protected var mainPelvisJointDef:b2RevoluteJointDef;
        
        protected var mainHand1JointDef:b2RevoluteJointDef;
        
        protected var mainHand2JointDef:b2RevoluteJointDef;
        
        protected var mainLeg1JointDef:b2RevoluteJointDef;
        
        protected var mainLeg2JointDef:b2RevoluteJointDef;
        
        protected var cartShape:b2Shape;
        
        protected var mainShape1:b2Shape;
        
        protected var mainShape2:b2Shape;
        
        protected var mainShape3:b2Shape;
        
        protected var mainShape4:b2Shape;
        
        protected var crackerShape:b2Shape;
        
        protected var sodaShape:b2Shape;
        
        protected var backWheelShape:b2Shape;
        
        protected var frontWheelShape:b2Shape;
        
        protected var handleShape:b2Shape;
        
        protected var shaftShape:b2Shape;
        
        internal var mainBody:b2Body;
        
        internal var cartBody:b2Body;
        
        internal var shaftBody:b2Body;
        
        internal var backShockBody:b2Body;
        
        internal var frontShockBody:b2Body;
        
        internal var backWheelBody:b2Body;
        
        internal var frontWheelBody:b2Body;
        
        internal var groceryBodies:Array;
        
        internal var shockMC:Sprite;
        
        internal var mainMC:MovieClip;
        
        internal var frontEndMC:MovieClip;
        
        internal var shaftMC:MovieClip;
        
        internal var backWheelMC:MovieClip;
        
        internal var frontWheelMC:MovieClip;
        
        internal var groceryMCs:Array;
        
        protected var mainFrontMC:Sprite;
        
        protected var mainBaseMC:Sprite;
        
        protected var mainRearMC:Sprite;
        
        protected var mainSeatMC:Sprite;
        
        protected var cartMC:Sprite;
        
        internal var backShockJoint:b2PrismaticJoint;
        
        internal var frontShockJoint:b2PrismaticJoint;
        
        internal var backWheelJoint:b2RevoluteJoint;
        
        internal var frontWheelJoint:b2RevoluteJoint;
        
        internal var mainCart:b2RevoluteJoint;
        
        internal var mainShaft:b2RevoluteJoint;
        
        internal var mainPelvis:b2RevoluteJoint;
        
        internal var mainHand1:b2RevoluteJoint;
        
        internal var mainHand2:b2RevoluteJoint;
        
        internal var mainLeg1:b2RevoluteJoint;
        
        internal var mainLeg2:b2RevoluteJoint;
        
        public function MotorCart(param1:Number, param2:Number, param3:DisplayObject, param4:Session)
        {
            super(param1,param2,param3,param4,-1,"Char4");
            this.jumpTranslation = 20 / m_physScale;
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
                _loc1_ = this.mainBody.GetAngle();
                _loc2_ = this.mainBody.GetAngularVelocity();
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
                _loc6_ = this.mainBody.GetLocalCenter();
                this.mainBody.ApplyImpulse(new b2Vec2(_loc5_,-_loc4_),this.mainBody.GetWorldPoint(new b2Vec2(_loc6_.x + this.impulseOffset,_loc6_.y)));
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
                _loc1_ = this.mainBody.GetAngle();
                _loc2_ = this.mainBody.GetAngularVelocity();
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
                _loc7_ = this.mainBody.GetLocalCenter();
                this.mainBody.ApplyImpulse(new b2Vec2(_loc6_,-_loc5_),this.mainBody.GetWorldPoint(new b2Vec2(_loc7_.x - this.impulseOffset,_loc7_.y)));
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
                    this.motorSound = SoundController.instance.playAreaSoundLoop("ElectricMotor1",this.backWheelBody,1);
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
                this.frontWheelJoint.SetMotorSpeed(this.wheelNewSpeed);
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
                    this.motorSound = SoundController.instance.playAreaSoundLoop("ElectricMotor1",this.backWheelBody,1);
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
                this.frontWheelJoint.SetMotorSpeed(this.wheelNewSpeed);
            }
        }
        
        override internal function upAndDownActions() : void
        {
            if(this.backWheelJoint.IsMotorEnabled())
            {
                this.backWheelJoint.EnableMotor(false);
                this.frontWheelJoint.EnableMotor(false);
                this.motorSound.fadeOut(0.25);
                this.motorSound = null;
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
                this.backShockJoint.SetMotorSpeed(5);
                this.frontShockJoint.SetMotorSpeed(5);
                this.backShockJoint.SetLimits(0,this.jumpTranslation);
                this.frontShockJoint.SetLimits(0,this.jumpTranslation);
                this.backShockJoint.EnableMotor(true);
                this.frontShockJoint.EnableMotor(true);
                SoundController.instance.playAreaSoundInstance("SegwayJump",this.backWheelBody);
            }
            else if(this.backShockJoint.GetMotorSpeed() > 0)
            {
                if(this.backShockJoint.GetJointTranslation() > this.jumpTranslation)
                {
                    this.backShockJoint.SetMotorSpeed(-1);
                    this.frontShockJoint.SetMotorSpeed(-1);
                }
            }
            else if(this.backShockJoint.GetMotorSpeed() < 0)
            {
                if(this.backShockJoint.GetJointTranslation() < 0)
                {
                    this.backShockJoint.EnableMotor(false);
                    this.frontShockJoint.EnableMotor(false);
                    this.backShockJoint.SetLimits(0,0);
                    this.frontShockJoint.SetLimits(0,0);
                    this.backShockJoint.SetMotorSpeed(0);
                    this.frontShockJoint.SetMotorSpeed(0);
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
                    if(this.backShockJoint.GetJointTranslation() > this.jumpTranslation)
                    {
                        this.backShockJoint.SetMotorSpeed(-1);
                        this.frontShockJoint.SetMotorSpeed(-1);
                    }
                }
                else if(this.backShockJoint.GetMotorSpeed() < 0)
                {
                    if(this.backShockJoint.GetJointTranslation() < 0)
                    {
                        this.backShockJoint.EnableMotor(false);
                        this.frontShockJoint.EnableMotor(false);
                        this.backShockJoint.SetLimits(0,0);
                        this.frontShockJoint.SetLimits(0,0);
                        this.backShockJoint.SetMotorSpeed(0);
                        this.frontShockJoint.SetMotorSpeed(0);
                    }
                }
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
            var _loc1_:Number = NaN;
            if(this.wheelContacts > 0)
            {
                _loc1_ = Math.abs(this.backWheelBody.GetAngularVelocity());
                if(_loc1_ > 50)
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
                else if(_loc1_ > 25)
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
                else if(_loc1_ > 5)
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
                    break;
                case 6:
                    this.lungePoseLeft();
                    break;
                case 7:
                    this.lungePoseRight();
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
            this.mainSmashed = false;
        }
        
        override public function paint() : void
        {
            var _loc2_:b2Vec2 = null;
            super.paint();
            var _loc1_:b2Vec2 = this.frontWheelBody.GetWorldCenter();
            this.frontWheelMC.x = _loc1_.x * m_physScale;
            this.frontWheelMC.y = _loc1_.y * m_physScale;
            this.frontWheelMC.inner.rotation = this.frontWheelBody.GetAngle() * (180 / Math.PI) % 360;
            _loc1_ = this.backWheelBody.GetWorldCenter();
            this.backWheelMC.x = _loc1_.x * m_physScale;
            this.backWheelMC.y = _loc1_.y * m_physScale;
            this.backWheelMC.inner.rotation = this.backWheelBody.GetAngle() * (180 / Math.PI) % 360;
            if(!this.mainSmashed)
            {
                _loc1_ = this.backShockJoint.GetAnchor1();
                _loc2_ = this.backShockBody.GetWorldCenter();
                this.shockMC.graphics.clear();
                this.shockMC.graphics.lineStyle(3,792077);
                this.shockMC.graphics.moveTo(_loc1_.x * m_physScale,_loc1_.y * m_physScale);
                this.shockMC.graphics.lineTo(_loc2_.x * m_physScale,_loc2_.y * m_physScale);
                _loc1_ = this.frontShockJoint.GetAnchor1();
                _loc2_ = this.frontShockBody.GetWorldCenter();
                this.shockMC.graphics.moveTo(_loc1_.x * m_physScale,_loc1_.y * m_physScale);
                this.shockMC.graphics.lineTo(_loc2_.x * m_physScale,_loc2_.y * m_physScale);
                this.cartMC.x = this.mainMC.x;
                this.cartMC.y = this.mainMC.y;
                this.cartMC.rotation = this.mainMC.rotation;
            }
        }
        
        override internal function createDictionaries() : void
        {
            super.createDictionaries();
            contactImpulseDict[this.cartShape] = this.cartSmashLimit;
            contactImpulseDict[this.mainShape1] = this.mainSmashLimit;
            contactImpulseDict[this.crackerShape] = this.crackerSmashLimit;
            contactImpulseDict[this.sodaShape] = this.crackerSmashLimit;
            contactAddSounds[this.backWheelShape] = "CarTire1";
            contactAddSounds[this.frontWheelShape] = "CarTire1";
            contactAddSounds[this.mainShape3] = "BikeHit3";
            contactAddSounds[this.cartShape] = "BikeHit1";
        }
        
        override internal function createBodies() : void
        {
            var _loc17_:b2PolygonDef = null;
            var _loc23_:MovieClip = null;
            var _loc24_:b2BodyDef = null;
            var _loc25_:b2Body = null;
            super.createBodies();
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
                _loc23_ = shapeGuide["chestVert" + [_loc6_]];
                _loc1_.vertices[_loc6_] = new b2Vec2(_loc23_.x / character_scale,_loc23_.y / character_scale);
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
                _loc23_ = shapeGuide["pelvisVert" + [_loc6_]];
                _loc1_.vertices[_loc6_] = new b2Vec2(_loc23_.x / character_scale,_loc23_.y / character_scale);
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
            var _loc9_:b2BodyDef = new b2BodyDef();
            var _loc10_:b2BodyDef = new b2BodyDef();
            var _loc11_:b2BodyDef = new b2BodyDef();
            var _loc12_:b2BodyDef = new b2BodyDef();
            var _loc13_:b2BodyDef = new b2BodyDef();
            var _loc14_:b2PolygonDef = new b2PolygonDef();
            var _loc15_:b2PolygonDef = new b2PolygonDef();
            var _loc16_:b2PolygonDef = new b2PolygonDef();
            _loc1_.density = 4;
            _loc1_.friction = 0.3;
            _loc1_.restitution = 0.1;
            _loc1_.filter = new b2FilterData();
            _loc1_.filter.categoryBits = 513;
            _loc1_.filter.groupIndex = -2;
            this.mainBody = _session.m_world.CreateBody(_loc7_);
            this.shaftBody = _session.m_world.CreateBody(_loc9_);
            _loc1_.vertexCount = 4;
            _loc6_ = 0;
            while(_loc6_ < 4)
            {
                _loc23_ = shapeGuide["frontVert" + [_loc6_ + 1]];
                _loc1_.vertices[_loc6_] = new b2Vec2(_startX + _loc23_.x / character_scale,_startY + _loc23_.y / character_scale);
                _loc6_++;
            }
            this.mainShape1 = this.mainBody.CreateShape(_loc1_);
            _session.contactListener.registerListener(ContactListener.RESULT,this.mainShape1,this.contactMainResultHandler);
            _loc5_ = shapeGuide["baseShape"];
            var _loc18_:b2Vec2 = new b2Vec2(_startX + _loc5_.x / character_scale,_startY + _loc5_.y / character_scale);
            var _loc19_:Number = _loc5_.rotation / (180 / Math.PI);
            _loc1_.SetAsOrientedBox(_loc5_.scaleX * 5 / character_scale,_loc5_.scaleY * 5 / character_scale,_loc18_,_loc19_);
            this.mainShape2 = this.mainBody.CreateShape(_loc1_);
            _session.contactListener.registerListener(ContactListener.RESULT,this.mainShape2,this.contactMainResultHandler);
            _loc5_ = shapeGuide["cartShape"];
            _loc18_ = new b2Vec2(_startX + _loc5_.x / character_scale,_startY + _loc5_.y / character_scale);
            _loc19_ = _loc5_.rotation / (180 / Math.PI);
            _loc1_.SetAsOrientedBox(_loc5_.scaleX * 5 / character_scale,_loc5_.scaleY * 5 / character_scale,_loc18_,_loc19_);
            this.cartShape = this.mainBody.CreateShape(_loc1_);
            _session.contactListener.registerListener(ContactListener.RESULT,this.cartShape,contactResultHandler);
            _session.contactListener.registerListener(ContactListener.ADD,this.cartShape,contactAddHandler);
            _loc5_ = shapeGuide["handleShape"];
            _loc18_ = new b2Vec2(_startX + _loc5_.x / character_scale,_startY + _loc5_.y / character_scale);
            _loc19_ = _loc5_.rotation / (180 / Math.PI);
            _loc1_.SetAsOrientedBox(_loc5_.scaleX * 5 / character_scale,_loc5_.scaleY * 5 / character_scale,_loc18_,_loc19_);
            this.handleShape = this.shaftBody.CreateShape(_loc1_);
            _loc1_.filter = zeroFilter.Copy();
            _loc1_.filter.groupIndex = -2;
            _loc5_ = shapeGuide["seatShape"];
            _loc18_ = new b2Vec2(_startX + _loc5_.x / character_scale,_startY + _loc5_.y / character_scale);
            _loc19_ = _loc5_.rotation / (180 / Math.PI);
            _loc1_.SetAsOrientedBox(_loc5_.scaleX * 5 / character_scale,_loc5_.scaleY * 5 / character_scale,_loc18_,_loc19_);
            this.mainShape3 = this.mainBody.CreateShape(_loc1_);
            _session.contactListener.registerListener(ContactListener.RESULT,this.mainShape3,this.contactMainResultHandler);
            _session.contactListener.registerListener(ContactListener.ADD,this.mainShape3,contactAddHandler);
            _loc1_.vertexCount = 4;
            _loc6_ = 0;
            while(_loc6_ < 4)
            {
                _loc23_ = shapeGuide["rearVert" + [_loc6_ + 1]];
                _loc1_.vertices[_loc6_] = new b2Vec2(_startX + _loc23_.x / character_scale,_startY + _loc23_.y / character_scale);
                _loc6_++;
            }
            this.mainShape4 = this.mainBody.CreateShape(_loc1_);
            _session.contactListener.registerListener(ContactListener.RESULT,this.mainShape4,this.contactMainResultHandler);
            this.mainBody.SetMassFromShapes();
            paintVector.push(this.mainBody);
            _loc5_ = shapeGuide["shaftShape"];
            _loc18_ = new b2Vec2(_startX + _loc5_.x / character_scale,_startY + _loc5_.y / character_scale);
            _loc19_ = _loc5_.rotation / (180 / Math.PI);
            _loc1_.SetAsOrientedBox(_loc5_.scaleX * 5 / character_scale,_loc5_.scaleY * 5 / character_scale,_loc18_,_loc19_);
            this.shaftShape = this.shaftBody.CreateShape(_loc1_);
            this.shaftBody.SetMassFromShapes();
            paintVector.push(this.shaftBody);
            _loc2_.density = 5;
            _loc2_.friction = 1;
            _loc2_.restitution = 0.3;
            _loc2_.filter.categoryBits = 513;
            _loc2_.filter.groupIndex = -2;
            _loc5_ = shapeGuide["backWheelShape"];
            _loc10_.position.Set(_startX + _loc5_.x / character_scale,_startY + _loc5_.y / character_scale);
            _loc10_.angle = _loc5_.rotation / (180 / Math.PI);
            _loc2_.localPosition.Set(0,0);
            _loc2_.radius = _loc5_.width / 2 / character_scale;
            this.backWheelBody = _session.m_world.CreateBody(_loc10_);
            this.backWheelShape = this.backWheelBody.CreateShape(_loc2_);
            this.backWheelBody.SetMassFromShapes();
            _session.contactListener.registerListener(ContactListener.ADD,this.backWheelShape,this.wheelContactAdd);
            _session.contactListener.registerListener(ContactListener.REMOVE,this.backWheelShape,this.wheelContactRemove);
            _loc5_ = shapeGuide["frontWheelShape"];
            _loc11_.position.Set(_startX + _loc5_.x / character_scale,_startY + _loc5_.y / character_scale);
            _loc11_.angle = _loc5_.rotation / (180 / Math.PI);
            _loc2_.radius = _loc5_.width / 2 / character_scale;
            this.frontWheelBody = _session.m_world.CreateBody(_loc11_);
            this.frontWheelShape = this.frontWheelBody.CreateShape(_loc2_);
            this.frontWheelBody.SetMassFromShapes();
            _session.contactListener.registerListener(ContactListener.ADD,this.frontWheelShape,this.wheelContactAdd);
            _session.contactListener.registerListener(ContactListener.REMOVE,this.frontWheelShape,this.wheelContactRemove);
            var _loc20_:Number = 12 / character_scale;
            _loc1_.SetAsOrientedBox(_loc20_,_loc20_,_loc10_.position);
            this.backShockBody = _session.m_world.CreateBody(_loc12_);
            this.backShockBody.CreateShape(_loc1_);
            this.backShockBody.SetMassFromShapes();
            _loc1_.SetAsOrientedBox(_loc20_,_loc20_,_loc11_.position);
            this.frontShockBody = _session.m_world.CreateBody(_loc13_);
            this.frontShockBody.CreateShape(_loc1_);
            this.frontShockBody.SetMassFromShapes();
            _loc1_.isSensor = false;
            _loc1_.filter.groupIndex = 0;
            _loc1_.density = 0.25;
            this.groceryBodies = new Array();
            _loc6_ = 0;
            while(_loc6_ < 10)
            {
                _loc24_ = new b2BodyDef();
                _loc5_ = shapeGuide["box" + _loc6_];
                _loc24_.position.Set(_startX + _loc5_.x / character_scale,_startY + _loc5_.y / character_scale);
                _loc24_.angle = _loc5_.rotation / (180 / Math.PI);
                _loc1_.SetAsBox(_loc5_.scaleX * 5 / character_scale,_loc5_.scaleY * 5 / character_scale);
                _loc25_ = _session.m_world.CreateBody(_loc24_);
                _loc25_.CreateShape(_loc1_);
                _loc25_.SetMassFromShapes();
                paintVector.push(_loc25_);
                this.groceryBodies.push(_loc25_);
                _loc6_++;
            }
            var _loc21_:b2Body = this.groceryBodies[4];
            this.crackerShape = _loc21_.GetShapeList();
            _session.contactListener.registerListener(ContactListener.RESULT,this.crackerShape,contactResultHandler);
            var _loc22_:b2Body = this.groceryBodies[3];
            this.sodaShape = _loc22_.GetShapeList();
            _session.contactListener.registerListener(ContactListener.RESULT,this.sodaShape,contactResultHandler);
        }
        
        override internal function createMovieClips() : void
        {
            var _loc7_:MovieClip = null;
            var _loc8_:b2Body = null;
            super.createMovieClips();
            _session.containerSprite.addChildAt(pelvisMC,_session.containerSprite.getChildIndex(chestMC));
            var _loc1_:MovieClip = sourceObject["cartPieces"];
            _session.particleController.createBMDArray("cart",_loc1_);
            _loc1_ = sourceObject["crackers"];
            _session.particleController.createBMDArray("crackers",_loc1_);
            _loc1_ = sourceObject["cola"];
            _session.particleController.createBMDArray("cola",_loc1_);
            this.shockMC = new Sprite();
            this.mainMC = sourceObject["main"];
            var _loc9_:* = 1 / mc_scale;
            this.mainMC.scaleY = 1 / mc_scale;
            this.mainMC.scaleX = _loc9_;
            this.backWheelMC = sourceObject["backWheel"];
            _loc9_ = 1 / mc_scale;
            this.backWheelMC.scaleY = 1 / mc_scale;
            this.backWheelMC.scaleX = _loc9_;
            this.frontWheelMC = sourceObject["frontWheel"];
            _loc9_ = 1 / mc_scale;
            this.frontWheelMC.scaleY = 1 / mc_scale;
            this.frontWheelMC.scaleX = _loc9_;
            this.shaftMC = sourceObject["shaft"];
            _loc9_ = 1 / mc_scale;
            this.shaftMC.scaleY = 1 / mc_scale;
            this.shaftMC.scaleX = _loc9_;
            this.mainFrontMC = sourceObject["mainFront"];
            _loc9_ = 1 / mc_scale;
            this.mainFrontMC.scaleY = 1 / mc_scale;
            this.mainFrontMC.scaleX = _loc9_;
            this.mainFrontMC.visible = false;
            this.mainBaseMC = sourceObject["mainBase"];
            _loc9_ = 1 / mc_scale;
            this.mainBaseMC.scaleY = 1 / mc_scale;
            this.mainBaseMC.scaleX = _loc9_;
            this.mainBaseMC.visible = false;
            this.mainSeatMC = sourceObject["mainSeat"];
            _loc9_ = 1 / mc_scale;
            this.mainSeatMC.scaleY = 1 / mc_scale;
            this.mainSeatMC.scaleX = _loc9_;
            this.mainSeatMC.visible = false;
            this.mainRearMC = sourceObject["mainRear"];
            _loc9_ = 1 / mc_scale;
            this.mainRearMC.scaleY = 1 / mc_scale;
            this.mainRearMC.scaleX = _loc9_;
            this.mainRearMC.visible = false;
            var _loc2_:b2Vec2 = this.mainBody.GetLocalCenter();
            _loc2_ = new b2Vec2((_startX - _loc2_.x) * character_scale,(_startY - _loc2_.y) * character_scale);
            var _loc3_:MovieClip = shapeGuide["rearVert4"];
            var _loc4_:b2Vec2 = new b2Vec2(_loc3_.x + _loc2_.x,_loc3_.y + _loc2_.y);
            this.mainMC.inner.x = _loc4_.x;
            this.mainMC.inner.y = _loc4_.y;
            _loc2_ = this.shaftBody.GetLocalCenter();
            _loc2_ = new b2Vec2((_startX - _loc2_.x) * character_scale,(_startY - _loc2_.y) * character_scale);
            _loc3_ = shapeGuide["shaftShape"];
            _loc4_ = new b2Vec2(_loc3_.x + _loc2_.x,_loc3_.y + _loc2_.y);
            this.shaftMC.inner.x = _loc4_.x;
            this.shaftMC.inner.y = _loc4_.y;
            this.mainBody.SetUserData(this.mainMC);
            this.backWheelBody.SetUserData(this.backWheelMC);
            this.frontWheelBody.SetUserData(this.frontWheelMC);
            this.shaftBody.SetUserData(this.shaftMC);
            _session.containerSprite.addChildAt(this.shockMC,_session.containerSprite.getChildIndex(pelvisMC));
            _session.containerSprite.addChildAt(this.backWheelMC,_session.containerSprite.getChildIndex(pelvisMC));
            _session.containerSprite.addChildAt(this.frontWheelMC,_session.containerSprite.getChildIndex(pelvisMC));
            _session.containerSprite.addChildAt(this.shaftMC,_session.containerSprite.getChildIndex(pelvisMC));
            _session.containerSprite.addChildAt(this.mainMC,_session.containerSprite.getChildIndex(pelvisMC));
            _session.containerSprite.addChildAt(this.mainBaseMC,_session.containerSprite.getChildIndex(pelvisMC));
            _session.containerSprite.addChildAt(this.mainFrontMC,_session.containerSprite.getChildIndex(pelvisMC));
            _session.containerSprite.addChildAt(this.mainRearMC,_session.containerSprite.getChildIndex(pelvisMC));
            _session.containerSprite.addChildAt(this.mainSeatMC,_session.containerSprite.getChildIndex(pelvisMC));
            this.groceryMCs = new Array();
            var _loc5_:int = 0;
            while(_loc5_ < 10)
            {
                _loc7_ = sourceObject["box" + _loc5_];
                _loc9_ = 1 / mc_scale;
                _loc7_.scaleY = 1 / mc_scale;
                _loc7_.scaleX = _loc9_;
                _loc8_ = this.groceryBodies[_loc5_];
                _loc8_.SetUserData(_loc7_);
                this.groceryMCs.push(_loc7_);
                _session.containerSprite.addChildAt(_loc7_,_session.containerSprite.getChildIndex(this.mainMC));
                _loc5_++;
            }
            this.cartMC = new Sprite();
            _loc9_ = 1 / mc_scale;
            this.cartMC.scaleY = 1 / mc_scale;
            this.cartMC.scaleX = _loc9_;
            var _loc6_:Sprite = this.mainMC.inner.cart;
            this.cartMC.addChild(_loc6_);
            _loc6_.x += this.mainMC.inner.x;
            _loc6_.y += this.mainMC.inner.y;
            _session.containerSprite.addChildAt(this.cartMC,_session.containerSprite.getChildIndex(lowerArm1MC) + 1);
        }
        
        override internal function resetMovieClips() : void
        {
            var _loc3_:b2Body = null;
            var _loc4_:MovieClip = null;
            super.resetMovieClips();
            this.mainFrontMC.visible = false;
            this.mainBaseMC.visible = false;
            this.mainSeatMC.visible = false;
            this.mainRearMC.visible = false;
            this.mainMC.visible = true;
            this.cartMC.visible = true;
            this.mainBody.SetUserData(this.mainMC);
            this.backWheelBody.SetUserData(this.backWheelMC);
            this.frontWheelBody.SetUserData(this.frontWheelMC);
            this.shaftBody.SetUserData(this.shaftMC);
            this.shockMC.graphics.clear();
            var _loc1_:int = 0;
            while(_loc1_ < 10)
            {
                _loc3_ = this.groceryBodies[_loc1_];
                _loc4_ = this.groceryMCs[_loc1_];
                _loc3_.SetUserData(_loc4_);
                _loc4_.visible = true;
                _loc4_.gotoAndStop(1);
                _loc1_++;
            }
            var _loc2_:MovieClip = sourceObject["cartPieces"];
            _session.particleController.createBMDArray("cart",_loc2_);
            _loc2_ = sourceObject["crackers"];
            _session.particleController.createBMDArray("crackers",_loc2_);
            _loc2_ = sourceObject["cola"];
            _session.particleController.createBMDArray("cola",_loc2_);
        }
        
        override internal function createJoints() : void
        {
            var _loc1_:Number = NaN;
            var _loc2_:Number = NaN;
            var _loc3_:Number = NaN;
            super.createJoints();
            var _loc4_:Number = 180 / Math.PI;
            _loc1_ = upperLeg1Body.GetAngle() - pelvisBody.GetAngle();
            _loc2_ = -80 / _loc4_ - _loc1_;
            _loc3_ = -75 / _loc4_ - _loc1_;
            _loc1_ = upperLeg2Body.GetAngle() - pelvisBody.GetAngle();
            _loc2_ = -80 / _loc4_ - _loc1_;
            _loc3_ = -75 / _loc4_ - _loc1_;
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
            var _loc7_:MovieClip = shapeGuide["backWheelShape"];
            _loc6_.Set(_startX + _loc7_.x / character_scale,_startY + _loc7_.y / character_scale);
            _loc5_.Initialize(this.mainBody,this.backShockBody,_loc6_,new b2Vec2(0,1));
            this.backShockJoint = _session.m_world.CreateJoint(_loc5_) as b2PrismaticJoint;
            _loc7_ = shapeGuide["frontWheelShape"];
            _loc6_.Set(_startX + _loc7_.x / character_scale,_startY + _loc7_.y / character_scale);
            _loc5_.Initialize(this.mainBody,this.frontShockBody,_loc6_,new b2Vec2(0,1));
            this.frontShockJoint = _session.m_world.CreateJoint(_loc5_) as b2PrismaticJoint;
            var _loc8_:b2RevoluteJointDef = new b2RevoluteJointDef();
            _loc8_.maxMotorTorque = this.maxTorque;
            _loc8_.enableLimit = true;
            _loc8_.lowerAngle = 0;
            _loc8_.upperAngle = 0;
            _loc6_ = new b2Vec2();
            _loc7_ = shapeGuide["shaftAnchor"];
            _loc6_.Set(_startX + _loc7_.x / character_scale,_startY + _loc7_.y / character_scale);
            _loc8_.Initialize(this.mainBody,this.shaftBody,_loc6_);
            this.mainShaft = _session.m_world.CreateJoint(_loc8_) as b2RevoluteJoint;
            if(_session.version >= 1.11)
            {
                _loc8_.enableLimit = false;
            }
            _loc6_.Set(pelvisBody.GetPosition().x,pelvisBody.GetPosition().y);
            _loc8_.Initialize(this.mainBody,pelvisBody,_loc6_);
            this.mainPelvis = _session.m_world.CreateJoint(_loc8_) as b2RevoluteJoint;
            this.mainPelvisJointDef = _loc8_.clone();
            this.pelvisAnchorPoint = this.mainBody.GetLocalPoint(_loc6_);
            _loc8_.enableLimit = false;
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
            _loc8_.Initialize(this.mainBody,lowerArm1Body,_loc6_);
            this.mainHand1 = _session.m_world.CreateJoint(_loc8_) as b2RevoluteJoint;
            this.mainHand1JointDef = _loc8_.clone();
            this.handleAnchorPoint = this.mainBody.GetLocalPoint(_loc6_);
            _loc8_.Initialize(this.mainBody,lowerArm2Body,_loc6_);
            this.mainHand2 = _session.m_world.CreateJoint(_loc8_) as b2RevoluteJoint;
            this.mainHand2JointDef = _loc8_.clone();
            _loc6_.Set(upperLeg1Body.GetPosition().x,upperLeg1Body.GetPosition().y);
            _loc8_.Initialize(this.mainBody,upperLeg1Body,_loc6_);
            this.mainLeg1 = _session.m_world.CreateJoint(_loc8_) as b2RevoluteJoint;
            this.mainLeg1JointDef = _loc8_.clone();
            this.leg1AnchorPoint = this.mainBody.GetLocalPoint(_loc6_);
            _loc6_.Set(upperLeg2Body.GetPosition().x,upperLeg2Body.GetPosition().y);
            _loc8_.Initialize(this.mainBody,upperLeg2Body,_loc6_);
            this.mainLeg2 = _session.m_world.CreateJoint(_loc8_) as b2RevoluteJoint;
            this.mainLeg2JointDef = _loc8_.clone();
            this.leg2AnchorPoint = this.mainBody.GetLocalPoint(_loc6_);
            _loc7_ = shapeGuide["sausageAnchor1"];
            _loc6_.Set(_startX + _loc7_.x / character_scale,_startY + _loc7_.y / character_scale);
            _loc8_.Initialize(this.groceryBodies[7],this.groceryBodies[8],_loc6_);
            _session.m_world.CreateJoint(_loc8_) as b2RevoluteJoint;
            _loc7_ = shapeGuide["sausageAnchor2"];
            _loc6_.Set(_startX + _loc7_.x / character_scale,_startY + _loc7_.y / character_scale);
            _loc8_.Initialize(this.groceryBodies[8],this.groceryBodies[9],_loc6_);
            _session.m_world.CreateJoint(_loc8_) as b2RevoluteJoint;
        }
        
        protected function contactMainResultHandler(param1:ContactEvent) : void
        {
            var _loc2_:Number = param1.impulse;
            if(_loc2_ > contactImpulseDict[this.mainShape1])
            {
                if(contactResultBuffer[this.mainShape1])
                {
                    if(_loc2_ > contactResultBuffer[this.mainShape1].impulse)
                    {
                        contactResultBuffer[this.mainShape1] = param1;
                    }
                }
                else
                {
                    contactResultBuffer[this.mainShape1] = param1;
                }
            }
        }
        
        override protected function handleContactResults() : void
        {
            var _loc1_:ContactEvent = null;
            super.handleContactResults();
            if(contactResultBuffer[this.cartShape])
            {
                _loc1_ = contactResultBuffer[this.cartShape];
                this.cartSmash(_loc1_.impulse);
                delete contactResultBuffer[this.cartShape];
                delete contactAddBuffer[this.cartShape];
                delete contactAddBuffer[this.mainShape3];
            }
            if(contactResultBuffer[this.mainShape1])
            {
                _loc1_ = contactResultBuffer[this.mainShape1];
                this.mainSmash(_loc1_.impulse);
                delete contactResultBuffer[this.mainShape1];
            }
            if(contactResultBuffer[this.crackerShape])
            {
                _loc1_ = contactResultBuffer[this.crackerShape];
                this.crackerSmash(_loc1_.impulse);
                delete contactResultBuffer[this.crackerShape];
            }
            if(contactResultBuffer[this.sodaShape])
            {
                _loc1_ = contactResultBuffer[this.sodaShape];
                this.colaSmash(_loc1_.impulse);
                delete contactResultBuffer[this.sodaShape];
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
            var _loc1_:b2World = _session.m_world;
            if(this.mainPelvis)
            {
                _loc1_.DestroyJoint(this.mainPelvis);
                this.mainPelvis = null;
            }
            if(this.mainHand1)
            {
                _loc1_.DestroyJoint(this.mainHand1);
                this.mainHand1 = null;
            }
            if(this.mainHand2)
            {
                _loc1_.DestroyJoint(this.mainHand2);
                this.mainHand2 = null;
            }
            if(this.mainLeg1)
            {
                trace("ref ang " + this.mainLeg1.m_referenceAngle);
                _loc1_.DestroyJoint(this.mainLeg1);
                this.mainLeg1 = null;
            }
            if(this.mainLeg2)
            {
                _loc1_.DestroyJoint(this.mainLeg2);
                this.mainLeg2 = null;
            }
            var _loc2_:b2FilterData = zeroFilter.Copy();
            _loc2_.groupIndex = -2;
            this.frontWheelBody.GetShapeList().SetFilterData(_loc2_);
            this.backWheelBody.GetShapeList().SetFilterData(_loc2_);
            _loc1_.Refilter(this.frontWheelBody.GetShapeList());
            _loc1_.Refilter(this.backWheelBody.GetShapeList());
            this.backShockJoint.EnableMotor(false);
            this.frontShockJoint.EnableMotor(false);
            this.backShockJoint.SetLimits(0,0);
            this.frontShockJoint.SetLimits(0,0);
            this.backShockJoint.SetMotorSpeed(0);
            this.frontShockJoint.SetMotorSpeed(0);
            var _loc3_:b2Shape = this.mainBody.GetShapeList();
            while(_loc3_)
            {
                _loc3_.SetFilterData(_loc2_);
                _loc1_.Refilter(_loc3_);
                _loc3_ = _loc3_.m_next;
            }
            _loc3_ = this.shaftBody.GetShapeList();
            while(_loc3_)
            {
                _loc3_.SetFilterData(zeroFilter);
                _loc1_.Refilter(_loc3_);
                _loc3_ = _loc3_.m_next;
            }
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
                this.backWheelJoint.EnableMotor(false);
                this.frontWheelJoint.EnableMotor(false);
                if(voiceSound)
                {
                    voiceSound.stopSound();
                    voiceSound = null;
                }
            }
        }
        
        internal function checkEject() : void
        {
            if(!this.mainHand1 && !this.mainHand2 && !this.mainLeg1 && !this.mainLeg2)
            {
                this.eject();
            }
        }
        
        protected function cartSmash(param1:Number, param2:Boolean = true) : void
        {
            trace(tag + " cart impulse " + param1 + " -> " + _session.iteration);
            delete contactImpulseDict[this.cartShape];
            _session.contactListener.deleteListener(ContactListener.RESULT,this.cartShape);
            _session.contactListener.deleteListener(ContactListener.ADD,this.cartShape);
            this.mainBody.DestroyShape(this.cartShape);
            this.cartMC.visible = false;
            var _loc3_:b2Vec2 = this.mainBody.GetLocalCenter();
            var _loc4_:b2Vec2 = this.mainBody.GetWorldPoint(new b2Vec2(_loc3_.x + 35 / m_physScale,_loc3_.y + -15 / m_physScale));
            _session.particleController.createPointBurst("cart",_loc4_.x * m_physScale,_loc4_.y * m_physScale,30,30,20);
            if(param2)
            {
                SoundController.instance.playAreaSoundInstance("MetalSmashLight",this.mainBody);
            }
        }
        
        protected function crackerSmash(param1:Number) : void
        {
            trace(tag + " cracker impulse " + param1 + " -> " + _session.iteration);
            delete contactImpulseDict[this.crackerShape];
            _session.contactListener.deleteListener(ContactListener.RESULT,this.crackerShape);
            var _loc2_:b2Body = this.groceryBodies[4];
            var _loc3_:Sprite = this.groceryMCs[4];
            _loc3_.visible = false;
            var _loc4_:b2Vec2 = _loc2_.GetWorldCenter();
            _session.m_world.DestroyBody(_loc2_);
            _session.particleController.createPointBurst("crackers",_loc4_.x * m_physScale,_loc4_.y * m_physScale,30,30,40);
        }
        
        protected function colaSmash(param1:Number) : void
        {
            trace(tag + " cola impulse " + param1 + " -> " + _session.iteration);
            delete contactImpulseDict[this.sodaShape];
            _session.contactListener.deleteListener(ContactListener.RESULT,this.sodaShape);
            var _loc2_:b2Body = this.groceryBodies[3];
            var _loc3_:MovieClip = this.groceryMCs[3];
            _loc3_.gotoAndStop(2);
            var _loc4_:b2Vec2 = _loc2_.GetWorldCenter();
            _session.particleController.createFlow("cola",2.5,4,_loc2_,new b2Vec2(0,-10 / m_physScale),270,300);
        }
        
        protected function mainSmash(param1:Number) : void
        {
            trace(tag + " main impulse " + param1 + " -> " + _session.iteration);
            delete contactImpulseDict[this.mainShape1];
            var _loc2_:ContactListener = _session.contactListener;
            _loc2_.deleteListener(ContactListener.RESULT,this.mainShape1);
            _loc2_.deleteListener(ContactListener.RESULT,this.mainShape2);
            _loc2_.deleteListener(ContactListener.RESULT,this.mainShape3);
            _loc2_.deleteListener(ContactListener.ADD,this.mainShape3);
            _loc2_.deleteListener(ContactListener.RESULT,this.mainShape4);
            this.eject();
            this.mainSmashed = true;
            if(this.cartShape.m_body)
            {
                this.cartSmash(100,false);
            }
            var _loc3_:b2World = _session.m_world;
            var _loc4_:b2Vec2 = this.mainBody.GetPosition();
            var _loc5_:Number = this.mainBody.GetAngle();
            var _loc6_:b2Vec2 = this.mainBody.GetLinearVelocity();
            var _loc7_:Number = this.mainBody.GetAngularVelocity();
            var _loc8_:b2BodyDef = new b2BodyDef();
            _loc8_.position = _loc4_;
            _loc8_.angle = _loc5_;
            var _loc9_:b2PolygonDef = new b2PolygonDef();
            _loc9_.density = 4;
            _loc9_.friction = 0.3;
            _loc9_.restitution = 0.1;
            _loc9_.filter = zeroFilter;
            var _loc10_:b2Body = _loc3_.CreateBody(_loc8_);
            _loc10_.SetLinearVelocity(_loc6_);
            _loc10_.SetAngularVelocity(_loc7_);
            var _loc11_:b2Body = _loc3_.CreateBody(_loc8_);
            _loc11_.SetLinearVelocity(_loc6_);
            _loc11_.SetAngularVelocity(_loc7_);
            var _loc12_:b2Body = _loc3_.CreateBody(_loc8_);
            _loc12_.SetLinearVelocity(_loc6_);
            _loc12_.SetAngularVelocity(_loc7_);
            var _loc13_:b2Body = _loc3_.CreateBody(_loc8_);
            _loc13_.SetLinearVelocity(_loc6_);
            _loc13_.SetAngularVelocity(_loc7_);
            var _loc14_:b2PolygonShape = this.mainBody.GetShapeList() as b2PolygonShape;
            var _loc15_:Array = _loc14_.GetVertices();
            _loc9_.vertexCount = 4;
            _loc9_.vertices = _loc15_;
            _loc10_.CreateShape(_loc9_);
            _loc10_.SetMassFromShapes();
            _loc14_ = _loc14_.GetNext() as b2PolygonShape;
            _loc15_ = _loc14_.GetVertices();
            _loc9_.vertices = _loc15_;
            _loc11_.CreateShape(_loc9_);
            _loc11_.SetMassFromShapes();
            _loc14_ = _loc14_.GetNext() as b2PolygonShape;
            _loc15_ = _loc14_.GetVertices();
            _loc9_.vertices = _loc15_;
            _loc12_.CreateShape(_loc9_);
            _loc12_.SetMassFromShapes();
            _loc14_ = _loc14_.GetNext() as b2PolygonShape;
            _loc15_ = _loc14_.GetVertices();
            _loc9_.vertices = _loc15_;
            _loc13_.CreateShape(_loc9_);
            _loc13_.SetMassFromShapes();
            _loc3_.DestroyBody(this.mainBody);
            _loc3_.DestroyBody(this.frontShockBody);
            _loc3_.DestroyBody(this.backShockBody);
            this.mainFrontMC.visible = true;
            _loc13_.SetUserData(this.mainFrontMC);
            paintVector.push(_loc13_);
            this.mainSeatMC.visible = true;
            _loc11_.SetUserData(this.mainSeatMC);
            paintVector.push(_loc11_);
            this.mainRearMC.visible = true;
            _loc10_.SetUserData(this.mainRearMC);
            paintVector.push(_loc10_);
            this.mainBaseMC.visible = true;
            _loc12_.SetUserData(this.mainBaseMC);
            paintVector.push(_loc12_);
            this.mainMC.visible = false;
            this.shockMC.graphics.clear();
            SoundController.instance.playAreaSoundInstance("MetalSmashHeavy",this.mainBody);
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
            if(this.mainHand1)
            {
                _session.m_world.DestroyJoint(this.mainHand1);
                this.mainHand1 = null;
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
            if(this.mainHand2)
            {
                _session.m_world.DestroyJoint(this.mainHand2);
                this.mainHand2 = null;
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
            if(this.mainLeg1)
            {
                _session.m_world.DestroyJoint(this.mainLeg1);
                this.mainLeg1 = null;
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
            if(this.mainLeg2)
            {
                _session.m_world.DestroyJoint(this.mainLeg2);
                this.mainLeg2 = null;
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

