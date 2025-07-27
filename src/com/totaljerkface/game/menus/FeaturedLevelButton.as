package com.totaljerkface.game.menus
{
    import com.totaljerkface.game.utils.TextUtils;
    import flash.display.Sprite;
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;

    [Embed(source="/_assets/assets.swf", symbol="symbol645")]
    public class FeaturedLevelButton extends Sprite
    {
        public var nameMC:Sprite;

        public var bg:Sprite;

        public var newStar:NewStar;

        private var nameText:TextField;

        private var _selected:Boolean;

        public function FeaturedLevelButton(param1:String, param2:Boolean = false)
        {
            super();
            this.nameText = this.nameMC.getChildByName("nameText") as TextField;
            this.nameText.autoSize = TextFieldAutoSize.CENTER;
            this.nameText.wordWrap = false;
            this.nameText.selectable = false;
            this.nameText.embedFonts = true;
            if (param1 != null)
            {
                this.nameText.htmlText = "<b>" + TextUtils.trimWhitespace(param1) + "</b>";
            }
            buttonMode = true;
            mouseChildren = false;
            this.selected = false;
            if (this.nameMC.width > this.bg.width - 30)
            {
                this.nameMC.width = this.bg.width - 30;
                this.nameMC.scaleY = this.nameMC.scaleX;
            }
            if (!param2)
            {
                removeChild(this.newStar);
                this.newStar = null;
            }
        }

        public function get selected():Boolean
        {
            return this._selected;
        }

        public function set selected(param1:Boolean):void
        {
            this._selected = param1;
            if (this._selected)
            {
                this.nameText.textColor = 16777215;
            }
            else
            {
                this.nameText.textColor = 2050921;
            }
        }

        override public function get height():Number
        {
            return this.bg.height;
        }
    }
}
