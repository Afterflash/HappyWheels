package com.totaljerkface.game.editor.specials
{
    import Box2D.Common.Math.b2Mat22;
    import Box2D.Common.Math.b2Vec2;
    import com.totaljerkface.game.editor.*;
    import com.totaljerkface.game.events.CanvasEvent;
    import flash.display.*;
    import flash.utils.Dictionary;

    [Embed(source="/_assets/assets.swf", symbol="symbol2634")]
    public class HarpoonGunRef extends Special
    {
        public var turret:Sprite;

        public var light:MovieClip;

        public var anchorSprite:Sprite;

        private var _useAnchor:Boolean = true;

        private var _fixedAngleTurret:Boolean = false;

        private var _turretAngle:int = 0;

        private var _triggerFiring:Boolean = false;

        private var _startDeactivated:Boolean;

        public function HarpoonGunRef()
        {
            _triggerable = true;
            _triggers = new Array();
            _triggerActions = new Dictionary();
            _triggerActionList = ["fire harpoon", "deactivate", "activate"];
            _triggerActionListProperties = [null, null, null];
            _triggerString = "triggerActionsHarpoon";
            super();
            name = "harpoon gun";
            _shapesUsed = 11;
            _rotatable = true;
            _scalable = false;
            _joinable = false;
            _groupable = false;
            _keyedPropertyObject[_triggerString] = _triggerActions;
            this.light = this.turret.getChildByName("light") as MovieClip;
            this.anchorSprite = new Sprite();
            addChildAt(this.anchorSprite, getChildIndex(this.turret));
            this.drawAnchor();
        }

        override public function setAttributes():void
        {
            _type = "HarpoonGunRef";
            _attributes = ["x", "y", "angle", "useAnchor", "fixedAngleTurret"];
            if (this._fixedAngleTurret)
            {
                _attributes.push("turretAngle");
            }
            _attributes.push("triggerFiring", "startDeactivated");
            addTriggerProperties();
        }

        override public function getFullProperties():Array
        {
            return ["x", "y", "angle", "useAnchor", "fixedAngleTurret", "turretAngle", "triggerFiring", "startDeactivated"];
        }

        override public function clone():RefSprite
        {
            var _loc1_:HarpoonGunRef = null;
            _loc1_ = new HarpoonGunRef();
            _loc1_.x = x;
            _loc1_.y = y;
            _loc1_.angle = angle;
            _loc1_.useAnchor = this.useAnchor;
            _loc1_.fixedAngleTurret = this.fixedAngleTurret;
            _loc1_.turretAngle = this.turretAngle;
            _loc1_.triggerFiring = this.triggerFiring;
            _loc1_.startDeactivated = this.startDeactivated;
            transferKeyedProperties(_loc1_);
            return _loc1_;
        }

        public function get useAnchor():Boolean
        {
            return this._useAnchor;
        }

        public function set useAnchor(param1:Boolean):void
        {
            if (this._useAnchor == param1)
            {
                return;
            }
            this._useAnchor = param1;
            this.anchorSprite.visible = this._useAnchor;
            if (this._useAnchor)
            {
                _shapesUsed = 11;
                dispatchEvent(new CanvasEvent(CanvasEvent.SHAPE, 7));
            }
            else
            {
                _shapesUsed = 4;
                dispatchEvent(new CanvasEvent(CanvasEvent.SHAPE, -7));
            }
        }

        public function get fixedAngleTurret():Boolean
        {
            return this._fixedAngleTurret;
        }

        public function set fixedAngleTurret(param1:Boolean):void
        {
            if (param1 < -110)
            {
                param1 = true;
            }
            if (param1 > 110)
            {
                param1 = true;
            }
            this._fixedAngleTurret = param1;
            this.turret.rotation = this._fixedAngleTurret ? this._turretAngle : 0;
            this.setAttributes();
            this.drawAnchor();
            if (_selected)
            {
                drawBoundingBox();
            }
            x = x;
            y = y;
            this.setLight();
        }

        public function get turretAngle():int
        {
            return this._turretAngle;
        }

        public function set turretAngle(param1:int):void
        {
            this._turretAngle = param1;
            this.turret.rotation = this._fixedAngleTurret ? this._turretAngle : 0;
            this.drawAnchor();
            if (_selected)
            {
                drawBoundingBox();
            }
            x = x;
            y = y;
        }

        public function get triggerFiring():Boolean
        {
            return this._triggerFiring;
        }

        public function set triggerFiring(param1:Boolean):void
        {
            this._triggerFiring = param1;
            this.setLight();
        }

        private function setLight():void
        {
            if (this._startDeactivated)
            {
                this.light.gotoAndStop(4);
            }
            else if (this._triggerFiring)
            {
                this.light.gotoAndStop(3);
            }
            else if (this._fixedAngleTurret)
            {
                this.light.gotoAndStop(2);
            }
            else
            {
                this.light.gotoAndStop(1);
            }
        }

        public function get startDeactivated():Boolean
        {
            return this._startDeactivated;
        }

        public function set startDeactivated(param1:Boolean):void
        {
            this._startDeactivated = param1;
            this.setLight();
        }

        private function drawAnchor():void
        {
            this.anchorSprite.graphics.clear();
            this.anchorSprite.graphics.lineStyle(1, 0, 1);
            this.anchorSprite.graphics.moveTo(-22, -17);
            var _loc1_:b2Vec2 = new b2Vec2(0, -45);
            var _loc2_:b2Mat22 = new b2Mat22(-this.turret.rotation * Math.PI / 180);
            _loc1_.MulTM(_loc2_);
            _loc1_.y += -35;
            var _loc3_:b2Vec2 = new b2Vec2(_loc1_.x + 22, _loc1_.y + 17);
            var _loc4_:Number = _loc3_.Length() * 0.25;
            _loc3_.Normalize();
            var _loc5_:b2Vec2 = new b2Vec2(-22, -17);
            _loc5_.x += _loc4_ * 3 * _loc3_.x;
            _loc5_.y += _loc4_ * 3 * _loc3_.y;
            _loc5_.x += _loc4_ * _loc3_.y;
            _loc5_.y -= _loc4_ * _loc3_.x;
            this.anchorSprite.graphics.curveTo(_loc5_.x, _loc5_.y, _loc1_.x, _loc1_.y);
        }
    }
}
