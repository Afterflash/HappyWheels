package com.totaljerkface.game.editor
{
    import com.totaljerkface.game.editor.actions.Action;
    import flash.events.Event;
    
    public class ActionEvent extends Event
    {
        public static const GENERIC:String = "generic";
        
        public static const TEMP:String = "temp";
        
        public static const SCALE:String = "scale";
        
        public static const TRANSLATE:String = "translate";
        
        public static const ROTATE:String = "rotate";
        
        public static const DEPTH:String = "depth";
        
        public static const VERT:String = "vert";
        
        private var _action:Action;
        
        public function ActionEvent(param1:String, param2:Action, param3:Boolean = false, param4:Boolean = false)
        {
            super(param1,param3,param4);
            this._action = param2;
        }
        
        public function get action() : Action
        {
            return this._action;
        }
    }
}

