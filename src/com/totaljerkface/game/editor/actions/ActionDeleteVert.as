package com.totaljerkface.game.editor.actions
{
    import Box2D.Common.Math.b2Vec2;
    import com.totaljerkface.game.editor.*;
    import com.totaljerkface.game.editor.vertedit.BezierVert;
    import com.totaljerkface.game.editor.vertedit.Vert;
    import flash.display.*;
    
    public class ActionDeleteVert extends Action
    {
        private var _vertIndex:int;
        
        private var _edgeShape:EdgeShape;
        
        private var posX:Number;
        
        private var posY:Number;
        
        private var handle1X:Number;
        
        private var handle1Y:Number;
        
        private var handle2X:Number;
        
        private var handle2Y:Number;
        
        private var _tool:Tool;
        
        public function ActionDeleteVert(param1:int, param2:EdgeShape, param3:Tool = null)
        {
            super(null);
            this._vertIndex = param1;
            this._edgeShape = param2;
            this._tool = param3;
            this.setPosition();
        }
        
        override public function undo() : void
        {
            var _loc1_:Vert = null;
            var _loc2_:b2Vec2 = null;
            trace("DELETE VERT UNDO " + this._edgeShape.name);
            if(this._edgeShape is ArtShape)
            {
                _loc1_ = new BezierVert(this.posX,this.posY,this.handle1X,this.handle1Y,this.handle2X,this.handle2Y);
            }
            else
            {
                _loc1_ = new Vert(this.posX,this.posY);
            }
            _loc1_.edgeShape = this._edgeShape;
            this._edgeShape.addVert(_loc1_,this._vertIndex);
            if(this._tool)
            {
                this._tool.remoteButtonPress();
                if(this._edgeShape.numVerts == 1)
                {
                    this._tool.addFrameHandler();
                }
                else
                {
                    _loc1_ = this._edgeShape.getVertAt(this._edgeShape.numVerts - 2);
                    _loc1_.selected = false;
                }
            }
            else
            {
                _loc2_ = this._edgeShape.vertVector[0];
                this._edgeShape.drawEditMode(_loc2_,this._edgeShape.completeFill);
            }
        }
        
        override public function redo() : void
        {
            var _loc1_:Vert = null;
            var _loc2_:b2Vec2 = null;
            trace("DELETE VERT REDO " + this._edgeShape.name);
            this._edgeShape.removeVert(this._vertIndex);
            if(this._tool)
            {
                this._tool.remoteButtonPress();
                if(this._edgeShape.numVerts == 0)
                {
                    this._tool.removeFrameHandler();
                    this._edgeShape.graphics.clear();
                }
                else
                {
                    _loc1_ = this._edgeShape.getVertAt(this._edgeShape.numVerts - 1);
                    _loc1_.selected = true;
                }
            }
            else
            {
                _loc2_ = this._edgeShape.vertVector[0];
                this._edgeShape.drawEditMode(_loc2_,this._edgeShape.completeFill);
            }
        }
        
        private function setPosition() : void
        {
            var _loc1_:b2Vec2 = null;
            var _loc2_:ArtShape = null;
            var _loc3_:int = 0;
            _loc1_ = this._edgeShape.vertVector[this._vertIndex];
            this.posX = _loc1_.x;
            this.posY = _loc1_.y;
            if(this._edgeShape is ArtShape)
            {
                _loc2_ = this._edgeShape as ArtShape;
                _loc3_ = this._vertIndex * 2;
                _loc1_ = _loc2_.handleVector[_loc3_];
                this.handle1X = _loc1_.x;
                this.handle1Y = _loc1_.y;
                _loc1_ = _loc2_.handleVector[_loc3_ + 1];
                this.handle2X = _loc1_.x;
                this.handle2Y = _loc1_.y;
            }
        }
    }
}

