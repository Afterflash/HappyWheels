package com.totaljerkface.game.editor.specials
{
    import com.totaljerkface.game.editor.*;
    import com.totaljerkface.game.events.CanvasEvent;
    import flash.utils.Dictionary;

    [Embed(source="/_assets/assets.swf", symbol="symbol2815")]
    public class BoomboxRef extends Special
    {
        private var _interactive:Boolean = true;

        private var _sleeping:Boolean = false;

        public function BoomboxRef()
        {
            _triggerable = true;
            _triggers = new Array();
            _triggerActions = new Dictionary();
            _triggerActionList = ["wake from sleep", "apply impulse"];
            _triggerActionListProperties = [null, ["impulseX", "impulseY", "spin"]];
            super();
            name = "boombox";
            _shapesUsed = 2;
            _rotatable = true;
            _scalable = false;
            _joinable = true;
            _joints = new Array();
            _keyedPropertyObject[_triggerString] = _triggerActions;
        }

        override public function setAttributes():void
        {
            _type = "BoomboxRef";
            _attributes = ["x", "y", "angle", "sleeping", "interactive"];
            addTriggerProperties();
        }

        override public function clone():RefSprite
        {
            var _loc1_:BoomboxRef = null;
            _loc1_ = new BoomboxRef();
            _loc1_.x = x;
            _loc1_.y = y;
            _loc1_.angle = angle;
            _loc1_.interactive = this._interactive;
            _loc1_.groupable = _groupable;
            _loc1_.joinable = _joinable;
            _loc1_.sleeping = this._sleeping;
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
                _shapesUsed = 2;
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
    }
}
