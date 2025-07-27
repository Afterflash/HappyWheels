package com.totaljerkface.game.editor.actions
{
    import com.totaljerkface.game.editor.RefSprite;
    
    public class ActionScale extends Action
    {
        private var _startScaleX:Number;
        
        private var _startScaleY:Number;
        
        private var _endScaleX:Number;
        
        private var _endScaleY:Number;
        
        public function ActionScale(param1:RefSprite, param2:Number, param3:Number)
        {
            super(param1);
            this._startScaleX = param2;
            this._startScaleY = param3;
        }
        
        override public function undo() : void
        {
            trace("SCALE UNDO " + refSprite.name);
            if(!this._endScaleX)
            {
                this.setEndScale();
            }
            refSprite.scaleX = this._startScaleX;
            refSprite.scaleY = this._startScaleY;
        }
        
        override public function redo() : void
        {
            trace("SCALE REDO " + refSprite.name);
            refSprite.scaleX = this._endScaleX;
            refSprite.scaleY = this._endScaleY;
        }
        
        public function set endScaleX(param1:Number) : void
        {
            this._endScaleX = param1;
        }
        
        public function set endScaleY(param1:Number) : void
        {
            this._endScaleY = param1;
        }
        
        public function setEndScale() : void
        {
            this._endScaleX = refSprite.scaleX;
            this._endScaleY = refSprite.scaleY;
        }
    }
}

