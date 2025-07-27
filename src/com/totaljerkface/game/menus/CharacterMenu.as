package com.totaljerkface.game.menus
{
    import com.totaljerkface.game.*;
    import com.totaljerkface.game.sound.SoundController;
    import flash.display.*;
    import flash.events.*;

    [Embed(source="/_assets/assets.swf", symbol="symbol2866")]
    public class CharacterMenu extends Sprite
    {
        public static const CHARACTER_SELECTED:String = "characterselected";

        public var spotlight1:Sprite;

        public var spotlight2:Sprite;

        public var altar:Sprite;

        private var bg:Sprite;

        private var smokeSprite1:Sprite;

        private var smokeSprite2:Sprite;

        private var scrollSpeedX:int = 2;

        private var scrollSpeedY:int = 1;

        private var scaleInc1:Number = 0;

        private var rotInc1:Number = 0;

        private var scaleInc2:Number = 3.14;

        private var rotInc2:Number = 3.14;

        private var characterLoader:SwfLoader;

        private var session:SessionCharacterMenu;

        private var iconHolder:Sprite;

        private var icons:Array;

        private var selectedIcon:CharacterIcon;

        public function CharacterMenu()
        {
            super();
            Settings.stageSprite = stage;
            Settings.characterIndex = 1;
            this.buildStage();
            this.buildMenu();
            SoundController.instance.playSoundItem("DrumLong");
            addEventListener(Event.ENTER_FRAME, this.scrollSmoke);
            this.loadCharacter();
            this.iconHolder.addEventListener(MouseEvent.MOUSE_OVER, this.iconMouseOverHandler);
            this.iconHolder.addEventListener(MouseEvent.MOUSE_UP, this.iconMouseUpHandler);
        }

        private function buildStage():void
        {
            var _loc4_:BitmapData = null;
            var _loc5_:BitmapData = null;
            this.bg = new Sprite();
            var _loc1_:int = 900;
            var _loc2_:int = 500;
            this.bg.graphics.beginFill(51);
            this.bg.graphics.drawRect(0, 0, _loc1_, _loc2_);
            this.bg.graphics.endFill();
            var _loc3_:BitmapManager = BitmapManager.instance;
            if (_loc3_.getTexture("smoke1") == null)
            {
                _loc4_ = new BitmapData(_loc1_, _loc2_, true);
                _loc4_.perlinNoise(_loc1_, _loc2_, 10, 4, true, true, BitmapDataChannel.ALPHA, true, null);
                _loc5_ = new BitmapData(_loc1_, _loc2_, true);
                _loc5_.perlinNoise(_loc1_, _loc2_, 10, 4, true, true, BitmapDataChannel.ALPHA, true, null);
                _loc3_.addTexture("smoke1", _loc4_);
                _loc3_.addTexture("smoke2", _loc5_);
            }
            else
            {
                _loc4_ = _loc3_.getTexture("smoke1");
                _loc5_ = _loc3_.getTexture("smoke2");
            }
            this.smokeSprite1 = new Sprite();
            this.smokeSprite1.graphics.beginBitmapFill(_loc4_, null, true);
            this.smokeSprite1.graphics.drawRect(0, 0, _loc1_ * 2, _loc2_ * 2);
            this.smokeSprite1.graphics.endFill();
            this.smokeSprite2 = new Sprite();
            this.smokeSprite2.graphics.beginBitmapFill(_loc5_, null, true);
            this.smokeSprite2.graphics.drawRect(0, 0, _loc1_ * 2, _loc2_ * 2);
            this.smokeSprite2.graphics.endFill();
            this.smokeSprite2.blendMode = BlendMode.HARDLIGHT;
            this.smokeSprite1.alpha = 0.5;
            this.smokeSprite2.alpha = 0.5;
            addChildAt(this.altar, 0);
            addChildAt(this.spotlight2, 0);
            addChildAt(this.spotlight1, 0);
            addChildAt(this.smokeSprite2, 0);
            addChildAt(this.smokeSprite1, 0);
            addChildAt(this.bg, 0);
        }

        private function buildMenu():void
        {
            var _loc1_:int = 0;
            var _loc2_:CharacterIcon = null;
            this.iconHolder = new Sprite();
            this.iconHolder.x = 500;
            this.iconHolder.y = 120;
            addChild(this.iconHolder);
            this.icons = new Array();
            _loc1_ = 0;
            while (_loc1_ < 25)
            {
                _loc2_ = new CharacterIcon(_loc1_ + 1);
                this.iconHolder.addChild(_loc2_);
                _loc2_.x = _loc1_ % 5 * 60;
                _loc2_.y = Math.floor(_loc1_ * 0.2) * 60;
                this.icons.push(_loc2_);
                _loc1_++;
            }
            _loc2_ = this.icons[0];
            _loc2_.selected = true;
            this.selectedIcon = _loc2_;
        }

        private function iconMouseOverHandler(param1:MouseEvent):void
        {
            var _loc2_:CharacterIcon = null;
            if (param1.target is CharacterIcon)
            {
                _loc2_ = param1.target as CharacterIcon;
                if (_loc2_ == this.selectedIcon || _loc2_.selectable == false)
                {
                    return;
                }
                this.selectedIcon.selected = false;
                _loc2_.selected = true;
                this.selectedIcon = _loc2_;
                this.loadCharacter();
                SoundController.instance.playSoundItem("SelectCharacter");
            }
        }

        private function iconMouseUpHandler(param1:MouseEvent):void
        {
            var _loc2_:CharacterIcon = null;
            if (param1.target is CharacterIcon)
            {
                _loc2_ = param1.target as CharacterIcon;
                if (!_loc2_.selectable)
                {
                    return;
                }
                SoundController.instance.playSoundItem("MenuSelect");
                dispatchEvent(new Event(CHARACTER_SELECTED));
            }
        }

        private function scrollSmoke(param1:Event):void
        {
            this.smokeSprite1.x += this.scrollSpeedX * 2;
            this.smokeSprite1.y -= this.scrollSpeedY;
            this.smokeSprite2.x -= this.scrollSpeedX;
            this.smokeSprite2.y -= this.scrollSpeedY;
            if (this.smokeSprite1.x > 0)
            {
                this.smokeSprite1.x -= this.smokeSprite1.width / 2;
            }
            if (this.smokeSprite1.y < -this.smokeSprite1.height / 2)
            {
                this.smokeSprite1.y += this.smokeSprite1.height / 2;
            }
            if (this.smokeSprite2.x < -this.smokeSprite2.width / 2)
            {
                this.smokeSprite2.x += this.smokeSprite2.width / 2;
            }
            if (this.smokeSprite2.y < -this.smokeSprite2.height / 2)
            {
                this.smokeSprite2.y += this.smokeSprite2.height / 2;
            }
            this.adjustSpotlights();
        }

        private function adjustSpotlights():void
        {
            this.spotlight1.scaleY = Math.sin(this.scaleInc1) * 0.25 + 1.25;
            this.scaleInc1 += 0.01;
            this.spotlight1.rotation = Math.sin(this.rotInc1) * 15 + 10;
            this.rotInc1 += 0.04;
            this.spotlight2.scaleY = Math.cos(this.scaleInc2) * 0.25 + 1.25;
            this.scaleInc2 -= 0.012;
            this.spotlight2.rotation = Math.cos(this.rotInc2) * 15 - 10;
            this.rotInc2 -= 0.04;
        }

        private function loadCharacter():void
        {
            Settings.characterIndex = this.selectedIcon.index;
            if (this.characterLoader)
            {
                this.characterLoader.removeEventListener(Event.COMPLETE, this.characterLoaded);
                this.characterLoader.cancelLoad();
            }
            else if (this.session)
            {
                this.killSession();
            }
            this.characterLoader = new SwfLoader(Settings.characterSWF);
            this.characterLoader.addEventListener(Event.COMPLETE, this.characterLoaded);
            this.characterLoader.loadSWF();
        }

        private function characterLoaded(param1:Event):void
        {
            this.characterLoader.removeEventListener(Event.COMPLETE, this.characterLoaded);
            var _loc2_:Sprite = this.characterLoader.swfContent as Sprite;
            this.characterLoader.unLoadSwf();
            this.characterLoader = null;
            Settings.currentSession = this.session = new SessionCharacterMenu(_loc2_);
            this.session.visible = false;
            addChild(this.session);
            this.session.scaleX = this.session.scaleY = 2;
            this.session.create();
            this.session.visible = true;
        }

        private function killSession():void
        {
            if (this.session)
            {
                this.session.die();
                removeChild(this.session);
                Settings.currentSession = this.session = null;
            }
        }

        public function die():void
        {
            this.killSession();
            if (this.characterLoader)
            {
                this.characterLoader.removeEventListener(Event.COMPLETE, this.characterLoaded);
                this.characterLoader.cancelLoad();
            }
            this.iconHolder.removeEventListener(MouseEvent.MOUSE_OVER, this.iconMouseOverHandler);
            removeEventListener(Event.ENTER_FRAME, this.scrollSmoke);
        }
    }
}
