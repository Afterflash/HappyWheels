package com.totaljerkface.game.editor.actions
{
    import com.totaljerkface.game.editor.ArrowTool;
    import com.totaljerkface.game.editor.RefGroup;
    import com.totaljerkface.game.editor.RefJoint;
    import com.totaljerkface.game.editor.RefShape;
    import com.totaljerkface.game.editor.RefSprite;
    import com.totaljerkface.game.editor.specials.Special;
    import com.totaljerkface.game.editor.specials.StartPlaceHolder;
    import com.totaljerkface.game.editor.trigger.RefTrigger;
    
    public class ActionDeselect extends Action
    {
        private var _selectionArray:Array;
        
        private var _index:int;
        
        private var _arrowTool:ArrowTool;
        
        public function ActionDeselect(param1:RefSprite, param2:Array, param3:int, param4:ArrowTool)
        {
            super(param1,false);
            this._selectionArray = param2;
            this._index = param3;
            this._arrowTool = param4;
        }
        
        override public function undo() : void
        {
            trace("DESELECT UNDO " + refSprite.name);
            this._selectionArray.splice(this._index,0,refSprite);
            refSprite.selected = true;
            if(refSprite is RefShape)
            {
                this._arrowTool.numShapesSelected += 1;
            }
            else if(refSprite is Special)
            {
                this._arrowTool.numSpecialsSelected += 1;
            }
            else if(refSprite is RefGroup)
            {
                this._arrowTool.numGroupsSelected += 1;
            }
            else if(refSprite is RefJoint)
            {
                this._arrowTool.numJointsSelected += 1;
            }
            else if(refSprite is RefTrigger)
            {
                this._arrowTool.numTriggersSelected += 1;
            }
            else if(refSprite is StartPlaceHolder)
            {
                this._arrowTool.numCharSelected += 1;
            }
        }
        
        override public function redo() : void
        {
            trace("DESELECT REDO " + refSprite.name);
            this._selectionArray.splice(this._index,1);
            refSprite.selected = false;
            if(refSprite is RefShape)
            {
                --this._arrowTool.numShapesSelected;
            }
            else if(refSprite is Special)
            {
                --this._arrowTool.numSpecialsSelected;
            }
            else if(refSprite is RefGroup)
            {
                --this._arrowTool.numGroupsSelected;
            }
            else if(refSprite is RefJoint)
            {
                --this._arrowTool.numJointsSelected;
            }
            else if(refSprite is RefTrigger)
            {
                --this._arrowTool.numTriggersSelected;
            }
            else if(refSprite is StartPlaceHolder)
            {
                --this._arrowTool.numCharSelected;
            }
        }
    }
}

