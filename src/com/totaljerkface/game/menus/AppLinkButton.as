package com.totaljerkface.game.menus
{
    import com.totaljerkface.game.utils.Tracker;
    import flash.display.Sprite;
    import flash.events.MouseEvent;
    import flash.net.URLRequest;
    import flash.net.navigateToURL;

    [Embed(source="/_assets/assets.swf", symbol="symbol454")]
    public class AppLinkButton extends Sprite
    {
        public var appButton:Sprite;

        public var googlePlayAppButton:Sprite;

        public var head:Sprite;

        public function AppLinkButton()
        {
            super();
            this.appButton.buttonMode = true;
            this.googlePlayAppButton.buttonMode = true;
            this.appButton.addEventListener(MouseEvent.MOUSE_UP, this.mouseUpHandler, false, 0, true);
            this.googlePlayAppButton.addEventListener(MouseEvent.MOUSE_UP, this.googlePlayMouseUpHandler, false, 0, true);
        }

        private function mouseUpHandler(param1:MouseEvent):void
        {
            var _loc2_:String = "https://itunes.apple.com/us/app/happy-wheels/id648668184?mt=8";
            Tracker.trackEvent(Tracker.MAIN_MENU, Tracker.CLICK_IOS_LINK);
            var _loc3_:URLRequest = new URLRequest(_loc2_);
            navigateToURL(_loc3_, "_blank");
        }

        private function googlePlayMouseUpHandler(param1:MouseEvent):void
        {
            var _loc2_:String = "https://play.google.com/store/apps/details?id=com.fancyforce.happywheels";
            Tracker.trackEvent(Tracker.MAIN_MENU, Tracker.CLICK_GOOGLEPLAY_LINK);
            var _loc3_:URLRequest = new URLRequest(_loc2_);
            navigateToURL(_loc3_, "_blank");
        }
    }
}
