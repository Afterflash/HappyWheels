package com.totaljerkface.game.editor.actions
{
    import Box2D.Common.Math.b2Vec2;
    import com.totaljerkface.game.editor.*;
    import com.totaljerkface.game.editor.vertedit.Vert;
    import flash.display.*;
    import flash.geom.Point;
    
    public class ActionMoveVert extends Action
    {
        private var _vertIndex:int;
        
        private var _edgeShape:EdgeShape;
        
        private var _startPoint:Point;
        
        private var _endPoint:Point;
        
        public function ActionMoveVert(param1:int, param2:EdgeShape, param3:Point, param4:Point = null)
        {
            super(null);
            this._vertIndex = param1;
            this._edgeShape = param2;
            this._startPoint = param3;
            if(param4)
            {
                this._endPoint = param4;
            }
        }
        
        override public function undo() : void
        {
            var _loc1_:Vert = null;
            trace("MOVE VERT UNDO " + this._vertIndex);
            _loc1_ = this._edgeShape.getVertAt(this._vertIndex);
            if(!this._endPoint)
            {
                this.setEndPoint();
            }
            _loc1_.x = this._startPoint.x;
            _loc1_.y = this._startPoint.y;
            var _loc2_:b2Vec2 = this._edgeShape.vertVector[0];
            this._edgeShape.drawEditMode(_loc2_,this._edgeShape.completeFill);
        }
        
        override public function redo() : void
        {
            trace("MOVE VERT REDO " + this._vertIndex);
            trace("sp + " + this._startPoint);
            trace("ep + " + this._endPoint);
            var _loc1_:Vert = this._edgeShape.getVertAt(this._vertIndex);
            _loc1_.x = this._endPoint.x;
            _loc1_.y = this._endPoint.y;
            var _loc2_:b2Vec2 = this._edgeShape.vertVector[0];
            this._edgeShape.drawEditMode(_loc2_,this._edgeShape.completeFill);
        }
        
        public function set endPoint(param1:Point) : void
        {
            this._endPoint = param1;
        }
        
        public function setEndPoint() : void
        {
            var _loc1_:Vert = this._edgeShape.getVertAt(this._vertIndex);
            this._endPoint = new Point(_loc1_.x,_loc1_.y);
            trace("SET END POINT " + this._endPoint);
        }
    }
}

