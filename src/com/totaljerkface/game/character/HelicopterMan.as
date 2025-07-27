package com.totaljerkface.game.character
{
    import Box2D.Collision.Shapes.*;
    import Box2D.Collision.b2AABB;
    import Box2D.Common.Math.b2Math;
    import Box2D.Common.Math.b2Vec2;
    import Box2D.Dynamics.*;
    import Box2D.Dynamics.Joints.*;
    import com.totaljerkface.game.*;
    import com.totaljerkface.game.character.heli.*;
    import com.totaljerkface.game.events.*;
    import com.totaljerkface.game.sound.*;
    import flash.display.*;
    import flash.events.*;
    import flash.utils.*;
    
    public class HelicopterMan extends CharacterB2D
    {
        protected var ejected:Boolean;
        
        protected var helmetOn:Boolean;
        
        protected var maxTorque:Number = 100000;
        
        protected const impulseMagnitude:Number = 0.5;
        
        protected const impulseLeft:Number = 1;
        
        protected const impulseRight:Number = 1;
        
        protected const impulseOffset:Number = 1;
        
        protected const maxSpinAV:Number = 3.5;
        
        protected var helmetSmashLimit:Number = 2;
        
        protected var copterSmashLimit:Number = 40;
        
        protected var bladeSmashLimit:Number = 30;
        
        protected var ejectImpulse:Number = 2;
        
        protected var hoverState:int = 0;
        
        protected var copterSmashed:Boolean;
        
        protected var bladeSmashed:Boolean;
        
        private var COMArray:Array;
        
        private var currCOM:b2Vec2;
        
        private var totalMass:Number;
        
        private var bladeLocalCenter:b2Vec2;
        
        private var targetAng:Number = 0;
        
        private var spinAcceleration:Number = 0;
        
        private var accelStep:Number = 0.025;
        
        private var decelStep:Number = 0.02;
        
        private var maxStep:Number = 0.1;
        
        private var ropeMinLength:Number;
        
        private var ropeMaxLength:Number = 3;
        
        private var ropeSpeed:Number = 0.05;
        
        private var numRopeSegments:int = 20;
        
        private var bladeImpactSound:AreaSoundInstance;
        
        private var heliLoop:AreaSoundLoop;
        
        private var isLoud:Boolean = false;
        
        private var magnetLoop:AreaSoundLoop;
        
        private var soundDelay:int = 10;
        
        private var soundDelayCount:int = 0;
        
        internal var copterBody:b2Body;
        
        internal var helmetBody:b2Body;
        
        internal var magnetBody:b2Body;
        
        internal var helmetShape:b2Shape;
        
        internal var backShape:b2Shape;
        
        internal var baseShape:b2Shape;
        
        internal var stemShape:b2Shape;
        
        internal var wheel1Shape:b2Shape;
        
        internal var wheel2Shape:b2Shape;
        
        internal var leg1Shape:b2Shape;
        
        internal var leg2Shape:b2Shape;
        
        internal var magnetRangeSensor:b2Shape;
        
        internal var magnetShape:b2Shape;
        
        internal var bladeShape:b2Shape;
        
        public var copterMC:MovieClip;
        
        internal var copterFrontMC:MovieClip;
        
        internal var helmetMC:MovieClip;
        
        internal var magnetMC:MovieClip;
        
        internal var ropeSprite:Sprite;
        
        internal var copterHand1:b2RevoluteJoint;
        
        internal var copterHand2:b2RevoluteJoint;
        
        internal var copterPelvis:b2RevoluteJoint;
        
        internal var magnetJoint1:b2RopeJoint;
        
        internal var magnetJoint2:b2RopeJoint;
        
        internal var ropeSprings:Array;
        
        internal var ropePoints:Array;
        
        internal var copterAnchorPoint:b2Vec2;
        
        internal var magnetAnchorPoint:b2Vec2;
        
        internal var bladeContactArray:Array;
        
        internal var magnetContactArray:Array;
        
        internal var magnetShapeArray:Array;
        
        internal var magnetized:Boolean;
        
        internal var spaceOff:Boolean;
        
        protected var bladeShards:Array;
        
        public var bladeActions:Array;
        
        protected var vertsBrokenCopter:Array;
        
        protected var brokenCopterMCs:Array;
        
        public function HelicopterMan(param1:Number, param2:Number, param3:DisplayObject, param4:Session)
        {
            super(param1,param2,param3,param4,-1,"Heli");
            shapeRefScale = 50;
            this.COMArray = new Array();
            this.magnetContactArray = new Array();
            this.magnetShapeArray = new Array();
            this.bladeContactArray = new Array();
            this.bladeActions = new Array();
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
                if(this.spinAcceleration > 0)
                {
                    this.spinAcceleration = -this.spinAcceleration;
                }
                this.spinAcceleration -= this.accelStep;
                if(this.spinAcceleration < -this.maxStep)
                {
                    this.spinAcceleration = -this.maxStep;
                }
                this.targetAng += this.spinAcceleration;
                if(this.bladeSmashed)
                {
                    _loc1_ = this.copterBody.GetAngle();
                    _loc2_ = this.copterBody.GetAngularVelocity();
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
                    _loc6_ = this.copterBody.GetLocalCenter();
                    this.copterBody.ApplyImpulse(new b2Vec2(_loc5_,-_loc4_),this.copterBody.GetWorldPoint(new b2Vec2(_loc6_.x + this.impulseOffset,_loc6_.y)));
                    this.copterBody.ApplyImpulse(new b2Vec2(-_loc5_,_loc4_),this.copterBody.GetWorldPoint(new b2Vec2(_loc6_.x - this.impulseOffset,_loc6_.y)));
                }
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
                if(this.spinAcceleration < 0)
                {
                    this.spinAcceleration = -this.spinAcceleration;
                }
                this.spinAcceleration += this.accelStep;
                if(this.spinAcceleration > this.maxStep)
                {
                    this.spinAcceleration = this.maxStep;
                }
                this.targetAng += this.spinAcceleration;
                if(this.bladeSmashed)
                {
                    _loc1_ = this.copterBody.GetAngle();
                    _loc2_ = this.copterBody.GetAngularVelocity();
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
                    _loc7_ = this.copterBody.GetLocalCenter();
                    this.copterBody.ApplyImpulse(new b2Vec2(-_loc6_,_loc5_),this.copterBody.GetWorldPoint(new b2Vec2(_loc7_.x + this.impulseOffset,_loc7_.y)));
                    this.copterBody.ApplyImpulse(new b2Vec2(_loc6_,-_loc5_),this.copterBody.GetWorldPoint(new b2Vec2(_loc7_.x - this.impulseOffset,_loc7_.y)));
                }
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
            else
            {
                if(this.targetAng > 0)
                {
                    this.spinAcceleration -= this.decelStep;
                    if(this.spinAcceleration < -this.maxStep)
                    {
                        this.spinAcceleration = -this.maxStep;
                    }
                    this.targetAng += this.spinAcceleration;
                    if(this.targetAng < 0)
                    {
                        this.targetAng = 0;
                    }
                }
                else if(this.targetAng < 0)
                {
                    this.spinAcceleration += this.decelStep;
                    if(this.spinAcceleration > this.maxStep)
                    {
                        this.spinAcceleration = this.maxStep;
                    }
                    this.targetAng += this.spinAcceleration;
                    if(this.targetAng > 0)
                    {
                        this.targetAng = 0;
                    }
                }
                if(_currentPose == 7 || _currentPose == 8)
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
            else if(!this.bladeSmashed)
            {
                this.hoverState = 1;
                if(!this.isLoud)
                {
                    this.isLoud = true;
                    this.heliLoop.fadeTo(0.75,0.25);
                }
            }
        }
        
        override internal function downPressedActions() : void
        {
            if(this.ejected)
            {
                currentPose = 4;
            }
            else if(!this.bladeSmashed)
            {
                this.hoverState = -1;
                if(!this.isLoud)
                {
                    this.isLoud = true;
                    this.heliLoop.fadeTo(0.75,0.25);
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
            else if(!this.bladeSmashed)
            {
                this.hoverState = 0;
                if(this.isLoud)
                {
                    this.isLoud = false;
                    this.heliLoop.fadeTo(0.5,0.25);
                }
            }
        }
        
        override internal function spacePressedActions() : void
        {
            if(this.ejected)
            {
                startGrab();
            }
            else if(this.spaceOff)
            {
                this.spaceOff = false;
                this.magnetized = !this.magnetized;
                if(this.magnetized)
                {
                    this.magnetMC.play();
                    this.magnetMC.lights.visible = true;
                    this.magnetLoop = SoundController.instance.playAreaSoundLoop("MagnetBuzz",this.magnetBody,0);
                    this.magnetLoop.fadeIn(0.25);
                }
                else
                {
                    this.magnetMC.stop();
                    this.magnetMC.lights.visible = false;
                    if(this.magnetLoop)
                    {
                        this.magnetLoop.fadeOut(0.25);
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
            else
            {
                this.spaceOff = true;
            }
        }
        
        override internal function shiftPressedActions() : void
        {
            var _loc1_:Number = NaN;
            if(this.ejected)
            {
                currentPose = 7;
            }
            else
            {
                _loc1_ = this.magnetJoint1.m_maxLength;
                this.magnetJoint1.m_maxLength -= this.ropeSpeed;
                this.magnetJoint2.m_maxLength -= this.ropeSpeed;
                if(this.magnetJoint1.m_maxLength < this.ropeMinLength)
                {
                    this.magnetJoint1.m_maxLength = this.magnetJoint2.m_maxLength = this.ropeMinLength;
                }
                if(_loc1_ != this.magnetJoint1.m_maxLength)
                {
                    this.resizeRope();
                }
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
        }
        
        override internal function ctrlPressedActions() : void
        {
            var _loc1_:Number = NaN;
            if(this.ejected)
            {
                currentPose = 8;
            }
            else
            {
                _loc1_ = this.magnetJoint1.m_maxLength;
                this.magnetJoint1.m_maxLength += this.ropeSpeed;
                this.magnetJoint2.m_maxLength += this.ropeSpeed;
                if(this.magnetJoint1.m_maxLength > this.ropeMaxLength)
                {
                    this.magnetJoint1.m_maxLength = this.magnetJoint2.m_maxLength = this.ropeMaxLength;
                }
                if(_loc1_ != this.magnetJoint1.m_maxLength)
                {
                    this.resizeRope();
                }
            }
        }
        
        private function resizeRope() : void
        {
            var _loc4_:VSpring = null;
            var _loc1_:Number = this.magnetJoint1.m_maxLength;
            var _loc2_:Number = 0.8 * _loc1_ / this.numRopeSegments;
            var _loc3_:int = 0;
            while(_loc3_ < this.numRopeSegments)
            {
                _loc4_ = this.ropeSprings[_loc3_];
                _loc4_.length = _loc2_;
                _loc3_++;
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
        }
        
        override internal function zPressedActions() : void
        {
            this.eject();
        }
        
        override public function preActions() : void
        {
            this.currCOM = this.getCenterOfMass();
        }
        
        override public function actions() : void
        {
            super.actions();
            if(!this.bladeSmashed)
            {
                this.balanceCopter();
                this.hoverCopter();
            }
            if(this.bladeImpactSound)
            {
                this.soundDelayCount += 1;
                if(this.soundDelayCount >= this.soundDelay)
                {
                    this.bladeImpactSound = null;
                    this.soundDelayCount = 0;
                    this.soundDelay = Math.round(Math.random() * 20) + 5;
                }
            }
        }
        
        protected function balanceCopter() : void
        {
            var _loc1_:Number = this.copterBody.GetAngularVelocity();
            while(this.targetAng > Math.PI)
            {
                this.targetAng -= Math.PI * 2;
            }
            while(this.targetAng < -Math.PI)
            {
                this.targetAng += Math.PI * 2;
            }
            var _loc2_:Number = this.copterBody.GetAngle();
            while(_loc2_ > Math.PI)
            {
                _loc2_ -= Math.PI * 2;
            }
            while(_loc2_ < -Math.PI)
            {
                _loc2_ += Math.PI * 2;
            }
            var _loc3_:Number = -Math.sin(_loc2_ - this.targetAng) * 3;
            var _loc4_:Number = _loc1_ - _loc3_;
            this.copterBody.m_angularVelocity -= _loc4_;
        }
        
        protected function hoverCopter() : void
        {
            var _loc8_:Number = NaN;
            var _loc1_:Number = this.copterBody.GetAngle();
            var _loc2_:b2Vec2 = new b2Vec2(Math.sin(_loc1_),-Math.cos(_loc1_));
            var _loc3_:b2Vec2 = this.copterBody.GetLinearVelocityFromWorldPoint(this.currCOM);
            var _loc4_:Number = b2Math.b2Dot(_loc3_,_loc2_);
            var _loc5_:Number = 10;
            var _loc6_:Number = this.totalMass * 0.3333333333333333;
            var _loc7_:Number = this.totalMass * 0.31;
            _loc4_ = _loc4_ > 0 ? Math.min(_loc4_,_loc5_) : Math.max(_loc4_,-_loc5_);
            if(this.hoverState >= 0)
            {
                this.copterBody.ApplyImpulse(new b2Vec2(_loc2_.x * _loc6_,_loc2_.y * _loc6_),this.currCOM);
                if(this.hoverState == 0)
                {
                    return;
                }
                _loc8_ = _loc7_ - _loc7_ * _loc4_ / _loc5_;
            }
            else
            {
                _loc8_ = -0.5 - (_loc7_ + _loc7_ * _loc4_ / _loc5_);
            }
            this.copterBody.ApplyImpulse(new b2Vec2(_loc2_.x * _loc8_,_loc2_.y * _loc8_),this.currCOM);
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
            this.targetAng = 0;
            this.spinAcceleration = 0;
            this.hoverState = 0;
            this.isLoud = false;
            this.helmetOn = true;
            this.copterSmashed = false;
            this.bladeSmashed = false;
            this.magnetized = false;
            this.ejected = false;
            this.bladeShards = null;
            this.magnetContactArray = new Array();
            this.magnetShapeArray = new Array();
            this.bladeContactArray = new Array();
            this.bladeActions = new Array();
        }
        
        override public function die() : void
        {
            super.die();
            this.helmetBody = null;
            if(this.heliLoop)
            {
                this.heliLoop.stopSound();
                this.heliLoop = null;
            }
            if(this.magnetLoop)
            {
                this.magnetLoop.stopSound();
                this.magnetLoop = null;
            }
        }
        
        override public function paint() : void
        {
            var _loc2_:int = 0;
            var _loc5_:b2Vec2 = null;
            var _loc6_:BladeShard = null;
            var _loc7_:int = 0;
            var _loc8_:VSpring = null;
            super.paint();
            this.copterFrontMC.x = this.copterMC.x;
            this.copterFrontMC.y = this.copterMC.y;
            this.copterFrontMC.rotation = this.copterMC.rotation;
            if(this.bladeShards)
            {
                _loc2_ = 0;
                while(_loc2_ < 4)
                {
                    _loc6_ = this.bladeShards[_loc2_];
                    _loc6_.paint();
                    _loc2_++;
                }
            }
            var _loc1_:VPoint = this.ropePoints[0];
            if(!this.copterSmashed)
            {
                _loc1_.setPosition(this.copterBody.GetWorldPoint(this.copterAnchorPoint));
            }
            _loc1_ = this.ropePoints[this.numRopeSegments];
            _loc1_.setPosition(this.magnetBody.GetWorldPoint(this.magnetAnchorPoint));
            _loc2_ = 0;
            while(_loc2_ < this.numRopeSegments + 1)
            {
                _loc1_ = this.ropePoints[_loc2_];
                _loc1_.step();
                _loc2_++;
            }
            var _loc3_:int = 20;
            _loc2_ = 0;
            while(_loc2_ < _loc3_)
            {
                _loc7_ = 0;
                while(_loc7_ < this.numRopeSegments)
                {
                    _loc8_ = this.ropeSprings[_loc7_] as VSpring;
                    _loc8_.resolve();
                    _loc7_++;
                }
                _loc2_++;
            }
            this.ropeSprite.graphics.clear();
            this.ropeSprite.graphics.lineStyle(1,3355443);
            _loc8_ = this.ropeSprings[0] as VSpring;
            var _loc4_:b2Vec2 = _loc8_.p1.currPos;
            _loc5_ = _loc8_.p2.currPos;
            this.ropeSprite.graphics.moveTo(_loc4_.x * m_physScale,_loc4_.y * m_physScale);
            this.ropeSprite.graphics.lineTo(_loc5_.x * m_physScale,_loc5_.y * m_physScale);
            _loc2_ = 1;
            while(_loc2_ < this.numRopeSegments)
            {
                _loc8_ = this.ropeSprings[_loc2_];
                _loc5_ = _loc8_.p2.currPos;
                this.ropeSprite.graphics.lineTo(_loc5_.x * m_physScale,_loc5_.y * m_physScale);
                _loc2_++;
            }
        }
        
        override internal function createBodies() : void
        {
            var _loc1_:b2PolygonDef = null;
            var _loc10_:MovieClip = null;
            var _loc11_:Array = null;
            var _loc12_:* = undefined;
            super.createBodies();
            _loc1_ = new b2PolygonDef();
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
                _loc10_ = shapeGuide["chestVert" + [_loc6_]];
                _loc1_.vertices[_loc6_] = new b2Vec2(_loc10_.x / character_scale,_loc10_.y / character_scale);
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
                _loc10_ = shapeGuide["pelvisVert" + [_loc6_]];
                _loc1_.vertices[_loc6_] = new b2Vec2(_loc10_.x / character_scale,_loc10_.y / character_scale);
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
            trace(chestBody.GetWorldCenter().y);
            var _loc7_:b2BodyDef = new b2BodyDef();
            _loc7_.linearDamping = 0.4;
            this.copterBody = _session.m_world.CreateBody(_loc7_);
            paintVector.push(this.copterBody);
            _loc1_.density = 3;
            _loc1_.friction = 0.3;
            _loc1_.restitution = 0.1;
            _loc1_.filter = zeroFilter;
            _loc5_ = shapeGuide["bladeShape"];
            var _loc8_:b2Vec2 = new b2Vec2(_startX + _loc5_.x / character_scale,_startY + _loc5_.y / character_scale);
            var _loc9_:Number = _loc5_.rotation / oneEightyOverPI;
            _loc1_.SetAsOrientedBox(_loc5_.scaleX * shapeRefScale / character_scale,_loc5_.scaleY * shapeRefScale / character_scale,_loc8_,_loc9_);
            this.bladeShape = this.copterBody.CreateShape(_loc1_);
            _session.contactListener.registerListener(ContactListener.RESULT,this.bladeShape,this.bladeContactResultHandler);
            this.bladeLocalCenter = _loc8_.Copy();
            _loc5_ = shapeGuide["stemShape"];
            _loc8_ = new b2Vec2(_startX + _loc5_.x / character_scale,_startY + _loc5_.y / character_scale);
            _loc9_ = _loc5_.rotation / oneEightyOverPI;
            _loc1_.SetAsOrientedBox(_loc5_.scaleX * shapeRefScale / character_scale,_loc5_.scaleY * shapeRefScale / character_scale,_loc8_,_loc9_);
            this.stemShape = this.copterBody.CreateShape(_loc1_);
            _loc5_ = shapeGuide["handleShape"];
            _loc8_ = new b2Vec2(_startX + _loc5_.x / character_scale,_startY + _loc5_.y / character_scale);
            _loc9_ = _loc5_.rotation / oneEightyOverPI;
            _loc1_.SetAsOrientedBox(_loc5_.scaleX * shapeRefScale / character_scale,_loc5_.scaleY * shapeRefScale / character_scale,_loc8_,_loc9_);
            _loc1_.vertexCount = 4;
            _loc6_ = 0;
            while(_loc6_ < 4)
            {
                _loc5_ = shapeGuide["baseVert" + [_loc6_]];
                _loc1_.vertices[_loc6_] = new b2Vec2(_startX + _loc5_.x / character_scale,_startY + _loc5_.y / character_scale);
                _loc6_++;
            }
            this.baseShape = this.copterBody.CreateShape(_loc1_) as b2PolygonShape;
            _session.contactListener.registerListener(ContactListener.ADD,this.baseShape,contactAddHandler);
            _session.contactListener.registerListener(ContactListener.RESULT,this.baseShape,this.contactCopterResultHandler);
            _loc1_.vertexCount = 5;
            _loc6_ = 0;
            while(_loc6_ < 5)
            {
                _loc5_ = shapeGuide["backVert" + [_loc6_]];
                _loc1_.vertices[_loc6_] = new b2Vec2(_startX + _loc5_.x / character_scale,_startY + _loc5_.y / character_scale);
                _loc6_++;
            }
            this.backShape = this.copterBody.CreateShape(_loc1_) as b2PolygonShape;
            _session.contactListener.registerListener(ContactListener.ADD,this.backShape,contactAddHandler);
            _session.contactListener.registerListener(ContactListener.RESULT,this.backShape,this.contactCopterResultHandler);
            _loc5_ = shapeGuide["magnetShape"];
            _loc7_.linearDamping = 0;
            _loc1_.filter = new b2FilterData();
            _loc1_.filter.categoryBits = zeroFilter.categoryBits;
            _loc1_.filter.maskBits = zeroFilter.maskBits;
            _loc7_.angularDamping = 1;
            _loc7_.position.Set(_startX + _loc5_.x / character_scale,_startY + _loc5_.y / character_scale);
            this.magnetBody = _session.m_world.CreateBody(_loc7_);
            paintVector.push(this.magnetBody);
            _loc1_.SetAsBox(_loc5_.scaleX * shapeRefScale / character_scale,_loc5_.scaleY * shapeRefScale / character_scale);
            this.magnetShape = this.magnetBody.CreateShape(_loc1_);
            this.magnetBody.SetMassFromShapes();
            _session.contactListener.registerListener(ContactListener.RESULT,this.magnetShape,this.magnetContactResult);
            _loc7_.angularDamping = 0;
            cameraSecondFocus = this.magnetBody;
            _loc1_.filter = defaultFilter;
            _loc5_ = shapeGuide["leg1Shape"];
            _loc8_ = new b2Vec2(_startX + _loc5_.x / character_scale,_startY + _loc5_.y / character_scale);
            _loc9_ = _loc5_.rotation / oneEightyOverPI;
            _loc1_.SetAsOrientedBox(_loc5_.scaleX * shapeRefScale / character_scale,_loc5_.scaleY * shapeRefScale / character_scale,_loc8_,_loc9_);
            this.leg1Shape = this.copterBody.CreateShape(_loc1_);
            _loc5_ = shapeGuide["leg2Shape"];
            _loc8_ = new b2Vec2(_startX + _loc5_.x / character_scale,_startY + _loc5_.y / character_scale);
            _loc9_ = _loc5_.rotation / oneEightyOverPI;
            _loc1_.SetAsOrientedBox(_loc5_.scaleX * shapeRefScale / character_scale,_loc5_.scaleY * shapeRefScale / character_scale,_loc8_,_loc9_);
            this.leg2Shape = this.copterBody.CreateShape(_loc1_);
            _loc2_.density = 3;
            _loc2_.friction = 0;
            _loc2_.restitution = 0.3;
            _loc2_.filter = zeroFilter;
            _loc5_ = shapeGuide["wheel1Shape"];
            _loc2_.radius = _loc5_.width * 0.5 / character_scale;
            _loc2_.localPosition = new b2Vec2(_startX + _loc5_.x / character_scale,_startY + _loc5_.y / character_scale);
            this.wheel1Shape = this.copterBody.CreateShape(_loc2_) as b2CircleShape;
            _session.contactListener.registerListener(ContactListener.ADD,this.wheel1Shape,contactAddHandler);
            _session.contactListener.registerListener(ContactListener.RESULT,this.wheel1Shape,contactResultHandler);
            _loc5_ = shapeGuide["wheel2Shape"];
            _loc2_.radius = _loc5_.width * 0.5 / character_scale;
            _loc2_.localPosition = new b2Vec2(_startX + _loc5_.x / character_scale,_startY + _loc5_.y / character_scale);
            this.wheel2Shape = this.copterBody.CreateShape(_loc2_) as b2CircleShape;
            _session.contactListener.registerListener(ContactListener.ADD,this.wheel2Shape,contactAddHandler);
            _session.contactListener.registerListener(ContactListener.RESULT,this.wheel2Shape,contactResultHandler);
            this.copterBody.SetMassFromShapes();
            _loc1_.vertexCount = 4;
            _loc1_.density = 0;
            _loc1_.isSensor = true;
            _loc6_ = 0;
            while(_loc6_ < 4)
            {
                _loc5_ = shapeGuide["magnetVert" + [_loc6_]];
                _loc1_.vertices[_loc6_] = new b2Vec2(_loc5_.x / character_scale,_loc5_.y / character_scale);
                _loc6_++;
            }
            this.magnetRangeSensor = this.magnetBody.CreateShape(_loc1_);
            this.magnetBody.SetMassFromShapes();
            this.magnetBody.DestroyShape(this.magnetRangeSensor);
            this.vertsBrokenCopter = new Array();
            _loc6_ = 0;
            while(_loc6_ < 7)
            {
                _loc11_ = new Array();
                _loc12_ = 0;
                while(_loc12_ < 6)
                {
                    _loc5_ = shapeGuide["broken_" + (_loc6_ + 1) + "_" + (_loc12_ + 1)];
                    if(_loc5_)
                    {
                        _loc11_.push(new b2Vec2(_startX + _loc5_.x / character_scale,_startY + _loc5_.y / character_scale));
                    }
                    _loc12_++;
                }
                this.vertsBrokenCopter.push(_loc11_);
                _loc6_++;
            }
            this.COMArray = [this.copterBody,head1Body,chestBody,pelvisBody,upperArm1Body,lowerArm1Body,upperArm2Body,lowerArm2Body,upperLeg1Body,lowerLeg1Body,upperLeg2Body,lowerLeg2Body];
            this.vertsBrokenCopter = new Array();
            _loc6_ = 1;
            while(_loc6_ < 8)
            {
                _loc11_ = new Array();
                _loc12_ = 0;
                while(_loc12_ < 4)
                {
                    _loc5_ = shapeGuide["broken" + _loc6_ + "Vert" + _loc12_];
                    if(_loc5_)
                    {
                        _loc11_.push(new b2Vec2(_startX + _loc5_.x / character_scale,_startY + _loc5_.y / character_scale));
                    }
                    _loc12_++;
                }
                this.vertsBrokenCopter.push(_loc11_);
                _loc6_++;
            }
            this.heliLoop = SoundController.instance.playAreaSoundLoop("HeliLoop",this.copterBody,0);
            this.heliLoop.fadeTo(0.5,1);
        }
        
        override internal function createJoints() : void
        {
            var _loc1_:Number = NaN;
            var _loc2_:Number = NaN;
            var _loc3_:Number = NaN;
            var _loc16_:VPoint = null;
            var _loc19_:VSpring = null;
            super.createJoints();
            var _loc4_:Number = 180 / Math.PI;
            _loc1_ = head1Body.GetAngle() - chestBody.GetAngle();
            _loc2_ = -10 / _loc4_ - _loc1_;
            _loc3_ = 10 / _loc4_ - _loc1_;
            neckJoint.SetLimits(_loc2_,_loc3_);
            var _loc5_:b2RevoluteJointDef = new b2RevoluteJointDef();
            _loc5_.maxMotorTorque = this.maxTorque;
            _loc5_.enableLimit = false;
            _loc5_.lowerAngle = 0;
            _loc5_.upperAngle = 0;
            var _loc6_:b2Vec2 = new b2Vec2();
            var _loc7_:MovieClip = shapeGuide["seatAnchor"];
            _loc6_.Set(_startX + _loc7_.x / character_scale,_startY + _loc7_.y / character_scale);
            _loc5_.Initialize(this.copterBody,pelvisBody,_loc6_);
            this.copterPelvis = _session.m_world.CreateJoint(_loc5_) as b2RevoluteJoint;
            _loc7_ = shapeGuide["handleAnchor"];
            _loc6_.Set(_startX + _loc7_.x / character_scale,_startY + _loc7_.y / character_scale);
            _loc5_.Initialize(this.copterBody,lowerArm1Body,_loc6_);
            this.copterHand1 = _session.m_world.CreateJoint(_loc5_) as b2RevoluteJoint;
            _loc5_.Initialize(this.copterBody,lowerArm2Body,_loc6_);
            this.copterHand2 = _session.m_world.CreateJoint(_loc5_) as b2RevoluteJoint;
            var _loc8_:b2Vec2 = this.getCenterOfMass();
            this.magnetBody.SetXForm(new b2Vec2(_loc8_.x,this.magnetBody.GetWorldCenter().y),0);
            this.COMArray.push(this.magnetBody);
            _loc7_ = shapeGuide["magnetAnchor"];
            _loc6_.Set(_startX + _loc7_.x / character_scale,_startY + _loc7_.y / character_scale);
            _loc6_.x = _loc8_.x;
            var _loc9_:b2Vec2 = this.magnetBody.GetWorldCenter();
            _loc9_.y -= 20 / character_scale;
            this.copterAnchorPoint = this.copterBody.GetLocalPoint(_loc6_);
            this.magnetAnchorPoint = this.magnetBody.GetLocalPoint(_loc9_);
            var _loc10_:b2RopeJointDef = new b2RopeJointDef();
            _loc10_.Initialize(this.copterBody,this.magnetBody,_loc6_,_loc9_);
            _loc10_.collideConnected = true;
            this.magnetJoint1 = _session.m_world.CreateJoint(_loc10_) as b2RopeJoint;
            _loc10_.localAnchor1.x -= 84 / character_scale;
            _loc10_.localAnchor2.x -= 84 / character_scale;
            this.magnetJoint2 = _session.m_world.CreateJoint(_loc10_) as b2RopeJoint;
            _session.m_world.DestroyJoint(this.magnetJoint2);
            this.ropeMinLength = this.magnetJoint1.m_maxLength;
            trace("Length " + this.magnetJoint1.m_maxLength);
            this.ropeSprings = new Array();
            this.ropePoints = new Array();
            var _loc11_:b2Vec2 = _loc6_.Copy();
            var _loc12_:b2Vec2 = _loc9_.Copy();
            var _loc13_:Number = (_loc12_.x - _loc11_.x) / this.numRopeSegments;
            var _loc14_:Number = (_loc12_.y - _loc11_.y) / this.numRopeSegments;
            var _loc15_:VPoint = new VPoint(_loc11_,true);
            this.ropePoints.push(_loc15_);
            var _loc17_:Number = 0;
            var _loc18_:int = 0;
            while(_loc18_ < this.numRopeSegments)
            {
                if(_loc18_ < this.numRopeSegments - 1)
                {
                    _loc16_ = new VPoint(new b2Vec2(_loc11_.x + _loc13_ * (_loc18_ + 1),_loc11_.y + _loc14_ * (_loc18_ + 1)),false);
                }
                else
                {
                    _loc16_ = new VPoint(_loc12_,true);
                }
                this.ropePoints.push(_loc16_);
                _loc19_ = new VSpring(_loc15_,_loc16_);
                this.ropeSprings.push(_loc19_);
                _loc17_ += _loc19_.length;
                _loc15_ = _loc16_;
                _loc18_++;
            }
            this.resizeRope();
            trace("totalLength " + _loc17_);
        }
        
        override internal function createMovieClips() : void
        {
            var _loc3_:MovieClip = null;
            super.createMovieClips();
            _session.containerSprite.addChildAt(pelvisMC,_session.containerSprite.getChildIndex(chestMC));
            var _loc1_:MovieClip = sourceObject["copterShards"];
            _session.particleController.createBMDArray("copterShards",_loc1_);
            this.copterMC = sourceObject["copter"];
            var _loc5_:* = 1 / mc_scale;
            this.copterMC.scaleY = 1 / mc_scale;
            this.copterMC.scaleX = _loc5_;
            this.copterFrontMC = sourceObject["copterFront"];
            _loc5_ = 1 / mc_scale;
            this.copterFrontMC.scaleY = 1 / mc_scale;
            this.copterFrontMC.scaleX = _loc5_;
            this.magnetMC = sourceObject["magnet"];
            this.magnetMC.lights.visible = false;
            _loc5_ = 1 / mc_scale;
            this.magnetMC.scaleY = 1 / mc_scale;
            this.magnetMC.scaleX = _loc5_;
            this.helmetMC = sourceObject["helmet"];
            _loc5_ = 1 / mc_scale;
            this.helmetMC.scaleY = 1 / mc_scale;
            this.helmetMC.scaleX = _loc5_;
            this.helmetMC.visible = false;
            var _loc2_:b2Vec2 = this.copterBody.GetLocalCenter();
            _loc2_ = new b2Vec2((_startX - _loc2_.x) * character_scale,(_startY - _loc2_.y) * character_scale);
            this.copterMC.inner.x = this.copterFrontMC.inner.x = _loc2_.x;
            this.copterMC.inner.y = this.copterFrontMC.inner.y = _loc2_.y;
            this.copterBody.SetUserData(this.copterMC);
            this.magnetBody.SetUserData(this.magnetMC);
            this.ropeSprite = new Sprite();
            _session.containerSprite.addChildAt(this.helmetMC,_session.containerSprite.getChildIndex(chestMC));
            _session.containerSprite.addChildAt(this.magnetMC,_session.containerSprite.getChildIndex(head1MC));
            _session.containerSprite.addChildAt(this.ropeSprite,_session.containerSprite.getChildIndex(head1MC));
            _session.containerSprite.addChildAt(this.copterMC,_session.containerSprite.getChildIndex(head1MC));
            _session.containerSprite.addChildAt(this.copterFrontMC,_session.containerSprite.getChildIndex(upperArm1MC));
            this.copterMC.inner.propeller.play();
            this.copterMC.inner.brokenPropeller.visible = false;
            this.brokenCopterMCs = new Array();
            var _loc4_:int = 1;
            while(_loc4_ < 8)
            {
                _loc3_ = sourceObject["broken" + _loc4_];
                _loc5_ = 1 / mc_scale;
                _loc3_.scaleY = 1 / mc_scale;
                _loc3_.scaleX = _loc5_;
                _loc3_.visible = false;
                this.brokenCopterMCs.push(_loc3_);
                _session.containerSprite.addChild(_loc3_);
                _loc4_++;
            }
        }
        
        override internal function resetMovieClips() : void
        {
            var _loc3_:MovieClip = null;
            super.resetMovieClips();
            this.helmetMC.visible = false;
            head1MC.helmet.visible = true;
            this.copterFrontMC.inner.leg1.visible = true;
            this.copterFrontMC.inner.leg2.visible = true;
            this.copterFrontMC.visible = true;
            this.copterMC.visible = true;
            this.copterMC.inner.propeller.visible = true;
            this.copterMC.inner.brokenPropeller.visible = false;
            var _loc1_:int = 0;
            while(_loc1_ < 7)
            {
                _loc3_ = this.brokenCopterMCs[_loc1_];
                _loc3_.visible = false;
                _loc1_++;
            }
            this.copterBody.SetUserData(this.copterMC);
            this.magnetBody.SetUserData(this.magnetMC);
            this.magnetMC.gotoAndStop(0);
            this.magnetMC.lights.visible = false;
            this.ropeSprite.graphics.clear();
            var _loc2_:MovieClip = sourceObject["copterShards"];
            _session.particleController.createBMDArray("copterShards",_loc2_);
        }
        
        override internal function createDictionaries() : void
        {
            super.createDictionaries();
            this.helmetShape = head1Shape;
            contactImpulseDict[this.helmetShape] = this.helmetSmashLimit;
            contactImpulseDict[this.backShape] = this.copterSmashLimit;
            contactImpulseDict[this.bladeShape] = this.bladeSmashLimit;
            contactImpulseDict[this.wheel1Shape] = this.copterSmashLimit;
            contactImpulseDict[this.wheel2Shape] = this.copterSmashLimit;
            contactAddSounds[this.wheel1Shape] = "CarTire1";
            contactAddSounds[this.wheel2Shape] = "CarTire1";
            contactAddSounds[this.backShape] = "BikeHit3";
            contactAddSounds[this.baseShape] = "BikeHit1";
        }
        
        protected function contactCopterResultHandler(param1:ContactEvent) : void
        {
            var _loc2_:Number = param1.impulse;
            if(_loc2_ > contactImpulseDict[this.backShape])
            {
                if(contactResultBuffer[this.backShape])
                {
                    if(_loc2_ > contactResultBuffer[this.backShape].impulse)
                    {
                        contactResultBuffer[this.backShape] = param1;
                    }
                }
                else
                {
                    contactResultBuffer[this.backShape] = param1;
                }
            }
        }
        
        private function bladeContactResultHandler(param1:ContactEvent) : void
        {
            var _loc2_:Number = param1.impulse;
            var _loc3_:b2Shape = param1.otherShape;
            this.bladeContactArray.push(param1);
            if(_loc2_ > contactImpulseDict[this.bladeShape])
            {
                if(contactResultBuffer[this.bladeShape])
                {
                    if(_loc2_ > contactResultBuffer[this.bladeShape].impulse)
                    {
                        contactResultBuffer[this.bladeShape] = param1;
                    }
                }
                else
                {
                    contactResultBuffer[this.bladeShape] = param1;
                }
            }
        }
        
        override protected function handleContactResults() : void
        {
            var _loc1_:ContactEvent = null;
            var _loc3_:BladeShard = null;
            if(contactResultBuffer[this.helmetShape])
            {
                _loc1_ = contactResultBuffer[this.helmetShape];
                this.helmetSmash(_loc1_.impulse);
                delete contactResultBuffer[head1Shape];
                delete contactAddBuffer[head1Shape];
            }
            super.handleContactResults();
            this.handleBladeContacts();
            if(contactResultBuffer[this.backShape])
            {
                _loc1_ = contactResultBuffer[this.backShape];
                this.copterSmash(_loc1_);
                delete contactResultBuffer[this.backShape];
                delete contactAddBuffer[this.backShape];
                delete contactAddBuffer[this.baseShape];
                delete contactAddBuffer[this.wheel1Shape];
                delete contactAddBuffer[this.wheel2Shape];
                delete contactResultBuffer[this.bladeShape];
                delete contactResultBuffer[this.wheel1Shape];
                delete contactResultBuffer[this.wheel2Shape];
            }
            if(contactResultBuffer[this.bladeShape])
            {
                _loc1_ = contactResultBuffer[this.bladeShape];
                this.bladeSmash(_loc1_);
                delete contactResultBuffer[this.bladeShape];
            }
            if(contactResultBuffer[this.wheel1Shape])
            {
                _loc1_ = contactResultBuffer[this.wheel1Shape];
                this.copterLegSmash(this.wheel1Shape,_loc1_);
                delete contactResultBuffer[this.wheel1Shape];
                delete contactAddBuffer[this.wheel1Shape];
            }
            if(contactResultBuffer[this.wheel2Shape])
            {
                _loc1_ = contactResultBuffer[this.wheel2Shape];
                this.copterLegSmash(this.wheel2Shape,_loc1_);
                delete contactResultBuffer[this.wheel2Shape];
                delete contactAddBuffer[this.wheel2Shape];
            }
            this.handleMagnetContacts();
            var _loc2_:int = 0;
            while(_loc2_ < this.bladeActions.length)
            {
                _loc3_ = this.bladeActions[_loc2_];
                _loc3_.actions();
                _loc2_++;
            }
        }
        
        private function handleMagnetContacts() : void
        {
            var _loc1_:int = 0;
            var _loc2_:b2AABB = null;
            var _loc3_:int = 0;
            var _loc4_:Dictionary = null;
            var _loc5_:b2JointEdge = null;
            var _loc6_:b2Joint = null;
            var _loc7_:ContactEvent = null;
            var _loc8_:b2Shape = null;
            var _loc9_:b2Body = null;
            var _loc10_:b2Vec2 = null;
            var _loc11_:Number = NaN;
            var _loc12_:b2AABB = null;
            var _loc13_:int = 0;
            var _loc14_:b2Vec2 = null;
            var _loc15_:b2RevoluteJointDef = null;
            var _loc16_:Array = null;
            if(this.magnetized)
            {
                _loc1_ = int(this.magnetContactArray.length);
                if(_loc1_ > 0)
                {
                    _loc4_ = new Dictionary();
                    _loc5_ = this.magnetBody.GetJointList();
                    while(_loc5_)
                    {
                        _loc6_ = _loc5_.joint;
                        if(_loc6_ is b2RevoluteJoint)
                        {
                            _loc4_[_loc6_.m_body2] = _loc6_;
                        }
                        _loc5_ = _loc5_.next;
                    }
                }
                _loc2_ = new b2AABB();
                this.magnetRangeSensor.ComputeAABB(_loc2_,this.magnetBody.m_xf);
                _loc3_ = 0;
                while(_loc3_ < _loc1_)
                {
                    _loc7_ = this.magnetContactArray[_loc3_];
                    _loc8_ = _loc7_.otherShape;
                    _loc9_ = _loc8_.GetBody();
                    if(_loc9_ != null)
                    {
                        _loc10_ = _loc7_.position;
                        _loc11_ = _loc9_.GetMass();
                        _loc12_ = new b2AABB();
                        _loc8_.ComputeAABB(_loc12_,_loc9_.m_xf);
                        if(!(_loc12_.lowerBound.x > _loc2_.upperBound.x || _loc12_.upperBound.x < _loc2_.lowerBound.x))
                        {
                            if(!(_loc12_.lowerBound.y > _loc2_.upperBound.y || _loc12_.upperBound.y < _loc2_.lowerBound.y))
                            {
                                _loc13_ = int(this.COMArray.indexOf(_loc9_));
                                _loc14_ = this.magnetBody.GetLocalPoint(_loc10_);
                                if(_loc14_.y > 0 && _loc11_ > 0 && _loc13_ < 0 && !_loc4_[_loc9_])
                                {
                                    _loc15_ = new b2RevoluteJointDef();
                                    _loc15_.collideConnected = true;
                                    _loc15_.enableLimit = true;
                                    _loc15_.upperAngle = 3 * Math.PI / 180;
                                    _loc15_.lowerAngle = -3 * Math.PI / 180;
                                    _loc15_.Initialize(this.magnetBody,_loc9_,_loc10_);
                                    _session.m_world.CreateJoint(_loc15_);
                                }
                            }
                        }
                    }
                    _loc3_++;
                }
            }
            else
            {
                _loc16_ = new Array();
                _loc5_ = this.magnetBody.GetJointList();
                while(_loc5_)
                {
                    _loc6_ = _loc5_.joint;
                    if(_loc6_ != this.magnetJoint1 && _loc6_ != this.magnetJoint2)
                    {
                        _loc16_.push(_loc6_);
                    }
                    _loc5_ = _loc5_.next;
                }
                _loc1_ = int(_loc16_.length);
                _loc3_ = 0;
                while(_loc3_ < _loc1_)
                {
                    _loc6_ = _loc16_[_loc3_];
                    _session.m_world.DestroyJoint(_loc6_);
                    _loc3_++;
                }
            }
            this.magnetContactArray = new Array();
            this.magnetShapeArray = new Array();
        }
        
        private function handleBladeContacts() : void
        {
            var _loc4_:ContactEvent = null;
            var _loc5_:b2Shape = null;
            var _loc6_:b2Body = null;
            var _loc7_:b2Vec2 = null;
            var _loc8_:Number = NaN;
            var _loc9_:b2Vec2 = null;
            var _loc10_:b2Vec2 = null;
            var _loc11_:Number = NaN;
            var _loc12_:Number = NaN;
            var _loc13_:Number = NaN;
            var _loc14_:Number = NaN;
            var _loc15_:* = undefined;
            var _loc16_:b2Vec2 = null;
            var _loc17_:String = null;
            var _loc18_:int = 0;
            var _loc19_:String = null;
            var _loc20_:b2Vec2 = null;
            if(this.bladeSmashed)
            {
                return;
            }
            var _loc1_:int = int(this.bladeContactArray.length);
            var _loc2_:Number = this.copterBody.m_mass;
            var _loc3_:int = 0;
            while(_loc3_ < _loc1_)
            {
                _loc4_ = this.bladeContactArray[_loc3_];
                _loc5_ = _loc4_.otherShape;
                _loc6_ = _loc5_.GetBody();
                _loc7_ = _loc4_.position;
                _loc8_ = _loc6_.GetMass();
                _loc9_ = this.copterBody.GetLocalPoint(_loc7_);
                _loc10_ = new b2Vec2(_loc9_.x - this.bladeLocalCenter.x,_loc9_.y - this.bladeLocalCenter.y);
                _loc10_.Normalize();
                _loc10_.MulM(this.copterBody.m_xf.R);
                _loc11_ = 3;
                if(_loc8_ > 0)
                {
                    _loc12_ = _loc6_.m_invMass + this.copterBody.m_invMass;
                    _loc13_ = _loc11_ * _loc6_.m_invMass / _loc12_;
                    _loc14_ = _loc11_ * this.copterBody.m_invMass / _loc12_;
                    _loc15_ = new b2Vec2(_loc10_.x * _loc13_,_loc10_.y * _loc13_);
                    _loc16_ = new b2Vec2(_loc10_.x * _loc14_,_loc10_.y * _loc14_);
                    _loc6_.ApplyImpulse(_loc15_,_loc7_);
                    this.copterBody.ApplyImpulse(_loc16_.Negative(),_loc7_);
                    if(_loc5_.m_material & 7)
                    {
                        _loc17_ = String(_loc7_.x);
                        _loc18_ = int(_loc17_.charAt(_loc17_.length - 1));
                        if(_loc18_ < 7)
                        {
                            _loc19_ = "BladeFlesh" + Math.ceil(Math.random() * 3);
                            SoundController.instance.playAreaSoundInstance(_loc19_,_loc6_);
                        }
                        else if(!this.bladeImpactSound)
                        {
                            _loc19_ = "MetalRicochet" + Math.ceil(Math.random() * 3);
                            this.bladeImpactSound = SoundController.instance.playAreaSoundInstance(_loc19_,_loc6_);
                            session.particleController.createSparkBurstPoint(_loc7_,new b2Vec2(_loc15_.x * 5,_loc15_.y * 5),5,50,20);
                        }
                    }
                    else if(!this.bladeImpactSound)
                    {
                        _loc19_ = "MetalRicochet" + Math.ceil(Math.random() * 3);
                        this.bladeImpactSound = SoundController.instance.playAreaSoundInstance(_loc19_,_loc6_);
                        session.particleController.createSparkBurstPoint(_loc7_,new b2Vec2(_loc15_.x * 5,_loc15_.y * 5),5,50,20);
                    }
                }
                else
                {
                    _loc20_ = new b2Vec2(_loc10_.x * _loc11_,_loc10_.y * _loc11_);
                    this.copterBody.ApplyImpulse(_loc20_.Negative(),_loc7_);
                    if(!this.bladeImpactSound)
                    {
                        _loc19_ = "MetalRicochet" + Math.ceil(Math.random() * 3);
                        this.bladeImpactSound = SoundController.instance.playAreaSoundInstance(_loc19_,this.copterBody,0.4);
                        session.particleController.createSparkBurstPoint(_loc7_,new b2Vec2(_loc20_.x * 5,_loc20_.y * 5),5,50,20);
                    }
                }
                _loc3_++;
            }
            this.bladeContactArray = new Array();
        }
        
        override internal function eject() : void
        {
            if(this.ejected)
            {
                return;
            }
            trace("EJECT");
            this.ejected = true;
            resetJointLimits();
            var _loc1_:b2World = _session.m_world;
            if(this.copterPelvis)
            {
                _loc1_.DestroyJoint(this.copterPelvis);
                this.copterPelvis = null;
            }
            if(this.copterHand1)
            {
                _loc1_.DestroyJoint(this.copterHand1);
                this.copterHand1 = null;
            }
            if(this.copterHand2)
            {
                _loc1_.DestroyJoint(this.copterHand2);
                this.copterHand2 = null;
            }
            var _loc2_:b2Shape = this.copterBody.GetShapeList();
            while(_loc2_)
            {
                if(_loc2_ != this.bladeShape)
                {
                    _loc2_.SetFilterData(zeroFilter);
                    _loc1_.Refilter(_loc2_);
                }
                _loc2_ = _loc2_.m_next;
            }
            lowerArm1MC.hand.gotoAndStop(2);
            lowerArm2MC.hand.gotoAndStop(2);
            var _loc3_:Number = this.copterBody.GetAngle();
            var _loc4_:Number = Math.cos(_loc3_) * this.ejectImpulse;
            var _loc5_:Number = Math.sin(_loc3_) * this.ejectImpulse;
            chestBody.ApplyImpulse(new b2Vec2(_loc4_,_loc5_),chestBody.GetWorldCenter());
            pelvisBody.ApplyImpulse(new b2Vec2(_loc4_,_loc5_),pelvisBody.GetWorldCenter());
            this.COMArray = [this.copterBody,this.magnetBody];
            this.targetAng = 0;
            _session.camera.removeSecondFocus();
        }
        
        override public function set dead(param1:Boolean) : void
        {
            _dead = param1;
            if(_dead)
            {
                this.targetAng = 0;
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
        
        override internal function grabAction(param1:b2Body, param2:b2Shape, param3:b2Body) : void
        {
            if(param2 == this.bladeShape)
            {
                return;
            }
            super.grabAction(param1,param2,param3);
        }
        
        private function magnetContactResult(param1:ContactEvent) : void
        {
            var _loc5_:ContactEvent = null;
            var _loc2_:Number = param1.impulse;
            var _loc3_:b2Shape = param1.otherShape;
            var _loc4_:int = int(this.magnetShapeArray.indexOf(_loc3_));
            if(_loc4_ > -1)
            {
                _loc5_ = this.magnetContactArray[_loc4_];
                if(param1.impulse > _loc5_.impulse)
                {
                    this.magnetContactArray[_loc4_] = param1;
                }
            }
            else
            {
                this.magnetShapeArray.push(_loc3_);
                this.magnetContactArray.push(param1);
            }
        }
        
        protected function getCenterOfMass() : b2Vec2
        {
            var _loc4_:b2Body = null;
            var _loc5_:b2Vec2 = null;
            var _loc6_:Number = NaN;
            var _loc1_:b2Vec2 = new b2Vec2();
            this.totalMass = 0;
            var _loc2_:int = int(this.COMArray.length);
            var _loc3_:int = 0;
            while(_loc3_ < _loc2_)
            {
                _loc4_ = this.COMArray[_loc3_];
                _loc5_ = _loc4_.GetWorldCenter();
                _loc6_ = _loc4_.GetMass();
                _loc1_.x += _loc5_.x * _loc6_;
                _loc1_.y += _loc5_.y * _loc6_;
                this.totalMass += _loc6_;
                _loc3_++;
            }
            _loc1_.Multiply(1 / this.totalMass);
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
        
        internal function copterSmash(param1:ContactEvent) : void
        {
            var _loc3_:b2Vec2 = null;
            var _loc14_:b2Body = null;
            var _loc15_:Array = null;
            var _loc16_:Sprite = null;
            trace("copter impulse " + param1.impulse + " -> " + _session.iteration);
            delete contactImpulseDict[this.backShape];
            var _loc2_:ContactListener = _session.contactListener;
            _loc2_.deleteListener(ContactListener.RESULT,this.backShape);
            _loc2_.deleteListener(ContactListener.RESULT,this.baseShape);
            _loc2_.deleteListener(ContactListener.RESULT,this.wheel1Shape);
            _loc2_.deleteListener(ContactListener.RESULT,this.wheel2Shape);
            _loc2_.deleteListener(ContactListener.ADD,this.backShape);
            _loc2_.deleteListener(ContactListener.ADD,this.baseShape);
            _loc2_.deleteListener(ContactListener.ADD,this.wheel1Shape);
            _loc2_.deleteListener(ContactListener.ADD,this.wheel2Shape);
            this.copterSmashed = true;
            if(!this.bladeSmashed)
            {
                this.bladeSmash(param1);
            }
            if(this.copterFrontMC.inner.leg1.visible == true)
            {
                this.copterLegSmash(this.wheel1Shape,param1,false);
            }
            if(this.copterFrontMC.inner.leg2.visible == true)
            {
                this.copterLegSmash(this.wheel2Shape,param1,false);
            }
            _loc3_ = this.copterBody.GetLocalCenter();
            this.eject();
            var _loc4_:b2World = _session.m_world;
            var _loc5_:b2Vec2 = this.copterBody.GetPosition();
            var _loc6_:Number = this.copterBody.GetAngle();
            var _loc7_:b2Vec2 = this.copterBody.GetLinearVelocity();
            var _loc8_:Number = this.copterBody.GetAngularVelocity();
            _loc4_.DestroyBody(this.copterBody);
            this.copterMC.visible = this.copterFrontMC.visible = false;
            var _loc9_:b2BodyDef = new b2BodyDef();
            _loc9_.position = _loc5_;
            _loc9_.angle = _loc6_;
            var _loc10_:b2PolygonDef = new b2PolygonDef();
            _loc10_.density = 3;
            _loc10_.friction = 0.3;
            _loc10_.restitution = 0.3;
            _loc10_.filter = zeroFilter;
            var _loc11_:int = 5;
            var _loc12_:int = 0;
            while(_loc12_ < _loc11_)
            {
                _loc14_ = _loc4_.CreateBody(_loc9_);
                _loc15_ = this.vertsBrokenCopter[_loc12_];
                _loc16_ = this.brokenCopterMCs[_loc12_];
                _loc10_.vertexCount = _loc15_.length;
                _loc10_.vertices = _loc15_;
                _loc14_.CreateShape(_loc10_);
                _loc14_.SetMassFromShapes();
                _loc14_.SetAngularVelocity(_loc8_);
                _loc14_.SetLinearVelocity(this.copterBody.GetLinearVelocityFromLocalPoint(_loc14_.GetLocalCenter()));
                _loc14_.SetUserData(_loc16_);
                _loc16_.visible = true;
                paintVector.push(_loc14_);
                _loc12_++;
            }
            var _loc13_:VPoint = this.ropePoints[0];
            _loc13_.fixed = false;
            _loc3_ = this.copterBody.GetWorldCenter();
            _session.particleController.createPointBurst("copterShards",_loc3_.x * m_physScale,_loc3_.y * m_physScale,30,30,70);
            SoundController.instance.playAreaSoundInstance("MetalSmashHeavy2",this.copterBody);
        }
        
        internal function bladeSmash(param1:ContactEvent) : void
        {
            var _loc12_:Array = null;
            var _loc13_:Array = null;
            var _loc18_:b2Vec2 = null;
            var _loc19_:* = false;
            var _loc20_:Number = NaN;
            var _loc21_:Number = NaN;
            var _loc22_:b2Body = null;
            var _loc23_:b2PolygonShape = null;
            var _loc24_:b2Vec2 = null;
            var _loc25_:b2Vec2 = null;
            var _loc26_:BladeShard = null;
            trace("blade smash impulse " + param1.impulse);
            delete contactImpulseDict[this.bladeShape];
            _session.contactListener.deleteListener(ContactListener.RESULT,this.bladeShape);
            this.bladeSmashed = true;
            var _loc2_:b2Vec2 = this.copterBody.GetLocalPoint(param1.position);
            _loc2_.Subtract(this.bladeLocalCenter);
            var _loc3_:Number = 20 / character_scale;
            var _loc4_:Number = -5 / character_scale;
            var _loc5_:Number = 5 / character_scale;
            var _loc6_:Number = 235 / character_scale;
            if(_loc2_.x < 0)
            {
                _loc19_ = false;
                _loc20_ = -200 / character_scale;
                _loc21_ = -35 / character_scale;
            }
            else
            {
                _loc19_ = true;
                _loc20_ = 35 / character_scale;
                _loc21_ = 200 / character_scale;
                _loc6_ = -_loc6_;
            }
            var _loc7_:b2Vec2 = new b2Vec2(_loc20_,_loc4_);
            var _loc8_:b2Vec2 = new b2Vec2(_loc21_,_loc4_);
            var _loc9_:b2Vec2 = new b2Vec2(_loc21_,_loc5_);
            var _loc10_:b2Vec2 = new b2Vec2(_loc20_,_loc5_);
            var _loc11_:b2Vec2 = new b2Vec2(0,0);
            if(_loc2_.x < _loc20_ + _loc3_)
            {
                _loc11_.x = _loc21_ - _loc3_;
                _loc13_ = [_loc11_,_loc10_,_loc7_];
                if(_loc2_.y > 0)
                {
                    _loc11_.y = _loc4_;
                    _loc12_ = [_loc11_,_loc8_,_loc9_,_loc10_];
                }
                else
                {
                    _loc11_.y = _loc5_;
                    _loc12_ = [_loc11_,_loc7_,_loc8_,_loc9_];
                }
            }
            else if(_loc2_.x > _loc21_ - _loc3_)
            {
                _loc11_.x = _loc20_ + _loc3_;
                _loc13_ = [_loc11_,_loc8_,_loc9_];
                if(_loc2_.y > 0)
                {
                    _loc11_.y = _loc4_;
                    _loc12_ = [_loc11_,_loc9_,_loc10_,_loc7_];
                }
                else
                {
                    _loc11_.y = _loc5_;
                    _loc12_ = [_loc11_,_loc10_,_loc7_,_loc8_];
                }
            }
            else
            {
                _loc11_.x = _loc2_.x;
                _loc13_ = [_loc11_,_loc8_,_loc9_];
                if(_loc2_.y > 0)
                {
                    _loc11_.y = _loc5_;
                    _loc12_ = [_loc11_,_loc10_,_loc7_,_loc8_];
                }
                else
                {
                    _loc11_.y = _loc4_;
                    _loc12_ = [_loc11_,_loc9_,_loc10_,_loc7_];
                }
            }
            this.bladeShards = new Array();
            var _loc14_:b2BodyDef = new b2BodyDef();
            _loc14_.position = this.copterBody.GetWorldPoint(this.bladeLocalCenter);
            _loc14_.angle = this.copterBody.GetAngle();
            var _loc15_:b2PolygonDef = new b2PolygonDef();
            _loc15_.density = 3;
            _loc15_.friction = 0.3;
            _loc15_.restitution = 0.1;
            _loc15_.filter = zeroFilter;
            var _loc16_:Number = 50;
            var _loc17_:int = 0;
            while(_loc17_ < 2)
            {
                if(_loc17_ == 1)
                {
                    _loc7_.x += _loc6_;
                    _loc8_.x += _loc6_;
                    _loc9_.x += _loc6_;
                    _loc10_.x += _loc6_;
                    _loc11_.x += _loc6_;
                    _loc19_ = !_loc19_;
                }
                _loc22_ = _session.m_world.CreateBody(_loc14_);
                _loc15_.vertexCount = 4;
                _loc15_.vertices = _loc12_;
                _loc23_ = _loc22_.CreateShape(_loc15_) as b2PolygonShape;
                _loc22_.SetMassFromShapes();
                _loc18_ = _loc22_.GetWorldCenter();
                _loc24_ = this.copterBody.GetLinearVelocityFromWorldPoint(_loc18_);
                _loc25_ = new b2Vec2(_loc18_.x - _loc22_.GetPosition().x,_loc18_.y - _loc22_.GetPosition().y);
                _loc25_.Multiply(_loc16_);
                _loc24_.Add(_loc25_);
                _loc22_.SetLinearVelocity(_loc24_);
                _loc26_ = new BladeShard(_loc22_,_loc19_,this);
                this.bladeShards.push(_loc26_);
                _loc15_.vertexCount = 3;
                _loc15_.vertices = _loc13_;
                _loc22_ = _session.m_world.CreateBody(_loc14_);
                _loc23_ = _loc22_.CreateShape(_loc15_) as b2PolygonShape;
                _loc22_.SetMassFromShapes();
                _loc24_ = this.copterBody.GetLinearVelocityFromWorldPoint(_loc22_.GetWorldCenter());
                _loc25_ = new b2Vec2(_loc18_.x - _loc22_.GetPosition().x,_loc18_.y - _loc22_.GetPosition().y);
                _loc25_.Multiply(_loc16_);
                _loc24_.Add(_loc25_);
                _loc22_.SetLinearVelocity(_loc24_);
                _loc26_ = new BladeShard(_loc22_,_loc19_,this);
                this.bladeShards.push(_loc26_);
                _loc17_++;
            }
            _loc18_ = this.copterBody.GetWorldPoint(this.bladeLocalCenter);
            _session.particleController.createPointBurst("copterShards",_loc18_.x * m_physScale,_loc18_.y * m_physScale,30,60,70);
            this.copterBody.DestroyShape(this.bladeShape);
            this.copterMC.inner.propeller.visible = false;
            this.copterMC.inner.brokenPropeller.visible = true;
            this.heliLoop.stopSound();
            this.heliLoop = null;
            SoundController.instance.playAreaSoundInstance("MetalSmashHeavy4",this.copterBody);
            addVocals("Help",4);
        }
        
        internal function copterLegSmash(param1:b2Shape, param2:ContactEvent, param3:Boolean = true) : void
        {
            var _loc14_:int = 0;
            trace("copterleg smash impulse " + param2.impulse);
            delete contactImpulseDict[param1];
            _session.contactListener.deleteListener(ContactListener.RESULT,param1);
            _session.contactListener.deleteListener(ContactListener.ADD,param1);
            var _loc4_:b2World = _session.m_world;
            var _loc5_:b2Vec2 = this.copterBody.GetPosition();
            var _loc6_:Number = this.copterBody.GetAngle();
            var _loc7_:b2Vec2 = this.copterBody.GetLinearVelocity();
            var _loc8_:Number = this.copterBody.GetAngularVelocity();
            var _loc9_:b2BodyDef = new b2BodyDef();
            _loc9_.position = _loc5_;
            _loc9_.angle = _loc6_;
            var _loc10_:b2PolygonDef = new b2PolygonDef();
            _loc10_.density = 3;
            _loc10_.friction = 0.3;
            _loc10_.restitution = 0.3;
            _loc10_.filter = zeroFilter;
            if(param1 == this.wheel1Shape)
            {
                _loc14_ = 5;
                this.copterFrontMC.inner.leg1.visible = false;
                this.copterBody.DestroyShape(this.leg1Shape);
            }
            else
            {
                _loc14_ = 6;
                this.copterFrontMC.inner.leg2.visible = false;
                this.copterBody.DestroyShape(this.leg2Shape);
            }
            var _loc11_:b2Body = _loc4_.CreateBody(_loc9_);
            var _loc12_:Array = this.vertsBrokenCopter[_loc14_];
            var _loc13_:Sprite = this.brokenCopterMCs[_loc14_];
            _loc10_.vertexCount = _loc12_.length;
            _loc10_.vertices = _loc12_;
            _loc11_.CreateShape(_loc10_);
            _loc11_.SetMassFromShapes();
            _loc11_.SetAngularVelocity(_loc8_);
            _loc11_.SetLinearVelocity(this.copterBody.GetLinearVelocityFromLocalPoint(_loc11_.GetLocalCenter()));
            _loc11_.SetUserData(_loc13_);
            _loc13_.visible = true;
            paintVector.push(_loc11_);
            this.copterBody.DestroyShape(param1);
            if(param3)
            {
                SoundController.instance.playAreaSoundInstance("StemSnap",this.copterBody);
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
        
        internal function checkEject() : void
        {
            if(!this.copterHand1 && !this.copterHand2)
            {
                this.eject();
            }
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
            if(this.copterHand1)
            {
                _session.m_world.DestroyJoint(this.copterHand1);
                this.copterHand1 = null;
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
            if(this.copterHand2)
            {
                _session.m_world.DestroyJoint(this.copterHand2);
                this.copterHand2 = null;
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
            if(this.copterHand1)
            {
                _session.m_world.DestroyJoint(this.copterHand1);
                this.copterHand1 = null;
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
            if(this.copterHand2)
            {
                _session.m_world.DestroyJoint(this.copterHand2);
                this.copterHand2 = null;
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
        }
        
        override internal function kneeBreak1(param1:Number) : void
        {
            super.kneeBreak1(param1);
            if(this.ejected)
            {
                return;
            }
            this.removeFromCOMArray(lowerLeg1Body);
        }
        
        override internal function kneeBreak2(param1:Number) : void
        {
            super.kneeBreak2(param1);
            if(this.ejected)
            {
                return;
            }
            this.removeFromCOMArray(lowerLeg2Body);
        }
        
        internal function leanBackPose() : void
        {
            setJoint(neckJoint,0,10);
            setJoint(elbowJoint1,2,5);
            setJoint(elbowJoint2,2,5);
        }
        
        internal function leanForwardPose() : void
        {
            setJoint(neckJoint,0.4,10);
            setJoint(elbowJoint1,0.5,5);
            setJoint(elbowJoint2,0.5,5);
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

