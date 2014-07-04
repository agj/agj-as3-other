package cl.agj.search.google.image {
	import be.boulevart.google.ajaxapi.search.GoogleSearchResult;
	import be.boulevart.google.ajaxapi.search.images.data.GoogleImage;
	
	import cl.agj.core.Destroyable;
	import cl.agj.core.net.ResourceListLoader;
	import cl.agj.core.utils.Tools;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	
	import org.osflash.signals.events.GenericEvent;
	
	public class ImageRetriever extends Destroyable {
		
		public var skiplist:Vector.<String>;
		public var domains:Vector.<String>
		
		public var defaultSearchPrefs:ImageSearchPrefs;
		
		protected var _blacklist:Vector.<String>;
		
		protected var _searchManager:ImageSearchManager;
		protected var _cache:ImageRetrieverCache;
		
		protected var _useCache:Boolean;
		
		protected var _searchResult:GoogleSearchResult;
		protected var _lastSearchIndex:uint;
		protected var _result:Vector.<Bitmap>;
		
		protected var _query:String;
		protected var _getAmount:uint;
		protected var _searchPrefs:ImageSearchPrefs;
		
		public function ImageRetriever(useCache:Boolean = true) {
			_useCache = useCache;
			
			_searchManager = new ImageSearchManager;
			_cache = new ImageRetrieverCache;
			
			_searchManager.resultObtained.add(onSearchResult);
			
			_blacklist = new Vector.<String>;
			
			useCache = false;
		}
		
		public function findNew(query:String, amount:uint = 1, searchPrefs:ImageSearchPrefs = null):void {
			_result = new Vector.<Bitmap>;
			_lastSearchIndex = 0;
			
			_query = query;
			_getAmount = Math.max(amount, 1);
			
			_searchPrefs = searchPrefs;
			if (!_searchPrefs)
				_searchPrefs = defaultSearchPrefs;
			
			search(_lastSearchIndex);
		}
		
		public function abort():void {
			
		}
		
		public function getCached(query:String, searchPrefs:ImageSearchPrefs):Vector.<Bitmap> {
			return new Vector.<Bitmap>;
		}
		
		/////
		
		protected function search(startResult:uint):void {
			_searchManager.search(_query, 0, _searchPrefs);
		}
		
		protected function findMore():void {
			search(_lastSearchIndex + 1);
		}
		
		/////
		
		public function onSearchResult(ism:ImageSearchManager):void {
			_searchResult = ism.result;
			
			_lastSearchIndex += _searchResult.results.length;
			
			var urls:Vector.<String> = new Vector.<String>;
			var forbiddenList:Vector.<String>;
			if (skiplist)
				forbiddenList = _blacklist.concat(skiplist);
			else
				forbiddenList = _blacklist;
			
			for each (var r:GoogleImage in _searchResult.results) {
				if (Tools.multipleStringMatch(r.url, domains, forbiddenList)) {
					urls.push(r.url);
				}
			}
			
			if (urls.length > 0) {
				var loader:ResourceListLoader = new ResourceListLoader(urls);
				loader.finished.add(onImagesLoaded);
			} else {
				// dispatch error signal? search for more?
			}
		}
		
		public function onImagesLoaded(e:GenericEvent):void {
			var loader:ResourceListLoader = ResourceListLoader(e.target);
			if (!loader.success) {
				trace("ImageRetriever onImagesLoadError", loader);
				return;
			}
			
			for each (var img:Object in loader.resources) {
				if (img is Bitmap) {
					_result.push(img);
					if (_useCache) {
						_cache.add(_query, _searchPrefs, Bitmap(img));
					}
				}
			}
			
			_cache.updateLastSearchIndex(_query, _searchPrefs, _lastSearchIndex);
			
			if (_result.length < _getAmount) {
				findMore();
			} else {
				// dispatch signal
			}
		}
		
		public function onSearchFailed(ism:ImageSearchManager):void {
			trace("ImageRetriever onSearchFailed", ism);
		}
		
		/////
		
		public function get useCache():Boolean {
			return _useCache;
		}
		
	}
}