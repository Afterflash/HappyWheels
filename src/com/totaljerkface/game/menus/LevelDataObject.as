package com.totaljerkface.game.menus
{
    import com.totaljerkface.game.utils.TextUtils;
    
    public class LevelDataObject
    {
        private var _id:int;
        
        private var _name:String;
        
        private var _author_id:int;
        
        private var _author_name:String;
        
        private var _weighted_rating:Number;
        
        private var _average_rating:Number;
        
        private var _votes:int;
        
        private var _plays:int;
        
        private var _created:Date;
        
        private var _comments:String;
        
        private var _character:int;
        
        private var _forceChar:Boolean;
        
        private var _importable:Boolean;
        
        private var _featured:Boolean;
        
        private var _isPublic:Boolean;
        
        private var _date_featured:Date;
        
        private var _data:XML;
        
        public function LevelDataObject(param1:Object = null, param2:Object = null, param3:Object = null, param4:Object = null, param5:Object = null, param6:Object = null, param7:Object = null, param8:Object = null, param9:Object = null, param10:Object = null, param11:Object = null, param12:Object = null, param13:Object = null, param14:Object = null, param15:Object = null)
        {
            super();
            this._id = int(param1);
            this._name = TextUtils.removeSlashes(String(param2));
            this._author_id = int(param3);
            this._author_name = String(param4);
            this._weighted_rating = Number(param5);
            this._votes = int(param6);
            this._average_rating = this.getAverageRating(this._weighted_rating,this._votes);
            this._plays = int(param7);
            this._comments = TextUtils.removeSlashes(String(param9));
            this._character = int(param10);
            this._forceChar = this._character > 0 ? true : false;
            this._importable = String(param11) == "1" ? true : false;
            this._featured = String(param12) == "1" ? true : false;
            this._isPublic = String(param13) == "1" ? true : false;
            var _loc16_:String = String(param8);
            this._created = this.dateFromString(_loc16_);
            if(param14)
            {
                this._date_featured = this.dateFromString(String(param14));
            }
            if(param15)
            {
                this._data = new XML(param15);
            }
        }
        
        private function dateFromString(param1:String) : Date
        {
            var _loc2_:Number = Number(param1.substr(0,4));
            var _loc3_:Number = Number(param1.substr(5,2)) - 1;
            var _loc4_:Number = Number(param1.substr(8,2));
            var _loc5_:Number = Number(param1.substr(11,2));
            var _loc6_:Number = Number(param1.substr(14,2));
            var _loc7_:Number = Number(param1.substr(17,2));
            return new Date(_loc2_,_loc3_,_loc4_,_loc5_,_loc6_,_loc7_);
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
        
        public function get name() : String
        {
            return this._name;
        }
        
        public function get author_id() : int
        {
            return this._author_id;
        }
        
        public function get author_name() : String
        {
            return this._author_name;
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
        
        public function get plays() : int
        {
            return this._plays;
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
        
        public function get forceChar() : Boolean
        {
            return this._forceChar;
        }
        
        public function get importable() : Boolean
        {
            return this._importable;
        }
        
        public function set importable(param1:Boolean) : void
        {
            this._importable = param1;
        }
        
        public function get featured() : Boolean
        {
            return this._featured;
        }
        
        public function get isPublic() : Boolean
        {
            return this._isPublic;
        }
        
        public function set isPublic(param1:Boolean) : void
        {
            this._isPublic = param1;
        }
        
        public function get date_featured() : Date
        {
            return this._date_featured;
        }
        
        public function get data() : XML
        {
            return this._data;
        }
        
        public function set data(param1:XML) : void
        {
            this._data = param1;
        }
        
        public function toString() : String
        {
            var _loc1_:String = "leveldataobj: ";
            _loc1_ = _loc1_.concat("id = " + this._id + ", ");
            _loc1_ = _loc1_.concat("name = " + this._name + ", ");
            _loc1_ = _loc1_.concat("author_id = " + this._author_id + ", ");
            _loc1_ = _loc1_.concat("author_name = " + this._author_name + ", ");
            _loc1_ = _loc1_.concat("weighted_rating = " + this._weighted_rating + ", ");
            _loc1_ = _loc1_.concat("average_rating = " + this._average_rating + ", ");
            _loc1_ = _loc1_.concat("votes = " + this._votes + ", ");
            _loc1_ = _loc1_.concat("plays = " + this._plays + ", ");
            _loc1_ = _loc1_.concat("created = " + this._created + ", ");
            _loc1_ = _loc1_.concat("comments = " + this._comments + ", ");
            _loc1_ = _loc1_.concat("character = " + this._character + ", ");
            _loc1_ = _loc1_.concat("forceChar = " + this._forceChar + ", ");
            _loc1_ = _loc1_.concat("importable = " + this._importable + ", ");
            _loc1_ = _loc1_.concat("featured = " + this._featured + ", ");
            return _loc1_.concat("isPublic = " + this._isPublic + ", ");
        }
        
        public function clone() : LevelDataObject
        {
            return new LevelDataObject(this._id,this._name,this._author_id,this._author_name,this._weighted_rating,this._votes,this._plays,this._created,this._comments,this._character,this._forceChar,this._importable,this._featured,this._isPublic);
        }
    }
}

