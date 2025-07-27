package com.totaljerkface.game.editor
{
    import com.totaljerkface.game.editor.actions.*;
    import flash.display.Sprite;
    import flash.events.*;
    import flash.utils.Dictionary;
    
    public class ActionRecorder extends EventDispatcher
    {
        public static const UNDO:String = "undo";
        
        public static const REDO:String = "redo";
        
        private var actionArray:Array;
        
        private var index:int;
        
        public var dictionary:Dictionary;
        
        public var counter:int = 0;
        
        private var testSprite:Sprite;
        
        public function ActionRecorder()
        {
            super();
            this.actionArray = new Array();
            this.index = -1;
            this.dictionary = new Dictionary(true);
            this.testSprite = new Sprite();
            this.dictionary[this.testSprite] = 1;
            this.testSprite = null;
        }
        
        public function pushAction(param1:Action) : void
        {
            var _loc5_:Action = null;
            this.index += 1;
            var _loc2_:int = this.actionArray.length - this.index;
            this.dictionary[param1] = this.counter;
            this.counter += 1;
            var _loc3_:Array = this.actionArray.splice(this.index,_loc2_,param1);
            var _loc4_:int = 0;
            while(_loc4_ < _loc3_.length)
            {
                _loc5_ = _loc3_[_loc4_];
                _loc5_ = _loc5_.firstAction;
                _loc5_.die();
                _loc4_++;
            }
        }
        
        public function undo() : void
        {
            trace("start undo");
            if(this.index < 0)
            {
                return;
            }
            var _loc1_:Action = this.actionArray[this.index];
            _loc1_ = _loc1_.lastAction;
            while(_loc1_)
            {
                _loc1_.undo();
                _loc1_ = _loc1_.prevAction;
            }
            --this.index;
            dispatchEvent(new Event(UNDO));
        }
        
        public function redo() : void
        {
            trace("start redo");
            if(this.index == this.actionArray.length - 1)
            {
                return;
            }
            var _loc1_:Action = this.actionArray[this.index + 1];
            _loc1_ = _loc1_.firstAction;
            while(_loc1_)
            {
                _loc1_.redo();
                _loc1_ = _loc1_.nextAction;
            }
            this.index += 1;
            dispatchEvent(new Event(REDO));
        }
        
        public function clearActions() : void
        {
            var _loc2_:Action = null;
            var _loc1_:int = 0;
            while(_loc1_ < this.actionArray.length)
            {
                _loc2_ = this.actionArray[_loc1_];
                _loc2_ = _loc2_.firstAction;
                _loc2_.die();
                _loc1_++;
            }
            this.actionArray = new Array();
            this.index = -1;
        }
        
        public function die() : void
        {
            var _loc2_:Action = null;
            var _loc1_:int = 0;
            while(_loc1_ < this.actionArray.length)
            {
                _loc2_ = this.actionArray[_loc1_];
                _loc2_ = _loc2_.firstAction;
                _loc2_.die();
                _loc1_++;
            }
        }
    }
}

