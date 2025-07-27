package com.totaljerkface.game.level.visuals
{
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.Sprite;
    import flash.filters.BlurFilter;
    import flash.geom.Matrix;
    
    public class BackDrop extends Sprite
    {
        protected var _visual:Sprite;
        
        protected var _multiplier:Number;
        
        protected var blur:int;
        
        protected var quality:int;
        
        protected var transparent:Boolean;
        
        public function BackDrop(param1:Sprite, param2:Number, param3:Boolean, param4:int = 0, param5:int = 3)
        {
            super();
            this._visual = param1;
            this._multiplier = param2;
            this.blur = param4;
            this.quality = param5;
            this.transparent = param3;
            this.createBitmaps();
        }
        
        public function get visual() : Sprite
        {
            return this._visual;
        }
        
        public function get multiplier() : Number
        {
            return this._multiplier;
        }
        
        protected function createBitmaps() : void
        {
            var _loc2_:Sprite = null;
            var _loc1_:int = 0;
            while(_loc1_ < this.visual.numChildren)
            {
                _loc2_ = this.visual.getChildAt(_loc1_) as Sprite;
                this.drawBitmap(_loc2_);
                _loc1_++;
            }
            this._visual = null;
        }
        
        protected function drawBitmap(param1:Sprite, param2:Boolean = false, param3:Number = 5000) : void
        {
            var _loc7_:BlurFilter = null;
            if(this.blur > 0)
            {
                _loc7_ = new BlurFilter(this.blur,this.blur,this.quality);
                param1.filters = [_loc7_];
            }
            var _loc4_:BitmapData = new BitmapData(param1.width + this.blur * 2,param1.height + this.blur * 2,this.transparent,16777215);
            var _loc5_:Matrix = new Matrix();
            _loc5_.translate(this.blur,this.blur);
            _loc4_.draw(param1,_loc5_);
            var _loc6_:Bitmap = new Bitmap(_loc4_);
            addChild(_loc6_);
            _loc6_.x = param1.x - this.blur;
            _loc6_.y = param1.y - this.blur;
            if(param2)
            {
                _loc6_ = new Bitmap(_loc4_);
                addChild(_loc6_);
                _loc6_.x = param1.x + param3 - this.blur;
                _loc6_.y = param1.y - this.blur;
            }
        }
        
        protected function drawBuilding(param1:Sprite, param2:Number, param3:Number, param4:Boolean = false, param5:Number = 5000) : void
        {
            var _loc6_:BitmapData = null;
            var _loc7_:Bitmap = null;
            var _loc8_:Matrix = null;
            var _loc9_:Number = NaN;
            var _loc10_:Number = NaN;
            var _loc11_:Number = NaN;
            var _loc12_:Number = 10000 * this._multiplier + 500 * (1 - this._multiplier);
            var _loc13_:BlurFilter = new BlurFilter(this.blur,this.blur,this.quality);
            param1.filters = [_loc13_];
            var _loc14_:Number = param1.x - this.blur;
            var _loc15_:Number = param1.y - this.blur;
            _loc9_ = param1.width + this.blur * 2;
            _loc10_ = param2 + this.blur;
            _loc6_ = new BitmapData(_loc9_,_loc10_,this.transparent,0);
            _loc8_ = new Matrix(1,0,0,1,this.blur,this.blur);
            _loc6_.draw(param1,_loc8_);
            _loc8_ = new Matrix(1,0,0,1,_loc14_,_loc15_);
            graphics.beginBitmapFill(_loc6_,_loc8_,false,false);
            graphics.drawRect(_loc14_,_loc15_,_loc9_,_loc10_);
            graphics.endFill();
            if(param4)
            {
                _loc8_ = new Matrix(1,0,0,1,_loc14_ + param5,_loc15_);
                graphics.beginBitmapFill(_loc6_,_loc8_,false,false);
                graphics.drawRect(_loc14_ + param5,_loc15_,_loc9_,_loc10_);
                graphics.endFill();
            }
            _loc10_ = param3;
            _loc15_ = _loc15_ + param2 + this.blur;
            _loc6_ = new BitmapData(_loc9_,_loc10_,this.transparent,0);
            _loc8_ = new Matrix(1,0,0,1,this.blur,-param2);
            _loc6_.draw(param1,_loc8_);
            _loc8_ = new Matrix(1,0,0,1,_loc14_,_loc15_);
            _loc11_ = _loc12_ - _loc15_;
            graphics.beginBitmapFill(_loc6_,_loc8_,true,false);
            graphics.drawRect(_loc14_,_loc15_,_loc9_,_loc11_);
            graphics.endFill();
            if(param4)
            {
                _loc8_ = new Matrix(1,0,0,1,_loc14_ + param5,_loc15_);
                graphics.beginBitmapFill(_loc6_,_loc8_,true,false);
                graphics.drawRect(_loc14_ + param5,_loc15_,_loc9_,_loc11_);
                graphics.endFill();
            }
        }
    }
}

