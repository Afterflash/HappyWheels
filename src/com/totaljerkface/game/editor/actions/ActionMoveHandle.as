package com.totaljerkface.game.editor.actions
{
    import Box2D.Common.Math.b2Vec2;
    import com.totaljerkface.game.editor.*;
    import com.totaljerkface.game.editor.vertedit.BezierVert;
    import flash.display.*;
    import flash.geom.Point;
    
    public class ActionMoveHandle extends Action
    {
        private var _vertIndex:int;
        
        private var _edgeShape:EdgeShape;
        
        private var _startPoint1:Point;
        
        private var _startPoint2:Point;
        
        private var _endPoint1:Point;
        
        private var _endPoint2:Point;
        
        public function ActionMoveHandle(param1:int, param2:EdgeShape, param3:Point = null, param4:Point = null)
        {
            super(null);
            this._vertIndex = param1;
            this._edgeShape = param2;
            var _loc5_:BezierVert = this._edgeShape.getVertAt(this._vertIndex) as BezierVert;
            this._startPoint1 = !!param3 ? param3 : new Point(_loc5_.handle1.x,_loc5_.handle1.y);
            this._startPoint2 = !!param4 ? param4 : new Point(_loc5_.handle2.x,_loc5_.handle2.y);
        }
        
        override public function undo() : void
        {
            trace("MOVE HANDLE UNDO " + this._vertIndex);
            var _loc1_:BezierVert = this._edgeShape.getVertAt(this._vertIndex) as BezierVert;
            if(!this._endPoint1)
            {
                this._endPoint1 = new Point(_loc1_.handle1.x,_loc1_.handle1.y);
            }
            if(!this._endPoint2)
            {
                this._endPoint2 = new Point(_loc1_.handle2.x,_loc1_.handle2.y);
            }
            _loc1_.handle1.Set(this._startPoint1.x,this._startPoint1.y);
            _loc1_.handle2.Set(this._startPoint2.x,this._startPoint2.y);
            var _loc2_:b2Vec2 = this._edgeShape.vertVector[0];
            this._edgeShape.drawEditMode(_loc2_,this._edgeShape.completeFill);
        }
        
        override public function redo() : void
        {
            trace("MOVE HANDLE REDO " + this._vertIndex);
            var _loc1_:BezierVert = this._edgeShape.getVertAt(this._vertIndex) as BezierVert;
            _loc1_.handle1.Set(this._endPoint1.x,this._endPoint1.y);
            _loc1_.handle2.Set(this._endPoint2.x,this._endPoint2.y);
            var _loc2_:b2Vec2 = this._edgeShape.vertVector[0];
            this._edgeShape.drawEditMode(_loc2_,this._edgeShape.completeFill);
        }
    }
}

