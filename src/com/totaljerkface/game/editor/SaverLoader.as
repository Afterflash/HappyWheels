package com.totaljerkface.game.editor
{
    import Box2D.Common.Math.b2Vec2;
    import com.hurlant.util.Base64;
    import com.totaljerkface.game.*;
    import com.totaljerkface.game.editor.specials.*;
    import com.totaljerkface.game.editor.trigger.RefTrigger;
    import com.totaljerkface.game.editor.ui.*;
    import com.totaljerkface.game.menus.LevelDataObject;
    import com.totaljerkface.game.sound.SoundList;
    import com.totaljerkface.game.utils.*;
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.net.*;
    import flash.utils.*;
    
    public class SaverLoader extends EventDispatcher
    {
        public static var _instance:SaverLoader;
        
        public static const LOAD_COMPLETE:String = "loadcomplete";
        
        public static const SAVE_COMPLETE:String = "savecomplete";
        
        public static const PUBLISH_COMPLETE:String = "publishcomplete";
        
        public static const DELETE_COMPLETE:String = "deletecomplete";
        
        public static const GENERIC_ERROR:String = "genericerror";
        
        public static const CLEAR_STAGE:String = "clearstage";
        
        public static const UPDATE_COPIED_VERTS:String = "updatecopiedverts";
        
        private var canvas:Canvas;
        
        private var levelXML:XML;
        
        private var _lastSavedData:LevelDataObject;
        
        private var currentLevelId:int;
        
        private var importable:Boolean;
        
        private var publicLevel:Boolean;
        
        private var comments:String;
        
        private var levelName:String;
        
        private var importAuthorId:int;
        
        private var statusSprite:StatusSprite;
        
        private var promptSprite:StatusSprite;
        
        private var pVertIDs:Array;
        
        private var eVertIDs:Array;
        
        public function SaverLoader(param1:Canvas)
        {
            super();
            if(_instance)
            {
                throw new Error("saverloader already exists");
            }
            this.canvas = param1;
            _instance = this;
            this.init();
        }
        
        public static function get instance() : SaverLoader
        {
            return _instance;
        }
        
        private function init() : void
        {
        }
        
        public function saveNewLevel(param1:String, param2:String) : void
        {
            if(this.canvas.tooManyShapes)
            {
                this.openErrorPrompt("I SAID TOO MANY GODDAMN SHAPES... DELETE SOME","alright");
                return;
            }
            if(this.canvas.tooMuchArt)
            {
                this.openErrorPrompt("I SAID TOO MANY GODDAMN ART SHAPES... DELETE SOME","alright");
                return;
            }
            this.statusSprite = new StatusSprite("Saving New Level...<br><br>(just in case this fails, levels are now autosaved locally)");
            var _loc3_:Window = this.statusSprite.window;
            this.canvas.parent.parent.addChild(_loc3_);
            _loc3_.center();
            this._lastSavedData = new LevelDataObject(null,param1,null,null,null,null,null,null,param2,null,null,null,null,null);
            var _loc4_:URLRequest = new URLRequest(Settings.siteURL + "set_level.hw");
            _loc4_.method = URLRequestMethod.POST;
            var _loc5_:URLVariables = new URLVariables();
            _loc5_.action = "create";
            _loc5_.level_name = param1;
            _loc5_.user_comment = param2;
            _loc5_.playable_character = this.canvas.startPlaceHolder.forceChar ? this.canvas.startPlaceHolder.characterIndex : 0;
            this.levelXML = Settings.sharedObject.data["editorLevelData"] = this.createXML();
            var _loc6_:String = this.levelXML.toXMLString();
            var _loc7_:ByteArray = new ByteArray();
            _loc7_.writeUTFBytes(_loc6_);
            _loc7_.compress();
            LevelEncryptor.encryptByteArray(_loc7_,"eatshit" + Settings.user_id);
            _loc5_.level_record = Base64.encodeByteArray(_loc7_);
            _loc4_.data = _loc5_;
            var _loc8_:URLLoader = new URLLoader();
            _loc8_.addEventListener(Event.COMPLETE,this.levelSaved);
            _loc8_.addEventListener(IOErrorEvent.IO_ERROR,this.IOErrorHandler);
            _loc8_.load(_loc4_);
        }
        
        private function levelSaved(param1:Event) : void
        {
            var _loc3_:String = null;
            trace("level saved");
            this.statusSprite.die();
            var _loc2_:URLLoader = param1.target as URLLoader;
            _loc2_.removeEventListener(Event.COMPLETE,this.levelSaved);
            _loc2_.removeEventListener(IOErrorEvent.IO_ERROR,this.IOErrorHandler);
            trace("result " + _loc3_);
            _loc3_ = String(_loc2_.data);
            var _loc4_:String = _loc3_.substr(0,8);
            var _loc5_:Array = _loc3_.split(":");
            trace("dataString " + _loc4_);
            if(_loc4_.indexOf("<html>") > -1)
            {
                this.openErrorPrompt("There was an unexpected system Error","oh");
            }
            else if(_loc5_[0] == "failure")
            {
                if(_loc5_[1] == "invalid_action")
                {
                    this.openErrorPrompt("An invalid action was passed (you really shouldn\'t ever be seeing this).","ok");
                }
                else if(_loc5_[1] == "time_lockout")
                {
                    this.openErrorPrompt("You saved a level too recently. Please wait a moment and try again.","ok");
                }
                else if(_loc5_[1] == "bad_param")
                {
                    this.openErrorPrompt("A bad parameter was passed (you really shouldn\'t ever be seeing this).","ok");
                }
                else if(_loc5_[1] == "app_error")
                {
                    this.openErrorPrompt("Sorry, there was an application error. It was most likely database related. Please try again in a moment.","ok");
                }
                else if(_loc5_[1] == "not_logged_in")
                {
                    this.openErrorPrompt("You were logged out somehow. You can try opening a new window and logging in, then attempt to save again.","alright");
                }
                else
                {
                    this.openErrorPrompt("An unknown Error has occurred.","oh");
                }
            }
            else if(_loc5_[0] == "success")
            {
                Tracker.trackEvent(Tracker.EDITOR,Tracker.SAVE_LEVEL,"authorID_" + Settings.user_id);
                this._lastSavedData.id = int(_loc5_[1]);
                this._lastSavedData.data = this.levelXML;
                dispatchEvent(new Event(SAVE_COMPLETE));
            }
            else
            {
                this.openErrorPrompt("Error: something dreadful has happened","ok");
            }
        }
        
        public function saveOverLevel(param1:int, param2:String, param3:String) : void
        {
            if(this.canvas.tooManyShapes)
            {
                this.openErrorPrompt("I SAID TOO MANY GODDAMN SHAPES... DELETE SOME","alright");
                return;
            }
            if(this.canvas.tooMuchArt)
            {
                this.openErrorPrompt("I SAID TOO MANY GODDAMN ART SHAPES... DELETE SOME","alright");
                return;
            }
            this.statusSprite = new StatusSprite("Saving Over Level...<br><br>(just in case this fails, levels are now autosaved locally)");
            var _loc4_:Window = this.statusSprite.window;
            this.canvas.parent.parent.addChild(_loc4_);
            _loc4_.center();
            this._lastSavedData = new LevelDataObject(param1,param2,null,null,null,null,null,null,param3,null,null,null,null,null);
            var _loc5_:URLRequest = new URLRequest(Settings.siteURL + "set_level.hw");
            _loc5_.method = URLRequestMethod.POST;
            var _loc6_:URLVariables = new URLVariables();
            _loc6_.action = "update";
            _loc6_.level_id = param1;
            _loc6_.level_name = param2;
            _loc6_.user_comment = param3;
            _loc6_.playable_character = this.canvas.startPlaceHolder.forceChar ? this.canvas.startPlaceHolder.characterIndex : 0;
            this.levelXML = this.levelXML = Settings.sharedObject.data["editorLevelData"] = this.createXML();
            var _loc7_:String = this.levelXML.toXMLString();
            var _loc8_:ByteArray = new ByteArray();
            _loc8_.writeUTFBytes(_loc7_);
            _loc8_.compress();
            LevelEncryptor.encryptByteArray(_loc8_,"eatshit" + Settings.user_id);
            _loc6_.level_record = Base64.encodeByteArray(_loc8_);
            _loc5_.data = _loc6_;
            var _loc9_:URLLoader = new URLLoader();
            _loc9_.addEventListener(Event.COMPLETE,this.levelOverWritten);
            _loc9_.addEventListener(IOErrorEvent.IO_ERROR,this.IOErrorHandler);
            _loc9_.load(_loc5_);
        }
        
        private function levelOverWritten(param1:Event) : void
        {
            trace("level overwritten");
            this.statusSprite.die();
            var _loc2_:URLLoader = param1.target as URLLoader;
            _loc2_.removeEventListener(Event.COMPLETE,this.levelOverWritten);
            _loc2_.removeEventListener(IOErrorEvent.IO_ERROR,this.IOErrorHandler);
            var _loc3_:String = String(_loc2_.data);
            var _loc4_:String = _loc3_.substr(0,8);
            var _loc5_:Array = _loc3_.split(":");
            trace("dataString " + _loc4_);
            if(_loc4_.indexOf("<html>") > -1)
            {
                this.openErrorPrompt("There was an unexpected system Error","oh");
            }
            else if(_loc5_[0] == "failure")
            {
                if(_loc5_[1] == "invalid_action")
                {
                    this.openErrorPrompt("An invalid action was passed (you really shouldn\'t ever be seeing this).","ok");
                }
                else if(_loc5_[1] == "time_lockout")
                {
                    this.openErrorPrompt("You updated a level too recently. Please wait a moment and try again.","ok");
                }
                else if(_loc5_[1] == "bad_param")
                {
                    this.openErrorPrompt("A bad parameter was passed (you really shouldn\'t ever be seeing this).","ok");
                }
                else if(_loc5_[1] == "app_error")
                {
                    this.openErrorPrompt("Sorry, there was an application error. It was most likely database related. Please try again in a moment.","ok");
                }
                else if(_loc5_[1] == "not_logged_in")
                {
                    this.openErrorPrompt("You were logged out somehow. You can try opening a new window and logging in, then attempt to save again.","alright");
                }
                else
                {
                    this.openErrorPrompt("An unknown Error has occurred.","oh");
                }
            }
            else if(_loc5_[0] == "success")
            {
                Tracker.trackEvent(Tracker.EDITOR,Tracker.OVERWRITE_LEVEL,"authorID_" + Settings.user_id);
                this._lastSavedData.data = this.levelXML;
                dispatchEvent(new Event(SAVE_COMPLETE));
            }
            else
            {
                this.openErrorPrompt("Error: something dreadful has happened","ok");
            }
        }
        
        public function get lastSavedData() : LevelDataObject
        {
            return this._lastSavedData;
        }
        
        public function publishLevel(param1:int) : void
        {
            this.statusSprite = new StatusSprite("Publishing Level...");
            var _loc2_:Window = this.statusSprite.window;
            this.canvas.parent.parent.addChild(_loc2_);
            _loc2_.center();
            var _loc3_:URLRequest = new URLRequest(Settings.siteURL + "set_level.hw");
            _loc3_.method = URLRequestMethod.POST;
            var _loc4_:URLVariables = new URLVariables();
            _loc4_.action = "publish";
            _loc4_.level_id = param1;
            _loc3_.data = _loc4_;
            var _loc5_:URLLoader = new URLLoader();
            _loc5_.addEventListener(Event.COMPLETE,this.levelPublished);
            _loc5_.addEventListener(IOErrorEvent.IO_ERROR,this.IOErrorHandler);
            _loc5_.load(_loc3_);
        }
        
        public function levelPublished(param1:Event) : void
        {
            trace("level published");
            this.statusSprite.die();
            var _loc2_:URLLoader = param1.target as URLLoader;
            _loc2_.removeEventListener(Event.COMPLETE,this.levelPublished);
            _loc2_.removeEventListener(IOErrorEvent.IO_ERROR,this.IOErrorHandler);
            var _loc3_:String = String(_loc2_.data);
            var _loc4_:String = _loc3_.substr(0,8);
            var _loc5_:Array = _loc3_.split(":");
            trace("dataString " + _loc4_);
            if(_loc4_.indexOf("<html>") > -1)
            {
                this.openErrorPrompt("There was an unexpected system Error","oh");
            }
            else if(_loc5_[0] == "failure")
            {
                if(_loc5_[1] == "invalid_action")
                {
                    this.openErrorPrompt("An invalid action was passed (you really shouldn\'t ever be seeing this).","ok");
                }
                else if(_loc5_[1] == "time_lockout")
                {
                    this.openErrorPrompt("You may only publish one level per day.","ok");
                }
                else if(_loc5_[1] == "bad_param")
                {
                    this.openErrorPrompt("A bad parameter was passed (you really shouldn\'t ever be seeing this).","ok");
                }
                else if(_loc5_[1] == "app_error")
                {
                    this.openErrorPrompt("Sorry, there was an application error. It was most likely database related. Please try again in a moment.","ok");
                }
                else if(_loc5_[1] == "not_logged_in")
                {
                    this.openErrorPrompt("You were logged out somehow. You can try opening a new window and logging in, then attempt to save and publish again.","alright");
                }
                else
                {
                    this.openErrorPrompt("An unknown Error has occurred.","oh");
                }
            }
            else if(_loc5_[0] == "success")
            {
                Tracker.trackEvent(Tracker.EDITOR,Tracker.PUBLISH_LEVEL,"authorID_" + Settings.user_id);
                this._lastSavedData.isPublic = true;
                dispatchEvent(new Event(PUBLISH_COMPLETE));
            }
            else
            {
                this.openErrorPrompt("Error: something dreadful has happened","ok");
            }
        }
        
        private function openErrorPrompt(param1:String, param2:String) : void
        {
            this.promptSprite = new PromptSprite(param1,param2);
            var _loc3_:Window = this.promptSprite.window;
            this.canvas.parent.parent.addChild(_loc3_);
            _loc3_.center();
            this.promptSprite.addEventListener(PromptSprite.BUTTON_PRESSED,this.closePrompt);
        }
        
        private function closePrompt(param1:Event) : void
        {
            this.promptSprite.removeEventListener(PromptSprite.BUTTON_PRESSED,this.closePrompt);
            this.promptSprite = null;
            dispatchEvent(new Event(GENERIC_ERROR));
        }
        
        public function loadLevel(param1:int, param2:int = -1) : void
        {
            this.statusSprite = new StatusSprite("Loading Level...");
            var _loc3_:Window = this.statusSprite.window;
            this.canvas.parent.parent.addChild(_loc3_);
            _loc3_.center();
            var _loc4_:URLRequest = new URLRequest(Settings.siteURL + "get_level.hw");
            _loc4_.method = URLRequestMethod.POST;
            var _loc5_:URLVariables = new URLVariables();
            _loc5_.level_id = param1;
            _loc5_.action = "get_record";
            _loc5_.ip_tracking = TextUtils.randomNumString(4,8,false);
            _loc4_.data = _loc5_;
            this.importAuthorId = param2;
            var _loc6_:URLLoader = new URLLoader();
            _loc6_.dataFormat = URLLoaderDataFormat.BINARY;
            _loc6_.addEventListener(IOErrorEvent.IO_ERROR,this.IOErrorHandler);
            _loc6_.addEventListener(Event.COMPLETE,this.levelLoaded);
            _loc6_.load(_loc4_);
        }
        
        private function levelLoaded(param1:Event) : void
        {
            var _loc8_:Array = null;
            trace("level loaded");
            this.statusSprite.die();
            var _loc2_:URLLoader = param1.target as URLLoader;
            _loc2_.removeEventListener(Event.COMPLETE,this.levelLoaded);
            _loc2_.removeEventListener(IOErrorEvent.IO_ERROR,this.IOErrorHandler);
            var _loc3_:String = String(_loc2_.data);
            var _loc4_:String = _loc3_.substr(0,8);
            trace("dataString " + _loc4_);
            if(_loc4_.indexOf("<html>") > -1)
            {
                this.openErrorPrompt("There was an unexpected system Error","oh");
                return;
            }
            if(_loc4_.indexOf("failure") > -1)
            {
                _loc8_ = _loc3_.split(":");
                if(_loc8_[1] == "invalid_action")
                {
                    this.openErrorPrompt("An invalid action was passed (you really shouldn\'t ever be seeing this).","ok");
                }
                else if(_loc8_[1] == "bad_param")
                {
                    this.openErrorPrompt("A bad parameter was passed (you really shouldn\'t ever be seeing this).","ok");
                }
                else if(_loc8_[1] == "app_error")
                {
                    this.openErrorPrompt("Sorry, there was an application error. It was most likely database related. Please try again in a moment.","ok");
                }
                else
                {
                    this.openErrorPrompt("An unknown Error has occurred.","oh");
                }
                return;
            }
            Tracker.trackEvent(Tracker.EDITOR,Tracker.LOAD_LEVEL,"authorID_" + Settings.user_id);
            var _loc5_:ByteArray = _loc2_.data;
            var _loc6_:int = this.importAuthorId > -1 ? this.importAuthorId : Settings.user_id;
            LevelEncryptor.decryptByteArray(_loc5_,"eatshit" + _loc6_);
            _loc5_.uncompress();
            var _loc7_:* = _loc5_.readUTFBytes(_loc5_.length);
            this.levelXML = new XML(_loc7_);
            this.buildLevel();
            dispatchEvent(new Event(LOAD_COMPLETE));
        }
        
        public function deleteLevel(param1:int, param2:Boolean) : void
        {
            this.statusSprite = new StatusSprite("Deleting Level...");
            var _loc3_:Window = this.statusSprite.window;
            this.canvas.parent.parent.addChild(_loc3_);
            _loc3_.center();
            var _loc4_:URLRequest = new URLRequest(Settings.siteURL + "set_level.hw");
            _loc4_.method = URLRequestMethod.POST;
            var _loc5_:URLVariables = new URLVariables();
            _loc5_.action = param2 ? "del_level" : "del_priv_level";
            _loc5_.level_id = param1;
            _loc4_.data = _loc5_;
            var _loc6_:URLLoader = new URLLoader();
            _loc6_.addEventListener(Event.COMPLETE,this.levelDeleted);
            _loc6_.addEventListener(IOErrorEvent.IO_ERROR,this.IOErrorHandler);
            _loc6_.load(_loc4_);
        }
        
        public function levelDeleted(param1:Event) : void
        {
            trace("level deleted");
            this.statusSprite.die();
            var _loc2_:URLLoader = param1.target as URLLoader;
            _loc2_.removeEventListener(Event.COMPLETE,this.levelDeleted);
            _loc2_.removeEventListener(IOErrorEvent.IO_ERROR,this.IOErrorHandler);
            var _loc3_:String = String(_loc2_.data);
            var _loc4_:String = _loc3_.substr(0,8);
            var _loc5_:Array = _loc3_.split(":");
            trace("dataString " + _loc4_);
            if(_loc4_.indexOf("<html>") > -1)
            {
                this.openErrorPrompt("There was an unexpected system Error","oh");
                return;
            }
            if(_loc5_[0] == "failure")
            {
                if(_loc5_[1] == "invalid_action")
                {
                    this.openErrorPrompt("An invalid action was passed (you really shouldn\'t ever be seeing this).","ok");
                }
                else if(_loc5_[1] == "bad_param")
                {
                    this.openErrorPrompt("A bad parameter was passed (you really shouldn\'t ever be seeing this).","ok");
                }
                else if(_loc5_[1] == "app_error")
                {
                    this.openErrorPrompt("Sorry, there was an application error. It was most likely database related. Please try again in a moment.","ok");
                }
                else if(_loc5_[1] == "not_logged_in")
                {
                    this.openErrorPrompt("You were logged out somehow. You can try opening a new window and logging in, then attempt to delete again.","ok");
                }
                else
                {
                    this.openErrorPrompt("An unknown Error has occurred.","oh");
                }
            }
            else if(_loc5_[0] == "success")
            {
                Tracker.trackEvent(Tracker.EDITOR,Tracker.DELETE_LEVEL,"authorID_" + Settings.user_id);
                dispatchEvent(new Event(DELETE_COMPLETE));
            }
            else
            {
                this.openErrorPrompt("Error: something dreadful has happened","ok");
            }
        }
        
        private function IOErrorHandler(param1:IOErrorEvent) : void
        {
            trace("io error");
            this.statusSprite.die();
            var _loc2_:URLLoader = param1.target as URLLoader;
            _loc2_.removeEventListener(Event.COMPLETE,this.levelLoaded);
            _loc2_.removeEventListener(Event.COMPLETE,this.levelOverWritten);
            _loc2_.removeEventListener(Event.COMPLETE,this.levelSaved);
            _loc2_.removeEventListener(Event.COMPLETE,this.levelPublished);
            _loc2_.removeEventListener(Event.COMPLETE,this.levelDeleted);
            _loc2_.removeEventListener(IOErrorEvent.IO_ERROR,this.IOErrorHandler);
            this.openErrorPrompt("Sorry, there was an IO error.  Maybe try again or something?","alright");
        }
        
        public function importLevelData(param1:XML) : void
        {
            Tracker.trackEvent(Tracker.EDITOR,Tracker.IMPORT_LEVELDATA,"authorID_" + Settings.user_id);
            this.levelXML = param1;
            this.buildLevel();
        }
        
        public function checkStolen(param1:XML) : Boolean
        {
            var _loc2_:XMLList = param1.info;
            if(Number(_loc2_.@e) > 0)
            {
                return false;
            }
            return true;
        }
        
        public function createXML(param1:* = false) : XML
        {
            var _loc3_:* = null;
            var _loc9_:XML = null;
            var _loc10_:int = 0;
            var _loc11_:RefShape = null;
            var _loc12_:XML = null;
            var _loc13_:Special = null;
            var _loc14_:XML = null;
            var _loc15_:RefGroup = null;
            var _loc16_:Point = null;
            var _loc17_:String = null;
            var _loc18_:String = null;
            var _loc19_:String = null;
            var _loc20_:String = null;
            var _loc21_:* = null;
            var _loc22_:XML = null;
            var _loc23_:Sprite = null;
            var _loc24_:int = 0;
            var _loc25_:RefVehicle = null;
            var _loc26_:String = null;
            var _loc27_:XML = null;
            var _loc28_:RefJoint = null;
            var _loc29_:int = 0;
            var _loc30_:RefSprite = null;
            var _loc31_:String = null;
            var _loc32_:PrisJoint = null;
            var _loc33_:String = null;
            var _loc34_:PinJoint = null;
            var _loc35_:XML = null;
            var _loc36_:RefTrigger = null;
            var _loc37_:Boolean = false;
            var _loc38_:Boolean = false;
            var _loc39_:String = null;
            var _loc40_:Array = null;
            var _loc41_:int = 0;
            var _loc42_:RefSprite = null;
            var _loc43_:* = null;
            var _loc44_:XML = null;
            var _loc45_:Array = null;
            var _loc46_:Array = null;
            var _loc47_:Array = null;
            var _loc48_:int = 0;
            var _loc49_:* = null;
            var _loc50_:String = null;
            var _loc51_:int = 0;
            var _loc52_:XML = null;
            var _loc53_:Array = null;
            var _loc54_:int = 0;
            var _loc55_:String = null;
            var _loc56_:Dictionary = null;
            var _loc57_:String = null;
            var _loc2_:XML = <levelXML></levelXML>;
            var _loc4_:StartPlaceHolder = this.canvas.startPlaceHolder;
            var _loc5_:String = _loc4_.forceChar ? "t" : "f";
            var _loc6_:String = !!param1 ? " e=\'1\'" : "";
            var _loc7_:String = _loc4_.hideVehicle ? "t" : "f";
            _loc3_ = "<info v=\'" + Settings.CURRENT_VERSION + "\' x=\'" + _loc4_.x + "\' y=\'" + _loc4_.y + "\' c=\'" + _loc4_.characterIndex + "\' f=\'" + _loc5_ + "\' h=\'" + _loc7_ + "\' bg=\'" + Canvas.backDropIndex + "\' bgc=\'" + Canvas.backgroundColor + "\'" + _loc6_ + "/>";
            var _loc8_:XML = new XML(_loc3_);
            _loc2_.appendChild(_loc8_);
            this.pVertIDs = new Array();
            this.eVertIDs = new Array();
            if(this.canvas.shapes.numChildren > 0)
            {
                _loc9_ = <shapes></shapes>;
                _loc10_ = 0;
                while(_loc10_ < this.canvas.shapes.numChildren)
                {
                    _loc11_ = this.canvas.shapes.getChildAt(_loc10_) as RefShape;
                    _loc9_.appendChild(this.createShapeNode(_loc11_));
                    _loc10_++;
                }
                _loc2_.appendChild(_loc9_);
            }
            if(this.canvas.special.numChildren > 0)
            {
                _loc12_ = <specials></specials>;
                _loc10_ = 0;
                while(_loc10_ < this.canvas.special.numChildren)
                {
                    _loc13_ = this.canvas.special.getChildAt(_loc10_) as Special;
                    _loc12_.appendChild(this.createSpecialNode(_loc13_));
                    _loc10_++;
                }
                _loc2_.appendChild(_loc12_);
            }
            if(this.canvas.groups.numChildren > 0)
            {
                _loc14_ = <groups></groups>;
                _loc10_ = 0;
                while(_loc10_ < this.canvas.groups.numChildren)
                {
                    _loc15_ = this.canvas.groups.getChildAt(_loc10_) as RefGroup;
                    _loc16_ = _loc15_.offset;
                    _loc17_ = _loc15_.sleeping ? "t" : "f";
                    _loc18_ = _loc15_.foreground ? "t" : "f";
                    _loc19_ = _loc15_.immovable ? "t" : "f";
                    _loc20_ = _loc15_.fixedRotation ? "t" : "f";
                    _loc21_ = "<g x=\'" + _loc15_.x + "\' y=\'" + _loc15_.y + "\' r=\'" + _loc15_.angle + "\' ox=\'" + _loc16_.x + "\' oy=\'" + _loc16_.y + "\' s=\'" + _loc17_ + "\' f=\'" + _loc18_ + "\' o=\'" + _loc15_.opacity + "\' im=\'" + _loc19_ + "\' fr=\'" + _loc20_;
                    if(_loc15_ is RefVehicle)
                    {
                        _loc25_ = _loc15_ as RefVehicle;
                        _loc26_ = _loc25_.lockJoints ? "t" : "f";
                        _loc21_ += "\' v=\'t\' sb=\'" + _loc25_.spaceAction + "\' sh=\'" + _loc25_.shiftAction + "\' ct=\'" + _loc25_.ctrlAction + "\' a=\'" + _loc25_.acceleration + "\' l=\'" + _loc25_.leaningStrength + "\' cp=\'" + _loc25_.characterPose + "\' lo=\'" + _loc26_ + "\'></g>";
                    }
                    else
                    {
                        _loc21_ += "\'></g>";
                    }
                    _loc22_ = new XML(_loc21_);
                    _loc14_.appendChild(_loc22_);
                    _loc23_ = _loc15_.shapeContainer;
                    _loc24_ = 0;
                    while(_loc24_ < _loc23_.numChildren)
                    {
                        _loc11_ = _loc23_.getChildAt(_loc24_) as RefShape;
                        _loc22_.appendChild(this.createShapeNode(_loc11_));
                        _loc24_++;
                    }
                    _loc23_ = _loc15_.specialContainer;
                    _loc24_ = 0;
                    while(_loc24_ < _loc23_.numChildren)
                    {
                        _loc13_ = _loc23_.getChildAt(_loc24_) as Special;
                        _loc22_.appendChild(this.createSpecialNode(_loc13_));
                        _loc24_++;
                    }
                    _loc10_++;
                }
                _loc2_.appendChild(_loc14_);
            }
            if(this.canvas.joints.numChildren > 0)
            {
                _loc27_ = <joints></joints>;
                _loc10_ = 0;
                while(_loc10_ < this.canvas.joints.numChildren)
                {
                    _loc28_ = this.canvas.joints.getChildAt(_loc10_) as RefJoint;
                    _loc29_ = _loc28_ is PrisJoint ? 1 : 0;
                    _loc3_ = "<j t=\'" + _loc29_ + "\' x=\'" + _loc28_.x + "\' y=\'" + _loc28_.y;
                    if(_loc28_.body1)
                    {
                        _loc30_ = _loc28_.body1 as RefSprite;
                        if(_loc30_ is Special)
                        {
                            _loc31_ = "s";
                        }
                        else if(_loc30_ is RefGroup)
                        {
                            _loc31_ = "g";
                        }
                        else
                        {
                            _loc31_ = "";
                        }
                        _loc3_ += "\' b1=\'" + _loc31_ + _loc30_.parent.getChildIndex(_loc30_);
                    }
                    else
                    {
                        _loc3_ += "\' b1=\'-1";
                    }
                    if(_loc28_.body2)
                    {
                        _loc30_ = _loc28_.body2 as RefSprite;
                        if(_loc30_ is Special)
                        {
                            _loc31_ = "s";
                        }
                        else if(_loc30_ is RefGroup)
                        {
                            _loc31_ = "g";
                        }
                        else
                        {
                            _loc31_ = "";
                        }
                        _loc3_ += "\' b2=\'" + _loc31_ + _loc30_.parent.getChildIndex(_loc30_);
                    }
                    else
                    {
                        _loc3_ += "\' b2=\'-1";
                    }
                    if(_loc28_ is PrisJoint)
                    {
                        _loc32_ = _loc28_ as PrisJoint;
                        _loc3_ += "\' a=\'" + _loc32_.axisAngle;
                        _loc33_ = _loc32_.limit ? "t" : "f";
                        _loc3_ += "\' l=\'" + _loc33_;
                        _loc3_ += "\' ul =\'" + _loc32_.upperLimit;
                        _loc3_ += "\' ll =\'" + _loc32_.lowerLimit;
                        _loc33_ = _loc32_.motor ? "t" : "f";
                        _loc3_ += "\' m=\'" + _loc33_;
                        _loc3_ += "\' fo=\'" + _loc32_.force;
                        _loc3_ += "\' sp=\'" + _loc32_.speed;
                    }
                    else
                    {
                        _loc34_ = _loc28_ as PinJoint;
                        _loc33_ = _loc34_.limit ? "t" : "f";
                        _loc3_ += "\' l=\'" + _loc33_;
                        _loc3_ += "\' ua =\'" + _loc34_.upperAngle;
                        _loc3_ += "\' la =\'" + _loc34_.lowerAngle;
                        _loc33_ = _loc34_.motor ? "t" : "f";
                        _loc3_ += "\' m=\'" + _loc33_;
                        _loc3_ += "\' tq=\'" + _loc34_.torque;
                        _loc3_ += "\' sp=\'" + _loc34_.speed;
                    }
                    _loc33_ = _loc28_.collideSelf ? "t" : "f";
                    _loc3_ += "\' c=\'" + _loc33_;
                    if(_loc28_.vehicleAttached)
                    {
                        _loc33_ = _loc28_.vehicleControlled ? "t" : "f";
                        _loc3_ += "\' v=\'" + _loc33_;
                    }
                    _loc3_ += "\'/>";
                    _loc8_ = new XML(_loc3_);
                    _loc27_.appendChild(_loc8_);
                    _loc10_++;
                }
                _loc2_.appendChild(_loc27_);
            }
            if(this.canvas.triggers.numChildren > 0)
            {
                _loc35_ = <triggers></triggers>;
                _loc10_ = 0;
                while(_loc10_ < this.canvas.triggers.numChildren)
                {
                    _loc36_ = this.canvas.triggers.getChildAt(_loc10_) as RefTrigger;
                    _loc37_ = _loc36_.typeIndex == 1 || _loc36_.triggeredBy == 4 ? true : false;
                    _loc38_ = _loc36_.typeIndex == 1 ? true : false;
                    _loc39_ = _loc36_.startDisabled ? "t" : "f";
                    _loc3_ = "<t x=\'" + _loc36_.x + "\' y=\'" + _loc36_.y + "\' w=\'" + _loc36_.shapeWidth + "\' h=\'" + _loc36_.shapeHeight + "\' a=\'" + _loc36_.angle + "\' b=\'" + _loc36_.triggeredBy + "\' t=\'" + _loc36_.typeIndex + "\' r=\'" + _loc36_.repeatType + "\' sd=\'" + _loc39_;
                    if(_loc36_.repeatType > 2)
                    {
                        _loc3_ += "\' i=\'" + _loc36_.repeatInterval;
                    }
                    if(_loc36_.typeIndex == 1)
                    {
                        _loc3_ += "\' d=\'" + _loc36_.triggerDelay + "\'/>";
                    }
                    else if(_loc36_.typeIndex == 2)
                    {
                        _loc3_ += "\' s=\'" + SoundList.instance.sfxLookup.indexOf(_loc36_.soundEffect) + "\' d=\'" + _loc36_.triggerDelay + "\' l=\'" + _loc36_.soundLocation + "\' p=\'" + _loc36_.panning + "\' v=\'" + _loc36_.volume + "\'/>";
                    }
                    else
                    {
                        _loc3_ += "\'/>";
                    }
                    _loc8_ = new XML(_loc3_);
                    if(_loc37_)
                    {
                        _loc40_ = _loc36_.targets;
                        _loc41_ = int(_loc40_.length);
                        _loc24_ = 0;
                        while(_loc24_ < _loc41_)
                        {
                            _loc42_ = _loc40_[_loc24_];
                            if(_loc42_ is RefShape)
                            {
                                _loc31_ = "sh";
                            }
                            else if(_loc42_ is Special)
                            {
                                _loc31_ = "sp";
                            }
                            else if(_loc42_ is RefGroup)
                            {
                                _loc31_ = "g";
                            }
                            else if(_loc42_ is RefJoint)
                            {
                                _loc31_ = "j";
                            }
                            else
                            {
                                if(!(_loc42_ is RefTrigger))
                                {
                                    throw new Error("what the fuck is this?");
                                }
                                _loc31_ = "t";
                            }
                            _loc43_ = "<" + _loc31_ + " i=\'" + _loc42_.parent.getChildIndex(_loc42_) + "\'>";
                            _loc43_ = _loc43_ + ("</" + _loc31_ + ">");
                            _loc44_ = new XML(_loc43_);
                            if(_loc38_)
                            {
                                _loc45_ = _loc42_.triggerActionList;
                                if(_loc45_)
                                {
                                    _loc46_ = _loc42_.triggerActionListProperties;
                                    _loc47_ = _loc42_.triggerActions[_loc36_];
                                    _loc48_ = 0;
                                    while(_loc48_ < _loc47_.length)
                                    {
                                        _loc49_ = "<a";
                                        _loc50_ = _loc47_[_loc48_];
                                        _loc51_ = !!_loc50_ ? int(_loc45_.indexOf(_loc50_)) : 0;
                                        _loc49_ += " i=\'" + _loc51_ + "\'";
                                        if(_loc46_[_loc51_])
                                        {
                                            _loc53_ = _loc46_[_loc51_];
                                            _loc54_ = 0;
                                            while(_loc54_ < _loc53_.length)
                                            {
                                                _loc55_ = _loc53_[_loc54_];
                                                _loc56_ = _loc42_.keyedPropertyObject[_loc55_];
                                                _loc57_ = _loc56_[_loc36_][_loc48_];
                                                _loc49_ += " p" + _loc54_ + "=\'" + _loc57_ + "\'";
                                                _loc54_++;
                                            }
                                        }
                                        _loc49_ += "/>";
                                        _loc52_ = new XML(_loc49_);
                                        _loc44_.appendChild(_loc52_);
                                        _loc48_++;
                                    }
                                }
                            }
                            _loc8_.appendChild(_loc44_);
                            _loc24_++;
                        }
                    }
                    _loc35_.appendChild(_loc8_);
                    _loc10_++;
                }
                _loc2_.appendChild(_loc35_);
            }
            return _loc2_;
        }
        
        private function createShapeNode(param1:RefShape) : XML
        {
            var _loc9_:String = null;
            var _loc10_:* = undefined;
            var _loc11_:PolygonShape = null;
            var _loc12_:String = null;
            var _loc13_:int = 0;
            var _loc14_:XML = null;
            var _loc15_:int = 0;
            var _loc16_:b2Vec2 = null;
            var _loc17_:ArtShape = null;
            var _loc18_:b2Vec2 = null;
            var _loc19_:b2Vec2 = null;
            var _loc2_:Array = getQualifiedClassName(param1).split("::");
            var _loc3_:String = _loc2_[_loc2_.length - 1];
            var _loc4_:int = int(Settings.shapeList.indexOf(_loc3_));
            if(_loc4_ < 0)
            {
                throw new Error("shape instance not found in the class list");
            }
            var _loc5_:* = "<sh t=\'" + _loc4_;
            if(param1.interactive == false)
            {
                _loc5_ += "\' i=\'f";
            }
            else if(param1.group is RefVehicle)
            {
                _loc10_ = param1.vehicleHandle == true ? "t" : "f";
                _loc5_ += "\' h=\'" + _loc10_;
            }
            var _loc6_:Array = param1.getFullProperties();
            var _loc7_:int = 0;
            while(_loc7_ < _loc6_.length)
            {
                _loc9_ = _loc6_[_loc7_];
                _loc10_ = param1[_loc9_];
                if(_loc10_ is Boolean)
                {
                    _loc10_ = _loc10_ == true ? "t" : "f";
                }
                _loc5_ += "\' p" + _loc7_ + "=\'" + _loc10_;
                _loc7_++;
            }
            _loc5_ += "\'/>";
            var _loc8_:XML = XML(_loc5_);
            if(_loc4_ == 3)
            {
                _loc11_ = param1 as PolygonShape;
                _loc12_ = _loc11_.completeFill == true ? "t" : "f";
                _loc13_ = _loc11_.vID;
                _loc5_ = "<v f=\'" + _loc12_ + "\' id=\'" + _loc13_;
                if(this.pVertIDs.indexOf(_loc13_) > -1)
                {
                    _loc5_ += "\'/>";
                }
                else
                {
                    this.pVertIDs.push(_loc13_);
                    _loc15_ = _loc11_.numVerts;
                    _loc5_ += "\' n=\'" + _loc15_;
                    _loc7_ = 0;
                    while(_loc7_ < _loc15_)
                    {
                        _loc16_ = _loc11_.vertVector[_loc7_];
                        _loc5_ += "\' v" + _loc7_ + "=\'" + _loc16_.x + "_" + _loc16_.y;
                        _loc7_++;
                    }
                    _loc5_ += "\'/>";
                }
                _loc14_ = XML(_loc5_);
                _loc8_.appendChild(_loc14_);
            }
            else if(_loc4_ == 4)
            {
                _loc17_ = param1 as ArtShape;
                _loc12_ = _loc17_.completeFill == true ? "t" : "f";
                _loc13_ = _loc17_.vID;
                _loc5_ = "<v f=\'" + _loc12_ + "\' id=\'" + _loc13_;
                if(this.eVertIDs.indexOf(_loc13_) > -1)
                {
                    _loc5_ += "\'/>";
                }
                else
                {
                    this.eVertIDs.push(_loc13_);
                    _loc15_ = _loc17_.numVerts;
                    _loc5_ += "\' n=\'" + _loc15_;
                    _loc7_ = 0;
                    while(_loc7_ < _loc15_)
                    {
                        _loc16_ = _loc17_.vertVector[_loc7_];
                        _loc18_ = _loc17_.handleVector[_loc7_ * 2];
                        _loc19_ = _loc17_.handleVector[_loc7_ * 2 + 1];
                        _loc5_ += "\' v" + _loc7_ + "=\'" + _loc16_.x + "_" + _loc16_.y;
                        if(!(_loc18_.x == 0 && _loc18_.y == 0 && _loc19_.x == 0 && _loc19_.y == 0))
                        {
                            _loc5_ += "_" + _loc18_.x + "_" + _loc18_.y + "_" + _loc19_.x + "_" + _loc19_.y;
                        }
                        _loc7_++;
                    }
                    _loc5_ += "\'/>";
                }
                _loc14_ = XML(_loc5_);
                _loc8_.appendChild(_loc14_);
            }
            return _loc8_;
        }
        
        private function createSpecialNode(param1:Special) : XML
        {
            var _loc11_:String = null;
            var _loc12_:* = undefined;
            var _loc13_:XML = null;
            var _loc2_:Array = getQualifiedClassName(param1).split("::");
            var _loc3_:String = _loc2_[_loc2_.length - 1];
            var _loc4_:int = int(Settings.specialList.indexOf(_loc3_));
            if(_loc4_ < 0)
            {
                throw new Error("special instance not found in the class list");
            }
            var _loc5_:* = "<sp t=\'" + _loc4_;
            var _loc6_:Array = new Array();
            var _loc7_:Array = param1.getFullProperties();
            var _loc8_:int = 0;
            while(_loc8_ < _loc7_.length)
            {
                if(!(_loc7_[_loc8_] is Array))
                {
                    _loc11_ = _loc7_[_loc8_];
                    _loc12_ = param1[_loc11_];
                    if(_loc12_ is String)
                    {
                        _loc6_.push(this.createCDataNode("p" + _loc8_,_loc12_ as String));
                    }
                    else
                    {
                        if(_loc12_ is Boolean)
                        {
                            _loc12_ = _loc12_ == true ? "t" : "f";
                        }
                        _loc5_ += "\' p" + _loc8_ + "=\'" + _loc12_;
                    }
                }
                _loc8_++;
            }
            _loc5_ += "\'/>";
            var _loc9_:XML = XML(_loc5_);
            var _loc10_:int = 0;
            while(_loc10_ < _loc6_.length)
            {
                _loc13_ = _loc6_[_loc10_];
                _loc9_.appendChild(_loc13_);
                _loc10_++;
            }
            return _loc9_;
        }
        
        private function createCDataNode(param1:String, param2:String) : XML
        {
            var _loc3_:* = "<" + param1 + "><![CDATA[" + param2 + "]]></" + param1 + ">";
            return XML(_loc3_);
        }
        
        private function buildLevel() : void
        {
            var _loc9_:XML = null;
            var _loc10_:Class = null;
            var _loc11_:String = null;
            var _loc12_:int = 0;
            var _loc13_:String = null;
            var _loc14_:Array = null;
            var _loc15_:XMLList = null;
            var _loc16_:String = null;
            var _loc17_:int = 0;
            var _loc18_:int = 0;
            var _loc19_:RefSprite = null;
            var _loc25_:int = 0;
            var _loc26_:XML = null;
            var _loc27_:int = 0;
            var _loc28_:String = null;
            var _loc29_:int = 0;
            var _loc30_:PolygonShape = null;
            var _loc31_:Array = null;
            var _loc32_:int = 0;
            var _loc33_:String = null;
            var _loc34_:Array = null;
            var _loc35_:b2Vec2 = null;
            var _loc36_:ArtShape = null;
            var _loc37_:b2Vec2 = null;
            var _loc38_:b2Vec2 = null;
            var _loc39_:XML = null;
            var _loc40_:RefGroup = null;
            var _loc41_:XMLList = null;
            var _loc42_:XMLList = null;
            var _loc43_:RefVehicle = null;
            var _loc44_:XML = null;
            var _loc45_:int = 0;
            var _loc46_:PinJoint = null;
            var _loc47_:String = null;
            var _loc48_:int = 0;
            var _loc49_:PrisJoint = null;
            var _loc50_:RefTrigger = null;
            var _loc51_:Boolean = false;
            var _loc52_:Boolean = false;
            var _loc53_:XMLList = null;
            var _loc54_:RefSprite = null;
            var _loc55_:XML = null;
            var _loc56_:String = null;
            var _loc57_:Array = null;
            var _loc58_:Array = null;
            var _loc59_:Array = null;
            var _loc60_:int = 0;
            var _loc61_:String = null;
            var _loc62_:Dictionary = null;
            var _loc63_:XMLList = null;
            var _loc64_:Array = null;
            var _loc65_:int = 0;
            var _loc66_:XML = null;
            var _loc67_:Array = null;
            dispatchEvent(new Event(CLEAR_STAGE));
            Settings.sharedObject.data["editorLevelData"] = this.levelXML;
            var _loc1_:XMLList = this.levelXML.children();
            var _loc2_:XMLList = this.levelXML.info;
            var _loc3_:XMLList = this.levelXML.shapes.sh;
            var _loc4_:XMLList = this.levelXML.specials.sp;
            var _loc5_:XMLList = this.levelXML.groups.g;
            var _loc6_:XMLList = this.levelXML.joints.j;
            var _loc7_:XMLList = this.levelXML.triggers.t;
            var _loc8_:Number = Number(_loc2_.@v);
            if(_loc8_ > Settings.CURRENT_VERSION)
            {
                Settings.debugText.text = "This Level is from a newer version of Happy Wheels.  Clear cache and reload";
                throw new Error("This Level is from a newer version of Happy Wheels.  Clear cache and reload");
            }
            var _loc20_:int = int(_loc3_.length());
            var _loc21_:Array = new Array();
            var _loc22_:Array = new Array();
            var _loc23_:Array = new Array();
            var _loc24_:Array = new Array();
            _loc17_ = 0;
            for(; _loc17_ < _loc20_; _loc17_++)
            {
                _loc9_ = _loc3_[_loc17_];
                _loc12_ = int(_loc9_.@t);
                if(_loc12_ == 3 && _loc9_.@i == "f")
                {
                    _loc12_ = 4;
                }
                _loc11_ = Settings.shapeList[_loc12_];
                _loc10_ = getDefinitionByName(Settings.shapeClassPath + _loc11_) as Class;
                _loc19_ = new _loc10_();
                if(_loc9_.@i == "f")
                {
                    _loc19_["interactive"] = false;
                }
                if(_loc9_.@h == "t")
                {
                    _loc19_["vehicleHandle"] = true;
                }
                if(_loc9_.@h == "f")
                {
                    _loc19_["vehicleHandle"] = false;
                }
                _loc14_ = _loc19_.getFullProperties();
                _loc25_ = int(_loc14_.length);
                if(_loc12_ == 3)
                {
                    _loc26_ = _loc9_.child("v")[0];
                    _loc27_ = int(_loc26_.@id);
                    _loc28_ = _loc26_.@f;
                    _loc29_ = int(_loc22_.indexOf(_loc27_));
                    if(_loc29_ > -1)
                    {
                        _loc31_ = _loc21_[_loc29_];
                    }
                    else
                    {
                        _loc32_ = int(_loc26_.@n);
                        _loc31_ = new Array();
                        _loc45_ = 0;
                        while(_loc45_ < _loc32_)
                        {
                            _loc33_ = _loc26_.attribute("v" + _loc45_);
                            _loc31_.push(_loc33_);
                            _loc45_++;
                        }
                        _loc21_.push(_loc31_);
                        _loc22_.push(_loc27_);
                    }
                    _loc30_ = _loc19_ as PolygonShape;
                    _loc45_ = 0;
                    while(_loc45_ < _loc31_.length)
                    {
                        _loc33_ = _loc31_[_loc45_];
                        _loc34_ = _loc8_ < 1.84 ? _loc33_.split(".") : _loc33_.split("_");
                        _loc35_ = new b2Vec2(Number(_loc34_[0]),Number(_loc34_[1]));
                        _loc30_.vertVector.push(_loc35_);
                        _loc45_++;
                    }
                    if(_loc30_.numVerts <= 1)
                    {
                        this.canvas.addRefSprite(this.createDummyShape());
                        continue;
                    }
                    _loc19_["completeFill"] = _loc28_ == "t" ? true : false;
                    _loc19_["vID"] = _loc27_;
                    _loc30_.redraw();
                }
                else if(_loc12_ == 4)
                {
                    _loc26_ = _loc9_.child("v")[0];
                    _loc27_ = int(_loc26_.@id);
                    _loc28_ = _loc26_.@f;
                    _loc29_ = int(_loc24_.indexOf(_loc27_));
                    if(_loc29_ > -1)
                    {
                        _loc31_ = _loc23_[_loc29_];
                    }
                    else
                    {
                        _loc32_ = int(_loc26_.@n);
                        _loc31_ = new Array();
                        _loc45_ = 0;
                        while(_loc45_ < _loc32_)
                        {
                            _loc33_ = _loc26_.attribute("v" + _loc45_);
                            _loc31_.push(_loc33_);
                            _loc45_++;
                        }
                        _loc23_.push(_loc31_);
                        _loc24_.push(_loc27_);
                    }
                    _loc36_ = _loc19_ as ArtShape;
                    _loc45_ = 0;
                    while(_loc45_ < _loc31_.length)
                    {
                        _loc33_ = _loc31_[_loc45_];
                        _loc34_ = _loc8_ < 1.84 ? _loc33_.split(".") : _loc33_.split("_");
                        _loc35_ = new b2Vec2(Number(_loc34_[0]),Number(_loc34_[1]));
                        _loc37_ = !!_loc34_[2] ? new b2Vec2(Number(_loc34_[2]),Number(_loc34_[3])) : new b2Vec2();
                        _loc38_ = !!_loc34_[4] ? new b2Vec2(Number(_loc34_[4]),Number(_loc34_[5])) : new b2Vec2();
                        _loc36_.vertVector.push(_loc35_);
                        _loc36_.handleVector.push(_loc37_);
                        _loc36_.handleVector.push(_loc38_);
                        _loc45_++;
                    }
                    if(_loc36_.numVerts <= 1)
                    {
                        this.canvas.addRefSprite(this.createDummyShape());
                        continue;
                    }
                    _loc19_["completeFill"] = _loc28_ == "t" ? true : false;
                    _loc19_["vID"] = _loc27_;
                    _loc36_.redraw();
                }
                _loc18_ = 0;
                while(_loc18_ < _loc25_)
                {
                    _loc13_ = _loc14_[_loc18_];
                    _loc16_ = _loc9_.attribute("p" + _loc18_);
                    if(_loc16_ == "t" || _loc16_ == "f")
                    {
                        _loc19_[_loc13_] = _loc16_ == "t" ? true : false;
                    }
                    else if(_loc16_ != "")
                    {
                        _loc19_[_loc13_] = _loc16_;
                    }
                    _loc18_++;
                }
                this.canvas.addRefSprite(_loc19_);
                _loc19_.x = _loc9_.@p0;
                _loc19_.y = _loc9_.@p1;
            }
            _loc20_ = int(_loc4_.length());
            _loc17_ = 0;
            while(_loc17_ < _loc20_)
            {
                _loc9_ = _loc4_[_loc17_];
                _loc12_ = int(_loc9_.@t);
                _loc11_ = Settings.specialList[_loc12_];
                _loc10_ = getDefinitionByName(Settings.specialClassPath + _loc11_) as Class;
                _loc19_ = new _loc10_();
                _loc14_ = _loc19_.getFullProperties();
                _loc18_ = 0;
                while(_loc18_ < _loc14_.length)
                {
                    _loc13_ = _loc14_[_loc18_];
                    if(_loc19_[_loc13_] is String)
                    {
                        _loc39_ = _loc9_.child("p" + _loc18_)[0];
                        _loc19_[_loc13_] = _loc39_;
                    }
                    else
                    {
                        _loc16_ = _loc9_.attribute("p" + _loc18_);
                        if(_loc16_ == "t" || _loc16_ == "f")
                        {
                            _loc19_[_loc13_] = _loc16_ == "t" ? true : false;
                        }
                        else if(_loc16_ != "")
                        {
                            _loc19_[_loc13_] = _loc16_;
                        }
                    }
                    _loc18_++;
                }
                this.canvas.addRefSprite(_loc19_);
                _loc19_.x = _loc9_.@p0;
                _loc19_.y = _loc9_.@p1;
                _loc17_++;
            }
            _loc20_ = int(_loc5_.length());
            _loc17_ = 0;
            while(_loc17_ < _loc20_)
            {
                _loc9_ = _loc5_[_loc17_];
                if(_loc9_.@v == "t")
                {
                    _loc40_ = new RefVehicle();
                    _loc43_ = _loc40_ as RefVehicle;
                    _loc43_.spaceAction = int(_loc9_.@sb);
                    _loc43_.shiftAction = int(_loc9_.@sh);
                    _loc43_.ctrlAction = int(_loc9_.@ct);
                    _loc43_.acceleration = int(_loc9_.@a);
                    _loc43_.leaningStrength = int(_loc9_.@l);
                    _loc43_.characterPose = int(_loc9_.@cp);
                    _loc43_.lockJoints = _loc9_.@lo == "t" ? true : false;
                }
                else
                {
                    _loc40_ = new RefGroup();
                }
                _loc40_.offset = new Point(_loc9_.@ox,_loc9_.@oy);
                _loc40_.angle = _loc9_.@r;
                _loc40_.sleeping = _loc9_.@s == "t" ? true : false;
                _loc40_.foreground = _loc9_.@f == "t" ? true : false;
                _loc40_.opacity = String(_loc9_.@o) == "" ? 100 : Number(_loc9_.@o);
                _loc40_.immovable = _loc9_.@im == "t" ? true : false;
                _loc40_.fixedRotation = _loc9_.@fr == "t" ? true : false;
                _loc41_ = _loc9_.sh;
                _loc18_ = 0;
                for(; _loc18_ < _loc41_.length(); _loc18_++)
                {
                    _loc44_ = _loc41_[_loc18_];
                    _loc12_ = int(_loc44_.@t);
                    if(_loc12_ == 3 && _loc44_.@i == "f")
                    {
                        _loc12_ = 4;
                    }
                    _loc11_ = Settings.shapeList[_loc12_];
                    _loc10_ = getDefinitionByName(Settings.shapeClassPath + _loc11_) as Class;
                    _loc19_ = new _loc10_();
                    _loc19_.inGroup = true;
                    _loc19_.group = _loc40_;
                    if(_loc44_.@i == "f")
                    {
                        _loc19_["interactive"] = false;
                    }
                    if(_loc44_.@h == "t")
                    {
                        _loc19_["vehicleHandle"] = true;
                    }
                    if(_loc44_.@h == "f")
                    {
                        _loc19_["vehicleHandle"] = false;
                    }
                    _loc14_ = _loc19_.getFullProperties();
                    _loc25_ = int(_loc14_.length);
                    if(_loc12_ == 3)
                    {
                        _loc26_ = _loc44_.child("v")[0];
                        _loc27_ = int(_loc26_.@id);
                        _loc28_ = _loc26_.@f;
                        _loc29_ = int(_loc22_.indexOf(_loc27_));
                        if(_loc29_ > -1)
                        {
                            _loc31_ = _loc21_[_loc29_];
                        }
                        else
                        {
                            _loc32_ = int(_loc26_.@n);
                            _loc31_ = new Array();
                            _loc45_ = 0;
                            while(_loc45_ < _loc32_)
                            {
                                _loc33_ = _loc26_.attribute("v" + _loc45_);
                                _loc31_.push(_loc33_);
                                _loc45_++;
                            }
                            _loc21_.push(_loc31_);
                            _loc22_.push(_loc27_);
                        }
                        _loc30_ = _loc19_ as PolygonShape;
                        _loc45_ = 0;
                        while(_loc45_ < _loc31_.length)
                        {
                            _loc33_ = _loc31_[_loc45_];
                            _loc34_ = _loc8_ < 1.84 ? _loc33_.split(".") : _loc33_.split("_");
                            _loc35_ = new b2Vec2(Number(_loc34_[0]),Number(_loc34_[1]));
                            _loc30_.vertVector.push(_loc35_);
                            _loc45_++;
                        }
                        if(_loc30_.numVerts <= 1)
                        {
                            _loc40_.addShape(this.createDummyShape());
                            continue;
                        }
                        _loc19_["completeFill"] = _loc28_ == "t" ? true : false;
                        _loc19_["vID"] = _loc27_;
                        _loc30_.redraw();
                    }
                    else if(_loc12_ == 4)
                    {
                        _loc26_ = _loc44_.child("v")[0];
                        _loc27_ = int(_loc26_.@id);
                        _loc28_ = _loc26_.@f;
                        _loc29_ = int(_loc24_.indexOf(_loc27_));
                        if(_loc29_ > -1)
                        {
                            _loc31_ = _loc23_[_loc29_];
                        }
                        else
                        {
                            _loc32_ = int(_loc26_.@n);
                            _loc31_ = new Array();
                            _loc45_ = 0;
                            while(_loc45_ < _loc32_)
                            {
                                _loc33_ = _loc26_.attribute("v" + _loc45_);
                                _loc31_.push(_loc33_);
                                _loc45_++;
                            }
                            _loc23_.push(_loc31_);
                            _loc24_.push(_loc27_);
                        }
                        _loc36_ = _loc19_ as ArtShape;
                        _loc45_ = 0;
                        while(_loc45_ < _loc31_.length)
                        {
                            _loc33_ = _loc31_[_loc45_];
                            _loc34_ = _loc8_ < 1.84 ? _loc33_.split(".") : _loc33_.split("_");
                            _loc35_ = new b2Vec2(Number(_loc34_[0]),Number(_loc34_[1]));
                            _loc37_ = !!_loc34_[2] ? new b2Vec2(Number(_loc34_[2]),Number(_loc34_[3])) : new b2Vec2();
                            _loc38_ = !!_loc34_[4] ? new b2Vec2(Number(_loc34_[4]),Number(_loc34_[5])) : new b2Vec2();
                            _loc36_.vertVector.push(_loc35_);
                            _loc36_.handleVector.push(_loc37_);
                            _loc36_.handleVector.push(_loc38_);
                            _loc45_++;
                        }
                        if(_loc36_.numVerts <= 1)
                        {
                            _loc40_.addShape(this.createDummyShape());
                            continue;
                        }
                        _loc19_["completeFill"] = _loc28_ == "t" ? true : false;
                        _loc19_["vID"] = _loc27_;
                        _loc36_.redraw();
                    }
                    _loc45_ = 0;
                    while(_loc45_ < _loc25_)
                    {
                        _loc13_ = _loc14_[_loc45_];
                        _loc16_ = _loc44_.attribute("p" + _loc45_);
                        if(_loc16_ == "t" || _loc16_ == "f")
                        {
                            _loc19_[_loc13_] = _loc16_ == "t" ? true : false;
                        }
                        else if(_loc16_ != "")
                        {
                            _loc19_[_loc13_] = _loc16_;
                        }
                        _loc45_++;
                    }
                    _loc40_.addShape(_loc19_ as RefShape);
                    _loc19_.x = _loc44_.@p0;
                    _loc19_.y = _loc44_.@p1;
                }
                _loc42_ = _loc9_.sp;
                _loc18_ = 0;
                while(_loc18_ < _loc42_.length())
                {
                    _loc44_ = _loc42_[_loc18_];
                    _loc12_ = int(_loc44_.@t);
                    _loc11_ = Settings.specialList[_loc12_];
                    _loc10_ = getDefinitionByName(Settings.specialClassPath + _loc11_) as Class;
                    _loc19_ = new _loc10_();
                    _loc19_.inGroup = true;
                    _loc19_.group = _loc40_;
                    _loc14_ = _loc19_.getFullProperties();
                    _loc45_ = 0;
                    while(_loc45_ < _loc14_.length)
                    {
                        _loc13_ = _loc14_[_loc45_];
                        if(_loc19_[_loc13_] is String)
                        {
                            _loc39_ = _loc44_.child("p" + _loc45_)[0];
                            _loc19_[_loc13_] = _loc39_;
                        }
                        else
                        {
                            _loc16_ = _loc44_.attribute("p" + _loc45_);
                            if(_loc16_ == "t" || _loc16_ == "f")
                            {
                                _loc19_[_loc13_] = _loc16_ == "t" ? true : false;
                            }
                            else if(_loc16_ != "")
                            {
                                _loc19_[_loc13_] = _loc16_;
                            }
                        }
                        _loc45_++;
                    }
                    _loc40_.addSpecial(_loc19_ as Special);
                    _loc19_.x = _loc44_.@p0;
                    _loc19_.y = _loc44_.@p1;
                    _loc18_++;
                }
                this.canvas.addRefSprite(_loc40_);
                _loc40_.x = _loc9_.@x;
                _loc40_.y = _loc9_.@y;
                _loc17_++;
            }
            _loc20_ = int(_loc6_.length());
            _loc17_ = 0;
            while(_loc17_ < _loc20_)
            {
                _loc9_ = _loc6_[_loc17_];
                if(_loc9_.@t == 0)
                {
                    _loc46_ = new PinJoint();
                    this.canvas.addRefSprite(_loc46_);
                    _loc46_.x = _loc9_.@x;
                    _loc46_.y = _loc9_.@y;
                    if(_loc9_.@b1 != -1)
                    {
                        _loc47_ = String(_loc9_.@b1).charAt(0);
                        if(_loc47_ == "s")
                        {
                            _loc48_ = int(String(_loc9_.@b1).substring(1));
                            _loc46_.body1 = this.canvas.special.getChildAt(_loc48_) as RefSprite;
                        }
                        else if(_loc47_ == "g")
                        {
                            _loc48_ = int(String(_loc9_.@b1).substring(1));
                            _loc46_.body1 = this.canvas.groups.getChildAt(_loc48_) as RefSprite;
                        }
                        else
                        {
                            _loc46_.body1 = this.canvas.shapes.getChildAt(_loc9_.@b1) as RefSprite;
                        }
                    }
                    if(_loc9_.@b2 != -1)
                    {
                        _loc47_ = String(_loc9_.@b2).charAt(0);
                        if(_loc47_ == "s")
                        {
                            _loc48_ = int(String(_loc9_.@b2).substring(1));
                            _loc46_.body2 = this.canvas.special.getChildAt(_loc48_) as RefSprite;
                        }
                        else if(_loc47_ == "g")
                        {
                            _loc48_ = int(String(_loc9_.@b2).substring(1));
                            _loc46_.body2 = this.canvas.groups.getChildAt(_loc48_) as RefSprite;
                        }
                        else
                        {
                            _loc46_.body2 = this.canvas.shapes.getChildAt(_loc9_.@b2) as RefSprite;
                        }
                    }
                    if(_loc9_.@l == "t")
                    {
                        _loc46_.limit = true;
                    }
                    if(_loc9_.@ua != undefined)
                    {
                        _loc46_.upperAngle = int(_loc9_.@ua);
                    }
                    if(_loc9_.@la != undefined)
                    {
                        _loc46_.lowerAngle = int(_loc9_.@la);
                    }
                    if(_loc9_.@m == "t")
                    {
                        _loc46_.motor = true;
                    }
                    if(_loc9_.@tq != undefined)
                    {
                        _loc46_.torque = Number(_loc9_.@tq);
                    }
                    if(_loc9_.@sp != undefined)
                    {
                        _loc46_.speed = Number(_loc9_.@sp);
                    }
                    if(_loc9_.@c == "t")
                    {
                        _loc46_.collideSelf = true;
                    }
                    if(_loc9_.@v == "f")
                    {
                        _loc46_.vehicleControlled = false;
                    }
                    _loc46_.drawArms();
                }
                else if(_loc9_.@t == 1)
                {
                    _loc49_ = new PrisJoint();
                    this.canvas.addRefSprite(_loc49_);
                    _loc49_.x = _loc9_.@x;
                    _loc49_.y = _loc9_.@y;
                    _loc49_.axisAngle = _loc9_.@a;
                    if(_loc9_.@b1 != -1)
                    {
                        _loc47_ = String(_loc9_.@b1).charAt(0);
                        if(_loc47_ == "s")
                        {
                            _loc48_ = int(String(_loc9_.@b1).substring(1));
                            _loc49_.body1 = this.canvas.special.getChildAt(_loc48_) as RefSprite;
                        }
                        else if(_loc47_ == "g")
                        {
                            _loc48_ = int(String(_loc9_.@b1).substring(1));
                            _loc49_.body1 = this.canvas.groups.getChildAt(_loc48_) as RefSprite;
                        }
                        else
                        {
                            _loc49_.body1 = this.canvas.shapes.getChildAt(_loc9_.@b1) as RefSprite;
                        }
                    }
                    if(_loc9_.@b2 != -1)
                    {
                        _loc47_ = String(_loc9_.@b2).charAt(0);
                        if(_loc47_ == "s")
                        {
                            _loc48_ = int(String(_loc9_.@b2).substring(1));
                            _loc49_.body2 = this.canvas.special.getChildAt(_loc48_) as RefSprite;
                        }
                        else if(_loc47_ == "g")
                        {
                            _loc48_ = int(String(_loc9_.@b2).substring(1));
                            _loc49_.body2 = this.canvas.groups.getChildAt(_loc48_) as RefSprite;
                        }
                        else
                        {
                            _loc49_.body2 = this.canvas.shapes.getChildAt(_loc9_.@b2) as RefSprite;
                        }
                    }
                    if(_loc9_.@l == "t")
                    {
                        _loc49_.limit = true;
                    }
                    if(_loc9_.@ul != undefined)
                    {
                        _loc49_.upperLimit = int(_loc9_.@ul);
                    }
                    if(_loc9_.@ll != undefined)
                    {
                        _loc49_.lowerLimit = int(_loc9_.@ll);
                    }
                    if(_loc9_.@m == "t")
                    {
                        _loc49_.motor = true;
                    }
                    if(_loc9_.@fo != undefined)
                    {
                        _loc49_.force = Number(_loc9_.@fo);
                    }
                    if(_loc9_.@sp != undefined)
                    {
                        _loc49_.speed = Number(_loc9_.@sp);
                    }
                    if(_loc9_.@c == "t")
                    {
                        _loc49_.collideSelf = true;
                    }
                    if(_loc9_.@v == "f")
                    {
                        _loc49_.vehicleControlled = false;
                    }
                    _loc49_.drawArms();
                }
                _loc17_++;
            }
            _loc20_ = int(_loc7_.length());
            _loc17_ = 0;
            while(_loc17_ < _loc20_)
            {
                _loc50_ = new RefTrigger();
                this.canvas.addRefSprite(_loc50_);
                _loc17_++;
            }
            _loc17_ = 0;
            while(_loc17_ < _loc20_)
            {
                _loc9_ = _loc7_[_loc17_];
                _loc50_ = this.canvas.triggers.getChildAt(_loc17_) as RefTrigger;
                _loc50_.x = _loc9_.@x;
                _loc50_.y = _loc9_.@y;
                _loc50_.angle = _loc9_.@a;
                _loc50_.shapeWidth = _loc9_.@w;
                _loc50_.shapeHeight = _loc9_.@h;
                _loc50_.triggeredBy = _loc9_.@b;
                _loc50_.typeIndex = _loc9_.@t;
                _loc50_.repeatType = _loc9_.@r;
                if(_loc9_.@sd == "t")
                {
                    _loc50_.startDisabled = true;
                }
                if(_loc50_.repeatType > 2)
                {
                    _loc50_.repeatInterval = _loc9_.@i;
                }
                _loc51_ = _loc50_.typeIndex == 1 || _loc50_.triggeredBy == 4 ? true : false;
                _loc52_ = _loc50_.typeIndex == 1 ? true : false;
                if(_loc50_.typeIndex == 1)
                {
                    _loc50_.triggerDelay = _loc9_.@d;
                }
                else if(_loc50_.typeIndex == 2)
                {
                    _loc50_.soundEffect = SoundList.instance.sfxLookup[int(_loc9_.@s)];
                    _loc50_.triggerDelay = _loc9_.@d;
                    _loc50_.volume = _loc9_.@v;
                    _loc50_.soundLocation = _loc9_.@l;
                    _loc50_.panning = _loc9_.@p;
                }
                else if(_loc50_.typeIndex == 3)
                {
                    _loc50_.triggerDelay = 0;
                }
                if(_loc51_)
                {
                    _loc53_ = _loc9_.children();
                    _loc18_ = 0;
                    while(_loc18_ < _loc53_.length())
                    {
                        _loc55_ = _loc53_[_loc18_];
                        _loc56_ = _loc55_.name();
                        _loc57_ = null;
                        _loc58_ = null;
                        _loc59_ = null;
                        _loc48_ = int(_loc55_.@i);
                        if(_loc56_ == "sh")
                        {
                            _loc54_ = this.canvas.shapes.getChildAt(_loc48_) as RefSprite;
                        }
                        else if(_loc56_ == "sp")
                        {
                            _loc54_ = this.canvas.special.getChildAt(_loc48_) as RefSprite;
                        }
                        else if(_loc56_ == "g")
                        {
                            _loc54_ = this.canvas.groups.getChildAt(_loc48_) as RefSprite;
                        }
                        else if(_loc56_ == "j")
                        {
                            _loc54_ = this.canvas.joints.getChildAt(_loc48_) as RefSprite;
                        }
                        else
                        {
                            _loc56_ = "t";
                            if(!_loc56_)
                            {
                                throw new Error("what the fuck is this target?");
                            }
                            _loc54_ = this.canvas.triggers.getChildAt(_loc48_) as RefSprite;
                        }
                        if(_loc52_)
                        {
                            _loc57_ = _loc54_.triggerActionList;
                            _loc58_ = _loc54_.triggerActionListProperties;
                            if(_loc57_)
                            {
                                if(_loc8_ < 1.87)
                                {
                                    _loc60_ = int(_loc55_.@a);
                                    _loc61_ = _loc57_[_loc60_];
                                    _loc54_.triggerActions[_loc50_] = [_loc61_];
                                    _loc59_ = !!_loc58_ ? _loc58_[_loc60_] : null;
                                    if(_loc59_)
                                    {
                                        _loc45_ = 0;
                                        while(_loc45_ < _loc59_.length)
                                        {
                                            _loc13_ = _loc59_[_loc45_];
                                            _loc62_ = _loc54_.keyedPropertyObject[_loc13_];
                                            if(!_loc62_)
                                            {
                                                _loc62_ = _loc54_.keyedPropertyObject[_loc13_] = new Dictionary();
                                            }
                                            _loc16_ = _loc55_.attribute("p" + _loc45_);
                                            if(_loc16_ == "t" || _loc16_ == "f")
                                            {
                                                _loc62_[_loc50_] = _loc16_ == "t" ? [true] : [false];
                                            }
                                            else if(_loc16_ != "")
                                            {
                                                _loc62_[_loc50_] = [_loc16_];
                                            }
                                            _loc45_++;
                                        }
                                    }
                                }
                                else
                                {
                                    _loc63_ = _loc55_.children();
                                    _loc64_ = _loc54_.triggerActions[_loc50_];
                                    if(!_loc64_)
                                    {
                                        _loc64_ = _loc54_.triggerActions[_loc50_] = new Array();
                                    }
                                    _loc65_ = 0;
                                    while(_loc65_ < _loc63_.length())
                                    {
                                        _loc66_ = _loc63_[_loc65_];
                                        _loc60_ = int(_loc66_.@i);
                                        if(_loc57_)
                                        {
                                            _loc61_ = _loc57_[_loc60_];
                                            _loc64_.push(_loc61_);
                                            _loc59_ = !!_loc58_ ? _loc58_[_loc60_] : null;
                                            if(_loc59_)
                                            {
                                                _loc45_ = 0;
                                                while(_loc45_ < _loc59_.length)
                                                {
                                                    _loc13_ = _loc59_[_loc45_];
                                                    _loc62_ = _loc54_.keyedPropertyObject[_loc13_];
                                                    if(!_loc62_)
                                                    {
                                                        _loc62_ = _loc54_.keyedPropertyObject[_loc13_] = new Dictionary();
                                                    }
                                                    _loc67_ = _loc62_[_loc50_];
                                                    if(!_loc67_)
                                                    {
                                                        _loc67_ = _loc62_[_loc50_] = new Array();
                                                    }
                                                    _loc16_ = _loc66_.attribute("p" + _loc45_);
                                                    if(_loc16_ == "t" || _loc16_ == "f")
                                                    {
                                                        _loc67_[_loc65_] = _loc16_ == "t" ? true : false;
                                                    }
                                                    else
                                                    {
                                                        _loc67_[_loc65_] = _loc16_;
                                                    }
                                                    _loc45_++;
                                                }
                                            }
                                        }
                                        _loc65_++;
                                    }
                                }
                            }
                        }
                        _loc50_.addTarget(_loc54_);
                        _loc18_++;
                    }
                }
                _loc50_.x = _loc9_.@x;
                _loc50_.y = _loc9_.@y;
                _loc17_++;
            }
            this.canvas.relabelTriggers();
            this.canvas.startPlaceHolder.x = _loc2_.@x;
            this.canvas.startPlaceHolder.y = _loc2_.@y;
            this.canvas.startPlaceHolder.characterIndex = _loc2_.@c;
            this.canvas.startPlaceHolder.forceChar = _loc2_.@f == "t" ? true : false;
            this.canvas.startPlaceHolder.hideVehicle = _loc2_.@h == "t" ? true : false;
            Canvas.backDropIndex = _loc2_.@bg;
            Canvas.backgroundColor = _loc2_.@bgc.length() > 0 ? int(_loc2_.@bgc) : 16777215;
            dispatchEvent(new Event(UPDATE_COPIED_VERTS));
        }
        
        protected function createDummyShape() : RefShape
        {
            var _loc1_:ArtShape = new ArtShape(false,false,false,1,0,-1,0);
            _loc1_.x = _loc1_.y = 0;
            _loc1_.vertVector.push(new b2Vec2());
            _loc1_.vertVector.push(new b2Vec2(10,0));
            _loc1_.vertVector.push(new b2Vec2(5,5));
            _loc1_.handleVector.push(new b2Vec2());
            _loc1_.handleVector.push(new b2Vec2());
            _loc1_.handleVector.push(new b2Vec2());
            _loc1_.handleVector.push(new b2Vec2());
            _loc1_.handleVector.push(new b2Vec2());
            _loc1_.handleVector.push(new b2Vec2());
            return _loc1_;
        }
        
        public function clearCanvas() : void
        {
            var _loc2_:RefShape = null;
            var _loc3_:RefJoint = null;
            var _loc4_:RefGroup = null;
            var _loc5_:Special = null;
            var _loc1_:int = this.canvas.shapes.numChildren;
            while(_loc1_ > 0)
            {
                _loc2_ = this.canvas.shapes.getChildAt(_loc1_ - 1) as RefShape;
                _loc2_.deleteSelf(this.canvas);
                _loc1_--;
            }
            _loc1_ = this.canvas.joints.numChildren;
            while(_loc1_ > 0)
            {
                _loc3_ = this.canvas.joints.getChildAt(_loc1_ - 1) as RefJoint;
                _loc3_.deleteSelf(this.canvas);
                _loc1_--;
            }
            _loc1_ = this.canvas.groups.numChildren;
            while(_loc1_ > 0)
            {
                _loc4_ = this.canvas.groups.getChildAt(_loc1_ - 1) as RefGroup;
                _loc4_.deleteSelf(this.canvas);
                _loc1_--;
            }
            _loc1_ = this.canvas.special.numChildren;
            while(_loc1_ > 0)
            {
                _loc5_ = this.canvas.special.getChildAt(_loc1_ - 1) as Special;
                _loc5_.deleteSelf(this.canvas);
                _loc1_--;
            }
        }
        
        public function die() : void
        {
            _instance = null;
        }
    }
}

