package com.totaljerkface.game.editor.actions
{
    import com.totaljerkface.game.editor.EdgeShape;
    import com.totaljerkface.game.editor.Tool;
    
    public class ActionCompleteShape extends Action
    {
        private var _edgeShape:EdgeShape;
        
        private var _newShape:EdgeShape;
        
        private var _tool:Tool;
        
        private var _completeFill:Boolean;
        
        public function ActionCompleteShape(param1:EdgeShape, param2:EdgeShape, param3:Tool)
        {
            super(null);
            this._edgeShape = param1;
            this._newShape = param2;
            this._tool = param3;
            this._completeFill = this._edgeShape.completeFill;
        }
        
        override public function undo() : void
        {
            trace("COMPLETE SHAPE UNDO " + this._edgeShape.name);
            this._tool.remoteButtonPress();
            this._tool.setCurrentShape(this._edgeShape);
        }
        
        override public function redo() : void
        {
            trace("COMPLETE SHAPE REDO " + this._edgeShape.name);
            this._edgeShape.completeFill = this._completeFill;
            this._edgeShape.editMode = false;
            this._edgeShape.mouseEnabled = true;
            this._tool.removeFrameHandler();
            this._tool.setCurrentShape(this._newShape);
        }
    }
}

