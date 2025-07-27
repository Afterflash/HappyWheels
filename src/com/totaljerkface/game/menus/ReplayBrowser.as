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

    [Embed(source="/_assets/assets.swf", symbol="symbol2984")]
    public class ReplayBrowser extends Sprite
    {
        private static var _levelId:int;

        private static var _levelDataObject:LevelDataObject;

        private static var replayDataArray:Array;

        private static var urlVariables:URLVariables;

        private static var currentPage:int;

        private static var totalResults:int;

        private static const pageLength:int = 50;

        private static const setLength:int = 500;

        private static const dropMenuSpacing:Number = 10;

        private static var currentDropSettings:Array = [3];

        private static var savedDropSettings:Array = [3];

        private static var dropStates:Array = [1];

        private static var selectedCharacter:int = -1;

        private static var lastReplayId:int = -1;

        private static var hideInnaccurate:Boolean = false;

        private static var currentSet:int = 1;

        public var bg:Sprite;

        public var shadow:Sprite;

        public var listHeader:Sprite;

        public var backButton:LibraryButton;

        public var titleText:TextField;

        private var archCheck:CheckBox;

        private var refreshButton:RefreshButton;

        private var sortDropMenu:DropMenu;

        private var dropMenuArray:Array;

        private var listContainer:Sprite;

        private var list:ReplayList;

        private var listMask:Sprite;

        private var scrollBar:ListScroller;

        private var pageFlipper:PageFlipperNew;

        private var loader:URLLoader;

        private var statusSprite:StatusSprite;

        public function ReplayBrowser(param1:LevelDataObject = null)
        {
            super();
            if (param1)
            {
                _levelId = param1.id;
                _levelDataObject = param1;
            }
        }

        public static function importReplayDataArray(param1:Array, param2:LevelDataObject):void
        {
            replayDataArray = param1;
            var _loc3_:ReplayDataObject = replayDataArray[0];
            lastReplayId = _loc3_.id;
            _levelDataObject = param2;
            _levelId = param2.id;
            currentPage = 1;
            currentSet = 1;
            hideInnaccurate = false;
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
            var _loc1_:* = "<b>Replays - " + _levelDataObject.name + " <font color=\'#E1E1E1\' size=\'15\'>by</font> <font color=\'#FFFF66\' size=\'15\'>" + _levelDataObject.author_name + "</font></b>";
            trace(_loc1_);
            this.titleText.htmlText = _loc1_;
            this.archCheck = new CheckBox("only show accurate replays", "hideInnaccurate", hideInnaccurate, true, false, 13421772);
            this.archCheck.x = this.shadow.x;
            this.archCheck.y = this.shadow.y - 23;
            addChild(this.archCheck);
            this.archCheck.addEventListener(ValueEvent.VALUE_CHANGE, this.archValueChange);
            this.archCheck.addEventListener(MouseEvent.ROLL_OVER, this.archRollOver);
            this.refreshButton.addEventListener(MouseEvent.MOUSE_UP, this.loadData);
            this.backButton.addEventListener(MouseEvent.MOUSE_UP, this.backPress);
        }

        public function activate():void
        {
            mouseChildren = true;
            if (replayDataArray)
            {
                this.buildList();
            }
            else
            {
                this.loadData();
            }
        }

        public function clearReplayList():void
        {
            replayDataArray = null;
            urlVariables = null;
        }

        private function loadData(param1:MouseEvent = null):void
        {
            var _loc5_:* = undefined;
            var _loc2_:int = 0;
            while (_loc2_ < this.dropMenuArray.length)
            {
                savedDropSettings[_loc2_] = currentDropSettings[_loc2_];
                _loc2_++;
            }
            this.refreshButton.setSpin(true);
            replayDataArray = new Array();
            var _loc3_:URLRequest = new URLRequest(Settings.siteURL + "replay.hw");
            _loc3_.method = URLRequestMethod.POST;
            urlVariables = new URLVariables();
            urlVariables.action = "get_all_by_level";
            urlVariables.page = currentSet = currentPage = 1;
            urlVariables.level_id = _levelId;
            urlVariables.sortby = this.sortDropMenu.value;
            _loc3_.data = urlVariables;
            if (param1)
            {
                Tracker.trackEvent(Tracker.REPLAY_BROWSER, Tracker.REFRESH_REPLAYS, this.sortDropMenu.value);
            }
            this.statusSprite = new StatusSprite("loading replays...");
            var _loc4_:Window = this.statusSprite.window;
            addChild(_loc4_);
            _loc4_.center();
            trace("LOAD DATA");
            for (_loc5_ in urlVariables)
            {
                trace("urlVariables." + _loc5_ + " = " + urlVariables[_loc5_]);
            }
            this.loader = new URLLoader();
            this.loader.addEventListener(Event.COMPLETE, this.replayDataLoaded);
            this.loader.addEventListener(IOErrorEvent.IO_ERROR, this.IOErrorHandler);
            this.loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.securityErrorHandler);
            this.loader.load(_loc3_);
        }

        private function loadDataOffset():void
        {
            var _loc3_:* = undefined;
            this.refreshButton.setSpin(true);
            var _loc1_:URLRequest = new URLRequest(Settings.siteURL + "replay.hw");
            _loc1_.method = URLRequestMethod.POST;
            _loc1_.data = urlVariables;
            urlVariables.page = currentSet;
            this.statusSprite = new StatusSprite("loading replays...");
            var _loc2_:Window = this.statusSprite.window;
            addChild(_loc2_);
            _loc2_.center();
            Tracker.trackEvent(Tracker.REPLAY_BROWSER, Tracker.PAGE_REPLAYS, this.sortDropMenu.value, currentSet);
            trace("LOAD DATA OFFSET");
            for (_loc3_ in urlVariables)
            {
                trace("urlVariables." + _loc3_ + " = " + urlVariables[_loc3_]);
            }
            this.loader = new URLLoader();
            this.loader.addEventListener(Event.COMPLETE, this.replayDataLoaded);
            this.loader.addEventListener(IOErrorEvent.IO_ERROR, this.IOErrorHandler);
            this.loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.securityErrorHandler);
            this.loader.load(_loc1_);
        }

        private function replayDataLoaded(param1:Event):void
        {
            var _loc8_:Array = null;
            var _loc9_:XML = null;
            var _loc10_:ReplayDataObject = null;
            trace("LOAD COMPLETE");
            this.statusSprite.die();
            this.removeLoaderListeners();
            this.refreshButton.setSpin(false);
            var _loc2_:String = String(this.loader.data);
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
            var _loc5_:int = -1;
            if (!replayDataArray)
            {
                replayDataArray = new Array();
            }
            var _loc6_:int = int(_loc4_.rp.length());
            trace("total results = " + _loc6_);
            if (_loc6_ > 50)
            {
                trace("MORE THAN 50 RESULTS");
            }
            var _loc7_:int = 0;
            while (_loc7_ < _loc6_)
            {
                _loc9_ = _loc4_.rp[_loc7_];
                _loc10_ = new ReplayDataObject(_loc9_.@id, _loc9_.@li, _loc9_.@ui, _loc9_.@un, _loc9_.@rg, _loc9_.@vs, _loc9_.@vw, _loc9_.@dc, _loc9_.uc, _loc9_.@pc, _loc9_.@ct, _loc9_.@ar, _loc9_.@vr);
                replayDataArray.push(_loc10_);
                if (lastReplayId > -1 && _loc10_.id == lastReplayId)
                {
                    _loc5_ = _loc7_;
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
            trace("replaybrowser: " + param1.text);
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
            trace("replaybrowser: " + param1.text);
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
            this.loader.removeEventListener(Event.COMPLETE, this.replayDataLoaded);
            this.loader.removeEventListener(IOErrorEvent.IO_ERROR, this.IOErrorHandler);
            this.loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, this.securityErrorHandler);
        }

        private function buildDropMenus():void
        {
            var _loc1_:Array = ["newest", "oldest", "rating", "completion time"];
            var _loc2_:Array = ["newest", "oldest", "rating", "completion_time"];
            var _loc3_:Array = ["today", "this week", "this month", "anytime"];
            var _loc4_:Array = ["today", "week", "month", "anytime"];
            this.sortDropMenu = new DropMenu("sort by:", _loc1_, _loc2_, savedDropSettings[0]);
            addChild(this.sortDropMenu);
            this.sortDropMenu.y = this.shadow.y - 21;
            this.sortDropMenu.addEventListener(DropMenu.ITEM_SELECTED, this.dropMenuSelected);
            this.dropMenuArray = [this.sortDropMenu];
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
                _loc4_ = int(dropStates[_loc2_]);
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
            var _loc2_:DropMenu = param1.target as DropMenu;
            var _loc3_:int = int(this.dropMenuArray.indexOf(_loc2_));
            var _loc4_:int = _loc2_.currentIndex;
            currentDropSettings[_loc3_] = _loc4_;
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
            currentPage = 1;
            Tracker.trackEvent(Tracker.REPLAY_BROWSER, Tracker.GOTO_LEVEL_BROWSER);
            dispatchEvent(new NavigationEvent(NavigationEvent.PREVIOUS_MENU));
        }

        private function flipPage(param1:Event):void
        {
            var _loc2_:int = currentSet;
            currentPage = this.pageFlipper.currentPage;
            currentSet = Math.ceil(currentPage * pageLength / setLength);
            var _loc3_:int = int(replayDataArray.length);
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

        private function flagReplay(param1:BrowserEvent):void
        {
            trace("FLAG REPLAY");
            var _loc2_:int = param1.extra as int;
            this.statusSprite = new StatusSprite("flagging replay...");
            var _loc3_:Window = this.statusSprite.window;
            addChild(_loc3_);
            _loc3_.center();
            var _loc4_:URLRequest = new URLRequest(Settings.siteURL + Settings.FLAG_REPLAY);
            var _loc5_:URLVariables = new URLVariables();
            _loc5_.replayid = _loc2_;
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
            var _loc2_:PromptSprite = null;
            var _loc3_:Window = null;
            this.statusSprite.die();
            this.removeLoaderListeners();
            trace(this.loader.data.ToFlash);
            if (this.loader.data.ToFlash != "error")
            {
                _loc2_ = new PromptSprite("Replay flagged, Thank you.", "ok");
                _loc3_ = _loc2_.window;
                addChild(_loc3_);
                _loc3_.center();
            }
        }

        private function buildList():void
        {
            var _loc5_:PromptSprite = null;
            var _loc6_:Window = null;
            var _loc7_:Boolean = false;
            var _loc1_:int = (currentPage - 1) * pageLength;
            var _loc2_:int = _loc1_ + pageLength;
            _loc2_ = Math.min(_loc2_, replayDataArray.length);
            var _loc3_:Array = replayDataArray.slice(_loc1_, _loc2_);
            this.listContainer = new Sprite();
            this.list = new ReplayList(_loc3_, lastReplayId, selectedCharacter, hideInnaccurate);
            lastReplayId = -1;
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
            this.list.addEventListener(ReplayList.UPDATE_SCROLLER, this.updateScroller);
            this.list.addEventListener(ReplayList.FACE_SELECTED, this.faceSelected);
            this.list.addEventListener(NavigationEvent.SESSION, this.cloneAndDispatchEvent);
            this.list.addEventListener(BrowserEvent.FLAG, this.flagReplay);
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
            var _loc4_:int = int(replayDataArray.length);
            if (_loc4_ == 0)
            {
                _loc5_ = new PromptSprite("no replays found using these parameters", "ok");
                _loc6_ = _loc5_.window;
                addChild(_loc6_);
                _loc6_.center();
            }
            else
            {
                _loc7_ = _loc4_ % setLength > 0 ? true : false;
                this.pageFlipper = new PageFlipperNew(currentPage, pageLength, _loc4_, _loc7_);
                addChild(this.pageFlipper);
                this.pageFlipper.x = this.shadow.x + this.shadow.width;
                this.pageFlipper.y = this.shadow.y + this.shadow.height + 7;
                this.pageFlipper.addEventListener(PageFlipperNew.FLIP_PAGE, this.flipPage);
            }
        }

        private function killList():void
        {
            this.list.removeEventListener(ReplayList.UPDATE_SCROLLER, this.updateScroller);
            this.list.removeEventListener(ReplayList.FACE_SELECTED, this.faceSelected);
            this.list.removeEventListener(NavigationEvent.SESSION, this.cloneAndDispatchEvent);
            this.list.removeEventListener(BrowserEvent.FLAG, this.flagReplay);
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
            var _loc2_:NavigationEvent = null;
            var _loc3_:Event = null;
            trace("Replay browser clone event");
            if (param1.type == NavigationEvent.SESSION)
            {
                if (param1.replayDataObject)
                {
                    lastReplayId = param1.replayDataObject.id;
                }
                _loc2_ = new NavigationEvent(param1.type, _levelDataObject, param1.replayDataObject, param1.extra);
                dispatchEvent(_loc2_);
            }
            else
            {
                _loc3_ = param1.clone();
                dispatchEvent(_loc3_);
            }
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

        private function archValueChange(param1:ValueEvent):void
        {
            hideInnaccurate = param1.value;
            trace("HIDE INACCURATE " + hideInnaccurate);
            this.list.inaccurateHidden = hideInnaccurate;
            this.updateScroller();
        }

        private function archRollOver(param1:MouseEvent):void
        {
            MouseHelper.instance.show("When a replay is saved, the type of computer it was created on is saved along with it.  Computers that match this type will show the replay 100% accurately.  Those that do not will playback the replay with slightly different floating point math, which often (but not always) creates a different end result entirely.<br><br>Users may only rate replays they can view accurately.", this.archCheck);
        }

        public function die():void
        {
            this.sortDropMenu.removeEventListener(DropMenu.ITEM_SELECTED, this.dropMenuSelected);
            this.sortDropMenu.die();
            if (this.pageFlipper)
            {
                this.pageFlipper.die();
                this.pageFlipper.removeEventListener(PageFlipperNew.FLIP_PAGE, this.flipPage);
            }
            this.backButton.removeEventListener(MouseEvent.MOUSE_UP, this.backPress);
            this.archCheck.die();
            this.archCheck.removeEventListener(ValueEvent.VALUE_CHANGE, this.archValueChange);
            this.archCheck.removeEventListener(MouseEvent.ROLL_OVER, this.archRollOver);
            this.refreshButton.removeEventListener(MouseEvent.MOUSE_UP, this.loadData);
            if (this.list)
            {
                this.killList();
            }
        }
    }
}
