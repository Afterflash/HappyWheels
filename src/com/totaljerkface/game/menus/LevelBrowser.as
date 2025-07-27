package com.totaljerkface.game.menus
{
    import com.totaljerkface.game.*;
    import com.totaljerkface.game.editor.*;
    import com.totaljerkface.game.editor.ui.*;
    import com.totaljerkface.game.events.*;
    import com.totaljerkface.game.utils.Tracker;
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;
    import flash.text.*;

    [Embed(source="/_assets/assets.swf", symbol="symbol3027")]
    public class LevelBrowser extends Sprite
    {
        private static var savedTerm:String;

        private static var levelDataArray:Array;

        private static var urlVariables:URLVariables;

        private static var _favorites:Boolean;

        private static var _importable:Boolean;

        private static var levelSearch:String;

        private static var authorNameSearch:String;

        private static var setLength:int = 500;

        private static const pageLength:int = 50;

        private static const dropMenuSpacing:Number = 10;

        private static var currentDropSettings:Array = [0, 0, 1];

        private static var savedDropSettings:Array = [0, 0, 1];

        private static var currentDropStates:Array = [1, 1, 1];

        private static var savedDropStates:Array = [1, 1, 1];

        private static var savedSearch:int = 0;

        private static var selectedCharacter:int = -1;

        private static var authorDisplay:Array = ["everyone"];

        private static var authorValues:Array = [0];

        private static var lastLevelId:int = -1;

        private static var currentSet:int = 1;

        private static var currentPage:int = 1;

        public var bg:Sprite;

        public var shadow:Sprite;

        public var listHeader:Sprite;

        public var backButton:LibraryButton;

        private var favoriteId:int;

        private var authorDropMenu:DropMenu;

        private var charDropMenu:DropMenu;

        private var sortDropMenu:DropMenu;

        private var uploadDropMenu:DropMenu;

        private var dropMenuArray:Array;

        private var searchButton:GenericButton;

        private var refreshButton:RefreshButton;

        private var favoritesButton:GenericButton;

        private var searchTermButton:XButton;

        private var listContainer:Sprite;

        private var list:LevelList;

        private var listMask:Sprite;

        private var scrollBar:ListScroller;

        private var pageFlipper:PageFlipperNew;

        private var loader:URLLoader;

        private var statusSprite:StatusSprite;

        private var searchMenu:SearchLevelMenu;

        public function LevelBrowser()
        {
            super();
        }

        public static function importLevelDataArray(param1:Array):void
        {
            levelDataArray = param1;
            var _loc2_:LevelDataObject = levelDataArray[0];
            lastLevelId = _loc2_.id;
            currentPage = 1;
            currentSet = 1;
            levelSearch = null;
            authorNameSearch = null;
            _favorites = false;
        }

        public static function importAuthor(param1:String, param2:int):void
        {
            var _loc3_:int = int(authorValues.indexOf(param2));
            if (_loc3_ == -1)
            {
                authorValues.push(param2);
                authorDisplay.push(param1);
                currentDropSettings = [authorValues.length - 1, 0, 3];
                savedDropSettings = [authorValues.length - 1, 0, 3];
                currentDropStates = [1, 0, 0];
                savedDropStates = [1, 0, 0];
            }
            else
            {
                savedDropSettings = [_loc3_, 0, 3];
                savedDropStates = [1, 0, 0];
            }
            authorNameSearch = null;
            levelSearch = null;
            _favorites = false;
            currentPage = 1;
            currentSet = 1;
            urlVariables = null;
            levelDataArray = null;
        }

        public function init():void
        {
            mouseChildren = false;
            this.shadow.mouseEnabled = false;
            this.refreshButton = new RefreshButton();
            addChild(this.refreshButton);
            this.refreshButton.x = this.shadow.x + this.shadow.width + 10;
            this.refreshButton.y = this.shadow.y - 22;
            this.buildDropMenus();
            this.searchButton = new GenericButton("search by name", 4032711, 120);
            addChild(this.searchButton);
            this.searchButton.x = this.shadow.x;
            this.searchButton.y = this.shadow.y - 27;
            this.searchButton.y = this.shadow.y + this.shadow.height + 6;
            this.favoritesButton = new GenericButton("list favorites", 16776805, 120, 6312772);
            addChild(this.favoritesButton);
            this.favoritesButton.x = this.searchButton.x + this.searchButton.width + 6;
            this.favoritesButton.y = this.searchButton.y;
            trace("Settings.id = " + Settings.user_id);
            if (Settings.user_id <= 0)
            {
                trace("FUCKING SHIT");
                removeChild(this.favoritesButton);
            }
            this.backButton.addEventListener(MouseEvent.MOUSE_UP, this.backPress);
            this.searchButton.addEventListener(MouseEvent.MOUSE_UP, this.openSearchMenu);
            this.favoritesButton.addEventListener(MouseEvent.MOUSE_UP, this.listFavorites);
            this.refreshButton.addEventListener(MouseEvent.MOUSE_UP, this.loadData);
            if (savedSearch > 0)
            {
                this.createSearchTermButton(savedSearch);
            }
        }

        public function activate():void
        {
            mouseChildren = true;
            if (levelDataArray)
            {
                this.buildList();
            }
            else
            {
                trace("---------------LOAD DATA");
                this.loadData();
            }
        }

        private function loadData(param1:MouseEvent = null):void
        {
            var _loc5_:* = undefined;
            var _loc2_:int = 0;
            while (_loc2_ < this.dropMenuArray.length)
            {
                savedDropSettings[_loc2_] = currentDropSettings[_loc2_];
                savedDropStates[_loc2_] = currentDropStates[_loc2_];
                _loc2_++;
            }
            this.refreshButton.setSpin(true);
            savedSearch = 0;
            levelDataArray = new Array();
            var _loc3_:URLRequest = new URLRequest(Settings.siteURL + "get_level.hw");
            _loc3_.method = URLRequestMethod.POST;
            urlVariables = new URLVariables();
            urlVariables.action = "get_all";
            urlVariables.page = currentSet = currentPage = 1;
            urlVariables.sortby = this.sortDropMenu.value;
            urlVariables.uploaded = this.uploadDropMenu.value;
            if (levelSearch)
            {
                savedSearch = 1;
                urlVariables.action = "search_by_name";
                urlVariables.sterm = levelSearch;
            }
            else if (authorNameSearch)
            {
                savedSearch = 2;
                urlVariables.action = "search_by_user";
                urlVariables.sterm = authorNameSearch;
            }
            else if (_favorites)
            {
                savedSearch = 3;
                _loc3_.url = Settings.siteURL + "user.hw";
                urlVariables = new URLVariables();
                urlVariables.action = "get_favorites";
                Settings.favoriteLevelIds = new Array();
            }
            else if (this.authorDropMenu.value != 0)
            {
                urlVariables.action = "get_pub_by_user";
                urlVariables.user_id = this.authorDropMenu.value;
            }
            else if (param1)
            {
                Tracker.trackEvent(Tracker.LEVEL_BROWSER, Tracker.REFRESH_LEVELS, this.sortDropMenu.value + "_" + this.uploadDropMenu.value);
            }
            _loc3_.data = urlVariables;
            this.statusSprite = new StatusSprite("loading levels...");
            var _loc4_:Window = this.statusSprite.window;
            addChild(_loc4_);
            _loc4_.center();
            trace("LOAD DATA");
            for (_loc5_ in urlVariables)
            {
                trace("urlVariables." + _loc5_ + " = " + urlVariables[_loc5_]);
            }
            trace(_loc3_.requestHeaders);
            trace(_loc3_.url);
            this.loader = new URLLoader();
            this.loader.addEventListener(Event.COMPLETE, this.levelDataLoaded);
            this.loader.addEventListener(IOErrorEvent.IO_ERROR, this.IOErrorHandler);
            this.loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.securityErrorHandler);
            this.loader.load(_loc3_);
        }

        private function loadDataOffset():void
        {
            var _loc3_:* = undefined;
            this.refreshButton.setSpin(true);
            var _loc1_:URLRequest = new URLRequest(Settings.siteURL + "get_level.hw");
            _loc1_.method = URLRequestMethod.POST;
            _loc1_.data = urlVariables;
            urlVariables.page = currentSet;
            this.statusSprite = new StatusSprite("loading levels...");
            var _loc2_:Window = this.statusSprite.window;
            addChild(_loc2_);
            _loc2_.center();
            if (urlVariables.action == "get_all")
            {
                Tracker.trackEvent(Tracker.LEVEL_BROWSER, Tracker.PAGE_LEVELS, this.sortDropMenu.value + "_" + this.uploadDropMenu.value, currentSet);
            }
            trace("LOAD DATA OFFSET");
            for (_loc3_ in urlVariables)
            {
                trace("urlVariables." + _loc3_ + " = " + urlVariables[_loc3_]);
            }
            this.loader = new URLLoader();
            this.loader.addEventListener(Event.COMPLETE, this.levelDataLoaded);
            this.loader.addEventListener(IOErrorEvent.IO_ERROR, this.IOErrorHandler);
            this.loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.securityErrorHandler);
            this.loader.load(_loc1_);
        }

        private function levelDataLoaded(param1:Event):void
        {
            var _loc8_:Array = null;
            var _loc9_:XML = null;
            var _loc10_:LevelDataObject = null;
            trace("LOAD COMPLETE");
            this.statusSprite.die();
            this.removeLoaderListeners();
            this.refreshButton.setSpin(false);
            var _loc2_:String = String(this.loader.data);
            trace("result " + _loc2_);
            var _loc3_:String = _loc2_.substr(0, 8);
            trace("dataString " + _loc3_);
            if (_loc3_.indexOf("<html>") > -1)
            {
                this.createPromptSprite("There was an unexpected system Error", "oh");
                this.updateRefreshButton(true);
                return;
            }
            if (_loc3_.indexOf("failure") > -1)
            {
                _loc8_ = _loc2_.split(":");
                if (_loc8_[1] == "invalid_action")
                {
                    this.createPromptSprite("An invalid action was passed (you really shouldn\'t ever be seeing this).", "ok");
                }
                else if (_loc8_[1] == "bad_param")
                {
                    this.createPromptSprite("A bad parameter was passed (you really shouldn\'t ever be seeing this).", "ok");
                }
                else if (_loc8_[1] == "app_error")
                {
                    this.createPromptSprite("Sorry, there was an application error. It was most likely database related. Please try again in a moment.", "ok");
                }
                else
                {
                    this.createPromptSprite("An unknown Error has occurred.", "oh");
                }
                this.updateRefreshButton(true);
                return;
            }
            this.updateRefreshButton();
            var _loc4_:XML = XML(this.loader.data);
            trace("NUM PER PAGE " + _loc4_.@pp);
            var _loc5_:int = int(_loc4_.@pp);
            if (_loc5_ > 1)
            {
                setLength = _loc5_;
            }
            if (!levelDataArray)
            {
                levelDataArray = new Array();
            }
            var _loc6_:int = int(_loc4_.lv.length());
            trace("total results = " + _loc6_);
            if (_loc6_ > 50)
            {
                trace("MORE THAN 50 RESULTS");
            }
            var _loc7_:int = 0;
            while (_loc7_ < _loc6_)
            {
                _loc9_ = _loc4_.lv[_loc7_];
                _loc10_ = new LevelDataObject(_loc9_.@id, _loc9_.@ln, _loc9_.@ui, _loc9_.@un, _loc9_.@rg, _loc9_.@vs, _loc9_.@ps, _loc9_.@dp, _loc9_.uc, _loc9_.@pc, "1", "1", "1", _loc9_.@dp);
                levelDataArray.push(_loc10_);
                if (_favorites)
                {
                    Settings.favoriteLevelIds.push(_loc10_.id);
                }
                _loc7_++;
            }
            if (this.list)
            {
                this.killList();
            }
            this.buildList();
        }

        private function IOErrorHandler(param1:IOErrorEvent):void
        {
            trace("levelbrowser: " + param1.text);
            if (this.statusSprite)
            {
                this.statusSprite.die();
            }
            this.removeLoaderListeners();
            this.updateRefreshButton();
            this.refreshButton.setSpin(false);
            this.createPromptSprite("Sorry, there was an IO Error.", "ugh, ok");
        }

        private function createPromptSprite(param1:String, param2:String):void
        {
            var _loc3_:PromptSprite = new PromptSprite(param1, param2);
            var _loc4_:Window = _loc3_.window;
            addChild(_loc4_);
            _loc4_.center();
        }

        private function securityErrorHandler(param1:SecurityErrorEvent):void
        {
            trace("levelbrowser: " + param1.text);
            if (this.statusSprite)
            {
                this.statusSprite.die();
            }
            this.removeLoaderListeners();
            this.updateRefreshButton();
            this.refreshButton.setSpin(false);
            this.createPromptSprite("Sorry, there was a Security Error.", "ugh, ok");
        }

        private function removeLoaderListeners():void
        {
            this.loader.removeEventListener(Event.COMPLETE, this.flagComplete);
            this.loader.removeEventListener(Event.COMPLETE, this.levelDataLoaded);
            this.loader.removeEventListener(Event.COMPLETE, this.editFavoritesComplete);
            this.loader.removeEventListener(IOErrorEvent.IO_ERROR, this.IOErrorHandler);
            this.loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, this.securityErrorHandler);
        }

        private function buildDropMenus():void
        {
            var _loc1_:int = Settings.user_id;
            if (_loc1_ > 0)
            {
                if (authorValues.indexOf(_loc1_) == -1)
                {
                    authorValues.push(_loc1_);
                    authorDisplay.push(Settings.username);
                }
            }
            var _loc2_:Array = Settings.characterNames.concat("all", "any");
            var _loc3_:* = new Array();
            var _loc4_:int = 0;
            while (_loc4_ < Settings.totalCharacters)
            {
                _loc3_.push(_loc4_ + 1);
                _loc4_++;
            }
            _loc3_ = _loc3_.concat(0, -1);
            trace(_loc3_);
            var _loc5_:Array = ["newest", "oldest", "play count", "rating"];
            var _loc6_:Array = ["newest", "oldest", "plays", "rating"];
            var _loc7_:Array = ["today", "this week", "this month", "anytime"];
            var _loc8_:Array = ["today", "week", "month", "anytime"];
            this.authorDropMenu = new DropMenu("author:", authorDisplay, authorValues, savedDropSettings[0]);
            this.charDropMenu = new DropMenu("playable character:", _loc2_, _loc3_, -1);
            this.sortDropMenu = new DropMenu("sort by:", _loc5_, _loc6_, savedDropSettings[1]);
            this.uploadDropMenu = new DropMenu("uploaded:", _loc7_, _loc8_, savedDropSettings[2]);
            addChild(this.authorDropMenu);
            addChild(this.sortDropMenu);
            addChild(this.uploadDropMenu);
            var _loc9_:* = this.shadow.y - 21;
            this.uploadDropMenu.y = this.shadow.y - 21;
            this.authorDropMenu.y = this.charDropMenu.y = this.sortDropMenu.y = _loc9_;
            this.authorDropMenu.addEventListener(DropMenu.ITEM_SELECTED, this.dropMenuSelected);
            this.charDropMenu.addEventListener(DropMenu.ITEM_SELECTED, this.dropMenuSelected);
            this.sortDropMenu.addEventListener(DropMenu.ITEM_SELECTED, this.dropMenuSelected);
            this.uploadDropMenu.addEventListener(DropMenu.ITEM_SELECTED, this.dropMenuSelected);
            this.dropMenuArray = [this.authorDropMenu, this.sortDropMenu, this.uploadDropMenu];
            _loc4_ = 0;
            while (_loc4_ < this.dropMenuArray.length)
            {
                currentDropStates[_loc4_] = savedDropStates[_loc4_];
                _loc4_++;
            }
            this.organizeDropMenus();
        }

        private function organizeDropMenus():void
        {
            var _loc3_:DropMenu = null;
            var _loc4_:int = 0;
            var _loc1_:Number = this.shadow.width + this.shadow.x;
            var _loc2_:int = int(this.dropMenuArray.length - 1);
            while (_loc2_ > -1)
            {
                _loc3_ = this.dropMenuArray[_loc2_];
                _loc4_ = int(currentDropStates[_loc2_]);
                if (_loc4_ == 1)
                {
                    _loc3_.visible = true;
                    _loc3_.xLeft = _loc1_ - _loc3_.width;
                    _loc1_ = _loc3_.xLeft - dropMenuSpacing;
                }
                else
                {
                    _loc3_.visible = false;
                }
                _loc2_--;
            }
        }

        private function dropMenuSelected(param1:Event = null):void
        {
            var _loc2_:int = 0;
            var _loc4_:DropMenu = null;
            if (param1 != null)
            {
                _loc4_ = param1.target as DropMenu;
            }
            else
            {
                _loc4_ = this.authorDropMenu;
            }
            var _loc3_:int = _loc4_.currentIndex;
            if (_loc4_ == this.authorDropMenu)
            {
                _loc2_ = 0;
                currentDropStates = _loc3_ > 0 ? [1, 0, 0] : [1, 1, 1];
            }
            else if (_loc4_ != this.charDropMenu)
            {
                if (_loc4_ == this.sortDropMenu)
                {
                    _loc2_ = 1;
                }
                else
                {
                    _loc2_ = 2;
                }
            }
            currentDropSettings[_loc2_] = _loc3_;
            this.organizeDropMenus();
            this.updateRefreshButton(param1 == null);
        }

        private function updateRefreshButton(param1:Boolean = false):void
        {
            var _loc2_:int = 0;
            while (_loc2_ < this.dropMenuArray.length)
            {
                if (currentDropSettings[_loc2_] != savedDropSettings[_loc2_])
                {
                    param1 = true;
                }
                _loc2_++;
            }
            this.refreshButton.setGlow(param1);
        }

        private function backPress(param1:MouseEvent):void
        {
            Tracker.trackEvent(Tracker.LEVEL_BROWSER, Tracker.GOTO_MAIN_MENU);
            dispatchEvent(new NavigationEvent(NavigationEvent.MAIN_MENU));
        }

        private function listFavorites(param1:MouseEvent):void
        {
            if (_favorites)
            {
                return;
            }
            if (this.searchTermButton)
            {
                this.removeSearchTerm();
            }
            Tracker.trackEvent(Tracker.LEVEL_BROWSER, Tracker.GET_FAVORITES);
            _favorites = true;
            this.createSearchTermButton(3);
            this.loadData();
        }

        private function openSearchMenu(param1:MouseEvent):void
        {
            this.searchMenu = new SearchLevelMenu();
            var _loc2_:Window = this.searchMenu.window;
            addChild(_loc2_);
            _loc2_.center();
            this.searchMenu.addEventListener(SearchLevelMenu.SEARCH, this.beginSearch);
            this.searchMenu.addEventListener(SearchLevelMenu.CANCEL, this.closeSearchMenu);
        }

        private function closeSearchMenu(param1:Event = null):*
        {
            this.searchMenu.removeEventListener(SearchLevelMenu.SEARCH, this.beginSearch);
            this.searchMenu.removeEventListener(SearchLevelMenu.CANCEL, this.closeSearchMenu);
            this.searchMenu.die();
            this.searchMenu = null;
        }

        private function beginSearch(param1:Event):void
        {
            var _loc2_:String = this.searchMenu.searchTerm;
            var _loc3_:String = this.searchMenu.searchType;
            this.closeSearchMenu();
            if (this.searchTermButton)
            {
                this.removeSearchTerm();
            }
            if (_loc3_ == SearchLevelMenu.LEVEL_NAME)
            {
                savedTerm = _loc2_;
                this.createSearchTermButton(1);
                Tracker.trackEvent(Tracker.LEVEL_BROWSER, Tracker.LEVEL_SEARCH, _loc2_);
                this.loadData();
            }
            else if (_loc3_ == SearchLevelMenu.AUTHOR_NAME)
            {
                savedTerm = _loc2_;
                this.createSearchTermButton(2);
                Tracker.trackEvent(Tracker.LEVEL_BROWSER, Tracker.AUTHOR_SEARCH, _loc2_);
                this.loadData();
            }
        }

        private function createSearchTermButton(param1:int):void
        {
            var _loc2_:* = null;
            var _loc3_:Number = 0;
            var _loc4_:Number = 0;
            if (param1 == 1)
            {
                levelSearch = savedTerm;
                _loc2_ = "level name: \'" + savedTerm + "\'";
                _loc3_ = 4032711;
                _loc4_ = 16777215;
            }
            else if (param1 == 2)
            {
                authorNameSearch = savedTerm;
                _loc2_ = "author name: \'" + savedTerm + "\'";
                _loc3_ = 16613761;
                _loc4_ = 16777215;
            }
            else if (param1 == 3)
            {
                _loc2_ = "favorites";
                _loc3_ = 16776805;
                _loc4_ = 6312772;
            }
            this.searchTermButton = new XButton(_loc2_, _loc3_, 120, _loc4_);
            addChild(this.searchTermButton);
            this.searchTermButton.x = this.shadow.x;
            this.searchTermButton.y = this.shadow.y - 27;
            currentDropStates = param1 == 3 ? [0, 0, 0] : [0, 1, 0];
            this.organizeDropMenus();
            this.searchTermButton.addEventListener(MouseEvent.MOUSE_UP, this.removeSearchTerm);
        }

        private function removeSearchTerm(param1:MouseEvent = null):void
        {
            levelSearch = null;
            authorNameSearch = null;
            _favorites = false;
            this.searchTermButton.removeEventListener(MouseEvent.MOUSE_UP, this.removeSearchTerm);
            removeChild(this.searchTermButton);
            this.searchTermButton = null;
            this.dropMenuSelected();
        }

        private function editFavorites(param1:BrowserEvent):void
        {
            var _loc7_:String = null;
            var _loc2_:Boolean = param1.type == BrowserEvent.ADD_TO_FAVORITES ? true : false;
            if (Settings.user_id <= 0)
            {
                this.createPromptSprite("You must be logged in to edit your favorite levels.  Login or register for free up there on the right.", "ok");
                return;
            }
            if (Settings.disableUpload)
            {
                this.createPromptSprite(Settings.disableMessage, "OH FINE");
                return;
            }
            var _loc3_:int = param1.extra as int;
            var _loc4_:URLRequest = new URLRequest(Settings.siteURL + "user.hw");
            _loc4_.method = URLRequestMethod.POST;
            var _loc5_:URLVariables = new URLVariables();
            _loc5_.level_id = _loc3_;
            _loc4_.data = _loc5_;
            if (_loc2_)
            {
                trace("ADD TO FAVORITES");
                _loc7_ = "adding level to favorites...";
                _loc5_.action = "set_favorite";
                this.favoriteId = _loc3_;
            }
            else
            {
                trace("REMOVE FROM FAVORITES");
                _loc7_ = "removing level from favorites...";
                _loc5_.action = "delete_favorite";
                this.favoriteId = -_loc3_;
            }
            this.statusSprite = new StatusSprite(_loc7_);
            var _loc6_:Window = this.statusSprite.window;
            addChild(_loc6_);
            _loc6_.center();
            this.loader = new URLLoader();
            this.loader.addEventListener(Event.COMPLETE, this.editFavoritesComplete);
            this.loader.addEventListener(IOErrorEvent.IO_ERROR, this.IOErrorHandler);
            this.loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.securityErrorHandler);
            this.loader.load(_loc4_);
        }

        private function editFavoritesComplete(param1:Event):void
        {
            var _loc5_:int = 0;
            trace("EDIT FAVORITES -- COMPLETE");
            this.statusSprite.die();
            this.removeLoaderListeners();
            var _loc2_:String = String(this.loader.data);
            var _loc3_:String = _loc2_.substr(0, 8);
            trace("dataString " + _loc3_);
            var _loc4_:Array = _loc2_.split(":");
            if (_loc3_.indexOf("<html>") > -1)
            {
                this.createPromptSprite("There was an unexpected system Error", "oh");
            }
            else if (_loc4_[0] == "failure")
            {
                if (_loc4_[1] == "not_logged_in")
                {
                    this.createPromptSprite("You must be logged in to edit your favorite levels.  Login or register for free up there on the right.", "ok");
                }
                else if (_loc4_[1] == "duplicate")
                {
                    this.createPromptSprite("This level is already one of your favorite levels.", "ok");
                }
                else if (_loc4_[1] == "invalid_action")
                {
                    this.createPromptSprite("An invalid action was passed (you really shouldn\'t ever be seeing this).", "ok");
                }
                else if (_loc4_[1] == "bad_param")
                {
                    this.createPromptSprite("A bad parameter was passed (you really shouldn\'t ever be seeing this).", "ok");
                }
                else if (_loc4_[1] == "app_error")
                {
                    this.createPromptSprite("Sorry, there was an application error. It was most likely database related. Please try again in a moment.", "ok");
                }
                else
                {
                    this.createPromptSprite("An unknown Error has occurred.", "oh");
                }
            }
            else if (_loc4_[0] == "success")
            {
                this.createPromptSprite("Favorites list updated.", "ok");
                if (this.favoriteId > 0)
                {
                    _loc5_ = int(Settings.favoriteLevelIds.indexOf(this.favoriteId));
                    if (_loc5_ == -1)
                    {
                        Settings.favoriteLevelIds.push(this.favoriteId);
                    }
                }
                else if (this.favoriteId < 0)
                {
                    _loc5_ = int(Settings.favoriteLevelIds.indexOf(-this.favoriteId));
                    if (_loc5_ > -1)
                    {
                        Settings.favoriteLevelIds.splice(_loc5_, 1);
                    }
                }
            }
        }

        private function flagLevel(param1:BrowserEvent):void
        {
            trace("FLAG LEVEL");
            var _loc2_:int = param1.extra as int;
            this.statusSprite = new StatusSprite("flagging level...");
            var _loc3_:Window = this.statusSprite.window;
            addChild(_loc3_);
            _loc3_.center();
            var _loc4_:URLRequest = new URLRequest(Settings.siteURL + Settings.FLAG_LEVEL);
            var _loc5_:URLVariables = new URLVariables();
            _loc5_.levelid = _loc2_;
            _loc4_.data = _loc5_;
            this.loader = new URLLoader();
            this.loader.dataFormat = URLLoaderDataFormat.VARIABLES;
            this.loader.addEventListener(Event.COMPLETE, this.flagComplete);
            this.loader.addEventListener(IOErrorEvent.IO_ERROR, this.IOErrorHandler);
            this.loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.securityErrorHandler);
            this.loader.load(_loc4_);
        }

        private function flagComplete(param1:Event):void
        {
            this.statusSprite.die();
            this.removeLoaderListeners();
            trace(this.loader.data.ToFlash);
            if (this.loader.data.ToFlash != "error")
            {
                this.createPromptSprite("Level flagged, Thank you.", "ok");
            }
        }

        private function updateAuthors(param1:String, param2:int):void
        {
            if (authorValues.indexOf(param2) == -1)
            {
                authorValues.push(param2);
                authorDisplay.push(param1);
                this.authorDropMenu.addValue(param1, param2);
            }
        }

        private function getLevelsFromAuthor(param1:BrowserEvent):void
        {
            var _loc2_:LevelDataObject = param1.extra as LevelDataObject;
            this.updateAuthors(_loc2_.author_name, _loc2_.author_id);
            this.authorDropMenu.currentIndex = this.authorDropMenu.valueIndex(_loc2_.author_id);
            currentDropSettings[0] = this.authorDropMenu.currentIndex;
            trace("searchtermbutton " + this.searchTermButton);
            if (this.searchTermButton)
            {
                this.removeSearchTerm();
            }
            currentDropStates = [1, 0, 0];
            this.organizeDropMenus();
            this.loadData();
        }

        private function flipPage(param1:Event):void
        {
            var _loc2_:int = currentSet;
            currentPage = this.pageFlipper.currentPage;
            currentSet = Math.ceil(currentPage * pageLength / setLength);
            var _loc3_:int = int(levelDataArray.length);
            if (currentSet > _loc2_ && _loc3_ <= (currentSet - 1) * setLength)
            {
                this.loadDataOffset();
            }
            else
            {
                this.killList();
                this.buildList();
            }
        }

        private function buildList():void
        {
            var _loc5_:Boolean = false;
            var _loc1_:int = (currentPage - 1) * pageLength;
            var _loc2_:int = _loc1_ + pageLength;
            _loc2_ = Math.min(_loc2_, levelDataArray.length);
            var _loc3_:Array = levelDataArray.slice(_loc1_, _loc2_);
            this.listContainer = new Sprite();
            this.list = new LevelList(_loc3_, lastLevelId, selectedCharacter);
            lastLevelId = -1;
            this.listMask = new Sprite();
            this.listContainer.x = this.listHeader.x;
            this.listContainer.y = this.listHeader.y + this.listHeader.height;
            this.listMask.graphics.beginFill(16711680);
            this.listMask.graphics.drawRect(0, 0, this.shadow.width, this.shadow.height - this.listHeader.height);
            this.listMask.graphics.endFill();
            this.list.mask = this.listMask;
            addChildAt(this.listContainer, getChildIndex(this.listHeader));
            this.listContainer.addChild(this.list);
            this.listContainer.addChild(this.listMask);
            this.list.addEventListener(LevelList.UPDATE_SCROLLER, this.updateScroller);
            this.list.addEventListener(LevelList.FACE_SELECTED, this.faceSelected);
            this.list.addEventListener(NavigationEvent.SESSION, this.cloneAndDispatchEvent);
            this.list.addEventListener(NavigationEvent.EDITOR, this.cloneAndDispatchEvent);
            this.list.addEventListener(NavigationEvent.REPLAY_BROWSER, this.cloneAndDispatchEvent);
            this.list.addEventListener(BrowserEvent.USER, this.getLevelsFromAuthor);
            this.list.addEventListener(BrowserEvent.FLAG, this.flagLevel);
            this.list.addEventListener(BrowserEvent.ADD_TO_FAVORITES, this.editFavorites);
            this.list.addEventListener(BrowserEvent.REMOVE_FROM_FAVORITES, this.editFavorites);
            this.scrollBar = new ListScroller(this.list, this.listMask, 22);
            this.scrollBar.x = this.shadow.x + this.shadow.width + 10;
            this.scrollBar.y = this.listContainer.y;
            addChildAt(this.scrollBar, 1);
            this.faceSelected();
            if (this.pageFlipper)
            {
                this.pageFlipper.die();
                this.pageFlipper.removeEventListener(PageFlipperNew.FLIP_PAGE, this.flipPage);
                removeChild(this.pageFlipper);
                this.pageFlipper = null;
            }
            var _loc4_:int = int(levelDataArray.length);
            if (_loc4_ == 0)
            {
                this.createPromptSprite("no levels found using these parameters", "ok");
            }
            else
            {
                _loc5_ = _loc4_ % setLength > 0 ? true : false;
                this.pageFlipper = new PageFlipperNew(currentPage, pageLength, _loc4_, _loc5_);
                addChild(this.pageFlipper);
                this.pageFlipper.x = this.shadow.x + this.shadow.width;
                this.pageFlipper.y = this.shadow.y + this.shadow.height + 7;
                this.pageFlipper.addEventListener(PageFlipperNew.FLIP_PAGE, this.flipPage);
            }
        }

        private function killList():void
        {
            this.list.removeEventListener(LevelList.UPDATE_SCROLLER, this.updateScroller);
            this.list.removeEventListener(LevelList.FACE_SELECTED, this.faceSelected);
            this.list.removeEventListener(NavigationEvent.SESSION, this.cloneAndDispatchEvent);
            this.list.removeEventListener(NavigationEvent.EDITOR, this.cloneAndDispatchEvent);
            this.list.removeEventListener(NavigationEvent.REPLAY_BROWSER, this.cloneAndDispatchEvent);
            this.list.removeEventListener(BrowserEvent.USER, this.getLevelsFromAuthor);
            this.list.removeEventListener(BrowserEvent.FLAG, this.flagLevel);
            this.list.removeEventListener(BrowserEvent.ADD_TO_FAVORITES, this.editFavorites);
            this.list.removeEventListener(BrowserEvent.REMOVE_FROM_FAVORITES, this.editFavorites);
            this.list.die();
            this.list = null;
            this.scrollBar.die();
            removeChild(this.scrollBar);
            this.scrollBar = null;
            removeChild(this.listContainer);
            this.listContainer = null;
            this.listMask = null;
        }

        private function cloneAndDispatchEvent(param1:NavigationEvent):void
        {
            if (param1.levelDataObject)
            {
                lastLevelId = param1.levelDataObject.id;
            }
            var _loc2_:Event = param1.clone();
            dispatchEvent(_loc2_);
        }

        private function faceSelected(param1:Event = null):void
        {
            selectedCharacter = this.list.selectedCharacter;
            if (selectedCharacter > 0)
            {
                this.scrollBar.addTickMarks(this.list.highlightedArray);
            }
            else
            {
                this.scrollBar.removeTickMarks();
            }
        }

        private function updateScroller(param1:Event = null):void
        {
            this.scrollBar.updateScrollTab();
        }

        private function listMouseWheelHandler(param1:MouseEvent):void
        {
            var _loc2_:Boolean = param1.delta < 0 ? true : false;
            this.scrollBar.step(_loc2_);
        }

        public function die():void
        {
            this.authorDropMenu.removeEventListener(DropMenu.ITEM_SELECTED, this.dropMenuSelected);
            this.charDropMenu.removeEventListener(DropMenu.ITEM_SELECTED, this.dropMenuSelected);
            this.sortDropMenu.removeEventListener(DropMenu.ITEM_SELECTED, this.dropMenuSelected);
            this.uploadDropMenu.removeEventListener(DropMenu.ITEM_SELECTED, this.dropMenuSelected);
            this.authorDropMenu.die();
            this.charDropMenu.die();
            this.sortDropMenu.die();
            this.uploadDropMenu.die();
            if (this.pageFlipper)
            {
                this.pageFlipper.die();
                this.pageFlipper.removeEventListener(PageFlipperNew.FLIP_PAGE, this.flipPage);
            }
            this.searchButton.removeEventListener(MouseEvent.MOUSE_UP, this.openSearchMenu);
            this.favoritesButton.removeEventListener(MouseEvent.MOUSE_UP, this.listFavorites);
            this.backButton.removeEventListener(MouseEvent.MOUSE_UP, this.backPress);
            if (this.searchTermButton)
            {
                this.searchTermButton.removeEventListener(MouseEvent.MOUSE_UP, this.removeSearchTerm);
            }
            this.refreshButton.removeEventListener(MouseEvent.MOUSE_UP, this.loadData);
            if (this.list)
            {
                this.killList();
            }
        }
    }
}
