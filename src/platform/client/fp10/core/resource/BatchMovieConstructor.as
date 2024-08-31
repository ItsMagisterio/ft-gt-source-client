package platform.client.fp10.core.resource
{
   import flash.display.DisplayObjectContainer;
   import flash.display.LoaderInfo;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.utils.ByteArray;
   import flash.utils.Dictionary;
   import flash.utils.setTimeout;

   public class BatchMovieConstructor extends EventDispatcher
   {

      public var movies:Vector.<DisplayObjectContainer>;

      private var movieBytes:Vector.<ByteArray>;

      private var loaders:Dictionary;

      private var maxParallelThreads:int;

      private var numRunningLoaders:int;

      private var lastMovieIndex:int;

      private var isRunning:Boolean;

      private var numCreatedImages:int;

      public function BatchMovieConstructor()
      {
         this.loaders = new Dictionary();
         super();
      }

      public function buildMovies(param1:Vector.<ByteArray>, param2:int):void
      {
         if (this.isRunning)
         {
            throw new Error("Already running");
         }
         if (param1 == null)
         {
            throw new ArgumentError("Parameter imageDatas is null");
         }
         this.movieBytes = param1;
         this.maxParallelThreads = param2;
         this.isRunning = true;
         this.movies = new Vector.<DisplayObjectContainer>(param1.length);
         this.numCreatedImages = 0;
         this.numRunningLoaders = 0;
         this.lastMovieIndex = 0;
         if (param1.length > 0)
         {
            this.runLoaders();
         }
         else
         {
            setTimeout(this.complete, 0);
         }
      }

      private function runLoaders():void
      {
         var _loc1_:MovieLoader = null;
         while (this.numRunningLoaders < this.maxParallelThreads && this.lastMovieIndex < this.movieBytes.length)
         {
            _loc1_ = this.createLoader(this.lastMovieIndex);
            this.loaders[_loc1_] = true;
            ++this.numRunningLoaders;
            ++this.lastMovieIndex;
         }
      }

      private function onMovieComplete(param1:Event):void
      {
         var _loc2_:MovieLoader = MovieLoader(LoaderInfo(param1.target).loader);
         --this.numRunningLoaders;
         ++this.numCreatedImages;
         delete this.loaders[_loc2_];
         this.movies[_loc2_.index] = _loc2_;
         if (this.numCreatedImages == this.movieBytes.length)
         {
            this.complete();
         }
         else
         {
            this.runLoaders();
         }
      }

      private function createLoader(param1:int):MovieLoader
      {
         var _loc2_:MovieLoader = new MovieLoader(param1);
         _loc2_.contentLoaderInfo.addEventListener(Event.COMPLETE, this.onMovieComplete);
         _loc2_.loadBytes(this.movieBytes[this.lastMovieIndex]);
         return _loc2_;
      }

      private function complete():void
      {
         this.isRunning = false;
         this.movieBytes = null;
         dispatchEvent(new Event(Event.COMPLETE));
      }
   }
}

import flash.display.Loader;

class MovieLoader extends Loader
{

   public var index:int;

   public function MovieLoader(param1:int)
   {
      super();
      this.index = param1;
   }
}
