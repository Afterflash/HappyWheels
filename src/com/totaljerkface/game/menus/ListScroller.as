package com.totaljerkface.game.menus
{
    import flash.display.*;
    import flash.events.*;
    import flash.filters.BevelFilter;
    import flash.filters.DropShadowFilter;
    import flash.geom.Rectangle;
    import flash.text.*;
    import flash.utils.Dictionary;
    
    public class ListScroller extends Sprite
    {
        protected var scrollTab:Sprite;
        
        protected var bg:Sprite;
        
        protected var tickHolder:Sprite;
        
        protected var tickDictionary:Dictionary;
        
        protected var content:Sprite;
        
        protected var maskSprite:Sprite;
        
        protected var dragging:Boolean;
        
        protected var stepDistance:int;
        
        public function ListScroller(param1:Sprite, param2:Sprite, param3:int = 10)
        {
            super();
            this.content = param1;
            this.maskSprite = param2;
            this.stepDistance = param3;
            this.createParts();
            this.bg.height = param2.height;
            this.updateScrollTab();
            addEventListener(MouseEvent.MOUSE_DOWN,this.mouseDownHandler);
            param1.addEventListener(MouseEvent.MOUSE_WHEEL,this.mouseWheelHandler);
        }
        
        protected function createParts() : void
        {
            this.bg = new Sprite();
            addChild(this.bg);
            this.bg.graphics.beginFill(16777215);
            this.bg.graphics.drawRoundRect(0,0,20,100,0,0);
            this.bg.graphics.endFill();
            this.bg.scale9Grid = new Rectangle(5,5,10,90);
            this.bg.blendMode = BlendMode.OVERLAY;
            var _loc1_:DropShadowFilter = new DropShadowFilter(2,90,0,1,4,4,0.25,3,true);
            this.bg.filters = [_loc1_];
            this.scrollTab = new Sprite();
            addChild(this.scrollTab);
            this.scrollTab.graphics.beginFill(10066329);
            this.scrollTab.graphics.drawRoundRect(0,0,20,100,10,10);
            this.scrollTab.graphics.endFill();
            this.scrollTab.scale9Grid = new Rectangle(5,5,10,90);
            var _loc2_:BevelFilter = new BevelFilter(5,90,16777215,0.3,0,0.3,5,5,1,3);
            _loc1_ = new DropShadowFilter(7.5,90,0,1,10,10,0.4,3);
            this.scrollTab.filters = [_loc2_,_loc1_];
            this.tickHolder = new Sprite();
            this.tickHolder.alpha = 0.5;
            this.tickHolder.mouseChildren = false;
            this.tickHolder.mouseEnabled = false;
            addChild(this.tickHolder);
        }
        
        public function updateScrollTab() : void
        {
            var _loc2_:* = undefined;
            var _loc3_:Sprite = null;
            var _loc4_:Sprite = null;
            this.adjustContentLimits();
            var _loc1_:Number = this.maskSprite.height / this.content.height;
            if(_loc1_ > 1)
            {
                _loc1_ = 1;
            }
            this.scrollTab.height = _loc1_ * this.bg.height;
            this.scrollTab.y = this.content.y * -this.bg.height / this.content.height;
            if(this.tickDictionary)
            {
                for(_loc2_ in this.tickDictionary)
                {
                    _loc3_ = _loc2_ as Sprite;
                    _loc4_ = this.tickDictionary[_loc2_];
                    _loc4_.y = _loc3_.y * _loc1_;
                    _loc4_.height = _loc3_.height * _loc1_;
                }
            }
        }
        
        protected function updateContent(param1:MouseEvent = null) : void
        {
            this.content.y = this.scrollTab.y * this.content.height / -this.bg.height;
        }
        
        protected function mouseDownHandler(param1:MouseEvent) : void
        {
            switch(param1.target)
            {
                case this.scrollTab:
                    if(!this.dragging)
                    {
                        this.startScrollDrag();
                    }
                    break;
                case this.bg:
                    this.bgPress();
            }
        }
        
        private function mouseWheelHandler(param1:MouseEvent) : void
        {
            var _loc2_:Boolean = param1.delta < 0 ? true : false;
            this.step(_loc2_);
        }
        
        protected function bgPress() : void
        {
            if(mouseY > this.scrollTab.y)
            {
                this.scrollTab.y += this.scrollTab.height;
                if(this.scrollTab.y + this.scrollTab.height > this.bg.height)
                {
                    this.scrollTab.y = this.bg.height - this.scrollTab.height;
                }
            }
            else
            {
                this.scrollTab.y -= this.scrollTab.height;
                if(this.scrollTab.y < 0)
                {
                    this.scrollTab.y = 0;
                }
            }
            this.updateContent();
        }
        
        protected function mouseUpHandler(param1:MouseEvent) : void
        {
            stage.removeEventListener(MouseEvent.MOUSE_UP,this.mouseUpHandler);
            stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.updateContent);
            this.stopScrollDrag();
            stage.focus = this.content;
        }
        
        protected function startScrollDrag() : void
        {
            this.dragging = true;
            stage.addEventListener(MouseEvent.MOUSE_UP,this.mouseUpHandler,false,0,true);
            stage.addEventListener(MouseEvent.MOUSE_MOVE,this.updateContent,false,0,true);
            this.scrollTab.startDrag(false,new Rectangle(0,0,0,this.bg.height - this.scrollTab.height));
        }
        
        protected function stopScrollDrag() : void
        {
            this.dragging = false;
            this.scrollTab.stopDrag();
            this.updateContent();
        }
        
        public function step(param1:Boolean = true) : void
        {
            var _loc2_:Number = this.maskSprite.height / this.content.height;
            if(_loc2_ > 1)
            {
                return;
            }
            if(param1)
            {
                this.content.y -= this.stepDistance;
            }
            else
            {
                this.content.y += this.stepDistance;
            }
            this.updateScrollTab();
        }
        
        public function adjustContentLimits() : void
        {
            if(this.content.y + this.content.height < this.maskSprite.height)
            {
                this.content.y = this.maskSprite.height - this.content.height;
            }
            if(this.content.y > 0)
            {
                this.content.y = 0;
            }
        }
        
        public function addTickMarks(param1:Array) : void
        {
            var _loc4_:Sprite = null;
            var _loc5_:Sprite = null;
            this.removeTickMarks();
            var _loc2_:Number = this.maskSprite.height / this.content.height;
            if(_loc2_ > 1)
            {
                _loc2_ = 1;
            }
            this.tickDictionary = new Dictionary(true);
            var _loc3_:int = 0;
            while(_loc3_ < param1.length)
            {
                _loc4_ = param1[_loc3_] as Sprite;
                _loc5_ = new Sprite();
                _loc5_.graphics.beginFill(4032711);
                _loc5_.graphics.drawRect(0,0,20,10);
                _loc5_.graphics.endFill();
                this.tickHolder.addChild(_loc5_);
                _loc5_.y = _loc4_.y * _loc2_;
                _loc5_.height = _loc4_.height * _loc2_;
                this.tickDictionary[_loc4_] = _loc5_;
                _loc3_++;
            }
        }
        
        public function removeTickMarks() : void
        {
            var _loc1_:* = undefined;
            var _loc2_:Sprite = null;
            if(this.tickDictionary)
            {
                for(_loc1_ in this.tickDictionary)
                {
                    _loc2_ = this.tickDictionary[_loc1_];
                    this.tickHolder.removeChild(_loc2_);
                    delete this.tickDictionary[_loc1_];
                }
                this.tickDictionary = null;
            }
        }
        
        public function die() : void
        {
            if(stage)
            {
                stage.removeEventListener(MouseEvent.MOUSE_UP,this.mouseUpHandler);
                stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.updateContent);
            }
            removeEventListener(MouseEvent.MOUSE_DOWN,this.mouseDownHandler);
            this.content.removeEventListener(MouseEvent.MOUSE_WHEEL,this.mouseWheelHandler);
        }
    }
}

