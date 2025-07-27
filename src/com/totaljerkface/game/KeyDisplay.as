package com.totaljerkface.game
{
    import com.totaljerkface.game.character.CharacterB2D;
    import flash.display.Sprite;

    [Embed(source="/_assets/assets.swf", symbol="symbol131")]
    public class KeyDisplay extends Sprite
    {
        public var upKey:Sprite;

        public var downKey:Sprite;

        public var leftKey:Sprite;

        public var rightKey:Sprite;

        public var spaceKey:Sprite;

        public var shiftKey:Sprite;

        public var ctrlKey:Sprite;

        public var zKey:Sprite;

        private var char:CharacterB2D;

        private var alphaVal:Number = 0.2;

        public function KeyDisplay(param1:CharacterB2D)
        {
            super();
            this.char = param1;
            this.setupMCs();
        }

        private function setupMCs():void
        {
            this.upKey.cacheAsBitmap = true;
            this.downKey.cacheAsBitmap = true;
            this.leftKey.cacheAsBitmap = true;
            this.rightKey.cacheAsBitmap = true;
            this.spaceKey.cacheAsBitmap = true;
            this.shiftKey.cacheAsBitmap = true;
            this.ctrlKey.cacheAsBitmap = true;
            this.zKey.cacheAsBitmap = true;
            this.upKey.alpha = this.alphaVal;
            this.downKey.alpha = this.alphaVal;
            this.leftKey.alpha = this.alphaVal;
            this.rightKey.alpha = this.alphaVal;
            this.spaceKey.alpha = this.alphaVal;
            this.shiftKey.alpha = this.alphaVal;
            this.ctrlKey.alpha = this.alphaVal;
            this.zKey.alpha = this.alphaVal;
        }

        public function upKeyON():void
        {
            this.upKey.alpha = 1;
        }

        public function upKeyOFF():void
        {
            this.upKey.alpha = 0.2;
        }

        public function rightKeyON():void
        {
            this.rightKey.alpha = 1;
        }

        public function rightKeyOFF():void
        {
            this.rightKey.alpha = 0.2;
        }

        public function downKeyON():void
        {
            this.downKey.alpha = 1;
        }

        public function downKeyOFF():void
        {
            this.downKey.alpha = 0.2;
        }

        public function leftKeyON():void
        {
            this.leftKey.alpha = 1;
        }

        public function leftKeyOFF():void
        {
            this.leftKey.alpha = 0.2;
        }

        public function spaceKeyON():void
        {
            this.spaceKey.alpha = 1;
        }

        public function spaceKeyOFF():void
        {
            this.spaceKey.alpha = 0.2;
        }

        public function shiftKeyON():void
        {
            this.shiftKey.alpha = 1;
        }

        public function shiftKeyOFF():void
        {
            this.shiftKey.alpha = 0.2;
        }

        public function ctrlKeyON():void
        {
            this.ctrlKey.alpha = 1;
        }

        public function ctrlKeyOFF():void
        {
            this.ctrlKey.alpha = 0.2;
        }

        public function zKeyON():void
        {
            this.zKey.alpha = 1;
        }

        public function zKeyOFF():void
        {
            this.zKey.alpha = 0.2;
        }
    }
}
