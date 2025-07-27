package com.totaljerkface.game.editor.specials
{
    import com.totaljerkface.game.editor.*;
    import com.totaljerkface.game.events.CanvasEvent;
    import flash.display.Sprite;
    import flash.utils.Dictionary;

    [Embed(source="/_assets/assets.swf", symbol="symbol2694")]
    public class ChairRef extends Special
    {
        public var container:Sprite;

        private var _reverse:Boolean;

        private var _interactive:Boolean = true;

        private var _sleeping:Boolean = false;

        public function ChairRef()
        {
            _triggerable = true;
            _triggers = new Array();
            _triggerActions = new Dictionary();
            _triggerActionList = ["wake from sleep", "apply impulse"];
            _triggerActionListProperties = [null, ["impulseX", "impulseY", "spin"]];
            super();
            name = "chair";
            _shapesUsed = 4;
            _rotatable = true;
            _scalable = false;
            _joinable = true;
            _joints = new Array();
            _keyedPropertyObject[_triggerString] = _triggerActions;
        }

        override public function setAttributes():void
        {
            _type = "ChairRef";
            _attributes = ["x", "y", "angle", "reverse", "sleeping", "interactive"];
            addTriggerProperties();
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
                _shapesUsed = 4;
                _artUsed = 0;
                dispatchEvent(new CanvasEvent(CanvasEvent.ART, -1));
                dispatchEvent(new CanvasEvent(CanvasEvent.SHAPE, 4));
            }
            else
            {
                _groupable = true;
                _joinable = false;
                _shapesUsed = 0;
                _artUsed = 1;
                dispatchEvent(new CanvasEvent(CanvasEvent.SHAPE, -4));
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

        override public function clone():RefSprite
        {
            var _loc1_:ChairRef = new ChairRef();
            _loc1_.x = x;
            _loc1_.y = y;
            _loc1_.reverse = this.reverse;
            _loc1_.angle = angle;
            _loc1_.sleeping = this._sleeping;
            _loc1_.interactive = this._interactive;
            _loc1_.joinable = _joinable;
            transferKeyedProperties(_loc1_);
            return _loc1_;
        }

        public function get reverse():Boolean
        {
            return this._reverse;
        }

        public function set reverse(param1:Boolean):void
        {
            if (param1 == this._reverse)
            {
                return;
            }
            this._reverse = param1;
            if (this._reverse)
            {
                this.container.scaleX = -1;
            }
            else
            {
                this.container.scaleX = 1;
            }
            if (_selected)
            {
                drawBoundingBox();
            }
            x = x;
            y = y;
        }
    }
}
