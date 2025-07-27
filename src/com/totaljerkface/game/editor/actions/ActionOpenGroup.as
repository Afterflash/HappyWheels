package com.totaljerkface.game.editor.actions
{
    import com.totaljerkface.game.editor.ArrowTool;
    import com.totaljerkface.game.editor.GroupCanvas;
    import flash.display.DisplayObjectContainer;
    
    public class ActionOpenGroup extends Action
    {
        private var _groupCanvas:GroupCanvas;
        
        private var _canvasHolder:DisplayObjectContainer;
        
        private var _arrowTool:ArrowTool;
        
        public function ActionOpenGroup(param1:GroupCanvas, param2:DisplayObjectContainer, param3:ArrowTool)
        {
            super(null);
            this._groupCanvas = param1;
            this._canvasHolder = param2;
            this._arrowTool = param3;
        }
        
        override public function undo() : void
        {
            trace("OPENGROUP UNDO " + this._groupCanvas.name);
            this._canvasHolder.removeChild(this._groupCanvas);
            this._arrowTool.currentCanvas = this._arrowTool.canvas;
        }
        
        override public function redo() : void
        {
            trace("OPENGROUP REDO " + this._groupCanvas.name);
            this._canvasHolder.addChild(this._groupCanvas);
            this._arrowTool.currentCanvas = this._groupCanvas;
        }
        
        override public function die() : void
        {
            super.die();
            this._arrowTool = null;
        }
    }
}

