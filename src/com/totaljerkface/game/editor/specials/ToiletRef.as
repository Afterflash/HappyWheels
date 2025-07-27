package com.totaljerkface.game.editor.specials
{
    import com.totaljerkface.game.editor.*;
    import com.totaljerkface.game.editor.actions.Action;
    import com.totaljerkface.game.editor.actions.ActionProperty;
    import com.totaljerkface.game.events.CanvasEvent;
    import flash.display.Sprite;
    import flash.geom.Point;
    import flash.utils.Dictionary;

    [Embed(source="/_assets/assets.swf", symbol="symbol920")]
    public class ToiletRef extends Special
    {
        public var container:Sprite;

        private var _reverse:Boolean;

        private var _interactive:Boolean = true;

        private var _sleeping:Boolean = false;

        public function ToiletRef()
        {
            _triggerable = true;
            _triggers = new Array();
            _triggerActions = new Dictionary();
            _triggerActionList = ["wake from sleep", "apply impulse"];
            _triggerActionListProperties = [null, ["impulseX", "impulseY", "spin"]];
            super();
            name = "toilet";
            _shapesUsed = 5;
            _rotatable = true;
            _scalable = false;
            _joinable = true;
            _joints = new Array();
            _keyedPropertyObject[_triggerString] = _triggerActions;
        }

        override public function setAttributes():void
        {
            _type = "ToiletRef";
            _attributes = ["x", "y", "angle", "reverse", "sleeping", "interactive"];
            addTriggerProperties();
        }

        override public function clone():RefSprite
        {
            var _loc1_:ToiletRef = null;
            _loc1_ = new ToiletRef();
            _loc1_.x = x;
            _loc1_.y = y;
            _loc1_.angle = angle;
            _loc1_.reverse = this.reverse;
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
                _shapesUsed = 5;
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

        override public function setProperty(param1:String, param2:*):Action
        {
            var _loc3_:Action = null;
            var _loc4_:Action = null;
            var _loc9_:* = 0;
            var _loc10_:RefJoint = null;
            if (param1 == "interactive" && param2 == false && Boolean(_joints))
            {
                _loc9_ = 0;
                while (_loc9_ < _joints.length)
                {
                    _loc10_ = _joints[_loc9_];
                    _loc3_ = _loc10_.removeBody(this);
                    if (_loc4_)
                    {
                        _loc4_.nextAction = _loc3_.firstAction;
                    }
                    _loc4_ = _loc3_;
                    removeJoint(_loc10_);
                    _loc9_ = --_loc9_ + 1;
                }
            }
            var _loc5_:* = this[param1];
            var _loc6_:Point = new Point(x, y);
            this[param1] = param2;
            var _loc7_:* = this[param1];
            var _loc8_:Point = new Point(x, y);
            if (_loc7_ != _loc5_)
            {
                _loc3_ = new ActionProperty(this, param1, _loc5_, _loc7_, _loc6_, _loc8_);
                if (_loc4_)
                {
                    _loc4_.nextAction = _loc3_;
                }
            }
            return _loc3_;
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
