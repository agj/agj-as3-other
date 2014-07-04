package cl.agj.extra.interactive {
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Rectangle;

	public class GridElement {
		
		public function GridElement(objectToWrap:DisplayObject) {
			var wrappedSize:Rectangle = objectToWrap.getBounds(objectToWrap);
			graphic = new Sprite;
			graphic.addChild(objectToWrap);
			objectToWrap.x = -wrappedSize.width / 2 + wrappedSize.x;
			objectToWrap.y = -wrappedSize.height / 2 + wrappedSize.y;
			
			size = graphic.getBounds(graphic);
			halfSize = size.clone();
			halfSize.inflate(-size.width / 4, -size.height / 4);
		}
		
		/////
		
		public var graphic:Sprite;
		public var size:Rectangle;
		public var halfSize:Rectangle;
		
		public function get scale():Number {
			return graphic.scaleX;
		}
		public function set scale(value:Number):void {
			graphic.scaleX = graphic.scaleY = value;
		}
		
	}
}