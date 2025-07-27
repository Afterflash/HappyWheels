package com.totaljerkface.game.particles
{
    import Box2D.Common.Math.b2Vec2;
    import Box2D.Dynamics.b2Body;
    import com.totaljerkface.game.*;
    import flash.display.*;
    import flash.filters.*;
    import flash.geom.Matrix;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.utils.Dictionary;
    
    public class ParticleController
    {
        public static var drawnParticles:Boolean;
        
        public static var maxParticles:int = 2000;
        
        public static var totalParticles:int = 0;
        
        private var bloodBmdArray:Array;
        
        private var vanBmdArray:Array;
        
        private var particleDict:Dictionary;
        
        private var emitters:Array;
        
        private var containerSprite:Sprite;
        
        private var bloodSetting:int;
        
        private var bloodSprite:Sprite;
        
        private var bloodBitmap1:Bitmap;
        
        private var bloodBMD1:BitmapData;
        
        private var blurFilter:BlurFilter;
        
        public function ParticleController(param1:Sprite)
        {
            super();
            this.emitters = new Array();
            this.particleDict = new Dictionary();
            this.containerSprite = param1;
            this.createVanShardBitmaps();
            this.createBloodBitmaps();
            this.bloodSprite = new Sprite();
            this.bloodSetting = Settings.bloodSetting;
            if(this.bloodSetting > 1)
            {
            }
            if(this.bloodSetting > 2)
            {
                this.bloodBMD1 = new BitmapData(900,500,true);
                this.bloodBitmap1 = new Bitmap(this.bloodBMD1);
                this.bloodBitmap1.alpha = 0.8;
                this.blurFilter = new BlurFilter(4,4,3);
            }
            if(this.bloodSetting > 3)
            {
                this.bloodBitmap1.blendMode = BlendMode.HARDLIGHT;
                this.bloodBitmap1.alpha = 1;
            }
        }
        
        public function placeBloodBitmap() : void
        {
            var _loc1_:Sprite = null;
            if(this.bloodBitmap1)
            {
                _loc1_ = Settings.currentSession.level.foreground;
                if(_loc1_)
                {
                    this.containerSprite.addChildAt(this.bloodBitmap1,this.containerSprite.getChildIndex(_loc1_));
                }
            }
        }
        
        private function createBloodBitmaps() : void
        {
            var _loc4_:BitmapData = null;
            this.bloodBmdArray = new Array();
            var _loc1_:BevelFilter = new BevelFilter(1,90,16752029,1,5308416,1,0,0);
            var _loc2_:MovieClip = new bloodMC();
            _loc2_.filters = [_loc1_];
            var _loc3_:int = 1;
            while(_loc3_ < 14)
            {
                _loc2_.gotoAndStop(_loc3_);
                _loc4_ = new BitmapData(_loc2_.width,_loc2_.height,true,0);
                _loc4_.draw(_loc2_);
                this.bloodBmdArray.push(_loc4_);
                _loc3_++;
            }
            this.particleDict["blood"] = this.bloodBmdArray;
        }
        
        private function createVanShardBitmaps() : void
        {
            var _loc4_:BitmapData = null;
            this.vanBmdArray = new Array();
            var _loc1_:BevelFilter = new BevelFilter(5,90,16777215,1,5308416,1,5,5);
            var _loc2_:MovieClip = new vanGlass();
            _loc2_.filters = [_loc1_];
            var _loc3_:int = 1;
            while(_loc3_ < 14)
            {
                _loc2_.gotoAndStop(_loc3_);
                _loc4_ = new BitmapData(_loc2_.width,_loc2_.height,true,0);
                _loc4_.draw(_loc2_);
                this.vanBmdArray.push(_loc4_);
                _loc3_++;
            }
            this.particleDict["vanglass"] = this.vanBmdArray;
        }
        
        public function createBMDArray(param1:String, param2:MovieClip, param3:Array = null) : void
        {
            var _loc6_:BitmapData = null;
            if(this.particleDict[param1])
            {
                return;
            }
            var _loc4_:Array = new Array();
            if(param3)
            {
                param2.filters = param3;
            }
            var _loc5_:int = 1;
            while(_loc5_ < param2.totalFrames + 1)
            {
                param2.gotoAndStop(_loc5_);
                _loc6_ = new BitmapData(param2.width,param2.height,true,0);
                _loc6_.draw(param2);
                _loc4_.push(_loc6_);
                _loc5_++;
            }
            this.particleDict[param1] = _loc4_;
        }
        
        public function createBloodFlow(param1:Number, param2:Number, param3:b2Body, param4:b2Vec2, param5:int, param6:int, param7:Sprite, param8:int = -1) : Emitter
        {
            var _loc9_:Emitter = null;
            if(this.bloodSetting == 1)
            {
                _loc9_ = new Flow2(this.bloodBmdArray,param1,param2,param3,param4,param5,param6);
                if(param8 == -1)
                {
                    param7.addChild(_loc9_);
                }
                else
                {
                    param7.addChildAt(_loc9_,param8);
                }
            }
            else if(this.bloodSetting == 2)
            {
                _loc9_ = new BloodFlow(null,param3,param4,param5,param1,param2,param6);
                if(param8 == -1)
                {
                    param7.addChild(_loc9_);
                }
                else
                {
                    param7.addChildAt(_loc9_,param8);
                }
            }
            else
            {
                _loc9_ = new BloodFlow(this.bloodSprite,param3,param4,param5,param1,param2,param6);
            }
            this.emitters.push(_loc9_);
            return _loc9_;
        }
        
        public function createBloodBurst(param1:Number, param2:Number, param3:b2Body, param4:int, param5:b2Vec2, param6:Sprite, param7:int = -1) : Emitter
        {
            var _loc8_:Emitter = null;
            if(this.bloodSetting == 1)
            {
                _loc8_ = new Burst2(this.bloodBmdArray,param1,param2,param3,param5,param4);
                if(param7 == -1)
                {
                    param6.addChild(_loc8_);
                }
                else
                {
                    param6.addChildAt(_loc8_,param7);
                }
            }
            else if(this.bloodSetting == 2)
            {
                _loc8_ = new BloodBurst2(null,param1,param2,param3,param5,param4);
                if(param7 == -1)
                {
                    param6.addChild(_loc8_);
                }
                else
                {
                    param6.addChildAt(_loc8_,param7);
                }
            }
            else
            {
                _loc8_ = new BloodBurst2(this.bloodSprite,param1,param2,param3,param5,param4);
            }
            this.emitters.push(_loc8_);
            return _loc8_;
        }
        
        public function createPointBloodBurst(param1:Number, param2:Number, param3:Number, param4:Number, param5:int, param6:int = -1) : Emitter
        {
            var _loc7_:Emitter = null;
            if(this.bloodSetting == 1)
            {
                _loc7_ = new Burst(this.bloodBmdArray,param1,param2,param3,param4,param5);
                if(param6 == -1)
                {
                    this.containerSprite.addChild(_loc7_);
                }
                else
                {
                    this.containerSprite.addChildAt(_loc7_,param6);
                }
            }
            else if(this.bloodSetting == 2)
            {
                _loc7_ = new BloodBurst(null,param1,param2,param3,param4,param5);
                if(param6 == -1)
                {
                    this.containerSprite.addChild(_loc7_);
                }
                else
                {
                    this.containerSprite.addChildAt(_loc7_,param6);
                }
            }
            else
            {
                _loc7_ = new BloodBurst(this.bloodSprite,param1,param2,param3,param4,param5);
            }
            this.emitters.push(_loc7_);
            return _loc7_;
        }
        
        public function createBloodSpray(param1:b2Body, param2:b2Vec2, param3:b2Vec2, param4:Number, param5:Number, param6:Number, param7:int, param8:int, param9:Sprite, param10:int = -1) : Emitter
        {
            var _loc11_:Emitter = null;
            if(this.bloodSetting == 1)
            {
                _loc11_ = new Spray(this.bloodBmdArray,param1,param2,param3,param4,param5,param6,param7,param8);
                if(param10 == -1)
                {
                    param9.addChild(_loc11_);
                }
                else
                {
                    param9.addChildAt(_loc11_,param10);
                }
            }
            else if(this.bloodSetting == 2)
            {
                _loc11_ = new BloodSpray(null,param1,param2,param3,param4,param5,param6,param7,param8);
                if(param10 == -1)
                {
                    param9.addChild(_loc11_);
                }
                else
                {
                    param9.addChildAt(_loc11_,param10);
                }
            }
            else
            {
                _loc11_ = new BloodSpray(this.bloodSprite,param1,param2,param3,param4,param5,param6,param7,param8);
            }
            this.emitters.push(_loc11_);
            return _loc11_;
        }
        
        public function createFlow(param1:String, param2:Number, param3:Number, param4:b2Body, param5:b2Vec2, param6:int, param7:int, param8:int = -1) : Flow2
        {
            var _loc9_:Flow2 = new Flow2(this.particleDict[param1],param2,param3,param4,param5,param6,param7);
            if(param8 == -1)
            {
                this.containerSprite.addChild(_loc9_);
            }
            else
            {
                this.containerSprite.addChildAt(_loc9_,param8);
            }
            this.emitters.push(_loc9_);
            return _loc9_;
        }
        
        public function createPointFlow(param1:String, param2:Number, param3:Number, param4:Number, param5:Number, param6:int, param7:int, param8:int = -1) : Flow
        {
            var _loc9_:Flow = new Flow(this.particleDict[param1],param2,param3,param4,param5,param6,param7);
            if(param8 == -1)
            {
                this.containerSprite.addChild(_loc9_);
            }
            else
            {
                this.containerSprite.addChildAt(_loc9_,param8);
            }
            this.emitters.push(_loc9_);
            return _loc9_;
        }
        
        public function createBurst(param1:String, param2:Number, param3:Number, param4:b2Body, param5:int, param6:int = -1) : Burst
        {
            var _loc7_:Burst2 = new Burst2(this.particleDict[param1],param2,param3,param4,new b2Vec2(0,0),param5);
            if(param6 == -1)
            {
                this.containerSprite.addChild(_loc7_);
            }
            else
            {
                this.containerSprite.addChildAt(_loc7_,param6);
            }
            this.emitters.push(_loc7_);
            return _loc7_;
        }
        
        public function createPointBurst(param1:String, param2:Number, param3:Number, param4:Number, param5:Number, param6:int, param7:int = -1) : Burst
        {
            var _loc8_:Burst = new Burst(this.particleDict[param1],param2,param3,param4,param5,param6);
            if(param7 == -1)
            {
                this.containerSprite.addChild(_loc8_);
            }
            else
            {
                this.containerSprite.addChildAt(_loc8_,param7);
            }
            this.emitters.push(_loc8_);
            return _loc8_;
        }
        
        public function createRectBurst(param1:String, param2:Number, param3:b2Body, param4:int, param5:int = -1) : Burst
        {
            var _loc6_:Burst = new BurstRect(this.particleDict[param1],param2,param3,param4);
            if(param5 == -1)
            {
                this.containerSprite.addChild(_loc6_);
            }
            else
            {
                this.containerSprite.addChildAt(_loc6_,param5);
            }
            this.emitters.push(_loc6_);
            return _loc6_;
        }
        
        public function createSpray(param1:String, param2:b2Body, param3:b2Vec2, param4:b2Vec2, param5:Number, param6:Number, param7:Number, param8:int, param9:int, param10:Sprite, param11:int = -1) : Spray
        {
            var _loc12_:Spray = new Spray(this.particleDict[param1],param2,param3,param4,param5,param6,param7,param8,param9);
            if(param11 == -1)
            {
                param10.addChild(_loc12_);
            }
            else
            {
                param10.addChildAt(_loc12_,param11);
            }
            this.emitters.push(_loc12_);
            return _loc12_;
        }
        
        public function createSnowSpray(param1:String, param2:b2Body, param3:b2Vec2, param4:b2Vec2, param5:Number, param6:Number, param7:Number, param8:int, param9:int, param10:Sprite, param11:int = -1) : SnowSpray
        {
            var _loc12_:SnowSpray = new SnowSpray(this.particleDict[param1],param2,param3,param4,param5,param6,param7,param8,param9);
            if(param11 == -1)
            {
                param10.addChild(_loc12_);
            }
            else
            {
                param10.addChildAt(_loc12_,param11);
            }
            this.emitters.push(_loc12_);
            return _loc12_;
        }
        
        public function createSparkBurst(param1:b2Body, param2:b2Vec2, param3:Number, param4:Number, param5:int, param6:int = -1) : SparkBurst
        {
            var _loc7_:SparkBurst = new SparkBurst(param1,param2,param3,param4,param5);
            if(param6 == -1)
            {
                this.containerSprite.addChild(_loc7_);
            }
            else
            {
                this.containerSprite.addChildAt(_loc7_,param6);
            }
            this.emitters.push(_loc7_);
            return _loc7_;
        }
        
        public function createSparkBurstPoint(param1:b2Vec2, param2:b2Vec2, param3:Number, param4:Number, param5:int, param6:int = -1) : SparkBurstPoint
        {
            var _loc7_:SparkBurstPoint = new SparkBurstPoint(param1,param2,param3,param4,param5);
            if(param6 == -1)
            {
                this.containerSprite.addChild(_loc7_);
            }
            else
            {
                this.containerSprite.addChildAt(_loc7_,param6);
            }
            this.emitters.push(_loc7_);
            return _loc7_;
        }
        
        public function createArrowSnap(param1:b2Body, param2:int, param3:Sprite = null, param4:* = -1) : ArrowSnap
        {
            var _loc5_:ArrowSnap = new ArrowSnap(param1,param2);
            if(param4 == -1)
            {
                this.containerSprite.addChild(_loc5_);
            }
            else
            {
                param3.addChildAt(_loc5_,param4);
            }
            this.emitters.push(_loc5_);
            return _loc5_;
        }
        
        public function step() : void
        {
            var _loc2_:Emitter = null;
            var _loc3_:Rectangle = null;
            var _loc4_:Matrix = null;
            this.bloodSprite.graphics.clear();
            var _loc1_:int = 0;
            while(_loc1_ < this.emitters.length)
            {
                _loc2_ = this.emitters[_loc1_];
                if(_loc2_.step() == false)
                {
                    _loc2_.die();
                    if(_loc2_.parent)
                    {
                        _loc2_.parent.removeChild(_loc2_);
                    }
                    this.emitters.splice(_loc1_,1);
                    _loc1_--;
                }
                _loc1_++;
            }
            if(this.bloodSetting > 2)
            {
                this.bloodBMD1.fillRect(this.bloodBMD1.rect,0);
                if(drawnParticles)
                {
                    drawnParticles = false;
                    _loc3_ = Settings.currentSession.camera.screenBounds;
                    this.bloodBitmap1.x = _loc3_.x;
                    this.bloodBitmap1.y = _loc3_.y;
                    _loc4_ = new Matrix();
                    _loc4_.translate(-_loc3_.x,-_loc3_.y);
                    this.bloodBMD1.draw(this.bloodSprite,_loc4_,null,null,new Rectangle(0,0,900,500));
                    this.bloodBMD1.applyFilter(this.bloodBMD1,this.bloodBMD1.rect,new Point(0,0),this.blurFilter);
                    this.bloodBMD1.threshold(this.bloodBMD1,this.bloodBMD1.rect,new Point(0,0),">=",1409286144,4288217088,4278190080,false);
                    this.bloodBMD1.threshold(this.bloodBMD1,this.bloodBMD1.rect,new Point(0,0),"<",1409286144,0,4278190080,false);
                    if(this.bloodSetting == 4)
                    {
                        this.bloodBMD1.applyFilter(this.bloodBMD1,this.bloodBMD1.rect,new Point(0,0),new BevelFilter(4,90,16777215,0.3,0,0.3,4,4,1,3));
                    }
                }
            }
        }
        
        public function die() : void
        {
            var _loc2_:Emitter = null;
            var _loc1_:int = 0;
            while(_loc1_ < this.emitters.length)
            {
                _loc2_ = this.emitters[_loc1_];
                _loc2_.die();
                if(_loc2_.parent)
                {
                    _loc2_.parent.removeChild(_loc2_);
                }
                _loc1_++;
            }
            this.emitters = null;
            totalParticles = 0;
            this.bloodSprite.graphics.clear();
            if(this.bloodSprite.parent)
            {
                this.bloodSprite.parent.removeChild(this.bloodSprite);
            }
            this.bloodSprite = null;
            if(this.bloodBMD1)
            {
                this.bloodBMD1.dispose();
                this.bloodBMD1 = null;
                if(this.bloodBitmap1.parent)
                {
                    this.bloodBitmap1.parent.removeChild(this.bloodBitmap1);
                }
                this.bloodBitmap1 = null;
            }
        }
    }
}

