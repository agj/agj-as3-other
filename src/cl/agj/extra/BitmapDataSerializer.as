package cl.agj.extra {
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;

	/**
	 * This probably doesn't work as is.
	 * 
	 * @author agj
	 */
	public class BitmapDataSerializer implements IExternalizable {
		
		internal var _width:int;
		internal var _height:int;
		internal var _bd:BitmapData;
		
		public function BitmapDataSerializer(bitmapData:BitmapData = null) {
			_bd = bitmapData;
		}
		
		public function set bd(bitmapData:BitmapData):void {
			_bd = bitmapData;
		}
		public function get bd():BitmapData {
			return _bd;
		}
		
		public function writeExternal(output:IDataOutput):void {
			var byteArray:ByteArray;
			if (_bd) {
				output.writeInt(_bd.width);
				output.writeInt(_bd.height);
				output.writeBoolean(_bd.transparent);
				byteArray = _bd.getPixels(new Rectangle(0, 0, _bd.width, _bd.height));
			} else {
				output.writeInt(0);
				output.writeInt(0);
				output.writeBoolean(false);
				byteArray = new ByteArray;
				byteArray.writeInt(0);
			}
			output.writeBytes(byteArray);
		}

		public function readExternal(input:IDataInput):void {
			var width:int = input.readInt();
			var height:int = input.readInt();
			
			if (width > 0 && height > 0) {
				var transparent:Boolean = input.readBoolean();
				_bd = new BitmapData(width, height, transparent);
				var byteArray:ByteArray = new ByteArray();
				input.readBytes(byteArray);
				_bd.setPixels(new Rectangle(0, 0, width, height), byteArray);
			}
		}
		
		
	}

}