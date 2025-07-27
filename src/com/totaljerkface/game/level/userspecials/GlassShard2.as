package com.totaljerkface.game.level.userspecials
{
    import Box2D.Collision.*;
    import Box2D.Collision.Shapes.*;
    import Box2D.Dynamics.*;
    import com.totaljerkface.game.*;
    import com.totaljerkface.game.editor.specials.*;
    import com.totaljerkface.game.events.*;
    import com.totaljerkface.game.level.*;
    import com.totaljerkface.game.sound.*;
    import flash.display.*;
    import flash.utils.*;
    
    public class GlassShard2 extends GlassShard
    {
        protected var stabbing:Boolean;
        
        public function GlassShard2(param1:b2Body, param2:Sprite, param3:Sprite, param4:Boolean)
        {
            this.stabbing = param4;
            super(param1,param2,param3);
        }
        
        override protected function setValues() : void
        {
            var _loc1_:Number = body.GetMass();
            shatterImpulse = _loc1_ * 10;
            if(this.stabbing)
            {
                stabImpulse = Math.min(body.m_mass * 5,2.5);
                if(_loc1_ < 0.1)
                {
                    bloodParticles = 15;
                    stabImpulse = 0;
                }
                if(_loc1_ >= 0.25 && sprite.width >= 15)
                {
                    fatal = true;
                }
            }
            else
            {
                stabImpulse = shatterImpulse;
            }
            if(_loc1_ < 0.75)
            {
                soundSuffix = "Light";
                glassParticles = 50;
            }
            else if(_loc1_ < 4)
            {
                soundSuffix = "Mid";
                glassParticles = 100;
            }
            else
            {
                soundSuffix = "Heavy";
                glassParticles = 200;
            }
        }
        
        override public function actions() : void
        {
            var _loc1_:int = 0;
            if(add)
            {
                _loc1_ = 0;
                while(_loc1_ < bodiesToAdd.length)
                {
                    createPrisJoint(bodiesToAdd[_loc1_],normals[_loc1_]);
                    _loc1_++;
                }
                bodiesToAdd = new Array();
                normals = new Array();
                add = false;
            }
            if(remove)
            {
                _loc1_ = 0;
                while(_loc1_ < bodiesToRemove.length)
                {
                    removeJoint(bodiesToRemove[_loc1_]);
                    _loc1_++;
                }
                bodiesToRemove = new Array();
                remove = false;
                this.checkZeroJoints();
            }
        }
        
        protected function checkZeroJoints() : void
        {
            var _loc2_:Object = null;
            var _loc3_:Session = null;
            var _loc4_:ContactListener = null;
            var _loc5_:b2FilterData = null;
            var _loc1_:int = 0;
            for(_loc2_ in bjDictionary)
            {
                _loc1_ += 1;
            }
            if(_loc1_ == 0)
            {
                _loc3_ = Settings.currentSession;
                _loc4_ = _loc3_.contactListener;
                _loc4_.deleteListener(ContactEvent.RESULT,shape);
                _loc5_ = new b2FilterData();
                _loc5_.categoryBits = 8;
                shape.SetFilterData(_loc5_);
                _loc3_.m_world.Refilter(shape);
                _loc4_.registerListener(ContactEvent.RESULT,shape,checkContact);
                _loc4_.deleteListener(ContactListener.ADD,sensor);
                _loc4_.deleteListener(ContactListener.REMOVE,sensor);
                body.DestroyShape(sensor);
                sensor = null;
                _loc3_.level.removeFromActionsVector(this);
            }
        }
    }
}

