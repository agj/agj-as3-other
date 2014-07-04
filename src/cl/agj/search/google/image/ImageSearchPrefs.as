package cl.agj.search.google.image {
	import be.boulevart.google.ajaxapi.search.images.data.types.GoogleImageSafeMode;
	
	public class ImageSearchPrefs {
		
		public var size:String;
		public var imageType:String;
		public var safeMode:String;
		public var filetype:String;
		public var colorization:String;
		public var imageColor:String;
		public var restrictedToDomain:String;
		public var language:String;
		public var restrictedToCreativeCommons:Boolean;
		
		/**
		 * @param size						Restrict results to images of a certain size, you can find all values in GoogleImageSize (package data.type)
		 * @param imageType					Restrict results to images of a certain type, you can find all values in GoogleImageType (package data.type)
		 * @param safeMode					This optional argument supplies the search safety level, you can find all values in GoogleImageSafeMode (package data.type). Default is MODERATE.
		 * @param filetype					Restrict results to images with a certain extension, you can find all values in GoogleImageFiletype (package data.type)
		 * @param colorization				Restrict results to images of a certain colorization, you can find all values in GoogleImageColorization (package data.type)
		 * @param imageColor				This optional argument tells the image search system to filter the search to images of the specified color, you can find all allowed values in GoogleImageColor (package data.type)
		 * @param restrictToDomain			This optional argument tells the image search system to restrict the search to images within the specified domain <br/> Note: This restriction may restrict results to images found on pages AT the given URL and/or images WITH the given URL. 
		 * @param language					Set main language using language code
		 * @param restrictToCreativeCommons	Restrict results to CreativeCommons licensed images
		 */
		public function ImageSearchPrefs(
				size:String = "",
				imageType:String = "",
				safeMode:String = null,
				filetype:String = "",
				colorization:String = "",
				imageColor:String = "",
				restrictedToDomain:String = "",
				language:String = "",
				restrictedToCreativeCommons:Boolean = false
			) {
			
			this.size = size;
			this.imageType = imageType;
			this.safeMode = safeMode ? safeMode : GoogleImageSafeMode.MODERATE;
			this.filetype = filetype;
			this.colorization = colorization;
			this.imageColor = imageColor;
			this.restrictedToDomain = restrictedToDomain;
			this.language = language;
			this.restrictedToCreativeCommons = restrictedToCreativeCommons;
		}
		
	}
}