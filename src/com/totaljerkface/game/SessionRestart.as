package com.totaljerkface.game
{
    import com.totaljerkface.game.character.CharacterB2D;
    import com.totaljerkface.game.events.ReplayEvent;
    import com.totaljerkface.game.level.LevelB2D;
    import com.totaljerkface.game.particles.ParticleController;
    import flash.display.Sprite;
    import flash.geom.Rectangle;
    
    public class SessionRestart extends Session
    {
        public function SessionRestart(param1:Sprite, param2:Number, param3:CharacterB2D, param4:LevelB2D, param5:Number)
        {
            super(param2,null,null,param5);
            trace("SESSION RESTART");
            _containerSprite = param1;
            addChild(_containerSprite);
            _character = param3;
            _character.session = this;
            _level = param4;
            _level.session = this;
        }
        
        override protected function init(param1:Sprite, param2:Sprite) : void
        {
        }
        
        override public function create() : void
        {
            _particleController = new ParticleController(_containerSprite);
            createWorld();
            trace("resetting level");
            _level.reset();
            _level.insertBackDrops();
            trace("resetting character");
            _character.reset();
            _character.addKeyListeners();
            _camera = new StageCamera(_containerSprite,_character.cameraFocus,this);
            _camera.secondFocus = _character.cameraSecondFocus;
            var _loc1_:Rectangle = _level.cameraBounds;
            _camera.setLimits(_loc1_.x,_loc1_.x + _loc1_.width,_loc1_.y,_loc1_.y + _loc1_.height);
            setupTextFields();
            _containerSprite.addChild(debug_sprite);
            _character.addEventListener(ReplayEvent.ADD_ENTRY,addReplayEntry);
            _character.paint();
            start();
        }
    }
}

