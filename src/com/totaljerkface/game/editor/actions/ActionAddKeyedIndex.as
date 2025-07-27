package com.totaljerkface.game.editor.actions
{
    import com.totaljerkface.game.editor.*;
    import flash.display.*;
    import flash.utils.Dictionary;
    
    public class ActionAddKeyedIndex extends Action
    {
        private var _key:Object;
        
        private var _property:String;
        
        private var _index:int;
        
        public function ActionAddKeyedIndex(param1:RefSprite, param2:String, param3:Object, param4:int)
        {
            super(param1);
            this._property = param2;
            this._key = param3;
            this._index = param4;
        }
        
        override public function undo() : void
        {
            var _loc4_:int = 0;
            var _loc5_:Array = null;
            var _loc6_:int = 0;
            var _loc7_:String = null;
            var _loc8_:Dictionary = null;
            var _loc9_:Array = null;
            trace("ADD KEYED INDEX UNDO " + this._property + " " + this._key + " " + refSprite.name);
            var _loc1_:Dictionary = refSprite.keyedPropertyObject[this._property];
            var _loc2_:Array = _loc1_[this._key];
            var _loc3_:int = int(_loc2_.length);
            if(_loc3_ > 1)
            {
                _loc2_.splice(this._index,1);
                _loc4_ = 0;
                while(_loc4_ < refSprite.triggerActionList.length)
                {
                    _loc5_ = refSprite.triggerActionListProperties[_loc4_];
                    if(_loc5_)
                    {
                        _loc6_ = 0;
                        while(_loc6_ < _loc5_.length)
                        {
                            _loc7_ = _loc5_[_loc6_];
                            _loc8_ = refSprite.keyedPropertyObject[_loc7_];
                            if(_loc8_)
                            {
                                _loc9_ = _loc8_[this._key];
                                if(_loc9_)
                                {
                                    _loc9_.splice(this._index,1);
                                    trace(_loc9_);
                                }
                            }
                            _loc6_++;
                        }
                    }
                    _loc4_++;
                }
                refSprite.setAttributes();
            }
        }
        
        override public function redo() : void
        {
            trace("ADD KEYED INDEX REDO " + this._property + " " + this._key + " " + refSprite.name);
            var _loc1_:Dictionary = refSprite.keyedPropertyObject[this._property];
            var _loc2_:Array = _loc1_[this._key];
            _loc2_.push(refSprite.triggerActionList[0]);
            refSprite.setAttributes();
        }
    }
}

