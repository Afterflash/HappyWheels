package com.totaljerkface.game.editor.ui
{
    import flash.display.Sprite;
    
    public class SpecialExpandItem extends SpecialListItem
    {
        private var holder:Sprite;
        
        private var symbol:Sprite = new Sprite();
        
        private var _expanded:Boolean;
        
        public function SpecialExpandItem(param1:String, param2:int = 0, param3:int = 100)
        {
            super(param1,"",param2,param3);
            _downBgColor = 8825545;
            addChild(this.symbol);
            this.symbol.y = 7;
            this.symbol.x = 5 + param2 * 13;
            this.symbol.mouseEnabled = false;
            textField.x = this.symbol.x + 12;
            this.holder = new Sprite();
            this.holder.y = _bgHeight;
        }
        
        public function addChildItem(param1:SpecialListItem) : void
        {
            this.holder.addChild(param1);
            param1.x = 0;
            param1.y = (this.holder.numChildren - 1) * _bgHeight;
            param1.parentItem = this;
        }
        
        public function get expanded() : Boolean
        {
            return this._expanded;
        }
        
        public function set expanded(param1:Boolean) : void
        {
            if(param1 == this._expanded)
            {
                return;
            }
            this._expanded = param1;
            if(this._expanded)
            {
                addChild(this.holder);
            }
            else if(this.holder.parent)
            {
                removeChild(this.holder);
            }
            this.drawSymbol();
        }
        
        override protected function drawSymbol() : void
        {
            this.symbol.graphics.clear();
            var _loc1_:uint = textField.textColor;
            if(this._expanded)
            {
                this.symbol.graphics.beginFill(_loc1_);
                this.symbol.graphics.drawRect(0,4,9,1);
                this.symbol.graphics.endFill();
            }
            else
            {
                this.symbol.graphics.beginFill(_loc1_);
                this.symbol.graphics.drawRect(0,4,9,1);
                this.symbol.graphics.endFill();
                this.symbol.graphics.beginFill(_loc1_);
                this.symbol.graphics.drawRect(4,0,1,9);
                this.symbol.graphics.endFill();
            }
        }
        
        override public function get height() : Number
        {
            var _loc1_:Number = NaN;
            var _loc2_:int = 0;
            var _loc3_:SpecialListItem = null;
            if(this._expanded)
            {
                _loc1_ = _bgHeight;
                _loc2_ = 0;
                while(_loc2_ < this.holder.numChildren)
                {
                    _loc3_ = this.holder.getChildAt(_loc2_) as SpecialListItem;
                    _loc1_ += _loc3_.height;
                    _loc2_++;
                }
                return _loc1_;
            }
            return _bgHeight;
        }
        
        public function organizeChildren() : void
        {
            var _loc1_:Number = NaN;
            var _loc3_:SpecialListItem = null;
            _loc1_ = 0;
            var _loc2_:int = 0;
            while(_loc2_ < this.holder.numChildren)
            {
                _loc3_ = this.holder.getChildAt(_loc2_) as SpecialListItem;
                _loc3_.y = _loc1_;
                _loc1_ += _loc3_.height;
                _loc2_++;
            }
        }
    }
}

