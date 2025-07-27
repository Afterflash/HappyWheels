package com.totaljerkface.game
{
    import com.totaljerkface.game.editor.MouseHelper;
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    
    public class ReplayProgressBar extends Sprite
    {
        private var bgBar:Sprite;
        
        private var progBar:Sprite;
        
        private var rightArrows:Sprite;
        
        private var leftArrows:Sprite;
        
        private const barWidth:int = 600;
        
        private const barHeight:int = 6;
        
        private const border:int = 2;
        
        private const minWidth:int = 10;
        
        private const remainder:int = 590;
        
        private const speedArray:Array = [5,15,30,60,100];
        
        private var speedIndex:int = 2;
        
        public function ReplayProgressBar()
        {
            super();
            this.drawShapes();
            addEventListener(MouseEvent.MOUSE_UP,this.mouseUpHandler);
            addEventListener(MouseEvent.MOUSE_OVER,this.mouseOverHandler);
        }
        
        private function drawShapes() : void
        {
            this.bgBar = new Sprite();
            addChild(this.bgBar);
            this.bgBar.graphics.beginFill(13421772);
            this.bgBar.graphics.drawRoundRect(-this.border,-this.border,this.barWidth + this.border * 2,this.barHeight + this.border * 2,this.border * 2,this.border * 2);
            this.bgBar.graphics.endFill();
            this.progBar = new Sprite();
            addChild(this.progBar);
            this.progBar.graphics.beginFill(16613761);
            this.progBar.graphics.drawRoundRect(0,0,this.barWidth,this.barHeight,this.border,this.border);
            this.progBar.graphics.endFill();
            this.progBar.scale9Grid = new Rectangle(this.border,this.border,5,2);
            this.updateProgress(0,1);
            var _loc1_:* = this.barHeight + this.border * 2;
            var _loc2_:Number = _loc1_ / 2;
            this.rightArrows = new Sprite();
            addChild(this.rightArrows);
            this.rightArrows.graphics.beginFill(13421772);
            this.rightArrows.graphics.lineTo(_loc1_,_loc2_);
            this.rightArrows.graphics.lineTo(0,_loc1_);
            this.rightArrows.graphics.lineTo(0,0);
            this.rightArrows.graphics.endFill();
            this.rightArrows.graphics.beginFill(13421772);
            this.rightArrows.graphics.moveTo(_loc2_,0);
            this.rightArrows.graphics.lineTo(_loc1_ + _loc2_,_loc2_);
            this.rightArrows.graphics.lineTo(_loc2_,_loc1_);
            this.rightArrows.graphics.lineTo(_loc2_,0);
            this.rightArrows.graphics.endFill();
            this.rightArrows.x = this.barWidth + 15;
            this.rightArrows.y = -this.border;
            this.leftArrows = new Sprite();
            addChild(this.leftArrows);
            this.leftArrows.graphics.beginFill(13421772);
            this.leftArrows.graphics.lineTo(0,_loc1_);
            this.leftArrows.graphics.lineTo(-_loc1_,_loc2_);
            this.leftArrows.graphics.lineTo(0,0);
            this.leftArrows.graphics.endFill();
            this.leftArrows.graphics.beginFill(13421772);
            this.leftArrows.graphics.moveTo(-_loc2_,0);
            this.leftArrows.graphics.lineTo(-_loc2_,_loc1_);
            this.leftArrows.graphics.lineTo(-(_loc1_ + _loc2_),_loc2_);
            this.leftArrows.graphics.lineTo(-_loc2_,0);
            this.leftArrows.graphics.endFill();
            this.leftArrows.x = -15;
            this.leftArrows.y = -this.border;
            this.leftArrows.buttonMode = this.rightArrows.buttonMode = true;
            tabChildren = false;
        }
        
        public function updateProgress(param1:int, param2:int) : void
        {
            var _loc3_:Number = param1 / param2;
            this.progBar.width = this.minWidth + Math.min(_loc3_ * this.remainder,this.remainder);
        }
        
        private function mouseUpHandler(param1:MouseEvent) : void
        {
            switch(param1.target)
            {
                case this.leftArrows:
                    this.decreaseSpeed();
                    break;
                case this.rightArrows:
                    this.increaseSpeed();
            }
        }
        
        private function mouseOverHandler(param1:MouseEvent) : void
        {
            switch(param1.target)
            {
                case this.leftArrows:
                    MouseHelper.instance.show("slower",this.leftArrows);
                    break;
                case this.rightArrows:
                    MouseHelper.instance.show("faster",this.rightArrows);
            }
        }
        
        private function increaseSpeed() : void
        {
            this.speedIndex = Math.min(this.speedArray.length - 1,this.speedIndex + 1);
            stage.frameRate = this.speedArray[this.speedIndex];
        }
        
        private function decreaseSpeed() : void
        {
            this.speedIndex = Math.max(0,this.speedIndex - 1);
            stage.frameRate = this.speedArray[this.speedIndex];
        }
        
        public function die() : void
        {
            removeEventListener(MouseEvent.MOUSE_UP,this.mouseUpHandler);
            removeEventListener(MouseEvent.MOUSE_OVER,this.mouseOverHandler);
            stage.frameRate = 30;
        }
    }
}

