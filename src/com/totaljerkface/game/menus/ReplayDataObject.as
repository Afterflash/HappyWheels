package com.totaljerkface.game.menus
{
    import com.totaljerkface.game.utils.TextUtils;
    
    public class ReplayDataObject
    {
        private var _id:int;
        
        private var _level_id:int;
        
        private var _user_id:int;
        
        private var _user_name:String;
        
        private var _weighted_rating:Number;
        
        private var _average_rating:Number;
        
        private var _votes:int;
        
        private var _views:int;
        
        private var _created:Date;
        
        private var _comments:String;
        
        private var _character:int;
        
        private var _timeFrames:int;
        
        private var _timeSeconds:Number;
        
        private var _architecture:String;
        
        private var _version:Number;
        
        public function ReplayDataObject(param1:Object = null, param2:Object = null, param3:Object = null, param4:Object = null, param5:Object = null, param6:Object = null, param7:Object = null, param8:Object = null, param9:Object = null, param10:Object = null, param11:Object = null, param12:Object = null, param13:Object = null)
        {
            super();
            this._id = int(param1);
            this._level_id = int(param2);
            this._user_id = int(param3);
            this._user_name = String(param4);
            this._weighted_rating = Number(param5);
            this._votes = int(param6);
            this._average_rating = this.getAverageRating(this._weighted_rating,this._votes);
            this._views = int(param7);
            this._comments = TextUtils.removeSlashes(String(param9));
            this._character = int(param10);
            this._timeFrames = int(param11);
            this._timeSeconds = int(param11) / 30;
            this._architecture = String(param12);
            this._version = Number(param13);
            var _loc14_:String = String(param8);
            var _loc15_:Number = Number(_loc14_.substr(0,4));
            var _loc16_:Number = Number(_loc14_.substr(5,2)) - 1;
            var _loc17_:Number = Number(_loc14_.substr(8,2));
            var _loc18_:Number = Number(_loc14_.substr(11,2));
            var _loc19_:Number = Number(_loc14_.substr(14,2));
            var _loc20_:Number = Number(_loc14_.substr(17,2));
            this._created = new Date(_loc15_,_loc16_,_loc17_,_loc18_,_loc19_,_loc20_);
        }
        
        private function getAverageRating(param1:Number, param2:int) : Number
        {
            var _loc3_:int = 10;
            var _loc4_:Number = 2.5;
            var _loc5_:Number = param2 == 0 ? 0 : (param1 - _loc4_ * _loc3_ / (param2 + _loc3_)) / (param2 / (param2 + _loc3_));
            return Math.min(5,Math.max(_loc5_,0));
        }
        
        public function get id() : int
        {
            return this._id;
        }
        
        public function set id(param1:int) : void
        {
            this._id = param1;
        }
        
        public function get level_id() : int
        {
            return this._level_id;
        }
        
        public function get user_id() : int
        {
            return this._user_id;
        }
        
        public function get user_name() : String
        {
            return this._user_name;
        }
        
        public function get weighted_rating() : Number
        {
            return this._weighted_rating;
        }
        
        public function get average_rating() : Number
        {
            return this._average_rating;
        }
        
        public function get votes() : int
        {
            return this._votes;
        }
        
        public function get views() : int
        {
            return this._views;
        }
        
        public function get created() : Date
        {
            return this._created;
        }
        
        public function get comments() : String
        {
            return this._comments;
        }
        
        public function get character() : int
        {
            return this._character;
        }
        
        public function get timeFrames() : int
        {
            return this._timeFrames;
        }
        
        public function get timeSeconds() : Number
        {
            return this._timeSeconds;
        }
        
        public function get architecture() : String
        {
            return this._architecture;
        }
        
        public function get version() : Number
        {
            return this._version;
        }
        
        public function toString() : String
        {
            var _loc1_:String = "replaydataobj: ";
            _loc1_ = _loc1_.concat("id = " + this._id + ", ");
            _loc1_ = _loc1_.concat("level_id = " + this._level_id + ", ");
            _loc1_ = _loc1_.concat("user_id = " + this._user_id + ", ");
            _loc1_ = _loc1_.concat("user_name = " + this._user_name + ", ");
            _loc1_ = _loc1_.concat("weighted_rating = " + this._weighted_rating + ", ");
            _loc1_ = _loc1_.concat("average_rating = " + this._average_rating + ", ");
            _loc1_ = _loc1_.concat("votes = " + this._votes + ", ");
            _loc1_ = _loc1_.concat("views = " + this._views + ", ");
            _loc1_ = _loc1_.concat("created = " + this._created + ", ");
            _loc1_ = _loc1_.concat("comments = " + this._comments + ", ");
            _loc1_ = _loc1_.concat("character = " + this._character + ", ");
            _loc1_ = _loc1_.concat("timeFrames = " + this._timeFrames + ", ");
            _loc1_ = _loc1_.concat("timeSeconds = " + this._timeSeconds + ", ");
            _loc1_ = _loc1_.concat("architecture = " + this._architecture + ", ");
            return _loc1_.concat("version = " + this._version + ", ");
        }
        
        public function clone() : ReplayDataObject
        {
            return new ReplayDataObject(this._id,this._user_id,this._user_name,this._weighted_rating,this._votes,this._views,this._created,this._comments,this._character,this._timeFrames,this._architecture,this._version);
        }
    }
}

