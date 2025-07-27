package com.kumokairo.mousewheel
{
    import flash.display.Stage;
    import flash.errors.IllegalOperationError;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.external.ExternalInterface;
    import flash.system.Capabilities;
    
    public class BlastedMouseWheelBlock
    {
        private static var externalJavascriptFunction:String;
        
        private static var nativeStage:Stage;
        
        private static var isMac:Boolean;
        
        private static const NEW_OBJECT_ERROR:String = "You don\'t have to create an instance of this class. Call BlastedMouseWheelBlock.initialize(..) instead";
        
        private static const NO_EXTERNAL_INTERFACE_ERROR:String = "No External Interface available. Please, disable BlastedMouseWheelBlock";
        
        private static const EXTERNAL_ALLOW_BROWSER_SCROLL_FUNCTION:String = "allowBrowserScroll";
        
        private static const EXTERNAL_JAVASCRIPT_FUNCTION_P1:String = "var browserScrollAllow=true;var isMac=false;function registerEventListeners(inputIsMac){if(window.addEventListener){window.addEventListener(\'mousewheel\',wheelHandler,true);window.addEventListener(\'DOMMouseScroll\',wheelHandler,true);window.addEventListener(\'scroll\',wheelHandler,true);isMac=inputIsMac}window.onmousewheel=wheelHandler;document.onmousewheel=wheelHandler}function wheelHandler(event){var delta=deltaFilter(event);if(delta==undefined){delta=event.detail}if(!event){event=window.event}if(!browserScrollAllow){if(window.chrome||isMac){document.getElementById(\'";
        
        private static const EXTERNAL_JAVASCRIPT_FUNCTION_P2:String = "\').scrollHappened(delta)}if(event.preventDefault){event.preventDefault()}else{event.returnValue=false}}}function allowBrowserScroll(allow){browserScrollAllow=allow}function deltaFilter(event){var delta=0;if(event.wheelDelta){delta=event.wheelDelta/40;if(window.opera)delta=-delta}else if(event.detail){delta=-event.detail}return delta}";
        
        public function BlastedMouseWheelBlock()
        {
            super();
            throw new IllegalOperationError(NEW_OBJECT_ERROR);
        }
        
        public static function initialize(param1:Stage, param2:String = "flashObject") : void
        {
            if(ExternalInterface.available)
            {
                isMac = Capabilities.os.toLowerCase().indexOf("mac") != -1;
                externalJavascriptFunction = EXTERNAL_JAVASCRIPT_FUNCTION_P1 + param2 + EXTERNAL_JAVASCRIPT_FUNCTION_P2;
                BlastedMouseWheelBlock.nativeStage = param1;
                param1.addEventListener(MouseEvent.MOUSE_MOVE,mouseOverStage);
                param1.addEventListener(Event.MOUSE_LEAVE,mouseLeavesStage);
                param1.addEventListener(MouseEvent.MOUSE_WHEEL,onMouseWheel);
                ExternalInterface.call("eval",externalJavascriptFunction);
                ExternalInterface.addCallback("scrollHappened",scrollHappened);
                ExternalInterface.call("registerEventListeners",isMac);
                return;
            }
            throw new UninitializedError(NO_EXTERNAL_INTERFACE_ERROR);
        }
        
        private static function onMouseWheel(param1:MouseEvent) : void
        {
        }
        
        private static function scrollHappened(param1:Number) : void
        {
            nativeStage.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_WHEEL,true,false,nativeStage.mouseX,nativeStage.mouseY,null,false,false,false,false,param1));
        }
        
        private static function mouseOverStage(param1:MouseEvent) : void
        {
            if(nativeStage.hasEventListener(MouseEvent.MOUSE_MOVE))
            {
                nativeStage.removeEventListener(MouseEvent.MOUSE_MOVE,mouseOverStage);
            }
            nativeStage.addEventListener(Event.MOUSE_LEAVE,mouseLeavesStage);
            ExternalInterface.call(EXTERNAL_ALLOW_BROWSER_SCROLL_FUNCTION,false);
        }
        
        private static function mouseLeavesStage(param1:Event) : void
        {
            if(nativeStage.hasEventListener(Event.MOUSE_LEAVE))
            {
                nativeStage.removeEventListener(Event.MOUSE_LEAVE,mouseLeavesStage);
            }
            nativeStage.addEventListener(MouseEvent.MOUSE_MOVE,mouseOverStage);
            ExternalInterface.call(EXTERNAL_ALLOW_BROWSER_SCROLL_FUNCTION,true);
        }
    }
}

