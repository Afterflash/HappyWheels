package com.totaljerkface.game.editor.ui
{
    import flash.display.Sprite;
    import flash.events.MouseEvent;
    import flash.geom.ColorTransform;
    import flash.text.AntiAliasType;
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
    import flash.text.TextFormat;
    import flash.text.TextFormatAlign;

    [Embed(source="/_assets/assets.swf", symbol="symbol2912")]
    public class XButton extends GenericButton
    {
        public var XSprite:Sprite;

        public function XButton(param1:String, param2:uint, param3:Number, param4:uint = 16777215)
        {
            super(param1, param2, param3, param4);
        }

        override protected function createTextField():void
        {
            var _loc1_:TextFormat = new TextFormat("HelveticaNeueLT Std Med", 12, _txtColor, null, null, null, null, null, TextFormatAlign.CENTER);
            textField = new TextField();
            textField.borderColor = 16711680;
            textField.defaultTextFormat = _loc1_;
            textField.autoSize = TextFieldAutoSize.CENTER;
            textField.height = 20;
            textField.y = 3;
            textField.multiline = false;
            textField.selectable = false;
            textField.embedFonts = true;
            textField.antiAliasType = AntiAliasType.ADVANCED;
            addChild(textField);
            var _loc2_:ColorTransform = this.XSprite.transform.colorTransform;
            _loc2_.color = _txtColor;
            this.XSprite.transform.colorTransform = _loc2_;
        }

        override protected function createBg():void
        {
            textField.width;
            textField.autoSize = TextFieldAutoSize.NONE;
            textField.width = Math.ceil(textField.width + 20);
            textField.x = 0;
            var _loc1_:Number = textField.width + 2;
            this.XSprite.x = _loc1_;
            this.XSprite.y = 11.5;
            _bgWidth = textField.width + 18;
            super.createBg();
        }

        override protected function rollOverHandler(param1:MouseEvent = null):void
        {
            textField.alpha = this.XSprite.alpha = 1;
        }

        override protected function rollOutHandler(param1:MouseEvent = null):void
        {
            if (_selected)
            {
                return;
            }
            textField.alpha = this.XSprite.alpha = offAlpha;
        }
    }
}
