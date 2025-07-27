package com.totaljerkface.game.editor.actions
{
    import com.totaljerkface.game.editor.*;
    import flash.display.*;
    
    public class ActionKeyedProperty extends Action
    {
        private var _startVal:*;
        
        private var _endVal:*;
        
        private var _key:Object;
        
        private var _property:String;
        
        private var _index:int;
        
        public function ActionKeyedProperty(param1:RefSprite, param2:String, param3:*, param4:*, param5:Object, param6:int)
        {
            super(param1);
            this._property = param2;
            this._startVal = param3;
            this._endVal = param4;
            this._key = param5;
            this._index = param6;
        }
        
        override public function undo() : void
        {
            trace("KEYED PROPERTY UNDO " + this._property + " " + this._key + " " + refSprite.name);
            refSprite.keyedPropertyObject[this._property][this._key][this._index] = this._startVal;
            refSprite.setAttributes();
        }
        
        override public function redo() : void
        {
            trace("KEYED PROPERTY REDO " + this._property + " " + this._key + " " + refSprite.name);
            refSprite.keyedPropertyObject[this._property][this._key][this._index] = this._endVal;
            refSprite.setAttributes();
        }
        
        public function set endVal(param1:*) : void
        {
            this._endVal = param1;
        }
        
        public function setEndVal() : void
        {
            this._endVal = refSprite.keyedPropertyObject[this._property][this._key][this._index];
        }
    }
}

