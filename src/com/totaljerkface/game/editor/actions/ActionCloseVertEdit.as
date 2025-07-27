package com.totaljerkface.game.editor.actions
{
    import com.totaljerkface.game.editor.ArrowTool;
    import com.totaljerkface.game.editor.EdgeShape;
    import com.totaljerkface.game.editor.RefSprite;
    
    public class ActionCloseVertEdit extends Action
    {
        private var _arrowTool:ArrowTool;
        
        public function ActionCloseVertEdit(param1:RefSprite, param2:ArrowTool)
        {
            super(param1);
            this._arrowTool = param2;
        }
        
        override public function undo() : void
        {
            trace("CLOSEVERTEDIT UNDO " + refSprite.name);
            this._arrowTool.openVertEdit(refSprite as EdgeShape,false);
        }
        
        override public function redo() : void
        {
            trace("CLOSEVERTEDIT REDO " + refSprite.name);
            this._arrowTool.closeVertEdit(null,false);
        }
        
        override public function die() : void
        {
            super.die();
            this._arrowTool = null;
        }
    }
}

