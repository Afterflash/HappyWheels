package com.totaljerkface.game.editor.actions
{
    import com.totaljerkface.game.editor.*;
    import flash.display.*;
    import flash.geom.Point;
    
    public class ActionProperty extends Action
    {
        private var _startVal:*;
        
        private var _endVal:*;
        
        private var _startPoint:Point;
        
        private var _endPoint:Point;
        
        private var _property:String;
        
        public function ActionProperty(param1:RefSprite, param2:String, param3:*, param4:*, param5:Point = null, param6:Point = null)
        {
            super(param1);
            this._property = param2;
            this._startVal = param3;
            this._endVal = param4;
            this._startPoint = param5;
            this._endPoint = param6;
        }
        
        override public function undo() : void
        {
            trace("PROPERTY UNDO " + this._property + " " + refSprite.name);
            refSprite[this._property] = this._startVal;
            if(this._startPoint)
            {
                refSprite.x = this._startPoint.x;
                refSprite.y = this._startPoint.y;
            }
        }
        
        override public function redo() : void
        {
            trace("PROPERTY REDO " + this._property + " " + refSprite.name);
            refSprite[this._property] = this._endVal;
            if(this._endPoint)
            {
                refSprite.x = this._endPoint.x;
                refSprite.y = this._endPoint.y;
            }
        }
        
        public function set endVal(param1:*) : void
        {
            this._endVal = param1;
        }
        
        public function setEndVal() : void
        {
            this._endVal = refSprite[this._property];
        }
    }
}

