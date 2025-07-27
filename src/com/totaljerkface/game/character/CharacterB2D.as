package com.totaljerkface.game.character
{
    import Box2D.Collision.*;
    import Box2D.Collision.Shapes.*;
    import Box2D.Common.*;
    import Box2D.Common.Math.*;
    import Box2D.Dynamics.*;
    import Box2D.Dynamics.Contacts.*;
    import Box2D.Dynamics.Joints.*;
    import com.totaljerkface.game.*;
    import com.totaljerkface.game.events.ContactEvent;
    import com.totaljerkface.game.events.ReplayEvent;
    import com.totaljerkface.game.level.groups.Vehicle;
    import com.totaljerkface.game.particles.*;
    import com.totaljerkface.game.sound.AreaSoundInstance;
    import com.totaljerkface.game.sound.SoundController;
    import flash.display.*;
    import flash.events.*;
    import flash.system.*;
    import flash.utils.*;
    
    public class CharacterB2D extends EventDispatcher
    {
        public static const DEF_HEAD_MASS:Number = 0.05456;
        
        public static const DEF_CHEST_MASS:Number = 0.17171;
        
        public static const DEF_PELVIS_MASS:Number = 0.0735;
        
        public static const DEF_UPPERARM_MASS:Number = 0.07019;
        
        public static const DEF_LOWERARM_MASS:Number = 0.07784;
        
        public static const DEF_UPPERLEG_MASS:Number = 0.14914;
        
        public static const DEF_LOWERLEG_MASS:Number = 0.10218;
        
        public static const DEF_HEAD_SMASH:Number = 3;
        
        public static const DEF_CHEST_SMASH:Number = 7.5;
        
        public static const DEF_PELVIS_SMASH:Number = 5.5;
        
        public static const DEF_FOOT_SMASH:Number = 4;
        
        protected static const oneEightyOverPI:Number = 180 / Math.PI;
        
        protected static const BLEED_OUT_TOTAL:int = 150;
        
        public static const GRIND_STATE:int = 1;
        
        internal var _startX:*;
        
        internal var _startY:*;
        
        public var shapeGuide:Sprite;
        
        protected var _session:Session;
        
        internal var groupID:int;
        
        internal var tag:String;
        
        public var main:Boolean = true;
        
        internal var contactImpulseDict:Dictionary;
        
        internal var contactResultBuffer:Dictionary;
        
        internal var contactAddBuffer:Dictionary;
        
        internal var contactAddSounds:Dictionary;
        
        internal var mc_scale:Number = 2;
        
        internal var character_scale:Number;
        
        internal var m_physScale:Number;
        
        internal var shapeRefScale:Number = 5;
        
        internal var leftPressed:Boolean;
        
        internal var rightPressed:Boolean;
        
        internal var upPressed:Boolean;
        
        internal var downPressed:Boolean;
        
        internal var spacePressed:Boolean;
        
        internal var ctrlPressed:Boolean;
        
        internal var shiftPressed:Boolean;
        
        internal var zPressed:Boolean;
        
        protected var _currentPose:int = 0;
        
        protected var _bleedCounter:int = 0;
        
        internal var headSmashLimit:Number;
        
        internal var chestSmashLimit:Number;
        
        internal var pelvisSmashLimit:Number;
        
        internal var footSmashLimit:Number;
        
        internal var neckBreakLimit:int = 75;
        
        internal var spineLimit:int = 95;
        
        internal var torsoBreakLimit:int = 160;
        
        internal var intestineLimit:int = 240;
        
        internal var shoulderBreakLimit:int = 65;
        
        internal var shoulderSnapLimit:int = 80;
        
        internal var hipBreakLimit:int = 85;
        
        internal var hipSnapLimit:int = 100;
        
        internal var elbowBreakLimit:int = 60;
        
        internal var elbowLigamentLimit:int = 70;
        
        internal var kneeBreakLimit:int = 65;
        
        internal var kneeLigamentLimit:int = 80;
        
        protected var _dead:Boolean;
        
        protected var _dying:Boolean;
        
        internal var grabbing:Boolean;
        
        internal var headSmashed:Boolean;
        
        internal var chestSmashed:Boolean;
        
        internal var pelvisSmashed:Boolean;
        
        internal var paintVector:Vector.<b2Body>;
        
        protected var lineThickness:Number = 1;
        
        protected var lineColor:uint = 16711680;
        
        protected var lineAlpha:Number = 1;
        
        protected var ligamentLength:Number;
        
        protected var intestineLength:Number;
        
        protected var headChunkRadius:Number;
        
        protected var chestChunkRadius:Number;
        
        protected var pelvisChunkRadius:Number;
        
        protected var brainRadius:Number = 12;
        
        public var defaultFilter:b2FilterData;
        
        public var zeroFilter:b2FilterData;
        
        public var lowerBodyFilter:b2FilterData;
        
        public var head1Body:b2Body;
        
        internal var chestBody:b2Body;
        
        internal var pelvisBody:b2Body;
        
        internal var upperArm1Body:b2Body;
        
        internal var upperArm2Body:b2Body;
        
        internal var lowerArm1Body:b2Body;
        
        internal var lowerArm2Body:b2Body;
        
        internal var upperLeg1Body:b2Body;
        
        internal var upperLeg2Body:b2Body;
        
        internal var lowerLeg1Body:b2Body;
        
        internal var lowerLeg2Body:b2Body;
        
        internal var brainBody:b2Body;
        
        internal var heartBody:b2Body;
        
        internal var upperArm3Body:b2Body;
        
        internal var upperArm4Body:b2Body;
        
        internal var upperLeg3Body:b2Body;
        
        internal var upperLeg4Body:b2Body;
        
        internal var foot1Body:b2Body;
        
        internal var foot2Body:b2Body;
        
        internal var chunks:Array;
        
        internal var head1Shape:b2Shape;
        
        internal var chestShape:b2Shape;
        
        internal var pelvisShape:b2Shape;
        
        internal var lowerLeg1Shape:b2Shape;
        
        internal var lowerLeg2Shape:b2Shape;
        
        internal var lowerArm1Shape:b2Shape;
        
        internal var lowerArm2Shape:b2Shape;
        
        public var head1MC:MovieClip;
        
        internal var chestMC:MovieClip;
        
        internal var pelvisMC:MovieClip;
        
        internal var upperLeg1MC:MovieClip;
        
        internal var upperLeg2MC:MovieClip;
        
        internal var upperArm1MC:MovieClip;
        
        internal var upperArm2MC:MovieClip;
        
        internal var lowerArm1MC:MovieClip;
        
        internal var lowerArm2MC:MovieClip;
        
        internal var lowerLeg1MC:MovieClip;
        
        internal var lowerLeg2MC:MovieClip;
        
        internal var headChunkMCs:Array;
        
        internal var chestChunkMCs:Array;
        
        internal var pelvisChunkMCs:Array;
        
        internal var spineMCs:Array;
        
        internal var intestineMCs:Array;
        
        internal var brainMC:MovieClip;
        
        internal var heartMC:MovieClip;
        
        internal var upperArm3MC:MovieClip;
        
        internal var upperArm4MC:MovieClip;
        
        internal var upperLeg3MC:MovieClip;
        
        internal var upperLeg4MC:MovieClip;
        
        internal var foot1MC:MovieClip;
        
        internal var foot2MC:MovieClip;
        
        internal var neckJoint:b2RevoluteJoint;
        
        internal var waistJoint:b2RevoluteJoint;
        
        internal var shoulderJoint1:b2RevoluteJoint;
        
        internal var shoulderJoint2:b2RevoluteJoint;
        
        internal var elbowJoint1:b2RevoluteJoint;
        
        internal var elbowJoint2:b2RevoluteJoint;
        
        internal var hipJoint1:b2RevoluteJoint;
        
        internal var hipJoint2:b2RevoluteJoint;
        
        internal var kneeJoint1:b2RevoluteJoint;
        
        internal var kneeJoint2:b2RevoluteJoint;
        
        internal var gripJoint1:b2RevoluteJoint;
        
        internal var gripJoint2:b2RevoluteJoint;
        
        internal var spinalChord:SpinalChord;
        
        internal var intestineChain:IntestineChain;
        
        internal var elbowLigament1:Ligament;
        
        internal var elbowLigament2:Ligament;
        
        internal var kneeLigament1:Ligament;
        
        internal var kneeLigament2:Ligament;
        
        internal var composites:Array;
        
        internal var headBloodFlow:Emitter;
        
        internal var neckBloodFlow:Emitter;
        
        internal var stomachBloodFlow:Emitter;
        
        internal var shoulder1BloodFlow:Emitter;
        
        internal var shoulder2BloodFlow:Emitter;
        
        internal var arm1BloodFlow:Emitter;
        
        internal var arm2BloodFlow:Emitter;
        
        internal var hip1BloodFlow:Emitter;
        
        internal var hip2BloodFlow:Emitter;
        
        internal var thigh1BloodFlow:Emitter;
        
        internal var thigh2BloodFlow:Emitter;
        
        protected var voiceSound:AreaSoundInstance;
        
        protected var voicePriority:int = -1;
        
        protected var voiceArray:Array;
        
        internal var actionsVector:Vector.<Function>;
        
        internal var sourceObject:DisplayObject;
        
        public var cameraFocus:b2Body;
        
        public var cameraSecondFocus:b2Body;
        
        internal var userVehicle:Vehicle;
        
        protected var vehicleArm1Joint:b2RevoluteJoint;
        
        protected var vehicleArm2Joint:b2RevoluteJoint;
        
        public function CharacterB2D(param1:Number, param2:Number, param3:DisplayObject, param4:Session, param5:int = -1, param6:String = "Char1")
        {
            super();
            this.sourceObject = param3;
            this.groupID = param5;
            this.tag = param6;
            this.session = param4;
            this.m_physScale = param4.m_physScale;
            this.character_scale = this.m_physScale * this.mc_scale;
            this._startX = param1 / this.m_physScale;
            this._startY = param2 / this.m_physScale;
            this.composites = new Array();
            this.voiceArray = new Array();
            this.actionsVector = new Vector.<Function>();
        }
        
        public function get session() : Session
        {
            return this._session;
        }
        
        public function set session(param1:Session) : void
        {
            this._session = param1;
        }
        
        public function addKeyListeners() : void
        {
            Settings.stageSprite.addEventListener(KeyboardEvent.KEY_DOWN,this.keyDownHandler);
            Settings.stageSprite.addEventListener(KeyboardEvent.KEY_UP,this.keyUpHandler);
        }
        
        public function removeKeyListeners() : void
        {
            trace("REMOVE");
            Settings.stageSprite.removeEventListener(KeyboardEvent.KEY_DOWN,this.keyDownHandler);
            Settings.stageSprite.removeEventListener(KeyboardEvent.KEY_UP,this.keyUpHandler);
            this.leftPressed = false;
            this.rightPressed = false;
            this.upPressed = false;
            this.downPressed = false;
            this.spacePressed = false;
        }
        
        public function set startX(param1:Number) : void
        {
            this._startX = param1 / this.m_physScale;
        }
        
        public function set startY(param1:Number) : void
        {
            this._startY = param1 / this.m_physScale;
        }
        
        internal function keyDownHandler(param1:KeyboardEvent) : void
        {
            switch(param1.keyCode)
            {
                case Settings.leanBackCode:
                    this.leftPressed = true;
                    break;
                case Settings.accelerateCode:
                    this.upPressed = true;
                    break;
                case Settings.leanForwardCode:
                    this.rightPressed = true;
                    break;
                case Settings.decelerateCode:
                    this.downPressed = true;
                    break;
                case Settings.primaryActionCode:
                    this.spacePressed = true;
                    break;
                case Settings.secondaryAction1Code:
                    this.shiftPressed = true;
                    break;
                case Settings.secondaryAction2Code:
                    this.ctrlPressed = true;
                    break;
                case Settings.ejectCode:
                    this.zPressed = true;
                    break;
                case Settings.switchCameraCode:
                    this.switchCamera();
                    break;
                case 82:
            }
        }
        
        internal function keyUpHandler(param1:KeyboardEvent) : void
        {
            switch(param1.keyCode)
            {
                case Settings.leanBackCode:
                    this.leftPressed = false;
                    break;
                case Settings.accelerateCode:
                    this.upPressed = false;
                    break;
                case Settings.leanForwardCode:
                    this.rightPressed = false;
                    break;
                case Settings.decelerateCode:
                    this.downPressed = false;
                    break;
                case Settings.primaryActionCode:
                    this.spacePressed = false;
                    break;
                case Settings.secondaryAction1Code:
                    this.shiftPressed = false;
                    break;
                case Settings.secondaryAction2Code:
                    this.ctrlPressed = false;
                    break;
                case Settings.ejectCode:
                    this.zPressed = false;
            }
        }
        
        public function doNothing() : void
        {
            this.leftAndRightActions();
            this.upAndDownActions();
            this.spaceNullActions();
            this.shiftNullActions();
            this.ctrlNullActions();
            this.zNullActions();
        }
        
        public function checkKeyStates() : void
        {
            var _loc1_:* = "";
            if(this.dead)
            {
                if(this.leftPressed)
                {
                    if(this.rightPressed)
                    {
                        _loc1_ += "11";
                    }
                    else
                    {
                        _loc1_ += "10";
                    }
                }
                else if(this.rightPressed)
                {
                    _loc1_ += "01";
                }
                else
                {
                    _loc1_ += "00";
                }
                if(this.upPressed)
                {
                    if(this.downPressed)
                    {
                        _loc1_ += "11";
                    }
                    else
                    {
                        _loc1_ += "10";
                    }
                }
                else if(this.downPressed)
                {
                    _loc1_ += "01";
                }
                else
                {
                    _loc1_ += "00";
                }
                if(this.spacePressed)
                {
                    _loc1_ += "1";
                }
                else
                {
                    _loc1_ += "0";
                }
                if(this.shiftPressed)
                {
                    _loc1_ += "1";
                }
                else
                {
                    _loc1_ += "0";
                }
                if(this.ctrlPressed)
                {
                    _loc1_ += "1";
                }
                else
                {
                    _loc1_ += "0";
                }
                if(this.zPressed)
                {
                    _loc1_ += "1";
                }
                else
                {
                    _loc1_ += "0";
                }
            }
            else if(this.userVehicle)
            {
                _loc1_ = this.userVehicle.operateKeys(this._session.iteration,this.leftPressed,this.rightPressed,this.upPressed,this.downPressed,this.spacePressed,this.shiftPressed,this.ctrlPressed,this.zPressed);
            }
            else
            {
                if(this.leftPressed)
                {
                    if(this.rightPressed)
                    {
                        this.leftAndRightActions();
                        _loc1_ += "11";
                    }
                    else
                    {
                        this.leftPressedActions();
                        _loc1_ += "10";
                    }
                }
                else if(this.rightPressed)
                {
                    this.rightPressedActions();
                    _loc1_ += "01";
                }
                else
                {
                    this.leftAndRightActions();
                    _loc1_ += "00";
                }
                if(this.upPressed)
                {
                    if(this.downPressed)
                    {
                        this.upAndDownActions();
                        _loc1_ += "11";
                    }
                    else
                    {
                        this.upPressedActions();
                        _loc1_ += "10";
                    }
                }
                else if(this.downPressed)
                {
                    this.downPressedActions();
                    _loc1_ += "01";
                }
                else
                {
                    this.upAndDownActions();
                    _loc1_ += "00";
                }
                if(this.spacePressed)
                {
                    this.spacePressedActions();
                    _loc1_ += "1";
                }
                else
                {
                    this.spaceNullActions();
                    _loc1_ += "0";
                }
                if(this.shiftPressed)
                {
                    this.shiftPressedActions();
                    _loc1_ += "1";
                }
                else
                {
                    this.shiftNullActions();
                    _loc1_ += "0";
                }
                if(this.ctrlPressed)
                {
                    this.ctrlPressedActions();
                    _loc1_ += "1";
                }
                else
                {
                    this.ctrlNullActions();
                    _loc1_ += "0";
                }
                if(this.zPressed)
                {
                    this.zPressedActions();
                    _loc1_ += "1";
                }
                else
                {
                    this.zNullActions();
                    _loc1_ += "0";
                }
            }
            dispatchEvent(new ReplayEvent(ReplayEvent.ADD_ENTRY,_loc1_));
        }
        
        public function checkReplayData(param1:KeyDisplay, param2:String) : void
        {
            if(this.dead)
            {
                if(param2.charAt(0) == "1")
                {
                    if(param2.charAt(1) == "1")
                    {
                        param1.leftKeyON();
                        param1.rightKeyON();
                    }
                    else
                    {
                        param1.leftKeyON();
                        param1.rightKeyOFF();
                    }
                }
                else if(param2.charAt(1) == "1")
                {
                    param1.leftKeyOFF();
                    param1.rightKeyON();
                }
                else
                {
                    param1.rightKeyOFF();
                    param1.leftKeyOFF();
                }
                if(param2.charAt(2) == "1")
                {
                    if(param2.charAt(3) == "1")
                    {
                        param1.upKeyON();
                        param1.downKeyON();
                    }
                    else
                    {
                        param1.upKeyON();
                        param1.downKeyOFF();
                    }
                }
                else if(param2.charAt(3) == "1")
                {
                    param1.upKeyOFF();
                    param1.downKeyON();
                }
                else
                {
                    param1.upKeyOFF();
                    param1.downKeyOFF();
                }
                if(param2.charAt(4) == "1")
                {
                    param1.spaceKeyON();
                }
                else
                {
                    param1.spaceKeyOFF();
                }
                if(param2.charAt(5) == "1")
                {
                    param1.shiftKeyON();
                }
                else
                {
                    param1.shiftKeyOFF();
                }
                if(param2.charAt(6) == "1")
                {
                    param1.ctrlKeyON();
                }
                else
                {
                    param1.ctrlKeyOFF();
                }
                if(param2.charAt(7) == "1")
                {
                    param1.zKeyON();
                }
                else
                {
                    param1.zKeyOFF();
                }
            }
            else if(this.userVehicle)
            {
                this.userVehicle.operateReplayData(this._session.iteration,param2,param1);
            }
            else
            {
                if(param2.charAt(0) == "1")
                {
                    if(param2.charAt(1) == "1")
                    {
                        this.leftAndRightActions();
                        param1.leftKeyON();
                        param1.rightKeyON();
                    }
                    else
                    {
                        this.leftPressedActions();
                        param1.leftKeyON();
                        param1.rightKeyOFF();
                    }
                }
                else if(param2.charAt(1) == "1")
                {
                    this.rightPressedActions();
                    param1.leftKeyOFF();
                    param1.rightKeyON();
                }
                else
                {
                    this.leftAndRightActions();
                    param1.rightKeyOFF();
                    param1.leftKeyOFF();
                }
                if(param2.charAt(2) == "1")
                {
                    if(param2.charAt(3) == "1")
                    {
                        this.upAndDownActions();
                        param1.upKeyON();
                        param1.downKeyON();
                    }
                    else
                    {
                        this.upPressedActions();
                        param1.upKeyON();
                        param1.downKeyOFF();
                    }
                }
                else if(param2.charAt(3) == "1")
                {
                    this.downPressedActions();
                    param1.upKeyOFF();
                    param1.downKeyON();
                }
                else
                {
                    this.upAndDownActions();
                    param1.upKeyOFF();
                    param1.downKeyOFF();
                }
                if(param2.charAt(4) == "1")
                {
                    this.spacePressedActions();
                    param1.spaceKeyON();
                }
                else
                {
                    this.spaceNullActions();
                    param1.spaceKeyOFF();
                }
                if(param2.charAt(5) == "1")
                {
                    this.shiftPressedActions();
                    param1.shiftKeyON();
                }
                else
                {
                    this.shiftNullActions();
                    param1.shiftKeyOFF();
                }
                if(param2.charAt(6) == "1")
                {
                    this.ctrlPressedActions();
                    param1.ctrlKeyON();
                }
                else
                {
                    this.ctrlNullActions();
                    param1.ctrlKeyOFF();
                }
                if(param2.charAt(7) == "1")
                {
                    this.zPressedActions();
                    param1.zKeyON();
                }
                else
                {
                    this.zNullActions();
                    param1.zKeyOFF();
                }
            }
        }
        
        public function preActions() : void
        {
        }
        
        public function actions() : void
        {
            var _loc3_:Function = null;
            this.checkPose();
            if(!this._dead)
            {
                this.checkVocals();
                this.voiceArray = new Array();
                if(this._dying)
                {
                    this.checkBleedOut();
                }
            }
            var _loc1_:int = int(this.actionsVector.length);
            var _loc2_:int = 0;
            while(_loc2_ < _loc1_)
            {
                _loc3_ = this.actionsVector[_loc2_];
                _loc3_();
                _loc2_++;
            }
        }
        
        public function removeAction(param1:Function) : void
        {
            var _loc2_:int = int(this.actionsVector.indexOf(param1));
            if(_loc2_ > -1)
            {
                this.actionsVector.splice(_loc2_,1);
            }
        }
        
        protected function switchCamera() : void
        {
        }
        
        protected function checkVocals() : void
        {
            var _loc2_:String = null;
            var _loc1_:int = int(this.voiceArray.length - 1);
            if(this.voiceSound)
            {
                if(this.voiceSound.soundChannel)
                {
                    if(_loc1_ > this.voicePriority)
                    {
                        this.voiceSound.stopSound();
                        _loc2_ = this.voiceArray[_loc1_];
                        this.voiceSound = SoundController.instance.playAreaSoundInstance(this.tag + _loc2_,this.head1Body);
                        this.voicePriority = _loc1_;
                    }
                    return;
                }
                this.voiceSound = null;
                this.voicePriority = -1;
            }
            if(_loc1_ < 0)
            {
                return;
            }
            _loc2_ = this.voiceArray[_loc1_];
            this.voiceSound = SoundController.instance.playAreaSoundInstance(this.tag + _loc2_,this.head1Body);
            this.voicePriority = _loc1_;
        }
        
        protected function checkBleedOut() : void
        {
            this._bleedCounter += 1;
            if(this._bleedCounter == BLEED_OUT_TOTAL)
            {
                this.dead = true;
            }
        }
        
        protected function checkPose() : void
        {
            switch(this._currentPose)
            {
                case 1:
                    this.archPose();
                    break;
                case 2:
                    this.pushupPose();
                    break;
                case 3:
                    this.supermanPose();
                    break;
                case 4:
                    this.tuckPose();
                    break;
                case 10:
                    this.armsForwardPose();
                    break;
                case 11:
                    this.armsOverheadPose();
                    break;
                case 12:
                    this.holdPositionPose();
            }
        }
        
        internal function leftPressedActions() : void
        {
            this.chestBody.ApplyImpulse(new b2Vec2(-1,0),this.chestBody.GetWorldCenter());
        }
        
        internal function rightPressedActions() : void
        {
            this.chestBody.ApplyImpulse(new b2Vec2(1,0),this.chestBody.GetWorldCenter());
        }
        
        internal function leftAndRightActions() : void
        {
        }
        
        internal function upPressedActions() : void
        {
            this.chestBody.ApplyImpulse(new b2Vec2(0,-1),this.chestBody.GetWorldCenter());
        }
        
        internal function downPressedActions() : void
        {
            this.chestBody.ApplyImpulse(new b2Vec2(0,1),this.chestBody.GetWorldCenter());
        }
        
        internal function upAndDownActions() : void
        {
        }
        
        internal function spacePressedActions() : void
        {
        }
        
        internal function spaceNullActions() : void
        {
        }
        
        internal function shiftPressedActions() : void
        {
        }
        
        internal function shiftNullActions() : void
        {
        }
        
        internal function ctrlPressedActions() : void
        {
        }
        
        internal function ctrlNullActions() : void
        {
        }
        
        internal function zPressedActions() : void
        {
        }
        
        internal function zNullActions() : void
        {
        }
        
        public function create() : void
        {
            this.createFilters();
            this.createBodies();
            this.createJoints();
            this.createMovieClips();
            this.setLimits();
            this.createDictionaries();
        }
        
        internal function createFilters() : void
        {
            this.defaultFilter = new b2FilterData();
            this.defaultFilter.groupIndex = this.groupID;
            this.defaultFilter.categoryBits = 260;
            this.defaultFilter.maskBits = 270;
            this.zeroFilter = new b2FilterData();
            this.zeroFilter.groupIndex = 0;
            this.zeroFilter.categoryBits = 260;
            this.lowerBodyFilter = new b2FilterData();
            this.lowerBodyFilter.categoryBits = 260;
            this.lowerBodyFilter.maskBits = 270;
            this.lowerBodyFilter.groupIndex = this.groupID - 5;
        }
        
        internal function setLimits() : void
        {
            var _loc1_:Number = this.head1Body.GetMass() / DEF_HEAD_MASS;
            var _loc2_:Number = this.chestBody.GetMass() / DEF_CHEST_MASS;
            var _loc3_:Number = this.pelvisBody.GetMass() / DEF_PELVIS_MASS;
            var _loc4_:Number = this.upperArm1Body.GetMass() / DEF_UPPERARM_MASS;
            var _loc5_:Number = this.lowerArm1Body.GetMass() / DEF_LOWERARM_MASS;
            var _loc6_:Number = this.upperLeg1Body.GetMass() / DEF_UPPERLEG_MASS;
            var _loc7_:Number = this.lowerLeg1Body.GetMass() / DEF_LOWERLEG_MASS;
            this.headSmashLimit = DEF_HEAD_SMASH * _loc1_;
            this.chestSmashLimit = DEF_CHEST_SMASH * _loc2_;
            this.pelvisSmashLimit = DEF_PELVIS_SMASH * _loc3_;
            this.footSmashLimit = DEF_FOOT_SMASH * _loc7_;
            this.neckBreakLimit = Math.round(85 * _loc1_);
            this.spineLimit = Math.round(105 * _loc1_);
            this.torsoBreakLimit = Math.round(180 * _loc3_);
            this.intestineLimit = Math.round(260 * _loc3_);
            this.shoulderBreakLimit = Math.round(75 * _loc4_);
            this.shoulderSnapLimit = Math.round(90 * _loc4_);
            this.hipBreakLimit = Math.round(95 * _loc6_);
            this.hipSnapLimit = Math.round(110 * _loc6_);
            this.elbowBreakLimit = Math.round(70 * _loc5_);
            this.elbowLigamentLimit = Math.round(80 * _loc5_);
            this.kneeBreakLimit = Math.round(80 * _loc7_);
            this.kneeLigamentLimit = Math.round(95 * _loc7_);
        }
        
        public function reset() : void
        {
            this.dead = false;
            this._dying = false;
            this._currentPose = 0;
            this._bleedCounter = 0;
            this.createFilters();
            this.createBodies();
            this.createJoints();
            this.resetMovieClips();
            this.createDictionaries();
            this.cameraFocus = this.chestBody;
        }
        
        public function die() : void
        {
            var _loc2_:Ligament = null;
            this.brainBody = null;
            this.heartBody = null;
            this.upperArm3Body = null;
            this.upperArm4Body = null;
            this.upperLeg3Body = null;
            this.upperLeg4Body = null;
            this.headBloodFlow = null;
            this.stomachBloodFlow = null;
            this.neckBloodFlow = null;
            this.shoulder1BloodFlow = null;
            this.shoulder2BloodFlow = null;
            this.hip1BloodFlow = null;
            this.hip2BloodFlow = null;
            this.chunks = new Array();
            this.voiceArray = new Array();
            this.voiceSound = null;
            this.voicePriority = -1;
            var _loc1_:int = 0;
            while(_loc1_ < this.composites.length)
            {
                if(this.composites[_loc1_] is Ligament)
                {
                    _loc2_ = this.composites[_loc1_];
                    _loc2_.die();
                }
                _loc1_++;
            }
            this.kneeLigament1 = null;
            this.kneeLigament2 = null;
            this.elbowLigament1 = null;
            this.elbowLigament2 = null;
            this.composites = new Array();
            if(this.intestineChain)
            {
                this.intestineChain = null;
            }
            if(this.spinalChord)
            {
                this.spinalChord.die();
                this.spinalChord = null;
            }
            this.actionsVector = new Vector.<Function>();
            this.userVehicle = null;
            this.vehicleArm1Joint = null;
            this.vehicleArm2Joint = null;
        }
        
        public function paint() : void
        {
            var _loc2_:b2Body = null;
            var _loc3_:b2Vec2 = null;
            var _loc1_:int = 0;
            while(_loc1_ < this.paintVector.length)
            {
                _loc2_ = this.paintVector[_loc1_];
                _loc3_ = _loc2_.GetWorldCenter();
                _loc2_.m_userData.x = _loc3_.x * this.m_physScale;
                _loc2_.m_userData.y = _loc3_.y * this.m_physScale;
                _loc2_.m_userData.rotation = _loc2_.GetAngle() * oneEightyOverPI % 360;
                _loc1_++;
            }
            _loc1_ = 0;
            while(_loc1_ < this.composites.length)
            {
                this.composites[_loc1_].paint();
                _loc1_++;
            }
        }
        
        internal function createDictionaries() : void
        {
            this.contactResultBuffer = new Dictionary();
            this.contactAddBuffer = new Dictionary();
            this.contactAddSounds = new Dictionary();
            this.contactImpulseDict = new Dictionary();
            this.contactImpulseDict[this.head1Shape] = this.headSmashLimit;
            this.contactImpulseDict[this.chestShape] = this.chestSmashLimit;
            this.contactImpulseDict[this.pelvisShape] = this.pelvisSmashLimit;
            this.contactImpulseDict[this.lowerLeg1Shape] = this.footSmashLimit;
            this.contactImpulseDict[this.lowerLeg2Shape] = this.footSmashLimit;
            this.contactImpulseDict[this.lowerArm1Shape] = 1e-8;
            this.contactImpulseDict[this.lowerArm2Shape] = 1e-8;
            this.contactAddSounds[this.head1Shape] = "Thud1";
            this.contactAddSounds[this.chestShape] = "Thud2";
            this.contactAddSounds[this.pelvisShape] = "Thud2";
        }
        
        internal function createBodies() : void
        {
            var _loc1_:b2World = this._session.m_world;
            this.paintVector = new Vector.<b2Body>();
            this.chunks = new Array();
            var _loc2_:b2BodyDef = new b2BodyDef();
            var _loc3_:b2BodyDef = new b2BodyDef();
            var _loc4_:b2BodyDef = new b2BodyDef();
            var _loc5_:b2BodyDef = new b2BodyDef();
            var _loc6_:b2BodyDef = new b2BodyDef();
            var _loc7_:b2BodyDef = new b2BodyDef();
            var _loc8_:b2BodyDef = new b2BodyDef();
            var _loc9_:b2BodyDef = new b2BodyDef();
            var _loc10_:b2BodyDef = new b2BodyDef();
            var _loc11_:b2BodyDef = new b2BodyDef();
            var _loc12_:b2BodyDef = new b2BodyDef();
            var _loc13_:b2PolygonDef = new b2PolygonDef();
            var _loc14_:b2CircleDef = new b2CircleDef();
            _loc13_.density = 1;
            _loc13_.friction = 0.3;
            _loc13_.restitution = 0.1;
            _loc13_.filter = this.defaultFilter;
            _loc14_.density = 1;
            _loc14_.friction = 0.3;
            _loc14_.restitution = 0.1;
            _loc14_.filter = this.defaultFilter;
            if(!this.shapeGuide)
            {
                this.shapeGuide = this.sourceObject["shapeGuide"];
            }
            if(this.shapeGuide.parent)
            {
                this.shapeGuide.parent.removeChild(this.shapeGuide);
            }
            var _loc15_:MovieClip = this.shapeGuide["chestShape"];
            _loc2_.position.Set(this._startX + _loc15_.x / this.character_scale,this._startY + _loc15_.y / this.character_scale);
            _loc2_.angle = _loc15_.rotation / oneEightyOverPI;
            _loc13_.SetAsBox(_loc15_.scaleX * this.shapeRefScale / this.character_scale,_loc15_.scaleY * this.shapeRefScale / this.character_scale);
            this.chestBody = _loc1_.CreateBody(_loc2_);
            this.chestBody.AllowSleeping(false);
            this.chestShape = this.chestBody.CreateShape(_loc13_);
            this.chestShape.SetUserData(this);
            this.chestShape.SetMaterial(2);
            this._session.contactListener.registerListener(ContactListener.RESULT,this.chestShape,this.contactResultHandler);
            this._session.contactListener.registerListener(ContactListener.ADD,this.chestShape,this.contactAddHandler);
            this.chestBody.SetMassFromShapes();
            this.paintVector.push(this.chestBody);
            this.cameraFocus = this.chestBody;
            _loc15_ = this.shapeGuide["headShape"];
            _loc3_.position.Set(this._startX + _loc15_.x / this.character_scale,this._startY + _loc15_.y / this.character_scale);
            _loc3_.angle = _loc15_.rotation / oneEightyOverPI;
            _loc14_.radius = _loc15_.scaleX * this.shapeRefScale / this.character_scale;
            this.head1Body = _loc1_.CreateBody(_loc3_);
            this.head1Body.AllowSleeping(false);
            this.head1Shape = this.head1Body.CreateShape(_loc14_);
            this.head1Shape.SetMaterial(2);
            this.head1Shape.SetUserData(this);
            this._session.contactListener.registerListener(ContactListener.RESULT,this.head1Shape,this.contactResultHandler);
            this._session.contactListener.registerListener(ContactListener.ADD,this.head1Shape,this.contactAddHandler);
            this.head1Body.SetMassFromShapes();
            this.paintVector.push(this.head1Body);
            _loc15_ = this.shapeGuide["pelvisShape"];
            _loc4_.position.Set(this._startX + _loc15_.x / this.character_scale,this._startY + _loc15_.y / this.character_scale);
            _loc4_.angle = _loc15_.rotation / oneEightyOverPI;
            _loc13_.SetAsBox(_loc15_.scaleX * this.shapeRefScale / this.character_scale,_loc15_.scaleY * this.shapeRefScale / this.character_scale);
            this.pelvisBody = _loc1_.CreateBody(_loc4_);
            this.pelvisBody.AllowSleeping(false);
            this.pelvisShape = this.pelvisBody.CreateShape(_loc13_);
            this.pelvisShape.SetMaterial(2);
            this.pelvisShape.SetUserData(this);
            this._session.contactListener.registerListener(ContactListener.RESULT,this.pelvisShape,this.contactResultHandler);
            this._session.contactListener.registerListener(ContactListener.ADD,this.pelvisShape,this.contactAddHandler);
            this.pelvisBody.SetMassFromShapes();
            this.paintVector.push(this.pelvisBody);
            _loc15_ = this.shapeGuide["upperArm1Shape"];
            _loc5_.position.Set(this._startX + _loc15_.x / this.character_scale,this._startY + _loc15_.y / this.character_scale);
            _loc5_.angle = _loc15_.rotation / oneEightyOverPI;
            _loc13_.SetAsBox(_loc15_.scaleX * this.shapeRefScale / this.character_scale,_loc15_.scaleY * this.shapeRefScale / this.character_scale);
            this.upperArm1Body = _loc1_.CreateBody(_loc5_);
            this.upperArm1Body.CreateShape(_loc13_);
            this.upperArm1Body.SetMassFromShapes();
            this.paintVector.push(this.upperArm1Body);
            _loc15_ = this.shapeGuide["upperArm2Shape"];
            _loc9_.position.Set(this._startX + _loc15_.x / this.character_scale,this._startY + _loc15_.y / this.character_scale);
            _loc9_.angle = _loc15_.rotation / oneEightyOverPI;
            _loc13_.SetAsBox(_loc15_.scaleX * this.shapeRefScale / this.character_scale,_loc15_.scaleY * this.shapeRefScale / this.character_scale);
            this.upperArm2Body = _loc1_.CreateBody(_loc9_);
            this.upperArm2Body.CreateShape(_loc13_);
            this.upperArm2Body.SetMassFromShapes();
            this.paintVector.push(this.upperArm2Body);
            _loc15_ = this.shapeGuide["upperLeg1Shape"];
            _loc7_.position.Set(this._startX + _loc15_.x / this.character_scale,this._startY + _loc15_.y / this.character_scale);
            _loc7_.angle = _loc15_.rotation / oneEightyOverPI;
            _loc13_.SetAsBox(_loc15_.scaleX * this.shapeRefScale / this.character_scale,_loc15_.scaleY * this.shapeRefScale / this.character_scale);
            this.upperLeg1Body = _loc1_.CreateBody(_loc7_);
            this.upperLeg1Body.CreateShape(_loc13_);
            this.upperLeg1Body.SetMassFromShapes();
            this.paintVector.push(this.upperLeg1Body);
            _loc15_ = this.shapeGuide["upperLeg2Shape"];
            _loc11_.position.Set(this._startX + _loc15_.x / this.character_scale,this._startY + _loc15_.y / this.character_scale);
            _loc11_.angle = _loc15_.rotation / oneEightyOverPI;
            _loc13_.SetAsBox(_loc15_.scaleX * this.shapeRefScale / this.character_scale,_loc15_.scaleY * this.shapeRefScale / this.character_scale);
            this.upperLeg2Body = _loc1_.CreateBody(_loc11_);
            this.upperLeg2Body.CreateShape(_loc13_);
            this.upperLeg2Body.SetMassFromShapes();
            this.paintVector.push(this.upperLeg2Body);
            _loc15_ = this.shapeGuide["lowerArm1Shape"];
            _loc6_.position.Set(this._startX + _loc15_.x / this.character_scale,this._startY + _loc15_.y / this.character_scale);
            _loc6_.angle = _loc15_.rotation / oneEightyOverPI;
            _loc13_.SetAsBox(_loc15_.scaleX * this.shapeRefScale / this.character_scale,_loc15_.scaleY * this.shapeRefScale / this.character_scale);
            this.lowerArm1Body = _loc1_.CreateBody(_loc6_);
            this.lowerArm1Shape = this.lowerArm1Body.CreateShape(_loc13_);
            this.lowerArm1Body.SetMassFromShapes();
            this.paintVector.push(this.lowerArm1Body);
            _loc15_ = this.shapeGuide["lowerArm2Shape"];
            _loc10_.position.Set(this._startX + _loc15_.x / this.character_scale,this._startY + _loc15_.y / this.character_scale);
            _loc10_.angle = _loc15_.rotation / oneEightyOverPI;
            _loc13_.SetAsBox(_loc15_.scaleX * this.shapeRefScale / this.character_scale,_loc15_.scaleY * this.shapeRefScale / this.character_scale);
            this.lowerArm2Body = _loc1_.CreateBody(_loc10_);
            this.lowerArm2Shape = this.lowerArm2Body.CreateShape(_loc13_);
            this.lowerArm2Body.SetMassFromShapes();
            this.paintVector.push(this.lowerArm2Body);
            _loc15_ = this.shapeGuide["lowerLeg1Shape"];
            _loc8_.position.Set(this._startX + _loc15_.x / this.character_scale,this._startY + _loc15_.y / this.character_scale);
            _loc8_.angle = _loc15_.rotation / oneEightyOverPI;
            _loc13_.SetAsBox(_loc15_.scaleX * this.shapeRefScale / this.character_scale,_loc15_.scaleY * this.shapeRefScale / this.character_scale);
            this.lowerLeg1Body = _loc1_.CreateBody(_loc8_);
            this.lowerLeg1Shape = this.lowerLeg1Body.CreateShape(_loc13_);
            this._session.contactListener.registerListener(ContactListener.RESULT,this.lowerLeg1Shape,this.contactResultHandler);
            this.lowerLeg1Body.SetMassFromShapes();
            this.paintVector.push(this.lowerLeg1Body);
            _loc15_ = this.shapeGuide["lowerLeg2Shape"];
            _loc12_.position.Set(this._startX + _loc15_.x / this.character_scale,this._startY + _loc15_.y / this.character_scale);
            _loc12_.angle = _loc15_.rotation / oneEightyOverPI;
            _loc13_.SetAsBox(_loc15_.scaleX * this.shapeRefScale / this.character_scale,_loc15_.scaleY * this.shapeRefScale / this.character_scale);
            this.lowerLeg2Body = _loc1_.CreateBody(_loc12_);
            this.lowerLeg2Shape = this.lowerLeg2Body.CreateShape(_loc13_);
            this._session.contactListener.registerListener(ContactListener.RESULT,this.lowerLeg2Shape,this.contactResultHandler);
            this.lowerLeg2Body.SetMassFromShapes();
            this.paintVector.push(this.lowerLeg2Body);
            _loc15_ = this.shapeGuide["intestineShape"];
            this.intestineLength = _loc15_.width;
            _loc15_ = this.shapeGuide["ligamentShape"];
            this.ligamentLength = _loc15_.width;
            _loc15_ = this.shapeGuide["headChunkShape"];
            this.headChunkRadius = _loc15_.width / 2;
            _loc15_ = this.shapeGuide["chestChunkShape"];
            this.chestChunkRadius = _loc15_.width / 2;
            _loc15_ = this.shapeGuide["pelvisChunkShape"];
            this.pelvisChunkRadius = _loc15_.width / 2;
        }
        
        internal function createMovieClips() : void
        {
            var _loc3_:MovieClip = null;
            var _loc4_:MovieClip = null;
            var _loc5_:MovieClip = null;
            var _loc6_:MovieClip = null;
            var _loc7_:MovieClip = null;
            var _loc1_:Sprite = this._session.containerSprite;
            this.upperArm2MC = this.sourceObject["upperArm2"];
            var _loc8_:* = 1 / this.mc_scale;
            this.upperArm2MC.scaleY = 1 / this.mc_scale;
            this.upperArm2MC.scaleX = _loc8_;
            this.upperArm4MC = this.sourceObject["upperArm4"];
            _loc8_ = 1 / this.mc_scale;
            this.upperArm4MC.scaleY = 1 / this.mc_scale;
            this.upperArm4MC.scaleX = _loc8_;
            this.upperArm4MC.visible = false;
            this.lowerArm2MC = this.sourceObject["lowerArm2"];
            _loc8_ = 1 / this.mc_scale;
            this.lowerArm2MC.scaleY = 1 / this.mc_scale;
            this.lowerArm2MC.scaleX = _loc8_;
            this.upperLeg2MC = this.sourceObject["upperLeg2"];
            _loc8_ = 1 / this.mc_scale;
            this.upperLeg2MC.scaleY = 1 / this.mc_scale;
            this.upperLeg2MC.scaleX = _loc8_;
            this.upperLeg4MC = this.sourceObject["upperLeg4"];
            _loc8_ = 1 / this.mc_scale;
            this.upperLeg4MC.scaleY = 1 / this.mc_scale;
            this.upperLeg4MC.scaleX = _loc8_;
            this.upperLeg4MC.visible = false;
            this.lowerLeg2MC = this.sourceObject["lowerLeg2"];
            _loc8_ = 1 / this.mc_scale;
            this.lowerLeg2MC.scaleY = 1 / this.mc_scale;
            this.lowerLeg2MC.scaleX = _loc8_;
            this.foot2MC = this.sourceObject["foot2"];
            _loc8_ = 1 / this.mc_scale;
            this.foot2MC.scaleY = 1 / this.mc_scale;
            this.foot2MC.scaleX = _loc8_;
            this.foot2MC.visible = false;
            this.intestineMCs = new Array();
            var _loc2_:int = 1;
            while(_loc2_ < 11)
            {
                _loc3_ = this.sourceObject["intestine" + _loc2_];
                _loc8_ = 1 / this.mc_scale;
                _loc3_.scaleY = 1 / this.mc_scale;
                _loc3_.scaleX = _loc8_;
                this.intestineMCs.push(_loc3_);
                _loc3_.visible = false;
                _loc2_++;
            }
            this.head1MC = this.sourceObject["head"];
            _loc8_ = 1 / this.mc_scale;
            this.head1MC.scaleY = 1 / this.mc_scale;
            this.head1MC.scaleX = _loc8_;
            this.chestMC = this.sourceObject["chest"];
            _loc8_ = 1 / this.mc_scale;
            this.chestMC.scaleY = 1 / this.mc_scale;
            this.chestMC.scaleX = _loc8_;
            this.chestMC.wound.visible = false;
            this.chestMC.neck.visible = false;
            this.chestChunkMCs = new Array();
            _loc2_ = 1;
            while(_loc2_ < 5)
            {
                _loc4_ = this.sourceObject["chestChunk" + _loc2_];
                _loc8_ = 1 / this.mc_scale;
                _loc4_.scaleY = 1 / this.mc_scale;
                _loc4_.scaleX = _loc8_;
                this.chestChunkMCs.push(_loc4_);
                _loc4_.visible = false;
                _loc2_++;
            }
            this.spineMCs = new Array();
            _loc2_ = 1;
            while(_loc2_ < 11)
            {
                _loc5_ = this.sourceObject["spine" + _loc2_];
                _loc8_ = 1 / this.mc_scale;
                _loc5_.scaleY = 1 / this.mc_scale;
                _loc5_.scaleX = _loc8_;
                this.spineMCs.push(_loc5_);
                _loc5_.visible = false;
                _loc2_++;
            }
            this.pelvisMC = this.sourceObject["pelvis"];
            _loc8_ = 1 / this.mc_scale;
            this.pelvisMC.scaleY = 1 / this.mc_scale;
            this.pelvisMC.scaleX = _loc8_;
            this.pelvisMC.wound.visible = false;
            this.pelvisChunkMCs = new Array();
            _loc2_ = 1;
            while(_loc2_ < 4)
            {
                _loc6_ = this.sourceObject["pelvisChunk" + _loc2_];
                _loc8_ = 1 / this.mc_scale;
                _loc6_.scaleY = 1 / this.mc_scale;
                _loc6_.scaleX = _loc8_;
                this.pelvisChunkMCs.push(_loc6_);
                _loc6_.visible = false;
                _loc2_++;
            }
            this.heartMC = this.sourceObject["heart"];
            _loc8_ = 1 / this.mc_scale;
            this.heartMC.scaleY = 1 / this.mc_scale;
            this.heartMC.scaleX = _loc8_;
            this.heartMC.visible = false;
            this.heartMC.stop();
            this.brainMC = this.sourceObject["brain"];
            _loc8_ = 1 / this.mc_scale;
            this.brainMC.scaleY = 1 / this.mc_scale;
            this.brainMC.scaleX = _loc8_;
            this.brainMC.visible = false;
            this.headChunkMCs = new Array();
            _loc2_ = 1;
            while(_loc2_ < 5)
            {
                _loc7_ = this.sourceObject["headChunk" + _loc2_];
                _loc8_ = 1 / this.mc_scale;
                _loc7_.scaleY = 1 / this.mc_scale;
                _loc7_.scaleX = _loc8_;
                this.headChunkMCs.push(_loc7_);
                _loc7_.visible = false;
                _loc2_++;
            }
            this.upperLeg1MC = this.sourceObject["upperLeg1"];
            _loc8_ = 1 / this.mc_scale;
            this.upperLeg1MC.scaleY = 1 / this.mc_scale;
            this.upperLeg1MC.scaleX = _loc8_;
            this.upperLeg3MC = this.sourceObject["upperLeg3"];
            _loc8_ = 1 / this.mc_scale;
            this.upperLeg3MC.scaleY = 1 / this.mc_scale;
            this.upperLeg3MC.scaleX = _loc8_;
            this.upperLeg3MC.visible = false;
            this.lowerLeg1MC = this.sourceObject["lowerLeg1"];
            _loc8_ = 1 / this.mc_scale;
            this.lowerLeg1MC.scaleY = 1 / this.mc_scale;
            this.lowerLeg1MC.scaleX = _loc8_;
            this.foot1MC = this.sourceObject["foot1"];
            _loc8_ = 1 / this.mc_scale;
            this.foot1MC.scaleY = 1 / this.mc_scale;
            this.foot1MC.scaleX = _loc8_;
            this.foot1MC.visible = false;
            this.upperArm1MC = this.sourceObject["upperArm1"];
            _loc8_ = 1 / this.mc_scale;
            this.upperArm1MC.scaleY = 1 / this.mc_scale;
            this.upperArm1MC.scaleX = _loc8_;
            this.upperArm3MC = this.sourceObject["upperArm3"];
            _loc8_ = 1 / this.mc_scale;
            this.upperArm3MC.scaleY = 1 / this.mc_scale;
            this.upperArm3MC.scaleX = _loc8_;
            this.upperArm3MC.visible = false;
            this.lowerArm1MC = this.sourceObject["lowerArm1"];
            _loc8_ = 1 / this.mc_scale;
            this.lowerArm1MC.scaleY = 1 / this.mc_scale;
            this.lowerArm1MC.scaleX = _loc8_;
            this.head1Body.SetUserData(this.head1MC);
            this.chestBody.SetUserData(this.chestMC);
            this.pelvisBody.SetUserData(this.pelvisMC);
            this.upperArm1Body.SetUserData(this.upperArm1MC);
            this.upperArm2Body.SetUserData(this.upperArm2MC);
            this.upperLeg1Body.SetUserData(this.upperLeg1MC);
            this.upperLeg2Body.SetUserData(this.upperLeg2MC);
            this.lowerArm1Body.SetUserData(this.lowerArm1MC);
            this.lowerArm2Body.SetUserData(this.lowerArm2MC);
            this.lowerLeg1Body.SetUserData(this.lowerLeg1MC);
            this.lowerLeg2Body.SetUserData(this.lowerLeg2MC);
            _loc1_.addChild(this.upperArm2MC);
            _loc1_.addChild(this.upperArm4MC);
            _loc1_.addChild(this.lowerArm2MC);
            _loc1_.addChild(this.upperLeg2MC);
            _loc1_.addChild(this.upperLeg4MC);
            _loc1_.addChild(this.lowerLeg2MC);
            _loc1_.addChild(this.foot2MC);
            _loc2_ = 0;
            while(_loc2_ < this.intestineMCs.length)
            {
                _loc1_.addChild(this.intestineMCs[_loc2_]);
                _loc2_++;
            }
            _loc1_.addChild(this.head1MC);
            _loc1_.addChild(this.chestMC);
            _loc2_ = 0;
            while(_loc2_ < this.chestChunkMCs.length)
            {
                _loc1_.addChild(this.chestChunkMCs[_loc2_]);
                _loc2_++;
            }
            _loc2_ = 0;
            while(_loc2_ < this.spineMCs.length)
            {
                _loc1_.addChild(this.spineMCs[_loc2_]);
                _loc2_++;
            }
            _loc1_.addChild(this.pelvisMC);
            _loc2_ = 0;
            while(_loc2_ < this.pelvisChunkMCs.length)
            {
                _loc1_.addChild(this.pelvisChunkMCs[_loc2_]);
                _loc2_++;
            }
            _loc1_.addChild(this.heartMC);
            _loc1_.addChild(this.brainMC);
            _loc2_ = 0;
            while(_loc2_ < this.headChunkMCs.length)
            {
                _loc1_.addChild(this.headChunkMCs[_loc2_]);
                _loc2_++;
            }
            _loc1_.addChild(this.upperLeg1MC);
            _loc1_.addChild(this.upperLeg3MC);
            _loc1_.addChild(this.lowerLeg1MC);
            _loc1_.addChild(this.foot1MC);
            _loc1_.addChild(this.upperArm1MC);
            _loc1_.addChild(this.upperArm3MC);
            _loc1_.addChild(this.lowerArm1MC);
        }
        
        internal function resetMovieClips() : void
        {
            var _loc2_:MovieClip = null;
            var _loc3_:MovieClip = null;
            var _loc4_:MovieClip = null;
            var _loc5_:MovieClip = null;
            var _loc6_:MovieClip = null;
            this.upperArm2MC.gotoAndStop(1);
            this.upperArm2MC.visible = true;
            this.upperArm4MC.gotoAndStop(1);
            this.upperArm4MC.visible = false;
            this.lowerArm2MC.gotoAndStop(1);
            this.lowerArm2MC.hand.gotoAndStop(1);
            this.upperLeg2MC.gotoAndStop(1);
            this.upperLeg2MC.visible = true;
            this.upperLeg4MC.gotoAndStop(1);
            this.upperLeg4MC.visible = false;
            this.lowerLeg2MC.gotoAndStop(1);
            this.foot2MC.visible = false;
            var _loc1_:int = 0;
            while(_loc1_ < 10)
            {
                _loc2_ = this.intestineMCs[_loc1_];
                _loc2_.visible = false;
                _loc2_.x = -500;
                _loc2_.y = -500;
                _loc1_++;
            }
            this.head1MC.gotoAndStop(1);
            this.head1MC.visible = true;
            this.chestMC.gotoAndStop(1);
            this.chestMC.visible = true;
            this.chestMC.wound.visible = false;
            this.chestMC.neck.visible = false;
            _loc1_ = 0;
            while(_loc1_ < 4)
            {
                _loc3_ = this.chestChunkMCs[_loc1_];
                _loc3_.visible = false;
                _loc1_++;
            }
            _loc1_ = 0;
            while(_loc1_ < 10)
            {
                _loc4_ = this.spineMCs[_loc1_];
                _loc4_.visible = false;
                _loc4_.x = -500;
                _loc4_.y = -500;
                _loc1_++;
            }
            this.pelvisMC.gotoAndStop(1);
            this.pelvisMC.visible = true;
            this.pelvisMC.wound.visible = false;
            _loc1_ = 0;
            while(_loc1_ < 3)
            {
                _loc5_ = this.pelvisChunkMCs[_loc1_];
                _loc5_.visible = false;
                _loc1_++;
            }
            this.heartMC.visible = false;
            this.heartMC.stop();
            this.brainMC.visible = false;
            _loc1_ = 0;
            while(_loc1_ < 4)
            {
                _loc6_ = this.headChunkMCs[_loc1_];
                _loc6_.visible = false;
                _loc1_++;
            }
            this.upperLeg1MC.gotoAndStop(1);
            this.upperLeg1MC.visible = true;
            this.upperLeg3MC.gotoAndStop(1);
            this.upperLeg3MC.visible = false;
            this.lowerLeg1MC.gotoAndStop(1);
            this.foot1MC.visible = false;
            this.upperArm1MC.gotoAndStop(1);
            this.upperArm1MC.visible = true;
            this.upperArm3MC.gotoAndStop(1);
            this.upperArm3MC.visible = false;
            this.lowerArm1MC.gotoAndStop(1);
            this.lowerArm1MC.hand.gotoAndStop(1);
            this.head1Body.SetUserData(this.head1MC);
            this.chestBody.SetUserData(this.chestMC);
            this.pelvisBody.SetUserData(this.pelvisMC);
            this.upperArm1Body.SetUserData(this.upperArm1MC);
            this.upperArm2Body.SetUserData(this.upperArm2MC);
            this.upperLeg1Body.SetUserData(this.upperLeg1MC);
            this.upperLeg2Body.SetUserData(this.upperLeg2MC);
            this.lowerArm1Body.SetUserData(this.lowerArm1MC);
            this.lowerArm2Body.SetUserData(this.lowerArm2MC);
            this.lowerLeg1Body.SetUserData(this.lowerLeg1MC);
            this.lowerLeg2Body.SetUserData(this.lowerLeg2MC);
        }
        
        internal function createJoints() : void
        {
            var _loc3_:Number = NaN;
            var _loc1_:b2World = this._session.m_world;
            var _loc2_:b2RevoluteJointDef = new b2RevoluteJointDef();
            _loc2_.enableLimit = true;
            _loc2_.maxMotorTorque = 4;
            var _loc4_:b2Vec2 = new b2Vec2();
            var _loc5_:MovieClip = this.shapeGuide["headAnchor"];
            _loc4_.Set(this._startX + _loc5_.x / this.character_scale,this._startY + _loc5_.y / this.character_scale);
            _loc3_ = this.head1Body.GetAngle() - this.chestBody.GetAngle();
            _loc2_.lowerAngle = -20 / (180 / Math.PI) - _loc3_;
            _loc2_.upperAngle = 20 / (180 / Math.PI) - _loc3_;
            _loc2_.Initialize(this.chestBody,this.head1Body,_loc4_);
            this.neckJoint = _loc1_.CreateJoint(_loc2_) as b2RevoluteJoint;
            _loc5_ = this.shapeGuide["pelvisAnchor"];
            _loc4_.Set(this._startX + _loc5_.x / this.character_scale,this._startY + _loc5_.y / this.character_scale);
            _loc3_ = this.pelvisBody.GetAngle() - this.chestBody.GetAngle();
            _loc2_.lowerAngle = -5 / (180 / Math.PI) - _loc3_;
            _loc2_.upperAngle = 5 / (180 / Math.PI) - _loc3_;
            _loc2_.Initialize(this.chestBody,this.pelvisBody,_loc4_);
            this.waistJoint = _loc1_.CreateJoint(_loc2_) as b2RevoluteJoint;
            _loc5_ = this.shapeGuide["upperArmAnchor"];
            _loc4_.Set(this._startX + _loc5_.x / this.character_scale,this._startY + _loc5_.y / this.character_scale);
            _loc3_ = this.upperArm1Body.GetAngle() - this.chestBody.GetAngle();
            _loc2_.lowerAngle = -180 / (180 / Math.PI) - _loc3_;
            _loc2_.upperAngle = 60 / (180 / Math.PI) - _loc3_;
            _loc2_.Initialize(this.chestBody,this.upperArm1Body,_loc4_);
            this.shoulderJoint1 = _loc1_.CreateJoint(_loc2_) as b2RevoluteJoint;
            _loc3_ = this.upperArm2Body.GetAngle() - this.chestBody.GetAngle();
            _loc2_.lowerAngle = -180 / (180 / Math.PI) - _loc3_;
            _loc2_.upperAngle = 60 / (180 / Math.PI) - _loc3_;
            _loc2_.Initialize(this.chestBody,this.upperArm2Body,_loc4_);
            this.shoulderJoint2 = _loc1_.CreateJoint(_loc2_) as b2RevoluteJoint;
            _loc5_ = this.shapeGuide["lowerArm1Anchor"];
            _loc4_.Set(this._startX + _loc5_.x / this.character_scale,this._startY + _loc5_.y / this.character_scale);
            _loc3_ = this.lowerArm1Body.GetAngle() - this.upperArm1Body.GetAngle();
            _loc2_.lowerAngle = -160 / (180 / Math.PI) - _loc3_;
            _loc2_.upperAngle = 0 / (180 / Math.PI) - _loc3_;
            _loc2_.Initialize(this.upperArm1Body,this.lowerArm1Body,_loc4_);
            this.elbowJoint1 = _loc1_.CreateJoint(_loc2_) as b2RevoluteJoint;
            _loc5_ = this.shapeGuide["lowerArm2Anchor"];
            _loc4_.Set(this._startX + _loc5_.x / this.character_scale,this._startY + _loc5_.y / this.character_scale);
            _loc3_ = this.lowerArm2Body.GetAngle() - this.upperArm2Body.GetAngle();
            _loc2_.lowerAngle = -160 / (180 / Math.PI) - _loc3_;
            _loc2_.upperAngle = 0 / (180 / Math.PI) - _loc3_;
            _loc2_.Initialize(this.upperArm2Body,this.lowerArm2Body,_loc4_);
            this.elbowJoint2 = _loc1_.CreateJoint(_loc2_) as b2RevoluteJoint;
            _loc5_ = this.shapeGuide["upperLegAnchor"];
            _loc4_.Set(this._startX + _loc5_.x / this.character_scale,this._startY + _loc5_.y / this.character_scale);
            _loc3_ = this.upperLeg1Body.GetAngle() - this.pelvisBody.GetAngle();
            _loc2_.lowerAngle = -150 / (180 / Math.PI) - _loc3_;
            _loc2_.upperAngle = 10 / (180 / Math.PI) - _loc3_;
            _loc2_.Initialize(this.pelvisBody,this.upperLeg1Body,_loc4_);
            this.hipJoint1 = _loc1_.CreateJoint(_loc2_) as b2RevoluteJoint;
            _loc3_ = this.upperLeg2Body.GetAngle() - this.pelvisBody.GetAngle();
            _loc2_.lowerAngle = -150 / (180 / Math.PI) - _loc3_;
            _loc2_.upperAngle = 10 / (180 / Math.PI) - _loc3_;
            _loc2_.Initialize(this.pelvisBody,this.upperLeg2Body,_loc4_);
            this.hipJoint2 = _loc1_.CreateJoint(_loc2_) as b2RevoluteJoint;
            _loc5_ = this.shapeGuide["lowerLeg1Anchor"];
            _loc4_.Set(this._startX + _loc5_.x / this.character_scale,this._startY + _loc5_.y / this.character_scale);
            _loc3_ = this.lowerLeg1Body.GetAngle() - this.upperLeg1Body.GetAngle();
            _loc2_.lowerAngle = 0 / (180 / Math.PI) - _loc3_;
            _loc2_.upperAngle = 150 / oneEightyOverPI - _loc3_;
            _loc2_.Initialize(this.upperLeg1Body,this.lowerLeg1Body,_loc4_);
            this.kneeJoint1 = _loc1_.CreateJoint(_loc2_) as b2RevoluteJoint;
            _loc5_ = this.shapeGuide["lowerLeg2Anchor"];
            _loc4_.Set(this._startX + _loc5_.x / this.character_scale,this._startY + _loc5_.y / this.character_scale);
            _loc3_ = this.lowerLeg2Body.GetAngle() - this.upperLeg2Body.GetAngle();
            _loc2_.lowerAngle = 0 / oneEightyOverPI - _loc3_;
            _loc2_.upperAngle = 150 / oneEightyOverPI - _loc3_;
            _loc2_.Initialize(this.upperLeg2Body,this.lowerLeg2Body,_loc4_);
            this.kneeJoint2 = _loc1_.CreateJoint(_loc2_) as b2RevoluteJoint;
        }
        
        internal function resetJointLimits() : void
        {
            var _loc1_:Number = NaN;
            var _loc2_:Number = NaN;
            var _loc3_:Number = NaN;
            var _loc4_:Number = oneEightyOverPI;
            _loc1_ = this.head1Body.GetAngle() - this.chestBody.GetAngle() - this.neckJoint.GetJointAngle();
            _loc2_ = -20 / _loc4_ - _loc1_;
            _loc3_ = 20 / _loc4_ - _loc1_;
            this.neckJoint.SetLimits(_loc2_,_loc3_);
            _loc1_ = this.pelvisBody.GetAngle() - this.chestBody.GetAngle() - this.waistJoint.GetJointAngle();
            _loc2_ = -5 / _loc4_ - _loc1_;
            _loc3_ = 5 / _loc4_ - _loc1_;
            this.waistJoint.SetLimits(_loc2_,_loc3_);
            _loc1_ = this.shoulderJoint1.m_body2.GetAngle() - this.shoulderJoint1.m_body1.GetAngle() - this.shoulderJoint1.GetJointAngle();
            _loc2_ = -180 / _loc4_ - _loc1_;
            _loc3_ = 60 / _loc4_ - _loc1_;
            this.shoulderJoint1.SetLimits(_loc2_,_loc3_);
            _loc1_ = this.shoulderJoint2.m_body2.GetAngle() - this.shoulderJoint2.m_body1.GetAngle() - this.shoulderJoint2.GetJointAngle();
            _loc2_ = -180 / _loc4_ - _loc1_;
            _loc3_ = 60 / _loc4_ - _loc1_;
            this.shoulderJoint2.SetLimits(_loc2_,_loc3_);
            _loc1_ = this.lowerArm1Body.GetAngle() - this.upperArm1Body.GetAngle() - this.elbowJoint1.GetJointAngle();
            _loc2_ = -160 / _loc4_ - _loc1_;
            _loc3_ = 0 / _loc4_ - _loc1_;
            this.elbowJoint1.SetLimits(_loc2_,_loc3_);
            _loc1_ = this.lowerArm2Body.GetAngle() - this.upperArm2Body.GetAngle() - this.elbowJoint2.GetJointAngle();
            _loc2_ = -160 / _loc4_ - _loc1_;
            _loc3_ = 0 / _loc4_ - _loc1_;
            this.elbowJoint2.SetLimits(_loc2_,_loc3_);
            _loc1_ = this.hipJoint1.m_body2.GetAngle() - this.hipJoint1.m_body1.GetAngle() - this.hipJoint1.GetJointAngle();
            _loc2_ = -150 / _loc4_ - _loc1_;
            _loc3_ = 10 / _loc4_ - _loc1_;
            this.hipJoint1.SetLimits(_loc2_,_loc3_);
            _loc1_ = this.hipJoint2.m_body2.GetAngle() - this.hipJoint2.m_body1.GetAngle() - this.hipJoint2.GetJointAngle();
            _loc2_ = -150 / _loc4_ - _loc1_;
            _loc3_ = 10 / _loc4_ - _loc1_;
            this.hipJoint2.SetLimits(_loc2_,_loc3_);
            _loc1_ = this.lowerLeg1Body.GetAngle() - this.upperLeg1Body.GetAngle() - this.kneeJoint1.GetJointAngle();
            _loc2_ = 0 / _loc4_ - _loc1_;
            _loc3_ = 150 / _loc4_ - _loc1_;
            this.kneeJoint1.SetLimits(_loc2_,_loc3_);
            _loc1_ = this.lowerLeg2Body.GetAngle() - this.upperLeg2Body.GetAngle() - this.kneeJoint2.GetJointAngle();
            _loc2_ = 0 / _loc4_ - _loc1_;
            _loc3_ = 150 / _loc4_ - _loc1_;
            this.kneeJoint2.SetLimits(_loc2_,_loc3_);
        }
        
        public function contactResultHandler(param1:ContactEvent) : void
        {
            var _loc2_:b2Shape = param1.shape;
            var _loc3_:Number = param1.impulse;
            if(_loc3_ > this.contactImpulseDict[_loc2_])
            {
                if(this.contactResultBuffer[_loc2_])
                {
                    if(_loc3_ > this.contactResultBuffer[_loc2_].impulse)
                    {
                        this.contactResultBuffer[_loc2_] = param1;
                    }
                }
                else
                {
                    this.contactResultBuffer[_loc2_] = param1;
                }
            }
        }
        
        public function contactAddHandler(param1:b2ContactPoint) : void
        {
            var _loc2_:b2Shape = param1.shape1;
            var _loc3_:b2Body = _loc2_.m_body;
            var _loc4_:b2Shape = param1.shape2;
            var _loc5_:b2Body = _loc4_.m_body;
            var _loc6_:Number = _loc5_.m_mass;
            if(Boolean(this.contactAddBuffer[_loc2_]) || _loc4_.m_isSensor)
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
                this.contactAddBuffer[_loc2_] = _loc7_;
            }
        }
        
        public function handleContactBuffer() : void
        {
            this.handleContactResults();
            this.handleContactAdds();
        }
        
        protected function handleContactResults() : void
        {
            var _loc1_:ContactEvent = null;
            if(this.contactResultBuffer[this.head1Shape])
            {
                _loc1_ = this.contactResultBuffer[this.head1Shape];
                this.headSmash1(_loc1_.impulse);
                delete this.contactResultBuffer[this.head1Shape];
                delete this.contactAddBuffer[this.head1Shape];
            }
            if(this.contactResultBuffer[this.chestShape])
            {
                _loc1_ = this.contactResultBuffer[this.chestShape];
                this.chestSmash(_loc1_.impulse);
                delete this.contactResultBuffer[this.chestShape];
                delete this.contactAddBuffer[this.chestShape];
            }
            if(this.contactResultBuffer[this.pelvisShape])
            {
                _loc1_ = this.contactResultBuffer[this.pelvisShape];
                this.pelvisSmash(_loc1_.impulse);
                delete this.contactResultBuffer[this.pelvisShape];
                delete this.contactAddBuffer[this.pelvisShape];
            }
            if(this.contactResultBuffer[this.lowerLeg1Shape])
            {
                _loc1_ = this.contactResultBuffer[this.lowerLeg1Shape];
                this.footSmash1(_loc1_.impulse);
                delete this.contactResultBuffer[this.lowerLeg1Shape];
                delete this.contactAddBuffer[this.lowerLeg1Shape];
            }
            if(this.contactResultBuffer[this.lowerLeg2Shape])
            {
                _loc1_ = this.contactResultBuffer[this.lowerLeg2Shape];
                this.footSmash2(_loc1_.impulse);
                delete this.contactResultBuffer[this.lowerLeg2Shape];
                delete this.contactAddBuffer[this.lowerLeg2Shape];
            }
            if(this.contactResultBuffer[this.lowerArm1Shape])
            {
                _loc1_ = this.contactResultBuffer[this.lowerArm1Shape];
                this.grabAction(this.lowerArm1Body,_loc1_.otherShape,_loc1_.otherShape.GetBody());
                delete this.contactResultBuffer[this.lowerArm1Shape];
            }
            if(this.contactResultBuffer[this.lowerArm2Shape])
            {
                _loc1_ = this.contactResultBuffer[this.lowerArm2Shape];
                this.grabAction(this.lowerArm2Body,_loc1_.otherShape,_loc1_.otherShape.GetBody());
                delete this.contactResultBuffer[this.lowerArm2Shape];
            }
        }
        
        protected function handleContactAdds() : void
        {
            var _loc1_:* = undefined;
            var _loc2_:b2Shape = null;
            var _loc3_:String = null;
            for(_loc1_ in this.contactAddBuffer)
            {
                _loc2_ = _loc1_ as b2Shape;
                _loc3_ = this.contactAddSounds[_loc2_];
                if(_loc2_.m_body)
                {
                    SoundController.instance.playAreaSoundInstance(_loc3_,_loc2_.m_body);
                }
                delete this.contactAddBuffer[_loc1_];
            }
        }
        
        public function checkJoints() : void
        {
            var _loc1_:Number = 10;
            this.checkRevJoint(this.waistJoint,this.torsoBreakLimit,this.torsoBreak);
            this.checkRevJoint(this.neckJoint,this.neckBreakLimit,this.neckBreak);
            this.checkRevJoint(this.shoulderJoint1,this.shoulderBreakLimit,this.shoulderBreak1);
            this.checkRevJoint(this.shoulderJoint2,this.shoulderBreakLimit,this.shoulderBreak2);
            this.checkRevJoint(this.elbowJoint1,this.elbowBreakLimit,this.elbowBreak1);
            this.checkRevJoint(this.elbowJoint2,this.elbowBreakLimit,this.elbowBreak2);
            this.checkRevJoint(this.hipJoint1,this.hipBreakLimit,this.hipBreak1);
            this.checkRevJoint(this.hipJoint2,this.hipBreakLimit,this.hipBreak2);
            this.checkRevJoint(this.kneeJoint1,this.kneeBreakLimit,this.kneeBreak1);
            this.checkRevJoint(this.kneeJoint2,this.kneeBreakLimit,this.kneeBreak2);
            var _loc2_:int = 0;
            while(_loc2_ < this.composites.length)
            {
                this.composites[_loc2_].checkJoints();
                _loc2_++;
            }
        }
        
        internal function checkRevJoint(param1:b2Joint, param2:Number, param3:*) : void
        {
            var _loc4_:b2Vec2 = null;
            var _loc5_:Number = NaN;
            var _loc6_:* = undefined;
            var _loc7_:* = undefined;
            var _loc8_:Number = NaN;
            var _loc9_:Number = NaN;
            var _loc10_:Number = NaN;
            if(Boolean(param1) && !param1.broken)
            {
                _loc4_ = param1.GetReactionForce();
                _loc5_ = _loc4_.Length();
                if(_loc5_ > param2)
                {
                    param3(_loc5_);
                    return;
                }
                _loc6_ = param1.GetAnchor1();
                _loc7_ = param1.GetAnchor2();
                _loc8_ = _loc7_.x - _loc6_.x;
                _loc9_ = _loc7_.y - _loc6_.y;
                _loc10_ = Math.sqrt(_loc8_ * _loc8_ + _loc9_ * _loc9_);
                if(_loc10_ > 0.5)
                {
                    param3(1000);
                }
            }
        }
        
        protected function checkDistJoint(param1:b2DistanceJoint, param2:Number, param3:*) : void
        {
            var _loc4_:Number = NaN;
            if(Boolean(param1) && !param1.broken)
            {
                _loc4_ = Math.abs(param1.m_impulse);
                if(_loc4_ > param2)
                {
                    param3(_loc4_);
                }
            }
        }
        
        internal function headSmash1(param1:Number) : void
        {
            var _loc9_:MovieClip = null;
            var _loc10_:b2BodyDef = null;
            var _loc11_:b2Body = null;
            trace(this.tag + " head impulse " + param1 + " -> " + this._session.iteration);
            delete this.contactImpulseDict[this.head1Shape];
            this._session.contactListener.deleteListener(ContactListener.RESULT,this.head1Shape);
            this._session.contactListener.deleteListener(ContactListener.ADD,this.head1Shape);
            this.dead = true;
            if(!this.neckJoint.broken)
            {
                trace("not broken");
                this.neckJoint.broken = true;
                this.head1MC.visible = false;
                this.chestMC.neck.visible = true;
                if(this.chestShape.m_userData != GRIND_STATE)
                {
                    _loc9_ = this.shapeGuide["spineAnchor"];
                    this.neckBloodFlow = this._session.particleController.createBloodFlow(2.5,4,this.chestBody,new b2Vec2(_loc9_.x / this.character_scale,_loc9_.y / this.character_scale),270,500,this._session.containerSprite,this._session.containerSprite.getChildIndex(this.chestMC));
                }
            }
            else
            {
                this.headBloodFlow.stopSpewing();
                this.head1MC.visible = false;
                if(this.spinalChord)
                {
                    this.spinalChord.spineBreak2(10);
                }
            }
            var _loc2_:b2CircleDef = new b2CircleDef();
            _loc2_.density = 1;
            _loc2_.friction = 0.3;
            _loc2_.restitution = 0.1;
            _loc2_.radius = this.headChunkRadius / this.character_scale;
            _loc2_.filter = this.zeroFilter;
            var _loc3_:b2Vec2 = this.head1Body.GetPosition();
            var _loc4_:Number = this.head1Body.GetAngle();
            var _loc5_:Number = 4 / this.character_scale;
            var _loc6_:b2Vec2 = new b2Vec2();
            var _loc7_:int = 0;
            while(_loc7_ < this.headChunkMCs.length)
            {
                _loc10_ = new b2BodyDef();
                _loc10_.userData = this.headChunkMCs[_loc7_];
                _loc10_.userData.visible = true;
                _loc10_.position.Set(_loc3_.x + Math.sin(_loc4_) * _loc5_,_loc3_.y + Math.cos(_loc4_) * _loc5_);
                _loc11_ = this._session.m_world.CreateBody(_loc10_);
                _loc11_.CreateShape(_loc2_);
                _loc11_.SetMassFromShapes();
                _loc11_.SetLinearVelocity(this.head1Body.GetLinearVelocityFromWorldPoint(_loc10_.position));
                _loc11_.SetAngularVelocity(this.head1Body.GetAngularVelocity());
                this.paintVector.push(_loc11_);
                this.chunks.push(_loc11_);
                _loc4_ += Math.PI / 2;
                _loc7_++;
            }
            _loc2_.radius = this.brainRadius / this.character_scale;
            var _loc8_:b2BodyDef = new b2BodyDef();
            _loc8_.userData = this.brainMC;
            this.brainMC.visible = true;
            _loc8_.position.Set(_loc3_.x,_loc3_.y);
            _loc8_.angle = this.head1Body.GetAngle();
            this.brainBody = this._session.m_world.CreateBody(_loc8_);
            this.brainBody.CreateShape(_loc2_);
            this.brainBody.SetMassFromShapes();
            this.brainBody.SetLinearVelocity(this.head1Body.GetLinearVelocity());
            this.brainBody.SetAngularVelocity(this.head1Body.GetAngularVelocity());
            this.paintVector.push(this.brainBody);
            this._session.particleController.createBloodBurst(5,15,this.head1Body,200,new b2Vec2(),this._session.containerSprite,this._session.containerSprite.getChildIndex(this.brainMC));
            SoundController.instance.playAreaSoundInstance("HeadSmash",this.head1Body);
            this._session.m_world.DestroyBody(this.head1Body);
        }
        
        internal function chestSmash(param1:Number) : void
        {
            var _loc9_:b2BodyDef = null;
            var _loc10_:b2Body = null;
            trace(this.tag + " chest impulse " + param1 + " -> " + this._session.iteration);
            delete this.contactImpulseDict[this.chestShape];
            this._session.contactListener.deleteListener(ContactListener.RESULT,this.chestShape);
            this._session.contactListener.deleteListener(ContactListener.ADD,this.chestShape);
            this.dead = true;
            if(this.neckJoint.broken)
            {
                if(this.spinalChord)
                {
                    this.spinalChord.spineBreak1(10);
                }
            }
            else
            {
                this.neckBreak(this.spineLimit,false,false);
            }
            this.chestMC.neck.visible = false;
            if(this.shoulderJoint1)
            {
                if(!this.shoulderJoint1.broken)
                {
                    this.shoulderBreak1(this.shoulderSnapLimit + 1,false);
                }
                else if(this.upperArm3Body)
                {
                    this._session.m_world.DestroyJoint(this.shoulderJoint1);
                    this.upperArm3Body.GetShapeList().SetFilterData(this.zeroFilter);
                    this._session.m_world.Refilter(this.upperArm3Body.GetShapeList());
                    this.upperArm3MC.gotoAndStop(8);
                }
            }
            if(this.shoulderJoint2)
            {
                if(!this.shoulderJoint2.broken)
                {
                    this.shoulderBreak2(this.shoulderSnapLimit + 1,false);
                }
                else if(this.upperArm4Body)
                {
                    this._session.m_world.DestroyJoint(this.shoulderJoint2);
                    this.upperArm4Body.GetShapeList().SetFilterData(this.zeroFilter);
                    this._session.m_world.Refilter(this.upperArm4Body.GetShapeList());
                    this.upperArm4MC.gotoAndStop(8);
                }
            }
            if(this.waistJoint.broken)
            {
                if(this.intestineChain)
                {
                    this.intestineChain.intestineBreak2(10);
                }
            }
            else
            {
                this.torsoBreak(this.intestineLimit - 1,false);
                this.intestineChain.intestineBreak2(10);
            }
            var _loc2_:b2CircleDef = new b2CircleDef();
            _loc2_.density = 1;
            _loc2_.friction = 0.3;
            _loc2_.restitution = 0.1;
            _loc2_.radius = this.chestChunkRadius / this.character_scale;
            _loc2_.filter = this.zeroFilter;
            var _loc3_:b2Vec2 = this.chestBody.GetPosition();
            var _loc4_:Number = this.chestBody.GetAngle() + Math.PI / 4;
            var _loc5_:Number = 5 / this.character_scale;
            var _loc6_:b2Vec2 = new b2Vec2();
            var _loc7_:int = 0;
            while(_loc7_ < this.chestChunkMCs.length)
            {
                _loc9_ = new b2BodyDef();
                _loc9_.userData = this.chestChunkMCs[_loc7_];
                _loc9_.userData.visible = true;
                _loc9_.position.Set(_loc3_.x + Math.sin(_loc4_) * _loc5_,_loc3_.y + Math.cos(_loc4_) * _loc5_);
                _loc9_.angle = this.chestBody.GetAngle();
                _loc10_ = this._session.m_world.CreateBody(_loc9_);
                _loc10_.CreateShape(_loc2_);
                _loc10_.SetMassFromShapes();
                _loc10_.SetLinearVelocity(this.chestBody.GetLinearVelocityFromWorldPoint(_loc9_.position));
                _loc10_.SetAngularVelocity(this.chestBody.GetAngularVelocity());
                this.paintVector.push(_loc10_);
                this.chunks.push(_loc10_);
                _loc4_ += Math.PI / 2;
                _loc7_++;
            }
            this.heartMC.visible = true;
            _loc2_.radius = this.headChunkRadius / this.character_scale;
            var _loc8_:b2BodyDef = new b2BodyDef();
            _loc8_.userData = this.heartMC;
            this.heartMC.play();
            _loc8_.position.Set(_loc3_.x,_loc3_.y);
            _loc8_.angle = this.chestBody.GetAngle();
            this.heartBody = this._session.m_world.CreateBody(_loc8_);
            this.heartBody.CreateShape(_loc2_);
            this.heartBody.SetMassFromShapes();
            this.heartBody.SetLinearVelocity(this.chestBody.GetLinearVelocity());
            this.heartBody.SetAngularVelocity(this.chestBody.GetAngularVelocity());
            this.paintVector.push(this.heartBody);
            if(this.stomachBloodFlow)
            {
                this.stomachBloodFlow.stopSpewing();
            }
            if(this.neckBloodFlow)
            {
                this.neckBloodFlow.stopSpewing();
            }
            if(this.shoulder1BloodFlow)
            {
                this.shoulder1BloodFlow.stopSpewing();
            }
            if(this.shoulder2BloodFlow)
            {
                this.shoulder2BloodFlow.stopSpewing();
            }
            this._session.particleController.createBloodBurst(5,20,this.chestBody,300,new b2Vec2(),this._session.containerSprite,this._session.containerSprite.getChildIndex(this.heartMC));
            SoundController.instance.playAreaSoundInstance("ChestSmash",this.chestBody);
            this.chestBody.SetAngularVelocity(0);
            this.chestBody.SetLinearVelocity(new b2Vec2());
            this._session.m_world.DestroyBody(this.chestBody);
            this.chestMC.visible = false;
            this.cameraFocus = this.heartBody;
            if(this._session.camera.focus == this.chestBody)
            {
                this._session.camera.focus = this.cameraFocus;
            }
        }
        
        internal function pelvisSmash(param1:Number) : void
        {
            var _loc8_:b2BodyDef = null;
            var _loc9_:b2Body = null;
            trace(this.tag + " pelvis impulse " + param1 + " -> " + this._session.iteration);
            delete this.contactImpulseDict[this.pelvisShape];
            this._session.contactListener.deleteListener(ContactListener.RESULT,this.pelvisShape);
            this._session.contactListener.deleteListener(ContactListener.ADD,this.pelvisShape);
            if(this.hipJoint1)
            {
                if(!this.hipJoint1.broken)
                {
                    this.hipBreak1(this.hipSnapLimit + 1,false);
                }
                else if(this.upperLeg3Body)
                {
                    this._session.m_world.DestroyJoint(this.hipJoint1);
                    this.upperLeg3Body.GetShapeList().SetFilterData(this.zeroFilter);
                    this._session.m_world.Refilter(this.upperLeg3Body.GetShapeList());
                    this.upperLeg3MC.gotoAndStop(8);
                }
            }
            if(this.hipJoint2)
            {
                if(!this.hipJoint2.broken)
                {
                    this.hipBreak2(this.hipSnapLimit + 1,false);
                }
                else if(this.upperLeg4Body)
                {
                    this._session.m_world.DestroyJoint(this.hipJoint2);
                    this.upperLeg4Body.GetShapeList().SetFilterData(this.zeroFilter);
                    this._session.m_world.Refilter(this.upperLeg4Body.GetShapeList());
                    this.upperLeg4MC.gotoAndStop(8);
                }
            }
            if(this.waistJoint.broken)
            {
                if(this.intestineChain)
                {
                    this.intestineChain.intestineBreak1(10);
                }
            }
            else
            {
                this.torsoBreak(this.intestineLimit);
            }
            if(this.hip1BloodFlow)
            {
                this.hip1BloodFlow.stopSpewing();
            }
            if(this.hip2BloodFlow)
            {
                this.hip2BloodFlow.stopSpewing();
            }
            var _loc2_:b2CircleDef = new b2CircleDef();
            _loc2_.density = 1;
            _loc2_.friction = 0.3;
            _loc2_.restitution = 0.1;
            _loc2_.radius = this.pelvisChunkRadius / this.character_scale;
            _loc2_.filter = this.zeroFilter;
            var _loc3_:b2Vec2 = this.pelvisBody.GetPosition();
            var _loc4_:Number = this.pelvisBody.GetAngle();
            var _loc5_:Number = 3 / this.character_scale;
            var _loc6_:b2Vec2 = new b2Vec2();
            var _loc7_:int = 0;
            while(_loc7_ < this.pelvisChunkMCs.length)
            {
                _loc8_ = new b2BodyDef();
                _loc8_.userData = this.pelvisChunkMCs[_loc7_];
                _loc8_.userData.visible = true;
                _loc8_.position.Set(_loc3_.x + Math.sin(_loc4_) * _loc5_,_loc3_.y + Math.cos(_loc4_) * _loc5_);
                _loc8_.angle = this.pelvisBody.GetAngle();
                _loc9_ = this._session.m_world.CreateBody(_loc8_);
                _loc9_.CreateShape(_loc2_);
                _loc9_.SetMassFromShapes();
                _loc9_.SetLinearVelocity(this.pelvisBody.GetLinearVelocityFromWorldPoint(_loc8_.position));
                _loc9_.SetAngularVelocity(this.pelvisBody.GetAngularVelocity());
                this.paintVector.push(_loc9_);
                this.chunks.push(_loc9_);
                _loc4_ += Math.PI * 2 / 3;
                _loc7_++;
            }
            this._session.particleController.createBloodBurst(5,15,this.pelvisBody,200,new b2Vec2(),this._session.containerSprite,this._session.containerSprite.getChildIndex(this.pelvisMC));
            SoundController.instance.playAreaSoundInstance("PelvisSmash",this.pelvisBody);
            this._session.m_world.DestroyBody(this.pelvisBody);
            this.pelvisMC.visible = false;
            this.addVocals("Pelvis",5);
        }
        
        internal function footSmash1(param1:Number) : void
        {
            trace(this.tag + " foot1 impulse " + param1 + " -> " + this._session.iteration);
            delete this.contactImpulseDict[this.lowerLeg1Shape];
            this._session.contactListener.deleteListener(ContactListener.RESULT,this.lowerLeg1Shape);
            this._session.contactListener.deleteListener(ContactListener.ADD,this.lowerLeg1Shape);
            var _loc2_:b2PolygonDef = new b2PolygonDef();
            var _loc3_:b2BodyDef = new b2BodyDef();
            var _loc4_:* = this.shapeGuide["footShape"];
            var _loc5_:b2Vec2 = this.lowerLeg1Body.GetWorldPoint(new b2Vec2(_loc4_.x / this.character_scale,_loc4_.y / this.character_scale));
            _loc3_.position = _loc5_;
            _loc3_.angle = this.lowerLeg1Body.GetAngle();
            _loc3_.userData = this.foot1MC;
            this.foot1MC.visible = true;
            _loc2_.density = 1;
            _loc2_.friction = 0.3;
            _loc2_.restitution = 0.1;
            _loc2_.filter = this.zeroFilter;
            _loc2_.SetAsBox(_loc4_.scaleX * this.shapeRefScale / this.character_scale,_loc4_.scaleY * this.shapeRefScale / this.character_scale);
            this.foot1Body = this._session.m_world.CreateBody(_loc3_);
            this.foot1Body.CreateShape(_loc2_);
            this.foot1Body.SetMassFromShapes();
            this.foot1Body.SetLinearVelocity(this.lowerLeg1Body.GetLinearVelocity());
            this.foot1Body.SetAngularVelocity(this.lowerLeg1Body.GetAngularVelocity());
            this.paintVector.push(this.foot1Body);
            var _loc6_:Sprite = this.shapeGuide["lowerLeg1Shape"];
            this._session.particleController.createBloodBurst(5,15,this.lowerLeg1Body,50,new b2Vec2(0,_loc6_.scaleY * 5 / this.character_scale),this._session.containerSprite);
            if(this.lowerLeg1MC.currentFrame == 2)
            {
                this.lowerLeg1MC.gotoAndStop(4);
            }
            else
            {
                this.lowerLeg1MC.gotoAndStop(3);
            }
            var _loc7_:int = Math.ceil(Math.random() * 4);
            SoundController.instance.playAreaSoundInstance("BoneBreak" + _loc7_,this.lowerLeg1Body);
            this.addVocals("Foot1",0);
        }
        
        internal function footSmash2(param1:Number) : void
        {
            trace(this.tag + " foot2 impulse " + param1 + " -> " + this._session.iteration);
            delete this.contactImpulseDict[this.lowerLeg2Shape];
            this._session.contactListener.deleteListener(ContactListener.RESULT,this.lowerLeg2Shape);
            this._session.contactListener.deleteListener(ContactListener.ADD,this.lowerLeg2Shape);
            var _loc2_:b2PolygonDef = new b2PolygonDef();
            var _loc3_:b2BodyDef = new b2BodyDef();
            var _loc4_:* = this.shapeGuide["footShape"];
            var _loc5_:b2Vec2 = this.lowerLeg2Body.GetWorldPoint(new b2Vec2(_loc4_.x / this.character_scale,_loc4_.y / this.character_scale));
            _loc3_.position = _loc5_;
            _loc3_.angle = this.lowerLeg2Body.GetAngle();
            _loc3_.userData = this.foot2MC;
            this.foot2MC.visible = true;
            _loc2_.density = 1;
            _loc2_.friction = 0.3;
            _loc2_.restitution = 0.1;
            _loc2_.filter = this.zeroFilter;
            _loc2_.SetAsBox(_loc4_.scaleX * this.shapeRefScale / this.character_scale,_loc4_.scaleY * this.shapeRefScale / this.character_scale);
            this.foot2Body = this._session.m_world.CreateBody(_loc3_);
            this.foot2Body.CreateShape(_loc2_);
            this.foot2Body.SetMassFromShapes();
            this.foot2Body.SetLinearVelocity(this.lowerLeg2Body.GetLinearVelocity());
            this.foot2Body.SetAngularVelocity(this.lowerLeg2Body.GetAngularVelocity());
            this.paintVector.push(this.foot2Body);
            var _loc6_:Sprite = this.shapeGuide["lowerLeg2Shape"];
            this._session.particleController.createBloodBurst(5,15,this.lowerLeg2Body,50,new b2Vec2(0,_loc6_.scaleY * 5 / this.character_scale),this._session.containerSprite);
            if(this.lowerLeg2MC.currentFrame == 2)
            {
                this.lowerLeg2MC.gotoAndStop(4);
            }
            else
            {
                this.lowerLeg2MC.gotoAndStop(3);
            }
            var _loc7_:int = Math.ceil(Math.random() * 4);
            SoundController.instance.playAreaSoundInstance("BoneBreak" + _loc7_,this.lowerLeg2Body);
            this.addVocals("Foot2",0);
        }
        
        internal function torsoBreak(param1:Number, param2:Boolean = true, param3:Boolean = true) : void
        {
            var _loc10_:Number = NaN;
            var _loc11_:Number = NaN;
            var _loc12_:Number = NaN;
            var _loc13_:Number = NaN;
            trace(this.tag + " torso break " + param1 + " -> " + this._session.iteration);
            this.waistJoint.broken = true;
            this._dying = true;
            this._session.m_world.DestroyJoint(this.waistJoint);
            this.chestMC.gotoAndStop(2);
            this.pelvisMC.wound.visible = true;
            var _loc4_:b2Vec2 = this.chestBody.GetPosition();
            var _loc5_:b2Vec2 = this.pelvisBody.GetPosition();
            var _loc6_:Number = Math.atan2(_loc4_.y - _loc5_.y,_loc4_.x - _loc5_.x);
            var _loc7_:Number = Math.cos(_loc6_) * 10 / this.character_scale;
            var _loc8_:Number = Math.sin(_loc6_) * 10 / this.character_scale;
            if(this.pelvisShape.m_userData != GRIND_STATE)
            {
                this.pelvisBody.GetShapeList().SetFilterData(this.lowerBodyFilter);
                this._session.m_world.Refilter(this.pelvisBody.GetShapeList());
            }
            var _loc9_:b2Shape = this.upperLeg1Body.GetShapeList();
            if(_loc9_.m_filter.groupIndex != -3)
            {
                _loc9_.SetFilterData(this.lowerBodyFilter);
                this.session.m_world.Refilter(_loc9_);
            }
            _loc9_ = this.upperLeg2Body.GetShapeList();
            if(_loc9_.m_filter.groupIndex != -3)
            {
                _loc9_.SetFilterData(this.lowerBodyFilter);
                this.session.m_world.Refilter(_loc9_);
            }
            this.lowerLeg1Body.GetShapeList().SetFilterData(this.lowerBodyFilter);
            this.lowerLeg2Body.GetShapeList().SetFilterData(this.lowerBodyFilter);
            this._session.m_world.Refilter(this.lowerLeg1Body.GetShapeList());
            this._session.m_world.Refilter(this.lowerLeg2Body.GetShapeList());
            if(param1 < this.intestineLimit && this.chestShape.m_userData != GRIND_STATE && this.pelvisShape.m_userData != GRIND_STATE)
            {
                trace(this.intestineLimit);
                trace(this.torsoBreakLimit);
                _loc10_ = this.intestineLimit - this.torsoBreakLimit;
                _loc11_ = param1 - this.torsoBreakLimit;
                _loc12_ = _loc10_ / 8;
                _loc13_ = Math.ceil(_loc11_ / _loc12_) + 1;
                this.intestineChain = new IntestineChain(this,_loc13_,this.intestineLength);
                this.composites.push(this.intestineChain);
            }
            if(param2 && this.chestShape.m_userData != GRIND_STATE)
            {
                this.stomachBloodFlow = this._session.particleController.createBloodFlow(2,3,this.chestBody,new b2Vec2(0,0),90,500,this._session.containerSprite,this._session.containerSprite.getChildIndex(this.chestMC));
            }
            if(param3)
            {
                SoundController.instance.playAreaSoundInstance("LimbRip1",this.pelvisBody);
            }
            this.addVocals("Torso",5);
        }
        
        internal function neckBreak(param1:Number, param2:Boolean = true, param3:Boolean = true) : void
        {
            var _loc4_:MovieClip = null;
            var _loc5_:Number = NaN;
            var _loc6_:Number = NaN;
            var _loc7_:Number = NaN;
            var _loc8_:Number = NaN;
            trace(this.tag + " neck break " + param1 + " -> " + this._session.iteration);
            this.dead = true;
            this.neckJoint.broken = true;
            this._session.m_world.DestroyJoint(this.neckJoint);
            this.head1MC.gotoAndStop(2);
            this.chestMC.neck.visible = true;
            if(this.head1Shape.m_userData != GRIND_STATE)
            {
                this.head1Body.GetShapeList().SetFilterData(this.zeroFilter);
                this._session.m_world.Refilter(this.head1Body.GetShapeList());
                this.headBloodFlow = this._session.particleController.createBloodFlow(2.5,4,this.head1Body,new b2Vec2(0,0),90,150,this._session.containerSprite,this._session.containerSprite.getChildIndex(this.head1MC));
            }
            if(param2 && this.chestShape.m_userData != GRIND_STATE)
            {
                _loc4_ = this.shapeGuide["spineAnchor"];
                this.neckBloodFlow = this._session.particleController.createBloodFlow(2.5,4,this.chestBody,new b2Vec2(_loc4_.x / this.character_scale,_loc4_.y / this.character_scale),270,500,this._session.containerSprite,this._session.containerSprite.getChildIndex(this.chestMC));
            }
            if(param1 < this.spineLimit && this.chestShape.m_userData != GRIND_STATE && this.head1Shape.m_userData != GRIND_STATE)
            {
                _loc5_ = this.spineLimit - this.neckBreakLimit;
                _loc6_ = param1 - this.neckBreakLimit;
                _loc7_ = _loc5_ / 9;
                _loc8_ = Math.ceil(_loc6_ / _loc7_) + 1;
                this.spinalChord = new SpinalChord(this,_loc8_,this.ligamentLength);
                this.composites.push(this.spinalChord);
            }
            if(param3)
            {
                SoundController.instance.playAreaSoundInstance("NeckBreak",this.head1Body);
            }
        }
        
        internal function shoulderBreak1(param1:Number, param2:Boolean = true) : void
        {
            var _loc3_:b2Shape = null;
            var _loc4_:MovieClip = null;
            var _loc5_:b2BodyDef = null;
            var _loc6_:b2PolygonDef = null;
            var _loc7_:b2Vec2 = null;
            var _loc8_:* = undefined;
            var _loc9_:b2RevoluteJointDef = null;
            var _loc10_:Number = NaN;
            trace(this.tag + " shoulder1 break " + param1 + " -> " + this._session.iteration);
            this.shoulderJoint1.broken = true;
            if(param1 > this.shoulderSnapLimit)
            {
                this._session.m_world.DestroyJoint(this.shoulderJoint1);
                _loc3_ = this.upperArm1Body.GetShapeList();
                _loc3_.SetFilterData(this.zeroFilter);
                _loc3_.SetMaterial(2);
                _loc3_.SetUserData(this);
                this._session.m_world.Refilter(_loc3_);
                _loc3_ = this.lowerArm1Body.GetShapeList();
                _loc3_.SetFilterData(this.zeroFilter);
                this._session.m_world.Refilter(_loc3_);
                if(this.upperArm1MC.currentFrame == 5)
                {
                    this.upperArm1MC.gotoAndStop(7);
                }
                else
                {
                    this.upperArm1MC.gotoAndStop(4);
                }
                this.chestMC.wound.visible = true;
                if(param2 && this.chestShape.m_userData != GRIND_STATE)
                {
                    _loc4_ = this.chestMC.wound;
                    this.shoulder1BloodFlow = this._session.particleController.createBloodFlow(0,1,this.chestBody,new b2Vec2(_loc4_.x / this.character_scale,_loc4_.y / this.character_scale),270,500,this._session.containerSprite,this._session.containerSprite.getChildIndex(this.upperArm1MC));
                    SoundController.instance.playAreaSoundInstance("LimbRip2",this.upperArm1Body);
                }
                _loc4_ = this.shapeGuide["upperArm1Shape"];
                this.arm1BloodFlow = this._session.particleController.createBloodFlow(1,3,this.upperArm1Body,new b2Vec2(0,_loc4_.scaleY * -this.shapeRefScale / this.character_scale),270,200,this._session.containerSprite,this._session.containerSprite.getChildIndex(this.upperArm1MC));
                this.addVocals("Shoulder1",3);
            }
            else
            {
                _loc5_ = new b2BodyDef();
                _loc6_ = new b2PolygonDef();
                this.upperArm3MC.visible = true;
                _loc5_.userData = this.upperArm3MC;
                _loc7_ = this.shoulderJoint1.GetAnchor1();
                _loc5_.position.Set(_loc7_.x,_loc7_.y);
                _loc5_.angle = this.upperArm1Body.GetAngle();
                _loc8_ = this.shapeGuide["sevArm1Shape"];
                _loc6_.density = 1;
                _loc6_.friction = 0.3;
                _loc6_.restitution = 0.1;
                _loc6_.filter = this.defaultFilter;
                _loc6_.SetAsOrientedBox(_loc8_.scaleX * this.shapeRefScale / this.character_scale,_loc8_.scaleY * this.shapeRefScale / this.character_scale,new b2Vec2(0,_loc8_.y / this.character_scale),0);
                this.upperArm3Body = this._session.m_world.CreateBody(_loc5_);
                this.upperArm3Body.CreateShape(_loc6_);
                this.upperArm3Body.SetMassFromShapes();
                this.upperArm3Body.SetLinearVelocity(this.upperArm1Body.GetLinearVelocity());
                this.upperArm3Body.SetAngularVelocity(this.upperArm1Body.GetAngularVelocity());
                this.paintVector.push(this.upperArm3Body);
                this._session.m_world.DestroyJoint(this.shoulderJoint1);
                this.shoulderJoint1 = null;
                _loc9_ = new b2RevoluteJointDef();
                _loc9_.enableLimit = true;
                _loc9_.maxMotorTorque = 4;
                _loc10_ = this.upperArm3Body.GetAngle() - this.chestBody.GetAngle();
                _loc9_.lowerAngle = -180 / (180 / Math.PI) - _loc10_;
                _loc9_.upperAngle = 60 / (180 / Math.PI) - _loc10_;
                _loc9_.Initialize(this.chestBody,this.upperArm3Body,_loc7_);
                this.shoulderJoint1 = this._session.m_world.CreateJoint(_loc9_) as b2RevoluteJoint;
                this.shoulderJoint1.broken = true;
                _loc3_ = this.upperArm1Body.GetShapeList();
                _loc3_.SetFilterData(this.zeroFilter);
                _loc3_.SetMaterial(2);
                _loc3_.SetUserData(this);
                this._session.m_world.Refilter(_loc3_);
                _loc3_ = this.lowerArm1Body.GetShapeList();
                _loc3_.SetFilterData(this.zeroFilter);
                this._session.m_world.Refilter(_loc3_);
                if(this.upperArm1MC.currentFrame == 5)
                {
                    this.upperArm1MC.gotoAndStop(6);
                }
                else
                {
                    this.upperArm1MC.gotoAndStop(3);
                }
                this.upperArm3MC.gotoAndStop(2);
                if(param2)
                {
                    this.shoulder1BloodFlow = this._session.particleController.createBloodFlow(1,3,this.upperArm3Body,new b2Vec2(0,0),90,200,this._session.containerSprite,this._session.containerSprite.getChildIndex(this.upperArm1MC));
                    SoundController.instance.playAreaSoundInstance("LimbRip2",this.upperArm1Body);
                }
                this.addVocals("Shoulder1",3);
            }
            if(this.vehicleArm1Joint)
            {
                this._session.m_world.DestroyJoint(this.vehicleArm1Joint);
                this.vehicleArm1Joint = null;
                if(this.vehicleArm2Joint == null)
                {
                    this.userVehicleEject();
                }
            }
        }
        
        internal function shoulderBreak2(param1:Number, param2:Boolean = true) : void
        {
            var _loc3_:b2Shape = null;
            var _loc4_:MovieClip = null;
            var _loc5_:b2BodyDef = null;
            var _loc6_:b2PolygonDef = null;
            var _loc7_:b2Vec2 = null;
            var _loc8_:* = undefined;
            var _loc9_:b2RevoluteJointDef = null;
            var _loc10_:Number = NaN;
            trace(this.tag + " shoulder2 break " + param1 + " -> " + this._session.iteration);
            this.shoulderJoint2.broken = true;
            if(param1 > this.shoulderSnapLimit)
            {
                this._session.m_world.DestroyJoint(this.shoulderJoint2);
                _loc3_ = this.upperArm2Body.GetShapeList();
                _loc3_.SetFilterData(this.zeroFilter);
                _loc3_.SetMaterial(2);
                _loc3_.SetUserData(this);
                this._session.m_world.Refilter(_loc3_);
                _loc3_ = this.lowerArm2Body.GetShapeList();
                _loc3_.SetFilterData(this.zeroFilter);
                this._session.m_world.Refilter(_loc3_);
                if(this.upperArm2MC.currentFrame == 5)
                {
                    this.upperArm2MC.gotoAndStop(7);
                }
                else
                {
                    this.upperArm2MC.gotoAndStop(4);
                }
                if(param2 && this.chestShape.m_userData != GRIND_STATE)
                {
                    _loc4_ = this.chestMC.wound;
                    this.shoulder2BloodFlow = this._session.particleController.createBloodFlow(0,1,this.chestBody,new b2Vec2(_loc4_.x / this.character_scale,_loc4_.y / this.character_scale),270,500,this.session.containerSprite,this.session.containerSprite.getChildIndex(this.upperArm2MC));
                    SoundController.instance.playAreaSoundInstance("LimbRip2",this.upperArm2Body);
                }
                _loc4_ = this.shapeGuide["upperArm2Shape"];
                this.arm2BloodFlow = this._session.particleController.createBloodFlow(1,3,this.upperArm2Body,new b2Vec2(0,_loc4_.scaleY * -this.shapeRefScale / this.character_scale),270,200,this._session.containerSprite,this._session.containerSprite.getChildIndex(this.chestMC));
                this.addVocals("Shoulder2",3);
            }
            else
            {
                _loc5_ = new b2BodyDef();
                _loc6_ = new b2PolygonDef();
                this.upperArm4MC.visible = true;
                _loc5_.userData = this.upperArm4MC;
                _loc7_ = this.shoulderJoint2.GetAnchor1();
                _loc5_.position.Set(_loc7_.x,_loc7_.y);
                _loc5_.angle = this.upperArm2Body.GetAngle();
                _loc8_ = this.shapeGuide["sevArm1Shape"];
                _loc6_.density = 1;
                _loc6_.friction = 0.3;
                _loc6_.restitution = 0.1;
                _loc6_.filter = this.defaultFilter;
                _loc6_.SetAsOrientedBox(_loc8_.scaleX * this.shapeRefScale / this.character_scale,_loc8_.scaleY * this.shapeRefScale / this.character_scale,new b2Vec2(0,_loc8_.y / this.character_scale),0);
                this.upperArm4Body = this._session.m_world.CreateBody(_loc5_);
                this.upperArm4Body.CreateShape(_loc6_);
                this.upperArm4Body.SetMassFromShapes();
                this.upperArm4Body.SetLinearVelocity(this.upperArm2Body.GetLinearVelocity());
                this.upperArm4Body.SetAngularVelocity(this.upperArm2Body.GetAngularVelocity());
                this.paintVector.push(this.upperArm4Body);
                this._session.m_world.DestroyJoint(this.shoulderJoint2);
                this.shoulderJoint2 = null;
                _loc9_ = new b2RevoluteJointDef();
                _loc9_.enableLimit = true;
                _loc9_.maxMotorTorque = 4;
                _loc10_ = this.upperArm4Body.GetAngle() - this.chestBody.GetAngle();
                _loc9_.lowerAngle = -180 / (180 / Math.PI) - _loc10_;
                _loc9_.upperAngle = 60 / (180 / Math.PI) - _loc10_;
                _loc9_.Initialize(this.chestBody,this.upperArm4Body,_loc7_);
                this.shoulderJoint2 = this._session.m_world.CreateJoint(_loc9_) as b2RevoluteJoint;
                this.shoulderJoint2.broken = true;
                _loc3_ = this.upperArm2Body.GetShapeList();
                _loc3_.SetFilterData(this.zeroFilter);
                _loc3_.SetMaterial(2);
                _loc3_.SetUserData(this);
                this._session.m_world.Refilter(_loc3_);
                _loc3_ = this.lowerArm2Body.GetShapeList();
                _loc3_.SetFilterData(this.zeroFilter);
                this._session.m_world.Refilter(_loc3_);
                if(this.upperArm2MC.currentFrame == 5)
                {
                    this.upperArm2MC.gotoAndStop(6);
                }
                else
                {
                    this.upperArm2MC.gotoAndStop(3);
                }
                this.upperArm4MC.gotoAndStop(2);
                if(param2)
                {
                    this.shoulder2BloodFlow = this._session.particleController.createBloodFlow(1,3,this.upperArm4Body,new b2Vec2(0,0),90,200,this._session.containerSprite,this._session.containerSprite.getChildIndex(this.upperArm2MC));
                    SoundController.instance.playAreaSoundInstance("LimbRip2",this.upperArm2Body);
                }
                this.addVocals("Shoulder2",3);
            }
            if(this.vehicleArm2Joint)
            {
                this._session.m_world.DestroyJoint(this.vehicleArm2Joint);
                this.vehicleArm2Joint = null;
                if(this.vehicleArm1Joint == null)
                {
                    this.userVehicleEject();
                }
            }
        }
        
        internal function elbowBreak1(param1:Number) : void
        {
            trace(this.tag + " elbow1 break " + param1 + " -> " + this._session.iteration);
            this.elbowJoint1.broken = true;
            this._session.m_world.DestroyJoint(this.elbowJoint1);
            this.lowerArm1Body.GetShapeList().SetFilterData(this.zeroFilter);
            this._session.m_world.Refilter(this.lowerArm1Body.GetShapeList());
            this.lowerArm1MC.gotoAndStop(2);
            switch(this.upperArm1MC.currentFrame)
            {
                case 3:
                    this.upperArm1MC.gotoAndStop(6);
                    break;
                case 4:
                    this.upperArm1MC.gotoAndStop(7);
                    break;
                default:
                    this.upperArm1MC.gotoAndStop(5);
            }
            this.lowerArm1MC.gotoAndStop(2);
            var _loc2_:Sprite = this.shapeGuide["lowerArm1Shape"];
            this._session.particleController.createBloodBurst(5,15,this.lowerArm1Body,50,new b2Vec2(0,_loc2_.scaleY * -this.shapeRefScale / this.character_scale),this._session.containerSprite);
            if(param1 < this.elbowLigamentLimit)
            {
                this.elbowLigament1 = new Ligament(this.upperArm1Body,this.lowerArm1Body,this.ligamentLength,this.character_scale,this);
                this.composites.push(this.elbowLigament1);
            }
            var _loc3_:int = Math.ceil(Math.random() * 4);
            SoundController.instance.playAreaSoundInstance("BoneBreak" + _loc3_,this.lowerArm1Body);
            this.addVocals("Elbow1",1);
            if(this.vehicleArm1Joint)
            {
                this._session.m_world.DestroyJoint(this.vehicleArm1Joint);
                this.vehicleArm1Joint = null;
                if(this.vehicleArm2Joint == null)
                {
                    this.userVehicleEject();
                }
            }
        }
        
        internal function elbowBreak2(param1:Number) : void
        {
            trace(this.tag + " elbow2 break " + param1 + " -> " + this._session.iteration);
            this.elbowJoint2.broken = true;
            this._session.m_world.DestroyJoint(this.elbowJoint2);
            this.lowerArm2Body.GetShapeList().SetFilterData(this.zeroFilter);
            this._session.m_world.Refilter(this.lowerArm2Body.GetShapeList());
            this.lowerArm2MC.gotoAndStop(2);
            switch(this.upperArm2MC.currentFrame)
            {
                case 3:
                    this.upperArm2MC.gotoAndStop(6);
                    break;
                case 4:
                    this.upperArm2MC.gotoAndStop(7);
                    break;
                default:
                    this.upperArm2MC.gotoAndStop(5);
            }
            this.lowerArm2MC.gotoAndStop(2);
            var _loc2_:Sprite = this.shapeGuide["lowerArm2Shape"];
            this._session.particleController.createBloodBurst(5,15,this.lowerArm2Body,50,new b2Vec2(0,_loc2_.scaleY * -this.shapeRefScale / this.character_scale),this._session.containerSprite);
            if(param1 < this.elbowLigamentLimit)
            {
                this.elbowLigament2 = new Ligament(this.upperArm2Body,this.lowerArm2Body,this.ligamentLength,this.character_scale,this);
                this.composites.push(this.elbowLigament2);
            }
            var _loc3_:int = Math.ceil(Math.random() * 4);
            SoundController.instance.playAreaSoundInstance("BoneBreak" + _loc3_,this.lowerArm2Body);
            this.addVocals("Elbow2",1);
            if(this.vehicleArm2Joint)
            {
                this._session.m_world.DestroyJoint(this.vehicleArm2Joint);
                this.vehicleArm2Joint = null;
                if(this.vehicleArm1Joint == null)
                {
                    this.userVehicleEject();
                }
            }
        }
        
        internal function hipBreak1(param1:Number, param2:Boolean = true) : void
        {
            var _loc3_:b2Shape = null;
            var _loc4_:Sprite = null;
            var _loc5_:b2BodyDef = null;
            var _loc6_:b2PolygonDef = null;
            var _loc7_:b2Vec2 = null;
            var _loc8_:Sprite = null;
            var _loc9_:b2RevoluteJointDef = null;
            var _loc10_:Number = NaN;
            trace(this.tag + " hip1 break " + param1 + " -> " + this._session.iteration);
            this.hipJoint1.broken = true;
            if(param1 > this.hipSnapLimit)
            {
                this._session.m_world.DestroyJoint(this.hipJoint1);
                _loc3_ = this.upperLeg1Body.GetShapeList();
                _loc3_.SetFilterData(this.zeroFilter);
                _loc3_.SetMaterial(2);
                _loc3_.m_isSensor = false;
                _loc3_.SetUserData(this);
                this._session.m_world.Refilter(_loc3_);
                _loc3_ = this.lowerLeg1Body.GetShapeList();
                _loc3_.SetFilterData(this.zeroFilter);
                this._session.m_world.Refilter(_loc3_);
                if(this.upperLeg1MC.currentFrame == 5)
                {
                    this.upperLeg1MC.gotoAndStop(7);
                }
                else
                {
                    this.upperLeg1MC.gotoAndStop(4);
                }
                this.pelvisMC.gotoAndStop(2);
                if(param2 && this.pelvisShape.m_userData != GRIND_STATE)
                {
                    this.hip1BloodFlow = this._session.particleController.createBloodFlow(0,1,this.pelvisBody,new b2Vec2(0,0),90,500,this._session.containerSprite,this._session.containerSprite.getChildIndex(this.upperLeg1MC));
                    SoundController.instance.playAreaSoundInstance("LimbRip3",this.upperLeg1Body);
                }
                _loc4_ = this.shapeGuide["upperLeg1Shape"];
                this.thigh1BloodFlow = this._session.particleController.createBloodFlow(1,3,this.upperLeg1Body,new b2Vec2(0,_loc4_.scaleY * -this.shapeRefScale / this.character_scale),270,200,this._session.containerSprite,this._session.containerSprite.getChildIndex(this.upperLeg1MC));
                this.addVocals("Hip1",4);
            }
            else
            {
                _loc5_ = new b2BodyDef();
                _loc6_ = new b2PolygonDef();
                this.upperLeg3MC.visible = true;
                _loc5_.userData = this.upperLeg3MC;
                _loc7_ = this.hipJoint1.GetAnchor1();
                _loc5_.position.Set(_loc7_.x,_loc7_.y);
                _loc5_.angle = this.upperLeg1Body.GetAngle();
                _loc8_ = this.shapeGuide["sevLeg1Shape"];
                _loc6_.density = 1;
                _loc6_.friction = 0.3;
                _loc6_.restitution = 0.1;
                _loc6_.filter = this.defaultFilter;
                _loc6_.SetAsOrientedBox(_loc8_.scaleX * this.shapeRefScale / this.character_scale,_loc8_.scaleY * this.shapeRefScale / this.character_scale,new b2Vec2(0,_loc8_.y / this.character_scale),0);
                this.upperLeg3Body = this._session.m_world.CreateBody(_loc5_);
                this.upperLeg3Body.CreateShape(_loc6_);
                this.upperLeg3Body.SetMassFromShapes();
                this.upperLeg3Body.SetLinearVelocity(this.upperLeg1Body.GetLinearVelocity());
                this.upperLeg3Body.SetAngularVelocity(this.upperLeg1Body.GetAngularVelocity());
                this.paintVector.push(this.upperLeg3Body);
                this._session.m_world.DestroyJoint(this.hipJoint1);
                this.hipJoint1 = null;
                _loc9_ = new b2RevoluteJointDef();
                _loc9_.enableLimit = true;
                _loc9_.maxMotorTorque = 4;
                _loc10_ = this.upperLeg3Body.GetAngle() - this.pelvisBody.GetAngle();
                _loc9_.lowerAngle = -150 / (180 / Math.PI) - _loc10_;
                _loc9_.upperAngle = 10 / (180 / Math.PI) - _loc10_;
                _loc9_.Initialize(this.pelvisBody,this.upperLeg3Body,_loc7_);
                this.hipJoint1 = this._session.m_world.CreateJoint(_loc9_) as b2RevoluteJoint;
                this.hipJoint1.broken = true;
                _loc8_ = this.shapeGuide["sevLeg2Shape"];
                this.upperLeg1Body.DestroyShape(this.upperLeg1Body.GetShapeList());
                _loc6_.filter = this.zeroFilter;
                _loc6_.userData = 1;
                _loc6_.SetAsOrientedBox(_loc8_.scaleX * this.shapeRefScale / this.character_scale,_loc8_.scaleY * this.shapeRefScale / this.character_scale,new b2Vec2(0,_loc8_.y / this.character_scale),0);
                this.upperLeg1Body.CreateShape(_loc6_);
                this.upperLeg1Body.SetMassFromShapes();
                this.lowerLeg1Body.GetShapeList().SetFilterData(this.zeroFilter);
                this._session.m_world.Refilter(this.lowerLeg1Body.GetShapeList());
                if(this.upperLeg1MC.currentFrame == 5)
                {
                    this.upperLeg1MC.gotoAndStop(6);
                }
                else
                {
                    this.upperLeg1MC.gotoAndStop(3);
                }
                this.upperLeg3MC.gotoAndStop(2);
                if(param2)
                {
                    this.hip1BloodFlow = this._session.particleController.createBloodFlow(1,3,this.upperLeg3Body,new b2Vec2(0,0),90,200,this._session.containerSprite,this._session.containerSprite.getChildIndex(this.upperLeg3MC));
                    SoundController.instance.playAreaSoundInstance("LimbRip3",this.upperLeg1Body);
                }
                _loc4_ = this.shapeGuide["sevLeg2Shape"];
                this.thigh1BloodFlow = this._session.particleController.createBloodFlow(1,3,this.upperLeg1Body,new b2Vec2(0,0),270,200,this._session.containerSprite,this._session.containerSprite.getChildIndex(this.upperLeg1MC));
                this.addVocals("Hip1",4);
            }
        }
        
        internal function hipBreak2(param1:Number, param2:Boolean = true) : void
        {
            var _loc3_:b2Shape = null;
            var _loc4_:Sprite = null;
            var _loc5_:b2BodyDef = null;
            var _loc6_:b2PolygonDef = null;
            var _loc7_:b2Vec2 = null;
            var _loc8_:Sprite = null;
            var _loc9_:b2RevoluteJointDef = null;
            var _loc10_:Number = NaN;
            trace(this.tag + " hip2 break " + param1 + " -> " + this._session.iteration);
            this.hipJoint2.broken = true;
            if(param1 > this.hipSnapLimit)
            {
                this._session.m_world.DestroyJoint(this.hipJoint2);
                _loc3_ = this.upperLeg2Body.GetShapeList();
                _loc3_.SetFilterData(this.zeroFilter);
                _loc3_.SetMaterial(2);
                _loc3_.m_isSensor = false;
                _loc3_.SetUserData(this);
                this._session.m_world.Refilter(_loc3_);
                _loc3_ = this.lowerLeg2Body.GetShapeList();
                _loc3_ = this.lowerLeg2Body.GetShapeList();
                _loc3_.SetFilterData(this.zeroFilter);
                this._session.m_world.Refilter(_loc3_);
                if(this.upperLeg2MC.currentFrame == 5)
                {
                    this.upperLeg2MC.gotoAndStop(7);
                }
                else
                {
                    this.upperLeg2MC.gotoAndStop(4);
                }
                if(param2 && this.pelvisShape.m_userData != GRIND_STATE)
                {
                    this.hip2BloodFlow = this._session.particleController.createBloodFlow(0,1,this.pelvisBody,new b2Vec2(0,0),90,500,this._session.containerSprite,this._session.containerSprite.getChildIndex(this.upperLeg2MC));
                    SoundController.instance.playAreaSoundInstance("LimbRip4",this.upperLeg2Body);
                }
                _loc4_ = this.shapeGuide["upperLeg2Shape"];
                this.thigh2BloodFlow = this._session.particleController.createBloodFlow(1,3,this.upperLeg2Body,new b2Vec2(0,_loc4_.scaleY * -this.shapeRefScale / this.character_scale),270,200,this._session.containerSprite,this._session.containerSprite.getChildIndex(this.upperLeg2MC));
                this.addVocals("Hip2",4);
            }
            else
            {
                _loc5_ = new b2BodyDef();
                _loc6_ = new b2PolygonDef();
                this.upperLeg4MC.visible = true;
                _loc5_.userData = this.upperLeg4MC;
                _loc7_ = this.hipJoint2.GetAnchor1();
                _loc5_.position.Set(_loc7_.x,_loc7_.y);
                _loc5_.angle = this.upperLeg2Body.GetAngle();
                _loc8_ = this.shapeGuide["sevLeg1Shape"];
                _loc6_.density = 1;
                _loc6_.friction = 0.3;
                _loc6_.restitution = 0.1;
                _loc6_.filter = this.defaultFilter;
                _loc6_.SetAsOrientedBox(_loc8_.scaleX * this.shapeRefScale / this.character_scale,_loc8_.scaleY * this.shapeRefScale / this.character_scale,new b2Vec2(0,_loc8_.y / this.character_scale),0);
                this.upperLeg4Body = this._session.m_world.CreateBody(_loc5_);
                this.upperLeg4Body.CreateShape(_loc6_);
                this.upperLeg4Body.SetMassFromShapes();
                this.upperLeg4Body.SetLinearVelocity(this.upperLeg2Body.GetLinearVelocity());
                this.upperLeg4Body.SetAngularVelocity(this.upperLeg2Body.GetAngularVelocity());
                this.paintVector.push(this.upperLeg4Body);
                this._session.m_world.DestroyJoint(this.hipJoint2);
                this.hipJoint2 = null;
                _loc9_ = new b2RevoluteJointDef();
                _loc9_.enableLimit = true;
                _loc9_.maxMotorTorque = 4;
                _loc10_ = this.upperLeg4Body.GetAngle() - this.pelvisBody.GetAngle();
                _loc9_.lowerAngle = -150 / (180 / Math.PI) - _loc10_;
                _loc9_.upperAngle = 10 / (180 / Math.PI) - _loc10_;
                _loc9_.Initialize(this.pelvisBody,this.upperLeg4Body,_loc7_);
                this.hipJoint2 = this._session.m_world.CreateJoint(_loc9_) as b2RevoluteJoint;
                this.hipJoint2.broken = true;
                _loc8_ = this.shapeGuide["sevLeg2Shape"];
                this.upperLeg2Body.DestroyShape(this.upperLeg2Body.GetShapeList());
                _loc6_.filter = this.zeroFilter;
                _loc6_.userData = 1;
                _loc6_.SetAsOrientedBox(_loc8_.scaleX * this.shapeRefScale / this.character_scale,_loc8_.scaleY * this.shapeRefScale / this.character_scale,new b2Vec2(0,_loc8_.y / this.character_scale),0);
                this.upperLeg2Body.CreateShape(_loc6_);
                this.upperLeg2Body.SetMassFromShapes();
                this.lowerLeg2Body.GetShapeList().SetFilterData(this.zeroFilter);
                this._session.m_world.Refilter(this.lowerLeg2Body.GetShapeList());
                if(this.upperLeg2MC.currentFrame == 5)
                {
                    this.upperLeg2MC.gotoAndStop(6);
                }
                else
                {
                    this.upperLeg2MC.gotoAndStop(3);
                }
                this.upperLeg4MC.gotoAndStop(2);
                if(param2)
                {
                    this.hip2BloodFlow = this._session.particleController.createBloodFlow(1,3,this.upperLeg4Body,new b2Vec2(0,0),90,200,this._session.containerSprite,this._session.containerSprite.getChildIndex(this.upperLeg4MC));
                    SoundController.instance.playAreaSoundInstance("LimbRip4",this.upperLeg2Body);
                }
                _loc4_ = this.shapeGuide["sevLeg2Shape"];
                this.thigh2BloodFlow = this._session.particleController.createBloodFlow(1,3,this.upperLeg2Body,new b2Vec2(0,0),270,200,this._session.containerSprite,this._session.containerSprite.getChildIndex(this.upperLeg2MC));
                this.addVocals("Hip2",4);
            }
        }
        
        internal function kneeBreak1(param1:Number) : void
        {
            trace(this.tag + " knee1 break " + param1 + " -> " + this._session.iteration);
            this.kneeJoint1.broken = true;
            this._session.m_world.DestroyJoint(this.kneeJoint1);
            var _loc2_:b2Shape = this.lowerLeg1Body.GetShapeList();
            _loc2_.SetFilterData(this.zeroFilter);
            _loc2_.m_isSensor = false;
            this._session.m_world.Refilter(_loc2_);
            if(this.lowerLeg1MC.currentFrame == 3)
            {
                this.lowerLeg1MC.gotoAndStop(4);
            }
            else
            {
                this.lowerLeg1MC.gotoAndStop(2);
            }
            switch(this.upperLeg1MC.currentFrame)
            {
                case 3:
                    this.upperLeg1MC.gotoAndStop(6);
                    break;
                case 4:
                    this.upperLeg1MC.gotoAndStop(7);
                    break;
                default:
                    this.upperLeg1MC.gotoAndStop(5);
            }
            var _loc3_:Sprite = this.shapeGuide["lowerLeg1Shape"];
            this._session.particleController.createBloodBurst(5,15,this.lowerLeg1Body,50,new b2Vec2(0,_loc3_.scaleY * -this.shapeRefScale / this.character_scale),this._session.containerSprite);
            if(param1 < this.kneeLigamentLimit)
            {
                this.kneeLigament1 = new Ligament(this.upperLeg1Body,this.lowerLeg1Body,this.ligamentLength,this.character_scale,this);
                this.composites.push(this.kneeLigament1);
            }
            var _loc4_:int = Math.ceil(Math.random() * 4);
            SoundController.instance.playAreaSoundInstance("BoneBreak" + _loc4_,this.upperLeg1Body);
            this.addVocals("Knee1",2);
        }
        
        internal function kneeBreak2(param1:Number) : void
        {
            trace(this.tag + " knee2 break " + param1 + " -> " + this._session.iteration);
            this.kneeJoint2.broken = true;
            this._session.m_world.DestroyJoint(this.kneeJoint2);
            var _loc2_:b2Shape = this.lowerLeg2Body.GetShapeList();
            _loc2_.SetFilterData(this.zeroFilter);
            _loc2_.m_isSensor = false;
            this._session.m_world.Refilter(_loc2_);
            if(this.lowerLeg2MC.currentFrame == 3)
            {
                this.lowerLeg2MC.gotoAndStop(4);
            }
            else
            {
                this.lowerLeg2MC.gotoAndStop(2);
            }
            switch(this.upperLeg2MC.currentFrame)
            {
                case 3:
                    this.upperLeg2MC.gotoAndStop(6);
                    break;
                case 4:
                    this.upperLeg2MC.gotoAndStop(7);
                    break;
                default:
                    this.upperLeg2MC.gotoAndStop(5);
            }
            var _loc3_:Sprite = this.shapeGuide["lowerLeg2Shape"];
            this._session.particleController.createBloodBurst(5,15,this.lowerLeg2Body,50,new b2Vec2(0,_loc3_.scaleY * -this.shapeRefScale / this.character_scale),this._session.containerSprite);
            if(param1 < this.kneeLigamentLimit)
            {
                this.kneeLigament2 = new Ligament(this.upperLeg2Body,this.lowerLeg2Body,this.ligamentLength,this.character_scale,this);
                this.composites.push(this.kneeLigament2);
            }
            var _loc4_:int = Math.ceil(Math.random() * 4);
            SoundController.instance.playAreaSoundInstance("BoneBreak" + _loc4_,this.upperLeg2Body);
            this.addVocals("Knee2",2);
        }
        
        internal function supermanPose() : void
        {
            this.setJoint(this.neckJoint,0.5,2);
            this.setJoint(this.hipJoint1,2.6,2);
            this.setJoint(this.hipJoint2,2.6,2);
            this.setJoint(this.kneeJoint1,0,10);
            this.setJoint(this.kneeJoint2,0,10);
            this.setJoint(this.shoulderJoint1,0,20);
            this.setJoint(this.shoulderJoint2,0,20);
            this.setJoint(this.elbowJoint1,2.5,15);
            this.setJoint(this.elbowJoint2,2.5,15);
        }
        
        internal function tuckPose() : void
        {
            this.setJoint(this.neckJoint,0.69,2);
            this.setJoint(this.hipJoint1,0,2);
            this.setJoint(this.hipJoint2,0,2);
            this.setJoint(this.kneeJoint1,2,10);
            this.setJoint(this.kneeJoint2,2,10);
            this.setJoint(this.shoulderJoint1,3,20);
            this.setJoint(this.shoulderJoint2,3,20);
            this.setJoint(this.elbowJoint1,1.5,15);
            this.setJoint(this.elbowJoint2,1.5,15);
        }
        
        internal function pushupPose() : void
        {
            this.setJoint(this.neckJoint,0.5,2);
            this.setJoint(this.hipJoint1,2.6,2);
            this.setJoint(this.hipJoint2,2.6,2);
            this.setJoint(this.kneeJoint1,0,10);
            this.setJoint(this.kneeJoint2,0,10);
            this.setJoint(this.shoulderJoint1,1.7,20);
            this.setJoint(this.shoulderJoint2,1.7,20);
            this.setJoint(this.elbowJoint1,2.5,15);
            this.setJoint(this.elbowJoint2,2.5,15);
        }
        
        internal function archPose() : void
        {
            this.setJoint(this.neckJoint,0.5,2);
            this.setJoint(this.hipJoint1,3,2);
            this.setJoint(this.hipJoint2,3,2);
            this.setJoint(this.kneeJoint1,2,10);
            this.setJoint(this.kneeJoint2,2,10);
            this.setJoint(this.shoulderJoint1,0,20);
            this.setJoint(this.shoulderJoint2,0,20);
            this.setJoint(this.elbowJoint1,1,15);
            this.setJoint(this.elbowJoint2,1,15);
        }
        
        internal function leftWalkPose() : void
        {
            this.setJoint(this.neckJoint,0.5,2);
            this.setJoint(this.hipJoint1,2.8,5);
            this.setJoint(this.hipJoint2,1.75,2.5);
            this.setJoint(this.kneeJoint1,0.5,10);
            this.setJoint(this.kneeJoint2,0.2,10);
            this.setJoint(this.shoulderJoint1,2.5,10);
            this.setJoint(this.shoulderJoint2,4,10);
            this.setJoint(this.elbowJoint1,2,15);
            this.setJoint(this.elbowJoint2,2.5,15);
        }
        
        internal function rightWalkPose() : void
        {
            this.setJoint(this.neckJoint,0.5,2);
            this.setJoint(this.hipJoint1,1.75,2.5);
            this.setJoint(this.hipJoint2,2.8,5);
            this.setJoint(this.kneeJoint1,0.2,5);
            this.setJoint(this.kneeJoint2,0.5,5);
            this.setJoint(this.shoulderJoint1,4,10);
            this.setJoint(this.shoulderJoint2,2.5,10);
            this.setJoint(this.elbowJoint1,2.5,15);
            this.setJoint(this.elbowJoint2,2,15);
        }
        
        internal function armsForwardPose() : void
        {
            this.setJoint(this.neckJoint,0.5,2);
            this.setJoint(this.shoulderJoint1,1.5,20);
            this.setJoint(this.shoulderJoint2,1.5,20);
            this.setJoint(this.elbowJoint1,2,15);
            this.setJoint(this.elbowJoint2,2,15);
        }
        
        internal function armsOverheadPose() : void
        {
            this.setJoint(this.neckJoint,0.5,2);
            this.setJoint(this.shoulderJoint1,0,20);
            this.setJoint(this.shoulderJoint2,0,20);
            this.setJoint(this.elbowJoint1,2.5,15);
            this.setJoint(this.elbowJoint2,2.5,15);
        }
        
        internal function holdPositionPose() : void
        {
            this.holdJoint(this.neckJoint);
            this.holdJoint(this.hipJoint1);
            this.holdJoint(this.hipJoint2);
            this.holdJoint(this.kneeJoint1);
            this.holdJoint(this.kneeJoint2);
            this.holdJoint(this.shoulderJoint1);
            this.holdJoint(this.shoulderJoint2);
            this.holdJoint(this.elbowJoint1);
            this.holdJoint(this.elbowJoint2);
        }
        
        internal function cancelPose() : void
        {
            if(Boolean(this.neckJoint) && this.neckJoint.IsMotorEnabled())
            {
                this.neckJoint.EnableMotor(false);
            }
            if(Boolean(this.shoulderJoint1) && this.shoulderJoint1.IsMotorEnabled())
            {
                this.shoulderJoint1.EnableMotor(false);
            }
            if(Boolean(this.shoulderJoint2) && this.shoulderJoint2.IsMotorEnabled())
            {
                this.shoulderJoint2.EnableMotor(false);
            }
            if(Boolean(this.elbowJoint1) && this.elbowJoint1.IsMotorEnabled())
            {
                this.elbowJoint1.EnableMotor(false);
            }
            if(Boolean(this.elbowJoint2) && this.elbowJoint2.IsMotorEnabled())
            {
                this.elbowJoint2.EnableMotor(false);
            }
            if(Boolean(this.hipJoint1) && this.hipJoint1.IsMotorEnabled())
            {
                this.hipJoint1.EnableMotor(false);
            }
            if(Boolean(this.hipJoint2) && this.hipJoint2.IsMotorEnabled())
            {
                this.hipJoint2.EnableMotor(false);
            }
            if(Boolean(this.kneeJoint1) && this.kneeJoint1.IsMotorEnabled())
            {
                this.kneeJoint1.EnableMotor(false);
            }
            if(Boolean(this.kneeJoint2) && this.kneeJoint2.IsMotorEnabled())
            {
                this.kneeJoint2.EnableMotor(false);
            }
        }
        
        internal function holdJoint(param1:b2RevoluteJoint) : void
        {
            if(!param1.IsMotorEnabled())
            {
                param1.EnableMotor(true);
            }
            param1.SetMotorSpeed(0);
        }
        
        internal function setJoint(param1:b2RevoluteJoint, param2:Number, param3:Number, param4:Number = 10) : void
        {
            if(!param1.IsMotorEnabled())
            {
                param1.EnableMotor(true);
            }
            var _loc5_:int = -1;
            var _loc6_:Number = param1.m_lowerAngle + param2;
            var _loc7_:Number = param1.GetJointAngle() - _loc6_;
            if(_loc7_ < 0)
            {
                _loc5_ = 1;
                _loc7_ = Math.abs(_loc7_);
            }
            var _loc8_:Number = Math.min(param3 * Math.pow(_loc7_,2),param4) * _loc5_;
            param1.SetMotorSpeed(_loc8_);
        }
        
        public function remoteEject() : void
        {
            this.eject();
        }
        
        internal function eject() : void
        {
        }
        
        public function userVehicleEject() : void
        {
            if(!this.userVehicle)
            {
                return;
            }
            this.userVehicle.removeCharacter(this);
            this.userVehicle = null;
            if(this.vehicleArm1Joint)
            {
                this._session.m_world.DestroyJoint(this.vehicleArm1Joint);
                this.vehicleArm1Joint = null;
            }
            if(this.vehicleArm2Joint)
            {
                this._session.m_world.DestroyJoint(this.vehicleArm2Joint);
                this.vehicleArm2Joint = null;
            }
            this.releaseGrip();
            this.currentPose = 0;
        }
        
        public function get dead() : Boolean
        {
            return this._dead;
        }
        
        public function set dead(param1:Boolean) : void
        {
            this._dead = param1;
            if(this._dead)
            {
                this.userVehicleEject();
                this.currentPose = 0;
                this.releaseGrip();
                if(this.voiceSound)
                {
                    this.voiceSound.stopSound();
                    this.voiceSound = null;
                }
            }
        }
        
        public function get currentPose() : int
        {
            return this._currentPose;
        }
        
        public function set currentPose(param1:int) : void
        {
            if(param1 == this._currentPose)
            {
                return;
            }
            this._currentPose = param1;
            if(this._currentPose == 0)
            {
                this.cancelPose();
            }
        }
        
        internal function startGrab() : void
        {
            if(this._session.version >= 1.11)
            {
                if(!this.grabbing)
                {
                    this.grabbing = true;
                    trace("StartGrip");
                    if(!this.shoulderJoint1.broken && !this.elbowJoint1.broken)
                    {
                        this._session.contactListener.registerListener(ContactListener.RESULT,this.lowerArm1Shape,this.contactResultHandler);
                    }
                    if(!this.shoulderJoint2.broken && !this.elbowJoint2.broken)
                    {
                        this._session.contactListener.registerListener(ContactListener.RESULT,this.lowerArm2Shape,this.contactResultHandler);
                    }
                }
                return;
            }
            if(!this.grabbing)
            {
                this.grabbing = true;
                trace("StartGrip");
                if(!this.shoulderJoint1.broken && !this.elbowJoint1.broken)
                {
                    this.lowerArm1MC.hand.gotoAndStop(1);
                    this._session.contactListener.registerListener(ContactListener.RESULT,this.lowerArm1Shape,this.contactResultHandler);
                }
                if(!this.shoulderJoint2.broken && !this.elbowJoint2.broken)
                {
                    this.lowerArm2MC.hand.gotoAndStop(1);
                    this._session.contactListener.registerListener(ContactListener.RESULT,this.lowerArm2Shape,this.contactResultHandler);
                }
            }
            else
            {
                this.endGrab();
            }
        }
        
        internal function endGrab() : void
        {
            this._session.contactListener.deleteListener(ContactListener.RESULT,this.lowerArm1Shape);
            this._session.contactListener.deleteListener(ContactListener.RESULT,this.lowerArm2Shape);
        }
        
        internal function grabAction(param1:b2Body, param2:b2Shape, param3:b2Body) : void
        {
            var _loc7_:Vehicle = null;
            trace("GRAB");
            var _loc4_:b2Shape = param1.GetShapeList();
            var _loc5_:b2Vec2 = param1.GetWorldPoint(new b2Vec2(0,(_loc4_ as b2PolygonShape).GetVertices()[2].y));
            var _loc6_:b2RevoluteJointDef = new b2RevoluteJointDef();
            if(!param3.IsStatic())
            {
                _loc6_.enableLimit = true;
            }
            _loc6_.maxMotorTorque = 4;
            _loc6_.Initialize(param3,param1,_loc5_);
            if(param1 == this.lowerArm1Body)
            {
                this.lowerArm1MC.hand.gotoAndStop(1);
                this._session.contactListener.deleteListener(ContactListener.RESULT,this.lowerArm1Shape);
                if(param2.GetUserData() is Vehicle)
                {
                    _loc7_ = param2.GetUserData();
                    if(Boolean(this.userVehicle) && _loc7_ != this.userVehicle)
                    {
                        this.gripJoint1 = this._session.m_world.CreateJoint(_loc6_) as b2RevoluteJoint;
                    }
                    else
                    {
                        this.userVehicle = param2.GetUserData();
                        this.userVehicle.addCharacter(this);
                        this.vehicleArm1Joint = this._session.m_world.CreateJoint(_loc6_) as b2RevoluteJoint;
                        this.currentPose = 0;
                        switch(this.userVehicle.characterPose)
                        {
                            case 0:
                                break;
                            case 1:
                                this.currentPose = 10;
                                break;
                            case 2:
                                this.currentPose = 11;
                                break;
                            case 3:
                                this.currentPose = 12;
                        }
                    }
                }
                else
                {
                    this.gripJoint1 = this._session.m_world.CreateJoint(_loc6_) as b2RevoluteJoint;
                }
            }
            if(param1 == this.lowerArm2Body)
            {
                this.lowerArm2MC.hand.gotoAndStop(1);
                this._session.contactListener.deleteListener(ContactListener.RESULT,this.lowerArm2Shape);
                if(param2.GetUserData() is Vehicle)
                {
                    _loc7_ = param2.GetUserData();
                    if(Boolean(this.userVehicle) && _loc7_ != this.userVehicle)
                    {
                        this.gripJoint2 = this._session.m_world.CreateJoint(_loc6_) as b2RevoluteJoint;
                    }
                    else
                    {
                        this.userVehicle = param2.GetUserData();
                        this.userVehicle.addCharacter(this);
                        this.vehicleArm2Joint = this._session.m_world.CreateJoint(_loc6_) as b2RevoluteJoint;
                        this.currentPose = 0;
                        switch(this.userVehicle.characterPose)
                        {
                            case 0:
                                break;
                            case 1:
                                this.currentPose = 10;
                                break;
                            case 2:
                                this.currentPose = 11;
                                break;
                            case 3:
                                this.currentPose = 12;
                        }
                    }
                }
                else
                {
                    this.gripJoint2 = this._session.m_world.CreateJoint(_loc6_) as b2RevoluteJoint;
                }
            }
        }
        
        internal function releaseGrip() : void
        {
            if(this.grabbing)
            {
                this.lowerArm1MC.hand.gotoAndStop(2);
                this.lowerArm2MC.hand.gotoAndStop(2);
                this.grabbing = false;
                this.endGrab();
                if(this.gripJoint1)
                {
                    this._session.m_world.DestroyJoint(this.gripJoint1);
                    this.gripJoint1 = null;
                }
                if(this.gripJoint2)
                {
                    this._session.m_world.DestroyJoint(this.gripJoint2);
                    this.gripJoint2 = null;
                }
            }
        }
        
        public function addVocals(param1:String, param2:int) : void
        {
            this.voiceArray[param2] = param1;
        }
        
        protected function randomVocals(param1:int) : String
        {
            var _loc2_:Array = ["Elbow1","Elbow2","Knee1","Knee2","Shoulder1","Shoulder2","Hip1","Hip2","Knee1","Spikes"];
            return _loc2_[param1];
        }
        
        public function shapeImpale(param1:b2Shape, param2:Boolean = true, param3:b2Vec2 = null, param4:Number = 0) : void
        {
            var _loc5_:String = null;
            var _loc6_:int = 0;
            var _loc7_:b2Vec2 = null;
            var _loc8_:b2Vec2 = null;
            var _loc9_:Number = NaN;
            if(param1 == this.chestShape || param1 == this.pelvisShape)
            {
                _loc5_ = param1.GetBody().GetPosition().x.toString();
                _loc6_ = int(_loc5_.charAt(_loc5_.length - 1));
                this.addVocals(this.randomVocals(_loc6_),5);
            }
            else if(param1 == this.head1Shape)
            {
                trace("FATAL " + param2);
                if(param2)
                {
                    if(param3)
                    {
                        _loc7_ = param1.GetBody().GetWorldCenter();
                        _loc8_ = new b2Vec2(param3.x - _loc7_.x,param3.y - _loc7_.y);
                        _loc9_ = _loc8_.LengthSquared();
                        if(_loc9_ < param4)
                        {
                            this.eject();
                            this.dead = true;
                        }
                        else
                        {
                            _loc5_ = param1.GetBody().GetPosition().x.toString();
                            _loc6_ = int(_loc5_.charAt(_loc5_.length - 1));
                            this.addVocals(this.randomVocals(_loc6_),5);
                        }
                    }
                    else
                    {
                        this.eject();
                        this.dead = true;
                        trace("DEAD " + this.dead);
                    }
                }
                else
                {
                    _loc5_ = param1.GetBody().GetPosition().x.toString();
                    _loc6_ = int(_loc5_.charAt(_loc5_.length - 1));
                    this.addVocals(this.randomVocals(_loc6_),5);
                }
            }
        }
        
        public function grindShape(param1:b2Shape) : void
        {
            switch(param1)
            {
                case this.head1Shape:
                    this.head1Shape.SetUserData(GRIND_STATE);
                    delete this.contactResultBuffer[this.head1Shape];
                    delete this.contactAddBuffer[this.head1Shape];
                    this.session.contactListener.deleteListener(ContactListener.RESULT,this.head1Shape);
                    this.session.contactListener.deleteListener(ContactListener.ADD,this.head1Shape);
                    if(this.headBloodFlow)
                    {
                        this.headBloodFlow.stopSpewing();
                    }
                    break;
                case this.chestShape:
                    this.chestShape.SetUserData(GRIND_STATE);
                    delete this.contactResultBuffer[this.chestShape];
                    delete this.contactAddBuffer[this.chestShape];
                    this.session.contactListener.deleteListener(ContactListener.RESULT,this.chestShape);
                    this.session.contactListener.deleteListener(ContactListener.ADD,this.chestShape);
                    if(this.neckBloodFlow)
                    {
                        this.neckBloodFlow.stopSpewing();
                    }
                    if(this.shoulder1BloodFlow)
                    {
                        this.shoulder1BloodFlow.stopSpewing();
                    }
                    if(this.shoulder2BloodFlow)
                    {
                        this.shoulder2BloodFlow.stopSpewing();
                    }
                    if(this.stomachBloodFlow)
                    {
                        this.stomachBloodFlow.stopSpewing();
                    }
                    break;
                case this.pelvisShape:
                    this.pelvisShape.SetUserData(GRIND_STATE);
                    delete this.contactResultBuffer[this.pelvisShape];
                    delete this.contactAddBuffer[this.pelvisShape];
                    this.session.contactListener.deleteListener(ContactListener.RESULT,this.pelvisShape);
                    this.session.contactListener.deleteListener(ContactListener.ADD,this.pelvisShape);
                    if(this.hip1BloodFlow)
                    {
                        this.hip1BloodFlow.stopSpewing();
                    }
                    if(this.hip2BloodFlow)
                    {
                        this.hip2BloodFlow.stopSpewing();
                    }
                    break;
                case this.upperArm1Body.GetShapeList():
                    if(this.arm1BloodFlow)
                    {
                        this.arm1BloodFlow.stopSpewing();
                    }
                    break;
                case this.upperArm2Body.GetShapeList():
                    if(this.arm2BloodFlow)
                    {
                        this.arm2BloodFlow.stopSpewing();
                    }
                    break;
                case this.upperLeg1Body.GetShapeList():
                    if(this.thigh1BloodFlow)
                    {
                        this.thigh1BloodFlow.stopSpewing();
                    }
                    break;
                case this.upperLeg2Body.GetShapeList():
                    if(this.thigh2BloodFlow)
                    {
                        this.thigh2BloodFlow.stopSpewing();
                    }
            }
        }
        
        public function removeBody(param1:b2Body) : void
        {
            switch(param1)
            {
                case this.head1Body:
                    if(!this.neckJoint.broken)
                    {
                        this.neckBreak(0,true,true);
                    }
                    if(this.spinalChord)
                    {
                        this.spinalChord.spineBreak2(10);
                    }
                    break;
                case this.chestBody:
                    if(!this.neckJoint.broken)
                    {
                        this.neckBreak(0,true,true);
                    }
                    if(!this.shoulderJoint1.broken)
                    {
                        this.shoulderBreak1(0,true);
                    }
                    if(!this.shoulderJoint2.broken)
                    {
                        this.shoulderBreak2(0,true);
                    }
                    if(!this.waistJoint.broken)
                    {
                        this.torsoBreak(0);
                    }
                    if(this.intestineChain)
                    {
                        this.intestineChain.intestineBreak2(10);
                    }
                    if(this.spinalChord)
                    {
                        this.spinalChord.spineBreak1(10);
                    }
                    break;
                case this.pelvisBody:
                    if(!this.hipJoint1.broken)
                    {
                        this.hipBreak1(0,true);
                    }
                    if(!this.hipJoint2.broken)
                    {
                        this.hipBreak2(0,true);
                    }
                    if(!this.waistJoint.broken)
                    {
                        this.torsoBreak(0);
                    }
                    if(this.intestineChain)
                    {
                        this.intestineChain.intestineBreak1(10);
                    }
                    break;
                case this.upperArm1Body:
                    if(!this.shoulderJoint1.broken)
                    {
                        this.shoulderBreak1(0,true);
                    }
                    if(!this.elbowJoint1.broken)
                    {
                        this.elbowBreak1(1000);
                    }
                    if(this.arm1BloodFlow)
                    {
                        this.arm1BloodFlow.stopSpewing();
                    }
                    if(this.elbowLigament1)
                    {
                        this.elbowLigament1.remoteBreak();
                    }
                    break;
                case this.upperArm2Body:
                    if(!this.shoulderJoint2.broken)
                    {
                        this.shoulderBreak2(0,true);
                    }
                    if(!this.elbowJoint2.broken)
                    {
                        this.elbowBreak2(1000);
                    }
                    if(this.arm2BloodFlow)
                    {
                        this.arm2BloodFlow.stopSpewing();
                    }
                    if(this.elbowLigament2)
                    {
                        this.elbowLigament2.remoteBreak();
                    }
                    break;
                case this.upperLeg1Body:
                    if(!this.hipJoint1.broken)
                    {
                        this.hipBreak1(0,true);
                    }
                    if(!this.kneeJoint1.broken)
                    {
                        this.kneeBreak1(1000);
                    }
                    if(this.thigh1BloodFlow)
                    {
                        this.thigh1BloodFlow.stopSpewing();
                    }
                    if(this.kneeLigament1)
                    {
                        this.kneeLigament1.remoteBreak();
                    }
                    break;
                case this.upperLeg2Body:
                    if(!this.hipJoint2.broken)
                    {
                        this.hipBreak2(0,true);
                    }
                    if(!this.kneeJoint2.broken)
                    {
                        this.kneeBreak2(1000);
                    }
                    if(this.thigh2BloodFlow)
                    {
                        this.thigh2BloodFlow.stopSpewing();
                    }
                    if(this.kneeLigament2)
                    {
                        this.kneeLigament2.remoteBreak();
                    }
            }
        }
        
        public function explodeShape(param1:b2Shape, param2:Number) : void
        {
            var _loc3_:Number = NaN;
            var _loc4_:Number = NaN;
            var _loc5_:Number = NaN;
            switch(param1)
            {
                case this.head1Shape:
                    if(param2 > 0.85)
                    {
                        this.headSmash1(0);
                    }
                    break;
                case this.chestShape:
                    _loc3_ = this.chestBody.GetMass() / DEF_CHEST_MASS;
                    _loc4_ = Math.max(1 - 0.15 * _loc3_,0.7);
                    trace("new chest ratio " + _loc4_);
                    if(param2 > _loc4_)
                    {
                        this.chestSmash(0);
                    }
                    break;
                case this.pelvisShape:
                    _loc5_ = this.pelvisBody.GetMass() / DEF_PELVIS_MASS;
                    _loc4_ = Math.max(1 - 0.15 * _loc5_,0.7);
                    trace("new pelvis ratio " + _loc4_);
                    if(param2 > _loc4_)
                    {
                        this.pelvisSmash(0);
                    }
            }
        }
        
        public function get centralBody() : b2Body
        {
            if(this.heartBody)
            {
                return this.heartBody;
            }
            return this.chestBody;
        }
    }
}

