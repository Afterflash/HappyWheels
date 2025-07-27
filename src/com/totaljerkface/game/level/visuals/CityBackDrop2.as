package com.totaljerkface.game.level.visuals
{
    import flash.display.Sprite;
    
    public class CityBackDrop2 extends BackDrop
    {
        public function CityBackDrop2()
        {
            super(new CitySource2(),0.25,true,5,3);
        }
        
        override protected function createBitmaps() : void
        {
            var _loc1_:Sprite = _visual.getChildByName("b1") as Sprite;
            drawBitmap(_loc1_,true,2500);
            _loc1_ = _visual.getChildByName("b2") as Sprite;
            drawBuilding(_loc1_,40,50,true,2500);
            _loc1_ = _visual.getChildByName("b3") as Sprite;
            drawBuilding(_loc1_,46,50,true,2500);
            _loc1_ = _visual.getChildByName("b4") as Sprite;
            drawBuilding(_loc1_,15,50,true,2500);
            _visual = null;
        }
    }
}

