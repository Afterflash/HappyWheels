package com.totaljerkface.game
{
    import flash.display.Stage;
    import flash.net.SharedObject;
    
    public class Settings
    {
        public static var username:String;
        
        public static var architecture:String;
        
        public static var disableUpload:Boolean;
        
        public static var sharedObject:SharedObject;
        
        public static var editorDebugDraw:Boolean;
        
        public static var GET_LOGIN:String;
        
        public static var GET_USER_ID:String;
        
        public static var GET_LEVEL_LIST:String;
        
        public static var GET_FEATURED_LEVEL_LIST:String;
        
        public static var GET_LEVEL_DATA:String;
        
        public static var GET_LEVEL_DATA_NO_CACHE:String;
        
        public static var SET_LEVEL_DATA:String;
        
        public static var VOTE_LEVEL:String;
        
        public static var ADD_LEVEL_FAVORITES:String;
        
        public static var REMOVE_LEVEL_FAVORITES:String;
        
        public static var FLAG_LEVEL:String;
        
        public static var GET_REPLAY_LIST:String;
        
        public static var GET_REPLAY_DATA:String;
        
        public static var SET_REPLAY_DATA:String;
        
        public static var VOTE_REPLAY:String;
        
        public static var FLAG_REPLAY:String;
        
        public static var USER_PROFILE:String;
        
        public static var LEVEL_RULES:String;
        
        public static var useCompressedTextures:Boolean;
        
        public static var replayIndex:int;
        
        public static var userLevelIndex:int;
        
        public static var debugText:DebugText;
        
        private static var session:Session;
        
        public static var stageSprite:Stage;
        
        public static const CURRENT_VERSION:Number = 2.0;
        
        public static var user_id:int = -1;
        
        public static var disableMessage:String = "Uploading new data is temporarily disabled. I\'M SORRY!";
        
        public static var numBackgroundLayers:int = 5;
        
        public static const characterPath:String = "characters/";
        
        public static const levelPath:String = "levels/";
        
        public static const imagePath:String = "game_images/";
        
        public static var siteURL:String = "";
        
        public static var pathPrefix:String = "";
        
        public static var hideHUD:Boolean = false;
        
        public static var smoothing:Boolean = true;
        
        public static var characterIndex:int = 1;
        
        public static var hideVehicle:Boolean = false;
        
        public static var levelIndex:int = 1;
        
        public static var bdIndex:int = 0;
        
        public static var bdColor:int = 16777215;
        
        public static var bloodSetting:int = 1;
        
        public static var YParticleLimit:int = 850;
        
        public static var activeXLimit:int = 2000;
        
        public static const maxReplayFrames:int = 6000;
        
        public static const characterNames:Array = ["wheelchair guy","segway guy","irresponsible dad","effective shopper","moped couple","lawnmower man","explorer guy","santa claus","pogostick man","irresponsible mom","helicopter man"];
        
        public static const shapeClassPath:String = "com.totaljerkface.game.editor.";
        
        public static const shapeList:Array = ["RectangleShape","CircleShape","TriangleShape","PolygonShape","ArtShape"];
        
        public static const jointClassPath:String = "com.totaljerkface.game.editor.joints.";
        
        public static const jointList:Array = ["PinJoint"];
        
        public static const specialClassPath:String = "com.totaljerkface.game.editor.specials.";
        
        public static const specialList:Array = ["VanRef","TableRef","MineRef","IBeamRef","LogRef","SpringBoxRef","SpikesRef","WreckingBallRef","FanRef","FinishLineRef","SoccerBallRef","MeteorRef","BoostRef","Building1Ref","Building2Ref","HarpoonGunRef","TextBoxRef","NPCharacterRef","GlassRef","ChairRef","BottleRef","TVRef","BoomboxRef","SignPostRef","ToiletRef","HomingMineRef","TrashCanRef","RailRef","JetRef","ArrowGunRef","ChainRef","TokenRef","FoodItemRef","CannonRef","BladeWeaponRef","PaddleRef"];
        
        public static var totalCharacters:int = 11;
        
        public static var favoriteLevelIds:Array = new Array();
        
        public static const accelerateDefaultCode:int = 38;
        
        public static const decelerateDefaultCode:int = 40;
        
        public static const leanForwardDefaultCode:int = 39;
        
        public static const leanBackDefaultCode:int = 37;
        
        public static const primaryActionDefaultCode:int = 32;
        
        public static const secondaryAction1DefaultCode:int = 16;
        
        public static const secondaryAction2DefaultCode:int = 17;
        
        public static const ejectDefaultCode:int = 90;
        
        public static const switchCameraDefaultCode:int = 67;
        
        public static var accelerateCode:int = accelerateDefaultCode;
        
        public static var decelerateCode:int = decelerateDefaultCode;
        
        public static var leanForwardCode:int = leanForwardDefaultCode;
        
        public static var leanBackCode:int = leanBackDefaultCode;
        
        public static var primaryActionCode:int = primaryActionDefaultCode;
        
        public static var secondaryAction1Code:int = secondaryAction1DefaultCode;
        
        public static var secondaryAction2Code:int = secondaryAction2DefaultCode;
        
        public static var ejectCode:int = ejectDefaultCode;
        
        public static var switchCameraCode:int = switchCameraDefaultCode;
        
        public function Settings()
        {
            super();
        }
        
        public static function get characterSWF() : String
        {
            return pathPrefix + characterPath + "character" + characterIndex.toString() + ".swf";
        }
        
        public static function get currentSession() : Session
        {
            return session;
        }
        
        public static function set currentSession(param1:Session) : void
        {
            session = param1;
        }
    }
}

