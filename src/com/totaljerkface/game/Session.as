package com.totaljerkface.game
{
    import Box2D.Collision.b2AABB;
    import Box2D.Common.Math.b2Vec2;
    import Box2D.Dynamics.b2Body;
    import Box2D.Dynamics.b2DebugDraw;
    import Box2D.Dynamics.b2World;
    import com.totaljerkface.game.character.CharacterB2D;
    import com.totaljerkface.game.character.HelicopterMan;
    import com.totaljerkface.game.character.IrresponsibleDad;
    import com.totaljerkface.game.character.IrresponsibleMom;
    import com.totaljerkface.game.character.LawnMowerMan;
    import com.totaljerkface.game.character.MiddleAgedExplorer;
    import com.totaljerkface.game.character.MopedCouple;
    import com.totaljerkface.game.character.MotorCart;
    import com.totaljerkface.game.character.MotorCartV111;
    import com.totaljerkface.game.character.PlayableCharacterB2D;
    import com.totaljerkface.game.character.PogoStickMan;
    import com.totaljerkface.game.character.SantaClaus;
    import com.totaljerkface.game.character.SegwayGuy;
    import com.totaljerkface.game.character.SegwayGuyV111;
    import com.totaljerkface.game.character.WheelChairGuy;
    import com.totaljerkface.game.events.ReplayEvent;
    import com.totaljerkface.game.events.SessionEvent;
    import com.totaljerkface.game.level.Level1;
    import com.totaljerkface.game.level.LevelB2D;
    import com.totaljerkface.game.level.UserLevel;
    import com.totaljerkface.game.particles.ParticleController;
    import com.totaljerkface.game.sound.SoundController;
    import flash.display.BlendMode;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.TimerEvent;
    import flash.geom.Rectangle;
    import flash.media.SoundChannel;
    import flash.system.System;
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
    import flash.text.TextFormat;
    import flash.text.TextFormatAlign;
    import flash.utils.Timer;
    
    public class Session extends Sprite
    {
        public var m_world:b2World;
        
        public var m_iterations:int = 10;
        
        public var m_timeStep:Number = 0.03333333333333333;
        
        public var m_physScale:Number = 62.5;
        
        public var debug_sprite:Sprite;
        
        protected var useDebugger:Boolean;
        
        protected var _version:Number;
        
        protected var _levelVersion:Number;
        
        protected var _containerSprite:Sprite;
        
        protected var _buttonContainer:Sprite;
        
        protected var _character:CharacterB2D;
        
        protected var _level:LevelB2D;
        
        protected var _contactListener:ContactListener;
        
        protected var _replayData:ReplayData;
        
        protected var _iteration:int;
        
        protected var totalIterations:int;
        
        protected var paused:Boolean;
        
        protected var _camera:StageCamera;
        
        protected var _particleController:ParticleController;
        
        protected var _music:SoundChannel;
        
        protected var fpsTimer:Timer;
        
        protected var fpsText:TextField;
        
        protected var frames:int = 0;
        
        protected var inputAllowed:Boolean;
        
        public var isReplay:Boolean;
        
        public function Session(param1:Number, param2:Sprite, param3:Sprite, param4:Number, param5:* = false)
        {
            super();
            trace("SESSION version " + param1 + ", level version " + param4);
            this._version = param1;
            this._levelVersion = param4;
            this.debug_sprite = new Sprite();
            this.useDebugger = param5;
            this.init(param2,param3);
        }
        
        protected function init(param1:Sprite, param2:Sprite) : void
        {
            this._containerSprite = new Sprite();
            this.containerSprite.mouseChildren = false;
            this.containerSprite.mouseEnabled = false;
            addChild(this._containerSprite);
            this.setupLevel(param2);
            this.setupCharacter(param1);
            MemoryTest.instance.addEntry("userLevel_",this._level);
            MemoryTest.instance.addEntry("character_",this._character);
            MemoryTest.instance.addEntry("session_",this);
            MemoryTest.instance.traceContents();
        }
        
        protected function setupLevel(param1:Sprite) : void
        {
            switch(Settings.levelIndex)
            {
                case 1:
                    this._level = new Level1(param1,this);
                    break;
                default:
                    this._level = new UserLevel(param1,this);
            }
        }
        
        protected function setupCharacter(param1:Sprite) : void
        {
            var _loc2_:b2Vec2 = this.getStartPoint();
            trace("SETUP CHARACTER " + Settings.characterIndex);
            if(Settings.hideVehicle)
            {
                this._character = new PlayableCharacterB2D(_loc2_.x,_loc2_.y,param1,this);
                return;
            }
            switch(Settings.characterIndex)
            {
                case 1:
                    this._character = new WheelChairGuy(_loc2_.x,_loc2_.y,param1,this);
                    break;
                case 2:
                    if(this.version >= 1.11)
                    {
                        this._character = new SegwayGuyV111(_loc2_.x,_loc2_.y,param1,this);
                    }
                    else
                    {
                        this._character = new SegwayGuy(_loc2_.x,_loc2_.y,param1,this);
                    }
                    break;
                case 3:
                    this._character = new IrresponsibleDad(_loc2_.x,_loc2_.y,param1,this);
                    break;
                case 4:
                    if(this.version >= 1.11)
                    {
                        this._character = new MotorCartV111(_loc2_.x,_loc2_.y,param1,this);
                    }
                    else
                    {
                        this._character = new MotorCart(_loc2_.x,_loc2_.y,param1,this);
                    }
                    break;
                case 5:
                    this._character = new MopedCouple(_loc2_.x,_loc2_.y,param1,this);
                    break;
                case 6:
                    this._character = new LawnMowerMan(_loc2_.x,_loc2_.y,param1,this);
                    break;
                case 7:
                    this._character = new MiddleAgedExplorer(_loc2_.x,_loc2_.y,param1,this);
                    break;
                case 8:
                    this._character = new SantaClaus(_loc2_.x,_loc2_.y,param1,this);
                    break;
                case 9:
                    this._character = new PogoStickMan(_loc2_.x,_loc2_.y,param1,this);
                    break;
                case 10:
                    this._character = new IrresponsibleMom(_loc2_.x,_loc2_.y,param1,this,-1,"Char4");
                    break;
                case 11:
                    this._character = new HelicopterMan(_loc2_.x,_loc2_.y,param1,this);
                    break;
                default:
                    throw new Error("FUCK THIS, DOG!");
            }
        }
        
        protected function getStartPoint() : b2Vec2
        {
            return new b2Vec2(this._level.startPoint.x,this._level.startPoint.y);
        }
        
        public function create() : void
        {
            this._particleController = new ParticleController(this._containerSprite);
            this.createWorld();
            trace("building level");
            this._level.create();
            trace("building character");
            this._character.create();
            this._character.addKeyListeners();
            this._containerSprite.addChild(this._level.foreground);
            this.particleController.placeBloodBitmap();
            this._camera = new StageCamera(this._containerSprite,this._character.cameraFocus,this);
            this._camera.secondFocus = this._character.cameraSecondFocus;
            var _loc1_:Rectangle = this._level.cameraBounds;
            this._camera.setLimits(_loc1_.x,_loc1_.x + _loc1_.width,_loc1_.y,_loc1_.y + _loc1_.height);
            this.setupTextFields();
            this._containerSprite.addChild(this.debug_sprite);
            this._character.addEventListener(ReplayEvent.ADD_ENTRY,this.addReplayEntry);
            this._character.paint();
            this.start();
        }
        
        protected function createWorld() : void
        {
            var _loc1_:b2AABB = new b2AABB();
            var _loc2_:Rectangle = this._level.worldBounds;
            _loc1_.lowerBound.Set(_loc2_.x / this.m_physScale,_loc2_.y / this.m_physScale);
            _loc1_.upperBound.Set((_loc2_.x + _loc2_.width) / this.m_physScale,(_loc2_.y + _loc2_.height) / this.m_physScale);
            var _loc3_:b2Vec2 = new b2Vec2(0,10);
            var _loc4_:Boolean = true;
            this.m_world = new b2World(_loc1_,_loc3_,_loc4_);
            var _loc5_:b2DebugDraw = new b2DebugDraw();
            _loc5_.m_sprite = this.debug_sprite;
            _loc5_.m_drawScale = 62.5;
            _loc5_.m_fillAlpha = 0.3;
            _loc5_.m_lineThickness = 1;
            _loc5_.m_drawFlags = b2DebugDraw.e_shapeBit | b2DebugDraw.e_jointBit;
            if(this.useDebugger)
            {
                this.m_world.SetDebugDraw(_loc5_);
            }
            this._contactListener = new ContactListener();
            this.m_world.SetContactListener(this._contactListener);
        }
        
        protected function setupTextFields() : void
        {
            var _loc1_:TextFormat = new TextFormat("HelveticaNeueLT Std",12,0,null,null,null,null,null,TextFormatAlign.LEFT);
            this.fpsText = new TextField();
            addChild(this.fpsText);
            this.fpsText.defaultTextFormat = _loc1_;
            this.fpsText.textColor = 16777215;
            this.fpsText.multiline = true;
            this.fpsText.height = 20;
            this.fpsText.selectable = false;
            this.fpsText.autoSize = TextFieldAutoSize.LEFT;
            this.fpsText.wordWrap = true;
            this.fpsText.embedFonts = true;
            this.fpsText.blendMode = BlendMode.INVERT;
            if(Settings.hideHUD)
            {
                this.fpsText.visible = false;
            }
        }
        
        public function start() : void
        {
            this.paused = false;
            this.inputAllowed = true;
            this.frames = 0;
            this._iteration = 0;
            this._replayData = new ReplayData();
            this._music = SoundController.instance.playSoundLoop("Silence");
            if(this._level.endBlock)
            {
                this._level.endBlock.addEventListener(SessionEvent.COMPLETED,this.levelComplete);
            }
            addEventListener(Event.ENTER_FRAME,this.run);
            this.fpsTimer = new Timer(1000,0);
            this.fpsTimer.addEventListener(TimerEvent.TIMER,this.setFps);
            this.fpsTimer.start();
        }
        
        protected function run(param1:Event) : void
        {
            this.frames += 1;
            this._character.preActions();
            if(this.inputAllowed)
            {
                this._character.checkKeyStates();
                ++this._iteration;
            }
            else
            {
                this._character.doNothing();
            }
            this._character.actions();
            this.m_world.Step(this.m_timeStep,this.m_iterations);
            this._character.handleContactBuffer();
            this._character.checkJoints();
            this._level.actions();
            this._character.paint();
            this._level.paint();
            this._camera.step();
            this._particleController.step();
            SoundController.instance.step();
        }
        
        protected function addReplayEntry(param1:ReplayEvent) : void
        {
            this._replayData.addKeyEntry(param1.keyString,this._iteration);
        }
        
        public function levelComplete(param1:SessionEvent = null) : void
        {
            trace("level complete");
            this.inputAllowed = false;
            this._replayData.completed = true;
            if(this._level.endBlock)
            {
                this._level.endBlock.removeEventListener(SessionEvent.COMPLETED,this.levelComplete);
            }
            dispatchEvent(new SessionEvent(SessionEvent.COMPLETED));
        }
        
        public function pause() : void
        {
            if(!this.paused)
            {
                this.paused = true;
                removeEventListener(Event.ENTER_FRAME,this.run);
                this.fpsTimer.stop();
                this.fpsTimer.removeEventListener(TimerEvent.TIMER,this.setFps);
                SoundController.instance.systemMute();
                if(this.buttonContainer)
                {
                    this.buttonContainer.mouseChildren = false;
                }
            }
        }
        
        public function unpause() : void
        {
            if(this.paused)
            {
                this.paused = false;
                addEventListener(Event.ENTER_FRAME,this.run);
                this.fpsTimer = new Timer(1000,0);
                this.fpsTimer.addEventListener(TimerEvent.TIMER,this.setFps);
                this.fpsTimer.start();
                SoundController.instance.systemUnMute();
                if(this.buttonContainer)
                {
                    this.buttonContainer.mouseChildren = true;
                }
            }
        }
        
        public function die() : void
        {
            removeEventListener(Event.ENTER_FRAME,this.run);
            if(this.fpsTimer)
            {
                this.fpsTimer.stop();
                this.fpsTimer.removeEventListener(TimerEvent.TIMER,this.setFps);
            }
            if(this._level.endBlock)
            {
                this._level.endBlock.removeEventListener(SessionEvent.COMPLETED,this.levelComplete);
            }
            var _loc1_:b2Body = this.m_world.GetBodyList();
            while(_loc1_)
            {
                this.m_world.DestroyBody(_loc1_);
                _loc1_ = _loc1_.m_next;
            }
            this.m_world = null;
            this._character.removeKeyListeners();
            this._character.removeEventListener(ReplayEvent.ADD_ENTRY,this.addReplayEntry);
            this._character.die();
            this._character = null;
            this._level.die();
            this._level = null;
            this._music.stop();
            this._music = null;
            this._particleController.die();
            this._particleController = null;
            SoundController.instance.stopAllSounds();
            SoundController.instance.systemUnMute();
            this._camera = null;
            this._replayData = null;
            this._contactListener.die();
            this._contactListener = null;
            this._containerSprite = null;
            this.debug_sprite.graphics.clear();
        }
        
        protected function cleanup() : void
        {
            var _loc1_:int = this._containerSprite.numChildren;
            var _loc2_:int = _loc1_;
            while(_loc2_ > 0)
            {
                this._containerSprite.removeChildAt(_loc2_ - 1);
                _loc2_--;
            }
        }
        
        protected function setFps(param1:TimerEvent) : void
        {
            var _loc2_:Number = Math.round(System.totalMemory / 10485.76) / 100;
            this.fpsText.htmlText = this.frames.toString() + " fps<br>" + _loc2_ + " MB";
            this.frames = 0;
        }
        
        public function get character() : CharacterB2D
        {
            return this._character;
        }
        
        public function set character(param1:CharacterB2D) : void
        {
            this._character = param1;
        }
        
        public function get level() : LevelB2D
        {
            return this._level;
        }
        
        public function set level(param1:LevelB2D) : void
        {
            this._level = param1;
        }
        
        public function get containerSprite() : Sprite
        {
            return this._containerSprite;
        }
        
        public function set containerSprite(param1:Sprite) : void
        {
            throw new Error("set this in an override");
        }
        
        public function get contactListener() : ContactListener
        {
            return this._contactListener;
        }
        
        public function get replayData() : ReplayData
        {
            return this._replayData;
        }
        
        public function get camera() : StageCamera
        {
            return this._camera;
        }
        
        public function get particleController() : ParticleController
        {
            return this._particleController;
        }
        
        public function get iteration() : int
        {
            return this._iteration;
        }
        
        public function get version() : Number
        {
            return this._version;
        }
        
        public function get levelVersion() : Number
        {
            return this._levelVersion;
        }
        
        public function get buttonContainer() : Sprite
        {
            if(!this._buttonContainer)
            {
                this._buttonContainer = new Sprite();
                if(!this.isReplay)
                {
                    addChild(this._buttonContainer);
                }
            }
            return this._buttonContainer;
        }
    }
}

