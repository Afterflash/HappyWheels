package com.totaljerkface.game.editor.actions
{
    import com.totaljerkface.game.editor.RefGroup;
    import com.totaljerkface.game.editor.RefSprite;
    import flash.display.DisplayObjectContainer;
    
    public class ActionUngroup extends Action
    {
        private var _prevGroup:RefGroup;
        
        private var _newGroup:RefGroup;
        
        private var _groupParent:DisplayObjectContainer;
        
        private var _groupIndex:int;
        
        public function ActionUngroup(param1:RefSprite, param2:RefGroup, param3:RefGroup, param4:DisplayObjectContainer, param5:int)
        {
            super(param1);
            this._prevGroup = param2;
            this._newGroup = param3;
            this._groupParent = param4;
            this._groupIndex = param5;
        }
        
        override public function undo() : void
        {
            trace("UNGROUP UNDO " + refSprite.name);
            this._groupParent.addChildAt(refSprite,this._groupIndex);
            refSprite.group = this._newGroup;
        }
        
        override public function redo() : void
        {
            trace("UNGROUP REDO " + refSprite.name);
            this._groupParent.removeChild(refSprite);
            refSprite.group = this._prevGroup;
        }
    }
}

