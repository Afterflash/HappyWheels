package com.totaljerkface.game
{
    import Box2D.Common.Math.b2Vec2;
    import Box2D.Dynamics.*;
    import com.totaljerkface.game.level.visuals.BackDrop;
    import flash.display.*;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    
    public class StageCamera
    {
        private var _containerObj:DisplayObject;
        
        private var _focus:b2Body;
        
        private var _secondFocus:b2Body;
        
        private var _midScreen:Point;
        
        private var _screenBounds:Rectangle;
        
        private var _displacement:Point;
        
        private var _buttonContainer:DisplayObject;
        
        private var _tempFocus:b2Body;
        
        private var _tempCount:int = 0;
        
        private var _tempMax:int = 20;
        
        private const midX:Number = 7.2;
        
        private const midY:Number = 4;
        
        private var leftLimit:Number;
        
        private var rightLimit:Number;
        
        private var topLimit:Number;
        
        private var bottomLimit:Number;
        
        private var leftBorder:int = 100;
        
        private var rightBorder:int = 200;
        
        private var topBorder:int = 100;
        
        private var bottomBorder:int = 150;
        
        private var minSpeed:int = 3;
        
        private var moveIncrement:int = 5;
        
        private var upInc:int = 1;
        
        private var downInc:int = 5;
        
        private var m_physScale:Number;
        
        private var backDrops:Vector.<BackDrop>;
        
        public function StageCamera(param1:DisplayObject, param2:b2Body, param3:Session)
        {
            super();
            this._containerObj = param1;
            this._focus = param2;
            this._midScreen = new Point();
            this._displacement = new Point();
            this.m_physScale = param3.m_physScale;
            this._buttonContainer = param3.buttonContainer;
            if(param3.level)
            {
                this.backDrops = param3.level.backDrops;
            }
        }
        
        public function setLimits(param1:Number, param2:Number, param3:Number, param4:Number) : void
        {
            this.leftLimit = -param1;
            this.rightLimit = -(param2 - 900);
            this.topLimit = -param3;
            this.bottomLimit = -(param4 - 500);
            trace(param1);
            trace(param2);
            trace(param3);
            trace(param4);
        }
        
        private function setBorders() : void
        {
            var _loc1_:b2Vec2 = this._focus.GetLinearVelocity();
            var _loc2_:Number = _loc1_.x;
            var _loc3_:Number = _loc1_.y;
            if(_loc2_ > this.minSpeed)
            {
                if(this.leftBorder < 100)
                {
                    this.leftBorder += this.moveIncrement;
                }
                else if(this.leftBorder > 100)
                {
                    this.leftBorder -= this.moveIncrement;
                }
                if(this.rightBorder < 200)
                {
                    this.rightBorder += this.moveIncrement;
                }
                else if(this.rightBorder > 200)
                {
                    this.rightBorder -= this.moveIncrement;
                }
            }
            else if(_loc2_ < -this.minSpeed)
            {
                if(this.leftBorder < 600)
                {
                    this.leftBorder += this.moveIncrement;
                }
                else if(this.leftBorder > 600)
                {
                    this.leftBorder -= this.moveIncrement;
                }
                if(this.rightBorder < 700)
                {
                    this.rightBorder += this.moveIncrement;
                }
                else if(this.rightBorder > 700)
                {
                    this.rightBorder -= this.moveIncrement;
                }
            }
            else
            {
                if(this.leftBorder < 350)
                {
                    this.leftBorder += this.moveIncrement;
                }
                else if(this.leftBorder > 350)
                {
                    this.leftBorder -= this.moveIncrement;
                }
                if(this.rightBorder < 450)
                {
                    this.rightBorder += this.moveIncrement;
                }
                else if(this.rightBorder > 450)
                {
                    this.rightBorder -= this.moveIncrement;
                }
            }
            if(_loc3_ > this.minSpeed)
            {
                if(this.topBorder < 100)
                {
                    this.topBorder += this.upInc;
                }
                else if(this.topBorder > 100)
                {
                    this.topBorder -= this.moveIncrement;
                }
                if(this.bottomBorder < 150)
                {
                    this.bottomBorder += this.upInc;
                }
                else if(this.bottomBorder > 150)
                {
                    this.bottomBorder -= this.moveIncrement;
                }
            }
            else if(_loc3_ < -this.minSpeed)
            {
                if(this.topBorder < 350)
                {
                    this.topBorder += this.upInc;
                }
                else if(this.topBorder > 350)
                {
                    this.topBorder -= this.moveIncrement;
                }
                if(this.bottomBorder < 400)
                {
                    this.bottomBorder += this.upInc;
                }
                else if(this.bottomBorder > 400)
                {
                    this.bottomBorder -= this.moveIncrement;
                }
            }
            else
            {
                if(this.topBorder < 300)
                {
                    this.topBorder += this.upInc;
                }
                else if(this.topBorder > 300)
                {
                    this.topBorder -= this.moveIncrement;
                }
                if(this.bottomBorder < 350)
                {
                    this.bottomBorder += this.upInc;
                }
                else if(this.bottomBorder > 350)
                {
                    this.bottomBorder -= this.moveIncrement;
                }
            }
        }
        
        public function step() : void
        {
            var _loc1_:b2Vec2 = null;
            var _loc2_:Number = NaN;
            this.setBorders();
            if(this._secondFocus)
            {
                _loc1_ = this._focus.GetPosition().Copy();
                _loc1_.y += this._secondFocus.GetPosition().y;
                _loc1_.y *= 0.5;
                this.center(_loc1_);
            }
            else if(this._tempFocus)
            {
                _loc1_ = this._focus.GetPosition().Copy();
                _loc2_ = 0.5 - 0.5 * this._tempCount / this._tempMax;
                _loc1_.y = _loc1_.y * (1 - _loc2_) + this._tempFocus.GetPosition().y * _loc2_;
                this.center(_loc1_);
                if(this._tempCount >= this._tempMax)
                {
                    this._tempFocus = null;
                }
                ++this._tempCount;
            }
            else
            {
                this.center(this._focus.GetPosition());
            }
            if(this._buttonContainer)
            {
                this._buttonContainer.x = this.containerObj.x;
                this._buttonContainer.y = this.containerObj.y;
            }
            this.adjustBackDrops();
            Settings.YParticleLimit = this._focus.GetPosition().y * this.m_physScale + 1000;
        }
        
        public function center(param1:b2Vec2) : void
        {
            var _loc5_:Number = NaN;
            var _loc6_:Number = NaN;
            var _loc7_:Number = NaN;
            var _loc8_:Number = NaN;
            var _loc2_:Point = new Point(param1.x * this.m_physScale,param1.y * this.m_physScale);
            var _loc3_:Number = this._containerObj.localToGlobal(_loc2_).x + this._displacement.x;
            var _loc4_:Number = this._containerObj.localToGlobal(_loc2_).y + this._displacement.y;
            if(_loc3_ > this.rightBorder)
            {
                _loc5_ = _loc3_ - this.rightBorder;
                this._containerObj.x -= _loc5_;
                if(this._containerObj.x < this.rightLimit)
                {
                    this._containerObj.x = this.rightLimit;
                }
            }
            if(_loc3_ < this.leftBorder)
            {
                _loc6_ = this.leftBorder - _loc3_;
                this._containerObj.x += _loc6_;
                if(this._containerObj.x > this.leftLimit)
                {
                    this._containerObj.x = this.leftLimit;
                }
            }
            if(_loc4_ > this.bottomBorder)
            {
                _loc7_ = _loc4_ - this.bottomBorder;
                this._containerObj.y -= _loc7_;
                if(this._containerObj.y < this.bottomLimit)
                {
                    this._containerObj.y = this.bottomLimit;
                }
            }
            if(_loc4_ < this.topBorder)
            {
                _loc8_ = this.topBorder - _loc4_;
                this._containerObj.y += _loc8_;
                if(this._containerObj.y > this.topLimit)
                {
                    this._containerObj.y = this.topLimit;
                }
            }
            this._screenBounds = new Rectangle(-this._containerObj.x,-this._containerObj.y,900,500);
            this._midScreen = new Point(this.midX - this._containerObj.x / this.m_physScale,this.midY - this._containerObj.y / this.m_physScale);
        }
        
        public function removeSecondFocus() : void
        {
            if(!this._secondFocus)
            {
                return;
            }
            this._tempFocus = this._secondFocus;
            this._secondFocus = null;
            this._tempCount = 0;
        }
        
        private function adjustBackDrops() : void
        {
            var _loc2_:BackDrop = null;
            var _loc1_:int = 0;
            while(_loc1_ < this.backDrops.length)
            {
                _loc2_ = this.backDrops[_loc1_];
                if(_loc2_.multiplier > 0)
                {
                    _loc2_.x = Math.round(this._containerObj.x * _loc2_.multiplier);
                    _loc2_.y = Math.round(this._containerObj.y * _loc2_.multiplier);
                }
                _loc1_++;
            }
        }
        
        public function get midScreenPoint() : Point
        {
            return this._midScreen;
        }
        
        public function get screenBounds() : Rectangle
        {
            return this._screenBounds;
        }
        
        public function get focus() : b2Body
        {
            return this._focus;
        }
        
        public function set focus(param1:b2Body) : void
        {
            this._focus = param1;
        }
        
        public function get secondFocus() : b2Body
        {
            return this._secondFocus;
        }
        
        public function set secondFocus(param1:b2Body) : void
        {
            this._secondFocus = param1;
        }
        
        public function get containerObj() : DisplayObject
        {
            return this._containerObj;
        }
        
        public function set containerObj(param1:DisplayObject) : void
        {
            this._containerObj = param1;
        }
        
        public function get displacement() : Point
        {
            return this._displacement;
        }
        
        public function set displacement(param1:Point) : void
        {
            this._displacement = param1.clone();
        }
        
        public function get buttonContainer() : DisplayObject
        {
            return this._buttonContainer;
        }
        
        public function set buttonContainer(param1:DisplayObject) : void
        {
            this._buttonContainer = param1;
        }
    }
}

