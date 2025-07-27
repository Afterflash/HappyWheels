package com.totaljerkface.game.editor
{
    import com.totaljerkface.game.editor.actions.*;
    import com.totaljerkface.game.editor.trigger.RefTrigger;
    import flash.display.*;
    import flash.events.*;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.utils.Dictionary;
    
    public class RefSprite extends MovieClip
    {
        public static const COORDINATE_CHANGE:String = "coordinatechange";
        
        protected var _selected:Boolean;
        
        protected var boundingBox:Sprite;
        
        protected var _deletable:Boolean = true;
        
        protected var _cloneable:Boolean = true;
        
        protected var _rotatable:Boolean = true;
        
        protected var _scalable:Boolean = true;
        
        protected var _joinable:Boolean = false;
        
        protected var _groupable:Boolean = false;
        
        protected var _inGroup:Boolean = false;
        
        protected var _triggerable:Boolean = false;
        
        protected var _attributes:Array;
        
        protected var _joints:Array;
        
        protected var _triggers:Array;
        
        protected var _triggerActionList:Array;
        
        protected var _triggerActionListProperties:Array;
        
        protected var _triggerActions:Dictionary;
        
        protected var _triggerString:String;
        
        protected var _keyedPropertyObject:Object;
        
        protected var _shapesUsed:int = 0;
        
        protected var _artUsed:int = 0;
        
        protected var _group:RefGroup;
        
        public function RefSprite()
        {
            super();
            this.boundingBox = new Sprite();
            addChild(this.boundingBox);
            mouseChildren = false;
            this._keyedPropertyObject = new Object();
            this.setAttributes();
        }
        
        public function setAttributes() : void
        {
            this._attributes = ["x","y"];
        }
        
        public function get attributes() : Array
        {
            return this._attributes;
        }
        
        public function get functions() : Array
        {
            if(this.groupable)
            {
                return ["groupSelected"];
            }
            return new Array();
        }
        
        public function getFullProperties() : Array
        {
            return this._attributes;
        }
        
        protected function addTriggerProperties() : void
        {
            var _loc2_:RefTrigger = null;
            var _loc3_:Array = null;
            var _loc4_:int = 0;
            var _loc5_:String = null;
            var _loc6_:int = 0;
            var _loc7_:Array = null;
            var _loc8_:int = 0;
            var _loc9_:String = null;
            var _loc10_:Dictionary = null;
            var _loc11_:Array = null;
            var _loc1_:int = 0;
            while(_loc1_ < this._triggers.length)
            {
                _loc2_ = this._triggers[_loc1_];
                if(_loc2_.typeIndex == 1)
                {
                    _loc3_ = this._triggerActions[_loc2_];
                    if(!_loc3_)
                    {
                        _loc3_ = this._triggerActions[_loc2_] = new Array();
                        _loc3_.push(this._triggerActionList[0]);
                    }
                    _loc4_ = 0;
                    while(_loc4_ < _loc3_.length)
                    {
                        this._attributes.push([this._triggerString,_loc2_,_loc4_]);
                        _loc5_ = _loc3_[_loc4_];
                        _loc6_ = int(this.triggerActionList.indexOf(_loc5_));
                        _loc7_ = this.triggerActionListProperties[_loc6_];
                        if(_loc7_)
                        {
                            _loc8_ = 0;
                            while(_loc8_ < _loc7_.length)
                            {
                                _loc9_ = _loc7_[_loc8_];
                                _loc10_ = this._keyedPropertyObject[_loc9_];
                                if(!_loc10_)
                                {
                                    _loc10_ = this._keyedPropertyObject[_loc9_] = new Dictionary();
                                }
                                _loc11_ = _loc10_[_loc2_];
                                if(!_loc11_)
                                {
                                    _loc11_ = _loc10_[_loc2_] = new Array();
                                }
                                if(!_loc11_[_loc4_])
                                {
                                    _loc11_[_loc4_] = AttributeReference.getDefaultValue(_loc9_);
                                }
                                this._attributes.push([_loc9_,_loc2_,_loc4_]);
                                _loc8_++;
                            }
                        }
                        _loc4_++;
                    }
                }
                _loc1_++;
            }
        }
        
        public function get shapesUsed() : int
        {
            return this._shapesUsed;
        }
        
        public function get artUsed() : int
        {
            return this._artUsed;
        }
        
        public function get selected() : Boolean
        {
            return this._selected;
        }
        
        public function set selected(param1:Boolean) : void
        {
            this._selected = param1;
            if(param1)
            {
                this.drawBoundingBox();
                alpha = 0.8;
            }
            else
            {
                this.clearBoundingBox();
                alpha = 1;
            }
        }
        
        public function get deletable() : Boolean
        {
            return this._deletable;
        }
        
        public function set deletable(param1:Boolean) : void
        {
            this._deletable = param1;
        }
        
        public function get cloneable() : Boolean
        {
            return this._cloneable;
        }
        
        public function set cloneable(param1:Boolean) : void
        {
            this._cloneable = param1;
        }
        
        public function get rotatable() : Boolean
        {
            return this._rotatable;
        }
        
        public function set rotatable(param1:Boolean) : void
        {
            this._rotatable = param1;
        }
        
        public function get scalable() : Boolean
        {
            return this._scalable;
        }
        
        public function set scalable(param1:Boolean) : void
        {
            this._scalable = param1;
        }
        
        public function get joinable() : Boolean
        {
            return this._joinable;
        }
        
        public function set joinable(param1:Boolean) : void
        {
            this._joinable = param1;
        }
        
        public function get group() : RefGroup
        {
            return this._group;
        }
        
        public function set group(param1:RefGroup) : void
        {
            this._group = param1;
        }
        
        public function get groupable() : Boolean
        {
            return this._groupable;
        }
        
        public function set groupable(param1:Boolean) : void
        {
            this._groupable = param1;
        }
        
        public function get inGroup() : Boolean
        {
            return this._inGroup;
        }
        
        public function set inGroup(param1:Boolean) : void
        {
            this._inGroup = param1;
        }
        
        public function get triggerable() : Boolean
        {
            return this._triggerable;
        }
        
        public function set triggerable(param1:Boolean) : void
        {
            this._triggerable = param1;
        }
        
        public function get joints() : Array
        {
            return this._joints;
        }
        
        public function get triggers() : Array
        {
            return this._triggers;
        }
        
        public function get triggerActions() : Dictionary
        {
            return this._triggerActions;
        }
        
        public function get triggerActionList() : Array
        {
            return this._triggerActionList;
        }
        
        public function get triggerActionListProperties() : Array
        {
            return this._triggerActionListProperties;
        }
        
        public function addJoint(param1:RefJoint) : void
        {
            this._joints.push(param1);
        }
        
        public function addTrigger(param1:RefTrigger) : void
        {
            var _loc5_:RefTrigger = null;
            var _loc6_:int = 0;
            var _loc2_:int = int(this._triggers.length);
            var _loc3_:int = param1.parent.getChildIndex(param1);
            var _loc4_:int = 0;
            while(_loc4_ < _loc2_)
            {
                _loc5_ = this._triggers[_loc4_];
                _loc6_ = _loc5_.parent.getChildIndex(_loc5_);
                if(_loc6_ > _loc3_)
                {
                    this._triggers.splice(_loc4_,0,param1);
                    this.setAttributes();
                    return;
                }
                _loc4_++;
            }
            this._triggers.push(param1);
            this.setAttributes();
        }
        
        public function removeJoint(param1:RefJoint) : void
        {
            var _loc2_:int = int(this._joints.indexOf(param1));
            this._joints.splice(_loc2_,1);
            if(_loc2_ < 0)
            {
                throw new Error("FUCK YOU joint not found");
            }
        }
        
        public function removeTrigger(param1:RefTrigger) : void
        {
            var _loc2_:int = int(this._triggers.indexOf(param1));
            this._triggers.splice(_loc2_,1);
            if(_loc2_ < 0)
            {
                throw new Error("FUCK YOU trigger not found");
            }
            this.setAttributes();
        }
        
        public function drawBoundingBox() : void
        {
            this.boundingBox.graphics.clear();
            var _loc1_:Rectangle = getBounds(this);
            var _loc2_:uint = doubleClickEnabled ? 52223 : 0;
            this.boundingBox.graphics.lineStyle(0,_loc2_,1,true);
            this.boundingBox.graphics.drawRect(_loc1_.x,_loc1_.y,_loc1_.width,_loc1_.height);
        }
        
        public function clearBoundingBox() : void
        {
            this.boundingBox.graphics.clear();
        }
        
        public function deleteSelf(param1:Canvas) : Action
        {
            var _loc2_:Action = null;
            var _loc3_:Action = null;
            var _loc4_:* = 0;
            var _loc5_:RefJoint = null;
            var _loc6_:RefTrigger = null;
            if(this.deletable && Boolean(parent))
            {
                if(this._joints)
                {
                    _loc4_ = 0;
                    while(_loc4_ < this._joints.length)
                    {
                        _loc5_ = this._joints[_loc4_];
                        _loc2_ = _loc5_.removeBody(this);
                        if(_loc3_)
                        {
                            _loc3_.nextAction = _loc2_.firstAction;
                        }
                        _loc3_ = _loc2_;
                        this.removeJoint(_loc5_);
                        _loc4_ = --_loc4_ + 1;
                    }
                }
                if(this._triggers)
                {
                    _loc4_ = 0;
                    while(_loc4_ < this._triggers.length)
                    {
                        _loc6_ = this._triggers[_loc4_];
                        _loc2_ = _loc6_.removeTarget(this);
                        if(_loc3_)
                        {
                            _loc3_.nextAction = _loc2_.firstAction;
                        }
                        _loc3_ = _loc2_;
                        this.removeTrigger(_loc6_);
                        _loc4_ = --_loc4_ + 1;
                    }
                }
                _loc2_ = new ActionDelete(this,param1,parent.getChildIndex(this));
                if(_loc3_)
                {
                    _loc3_.nextAction = _loc2_;
                }
                param1.removeRefSprite(this);
                if(param1 is GroupCanvas)
                {
                    this.inGroup = false;
                }
                return _loc2_;
            }
            return null;
        }
        
        public function clone() : RefSprite
        {
            return null;
        }
        
        public function transferKeyedProperties(param1:RefSprite) : void
        {
            var _loc2_:String = null;
            var _loc3_:Dictionary = null;
            var _loc4_:Array = null;
            var _loc5_:Array = null;
            var _loc6_:Dictionary = null;
            var _loc7_:* = undefined;
            var _loc8_:int = 0;
            var _loc9_:int = 0;
            for(_loc2_ in this._keyedPropertyObject)
            {
                _loc3_ = this._keyedPropertyObject[_loc2_];
                if(_loc3_)
                {
                    _loc6_ = param1.keyedPropertyObject[_loc2_];
                    if(!_loc6_)
                    {
                        _loc6_ = param1.keyedPropertyObject[_loc2_] = new Dictionary();
                    }
                    for(_loc7_ in _loc3_)
                    {
                        _loc4_ = _loc3_[_loc7_];
                        _loc5_ = new Array();
                        _loc8_ = int(_loc4_.length);
                        _loc9_ = 0;
                        while(_loc9_ < _loc8_)
                        {
                            _loc5_.push(_loc4_[_loc9_]);
                            _loc9_++;
                        }
                        _loc6_[_loc7_] = _loc5_;
                    }
                }
            }
        }
        
        override public function set x(param1:Number) : void
        {
            var _loc3_:Number = NaN;
            super.x = param1;
            if(!parent)
            {
                return;
            }
            var _loc2_:Rectangle = getBounds(parent);
            if(_loc2_.x < 0)
            {
                _loc3_ = 0 - _loc2_.x;
                param1 += _loc3_;
            }
            else if(_loc2_.x + _loc2_.width > Canvas.canvasWidth)
            {
                _loc3_ = Canvas.canvasWidth - (_loc2_.x + _loc2_.width);
                param1 += _loc3_;
            }
            super.x = param1;
            if(this._joinable || this._triggerable)
            {
                dispatchEvent(new Event(COORDINATE_CHANGE));
            }
        }
        
        override public function set y(param1:Number) : void
        {
            var _loc3_:Number = NaN;
            super.y = param1;
            if(!parent)
            {
                return;
            }
            var _loc2_:Rectangle = getBounds(parent);
            if(_loc2_.y < 0)
            {
                _loc3_ = 0 - _loc2_.y;
                param1 += _loc3_;
            }
            else if(_loc2_.y + _loc2_.height > Canvas.canvasHeight)
            {
                _loc3_ = Canvas.canvasHeight - (_loc2_.y + _loc2_.height);
                param1 += _loc3_;
            }
            super.y = param1;
            if(this._joinable || this._triggerable)
            {
                dispatchEvent(new Event(COORDINATE_CHANGE));
            }
        }
        
        public function set xUnbound(param1:Number) : void
        {
            super.x = param1;
        }
        
        public function set yUnbound(param1:Number) : void
        {
            super.y = param1;
        }
        
        public function set angleUnbound(param1:Number) : void
        {
            rotation = param1;
        }
        
        override public function set scaleX(param1:Number) : void
        {
            super.scaleX = param1;
            this.x = x;
            this.y = y;
        }
        
        override public function set scaleY(param1:Number) : void
        {
            super.scaleY = param1;
            this.x = x;
            this.y = y;
        }
        
        public function get angle() : Number
        {
            return rotation;
        }
        
        public function set angle(param1:Number) : void
        {
            rotation = param1;
            this.x = x;
            this.y = y;
        }
        
        public function get shapeWidth() : Number
        {
            return Math.round(scaleX * 100);
        }
        
        public function set shapeWidth(param1:Number) : void
        {
            this.scaleX = param1 / 100;
        }
        
        public function get shapeHeight() : Number
        {
            return Math.round(scaleY * 100);
        }
        
        public function set shapeHeight(param1:Number) : void
        {
            this.scaleY = param1 / 100;
        }
        
        public function setFilters() : void
        {
        }
        
        public function checkVehicleAttached(param1:Array = null) : Boolean
        {
            var _loc3_:RefJoint = null;
            var _loc4_:int = 0;
            var _loc5_:RefSprite = null;
            var _loc6_:RefSprite = null;
            if(!this.joints)
            {
                return false;
            }
            if(!param1)
            {
                param1 = new Array();
            }
            var _loc2_:int = 0;
            while(_loc2_ < this.joints.length)
            {
                _loc3_ = this.joints[_loc2_];
                _loc4_ = int(param1.indexOf(_loc3_));
                if(_loc4_ < 0)
                {
                    param1.push(_loc3_);
                    _loc5_ = _loc3_.body1;
                    if((Boolean(_loc5_)) && this != _loc5_)
                    {
                        if(_loc5_.checkVehicleAttached(param1))
                        {
                            return true;
                        }
                    }
                    _loc6_ = _loc3_.body2;
                    if((Boolean(_loc6_)) && this != _loc6_)
                    {
                        if(_loc6_.checkVehicleAttached(param1))
                        {
                            return true;
                        }
                    }
                }
                _loc2_++;
            }
            return false;
        }
        
        public function setProperty(param1:String, param2:*) : Action
        {
            var _loc3_:Action = null;
            var _loc4_:* = this[param1];
            var _loc5_:Point = new Point(x,y);
            this[param1] = param2;
            var _loc6_:* = this[param1];
            var _loc7_:Point = new Point(x,y);
            if(_loc6_ != _loc4_)
            {
                _loc3_ = new ActionProperty(this,param1,_loc4_,_loc6_,_loc5_,_loc7_);
            }
            return _loc3_;
        }
        
        public function setKeyedProperty(param1:String, param2:Object, param3:int, param4:*) : Action
        {
            var _loc5_:Action = null;
            trace("SET Keyed PROPERTY " + param2 + " " + param3 + " " + param4);
            var _loc6_:* = this._keyedPropertyObject[param1][param2][param3];
            trace("startVal " + _loc6_);
            trace("value " + param4);
            this._keyedPropertyObject[param1][param2][param3] = param4;
            var _loc7_:* = this._keyedPropertyObject[param1][param2][param3];
            trace("array " + this._keyedPropertyObject[param1][param2]);
            if(_loc7_ != _loc6_)
            {
                _loc5_ = new ActionKeyedProperty(this,param1,_loc6_,_loc7_,param2,param3);
            }
            this.setAttributes();
            return _loc5_;
        }
        
        public function get keyedPropertyObject() : Object
        {
            return this._keyedPropertyObject;
        }
        
        public function get triggerString() : String
        {
            return this._triggerString;
        }
    }
}

