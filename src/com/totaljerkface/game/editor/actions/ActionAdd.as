package com.totaljerkface.game.editor.actions
{
    import com.totaljerkface.game.editor.Canvas;
    import com.totaljerkface.game.editor.GroupCanvas;
    import com.totaljerkface.game.editor.RefGroup;
    import com.totaljerkface.game.editor.RefSprite;
    
    public class ActionAdd extends Action
    {
        private var _canvas:Canvas;
        
        private var _childIndex:int;
        
        private var _group:RefGroup;
        
        public function ActionAdd(param1:RefSprite, param2:Canvas, param3:int)
        {
            var _loc4_:GroupCanvas = null;
            super(param1);
            this._canvas = param2;
            this._childIndex = param3;
            if(this._canvas is GroupCanvas)
            {
                _loc4_ = this._canvas as GroupCanvas;
                this._group = _loc4_.refGroup;
            }
        }
        
        override public function undo() : void
        {
            trace("ADD UNDO " + refSprite.name);
            this._canvas.removeRefSprite(refSprite);
            if(this._group)
            {
                refSprite.inGroup = false;
                refSprite.group = null;
            }
        }
        
        override public function redo() : void
        {
            trace("ADD REDO " + refSprite.name);
            this._canvas.addRefSpriteAt(refSprite,this._childIndex);
            if(this._group)
            {
                refSprite.inGroup = true;
                refSprite.group = this._group;
            }
        }
    }
}

