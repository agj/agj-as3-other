package cl.agj.extra.utils {
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	/**
	 * Code based on switchonthecode.com's FileSerializer class.
	 * @author agj
	 */
	public class FileSerializer {
		
		public static function writeObjectToFile(object:Object, file:File):void {
			var fileStream:FileStream = new FileStream();
			fileStream.open(file, FileMode.WRITE);
			fileStream.writeObject(object);
			fileStream.close();
		}

		public static function readObjectFromFile(file:File):Object {
			if(file.exists) {
				var obj:Object;
				var fileStream:FileStream = new FileStream();
				fileStream.open(file, FileMode.READ);
				obj = fileStream.readObject();
				fileStream.close();
				return obj;
			}
			return null;
		}
		
	}

}