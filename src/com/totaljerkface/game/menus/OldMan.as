package com.totaljerkface.game.menus
{
    import flash.display.MovieClip;
    import flash.display.Sprite;
    import gs.TweenLite;
    import gs.easing.Strong;

    [Embed(source="/_assets/assets.swf", symbol="symbol430")]
    public class OldMan extends Sprite
    {
        public var body:Sprite;

        public var arm:Sprite;

        public var foreArm:Sprite;

        public var head:Sprite;

        public var jaw:Sprite;

        public var eyes:MovieClip;

        public var eye1:Sprite;

        public var eye2:Sprite;

        protected var bodyMinAngle:int = -6;

        protected var bodyRange:int = 8;

        protected var headMinAngle:int = -6;

        protected var headRange:int = 6;

        protected var armMinAngle:int = -10;

        protected var armRange:int = 40;

        protected var foreArmMinAngle:int = -15;

        protected var foreArmRange:int = 30;

        protected var jawTopY:Number = -65.5;

        protected var jawRangeY:int = 15;

        protected var eye1LeftX:int = -24;

        protected var eye1RangeX:int = 16;

        protected var eye2LeftX:int = 34;

        protected var eye2RangeX:int = 13;

        protected var eye1TopY:int = -10;

        protected var eye1RangeY:int = 6;

        protected var eye2TopY:int = -3;

        protected var eye2RangeY:int = 6;

        protected var timeRange:Number = 2.5;

        protected var jawMoving:Boolean = false;

        protected var _jawTween:Number = 0;

        public function OldMan()
        {
            super();
            this.arm = this.body.getChildByName("arm") as Sprite;
            this.foreArm = this.arm.getChildByName("foreArm") as Sprite;
            this.head = this.body.getChildByName("head") as Sprite;
            this.jaw = this.head.getChildByName("jaw") as Sprite;
            this.eyes = this.head.getChildByName("eyes") as MovieClip;
            this.eye1 = this.eyes.getChildByName("eye1") as Sprite;
            this.eye2 = this.eyes.getChildByName("eye2") as Sprite;
            this._jawTween = (this.jaw.y - this.jawTopY) / this.jawRangeY;
        }

        public function slideIn():void
        {
            var _loc1_:Number = NaN;
            _loc1_ = rotation;
            var _loc2_:Number = x;
            var _loc3_:Number = y;
            rotation = -45;
            x = -54;
            y = 575;
            TweenLite.to(this, 2, {
                        "rotation": _loc1_,
                        "x": _loc2_,
                        "y": _loc3_,
                        "ease": Strong.easeOut,
                        "delay": 1
                    });
        }

        public function step():*
        {
            var _loc1_:Number = NaN;
            var _loc2_:Number = NaN;
            var _loc3_:Number = NaN;
            var _loc4_:Number = NaN;
            var _loc5_:Number = NaN;
            var _loc6_:Number = NaN;
            if (Math.random() < 0.02)
            {
                _loc1_ = this.armMinAngle + Math.random() * this.armRange;
                _loc2_ = Math.random() * this.timeRange + 0.5;
                TweenLite.to(this.arm, _loc2_, {
                            "rotation": _loc1_,
                            "ease": Strong.easeInOut
                        });
            }
            if (Math.random() < 0.02)
            {
                _loc1_ = this.foreArmMinAngle + Math.random() * this.foreArmRange;
                _loc2_ = Math.random() * this.timeRange + 0.5;
                TweenLite.to(this.foreArm, _loc2_, {
                            "rotation": _loc1_,
                            "ease": Strong.easeInOut
                        });
            }
            if (Math.random() < 0.02)
            {
                _loc1_ = this.bodyMinAngle + Math.random() * this.bodyRange;
                _loc2_ = Math.random() * this.timeRange + 0.5;
                TweenLite.to(this.body, _loc2_, {
                            "rotation": _loc1_,
                            "ease": Strong.easeInOut
                        });
            }
            if (Math.random() < 0.02)
            {
                _loc1_ = this.headMinAngle + Math.random() * this.headRange;
                _loc2_ = Math.random() * this.timeRange + 0.5;
                TweenLite.to(this.head, _loc2_, {
                            "rotation": _loc1_,
                            "ease": Strong.easeInOut
                        });
            }
            if (Math.random() < 0.1)
            {
                if (this.jawMoving)
                {
                    return;
                }
                _loc3_ = this.jawTopY + Math.random() * this.jawRangeY;
                _loc2_ = Math.random() * this.timeRange + 0.05;
                _loc4_ = _loc3_ - this.jaw.y;
                this.jawMoving = true;
                TweenLite.to(this, _loc2_, {
                            "jawTween": Math.random(),
                            "ease": Strong.easeInOut,
                            "overwrite": 0,
                            "onComplete": this.jawFinished
                        });
            }
            if (Math.random() < 0.005)
            {
                _loc5_ = Math.random();
                _loc6_ = this.eye1LeftX + _loc5_ * this.eye1RangeX;
                _loc2_ = Math.random() * this.timeRange + 0.5;
                TweenLite.to(this.eye1, _loc2_, {
                            "x": _loc6_,
                            "ease": Strong.easeInOut
                        });
                _loc6_ = this.eye2LeftX + _loc5_ * this.eye2RangeX;
                TweenLite.to(this.eye2, _loc2_, {
                            "x": _loc6_,
                            "ease": Strong.easeInOut
                        });
            }
        }

        public function get jawTween():Number
        {
            return this._jawTween;
        }

        public function set jawTween(param1:Number):void
        {
            this._jawTween = param1;
            this.jaw.y = this.jawTopY + this._jawTween * this.jawRangeY;
        }

        protected function jawFinished():void
        {
            this.jawMoving = false;
        }
    }
}
