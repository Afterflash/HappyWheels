package com.totaljerkface.game.editor.specials
{
    import com.totaljerkface.game.*;
    import com.totaljerkface.game.editor.*;
    import flash.display.*;
    import flash.geom.*;
    
    public class Building2Ref extends BuildingRef
    {
        public static var B2_ROOF:String = "b2roof";
        
        public static var B2_FLOOR:String = "b2floor";
        
        public function Building2Ref()
        {
            name = "building 2";
            super();
        }
        
        override public function setAttributes() : void
        {
            _type = "Building2Ref";
            _attributes = ["x","y","floorWidth","numFloors"];
        }
        
        override protected function createTextures() : void
        {
            var _loc2_:Sprite = null;
            tileWidth = 500;
            tileHeight = 180;
            roofHeight = 120;
            var _loc1_:BitmapManager = BitmapManager.instance;
            if(_loc1_.getTexture(B2_ROOF))
            {
                roofBMD = _loc1_.getTexture(B2_ROOF);
                floorBMD = _loc1_.getTexture(B2_FLOOR);
                return;
            }
            _loc2_ = new Building2Source();
            var _loc3_:Sprite = _loc2_["roofTexture"];
            roofBMD = new BitmapData(tileWidth,roofHeight,false,0);
            roofBMD.draw(_loc3_);
            var _loc4_:Sprite = _loc2_["floorTexture"];
            floorBMD = new BitmapData(tileWidth,tileHeight,false,0);
            floorBMD.draw(_loc4_);
            _loc1_.addTexture(B2_ROOF,roofBMD);
            _loc1_.addTexture(B2_FLOOR,floorBMD);
        }
        
        override protected function drawBuilding() : void
        {
            graphics.clear();
            var _loc1_:Number = tileWidth * _floorWidth + 226;
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
            var _loc1_:Building2Ref = new Building2Ref();
            _loc1_.x = x;
            _loc1_.y = y;
            _loc1_.numFloors = _numFloors;
            _loc1_.floorWidth = _floorWidth;
            return _loc1_;
        }
    }
}

