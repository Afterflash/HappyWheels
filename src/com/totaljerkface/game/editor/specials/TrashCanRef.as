package com.totaljerkface.game.editor.specials
{
    import com.totaljerkface.game.editor.*;
    import com.totaljerkface.game.editor.actions.Action;
    import com.totaljerkface.game.editor.actions.ActionProperty;
    import com.totaljerkface.game.events.CanvasEvent;
    import flash.display.MovieClip;
    import flash.geom.Point;
    import flash.utils.Dictionary;

    [Embed(source="/_assets/assets.swf", symbol="symbol853")]
    public class TrashCanRef extends Special
    {
        public var lid:MovieClip;

        private var _bottleType:int = 1;

        private var _interactive:Boolean = true;

        private var _sleeping:Boolean = false;

        private var _containsTrash:Boolean = true;

        private var _lid:MovieClip;

        public function TrashCanRef()
        {
            _triggerable = true;
            _triggers = new Array();
            _triggerActions = new Dictionary();
            _triggerActionList = ["wake from sleep", "apply impulse"];
            _triggerActionListProperties = [null, ["impulseX", "impulseY", "spin"]];
            super();
            name = "trash can";
            this._lid = this.lid;
            _shapesUsed = 13;
            _rotatable = true;
            _scalable = false;
            _joinable = true;
            _joints = new Array();
            _keyedPropertyObject[_triggerString] = _triggerActions;
        }

        override public function setAttributes():void
        {
            _type = "TrashCanRef";
            _attributes = ["x", "y", "angle", "sleeping", "interactive", "containsTrash"];
            addTriggerProperties();
        }

        override public function clone():RefSprite
        {
            var _loc1_:TrashCanRef = new TrashCanRef();
            _loc1_.x = x;
            _loc1_.y = y;
            _loc1_.rotatable = _rotatable;
            _loc1_.angle = angle;
            _loc1_.interactive = this._interactive;
            _loc1_.groupable = _groupable;
            _loc1_.joinable = _joinable;
            _loc1_.sleeping = this._sleeping;
            _loc1_.containsTrash = this._containsTrash;
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
                _shapesUsed = 1;
                _artUsed = 0;
                dispatchEvent(new CanvasEvent(CanvasEvent.ART, -1));
                dispatchEvent(new CanvasEvent(CanvasEvent.SHAPE, 1));
            }
            else
            {
                _groupable = true;
                _joinable = false;
                _shapesUsed = 0;
                _artUsed = 1;
                dispatchEvent(new CanvasEvent(CanvasEvent.SHAPE, -1));
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

        public function get containsTrash():Boolean
        {
            return this._containsTrash;
        }

        public function set containsTrash(param1:Boolean):void
        {
            if (this._containsTrash == param1)
            {
                return;
            }
            if (param1)
            {
                addChild(this._lid);
            }
            else
            {
                removeChild(this._lid);
            }
            if (_selected)
            {
                drawBoundingBox();
            }
            this._containsTrash = param1;
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
    }
}
