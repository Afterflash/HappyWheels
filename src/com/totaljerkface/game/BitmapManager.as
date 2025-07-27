package com.totaljerkface.game
{
    import flash.display.*;
    
    public class BitmapManager
    {
        private static var _instance:BitmapManager;
        
        private var _textures:Object;
        
        public function BitmapManager()
        {
            super();
            if(_instance)
            {
                throw new Error("BitmapManager already exists");
            }
            _instance = this;
            this.init();
        }
        
        public static function get instance() : BitmapManager
        {
            return _instance;
        }
        
        private function init() : void
        {
            this._textures = new Object();
        }
        
        public function get textures() : Object
        {
            return this._textures;
        }
        
        public function addTexture(param1:String, param2:BitmapData) : void
        {
            this._textures[param1] = param2;
        }
        
        public function getTexture(param1:String) : BitmapData
        {
            return this._textures[param1];
        }
    }
}

