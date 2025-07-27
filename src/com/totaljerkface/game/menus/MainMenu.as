package com.totaljerkface.game.menus
{
    import com.totaljerkface.game.*;
    import com.totaljerkface.game.editor.*;
    import com.totaljerkface.game.editor.ui.*;
    import com.totaljerkface.game.events.*;
    import com.totaljerkface.game.sound.*;
    import com.totaljerkface.game.utils.*;
    import flash.display.*;
    import flash.events.*;
    import flash.media.*;
    import flash.net.*;
    import flash.text.TextField;
    import gs.*;
    import gs.easing.*;

    [Embed(source="/_assets/assets.swf", symbol="symbol455")]
    public class MainMenu extends Sprite
    {
        private static var currentMenu:String;

        private static var previousMenu:String;

        private static var firstLoad:Boolean = true;

        public static const FEATURED_MENU:String = "featuredmenu";

        public static const LEVEL_BROWSER:String = "levelbrowser";

        public static const REPLAY_BROWSER:String = "replaybrowser";

        public var oldMan:OldMan;

        public var logo:Sprite;

        public var logobg:Sprite;

        public var versionText:TextField;

        public var appLink:AppLinkButton;

        private var bg:Sprite;

        private var smokeSprite1:Sprite;

        private var smokeSprite2:Sprite;

        private var scrollSpeedX:int = 2;

        private var scrollSpeedY:int = 1;

        private var superPretzel:SoundItem;

        private var loadMenu:LoadLevelMenu;

        private var featuredMenu:FeaturedMenu;

        private var levelBrowser:LevelBrowser;

        private var replayBrowser:ReplayBrowser;

        private var playBtn:MainSelectionButton;

        private var browseBtn:MainSelectionButton;

        private var editorBtn:MainSelectionButton;

        private var optionsBtn:MainSelectionButton;

        private var loadLevelBtn:MainSelectionButton;

        private var creditsBtn:MainSelectionButton;

        private var buttons:Array;

        private const buttonX:Number = 885;

        private var buttonSpacing:int = 10;

        private var spaceHeight:int = 0;

        private var menuCenter:Number = 380;

        private var tweenTime:Number = 1;

        private var _tweenVal:Number = 0;

        private var transitioning:Boolean;

        private var leftBrowser:Sprite;

        private var rightBrowser:Sprite;

        private var menuMask:Sprite;

        private var statusSprite:StatusSprite;

        private var promptSprite:PromptSprite;

        private var bigArrow:Sprite;

        private var muteBtn:MovieClip;

        public function MainMenu()
        {
            super();
        }

        public static function setCurrentMenu(param1:String):void
        {
            currentMenu = param1;
            firstLoad = false;
        }

        public function init():void
        {
            this.buildStage();
            this.createButtons();
            addEventListener(Event.ENTER_FRAME, this.organizeButtons);
            addEventListener(MouseEvent.MOUSE_UP, this.mouseUpHandler);
            if (firstLoad)
            {
                firstLoad = false;
                this.beginIntroAnimation();
            }
            else
            {
                switch (currentMenu)
                {
                    case FEATURED_MENU:
                        this.openFeaturedMenu();
                        break;
                    case LEVEL_BROWSER:
                        this.openLevelBrowser();
                        break;
                    case REPLAY_BROWSER:
                        this.openReplayBrowser();
                }
            }
        }

        private function buildStage():void
        {
            var _loc5_:BitmapData = null;
            var _loc6_:BitmapData = null;
            var _loc1_:SharedObject = Settings.sharedObject;
            if (_loc1_.data["fatlady"] != 1)
            {
                _loc1_.data["fatlady"] = 1;
                this.oldMan = new FatLady();
            }
            else
            {
                this.oldMan = Math.random() > 0.5 ? new FatLady() : new OldMan();
            }
            this.oldMan.x = 450;
            this.oldMan.y = 250;
            addChildAt(this.oldMan, 0);
            this.bg = new Sprite();
            var _loc2_:int = 900;
            var _loc3_:int = 500;
            this.bg.graphics.beginFill(51);
            this.bg.graphics.drawRect(0, 0, _loc2_, _loc3_);
            this.bg.graphics.endFill();
            var _loc4_:BitmapManager = BitmapManager.instance;
            if (_loc4_.getTexture("smoke1") == null)
            {
                _loc5_ = new BitmapData(_loc2_, _loc3_, true);
                _loc5_.perlinNoise(_loc2_, _loc3_, 10, 4, true, true, BitmapDataChannel.ALPHA, true, null);
                _loc6_ = new BitmapData(_loc2_, _loc3_, true);
                _loc6_.perlinNoise(_loc2_, _loc3_, 10, 4, true, true, BitmapDataChannel.ALPHA, true, null);
                _loc4_.addTexture("smoke1", _loc5_);
                _loc4_.addTexture("smoke2", _loc6_);
            }
            else
            {
                _loc5_ = _loc4_.getTexture("smoke1");
                _loc6_ = _loc4_.getTexture("smoke2");
            }
            this.smokeSprite1 = new Sprite();
            this.smokeSprite1.graphics.beginBitmapFill(_loc5_, null, true);
            this.smokeSprite1.graphics.drawRect(0, 0, _loc2_ * 2, _loc3_ * 2);
            this.smokeSprite1.graphics.endFill();
            this.smokeSprite2 = new Sprite();
            this.smokeSprite2.graphics.beginBitmapFill(_loc6_, null, true);
            this.smokeSprite2.graphics.drawRect(0, 0, _loc2_ * 2, _loc3_ * 2);
            this.smokeSprite2.graphics.endFill();
            this.smokeSprite2.blendMode = BlendMode.HARDLIGHT;
            this.smokeSprite1.alpha = 0.5;
            this.smokeSprite2.alpha = 0.5;
            addChildAt(this.smokeSprite2, 0);
            addChildAt(this.smokeSprite1, 0);
            addChildAt(this.bg, 0);
            this.versionText.text = "v " + TextUtils.setToHundredths(Settings.CURRENT_VERSION);
        }

        private function createButtons():void
        {
            var _loc3_:String = null;
            this.buttons = new Array();
            var _loc1_:Number = 4032711;
            var _loc2_:Number = 16613761;
            _loc3_ = stage.quality;
            stage.quality = "HIGH";
            this.creditsBtn = new MainSelectionButton("CREDITS", 25, _loc2_);
            addChild(this.creditsBtn);
            this.optionsBtn = new MainSelectionButton("OPTIONS", 25, _loc2_);
            addChild(this.optionsBtn);
            this.editorBtn = new MainSelectionButton("LEVEL EDITOR", 30, _loc1_);
            addChild(this.editorBtn);
            this.loadLevelBtn = new MainSelectionButton("LOAD LEVEL/REPLAY", 30, _loc1_);
            addChild(this.loadLevelBtn);
            this.browseBtn = new MainSelectionButton("BROWSE LEVELS", 30, _loc1_);
            addChild(this.browseBtn);
            this.playBtn = new MainSelectionButton("PLAY", 56, _loc1_);
            addChild(this.playBtn);
            this.creditsBtn.x = this.loadLevelBtn.x = this.optionsBtn.x = this.editorBtn.x = this.browseBtn.x = this.playBtn.x = this.buttonX;
            this.buttons = [this.playBtn, this.browseBtn, this.loadLevelBtn, this.editorBtn, this.optionsBtn, this.creditsBtn];
            this.spaceHeight = (this.buttons.length - 1) * this.buttonSpacing;
            stage.quality = _loc3_;
            this.muteBtn = new MuteButton();
            this.muteBtn.x = stage.stageWidth - this.muteBtn.width - 5;
            this.muteBtn.y = 5;
            this.muteBtn.gotoAndStop(1);
            this.muteBtn.buttonMode = true;
            this.muteBtn.alpha = 0.7;
            addChild(this.muteBtn);
            this.muteBtn.gotoAndStop(!!Settings.sharedObject.data["muted"] ? 2 : 1);
        }

        private function beginIntroAnimation():void
        {
            var _loc3_:int = 0;
            var _loc4_:MainSelectionButton = null;
            this.bg.alpha = 0;
            this.smokeSprite1.alpha = 0;
            this.smokeSprite2.alpha = 0;
            this.logo.scaleX = this.logo.scaleY = this.logobg.scaleX = this.logobg.scaleY = 0;
            this.appLink.x = -265;
            var _loc1_:int = int(this.buttons.length);
            var _loc2_:Number = 2;
            _loc3_ = 0;
            while (_loc3_ < _loc1_)
            {
                _loc4_ = this.buttons[_loc3_];
                _loc4_.mouseEnabled = false;
                _loc4_.x = this.buttonX + 400;
                if (_loc3_ == _loc1_ - 1)
                {
                    TweenLite.to(_loc4_, 0.5, {
                                "x": this.buttonX,
                                "ease": Strong.easeOut,
                                "delay": _loc2_,
                                "onComplete": this.introComplete
                            });
                }
                else
                {
                    TweenLite.to(_loc4_, 0.5, {
                                "x": this.buttonX,
                                "ease": Strong.easeOut,
                                "delay": _loc2_
                            });
                }
                _loc2_ += 0.15;
                _loc3_++;
            }
            TweenLite.to(this.smokeSprite1, 1, {"alpha": 0.5});
            TweenLite.to(this.smokeSprite2, 1, {"alpha": 0.5});
            TweenLite.to(this.bg, 2, {"alpha": 1});
            TweenLite.to(this.logo, 0.5, {
                        "scaleX": 2,
                        "scaleY": 2,
                        "ease": Bounce.easeOut,
                        "delay": 1.5
                    });
            TweenLite.to(this.logobg, 0.5, {
                        "scaleX": 2,
                        "scaleY": 2,
                        "ease": Bounce.easeOut,
                        "delay": 1.5
                    });
            TweenLite.to(this.appLink, 0.5, {
                        "x": 37.75,
                        "ease": Strong.easeOut,
                        "delay": 1.5
                    });
            this.oldMan.slideIn();
            this.superPretzel = SoundController.instance.playSoundItem("SuperPretzel");
        }

        private function introComplete():void
        {
            var _loc3_:MainSelectionButton = null;
            var _loc1_:int = 0;
            while (_loc1_ < this.buttons.length)
            {
                _loc3_ = this.buttons[_loc1_];
                _loc3_.mouseEnabled = true;
                _loc1_++;
            }
            var _loc2_:SharedObject = Settings.sharedObject;
            trace("blood popup " + _loc2_.data["bloodpopup"]);
            if (Settings.CURRENT_VERSION == 1.6 && _loc2_.data["bloodpopup"] == undefined)
            {
                _loc2_.data["bloodpopup"] = 1;
                this.promptSprite = new PromptSprite("For those of you incapable of problem solving, I\'ve set blood back to setting 1 by default. As stated several times, you can change the blood in the options menu. Here is a large, noticeable arrow pointing to the options menu. It\'s the button labelled: options.", "woah!", false, 250);
                addChild(this.promptSprite.window);
                this.promptSprite.window.x = 310;
                this.promptSprite.window.y = 320;
                this.optionsBtn.addArrow();
            }
        }

        private function organizeButtons(param1:Event):void
        {
            var _loc7_:MainSelectionButton = null;
            var _loc2_:Number = 0;
            var _loc3_:Number = 0;
            var _loc4_:int = int(this.buttons.length);
            var _loc5_:int = 0;
            while (_loc5_ < _loc4_)
            {
                _loc7_ = this.buttons[_loc5_];
                _loc3_ += _loc7_.height;
                _loc5_++;
            }
            _loc2_ = _loc3_ + this.spaceHeight;
            var _loc6_:int = this.menuCenter - _loc2_ * 0.5;
            _loc5_ = 0;
            while (_loc5_ < _loc4_)
            {
                _loc7_ = this.buttons[_loc5_];
                _loc7_.y = _loc6_;
                _loc6_ = _loc7_.y + _loc7_.height + this.buttonSpacing;
                _loc5_++;
            }
            this.scrollSmoke();
            this.oldMan.step();
        }

        private function scrollSmoke(param1:Event = null):void
        {
            this.smokeSprite1.x += this.scrollSpeedX * 2;
            this.smokeSprite1.y -= this.scrollSpeedY;
            this.smokeSprite2.x -= this.scrollSpeedX;
            this.smokeSprite2.y -= this.scrollSpeedY;
            if (this.smokeSprite1.x > 0)
            {
                this.smokeSprite1.x -= this.smokeSprite1.width / 2;
            }
            if (this.smokeSprite1.y < -this.smokeSprite1.height / 2)
            {
                this.smokeSprite1.y += this.smokeSprite1.height / 2;
            }
            if (this.smokeSprite2.x < -this.smokeSprite2.width / 2)
            {
                this.smokeSprite2.x += this.smokeSprite2.width / 2;
            }
            if (this.smokeSprite2.y < -this.smokeSprite2.height / 2)
            {
                this.smokeSprite2.y += this.smokeSprite2.height / 2;
            }
        }

        private function mouseUpHandler(param1:MouseEvent):void
        {
            var _loc2_:SharedObject = null;
            switch (param1.target)
            {
                case this.playBtn:
                    Tracker.trackEvent(Tracker.MAIN_MENU, Tracker.GOTO_FEATURED_BROWSER);
                    this.openFeaturedMenu();
                    this.maskTransition(this.featuredMenu);
                    break;
                case this.browseBtn:
                    Tracker.trackEvent(Tracker.MAIN_MENU, Tracker.GOTO_LEVEL_BROWSER);
                    this.openLevelBrowser();
                    this.maskTransition(this.levelBrowser);
                    break;
                case this.editorBtn:
                    Tracker.trackEvent(Tracker.MAIN_MENU, Tracker.GOTO_EDITOR);
                    currentMenu = null;
                    dispatchEvent(new NavigationEvent(NavigationEvent.EDITOR));
                    break;
                case this.loadLevelBtn:
                    Tracker.trackEvent(Tracker.MAIN_MENU, Tracker.GOTO_LEVEL_REPLAY_LOADER);
                    this.openLoadLevelMenu();
                    break;
                case this.optionsBtn:
                    Tracker.trackEvent(Tracker.MAIN_MENU, Tracker.GOTO_OPTIONS);
                    this.openBasicMenu("options");
                    break;
                case this.creditsBtn:
                    Tracker.trackEvent(Tracker.MAIN_MENU, Tracker.GOTO_CREDITS);
                    this.openBasicMenu("credits");
                    break;
                case this.muteBtn:
                    _loc2_ = Settings.sharedObject;
                    if (_loc2_.data["muted"])
                    {
                        Tracker.trackEvent(Tracker.MAIN_MENU, Tracker.UNMUTE);
                        SoundController.instance.unMute();
                        this.muteBtn.gotoAndStop(1);
                    }
                    else
                    {
                        Tracker.trackEvent(Tracker.MAIN_MENU, Tracker.MUTE);
                        SoundController.instance.mute();
                        this.muteBtn.gotoAndStop(2);
                    }
                    break;
                default:
                    return;
            }
            SoundController.instance.playSoundItem("MenuSelect");
        }

        private function openLoadLevelMenu():void
        {
            this.loadMenu = new LoadLevelMenu();
            var _loc1_:Window = this.loadMenu.window;
            addChild(_loc1_);
            _loc1_.center();
            this.loadMenu.addEventListener(LoadLevelMenu.LOAD, this.beginLoad);
            this.loadMenu.addEventListener(LoadLevelMenu.CANCEL, this.closeLoadMenu);
        }

        private function beginLoad(param1:Event):void
        {
            var _loc5_:String = null;
            var _loc6_:LevelLoader = null;
            var _loc7_:Window = null;
            var _loc8_:ReplayLoader = null;
            var _loc2_:String = this.loadMenu.loadID;
            var _loc3_:String = this.loadMenu.loadType;
            var _loc4_:Array = _loc2_.split("=");
            if (_loc4_.length > 1)
            {
                _loc5_ = _loc4_[0];
                if (_loc5_.indexOf("levelid") > -1)
                {
                    _loc3_ = LoadLevelMenu.LEVEL;
                }
                else if (_loc5_.indexOf("replayid") > -1)
                {
                    _loc3_ = LoadLevelMenu.REPLAY;
                }
                _loc2_ = this.loadMenu.loadID = _loc4_[1];
            }
            if (_loc3_ == LoadLevelMenu.LEVEL)
            {
                this.statusSprite = new StatusSprite("loading level...");
                _loc7_ = this.statusSprite.window;
                addChild(_loc7_);
                _loc7_.center();
                _loc6_ = new LevelLoader();
                _loc6_.addEventListener(LevelLoader.LEVEL_LOADED, this.levelLoadComplete);
                _loc6_.addEventListener(LevelLoader.ID_NOT_FOUND, this.levelLoadComplete);
                _loc6_.addEventListener(LevelLoader.LOAD_ERROR, this.levelLoadComplete);
                _loc6_.load(int(_loc2_));
            }
            else
            {
                this.statusSprite = new StatusSprite("loading replay...");
                _loc7_ = this.statusSprite.window;
                addChild(_loc7_);
                _loc7_.center();
                _loc8_ = new ReplayLoader();
                _loc8_.addEventListener(ReplayLoader.REPLAY_AND_LEVEL_LOADED, this.replayLoadComplete);
                _loc8_.addEventListener(ReplayLoader.ID_NOT_FOUND, this.replayLoadComplete);
                _loc8_.addEventListener(ReplayLoader.LOAD_ERROR, this.replayLoadComplete);
                _loc8_.load(int(_loc2_));
            }
            this.closeLoadMenu(param1);
        }

        private function closeLoadMenu(param1:Event):void
        {
            this.loadMenu.removeEventListener(LoadLevelMenu.LOAD, this.beginLoad);
            this.loadMenu.removeEventListener(LoadLevelMenu.CANCEL, this.closeLoadMenu);
            this.loadMenu.die();
            this.loadMenu = null;
        }

        private function levelLoadComplete(param1:Event):void
        {
            var _loc3_:PromptSprite = null;
            var _loc4_:Window = null;
            var _loc5_:String = null;
            var _loc6_:String = null;
            var _loc2_:LevelLoader = param1.target as LevelLoader;
            _loc2_.removeEventListener(LevelLoader.LEVEL_LOADED, this.levelLoadComplete);
            _loc2_.removeEventListener(LevelLoader.ID_NOT_FOUND, this.levelLoadComplete);
            _loc2_.removeEventListener(LevelLoader.LOAD_ERROR, this.levelLoadComplete);
            _loc2_.die();
            this.statusSprite.die();
            if (param1.type == LevelLoader.ID_NOT_FOUND)
            {
                _loc3_ = new PromptSprite("Sorry, level not found.", "oh?");
                _loc4_ = _loc3_.window;
                addChild(_loc4_);
                _loc4_.center();
            }
            else if (param1.type == LevelLoader.LOAD_ERROR)
            {
                _loc6_ = "ok";
                if (_loc2_.errorString == "system_error")
                {
                    _loc5_ = "There was an unexpected system Error";
                }
                else if (_loc2_.errorString == "invalid_action")
                {
                    _loc5_ = "An invalid action was passed (you really shouldn\'t ever be seeing this).";
                }
                else if (_loc2_.errorString == "bad_param")
                {
                    _loc5_ = "A bad parameter was passed (you really shouldn\'t ever be seeing this).";
                }
                else if (_loc2_.errorString == "app_error")
                {
                    _loc5_ = "Sorry, there was an application error. It was most likely database related. Please try again in a moment.";
                }
                else if (_loc2_.errorString == "io_error")
                {
                    _loc5_ = "Sorry, there was an IO Error.";
                }
                else if (_loc2_.errorString == "security_error")
                {
                    _loc5_ = "Sorry, there was a security Error.";
                }
                else
                {
                    _loc5_ = "An unknown Error has occurred.";
                }
                _loc3_ = new PromptSprite(_loc5_, _loc6_);
                _loc4_ = _loc3_.window;
                addChild(_loc4_);
                _loc4_.center();
            }
            else
            {
                Tracker.trackEvent(Tracker.LEVEL_REPLAY_LOADER, Tracker.LOAD_LEVEL, "levelID_" + _loc2_.levelDataObject.id);
                currentMenu = LEVEL_BROWSER;
                LevelBrowser.importLevelDataArray([_loc2_.levelDataObject]);
                dispatchEvent(new NavigationEvent(NavigationEvent.SESSION, _loc2_.levelDataObject, null));
            }
        }

        private function replayLoadComplete(param1:Event):void
        {
            var _loc3_:PromptSprite = null;
            var _loc4_:Window = null;
            var _loc5_:String = null;
            var _loc6_:String = null;
            var _loc2_:ReplayLoader = param1.target as ReplayLoader;
            _loc2_.removeEventListener(ReplayLoader.REPLAY_AND_LEVEL_LOADED, this.replayLoadComplete);
            _loc2_.removeEventListener(ReplayLoader.ID_NOT_FOUND, this.replayLoadComplete);
            _loc2_.removeEventListener(ReplayLoader.LOAD_ERROR, this.replayLoadComplete);
            _loc2_.die();
            this.statusSprite.die();
            if (param1.type == ReplayLoader.ID_NOT_FOUND)
            {
                _loc3_ = new PromptSprite("Sorry, replay not found.", "oh?");
                _loc4_ = _loc3_.window;
                addChild(_loc4_);
                _loc4_.center();
            }
            else if (param1.type == LevelLoader.LOAD_ERROR)
            {
                _loc6_ = "ok";
                if (_loc2_.errorString == "system_error")
                {
                    _loc5_ = "There was an unexpected system Error";
                }
                else if (_loc2_.errorString == "invalid_action")
                {
                    _loc5_ = "An invalid action was passed (you really shouldn\'t ever be seeing this).";
                }
                else if (_loc2_.errorString == "bad_param")
                {
                    _loc5_ = "A bad parameter was passed (you really shouldn\'t ever be seeing this).";
                }
                else if (_loc2_.errorString == "app_error")
                {
                    _loc5_ = "Sorry, there was an application error. It was most likely database related. Please try again in a moment.";
                }
                else if (_loc2_.errorString == "io_error")
                {
                    _loc5_ = "Sorry, there was an IO Error.";
                }
                else if (_loc2_.errorString == "security_error")
                {
                    _loc5_ = "Sorry, there was a security Error.";
                }
                else
                {
                    _loc5_ = "An unknown Error has occurred.";
                }
                _loc3_ = new PromptSprite(_loc5_, _loc6_);
                _loc4_ = _loc3_.window;
                addChild(_loc4_);
                _loc4_.center();
            }
            else
            {
                Tracker.trackEvent(Tracker.LEVEL_REPLAY_LOADER, Tracker.LOAD_REPLAY, "replayID_" + _loc2_.replayDataObject.id);
                currentMenu = REPLAY_BROWSER;
                LevelBrowser.importLevelDataArray([_loc2_.levelDataObject]);
                ReplayBrowser.importReplayDataArray([_loc2_.replayDataObject], _loc2_.levelDataObject);
                dispatchEvent(new NavigationEvent(NavigationEvent.SESSION, _loc2_.levelDataObject, _loc2_.replayDataObject));
            }
        }

        private function IOErrorHandler(param1:IOErrorEvent):void
        {
            if (this.statusSprite)
            {
                this.statusSprite.die();
            }
            param1.target.removeEventListener(IOErrorEvent.IO_ERROR, this.IOErrorHandler);
            var _loc2_:PromptSprite = new PromptSprite("Sorry, there was a problem. Please wait a moment and then try again.", "ugh, ok");
            var _loc3_:Window = _loc2_.window;
            addChild(_loc3_);
            _loc3_.center();
        }

        private function maskTransition(param1:Sprite):void
        {
            this.menuMask = new MenuMask();
            addChild(this.menuMask);
            this.menuMask.x = this.menuMask.width;
            param1.mask = this.menuMask;
            TweenLite.to(this.menuMask, 0.5, {
                        "x": -50,
                        "ease": Strong.easeOut,
                        "onComplete": this.maskTransitionComplete
                    });
        }

        private function maskTransitionComplete():void
        {
            if (this.featuredMenu)
            {
                this.featuredMenu.mask = null;
            }
            if (this.levelBrowser)
            {
                this.levelBrowser.mask = null;
            }
            removeChild(this.menuMask);
            this.menuMask = null;
        }

        private function hideButtons():void
        {
            var _loc2_:MainSelectionButton = null;
            var _loc1_:int = 0;
            while (_loc1_ < this.buttons.length)
            {
                _loc2_ = this.buttons[_loc1_];
                _loc2_.alpha = 0.25;
                _loc1_++;
            }
            this.logo.alpha = 0.25;
            this.logobg.alpha = 0.1;
            this.muteBtn.alpha = 0.25;
        }

        private function showButtons():void
        {
            var _loc2_:MainSelectionButton = null;
            var _loc1_:int = 0;
            while (_loc1_ < this.buttons.length)
            {
                _loc2_ = this.buttons[_loc1_];
                _loc2_.alpha = 1;
                _loc1_++;
            }
            this.logo.alpha = 1;
            this.logobg.alpha = 1;
            this.muteBtn.alpha = 0.7;
            this.muteBtn.gotoAndStop(!!Settings.sharedObject.data["muted"] ? 2 : 1);
        }

        private function openBasicMenu(param1:String):void
        {
            var _loc2_:BasicMenu = null;
            switch (param1)
            {
                case "options":
                    _loc2_ = new OptionsMenu(stage.quality, stage.displayState);
                    break;
                case "controls":
                    _loc2_ = new ControlsMenu();
                    break;
                case "credits":
                    _loc2_ = new CreditsMenu();
                    break;
                case "customize_controls":
                    _loc2_ = new CustomizeControlsMenu();
                    break;
                default:
                    throw new Error("basic menu type not defined");
            }
            addChild(_loc2_);
            _loc2_.addEventListener(NavigationEvent.MAIN_MENU, this.basicMenuClosed);
            _loc2_.addEventListener(NavigationEvent.CUSTOMIZE_CONTROLS, this.openCustomizeControls);
            this.hideButtons();
            if (this.superPretzel)
            {
                this.superPretzel.volume = 0.5;
            }
        }

        private function openCustomizeControls(param1:NavigationEvent):void
        {
            this.basicMenuClosed(param1);
            this.openBasicMenu("customize_controls");
        }

        private function basicMenuClosed(param1:NavigationEvent):void
        {
            var _loc2_:BasicMenu = param1.target as BasicMenu;
            _loc2_.removeEventListener(NavigationEvent.MAIN_MENU, this.basicMenuClosed);
            _loc2_.removeEventListener(NavigationEvent.CUSTOMIZE_CONTROLS, this.openCustomizeControls);
            _loc2_.die();
            removeChild(_loc2_);
            this.showButtons();
            if (this.superPretzel)
            {
                this.superPretzel.volume = 1;
            }
        }

        private function openFeaturedMenu():void
        {
            currentMenu = FEATURED_MENU;
            this.hideButtons();
            this.featuredMenu = new FeaturedMenu();
            addChild(this.featuredMenu);
            this.featuredMenu.init();
            this.featuredMenu.addEventListener(NavigationEvent.MAIN_MENU, this.closeFeaturedMenu);
            this.featuredMenu.addEventListener(NavigationEvent.SESSION, this.cloneAndDispatchEvent);
            this.featuredMenu.addEventListener(NavigationEvent.REPLAY_BROWSER, this.transToReplayBrowser);
            this.featuredMenu.addEventListener(NavigationEvent.LEVEL_BROWSER, this.transToLevelBrowser);
            if (!this.transitioning)
            {
                this.featuredMenu.activate();
            }
            if (this.superPretzel)
            {
                this.superPretzel.volume = 0.5;
            }
        }

        private function closeFeaturedMenu(param1:NavigationEvent = null):void
        {
            this.featuredMenu.removeEventListener(NavigationEvent.MAIN_MENU, this.closeFeaturedMenu);
            this.featuredMenu.removeEventListener(NavigationEvent.SESSION, this.cloneAndDispatchEvent);
            this.featuredMenu.removeEventListener(NavigationEvent.REPLAY_BROWSER, this.transToReplayBrowser);
            this.featuredMenu.removeEventListener(NavigationEvent.LEVEL_BROWSER, this.transToLevelBrowser);
            this.featuredMenu.die();
            removeChild(this.featuredMenu);
            this.featuredMenu = null;
            this.showButtons();
            if (this.superPretzel)
            {
                this.superPretzel.volume = 1;
            }
        }

        private function openLevelBrowser(param1:Boolean = true):void
        {
            currentMenu = LEVEL_BROWSER;
            this.hideButtons();
            this.levelBrowser = new LevelBrowser();
            addChild(this.levelBrowser);
            this.levelBrowser.init();
            this.levelBrowser.addEventListener(NavigationEvent.MAIN_MENU, this.closeLevelBrowser);
            this.levelBrowser.addEventListener(NavigationEvent.SESSION, this.cloneAndDispatchEvent);
            this.levelBrowser.addEventListener(NavigationEvent.EDITOR, this.cloneAndDispatchEvent);
            this.levelBrowser.addEventListener(NavigationEvent.REPLAY_BROWSER, this.transToReplayBrowser);
            if (!this.transitioning)
            {
                this.levelBrowser.activate();
            }
            if (this.superPretzel)
            {
                this.superPretzel.volume = 0.5;
            }
        }

        private function closeLevelBrowser(param1:NavigationEvent = null):void
        {
            this.levelBrowser.removeEventListener(NavigationEvent.MAIN_MENU, this.closeLevelBrowser);
            this.levelBrowser.removeEventListener(NavigationEvent.SESSION, this.cloneAndDispatchEvent);
            this.levelBrowser.removeEventListener(NavigationEvent.EDITOR, this.cloneAndDispatchEvent);
            this.levelBrowser.removeEventListener(NavigationEvent.REPLAY_BROWSER, this.transToReplayBrowser);
            this.levelBrowser.die();
            removeChild(this.levelBrowser);
            this.levelBrowser = null;
            this.showButtons();
            if (this.superPretzel)
            {
                this.superPretzel.volume = 1;
            }
        }

        private function openReplayBrowser(param1:LevelDataObject = null):void
        {
            currentMenu = REPLAY_BROWSER;
            this.hideButtons();
            this.replayBrowser = new ReplayBrowser(param1);
            addChild(this.replayBrowser);
            this.replayBrowser.init();
            this.replayBrowser.addEventListener(NavigationEvent.PREVIOUS_MENU, this.transFromReplayBrowser);
            this.replayBrowser.addEventListener(NavigationEvent.SESSION, this.cloneAndDispatchEvent);
            if (!this.transitioning)
            {
                this.replayBrowser.activate();
            }
        }

        private function closeReplayBrowser(param1:NavigationEvent = null):void
        {
            this.replayBrowser.removeEventListener(NavigationEvent.PREVIOUS_MENU, this.transFromReplayBrowser);
            this.replayBrowser.removeEventListener(NavigationEvent.SESSION, this.cloneAndDispatchEvent);
            this.replayBrowser.die();
            removeChild(this.replayBrowser);
            this.replayBrowser = null;
            this.showButtons();
        }

        private function transToLevelBrowser(param1:NavigationEvent):void
        {
            this.transitioning = true;
            this.featuredMenu.mouseChildren = false;
            this.openLevelBrowser();
            this.levelBrowser.x = 900;
            this.leftBrowser = this.featuredMenu;
            this.rightBrowser = this.levelBrowser;
            this._tweenVal = 0;
            TweenLite.to(this, this.tweenTime, {
                        "tweenVal": 1,
                        "ease": Strong.easeInOut,
                        "onComplete": this.transToLBComplete
                    });
        }

        private function transToLBComplete():void
        {
            this.transitioning = false;
            this.leftBrowser = null;
            this.rightBrowser = null;
            this.closeFeaturedMenu();
            this.levelBrowser.activate();
            this.hideButtons();
            if (this.superPretzel)
            {
                this.superPretzel.volume = 0.5;
            }
        }

        private function transToReplayBrowser(param1:NavigationEvent):void
        {
            this.transitioning = true;
            if (param1.target == this.featuredMenu)
            {
                previousMenu = FEATURED_MENU;
                this.featuredMenu.mouseChildren = false;
                this.leftBrowser = this.featuredMenu;
            }
            else
            {
                previousMenu = LEVEL_BROWSER;
                this.levelBrowser.mouseChildren = false;
                this.leftBrowser = this.levelBrowser;
            }
            this.openReplayBrowser(param1.levelDataObject);
            this.replayBrowser.clearReplayList();
            this.replayBrowser.x = 900;
            this.rightBrowser = this.replayBrowser;
            this._tweenVal = 0;
            TweenLite.to(this, this.tweenTime, {
                        "tweenVal": 1,
                        "ease": Strong.easeInOut,
                        "onComplete": this.transToComplete
                    });
        }

        private function transToComplete():void
        {
            this.transitioning = false;
            this.leftBrowser = null;
            this.rightBrowser = null;
            if (previousMenu == FEATURED_MENU)
            {
                this.closeFeaturedMenu();
            }
            else
            {
                this.closeLevelBrowser();
            }
            this.replayBrowser.activate();
            this.hideButtons();
        }

        private function transFromReplayBrowser(param1:NavigationEvent):void
        {
            this.transitioning = true;
            this.replayBrowser.mouseChildren = false;
            if (previousMenu == FEATURED_MENU)
            {
                this.openFeaturedMenu();
                this.featuredMenu.x = -900;
                this.leftBrowser = this.featuredMenu;
            }
            else
            {
                this.openLevelBrowser();
                this.levelBrowser.x = -900;
                this.leftBrowser = this.levelBrowser;
            }
            this.rightBrowser = this.replayBrowser;
            this._tweenVal = 1;
            TweenLite.to(this, this.tweenTime, {
                        "tweenVal": 0,
                        "ease": Strong.easeInOut,
                        "onComplete": this.transFromRBComplete
                    });
        }

        private function transFromRBComplete():void
        {
            this.transitioning = false;
            this.leftBrowser = null;
            this.rightBrowser = null;
            this.closeReplayBrowser();
            if (previousMenu == FEATURED_MENU)
            {
                this.featuredMenu.activate();
            }
            else
            {
                this.levelBrowser.activate();
            }
            previousMenu = null;
            this.hideButtons();
        }

        public function get tweenVal():Number
        {
            return this._tweenVal;
        }

        public function set tweenVal(param1:Number):void
        {
            this._tweenVal = param1;
            var _loc2_:int = Math.round(this._tweenVal * -900);
            this.leftBrowser.x = _loc2_;
            this.rightBrowser.x = _loc2_ + 900;
        }

        private function cloneAndDispatchEvent(param1:Event):void
        {
            dispatchEvent(param1.clone());
        }

        public function die():void
        {
            var _loc2_:MainSelectionButton = null;
            removeEventListener(Event.ENTER_FRAME, this.organizeButtons);
            removeEventListener(MouseEvent.MOUSE_UP, this.mouseUpHandler);
            if (this.featuredMenu)
            {
                this.closeFeaturedMenu();
            }
            if (this.levelBrowser)
            {
                this.closeLevelBrowser();
            }
            if (this.replayBrowser)
            {
                this.closeReplayBrowser();
            }
            if (this.superPretzel)
            {
                this.superPretzel.fadeOut(1);
                this.superPretzel = null;
            }
            var _loc1_:int = 0;
            while (_loc1_ < this.buttons.length)
            {
                _loc2_ = this.buttons[_loc1_];
                _loc2_.die();
                _loc1_++;
            }
        }
    }
}
