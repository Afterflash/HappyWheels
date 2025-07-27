package com.totaljerkface.game.character
{
    import Box2D.Collision.Shapes.*;
    import Box2D.Common.Math.b2Vec2;
    import Box2D.Dynamics.*;
    import Box2D.Dynamics.Joints.*;
    import com.totaljerkface.game.*;
    import com.totaljerkface.game.sound.SoundController;
    import flash.display.*;
    
    public class IntestineChain
    {
        private var character:CharacterB2D;
        
        private var totalIntestines:int;
        
        private var intestineLength:Number;
        
        private var chestBody:b2Body;
        
        private var pelvisBody:b2Body;
        
        private var intestineJoints:Array;
        
        private var intestineMCs:Array;
        
        private var m_physScale:Number;
        
        private var pelvisIntestineJoint:b2DistanceJoint;
        
        private var intestineChestJoint:b2DistanceJoint;
        
        private var antiGrav:Array;
        
        public function IntestineChain(param1:CharacterB2D, param2:int, param3:Number)
        {
            var _loc4_:SantaClaus = null;
            var _loc5_:SleighElf = null;
            super();
            this.character = param1;
            this.totalIntestines = param2;
            this.intestineLength = param3;
            this.m_physScale = param1.m_physScale;
            this.chestBody = param1.chestBody;
            this.pelvisBody = param1.pelvisBody;
            this.intestineMCs = param1.intestineMCs;
            if(param1 is SantaClaus)
            {
                _loc4_ = param1 as SantaClaus;
                this.antiGrav = _loc4_.antiGravArray;
            }
            else if(param1 is SleighElf)
            {
                _loc5_ = param1 as SleighElf;
                this.antiGrav = _loc5_.antiGravArray;
            }
            this.create();
        }
        
        private function create() : void
        {
            var _loc20_:b2Body = null;
            var _loc21_:b2Body = null;
            var _loc22_:b2Body = null;
            var _loc23_:MovieClip = null;
            var _loc1_:b2World = this.character.session.m_world;
            var _loc2_:* = this.character.character_scale;
            var _loc3_:* = this.character.mc_scale;
            var _loc4_:b2BodyDef = new b2BodyDef();
            var _loc5_:b2CircleDef = new b2CircleDef();
            _loc5_.density = 1;
            _loc5_.friction = 0.3;
            _loc5_.restitution = 0.1;
            _loc5_.radius = 5 / _loc2_;
            _loc5_.filter = this.character.zeroFilter;
            var _loc6_:Number = Number((this.pelvisBody.GetShapeList() as b2PolygonShape).GetVertices()[0].y);
            var _loc7_:Number = this.pelvisBody.GetAngle() + Math.PI / 2;
            var _loc8_:b2Vec2 = new b2Vec2(this.pelvisBody.GetPosition().x + Math.cos(_loc7_) * _loc6_,this.pelvisBody.GetPosition().y + Math.sin(_loc7_) * _loc6_);
            _loc6_ = Number((this.chestBody.GetShapeList() as b2PolygonShape).GetVertices()[2].y);
            _loc7_ = this.chestBody.GetAngle() + Math.PI / 2;
            var _loc9_:b2Vec2 = new b2Vec2(this.chestBody.GetPosition().x + Math.cos(_loc7_) * _loc6_,this.chestBody.GetPosition().y + Math.sin(_loc7_) * _loc6_);
            var _loc10_:Number = _loc8_.x;
            var _loc11_:Number = _loc8_.y;
            var _loc12_:Number = _loc9_.x - _loc10_;
            var _loc13_:Number = _loc9_.y - _loc11_;
            var _loc14_:Number = _loc12_ / (this.totalIntestines + 1);
            var _loc15_:Number = _loc13_ / (this.totalIntestines + 1);
            var _loc16_:Array = new Array();
            var _loc17_:int = 1;
            while(_loc17_ <= this.totalIntestines)
            {
                _loc4_.position.Set(_loc10_ + _loc14_ * _loc17_,_loc11_ + _loc15_ * _loc17_);
                _loc4_.fixedRotation = true;
                _loc20_ = _loc1_.CreateBody(_loc4_);
                _loc20_.CreateShape(_loc5_);
                _loc20_.SetMassFromShapes();
                _loc20_.SetLinearVelocity(this.chestBody.GetLinearVelocity());
                _loc16_.push(_loc20_);
                _loc17_++;
            }
            if(this.antiGrav)
            {
                _loc17_ = 0;
                while(_loc17_ < this.totalIntestines)
                {
                    this.antiGrav.push(_loc16_[_loc17_]);
                    _loc17_++;
                }
            }
            var _loc18_:b2DistanceJointDef = new b2DistanceJointDef();
            var _loc19_:Number = this.intestineLength / _loc2_;
            _loc18_.Initialize(this.pelvisBody,_loc16_[0],_loc8_,_loc16_[0].GetPosition());
            _loc18_.length = _loc19_;
            _loc18_.collideConnected = false;
            this.pelvisIntestineJoint = _loc1_.CreateJoint(_loc18_) as b2DistanceJoint;
            this.intestineJoints = new Array();
            _loc17_ = 0;
            while(_loc17_ <= this.totalIntestines - 2)
            {
                _loc21_ = _loc16_[_loc17_];
                _loc22_ = _loc16_[_loc17_ + 1];
                _loc18_.Initialize(_loc21_,_loc22_,_loc21_.GetPosition(),_loc22_.GetPosition());
                _loc18_.length = _loc19_;
                _loc18_.collideConnected = false;
                this.intestineJoints.push(_loc1_.CreateJoint(_loc18_) as b2DistanceJoint);
                _loc17_++;
            }
            _loc21_ = _loc16_[this.totalIntestines - 1];
            _loc18_.Initialize(_loc21_,this.chestBody,_loc21_.GetPosition(),_loc9_);
            _loc18_.length = _loc19_;
            _loc18_.collideConnected = false;
            this.intestineChestJoint = _loc1_.CreateJoint(_loc18_) as b2DistanceJoint;
            _loc17_ = 0;
            while(_loc17_ < this.intestineMCs.length)
            {
                _loc23_ = this.intestineMCs[_loc17_];
                _loc23_.x = -200;
                _loc23_.y = -200;
                _loc23_.visible = true;
                var _loc24_:* = 1 / _loc3_;
                _loc23_.scaleY = 1 / _loc3_;
                _loc23_.scaleX = _loc24_;
                _loc17_++;
            }
        }
        
        public function paint() : void
        {
            var _loc2_:MovieClip = null;
            var _loc3_:b2Vec2 = null;
            var _loc4_:b2Vec2 = null;
            var _loc5_:Number = NaN;
            var _loc6_:Number = NaN;
            var _loc7_:Number = NaN;
            var _loc8_:b2DistanceJoint = null;
            if(this.pelvisIntestineJoint)
            {
                _loc2_ = this.intestineMCs[0];
                _loc3_ = this.pelvisIntestineJoint.GetAnchor1();
                _loc2_.x = _loc3_.x * this.m_physScale;
                _loc2_.y = _loc3_.y * this.m_physScale;
                _loc4_ = this.pelvisIntestineJoint.GetBody2().GetPosition();
                _loc5_ = Math.atan2(_loc3_.y - _loc4_.y,_loc3_.x - _loc4_.x);
                _loc2_.rotation = _loc5_ * (180 / Math.PI);
                _loc6_ = Math.sqrt(Math.pow(_loc4_.x - _loc3_.x,2) + Math.pow(_loc4_.y - _loc3_.y,2));
                _loc7_ = _loc6_ / this.pelvisIntestineJoint.m_length;
                _loc2_["inner"].scaleX = _loc7_;
            }
            var _loc1_:int = 0;
            while(_loc1_ < this.intestineJoints.length)
            {
                _loc8_ = this.intestineJoints[_loc1_];
                _loc2_ = this.intestineMCs[_loc1_ + 1];
                _loc3_ = _loc8_.GetBody1().GetPosition();
                _loc2_.x = _loc3_.x * this.m_physScale;
                _loc2_.y = _loc3_.y * this.m_physScale;
                _loc4_ = _loc8_.GetBody2().GetPosition();
                _loc5_ = Math.atan2(_loc3_.y - _loc4_.y,_loc3_.x - _loc4_.x);
                _loc2_.rotation = _loc5_ * (180 / Math.PI);
                _loc6_ = Math.sqrt(Math.pow(_loc4_.x - _loc3_.x,2) + Math.pow(_loc4_.y - _loc3_.y,2));
                _loc7_ = _loc6_ / _loc8_.m_length;
                _loc2_["inner"].scaleX = _loc7_;
                _loc1_++;
            }
            if(this.intestineChestJoint)
            {
                _loc2_ = this.intestineMCs[this.intestineMCs.length - 1];
                _loc3_ = _loc4_;
                _loc2_.x = _loc3_.x * this.m_physScale;
                _loc2_.y = _loc3_.y * this.m_physScale;
                _loc4_ = this.intestineChestJoint.GetAnchor2();
                _loc5_ = Math.atan2(_loc3_.y - _loc4_.y,_loc3_.x - _loc4_.x);
                _loc2_.rotation = _loc5_ * (180 / Math.PI);
                _loc6_ = Math.sqrt(Math.pow(_loc4_.x - _loc3_.x,2) + Math.pow(_loc4_.y - _loc3_.y,2));
                _loc7_ = _loc6_ / this.intestineChestJoint.m_length;
                _loc2_["inner"].scaleX = _loc7_;
            }
        }
        
        public function intestineBreak1(param1:Number) : void
        {
            this.intestineMCs[0].visible = false;
            if(this.pelvisIntestineJoint == null)
            {
                return;
            }
            this.pelvisIntestineJoint.broken = true;
            this.character.session.m_world.DestroyJoint(this.pelvisIntestineJoint);
            this.pelvisIntestineJoint = null;
            SoundController.instance.playAreaSoundInstance("LigTear1",this.pelvisBody);
        }
        
        public function intestineBreak2(param1:Number) : void
        {
            this.intestineMCs[this.intestineMCs.length - 1].visible = false;
            if(this.intestineChestJoint == null)
            {
                return;
            }
            this.intestineChestJoint.broken = true;
            this.character.session.m_world.DestroyJoint(this.intestineChestJoint);
            this.intestineChestJoint = null;
            SoundController.instance.playAreaSoundInstance("LigTear1",this.chestBody);
        }
        
        public function checkJoints() : void
        {
            this.checkDistJoint(this.pelvisIntestineJoint,1.5,this.intestineBreak1);
            this.checkDistJoint(this.intestineChestJoint,1.5,this.intestineBreak2);
        }
        
        private function checkDistJoint(param1:b2DistanceJoint, param2:Number, param3:*) : void
        {
            var _loc4_:Number = NaN;
            if(Boolean(param1) && !param1.broken)
            {
                _loc4_ = Math.abs(param1.m_impulse);
                if(_loc4_ > param2)
                {
                    param3(_loc4_);
                }
            }
        }
    }
}

