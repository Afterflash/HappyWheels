package com.totaljerkface.game.editor.actions
{
    import com.totaljerkface.game.editor.RefSprite;
    import flash.geom.Point;
    
    public class ActionTranslate extends Action
    {
        private var _startPoint:Point;
        
        private var _endPoint:Point;
        
        public function ActionTranslate(param1:RefSprite, param2:Point, param3:Point = null)
        {
            super(param1);
            this._startPoint = param2;
            if(param3)
            {
                this._endPoint = param3;
            }
        }
        
        override public function undo() : void
        {
            trace("TRANSLATE UNDO " + refSprite.name);
            if(!this._endPoint)
            {
                this.setEndPoint();
            }
            refSprite.x = this._startPoint.x;
            refSprite.y = this._startPoint.y;
        }
        
        override public function redo() : void
        {
            trace("TRANSLATE REDO " + refSprite.name);
            trace("sp + " + this._startPoint);
            trace("ep + " + this._endPoint);
            refSprite.x = this._endPoint.x;
            refSprite.y = this._endPoint.y;
        }
        
        public function set endPoint(param1:Point) : void
        {
            this._endPoint = param1;
        }
        
        public function setEndPoint() : void
        {
            this._endPoint = new Point(refSprite.x,refSprite.y);
            trace("SET END POINT " + this._endPoint);
        }
    }
}

