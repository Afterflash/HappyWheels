package com.totaljerkface.game.editor
{
    import com.totaljerkface.game.Settings;
    import com.totaljerkface.game.editor.actions.*;
    import com.totaljerkface.game.editor.poser.Poser;
    import com.totaljerkface.game.editor.specials.NPCharacterRef;
    import com.totaljerkface.game.editor.specials.Special;
    import com.totaljerkface.game.editor.specials.StartPlaceHolder;
    import com.totaljerkface.game.editor.specials.TextBoxRef;
    import com.totaljerkface.game.editor.trigger.RefTrigger;
    import com.totaljerkface.game.editor.trigger.TrigSelector;
    import com.totaljerkface.game.editor.ui.*;
    import com.totaljerkface.game.editor.vertedit.VertEdit;
    import flash.display.*;
    import flash.events.*;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.text.TextField;
    import flash.utils.Dictionary;

    [Embed(source="/_assets/assets.swf", symbol="symbol835")]
    public class ArrowTool extends Tool
    {
        public var labelText:TextField;

        private var currentSelection:Array;

        private var copiedSelection:Array;

        private var dragging:Boolean;

        private var currMouseX:Number;

        private var currMouseY:Number;

        private var selectBox:Sprite;

        private var trigSelector:TrigSelector;

        private var poser:Poser;

        private var vertEdit:VertEdit;

        private var currentAttributes:Array;

        private var inputs:Array;

        private var currentFunctions:Array;

        private var buttons:Array;

        private var inputHolder:Sprite;

        private var inputMask:Sprite;

        private var holderY:int;

        private var translating:Boolean;

        private var scaling:Boolean;

        private var rotating:Boolean;

        private var scrolling:Boolean;

        private var scrollUpSprite:Sprite;

        private var scrollDownSprite:Sprite;

        private const windowWidth:int = 130;

        private const cutoffHeight:int = 430;

        private const indent:int = 5;

        private var _currentCanvas:Canvas;

        public var numShapesSelected:int = 0;

        public var numSpecialsSelected:int = 0;

        public var numJointsSelected:int = 0;

        public var numTriggersSelected:int = 0;

        public var numGroupsSelected:int = 0;

        public var numCharSelected:int = 0;

        private const helpMessage:String = "<u><b>Selection Tool Help:</b></u><br><br>The selection tool allows you to select objects by clicking on them, or by dragging a rectangle around them.  When an object is selected, the properties of that object will be displayed for your goddamn pleasure.<br><br>Selecting multiple objects will allow you to make changes to several objects at once.  No playa, I\'m fuckin serious.  Hold <b>shift</b> when selecting to add to or remove from your current selection.<br><br>If all of the selected objects are groupable (such as non-fixed shapes), you will be able to group them to make more complex objects.  Once a group is created, you can double-click on it to enter and edit it.  Double click again on the background to exit.<br><br>You may now also double click into art and polygon shapes to edit them.<br><br><u>Keyboard Shortcuts:</u><br><br><b>up,down,left,right</b>: Move the selected object(s) around the stage.  Hold <b>shift</b> to move them around faster.<br><br><b>a,w,s,d</b>: Resize the height and width of the selected object(s), when allowable.  Hold <b>shift</b> to resize faster.<br><br><b>z,x</b>: Rotate the selected object(s) when allowable.  Hold <b>shift</b> to rotate faster.<br><br><b>ctrl+up,down</b>: Raise or lower the depth of the object.<br><br><b>backspace</b>: Delete the current selection.<br><br><b>ctrl+c</b>: Copy the selected object(s).<br><br><b>ctrl+v</b>: Paste the last copied objects.  Hold <b>shift</b> to paste in the same location as the original.<br><br><b>ctrl+z</b>:  Undo the last action.<br><br><b>ctrl+y</b>:  Redo what you just undid.<br><br>";

        private const helpPolyEdit:String = "<u><b>Polygon Editor Help:</b></u><br><br>Manually move the points of your polygon to your liking. The polygon must remain convex, so your actions will be constrained.<br><br><u>Keyboard Shortcuts:</u><br><br><b>up,down,left,right</b>: Move the selected points(s) around the stage.  Hold <b>shift</b> to move them around faster.<br><br><b>backspace</b>: Delete the selected points.<br><br><b>Enter</b>: After selecting a point, use Enter to insert a point between the current and next point.";

        private const helpArtEdit:String = "<u><b>Art Editor Help:</b></u><br><br>Manually move the points of your art shape to your liking. Double click on a point to add bezier handles for controlling the curves of your shape. To remove handles and simply use straight lines, drag handles into the selected point.<br><br><u>Keyboard Shortcuts:</u><br><br><b>up,down,left,right</b>: Move the selected points(s) around the stage.  Hold <b>shift</b> to move them around faster.<br><br><b>backspace</b>: Delete the selected points.<br><br><b>Enter</b>: After selecting a point, use Enter to insert a point between the current and next point.";

        public function ArrowTool(param1:Editor, param2:Canvas)
        {
            super(param1, param2);
            this.currentCanvas = param2;
            this.init();
        }

        private function init():void
        {
            this.inputs = new Array();
            this.buttons = new Array();
            this.currentAttributes = new Array();
            this.currentFunctions = new Array();
            this.copiedSelection = new Array();
            this.currentSelection = new Array();
            this.inputHolder = new Sprite();
            addChild(this.inputHolder);
            this.inputMask = new Sprite();
            addChild(this.inputMask);
            this.inputMask.graphics.beginFill(16711680);
            this.inputMask.graphics.drawRect(0, 0, this.windowWidth, 100);
            this.inputHolder.mask = this.inputMask;
            this.inputHolder.y = this.inputMask.y = this.holderY = this.labelText.y + Math.ceil(this.labelText.height);
        }

        override public function activate():void
        {
            super.activate();
            HelpWindow.instance.populate(this.helpMessage);
            stage.addEventListener(MouseEvent.MOUSE_DOWN, this.mouseDownCanvasHandler);
            stage.addEventListener(MouseEvent.DOUBLE_CLICK, this.doubleClickHandler);
            stage.addEventListener(KeyboardEvent.KEY_DOWN, this.keyDownHandler);
        }

        override public function deactivate():void
        {
            var _loc2_:String = null;
            var _loc3_:ColorInput = null;
            this.killTriggerSelector(false);
            this.closePoser();
            var _loc1_:Action = this.deselectAll();
            if (_loc1_)
            {
                dispatchEvent(new ActionEvent(ActionEvent.GENERIC, _loc1_));
            }
            for (_loc2_ in this.inputs)
            {
                if (this.inputs[_loc2_] is ColorInput)
                {
                    _loc3_ = this.inputs[_loc2_] as ColorInput;
                    _loc3_.closeColorSelector();
                }
            }
            stage.removeEventListener(MouseEvent.MOUSE_DOWN, this.mouseDownCanvasHandler);
            stage.removeEventListener(MouseEvent.DOUBLE_CLICK, this.doubleClickHandler);
            stage.removeEventListener(MouseEvent.MOUSE_UP, this.mouseUpHandler);
            stage.removeEventListener(MouseEvent.MOUSE_UP, this.selectContained);
            stage.removeEventListener(MouseEvent.MOUSE_MOVE, this.createSelectBox);
            stage.removeEventListener(KeyboardEvent.KEY_DOWN, this.keyDownHandler);
            stage.removeEventListener(MouseEvent.MOUSE_MOVE, this.dragShapes);
            this.disableScrolling();
            if (this.selectBox)
            {
                this._currentCanvas.removeChild(this.selectBox);
                this.selectBox = null;
            }
            super.deactivate();
        }

        public function deactivateKeepSelection():void
        {
            var _loc1_:String = null;
            var _loc2_:ColorInput = null;
            this.killTriggerSelector(false);
            this.closePoser();
            for (_loc1_ in this.inputs)
            {
                if (this.inputs[_loc1_] is ColorInput)
                {
                    _loc2_ = this.inputs[_loc1_] as ColorInput;
                    _loc2_.closeColorSelector();
                }
            }
            stage.removeEventListener(MouseEvent.MOUSE_DOWN, this.mouseDownCanvasHandler);
            stage.removeEventListener(MouseEvent.MOUSE_UP, this.mouseUpHandler);
            stage.removeEventListener(MouseEvent.MOUSE_UP, this.selectContained);
            stage.removeEventListener(MouseEvent.MOUSE_MOVE, this.createSelectBox);
            stage.removeEventListener(KeyboardEvent.KEY_DOWN, this.keyDownHandler);
            stage.removeEventListener(MouseEvent.MOUSE_MOVE, this.dragShapes);
            this.disableScrolling();
            if (this.selectBox)
            {
                this._currentCanvas.removeChild(this.selectBox);
                this.selectBox = null;
            }
            super.deactivate();
        }

        override public function resetActionVars(param1:String):void
        {
            switch (param1)
            {
                case ActionEvent.TRANSLATE:
                    this.scaling = false;
                    this.rotating = false;
                    break;
                case ActionEvent.SCALE:
                    this.translating = false;
                    this.rotating = false;
                    break;
                case ActionEvent.ROTATE:
                    this.scaling = false;
                    this.translating = false;
                    break;
                default:
                    this.translating = false;
                    this.scaling = false;
                    this.rotating = false;
            }
            if (this.vertEdit)
            {
                this.vertEdit.translating = false;
            }
        }

        public function reverseShape(param1:MouseEvent = null):void
        {
            var _loc2_:Action = null;
            var _loc3_:Action = null;
            var _loc6_:RefSprite = null;
            var _loc7_:EdgeShape = null;
            var _loc8_:Point = null;
            var _loc9_:Point = null;
            var _loc4_:int = int(this.currentSelection.length);
            var _loc5_:int = 0;
            while (_loc5_ < _loc4_)
            {
                _loc6_ = this.currentSelection[_loc5_] as RefSprite;
                if (_loc6_ is EdgeShape)
                {
                    _loc7_ = _loc6_ as EdgeShape;
                    _loc8_ = new Point(_loc7_.x, _loc7_.y);
                    _loc7_.reverse();
                    _loc9_ = new Point(_loc7_.x, _loc7_.y);
                    _loc2_ = new ActionReverseShape(_loc7_, _loc8_, _loc9_);
                    if (_loc3_)
                    {
                        _loc3_.nextAction = _loc2_;
                    }
                    _loc3_ = _loc2_;
                }
                _loc5_++;
            }
            if (_loc3_)
            {
                dispatchEvent(new ActionEvent(ActionEvent.GENERIC, _loc3_));
                this.updateInputValues();
            }
        }

        public function resetScale(param1:MouseEvent = null):void
        {
            var _loc2_:Action = null;
            var _loc3_:Action = null;
            var _loc4_:Action = null;
            var _loc7_:RefSprite = null;
            var _loc8_:EdgeShape = null;
            var _loc5_:int = int(this.currentSelection.length);
            var _loc6_:int = 0;
            while (_loc6_ < _loc5_)
            {
                _loc7_ = this.currentSelection[_loc6_] as RefSprite;
                if (_loc7_ is EdgeShape)
                {
                    _loc8_ = _loc7_ as EdgeShape;
                    _loc2_ = new ActionProperty(_loc8_, "shapeWidth", _loc8_.shapeWidth, _loc8_.defaultWidth);
                    _loc3_ = new ActionProperty(_loc8_, "shapeHeight", _loc8_.shapeHeight, _loc8_.defaultHeight);
                    _loc8_.shapeWidth = _loc8_.defaultWidth;
                    _loc8_.shapeHeight = _loc8_.defaultHeight;
                    _loc2_.nextAction = _loc3_;
                    if (_loc4_)
                    {
                        _loc4_.nextAction = _loc2_;
                    }
                    _loc4_ = _loc3_;
                }
                _loc6_++;
            }
            if (_loc4_)
            {
                dispatchEvent(new ActionEvent(ActionEvent.GENERIC, _loc4_));
                this.updateInputValues();
            }
        }

        private function dragShapes(param1:MouseEvent):void
        {
            var _loc2_:Action = null;
            var _loc3_:Action = null;
            var _loc7_:RefSprite = null;
            var _loc4_:Number = _canvas.mouseX - this.currMouseX;
            var _loc5_:Number = _canvas.mouseY - this.currMouseY;
            this.currMouseX = _canvas.mouseX;
            this.currMouseY = _canvas.mouseY;
            var _loc6_:int = 0;
            while (_loc6_ < this.currentSelection.length)
            {
                _loc7_ = this.currentSelection[_loc6_] as RefSprite;
                if (!this.dragging)
                {
                    _loc2_ = new ActionTranslate(_loc7_, new Point(_loc7_.x, _loc7_.y));
                    if (_loc3_)
                    {
                        _loc2_.prevAction = _loc3_;
                    }
                    _loc3_ = _loc2_;
                }
                _loc7_.x += _loc4_;
                _loc7_.y += _loc5_;
                _loc6_++;
            }
            this.updateInputValues();
            if (!this.dragging)
            {
                dispatchEvent(new ActionEvent(ActionEvent.GENERIC, _loc2_));
                this.dragging = true;
            }
        }

        private function createSelectBox(param1:MouseEvent):void
        {
            if (!this.selectBox)
            {
                stage.removeEventListener(MouseEvent.MOUSE_UP, this.mouseUpHandler);
                stage.addEventListener(MouseEvent.MOUSE_UP, this.selectContained);
                this.selectBox = new SelectBoxSprite();
                this._currentCanvas.addChild(this.selectBox);
                this.selectBox.x = this.currMouseX;
                this.selectBox.y = this.currMouseY;
                this.selectBox.mouseEnabled = false;
                this.selectBox.blendMode = "invert";
            }
            this.selectBox.scaleX = (_canvas.mouseX - this.currMouseX) / 100;
            this.selectBox.scaleY = (_canvas.mouseY - this.currMouseY) / 100;
        }

        private function selectContained(param1:MouseEvent):void
        {
            var _loc2_:Action = null;
            var _loc3_:Action = null;
            var _loc5_:Action = null;
            var _loc6_:RefSprite = null;
            trace("SELECT CONTAINED");
            if (!param1.shiftKey)
            {
                _loc5_ = this.deselectAll();
            }
            var _loc4_:int = 0;
            while (_loc4_ < this._currentCanvas.shapes.numChildren)
            {
                _loc6_ = this._currentCanvas.shapes.getChildAt(_loc4_) as RefSprite;
                if (this.selectBox.hitTestObject(_loc6_) && !_loc6_.selected)
                {
                    _loc2_ = this.addToSelection(_loc6_);
                    if (_loc3_)
                    {
                        _loc2_.prevAction = _loc3_;
                    }
                    _loc3_ = _loc2_;
                }
                _loc4_++;
            }
            _loc4_ = 0;
            while (_loc4_ < this._currentCanvas.special.numChildren)
            {
                _loc6_ = this._currentCanvas.special.getChildAt(_loc4_) as RefSprite;
                if (this.selectBox.hitTestObject(_loc6_) && !_loc6_.selected)
                {
                    _loc2_ = this.addToSelection(_loc6_);
                    if (_loc3_)
                    {
                        _loc2_.prevAction = _loc3_;
                    }
                    _loc3_ = _loc2_;
                }
                _loc4_++;
            }
            if (!(this._currentCanvas is GroupCanvas))
            {
                _loc4_ = 0;
                while (_loc4_ < this._currentCanvas.groups.numChildren)
                {
                    _loc6_ = this._currentCanvas.groups.getChildAt(_loc4_) as RefSprite;
                    if (this.selectBox.hitTestObject(_loc6_) && !_loc6_.selected)
                    {
                        _loc2_ = this.addToSelection(_loc6_);
                        if (_loc3_)
                        {
                            _loc2_.prevAction = _loc3_;
                        }
                        _loc3_ = _loc2_;
                    }
                    _loc4_++;
                }
                _loc4_ = 0;
                while (_loc4_ < this._currentCanvas.joints.numChildren)
                {
                    _loc6_ = this._currentCanvas.joints.getChildAt(_loc4_) as RefSprite;
                    if (this.selectBox.hitTestObject(_loc6_) && !_loc6_.selected)
                    {
                        _loc2_ = this.addToSelection(_loc6_);
                        if (_loc3_)
                        {
                            _loc2_.prevAction = _loc3_;
                        }
                        _loc3_ = _loc2_;
                    }
                    _loc4_++;
                }
                _loc4_ = 0;
                while (_loc4_ < this._currentCanvas.triggers.numChildren)
                {
                    _loc6_ = this._currentCanvas.triggers.getChildAt(_loc4_) as RefSprite;
                    if (this.selectBox.hitTestObject(_loc6_) && !_loc6_.selected)
                    {
                        _loc2_ = this.addToSelection(_loc6_);
                        if (_loc3_)
                        {
                            _loc2_.prevAction = _loc3_;
                        }
                        _loc3_ = _loc2_;
                    }
                    _loc4_++;
                }
                _loc6_ = this._currentCanvas.startPlaceHolder;
                if (this.selectBox.hitTestObject(_loc6_) && !_loc6_.selected)
                {
                    _loc2_ = this.addToSelection(_loc6_);
                    if (_loc3_)
                    {
                        _loc2_.prevAction = _loc3_;
                    }
                    _loc3_ = _loc2_;
                }
            }
            if (_loc2_)
            {
                if (_loc5_)
                {
                    _loc5_.nextAction = _loc2_.firstAction;
                }
                dispatchEvent(new ActionEvent(ActionEvent.GENERIC, _loc2_));
            }
            else if (_loc5_)
            {
                dispatchEvent(new ActionEvent(ActionEvent.GENERIC, _loc5_));
            }
            this.setInputs();
            this._currentCanvas.removeChild(this.selectBox);
            this.selectBox = null;
            stage.removeEventListener(MouseEvent.MOUSE_UP, this.selectContained);
            stage.removeEventListener(MouseEvent.MOUSE_MOVE, this.createSelectBox);
        }

        private function mouseDownCanvasHandler(param1:MouseEvent):void
        {
            var _loc2_:RefSprite = null;
            var _loc3_:Action = null;
            var _loc4_:Action = null;
            this.currMouseX = _canvas.mouseX;
            this.currMouseY = _canvas.mouseY;
            if (param1.target is RefSprite)
            {
                _loc2_ = param1.target as RefSprite;
                if (!_loc2_.selected)
                {
                    if (!param1.shiftKey)
                    {
                        _loc3_ = this.deselectAll();
                    }
                    else
                    {
                        _loc3_ = this.completeEdit();
                    }
                    _loc4_ = this.addToSelection(_loc2_);
                    if (_loc3_)
                    {
                        _loc4_.prevAction = _loc3_;
                    }
                    dispatchEvent(new ActionEvent(ActionEvent.GENERIC, _loc4_));
                }
                else if (param1.shiftKey)
                {
                    _loc4_ = this.removeFromSelection(_loc2_);
                    dispatchEvent(new ActionEvent(ActionEvent.GENERIC, _loc4_));
                }
                this.setInputs();
                if (this.currentSelection.length < 1)
                {
                    return;
                }
                stage.addEventListener(MouseEvent.MOUSE_UP, this.mouseUpHandler);
                stage.addEventListener(MouseEvent.MOUSE_MOVE, this.dragShapes);
            }
            else if (param1.target == this._currentCanvas)
            {
                stage.addEventListener(MouseEvent.MOUSE_MOVE, this.createSelectBox);
                stage.addEventListener(MouseEvent.MOUSE_UP, this.mouseUpHandler);
            }
        }

        private function mouseUpHandler(param1:MouseEvent):void
        {
            var _loc2_:Action = null;
            if (!(param1.target is RefSprite))
            {
                if (!param1.shiftKey)
                {
                    _loc2_ = this.deselectAll();
                    if (_loc2_)
                    {
                        dispatchEvent(new ActionEvent(ActionEvent.GENERIC, _loc2_));
                    }
                    this.setInputs();
                }
            }
            stage.removeEventListener(MouseEvent.MOUSE_UP, this.mouseUpHandler);
            stage.removeEventListener(MouseEvent.MOUSE_MOVE, this.dragShapes);
            stage.removeEventListener(MouseEvent.MOUSE_MOVE, this.createSelectBox);
            this.dragging = false;
        }

        private function doubleClickHandler(param1:MouseEvent):void
        {
            var _loc2_:TextBoxRef = null;
            var _loc3_:Action = null;
            var _loc4_:Action = null;
            var _loc5_:RefGroup = null;
            var _loc6_:GroupCanvas = null;
            var _loc7_:NPCharacterRef = null;
            var _loc8_:EdgeShape = null;
            trace("doubleclick " + (param1.target is ArtShape));
            if (param1.target is TextBoxRef)
            {
                _loc2_ = param1.target as TextBoxRef;
                _loc3_ = this.deselectAll();
                _loc4_ = this.addToSelection(_loc2_);
                if (_loc3_)
                {
                    _loc4_.prevAction = _loc3_;
                }
                _loc2_.editing = true;
                dispatchEvent(new ActionEvent(ActionEvent.GENERIC, _loc4_));
                this.setInputs();
            }
            else if (param1.target is RefGroup)
            {
                _loc5_ = param1.target as RefGroup;
                this.openGroupCanvas(_loc5_);
            }
            else if (param1.target is GroupCanvas)
            {
                _loc6_ = param1.target as GroupCanvas;
                this.closeGroupCanvas(_loc6_);
            }
            else if (param1.target is NPCharacterRef)
            {
                _loc7_ = param1.target as NPCharacterRef;
                this.openPoser(_loc7_);
            }
            else if (param1.target is EdgeShape)
            {
                _loc8_ = param1.target as EdgeShape;
                this.openVertEdit(_loc8_);
            }
        }

        private function checkAlreadySelected(param1:Sprite):Boolean
        {
            var _loc2_:int = int(this.currentSelection.indexOf(param1));
            if (_loc2_ < 0)
            {
                return false;
            }
            return true;
        }

        private function addToSelection(param1:RefSprite):Action
        {
            var _loc3_:int = 0;
            var _loc4_:int = 0;
            var _loc5_:int = 0;
            var _loc6_:int = 0;
            var _loc7_:RefSprite = null;
            var _loc8_:int = 0;
            param1.selected = true;
            var _loc2_:int = param1.parent.getChildIndex(param1);
            if (param1 is RefShape)
            {
                if (this.numShapesSelected > 0)
                {
                    _loc3_ = 0;
                    _loc4_ = _loc5_ = this.numShapesSelected;
                    _loc6_ = _loc3_;
                    while (_loc6_ < _loc4_)
                    {
                        _loc7_ = this.currentSelection[_loc6_];
                        _loc8_ = _loc7_.parent.getChildIndex(_loc7_);
                        if (_loc8_ > _loc2_)
                        {
                            _loc5_ = _loc6_;
                            _loc6_ = 100000;
                        }
                        _loc6_++;
                    }
                }
                else
                {
                    _loc5_ = 0;
                }
                this.currentSelection.splice(_loc5_, 0, param1);
                this.numShapesSelected += 1;
            }
            else if (param1 is Special)
            {
                if (this.numSpecialsSelected > 0)
                {
                    _loc3_ = this.numShapesSelected;
                    _loc4_ = _loc5_ = this.numShapesSelected + this.numSpecialsSelected;
                    _loc6_ = _loc3_;
                    while (_loc6_ < _loc4_)
                    {
                        _loc7_ = this.currentSelection[_loc6_];
                        _loc8_ = _loc7_.parent.getChildIndex(_loc7_);
                        if (_loc8_ > _loc2_)
                        {
                            _loc5_ = _loc6_;
                            _loc6_ = 100000;
                        }
                        _loc6_++;
                    }
                }
                else
                {
                    _loc5_ = this.numShapesSelected;
                }
                this.currentSelection.splice(_loc5_, 0, param1);
                this.numSpecialsSelected += 1;
            }
            else if (param1 is RefGroup)
            {
                if (this.numGroupsSelected > 0)
                {
                    _loc3_ = this.numShapesSelected + this.numSpecialsSelected;
                    _loc4_ = _loc5_ = this.numShapesSelected + this.numSpecialsSelected + this.numGroupsSelected;
                    _loc6_ = _loc3_;
                    while (_loc6_ < _loc4_)
                    {
                        _loc7_ = this.currentSelection[_loc6_];
                        _loc8_ = _loc7_.parent.getChildIndex(_loc7_);
                        if (_loc8_ > _loc2_)
                        {
                            _loc5_ = _loc6_;
                            _loc6_ = 100000;
                        }
                        _loc6_++;
                    }
                }
                else
                {
                    _loc5_ = this.numShapesSelected + this.numSpecialsSelected;
                }
                this.currentSelection.splice(_loc5_, 0, param1);
                this.numGroupsSelected += 1;
            }
            else if (param1 is RefJoint)
            {
                if (this.numJointsSelected > 0)
                {
                    _loc3_ = this.numShapesSelected + this.numSpecialsSelected + this.numGroupsSelected;
                    _loc4_ = _loc5_ = this.numShapesSelected + this.numSpecialsSelected + this.numGroupsSelected + this.numJointsSelected;
                    _loc6_ = _loc3_;
                    while (_loc6_ < _loc4_)
                    {
                        _loc7_ = this.currentSelection[_loc6_];
                        _loc8_ = _loc7_.parent.getChildIndex(_loc7_);
                        if (_loc8_ > _loc2_)
                        {
                            _loc5_ = _loc6_;
                            _loc6_ = 100000;
                        }
                        _loc6_++;
                    }
                }
                else
                {
                    _loc5_ = this.numShapesSelected + this.numSpecialsSelected + this.numGroupsSelected;
                }
                this.currentSelection.splice(_loc5_, 0, param1);
                this.numJointsSelected += 1;
            }
            else if (param1 is RefTrigger)
            {
                if (this.numTriggersSelected > 0)
                {
                    _loc3_ = this.numShapesSelected + this.numSpecialsSelected + this.numGroupsSelected + this.numJointsSelected;
                    _loc4_ = _loc5_ = this.numShapesSelected + this.numSpecialsSelected + this.numGroupsSelected + this.numJointsSelected + this.numTriggersSelected;
                    _loc6_ = _loc3_;
                    while (_loc6_ < _loc4_)
                    {
                        _loc7_ = this.currentSelection[_loc6_];
                        _loc8_ = _loc7_.parent.getChildIndex(_loc7_);
                        if (_loc8_ > _loc2_)
                        {
                            _loc5_ = _loc6_;
                            _loc6_ = 100000;
                        }
                        _loc6_++;
                    }
                }
                else
                {
                    _loc5_ = this.numShapesSelected + this.numSpecialsSelected + this.numGroupsSelected + this.numJointsSelected;
                }
                this.currentSelection.splice(_loc5_, 0, param1);
                this.numTriggersSelected += 1;
            }
            else
            {
                if (!(param1 is StartPlaceHolder))
                {
                    throw new Error("What the fu");
                }
                _loc5_ = int(this.currentSelection.length);
                this.currentSelection.splice(_loc5_, 0, param1);
                this.numCharSelected += 1;
            }
            return new ActionSelect(param1, this.currentSelection, _loc5_, this);
        }

        private function getNumSelectedOfType(param1:Class):void
        {
            var _loc5_:RefSprite = null;
            var _loc2_:int = 0;
            var _loc3_:int = 0;
            var _loc4_:int = 0;
            while (_loc4_ < this.currentSelection.length)
            {
                _loc5_ = this.currentSelection[_loc4_];
                if (_loc5_ is param1)
                {
                    _loc2_ += 1;
                }
                _loc4_++;
            }
        }

        private function removeFromSelection(param1:RefSprite):Action
        {
            var _loc4_:TextBoxRef = null;
            var _loc5_:ActionProperty = null;
            var _loc2_:int = int(this.currentSelection.indexOf(param1));
            if (param1 is RefShape)
            {
                --this.numShapesSelected;
            }
            else if (param1 is Special)
            {
                --this.numSpecialsSelected;
                if (param1 is TextBoxRef)
                {
                    _loc4_ = param1 as TextBoxRef;
                    if (_loc4_.editing)
                    {
                        _loc5_ = new ActionProperty(_loc4_, "caption", _loc4_.caption, _loc4_.currentText);
                        _loc4_.caption = _loc4_.currentText;
                        _loc4_.editing = false;
                    }
                }
            }
            else if (param1 is RefGroup)
            {
                --this.numGroupsSelected;
            }
            else if (param1 is RefJoint)
            {
                --this.numJointsSelected;
            }
            else if (param1 is RefTrigger)
            {
                --this.numTriggersSelected;
            }
            else
            {
                if (!(param1 is StartPlaceHolder))
                {
                    throw new Error("tried to Deselect this... what is it");
                }
                --this.numCharSelected;
            }
            param1.selected = false;
            this.currentSelection.splice(_loc2_, 1);
            var _loc3_:Action = new ActionDeselect(param1, this.currentSelection, _loc2_, this);
            if (_loc5_)
            {
                _loc3_.prevAction = _loc5_;
            }
            return _loc3_;
        }

        private function deselectAll():Action
        {
            var _loc1_:Action = null;
            var _loc2_:Action = null;
            var _loc4_:RefSprite = null;
            trace("deselectAll");
            var _loc3_:int = int(this.currentSelection.length - 1);
            while (_loc3_ > -1)
            {
                _loc4_ = this.currentSelection[_loc3_];
                _loc1_ = this.removeFromSelection(_loc4_);
                if (_loc2_)
                {
                    _loc2_.nextAction = _loc1_.firstAction;
                }
                _loc2_ = _loc1_;
                _loc3_--;
            }
            this.setInputs();
            return _loc1_;
        }

        private function deleteSelection():Action
        {
            var _loc1_:Action = null;
            var _loc2_:Action = null;
            var _loc3_:Action = null;
            var _loc5_:RefSprite = null;
            if (this.currentSelection.length == 0)
            {
                return null;
            }
            trace("DELETE SELECTION");
            var _loc4_:int = int(this.currentSelection.length - 1);
            while (_loc4_ > -1)
            {
                _loc5_ = this.currentSelection[_loc4_];
                _loc2_ = this.removeFromSelection(_loc5_);
                if (_loc3_)
                {
                    _loc3_.nextAction = _loc2_.firstAction;
                }
                _loc3_ = _loc2_;
                if (_loc5_.deletable)
                {
                    _loc1_ = _loc5_.deleteSelf(this._currentCanvas);
                    if (_loc1_)
                    {
                        _loc2_.nextAction = _loc1_.firstAction;
                        _loc3_ = _loc1_;
                    }
                }
                _loc4_--;
            }
            _canvas.relabelTriggers();
            this.currentSelection.splice(0, this.currentSelection.length);
            return _loc3_;
        }

        public function editSelectText(param1:TextBoxRef):void
        {
            var _loc2_:Action = this.addToSelection(param1);
            param1.editing = true;
            param1.selectAllText();
            this.setInputs();
            dispatchEvent(new ActionEvent(ActionEvent.GENERIC, _loc2_));
        }

        private function completeEdit():Action
        {
            var _loc2_:TextBoxRef = null;
            var _loc3_:ActionProperty = null;
            var _loc1_:int = int(this.currentSelection.length - 1);
            while (_loc1_ > -1)
            {
                if (this.currentSelection[_loc1_] is TextBoxRef)
                {
                    _loc2_ = this.currentSelection[_loc1_] as TextBoxRef;
                    _loc3_ = new ActionProperty(_loc2_, "caption", _loc2_.caption, _loc2_.currentText);
                    _loc2_.caption = _loc2_.currentText;
                    _loc2_.editing = false;
                    return _loc3_;
                }
                _loc1_--;
            }
            return null;
        }

        public function beginTriggerSelector(param1:RefTrigger = null):void
        {
            var _loc3_:Action = null;
            var _loc4_:RefTrigger = null;
            stage.removeEventListener(MouseEvent.MOUSE_DOWN, this.mouseDownCanvasHandler);
            stage.removeEventListener(MouseEvent.DOUBLE_CLICK, this.doubleClickHandler);
            stage.removeEventListener(MouseEvent.MOUSE_UP, this.mouseUpHandler);
            stage.removeEventListener(MouseEvent.MOUSE_UP, this.selectContained);
            stage.removeEventListener(MouseEvent.MOUSE_MOVE, this.createSelectBox);
            stage.removeEventListener(KeyboardEvent.KEY_DOWN, this.keyDownHandler);
            stage.removeEventListener(MouseEvent.MOUSE_MOVE, this.dragShapes);
            if (param1)
            {
                _loc3_ = this.addToSelection(param1);
                dispatchEvent(new ActionEvent(ActionEvent.GENERIC, _loc3_));
            }
            var _loc2_:int = 0;
            while (_loc2_ < this.currentSelection.length)
            {
                _loc4_ = this.currentSelection[_loc2_];
                _loc4_.addingTargets = true;
                _loc2_++;
            }
            this.setInputs();
            this.trigSelector = new TrigSelector(this.currentSelection, canvas);
            this.trigSelector.addEventListener(ActionEvent.GENERIC, this.triggerSelectorHandler);
            this.trigSelector.addEventListener(TrigSelector.SELECT_COMPLETE, this.triggerSelectorComplete);
        }

        private function triggerSelectorHandler(param1:ActionEvent):void
        {
            dispatchEvent(new ActionEvent(ActionEvent.GENERIC, param1.action));
        }

        private function triggerSelectorComplete(param1:Event):void
        {
            this.killTriggerSelector();
            this.setInputs();
        }

        public function killTriggerSelector(param1:Boolean = true):void
        {
            var _loc2_:int = 0;
            var _loc3_:RefTrigger = null;
            if (this.trigSelector)
            {
                this.trigSelector.removeEventListener(ActionEvent.GENERIC, this.triggerSelectorHandler);
                this.trigSelector.removeEventListener(TrigSelector.SELECT_COMPLETE, this.triggerSelectorComplete);
                this.trigSelector.die();
                this.trigSelector = null;
                _loc2_ = 0;
                while (_loc2_ < this.currentSelection.length)
                {
                    _loc3_ = this.currentSelection[_loc2_];
                    _loc3_.addingTargets = false;
                    _loc2_++;
                }
                if (param1)
                {
                    stage.addEventListener(MouseEvent.MOUSE_DOWN, this.mouseDownCanvasHandler);
                    stage.addEventListener(MouseEvent.DOUBLE_CLICK, this.doubleClickHandler);
                    stage.addEventListener(KeyboardEvent.KEY_DOWN, this.keyDownHandler);
                }
            }
        }

        private function keyDownHandler(param1:KeyboardEvent):void
        {
            var _loc2_:Action = null;
            if (param1.target is TextField)
            {
                return;
            }
            switch (param1.keyCode)
            {
                case 8:
                    _loc2_ = this.deleteSelection();
                    if (_loc2_)
                    {
                        dispatchEvent(new ActionEvent(ActionEvent.GENERIC, _loc2_));
                    }
                    this.setInputs();
                    break;
                case 37:
                    this.moveSelected(-1, 0, param1.shiftKey);
                    break;
                case 38:
                    if (param1.ctrlKey)
                    {
                        this.raiseDepthSelected();
                    }
                    else
                    {
                        this.moveSelected(0, -1, param1.shiftKey);
                    }
                    break;
                case 39:
                    this.moveSelected(1, 0, param1.shiftKey);
                    break;
                case 40:
                    if (param1.ctrlKey)
                    {
                        this.lowerDepthSelected();
                    }
                    else
                    {
                        this.moveSelected(0, 1, param1.shiftKey);
                    }
                    break;
                case 65:
                    this.adjustScale(-1, 0, param1.shiftKey);
                    break;
                case 87:
                    this.adjustScale(0, 1, param1.shiftKey);
                    break;
                case 68:
                    this.adjustScale(1, 0, param1.shiftKey);
                    break;
                case 83:
                    this.adjustScale(0, -1, param1.shiftKey);
                    break;
                case 90:
                    if (!param1.ctrlKey)
                    {
                        this.adjustRotation(-1, param1.shiftKey);
                    }
                    break;
                case 88:
                    this.adjustRotation(1, param1.shiftKey);
                    break;
                case 67:
                    this.copySelected();
                    break;
                case 86:
                    this.paste(param1.shiftKey);
                    break;
                case 71:
                    break;
                default:
                    return;
            }
        }

        private function groupSelected(param1:MouseEvent = null):void
        {
            var _loc2_:RefGroup = new RefGroup();
            var _loc3_:Action = _loc2_.build(this.currentSelection, _canvas);
            var _loc4_:Action = this.deselectAll();
            _loc3_.nextAction = _loc4_.firstAction;
            _canvas.addRefSprite(_loc2_);
            var _loc5_:Action = new ActionAdd(_loc2_, _canvas, _loc2_.parent.getChildIndex(_loc2_));
            _loc4_.nextAction = _loc5_;
            var _loc6_:Action = this.addToSelection(_loc2_);
            _loc5_.nextAction = _loc6_;
            dispatchEvent(new ActionEvent(ActionEvent.GENERIC, _loc6_));
            this.setInputs();
        }

        private function breakSelectedGroups(param1:MouseEvent = null):void
        {
            var _loc4_:Action = null;
            var _loc5_:Action = null;
            var _loc7_:RefGroup = null;
            var _loc8_:RefSprite = null;
            var _loc2_:Array = new Array();
            var _loc3_:Array = new Array();
            var _loc6_:int = 0;
            while (_loc6_ < this.currentSelection.length)
            {
                _loc3_.push(this.currentSelection[_loc6_]);
                _loc6_++;
            }
            _loc5_ = _loc4_ = this.deleteSelection();
            _loc6_ = 0;
            while (_loc6_ < _loc3_.length)
            {
                _loc7_ = _loc3_[_loc6_];
                _loc4_ = _loc7_.breakApart(_loc2_, _canvas);
                _loc5_.nextAction = _loc4_.firstAction;
                _loc5_ = _loc4_;
                _loc6_++;
            }
            _loc6_ = 0;
            while (_loc6_ < _loc2_.length)
            {
                _loc8_ = _loc2_[_loc6_];
                _loc4_ = this.addToSelection(_loc8_);
                _loc5_.nextAction = _loc4_;
                _loc5_ = _loc4_;
                _loc6_++;
            }
            this.setInputs();
            dispatchEvent(new ActionEvent(ActionEvent.GENERIC, _loc4_));
        }

        private function openGroupCanvas(param1:RefGroup):void
        {
            var _loc2_:Action = this.deselectAll();
            var _loc3_:int = param1.parent.getChildIndex(param1);
            _canvas.removeRefSprite(param1);
            var _loc4_:ActionDelete = new ActionDelete(param1, _canvas, _loc3_);
            _loc2_.nextAction = _loc4_;
            var _loc5_:GroupCanvas = new GroupCanvas(param1, _canvas, _loc3_);
            _canvas.parent.addChild(_loc5_);
            var _loc6_:ActionOpenGroup = new ActionOpenGroup(_loc5_, _loc5_.parent, this);
            _loc6_.prevAction = _loc4_;
            var _loc7_:Array = new Array();
            var _loc8_:Action = param1.breakApart(_loc7_, _loc5_);
            _loc6_.nextAction = _loc8_.firstAction;
            this.currentCanvas = _loc5_;
            dispatchEvent(new ActionEvent(ActionEvent.GENERIC, _loc8_));
        }

        private function closeGroupCanvas(param1:GroupCanvas):void
        {
            var _loc9_:RefSprite = null;
            var _loc10_:Action = null;
            var _loc11_:Action = null;
            var _loc2_:RefGroup = param1.refGroup;
            var _loc3_:Array = new Array();
            var _loc4_:int = 0;
            while (_loc4_ < param1.shapes.numChildren)
            {
                _loc9_ = param1.shapes.getChildAt(_loc4_) as RefSprite;
                _loc3_.push(_loc9_);
                _loc4_++;
            }
            _loc4_ = 0;
            while (_loc4_ < param1.special.numChildren)
            {
                _loc9_ = param1.special.getChildAt(_loc4_) as RefSprite;
                _loc3_.push(_loc9_);
                _loc4_++;
            }
            var _loc5_:Action = _loc2_.rebuild(_loc3_, param1, false);
            var _loc6_:Action = new ActionCloseGroup(param1, param1.parent, this);
            param1.parent.removeChild(param1);
            this.currentCanvas = _canvas;
            var _loc7_:ActionAdd = new ActionAdd(_loc2_, _canvas, param1.groupIndex);
            _canvas.addRefSpriteAt(_loc2_, param1.groupIndex);
            var _loc8_:Action = this.addToSelection(_loc2_);
            if (_loc5_)
            {
                _loc5_.nextAction = _loc6_;
                _loc6_.nextAction = _loc7_;
                _loc7_.nextAction = _loc8_;
                _loc10_ = _loc8_;
            }
            else
            {
                _loc11_ = this.deleteSelection();
                _loc6_.nextAction = _loc7_;
                _loc7_.nextAction = _loc8_;
                _loc8_.nextAction = _loc11_.firstAction;
                _loc10_ = _loc11_;
            }
            dispatchEvent(new ActionEvent(ActionEvent.GENERIC, _loc10_));
            this.setInputs();
            Settings.debugText.text = "";
        }

        private function openPoser(param1:NPCharacterRef):void
        {
            var _loc2_:Action = this.deselectAll();
            this.poser = new Poser(param1);
            _canvas.parent.addChild(this.poser);
            this.poser.addEventListener(ActionEvent.GENERIC, this.poserHandler);
            this.poser.addEventListener(Poser.POSE_COMPLETE, this.closePoser);
            dispatchEvent(new ActionEvent(ActionEvent.GENERIC, _loc2_));
        }

        private function poserHandler(param1:ActionEvent):void
        {
            dispatchEvent(new ActionEvent(ActionEvent.GENERIC, param1.action));
        }

        public function closePoser(param1:Event = null):void
        {
            if (this.poser)
            {
                this.poser.removeEventListener(ActionEvent.GENERIC, this.poserHandler);
                this.poser.removeEventListener(Poser.POSE_COMPLETE, this.closePoser);
                this.poser.die();
                this.poser = null;
                Settings.debugText.text = "";
            }
        }

        public function openVertEdit(param1:EdgeShape, param2:Boolean = true):void
        {
            var _loc3_:Action = null;
            var _loc4_:Action = null;
            if (param2)
            {
                _loc3_ = this.deselectAll();
                _loc4_ = new ActionOpenVertEdit(param1, this);
                if (_loc3_)
                {
                    _loc3_.nextAction = _loc4_;
                }
            }
            this.vertEdit = new VertEdit(param1, this._currentCanvas);
            _canvas.parent.addChild(this.vertEdit);
            this.vertEdit.addEventListener(ActionEvent.GENERIC, this.vertEditHandler);
            this.vertEdit.addEventListener(VertEdit.EDIT_COMPLETE, this.closeVertEdit);
            if (param2)
            {
                dispatchEvent(new ActionEvent(ActionEvent.GENERIC, _loc4_));
            }
            if (param1 is ArtShape)
            {
                HelpWindow.instance.populate(this.helpArtEdit);
            }
            else
            {
                HelpWindow.instance.populate(this.helpPolyEdit);
            }
        }

        private function vertEditHandler(param1:ActionEvent):void
        {
            dispatchEvent(new ActionEvent(ActionEvent.GENERIC, param1.action));
        }

        public function closeVertEdit(param1:Event = null, param2:Boolean = true):void
        {
            var _loc3_:EdgeShape = null;
            var _loc4_:Action = null;
            var _loc5_:Action = null;
            var _loc6_:Number = NaN;
            var _loc7_:Number = NaN;
            var _loc8_:Action = null;
            if (this.vertEdit)
            {
                _loc3_ = this.vertEdit.edgeShape;
                if (param2)
                {
                    _loc4_ = this.vertEdit.deselectAll();
                    _loc5_ = new ActionCloseVertEdit(_loc3_, this);
                    if (_loc4_)
                    {
                        _loc4_.nextAction = _loc5_;
                    }
                }
                this.vertEdit.removeEventListener(ActionEvent.GENERIC, this.vertEditHandler);
                this.vertEdit.removeEventListener(VertEdit.EDIT_COMPLETE, this.closeVertEdit);
                this.vertEdit.die();
                this.vertEdit = null;
                Settings.debugText.text = "";
                if (param2)
                {
                    _loc6_ = _loc3_.x;
                    _loc7_ = _loc3_.y;
                    _loc3_.x = _loc6_;
                    _loc3_.y = _loc7_;
                    _loc8_ = _loc5_;
                    if (_loc3_.x != _loc6_ || _loc3_.y != _loc7_)
                    {
                        _loc8_ = new ActionTranslateUnbound(_loc3_, new Point(_loc6_, _loc7_), new Point(_loc3_.x, _loc3_.y));
                        _loc5_.nextAction = _loc8_;
                    }
                    dispatchEvent(new ActionEvent(ActionEvent.GENERIC, _loc8_));
                }
            }
            HelpWindow.instance.populate(this.helpMessage);
        }

        public function vertEditOpen():Boolean
        {
            if (this.vertEdit)
            {
                return true;
            }
            return false;
        }

        override public function resizeElements():void
        {
            if (this.vertEdit)
            {
                this.vertEdit.resizeVerts();
            }
        }

        private function copySelected():void
        {
            var _loc2_:RefSprite = null;
            var _loc3_:RefSprite = null;
            var _loc4_:RefJoint = null;
            var _loc5_:RefJoint = null;
            var _loc6_:int = 0;
            var _loc7_:RefTrigger = null;
            var _loc8_:RefTrigger = null;
            var _loc9_:Array = null;
            var _loc10_:Array = null;
            var _loc11_:int = 0;
            var _loc12_:int = 0;
            var _loc13_:RefSprite = null;
            var _loc14_:RefSprite = null;
            var _loc15_:String = null;
            var _loc16_:Dictionary = null;
            var _loc17_:Array = null;
            var _loc18_:* = undefined;
            var _loc19_:int = 0;
            trace("copy");
            if (this.currentSelection.length == 0)
            {
                return;
            }
            this.copiedSelection = new Array();
            var _loc1_:int = 0;
            while (_loc1_ < this.currentSelection.length)
            {
                _loc2_ = this.currentSelection[_loc1_] as RefSprite;
                _loc3_ = null;
                if (_loc2_.cloneable)
                {
                    _loc3_ = _loc2_.clone();
                    if (_loc3_ is RefJoint)
                    {
                        _loc4_ = _loc2_ as RefJoint;
                        _loc5_ = _loc3_ as RefJoint;
                        if (_loc4_.body1)
                        {
                            _loc6_ = int(this.currentSelection.indexOf(_loc4_.body1));
                            _loc5_.body1 = _loc6_ > -1 ? this.copiedSelection[_loc6_] : _loc4_.body1;
                        }
                        if (_loc4_.body2)
                        {
                            _loc6_ = int(this.currentSelection.indexOf(_loc4_.body2));
                            _loc5_.body2 = _loc6_ > -1 ? this.copiedSelection[_loc6_] : _loc4_.body2;
                        }
                        if (!_loc5_.body1 && !_loc5_.body2)
                        {
                            _loc3_ = null;
                        }
                    }
                }
                this.copiedSelection.push(_loc3_);
                _loc1_++;
            }
            _loc1_ = 0;
            while (_loc1_ < this.currentSelection.length)
            {
                _loc2_ = this.currentSelection[_loc1_];
                _loc3_ = this.copiedSelection[_loc1_];
                if (_loc2_ is RefTrigger && Boolean(_loc3_))
                {
                    _loc7_ = _loc2_ as RefTrigger;
                    _loc8_ = _loc3_ as RefTrigger;
                    _loc9_ = _loc7_.targets;
                    _loc10_ = _loc8_.cloneTargets;
                    _loc11_ = int(_loc9_.length);
                    _loc12_ = 0;
                    while (_loc12_ < _loc11_)
                    {
                        _loc13_ = _loc9_[_loc12_];
                        _loc6_ = int(this.currentSelection.indexOf(_loc13_));
                        _loc14_ = _loc6_ > -1 ? this.copiedSelection[_loc6_] : _loc13_;
                        _loc10_[_loc12_] = _loc14_;
                        trace("addedtarget " + _loc14_);
                        for (_loc15_ in _loc14_.keyedPropertyObject)
                        {
                            trace("prop " + _loc15_);
                            _loc16_ = _loc14_.keyedPropertyObject[_loc15_];
                            if (_loc16_)
                            {
                                if (_loc16_[_loc7_])
                                {
                                    trace("val 1: " + _loc16_[_loc7_]);
                                    _loc17_ = _loc16_[_loc7_];
                                    _loc18_ = new Array();
                                    _loc19_ = 0;
                                    while (_loc19_ < _loc17_.length)
                                    {
                                        _loc18_.push(_loc17_[_loc19_]);
                                        _loc19_++;
                                    }
                                    _loc16_[_loc8_] = _loc18_;
                                    trace("val 2: " + _loc16_[_loc8_]);
                                }
                            }
                        }
                        _loc12_++;
                    }
                }
                _loc1_++;
            }
            trace("current selection " + this.currentSelection);
            trace("copied selection " + this.copiedSelection);
        }

        private function paste(param1:Boolean = false):void
        {
            var _loc3_:Action = null;
            var _loc4_:Action = null;
            var _loc5_:Action = null;
            var _loc6_:int = 0;
            var _loc7_:RefSprite = null;
            var _loc8_:RefSprite = null;
            var _loc9_:RefJoint = null;
            var _loc10_:RefJoint = null;
            var _loc11_:int = 0;
            var _loc12_:RefSprite = null;
            var _loc13_:RefTrigger = null;
            var _loc14_:RefTrigger = null;
            var _loc15_:int = 0;
            var _loc16_:Array = null;
            var _loc17_:int = 0;
            var _loc18_:int = 0;
            var _loc19_:RefSprite = null;
            var _loc20_:RefSprite = null;
            var _loc21_:Action = null;
            var _loc22_:String = null;
            var _loc23_:Dictionary = null;
            var _loc24_:GroupCanvas = null;
            trace("paste");
            if (this.copiedSelection.length == 0)
            {
                return;
            }
            var _loc2_:Action = this.deselectAll();
            if (!(this._currentCanvas is GroupCanvas))
            {
                _loc6_ = 0;
                while (_loc6_ < this.copiedSelection.length)
                {
                    if (this.copiedSelection[_loc6_])
                    {
                        _loc7_ = this.copiedSelection[_loc6_];
                        _loc8_ = _loc7_.clone();
                        if (_loc8_ is RefShape || _loc8_ is Special || _loc8_ is RefGroup || _loc8_ is RefTrigger)
                        {
                            this._currentCanvas.addRefSprite(_loc8_);
                            trace("PARENT " + _loc8_.parent);
                            _loc8_.x = _loc8_.x;
                            _loc8_.y = _loc8_.y;
                            _loc4_ = new ActionAdd(_loc8_, this._currentCanvas, _loc8_.parent.getChildIndex(_loc8_));
                            _loc3_ = this.addToSelection(_loc8_);
                            _loc4_.nextAction = _loc3_;
                            if (_loc2_)
                            {
                                _loc2_.nextAction = _loc4_;
                            }
                            _loc2_ = _loc3_;
                        }
                        else
                        {
                            if (!(_loc8_ is RefJoint))
                            {
                                throw new Error("clone is unknown type or null");
                            }
                            this._currentCanvas.addRefSprite(_loc8_);
                            _loc8_.x = _loc8_.x;
                            _loc8_.y = _loc8_.y;
                            _loc3_ = this.addToSelection(_loc8_);
                            _loc4_ = new ActionAdd(_loc8_, this._currentCanvas, _loc8_.parent.getChildIndex(_loc8_));
                            _loc4_.nextAction = _loc3_;
                            if (_loc2_)
                            {
                                _loc2_.nextAction = _loc4_;
                            }
                            _loc2_ = _loc3_;
                            _loc9_ = _loc7_ as RefJoint;
                            _loc10_ = _loc8_ as RefJoint;
                            if (_loc9_.body1)
                            {
                                _loc11_ = int(this.copiedSelection.indexOf(_loc9_.body1));
                                _loc12_ = _loc11_ > -1 ? this.currentSelection[_loc11_] : _loc9_.body1;
                                _loc10_.body1 = _loc12_;
                                _loc5_ = new ActionProperty(_loc10_, "body1", null, _loc12_);
                                _loc2_.nextAction = _loc5_;
                                _loc2_ = _loc5_;
                            }
                            if (_loc9_.body2)
                            {
                                _loc11_ = int(this.copiedSelection.indexOf(_loc9_.body2));
                                _loc12_ = _loc11_ > -1 ? this.currentSelection[_loc11_] : _loc9_.body2;
                                _loc10_.body2 = _loc12_;
                                _loc5_ = new ActionProperty(_loc10_, "body2", null, _loc12_);
                                _loc2_.nextAction = _loc5_;
                                _loc2_ = _loc5_;
                            }
                            _loc10_.x = _loc10_.x;
                        }
                    }
                    _loc6_++;
                }
                _loc6_ = 0;
                while (_loc6_ < this.copiedSelection.length)
                {
                    if (this.copiedSelection[_loc6_])
                    {
                        _loc7_ = this.copiedSelection[_loc6_];
                        _loc8_ = this.currentSelection[_loc6_];
                        if (_loc7_ is RefTrigger)
                        {
                            _loc13_ = _loc7_ as RefTrigger;
                            _loc14_ = _loc8_ as RefTrigger;
                            _loc15_ = _loc14_.parent.getChildIndex(_loc14_);
                            _loc14_.setNumLabel(_loc15_ + 1);
                            _loc16_ = _loc13_.cloneTargets;
                            _loc17_ = int(_loc16_.length);
                            _loc18_ = 0;
                            while (_loc18_ < _loc17_)
                            {
                                _loc19_ = _loc16_[_loc18_];
                                _loc11_ = int(this.copiedSelection.indexOf(_loc19_));
                                _loc20_ = _loc11_ > -1 ? this.currentSelection[_loc11_] : _loc19_;
                                _loc21_ = _loc14_.addTarget(_loc20_);
                                _loc2_.nextAction = _loc21_;
                                _loc2_ = _loc21_;
                                for (_loc22_ in _loc20_.keyedPropertyObject)
                                {
                                    _loc23_ = _loc20_.keyedPropertyObject[_loc22_];
                                    if (_loc23_)
                                    {
                                        if (_loc23_[_loc13_])
                                        {
                                            _loc23_[_loc14_] = _loc23_[_loc13_];
                                        }
                                    }
                                }
                                _loc20_.setAttributes();
                                _loc18_++;
                            }
                            _loc14_.x = _loc14_.x;
                        }
                    }
                    _loc6_++;
                }
            }
            else
            {
                _loc24_ = this._currentCanvas as GroupCanvas;
                _loc6_ = 0;
                while (_loc6_ < this.copiedSelection.length)
                {
                    if (this.copiedSelection[_loc6_])
                    {
                        _loc7_ = this.copiedSelection[_loc6_];
                        _loc8_ = _loc7_.clone();
                        if ((_loc8_ is RefShape || _loc8_ is Special) && _loc8_.groupable)
                        {
                            this._currentCanvas.addRefSprite(_loc8_);
                            _loc8_.x = _loc8_.x;
                            _loc8_.y = _loc8_.y;
                            _loc8_.inGroup = true;
                            _loc8_.group = _loc24_.refGroup;
                            _loc8_.setFilters();
                            _loc4_ = new ActionAdd(_loc8_, this._currentCanvas, _loc8_.parent.getChildIndex(_loc8_));
                            _loc3_ = this.addToSelection(_loc8_);
                            _loc4_.nextAction = _loc3_;
                            if (_loc2_)
                            {
                                _loc2_.nextAction = _loc4_;
                            }
                            _loc2_ = _loc3_;
                        }
                    }
                    _loc6_++;
                }
            }
            this.setInputs();
            if (_loc2_)
            {
                dispatchEvent(new ActionEvent(ActionEvent.GENERIC, _loc2_));
            }
            if (!param1)
            {
                this.centerSelected();
            }
        }

        private function centerSelected():void
        {
            if (this.currentSelection.length == 0)
            {
                return;
            }
            var _loc1_:RefSprite = this.currentSelection[0];
            var _loc2_:Rectangle = _loc1_.getBounds(this._currentCanvas);
            var _loc3_:int = 1;
            while (_loc3_ < this.currentSelection.length)
            {
                _loc1_ = this.currentSelection[_loc3_];
                _loc2_ = _loc2_.union(_loc1_.getBounds(this._currentCanvas));
                _loc3_++;
            }
            var _loc4_:Point = new Point(stage.stageWidth / 2, stage.stageHeight / 2);
            _loc4_ = this._currentCanvas.globalToLocal(_loc4_);
            var _loc5_:int = _loc4_.x - (_loc2_.x + _loc2_.width / 2);
            var _loc6_:int = _loc4_.y - (_loc2_.y + _loc2_.height / 2);
            _loc3_ = 0;
            while (_loc3_ < this.currentSelection.length)
            {
                _loc1_ = this.currentSelection[_loc3_];
                _loc1_.x += _loc5_;
                _loc1_.y += _loc6_;
                _loc3_++;
            }
        }

        private function moveSelected(param1:Number, param2:Number, param3:Boolean):void
        {
            var _loc4_:Action = null;
            var _loc5_:Action = null;
            var _loc7_:RefSprite = null;
            if (this.dragging)
            {
                return;
            }
            if (this.currentSelection.length == 0)
            {
                return;
            }
            if (param3)
            {
                param1 *= 10;
                param2 *= 10;
            }
            param1 *= 1 / _canvas.parent.scaleX;
            param2 *= 1 / _canvas.parent.scaleY;
            var _loc6_:int = 0;
            while (_loc6_ < this.currentSelection.length)
            {
                _loc7_ = this.currentSelection[_loc6_] as RefSprite;
                if (!this.translating)
                {
                    _loc4_ = new ActionTranslate(_loc7_, new Point(_loc7_.x, _loc7_.y));
                    if (_loc5_)
                    {
                        _loc4_.prevAction = _loc5_;
                    }
                    _loc5_ = _loc4_;
                }
                _loc7_.x += param1;
                _loc7_.y += param2;
                _loc6_++;
            }
            this.updateInputValues();
            if (!this.translating && Boolean(_loc5_))
            {
                dispatchEvent(new ActionEvent(ActionEvent.TRANSLATE, _loc4_));
                this.translating = true;
            }
        }

        private function raiseDepthSelected():void
        {
            var _loc1_:ActionDepth = null;
            var _loc2_:ActionDepth = null;
            var _loc3_:DisplayObjectContainer = null;
            var _loc4_:int = 0;
            var _loc5_:int = 0;
            var _loc6_:Boolean = false;
            var _loc8_:RefSprite = null;
            var _loc9_:DisplayObjectContainer = null;
            var _loc10_:int = 0;
            var _loc11_:int = 0;
            if (this.dragging)
            {
                return;
            }
            if (this.currentSelection.length == 0)
            {
                return;
            }
            var _loc7_:int = int(this.currentSelection.length - 1);
            while (_loc7_ > -1)
            {
                _loc8_ = this.currentSelection[_loc7_] as RefSprite;
                _loc9_ = _loc8_.parent;
                if (_loc8_ is RefTrigger)
                {
                    _loc6_ = true;
                }
                if (_loc9_ != _loc3_)
                {
                    _loc4_ = 10000000;
                    _loc3_ = _loc9_;
                    _loc5_ = _loc9_.numChildren;
                }
                _loc10_ = _loc9_.getChildIndex(_loc8_);
                _loc11_ = _loc10_ + 1;
                if (_loc11_ < _loc5_ && _loc11_ < _loc4_)
                {
                    _loc9_.addChildAt(_loc8_, _loc11_);
                    _loc1_ = new ActionDepth(_loc8_, _loc9_, _loc11_, _loc10_);
                    if (_loc2_)
                    {
                        _loc2_.nextAction = _loc1_;
                    }
                    _loc2_ = _loc1_;
                    _loc4_ = _loc11_;
                }
                else
                {
                    _loc4_ = _loc10_;
                }
                _loc7_--;
            }
            if (_loc6_)
            {
                _canvas.relabelTriggers();
            }
            if (_loc1_)
            {
                dispatchEvent(new ActionEvent(ActionEvent.DEPTH, _loc1_));
            }
        }

        private function lowerDepthSelected():void
        {
            var _loc1_:ActionDepth = null;
            var _loc2_:ActionDepth = null;
            var _loc3_:DisplayObjectContainer = null;
            var _loc4_:int = 0;
            var _loc5_:Boolean = false;
            var _loc7_:RefSprite = null;
            var _loc8_:DisplayObjectContainer = null;
            var _loc9_:int = 0;
            var _loc10_:int = 0;
            if (this.dragging)
            {
                return;
            }
            if (this.currentSelection.length == 0)
            {
                return;
            }
            var _loc6_:int = 0;
            while (_loc6_ < this.currentSelection.length)
            {
                _loc7_ = this.currentSelection[_loc6_] as RefSprite;
                if (_loc7_ is RefTrigger)
                {
                    _loc5_ = true;
                }
                _loc8_ = _loc7_.parent;
                if (_loc8_ != _loc3_)
                {
                    _loc4_ = -1;
                    _loc3_ = _loc8_;
                }
                _loc9_ = _loc8_.getChildIndex(_loc7_);
                _loc10_ = _loc9_ - 1;
                if (_loc10_ < _loc9_ && _loc10_ > _loc4_)
                {
                    _loc8_.addChildAt(_loc7_, _loc10_);
                    _loc1_ = new ActionDepth(_loc7_, _loc8_, _loc10_, _loc9_);
                    if (_loc2_)
                    {
                        _loc2_.nextAction = _loc1_;
                    }
                    _loc2_ = _loc1_;
                    _loc4_ = _loc10_;
                }
                else
                {
                    _loc4_ = _loc9_;
                }
                _loc6_++;
            }
            if (_loc5_)
            {
                _canvas.relabelTriggers();
            }
            if (_loc1_)
            {
                dispatchEvent(new ActionEvent(ActionEvent.DEPTH, _loc1_));
            }
        }

        private function adjustScale(param1:Number, param2:Number, param3:Boolean):void
        {
            var _loc4_:Action = null;
            var _loc5_:Action = null;
            var _loc6_:Action = null;
            var _loc8_:RefSprite = null;
            if (this.currentSelection.length == 0)
            {
                return;
            }
            if (param3)
            {
                param1 *= 10;
                param2 *= 10;
            }
            var _loc7_:int = 0;
            while (_loc7_ < this.currentSelection.length)
            {
                _loc8_ = this.currentSelection[_loc7_];
                if (_loc8_.scalable)
                {
                    if (!this.scaling)
                    {
                        _loc5_ = new ActionTranslate(_loc8_, new Point(_loc8_.x, _loc8_.y));
                        _loc4_ = new ActionScale(_loc8_, _loc8_.scaleX, _loc8_.scaleY);
                        _loc5_.nextAction = _loc4_;
                        if (_loc6_)
                        {
                            _loc5_.prevAction = _loc6_;
                        }
                        _loc6_ = _loc4_;
                    }
                    _loc8_.shapeWidth += param1;
                    _loc8_.shapeHeight += param2;
                }
                _loc7_++;
            }
            this.updateInputValues();
            if (!this.scaling && Boolean(_loc6_))
            {
                dispatchEvent(new ActionEvent(ActionEvent.SCALE, _loc4_));
                this.scaling = true;
            }
        }

        private function adjustRotation(param1:Number, param2:Boolean):void
        {
            var _loc3_:Action = null;
            var _loc4_:Action = null;
            var _loc5_:Action = null;
            var _loc7_:RefSprite = null;
            if (this.currentSelection.length == 0)
            {
                return;
            }
            if (param2)
            {
                param1 *= 10;
            }
            var _loc6_:int = 0;
            while (_loc6_ < this.currentSelection.length)
            {
                _loc7_ = this.currentSelection[_loc6_];
                if (_loc7_.rotatable)
                {
                    if (!this.rotating)
                    {
                        _loc4_ = new ActionTranslate(_loc7_, new Point(_loc7_.x, _loc7_.y));
                        _loc3_ = new ActionRotate(_loc7_, _loc7_.angle);
                        _loc4_.nextAction = _loc3_;
                        if (_loc5_)
                        {
                            _loc4_.prevAction = _loc5_;
                        }
                        _loc5_ = _loc3_;
                    }
                    _loc7_.angle += param1;
                }
                _loc6_++;
            }
            this.updateInputValues();
            if (!this.rotating && Boolean(_loc5_))
            {
                dispatchEvent(new ActionEvent(ActionEvent.ROTATE, _loc3_));
                this.rotating = true;
            }
        }

        private function convertGroupToVehicle(param1:MouseEvent):void
        {
            var _loc3_:Action = null;
            var _loc5_:RefGroup = null;
            var _loc6_:int = 0;
            var _loc7_:RefVehicle = null;
            var _loc8_:ActionAdd = null;
            var _loc9_:Action = null;
            var _loc10_:Action = null;
            var _loc11_:Action = null;
            var _loc12_:RefJoint = null;
            var _loc13_:Point = null;
            var _loc14_:ActionProperty = null;
            var _loc2_:Array = new Array();
            var _loc4_:int = 0;
            while (_loc4_ < this.currentSelection.length)
            {
                _loc5_ = this.currentSelection[_loc4_];
                _loc6_ = _loc5_.parent.getChildIndex(_loc5_);
                _loc7_ = _loc5_.vehicleClone();
                this._currentCanvas.addRefSpriteAt(_loc7_, _loc6_);
                _loc7_.x = _loc7_.x;
                _loc7_.y = _loc7_.y;
                _loc8_ = new ActionAdd(_loc7_, this._currentCanvas, _loc6_);
                if (_loc3_)
                {
                    _loc8_.prevAction = _loc3_.lastAction;
                }
                _loc3_ = _loc8_;
                while (_loc5_.joints.length > 0)
                {
                    _loc12_ = _loc5_.joints[0];
                    _loc13_ = new Point(_loc12_.x, _loc12_.y);
                    if (_loc12_.body1 == _loc5_)
                    {
                        _loc12_.body1 = _loc7_;
                        _loc14_ = new ActionProperty(_loc12_, "body1", _loc5_, _loc7_, _loc13_, _loc13_);
                    }
                    else
                    {
                        _loc12_.body2 = _loc7_;
                        _loc14_ = new ActionProperty(_loc12_, "body2", _loc5_, _loc7_, _loc13_, _loc13_);
                    }
                    _loc3_.nextAction = _loc14_;
                    _loc3_ = _loc14_;
                }
                _loc9_ = this.removeFromSelection(_loc5_);
                _loc3_.nextAction = _loc9_.firstAction;
                _loc10_ = _loc5_.deleteSelf(this._currentCanvas);
                _loc9_.nextAction = _loc10_.firstAction;
                _loc11_ = this.addToSelection(_loc7_);
                _loc11_.prevAction = _loc10_.lastAction;
                _loc3_ = _loc11_.lastAction;
                _loc4_++;
            }
            this.setInputs();
            dispatchEvent(new ActionEvent(ActionEvent.GENERIC, _loc3_));
        }

        public function convertVehicleToGroup(param1:MouseEvent):void
        {
            var _loc3_:Action = null;
            var _loc5_:RefVehicle = null;
            var _loc6_:int = 0;
            var _loc7_:RefGroup = null;
            var _loc8_:ActionAdd = null;
            var _loc9_:Action = null;
            var _loc10_:Action = null;
            var _loc11_:Action = null;
            var _loc12_:RefJoint = null;
            var _loc13_:Point = null;
            var _loc14_:ActionProperty = null;
            var _loc2_:Array = new Array();
            var _loc4_:int = 0;
            while (_loc4_ < this.currentSelection.length)
            {
                _loc5_ = this.currentSelection[_loc4_];
                _loc6_ = _loc5_.parent.getChildIndex(_loc5_);
                _loc7_ = _loc5_.cloneAsGroup();
                this._currentCanvas.addRefSpriteAt(_loc7_, _loc6_);
                _loc7_.x = _loc7_.x;
                _loc7_.y = _loc7_.y;
                _loc8_ = new ActionAdd(_loc7_, this._currentCanvas, _loc6_);
                if (_loc3_)
                {
                    _loc8_.prevAction = _loc3_.lastAction;
                }
                _loc3_ = _loc8_;
                while (_loc5_.joints.length > 0)
                {
                    _loc12_ = _loc5_.joints[0];
                    _loc13_ = new Point(_loc12_.x, _loc12_.y);
                    if (_loc12_.body1 == _loc5_)
                    {
                        _loc12_.body1 = _loc7_;
                        _loc14_ = new ActionProperty(_loc12_, "body1", _loc5_, _loc7_, _loc13_, _loc13_);
                    }
                    else
                    {
                        _loc12_.body2 = _loc7_;
                        _loc14_ = new ActionProperty(_loc12_, "body2", _loc5_, _loc7_, _loc13_, _loc13_);
                    }
                    _loc3_.nextAction = _loc14_;
                    _loc3_ = _loc14_;
                }
                _loc9_ = this.removeFromSelection(_loc5_);
                _loc3_.nextAction = _loc9_.firstAction;
                _loc10_ = _loc5_.deleteSelf(this._currentCanvas);
                _loc9_.nextAction = _loc10_.firstAction;
                _loc11_ = this.addToSelection(_loc7_);
                _loc11_.prevAction = _loc10_.lastAction;
                _loc3_ = _loc11_.lastAction;
                _loc4_++;
            }
            this.setInputs();
            dispatchEvent(new ActionEvent(ActionEvent.GENERIC, _loc3_));
        }

        public function setShapeAsHandle(param1:MouseEvent):void
        {
            var _loc2_:ActionProperty = null;
            var _loc3_:ActionProperty = null;
            var _loc5_:RefShape = null;
            var _loc4_:int = 0;
            while (_loc4_ < this.currentSelection.length)
            {
                _loc5_ = this.currentSelection[_loc4_];
                _loc5_.vehicleHandle = true;
                _loc3_ = new ActionProperty(_loc5_, "vehicleHandle", false, true);
                if (_loc2_)
                {
                    _loc2_.nextAction = _loc3_;
                }
                _loc2_ = _loc3_;
                _loc4_++;
            }
            this.setInputs();
            dispatchEvent(new ActionEvent(ActionEvent.GENERIC, _loc3_));
        }

        public function removeHandleProperty(param1:MouseEvent):void
        {
            var _loc2_:ActionProperty = null;
            var _loc3_:ActionProperty = null;
            var _loc5_:RefShape = null;
            var _loc4_:int = 0;
            while (_loc4_ < this.currentSelection.length)
            {
                _loc5_ = this.currentSelection[_loc4_];
                _loc5_.vehicleHandle = false;
                _loc3_ = new ActionProperty(_loc5_, "vehicleHandle", true, false);
                if (_loc2_)
                {
                    _loc2_.nextAction = _loc3_;
                }
                _loc2_ = _loc3_;
                _loc4_++;
            }
            this.setInputs();
            dispatchEvent(new ActionEvent(ActionEvent.GENERIC, _loc3_));
        }

        public function addNewTarget(param1:MouseEvent):void
        {
            this.beginTriggerSelector();
        }

        public function removeTarget(param1:MouseEvent):void
        {
            var _loc2_:Action = null;
            var _loc3_:Action = null;
            var _loc5_:RefTrigger = null;
            var _loc4_:int = 0;
            while (_loc4_ < this.currentSelection.length)
            {
                _loc5_ = this.currentSelection[_loc4_];
                _loc2_ = _loc5_.removeLastTarget();
                if (_loc3_)
                {
                    _loc3_.nextAction = _loc2_;
                }
                _loc3_ = _loc2_;
                _loc4_++;
            }
            dispatchEvent(new ActionEvent(ActionEvent.GENERIC, _loc2_));
        }

        public function setInputs():void
        {
            var _loc11_:* = undefined;
            var _loc12_:int = 0;
            var _loc13_:int = 0;
            var _loc14_:String = null;
            var _loc15_:Object = null;
            var _loc16_:int = 0;
            var _loc17_:Boolean = false;
            var _loc18_:int = 0;
            var _loc19_:Array = null;
            var _loc20_:String = null;
            var _loc21_:* = undefined;
            var _loc22_:* = undefined;
            var _loc23_:InputObject = null;
            var _loc24_:InputObject = null;
            trace("SET INPUTS");
            var _loc1_:int = int(this.currentSelection.length);
            if (_loc1_ == 0)
            {
                this.removeInputs();
                this.labelText.text = "nothing selected";
                this.inputMask.height = 0;
                this.disableScrolling();
                window.setDimensions(this.windowWidth, this.height + 5);
                return;
            }
            var _loc2_:Array = this.currentAttributes;
            var _loc3_:Array = this.inputs;
            var _loc4_:RefSprite = this.currentSelection[0];
            var _loc5_:String = _loc4_.name;
            var _loc6_:Boolean = true;
            var _loc7_:Array = new Array();
            var _loc8_:int = 0;
            while (_loc8_ < _loc4_.attributes.length)
            {
                _loc11_ = _loc4_.attributes[_loc8_];
                _loc7_.push(_loc11_);
                _loc8_++;
            }
            _loc8_ = 1;
            while (_loc8_ < _loc1_)
            {
                _loc4_ = this.currentSelection[_loc8_];
                if (_loc4_.name != _loc5_)
                {
                    _loc6_ = false;
                }
                _loc12_ = 0;
                while (_loc12_ < _loc7_.length)
                {
                    _loc11_ = _loc7_[_loc12_];
                    if (_loc11_ is String)
                    {
                        _loc13_ = int(_loc4_.attributes.indexOf(_loc11_));
                        if (_loc13_ < 0)
                        {
                            _loc7_.splice(_loc12_, 1);
                            _loc12_--;
                        }
                    }
                    else
                    {
                        _loc14_ = _loc11_[0];
                        _loc15_ = _loc11_[1];
                        _loc16_ = int(_loc11_[2]);
                        _loc17_ = false;
                        _loc18_ = 0;
                        while (_loc18_ < _loc4_.attributes.length)
                        {
                            if (_loc4_.attributes[_loc18_] is Array)
                            {
                                _loc19_ = _loc4_.attributes[_loc18_];
                                if (_loc19_[0] == _loc14_ && _loc19_[1] == _loc15_ && _loc19_[2] == _loc16_)
                                {
                                    _loc17_ = true;
                                }
                            }
                            _loc18_++;
                        }
                        if (!_loc17_)
                        {
                            _loc7_.splice(_loc12_, 1);
                            _loc12_--;
                        }
                    }
                    _loc12_++;
                }
                _loc8_++;
            }
            _loc4_ = this.currentSelection[0];
            if (_loc6_)
            {
                _loc20_ = _loc1_ > 1 ? "s" : "";
                this.labelText.text = "" + _loc5_ + _loc20_;
            }
            else
            {
                this.labelText.text = "multiple objects";
            }
            var _loc9_:int = int(_loc2_.length);
            _loc8_ = 0;
            while (_loc8_ < _loc2_.length)
            {
                _loc21_ = _loc7_[_loc8_];
                _loc22_ = _loc2_[_loc8_];
                if (_loc21_ is String && _loc22_ is String)
                {
                    if (_loc22_ != _loc21_)
                    {
                        _loc9_ = _loc8_;
                        _loc8_ = int(_loc2_.length);
                    }
                }
                else if (_loc21_ is Array && _loc22_ is Array)
                {
                    if (_loc21_[0] != _loc22_[0] || _loc21_[1] != _loc22_[1] || _loc21_[2] != _loc22_[2])
                    {
                        _loc9_ = 1;
                        _loc8_ = int(_loc2_.length);
                    }
                }
                else
                {
                    _loc9_ = 1;
                    _loc8_ = int(_loc2_.length);
                }
                _loc8_++;
            }
            this.removeInputs(_loc9_);
            var _loc10_:int = 0;
            if (_loc9_ > 0)
            {
                _loc24_ = this.inputs[this.inputs.length - 1];
                _loc10_ = _loc24_.y + _loc24_.height;
                if (_loc24_.childInputs)
                {
                    _loc12_ = 0;
                    while (_loc12_ < _loc24_.childInputs.length)
                    {
                        _loc23_ = _loc24_.childInputs[_loc12_];
                        _loc10_ += _loc23_.height;
                        _loc12_++;
                    }
                }
            }
            this.currentAttributes = _loc7_;
            _loc8_ = _loc9_;
            while (_loc8_ < this.currentAttributes.length)
            {
                _loc21_ = this.currentAttributes[_loc8_];
                if (this.currentAttributes[_loc8_] is Array)
                {
                    _loc24_ = AttributeReference.buildKeyedInput(_loc21_[0], _loc21_[1], _loc21_[2], _loc4_);
                }
                else
                {
                    _loc24_ = AttributeReference.buildInput(_loc21_);
                }
                _loc24_.y = _loc10_;
                _loc24_.x = this.indent;
                this.inputHolder.addChild(_loc24_);
                _loc24_.addEventListener(ValueEvent.VALUE_CHANGE, this.inputValueChange);
                if (_loc24_.expandable)
                {
                    _loc24_.addEventListener(ValueEvent.ADD_INPUT, this.inputAddInput);
                    _loc24_.addEventListener(ValueEvent.REMOVE_INPUT, this.inputRemoveInput);
                }
                this.inputs.push(_loc24_);
                _loc10_ += _loc24_.height;
                if (_loc24_.childInputs)
                {
                    _loc12_ = 0;
                    while (_loc12_ < _loc24_.childInputs.length)
                    {
                        _loc23_ = _loc24_.childInputs[_loc12_];
                        _loc23_.y = _loc10_;
                        _loc23_.x = this.indent;
                        this.inputHolder.addChild(_loc23_);
                        _loc10_ += _loc23_.height;
                        _loc12_++;
                    }
                }
                _loc8_++;
            }
            this.updateInputValues();
            this.setButtons();
            if (this.inputHolder.height > this.cutoffHeight)
            {
                this.inputMask.height = this.cutoffHeight + 5 - this.inputMask.y;
                window.setDimensions(this.windowWidth, this.cutoffHeight + 5);
                this.enableScrolling();
            }
            else
            {
                this.inputMask.height = this.inputHolder.height;
                this.disableScrolling();
                this.inputHolder.y = this.holderY;
                window.setDimensions(this.windowWidth, this.holderY + this.inputMask.height + 5);
            }
        }

        private function setButtons():void
        {
            var _loc6_:String = null;
            var _loc7_:int = 0;
            var _loc8_:int = 0;
            var _loc9_:String = null;
            var _loc10_:GenericButton = null;
            var _loc1_:int = int(this.currentSelection.length);
            var _loc2_:RefSprite = this.currentSelection[0];
            var _loc3_:Array = new Array();
            var _loc4_:int = 0;
            while (_loc4_ < _loc2_.functions.length)
            {
                _loc6_ = _loc2_.functions[_loc4_];
                _loc3_.push(_loc6_);
                _loc4_++;
            }
            _loc4_ = 1;
            while (_loc4_ < _loc1_)
            {
                _loc2_ = this.currentSelection[_loc4_];
                _loc7_ = 0;
                while (_loc7_ < _loc3_.length)
                {
                    _loc6_ = _loc3_[_loc7_];
                    _loc8_ = int(_loc2_.functions.indexOf(_loc6_));
                    if (_loc8_ < 0)
                    {
                        _loc3_.splice(_loc7_, 1);
                        _loc7_--;
                    }
                    _loc7_++;
                }
                _loc4_++;
            }
            var _loc5_:int = Math.ceil(this.inputHolder.height) + 5;
            this.currentFunctions = _loc3_;
            _loc4_ = 0;
            while (_loc4_ < this.currentFunctions.length)
            {
                _loc9_ = this.currentFunctions[_loc4_];
                _loc10_ = FunctionReference.buildButton(_loc9_);
                _loc10_.y = _loc5_;
                _loc10_.x = this.indent;
                this.inputHolder.addChild(_loc10_);
                _loc10_.addEventListener(MouseEvent.MOUSE_UP, this[_loc10_.functionString], false, 0, true);
                this.buttons.push(_loc10_);
                _loc5_ += Math.ceil(_loc10_.height) + 5;
                _loc4_++;
            }
        }

        private function updateInputValues():void
        {
            var _loc2_:InputObject = null;
            var _loc1_:int = 0;
            while (_loc1_ < this.inputs.length)
            {
                _loc2_ = this.inputs[_loc1_] as InputObject;
                this.updateInput(_loc2_);
                _loc1_++;
            }
        }

        private function updateInput(param1:InputObject):void
        {
            var _loc6_:* = undefined;
            var _loc7_:int = 0;
            var _loc8_:RefSprite = null;
            var _loc9_:Dictionary = null;
            var _loc10_:* = undefined;
            var _loc11_:int = 0;
            var _loc12_:InputObject = null;
            var _loc2_:String = param1.attribute;
            var _loc3_:Object = param1.multipleKey;
            var _loc4_:int = param1.multipleIndex;
            var _loc5_:Boolean = false;
            if (!_loc3_)
            {
                _loc6_ = this.currentSelection[0][_loc2_];
                _loc7_ = 1;
                while (_loc7_ < this.currentSelection.length)
                {
                    if (this.currentSelection[_loc7_][_loc2_] != _loc6_)
                    {
                        _loc5_ = true;
                        break;
                    }
                    _loc7_++;
                }
            }
            else
            {
                _loc8_ = this.currentSelection[0] as RefSprite;
                _loc9_ = _loc8_.keyedPropertyObject[_loc2_];
                if (!_loc9_)
                {
                    _loc9_ = _loc8_.keyedPropertyObject[_loc2_] = new Dictionary();
                }
                _loc6_ = _loc9_[_loc3_][_loc4_];
                if (!_loc6_)
                {
                    _loc9_[_loc3_][_loc4_] = _loc6_ = param1.defaultValue;
                }
                _loc7_ = 1;
                while (_loc7_ < this.currentSelection.length)
                {
                    _loc8_ = this.currentSelection[_loc7_];
                    _loc9_ = _loc8_.keyedPropertyObject[_loc2_];
                    if (!_loc9_)
                    {
                        _loc9_ = _loc8_.keyedPropertyObject[_loc2_] = new Dictionary();
                    }
                    _loc10_ = _loc9_[_loc3_][_loc4_];
                    if (!_loc10_)
                    {
                        _loc9_[_loc3_][_loc4_] = _loc10_ = param1.defaultValue;
                    }
                    if (_loc9_[_loc3_][_loc4_] != _loc6_)
                    {
                        _loc5_ = true;
                        break;
                    }
                    _loc7_++;
                }
            }
            if (_loc5_)
            {
                param1.setToAmbiguous();
            }
            else
            {
                param1.setValue(_loc6_);
                _loc11_ = 0;
                while (_loc11_ < param1.childInputs.length)
                {
                    _loc12_ = param1.childInputs[_loc11_];
                    this.updateInput(_loc12_);
                    _loc11_++;
                }
            }
        }

        private function removeInputs(param1:int = 0):void
        {
            var _loc3_:InputObject = null;
            var _loc4_:int = 0;
            var _loc5_:InputObject = null;
            var _loc6_:GenericButton = null;
            var _loc2_:int = param1;
            while (_loc2_ < this.inputs.length)
            {
                _loc3_ = this.inputs[_loc2_];
                _loc4_ = 0;
                while (_loc4_ < _loc3_.childInputs.length)
                {
                    _loc5_ = _loc3_.childInputs[_loc4_];
                    this.inputHolder.removeChild(_loc5_);
                    _loc4_++;
                }
                _loc3_.removeEventListener(ValueEvent.VALUE_CHANGE, this.inputValueChange);
                _loc3_.removeEventListener(ValueEvent.ADD_INPUT, this.inputAddInput);
                _loc3_.removeEventListener(ValueEvent.REMOVE_INPUT, this.inputRemoveInput);
                _loc3_.die();
                this.inputHolder.removeChild(_loc3_);
                this.inputs.splice(_loc2_, 1);
                this.currentAttributes.splice(_loc2_, 1);
                _loc2_--;
                _loc2_++;
            }
            _loc2_ = 0;
            while (_loc2_ < this.buttons.length)
            {
                _loc6_ = this.buttons[_loc2_];
                _loc6_.removeEventListener(MouseEvent.MOUSE_UP, this[_loc6_.functionString]);
                this.inputHolder.removeChild(_loc6_);
                _loc2_++;
            }
            this.buttons = new Array();
            this.currentFunctions = new Array();
        }

        private function inputValueChange(param1:ValueEvent):void
        {
            var _loc6_:Action = null;
            var _loc7_:Action = null;
            var _loc8_:int = 0;
            var _loc9_:RefSprite = null;
            var _loc2_:InputObject = param1.inputObject;
            var _loc3_:String = _loc2_.attribute;
            var _loc4_:Object = _loc2_.multipleKey;
            var _loc5_:int = _loc2_.multipleIndex;
            if (!_loc4_)
            {
                _loc8_ = 0;
                while (_loc8_ < this.currentSelection.length)
                {
                    _loc9_ = this.currentSelection[_loc8_];
                    _loc6_ = _loc9_.setProperty(_loc3_, param1.value);
                    if (_loc6_)
                    {
                        if (_loc7_)
                        {
                            _loc6_.firstAction.prevAction = _loc7_;
                        }
                        _loc7_ = _loc6_;
                    }
                    _loc8_++;
                }
            }
            else
            {
                _loc8_ = 0;
                while (_loc8_ < this.currentSelection.length)
                {
                    _loc9_ = this.currentSelection[_loc8_];
                    _loc6_ = _loc9_.setKeyedProperty(_loc3_, _loc4_, _loc5_, param1.value);
                    if (_loc6_)
                    {
                        if (_loc7_)
                        {
                            _loc6_.firstAction.prevAction = _loc7_;
                        }
                        _loc7_ = _loc6_;
                    }
                    _loc8_++;
                }
            }
            if (_loc6_)
            {
                dispatchEvent(new ActionEvent(ActionEvent.GENERIC, _loc6_));
            }
            if (param1.resetInputs)
            {
                this.setInputs();
            }
        }

        private function inputAddInput(param1:ValueEvent):void
        {
            var _loc6_:* = undefined;
            var _loc7_:Action = null;
            var _loc8_:Action = null;
            var _loc10_:RefSprite = null;
            var _loc11_:Dictionary = null;
            var _loc12_:Array = null;
            var _loc2_:InputObject = param1.inputObject;
            var _loc3_:String = _loc2_.attribute;
            var _loc4_:Object = _loc2_.multipleKey;
            var _loc5_:int = _loc2_.multipleIndex;
            var _loc9_:int = 0;
            while (_loc9_ < this.currentSelection.length)
            {
                _loc10_ = this.currentSelection[_loc9_];
                _loc11_ = _loc10_.keyedPropertyObject[_loc3_];
                _loc12_ = _loc11_[_loc4_];
                _loc6_ = _loc12_.length;
                if (_loc6_ < 10)
                {
                    _loc12_.push(_loc10_.triggerActionList[0]);
                    _loc10_.setAttributes();
                    _loc7_ = new ActionAddKeyedIndex(_loc10_, _loc3_, _loc4_, _loc5_);
                    if (_loc8_)
                    {
                        _loc8_.nextAction = _loc7_;
                    }
                    _loc8_ = _loc7_;
                }
                _loc9_++;
            }
            if (param1.resetInputs)
            {
                this.removeInputs();
                this.setInputs();
            }
            if (_loc8_)
            {
                dispatchEvent(new ActionEvent(ActionEvent.GENERIC, _loc8_));
            }
        }

        private function inputRemoveInput(param1:ValueEvent):void
        {
            var _loc6_:Array = null;
            var _loc7_:Action = null;
            var _loc8_:Action = null;
            var _loc10_:RefSprite = null;
            var _loc11_:Dictionary = null;
            var _loc12_:Object = null;
            var _loc13_:Array = null;
            var _loc14_:int = 0;
            var _loc15_:int = 0;
            var _loc16_:int = 0;
            var _loc17_:String = null;
            var _loc18_:Dictionary = null;
            var _loc19_:Array = null;
            var _loc2_:InputObject = param1.inputObject;
            var _loc3_:String = _loc2_.attribute;
            var _loc4_:Object = _loc2_.multipleKey;
            var _loc5_:int = _loc2_.multipleIndex;
            var _loc9_:int = 0;
            while (_loc9_ < this.currentSelection.length)
            {
                _loc10_ = this.currentSelection[_loc9_];
                _loc11_ = _loc10_.keyedPropertyObject[_loc3_];
                _loc12_ = new Object();
                _loc13_ = _loc11_[_loc4_];
                _loc14_ = int(_loc13_.length);
                if (_loc14_ > 1)
                {
                    _loc12_[_loc3_] = _loc13_[_loc5_];
                    _loc13_.splice(_loc5_, 1);
                    _loc15_ = 0;
                    while (_loc15_ < _loc10_.triggerActionList.length)
                    {
                        _loc6_ = _loc10_.triggerActionListProperties[_loc15_];
                        if (_loc6_)
                        {
                            _loc16_ = 0;
                            while (_loc16_ < _loc6_.length)
                            {
                                _loc17_ = _loc6_[_loc16_];
                                _loc18_ = _loc10_.keyedPropertyObject[_loc17_];
                                trace(_loc18_);
                                if (_loc18_)
                                {
                                    _loc19_ = _loc18_[_loc4_];
                                    if (_loc19_)
                                    {
                                        _loc12_[_loc17_] = _loc19_[_loc5_];
                                        _loc19_.splice(_loc5_, 1);
                                    }
                                }
                                _loc16_++;
                            }
                        }
                        _loc15_++;
                    }
                    _loc7_ = new ActionRemoveKeyedIndex(_loc10_, _loc3_, _loc4_, _loc5_, _loc12_);
                    if (_loc8_)
                    {
                        _loc8_.nextAction = _loc7_;
                    }
                    _loc8_ = _loc7_;
                    _loc10_.setAttributes();
                }
                _loc9_++;
            }
            if (param1.resetInputs)
            {
                this.removeInputs();
                this.setInputs();
            }
            if (_loc8_)
            {
                dispatchEvent(new ActionEvent(ActionEvent.GENERIC, _loc8_));
            }
        }

        public function updateCopiedVerts():void
        {
            var _loc6_:RefSprite = null;
            var _loc7_:PolygonShape = null;
            var _loc8_:int = 0;
            var _loc9_:ArtShape = null;
            var _loc10_:RefGroup = null;
            var _loc11_:Sprite = null;
            var _loc12_:int = 0;
            var _loc13_:DisplayObject = null;
            trace("UPDATE COPIED VERT IDS");
            var _loc1_:Array = new Array();
            var _loc2_:Array = new Array();
            var _loc3_:int = PolygonTool.getIDCounter();
            var _loc4_:int = ArtTool.getIDCounter();
            var _loc5_:int = 0;
            while (_loc5_ < this.copiedSelection.length)
            {
                _loc6_ = this.copiedSelection[_loc5_];
                if (_loc6_ is PolygonShape)
                {
                    _loc7_ = _loc6_ as PolygonShape;
                    _loc8_ = _loc7_.vID;
                    if (_loc1_[_loc8_])
                    {
                        _loc7_.vID = _loc1_[_loc8_];
                    }
                    else
                    {
                        _loc7_.vID = _loc3_;
                        _loc1_[_loc8_] = _loc3_;
                    }
                    _loc3_ += 1;
                }
                else if (_loc6_ is ArtShape)
                {
                    _loc9_ = _loc6_ as ArtShape;
                    _loc8_ = _loc9_.vID;
                    if (_loc2_[_loc8_])
                    {
                        _loc9_.vID = _loc2_[_loc8_];
                    }
                    else
                    {
                        _loc9_.vID = _loc4_;
                        _loc2_[_loc8_] = _loc4_;
                    }
                    _loc4_ += 1;
                }
                else if (_loc6_ is RefGroup)
                {
                    _loc10_ = _loc6_ as RefGroup;
                    _loc11_ = _loc10_.shapeContainer;
                    _loc12_ = 0;
                    while (_loc12_ < _loc11_.numChildren)
                    {
                        _loc13_ = _loc11_.getChildAt(_loc12_);
                        if (_loc13_ is PolygonShape)
                        {
                            _loc7_ = _loc13_ as PolygonShape;
                            _loc8_ = _loc7_.vID;
                            if (_loc1_[_loc8_])
                            {
                                _loc7_.vID = _loc1_[_loc8_];
                            }
                            else
                            {
                                _loc7_.vID = _loc3_;
                                _loc1_[_loc8_] = _loc3_;
                            }
                            _loc3_ += 1;
                        }
                        else if (_loc13_ is ArtShape)
                        {
                            _loc9_ = _loc6_ as ArtShape;
                            _loc8_ = _loc9_.vID;
                            if (_loc2_[_loc8_])
                            {
                                _loc9_.vID = _loc2_[_loc8_];
                            }
                            else
                            {
                                _loc9_.vID = _loc4_;
                                _loc2_[_loc8_] = _loc4_;
                            }
                            _loc4_ += 1;
                        }
                        _loc12_++;
                    }
                }
                _loc5_++;
            }
        }

        private function enableScrolling():void
        {
            if (!this.scrolling)
            {
                this.scrolling = true;
                this.scrollUpSprite = new ScrollUpSprite();
                addChild(this.scrollUpSprite);
                this.scrollUpSprite.y = this.holderY;
                this.scrollDownSprite = new ScrollUpSprite();
                addChild(this.scrollDownSprite);
                this.scrollDownSprite.y = this.cutoffHeight + 5;
                this.scrollDownSprite.scaleY = -1;
                addEventListener(Event.ENTER_FRAME, this.scrollInputs);
            }
        }

        private function disableScrolling():void
        {
            this.scrolling = false;
            if (this.scrollUpSprite)
            {
                removeChild(this.scrollUpSprite);
            }
            if (this.scrollDownSprite)
            {
                removeChild(this.scrollDownSprite);
            }
            this.scrollUpSprite = null;
            this.scrollDownSprite = null;
            removeEventListener(Event.ENTER_FRAME, this.scrollInputs);
        }

        private function scrollInputs(param1:Event):void
        {
            var _loc2_:Number = this.inputHolder.height;
            var _loc3_:Number = Math.round(this.holderY - (_loc2_ - this.inputMask.height) - 5);
            if (mouseX > 0 && mouseX < this.windowWidth)
            {
                if (mouseY >= this.cutoffHeight - 30 && mouseY <= this.cutoffHeight + 5)
                {
                    this.inputHolder.y -= 10;
                    if (this.inputHolder.y < _loc3_)
                    {
                        this.inputHolder.y = _loc3_;
                    }
                }
                else if (mouseY > 0 && mouseY < 35)
                {
                    this.inputHolder.y += 10;
                    if (this.inputHolder.y > this.holderY)
                    {
                        this.inputHolder.y = this.holderY;
                    }
                }
            }
            this.scrollUpSprite.visible = this.inputHolder.y == this.holderY ? false : true;
            this.scrollDownSprite.visible = this.inputHolder.y == _loc3_ ? false : true;
        }

        override public function die():void
        {
            super.die();
        }

        public function get currentCanvas():Canvas
        {
            return this._currentCanvas;
        }

        public function set currentCanvas(param1:Canvas):void
        {
            this._currentCanvas = param1;
        }
    }
}
