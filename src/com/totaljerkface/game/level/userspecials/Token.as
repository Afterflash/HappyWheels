package com.totaljerkface.game.level.userspecials
{
    import Box2D.Collision.*;
    import Box2D.Collision.Shapes.*;
    import Box2D.Common.Math.b2Vec2;
    import Box2D.Dynamics.*;
    import com.totaljerkface.game.ContactListener;
    import com.totaljerkface.game.Session;
    import com.totaljerkface.game.Settings;
    import com.totaljerkface.game.character.CharacterB2D;
    import com.totaljerkface.game.editor.specials.*;
    import com.totaljerkface.game.level.*;
    import com.totaljerkface.game.sound.SoundController;
    import flash.display.*;
    import flash.geom.Point;
    
    public class Token extends LevelItem
    {
        private var _shape:b2Shape;
        
        private var _body:b2Body;
        
        private var mc:MovieClip;
        
        public function Token(param1:Special, param2:b2Body = null, param3:Point = null)
        {
            super();
            var _loc4_:TokenRef = param1 as TokenRef;
            this.mc = new CoinMC();
            this.mc.x = param1.x;
            this.mc.y = param1.y;
            this.mc.container.gotoAndStop(_loc4_.tokenType);
            Settings.currentSession.level.background.addChild(this.mc);
            this.createBody(_loc4_);
        }
        
        internal function createBody(param1:TokenRef) : *
        {
            var _loc2_:b2BodyDef = new b2BodyDef();
            _loc2_.position = new b2Vec2(param1.x / m_physScale,param1.y / m_physScale);
            var _loc3_:b2CircleDef = new b2CircleDef();
            _loc3_.isSensor = true;
            _loc3_.radius = 23 / m_physScale;
            _loc3_.filter.categoryBits = 8;
            this._body = Settings.currentSession.m_world.CreateBody(_loc2_);
            this._shape = this._body.CreateShape(_loc3_) as b2Shape;
            Settings.currentSession.contactListener.registerListener(ContactListener.ADD,this._shape,this.checkContact);
        }
        
        private function checkContact(param1:b2ContactPoint) : void
        {
            var _loc3_:* = undefined;
            var _loc4_:CharacterB2D = null;
            var _loc2_:Session = Settings.currentSession;
            if(param1.shape2.GetMaterial() & 2)
            {
                _loc3_ = param1.shape2.GetUserData();
                if(_loc3_ is CharacterB2D)
                {
                    _loc4_ = _loc3_ as CharacterB2D;
                    if(!_loc4_.dead)
                    {
                        _loc2_.contactListener.deleteListener(ContactListener.ADD,this._shape);
                        SoundController.instance.playAreaSoundInstance("Bleep3",this._body);
                        Settings.currentSession.level.singleActionVector.push(this);
                    }
                }
            }
        }
        
        override public function singleAction() : void
        {
            var _loc1_:UserLevel = Settings.currentSession.level as UserLevel;
            _loc1_.tokenFound();
            Settings.currentSession.level.background.removeChild(this.mc);
            Settings.currentSession.m_world.DestroyBody(this._body);
            this._body = null;
        }
    }
}

