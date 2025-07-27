package com.totaljerkface.game.editor.specials
{
    import com.totaljerkface.game.editor.*;
    import com.totaljerkface.game.editor.actions.*;
    import com.totaljerkface.game.editor.specials.npcsprites.*;
    import com.totaljerkface.game.events.CanvasEvent;
    import flash.geom.Point;
    import flash.utils.Dictionary;
    import flash.utils.getDefinitionByName;
    
    public class NPCharacterRef extends Special
    {
        public static const NUM_CHARACTERS:int = 16;
             
        private var _npcSprite:NPCSprite;
        
        private var _neckAngle:int = 0;
        
        private var _shoulder1Angle:int = 0;
        
        private var _shoulder2Angle:int = 0;
        
        private var _elbow1Angle:int = 0;
        
        private var _elbow2Angle:int = 0;
        
        private var _hip1Angle:int = 0;
        
        private var _hip2Angle:int = 0;
        
        private var _knee1Angle:int = 0;
        
        private var _knee2Angle:int = 0;
        
        private var _reverse:Boolean;
        
        private var _sleeping:Boolean;
        
        private var _holdPose:Boolean;
        
        private var _interactive:Boolean;
        
        private var _destroyJointsUponDeath:Boolean;
        
        private var _charIndex:int = 1;
        
        public function NPCharacterRef()
        {
            _triggerable = true;
            _triggers = new Array();
            _triggerActions = new Dictionary();
            _triggerActionList = ["wake from sleep","apply impulse","hold pose","release pose"];
            _triggerActionListProperties = [null,["impulseX","impulseY","spin"],null,null];
            _triggerString = "triggerActionsNPC";
            super();
            name = "non-player character";
            _shapesUsed = 24;
            _artUsed = 0;
            _rotatable = true;
            _scalable = false;
            _groupable = false;
            _joinable = true;
            this._interactive = true;
            this._destroyJointsUponDeath = false;
            _joints = new Array();
            _keyedPropertyObject[_triggerString] = _triggerActions;
            doubleClickEnabled = true;
            trace("com.totaljerkface.game.editor.specials.npcsprites.NPCSprite" + this._charIndex);
            var _loc1_:Class = getDefinitionByName("com.totaljerkface.game.editor.specials.npcsprites.NPCSprite" + this._charIndex) as Class;
            this._npcSprite = new _loc1_();
            addChild(this._npcSprite);
            this._npcSprite.scaleX = this._npcSprite.scaleY = 0.5;
        }
        
        override public function setAttributes() : void
        {
            _type = "NPCharacterRef";
            _attributes = ["x","y","angle","charIndex","sleeping","reverse","holdPose","interactive","neckAngle","shoulder1Angle","shoulder2Angle","elbow1Angle","elbow2Angle","hip1Angle","hip2Angle","knee1Angle","knee2Angle","destroyJointsUponDeath"];
            addTriggerProperties();
        }
        
        override public function clone() : RefSprite
        {
            var _loc1_:NPCharacterRef = null;
            _loc1_ = new NPCharacterRef();
            _loc1_.angle = angle;
            _loc1_.sleeping = this.sleeping;
            _loc1_.reverse = this.reverse;
            _loc1_.holdPose = this.holdPose;
            _loc1_.interactive = this.interactive;
            _loc1_.neckAngle = this.neckAngle;
            _loc1_.shoulder1Angle = this.shoulder1Angle;
            _loc1_.shoulder2Angle = this.shoulder2Angle;
            _loc1_.elbow1Angle = this.elbow1Angle;
            _loc1_.elbow2Angle = this.elbow2Angle;
            _loc1_.hip1Angle = this.hip1Angle;
            _loc1_.hip2Angle = this.hip2Angle;
            _loc1_.knee1Angle = this.knee1Angle;
            _loc1_.knee2Angle = this.knee2Angle;
            _loc1_.charIndex = this.charIndex;
            _loc1_.destroyJointsUponDeath = this.destroyJointsUponDeath;
            _loc1_.x = x;
            _loc1_.y = y;
            transferKeyedProperties(_loc1_);
            return _loc1_;
        }
        
        public function get npcSprite() : NPCSprite
        {
            return this._npcSprite;
        }
        
        public function get charIndex() : int
        {
            return this._charIndex;
        }
        
        public function set charIndex(param1:int) : void
        {
            if(this._charIndex == param1)
            {
                return;
            }
            if(param1 < 1)
            {
                param1 = 1;
            }
            if(param1 > NUM_CHARACTERS)
            {
                param1 = NUM_CHARACTERS;
            }
            this._charIndex = param1;
            removeChild(this._npcSprite);
            var _loc2_:Class = getDefinitionByName("com.totaljerkface.game.editor.specials.npcsprites.NPCSprite" + this._charIndex) as Class;
            this._npcSprite = new _loc2_();
            addChild(this._npcSprite);
            this._npcSprite.scaleX = this._reverse ? -0.5 : 0.5;
            this._npcSprite.scaleY = 0.5;
            this._npcSprite.headOuter.rotation = this._neckAngle;
            this._npcSprite.arm1.rotation = this._shoulder1Angle;
            this._npcSprite.arm2.rotation = this._shoulder2Angle;
            this._npcSprite.lowerArmOuter1.rotation = this._elbow1Angle;
            this._npcSprite.lowerArmOuter2.rotation = this._elbow2Angle;
            this._npcSprite.leg1.rotation = this._hip1Angle;
            this._npcSprite.leg2.rotation = this._hip2Angle;
            this._npcSprite.lowerLegOuter1.rotation = this._knee1Angle;
            this._npcSprite.lowerLegOuter2.rotation = this._knee2Angle;
            if(_selected)
            {
                drawBoundingBox();
            }
            x = x;
            y = y;
        }
        
        public function get reverse() : Boolean
        {
            return this._reverse;
        }
        
        public function set reverse(param1:Boolean) : void
        {
            if(param1 == this._reverse)
            {
                return;
            }
            this._reverse = param1;
            if(this._reverse)
            {
                this._npcSprite.scaleX = -0.5;
            }
            else
            {
                this._npcSprite.scaleX = 0.5;
            }
            if(_selected)
            {
                drawBoundingBox();
            }
            x = x;
            y = y;
        }
        
        public function get destroyJointsUponDeath() : Boolean
        {
            return this._destroyJointsUponDeath;
        }
        
        public function set destroyJointsUponDeath(param1:Boolean) : void
        {
            this._destroyJointsUponDeath = param1;
        }
        
        public function get sleeping() : Boolean
        {
            return this._sleeping;
        }
        
        public function set sleeping(param1:Boolean) : void
        {
            this._sleeping = param1;
        }
        
        public function get holdPose() : Boolean
        {
            return this._holdPose;
        }
        
        public function set holdPose(param1:Boolean) : void
        {
            this._holdPose = param1;
        }
        
        public function get interactive() : Boolean
        {
            return this._interactive;
        }
        
        public function set interactive(param1:Boolean) : void
        {
            if(this._interactive == param1)
            {
                return;
            }
            if(param1 && _inGroup)
            {
                return;
            }
            this._interactive = param1;
            if(this._interactive)
            {
                _groupable = false;
                _joinable = true;
                _shapesUsed = 24;
                _artUsed = 0;
                dispatchEvent(new CanvasEvent(CanvasEvent.ART,-10));
                dispatchEvent(new CanvasEvent(CanvasEvent.SHAPE,24));
            }
            else
            {
                _groupable = true;
                _joinable = false;
                _shapesUsed = 0;
                _artUsed = 10;
                dispatchEvent(new CanvasEvent(CanvasEvent.SHAPE,-24));
                dispatchEvent(new CanvasEvent(CanvasEvent.ART,10));
            }
        }
        
        public function get neckAngle() : int
        {
            return this._neckAngle;
        }
        
        public function set neckAngle(param1:int) : void
        {
            if(param1 > 20)
            {
                param1 = 20;
            }
            if(param1 < -20)
            {
                param1 = -20;
            }
            this._npcSprite.headOuter.rotation = param1;
            this._neckAngle = param1;
            if(_selected)
            {
                drawBoundingBox();
            }
            x = x;
            y = y;
        }
        
        public function get shoulder1Angle() : int
        {
            return this._shoulder1Angle;
        }
        
        public function set shoulder1Angle(param1:int) : void
        {
            if(param1 > 60)
            {
                param1 = 60;
            }
            if(param1 < -180)
            {
                param1 = -180;
            }
            this._npcSprite.arm1.rotation = param1;
            this._shoulder1Angle = param1;
            if(_selected)
            {
                drawBoundingBox();
            }
            x = x;
            y = y;
        }
        
        public function get shoulder2Angle() : int
        {
            return this._shoulder2Angle;
        }
        
        public function set shoulder2Angle(param1:int) : void
        {
            if(param1 > 60)
            {
                param1 = 60;
            }
            if(param1 < -180)
            {
                param1 = -180;
            }
            this._npcSprite.arm2.rotation = param1;
            this._shoulder2Angle = param1;
            if(_selected)
            {
                drawBoundingBox();
            }
            x = x;
            y = y;
        }
        
        public function get elbow1Angle() : int
        {
            return this._elbow1Angle;
        }
        
        public function set elbow1Angle(param1:int) : void
        {
            if(param1 > 0)
            {
                param1 = 0;
            }
            if(param1 < -160)
            {
                param1 = -160;
            }
            this._npcSprite.lowerArmOuter1.rotation = param1;
            this._elbow1Angle = param1;
            if(_selected)
            {
                drawBoundingBox();
            }
            x = x;
            y = y;
        }
        
        public function get elbow2Angle() : int
        {
            return this._elbow2Angle;
        }
        
        public function set elbow2Angle(param1:int) : void
        {
            if(param1 > 0)
            {
                param1 = 0;
            }
            if(param1 < -160)
            {
                param1 = -160;
            }
            this._npcSprite.lowerArmOuter2.rotation = param1;
            this._elbow2Angle = param1;
            if(_selected)
            {
                drawBoundingBox();
            }
            x = x;
            y = y;
        }
        
        public function get hip1Angle() : int
        {
            return this._hip1Angle;
        }
        
        public function set hip1Angle(param1:int) : void
        {
            if(param1 > 10)
            {
                param1 = 10;
            }
            if(param1 < -150)
            {
                param1 = -150;
            }
            this._npcSprite.leg1.rotation = param1;
            this._hip1Angle = param1;
            if(_selected)
            {
                drawBoundingBox();
            }
            x = x;
            y = y;
        }
        
        public function get hip2Angle() : int
        {
            return this._hip2Angle;
        }
        
        public function set hip2Angle(param1:int) : void
        {
            if(param1 > 10)
            {
                param1 = 10;
            }
            if(param1 < -150)
            {
                param1 = -150;
            }
            this._npcSprite.leg2.rotation = param1;
            this._hip2Angle = param1;
            if(_selected)
            {
                drawBoundingBox();
            }
            x = x;
            y = y;
        }
        
        public function get knee1Angle() : int
        {
            return this._knee1Angle;
        }
        
        public function set knee1Angle(param1:int) : void
        {
            if(param1 > 150)
            {
                param1 = 150;
            }
            if(param1 < 0)
            {
                param1 = 0;
            }
            this._npcSprite.lowerLegOuter1.rotation = param1;
            this._knee1Angle = param1;
            if(_selected)
            {
                drawBoundingBox();
            }
            x = x;
            y = y;
        }
        
        public function get knee2Angle() : int
        {
            return this._knee2Angle;
        }
        
        public function set knee2Angle(param1:int) : void
        {
            if(param1 > 150)
            {
                param1 = 150;
            }
            if(param1 < 0)
            {
                param1 = 0;
            }
            this._npcSprite.lowerLegOuter2.rotation = param1;
            this._knee2Angle = param1;
            if(_selected)
            {
                drawBoundingBox();
            }
            x = x;
            y = y;
        }
        
        public function get tag() : String
        {
            var _loc1_:String = null;
            switch(this._charIndex)
            {
                case 1:
                    _loc1_ = "Char1";
                    break;
                case 2:
                    _loc1_ = "Char2";
                    break;
                case 3:
                    _loc1_ = "Char3";
                    break;
                case 4:
                    _loc1_ = "Kid1";
                    break;
                case 5:
                    _loc1_ = "Char4";
                    break;
                case 6:
                    _loc1_ = "Char8";
                    break;
                case 7:
                    _loc1_ = "Char9";
                    break;
                case 8:
                    _loc1_ = "Char11";
                    break;
                case 9:
                    _loc1_ = "Char2";
                    break;
                case 10:
                    _loc1_ = "Santa";
                    break;
                case 11:
                    _loc1_ = "Elf1";
                    break;
                case 12:
                    _loc1_ = "Char12";
                    break;
                case 13:
                    _loc1_ = "Char4";
                    break;
                case 14:
                    _loc1_ = "Kid2";
                    break;
                case 15:
                    _loc1_ = "Kid1";
                    break;
                case 16:
                    _loc1_ = "Heli";
            }
            return _loc1_;
        }
        
        override public function setProperty(param1:String, param2:*) : Action
        {
            var _loc3_:Action = null;
            var _loc4_:Action = null;
            var _loc9_:* = 0;
            var _loc10_:RefJoint = null;
            if(param1 == "interactive" && param2 == false && Boolean(_joints))
            {
                _loc9_ = 0;
                while(_loc9_ < _joints.length)
                {
                    _loc10_ = _joints[_loc9_];
                    _loc3_ = _loc10_.removeBody(this);
                    if(_loc4_)
                    {
                        _loc4_.nextAction = _loc3_.firstAction;
                    }
                    _loc4_ = _loc3_;
                    removeJoint(_loc10_);
                    _loc9_ = --_loc9_ + 1;
                }
            }
            var _loc5_:* = this[param1];
            var _loc6_:Point = new Point(x,y);
            this[param1] = param2;
            var _loc7_:* = this[param1];
            var _loc8_:Point = new Point(x,y);
            if(_loc7_ != _loc5_)
            {
                _loc3_ = new ActionProperty(this,param1,_loc5_,_loc7_,_loc6_,_loc8_);
                if(_loc4_)
                {
                    _loc4_.nextAction = _loc3_;
                }
            }
            return _loc3_;
        }
    }
}

