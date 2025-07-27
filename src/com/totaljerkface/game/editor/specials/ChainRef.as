package com.totaljerkface.game.editor.specials
{
    import com.totaljerkface.game.editor.*;
    import com.totaljerkface.game.events.CanvasEvent;
    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.utils.Dictionary;
    
    public class ChainRef extends Special
    {
        public var container:Sprite;
        
        private var baseAngle:int = 90;
        
        private var baseLinkThickness:int = 3;
        
        private var linkThickness:int;
        
        private var baseLinkHeight:int = 15;
        
        private var linkHeight:int;
        
        private var _interactive:Boolean = true;
        
        private var _sleeping:Boolean = false;
        
        private var _linkAngle:Number = 0;
        
        private var _linkScale:Number = 1;
        
        private var _linkCount:int = 20;
        
        private var _linkMCs:Array = [];
        
        private var _points:Array = [];
        
        public function ChainRef()
        {
            _triggerable = true;
            _triggers = new Array();
            _triggerActions = new Dictionary();
            _triggerActionList = ["wake from sleep","apply impulse"];
            _triggerActionListProperties = [null,["impulseX","impulseY"]];
            super();
            name = "chain";
            _shapesUsed = this._linkCount;
            _artUsed = 0;
            _rotatable = true;
            _scalable = true;
            _joinable = true;
            _joints = new Array();
            _keyedPropertyObject[_triggerString] = _triggerActions;
            this.container = new Sprite();
            addChild(this.container);
            this.addLinks();
        }
        
        private function addLinks() : void
        {
            var _loc1_:Number = NaN;
            var _loc2_:Number = NaN;
            var _loc6_:Number = NaN;
            var _loc7_:Number = NaN;
            var _loc8_:Array = null;
            var _loc12_:Number = NaN;
            var _loc13_:Number = NaN;
            var _loc14_:MovieClip = null;
            this.clearLinks();
            _loc1_ = 1 + (this._linkScale - 1) / 9 * 2;
            _loc2_ = -(this._linkAngle / 10 * (360 / (this._linkCount * 2)));
            _shapesUsed = this._linkCount;
            var _loc3_:Number = 180 / Math.PI;
            var _loc4_:Number = this.baseAngle / _loc3_;
            var _loc5_:Number = _loc2_ / _loc3_;
            _loc8_ = [0,0];
            this._points = [_loc8_];
            var _loc9_:Number = (this.baseLinkHeight - this.baseLinkThickness * 2) * _loc1_;
            var _loc10_:int = this.container.numChildren;
            var _loc11_:int = 0;
            while(_loc11_ < this._linkCount)
            {
                _loc6_ = _loc4_ + ((_loc11_ + 1) * _loc5_ - _loc5_ * 0.5);
                _loc7_ = _loc6_ * _loc3_;
                _loc12_ = Math.cos(_loc6_) * _loc9_;
                _loc13_ = Math.sin(_loc6_) * _loc9_;
                if(_loc11_ % 2 == 0)
                {
                    _loc14_ = new link0MC();
                    this.container.addChildAt(_loc14_,Math.max(0,_loc10_));
                }
                else
                {
                    _loc14_ = new link1MC();
                    this.container.addChildAt(_loc14_,_loc10_ + 1);
                }
                _loc14_.scaleX = _loc14_.scaleY = _loc1_;
                _loc14_.rotation = _loc7_ - 90;
                _loc14_.x = _loc8_[0] + _loc12_ / 2;
                _loc14_.y = _loc8_[1] + _loc13_ / 2;
                this._linkMCs.push(_loc14_);
                _loc8_[0] += _loc12_;
                _loc8_[1] += _loc13_;
                _loc10_ = _loc14_.parent.getChildIndex(_loc14_);
                this._points.push(_loc8_);
                _loc11_++;
            }
            if(_selected)
            {
                drawBoundingBox();
            }
        }
        
        private function clearLinks() : void
        {
            var _loc1_:int = 0;
            while(_loc1_ < this._linkMCs.length)
            {
                this.container.removeChild(this._linkMCs[_loc1_]);
                _loc1_++;
            }
            this._linkMCs = [];
        }
        
        override public function setAttributes() : void
        {
            _type = "ChainRef";
            _attributes = ["x","y","angle","sleeping","interactive","linkCount","linkScale","linkAngle"];
            addTriggerProperties();
        }
        
        override public function clone() : RefSprite
        {
            var _loc1_:ChainRef = null;
            _loc1_ = new ChainRef();
            _loc1_.x = x;
            _loc1_.y = y;
            _loc1_.rotatable = _rotatable;
            _loc1_.angle = angle;
            _loc1_.interactive = this._interactive;
            _loc1_.groupable = _groupable;
            _loc1_.joinable = _joinable;
            _loc1_.sleeping = this._sleeping;
            _loc1_.linkScale = this._linkScale;
            _loc1_.linkAngle = this._linkAngle;
            _loc1_.linkCount = this._linkCount;
            transferKeyedProperties(_loc1_);
            return _loc1_;
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
            if(this._interactive)
            {
                _joinable = true;
                _shapesUsed = this._linkCount;
                _artUsed = 0;
                dispatchEvent(new CanvasEvent(CanvasEvent.ART,-this._linkCount));
                dispatchEvent(new CanvasEvent(CanvasEvent.SHAPE,this._linkCount));
            }
            else
            {
                _joinable = false;
                _shapesUsed = 0;
                _artUsed = this._linkCount;
                dispatchEvent(new CanvasEvent(CanvasEvent.SHAPE,-this._linkCount));
                dispatchEvent(new CanvasEvent(CanvasEvent.ART,this._linkCount));
            }
        }
        
        public function get sleeping() : Boolean
        {
            return this._sleeping;
        }
        
        public function set sleeping(param1:Boolean) : void
        {
            this._sleeping = param1;
        }
        
        public function get linkScale() : Number
        {
            return this._linkScale;
        }
        
        public function set linkScale(param1:Number) : void
        {
            if(param1 < 1)
            {
                param1 = 1;
            }
            if(param1 > 10)
            {
                param1 = 10;
            }
            this._linkScale = param1;
            this.addLinks();
        }
        
        public function get linkAngle() : Number
        {
            return this._linkAngle;
        }
        
        public function set linkAngle(param1:Number) : void
        {
            if(param1 < -10)
            {
                param1 = -10;
            }
            if(param1 > 10)
            {
                param1 = 10;
            }
            this._linkAngle = param1;
            this.addLinks();
        }
        
        public function set linkCount(param1:Number) : void
        {
            if(param1 < 2)
            {
                param1 = 2;
            }
            if(param1 > 40)
            {
                param1 = 40;
            }
            var _loc2_:int = param1 - this._linkCount;
            dispatchEvent(new CanvasEvent(CanvasEvent.SHAPE,_loc2_));
            this._linkCount = param1;
            this.addLinks();
        }
        
        public function get linkCount() : Number
        {
            return this._linkCount;
        }
        
        public function get linkMCs() : Array
        {
            return this._linkMCs;
        }
        
        public function set linkMCs(param1:Array) : void
        {
            this._linkMCs = param1;
        }
        
        public function get points() : Array
        {
            return this._points;
        }
        
        public function set points(param1:Array) : void
        {
            this._points = param1;
        }
    }
}

