package com.totaljerkface.game.editor.ui
{
    import com.totaljerkface.game.*;
    import com.totaljerkface.game.editor.*;
    import com.totaljerkface.game.editor.specials.*;
    import flash.display.*;
    import flash.events.*;
    import flash.utils.*;
    
    public class SpecialMenu extends Sprite
    {
        public static const SPECIAL_CHOSEN:String = "specialchosen";
        
        private static const specialList:Array = [["building blocks","IBeamRef","LogRef","RailRef"],["hazards","ArrowGunRef","HarpoonGunRef","HomingMineRef","MineRef","SpikesRef","WreckingBallRef"],["movement","CannonRef","BoostRef","FanRef","JetRef","SpringBoxRef","PaddleRef"],["characters","NPCharacterRef"],["buildings","Building1Ref","Building2Ref"],["miscellaneous","BladeWeaponRef","FoodItemRef","ChainRef","GlassRef","MeteorRef","TableRef","ChairRef","BottleRef","TVRef","BoomboxRef","SoccerBallRef","VanRef","SignPostRef","TrashCanRef","ToiletRef"],"TokenRef","FinishLineRef"];
        
        private var _selectedItem:SpecialListItem;
        
        private var lastRolledItem:SpecialListItem;
        
        private var holder:Sprite;
        
        private var listMask:Sprite;
        
        private var list:Sprite;
        
        private var scroller:SpecialListScroller;
        
        private var bgSquare:ConcaveSquare;
        
        private const listHeight:int = 220;
        
        private const totalHeight:int = 224;
        
        private const totalWidth:int = 154;
        
        private const itemWidth:int = 150;
        
        public function SpecialMenu()
        {
            super();
            this.init();
        }
        
        private function init() : void
        {
            this.createList();
            this.list.addEventListener(MouseEvent.MOUSE_UP,this.mouseUpHandler);
            this.list.addEventListener(MouseEvent.MOUSE_OVER,this.mouseOverHandler);
        }
        
        private function createList() : void
        {
            var _loc2_:Object = null;
            var _loc3_:SpecialListItem = null;
            this.bgSquare = new ConcaveSquare(this.totalWidth,this.listHeight + 4,10066329);
            this.bgSquare.y = this.totalHeight - (this.listHeight + 4);
            addChild(this.bgSquare);
            this.holder = new Sprite();
            this.holder.y = this.bgSquare.y + 2;
            this.holder.x = 2;
            addChild(this.holder);
            this.listMask = new Sprite();
            this.listMask.graphics.beginFill(0);
            this.listMask.graphics.drawRect(0,0,this.itemWidth,this.listHeight);
            this.listMask.graphics.endFill();
            this.holder.addChild(this.listMask);
            this.list = new Sprite();
            this.holder.addChildAt(this.list,0);
            this.list.mask = this.listMask;
            var _loc1_:int = 0;
            while(_loc1_ < specialList.length)
            {
                _loc2_ = specialList[_loc1_];
                _loc3_ = this.createItem(_loc2_,0);
                this.list.addChild(_loc3_);
                _loc1_++;
            }
            this.organizeList();
            this.scroller = new SpecialListScroller(this.list,this.listMask,22);
            this.holder.addChild(this.scroller);
            this.scroller.x = this.itemWidth - 12;
        }
        
        private function createItem(param1:Object, param2:int) : SpecialListItem
        {
            var _loc3_:Array = null;
            var _loc4_:SpecialExpandItem = null;
            var _loc5_:int = 0;
            var _loc6_:Object = null;
            var _loc7_:String = null;
            var _loc8_:Class = null;
            var _loc9_:Special = null;
            var _loc10_:SpecialListItem = null;
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
            _loc8_ = getDefinitionByName(Settings.specialClassPath + _loc7_) as Class;
            _loc9_ = new _loc8_();
            _loc10_ = new SpecialListItem(_loc9_.name,_loc7_,param2,this.itemWidth);
            if(!this._selectedItem)
            {
                this._selectedItem = _loc10_;
                this._selectedItem.selected = true;
            }
            return _loc10_;
        }
        
        private function organizeList() : void
        {
            var _loc1_:int = 0;
            var _loc3_:DisplayObject = null;
            _loc1_ = 0;
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
            if(param1.target is SpecialExpandItem)
            {
                _loc2_ = param1.target as SpecialExpandItem;
                _loc2_.expanded = !_loc2_.expanded;
                this.organizeList();
                this.scroller.updateScrollTab();
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
                dispatchEvent(new Event(SPECIAL_CHOSEN));
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
            }
        }
        
        public function get selectedClassName() : String
        {
            return this._selectedItem.value;
        }
        
        override public function get height() : Number
        {
            return this.totalHeight;
        }
        
        override public function get width() : Number
        {
            return this.totalWidth;
        }
        
        public function die() : void
        {
            this.list.removeEventListener(MouseEvent.MOUSE_UP,this.mouseUpHandler);
            this.list.removeEventListener(MouseEvent.MOUSE_OVER,this.mouseOverHandler);
            this.scroller.die();
        }
    }
}

