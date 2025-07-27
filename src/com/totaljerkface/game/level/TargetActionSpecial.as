package com.totaljerkface.game.level
{
    import com.totaljerkface.game.Settings;
    import com.totaljerkface.game.editor.RefSprite;
    
    public class TargetActionSpecial extends LevelItem
    {
        protected var _refSprite:RefSprite;
        
        protected var _trigger:Trigger;
        
        protected var _levelItem:LevelItem;
        
        protected var _targetAction:String;
        
        protected var _properties:Array;
        
        protected var _instant:Boolean;
        
        protected var counter:int = 0;
        
        public function TargetActionSpecial(param1:RefSprite, param2:Trigger, param3:LevelItem, param4:String, param5:Array)
        {
            super();
            this._refSprite = param1;
            this._trigger = param2;
            this._levelItem = param3;
            this._targetAction = param4;
            this._instant = param4 == "change opacity" || param4 == "slide" ? false : true;
            this._properties = param5;
        }
        
        override public function singleAction() : void
        {
            this._levelItem.triggerSingleActivation(this._trigger,this._targetAction,this._properties);
        }
        
        override public function actions() : void
        {
            var _loc1_:Boolean = this._levelItem.triggerRepeatActivation(this._trigger,this._targetAction,this._properties,this.counter);
            if(_loc1_)
            {
                if(Settings.currentSession.levelVersion > 1.8)
                {
                    this.counter = 0;
                }
                Settings.currentSession.level.removeFromActionsVector(this);
                return;
            }
            this.counter += 1;
        }
        
        public function get targetAction() : String
        {
            return this._targetAction;
        }
        
        public function get levelItem() : LevelItem
        {
            return this._levelItem;
        }
        
        public function get instant() : Boolean
        {
            return this._instant;
        }
    }
}

