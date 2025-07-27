package com.totaljerkface.game
{
    import flash.display.*;
    import flash.system.*;
    import flash.utils.*;
    
    public class MemoryTest
    {
        private static var _instance:MemoryTest;
        
        private var _dictionary:Dictionary;
        
        private var counter:int = 0;
        
        public function MemoryTest()
        {
            super();
            if(_instance)
            {
                throw new Error("MemoryTest already exists");
            }
            _instance = this;
            this.init();
        }
        
        public static function get instance() : MemoryTest
        {
            return _instance;
        }
        
        private function init() : void
        {
            this._dictionary = new Dictionary(true);
        }
        
        public function get dictionary() : Dictionary
        {
            return this._dictionary;
        }
        
        public function addEntry(param1:String, param2:Object) : void
        {
            if(this._dictionary[param2])
            {
                trace(param1 + " already in dictionary");
                return;
            }
            this._dictionary[param2] = "" + param1 + this.counter;
            ++this.counter;
        }
        
        public function traceContents() : void
        {
            var _loc1_:Object = null;
            trace("_dictionary:");
            for(_loc1_ in this._dictionary)
            {
                trace(_loc1_ + " = " + this._dictionary[_loc1_]);
            }
        }
    }
}

