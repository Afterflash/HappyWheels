package com.totaljerkface.game
{
    import Box2D.Collision.*;
    import Box2D.Collision.Shapes.*;
    import Box2D.Common.*;
    import Box2D.Common.Math.*;
    import Box2D.Dynamics.*;
    import Box2D.Dynamics.Contacts.*;
    import Box2D.Dynamics.Joints.*;
    import com.totaljerkface.game.character.*;
    import com.totaljerkface.game.events.*;
    import com.totaljerkface.game.level.*;
    import com.totaljerkface.game.particles.*;
    import com.totaljerkface.game.sound.SoundController;
    import flash.display.*;
    import flash.events.*;
    import flash.geom.Rectangle;
    import flash.text.*;
    import flash.utils.Timer;
    
    public class SessionReplay extends Session
    {
        protected var keyDisplay:KeyDisplay;
        
        protected var replayProgressBar:ReplayProgressBar;
        
        protected var mouseClickMap:Object;
        
        public function SessionReplay(param1:Number, param2:Sprite, param3:Sprite, param4:Number, param5:ReplayData)
        {
            super(param1,param2,param3,param4);
            trace("SESSION REPLAY");
            _replayData = param5;
            this.mouseClickMap = _replayData.getMouseClickMap();
            totalIterations = _replayData.getLength();
            isReplay = true;
        }
        
        override public function create() : void
        {
            _particleController = new ParticleController(_containerSprite);
            createWorld();
            trace("building level");
            _level.create();
            trace("building character");
            _character.create();
            _containerSprite.addChild(_level.foreground);
            _camera = new StageCamera(_containerSprite,_character.cameraFocus,this);
            _camera.secondFocus = _character.cameraSecondFocus;
            var _loc1_:Rectangle = _level.cameraBounds;
            _camera.setLimits(_loc1_.x,_loc1_.x + _loc1_.width,_loc1_.y,_loc1_.y + _loc1_.height);
            setupTextFields();
            _containerSprite.addChild(debug_sprite);
            _character.paint();
            this.start();
        }
        
        override public function start() : void
        {
            paused = false;
            inputAllowed = true;
            frames = 0;
            _iteration = 0;
            _music = SoundController.instance.playSoundLoop("Silence");
            this.addReplayControls();
            addEventListener(Event.ENTER_FRAME,this.run);
            fpsTimer = new Timer(1000,0);
            fpsTimer.addEventListener(TimerEvent.TIMER,setFps);
            fpsTimer.start();
        }
        
        private function addReplayControls() : void
        {
            this.keyDisplay = new KeyDisplay(_character);
            addChild(this.keyDisplay);
            this.replayProgressBar = new ReplayProgressBar();
            this.replayProgressBar.x = 150;
            this.replayProgressBar.y = 20;
            addChild(this.replayProgressBar);
            if(Settings.hideHUD)
            {
                this.keyDisplay.visible = this.replayProgressBar.visible = fpsText.visible = false;
            }
        }
        
        public function removeReplayControls() : void
        {
            removeChild(this.keyDisplay);
            this.keyDisplay = null;
            this.replayProgressBar.die();
            stage.frameRate = 30;
        }
        
        override protected function run(param1:Event) : void
        {
            var _loc2_:MouseData = null;
            this.replayProgressBar.updateProgress(iteration,totalIterations);
            frames += 1;
            _character.preActions();
            if(inputAllowed)
            {
                _loc2_ = this.mouseClickMap[iteration.toString()];
                if(_loc2_)
                {
                    level.mouseClickTrigger(_loc2_);
                }
                if(iteration >= totalIterations)
                {
                    this.levelComplete();
                }
                _character.checkReplayData(this.keyDisplay,replayData.getKeyEntry(iteration));
                ++_iteration;
            }
            else
            {
                _character.doNothing();
            }
            _character.actions();
            m_world.Step(m_timeStep,m_iterations);
            _character.handleContactBuffer();
            _character.checkJoints();
            _level.actions();
            _character.paint();
            _level.paint();
            _camera.step();
            _particleController.step();
            SoundController.instance.step();
        }
        
        override public function levelComplete(param1:SessionEvent = null) : void
        {
            trace("level complete");
            inputAllowed = false;
            dispatchEvent(new SessionEvent(SessionEvent.COMPLETED));
        }
        
        override public function die() : void
        {
            super.die();
            this.removeReplayControls();
        }
    }
}

