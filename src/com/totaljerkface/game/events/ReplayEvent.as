package com.totaljerkface.game.events
{
    import flash.events.Event;
    
    public class ReplayEvent extends Event
    {
        public static const ADD_ENTRY:String = "addentry";
        
        private var _keyString:String;
        
        public function ReplayEvent(param1:String, param2:String)
        {
            super(param1);
            this._keyString = param2;
        }
        
        public function get keyString() : String
        {
            return this._keyString;
        }
    }
}

