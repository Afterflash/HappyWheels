package com.totaljerkface.game.editor.actions
{
    import com.totaljerkface.game.editor.EdgeShape;
    import flash.geom.Point;
    
    public class ActionReverseShape extends Action
    {
        private var _startPoint:Point;
        
        private var _endPoint:Point;
        
        private var _edgeShape:EdgeShape;
        
        public function ActionReverseShape(param1:EdgeShape, param2:Point = null, param3:Point = null)
        {
            super(null);
            this._edgeShape = param1;
            this._startPoint = param2;
            this._endPoint = param3;
        }
        
        override public function undo() : void
        {
            trace("MIRROR UNDO " + this._edgeShape.name);
            this._edgeShape.reverse();
            if(this._startPoint)
            {
                this._edgeShape.x = this._startPoint.x;
                this._edgeShape.y = this._startPoint.y;
            }
        }
        
        override public function redo() : void
        {
            trace("MIRROR REDO " + this._edgeShape.name);
            this._edgeShape.reverse();
            if(this._endPoint)
            {
                this._edgeShape.x = this._endPoint.x;
                this._edgeShape.y = this._endPoint.y;
            }
        }
    }
}

