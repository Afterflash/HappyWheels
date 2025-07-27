package com.totaljerkface.game.menus
{
    import com.totaljerkface.game.events.*;
    import flash.display.*;
    import flash.events.*;
    import gs.*;
    import gs.easing.*;
    
    public class ReplayList extends Sprite
    {
        public static const UPDATE_SCROLLER:String = "updatescroller";
        
        public static const FACE_SELECTED:String = "faceselected";
        
        private var replaySelection:ReplaySelection;
        
        private var listItemArray:Array;
        
        private var selectedListItem:ReplayListItem;
        
        private var nextSelectedListItem:ReplayListItem;
        
        private var _selectedCharacter:int;
        
        private var _highlightedArray:Array;
        
        private var _inaccurateHidden:Boolean;
        
        private var _tweenVal:Number = 0;
        
        private var tweenTime:Number = 0.25;
        
        private var opening:Boolean;
        
        private var closing:Boolean;
        
        public function ReplayList(param1:Array, param2:int = -1, param3:int = -1, param4:Boolean = false)
        {
            var _loc9_:ReplayDataObject = null;
            var _loc10_:ReplayListItem = null;
            super();
            this.listItemArray = new Array();
            var _loc5_:int = 0;
            var _loc6_:int = ReplayListItem.BG_HEIGHT;
            var _loc7_:int = int(param1.length);
            var _loc8_:int = 0;
            while(_loc8_ < _loc7_)
            {
                _loc9_ = param1[_loc8_];
                _loc10_ = new ReplayListItem(_loc9_);
                addChild(_loc10_);
                this.listItemArray.push(_loc10_);
                _loc10_.y = _loc5_;
                _loc5_ += _loc10_.height;
                if(_loc9_.id == param2)
                {
                    this.selectedListItem = _loc10_;
                }
                _loc8_++;
            }
            if(this.selectedListItem)
            {
                this.selectedListItem.selected = true;
                this.openSelection();
            }
            this.selectedCharacter = param3;
            this.inaccurateHidden = param4;
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
            var _loc2_:ReplayListItem = null;
            if(param1.target is ReplayListItem)
            {
                _loc2_ = param1.target as ReplayListItem;
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
            var _loc2_:ReplayListItem = null;
            if(param1.target is ReplayListItem)
            {
                _loc2_ = param1.target as ReplayListItem;
                _loc2_.rollOut();
            }
        }
        
        private function mouseDownHandler(param1:MouseEvent) : void
        {
            var _loc2_:ReplayListItem = null;
            if(param1.target is ReplayListItem)
            {
                _loc2_ = param1.target as ReplayListItem;
                _loc2_.mouseDown();
            }
        }
        
        private function mouseUpHandler(param1:MouseEvent) : void
        {
            var _loc2_:ReplayListItem = null;
            var _loc3_:MovieClip = null;
            if(param1.target is ReplayListItem)
            {
                _loc2_ = param1.target as ReplayListItem;
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
                    dispatchEvent(new Event(ReplayList.FACE_SELECTED));
                }
            }
        }
        
        private function closeSelection() : void
        {
            this.closing = true;
            this.killReplaySelection();
            TweenLite.to(this,this.tweenTime,{
                "tweenVal":0,
                "ease":Strong.easeInOut,
                "onComplete":this.closingComplete
            });
        }
        
        private function killReplaySelection() : void
        {
            this.replaySelection.die();
            this.replaySelection.removeEventListener(NavigationEvent.SESSION,this.cloneAndDispatchEvent);
            this.replaySelection.removeEventListener(BrowserEvent.FLAG,this.cloneAndDispatchEvent);
        }
        
        public function get tweenVal() : Number
        {
            return this._tweenVal;
        }
        
        public function set tweenVal(param1:Number) : void
        {
            this._tweenVal = param1;
            this.replaySelection.maskHeight = Math.round(this.replaySelection.height * param1);
            this.organizeList();
            dispatchEvent(new Event(UPDATE_SCROLLER));
        }
        
        private function closingComplete() : void
        {
            this.closing = false;
            removeChild(this.replaySelection);
            this.replaySelection = null;
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
            this.replaySelection = new ReplaySelection(this.selectedListItem.replayDataObject);
            this.replaySelection.addEventListener(NavigationEvent.SESSION,this.cloneAndDispatchEvent);
            this.replaySelection.addEventListener(BrowserEvent.FLAG,this.cloneAndDispatchEvent);
            addChildAt(this.replaySelection,_loc1_);
            this.replaySelection.maskHeight = 0;
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
            trace("Replay list clone event");
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
                if(_loc3_ is ReplayListItem)
                {
                    _loc5_ = (_loc3_ as ReplayListItem).height;
                }
                else if(_loc3_ is ReplaySelection)
                {
                    _loc5_ = (_loc3_ as ReplaySelection).maskHeight;
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
            if(Boolean(this.replaySelection) && this.opening)
            {
                _loc8_ = this.replaySelection.y + this.replaySelection.maskHeight;
                _loc7_ = 352 - y - _loc8_;
                if(_loc7_ < 0)
                {
                    y += _loc7_;
                }
            }
        }
        
        override public function get height() : Number
        {
            var _loc4_:ReplayListItem = null;
            var _loc1_:Number = 0;
            var _loc2_:int = int(this.listItemArray.length);
            var _loc3_:int = 0;
            while(_loc3_ < _loc2_)
            {
                _loc4_ = this.listItemArray[_loc3_];
                _loc1_ += _loc4_.height;
                _loc3_++;
            }
            if(this.replaySelection)
            {
                _loc1_ += this.replaySelection.maskHeight;
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
            var _loc4_:ReplayListItem = null;
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
        
        public function get inaccurateHidden() : Boolean
        {
            return this._inaccurateHidden;
        }
        
        public function set inaccurateHidden(param1:Boolean) : void
        {
            var _loc3_:int = 0;
            var _loc4_:ReplayListItem = null;
            var _loc2_:int = int(this.listItemArray.length);
            trace("INNACURATE HIDDEN " + param1);
            if(param1)
            {
                _loc3_ = 0;
                while(_loc3_ < _loc2_)
                {
                    _loc4_ = this.listItemArray[_loc3_];
                    _loc4_.hidden = !_loc4_.accurate;
                    if(_loc4_.hidden)
                    {
                        if(this.selectedListItem)
                        {
                            if(_loc4_ == this.selectedListItem)
                            {
                                this.selectedListItem.selected = false;
                                this.selectedListItem = null;
                                if(this.replaySelection)
                                {
                                    this.closeSelection();
                                }
                            }
                        }
                    }
                    _loc3_++;
                }
            }
            else
            {
                _loc3_ = 0;
                while(_loc3_ < _loc2_)
                {
                    _loc4_ = this.listItemArray[_loc3_];
                    _loc4_.hidden = false;
                    _loc3_++;
                }
            }
            this._inaccurateHidden = param1;
            this.organizeList();
            dispatchEvent(new Event(UPDATE_SCROLLER));
        }
        
        public function die() : void
        {
            removeEventListener(MouseEvent.MOUSE_OVER,this.mouseOverHandler);
            removeEventListener(MouseEvent.MOUSE_OUT,this.mouseOutHandler);
            removeEventListener(MouseEvent.MOUSE_DOWN,this.mouseDownHandler);
            removeEventListener(MouseEvent.MOUSE_UP,this.mouseUpHandler);
            removeEventListener(KeyboardEvent.KEY_DOWN,this.keyDownHandler);
            if(this.replaySelection)
            {
                this.killReplaySelection();
            }
        }
    }
}

