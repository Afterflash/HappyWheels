package com.totaljerkface.game.level.visuals
{
    import flash.display.Sprite;
    
    public class CityBackDrop1 extends BackDrop
    {
        public function CityBackDrop1()
        {
            super(new CitySource1(),0.5,true,2,3);
        }
        
        override protected function createBitmaps() : void
        {
            var _loc1_:Sprite = _visual.getChildByName("b1") as Sprite;
            drawBuilding(_loc1_,90,88,true,5000);
            _loc1_ = _visual.getChildByName("b2") as Sprite;
            drawBuilding(_loc1_,140,90,true,5000);
            _loc1_ = _visual.getChildByName("b3") as Sprite;
            drawBuilding(_loc1_,60,102,true,5000);
            _loc1_ = _visual.getChildByName("b4") as Sprite;
            drawBuilding(_loc1_,160,101,true,5000);
            _visual = null;
        }
    }
}

