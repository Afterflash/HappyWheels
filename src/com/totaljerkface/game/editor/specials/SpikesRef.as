package com.totaljerkface.game.editor.specials
{
    import com.totaljerkface.game.editor.*;
    import flash.display.*;
    import flash.utils.Dictionary;

    [Embed(source="/_assets/assets.swf", symbol="symbol1015")]
    public class SpikesRef extends Special
    {
        public var base:Sprite;

        public var spikes:Sprite;

        private var minSpikes:int = 20;

        private var maxSpikes:int = 150;

        protected var _immovable2:Boolean = true;

        protected var _sleeping:Boolean;

        private var _numSpikes:int = 20;

        public function SpikesRef()
        {
            _triggerable = true;
            _triggers = new Array();
            _triggerActions = new Dictionary();
            _triggerActionList = ["wake from sleep", "apply impulse"];
            _triggerActionListProperties = [null, ["impulseX", "impulseY", "spin"]];
            super();
            name = "spike set";
            _shapesUsed = 2;
            _rotatable = true;
            _scalable = false;
            _joinable = true;
            _groupable = true;
            _joints = new Array();
            _keyedPropertyObject[_triggerString] = _triggerActions;
        }

        override public function setAttributes():void
        {
            _type = "SpikesRef";
            _attributes = ["x", "y", "angle", "immovable2", "numSpikes", "sleeping"];
            addTriggerProperties();
        }

        override public function clone():RefSprite
        {
            var _loc1_:SpikesRef = new SpikesRef();
            _loc1_.x = x;
            _loc1_.y = y;
            _loc1_.angle = angle;
            _loc1_.numSpikes = this.numSpikes;
            _loc1_.immovable2 = this.immovable2;
            _loc1_.sleeping = this.sleeping;
            transferKeyedProperties(_loc1_);
            return _loc1_;
        }

        public function get numSpikes():int
        {
            return this._numSpikes;
        }

        public function set numSpikes(param1:int):void
        {
            var _loc3_:int = 0;
            var _loc4_:DisplayObject = null;
            if (param1 < this.minSpikes)
            {
                param1 = this.minSpikes;
            }
            if (param1 > this.maxSpikes)
            {
                param1 = this.maxSpikes;
            }
            var _loc2_:int = param1 - this._numSpikes;
            if (_loc2_ > 0)
            {
                _loc3_ = this._numSpikes;
                while (_loc3_ < param1)
                {
                    _loc4_ = new Spike();
                    this.spikes.addChild(_loc4_);
                    _loc4_.x = _loc3_ * 15;
                    _loc3_++;
                }
            }
            else if (_loc2_ < 0)
            {
                _loc3_ = _loc2_;
                while (_loc3_ < 0)
                {
                    _loc4_ = this.spikes.getChildAt(this.spikes.numChildren - 1);
                    this.spikes.removeChild(_loc4_);
                    _loc3_++;
                }
            }
            this.base.width = param1 * 15;
            this.spikes.x = this.base.width / -2;
            if (_selected)
            {
                drawBoundingBox();
            }
            x = x;
            y = y;
            this._numSpikes = param1;
        }

        public function get immovable2():Boolean
        {
            return this._immovable2;
        }

        public function set immovable2(param1:Boolean):void
        {
            if (param1 && _inGroup)
            {
                return;
            }
            this._immovable2 = param1;
        }

        override public function get joinable():Boolean
        {
            if (this._immovable2)
            {
                return false;
            }
            return _joinable;
        }

        override public function get groupable():Boolean
        {
            if (this._immovable2 || _inGroup)
            {
                return false;
            }
            return _groupable;
        }

        public function get sleeping():Boolean
        {
            return this._sleeping;
        }

        public function set sleeping(param1:Boolean):void
        {
            this._sleeping = param1;
        }
    }
}
