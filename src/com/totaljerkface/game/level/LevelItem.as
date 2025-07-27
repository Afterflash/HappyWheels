package com.totaljerkface.game.level
{
    import Box2D.Common.Math.b2Vec2;
    import Box2D.Dynamics.b2Body;
    import com.totaljerkface.game.Settings;
    import flash.display.DisplayObject;
    import flash.events.EventDispatcher;
    
    public class LevelItem extends EventDispatcher
    {
        protected static const oneEightyOverPI:Number = 180 / Math.PI;
        
        protected var m_physScale:Number = Settings.currentSession.level.m_physScale;
        
        protected var _triggered:Boolean;
        
        public function LevelItem()
        {
            super();
        }
        
        public function paint() : void
        {
        }
        
        public function actions() : void
        {
        }
        
        public function singleAction() : void
        {
        }
        
        public function die() : void
        {
        }
        
        public function getJointBody(param1:b2Vec2 = null) : b2Body
        {
            return null;
        }
        
        public function get groupDisplayObject() : DisplayObject
        {
            return null;
        }
        
        public function triggerSingleActivation(param1:Trigger, param2:String, param3:Array) : void
        {
            if(this._triggered)
            {
                return;
            }
            this._triggered = true;
        }
        
        public function triggerRepeatActivation(param1:Trigger, param2:String, param3:Array, param4:int) : Boolean
        {
            return true;
        }
        
        public function get bodyList() : Array
        {
            return [];
        }
        
        public function prepareForTrigger() : void
        {
        }
    }
}

