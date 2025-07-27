package com.totaljerkface.game.editor.actions
{
    import com.totaljerkface.game.editor.RefSprite;
    import com.totaljerkface.game.editor.trigger.RefTrigger;
    
    public class ActionTriggerRemove extends Action
    {
        private var _trigger:RefTrigger;
        
        private var _targetIndex:int;
        
        public function ActionTriggerRemove(param1:RefTrigger, param2:RefSprite, param3:int)
        {
            super(param2);
            this._trigger = param1;
            this._targetIndex = param3;
        }
        
        override public function undo() : void
        {
            trace("TRIGGER REMOVE UNDO " + refSprite.name + " " + this._targetIndex);
            this._trigger.targets.splice(this._targetIndex,0,refSprite);
            this._trigger.addMoveListener(refSprite);
            refSprite.addTrigger(this._trigger);
            this._trigger.drawArms();
        }
        
        override public function redo() : void
        {
            trace("TRIGGER REMOVE REDO " + refSprite.name);
            this._trigger.targets.splice(this._targetIndex,1);
            this._trigger.removeMoveListener(refSprite);
            refSprite.removeTrigger(this._trigger);
            this._trigger.drawArms();
        }
    }
}

