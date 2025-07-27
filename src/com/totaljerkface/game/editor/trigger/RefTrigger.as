package com.totaljerkface.game.editor.trigger
{
    import Box2D.Common.Math.*;
    import com.totaljerkface.game.editor.*;
    import com.totaljerkface.game.editor.actions.*;
    import com.totaljerkface.game.editor.specials.*;
    import flash.display.*;
    import flash.events.*;
    import flash.text.*;
    import flash.utils.Dictionary;
    
    public class RefTrigger extends RefSprite
    {
        protected static var bmd:BitmapData;
        
        protected static var bmd_disabled:BitmapData;
        
        public static const typeArray:Array = ["activate object","play sound effect","level victory"];
        
        protected static const minDelay:Number = 0;
        
        protected static const maxDelay:Number = 30;
        
        protected var bitmapSprite:Sprite;
        
        protected var armSprite:Sprite;
        
        protected var numLabel:TextField;
        
        protected var minDimension:Number = 0.05;
        
        protected var maxDimension:Number = 50;
        
        protected var scaleXCopy:Number = 1;
        
        protected var scaleYCopy:Number = 1;
        
        protected var rotationCopy:Number = 0;
        
        protected var _triggeredBy:int = 1;
        
        protected var _triggerDelay:Number = 0;
        
        protected var _triggerType:String = "activate object";
        
        protected var _typeIndex:int = 1;
        
        protected var _repeatType:int = 1;
        
        protected var _repeatInterval:Number = 1;
        
        protected var _startDisabled:Boolean;
        
        protected var _soundEffect:String = "wg voice 1";
        
        protected var _soundLocation:int = 1;
        
        protected var _panning:Number = 0;
        
        protected var _volume:Number = 1;
        
        protected var _addingTargets:Boolean;
        
        protected var _targets:Array;
        
        protected var _cloneTargets:Array;
        
        public function RefTrigger()
        {
            _triggers = new Array();
            _triggerActions = new Dictionary();
            _triggerActionList = ["activate trigger","disable","enable"];
            _triggerActionListProperties = [null,null,null];
            super();
            name = "trigger";
            _shapesUsed = 1;
            _rotatable = true;
            _scalable = true;
            _joinable = false;
            _groupable = false;
            this._targets = new Array();
            this._cloneTargets = new Array();
            _triggerable = true;
            _triggerString = "triggerActionsTrigger";
            _keyedPropertyObject[_triggerString] = _triggerActions;
            if(!bmd)
            {
                this.createBMD();
            }
            this.bitmapSprite = new Sprite();
            addChildAt(this.bitmapSprite,0);
            this.bitmapSprite.blendMode = BlendMode.HARDLIGHT;
            this.armSprite = new Sprite();
            this.armSprite.blendMode = BlendMode.INVERT;
            addChild(this.armSprite);
            this.drawShape();
            this.createNumLabel();
            this.numLabel.cacheAsBitmap = true;
        }
        
        override public function setAttributes() : void
        {
            _attributes = ["x","y","shapeWidth","shapeHeight","angle","triggeredBy","repeatType"];
            if(this._repeatType > 2)
            {
                _attributes.push("repeatInterval");
            }
            _attributes.push("triggerType");
            if(this._typeIndex == 1)
            {
                _attributes.push("triggerDelay");
            }
            else if(this._typeIndex == 2)
            {
                _attributes.push("soundEffect","triggerDelay","soundLocation","volume");
                if(this.soundLocation == 1)
                {
                    _attributes.push("panning");
                }
            }
            _attributes.push("startDisabled");
            addTriggerProperties();
        }
        
        override public function get functions() : Array
        {
            var _loc1_:Array = null;
            if(!this._addingTargets && (this._typeIndex == 1 || this._triggeredBy == 4))
            {
                _loc1_ = ["addNewTarget"];
                if(this._targets.length > 0)
                {
                    _loc1_.push("removeTarget");
                }
                return _loc1_;
            }
            return [];
        }
        
        private function createNumLabel() : void
        {
            var _loc1_:TextFormat = new TextFormat("HelveticaNeueLT Std Med",15,4032711,true,null,null,null,null,TextFormatAlign.LEFT);
            this.numLabel = new TextField();
            this.numLabel.type = TextFieldType.DYNAMIC;
            this.numLabel.defaultTextFormat = _loc1_;
            this.numLabel.autoSize = TextFieldAutoSize.LEFT;
            this.numLabel.x = 3;
            this.numLabel.y = 3;
            this.numLabel.multiline = false;
            this.numLabel.selectable = false;
            this.numLabel.embedFonts = true;
            this.numLabel.antiAliasType = AntiAliasType.ADVANCED;
            addChild(this.numLabel);
        }
        
        private function createBMD() : void
        {
            var _loc3_:* = 0;
            var _loc4_:* = 0;
            var _loc1_:Sprite = new Sprite();
            var _loc2_:int = 0;
            while(_loc2_ < 2)
            {
                _loc1_.graphics.clear();
                _loc3_ = _loc2_ == 0 ? 16750848 : 10066329;
                _loc4_ = _loc2_ == 0 ? 16777062 : 13421772;
                _loc1_.graphics.beginFill(_loc3_,1);
                _loc1_.graphics.moveTo(0,0);
                _loc1_.graphics.lineTo(5,0);
                _loc1_.graphics.lineTo(0,5);
                _loc1_.graphics.lineTo(0,0);
                _loc1_.graphics.endFill();
                _loc1_.graphics.beginFill(_loc4_,1);
                _loc1_.graphics.moveTo(5,0);
                _loc1_.graphics.lineTo(15,0);
                _loc1_.graphics.lineTo(0,15);
                _loc1_.graphics.lineTo(0,5);
                _loc1_.graphics.lineTo(5,0);
                _loc1_.graphics.endFill();
                _loc1_.graphics.beginFill(_loc3_,1);
                _loc1_.graphics.moveTo(15,0);
                _loc1_.graphics.lineTo(20,0);
                _loc1_.graphics.lineTo(20,5);
                _loc1_.graphics.lineTo(5,20);
                _loc1_.graphics.lineTo(0,20);
                _loc1_.graphics.lineTo(0,15);
                _loc1_.graphics.lineTo(15,0);
                _loc1_.graphics.endFill();
                _loc1_.graphics.beginFill(_loc4_,1);
                _loc1_.graphics.moveTo(20,5);
                _loc1_.graphics.lineTo(20,15);
                _loc1_.graphics.lineTo(15,20);
                _loc1_.graphics.lineTo(5,20);
                _loc1_.graphics.lineTo(20,5);
                _loc1_.graphics.endFill();
                _loc1_.graphics.beginFill(_loc3_,1);
                _loc1_.graphics.moveTo(20,15);
                _loc1_.graphics.lineTo(20,20);
                _loc1_.graphics.lineTo(15,20);
                _loc1_.graphics.lineTo(20,15);
                _loc1_.graphics.endFill();
                if(_loc2_ == 0)
                {
                    bmd = new BitmapData(20,20,true,0);
                    bmd.draw(_loc1_);
                }
                else
                {
                    bmd_disabled = new BitmapData(20,20,true,0);
                    bmd_disabled.draw(_loc1_);
                }
                _loc2_++;
            }
        }
        
        private function drawShape() : void
        {
            this.bitmapSprite.graphics.clear();
            this.bitmapSprite.graphics.lineStyle(5,6710886,1,true);
            var _loc1_:BitmapData = this._startDisabled ? bmd_disabled : bmd;
            this.bitmapSprite.graphics.beginBitmapFill(_loc1_,null,true);
            var _loc2_:b2Mat22 = new b2Mat22(this.rotationCopy * Math.PI / 180);
            var _loc3_:Number = 50 * this.scaleXCopy;
            var _loc4_:Number = 50 * this.scaleYCopy;
            var _loc5_:b2Vec2 = new b2Vec2(-_loc3_,-_loc4_);
            _loc5_.MulM(_loc2_);
            this.bitmapSprite.graphics.moveTo(_loc5_.x,_loc5_.y);
            _loc5_ = new b2Vec2(_loc3_,-_loc4_);
            _loc5_.MulM(_loc2_);
            this.bitmapSprite.graphics.lineTo(_loc5_.x,_loc5_.y);
            _loc5_ = new b2Vec2(_loc3_,_loc4_);
            _loc5_.MulM(_loc2_);
            this.bitmapSprite.graphics.lineTo(_loc5_.x,_loc5_.y);
            _loc5_ = new b2Vec2(-_loc3_,_loc4_);
            _loc5_.MulM(_loc2_);
            this.bitmapSprite.graphics.lineTo(_loc5_.x,_loc5_.y);
            _loc5_ = new b2Vec2(-_loc3_,-_loc4_);
            _loc5_.MulM(_loc2_);
            this.bitmapSprite.graphics.lineTo(_loc5_.x,_loc5_.y);
            this.bitmapSprite.graphics.endFill();
            this.drawArms();
        }
        
        public function drawArms() : void
        {
            var _loc4_:RefSprite = null;
            var _loc5_:Number = NaN;
            var _loc6_:Number = NaN;
            var _loc7_:Number = NaN;
            var _loc8_:Number = NaN;
            var _loc9_:Number = NaN;
            var _loc10_:b2Mat22 = null;
            var _loc11_:Number = NaN;
            var _loc12_:Number = NaN;
            var _loc13_:int = 0;
            var _loc14_:Number = NaN;
            var _loc15_:Number = NaN;
            var _loc16_:b2Vec2 = null;
            var _loc17_:Vector.<b2Vec2> = null;
            var _loc18_:int = 0;
            var _loc19_:int = 0;
            this.armSprite.graphics.clear();
            var _loc1_:Vector.<b2Vec2> = new Vector.<b2Vec2>();
            _loc1_.push(new b2Vec2(5,0),new b2Vec2(-5,0),new b2Vec2(0,10));
            var _loc2_:int = int(this._targets.length);
            var _loc3_:int = 0;
            while(_loc3_ < _loc2_)
            {
                _loc4_ = this._targets[_loc3_];
                _loc5_ = _loc4_.x - x;
                _loc6_ = _loc4_.y - y;
                this.armSprite.graphics.lineStyle(3,6710886,1,false);
                this.armSprite.graphics.moveTo(0,0);
                this.armSprite.graphics.lineTo(_loc5_,_loc6_);
                if(_loc4_ is RefTrigger)
                {
                    _loc7_ = 0;
                    _loc8_ = 0;
                    _loc9_ = Math.atan2(_loc6_,_loc5_);
                    _loc10_ = new b2Mat22(_loc9_ - Math.PI * 0.5);
                    _loc11_ = Math.sqrt(Math.pow(_loc6_,2) + Math.pow(_loc5_,2)) - 10;
                    _loc12_ = 50;
                    _loc13_ = Math.floor(_loc11_ / _loc12_);
                    _loc14_ = _loc12_ * Math.cos(_loc9_);
                    _loc15_ = _loc12_ * Math.sin(_loc9_);
                    _loc16_ = _loc1_[0];
                    _loc17_ = new Vector.<b2Vec2>();
                    _loc18_ = 0;
                    while(_loc18_ < 3)
                    {
                        _loc16_ = _loc1_[_loc18_];
                        _loc16_ = _loc16_.Copy();
                        _loc16_.MulM(_loc10_);
                        _loc17_.push(_loc16_);
                        _loc18_++;
                    }
                    _loc18_ = 1;
                    while(_loc18_ <= _loc13_)
                    {
                        _loc7_ += _loc14_;
                        _loc8_ += _loc15_;
                        _loc16_ = _loc17_[2];
                        this.armSprite.graphics.lineStyle(0);
                        this.armSprite.graphics.beginFill(6710886);
                        this.armSprite.graphics.moveTo(_loc16_.x + _loc7_,_loc16_.y + _loc8_);
                        _loc19_ = 0;
                        while(_loc19_ < 3)
                        {
                            _loc16_ = _loc17_[_loc19_];
                            this.armSprite.graphics.lineTo(_loc16_.x + _loc7_,_loc16_.y + _loc8_);
                            _loc19_++;
                        }
                        this.armSprite.graphics.endFill();
                        _loc18_++;
                    }
                }
                _loc3_++;
            }
            if(selected)
            {
                drawBoundingBox();
            }
        }
        
        private function targetMoved(param1:Event) : void
        {
            this.drawArms();
        }
        
        override public function set x(param1:Number) : void
        {
            this.armSprite.graphics.clear();
            super.x = param1;
            this.drawArms();
        }
        
        override public function set y(param1:Number) : void
        {
            this.armSprite.graphics.clear();
            super.y = param1;
            this.drawArms();
        }
        
        public function setPositionOld(param1:Number, param2:Number) : void
        {
            super.x = param1;
            super.y = param2;
        }
        
        override public function get scaleX() : Number
        {
            return this.scaleXCopy;
        }
        
        override public function set scaleX(param1:Number) : void
        {
            if(param1 < this.minDimension)
            {
                param1 = this.minDimension;
            }
            if(param1 > this.maxDimension)
            {
                param1 = this.maxDimension;
            }
            this.scaleXCopy = param1;
            this.drawShape();
            this.x = x;
            this.y = y;
        }
        
        override public function get scaleY() : Number
        {
            return this.scaleYCopy;
        }
        
        override public function set scaleY(param1:Number) : void
        {
            if(param1 < this.minDimension)
            {
                param1 = this.minDimension;
            }
            if(param1 > this.maxDimension)
            {
                param1 = this.maxDimension;
            }
            this.scaleYCopy = param1;
            this.drawShape();
            this.x = x;
            this.y = y;
        }
        
        override public function get angle() : Number
        {
            return this.rotationCopy;
        }
        
        override public function set angle(param1:Number) : void
        {
            if(param1 > 180)
            {
                param1 -= 360;
            }
            if(param1 < -180)
            {
                param1 += 360;
            }
            this.rotationCopy = param1;
            this.drawShape();
            this.x = x;
            this.y = y;
        }
        
        public function get triggerType() : String
        {
            return this._triggerType;
        }
        
        public function set triggerType(param1:String) : void
        {
            var _loc4_:RefSprite = null;
            this._triggerType = param1;
            var _loc2_:int = int(typeArray.indexOf(param1));
            if(_loc2_ < 0)
            {
                throw new Error("TRIGGER TYPE NOT IN TYPE ARRAY");
            }
            this._typeIndex = _loc2_ + 1;
            if(this._typeIndex == 1)
            {
                addChildAt(this.armSprite,1);
                if(_selected)
                {
                    drawBoundingBox();
                }
            }
            else if(this._triggeredBy != 4)
            {
                if(this.armSprite.parent)
                {
                    removeChild(this.armSprite);
                    if(_selected)
                    {
                        drawBoundingBox();
                    }
                }
            }
            this.setAttributes();
            var _loc3_:int = 0;
            while(_loc3_ < this._targets.length)
            {
                _loc4_ = this._targets[_loc3_];
                _loc4_.setAttributes();
                _loc3_++;
            }
        }
        
        public function get triggerDelay() : Number
        {
            return this._triggerDelay;
        }
        
        public function set triggerDelay(param1:Number) : void
        {
            if(param1 < minDelay)
            {
                param1 = minDelay;
            }
            if(param1 > maxDelay)
            {
                param1 = maxDelay;
            }
            this._triggerDelay = param1;
        }
        
        public function get typeIndex() : int
        {
            return this._typeIndex;
        }
        
        public function set typeIndex(param1:int) : void
        {
            this._typeIndex = param1;
            if(this._typeIndex > typeArray.length || this.typeIndex < 1)
            {
                throw new Error("TYPE INDEX OUT OF TYPEARRAY RANGE");
            }
            this.triggerType = typeArray[this._typeIndex - 1];
        }
        
        public function get soundEffect() : String
        {
            return this._soundEffect;
        }
        
        public function set soundEffect(param1:String) : void
        {
            this._soundEffect = param1;
        }
        
        public function get panning() : Number
        {
            return this._panning;
        }
        
        public function set panning(param1:Number) : void
        {
            if(param1 < -1)
            {
                param1 = -1;
            }
            if(param1 > 1)
            {
                param1 = 1;
            }
            this._panning = param1;
        }
        
        public function get volume() : Number
        {
            return this._volume;
        }
        
        public function set volume(param1:Number) : void
        {
            if(param1 < 0)
            {
                param1 = 0;
            }
            if(param1 > 1)
            {
                param1 = 1;
            }
            this._volume = param1;
        }
        
        public function get soundLocation() : int
        {
            return this._soundLocation;
        }
        
        public function set soundLocation(param1:int) : void
        {
            if(param1 < 1)
            {
                param1 = 1;
            }
            if(param1 > 2)
            {
                param1 = 2;
            }
            this._soundLocation = param1;
            this.setAttributes();
        }
        
        public function get triggeredBy() : int
        {
            return this._triggeredBy;
        }
        
        public function set triggeredBy(param1:int) : void
        {
            if(param1 < 1)
            {
                param1 = 1;
            }
            if(param1 > 6)
            {
                param1 = 6;
            }
            this._triggeredBy = param1;
            if(this._triggeredBy == 4)
            {
                addChildAt(this.armSprite,1);
                if(_selected)
                {
                    drawBoundingBox();
                }
            }
            else if(this._typeIndex != 1)
            {
                if(this.armSprite.parent)
                {
                    removeChild(this.armSprite);
                    if(_selected)
                    {
                        drawBoundingBox();
                    }
                }
            }
        }
        
        public function get repeatType() : int
        {
            return this._repeatType;
        }
        
        public function set repeatType(param1:int) : void
        {
            if(param1 < 1)
            {
                param1 = 1;
            }
            if(param1 > 4)
            {
                param1 = 4;
            }
            this._repeatType = param1;
            this.setAttributes();
        }
        
        public function get repeatInterval() : Number
        {
            return this._repeatInterval;
        }
        
        public function set repeatInterval(param1:Number) : void
        {
            if(param1 < 0.1)
            {
                param1 = 0.1;
            }
            if(param1 > 30)
            {
                param1 = 30;
            }
            this._repeatInterval = param1;
        }
        
        public function get startDisabled() : Boolean
        {
            return this._startDisabled;
        }
        
        public function set startDisabled(param1:Boolean) : void
        {
            if(param1 == this._startDisabled)
            {
                return;
            }
            this._startDisabled = param1;
            this.drawShape();
        }
        
        public function get addingTargets() : Boolean
        {
            return this._addingTargets;
        }
        
        public function set addingTargets(param1:Boolean) : void
        {
            this._addingTargets = param1;
        }
        
        public function get targets() : Array
        {
            return this._targets;
        }
        
        public function get cloneTargets() : Array
        {
            return this._cloneTargets;
        }
        
        override public function clone() : RefSprite
        {
            var _loc1_:RefTrigger = null;
            _loc1_ = new RefTrigger();
            _loc1_.x = x;
            _loc1_.y = y;
            _loc1_.angle = this.angle;
            _loc1_.scaleX = this.scaleX;
            _loc1_.scaleY = this.scaleY;
            _loc1_.triggerDelay = this.triggerDelay;
            _loc1_.repeatInterval = this.repeatInterval;
            _loc1_.typeIndex = this.typeIndex;
            _loc1_.triggeredBy = this.triggeredBy;
            _loc1_.repeatType = this.repeatType;
            _loc1_.soundEffect = this.soundEffect;
            _loc1_.panning = this.panning;
            _loc1_.volume = this.volume;
            _loc1_.soundLocation = this.soundLocation;
            _loc1_.startDisabled = this.startDisabled;
            transferKeyedProperties(_loc1_);
            return _loc1_;
        }
        
        public function setNumLabel(param1:int) : void
        {
            this.numLabel.text = String(param1);
            addChild(this.numLabel);
        }
        
        public function addTarget(param1:RefSprite) : Action
        {
            this._targets.push(param1);
            param1.addEventListener(RefSprite.COORDINATE_CHANGE,this.targetMoved,false,0,true);
            param1.addTrigger(this);
            var _loc2_:ActionTriggerAdd = new ActionTriggerAdd(this,param1,this._targets.length - 1);
            this.drawArms();
            return _loc2_;
        }
        
        public function addMoveListener(param1:RefSprite) : void
        {
            param1.addEventListener(RefSprite.COORDINATE_CHANGE,this.targetMoved,false,0,true);
        }
        
        public function removeTarget(param1:RefSprite) : Action
        {
            var _loc3_:RefSprite = null;
            var _loc4_:ActionTriggerRemove = null;
            var _loc2_:int = int(this._targets.indexOf(param1));
            if(_loc2_ > -1)
            {
                _loc3_ = this._targets[_loc2_];
                _loc3_.removeEventListener(RefSprite.COORDINATE_CHANGE,this.targetMoved);
                _loc4_ = new ActionTriggerRemove(this,param1,_loc2_);
                this._targets.splice(_loc2_,1);
                this.drawArms();
                return _loc4_;
            }
            throw new Error("target not contained in this trigger");
        }
        
        public function removeLastTarget() : Action
        {
            var _loc1_:int = int(this._targets.length - 1);
            var _loc2_:RefSprite = this._targets[_loc1_];
            _loc2_.removeEventListener(RefSprite.COORDINATE_CHANGE,this.targetMoved);
            var _loc3_:ActionTriggerRemove = new ActionTriggerRemove(this,_loc2_,_loc1_);
            this._targets.splice(_loc1_,1);
            _loc2_.removeTrigger(this);
            this.drawArms();
            return _loc3_;
        }
        
        public function removeMoveListener(param1:RefSprite) : void
        {
            param1.removeEventListener(RefSprite.COORDINATE_CHANGE,this.targetMoved);
        }
        
        override public function deleteSelf(param1:Canvas) : Action
        {
            var _loc2_:Action = null;
            var _loc3_:Action = null;
            var _loc5_:RefSprite = null;
            var _loc6_:RefTrigger = null;
            var _loc4_:* = 0;
            while(_loc4_ < this._targets.length)
            {
                _loc5_ = this._targets[_loc4_];
                this._targets.splice(_loc4_,1);
                _loc5_.removeEventListener(RefSprite.COORDINATE_CHANGE,this.targetMoved);
                _loc5_.removeTrigger(this);
                _loc2_ = new ActionTriggerRemove(this,_loc5_,_loc4_);
                if(_loc3_)
                {
                    _loc3_.nextAction = _loc2_;
                }
                _loc3_ = _loc2_;
                _loc4_ = --_loc4_ + 1;
            }
            _loc4_ = 0;
            while(_loc4_ < _triggers.length)
            {
                _loc6_ = _triggers[_loc4_];
                _loc2_ = _loc6_.removeTarget(this);
                if(_loc3_)
                {
                    _loc3_.nextAction = _loc2_.firstAction;
                }
                _loc3_ = _loc2_;
                removeTrigger(_loc6_);
                _loc4_ = --_loc4_ + 1;
            }
            if(parent)
            {
                _loc2_ = new ActionDelete(this,param1,parent.getChildIndex(this));
                if(_loc3_)
                {
                    _loc3_.nextAction = _loc2_;
                }
                param1.removeRefSprite(this);
                return _loc2_;
            }
            return null;
        }
    }
}

