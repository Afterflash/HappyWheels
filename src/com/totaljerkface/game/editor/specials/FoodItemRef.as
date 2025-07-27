package com.totaljerkface.game.editor.specials
{
    import com.totaljerkface.game.editor.*;
    import com.totaljerkface.game.events.CanvasEvent;
    import flash.display.MovieClip;
    import flash.utils.Dictionary;

    [Embed(source="/_assets/assets.swf", symbol="symbol602")]
    public class FoodItemRef extends Special
    {
        public var container:MovieClip;

        private var _interactive:Boolean = true;

        private var _sleeping:Boolean = false;

        private var _foodType:int = 1;

        public function FoodItemRef()
        {
            _triggerable = true;
            _triggers = new Array();
            _triggerActions = new Dictionary();
            _triggerActionList = ["wake from sleep", "apply impulse"];
            _triggerActionListProperties = [null, ["impulseX", "impulseY", "spin"]];
            super();
            name = "food item";
            _shapesUsed = 3;
            _rotatable = true;
            _scalable = false;
            _joinable = true;
            _joints = new Array();
            _keyedPropertyObject[_triggerString] = _triggerActions;
            this.container.gotoAndStop(this._foodType);
        }

        override public function setAttributes():void
        {
            _type = "FoodItemRef";
            _attributes = ["x", "y", "angle", "sleeping", "interactive", "foodItemType"];
            addTriggerProperties();
        }

        override public function clone():RefSprite
        {
            var _loc1_:FoodItemRef = null;
            _loc1_ = new FoodItemRef();
            _loc1_.x = x;
            _loc1_.y = y;
            _loc1_.angle = angle;
            _loc1_.interactive = this._interactive;
            _loc1_.groupable = _groupable;
            _loc1_.joinable = _joinable;
            _loc1_.sleeping = this._sleeping;
            _loc1_.foodItemType = this._foodType;
            transferKeyedProperties(_loc1_);
            return _loc1_;
        }

        public function get interactive():Boolean
        {
            return this._interactive;
        }

        public function set interactive(param1:Boolean):void
        {
            if (this._interactive == param1)
            {
                return;
            }
            if (param1 && _inGroup)
            {
                return;
            }
            this._interactive = param1;
            if (this._interactive)
            {
                _groupable = false;
                _joinable = true;
                _shapesUsed = 3;
                _artUsed = 0;
                dispatchEvent(new CanvasEvent(CanvasEvent.ART, -1));
                dispatchEvent(new CanvasEvent(CanvasEvent.SHAPE, _shapesUsed));
            }
            else
            {
                _groupable = true;
                _joinable = false;
                _shapesUsed = 0;
                _artUsed = 1;
                dispatchEvent(new CanvasEvent(CanvasEvent.SHAPE, -_shapesUsed));
                dispatchEvent(new CanvasEvent(CanvasEvent.ART, 1));
            }
        }

        public function get sleeping():Boolean
        {
            return this._sleeping;
        }

        public function set sleeping(param1:Boolean):void
        {
            this._sleeping = param1;
        }

        public function get foodItemType():int
        {
            return this._foodType;
        }

        public function set foodItemType(param1:int):void
        {
            this._foodType = param1;
            this.container.gotoAndStop(param1);
            if (_selected)
            {
                drawBoundingBox();
            }
        }
    }
}
