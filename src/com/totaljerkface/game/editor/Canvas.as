package com.totaljerkface.game.editor
{
    import com.totaljerkface.game.editor.specials.Special;
    import com.totaljerkface.game.editor.specials.StartPlaceHolder;
    import com.totaljerkface.game.editor.trigger.RefTrigger;
    import com.totaljerkface.game.events.CanvasEvent;
    import flash.display.BlendMode;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
    import flash.text.TextFormat;
    import flash.text.TextFormatAlign;
    
    public class Canvas extends Sprite
    {
        public static const SHAPE_LIMIT_STATUS:String = "shapelimitstatus";
        
        public static const ART_LIMIT_STATUS:String = "artlimitstatus";
        
        protected static var _canvasWidth:int = 20000;
        
        protected static var _canvasHeight:int = 10000;
        
        protected static var _backDropIndex:int = 0;
        
        protected static var _backgroundColor:int = 16777215;
        
        protected static var maxShapes:int = 900;
        
        protected static var maxArt:int = 10000;
        
        protected var _shapeCount:int;
        
        protected var _artCount:int;
        
        protected var _tooMuchArt:Boolean;
        
        protected var _tooManyShapes:Boolean;
        
        protected var _mainCanvas:Canvas;
        
        public var startPlaceHolder:StartPlaceHolder;
        
        public var shapes:Sprite;
        
        public var joints:Sprite;
        
        public var triggers:Sprite;
        
        public var special:Sprite;
        
        public var groups:Sprite;
        
        public var char:Sprite;
        
        public var textField:TextField;
        
        public function Canvas()
        {
            super();
            this.init();
        }
        
        public static function get backDropIndex() : int
        {
            return _backDropIndex;
        }
        
        public static function set backDropIndex(param1:int) : void
        {
            _backDropIndex = param1;
        }
        
        public static function get backgroundColor() : int
        {
            return _backgroundColor;
        }
        
        public static function set backgroundColor(param1:int) : void
        {
            _backgroundColor = param1;
        }
        
        public static function get canvasWidth() : int
        {
            return _canvasWidth;
        }
        
        public static function get canvasHeight() : int
        {
            return _canvasHeight;
        }
        
        protected function init() : void
        {
            _canvasWidth = 20000;
            _canvasHeight = 10000;
            _backDropIndex = 0;
            this._shapeCount = 0;
            this._mainCanvas = this;
            graphics.beginFill(16777215);
            graphics.drawRect(0,0,_canvasWidth,_canvasHeight);
            graphics.endFill();
            this.shapes = new Sprite();
            this.shapes.name = "shapes";
            this.joints = new Sprite();
            this.joints.name = "joints";
            this.triggers = new Sprite();
            this.triggers.name = "triggers";
            this.special = new Sprite();
            this.special.name = "special";
            this.groups = new Sprite();
            this.groups.name = "groups";
            this.char = new Sprite();
            this.char.name = "char";
            addChild(this.shapes);
            addChild(this.special);
            addChild(this.groups);
            addChild(this.joints);
            addChild(this.triggers);
            addChild(this.char);
            this.startPlaceHolder = new StartPlaceHolder();
            this.char.addChild(this.startPlaceHolder);
            this.startPlaceHolder.scaleX = this.startPlaceHolder.scaleY = 0.5;
            this.startPlaceHolder.x = 300;
            this.startPlaceHolder.y = 100 + _canvasHeight / 2;
            addEventListener(CanvasEvent.ART,this.artStatusHandler,false,0,true);
            addEventListener(CanvasEvent.SHAPE,this.shapeStatusHandler,false,0,true);
        }
        
        public function createTextField(param1:Sprite) : void
        {
            this.textField = new TextField();
            param1.addChild(this.textField);
            var _loc2_:TextFormat = new TextFormat("HelveticaNeueLT Std",11,0,null,null,null,null,null,TextFormatAlign.RIGHT);
            this.textField.defaultTextFormat = _loc2_;
            this.textField.multiline = true;
            this.textField.height = 20;
            this.textField.width = 0;
            this.textField.x = 890;
            this.textField.y = 465;
            this.textField.mouseEnabled = false;
            this.textField.selectable = false;
            this.textField.embedFonts = true;
            this.textField.autoSize = TextFieldAutoSize.RIGHT;
            this.textField.wordWrap = false;
            this.textField.blendMode = BlendMode.INVERT;
            this.setTextField();
        }
        
        public function addRefSprite(param1:RefSprite) : RefSprite
        {
            if(!(param1 is RefSprite))
            {
                throw new Error("attempted to add non-refsprite to canvas");
            }
            if(param1 is RefShape)
            {
                this.shapes.addChild(param1);
            }
            else if(param1 is Special)
            {
                this.special.addChild(param1);
            }
            else if(param1 is RefJoint)
            {
                this.joints.addChild(param1);
            }
            else if(param1 is RefTrigger)
            {
                this.triggers.addChild(param1);
            }
            else
            {
                if(!(param1 is RefGroup))
                {
                    throw new Error("what the fuck is this");
                }
                this.groups.addChild(param1);
            }
            this.shapeCount = this._mainCanvas.shapeCount + param1.shapesUsed;
            this.tooManyShapes = this._mainCanvas.shapeCount > maxShapes ? true : false;
            this.artCount = this._artCount + param1.artUsed;
            this.tooMuchArt = this._artCount > maxArt ? true : false;
            return param1;
        }
        
        public function addRefSpriteAt(param1:RefSprite, param2:int) : RefSprite
        {
            if(!(param1 is RefSprite))
            {
                throw new Error("attempted to add non-refsprite to canvas");
            }
            if(param1 is RefShape)
            {
                this.shapes.addChildAt(param1,param2);
            }
            else if(param1 is Special)
            {
                this.special.addChildAt(param1,param2);
            }
            else if(param1 is RefJoint)
            {
                this.joints.addChildAt(param1,param2);
            }
            else if(param1 is RefTrigger)
            {
                this.triggers.addChildAt(param1,param2);
            }
            else
            {
                if(!(param1 is RefGroup))
                {
                    throw new Error("what the fuck is this");
                }
                this.groups.addChildAt(param1,param2);
            }
            this.shapeCount = this._mainCanvas.shapeCount + param1.shapesUsed;
            this.tooManyShapes = this._mainCanvas.shapeCount > maxShapes ? true : false;
            this.artCount = this._artCount + param1.artUsed;
            this.tooMuchArt = this._artCount > maxArt ? true : false;
            return param1;
        }
        
        public function removeRefSprite(param1:RefSprite) : RefSprite
        {
            if(!(param1 is RefSprite))
            {
                throw new Error("attempted to remove non-refsprite from canvas");
            }
            var _loc2_:RefSprite = param1 as RefSprite;
            if(_loc2_ is RefShape)
            {
                this.shapes.removeChild(_loc2_);
            }
            else if(_loc2_ is Special)
            {
                this.special.removeChild(_loc2_);
            }
            else if(_loc2_ is RefJoint)
            {
                this.joints.removeChild(_loc2_);
            }
            else if(_loc2_ is RefTrigger)
            {
                this.triggers.removeChild(_loc2_);
            }
            else
            {
                if(!(_loc2_ is RefGroup))
                {
                    throw new Error("what the fuck is this");
                }
                this.groups.removeChild(_loc2_);
            }
            this.shapeCount = this._mainCanvas.shapeCount - param1.shapesUsed;
            this.tooManyShapes = this._mainCanvas.shapeCount > maxShapes ? true : false;
            this.artCount = this._artCount - param1.artUsed;
            this.tooMuchArt = this._artCount > maxArt ? true : false;
            return param1;
        }
        
        public function get shapeCount() : int
        {
            return this._shapeCount;
        }
        
        public function set shapeCount(param1:int) : void
        {
            this._shapeCount = param1;
            this.setTextField();
        }
        
        public function get artCount() : int
        {
            return this._artCount;
        }
        
        public function set artCount(param1:int) : void
        {
            this._artCount = param1;
            this.setTextField();
        }
        
        protected function setTextField() : void
        {
            this.textField.htmlText = "shapes left: " + (maxShapes - this.shapeCount) + "<br>art left: " + (maxArt - this.artCount);
        }
        
        public function get tooManyShapes() : Boolean
        {
            return this._tooManyShapes;
        }
        
        public function set tooManyShapes(param1:Boolean) : void
        {
            if(param1 == this._tooManyShapes)
            {
                return;
            }
            this._tooManyShapes = param1;
            dispatchEvent(new Event(SHAPE_LIMIT_STATUS));
        }
        
        public function get tooMuchArt() : Boolean
        {
            return this._tooMuchArt;
        }
        
        public function set tooMuchArt(param1:Boolean) : void
        {
            if(param1 == this._tooMuchArt)
            {
                return;
            }
            this._tooMuchArt = param1;
            dispatchEvent(new Event(ART_LIMIT_STATUS));
        }
        
        protected function shapeStatusHandler(param1:CanvasEvent) : void
        {
            trace("shape status handler");
            var _loc2_:RefSprite = param1.target as RefSprite;
            if(_loc2_.parent == this.shapes || _loc2_.parent == this.special)
            {
                this.shapeCount = this._mainCanvas.shapeCount + param1.value;
                this.tooManyShapes = this._mainCanvas.shapeCount > maxShapes ? true : false;
            }
            trace("shapecount = " + this._mainCanvas.shapeCount);
        }
        
        protected function artStatusHandler(param1:CanvasEvent) : void
        {
            trace("art status handler");
            var _loc2_:RefSprite = param1.target as RefSprite;
            if(_loc2_.parent == this.shapes || _loc2_.parent == this.special)
            {
                this.artCount = this._artCount + param1.value;
                this.tooMuchArt = this._artCount > maxArt ? true : false;
            }
            trace("artcount = " + this._artCount);
        }
        
        public function relabelTriggers() : void
        {
            var _loc2_:RefTrigger = null;
            var _loc1_:int = 0;
            while(_loc1_ < this.triggers.numChildren)
            {
                _loc2_ = this.triggers.getChildAt(_loc1_) as RefTrigger;
                _loc2_.setNumLabel(_loc1_ + 1);
                _loc1_++;
            }
        }
    }
}

