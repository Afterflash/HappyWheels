package com.totaljerkface.game.events
{
    import flash.events.Event;
    
    public class CanvasEvent extends Event
    {
        public static const ART:String = "art";
        
        public static const SHAPE:String = "shape";
        
        private var _value:int;
        
        public function CanvasEvent(param1:String, param2:int)
        {
            super(param1,true);
            this._value = param2;
        }
        
        public function get value() : *
        {
            return this._value;
        }
        
        override public function clone() : Event
        {
            return new CanvasEvent(type,this._value);
        }
    }
}

