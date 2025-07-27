package com.totaljerkface.game.level
{
    import com.totaljerkface.game.*;
    import com.totaljerkface.game.level.visuals.*;
    import flash.display.*;
    
    public class Level1 extends LevelB2D
    {
        public function Level1(param1:Sprite, param2:Session)
        {
            super(param1,param2);
            var _loc3_:MemoryTest = MemoryTest.instance;
            _loc3_.addEntry("Level1_",this);
            _loc3_.traceContents();
        }
        
        override internal function convertBackground() : void
        {
            var _loc4_:Bitmap = null;
            super.convertBackground();
            if(Settings.useCompressedTextures)
            {
                return;
            }
            var _loc1_:DisplayObject = background["chasm"];
            var _loc2_:BitmapData = new BitmapData(_loc1_.width,_loc1_.height,true,16777215);
            _loc2_.draw(_loc1_);
            var _loc3_:int = 0;
            while(_loc3_ < 4)
            {
                _loc4_ = new Bitmap(_loc2_);
                background.addChildAt(_loc4_,background.getChildIndex(_loc1_));
                _loc4_.x = _loc1_.x;
                _loc4_.y = _loc1_.y + _loc3_ * _loc1_.height;
                _loc3_++;
            }
            background.removeChild(_loc1_);
        }
        
        override internal function createBackDrops() : void
        {
            var _loc4_:MovieClip = null;
            var _loc5_:BackDrop = null;
            var _loc6_:MovieClip = null;
            var _loc7_:BackDrop = null;
            var _loc8_:MovieClip = null;
            var _loc9_:BackDrop = null;
            backDrops = new Vector.<BackDrop>();
            var _loc1_:int = Settings.numBackgroundLayers;
            if(_loc1_ > 1)
            {
                _loc4_ = levelData["backdrop3"];
                _loc5_ = new BackDrop(_loc4_,0.1,true,3);
                _session.addChildAt(_loc5_,0);
                backDrops.push(_loc5_);
            }
            if(_loc1_ > 2)
            {
                _loc6_ = levelData["backdrop2"];
                _loc7_ = new BackDrop(_loc6_,0.05,true,6);
                _session.addChildAt(_loc7_,0);
                backDrops.push(_loc7_);
            }
            var _loc2_:MovieClip = levelData["backdrop4"];
            var _loc3_:BackDrop = new BackDrop(_loc2_,0.01,true,7);
            _session.addChildAt(_loc3_,0);
            backDrops.push(_loc3_);
            if(_loc1_ > 0)
            {
                _loc8_ = levelData["backdrop1"];
                _loc9_ = new BackDrop(_loc8_,0,false);
                _session.addChildAt(_loc9_,0);
                backDrops.push(_loc9_);
            }
        }
        
        override internal function createItems() : void
        {
            super.createItems();
            var _loc1_:Array = new Array(shapeGuide["ba0"],shapeGuide["ba1"],shapeGuide["ba2"],shapeGuide["ba3"],shapeGuide["ba4"],shapeGuide["ba5"]);
            var _loc2_:Array = new Array(background["bmc0"],background["bmc1"],background["bmc2"],background["bmc3"],background["bmc4"],background["bmc5"]);
            var _loc3_:Bridge = new Bridge("ba",6);
            paintItemVector.push(_loc3_);
            var _loc4_:Gear = new Gear("geara",0.1);
            paintItemVector.push(_loc4_);
            var _loc5_:Gear = new Gear("gearb",0.1,3,0.75,0.1);
            paintItemVector.push(_loc5_);
            var _loc6_:PrisBlock = new PrisBlock("pb1",3,3.4);
            paintItemVector.push(_loc6_);
            actionsVector.push(_loc6_);
            var _loc7_:PrisBlock = new PrisBlock("pb2",3,3.4,60,90);
            paintItemVector.push(_loc7_);
            actionsVector.push(_loc7_);
            var _loc8_:PrisBlock = new PrisBlock("pb3",3,3.4);
            paintItemVector.push(_loc8_);
            actionsVector.push(_loc8_);
            var _loc9_:LandMine = new LandMine("mine1");
        }
    }
}

