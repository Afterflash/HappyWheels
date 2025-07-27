package com.totaljerkface.game.editor.specials
{
    import com.totaljerkface.game.editor.*;
    import com.totaljerkface.game.editor.actions.*;
    import flash.geom.Point;
    import flash.utils.Dictionary;
    
    public class Special extends RefSprite
    {
        protected var _type:String;
        
        public function Special()
        {
            super();
            if(!_triggerString)
            {
                _triggerString = "triggerActionsSpecial";
            }
        }
        
        public function get type() : String
        {
            return this._type;
        }
        
        override public function clone() : RefSprite
        {
            var _loc1_:Special = new Special();
            _loc1_.x = x;
            _loc1_.y = y;
            return _loc1_;
        }
        
        override public function setProperty(param1:String, param2:*) : Action
        {
            var _loc3_:Action = null;
            var _loc4_:Action = null;
            var _loc9_:* = 0;
            var _loc10_:RefJoint = null;
            if((param1 == "immovable2" && param2 == true || param1 == "interactive" && param2 == false) && Boolean(_joints))
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
        
        override public function get groupable() : Boolean
        {
            if(_inGroup)
            {
                return false;
            }
            return _groupable;
        }
        
        public function get triggerActionsSpecial() : Dictionary
        {
            return _triggerActions;
        }
    }
}

