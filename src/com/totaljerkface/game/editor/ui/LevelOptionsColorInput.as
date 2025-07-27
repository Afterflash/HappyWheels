package com.totaljerkface.game.editor.ui
{
    import flash.text.AntiAliasType;
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
    import flash.text.TextFormat;
    import flash.text.TextFormatAlign;
    
    public class LevelOptionsColorInput extends ColorInput
    {
        public function LevelOptionsColorInput(param1:String, param2:String, param3:Boolean, param4:Boolean = false)
        {
            super(param1,param2,param3,param4);
        }
        
        override protected function createLabel(param1:String) : void
        {
            var _loc2_:TextFormat = new TextFormat("HelveticaNeueLT Std Med",12,16777215,null,null,null,null,null,TextFormatAlign.LEFT);
            labelText = new TextField();
            labelText.defaultTextFormat = _loc2_;
            labelText.autoSize = TextFieldAutoSize.LEFT;
            labelText.width = 10;
            labelText.height = 17;
            labelText.x = 0;
            labelText.y = 0;
            labelText.multiline = false;
            labelText.selectable = false;
            labelText.embedFonts = true;
            labelText.antiAliasType = AntiAliasType.ADVANCED;
            labelText.text = param1 + ":";
            addChild(labelText);
            colorBorder.x = 108;
            noColorSprite.x = 117.5;
        }
    }
}

