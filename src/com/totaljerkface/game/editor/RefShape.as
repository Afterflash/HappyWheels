package com.totaljerkface.game.editor
{
    import com.totaljerkface.game.editor.actions.*;
    import com.totaljerkface.game.events.CanvasEvent;
    import flash.display.*;
    import flash.filters.GlowFilter;
    import flash.geom.Point;
    import flash.utils.Dictionary;
    
    public class RefShape extends RefSprite
    {
        protected static var handleGlowFilter:GlowFilter = new GlowFilter(52479,0.5,7,7,10,1);
        
        protected var _interactive:Boolean;
        
        protected var _density:Number;
        
        protected var _immovable:Boolean;
        
        protected var _sleeping:Boolean;
        
        protected var _vehicleHandle:Boolean = true;
        
        protected var _color:int;
        
        protected var _outlineColor:int;
        
        protected var _opacity:Number = 1;
        
        protected var _innerCutout:Number = 0;
        
        protected var _collision:int = 1;
        
        public var minDimension:Number = 0.05;
        
        public var maxDimension:Number = 50;
        
        protected var maxDensity:Number = 100;
        
        protected var minDensity:Number = 0.1;
        
        protected var minOpacity:Number = 0;
        
        protected var maxOpacity:Number = 100;
        
        public function RefShape(param1:Boolean, param2:Boolean, param3:Boolean = false, param4:Number = 5, param5:uint = 11184810, param6:int = -1, param7:Number = 100, param8:int = 0, param9:int = 0)
        {
            _joints = new Array();
            _triggers = new Array();
            _triggerActions = new Dictionary();
            _triggerActionList = ["wake from sleep","set to fixed","set to non fixed","change opacity","apply impulse","delete shape","delete self","change collision"];
            _triggerActionListProperties = [null,null,null,["newOpacities","opacityTimes"],["impulseX","impulseY","spin"],null,null,["newCollisions"]];
            super();
            this._interactive = param1;
            if(this._interactive)
            {
                _shapesUsed = 1;
                _artUsed = 0;
            }
            else
            {
                _shapesUsed = 0;
                _artUsed = 1;
            }
            this._immovable = param2;
            this._sleeping = param3;
            this._density = param4;
            this._color = param5;
            this._outlineColor = param6;
            this._opacity = param7 * 0.01;
            this._collision = param8;
            this._innerCutout = param9;
            _joinable = true;
            _groupable = true;
            _triggerable = true;
            _triggerString = "triggerActionsShape";
            _keyedPropertyObject[_triggerString] = _triggerActions;
            this.setAttributes();
            this.setFilters();
            this.drawShape();
        }
        
        override public function setAttributes() : void
        {
            if(this._interactive)
            {
                _attributes = ["x","y","shapeWidth","shapeHeight","angle","color","outlineColor","opacity","interactive","immovable","collision"];
            }
            else
            {
                _attributes = ["x","y","shapeWidth","shapeHeight","angle","color","outlineColor","opacity","interactive"];
            }
            addTriggerProperties();
        }
        
        override public function getFullProperties() : Array
        {
            return ["x","y","shapeWidth","shapeHeight","angle","immovable","sleeping","density","color","outlineColor","opacity","collision"];
        }
        
        override public function get functions() : Array
        {
            if(this.groupable)
            {
                return ["groupSelected"];
            }
            if(group is RefVehicle && this._interactive == true)
            {
                if(this.vehicleHandle)
                {
                    return ["removeHandleProperty"];
                }
                return ["setShapeAsHandle"];
            }
            return new Array();
        }
        
        protected function drawShape() : void
        {
        }
        
        public function getFlatSprite() : Sprite
        {
            return null;
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
            this._interactive = param1;
            this.setAttributes();
            this.setFilters();
            if(this._interactive)
            {
                _shapesUsed = 1;
                _artUsed = 0;
                dispatchEvent(new CanvasEvent(CanvasEvent.ART,-1));
                dispatchEvent(new CanvasEvent(CanvasEvent.SHAPE,1));
            }
            else
            {
                _shapesUsed = 0;
                _artUsed = 1;
                dispatchEvent(new CanvasEvent(CanvasEvent.SHAPE,-1));
                dispatchEvent(new CanvasEvent(CanvasEvent.ART,1));
            }
        }
        
        public function get density() : Number
        {
            return this._density;
        }
        
        public function set density(param1:Number) : void
        {
            if(param1 > this.maxDensity)
            {
                param1 = this.maxDensity;
            }
            if(param1 < this.minDensity)
            {
                param1 = this.minDensity;
            }
            this._density = param1;
        }
        
        public function get immovable() : Boolean
        {
            return this._immovable;
        }
        
        public function set immovable(param1:Boolean) : void
        {
            if(param1 && _inGroup)
            {
                return;
            }
            this._immovable = param1;
        }
        
        public function get sleeping() : Boolean
        {
            return this._sleeping;
        }
        
        public function set sleeping(param1:Boolean) : void
        {
            this._sleeping = param1;
        }
        
        public function get color() : int
        {
            return this._color;
        }
        
        public function set color(param1:int) : void
        {
            if(this._color == param1)
            {
                return;
            }
            this._color = param1;
            this.drawShape();
        }
        
        public function get outlineColor() : int
        {
            return this._outlineColor;
        }
        
        public function set outlineColor(param1:int) : void
        {
            if(this._outlineColor == param1)
            {
                return;
            }
            this._outlineColor = param1;
            this.drawShape();
        }
        
        public function get opacity() : Number
        {
            return Math.round(this._opacity * 100);
        }
        
        public function set opacity(param1:Number) : void
        {
            if(param1 < this.minOpacity)
            {
                param1 = this.minOpacity;
            }
            if(param1 > this.maxOpacity)
            {
                param1 = this.maxOpacity;
            }
            this._opacity = param1 * 0.01;
            this.drawShape();
        }
        
        public function get innerCutout() : int
        {
            return this._innerCutout;
        }
        
        public function set innerCutout(param1:int) : void
        {
            if(param1 < 0)
            {
                param1 = 0;
            }
            if(param1 > 100)
            {
                param1 = 100;
            }
            this._innerCutout = param1;
            this.drawShape();
        }
        
        public function get collision() : int
        {
            return this._collision;
        }
        
        public function set collision(param1:int) : void
        {
            if(param1 < 1)
            {
                param1 = 1;
            }
            if(param1 > 7)
            {
                param1 = 7;
            }
            this._collision = param1;
        }
        
        public function get vehicleHandle() : Boolean
        {
            return this._vehicleHandle;
        }
        
        public function set vehicleHandle(param1:Boolean) : void
        {
            this._vehicleHandle = param1;
            this.setFilters();
        }
        
        override public function get joinable() : Boolean
        {
            if(this._immovable || !this.interactive)
            {
                return false;
            }
            return _joinable;
        }
        
        override public function get groupable() : Boolean
        {
            if(this._interactive && this._immovable || _inGroup)
            {
                return false;
            }
            return _groupable;
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
            super.scaleX = param1;
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
            super.scaleY = param1;
        }
        
        override public function setFilters() : void
        {
            if(this._vehicleHandle && this._interactive && _group is RefVehicle && filters.length == 0)
            {
                filters = [handleGlowFilter];
            }
            else
            {
                filters = [];
            }
        }
        
        override public function setProperty(param1:String, param2:*) : Action
        {
            var _loc3_:Action = null;
            var _loc4_:Action = null;
            var _loc9_:* = 0;
            var _loc10_:RefJoint = null;
            if(param1 == "immovable" && param2 == true || param1 == "interactive" && param2 == false)
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
            else if(param1 == "interactive" && this._immovable && _inGroup)
            {
                this._immovable = false;
                _loc4_ = new ActionProperty(this,"immovable",true,false);
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
        
        override public function clone() : RefSprite
        {
            var _loc1_:RefShape = null;
            if(this is RectangleShape)
            {
                _loc1_ = new RectangleShape(this.interactive,this.immovable,this.sleeping,this.density,this.color,this.outlineColor,this.opacity,this.collision);
            }
            else if(this is CircleShape)
            {
                _loc1_ = new CircleShape(this.interactive,this.immovable,this.sleeping,this.density,this.color,this.outlineColor,this.opacity,this.collision);
            }
            else if(this is TriangleShape)
            {
                _loc1_ = new TriangleShape(this.interactive,this.immovable,this.sleeping,this.density,this.color,this.outlineColor,this.opacity,this.collision);
            }
            _loc1_.x = x;
            _loc1_.y = y;
            _loc1_.shapeWidth = shapeWidth;
            _loc1_.shapeHeight = shapeHeight;
            _loc1_.angle = angle;
            _loc1_.vehicleHandle = this.vehicleHandle;
            _loc1_.innerCutout = this.innerCutout;
            transferKeyedProperties(_loc1_);
            return _loc1_;
        }
        
        public function get triggerActionsShape() : Dictionary
        {
            return _triggerActions;
        }
    }
}

