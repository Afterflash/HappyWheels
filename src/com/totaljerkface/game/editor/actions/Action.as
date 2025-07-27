package com.totaljerkface.game.editor.actions
{
    import com.totaljerkface.game.editor.RefSprite;
    
    public class Action
    {
        private var _refSprite:RefSprite;
        
        private var _prevAction:Action;
        
        private var _nextAction:Action;
        
        private var _resetTested:Boolean;
        
        public function Action(param1:RefSprite, param2:Boolean = true)
        {
            super();
            this._refSprite = param1;
            this._resetTested = param2;
        }
        
        public function get refSprite() : RefSprite
        {
            return this._refSprite;
        }
        
        public function set prevAction(param1:Action) : void
        {
            this._prevAction = param1;
            if(param1.nextAction != this)
            {
                param1.nextAction = this;
            }
        }
        
        public function get prevAction() : Action
        {
            return this._prevAction;
        }
        
        public function set nextAction(param1:Action) : void
        {
            this._nextAction = param1;
            if(param1.prevAction != this)
            {
                param1.prevAction = this;
            }
        }
        
        public function get nextAction() : Action
        {
            return this._nextAction;
        }
        
        public function get firstAction() : Action
        {
            var _loc1_:Action = this;
            while(_loc1_.prevAction)
            {
                _loc1_ = _loc1_.prevAction;
            }
            return _loc1_;
        }
        
        public function get lastAction() : Action
        {
            var _loc1_:Action = this;
            while(_loc1_.nextAction)
            {
                _loc1_ = _loc1_.nextAction;
            }
            return _loc1_;
        }
        
        public function undo() : void
        {
        }
        
        public function redo() : void
        {
        }
        
        public function get resetTested() : Boolean
        {
            return this._resetTested;
        }
        
        public function die() : void
        {
            this._prevAction = null;
            if(this._nextAction)
            {
                this._nextAction.die();
            }
            this._nextAction = null;
        }
    }
}

