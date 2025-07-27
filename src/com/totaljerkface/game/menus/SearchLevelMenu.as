package com.totaljerkface.game.menus
{
    import com.totaljerkface.game.editor.ui.GenericButton;
    import com.totaljerkface.game.editor.ui.Window;
    import com.totaljerkface.game.utils.TextUtils;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.KeyboardEvent;
    import flash.events.MouseEvent;
    import flash.text.TextField;

    [Embed(source="/_assets/assets.swf", symbol="symbol2922")]
    public class SearchLevelMenu extends Sprite
    {
        public static const AUTHOR_NAME:String = "author";

        public static const LEVEL_NAME:String = "level";

        public static const SEARCH:String = "search";

        public static const CANCEL:String = "CANCEL";

        private static var index:int = 0;

        private static var minChars:int = 4;

        private static var maxChars:int = 12;

        public var searchText:TextField;

        public var errorText:TextField;

        protected var _window:Window;

        protected var dropMenu:DropMenu;

        private var searchButton:GenericButton;

        private var cancelButton:GenericButton;

        public function SearchLevelMenu()
        {
            super();
            this.createWindow();
            this.dropMenu = new DropMenu("search by:", ["level name", "author name"], [LEVEL_NAME, AUTHOR_NAME], index, 8947848);
            addChild(this.dropMenu);
            this.dropMenu.xLeft = 25;
            this.dropMenu.y = 14;
            this.searchButton = new GenericButton("search", 16613761, 70);
            addChild(this.searchButton);
            this.searchButton.x = 25;
            this.searchButton.y = 114;
            this.cancelButton = new GenericButton("cancel", 10066329, 70);
            addChild(this.cancelButton);
            this.cancelButton.x = 105;
            this.cancelButton.y = 114;
            this.searchText.maxChars = maxChars;
            this.searchText.restrict = "a-z A-Z 0-9 !@#$%\\^&*()_+\\-=\'|?/,.<> \"";
            addEventListener(MouseEvent.MOUSE_UP, this.mouseUpHandler);
            this.searchText.addEventListener(KeyboardEvent.KEY_DOWN, this.keyDownHandler);
        }

        protected function createWindow():void
        {
            this._window = new Window(false, this, true);
        }

        public function get window():Window
        {
            return this._window;
        }

        public function get searchType():String
        {
            return this.dropMenu.value;
        }

        public function get searchTerm():String
        {
            return this.searchText.text;
        }

        private function keyDownHandler(param1:KeyboardEvent):void
        {
            if (param1.keyCode == 13)
            {
                this.validateTerm();
            }
        }

        private function mouseUpHandler(param1:MouseEvent):void
        {
            switch (param1.target)
            {
                case this.searchButton:
                    this.validateTerm();
                    break;
                case this.cancelButton:
                    dispatchEvent(new Event(CANCEL));
            }
        }

        private function validateTerm():void
        {
            var _loc1_:* = null;
            this.searchText.text = TextUtils.trimWhitespace(this.searchText.text);
            if (this.searchText.length < minChars)
            {
                _loc1_ = "must be between " + minChars + " and " + maxChars + " characters";
                this.errorText.text = _loc1_;
                return;
            }
            dispatchEvent(new Event(SEARCH));
        }

        public function die():void
        {
            index = this.dropMenu.currentIndex;
            removeEventListener(MouseEvent.MOUSE_UP, this.mouseUpHandler);
            this.dropMenu.die();
            this._window.closeWindow();
        }
    }
}
