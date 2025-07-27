package com.totaljerkface.game.events
{
    import com.totaljerkface.game.menus.LevelDataObject;
    import com.totaljerkface.game.menus.ReplayDataObject;
    import flash.events.Event;
    
    public class NavigationEvent extends Event
    {
        public static const MAIN_MENU:String = "mainmenu";
        
        public static const EDITOR:String = "editor";
        
        public static const SESSION:String = "session";
        
        public static const REPLAY_BROWSER:String = "replaybrowser";
        
        public static const LEVEL_BROWSER:String = "levelbrowser";
        
        public static const PREVIOUS_MENU:String = "previousmenu";
        
        public static const CUSTOMIZE_CONTROLS:String = "customizecontrols";
        
        private var _extra:*;
        
        private var _levelDataObject:LevelDataObject;
        
        private var _replayDataObject:ReplayDataObject;
        
        public function NavigationEvent(param1:String, param2:LevelDataObject = null, param3:ReplayDataObject = null, param4:* = null)
        {
            super(param1);
            this._levelDataObject = param2;
            this._replayDataObject = param3;
            this._extra = param4;
        }
        
        public function get levelDataObject() : LevelDataObject
        {
            return this._levelDataObject;
        }
        
        public function get replayDataObject() : ReplayDataObject
        {
            return this._replayDataObject;
        }
        
        public function get extra() : *
        {
            return this._extra;
        }
        
        override public function clone() : Event
        {
            return new NavigationEvent(type,this._levelDataObject,this._replayDataObject,this._extra);
        }
    }
}

