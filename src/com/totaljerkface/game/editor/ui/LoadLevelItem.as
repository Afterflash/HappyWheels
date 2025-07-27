package com.totaljerkface.game.editor.ui
{
    import flash.display.Sprite;
    import flash.text.AntiAliasType;
    import flash.text.TextField;
    import flash.text.TextFormat;
    import flash.text.TextFormatAlign;
    
    public class LoadLevelItem extends Sprite
    {
        private var bg:Sprite;
        
        private var textField:TextField;
        
        private var defColor:uint = 13421772;
        
        private var selColor:uint = 4032711;
        
        private var _selected:Boolean;
        
        public function LoadLevelItem(param1:String)
        {
            super();
            this.createTextField();
            if(param1 != null)
            {
                this.textField.htmlText = "" + param1 + "";
            }
            this.bg = new Sprite();
            addChildAt(this.bg,0);
            buttonMode = true;
            mouseChildren = false;
            this.selected = false;
        }
        
        public function get selected() : Boolean
        {
            return this._selected;
        }
        
        private function createTextField() : void
        {
            var _loc1_:TextFormat = new TextFormat("HelveticaNeueLT Std Med",12,16777215,null,null,null,null,null,TextFormatAlign.LEFT);
            this.textField = new TextField();
            this.textField.defaultTextFormat = _loc1_;
            this.textField.width = 195;
            this.textField.height = 18;
            this.textField.x = 5;
            this.textField.y = 2;
            this.textField.multiline = false;
            this.textField.wordWrap = false;
            this.textField.selectable = false;
            this.textField.embedFonts = true;
            this.textField.antiAliasType = AntiAliasType.ADVANCED;
            addChild(this.textField);
        }
        
        private function drawBg(param1:uint) : void
        {
            this.bg.graphics.clear();
            this.bg.graphics.beginFill(param1);
            this.bg.graphics.drawRect(0,0,200,20);
            this.bg.graphics.endFill();
            this.bg.graphics.lineStyle(0,10066329,1);
            this.bg.graphics.moveTo(0,0);
            this.bg.graphics.lineTo(200,0);
            this.bg.graphics.moveTo(0,20);
            this.bg.graphics.lineTo(200,20);
        }
        
        public function set selected(param1:Boolean) : void
        {
            this._selected = param1;
            if(this._selected)
            {
                this.drawBg(this.selColor);
            }
            else
            {
                this.drawBg(this.defColor);
            }
        }
    }
}

