package com.totaljerkface.game.menus
{
    import flash.display.Sprite;
    import flash.events.Event;

    [Embed(source="/_assets/assets.swf", symbol="symbol477")]
    public class CreditsMenu extends BasicMenu
    {
        public var creditsSprite:Sprite;

        public function CreditsMenu()
        {
            var _loc2_:CreditsLink = null;
            super();
            this.creditsSprite.y = 510;
            addEventListener(Event.ENTER_FRAME, this.scroll);
            var _loc1_:Sprite = this.creditsSprite.getChildByName("benText1") as Sprite;
            if (_loc1_)
            {
                _loc2_ = new CreditsLink(_loc1_, "http://contactbenhaynes.com");
            }
            _loc1_ = this.creditsSprite.getChildByName("jimText") as Sprite;
            _loc2_ = new CreditsLink(_loc1_, "http://www.totaljerkface.com");
            _loc1_ = this.creditsSprite.getChildByName("jackText") as Sprite;
            _loc2_ = new CreditsLink(_loc1_, "http://www.pekopeko.com");
            _loc1_ = this.creditsSprite.getChildByName("brianText") as Sprite;
            if (_loc1_)
            {
                _loc2_ = new CreditsLink(_loc1_, "http://wateristhenewfire.com");
            }
            _loc1_ = this.creditsSprite.getChildByName("jonText") as Sprite;
            if (_loc1_)
            {
                _loc2_ = new CreditsLink(_loc1_, "http://www.jonathanbelsky.com");
            }
            _loc1_ = this.creditsSprite.getChildByName("andyText") as Sprite;
            if (_loc1_)
            {
                _loc2_ = new CreditsLink(_loc1_, "http://andypressman.com");
            }
            _loc1_ = this.creditsSprite.getChildByName("benText2") as Sprite;
            if (_loc1_)
            {
                _loc2_ = new CreditsLink(_loc1_, "http://contactbenhaynes.com");
            }
            _loc1_ = this.creditsSprite.getChildByName("erinText") as Sprite;
            _loc2_ = new CreditsLink(_loc1_, "http://www.box2d.org");
        }

        private function scroll(param1:Event):void
        {
            --this.creditsSprite.y;
            if (this.creditsSprite.y < -50 - this.creditsSprite.height)
            {
                this.creditsSprite.y = 510;
            }
        }

        override public function die():void
        {
            super.die();
            removeEventListener(Event.ENTER_FRAME, this.scroll);
        }
    }
}
