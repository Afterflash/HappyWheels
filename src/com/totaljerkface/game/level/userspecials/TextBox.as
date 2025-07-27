package com.totaljerkface.game.level.userspecials
{
    import Box2D.Collision.*;
    import Box2D.Collision.Shapes.*;
    import Box2D.Dynamics.*;
    import com.totaljerkface.game.*;
    import com.totaljerkface.game.editor.specials.*;
    import com.totaljerkface.game.events.*;
    import com.totaljerkface.game.level.*;
    import flash.display.*;
    import flash.geom.*;
    import flash.text.*;
    
    public class TextBox extends LevelItem
    {
        protected var textField:TextField;
        
        public function TextBox(param1:Special, param2:b2Body = null, param3:Point = null)
        {
            super();
            var _loc4_:TextBoxRef = param1 as TextBoxRef;
            var _loc5_:TextFormat = new TextFormat(TextBoxRef.getFontName(_loc4_.font),_loc4_.fontSize,_loc4_.color,TextBoxRef.getFontBold(_loc4_.font),null,null,null,null,TextBoxRef.getAlignment(_loc4_.align));
            this.textField = new TextField();
            this.textField.defaultTextFormat = _loc5_;
            this.textField.type = TextFieldType.DYNAMIC;
            this.textField.multiline = true;
            this.textField.autoSize = TextFieldAutoSize.LEFT;
            this.textField.wordWrap = false;
            this.textField.selectable = false;
            this.textField.embedFonts = true;
            this.textField.antiAliasType = AntiAliasType.ADVANCED;
            this.textField.text = _loc4_.caption;
            this.textField.x = _loc4_.x;
            this.textField.y = _loc4_.y;
            this.textField.rotation = _loc4_.rotation;
            if(Settings.currentSession.levelVersion > 1.68)
            {
                this.textField.alpha = _loc4_.opacity * 0.01;
                this.textField.visible = this.textField.alpha == 0 ? false : true;
            }
            var _loc6_:Sprite = Settings.currentSession.level.background;
            _loc6_.addChild(this.textField);
        }
        
        override public function get groupDisplayObject() : DisplayObject
        {
            return this.textField;
        }
        
        override public function prepareForTrigger() : void
        {
            if(Settings.currentSession.levelVersion < 1.69)
            {
                this.textField.visible = false;
            }
            trace("setting textfield to invisible");
        }
        
        override public function triggerSingleActivation(param1:Trigger, param2:String, param3:Array) : void
        {
            this.textField.visible = true;
        }
        
        override public function triggerRepeatActivation(param1:Trigger, param2:String, param3:Array, param4:int) : Boolean
        {
            var _loc5_:Number = NaN;
            var _loc6_:Number = NaN;
            var _loc7_:Number = NaN;
            var _loc8_:Number = NaN;
            var _loc9_:Number = NaN;
            var _loc10_:Number = NaN;
            var _loc11_:Number = NaN;
            var _loc12_:Number = NaN;
            var _loc13_:Number = NaN;
            var _loc14_:Number = NaN;
            switch(param2)
            {
                case "change opacity":
                    _loc5_ = Number(param3[0]);
                    _loc6_ = Number(param3[1]);
                    _loc5_ *= 0.01;
                    _loc6_ = Math.round(_loc6_ * 30);
                    if(param4 == _loc6_)
                    {
                        this.textField.visible = _loc5_ == 0 ? false : true;
                        this.textField.alpha = _loc5_;
                        return true;
                    }
                    _loc7_ = this.textField.alpha;
                    _loc8_ = _loc5_ - _loc7_;
                    this.textField.alpha = _loc7_ + _loc8_ / (_loc6_ - param4);
                    this.textField.visible = this.textField.alpha == 0 ? false : true;
                    break;
                case "slide":
                    _loc6_ = Number(param3[0]);
                    _loc9_ = Number(param3[1]);
                    _loc10_ = Number(param3[2]);
                    _loc6_ = Math.round(_loc6_ * 30);
                    if(param4 == _loc6_)
                    {
                        this.textField.x = _loc9_;
                        this.textField.y = _loc10_;
                        return true;
                    }
                    _loc11_ = this.textField.x;
                    _loc12_ = this.textField.y;
                    _loc13_ = _loc9_ - _loc11_;
                    _loc14_ = _loc10_ - _loc12_;
                    this.textField.x = _loc11_ + _loc13_ / (_loc6_ - param4);
                    this.textField.y = _loc12_ + _loc14_ / (_loc6_ - param4);
                    break;
            }
            return false;
        }
    }
}

