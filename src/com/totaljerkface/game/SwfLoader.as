package com.totaljerkface.game
{
    import flash.display.DisplayObject;
    import flash.display.Loader;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.events.IOErrorEvent;
    import flash.events.ProgressEvent;
    import flash.net.URLRequest;
    import flash.system.ApplicationDomain;
    import flash.system.LoaderContext;
    
    public class SwfLoader extends EventDispatcher
    {
        internal var swf:String;
        
        internal var loader:Loader;
        
        private var domain:ApplicationDomain;
        
        private var context:LoaderContext;
        
        private var _content:DisplayObject;
        
        public function SwfLoader(param1:String)
        {
            super();
            this.swf = param1;
        }
        
        public function loadSWF() : void
        {
            this.loader = new Loader();
            var _loc1_:URLRequest = new URLRequest(this.swf);
            trace("LoadSWF " + _loc1_.url);
            this.loader.load(_loc1_);
            this.loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,this.loadProgress,false,0,true);
            this.loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.loadComplete,false,0,true);
            this.loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.IOErrorHandler,false,0,true);
        }
        
        internal function loadProgress(param1:ProgressEvent) : void
        {
        }
        
        internal function loadComplete(param1:Event) : void
        {
            this.loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS,this.loadProgress);
            this.loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.loadComplete);
            this.loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.IOErrorHandler);
            dispatchEvent(new Event(Event.COMPLETE));
        }
        
        internal function IOErrorHandler(param1:IOErrorEvent) : void
        {
            trace("SwfLoader: " + param1.text);
            this.loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS,this.loadProgress);
            this.loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.loadComplete);
            this.loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.IOErrorHandler);
            dispatchEvent(new Event(IOErrorEvent.IO_ERROR));
        }
        
        public function get swfContent() : DisplayObject
        {
            var _loc1_:Sprite = new Sprite();
            var _loc2_:DisplayObject = this.loader.content;
            _loc1_.addChild(this.loader.content);
            return _loc2_;
        }
        
        public function unLoadSwf() : void
        {
            this.loader.unloadAndStop();
        }
        
        public function cancelLoad() : void
        {
            if(this.loader.contentLoaderInfo.hasEventListener(Event.COMPLETE))
            {
                this.loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS,this.loadProgress);
                this.loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.loadComplete);
                this.loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.IOErrorHandler);
                if(this.loader.contentLoaderInfo.bytesLoaded > 4)
                {
                    if(this.loader.contentLoaderInfo.bytesLoaded < this.loader.contentLoaderInfo.bytesTotal)
                    {
                        try
                        {
                            this.loader.close();
                        }
                        catch(error:Error)
                        {
                            trace("catch error = " + Error);
                        }
                    }
                }
            }
        }
    }
}

