package com.totaljerkface.game.editor.ui
{
    import com.totaljerkface.game.*;
    import com.totaljerkface.game.editor.*;
    import com.totaljerkface.game.editor.specials.*;
    import com.totaljerkface.game.sound.SoundController;
    import com.totaljerkface.game.sound.SoundList;
    import flash.display.*;
    import flash.events.*;
    import flash.media.Sound;
    import flash.media.SoundChannel;
    import flash.utils.*;
    
    public class ListMenu extends Sprite
    {
        public static const ITEM_SELECTED:String = "itemselected";
        
        private var _selectedItem:SpecialListItem;
        
        private var lastRolledItem:SpecialListItem;
        
        private var mouseItem:SpecialListItem;
        
        private var holder:Sprite;
        
        private var listMask:Sprite;
        
        private var list:Sprite;
        
        private var scroller:SpecialListScroller;
        
        private var entryList:Array;
        
        private var initialEntry:String;
        
        private var playSound:Boolean;
        
        private var playSprite:Sprite;
        
        private var soundChannel:SoundChannel;
        
        private const maxHeight:int = 220;
        
        private var maskHeight:int = 220;
        
        private var totalHeight:int = 224;
        
        private var totalWidth:int = 154;
        
        private var itemWidth:int = 150;
        
        private var scrollable:Boolean;
        
        public function ListMenu(param1:Array, param2:String, param3:Boolean = false, param4:Boolean = false)
        {
            super();
            this.entryList = param1;
            if(!param4)
            {
                this.initialEntry = param2;
            }
            this.playSound = param3;
            this.init();
        }
        
        private function init() : void
        {
            this.createList();
            this.list.addEventListener(MouseEvent.MOUSE_UP,this.mouseUpHandler);
            this.list.addEventListener(MouseEvent.MOUSE_OVER,this.mouseOverHandler);
            if(this.scrollable)
            {
                this.holder.addEventListener(Event.ENTER_FRAME,this.enterFrameHandler);
            }
        }
        
        private function createList() : void
        {
            var _loc3_:Object = null;
            var _loc4_:SpecialListItem = null;
            var _loc5_:SpecialExpandItem = null;
            var _loc6_:Number = NaN;
            var _loc7_:Number = NaN;
            var _loc8_:Number = NaN;
            var _loc9_:DisplayObjectContainer = null;
            var _loc10_:DisplayObject = null;
            var _loc11_:int = 0;
            this.holder = new Sprite();
            this.holder.y = 2;
            this.holder.x = 2;
            addChild(this.holder);
            this.listMask = new Sprite();
            this.listMask.graphics.beginFill(0);
            this.listMask.graphics.drawRect(0,0,this.itemWidth,this.maskHeight);
            this.listMask.graphics.endFill();
            this.holder.addChild(this.listMask);
            this.list = new Sprite();
            this.holder.addChildAt(this.list,0);
            this.list.mask = this.listMask;
            var _loc1_:int = 0;
            var _loc2_:int = 0;
            while(_loc2_ < this.entryList.length)
            {
                _loc3_ = this.entryList[_loc2_];
                _loc4_ = this.createItem(_loc3_,0);
                this.list.addChild(_loc4_);
                _loc1_ += _loc4_.height;
                _loc2_++;
            }
            if(_loc1_ >= this.maxHeight)
            {
                this.scrollable = true;
                this.maskHeight = this.maxHeight;
            }
            else
            {
                this.maskHeight = _loc1_;
            }
            this.totalHeight = this.maskHeight + 4;
            graphics.beginFill(10066329);
            graphics.drawRect(0,0,this.totalWidth,this.totalHeight);
            graphics.endFill();
            if(this._selectedItem)
            {
                if(this._selectedItem.parentItem)
                {
                    _loc5_ = this._selectedItem.parentItem;
                    while(_loc5_)
                    {
                        _loc5_.expanded = true;
                        _loc5_ = _loc5_.parentItem;
                    }
                }
                this.organizeList();
                if(this.scrollable)
                {
                    _loc6_ = this.list.height;
                    _loc7_ = Math.round(this.maskHeight * 0.5);
                    _loc8_ = 0;
                    _loc9_ = this._selectedItem.parent;
                    _loc10_ = this._selectedItem;
                    while(_loc10_ != this.list)
                    {
                        _loc8_ += _loc10_.y;
                        _loc10_ = _loc9_;
                        _loc9_ = _loc10_.parent;
                    }
                    _loc11_ = _loc7_ - _loc8_;
                    this.list.y = _loc11_ - 11;
                }
            }
            else
            {
                this.organizeList();
            }
        }
        
        private function createItem(param1:Object, param2:int) : SpecialListItem
        {
            var _loc3_:Array = null;
            var _loc4_:SpecialExpandItem = null;
            var _loc5_:int = 0;
            var _loc6_:Object = null;
            var _loc7_:String = null;
            var _loc8_:SpecialListItem = null;
            if(param1 is Array)
            {
                _loc3_ = param1 as Array;
                _loc4_ = new SpecialExpandItem(_loc3_[0] as String,param2,this.itemWidth);
                _loc5_ = 1;
                while(_loc5_ < _loc3_.length)
                {
                    _loc6_ = _loc3_[_loc5_];
                    _loc4_.addChildItem(this.createItem(_loc6_,param2 + 1));
                    _loc5_++;
                }
                return _loc4_;
            }
            _loc7_ = param1 as String;
            _loc8_ = new SpecialListItem(_loc7_,_loc7_,param2,this.itemWidth);
            if(_loc7_ == this.initialEntry)
            {
                this._selectedItem = _loc8_;
                this._selectedItem.selected = true;
            }
            return _loc8_;
        }
        
        private function organizeList() : void
        {
            var _loc3_:DisplayObject = null;
            var _loc1_:int = 0;
            var _loc2_:int = 0;
            while(_loc2_ < this.list.numChildren)
            {
                _loc3_ = this.list.getChildAt(_loc2_);
                _loc3_.y = _loc1_;
                _loc1_ += _loc3_.height;
                if(_loc3_ is SpecialExpandItem)
                {
                    (_loc3_ as SpecialExpandItem).organizeChildren();
                }
                _loc2_++;
            }
        }
        
        private function mouseUpHandler(param1:MouseEvent) : void
        {
            var _loc2_:SpecialExpandItem = null;
            var _loc3_:String = null;
            var _loc4_:String = null;
            var _loc5_:Class = null;
            var _loc6_:Sound = null;
            if(param1.target is SpecialExpandItem)
            {
                _loc2_ = param1.target as SpecialExpandItem;
                _loc2_.expanded = !_loc2_.expanded;
                this.organizeList();
            }
            else if(param1.target is SpecialListItem)
            {
                if(this._selectedItem)
                {
                    if(this._selectedItem == param1.target)
                    {
                        return;
                    }
                    this._selectedItem.selected = false;
                }
                this._selectedItem = param1.target as SpecialListItem;
                this._selectedItem.selected = true;
                dispatchEvent(new Event(ITEM_SELECTED));
            }
            else if(param1.target == this.playSprite && this.playSound)
            {
                _loc3_ = this.mouseItem.value;
                _loc4_ = SoundList.instance.sfxDictionary[_loc3_];
                _loc5_ = getDefinitionByName(SoundController.SOUND_PATH + _loc4_) as Class;
                _loc6_ = new _loc5_();
                if(this.soundChannel)
                {
                    this.soundChannel.stop();
                }
                this.soundChannel = _loc6_.play();
            }
        }
        
        private function mouseOverHandler(param1:MouseEvent) : void
        {
            var _loc2_:SpecialListItem = null;
            if(param1.target is SpecialListItem)
            {
                _loc2_ = param1.target as SpecialListItem;
                if(this.lastRolledItem)
                {
                    this.lastRolledItem.rollOut();
                }
                this.lastRolledItem = _loc2_;
                this.lastRolledItem.rollOver();
                if(_loc2_ is SpecialExpandItem || !this.playSound)
                {
                    return;
                }
                if(!this.playSprite)
                {
                    this.playSprite = new ListPlayButton();
                    this.playSprite.buttonMode = true;
                    this.playSprite.x = 135;
                    this.playSprite.y = 11;
                }
                this.mouseItem = param1.target as SpecialListItem;
                this.mouseItem.addChild(this.playSprite);
            }
        }
        
        private function enterFrameHandler(param1:Event) : void
        {
            var _loc7_:Number = NaN;
            var _loc2_:Number = this.maskHeight * 0.5;
            var _loc3_:Number = 30;
            var _loc4_:Number = _loc2_ - _loc3_;
            var _loc5_:Number = _loc2_ + _loc3_;
            if(this.holder.mouseY < _loc4_)
            {
                _loc7_ = this.holder.mouseY - _loc4_;
            }
            else if(this.holder.mouseY > _loc5_)
            {
                _loc7_ = this.holder.mouseY - _loc5_;
            }
            else
            {
                _loc7_ = 0;
            }
            var _loc6_:Number = 10 * (_loc7_ / _loc4_);
            this.list.y -= _loc6_;
            if(this.list.y > 0)
            {
                this.list.y = 0;
            }
            if(this.list.y < this.maskHeight - this.list.height)
            {
                this.list.y = this.maskHeight - this.list.height;
            }
        }
        
        public function get selectedEntry() : String
        {
            return this._selectedItem.value;
        }
        
        override public function get height() : Number
        {
            return this.totalHeight;
        }
        
        public function die() : void
        {
            if(this.soundChannel)
            {
                this.soundChannel.stop();
            }
            this.list.removeEventListener(MouseEvent.MOUSE_UP,this.mouseUpHandler);
            this.list.removeEventListener(MouseEvent.MOUSE_OVER,this.mouseOverHandler);
            this.holder.removeEventListener(Event.ENTER_FRAME,this.enterFrameHandler);
        }
    }
}

