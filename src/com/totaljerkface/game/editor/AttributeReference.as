package com.totaljerkface.game.editor
{
    import com.totaljerkface.game.Settings;
    import com.totaljerkface.game.editor.specials.BoostRef;
    import com.totaljerkface.game.editor.specials.JetRef;
    import com.totaljerkface.game.editor.specials.NPCharacterRef;
    import com.totaljerkface.game.editor.specials.SignPostRef;
    import com.totaljerkface.game.editor.trigger.RefTrigger;
    import com.totaljerkface.game.editor.ui.*;
    import com.totaljerkface.game.sound.SoundList;
    
    public class AttributeReference
    {
        private static const poseString:String = "you can now double-click on the non-player characters to manually adjust the pose";
        
        public var name:String;
        
        public var type:String;
        
        public function AttributeReference(param1:String, param2:String)
        {
            super();
            this.name = param1;
            this.type = param2;
        }
        
        public static function buildInput(param1:String) : InputObject
        {
            var _loc2_:TextInput = null;
            var _loc3_:TextInput = null;
            var _loc4_:TextInput = null;
            var _loc5_:TextInput = null;
            var _loc6_:TextInput = null;
            var _loc7_:* = undefined;
            var _loc8_:CheckBox = null;
            var _loc9_:InputObject = null;
            var _loc10_:TextInput = null;
            var _loc11_:ColorInput = null;
            var _loc12_:ColorInput = null;
            var _loc13_:SliderInput = null;
            var _loc14_:SliderInput = null;
            var _loc15_:CheckBox = null;
            var _loc16_:CheckBox = null;
            var _loc17_:SliderInput = null;
            var _loc18_:SliderInput = null;
            var _loc19_:CheckBox = null;
            var _loc20_:TextInput = null;
            var _loc21_:SliderInput = null;
            var _loc22_:SliderInput = null;
            var _loc23_:TextInput = null;
            var _loc24_:SliderInput = null;
            var _loc25_:CheckBox = null;
            var _loc26_:SliderInput = null;
            var _loc27_:SliderInput = null;
            var _loc28_:SliderInput = null;
            var _loc29_:SliderInput = null;
            var _loc30_:SliderInput = null;
            var _loc31_:SliderInput = null;
            var _loc32_:CheckBox = null;
            var _loc33_:SliderInput = null;
            var _loc34_:SliderInput = null;
            var _loc35_:CheckBox = null;
            var _loc36_:CheckBox = null;
            var _loc37_:CheckBox = null;
            var _loc38_:SliderInput = null;
            var _loc39_:SliderInput = null;
            var _loc40_:SliderInput = null;
            var _loc41_:SliderInput = null;
            var _loc42_:SliderInput = null;
            var _loc43_:SliderInput = null;
            var _loc44_:SliderInput = null;
            var _loc45_:SliderInput = null;
            var _loc46_:SliderInput = null;
            var _loc47_:SliderInput = null;
            var _loc48_:SliderInput = null;
            var _loc49_:SliderInput = null;
            var _loc50_:SliderInput = null;
            var _loc51_:CheckBox = null;
            var _loc52_:CheckBox = null;
            var _loc53_:SliderInput = null;
            var _loc54_:CheckBox = null;
            var _loc55_:SliderInput = null;
            var _loc56_:SliderInput = null;
            var _loc57_:CheckBox = null;
            var _loc58_:CheckBox = null;
            var _loc59_:SliderInput = null;
            var _loc60_:SliderInput = null;
            var _loc61_:SliderInput = null;
            var _loc62_:SliderInput = null;
            var _loc63_:SliderInput = null;
            var _loc64_:CheckBox = null;
            var _loc65_:SliderInput = null;
            var _loc66_:CheckBox = null;
            var _loc67_:SliderInput = null;
            var _loc68_:SliderInput = null;
            var _loc69_:SliderInput = null;
            var _loc70_:SliderInput = null;
            var _loc71_:SliderInput = null;
            var _loc72_:SliderInput = null;
            var _loc73_:SliderInput = null;
            var _loc74_:SliderInput = null;
            var _loc75_:SliderInput = null;
            var _loc76_:SliderInput = null;
            var _loc77_:SliderInput = null;
            var _loc78_:SliderInput = null;
            var _loc79_:SliderInput = null;
            var _loc80_:SliderInput = null;
            var _loc81_:SliderInput = null;
            var _loc82_:SliderInput = null;
            var _loc83_:SliderInput = null;
            var _loc84_:CheckBox = null;
            var _loc85_:SliderInput = null;
            var _loc86_:CheckBox = null;
            var _loc87_:SliderInput = null;
            var _loc88_:CheckBox = null;
            var _loc89_:SliderInput = null;
            var _loc90_:SliderInput = null;
            var _loc91_:CheckBox = null;
            var _loc92_:SliderInput = null;
            var _loc93_:SliderInput = null;
            var _loc94_:ListInput = null;
            var _loc95_:SliderInput = null;
            var _loc96_:SliderInput = null;
            var _loc97_:ListInput = null;
            var _loc98_:SliderInput = null;
            var _loc99_:SliderInput = null;
            var _loc100_:SliderInput = null;
            var _loc101_:SliderInput = null;
            var _loc102_:CheckBox = null;
            var _loc103_:CheckBox = null;
            var _loc104_:SliderInput = null;
            var _loc105_:CheckBox = null;
            var _loc106_:CheckBox = null;
            var _loc107_:SliderInput = null;
            switch(param1)
            {
                case "x":
                    _loc2_ = new TextInput("x","x",7,true);
                    _loc2_.restrict = "0-9.";
                    return _loc2_;
                case "y":
                    _loc3_ = new TextInput("y","y",7,true);
                    _loc3_.restrict = "0-9.";
                    return _loc3_;
                case "shapeWidth":
                    _loc4_ = new TextInput("width","shapeWidth",7,true);
                    _loc4_.restrict = "0-9.";
                    return _loc4_;
                case "shapeHeight":
                    _loc5_ = new TextInput("height","shapeHeight",7,true);
                    _loc5_.restrict = "0-9.";
                    return _loc5_;
                case "angle":
                    _loc6_ = new TextInput("rotation","angle",5,true);
                    _loc6_.restrict = "0-9\\-";
                    return _loc6_;
                case "interactive":
                    _loc7_ = new CheckBox("interactive","interactive");
                    _loc7_.helpCaption = "Setting interactive to false will treat the shape like flat artwork.  The shape will only move if part of a group, and will not take away from the total available shapecount allowed in your level.  Useful when just adding visual detail to already interactive larger shapes or groups.";
                    return _loc7_;
                case "immovable":
                    _loc8_ = new CheckBox("fixed","immovable",false,true,true);
                    _loc8_.helpCaption = "A fixed object will never move and will support any weight.";
                    _loc8_.oppositeDependent = true;
                    _loc9_ = new CheckBox("sleeping","sleeping",false,false);
                    _loc9_.helpCaption = "A sleeping object will remain frozen in place until it is touched by any other moving object.";
                    _loc10_ = new TextInput("density","density",4,true);
                    _loc10_.restrict = "0-9.";
                    _loc8_.addChildInput(_loc9_);
                    _loc8_.addChildInput(_loc10_);
                    return _loc8_;
                case "color":
                    return new ColorInput("color","color",true,true);
                case "outlineColor":
                    return new ColorInput("outline color","outlineColor",true,true);
                case "opacity":
                    _loc13_ = new SliderInput("opacity","opacity",3,true,0,100,100);
                    _loc13_.restrict = "0-9";
                    _loc13_.helpCaption = "Transparent shapes are more cpu intensive than opaque shapes, so use transparency sparingly.  Best performance is at 100 or 0.";
                    return _loc13_;
                case "collision":
                    _loc14_ = new SliderInput("collision","collision",1,true,1,7,6);
                    _loc14_.restrict = "0-9";
                    _loc14_.helpCaption = "This value determines what the shape will collide with.<br><br>1: collides with everything.<br><br>2: collides with mostly everything but characters.<br><br>3: collides with nothing. (mostly for use with joints. If you\'d like to just use shapes as art, uncheck interactive instead)<br><br>4: collides with everything except other shapes with collision set to this value. (useful for something like a pair of attached legs that you don\'t want colliding with each other)<br><br>5: Collides only with fixed shapes.<br><br>6: Collides only with fixed shapes and other shapes with collision set to this value.<br><br>7: Collides only with characters.";
                    return _loc14_;
                case "immovable2":
                    _loc15_ = new CheckBox("fixed","immovable2",false,true,true);
                    _loc15_.oppositeDependent = true;
                    _loc15_.helpCaption = "A fixed object doesn\'t move and will support any weight.";
                    return _loc15_;
                case "immovable3":
                    _loc15_ = new CheckBox("fixed","immovable",false,true,true);
                    _loc15_.oppositeDependent = true;
                    _loc15_.helpCaption = "A fixed object doesn\'t move and will support any weight.";
                    return _loc15_;
                case "limit":
                    _loc16_ = new CheckBox("limit rotation","limit",false);
                    _loc17_ = new SliderInput("upper angle","upperAngle",3,true,0,180,180);
                    _loc17_.restrict = "0-9";
                    _loc18_ = new SliderInput("lower angle","lowerAngle",4,true,-180,0,180);
                    _loc18_.restrict = "0-9\\-";
                    _loc16_.addChildInput(_loc17_);
                    _loc16_.addChildInput(_loc18_);
                    return _loc16_;
                case "motor":
                    _loc19_ = new CheckBox("enable motor","motor",false);
                    _loc20_ = new TextInput("motor torque","torque",5,true);
                    _loc20_.restrict = "0-9";
                    _loc20_.helpCaption = "Controls the amount of force used to rotate the joint.  Very dense objects may need a lot of torque to rotate effectively with a motor.";
                    _loc21_ = new SliderInput("motor speed ","speed",5,true,-20,20,40);
                    _loc21_.helpCaption = "Controls how quickly the motor rotates the joint.  If this is a large amount and the joint is unresponsive, you may have to play around with the torque. Change the speed to negative to change the direction of movement.";
                    _loc21_.restrict = "0-9\\-.";
                    _loc19_.addChildInput(_loc20_);
                    _loc19_.addChildInput(_loc21_);
                    return _loc19_;
                case "axisAngle":
                    _loc22_ = new SliderInput("axis angle","axisAngle",4,true,-180,180,360);
                    _loc22_.helpCaption = "This is the angle (in degrees) of the axis of movement between the bodies of this joint. Relative to each other, the two bodies will be constrained to this axis.";
                    return _loc22_;
                case "limitPris":
                    _loc16_ = new CheckBox("limit range","limit",false);
                    _loc17_ = new SliderInput("upper limit","upperLimit",4,true,0,3000,300);
                    _loc17_.restrict = "0-9";
                    _loc18_ = new SliderInput("lower limit","lowerLimit",5,true,-3000,0,300);
                    _loc18_.restrict = "0-9\\-";
                    _loc16_.addChildInput(_loc17_);
                    _loc16_.addChildInput(_loc18_);
                    return _loc16_;
                case "motorPris":
                    _loc19_ = new CheckBox("enable motor","motor",false);
                    _loc23_ = new TextInput("motor force","force",5,true);
                    _loc23_.restrict = "0-9";
                    _loc23_.helpCaption = "Controls the amount of force used to power the joint.  Very dense objects may need a lot of force to move effectively with a motor.";
                    _loc24_ = new SliderInput("motor speed ","speed",5,true,-50,50,100);
                    _loc24_.helpCaption = "Controls how quickly the motor moves objects along the axis of the joint.  If this is a large amount and the joint is unresponsive, you may have to play around with the force. Change the speed to negative to change the direction of movement.";
                    _loc24_.restrict = "0-9\\-.";
                    _loc19_.addChildInput(_loc23_);
                    _loc19_.addChildInput(_loc24_);
                    return _loc19_;
                case "collideSelf":
                    _loc25_ = new CheckBox("collide connected","collideSelf",false);
                    _loc25_.helpCaption = "Select this if you\'d like the two objects connected by this joint to collide with each other. Do not use this if you\'d like the objects to overlap.";
                    return _loc25_;
                case "ropeLength":
                    _loc26_ = new SliderInput("rope length","ropeLength",4,true,200,1000,80);
                    _loc26_.restrict = "0-9";
                    return _loc26_;
                case "ballSpeed":
                    _loc27_ = new SliderInput("ball speed","ballSpeed",1,true,0,7,7);
                    _loc27_.restrict = "0-9";
                    return _loc27_;
                case "springDelay":
                    _loc28_ = new SliderInput("delay","springDelay",1,true,0,2,4);
                    _loc28_.restrict = "0-9";
                    return _loc28_;
                case "numSpikes":
                    _loc29_ = new SliderInput("spikes","numSpikes",3,true,20,150,130);
                    _loc29_.restrict = "0-9";
                    return _loc29_;
                case "numPanels":
                    _loc30_ = new SliderInput("panels","numPanels",1,true,1,6,5);
                    _loc30_.restrict = "0-9";
                    return _loc30_;
                case "characterIndex":
                    _loc31_ = new SliderInput("default character","characterIndex",1,true,1,Settings.totalCharacters,Settings.totalCharacters - 1);
                    _loc31_.restrict = "0-9";
                    return _loc31_;
                case "forceChar":
                    _loc32_ = new CheckBox("force character","forceChar",false);
                    _loc32_.helpCaption = "If enabled, the user must play this level with the current character.";
                    return _loc32_;
                case "numFloors":
                    _loc33_ = new SliderInput("floors","numFloors",2,true,3,50,47);
                    _loc33_.restrict = "0-9";
                    return _loc33_;
                case "floorWidth":
                    _loc34_ = new SliderInput("floor width","floorWidth",2,true,1,10,9);
                    _loc34_.restrict = "0-9";
                    return _loc34_;
                case "sleeping":
                    _loc35_ = new CheckBox("sleeping","sleeping",false);
                    _loc35_.helpCaption = "A sleeping object will remain frozen in place until it is touched by any other moving object.";
                    return _loc35_;
                case "useAnchor":
                    return new CheckBox("anchor","useAnchor");
                case "foreground":
                    _loc37_ = new CheckBox("foreground","foreground",false);
                    _loc37_.helpCaption = "When checked, this item will overlap in front of the player character during gameplay";
                    return _loc37_;
                case "font":
                    return new SliderInput("font","font",1,true,1,5,4);
                case "fontSize":
                    return new SliderInput("font size","fontSize",3,true,10,100,90);
                case "align":
                    return new SliderInput("alignment","align",1,true,1,3,2);
                case "charIndex":
                    return new SliderInput("character type","charIndex",1,true,1,NPCharacterRef.NUM_CHARACTERS,NPCharacterRef.NUM_CHARACTERS - 1);
                case "neckAngle":
                    _loc42_ = new SliderInput("neck angle","neckAngle",4,true,-20,20,40);
                    _loc42_.helpCaption = poseString;
                    return _loc42_;
                case "shoulder1Angle":
                    _loc43_ = new SliderInput("arm 1 angle","shoulder1Angle",4,true,-180,60,240);
                    _loc43_.helpCaption = poseString;
                    return _loc43_;
                case "shoulder2Angle":
                    _loc44_ = new SliderInput("arm 2 angle","shoulder2Angle",4,true,-180,60,240);
                    _loc44_.helpCaption = poseString;
                    return _loc44_;
                case "elbow1Angle":
                    _loc45_ = new SliderInput("elbow 1 angle","elbow1Angle",4,true,-160,0,160);
                    _loc45_.helpCaption = poseString;
                    return _loc45_;
                case "elbow2Angle":
                    _loc46_ = new SliderInput("elbow 2 angle","elbow2Angle",4,true,-160,0,160);
                    _loc46_.helpCaption = poseString;
                    return _loc46_;
                case "hip1Angle":
                    _loc47_ = new SliderInput("leg 1 angle","hip1Angle",4,true,-150,10,160);
                    _loc47_.helpCaption = poseString;
                    return _loc47_;
                case "hip2Angle":
                    _loc48_ = new SliderInput("leg 2 angle","hip2Angle",4,true,-150,10,160);
                    _loc48_.helpCaption = poseString;
                    return _loc48_;
                case "knee1Angle":
                    _loc49_ = new SliderInput("knee 1 angle","knee1Angle",4,true,0,150,150);
                    _loc49_.helpCaption = poseString;
                    return _loc49_;
                case "knee2Angle":
                    _loc50_ = new SliderInput("knee 2 angle","knee2Angle",4,true,0,150,150);
                    _loc50_.helpCaption = poseString;
                    return _loc50_;
                case "reverse":
                    return new CheckBox("reverse","reverse");
                case "holdPose":
                    return new CheckBox("hold pose","holdPose");
                case "shatterStrength":
                    _loc53_ = new SliderInput("strength","shatterStrength",2,true,1,10,9);
                    _loc53_.helpCaption = "Determines how much force is required to shatter the initial glass pane.";
                    return _loc53_;
                case "stabbing":
                    _loc54_ = new CheckBox("stabbing","stabbing");
                    _loc54_.helpCaption = "Determines if broken glass can stab the character.";
                    return _loc54_;
                case "bottleType":
                    return new SliderInput("bottle type","bottleType",1,true,1,4,3);
                case "signPostType":
                    return new SliderInput("sign type","signPostType",1,true,1,SignPostRef.TOTAL_SIGN_TYPES,SignPostRef.TOTAL_SIGN_TYPES - 1);
                case "signPost":
                    return new CheckBox("show sign post","signPost");
                case "containsTrash":
                    return new CheckBox("contains trash","containsTrash");
                case "seekSpeed":
                    _loc59_ = new SliderInput("speed","seekSpeed",1,true,1,10,9);
                    _loc59_.restrict = "0-9";
                    return _loc59_;
                case "explosionDelay":
                    _loc60_ = new SliderInput("delay","explosionDelay",1,true,0,5,5);
                    _loc60_.restrict = "0-9";
                    return _loc60_;
                case "power":
                    _loc61_ = new SliderInput("power","power",2,true,JetRef.MIN_POWER,JetRef.MAX_POWER,JetRef.MAX_POWER - 1);
                    _loc61_.restrict = "0-9";
                    return _loc61_;
                case "fireTime":
                    _loc62_ = new SliderInput("firing time","fireTime",1,true,JetRef.MIN_FIRE_TIME,JetRef.MAX_FIRE_TIME,JetRef.MAX_FIRE_TIME - JetRef.MIN_FIRE_TIME);
                    _loc62_.restrict = "0-9";
                    _loc62_.helpCaption = "The amount of time (in seconds) until the jet shuts off. With a setting of 0, the jet will not shut off.";
                    return _loc62_;
                case "accelTime":
                    _loc63_ = new SliderInput("acceleration time","accelTime",1,true,JetRef.MIN_ACCEL_TIME,JetRef.MAX_ACCEL_TIME,JetRef.MAX_ACCEL_TIME - JetRef.MIN_ACCEL_TIME);
                    _loc63_.restrict = "0-9";
                    _loc63_.helpCaption = "The amount of time (in seconds) until the jet reaches full power";
                    return _loc63_;
                case "fixedRotation":
                    _loc64_ = new CheckBox("fixed angle","fixedRotation",false,true);
                    _loc64_.helpCaption = "Checking this will prevent the object from rotating";
                    return _loc64_;
                case "rateOfFire":
                    _loc65_ = new SliderInput("rate of fire","rateOfFire",2,true,1,10,9);
                    _loc65_.restrict = "0-9";
                    return _loc65_;
                case "dontShootPlayer":
                    _loc66_ = new CheckBox("don\'t shoot player","dontShootPlayer",false,true);
                    _loc66_.helpCaption = "Uncheck this if you only want the gun to target non-player characters";
                    return _loc66_;
                case "linkCount":
                    return new SliderInput("link count","linkCount",3,true,2,40,19);
                case "linkScale":
                    return new SliderInput("link scale","linkScale",1,true,1,10,9);
                case "linkAngle":
                    return new SliderInput("chain curve","linkAngle",3,true,-10,10,40);
                case "tokenType":
                    return new SliderInput("token type","tokenType",1,true,1,6,5);
                case "foodItemType":
                    return new SliderInput("food type","foodItemType",1,true,1,3,2);
                case "startRotation":
                    _loc72_ = new SliderInput("start rotation","startRotation",2,true,-90,90,180);
                    _loc72_.helpCaption = "The angle the muzzle rests at until objects fall into it.";
                    return _loc72_;
                case "firingRotation":
                    _loc73_ = new SliderInput("firing rotation","firingRotation",2,true,-90,90,180);
                    _loc73_.helpCaption = "The angle the muzzle moves to and fires.";
                    return _loc73_;
                case "muzzleScale":
                    return new SliderInput("muzzle scale","muzzleScale",2,true,1,10,9);
                case "cannonPower":
                    return new SliderInput("power","cannonPower",2,true,1,10,9);
                case "cannonDelay":
                    _loc76_ = new SliderInput("delay","cannonDelay",1,true,1,10,9);
                    _loc76_.helpCaption = "The amount of time in seconds before the cannon moves to the firing position.";
                    return _loc76_;
                case "cannonType":
                    return new SliderInput("type","cannonType",1,true,1,2,1);
                case "bladeWeaponType":
                    return new SliderInput("type","bladeWeaponType",2,true,1,12,11);
                case "spaceAction":
                    _loc79_ = new SliderInput("spacebar action","spaceAction",1,true,0,RefVehicle.NUM_ACTIONS,RefVehicle.NUM_ACTIONS);
                    _loc79_.helpCaption = "This value determines what happens when spacebar is pressed.<br><br>0: Nothing!<br><br>1: All attached joints will brake (motors set to 0).<br><br>2: Any jets attached to the vehicle with joints will fire.<br><br>3: Any arrowguns attached to the vehicle with joints will shoot";
                    return _loc79_;
                case "shiftAction":
                    _loc80_ = new SliderInput("shift action","shiftAction",1,true,0,RefVehicle.NUM_ACTIONS,RefVehicle.NUM_ACTIONS);
                    _loc80_.helpCaption = "This value determines what happens when SHIFT is pressed.<br><br>0: Nothing!<br><br>1: All attached joints will brake (motors set to 0).<br><br>2: Any jets attached to the vehicle with joints will fire.<br><br>3: Any arrowguns attached to the vehicle with joints will shoot";
                    return _loc80_;
                case "ctrlAction":
                    _loc81_ = new SliderInput("ctrl action","ctrlAction",1,true,0,RefVehicle.NUM_ACTIONS,RefVehicle.NUM_ACTIONS);
                    _loc81_.helpCaption = "This value determines what happens when CTRL is pressed.<br><br>0: Nothing!<br><br>1: All attached joints will brake (motors set to 0).<br><br>2: Any jets attached to the vehicle with joints will fire.<br><br>3: Any arrowguns attached to the vehicle with joints will shoot";
                    return _loc81_;
                case "acceleration":
                    _loc82_ = new SliderInput("acceleration","acceleration",2,true,1,10,9);
                    _loc82_.helpCaption = "Determines how quickly attached joints reach their set motor speed when pressing up or down. Low torque can prevent a motor from reaching its top speed.";
                    return _loc82_;
                case "leaningStrength":
                    _loc83_ = new SliderInput("leaning strength","leaningStrength",1,true,0,10,10);
                    _loc83_.helpCaption = "Determines how much force is used when leaning using left and right. Set to zero to disable leaning.";
                    return _loc83_;
                case "vehicleControlled":
                    _loc84_ = new CheckBox("vehicle controlled","vehicleControlled",true,true);
                    _loc84_.helpCaption = "Uncheck this is you don\'t want this joint to be controlled by the vehicle. It will function like a normal joint.";
                    return _loc84_;
                case "characterPose":
                    _loc85_ = new SliderInput("grabbing pose","characterPose",1,true,0,RefVehicle.NUM_POSES,RefVehicle.NUM_POSES);
                    _loc85_.helpCaption = "This value determines what pose the character will take after grabbing a vehicle handle.<br><br>0: limp limbs<br><br>1: arms forward<br><br>2: arms overhead<br><br>3: the character will hold whatever pose he had when grabbing";
                    return _loc85_;
                case "lockJoints":
                    _loc86_ = new CheckBox("lock joints","lockJoints",false);
                    _loc86_.helpCaption = "Check this if you\'d like all attached joints with motors to slow their speed to 0 when not accelerating or decelerating (by default, joints will hang loose). Joints will slow at the acceleration rate you\'ve specified.";
                    return _loc86_;
                case "innerCutout":
                    return new SliderInput("inner cutout","innerCutout",3,true,0,100,100);
                case "destroyJointsUponDeath":
                    _loc88_ = new CheckBox("release on death","destroyJointsUponDeath",false,true);
                    _loc88_.helpCaption = "Check this if you\'d like all attached joints and associated trigger actions to be detroyed when the character dies. This is especially good for characters with walk cycles.";
                    return _loc88_;
                case "paddleAngle":
                    return new SliderInput("max angle","paddleAngle",2,true,15,90,75);
                case "paddleSpeed":
                    return new SliderInput("speed","paddleSpeed",2,true,1,10,9);
                case "hideVehicle":
                    _loc91_ = new CheckBox("hide vehicle","hideVehicle",true);
                    _loc91_.helpCaption = "Check this if you don\'t want to include the character\'s vehicle in your level. This is good for getting the character into a custom vehicle, rope levels, etc.";
                    return _loc91_;
                case "triggeredBy":
                    _loc92_ = new SliderInput("triggered by","triggeredBy",1,true,1,6,5);
                    _loc92_.restrict = "0-9";
                    _loc92_.helpCaption = "Set this to determine what will activate the trigger upon contact. In addition to these options, triggers can now also be triggered by other triggers.<br><br>1. Triggered by only the main character.<br><br>2. Triggered by any character, including NCPs.<br><br>3. Triggered by any non-fixed shape.<br><br>4. Triggered by only the targets attached to this trigger.<br><br>5. Triggered only by other triggers<br><br>6. Triggered by left-clicking the trigger shape with your mouse";
                    return _loc92_;
                case "triggerDelay":
                    _loc93_ = new SliderInput("delay","triggerDelay",4,true,0,30,60);
                    _loc93_.restrict = "0-9.";
                    return _loc93_;
                case "soundEffect":
                    return new ListInput("sound effect","soundEffect",SoundList.instance.sfxArray,true,true);
                case "panning":
                    return new SliderInput("panning","panning",4,true,-1,1,20);
                case "volume":
                    return new SliderInput("volume","volume",3,true,0,1,10);
                case "triggerType":
                    return new ListInput("action","triggerType",RefTrigger.typeArray,false,true);
                case "wheelType":
                    return new SliderInput("wheel type","wheelType",2,true,1,10,9);
                case "repeatType":
                    _loc99_ = new SliderInput("repeat type","repeatType",1,true,1,4,3);
                    _loc99_.restrict = "0-9";
                    _loc99_.helpCaption = "This determines the repeating behavior of the trigger.<br><br>1. Trigger action only occurs once, then trigger is deleted.<br><br>2. Trigger action occurs upon contact with the trigger. It will occur again with new contact after the trigger area is clear of the original triggering body.<br><br>3. Trigger action will occur on a repeated interval until the triggering body leaves the trigger area.<br><br>4. Trigger action will occur on a repeated interval once activated until disabled by other triggers.";
                    return _loc99_;
                case "repeatInterval":
                    _loc100_ = new SliderInput("repeat interval","repeatInterval",4,true,0,30,60);
                    _loc100_.restrict = "0-9.";
                    _loc100_.helpCaption = "This is the number of seconds between trigger activations when repeat type is set to 3 or 4.";
                    return _loc100_;
                case "soundLocation":
                    _loc101_ = new SliderInput("sound location","soundLocation",1,true,1,2,1);
                    _loc101_.restrict = "0-9";
                    _loc101_.helpCaption = "This determines the apparent location of the sound.<br><br>1. Global. The sound effect will sound the same no matter when or where it is activated. Volume and panning are determined by the user.<br><br>2. Location specific. The sound effect will play as if it is coming from the location of its trigger. Sounds will diminish and pan left and right depending on the player\'s location relative to the trigger. Volume will determine the max volume of the sound.";
                    return _loc101_;
                case "startDisabled":
                    _loc102_ = new CheckBox("start disabled","startDisabled",false,true);
                    _loc102_.helpCaption = "If checked, this trigger will not function until enabled by another trigger.";
                    return _loc102_;
                case "fixedAngleTurret":
                    _loc103_ = new CheckBox("fixed turret","fixedAngleTurret",false,true);
                    _loc103_.helpCaption = "If checked, the turret of the gun will only aim at the specified turret angle.";
                    return _loc103_;
                case "turretAngle":
                    _loc104_ = new SliderInput("turret angle","turretAngle",4,true,-110,110,220);
                    _loc104_.restrict = "0-9\\-";
                    return _loc104_;
                case "triggerFiring":
                    _loc105_ = new CheckBox("trigger firing","triggerFiring",false,true);
                    _loc105_.helpCaption = "If checked, the turret of the gun will only fire when signaled by a trigger.";
                    return _loc105_;
                case "startDeactivated":
                    _loc106_ = new CheckBox("start deactivated","startDeactivated",false,true);
                    _loc106_.helpCaption = "If checked, the object will be deactivated until activated by a trigger.";
                    return _loc106_;
                case "boostPower":
                    _loc107_ = new SliderInput("boost power","boostPower",3,true,BoostRef.MIN_POWER,BoostRef.MAX_POWER,BoostRef.MAX_POWER - BoostRef.MIN_POWER);
                    _loc107_.restrict = "0-9";
                    return _loc107_;
                default:
                    return null;
            }
        }
        
        public static function buildKeyedInput(param1:String, param2:Object, param3:int, param4:RefSprite) : InputObject
        {
            var _loc7_:int = 0;
            var _loc8_:ListInput = null;
            var _loc9_:SliderInput = null;
            var _loc10_:SliderInput = null;
            var _loc11_:SliderInput = null;
            var _loc12_:SliderInput = null;
            var _loc13_:SliderInput = null;
            var _loc14_:SliderInput = null;
            var _loc15_:TextInput = null;
            var _loc16_:TextInput = null;
            var _loc17_:SliderInput = null;
            var _loc18_:SliderInput = null;
            var _loc19_:SliderInput = null;
            var _loc20_:SliderInput = null;
            var _loc21_:SliderInput = null;
            var _loc5_:RefTrigger = param2 as RefTrigger;
            var _loc6_:int = _loc5_.parent.getChildIndex(_loc5_);
            _loc7_ = _loc6_ + 1;
            switch(param1)
            {
                case "triggerActionsShape":
                    _loc8_ = new ListInput("trigger " + _loc7_ + " action " + (param3 + 1),"triggerActionsShape",param4.triggerActionList,false,true,true);
                    _loc8_.multipleKey = param2;
                    _loc8_.multipleIndex = param3;
                    _loc8_.defaultValue = param4.triggerActionList[0];
                    return _loc8_;
                case "triggerActionsSpecial":
                    _loc8_ = new ListInput("trigger " + _loc7_ + " action " + (param3 + 1),"triggerActionsSpecial",param4.triggerActionList,false,true,true);
                    _loc8_.multipleKey = param2;
                    _loc8_.multipleIndex = param3;
                    _loc8_.defaultValue = param4.triggerActionList[0];
                    return _loc8_;
                case "triggerActionsGroup":
                    _loc8_ = new ListInput("trigger " + _loc7_ + " action " + (param3 + 1),"triggerActionsGroup",param4.triggerActionList,false,true,true);
                    _loc8_.multipleKey = param2;
                    _loc8_.multipleIndex = param3;
                    _loc8_.defaultValue = param4.triggerActionList[0];
                    return _loc8_;
                case "triggerActionsPinJoint":
                    _loc8_ = new ListInput("trigger " + _loc7_ + " action" + (param3 + 1),"triggerActionsPinJoint",param4.triggerActionList,false,true,true);
                    _loc8_.multipleKey = param2;
                    _loc8_.multipleIndex = param3;
                    _loc8_.defaultValue = param4.triggerActionList[0];
                    return _loc8_;
                case "triggerActionsPrisJoint":
                    _loc8_ = new ListInput("trigger " + _loc7_ + " action" + (param3 + 1),"triggerActionsPrisJoint",param4.triggerActionList,false,true,true);
                    _loc8_.multipleKey = param2;
                    _loc8_.multipleIndex = param3;
                    _loc8_.defaultValue = param4.triggerActionList[0];
                    return _loc8_;
                case "triggerActionsGlass":
                    _loc8_ = new ListInput("trigger " + _loc7_ + " action" + (param3 + 1),"triggerActionsGlass",param4.triggerActionList,false,true);
                    _loc8_.multipleKey = param2;
                    _loc8_.multipleIndex = param3;
                    _loc8_.defaultValue = param4.triggerActionList[0];
                    return _loc8_;
                case "triggerActionsText":
                    _loc8_ = new ListInput("trigger " + _loc7_ + " action " + (param3 + 1),"triggerActionsText",param4.triggerActionList,false,true,true);
                    _loc8_.multipleKey = param2;
                    _loc8_.multipleIndex = param3;
                    _loc8_.defaultValue = param4.triggerActionList[0];
                    return _loc8_;
                case "triggerActionsNPC":
                    _loc8_ = new ListInput("trigger " + _loc7_ + " action " + (param3 + 1),"triggerActionsNPC",param4.triggerActionList,false,true,true);
                    _loc8_.multipleKey = param2;
                    _loc8_.multipleIndex = param3;
                    _loc8_.defaultValue = param4.triggerActionList[0];
                    return _loc8_;
                case "triggerActionsHarpoon":
                    _loc8_ = new ListInput("trigger " + _loc7_ + " action " + (param3 + 1),"triggerActionsHarpoon",param4.triggerActionList,false,true,true);
                    _loc8_.multipleKey = param2;
                    _loc8_.multipleIndex = param3;
                    _loc8_.defaultValue = param4.triggerActionList[0];
                    return _loc8_;
                case "triggerActionsTrigger":
                    _loc8_ = new ListInput("trigger " + _loc7_ + " action","triggerActionsTrigger",param4.triggerActionList,false,true);
                    _loc8_.multipleKey = param2;
                    _loc8_.defaultValue = param4.triggerActionList[0];
                    return _loc8_;
                case "newOpacities":
                    _loc9_ = new SliderInput("new opacity " + _loc7_,"newOpacities",3,true,0,100,100);
                    _loc9_.restrict = "0-9";
                    _loc9_.multipleKey = param2;
                    _loc9_.multipleIndex = param3;
                    _loc9_.defaultValue = 100;
                    return _loc9_;
                case "opacityTimes":
                    _loc10_ = new SliderInput("duration " + _loc7_,"opacityTimes",1,true,0,5,50);
                    _loc10_.restrict = "0-9";
                    _loc10_.multipleKey = param2;
                    _loc10_.multipleIndex = param3;
                    _loc10_.defaultValue = 1;
                    return _loc10_;
                case "impulseX":
                    _loc11_ = new SliderInput("impulse x " + _loc7_,"impulseX",4,true,-50,50,100);
                    _loc11_.restrict = "0-9\\-";
                    _loc11_.multipleKey = param2;
                    _loc11_.multipleIndex = param3;
                    _loc11_.defaultValue = 10;
                    return _loc11_;
                case "impulseY":
                    _loc12_ = new SliderInput("impulse y " + _loc7_,"impulseY",4,true,-50,50,100);
                    _loc12_.restrict = "0-9\\-";
                    _loc12_.multipleKey = param2;
                    _loc12_.multipleIndex = param3;
                    _loc12_.defaultValue = -10;
                    return _loc12_;
                case "spin":
                    _loc13_ = new SliderInput("spin " + _loc7_,"spin",2,true,-20,20,40);
                    _loc13_.restrict = "0-9\\-";
                    _loc13_.multipleKey = param2;
                    _loc13_.multipleIndex = param3;
                    _loc13_.defaultValue = 0;
                    return _loc13_;
                case "slideTimes":
                    _loc14_ = new SliderInput("duration " + _loc7_,"slideTimes",2,true,0,10,100);
                    _loc14_.restrict = "0-9";
                    _loc14_.multipleKey = param2;
                    _loc14_.multipleIndex = param3;
                    _loc14_.defaultValue = 1;
                    return _loc14_;
                case "newX":
                    _loc15_ = new TextInput("new x " + _loc7_,"newX",7,true);
                    _loc15_.restrict = "0-9.";
                    _loc15_.multipleKey = param2;
                    _loc15_.multipleIndex = param3;
                    _loc15_.defaultValue = param4.x;
                    return _loc15_;
                case "newY":
                    _loc16_ = new TextInput("new y " + _loc7_,"newY",7,true);
                    _loc16_.restrict = "0-9.";
                    _loc16_.multipleKey = param2;
                    _loc16_.multipleIndex = param3;
                    _loc16_.defaultValue = param4.y;
                    return _loc16_;
                case "newMotorSpeeds":
                    _loc17_ = new SliderInput("new speed " + _loc7_,"newMotorSpeeds",5,true,-20,20,40);
                    _loc17_.restrict = "0-9\\-.";
                    _loc17_.multipleKey = param2;
                    _loc17_.multipleIndex = param3;
                    _loc17_.defaultValue = 0;
                    return _loc17_;
                case "motorSpeedTimes":
                    _loc18_ = new SliderInput("duration " + _loc7_,"motorSpeedTimes",1,true,0,5,50);
                    _loc18_.restrict = "0-9";
                    _loc18_.multipleKey = param2;
                    _loc18_.multipleIndex = param3;
                    _loc18_.defaultValue = 1;
                    _loc18_.helpCaption = "the time (in seconds) it takes for the motor to reach the new speed";
                    return _loc18_;
                case "newMotorSpeedsPris":
                    _loc17_ = new SliderInput("new speed " + _loc7_,"newMotorSpeedsPris",5,true,-50,50,100);
                    _loc17_.restrict = "0-9\\-.";
                    _loc17_.multipleKey = param2;
                    _loc17_.multipleIndex = param3;
                    _loc17_.defaultValue = 0;
                    return _loc17_;
                case "newUpperLimits":
                    _loc19_ = new SliderInput("new upper limit " + _loc7_,"newUpperLimits",4,true,0,3000,300);
                    _loc19_.restrict = "0-9";
                    _loc19_.multipleKey = param2;
                    _loc19_.multipleIndex = param3;
                    _loc19_.defaultValue = 100;
                    return _loc19_;
                case "newLowerLimits":
                    _loc20_ = new SliderInput("new lower limit " + _loc7_,"newLowerLimits",5,true,-3000,0,300);
                    _loc20_.restrict = "0-9\\-";
                    _loc20_.multipleKey = param2;
                    _loc20_.multipleIndex = param3;
                    _loc20_.defaultValue = -100;
                    return _loc20_;
                case "newUpperAngles":
                    _loc19_ = new SliderInput("new upper angle " + _loc7_,"newUpperAngles",3,true,0,180,180);
                    _loc19_.restrict = "0-9";
                    _loc19_.multipleKey = param2;
                    _loc19_.multipleIndex = param3;
                    _loc19_.defaultValue = 90;
                    return _loc19_;
                case "newLowerAngles":
                    _loc20_ = new SliderInput("new lower angle " + _loc7_,"newLowerAngles",4,true,-180,0,180);
                    _loc20_.restrict = "0-9\\-";
                    _loc20_.multipleKey = param2;
                    _loc20_.multipleIndex = param3;
                    _loc20_.defaultValue = -90;
                    return _loc20_;
                case "newCollisions":
                    _loc21_ = new SliderInput("new collision " + _loc7_,"newCollisions",1,true,1,7,6);
                    _loc21_.restrict = "0-9";
                    _loc21_.multipleKey = param2;
                    _loc21_.multipleIndex = param3;
                    _loc21_.defaultValue = 1;
                    _loc21_.helpCaption = "This value determines what the shape will collide with.<br><br>1: collides with everything.<br><br>2: collides with mostly everything but characters.<br><br>3: collides with nothing. (mostly for use with joints. If you\'d like to just use shapes as art, uncheck interactive instead)<br><br>4: collides with everything except other shapes with collision set to this value. (useful for something like a pair of attached legs that you don\'t want colliding with each other)<br><br>5: Collides only with fixed shapes.<br><br>6: Collides only with fixed shapes and other shapes with collision set to this value.<br><br>7: Collides only with characters.";
                    return _loc21_;
                default:
                    return null;
            }
        }
        
        public static function getDefaultValue(param1:String) : *
        {
            switch(param1)
            {
                case "newOpacities":
                    return 100;
                case "opacityTimes":
                    return 1;
                case "impulseX":
                    return 10;
                case "impulseY":
                    return -10;
                case "spin":
                    return 0;
                case "slideTimes":
                    return 1;
                case "newX":
                    return 0;
                case "newY":
                    return 0;
                case "newMotorSpeeds":
                    return 0;
                case "motorSpeedTimes":
                    return 1;
                case "newCollisions":
                    return 1;
                default:
                    return 0;
            }
        }
    }
}

