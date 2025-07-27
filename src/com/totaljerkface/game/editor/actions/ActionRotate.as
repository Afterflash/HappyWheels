package com.totaljerkface.game.editor.actions
{
    import com.totaljerkface.game.editor.RefSprite;
    
    public class ActionRotate extends Action
    {
        private var _startAngle:Number;
        
        private var _endAngle:Number;
        
        public function ActionRotate(param1:RefSprite, param2:Number)
        {
            super(param1);
            this._startAngle = param2;
        }
        
        override public function undo() : void
        {
            trace("ROTATE UNDO " + refSprite.name);
            if(!this._endAngle)
            {
                this.setEndAngle();
            }
            refSprite.angle = this._startAngle;
        }
        
        override public function redo() : void
        {
            trace("ROTATE REDO " + refSprite.name);
            refSprite.angle = this._endAngle;
        }
        
        public function set endAngle(param1:Number) : void
        {
            this._endAngle = param1;
        }
        
        public function setEndAngle() : void
        {
            this._endAngle = refSprite.angle;
        }
    }
}

