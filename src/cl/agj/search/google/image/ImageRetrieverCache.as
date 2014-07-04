package cl.agj.search.google.image {
	import flash.display.Bitmap;
	
	public class ImageRetrieverCache {
		
		protected var _images:Object;
		protected var _lastSearchIndexes:Object;
		
		public function ImageRetrieverCache() {
			_images = {};
			_lastSearchIndexes = {};
		}
		
		public function add(query:String, prefs:ImageSearchPrefs, image:Bitmap):void {
			var hash:String = getHash(query, prefs);
			var list:Vector.<Bitmap> = _images[hash];
			if (!list)
				list = new Vector.<Bitmap>;
			list.push(image);
			_images[hash] = getHash(query, prefs);
		}
		
		public function updateLastSearchIndex(query:String, prefs:ImageSearchPrefs, index:uint):void {
			var hash:String = getHash(query, prefs);
			_lastSearchIndexes[hash] = index;
		}
		
		public function getLastSearchIndex(query:String, prefs:ImageSearchPrefs):uint {
			var hash:String = getHash(query, prefs);
			return uint(_lastSearchIndexes[hash]);
		}
		
		/////
		
		protected function getHash(query:String, prefs:ImageSearchPrefs):String {
			var hash:String = query;
			hash += "|" + prefs.size;
			hash += "|" + prefs.imageType;
			hash += "|" + prefs.safeMode;
			hash += "|" + prefs.filetype;
			hash += "|" + prefs.colorization;
			hash += "|" + prefs.imageColor;
			hash += "|" + prefs.restrictedToDomain;
			hash += "|" + prefs.language;
			hash += "|" + prefs.restrictedToCreativeCommons;
			
			return hash;
		}
		
	}
}