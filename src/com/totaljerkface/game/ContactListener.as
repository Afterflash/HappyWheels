package com.totaljerkface.game
{
    import Box2D.Collision.Shapes.b2Shape;
    import Box2D.Collision.b2ContactPoint;
    import Box2D.Dynamics.Contacts.b2ContactResult;
    import Box2D.Dynamics.b2ContactListener;
    import com.totaljerkface.game.events.ContactEvent;
    import flash.utils.Dictionary;
    
    public class ContactListener extends b2ContactListener
    {
        public static const ADD:String = "add";
        
        public static const REMOVE:String = "remove";
        
        public static const PERSIST:String = "persist";
        
        public static const RESULT:String = "result";
        
        private var _addListeners:Dictionary;
        
        private var _removeListeners:Dictionary;
        
        private var _persistListeners:Dictionary;
        
        private var _resultListeners:Dictionary;
        
        public function ContactListener()
        {
            super();
            this._addListeners = new Dictionary();
            this._removeListeners = new Dictionary();
            this._persistListeners = new Dictionary();
            this._resultListeners = new Dictionary();
        }
        
        override public function Add(param1:b2ContactPoint) : void
        {
            var _loc3_:b2ContactPoint = null;
            var _loc2_:Function = this._addListeners[param1.shape1];
            if(_loc2_ != null)
            {
                _loc2_(param1);
            }
            _loc2_ = this._addListeners[param1.shape2];
            if(_loc2_ != null)
            {
                _loc3_ = new b2ContactPoint();
                _loc3_.shape1 = param1.shape2;
                _loc3_.shape2 = param1.shape1;
                _loc3_.normal = param1.normal.Negative();
                _loc3_.separation = param1.separation;
                _loc3_.velocity = param1.velocity;
                _loc3_.position = param1.position;
                _loc3_.id = param1.id;
                _loc3_.swap = true;
                _loc2_(_loc3_);
            }
        }
        
        override public function Persist(param1:b2ContactPoint) : void
        {
            var _loc3_:b2ContactPoint = null;
            var _loc2_:Function = this._persistListeners[param1.shape1];
            if(_loc2_ != null)
            {
                _loc2_(param1);
            }
            _loc2_ = this._persistListeners[param1.shape2];
            if(_loc2_ != null)
            {
                _loc3_ = new b2ContactPoint();
                _loc3_.shape1 = param1.shape2;
                _loc3_.shape2 = param1.shape1;
                _loc3_.normal = param1.normal.Negative();
                _loc3_.separation = param1.separation;
                _loc3_.velocity = param1.velocity;
                _loc3_.position = param1.position;
                _loc2_(_loc3_);
            }
        }
        
        override public function Remove(param1:b2ContactPoint) : void
        {
            var _loc3_:b2ContactPoint = null;
            var _loc2_:Function = this._removeListeners[param1.shape1];
            if(_loc2_ != null)
            {
                _loc2_(param1);
            }
            _loc2_ = this._removeListeners[param1.shape2];
            if(_loc2_ != null)
            {
                _loc3_ = new b2ContactPoint();
                _loc3_.shape1 = param1.shape2;
                _loc3_.shape2 = param1.shape1;
                _loc3_.velocity = param1.velocity;
                _loc2_(_loc3_);
            }
        }
        
        override public function Result(param1:b2ContactResult) : void
        {
            var _loc2_:Function = this._resultListeners[param1.shape1];
            if(_loc2_ != null)
            {
                _loc2_(new ContactEvent(ContactEvent.RESULT,param1.shape1,param1.normalImpulse,param1.normal,param1.shape2,param1.position));
            }
            _loc2_ = this._resultListeners[param1.shape2];
            if(_loc2_ != null)
            {
                _loc2_(new ContactEvent(ContactEvent.RESULT,param1.shape2,param1.normalImpulse,param1.normal,param1.shape1,param1.position));
            }
        }
        
        public function registerListener(param1:String, param2:b2Shape, param3:Function) : void
        {
            switch(param1)
            {
                case ADD:
                    this._addListeners[param2] = param3;
                    break;
                case REMOVE:
                    this._removeListeners[param2] = param3;
                    break;
                case PERSIST:
                    this._persistListeners[param2] = param3;
                    break;
                case RESULT:
                    this._resultListeners[param2] = param3;
            }
        }
        
        public function deleteListener(param1:String, param2:b2Shape) : void
        {
            switch(param1)
            {
                case ADD:
                    delete this._addListeners[param2];
                    break;
                case REMOVE:
                    delete this._removeListeners[param2];
                    break;
                case PERSIST:
                    delete this._persistListeners[param2];
                    break;
                case RESULT:
                    delete this._resultListeners[param2];
            }
        }
        
        public function listenerExists(param1:String, param2:b2Shape) : Boolean
        {
            switch(param1)
            {
                case ADD:
                    if(this._addListeners[param2])
                    {
                        return true;
                    }
                    break;
                case REMOVE:
                    if(this._removeListeners[param2])
                    {
                        return true;
                    }
                    break;
                case PERSIST:
                    if(this._persistListeners[param2])
                    {
                        return true;
                    }
                    break;
                case RESULT:
                    if(this._resultListeners[param2])
                    {
                        return true;
                    }
                    break;
            }
            return false;
        }
        
        public function die() : void
        {
            this._addListeners = null;
            this._removeListeners = null;
            this._persistListeners = null;
            this._resultListeners = null;
        }
    }
}

