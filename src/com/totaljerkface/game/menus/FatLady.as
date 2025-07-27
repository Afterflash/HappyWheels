package com.totaljerkface.game.menus
{
    import flash.display.Sprite;

    [Embed(source="/_assets/assets.swf", symbol="symbol524")]
    public class FatLady extends OldMan
    {
        public var jaw2:Sprite;

        public var jaw3:Sprite;

        public var jaw4:Sprite;

        public var jaw5:Sprite;

        public function FatLady()
        {
            super();
            this.jaw2 = head.getChildByName("jaw2") as Sprite;
            this.jaw3 = head.getChildByName("jaw3") as Sprite;
            this.jaw4 = head.getChildByName("jaw4") as Sprite;
            this.jaw5 = head.getChildByName("jaw5") as Sprite;
            jawTopY = -56.85;
            headMinAngle = -3;
            eye1LeftX = -32;
            eye1RangeX = 16;
            eye1TopY = 1;
            eye1RangeY = 5;
            eye2LeftX = 31;
            eye2RangeX = 11;
            eye2TopY = 0;
            eye2RangeY = 5;
            foreArmMinAngle = -25;
            foreArmRange = 60;
        }

        override public function set jawTween(param1:Number):void
        {
            _jawTween = param1;
            jaw.y = jawTopY + _jawTween * jawRangeY;
            this.jaw2.y = -34 + _jawTween * 6.5;
            this.jaw3.x = -76.9 + _jawTween * 3.4;
            this.jaw3.rotation = 0 + _jawTween * 11.5;
            this.jaw4.y = -65.45 + _jawTween * 5;
            this.jaw5.x = 33.45 - _jawTween * 10;
            this.jaw5.y = -16.55 + _jawTween * 7.75;
            this.jaw5.rotation = 0 + _jawTween * 10.4;
        }
    }
}
