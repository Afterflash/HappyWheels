package com.totaljerkface.game.editor.ui
{
    import com.totaljerkface.game.editor.MouseHelper;
    import com.totaljerkface.game.editor.trigger.RefTrigger;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.geom.Point;
    import flash.text.AntiAliasType;
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
    import flash.text.TextFormat;
    import flash.text.TextFormatAlign;
    
    public class ListInput extends InputObject
    {
        protected var labelText:TextField;
        
        protected var valueText:TextField;
        
        private var entryArray:Array;
        
        private var listMenu:ListMenu;
        
        private var _entry:String = "UHH";
        
        private var playSound:Boolean;
        
        private var arrowSprite:Sprite;
        
        private var plusSprite:Sprite;
        
        private var minusSprite:Sprite;
        
        public function ListInput(param1:String, param2:String, param3:Array, param4:Boolean, param5:Boolean, param6:Boolean = false)
        {
            super();
            this.attribute = param2;
            this.entryArray = param3;
            childInputs = new Array();
            this.editable = param5;
            this.playSound = param4;
            _expandable = param6;
            this.createLabel(param1);
            this.init();
        }
        
        private function init() : void
        {
            this.arrowSprite = new Sprite();
            addChild(this.arrowSprite);
            this.arrowSprite.x = 110;
            this.arrowSprite.y = 7;
            this.arrowSprite.graphics.beginFill(4032711);
            this.arrowSprite.graphics.lineTo(10,8);
            this.arrowSprite.graphics.lineTo(0,16);
            this.arrowSprite.graphics.lineTo(0,0);
            this.arrowSprite.graphics.endFill();
            this.arrowSprite.buttonMode = true;
            this.arrowSprite.addEventListener(MouseEvent.MOUSE_UP,this.arrowUpHandler);
            if(_expandable)
            {
                this.drawExpandButton();
            }
        }
        
        private function drawExpandButton() : void
        {
            if(!this.plusSprite)
            {
                this.plusSprite = new Sprite();
                addChild(this.plusSprite);
                this.plusSprite.x = 100.5;
                this.plusSprite.y = 14.5;
                this.plusSprite.buttonMode = true;
                this.plusSprite.addEventListener(MouseEvent.MOUSE_UP,this.expandUpHandler);
                this.plusSprite.addEventListener(MouseEvent.ROLL_OVER,this.expandOverHandler);
            }
            this.plusSprite.graphics.clear();
            this.plusSprite.graphics.beginFill(16777215);
            this.plusSprite.graphics.drawCircle(0,0,4.5);
            this.plusSprite.graphics.endFill();
            if(multipleIndex == 0)
            {
                this.plusSprite.graphics.beginFill(4032711);
                this.plusSprite.graphics.drawRect(-2.5,-0.5,5,1);
                this.plusSprite.graphics.endFill();
                this.plusSprite.graphics.beginFill(4032711);
                this.plusSprite.graphics.drawRect(-0.5,-2.5,1,5);
                this.plusSprite.graphics.endFill();
            }
            else
            {
                this.plusSprite.graphics.beginFill(16613761);
                this.plusSprite.graphics.drawRect(-2.5,-0.5,5,1);
                this.plusSprite.graphics.endFill();
            }
        }
        
        protected function createLabel(param1:String) : void
        {
            var _loc2_:TextFormat = new TextFormat("HelveticaNeueLT Std",11,16777215,null,null,null,null,null,TextFormatAlign.LEFT);
            this.labelText = new TextField();
            this.labelText.defaultTextFormat = _loc2_;
            this.labelText.autoSize = TextFieldAutoSize.LEFT;
            this.labelText.width = 10;
            this.labelText.height = 17;
            this.labelText.x = 0;
            this.labelText.y = 0;
            this.labelText.multiline = false;
            this.labelText.selectable = false;
            this.labelText.embedFonts = true;
            this.labelText.antiAliasType = AntiAliasType.ADVANCED;
            this.labelText.text = param1 + ":";
            addChild(this.labelText);
            _loc2_ = new TextFormat("HelveticaNeueLT Std",11,7895160,null,null,null,null,null,TextFormatAlign.LEFT);
            this.valueText = new TextField();
            this.valueText.defaultTextFormat = _loc2_;
            this.valueText.autoSize = TextFieldAutoSize.LEFT;
            this.valueText.width = 10;
            this.valueText.height = 17;
            this.valueText.x = 0;
            this.valueText.y = Math.ceil(this.labelText.y + this.labelText.height) - 5;
            this.valueText.multiline = false;
            this.valueText.selectable = false;
            this.valueText.embedFonts = true;
            this.valueText.antiAliasType = AntiAliasType.ADVANCED;
            this.valueText.text = "";
            addChild(this.valueText);
        }
        
        public function get entry() : String
        {
            return this._entry;
        }
        
        public function set entry(param1:String) : void
        {
            if(!editable)
            {
                return;
            }
            _ambiguous = false;
            this._entry = param1;
            this.valueText.text = this._entry;
        }
        
        override public function setValue(param1:*) : void
        {
            this.entry = param1;
        }
        
        override public function setToAmbiguous() : void
        {
            this.valueText.text = "-";
            _ambiguous = true;
        }
        
        private function arrowUpHandler(param1:MouseEvent) : void
        {
            if(this.listMenu)
            {
                return;
            }
            this.listMenu = new ListMenu(this.entryArray,this.entry,this.playSound,_ambiguous);
            stage.addChild(this.listMenu);
            var _loc2_:Point = localToGlobal(new Point(this.arrowSprite.x,this.arrowSprite.y));
            this.listMenu.x = _loc2_.x;
            this.listMenu.y = Math.round(_loc2_.y - this.listMenu.height * 0.5) + 8;
            var _loc3_:Number = Math.round(this.listMenu.y + this.listMenu.height);
            if(this.listMenu.y + this.listMenu.height > 500)
            {
                this.listMenu.y = Math.ceil(500 - this.listMenu.height);
            }
            this.listMenu.addEventListener(ListMenu.ITEM_SELECTED,this.itemSelected);
            this.listMenu.addEventListener(MouseEvent.ROLL_OUT,this.closeListMenu);
        }
        
        private function expandUpHandler(param1:MouseEvent) : void
        {
            if(stage)
            {
                stage.focus = stage;
            }
            if(multipleIndex == 0)
            {
                dispatchEvent(new ValueEvent(ValueEvent.ADD_INPUT,this,this.entry));
            }
            else
            {
                dispatchEvent(new ValueEvent(ValueEvent.REMOVE_INPUT,this,this.entry));
            }
        }
        
        private function expandOverHandler(param1:MouseEvent) : void
        {
            var _loc2_:RefTrigger = null;
            var _loc3_:int = 0;
            var _loc4_:int = 0;
            if(multipleIndex == 0)
            {
                _loc2_ = multipleKey as RefTrigger;
                _loc3_ = _loc2_.parent.getChildIndex(_loc2_);
                _loc4_ = _loc3_ + 1;
                MouseHelper.instance.show("add another action for trigger " + _loc4_,this);
            }
        }
        
        private function itemSelected(param1:Event) : void
        {
            this.entry = this.listMenu.selectedEntry;
            dispatchEvent(new ValueEvent(ValueEvent.VALUE_CHANGE,this,this.entry,true));
        }
        
        public function closeListMenu(param1:MouseEvent = null) : void
        {
            if(!this.listMenu)
            {
                return;
            }
            this.listMenu.die();
            this.listMenu.removeEventListener(ListMenu.ITEM_SELECTED,this.itemSelected);
            stage.removeChild(this.listMenu);
            this.listMenu = null;
        }
        
        override public function get height() : Number
        {
            return 31;
        }
        
        override public function set multipleIndex(param1:int) : void
        {
            _multipleIndex = param1;
            this.drawExpandButton();
        }
        
        override public function die() : void
        {
            super.die();
            this.closeListMenu();
            this.arrowSprite.removeEventListener(MouseEvent.MOUSE_UP,this.arrowUpHandler);
            if(this.plusSprite)
            {
                this.plusSprite.removeEventListener(MouseEvent.MOUSE_UP,this.expandUpHandler);
                this.plusSprite.removeEventListener(MouseEvent.ROLL_OVER,this.expandOverHandler);
            }
        }
    }
}

