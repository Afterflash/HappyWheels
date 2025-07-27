package com.totaljerkface.game.menus
{
    import flash.display.Sprite;
    import flash.events.Event;

    [Embed(source="/_assets/assets.swf", symbol="symbol453")]
    public class NewStar extends Sprite
    {
        public var star:Sprite;

        public function NewStar()
        {
            super();
            addEventListener(Event.ENTER_FRAME, this.rotate, false, 0, true);
        }

        public function rotate(param1:Event):void
        {
            this.star.rotation += 1;
        }
    }
}
