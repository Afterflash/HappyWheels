package com.totaljerkface.game.editor.ui
{
    import com.totaljerkface.game.Settings;
    import com.totaljerkface.game.editor.MouseHelper;
    import flash.display.*;
    import flash.events.*;
    import flash.filters.DropShadowFilter;
    import flash.geom.Point;
    import flash.text.*;
    import flash.ui.Mouse;
    
    public class ColorSelector extends Sprite
    {
        public static var swatches:Array;
        
        public static const COLOR_SELECTED:String = "colorselected";
        
        public static const ROLL_OUT:String = "rollout";
        
        private var bg:Sprite;
        
        private var bgWidth:int = 307;
        
        private var bgHeight:int = 185;
        
        private var _startColor:int;
        
        private var _currentColor:int;
        
        private var _selectedColor:int;
        
        private var _currentHue:int = 16711680;
        
        private var huePosition:int = 0;
        
        private var colorSprite:Sprite;
        
        private var colorText:TextField;
        
        private var noColorBtn:Sprite;
        
        private var _minusColor:Boolean;
        
        internal var spectrumSprite:Sprite;
        
        internal var hueSliderSprite:Sprite;
        
        internal var hueSliderBitmap:Bitmap;
        
        internal var hueSliderTab:Sprite;
        
        internal var spectrumBitmap:Bitmap;
        
        internal var spectrumWidth:uint = 128;
        
        internal var sliderHeight:uint = 15;
        
        private var ring:Sprite;
        
        private var prevRing:Sprite;
        
        private var bitmapData:BitmapData;
        
        private var blocker:Sprite;
        
        private var colorSquares:Array;
        
        private var currentSwatch:ColorSquare;
        
        private var swatchOutline:Sprite;
        
        private var swatchColumnLength:int = 16;
        
        private var swatchSize:int = 10;
        
        private var swatchSpacer:int = 0;
        
        private var swatchMax:int = 128;
        
        private var swatchStartX:Number;
        
        private var swatchStartY:Number;
        
        private var swatchBeginIndex:int = 25;
        
        private var maxSwatches:int = Math.floor(120 / 10) * 16;
        
        private var addSwatchButton:GenericButton;
        
        private var remSwatchButton:GenericButton;
        
        private var dropperButton:LibraryButton;
        
        private var dropperCursor:DropperCursor;
        
        private var tracking:Boolean = false;
        
        private var spectrumTracking:Boolean = false;
        
        public function ColorSelector(param1:int, param2:Boolean)
        {
            super();
            this._startColor = this._currentColor = param1;
            this._minusColor = param2;
            addEventListener(Event.ADDED_TO_STAGE,this.addedToStageHandler);
        }
        
        private function addedToStageHandler(param1:Event) : void
        {
            removeEventListener(Event.ADDED_TO_STAGE,this.addedToStageHandler);
            this.init();
        }
        
        public function init() : void
        {
            var _loc2_:int = 0;
            var _loc3_:Sprite = null;
            var _loc4_:int = 0;
            this.drawBg();
            this.ring = new ColorSpectrumRing();
            this.prevRing = new ColorSpectrumRing();
            this.colorSprite = new Sprite();
            addChild(this.colorSprite);
            this.colorSprite.x = 7;
            this.colorSprite.y = 7;
            this.drawColorSprite();
            this.createTextField();
            if(this._minusColor)
            {
                this.createNoColorBtn();
            }
            var _loc1_:int = 7;
            _loc2_ = 28;
            this.refreshSpectrum();
            this.addHueSlider();
            this.spectrumSprite.x = _loc1_;
            this.spectrumSprite.y = _loc2_;
            this.hueSliderSprite.x = _loc1_;
            this.hueSliderSprite.y = this.spectrumSprite.y + this.spectrumSprite.height + 6;
            this.addSwatches();
            this.spectrumSprite.addChild(this.ring);
            this.spectrumSprite.addChild(this.prevRing);
            this.prevRing.alpha = 0.5;
            this.prevRing.visible = false;
            _loc3_ = new Sprite();
            _loc3_.graphics.beginFill(16711680,0.5);
            _loc3_.graphics.drawRect(0,0,this.spectrumWidth,this.spectrumWidth);
            _loc3_.x = this.spectrumSprite.x;
            _loc3_.y = this.spectrumSprite.y;
            addChild(_loc3_);
            this.spectrumSprite.mask = _loc3_;
            _loc4_ = 23;
            var _loc5_:GenericButton = this.addSwatchButton = new GenericButton("+    ",16777215,_loc4_,0);
            this.remSwatchButton = new GenericButton("-",16777215,_loc4_,0);
            addChild(this.addSwatchButton);
            addChild(this.remSwatchButton);
            this.checkIfColorIsSwatch();
            this.dropperButton = new DropperButton();
            addChild(this.dropperButton);
            this.remSwatchButton.x = this.swatchStartX + this.swatchColumnLength * (this.swatchSize + this.swatchSpacer) - this.remSwatchButton.width;
            var _loc6_:* = this.bg.height - this.remSwatchButton.height - 7;
            this.dropperButton.y = this.bg.height - this.remSwatchButton.height - 7;
            this.remSwatchButton.y = this.addSwatchButton.y = _loc6_;
            this.addSwatchButton.x = this.remSwatchButton.x - (_loc4_ + 5);
            this.dropperButton.x = this.swatchStartX;
            this.showColorInUI();
            this.prevRing.x = this.ring.x;
            this.prevRing.y = this.ring.y;
            this.prevRing.visible = true;
            this.currentColor = this._currentColor;
            this.selectedColor = this._currentColor;
            addEventListener(MouseEvent.MOUSE_OVER,this.mouseOverHandler);
            addEventListener(MouseEvent.MOUSE_DOWN,this.mouseDownHandler);
            addEventListener(MouseEvent.MOUSE_UP,this.mouseUpHandler);
            addEventListener(MouseEvent.MOUSE_MOVE,this.mouseMoveHandler);
            addEventListener(MouseEvent.MOUSE_OUT,this.mouseOutHandler);
            addEventListener(MouseEvent.ROLL_OUT,this.mouseRollOutHander);
            this.colorText.addEventListener(KeyboardEvent.KEY_UP,this.keyUpHandler);
            stage.addEventListener(KeyboardEvent.KEY_UP,this.stageKeyUpHandler);
            this.refreshBitmapData();
        }
        
        private function frameRenderedHandler(param1:Event) : void
        {
            removeEventListener(Event.ENTER_FRAME,this.frameRenderedHandler);
            this.refreshBitmapData();
        }
        
        private function drawBg() : void
        {
            var _loc1_:DropShadowFilter = null;
            if(!this.bg)
            {
                this.bg = new Sprite();
                addChild(this.bg);
                _loc1_ = new DropShadowFilter(7,90,0,1,7,7,0.2,3);
                this.bg.filters = [_loc1_];
            }
            this.bg.graphics.beginFill(10066329);
            this.bg.graphics.drawRect(0,0,this.bgWidth,this.bgHeight);
            this.bg.graphics.endFill();
            this.bg.graphics.beginFill(13421772);
            this.bg.graphics.drawRect(2,2,this.bgWidth - 4,this.bgHeight - 4);
            this.bg.graphics.endFill();
        }
        
        private function createTextField() : void
        {
            var _loc1_:TextFormat = new TextFormat("HelveticaNeueLT Std",11,4032711,null,null,null,null,null,TextFormatAlign.LEFT);
            this.colorText = new TextField();
            this.colorText.defaultTextFormat = _loc1_;
            this.colorText.maxChars = 6;
            this.colorText.type = TextFieldType.INPUT;
            this.colorText.width = 70;
            this.colorText.height = 20;
            this.colorText.x = this.colorSprite.x + this.colorSprite.width + 5;
            this.colorText.y = this.colorSprite.y;
            this.colorText.multiline = false;
            this.colorText.selectable = true;
            this.colorText.embedFonts = true;
            this.colorText.antiAliasType = AntiAliasType.ADVANCED;
            this.colorText.restrict = "1234567890ABCDEF";
            addChild(this.colorText);
        }
        
        private function createNoColorBtn() : void
        {
            this.noColorBtn = new Sprite();
            this.noColorBtn.buttonMode = true;
            this.noColorBtn.tabEnabled = false;
            addChild(this.noColorBtn);
            this.noColorBtn.x = this.bgWidth - 23;
            this.noColorBtn.y = 7;
            this.noColorBtn.graphics.beginFill(16777215);
            this.noColorBtn.graphics.drawRect(0,0,16,16);
            this.noColorBtn.graphics.endFill();
            this.noColorBtn.graphics.beginFill(16711680);
            this.noColorBtn.graphics.moveTo(13.5,0);
            this.noColorBtn.graphics.lineTo(16,0);
            this.noColorBtn.graphics.lineTo(16,2.5);
            this.noColorBtn.graphics.lineTo(2.5,16);
            this.noColorBtn.graphics.lineTo(0,16);
            this.noColorBtn.graphics.lineTo(0,13.5);
            this.noColorBtn.graphics.lineTo(13.5,0);
            this.noColorBtn.graphics.endFill();
        }
        
        private function drawColorSprite() : void
        {
            this.colorSprite.graphics.clear();
            this.colorSprite.graphics.beginFill(this._currentColor);
            this.colorSprite.graphics.drawRect(0,0,36,16);
            this.colorSprite.graphics.endFill();
        }
        
        private function refreshSpectrum() : void
        {
            var _loc3_:Number = NaN;
            var _loc4_:Number = NaN;
            var _loc5_:int = 0;
            var _loc6_:* = 0;
            var _loc8_:Number = 0;
            if(!this.spectrumSprite)
            {
                this.spectrumSprite = new Sprite();
                this.spectrumBitmap = new Bitmap();
                this.spectrumSprite.addChild(this.spectrumBitmap);
                this.spectrumSprite.mouseChildren = false;
                addChild(this.spectrumSprite);
            }
            var _loc1_:int = 16777215;
            var _loc2_:BitmapData = new BitmapData(this.spectrumWidth,this.spectrumWidth,false);
            var _loc7_:Number = 0;
            while(_loc7_ < this.spectrumWidth)
            {
                _loc3_ = _loc7_ / this.spectrumWidth;
                _loc5_ = int(this.interpolateColor(_loc1_,this._currentHue,_loc3_));
                _loc8_ = 0;
                while(_loc8_ < this.spectrumWidth)
                {
                    _loc4_ = _loc8_ / this.spectrumWidth;
                    _loc6_ = this.interpolateColor(_loc5_,0,_loc4_);
                    _loc2_.setPixel(_loc7_,_loc8_,_loc6_);
                    _loc8_++;
                }
                _loc7_++;
            }
            this.spectrumBitmap.bitmapData = _loc2_;
        }
        
        private function addHueSlider() : void
        {
            var _loc4_:Number = 0;
            var _loc1_:Array = this.createSpectrum(this.spectrumWidth);
            this.hueSliderSprite = new Sprite();
            this.hueSliderSprite.mouseChildren = false;
            addChild(this.hueSliderSprite);
            var _loc2_:BitmapData = new BitmapData(this.spectrumWidth,this.sliderHeight,false);
            var _loc3_:Number = 0;
            while(_loc3_ < _loc1_.length)
            {
                _loc4_ = 0;
                while(_loc4_ < this.sliderHeight)
                {
                    _loc2_.setPixel(_loc3_,_loc4_,_loc1_[_loc3_]);
                    _loc4_++;
                }
                _loc3_++;
            }
            this.hueSliderBitmap = new Bitmap(_loc2_);
            this.hueSliderSprite.addChild(this.hueSliderBitmap);
            this.hueSliderTab = new HueSliderTab() as Sprite;
            this.hueSliderSprite.addChild(this.hueSliderTab);
        }
        
        private function addSwatches() : void
        {
            var _loc5_:* = 0;
            var _loc1_:Number = this.swatchStartX = this.spectrumSprite.x + this.spectrumSprite.width + 5;
            var _loc2_:Number = this.swatchStartY = this.spectrumSprite.y;
            if(Settings.sharedObject.data["colorSwatches"])
            {
                ColorSelector.swatches = Settings.sharedObject.data["colorSwatches"];
            }
            else
            {
                ColorSelector.swatches = new Array();
                _loc5_ = 0;
                while(_loc5_ <= 16777215)
                {
                    swatches.push(_loc5_);
                    _loc5_ += 1118481;
                }
                swatches.push(16711680);
                swatches.push(16776960);
                swatches.push(65280);
                swatches.push(65535);
                swatches.push(255);
                swatches.push(16711935);
                swatches.push(4032711);
                swatches.push(16777062);
                swatches.push(16613761);
                Settings.sharedObject.data["colorSwatches"] = swatches;
            }
            var _loc3_:TextFormat = new TextFormat("HelveticaNeueLT Std",11,16777215,null,null,null,null,null,TextFormatAlign.LEFT);
            var _loc4_:TextField = new TextField();
            _loc4_.defaultTextFormat = _loc3_;
            _loc4_.width = 70;
            _loc4_.height = 20;
            _loc4_.x = this.colorSprite.x + this.colorSprite.width + 5;
            _loc4_.y = this.colorSprite.y;
            _loc4_.multiline = false;
            _loc4_.selectable = false;
            _loc4_.embedFonts = true;
            _loc4_.antiAliasType = AntiAliasType.ADVANCED;
            _loc4_.text = "Saved Colors";
            _loc4_.x = this.spectrumSprite.x + this.spectrumWidth + 5;
            _loc4_.y = this.colorText.y;
            addChild(_loc4_);
            this.refreshSwatches();
            this.swatchOutline = new Sprite();
            this.swatchOutline.graphics.lineStyle(1,16777215);
            this.swatchOutline.graphics.drawRect(0,0,this.swatchSize,this.swatchSize);
            this.swatchOutline.visible = false;
            this.swatchOutline.mouseEnabled = false;
            addChild(this.swatchOutline);
        }
        
        public function refreshSwatches() : void
        {
            var _loc1_:ColorSquare = null;
            var _loc4_:Number = 0;
            var _loc5_:ColorSquare = null;
            if(this.colorSquares)
            {
                while(_loc4_ < this.colorSquares.length)
                {
                    _loc5_ = this.colorSquares[_loc4_];
                    removeChild(_loc5_);
                    _loc4_++;
                }
            }
            this.colorSquares = new Array();
            ColorSquare.squareWidth = this.swatchSize;
            var _loc2_:Number = this.swatchStartX;
            var _loc3_:Number = this.swatchStartY;
            _loc4_ = 0;
            while(_loc4_ < swatches.length)
            {
                _loc1_ = new ColorSquare(swatches[_loc4_]);
                _loc1_.x = _loc2_ + _loc4_ % this.swatchColumnLength * (this.swatchSize + this.swatchSpacer);
                _loc1_.y = _loc3_ + Math.floor(_loc4_ / this.swatchColumnLength) * (this.swatchSize + this.swatchSpacer);
                this.colorSquares.push(_loc1_);
                addChild(_loc1_);
                _loc4_++;
            }
            if(this.swatchOutline)
            {
                removeChild(this.swatchOutline);
                addChild(this.swatchOutline);
            }
            Settings.sharedObject.data["colorSwatches"] = swatches;
            this.refreshBitmapData();
        }
        
        public function set currentHue(param1:int) : void
        {
            this._currentHue = param1;
            this.refreshSpectrum();
        }
        
        public function get selectedColor() : int
        {
            return this._selectedColor;
        }
        
        public function set selectedColor(param1:int) : void
        {
            this._selectedColor = param1;
            this.showColorInUI();
            this.commitColor();
        }
        
        private function checkIfColorIsSwatch() : void
        {
            var _loc2_:Number = NaN;
            var _loc3_:Number = NaN;
            var _loc1_:int = int(swatches.indexOf(this.currentColor));
            if(_loc1_ > -1)
            {
                this.addSwatchButton.disabled = true;
                if(_loc1_ >= this.swatchBeginIndex && this.currentColor != -1)
                {
                    this.remSwatchButton.disabled = false;
                }
                else
                {
                    this.remSwatchButton.disabled = true;
                }
                _loc2_ = this.swatchStartX + _loc1_ % this.swatchColumnLength * (this.swatchSize + this.swatchSpacer);
                _loc3_ = this.swatchStartY + Math.floor(_loc1_ / this.swatchColumnLength) * (this.swatchSize + this.swatchSpacer);
                this.swatchOutline.visible = true;
                this.swatchOutline.x = _loc2_;
                this.swatchOutline.y = _loc3_;
            }
            else
            {
                this.swatchOutline.visible = false;
                this.addSwatchButton.disabled = false;
                this.remSwatchButton.disabled = true;
            }
        }
        
        public function get currentColor() : int
        {
            return this._currentColor;
        }
        
        public function set currentColor(param1:int) : void
        {
            var _loc2_:String = null;
            this._currentColor = param1;
            this.drawColorSprite();
            if(this._currentColor < 0)
            {
                this.colorText.text = "";
            }
            else
            {
                _loc2_ = this._currentColor.toString(16).toUpperCase();
                while(_loc2_.length < 6)
                {
                    _loc2_ = "0" + _loc2_;
                }
                this.colorText.text = _loc2_;
            }
            this.checkIfColorIsSwatch();
        }
        
        public function showColorInUI() : void
        {
            var _loc16_:* = undefined;
            var _loc17_:Number = NaN;
            var _loc18_:Number = NaN;
            var _loc19_:Number = NaN;
            var _loc1_:String = this.currentColor.toString(16).toUpperCase();
            if(_loc1_.length < 6)
            {
                _loc1_ = "0" + _loc1_;
            }
            var _loc2_:Object = this.getColorObject();
            var _loc3_:Number = _loc2_.red / 255;
            var _loc4_:Number = _loc2_.green / 255;
            var _loc5_:Number = _loc2_.blue / 255;
            var _loc6_:Number = Math.max(_loc3_,_loc4_,_loc5_);
            var _loc7_:Number = Math.min(_loc3_,_loc4_,_loc5_);
            var _loc8_:Number = _loc6_;
            if(_loc6_ < 1)
            {
                _loc16_ = 1 / _loc6_;
                _loc17_ = _loc2_.red * _loc16_;
                _loc18_ = _loc2_.green * _loc16_;
                _loc19_ = _loc2_.blue * _loc16_;
            }
            else
            {
                _loc17_ = Number(_loc2_.red);
                _loc18_ = Number(_loc2_.green);
                _loc19_ = Number(_loc2_.blue);
            }
            var _loc9_:Number = Math.min(_loc17_,_loc18_,_loc19_);
            var _loc10_:Number = (255 - _loc9_) / 255;
            if(_loc9_ > 0)
            {
                _loc16_ = 255 / (255 - _loc9_);
                _loc17_ = (_loc17_ - _loc9_) * _loc16_;
                _loc18_ = (_loc18_ - _loc9_) * _loc16_;
                _loc19_ = (_loc19_ - _loc9_) * _loc16_;
            }
            var _loc11_:Number = Math.atan2(Math.sqrt(3) * (_loc18_ - _loc19_),2 * _loc17_ - _loc18_ - _loc19_);
            if(isNaN(_loc11_))
            {
                _loc11_ = 0;
            }
            if(_loc11_ < 0)
            {
                _loc11_ += Math.PI * 2;
            }
            var _loc12_:Number = _loc11_ * 180 / Math.PI;
            this.currentHue = this.intForHueValue(_loc12_);
            this.ring.x = Math.round(this.spectrumWidth * _loc10_);
            this.ring.y = Math.round(this.spectrumWidth * (1 - _loc8_));
            this.prevRing.x = this.ring.x;
            this.prevRing.y = this.ring.y;
            var _loc13_:Number = _loc11_ / (Math.PI * 2) * this.spectrumWidth;
            this.hueSliderTab.x = _loc13_;
            var _loc14_:Number = _loc13_ / this.spectrumWidth;
            var _loc15_:Number = Math.round(_loc14_ * 360);
            this.huePosition = _loc15_;
        }
        
        protected function getColorObject() : Object
        {
            var _loc1_:Object = new Object();
            var _loc2_:String = this.currentColor.toString(16);
            while(_loc2_.length < 6)
            {
                _loc2_ = "0" + _loc2_;
            }
            _loc1_.red = uint("0x" + _loc2_.substring(0,2));
            _loc1_.green = uint("0x" + _loc2_.substr(2,2));
            _loc1_.blue = uint("0x" + _loc2_.substr(4,2));
            return _loc1_;
        }
        
        private function refreshBitmapData() : void
        {
            trace("refresh bitmap data");
            this.bitmapData = new BitmapData(stage.stageWidth,stage.stageHeight);
            this.bitmapData.draw(stage);
        }
        
        private function commitColor(param1:Point = null) : void
        {
            Mouse.show();
            dispatchEvent(new Event(COLOR_SELECTED));
        }
        
        private function mouseOverHandler(param1:MouseEvent) : void
        {
            if(this.tracking)
            {
                return;
            }
            if(this.spectrumTracking)
            {
                if(param1.target != this.blocker)
                {
                    if(param1.target is ColorSquare)
                    {
                    }
                }
                return;
            }
            if(param1.target is ColorSquare)
            {
                this.moveSwatchOutline(param1);
            }
            else if(param1.target == this.addSwatchButton)
            {
                MouseHelper.instance.show("save color",this.addSwatchButton);
            }
            else if(param1.target == this.remSwatchButton)
            {
                MouseHelper.instance.show("remove saved color",this.remSwatchButton);
            }
        }
        
        private function mouseMoveHandler(param1:MouseEvent) : void
        {
            if(this.spectrumTracking)
            {
                if(!(param1.target is ColorSquare))
                {
                    if(param1.target == this.blocker)
                    {
                    }
                }
                return;
            }
        }
        
        private function moveSwatchOutline(param1:MouseEvent) : *
        {
            var _loc2_:ColorSquare = param1.target as ColorSquare;
            this.currentColor = _loc2_.color;
            this.swatchOutline.visible = true;
            this.swatchOutline.x = _loc2_.x;
            this.swatchOutline.y = _loc2_.y;
        }
        
        private function mouseDownHandler(param1:MouseEvent) : void
        {
            switch(param1.target)
            {
                case this.spectrumSprite:
                    Mouse.hide();
                    this.colorText.mouseEnabled = false;
                    this.spectrumTracking = true;
                    stage.addEventListener(MouseEvent.MOUSE_UP,this.mouseUpHandler);
                    stage.addEventListener(MouseEvent.MOUSE_MOVE,this.spectrumMouseTrack);
                    this.spectrumMouseTrack(param1);
                    break;
                case this.hueSliderSprite:
                    this.tracking = true;
                    stage.addEventListener(MouseEvent.MOUSE_UP,this.mouseUpHandler);
                    stage.addEventListener(MouseEvent.MOUSE_MOVE,this.mouseTrack);
                    this.mouseTrack(param1);
            }
        }
        
        private function setColorForSpectrumPosition(param1:Point = null) : void
        {
            var _loc2_:Point = null;
            if(param1)
            {
                _loc2_ = this.spectrumSprite.globalToLocal(param1);
            }
            else
            {
                _loc2_ = this.spectrumSprite.globalToLocal(new Point(stage.mouseX,stage.mouseY));
                this.ring.x = Math.max(0,Math.min(_loc2_.x,this.spectrumWidth));
                this.ring.y = Math.max(0,Math.min(_loc2_.y,this.spectrumWidth));
            }
            var _loc3_:Number = this.ring.x / this.spectrumWidth;
            var _loc4_:Number = 1 - this.ring.y / this.spectrumWidth;
            var _loc9_:* = _loc5_[0] * 255;
            var _loc5_:Array = this.HSVtoRGB(this.huePosition,_loc3_,_loc4_);
            _loc5_[0] = _loc5_[0] * 255;
            var _loc6_:Number = _loc9_;
            _loc9_ = _loc5_[1] * 255;
            _loc5_[1] *= 255;
            var _loc7_:Number = _loc9_;
            _loc9_ = _loc5_[2] * 255;
            _loc5_[2] *= 255;
            var _loc8_:Number = _loc9_;
            this.currentColor = _loc6_ << 16 | _loc7_ << 8 | _loc8_;
        }
        
        private function mouseRollOutHander(param1:MouseEvent) : void
        {
            dispatchEvent(new Event(ColorSelector.ROLL_OUT));
        }
        
        private function mouseOutHandler(param1:MouseEvent) : void
        {
            var _loc2_:ColorSquare = null;
            if(param1.target is ColorSquare)
            {
                if(!this.spectrumTracking)
                {
                    _loc2_ = param1.target as ColorSquare;
                    this.currentColor = this.selectedColor;
                }
            }
            else if(param1.target == this.spectrumSprite)
            {
                Mouse.show();
            }
            else if(param1.target != this.blocker)
            {
                if(param1.target == this.bg)
                {
                }
            }
        }
        
        private function mouseUpHandler(param1:MouseEvent) : void
        {
            var _loc2_:ColorSquare = null;
            this.colorText.mouseEnabled = true;
            if(this.tracking)
            {
                this.tracking = false;
                stage.removeEventListener(MouseEvent.MOUSE_UP,this.mouseUpHandler);
                stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.mouseTrack);
                return;
            }
            if(this.spectrumTracking)
            {
                this.spectrumTracking = false;
                stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.spectrumMouseTrack);
                stage.removeEventListener(MouseEvent.MOUSE_UP,this.mouseUpHandler);
                if(param1.target != this.blocker)
                {
                    if(param1.target is ColorSquare)
                    {
                        _loc2_ = param1.target as ColorSquare;
                        this.currentSwatch = _loc2_;
                        this.currentColor = _loc2_.color;
                    }
                }
                this.selectedColor = this.currentColor;
                Mouse.show();
                return;
            }
            if(param1.target == this.spectrumSprite)
            {
                this.setColorForSpectrumPosition();
                this.commitColor();
            }
            else if(param1.target == this.addSwatchButton)
            {
                this.addSwatchToSwatches(this.currentColor);
                this.addSwatchButton.disabled = true;
            }
            else if(param1.target == this.remSwatchButton)
            {
                this.removeSwatchFromSwatches(this.currentColor);
                this.addSwatchButton.disabled = false;
                this.remSwatchButton.disabled = true;
            }
            else if(param1.target is ColorSquare)
            {
                _loc2_ = param1.target as ColorSquare;
                this.currentSwatch = _loc2_;
                this.currentColor = _loc2_.color;
                this.selectedColor = this.currentColor;
            }
            else if(param1.target == this.colorSprite)
            {
                dispatchEvent(new Event(ColorSelector.ROLL_OUT));
            }
            else if(param1.target == this.noColorBtn)
            {
                this._currentColor = -1;
                dispatchEvent(new Event(ROLL_OUT));
            }
            else if(param1.target == this.dropperButton)
            {
                removeEventListener(MouseEvent.ROLL_OUT,this.mouseRollOutHander);
                removeEventListener(MouseEvent.MOUSE_OVER,this.mouseOverHandler);
                removeEventListener(MouseEvent.MOUSE_DOWN,this.mouseDownHandler);
                removeEventListener(MouseEvent.MOUSE_UP,this.mouseUpHandler);
                removeEventListener(MouseEvent.MOUSE_MOVE,this.mouseMoveHandler);
                removeEventListener(MouseEvent.MOUSE_OUT,this.mouseOutHandler);
                stage.removeEventListener(MouseEvent.MOUSE_UP,this.mouseUpHandler);
                stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.mouseTrack);
                stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.spectrumMouseTrack);
                this.colorText.removeEventListener(KeyboardEvent.KEY_UP,this.keyUpHandler);
                this.refreshBitmapData();
                this.dropperCursor = new com.totaljerkface.game.editor.ui.DropperCursor();
                stage.addChild(this.dropperCursor);
                Mouse.hide();
                this.blocker = new Sprite();
                stage.addChild(this.blocker);
                this.blocker.graphics.beginFill(0,0);
                this.blocker.graphics.drawRect(0,0,stage.stageWidth,stage.stageHeight);
                addEventListener(Event.ENTER_FRAME,this.setDropper);
                this.blocker.addEventListener(MouseEvent.MOUSE_UP,this.blockerUpHandler);
            }
        }
        
        private function setDropper(param1:Event) : void
        {
            this.dropperCursor.x = stage.mouseX;
            this.dropperCursor.y = stage.mouseY;
            this.dropperCursor.color = this.bitmapData.getPixel(stage.mouseX,stage.mouseY);
        }
        
        private function blockerUpHandler(param1:MouseEvent) : void
        {
            removeEventListener(Event.ENTER_FRAME,this.setDropper);
            this.blocker.removeEventListener(MouseEvent.MOUSE_UP,this.blockerUpHandler);
            this.currentColor = this.bitmapData.getPixel(stage.mouseX,stage.mouseY);
            this.commitColor();
            dispatchEvent(new Event(ColorSelector.ROLL_OUT));
        }
        
        private function addSwatchToSwatches(param1:uint) : void
        {
            if(swatches.length == this.maxSwatches)
            {
                swatches.splice(this.swatchBeginIndex,1);
                swatches.push(param1);
            }
            else
            {
                swatches.push(param1);
            }
            this.refreshSwatches();
        }
        
        private function removeSwatchFromSwatches(param1:int) : void
        {
            var _loc2_:int = int(swatches.indexOf(param1));
            if(_loc2_ > -1)
            {
                this.swatchOutline.visible = false;
                swatches.splice(_loc2_,1);
                this.refreshSwatches();
            }
            else
            {
                trace("ERROR REMOVING SWATCH: swatch was not found in array");
            }
        }
        
        private function ringTrack() : void
        {
        }
        
        private function mouseTrack(param1:MouseEvent) : void
        {
            var _loc2_:Number = this.hueSliderSprite.globalToLocal(new Point(stage.mouseX,stage.mouseY)).x;
            var _loc3_:Number = Math.max(0,Math.min(_loc2_ / this.spectrumWidth,1));
            this.moveTab(_loc3_);
            var _loc4_:Number = Math.round(_loc3_ * 360);
            this.huePosition = _loc4_;
            this.currentHue = this.intForHueValue(_loc4_);
            this.setColorForSpectrumPosition(new Point(this.ring.x,this.ring.y));
        }
        
        private function spectrumMouseTrack(param1:MouseEvent) : void
        {
            this.setColorForSpectrumPosition();
        }
        
        private function moveTab(param1:Number) : void
        {
            this.hueSliderTab.x = Math.floor(param1 * this.spectrumWidth);
        }
        
        private function stageKeyUpHandler(param1:KeyboardEvent) : void
        {
            trace("charCode: " + param1.charCode + " keyCode: " + param1.keyCode);
            if(param1.keyCode == 27)
            {
                this.currentColor = this._startColor;
                this.commitColor();
                dispatchEvent(new Event(ColorSelector.ROLL_OUT));
            }
            else
            {
                this.refreshBitmapData();
            }
        }
        
        private function keyUpHandler(param1:KeyboardEvent) : void
        {
            trace(param1.charCode);
            this.refreshBitmapData();
            this._currentColor = int("0x" + this.colorText.text);
            this.drawColorSprite();
            if(param1.keyCode == 13)
            {
                this.commitColor();
                this.showColorInUI();
            }
        }
        
        public function die() : void
        {
            trace("color selector die");
            if(this.dropperCursor)
            {
                removeEventListener(Event.ENTER_FRAME,this.setDropper);
                stage.removeChild(this.dropperCursor);
                this.dropperCursor = null;
            }
            if(this.blocker)
            {
                this.blocker.removeEventListener(MouseEvent.MOUSE_UP,this.blockerUpHandler);
                stage.removeChild(this.blocker);
            }
            removeEventListener(MouseEvent.ROLL_OUT,this.mouseRollOutHander);
            removeEventListener(MouseEvent.MOUSE_OVER,this.mouseOverHandler);
            removeEventListener(MouseEvent.MOUSE_DOWN,this.mouseDownHandler);
            removeEventListener(MouseEvent.MOUSE_UP,this.mouseUpHandler);
            removeEventListener(MouseEvent.MOUSE_MOVE,this.mouseMoveHandler);
            removeEventListener(MouseEvent.MOUSE_OUT,this.mouseOutHandler);
            stage.removeEventListener(MouseEvent.MOUSE_UP,this.mouseUpHandler);
            stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.mouseTrack);
            stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.spectrumMouseTrack);
            stage.removeEventListener(KeyboardEvent.KEY_UP,this.stageKeyUpHandler);
            this.colorText.removeEventListener(KeyboardEvent.KEY_UP,this.keyUpHandler);
            stage.focus = stage;
        }
        
        private function HSVtoRGB(param1:Number, param2:Number, param3:Number) : Array
        {
            var _loc4_:int = 0;
            var _loc5_:Number = NaN;
            var _loc6_:Number = NaN;
            var _loc7_:Number = NaN;
            var _loc8_:Number = NaN;
            var _loc9_:Number = NaN;
            var _loc10_:Number = NaN;
            var _loc11_:Number = NaN;
            param1 %= 360;
            if(param2 == 0)
            {
                _loc9_ = _loc10_ = _loc11_ = param3;
                return [_loc9_,_loc10_,_loc11_];
            }
            param1 /= 60;
            _loc4_ = Math.floor(param1);
            _loc5_ = param1 - _loc4_;
            _loc6_ = param3 * (1 - param2);
            _loc7_ = param3 * (1 - param2 * _loc5_);
            _loc8_ = param3 * (1 - param2 * (1 - _loc5_));
            switch(_loc4_)
            {
                case 0:
                    _loc9_ = param3;
                    _loc10_ = _loc8_;
                    _loc11_ = _loc6_;
                    break;
                case 1:
                    _loc9_ = _loc7_;
                    _loc10_ = param3;
                    _loc11_ = _loc6_;
                    break;
                case 2:
                    _loc9_ = _loc6_;
                    _loc10_ = param3;
                    _loc11_ = _loc8_;
                    break;
                case 3:
                    _loc9_ = _loc6_;
                    _loc10_ = _loc7_;
                    _loc11_ = param3;
                    break;
                case 4:
                    _loc9_ = _loc8_;
                    _loc10_ = _loc6_;
                    _loc11_ = param3;
                    break;
                default:
                    _loc9_ = param3;
                    _loc10_ = _loc6_;
                    _loc11_ = _loc7_;
            }
            return [_loc9_,_loc10_,_loc11_];
        }
        
        private function interpolateColor(param1:uint, param2:uint, param3:Number) : uint
        {
            var _loc4_:Number = 1 - param3;
            var _loc5_:uint = uint(param1 >> 24 & 255);
            var _loc6_:uint = uint(param1 >> 16 & 255);
            var _loc7_:uint = uint(param1 >> 8 & 255);
            var _loc8_:uint = uint(param1 & 255);
            var _loc9_:uint = uint(param2 >> 24 & 255);
            var _loc10_:uint = uint(param2 >> 16 & 255);
            var _loc11_:uint = uint(param2 >> 8 & 255);
            var _loc12_:uint = uint(param2 & 255);
            var _loc13_:uint = _loc5_ * _loc4_ + _loc9_ * param3;
            var _loc14_:uint = _loc6_ * _loc4_ + _loc10_ * param3;
            var _loc15_:uint = _loc7_ * _loc4_ + _loc11_ * param3;
            var _loc16_:uint = _loc8_ * _loc4_ + _loc12_ * param3;
            return uint(_loc13_ << 24 | _loc14_ << 16 | _loc15_ << 8 | _loc16_);
        }
        
        private function intForHueValue(param1:uint, param2:uint = 360) : uint
        {
            var _loc3_:* = 0;
            var _loc4_:* = 0;
            var _loc5_:* = 0;
            var _loc6_:* = 0;
            _loc6_ = Math.floor(param1 % param2);
            if(_loc6_ <= param2 * 1 / 6)
            {
                _loc3_ = 255;
                _loc4_ = this.I(param1,param2);
                _loc5_ = 0;
            }
            if(_loc6_ >= param2 * 1 / 6 && _loc6_ <= param2 * 2 / 6)
            {
                _loc3_ = 255 - this.I(param1,param2);
                _loc4_ = 255;
                _loc5_ = 0;
            }
            if(_loc6_ >= param2 * 2 / 6 && _loc6_ <= param2 * 3 / 6)
            {
                _loc3_ = 0;
                _loc4_ = 255;
                _loc5_ = this.I(param1,param2);
            }
            if(_loc6_ >= param2 * 3 / 6 && _loc6_ <= param2 * 4 / 6)
            {
                _loc3_ = 0;
                _loc4_ = 255 - this.I(param1,param2);
                _loc5_ = 255;
            }
            if(_loc6_ >= param2 * 4 / 6 && _loc6_ <= param2 * 5 / 6)
            {
                _loc3_ = this.I(param1,param2);
                _loc4_ = 0;
                _loc5_ = 255;
            }
            if(_loc6_ >= param2 * 5 / 6)
            {
                _loc3_ = 255;
                _loc4_ = 0;
                _loc5_ = 255 - this.I(param1,param2);
            }
            return _loc3_ << 16 | _loc4_ << 8 | _loc5_;
        }
        
        private function createSpectrum(param1:uint = 100) : Array
        {
            var _loc2_:Array = new Array();
            var _loc3_:int = 0;
            while(_loc3_ < param1)
            {
                _loc2_.push(this.intForHueValue(_loc3_,param1));
                _loc3_++;
            }
            return _loc2_;
        }
        
        private function I(param1:uint, param2:uint) : uint
        {
            return param1 % param2 / (param2 * 1 / 6) * 255 % 255;
        }
    }
}

