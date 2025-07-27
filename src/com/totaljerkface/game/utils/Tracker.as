package com.totaljerkface.game.utils
{
    import flash.external.ExternalInterface;
    
    public class Tracker
    {
        public static const PRELOADER:String = "preloader";
        
        public static const MAIN_MENU:String = "main_menu";
        
        public static const FEATURED_BROWSER:String = "featured_browser";
        
        public static const LEVEL_BROWSER:String = "level_browser";
        
        public static const REPLAY_BROWSER:String = "replay_browser";
        
        public static const LEVEL_REPLAY_LOADER:String = "level_replay_loader";
        
        public static const EDITOR:String = "editor";
        
        public static const OPTIONS:String = "options";
        
        public static const CREDITS:String = "credits";
        
        public static const LEVEL:String = "level";
        
        public static const REPLAY:String = "replay";
        
        public static const CHARACTER_MENU:String = "character_menu";
        
        public static const BEGIN_LOAD:String = "begin_load";
        
        public static const AD_COMPLETE:String = "ad_complete";
        
        public static const LOAD_COMPLETE:String = "load_complete";
        
        public static const GOTO_MAIN_MENU:String = "goto_main_menu";
        
        public static const GOTO_FEATURED_BROWSER:String = "goto_featured_browser";
        
        public static const GOTO_LEVEL_BROWSER:String = "goto_level_browser";
        
        public static const GOTO_REPLAY_BROWSER:String = "goto_replay_browser";
        
        public static const GOTO_LEVEL_REPLAY_LOADER:String = "goto_level_replay_loader";
        
        public static const GOTO_EDITOR:String = "goto_editor";
        
        public static const GOTO_OPTIONS:String = "goto_options";
        
        public static const GOTO_CREDITS:String = "goto_credits";
        
        public static const GOTO_USER_PAGE:String = "goto_user_page";
        
        public static const CLICK_IOS_LINK:String = "click_ios_link";
        
        public static const CLICK_GOOGLEPLAY_LINK:String = "click_google_play_link";
        
        public static const MUTE:String = "mute";
        
        public static const UNMUTE:String = "unmute";
        
        public static const GET_FAVORITES:String = "get_favorites";
        
        public static const GET_LEVELS_BY_AUTHOR:String = "get_levels_by_author";
        
        public static const LEVEL_SEARCH:String = "level_search";
        
        public static const AUTHOR_SEARCH:String = "author_search";
        
        public static const ADD_FAVORITE:String = "add_favorite";
        
        public static const REMOVE_FAVORITE:String = "remove_favorite";
        
        public static const REFRESH_LEVELS:String = "refresh_levels";
        
        public static const PAGE_LEVELS:String = "page_levels";
        
        public static const REFRESH_REPLAYS:String = "refresh_replays";
        
        public static const PAGE_REPLAYS:String = "page_replays";
        
        public static const LOAD_REPLAY:String = "load_replay";
        
        public static const SAVE_LEVEL:String = "save_level";
        
        public static const OVERWRITE_LEVEL:String = "overwrite_level";
        
        public static const PUBLISH_LEVEL:String = "publish_level";
        
        public static const LOAD_LEVEL:String = "load_level";
        
        public static const DELETE_LEVEL:String = "delete_level";
        
        public static const IMPORT_LEVELDATA:String = "import_leveldata";
        
        public static const COPY_LEVELDATA:String = "copy_leveldata";
        
        public static const SET_QUALITY:String = "set_quality";
        
        public static const SET_BLOOD:String = "set_blood";
        
        public static const CUSTOMIZE_CONTROLS:String = "customize_controls";
        
        public static const VOTE:String = "vote";
        
        public static const RESTART:String = "restart";
        
        public static const CHANGE_CHARACTER:String = "change_character";
        
        public static const CHARACTER_SELECTED:String = "character_selected";
        
        public static const VIEW_REPLAY:String = "view_replay";
        
        public static const SAVE_REPLAY:String = "save_replay";
        
        public function Tracker()
        {
            super();
        }
        
        public static function trackEvent(param1:String, param2:String, param3:String = null, param4:int = -1, param5:Boolean = false) : *
        {
            var _loc6_:Object = null;
            var _loc7_:String = null;
            var _loc8_:* = undefined;
            if(ExternalInterface.available)
            {
                _loc6_ = new Object();
                _loc6_["eventCategory"] = param1;
                _loc6_["eventAction"] = param2;
                if(param3)
                {
                    _loc6_["eventLabel"] = param3;
                }
                if(param4 > -1)
                {
                    _loc6_["eventValue"] = param4;
                }
                ExternalInterface.call("ga","send","event",_loc6_);
                _loc7_ = "";
                for(_loc8_ in _loc6_)
                {
                    _loc7_ += _loc8_ + ": " + _loc6_[_loc8_] + " ";
                }
                trace("TRACK EVENT: " + _loc7_);
            }
        }
    }
}

