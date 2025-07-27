package com.totaljerkface.game.events
{
    import flash.events.Event;
    
    public class BrowserEvent extends Event
    {
        public static const USER:String = "user";
        
        public static const FLAG:String = "flag";
        
        public static const ADD_TO_FAVORITES:String = "add to favorites";
        
        public static const REMOVE_FROM_FAVORITES:String = "remove from favorites";
        
        private var _extra:*;
        
        public function BrowserEvent(param1:String, param2:* = null)
        {
            super(param1);
            this._extra = param2;
        }
        
        public function get extra() : *
        {
            return this._extra;
        }
        
        override public function clone() : Event
        {
            return new BrowserEvent(type,this._extra);
        }
    }
}

