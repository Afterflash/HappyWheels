package com.totaljerkface.game.editor.actions
{
    import com.totaljerkface.game.editor.RefSprite;
    import flash.geom.Point;
    
    public class ActionTranslateUnbound extends Action
    {
        private var _startPoint:Point;
        
        private var _endPoint:Point;
        
        public function ActionTranslateUnbound(param1:RefSprite, param2:Point, param3:Point = null)
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
            trace("TRANSLATE UNBOUND UNDO " + refSprite.name);
            if(!this._endPoint)
            {
                this.setEndPoint();
            }
            refSprite.xUnbound = this._startPoint.x;
            refSprite.yUnbound = this._startPoint.y;
        }
        
        override public function redo() : void
        {
            trace("TRANSLATE UNBOUND REDO " + refSprite.name);
            trace("sp + " + this._startPoint);
            trace("ep + " + this._endPoint);
            refSprite.xUnbound = this._endPoint.x;
            refSprite.yUnbound = this._endPoint.y;
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

