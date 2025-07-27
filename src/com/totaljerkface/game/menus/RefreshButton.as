package com.totaljerkface.game.menus
{
    import com.totaljerkface.game.editor.MouseHelper;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.filters.BevelFilter;
    import flash.filters.DropShadowFilter;
    import flash.filters.GlowFilter;
    
    public class RefreshButton extends Sprite
    {
        protected var shapeSprite:Sprite;
        
        protected var areaSprite:Sprite;
        
        protected var bevelFilter:BevelFilter;
        
        protected var shadowFilter:DropShadowFilter;
        
        protected var glowFilter:GlowFilter;
        
        protected var glowStrength:Number = 0;
        
        protected var glowCounter:Number = 0;
        
        protected var glowStep:Number = 0.1;
        
        protected var shakeCounter:Number = 0;
        
        protected var shakeStep:Number = 1;
        
        protected var shakeMaxAngle:Number = 15;
        
        protected var maxGlowStrength:Number = 3;
        
        protected var mouseContact:Boolean;
        
        protected var spinActive:Boolean;
        
        protected var shakeActive:Boolean;
        
        protected var glowActive:Boolean;
        
        protected var _disableSpin:Boolean;
        
        public function RefreshButton()
        {
            super();
            mouseChildren = false;
            buttonMode = true;
            tabEnabled = false;
            this.areaSprite = new Sprite();
            addChild(this.areaSprite);
            this.areaSprite.graphics.beginFill(0);
            this.areaSprite.graphics.drawRect(0,0,20,20);
            this.areaSprite.graphics.endFill();
            this.areaSprite.visible = false;
            hitArea = this.areaSprite;
            this.shapeSprite = new RefreshShape();
            addChild(this.shapeSprite);
            this.shapeSprite.x = 10;
            this.shapeSprite.y = 10;
            this.bevelFilter = new BevelFilter(2,90,16777215,0.3,0,0.3,3,3,1,3);
            this.shadowFilter = new DropShadowFilter(2,90,0,1,4,4,0.25,3);
            this.glowFilter = new GlowFilter(4032711,1,5,5,0,3,false,false);
            alpha = 0.2;
            mouseEnabled = false;
            filters = [this.bevelFilter,this.shadowFilter];
            addEventListener(MouseEvent.ROLL_OVER,this.rollOverHandler,false,0,true);
            addEventListener(MouseEvent.ROLL_OUT,this.rollOutHandler,false,0,true);
            addEventListener(Event.ENTER_FRAME,this.step,false,0,true);
        }
        
        private function rollOverHandler(param1:MouseEvent = null) : void
        {
            this.mouseContact = true;
            this.shakeActive = true;
            MouseHelper.instance.show("refresh results",this);
        }
        
        private function rollOutHandler(param1:MouseEvent = null) : void
        {
            this.mouseContact = false;
        }
        
        private function step(param1:Event) : void
        {
            var _loc2_:Number = NaN;
            if(this.spinActive)
            {
                this.shapeSprite.rotation = (this.shapeSprite.rotation + 15) % 360;
                if(this.shapeSprite.rotation == 0 && this._disableSpin)
                {
                    this.spinActive = false;
                    this._disableSpin = false;
                }
            }
            else if(this.shakeActive)
            {
                _loc2_ = Math.PI * this.shakeCounter / 10;
                this.shapeSprite.rotation = Math.round(Math.sin(_loc2_) * 20);
                this.shakeCounter += this.shakeStep;
                if(this.shapeSprite.rotation == 0 && !this.mouseContact)
                {
                    this.shakeActive = false;
                }
            }
            if(this.glowActive)
            {
                this.glowFilter.strength = (-Math.cos(this.glowCounter) * 0.5 + 0.5) * this.maxGlowStrength;
                this.glowCounter += this.glowStep;
                filters = [this.bevelFilter,this.glowFilter,this.shadowFilter];
            }
        }
        
        public function setGlow(param1:Boolean) : void
        {
            if(param1 && !this.glowActive)
            {
                alpha = 1;
                mouseEnabled = true;
                this.glowActive = true;
                this.glowStrength = 0;
                this.glowCounter = 0;
                filters = [this.bevelFilter,this.glowFilter,this.shadowFilter];
            }
            else if(!param1)
            {
                alpha = 0.2;
                mouseEnabled = false;
                this.glowActive = false;
                filters = [this.bevelFilter,this.shadowFilter];
            }
        }
        
        public function set disableSpin(param1:Boolean) : void
        {
            this._disableSpin = param1;
        }
        
        public function setSpin(param1:Boolean) : *
        {
            if(param1 && !this.spinActive)
            {
                this.shakeActive = false;
                this.shakeCounter = 0;
                this.spinActive = true;
                this.shapeSprite.rotation -= this.shapeSprite.rotation % 15;
            }
            else if(!param1)
            {
                this._disableSpin = true;
            }
        }
    }
}

