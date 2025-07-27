package com.totaljerkface.game.menus
{
    import com.totaljerkface.game.events.*;
    import flash.display.*;
    import flash.events.*;
    import gs.*;
    import gs.easing.*;
    
    public class LevelList extends Sprite
    {
        public static const UPDATE_SCROLLER:String = "updatescroller";
        
        public static const FACE_SELECTED:String = "faceselected";
        
        private var levelSelection:LevelSelection;
        
        private var listItemArray:Array;
        
        private var selectedListItem:LevelListItem;
        
        private var nextSelectedListItem:LevelListItem;
        
        private var _selectedCharacter:int;
        
        private var _highlightedArray:Array;
        
        private var _tweenVal:Number = 0;
        
        private var tweenTime:Number = 0.25;
        
        private var opening:Boolean;
        
        private var closing:Boolean;
        
        public function LevelList(param1:Array, param2:int = -1, param3:int = -1)
        {
            var _loc5_:int = 0;
            var _loc8_:LevelDataObject = null;
            var _loc9_:LevelListItem = null;
            super();
            this.listItemArray = new Array();
            var _loc4_:int = 0;
            _loc5_ = LevelListItem.BG_HEIGHT;
            var _loc6_:int = int(param1.length);
            var _loc7_:int = 0;
            while(_loc7_ < _loc6_)
            {
                _loc8_ = param1[_loc7_];
                _loc9_ = new LevelListItem(_loc8_);
                addChild(_loc9_);
                this.listItemArray.push(_loc9_);
                _loc9_.y = _loc4_;
                _loc4_ += _loc5_;
                if(_loc8_.id == param2)
                {
                    this.selectedListItem = _loc9_;
                }
                _loc7_++;
            }
            if(this.selectedListItem)
            {
                this.selectedListItem.selected = true;
                this.openSelection();
            }
            this.selectedCharacter = param3;
            focusRect = false;
            addEventListener(MouseEvent.MOUSE_OVER,this.mouseOverHandler);
            addEventListener(MouseEvent.MOUSE_OUT,this.mouseOutHandler);
            addEventListener(MouseEvent.MOUSE_DOWN,this.mouseDownHandler);
            addEventListener(MouseEvent.MOUSE_UP,this.mouseUpHandler);
            addEventListener(KeyboardEvent.KEY_DOWN,this.keyDownHandler);
        }
        
        private function keyDownHandler(param1:KeyboardEvent) : void
        {
            if(this.opening)
            {
                return;
            }
            switch(param1.keyCode)
            {
                case 38:
                    this.selectPreviousListItem();
                    break;
                case 40:
                    this.selectNextListItem();
            }
        }
        
        private function selectPreviousListItem() : void
        {
            var _loc1_:* = undefined;
            if(this.selectedListItem)
            {
                _loc1_ = this.listItemArray.indexOf(this.selectedListItem);
                if(_loc1_ == 0)
                {
                    return;
                }
                this.selectedListItem.selected = false;
                _loc1_--;
                this.selectedListItem = this.listItemArray[_loc1_];
                this.selectedListItem.selected = true;
                if(!this.closing)
                {
                    this.closeSelection();
                }
            }
        }
        
        private function selectNextListItem() : void
        {
            var _loc1_:* = undefined;
            if(this.selectedListItem)
            {
                _loc1_ = this.listItemArray.indexOf(this.selectedListItem);
                if(_loc1_ == this.listItemArray.length - 1)
                {
                    return;
                }
                this.selectedListItem.selected = false;
                _loc1_ += 1;
                this.selectedListItem = this.listItemArray[_loc1_];
                this.selectedListItem.selected = true;
                if(!this.closing)
                {
                    this.closeSelection();
                }
            }
        }
        
        private function mouseOverHandler(param1:MouseEvent) : void
        {
            var _loc2_:LevelListItem = null;
            if(param1.target is LevelListItem)
            {
                _loc2_ = param1.target as LevelListItem;
                if(!param1.buttonDown)
                {
                    _loc2_.rollOver();
                }
                else
                {
                    _loc2_.mouseDown();
                }
            }
        }
        
        private function mouseOutHandler(param1:MouseEvent) : void
        {
            var _loc2_:LevelListItem = null;
            if(param1.target is LevelListItem)
            {
                _loc2_ = param1.target as LevelListItem;
                _loc2_.rollOut();
            }
        }
        
        private function mouseDownHandler(param1:MouseEvent) : void
        {
            var _loc2_:LevelListItem = null;
            if(param1.target is LevelListItem)
            {
                _loc2_ = param1.target as LevelListItem;
                _loc2_.mouseDown();
            }
        }
        
        private function mouseUpHandler(param1:MouseEvent) : void
        {
            var _loc2_:LevelListItem = null;
            var _loc3_:MovieClip = null;
            trace(param1.target is LevelListItem);
            if(param1.target is LevelListItem)
            {
                _loc2_ = param1.target as LevelListItem;
                if(this.selectedListItem)
                {
                    if(_loc2_ != this.selectedListItem)
                    {
                        this.selectedListItem.selected = false;
                        this.selectedListItem = _loc2_;
                        this.selectedListItem.selected = true;
                    }
                    else
                    {
                        this.selectedListItem.selected = false;
                        this.selectedListItem = null;
                    }
                    if(!this.closing)
                    {
                        this.closeSelection();
                    }
                }
                else
                {
                    this.selectedListItem = _loc2_;
                    _loc2_.selected = true;
                    if(!this.closing)
                    {
                        this.openSelection();
                    }
                }
            }
            else if(param1.target is MovieClip)
            {
                _loc3_ = param1.target as MovieClip;
                if(_loc3_.name == "characterFaces")
                {
                    trace(_loc3_.currentFrame);
                    this.selectedCharacter = _loc3_.currentFrame;
                    dispatchEvent(new Event(LevelList.FACE_SELECTED));
                }
            }
        }
        
        public function closeSelection(param1:Boolean = false) : void
        {
            if(param1 && Boolean(this.selectedListItem))
            {
                this.selectedListItem.selected = false;
                this.selectedListItem = null;
            }
            this.closing = true;
            this.killLevelSelection();
            TweenLite.to(this,this.tweenTime,{
                "tweenVal":0,
                "ease":Strong.easeInOut,
                "onComplete":this.closingComplete
            });
        }
        
        private function killLevelSelection() : void
        {
            this.levelSelection.die();
            this.levelSelection.removeEventListener(NavigationEvent.SESSION,this.cloneAndDispatchEvent);
            this.levelSelection.removeEventListener(NavigationEvent.EDITOR,this.cloneAndDispatchEvent);
            this.levelSelection.removeEventListener(NavigationEvent.REPLAY_BROWSER,this.cloneAndDispatchEvent);
            this.levelSelection.removeEventListener(BrowserEvent.USER,this.cloneAndDispatchEvent);
            this.levelSelection.removeEventListener(BrowserEvent.FLAG,this.cloneAndDispatchEvent);
            this.levelSelection.removeEventListener(BrowserEvent.ADD_TO_FAVORITES,this.cloneAndDispatchEvent);
            this.levelSelection.removeEventListener(BrowserEvent.REMOVE_FROM_FAVORITES,this.cloneAndDispatchEvent);
        }
        
        public function get tweenVal() : Number
        {
            return this._tweenVal;
        }
        
        public function set tweenVal(param1:Number) : void
        {
            this._tweenVal = param1;
            this.levelSelection.maskHeight = Math.round(this.levelSelection.fullHeight * param1);
            this.organizeList();
            dispatchEvent(new Event(UPDATE_SCROLLER));
        }
        
        private function closingComplete() : void
        {
            this.closing = false;
            removeChild(this.levelSelection);
            this.levelSelection = null;
            if(this.selectedListItem)
            {
                this.openSelection();
            }
            else
            {
                this.organizeList();
                dispatchEvent(new Event(UPDATE_SCROLLER));
            }
        }
        
        private function openSelection() : void
        {
            var _loc1_:int = getChildIndex(this.selectedListItem) + 1;
            this.levelSelection = new LevelSelection(this.selectedListItem.levelDataObject);
            this.levelSelection.addEventListener(NavigationEvent.SESSION,this.cloneAndDispatchEvent);
            this.levelSelection.addEventListener(NavigationEvent.EDITOR,this.cloneAndDispatchEvent);
            this.levelSelection.addEventListener(NavigationEvent.REPLAY_BROWSER,this.cloneAndDispatchEvent);
            this.levelSelection.addEventListener(BrowserEvent.USER,this.cloneAndDispatchEvent);
            this.levelSelection.addEventListener(BrowserEvent.FLAG,this.cloneAndDispatchEvent);
            this.levelSelection.addEventListener(BrowserEvent.ADD_TO_FAVORITES,this.cloneAndDispatchEvent);
            this.levelSelection.addEventListener(BrowserEvent.REMOVE_FROM_FAVORITES,this.cloneAndDispatchEvent);
            addChildAt(this.levelSelection,_loc1_);
            this.levelSelection.maskHeight = 0;
            this.opening = true;
            TweenLite.to(this,this.tweenTime,{
                "tweenVal":1,
                "ease":Strong.easeInOut,
                "onComplete":this.openComplete
            });
        }
        
        private function openComplete() : void
        {
            this.opening = false;
        }
        
        private function cloneAndDispatchEvent(param1:Event) : void
        {
            var _loc2_:Event = param1.clone();
            dispatchEvent(_loc2_);
        }
        
        private function organizeList() : void
        {
            var _loc1_:Number = NaN;
            var _loc3_:DisplayObject = null;
            var _loc5_:int = 0;
            var _loc7_:Number = NaN;
            var _loc8_:Number = NaN;
            if(this.selectedListItem)
            {
                _loc1_ = this.selectedListItem.y;
            }
            var _loc2_:int = numChildren;
            var _loc4_:int = 0;
            var _loc6_:int = 0;
            while(_loc6_ < _loc2_)
            {
                _loc3_ = getChildAt(_loc6_);
                _loc3_.y = _loc4_;
                if(_loc3_ is LevelListItem)
                {
                    _loc5_ = LevelListItem.BG_HEIGHT;
                }
                else if(_loc3_ is LevelSelection)
                {
                    _loc5_ = (_loc3_ as LevelSelection).maskHeight;
                }
                else
                {
                    _loc5_ = _loc3_.height;
                }
                _loc4_ += _loc5_;
                _loc6_++;
            }
            if(this.selectedListItem)
            {
                _loc7_ = _loc1_ - this.selectedListItem.y;
                y += _loc7_;
                _loc7_ = y + this.selectedListItem.y;
                if(_loc7_ < 0)
                {
                    y -= _loc7_;
                }
            }
            if(Boolean(this.levelSelection) && this.opening)
            {
                _loc8_ = this.levelSelection.y + this.levelSelection.maskHeight;
                _loc7_ = 352 - y - _loc8_;
                if(_loc7_ < 0)
                {
                    y += _loc7_;
                }
            }
        }
        
        override public function get height() : Number
        {
            var _loc1_:Number = numChildren * LevelListItem.BG_HEIGHT;
            if(this.levelSelection)
            {
                _loc1_ += this.levelSelection.maskHeight - LevelListItem.BG_HEIGHT;
            }
            return _loc1_;
        }
        
        override public function set height(param1:Number) : void
        {
            throw new Error("cannot set list height manually");
        }
        
        public function get selectedCharacter() : int
        {
            return this._selectedCharacter;
        }
        
        public function set selectedCharacter(param1:int) : void
        {
            var _loc2_:int = 0;
            var _loc3_:int = 0;
            var _loc4_:LevelListItem = null;
            var _loc5_:int = 0;
            if(param1 > 0 && this._selectedCharacter != param1)
            {
                this._highlightedArray = new Array();
                _loc2_ = int(this.listItemArray.length);
                _loc3_ = 0;
                while(_loc3_ < _loc2_)
                {
                    _loc4_ = this.listItemArray[_loc3_];
                    _loc5_ = _loc4_.characterFaces.currentFrame;
                    if(_loc5_ == param1)
                    {
                        _loc4_.faded = false;
                        this._highlightedArray.push(_loc4_);
                    }
                    else
                    {
                        _loc4_.faded = true;
                    }
                    _loc3_++;
                }
                this._selectedCharacter = param1;
            }
            else
            {
                this._highlightedArray = null;
                _loc2_ = int(this.listItemArray.length);
                _loc3_ = 0;
                while(_loc3_ < _loc2_)
                {
                    _loc4_ = this.listItemArray[_loc3_];
                    _loc5_ = _loc4_.characterFaces.currentFrame;
                    _loc4_.faded = false;
                    _loc3_++;
                }
                this._selectedCharacter = -1;
                dispatchEvent(new Event(FACE_SELECTED));
            }
        }
        
        public function get highlightedArray() : Array
        {
            return this._highlightedArray;
        }
        
        public function die() : void
        {
            removeEventListener(MouseEvent.MOUSE_OVER,this.mouseOverHandler);
            removeEventListener(MouseEvent.MOUSE_OUT,this.mouseOutHandler);
            removeEventListener(MouseEvent.MOUSE_DOWN,this.mouseDownHandler);
            removeEventListener(MouseEvent.MOUSE_UP,this.mouseUpHandler);
            removeEventListener(KeyboardEvent.KEY_DOWN,this.keyDownHandler);
            if(this.levelSelection)
            {
                this.killLevelSelection();
            }
        }
    }
}

