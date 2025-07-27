package com.totaljerkface.game
{
    import flash.display.DisplayObject;
    import flash.display.Loader;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.events.ProgressEvent;
    import flash.net.URLLoader;
    import flash.net.URLLoaderDataFormat;
    import flash.net.URLRequest;
    import flash.system.ApplicationDomain;
    import flash.system.LoaderContext;
    import flash.text.TextField;
    import flash.utils.ByteArray;

    [Embed(source="/_assets/assets.swf", symbol="symbol369")]
    public class SoundLoader extends Sprite
    {
        public var loadText:TextField;

        private var urlLoader:URLLoader;

        private var loader:Loader;

        private var domain:ApplicationDomain;

        private var context:LoaderContext;

        private var _content:DisplayObject;

        public function SoundLoader()
        {
            super();
        }

        public function loadSound(param1:String):void
        {
            var _loc2_:URLRequest = new URLRequest(Settings.pathPrefix + "happy_sounds_v1_72.swf");
            this.urlLoader = new URLLoader();
            this.urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
            this.urlLoader.addEventListener(Event.COMPLETE, this.bytesComplete, false, 0, true);
            this.urlLoader.addEventListener(IOErrorEvent.IO_ERROR, this.IOErrorHandler, false, 0, true);
            this.urlLoader.addEventListener(ProgressEvent.PROGRESS, this.loadProgress, false, 0, true);
            this.urlLoader.load(_loc2_);
        }

        private function bytesComplete(param1:Event):void
        {
            this.urlLoader.removeEventListener(Event.COMPLETE, this.bytesComplete);
            this.urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, this.IOErrorHandler);
            this.urlLoader.removeEventListener(ProgressEvent.PROGRESS, this.loadProgress);
            var _loc2_:ByteArray = this.urlLoader.data;
            this.loader = new Loader();
            this.loader.contentLoaderInfo.addEventListener(Event.COMPLETE, this.loadComplete);
            var _loc3_:ApplicationDomain = ApplicationDomain.currentDomain;
            var _loc4_:LoaderContext = new LoaderContext(false, _loc3_);
            this.loader.loadBytes(_loc2_, _loc4_);
        }

        private function loadProgress(param1:ProgressEvent):void
        {
            var _loc2_:Number = Math.round(param1.bytesLoaded / param1.bytesTotal * 100);
            this.loadText.text = "loading sounds ... " + _loc2_ + " %";
        }

        private function loadComplete(param1:Event):void
        {
            this.loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, this.loadProgress);
            this.loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, this.loadComplete);
            this.loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, this.IOErrorHandler);
            dispatchEvent(new Event(Event.COMPLETE));
        }

        internal function IOErrorHandler(param1:IOErrorEvent):void
        {
            trace(param1.text);
        }

        public function unLoadSwf():void
        {
            this.loader.unloadAndStop();
        }
    }
}
