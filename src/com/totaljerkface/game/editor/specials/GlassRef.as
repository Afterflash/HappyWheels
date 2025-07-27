package com.totaljerkface.game.editor.specials
{
    import com.totaljerkface.game.editor.*;
    import flash.utils.Dictionary;
    
    public class GlassRef extends Special
    {
        protected var minXDimension:Number = 0.05;
        
        protected var maxXDimension:Number = 0.5;
        
        protected var minYDimension:Number = 0.5;
        
        protected var maxYDimension:Number = 5;
        
        protected var minStrength:Number = 1;
        
        protected var maxStrength:Number = 10;
        
        private var _sleeping:Boolean;
        
        private var _shatterStrength:int = 10;
        
        private var _stabbing:Boolean = true;
        
        public function GlassRef()
        {
            _triggerable = true;
            _triggers = new Array();
            _triggerActions = new Dictionary();
            _triggerActionList = ["shatter","wake from sleep","apply impulse"];
            _triggerActionListProperties = [null,null,["impulseX","impulseY","spin"]];
            _triggerString = "triggerActionsGlass";
            super();
            name = "glass panel";
            _shapesUsed = 16;
            _rotatable = true;
            _scalable = true;
            _joinable = true;
            _joints = new Array();
            this.scaleX = 0.1;
            this.scaleY = 1;
            _keyedPropertyObject[_triggerString] = _triggerActions;
            this.drawShape();
        }
        
        override public function setAttributes() : void
        {
            _type = "GlassRef";
            _attributes = ["x","y","shapeWidth","shapeHeight","angle","sleeping","shatterStrength","stabbing"];
            addTriggerProperties();
        }
        
        override public function clone() : RefSprite
        {
            var _loc1_:GlassRef = null;
            _loc1_ = new GlassRef();
            _loc1_.x = x;
            _loc1_.y = y;
            _loc1_.angle = angle;
            _loc1_.scaleX = scaleX;
            _loc1_.scaleY = scaleY;
            _loc1_.sleeping = this.sleeping;
            _loc1_.shatterStrength = this.shatterStrength;
            _loc1_.stabbing = this.stabbing;
            transferKeyedProperties(_loc1_);
            return _loc1_;
        }
        
        protected function drawShape() : void
        {
            graphics.clear();
            graphics.beginFill(6737151,0.35);
            graphics.drawRect(-50,-50,100,100);
            graphics.endFill();
        }
        
        override public function set scaleX(param1:Number) : void
        {
            if(param1 < this.minXDimension)
            {
                param1 = this.minXDimension;
            }
            if(param1 > this.maxXDimension)
            {
                param1 = this.maxXDimension;
            }
            super.scaleX = param1;
        }
        
        override public function set scaleY(param1:Number) : void
        {
            if(param1 < this.minYDimension)
            {
                param1 = this.minYDimension;
            }
            if(param1 > this.maxYDimension)
            {
                param1 = this.maxYDimension;
            }
            super.scaleY = param1;
        }
        
        public function get sleeping() : Boolean
        {
            return this._sleeping;
        }
        
        public function set sleeping(param1:Boolean) : void
        {
            this._sleeping = param1;
        }
        
        public function get shatterStrength() : int
        {
            return this._shatterStrength;
        }
        
        public function set shatterStrength(param1:int) : void
        {
            if(param1 == 0)
            {
                param1 = 10;
            }
            if(param1 < this.minStrength)
            {
                param1 = this.minStrength;
            }
            if(param1 > this.maxStrength)
            {
                param1 = this.maxStrength;
            }
            this._shatterStrength = param1;
        }
        
        public function get stabbing() : Boolean
        {
            return this._stabbing;
        }
        
        public function set stabbing(param1:Boolean) : void
        {
            this._stabbing = param1;
        }
        
        public function get triggerActionsGlass() : Dictionary
        {
            return _triggerActions;
        }
    }
}

