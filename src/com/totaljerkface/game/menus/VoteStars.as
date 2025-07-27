package com.totaljerkface.game.menus
{
    import flash.display.Sprite;

    [Embed(source="/_assets/assets.swf", symbol="symbol2930")]
    public class VoteStars extends Sprite
    {
        public var filler:Sprite;

        private var _rating:Number;

        private var maxRating:Number = 5;

        public function VoteStars(param1:Number = 0)
        {
            super();
            this.rating = param1;
            mouseChildren = false;
        }

        public function get rating():Number
        {
            return this._rating;
        }

        public function set rating(param1:Number):void
        {
            this._rating = param1;
            this.filler.scaleX = param1 / this.maxRating;
        }
    }
}
