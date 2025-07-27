package com.totaljerkface.game
{
    import Box2D.Common.Math.b2Vec2;
    import com.totaljerkface.game.editor.*;
    import com.totaljerkface.game.editor.specials.*;
    import com.totaljerkface.game.editor.trigger.RefTrigger;
    import com.totaljerkface.game.sound.SoundList;
    import com.totaljerkface.game.utils.LevelEncryptor;
    import com.totaljerkface.game.utils.TextUtils;
    import flash.display.*;
    import flash.events.*;
    import flash.geom.Point;
    import flash.net.*;
    import flash.system.*;
    import flash.utils.*;
    
    public class UserLevelLoader extends EventDispatcher
    {
        protected var _levelXML:XML;
        
        protected var _levelVersion:Number;
        
        protected var levelId:int;
        
        protected var authorId:int;
        
        protected var _errorString:String;
        
        protected var incrementPlays:Boolean;
        
        public function UserLevelLoader(param1:int, param2:int, param3:Boolean = false)
        {
            super();
            this.levelId = param1;
            this.authorId = param2;
            this.incrementPlays = param3;
        }
        
        public function loadData() : void
        {
            var _loc1_:URLRequest = new URLRequest(Settings.siteURL + "get_level.hw");
            _loc1_.method = URLRequestMethod.POST;
            var _loc2_:URLVariables = new URLVariables();
            _loc2_.level_id = this.levelId;
            _loc2_.action = "get_record";
            _loc2_.ip_tracking = TextUtils.randomNumString(4,8,this.incrementPlays);
            _loc1_.data = _loc2_;
            var _loc3_:URLLoader = new URLLoader();
            _loc3_.dataFormat = URLLoaderDataFormat.BINARY;
            _loc3_.addEventListener(Event.COMPLETE,this.loadComplete);
            _loc3_.addEventListener(IOErrorEvent.IO_ERROR,this.IOErrorHandler);
            _loc3_.load(_loc1_);
        }
        
        protected function IOErrorHandler(param1:IOErrorEvent) : void
        {
            var _loc2_:URLLoader = param1.target as URLLoader;
            _loc2_.removeEventListener(Event.COMPLETE,this.loadComplete);
            _loc2_.removeEventListener(IOErrorEvent.IO_ERROR,this.IOErrorHandler);
            dispatchEvent(new Event(IOErrorEvent.IO_ERROR));
        }
        
        protected function loadComplete(param1:Event) : void
        {
            var _loc7_:Array = null;
            var _loc2_:URLLoader = param1.target as URLLoader;
            _loc2_.removeEventListener(Event.COMPLETE,this.loadComplete);
            _loc2_.removeEventListener(IOErrorEvent.IO_ERROR,this.IOErrorHandler);
            var _loc3_:String = String(_loc2_.data);
            var _loc4_:String = _loc3_.substr(0,8);
            trace("dataString " + _loc4_);
            if(_loc4_.indexOf("<html>") > -1)
            {
                this._errorString = "system_error";
                dispatchEvent(new ErrorEvent(ErrorEvent.ERROR));
                return;
            }
            if(_loc4_.indexOf("failure") > -1)
            {
                _loc7_ = _loc3_.split(":");
                this._errorString = _loc7_[1];
                dispatchEvent(new ErrorEvent(ErrorEvent.ERROR));
                return;
            }
            var _loc5_:ByteArray = _loc2_.data;
            LevelEncryptor.decryptByteArray(_loc5_,"eatshit" + this.authorId);
            _loc5_.uncompress();
            var _loc6_:* = _loc5_.readUTFBytes(_loc5_.length);
            this._levelXML = new XML(_loc6_);
            dispatchEvent(new Event(Event.COMPLETE));
        }
        
        protected function get levelXML() : XML
        {
            return this._levelXML;
        }
        
        public function set levelXML(param1:XML) : *
        {
            this._levelXML = param1;
        }
        
        public function buildLevelSourceObject() : Sprite
        {
            var _loc5_:Sprite = null;
            var _loc8_:XMLList = null;
            var _loc14_:XML = null;
            var _loc15_:Class = null;
            var _loc16_:String = null;
            var _loc17_:int = 0;
            var _loc18_:String = null;
            var _loc19_:Array = null;
            var _loc20_:XMLList = null;
            var _loc21_:String = null;
            var _loc22_:int = 0;
            var _loc23_:int = 0;
            var _loc24_:RefSprite = null;
            var _loc31_:int = 0;
            var _loc32_:XML = null;
            var _loc33_:int = 0;
            var _loc34_:String = null;
            var _loc35_:int = 0;
            var _loc36_:PolygonShape = null;
            var _loc37_:Array = null;
            var _loc38_:int = 0;
            var _loc39_:String = null;
            var _loc40_:Array = null;
            var _loc41_:b2Vec2 = null;
            var _loc42_:ArtShape = null;
            var _loc43_:b2Vec2 = null;
            var _loc44_:b2Vec2 = null;
            var _loc45_:XML = null;
            var _loc46_:RefGroup = null;
            var _loc47_:XMLList = null;
            var _loc48_:XMLList = null;
            var _loc49_:RefVehicle = null;
            var _loc50_:XML = null;
            var _loc51_:int = 0;
            var _loc52_:PinJoint = null;
            var _loc53_:String = null;
            var _loc54_:int = 0;
            var _loc55_:PrisJoint = null;
            var _loc56_:RefTrigger = null;
            var _loc57_:Boolean = false;
            var _loc58_:Boolean = false;
            var _loc59_:XMLList = null;
            var _loc60_:RefSprite = null;
            var _loc61_:XML = null;
            var _loc62_:String = null;
            var _loc63_:Array = null;
            var _loc64_:Array = null;
            var _loc65_:Array = null;
            var _loc66_:int = 0;
            var _loc67_:String = null;
            var _loc68_:Dictionary = null;
            var _loc69_:XMLList = null;
            var _loc70_:Array = null;
            var _loc71_:int = 0;
            var _loc72_:XML = null;
            var _loc73_:Array = null;
            var _loc1_:XMLList = this._levelXML.children();
            var _loc2_:Sprite = new Sprite();
            _loc2_.name = "shapeGuide";
            var _loc3_:Sprite = new Sprite();
            _loc3_.name = "shapes";
            var _loc4_:Sprite = new Sprite();
            _loc4_.name = "joints";
            _loc5_ = new Sprite();
            _loc5_.name = "special";
            var _loc6_:Sprite = new Sprite();
            _loc6_.name = "groups";
            var _loc7_:Sprite = new Sprite();
            _loc7_.name = "triggers";
            _loc2_.addChild(_loc3_);
            _loc2_.addChild(_loc5_);
            _loc2_.addChild(_loc6_);
            _loc2_.addChild(_loc4_);
            _loc2_.addChild(_loc7_);
            _loc8_ = this._levelXML.info;
            var _loc9_:XMLList = this._levelXML.shapes.sh;
            var _loc10_:XMLList = this._levelXML.specials.sp;
            var _loc11_:XMLList = this._levelXML.groups.g;
            var _loc12_:XMLList = this._levelXML.joints.j;
            var _loc13_:XMLList = this._levelXML.triggers.t;
            this._levelVersion = Number(_loc8_.@v);
            if(this._levelVersion > Settings.CURRENT_VERSION)
            {
                Settings.debugText.text = "This Level is from a newer version of Happy Wheels.  Clear cache and reload";
                throw new Error("This Level is from a newer version of Happy Wheels.  Clear cache and reload");
            }
            var _loc25_:int = int(_loc9_.length());
            var _loc26_:Array = new Array();
            var _loc27_:Array = new Array();
            var _loc28_:Array = new Array();
            var _loc29_:Array = new Array();
            _loc22_ = 0;
            for(; _loc22_ < _loc25_; _loc22_++)
            {
                _loc14_ = _loc9_[_loc22_];
                _loc17_ = int(_loc14_.@t);
                if(_loc17_ == 3 && _loc14_.@i == "f")
                {
                    _loc17_ = 4;
                }
                _loc16_ = Settings.shapeList[_loc17_];
                _loc15_ = getDefinitionByName(Settings.shapeClassPath + _loc16_) as Class;
                _loc24_ = new _loc15_();
                if(_loc14_.@i == "f")
                {
                    _loc24_["interactive"] = false;
                }
                if(_loc14_.@h == "t")
                {
                    _loc24_["vehicleHandle"] = true;
                }
                if(_loc14_.@h == "f")
                {
                    _loc24_["vehicleHandle"] = false;
                }
                _loc19_ = _loc24_.getFullProperties();
                _loc31_ = int(_loc19_.length);
                if(_loc17_ == 3)
                {
                    _loc32_ = _loc14_.child("v")[0];
                    _loc33_ = int(_loc32_.@id);
                    _loc34_ = _loc32_.@f;
                    _loc35_ = int(_loc27_.indexOf(_loc33_));
                    if(_loc35_ > -1)
                    {
                        _loc37_ = _loc26_[_loc35_];
                    }
                    else
                    {
                        _loc38_ = int(_loc32_.@n);
                        _loc37_ = new Array();
                        _loc51_ = 0;
                        while(_loc51_ < _loc38_)
                        {
                            _loc39_ = _loc32_.attribute("v" + _loc51_);
                            _loc37_.push(_loc39_);
                            _loc51_++;
                        }
                        _loc26_.push(_loc37_);
                        _loc27_.push(_loc33_);
                    }
                    _loc36_ = _loc24_ as PolygonShape;
                    _loc51_ = 0;
                    while(_loc51_ < _loc37_.length)
                    {
                        _loc39_ = _loc37_[_loc51_];
                        _loc40_ = this._levelVersion < 1.84 ? _loc39_.split(".") : _loc39_.split("_");
                        _loc41_ = new b2Vec2(Number(_loc40_[0]),Number(_loc40_[1]));
                        _loc36_.vertVector.push(_loc41_);
                        _loc51_++;
                    }
                    if(_loc36_.numVerts <= 1)
                    {
                        _loc3_.addChild(this.createDummyShape());
                        continue;
                    }
                    _loc24_["completeFill"] = _loc34_ == "t" ? true : false;
                    _loc24_["vID"] = _loc33_;
                    _loc36_.redraw();
                }
                else if(_loc17_ == 4)
                {
                    _loc32_ = _loc14_.child("v")[0];
                    _loc33_ = int(_loc32_.@id);
                    _loc34_ = _loc32_.@f;
                    _loc35_ = int(_loc29_.indexOf(_loc33_));
                    if(_loc35_ > -1)
                    {
                        _loc37_ = _loc28_[_loc35_];
                    }
                    else
                    {
                        _loc38_ = int(_loc32_.@n);
                        _loc37_ = new Array();
                        _loc51_ = 0;
                        while(_loc51_ < _loc38_)
                        {
                            _loc39_ = _loc32_.attribute("v" + _loc51_);
                            _loc37_.push(_loc39_);
                            _loc51_++;
                        }
                        _loc28_.push(_loc37_);
                        _loc29_.push(_loc33_);
                    }
                    _loc42_ = _loc24_ as ArtShape;
                    _loc51_ = 0;
                    while(_loc51_ < _loc37_.length)
                    {
                        _loc39_ = _loc37_[_loc51_];
                        _loc40_ = this._levelVersion < 1.84 ? _loc39_.split(".") : _loc39_.split("_");
                        _loc41_ = new b2Vec2(Number(_loc40_[0]),Number(_loc40_[1]));
                        _loc43_ = !!_loc40_[2] ? new b2Vec2(Number(_loc40_[2]),Number(_loc40_[3])) : new b2Vec2();
                        _loc44_ = !!_loc40_[4] ? new b2Vec2(Number(_loc40_[4]),Number(_loc40_[5])) : new b2Vec2();
                        _loc42_.vertVector.push(_loc41_);
                        _loc42_.handleVector.push(_loc43_);
                        _loc42_.handleVector.push(_loc44_);
                        _loc51_++;
                    }
                    if(_loc42_.numVerts <= 1)
                    {
                        _loc3_.addChild(this.createDummyShape());
                        continue;
                    }
                    _loc24_["completeFill"] = _loc34_ == "t" ? true : false;
                    _loc24_["vID"] = _loc33_;
                    _loc42_.redraw();
                }
                _loc23_ = 0;
                while(_loc23_ < _loc31_)
                {
                    _loc18_ = _loc19_[_loc23_];
                    _loc21_ = _loc14_.attribute("p" + _loc23_);
                    if(_loc21_ == "t" || _loc21_ == "f")
                    {
                        _loc24_[_loc18_] = _loc21_ == "t" ? true : false;
                    }
                    else if(_loc21_ != "")
                    {
                        _loc24_[_loc18_] = _loc21_;
                    }
                    _loc23_++;
                }
                _loc3_.addChild(_loc24_);
                _loc24_.x = _loc14_.@p0;
                _loc24_.y = _loc14_.@p1;
            }
            _loc25_ = int(_loc10_.length());
            _loc22_ = 0;
            while(_loc22_ < _loc25_)
            {
                _loc14_ = _loc10_[_loc22_];
                _loc17_ = int(_loc14_.@t);
                _loc16_ = Settings.specialList[_loc17_];
                _loc15_ = getDefinitionByName(Settings.specialClassPath + _loc16_) as Class;
                _loc24_ = new _loc15_();
                _loc19_ = _loc24_.getFullProperties();
                _loc23_ = 0;
                while(_loc23_ < _loc19_.length)
                {
                    _loc18_ = _loc19_[_loc23_];
                    if(_loc24_[_loc18_] is String)
                    {
                        _loc45_ = _loc14_.child("p" + _loc23_)[0];
                        _loc24_[_loc18_] = _loc45_;
                    }
                    else
                    {
                        _loc21_ = _loc14_.attribute("p" + _loc23_);
                        if(_loc21_ == "t" || _loc21_ == "f")
                        {
                            _loc24_[_loc18_] = _loc21_ == "t" ? true : false;
                        }
                        else if(_loc21_ != "")
                        {
                            _loc24_[_loc18_] = _loc21_;
                        }
                    }
                    _loc23_++;
                }
                _loc5_.addChild(_loc24_);
                _loc24_.x = _loc14_.@p0;
                _loc24_.y = _loc14_.@p1;
                _loc22_++;
            }
            _loc25_ = int(_loc11_.length());
            _loc22_ = 0;
            while(_loc22_ < _loc25_)
            {
                _loc14_ = _loc11_[_loc22_];
                if(_loc14_.@v == "t")
                {
                    _loc46_ = new RefVehicle();
                    _loc49_ = _loc46_ as RefVehicle;
                    _loc49_.spaceAction = int(_loc14_.@sb);
                    _loc49_.shiftAction = int(_loc14_.@sh);
                    _loc49_.ctrlAction = int(_loc14_.@ct);
                    _loc49_.acceleration = int(_loc14_.@a);
                    _loc49_.leaningStrength = int(_loc14_.@l);
                    _loc49_.characterPose = int(_loc14_.@cp);
                    _loc49_.lockJoints = _loc14_.@lo == "t" ? true : false;
                }
                else
                {
                    _loc46_ = new RefGroup();
                }
                _loc46_.offset = new Point(_loc14_.@ox,_loc14_.@oy);
                _loc46_.angle = _loc14_.@r;
                _loc46_.sleeping = _loc14_.@s == "t" ? true : false;
                _loc46_.foreground = _loc14_.@f == "t" ? true : false;
                _loc46_.opacity = String(_loc14_.@o) == "" ? 100 : Number(_loc14_.@o);
                _loc46_.immovable = _loc14_.@im == "t" ? true : false;
                _loc46_.fixedRotation = _loc14_.@fr == "t" ? true : false;
                _loc47_ = _loc14_.sh;
                _loc23_ = 0;
                for(; _loc23_ < _loc47_.length(); _loc23_++)
                {
                    _loc50_ = _loc47_[_loc23_];
                    _loc17_ = int(_loc50_.@t);
                    if(_loc17_ == 3 && _loc50_.@i == "f")
                    {
                        _loc17_ = 4;
                    }
                    _loc16_ = Settings.shapeList[_loc17_];
                    _loc15_ = getDefinitionByName(Settings.shapeClassPath + _loc16_) as Class;
                    _loc24_ = new _loc15_();
                    _loc24_.inGroup = true;
                    _loc24_.group = _loc46_;
                    if(_loc50_.@i == "f")
                    {
                        _loc24_["interactive"] = false;
                    }
                    if(_loc50_.@h == "t")
                    {
                        _loc24_["vehicleHandle"] = true;
                    }
                    if(_loc50_.@h == "f")
                    {
                        _loc24_["vehicleHandle"] = false;
                    }
                    _loc19_ = _loc24_.getFullProperties();
                    _loc31_ = int(_loc19_.length);
                    if(_loc17_ == 3)
                    {
                        _loc32_ = _loc50_.child("v")[0];
                        _loc33_ = int(_loc32_.@id);
                        _loc34_ = _loc32_.@f;
                        _loc35_ = int(_loc27_.indexOf(_loc33_));
                        if(_loc35_ > -1)
                        {
                            _loc37_ = _loc26_[_loc35_];
                        }
                        else
                        {
                            _loc38_ = int(_loc32_.@n);
                            _loc37_ = new Array();
                            _loc51_ = 0;
                            while(_loc51_ < _loc38_)
                            {
                                _loc39_ = _loc32_.attribute("v" + _loc51_);
                                _loc37_.push(_loc39_);
                                _loc51_++;
                            }
                            _loc26_.push(_loc37_);
                            _loc27_.push(_loc33_);
                        }
                        _loc36_ = _loc24_ as PolygonShape;
                        _loc51_ = 0;
                        while(_loc51_ < _loc37_.length)
                        {
                            _loc39_ = _loc37_[_loc51_];
                            _loc40_ = this._levelVersion < 1.84 ? _loc39_.split(".") : _loc39_.split("_");
                            _loc41_ = new b2Vec2(Number(_loc40_[0]),Number(_loc40_[1]));
                            _loc36_.vertVector.push(_loc41_);
                            _loc51_++;
                        }
                        if(_loc36_.numVerts <= 1)
                        {
                            _loc46_.addShape(this.createDummyShape());
                            continue;
                        }
                        _loc24_["completeFill"] = _loc34_ == "t" ? true : false;
                        _loc24_["vID"] = _loc33_;
                        _loc36_.redraw();
                    }
                    else if(_loc17_ == 4)
                    {
                        _loc32_ = _loc50_.child("v")[0];
                        _loc33_ = int(_loc32_.@id);
                        _loc34_ = _loc32_.@f;
                        _loc35_ = int(_loc29_.indexOf(_loc33_));
                        if(_loc35_ > -1)
                        {
                            _loc37_ = _loc28_[_loc35_];
                        }
                        else
                        {
                            _loc38_ = int(_loc32_.@n);
                            _loc37_ = new Array();
                            _loc51_ = 0;
                            while(_loc51_ < _loc38_)
                            {
                                _loc39_ = _loc32_.attribute("v" + _loc51_);
                                _loc37_.push(_loc39_);
                                _loc51_++;
                            }
                            _loc28_.push(_loc37_);
                            _loc29_.push(_loc33_);
                        }
                        _loc42_ = _loc24_ as ArtShape;
                        _loc51_ = 0;
                        while(_loc51_ < _loc37_.length)
                        {
                            _loc39_ = _loc37_[_loc51_];
                            _loc40_ = this._levelVersion < 1.84 ? _loc39_.split(".") : _loc39_.split("_");
                            _loc41_ = new b2Vec2(Number(_loc40_[0]),Number(_loc40_[1]));
                            _loc43_ = !!_loc40_[2] ? new b2Vec2(Number(_loc40_[2]),Number(_loc40_[3])) : new b2Vec2();
                            _loc44_ = !!_loc40_[4] ? new b2Vec2(Number(_loc40_[4]),Number(_loc40_[5])) : new b2Vec2();
                            _loc42_.vertVector.push(_loc41_);
                            _loc42_.handleVector.push(_loc43_);
                            _loc42_.handleVector.push(_loc44_);
                            _loc51_++;
                        }
                        if(_loc42_.numVerts <= 1)
                        {
                            _loc46_.addShape(this.createDummyShape());
                            continue;
                        }
                        _loc24_["completeFill"] = _loc34_ == "t" ? true : false;
                        _loc24_["vID"] = _loc33_;
                        _loc42_.redraw();
                    }
                    _loc51_ = 0;
                    while(_loc51_ < _loc31_)
                    {
                        _loc18_ = _loc19_[_loc51_];
                        _loc21_ = _loc50_.attribute("p" + _loc51_);
                        if(_loc21_ == "t" || _loc21_ == "f")
                        {
                            _loc24_[_loc18_] = _loc21_ == "t" ? true : false;
                        }
                        else if(_loc21_ != "")
                        {
                            _loc24_[_loc18_] = _loc21_;
                        }
                        _loc51_++;
                    }
                    _loc46_.addShape(_loc24_ as RefShape);
                    _loc24_.x = _loc50_.@p0;
                    _loc24_.y = _loc50_.@p1;
                }
                _loc48_ = _loc14_.sp;
                _loc23_ = 0;
                while(_loc23_ < _loc48_.length())
                {
                    _loc50_ = _loc48_[_loc23_];
                    _loc17_ = int(_loc50_.@t);
                    _loc16_ = Settings.specialList[_loc17_];
                    _loc15_ = getDefinitionByName(Settings.specialClassPath + _loc16_) as Class;
                    _loc24_ = new _loc15_();
                    _loc24_.inGroup = true;
                    _loc24_.group = _loc46_;
                    _loc19_ = _loc24_.getFullProperties();
                    _loc51_ = 0;
                    while(_loc51_ < _loc19_.length)
                    {
                        _loc18_ = _loc19_[_loc51_];
                        if(_loc24_[_loc18_] is String)
                        {
                            _loc45_ = _loc50_.child("p" + _loc51_)[0];
                            _loc24_[_loc18_] = _loc45_;
                        }
                        else
                        {
                            _loc21_ = _loc50_.attribute("p" + _loc51_);
                            if(_loc21_ == "t" || _loc21_ == "f")
                            {
                                _loc24_[_loc18_] = _loc21_ == "t" ? true : false;
                            }
                            else if(_loc21_ != "")
                            {
                                _loc24_[_loc18_] = _loc21_;
                            }
                        }
                        _loc51_++;
                    }
                    _loc46_.addSpecial(_loc24_ as Special);
                    _loc24_.x = _loc50_.@p0;
                    _loc24_.y = _loc50_.@p1;
                    _loc23_++;
                }
                _loc6_.addChild(_loc46_);
                _loc46_.x = _loc14_.@x;
                _loc46_.y = _loc14_.@y;
                _loc22_++;
            }
            _loc25_ = int(_loc12_.length());
            _loc22_ = 0;
            while(_loc22_ < _loc25_)
            {
                _loc14_ = _loc12_[_loc22_];
                if(_loc14_.@t == 0)
                {
                    _loc52_ = new PinJoint();
                    _loc4_.addChild(_loc52_);
                    _loc52_.x = _loc14_.@x;
                    _loc52_.y = _loc14_.@y;
                    if(_loc14_.@b1 != -1)
                    {
                        _loc53_ = String(_loc14_.@b1).charAt(0);
                        if(_loc53_ == "s")
                        {
                            _loc54_ = int(String(_loc14_.@b1).substring(1));
                            _loc52_.body1 = _loc5_.getChildAt(_loc54_) as RefSprite;
                        }
                        else if(_loc53_ == "g")
                        {
                            _loc54_ = int(String(_loc14_.@b1).substring(1));
                            _loc52_.body1 = _loc6_.getChildAt(_loc54_) as RefSprite;
                        }
                        else
                        {
                            _loc52_.body1 = _loc3_.getChildAt(_loc14_.@b1) as RefSprite;
                        }
                    }
                    if(_loc14_.@b2 != -1)
                    {
                        _loc53_ = String(_loc14_.@b2).charAt(0);
                        if(_loc53_ == "s")
                        {
                            _loc54_ = int(String(_loc14_.@b2).substring(1));
                            _loc52_.body2 = _loc5_.getChildAt(_loc54_) as RefSprite;
                        }
                        else if(_loc53_ == "g")
                        {
                            _loc54_ = int(String(_loc14_.@b2).substring(1));
                            _loc52_.body2 = _loc6_.getChildAt(_loc54_) as RefSprite;
                        }
                        else
                        {
                            _loc52_.body2 = _loc3_.getChildAt(_loc14_.@b2) as RefSprite;
                        }
                    }
                    if(_loc14_.@l == "t")
                    {
                        _loc52_.limit = true;
                    }
                    if(_loc14_.@ua != undefined)
                    {
                        _loc52_.upperAngle = int(_loc14_.@ua);
                    }
                    if(_loc14_.@la != undefined)
                    {
                        _loc52_.lowerAngle = int(_loc14_.@la);
                    }
                    if(_loc14_.@m == "t")
                    {
                        _loc52_.motor = true;
                    }
                    if(_loc14_.@tq != undefined)
                    {
                        _loc52_.torque = Number(_loc14_.@tq);
                    }
                    if(_loc14_.@sp != undefined)
                    {
                        _loc52_.speed = Number(_loc14_.@sp);
                    }
                    if(_loc14_.@c == "t")
                    {
                        _loc52_.collideSelf = true;
                    }
                    if(_loc14_.@v == "f")
                    {
                        _loc52_.vehicleControlled = false;
                    }
                    _loc52_.drawArms();
                }
                else if(_loc14_.@t == 1)
                {
                    _loc55_ = new PrisJoint();
                    _loc4_.addChild(_loc55_);
                    _loc55_.x = _loc14_.@x;
                    _loc55_.y = _loc14_.@y;
                    _loc55_.axisAngle = _loc14_.@a;
                    if(_loc14_.@b1 != -1)
                    {
                        _loc53_ = String(_loc14_.@b1).charAt(0);
                        if(_loc53_ == "s")
                        {
                            _loc54_ = int(String(_loc14_.@b1).substring(1));
                            _loc55_.body1 = _loc5_.getChildAt(_loc54_) as RefSprite;
                        }
                        else if(_loc53_ == "g")
                        {
                            _loc54_ = int(String(_loc14_.@b1).substring(1));
                            _loc55_.body1 = _loc6_.getChildAt(_loc54_) as RefSprite;
                        }
                        else
                        {
                            _loc55_.body1 = _loc3_.getChildAt(_loc14_.@b1) as RefSprite;
                        }
                    }
                    if(_loc14_.@b2 != -1)
                    {
                        _loc53_ = String(_loc14_.@b2).charAt(0);
                        if(_loc53_ == "s")
                        {
                            _loc54_ = int(String(_loc14_.@b2).substring(1));
                            _loc55_.body2 = _loc5_.getChildAt(_loc54_) as RefSprite;
                        }
                        else if(_loc53_ == "g")
                        {
                            _loc54_ = int(String(_loc14_.@b2).substring(1));
                            _loc55_.body2 = _loc6_.getChildAt(_loc54_) as RefSprite;
                        }
                        else
                        {
                            _loc55_.body2 = _loc3_.getChildAt(_loc14_.@b2) as RefSprite;
                        }
                    }
                    if(_loc14_.@l == "t")
                    {
                        _loc55_.limit = true;
                    }
                    if(_loc14_.@ul != undefined)
                    {
                        _loc55_.upperLimit = int(_loc14_.@ul);
                    }
                    if(_loc14_.@ll != undefined)
                    {
                        _loc55_.lowerLimit = int(_loc14_.@ll);
                    }
                    if(_loc14_.@m == "t")
                    {
                        _loc55_.motor = true;
                    }
                    if(_loc14_.@fo != undefined)
                    {
                        _loc55_.force = Number(_loc14_.@fo);
                    }
                    if(_loc14_.@sp != undefined)
                    {
                        _loc55_.speed = Number(_loc14_.@sp);
                    }
                    if(_loc14_.@c == "t")
                    {
                        _loc55_.collideSelf = true;
                    }
                    if(_loc14_.@v == "f")
                    {
                        _loc55_.vehicleControlled = false;
                    }
                    _loc55_.drawArms();
                }
                _loc22_++;
            }
            _loc25_ = int(_loc13_.length());
            _loc22_ = 0;
            while(_loc22_ < _loc25_)
            {
                _loc56_ = new RefTrigger();
                _loc7_.addChild(_loc56_);
                _loc22_++;
            }
            _loc22_ = 0;
            while(_loc22_ < _loc25_)
            {
                _loc14_ = _loc13_[_loc22_];
                _loc56_ = _loc7_.getChildAt(_loc22_) as RefTrigger;
                _loc56_.x = _loc14_.@x;
                _loc56_.y = _loc14_.@y;
                _loc56_.angle = _loc14_.@a;
                _loc56_.shapeWidth = _loc14_.@w;
                _loc56_.shapeHeight = _loc14_.@h;
                _loc56_.triggeredBy = _loc14_.@b;
                _loc56_.typeIndex = _loc14_.@t;
                _loc56_.repeatType = _loc14_.@r;
                if(_loc14_.@sd == "t")
                {
                    _loc56_.startDisabled = true;
                }
                if(_loc56_.repeatType > 2)
                {
                    _loc56_.repeatInterval = _loc14_.@i;
                }
                _loc57_ = _loc56_.typeIndex == 1 || _loc56_.triggeredBy == 4 ? true : false;
                _loc58_ = _loc56_.typeIndex == 1 ? true : false;
                if(_loc56_.typeIndex == 1)
                {
                    _loc56_.triggerDelay = _loc14_.@d;
                }
                else if(_loc56_.typeIndex == 2)
                {
                    _loc56_.soundEffect = SoundList.instance.sfxLookup[int(_loc14_.@s)];
                    _loc56_.triggerDelay = _loc14_.@d;
                    _loc56_.volume = _loc14_.@v;
                    _loc56_.soundLocation = _loc14_.@l;
                    _loc56_.panning = _loc14_.@p;
                }
                else if(_loc56_.typeIndex == 3)
                {
                    _loc56_.triggerDelay = 0;
                }
                if(_loc57_)
                {
                    _loc59_ = _loc14_.children();
                    _loc23_ = 0;
                    while(_loc23_ < _loc59_.length())
                    {
                        _loc61_ = _loc59_[_loc23_];
                        _loc62_ = _loc61_.name();
                        _loc63_ = null;
                        _loc64_ = null;
                        _loc65_ = null;
                        _loc54_ = int(_loc61_.@i);
                        if(_loc62_ == "sh")
                        {
                            _loc60_ = _loc3_.getChildAt(_loc54_) as RefSprite;
                        }
                        else if(_loc62_ == "sp")
                        {
                            _loc60_ = _loc5_.getChildAt(_loc54_) as RefSprite;
                        }
                        else if(_loc62_ == "g")
                        {
                            _loc60_ = _loc6_.getChildAt(_loc54_) as RefSprite;
                        }
                        else if(_loc62_ == "j")
                        {
                            _loc60_ = _loc4_.getChildAt(_loc54_) as RefSprite;
                        }
                        else
                        {
                            _loc62_ = "t";
                            if(!_loc62_)
                            {
                                throw new Error("what the fuck is this target?");
                            }
                            _loc60_ = _loc7_.getChildAt(_loc54_) as RefSprite;
                        }
                        if(_loc58_)
                        {
                            _loc63_ = _loc60_.triggerActionList;
                            _loc64_ = _loc60_.triggerActionListProperties;
                            if(_loc63_)
                            {
                                if(this._levelVersion < 1.87)
                                {
                                    _loc66_ = int(_loc61_.@a);
                                    _loc67_ = _loc63_[_loc66_];
                                    _loc60_.triggerActions[_loc56_] = [_loc67_];
                                    _loc65_ = !!_loc64_ ? _loc64_[_loc66_] : null;
                                    if(_loc65_)
                                    {
                                        _loc51_ = 0;
                                        while(_loc51_ < _loc65_.length)
                                        {
                                            _loc18_ = _loc65_[_loc51_];
                                            _loc68_ = _loc60_.keyedPropertyObject[_loc18_];
                                            if(!_loc68_)
                                            {
                                                _loc68_ = _loc60_.keyedPropertyObject[_loc18_] = new Dictionary();
                                            }
                                            _loc21_ = _loc61_.attribute("p" + _loc51_);
                                            if(_loc21_ == "t" || _loc21_ == "f")
                                            {
                                                _loc68_[_loc56_] = _loc21_ == "t" ? [true] : [false];
                                            }
                                            else if(_loc21_ != "")
                                            {
                                                _loc68_[_loc56_] = [_loc21_];
                                            }
                                            _loc51_++;
                                        }
                                    }
                                }
                                else
                                {
                                    _loc69_ = _loc61_.children();
                                    _loc70_ = _loc60_.triggerActions[_loc56_];
                                    if(!_loc70_)
                                    {
                                        _loc70_ = _loc60_.triggerActions[_loc56_] = new Array();
                                    }
                                    _loc71_ = 0;
                                    while(_loc71_ < _loc69_.length())
                                    {
                                        _loc72_ = _loc69_[_loc71_];
                                        _loc66_ = int(_loc72_.@i);
                                        if(_loc63_)
                                        {
                                            _loc67_ = _loc63_[_loc66_];
                                            _loc70_.push(_loc67_);
                                            _loc65_ = !!_loc64_ ? _loc64_[_loc66_] : null;
                                            if(_loc65_)
                                            {
                                                _loc51_ = 0;
                                                while(_loc51_ < _loc65_.length)
                                                {
                                                    _loc18_ = _loc65_[_loc51_];
                                                    _loc68_ = _loc60_.keyedPropertyObject[_loc18_];
                                                    if(!_loc68_)
                                                    {
                                                        _loc68_ = _loc60_.keyedPropertyObject[_loc18_] = new Dictionary();
                                                    }
                                                    _loc73_ = _loc68_[_loc56_];
                                                    if(!_loc73_)
                                                    {
                                                        _loc73_ = _loc68_[_loc56_] = new Array();
                                                    }
                                                    _loc21_ = _loc72_.attribute("p" + _loc51_);
                                                    if(_loc21_ == "t" || _loc21_ == "f")
                                                    {
                                                        _loc73_[_loc71_] = _loc21_ == "t" ? true : false;
                                                    }
                                                    else
                                                    {
                                                        _loc73_[_loc71_] = _loc21_;
                                                    }
                                                    _loc51_++;
                                                }
                                            }
                                        }
                                        _loc71_++;
                                    }
                                }
                            }
                        }
                        _loc56_.addTarget(_loc60_);
                        _loc23_++;
                    }
                }
                _loc56_.x = _loc14_.@x;
                _loc56_.y = _loc14_.@y;
                _loc22_++;
            }
            var _loc30_:StartPlaceHolder = new StartPlaceHolder();
            _loc2_.addChild(_loc30_);
            _loc30_.x = _loc8_.@x;
            _loc30_.y = _loc8_.@y;
            _loc30_.characterIndex = _loc8_.@c;
            _loc30_.hideVehicle = _loc8_.@h == "t" ? true : false;
            Settings.hideVehicle = _loc30_.hideVehicle;
            Settings.bdIndex = _loc8_.@bg;
            if(_loc8_.@bgc.length() > 0)
            {
                Settings.bdColor = _loc8_.@bgc;
            }
            else
            {
                Settings.bdColor = 16777215;
            }
            return _loc2_;
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
        
        protected function buildRefShape(param1:XML) : RefShape
        {
            return null;
        }
        
        public function get levelVersion() : Number
        {
            return this._levelVersion;
        }
        
        public function get errorString() : String
        {
            return this._errorString;
        }
    }
}

