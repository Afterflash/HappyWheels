package com.totaljerkface.game.menus
{
    import com.totaljerkface.game.sound.SoundController;
    import flash.display.Sprite;
    import flash.events.MouseEvent;
    import flash.filters.DropShadowFilter;
    import flash.text.AntiAliasType;
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
    import flash.text.TextFormat;
    import flash.text.TextFormatAlign;
    import gs.TweenLite;
    import gs.easing.Strong;
    
    public class MainSelectionButton extends Sprite
    {
        private var textField:TextField;
        
        private var hitBox:Sprite;
        
        private var tweenTime:Number = 0.4;
        
        private var maxScale:Number = 1.5;
        
        public function MainSelectionButton(param1:String, param2:int, param3:uint)
        {
            super();
            buttonMode = true;
            tabEnabled = false;
            this.createTextField(param2,param3);
            this.textField.htmlText = param1;
            this.createHitBox();
            var _loc4_:DropShadowFilter = new DropShadowFilter(3,90,0,1,5,5,0.25,1);
            this.textField.filters = [_loc4_];
            addEventListener(MouseEvent.ROLL_OVER,this.rollOverHandler,false,0,true);
            addEventListener(MouseEvent.ROLL_OUT,this.rollOutHandler,false,0,true);
        }
        
        private function rollOverHandler(param1:MouseEvent) : void
        {
            TweenLite.to(this,this.tweenTime,{
                "scaleX":this.maxScale,
                "scaleY":this.maxScale,
                "ease":Strong.easeInOut
            });
            SoundController.instance.playSoundItem("SwishUp");
        }
        
        private function rollOutHandler(param1:MouseEvent) : void
        {
            TweenLite.to(this,this.tweenTime,{
                "scaleX":1,
                "scaleY":1,
                "ease":Strong.easeInOut
            });
        }
        
        private function createTextField(param1:int, param2:uint) : void
        {
            var _loc3_:TextFormat = new TextFormat("Clarendon LT Std",param1,param2,true,null,null,null,null,TextFormatAlign.RIGHT);
            this.textField = new TextField();
            this.textField.defaultTextFormat = _loc3_;
            this.textField.width = 0;
            this.textField.height = 20;
            this.textField.autoSize = TextFieldAutoSize.RIGHT;
            this.textField.x = 0;
            this.textField.y = 0;
            this.textField.multiline = true;
            this.textField.wordWrap = false;
            this.textField.selectable = false;
            this.textField.embedFonts = true;
            this.textField.antiAliasType = AntiAliasType.NORMAL;
            this.textField.mouseEnabled = false;
            addChild(this.textField);
        }
        
        private function createHitBox() : void
        {
            var _loc3_:Number = NaN;
            var _loc1_:Number = this.textField.height;
            var _loc2_:Number = _loc1_ * 0.55;
            _loc3_ = (_loc1_ - _loc2_) / 2;
            this.hitBox = new Sprite();
            this.hitBox.graphics.beginFill(16711680);
            this.hitBox.graphics.drawRect(0,0,this.textField.width,_loc2_);
            this.hitBox.graphics.endFill();
            this.hitBox.x = -this.hitBox.width;
            this.textField.y = -_loc3_;
            addChild(this.hitBox);
            hitArea = this.hitBox;
            this.hitBox.visible = false;
        }
        
        override public function get height() : Number
        {
            return this.hitBox.height * scaleX;
        }
        
        public function addArrow() : void
        {
            var _loc1_:Sprite = null;
            _loc1_ = new BigArrow();
            _loc1_.x = -this.textField.width - 5;
            _loc1_.y = 8;
            addChild(_loc1_);
        }
        
        public function die() : void
        {
            removeEventListener(MouseEvent.ROLL_OVER,this.rollOverHandler);
            removeEventListener(MouseEvent.ROLL_OUT,this.rollOutHandler);
        }
    }
}

