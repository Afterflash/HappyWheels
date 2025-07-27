package com.totaljerkface.game.editor.actions
{
    import com.totaljerkface.game.editor.RefSprite;
    import flash.display.DisplayObjectContainer;
    
    public class ActionDepth extends Action
    {
        private var _newIndex:int;
        
        private var _oldIndex:int;
        
        private var _parent:DisplayObjectContainer;
        
        public function ActionDepth(param1:RefSprite, param2:DisplayObjectContainer, param3:int, param4:int)
        {
            super(param1);
            this._parent = param2;
            this._newIndex = param3;
            this._oldIndex = param4;
        }
        
        override public function undo() : void
        {
            trace("DEPTH UNDO " + refSprite.name);
            this._parent.addChildAt(refSprite,this._oldIndex);
        }
        
        override public function redo() : void
        {
            trace("DEPTH REDO " + refSprite.name);
            this._parent.addChildAt(refSprite,this._newIndex);
        }
    }
}

