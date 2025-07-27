package com.totaljerkface.game.editor.specials
{
    import com.totaljerkface.game.*;
    import com.totaljerkface.game.editor.*;
    import flash.display.*;
    import flash.geom.*;
    
    public class Building1Ref extends BuildingRef
    {
        public static var B1_ROOF:String = "b1roof";
        
        public static var B1_FLOOR:String = "b1floor";
        
        public function Building1Ref()
        {
            name = "building 1";
            super();
        }
        
        override public function setAttributes() : void
        {
            _type = "Building1Ref";
            _attributes = ["x","y","floorWidth","numFloors"];
        }
        
        override protected function createTextures() : void
        {
            var _loc3_:Sprite = null;
            var _loc1_:BitmapManager = BitmapManager.instance;
            if(_loc1_.getTexture(B1_ROOF))
            {
                roofBMD = _loc1_.getTexture(B1_ROOF);
                floorBMD = _loc1_.getTexture(B1_FLOOR);
                return;
            }
            var _loc2_:Sprite = new Building1Source();
            _loc3_ = new Sprite();
            _loc3_.addChild(this.createBricks(tileWidth,roofHeight));
            var _loc4_:Sprite = _loc2_["roofTexture"];
            _loc3_.addChild(_loc4_);
            roofBMD = new BitmapData(tileWidth,roofHeight,false,0);
            roofBMD.draw(_loc3_);
            floorBMD = new BitmapData(600,330,false,0);
            floorBMD.draw(this.createBricks(600,330));
            var _loc5_:Sprite = _loc2_["windowTexture"];
            this.addWindows(_loc5_,floorBMD);
            var _loc6_:Sprite = _loc2_["ledgeTexture"];
            this.addLedge(_loc6_,floorBMD);
            _loc1_.addTexture(B1_ROOF,roofBMD);
            _loc1_.addTexture(B1_FLOOR,floorBMD);
        }
        
        protected function createBricks(param1:*, param2:*) : Sprite
        {
            var _loc9_:int = 0;
            var _loc10_:* = 0;
            var _loc11_:Number = NaN;
            var _loc12_:Number = NaN;
            var _loc13_:Number = NaN;
            var _loc14_:Number = NaN;
            var _loc15_:Number = NaN;
            var _loc3_:Sprite = new Sprite();
            _loc3_.graphics.beginFill(13351586,1);
            _loc3_.graphics.drawRect(0,0,param1,param2);
            var _loc4_:int = Math.floor(param1 / 15);
            var _loc5_:int = Math.floor(param2 / 5);
            var _loc6_:int = 0;
            var _loc7_:int = 0;
            var _loc8_:int = 0;
            while(_loc8_ < _loc5_)
            {
                _loc6_ = _loc8_ % 2 == 1 ? -7 : 0;
                _loc9_ = 0;
                while(_loc9_ < _loc4_)
                {
                    _loc10_ = 9206119;
                    _loc11_ = 64;
                    _loc12_ = _loc11_ * 0.5;
                    _loc13_ = Math.round(Math.random() * _loc11_) - _loc12_;
                    _loc14_ = _loc13_ << 8;
                    _loc15_ = _loc13_ << 16;
                    _loc10_ += _loc13_;
                    _loc10_ = _loc10_ + _loc14_;
                    _loc10_ = _loc10_ + _loc15_;
                    _loc3_.graphics.beginFill(_loc10_,1);
                    _loc3_.graphics.drawRect(_loc6_,_loc7_,14,4);
                    _loc3_.graphics.endFill();
                    if(_loc6_ == -7)
                    {
                        _loc3_.graphics.beginFill(_loc10_,1);
                        _loc3_.graphics.drawRect(_loc6_ + param1,_loc7_,14,4);
                        _loc3_.graphics.endFill();
                    }
                    _loc6_ += 15;
                    _loc9_++;
                }
                _loc7_ += 5;
                _loc8_++;
            }
            return _loc3_;
        }
        
        protected function addWindows(param1:Sprite, param2:BitmapData) : *
        {
            var _loc7_:int = 0;
            var _loc8_:Matrix = null;
            var _loc3_:int = Math.floor(param2.width / tileWidth) * 3;
            var _loc4_:int = Math.floor(param2.height / tileHeight);
            var _loc5_:int = 40;
            var _loc6_:int = 0;
            while(_loc6_ < _loc4_)
            {
                _loc7_ = 0;
                while(_loc7_ < _loc3_)
                {
                    this.randomizeWindowTexture(param1);
                    _loc8_ = new Matrix();
                    _loc8_.translate(_loc5_ + _loc7_ * 80,_loc6_ * 165);
                    param2.draw(param1,_loc8_);
                    if(_loc7_ % 3 == 2)
                    {
                        _loc5_ += 60;
                    }
                    _loc7_++;
                }
                _loc5_ = 40;
                _loc6_++;
            }
        }
        
        protected function addLedge(param1:Sprite, param2:BitmapData) : *
        {
            param1.width = param2.width;
            var _loc3_:Matrix = new Matrix();
            _loc3_.scale(50,1);
            _loc3_.translate(0,90);
            param2.draw(param1,_loc3_);
        }
        
        protected function randomizeWindowTexture(param1:Sprite) : *
        {
            var _loc2_:Number = Math.random();
            var _loc3_:MovieClip = param1["ac"];
            var _loc4_:MovieClip = param1["frame"];
            var _loc5_:MovieClip = param1["frameShadow"];
            var _loc6_:MovieClip = param1["shade"];
            _loc3_.visible = true;
            if(_loc2_ < 0.1)
            {
                _loc4_.y = 8;
            }
            else
            {
                _loc3_.visible = false;
                _loc4_.y = Math.ceil(Math.random() * 43);
            }
            _loc5_.y = _loc4_.y + 4;
            _loc6_.scaleY = Math.random() * 0.8 + 0.2;
        }
        
        override protected function drawBuilding() : void
        {
            graphics.clear();
            var _loc1_:Number = tileWidth * _floorWidth;
            var _loc2_:Number = 0;
            var _loc3_:Number = 0;
            var _loc4_:Matrix = new Matrix(1,0,0,1,_loc2_,_loc3_);
            graphics.beginBitmapFill(roofBMD,_loc4_,true,false);
            graphics.drawRect(_loc2_,_loc3_,_loc1_,roofHeight);
            graphics.endFill();
            _loc3_ += roofHeight;
            _loc4_ = new Matrix(1,0,0,1,_loc2_,_loc3_);
            graphics.beginBitmapFill(floorBMD,_loc4_,true,false);
            graphics.drawRect(_loc2_,_loc3_,_loc1_,tileHeight * _numFloors);
            graphics.endFill();
        }
        
        override public function clone() : RefSprite
        {
            var _loc1_:Building1Ref = new Building1Ref();
            _loc1_.x = x;
            _loc1_.y = y;
            _loc1_.numFloors = _numFloors;
            _loc1_.floorWidth = _floorWidth;
            return _loc1_;
        }
    }
}

