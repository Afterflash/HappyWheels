package com.totaljerkface.game.editor.actions
{
    import com.totaljerkface.game.editor.EdgeShape;
    import com.totaljerkface.game.editor.vertedit.Vert;
    
    public class ActionSelectVert extends Action
    {
        private var _vertIndex:int;
        
        private var _edgeShape:EdgeShape;
        
        private var _selectionVector:Vector.<Vert>;
        
        private var _selectionIndex:int;
        
        public function ActionSelectVert(param1:int, param2:EdgeShape, param3:Vector.<Vert>, param4:int)
        {
            super(null);
            this._vertIndex = param1;
            this._edgeShape = param2;
            this._selectionVector = param3;
            this._selectionIndex = param4;
        }
        
        override public function undo() : void
        {
            trace("SELECT VERT UNDO " + this._vertIndex);
            var _loc1_:Vert = this._edgeShape.getVertAt(this._vertIndex);
            this._selectionVector.splice(this._selectionIndex,1);
            _loc1_.selected = false;
        }
        
        override public function redo() : void
        {
            trace("SELECT VERT REDO " + this._vertIndex);
            var _loc1_:Vert = this._edgeShape.getVertAt(this._vertIndex);
            this._selectionVector.splice(this._selectionIndex,0,_loc1_);
            _loc1_.selected = true;
        }
    }
}

