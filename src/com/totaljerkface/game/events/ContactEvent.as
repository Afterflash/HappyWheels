package com.totaljerkface.game.events
{
    import Box2D.Collision.Shapes.b2Shape;
    import Box2D.Common.Math.b2Vec2;
    import flash.events.Event;
    
    public class ContactEvent extends Event
    {
        public static const ADD:String = "add";
        
        public static const REMOVE:String = "remove";
        
        public static const PERSIST:String = "persist";
        
        public static const RESULT:String = "result";
        
        private var _impulse:Number;
        
        private var _normal:b2Vec2;
        
        private var _shape:b2Shape;
        
        private var _otherShape:b2Shape;
        
        private var _position:b2Vec2;
        
        public function ContactEvent(param1:String, param2:b2Shape, param3:Number, param4:b2Vec2, param5:b2Shape, param6:b2Vec2)
        {
            super(param1);
            this._shape = param2;
            this._impulse = param3;
            this._normal = param4;
            this._otherShape = param5;
            this._position = param6;
        }
        
        public function get impulse() : Number
        {
            return this._impulse;
        }
        
        public function get normal() : b2Vec2
        {
            return this._normal;
        }
        
        public function get shape() : b2Shape
        {
            return this._shape;
        }
        
        public function get otherShape() : b2Shape
        {
            return this._otherShape;
        }
        
        public function get position() : b2Vec2
        {
            return this._position;
        }
    }
}

