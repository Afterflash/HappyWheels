package com.totaljerkface.game.level
{
    import com.totaljerkface.game.editor.RefSprite;
    
    public class TargetActionTrigger extends LevelItem
    {
        protected var _refSprite:RefSprite;
        
        protected var _sourceTrigger:Trigger;
        
        protected var _receivingTrigger:Trigger;
        
        protected var _targetAction:String;
        
        protected var _properties:Array;
        
        protected var _instant:Boolean;
        
        protected var counter:int = 0;
        
        public function TargetActionTrigger(param1:RefSprite, param2:Trigger, param3:Trigger, param4:String, param5:Array)
        {
            super();
            this._refSprite = param1;
            this._sourceTrigger = param2;
            this._receivingTrigger = param3;
            this._targetAction = param4;
            this._instant = true;
            this._properties = param5;
        }
        
        override public function singleAction() : void
        {
            switch(this._targetAction)
            {
                case "activate trigger":
                    this._receivingTrigger.activateByTrigger();
                    break;
                case "disable":
                    this._receivingTrigger.disabled = true;
                    break;
                case "enable":
                    this._receivingTrigger.disabled = false;
            }
        }
        
        override public function actions() : void
        {
        }
        
        public function get targetAction() : String
        {
            return this._targetAction;
        }
        
        public function get instant() : Boolean
        {
            return this._instant;
        }
    }
}

