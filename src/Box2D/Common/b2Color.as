package Box2D.Common
{
    import Box2D.Common.Math.b2Math;
    
    public class b2Color
    {
        private var _r:uint = 0;
        
        private var _g:uint = 0;
        
        private var _b:uint = 0;
        
        public function b2Color(param1:Number, param2:Number, param3:Number)
        {
            super();
            this._r = uint(255 * b2Math.b2Clamp(param1,0,1));
            this._g = uint(255 * b2Math.b2Clamp(param2,0,1));
            this._b = uint(255 * b2Math.b2Clamp(param3,0,1));
        }
        
        public function Set(param1:Number, param2:Number, param3:Number) : void
        {
            this._r = uint(255 * b2Math.b2Clamp(param1,0,1));
            this._g = uint(255 * b2Math.b2Clamp(param2,0,1));
            this._b = uint(255 * b2Math.b2Clamp(param3,0,1));
        }
        
        public function set r(param1:Number) : void
        {
            this._r = uint(255 * b2Math.b2Clamp(param1,0,1));
        }
        
        public function set g(param1:Number) : void
        {
            this._g = uint(255 * b2Math.b2Clamp(param1,0,1));
        }
        
        public function set b(param1:Number) : void
        {
            this._b = uint(255 * b2Math.b2Clamp(param1,0,1));
        }
        
        public function get color() : uint
        {
            return this._r | this._g << 8 | this._b << 16;
        }
    }
}

