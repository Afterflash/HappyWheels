package com.totaljerkface.game.editor.ui
{
    import flash.events.Event;
    
    public class ValueEvent extends Event
    {
        public static const VALUE_CHANGE:String = "valuechange";
        
        public static const ADD_INPUT:String = "addinput";
        
        public static const REMOVE_INPUT:String = "removeinput";
        
        public var value:*;
        
        public var inputObject:InputObject;
        
        private var _resetInputs:Boolean;
        
        public function ValueEvent(param1:String, param2:InputObject, param3:*, param4:Boolean = true)
        {
            this.inputObject = param2;
            this.value = param3;
            this._resetInputs = param4;
            super(param1);
        }
        
        override public function clone() : Event
        {
            return new ValueEvent(type,this.inputObject,this.value);
        }
        
        public function get resetInputs() : Boolean
        {
            return this._resetInputs;
        }
    }
}

