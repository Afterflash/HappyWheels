package com.totaljerkface.game.editor
{
    import com.totaljerkface.game.editor.ui.Window;
    import flash.display.DisplayObjectContainer;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;

    [Embed(source="/_assets/assets.swf", symbol="symbol719")]
    public class ToolBar extends Sprite
    {
        public static const TOOL_SELECTED:String = "toolselected";

        public static const ARROW:String = "arrow";

        public static const SHAPE:String = "shape";

        public static const POLYGON:String = "polygon";

        public static const JOINT:String = "joint";

        public static const SPECIAL:String = "special";

        public static const TEXT:String = "text";

        public static const TRIGGER:String = "trigger";

        public static const ART:String = "art";

        public var arrowButton:ToolButton;

        public var shapeButton:ToolButton;

        public var polygonButton:ToolButton;

        public var pinButton:ToolButton;

        public var specialButton:ToolButton;

        public var textButton:ToolButton;

        public var triggerButton:ToolButton;

        public var artButton:ToolButton;

        private var window:Window;

        private var _currentButton:ToolButton;

        public function ToolBar()
        {
            super();
        }

        public function init():void
        {
            var _loc1_:DisplayObjectContainer = null;
            _loc1_ = parent;
            this.window = new Window(false);
            this.window.x = x;
            this.window.y = y;
            this.window.populate(this);
            _loc1_.addChild(this.window);
            addEventListener(MouseEvent.MOUSE_UP, this.mouseUpHandler);
            addEventListener(MouseEvent.MOUSE_OVER, this.mouseOverHandler);
        }

        private function mouseUpHandler(param1:MouseEvent):void
        {
            var _loc2_:ToolButton = null;
            if (param1.target is ToolButton)
            {
                _loc2_ = param1.target as ToolButton;
                this.currentButton = _loc2_;
            }
            param1.stopPropagation();
        }

        private function mouseOverHandler(param1:MouseEvent):void
        {
            var _loc2_:MouseHelper = MouseHelper.instance;
            switch (param1.target)
            {
                case this.arrowButton:
                    _loc2_.show("selection tool (1)", this.arrowButton);
                    break;
                case this.shapeButton:
                    _loc2_.show("shape tool (2)", this.shapeButton);
                    break;
                case this.polygonButton:
                    _loc2_.show("poly tool (3)", this.polygonButton);
                    break;
                case this.pinButton:
                    _loc2_.show("joint tool (5)", this.pinButton);
                    break;
                case this.specialButton:
                    _loc2_.show("special item tool (6)", this.specialButton);
                    break;
                case this.textButton:
                    _loc2_.show("text tool (7)", this.textButton);
                    break;
                case this.triggerButton:
                    _loc2_.show("trigger tool (8)", this.triggerButton);
                    break;
                case this.artButton:
                    _loc2_.show("art tool (4)", this.artButton);
            }
        }

        private function set currentButton(param1:ToolButton):void
        {
            if (this._currentButton)
            {
                if (param1 == this._currentButton)
                {
                    return;
                }
                this._currentButton.selected = false;
            }
            this._currentButton = param1;
            this._currentButton.selected = true;
            dispatchEvent(new Event(TOOL_SELECTED));
        }

        public function get currentSelection():String
        {
            switch (this._currentButton)
            {
                case this.arrowButton:
                    return ARROW;
                case this.shapeButton:
                    return SHAPE;
                case this.polygonButton:
                    return POLYGON;
                case this.pinButton:
                    return JOINT;
                case this.specialButton:
                    return SPECIAL;
                case this.textButton:
                    return TEXT;
                case this.triggerButton:
                    return TRIGGER;
                case this.artButton:
                    return ART;
                default:
                    return "";
            }
        }

        public function pressButton(param1:String):*
        {
            switch (param1)
            {
                case ARROW:
                    this.currentButton = this.arrowButton;
                    break;
                case SHAPE:
                    this.currentButton = this.shapeButton;
                    break;
                case POLYGON:
                    this.currentButton = this.polygonButton;
                    break;
                case JOINT:
                    this.currentButton = this.pinButton;
                    break;
                case SPECIAL:
                    this.currentButton = this.specialButton;
                    break;
                case TEXT:
                    this.currentButton = this.textButton;
                    break;
                case TRIGGER:
                    this.currentButton = this.triggerButton;
                    break;
                case ART:
                    this.currentButton = this.artButton;
            }
        }

        public function die():void
        {
            removeEventListener(MouseEvent.MOUSE_UP, this.mouseUpHandler);
            removeEventListener(MouseEvent.MOUSE_OVER, this.mouseOverHandler);
        }
    }
}
