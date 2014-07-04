package cl.agj.search.google.image {
	
	import be.boulevart.google.ajaxapi.search.GoogleSearchResult;
	import be.boulevart.google.ajaxapi.search.images.GoogleImageSearch;
	import be.boulevart.google.ajaxapi.search.images.data.GoogleImage;
	import be.boulevart.google.ajaxapi.search.images.data.types.GoogleImageSize;
	import be.boulevart.google.events.GoogleAPIErrorEvent;
	import be.boulevart.google.events.GoogleApiEvent;
	
	import cl.agj.core.utils.Destroyer;
	import cl.agj.core.TidyListenerRegistrar;
	
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import org.osflash.signals.Signal;
	
	public class ImageSearchManager extends TidyListenerRegistrar {
		
		protected var _resultObtained:Signal;
		protected var _failed:Signal;
		
		protected var _query:String;
		protected var _start:uint;
		
		public var searchTimeout:Number;
		public var maxRetries:uint;
		
		protected var _prefs:ImageSearchPrefs;
		
		protected var _busy:Boolean;
		protected var _timer:Timer;
		
		protected var _failures:uint;
		protected var _timeouts:uint;
		
		protected var _googleSearch:GoogleImageSearch;
		protected var _result:GoogleSearchResult;
		
		public function ImageSearchManager() {
			_resultObtained = new Signal(ImageSearchManager);
			_failed = new Signal(ImageSearchManager);
			
			searchTimeout = 10;
			maxRetries = 1;
			
			_busy = false;
			
			super();
			
			_timer = new Timer(1, 1);
			registerListener(_timer, TimerEvent.TIMER_COMPLETE, onTrackingTimeout);
		}
		
		public function search(query:String, start:uint = 0, prefs:ImageSearchPrefs = null):void {
			reset();
			_busy = true;
			
			_query = query;
			_start = Math.min(start, 50);
			if (prefs)
				_prefs = prefs;
			else
				_prefs = new ImageSearchPrefs;
			
			_googleSearch = new GoogleImageSearch;
			registerListener(_googleSearch, GoogleApiEvent.IMAGE_SEARCH_RESULT, onSearchResults);
			registerListener(_googleSearch, GoogleApiEvent.ON_ERROR, onSearchError);
			registerListener(_googleSearch, GoogleAPIErrorEvent.API_ERROR, onSearchError);
			_googleSearch.search(_query, _start, _prefs.safeMode, _prefs.size, _prefs.colorization, _prefs.imageColor, _prefs.imageType, _prefs.filetype, _prefs.restrictedToCreativeCommons, _prefs.language, _prefs.restrictedToDomain);
			
			_timer.delay = searchTimeout * 1000;
			_timer.start();
		}
		
		public function abort():void {
			_busy = false;
			reset();
		}
		
		/////
		
		protected function retrySearch():void {
			if (_failures < maxRetries) {
				search(_query, _start, _prefs);
			} else {
				_failed.dispatch(this);
			}
		}
		
		protected function reset():void {
			_timer.stop();
			_failures = 0;
			_timeouts = 0;
			unregisterAllListeners(_googleSearch);
		}
		
		/////
		
		protected function onSearchResults(e:GoogleApiEvent):void {
			_timer.stop();
			_busy = false;
			_result = e.data as GoogleSearchResult;
			_resultObtained.dispatch(this);
		}
		
		protected function onSearchError(e:Event):void {
			_failures++;
			retrySearch();
		}
		
		protected function onTrackingTimeout(e:TimerEvent):void {
			_timeouts++;
			_busy = false;
			
			_failed.dispatch(this);
		}
		
		/////
		
		/**
		 * Returns: this:ImageSearchManager
		 */
		public function get resultObtained():Signal {
			return _resultObtained;
		}
		
		/**
		 * Returns: this:ImageSearchManager
		 */
		public function get failed():Signal {
			return _failed;
		}
		
		public function get busy():Boolean {
			return _busy;
		}
		
		public function get result():GoogleSearchResult {
			return _result;
		}
		
		/////
		
		override public function destroy():void {
			Destroyer.destroy([
				_resultObtained,
				_failed,
				_timer
			]);
			super.destroy();
		}
		
	}
}