package com.totaljerkface.game.events
{
    import flash.events.Event;
    
    public class SessionEvent extends Event
    {
        public static const PAUSE:String = "pause";
        
        public static const COMPLETED:String = "completed";
        
        public static const REPLAY_COMPLETED:String = "replaycompleted";
        
        public function SessionEvent(param1:String)
        {
            super(param1);
        }
    }
}

