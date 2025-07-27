package com.totaljerkface.game.menus
{
    import com.totaljerkface.game.editor.ui.SliderInput;
    import flash.events.KeyboardEvent;
    import flash.events.MouseEvent;
    import flash.text.TextFieldAutoSize;

    [Embed(source="/_assets/assets.swf", symbol="symbol407")]
    public class OptionsSlider extends SliderInput
    {
        public function OptionsSlider(param1:String, param2:String, param3:int, param4:Boolean, param5:Number, param6:Number, param7:Number)
        {
            super(param1, param2, param3, param4, param5, param6, param7);
        }

        override protected function init():void
        {
            sliderTab.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
            labelText.mouseEnabled = false;
            removeChild(labelText);
            inputText.wordWrap = labelText.wordWrap = false;
            inputText.autoSize = labelText.autoSize = TextFieldAutoSize.LEFT;
            inputText.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
        }
    }
}
