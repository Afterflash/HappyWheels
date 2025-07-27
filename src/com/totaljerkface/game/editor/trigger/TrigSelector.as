package com.totaljerkface.game.editor.trigger
{
    import Box2D.Common.Math.b2Vec2;
    import com.totaljerkface.game.editor.*;
    import com.totaljerkface.game.editor.actions.Action;
    import com.totaljerkface.game.editor.specials.*;
    import flash.display.*;
    import flash.events.Event;
    import flash.events.MouseEvent;
    
    public class TrigSelector extends Sprite
    {
        public static const SELECT_COMPLETE:String = "selectcomplete";
        
        private var _trigger:RefTrigger;
        
        private var _triggers:Array;
        
        private var indexArray:Array;
        
        private var _canvas:Canvas;
        
        private var _targetRef:RefSprite;
        
        private var increment:Number = 0;
        
        public function TrigSelector(param1:Array, param2:Canvas)
        {
            super();
            trace("OK");
            this._triggers = param1;
            this._canvas = param2;
            param2.addChild(this);
            this.indexArray = new Array();
            addEventListener(Event.ENTER_FRAME,this.detectBodies);
            stage.addEventListener(MouseEvent.MOUSE_DOWN,this.mouseDownHandler);
        }
        
        private function detectBodies(param1:Event) : void
        {
            var _loc4_:b2Vec2 = null;
            var _loc7_:Boolean = false;
            var _loc10_:RefSprite = null;
            var _loc11_:Array = null;
            var _loc12_:int = 0;
            var _loc13_:RefTrigger = null;
            var _loc14_:int = 0;
            if(this._targetRef)
            {
                this._targetRef.alpha = 1;
            }
            this._targetRef = null;
            var _loc2_:Number = Infinity;
            var _loc3_:b2Vec2 = new b2Vec2(mouseX,mouseY);
            var _loc5_:Number = 0;
            var _loc6_:int = int(this._triggers.length);
            var _loc8_:int = this._canvas.shapes.numChildren;
            var _loc9_:int = 0;
            while(_loc9_ < _loc8_)
            {
                _loc10_ = this._canvas.shapes.getChildAt(_loc9_) as RefSprite;
                if(_loc10_.triggerable && _loc10_.hitTestPoint(stage.mouseX,stage.mouseY,true))
                {
                    _loc7_ = false;
                    _loc11_ = new Array();
                    _loc12_ = 0;
                    while(_loc12_ < _loc6_)
                    {
                        _loc13_ = this._triggers[_loc12_] as RefTrigger;
                        _loc14_ = int(_loc13_.targets.indexOf(_loc10_));
                        _loc11_[_loc12_] = _loc14_;
                        if(_loc14_ < 0)
                        {
                            _loc7_ = true;
                        }
                        _loc12_++;
                    }
                    if(_loc7_)
                    {
                        _loc4_ = new b2Vec2(_loc10_.x - _loc3_.x,_loc10_.y - _loc3_.y);
                        _loc5_ = _loc4_.LengthSquared();
                        if(_loc5_ < _loc2_)
                        {
                            this._targetRef = _loc10_;
                            _loc2_ = _loc5_;
                            this.indexArray = _loc11_;
                        }
                    }
                }
                _loc9_++;
            }
            _loc8_ = this._canvas.special.numChildren;
            _loc9_ = 0;
            while(_loc9_ < _loc8_)
            {
                _loc10_ = this._canvas.special.getChildAt(_loc9_) as RefSprite;
                if(_loc10_.triggerable && _loc10_.hitTestPoint(stage.mouseX,stage.mouseY,true))
                {
                    _loc7_ = false;
                    _loc11_ = new Array();
                    _loc12_ = 0;
                    while(_loc12_ < _loc6_)
                    {
                        _loc13_ = this._triggers[_loc12_] as RefTrigger;
                        _loc14_ = int(_loc13_.targets.indexOf(_loc10_));
                        _loc11_[_loc12_] = _loc14_;
                        if(_loc14_ < 0)
                        {
                            _loc7_ = true;
                        }
                        _loc12_++;
                    }
                    if(_loc7_)
                    {
                        _loc4_ = new b2Vec2(_loc10_.x - _loc3_.x,_loc10_.y - _loc3_.y);
                        _loc5_ = _loc4_.LengthSquared();
                        if(_loc5_ < _loc2_)
                        {
                            this._targetRef = _loc10_;
                            _loc2_ = _loc5_;
                            this.indexArray = _loc11_;
                        }
                    }
                }
                _loc9_++;
            }
            _loc8_ = this._canvas.groups.numChildren;
            _loc9_ = 0;
            while(_loc9_ < _loc8_)
            {
                _loc10_ = this._canvas.groups.getChildAt(_loc9_) as RefSprite;
                if(_loc10_.triggerable && _loc10_.hitTestPoint(stage.mouseX,stage.mouseY,true))
                {
                    _loc7_ = false;
                    _loc11_ = new Array();
                    _loc12_ = 0;
                    while(_loc12_ < _loc6_)
                    {
                        _loc13_ = this._triggers[_loc12_] as RefTrigger;
                        _loc14_ = int(_loc13_.targets.indexOf(_loc10_));
                        _loc11_[_loc12_] = _loc14_;
                        if(_loc14_ < 0)
                        {
                            _loc7_ = true;
                        }
                        _loc12_++;
                    }
                    if(_loc7_)
                    {
                        _loc4_ = new b2Vec2(_loc10_.x - _loc3_.x,_loc10_.y - _loc3_.y);
                        _loc5_ = _loc4_.LengthSquared();
                        if(_loc5_ < _loc2_)
                        {
                            this._targetRef = _loc10_;
                            _loc2_ = _loc5_;
                            this.indexArray = _loc11_;
                        }
                    }
                }
                _loc9_++;
            }
            _loc8_ = this._canvas.joints.numChildren;
            _loc9_ = 0;
            while(_loc9_ < _loc8_)
            {
                _loc10_ = this._canvas.joints.getChildAt(_loc9_) as RefSprite;
                if(_loc10_.triggerable && _loc10_.hitTestPoint(stage.mouseX,stage.mouseY,true))
                {
                    _loc7_ = false;
                    _loc11_ = new Array();
                    _loc12_ = 0;
                    while(_loc12_ < _loc6_)
                    {
                        _loc13_ = this._triggers[_loc12_] as RefTrigger;
                        _loc14_ = int(_loc13_.targets.indexOf(_loc10_));
                        _loc11_[_loc12_] = _loc14_;
                        if(_loc14_ < 0)
                        {
                            _loc7_ = true;
                        }
                        _loc12_++;
                    }
                    if(_loc7_)
                    {
                        _loc4_ = new b2Vec2(_loc10_.x - _loc3_.x,_loc10_.y - _loc3_.y);
                        _loc5_ = _loc4_.LengthSquared();
                        if(_loc5_ < _loc2_)
                        {
                            this._targetRef = _loc10_;
                            _loc2_ = _loc5_;
                            this.indexArray = _loc11_;
                        }
                    }
                }
                _loc9_++;
            }
            _loc8_ = this._canvas.triggers.numChildren;
            _loc9_ = 0;
            while(_loc9_ < _loc8_)
            {
                _loc10_ = this._canvas.triggers.getChildAt(_loc9_) as RefSprite;
                if(_loc10_.triggerable && _loc10_.hitTestPoint(stage.mouseX,stage.mouseY,true))
                {
                    _loc7_ = false;
                    _loc11_ = new Array();
                    _loc12_ = 0;
                    while(_loc12_ < _loc6_)
                    {
                        _loc13_ = this._triggers[_loc12_] as RefTrigger;
                        if(!(_loc10_ == _loc13_ || this.checkCircularLink(_loc13_,_loc10_ as RefTrigger)))
                        {
                            _loc14_ = int(_loc13_.targets.indexOf(_loc10_));
                            _loc11_[_loc12_] = _loc14_;
                            if(_loc14_ < 0)
                            {
                                _loc7_ = true;
                            }
                        }
                        _loc12_++;
                    }
                    if(_loc7_)
                    {
                        _loc4_ = new b2Vec2(_loc10_.x - _loc3_.x,_loc10_.y - _loc3_.y);
                        _loc5_ = _loc4_.LengthSquared();
                        if(_loc5_ < _loc2_)
                        {
                            this._targetRef = _loc10_;
                            _loc2_ = _loc5_;
                            this.indexArray = _loc11_;
                        }
                    }
                }
                _loc9_++;
            }
            this.drawArms();
        }
        
        private function checkCircularLink(param1:RefTrigger, param2:RefTrigger) : Boolean
        {
            var _loc5_:RefTrigger = null;
            var _loc3_:int = int(param1.triggers.length);
            var _loc4_:int = 0;
            if(_loc4_ >= _loc3_)
            {
                return false;
            }
            _loc5_ = param1.triggers[_loc4_];
            if(_loc5_ == param2)
            {
                return true;
            }
            return this.checkCircularLink(_loc5_,param2);
        }
        
        private function drawArms() : void
        {
            var _loc4_:int = 0;
            var _loc5_:RefTrigger = null;
            var _loc6_:int = 0;
            this.increment += 0.15;
            var _loc1_:Number = Math.sin(this.increment) * 0.4;
            var _loc2_:Number = 0.6 - _loc1_;
            var _loc3_:Number = 0.6 + _loc1_;
            graphics.clear();
            if(this._targetRef)
            {
                this._targetRef.alpha = _loc2_;
                graphics.lineStyle(3,16613761,_loc3_);
                _loc4_ = 0;
                while(_loc4_ < this._triggers.length)
                {
                    _loc5_ = this._triggers[_loc4_];
                    _loc6_ = int(this.indexArray[_loc4_]);
                    if(_loc6_ < 0)
                    {
                        graphics.moveTo(_loc5_.x,_loc5_.y);
                        graphics.lineTo(this._targetRef.x,this._targetRef.y);
                    }
                    _loc4_++;
                }
                graphics.beginFill(16613761,_loc3_);
                graphics.drawCircle(this._targetRef.x,this._targetRef.y,3);
                graphics.endFill();
            }
            else
            {
                graphics.lineStyle(1,16613761,_loc3_);
                _loc4_ = 0;
                while(_loc4_ < this._triggers.length)
                {
                    _loc5_ = this._triggers[_loc4_];
                    graphics.moveTo(_loc5_.x,_loc5_.y);
                    graphics.lineTo(mouseX,mouseY);
                    _loc4_++;
                }
                graphics.beginFill(16613761,_loc3_);
                graphics.drawCircle(mouseX,mouseY,1.5);
                graphics.endFill();
            }
        }
        
        private function mouseDownHandler(param1:MouseEvent) : void
        {
            removeEventListener(MouseEvent.MOUSE_DOWN,this.mouseDownHandler);
            stage.addEventListener(MouseEvent.MOUSE_UP,this.mouseUpHandler);
        }
        
        private function mouseUpHandler(param1:MouseEvent) : void
        {
            var _loc2_:Action = null;
            var _loc3_:Action = null;
            var _loc4_:int = 0;
            var _loc5_:RefTrigger = null;
            var _loc6_:int = 0;
            if(this._targetRef)
            {
                _loc4_ = 0;
                while(_loc4_ < this._triggers.length)
                {
                    _loc5_ = this._triggers[_loc4_];
                    _loc6_ = int(this.indexArray[_loc4_]);
                    if(_loc6_ < 0)
                    {
                        _loc2_ = _loc5_.addTarget(this._targetRef);
                        if(_loc3_)
                        {
                            _loc3_.nextAction = _loc2_;
                        }
                        _loc3_ = _loc2_;
                    }
                    _loc4_++;
                }
                dispatchEvent(new ActionEvent(ActionEvent.GENERIC,_loc2_));
            }
            else
            {
                dispatchEvent(new Event(SELECT_COMPLETE));
            }
        }
        
        public function die() : void
        {
            if(this._targetRef)
            {
                this._targetRef.alpha = 1;
            }
            graphics.clear();
            removeEventListener(Event.ENTER_FRAME,this.detectBodies);
            stage.removeEventListener(MouseEvent.MOUSE_UP,this.mouseUpHandler);
            stage.removeEventListener(MouseEvent.MOUSE_DOWN,this.mouseDownHandler);
            this._canvas.removeChild(this);
        }
    }
}

