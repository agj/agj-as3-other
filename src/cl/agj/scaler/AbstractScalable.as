package cl.agj.scaler {
	
	import cl.agj.core.Destroyable;
	
	import flash.display.BitmapData;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * Extend this abstract class to create scalable objects compatible with Scaler.
	 */
	public class AbstractScalable extends Destroyable implements IScalable {
		
		internal const CLASS_NAME:String = "cl.agj.scaler::AbstractScalable";
		
		protected var _distance:Number;
		protected var _x:Number;
		protected var _y:Number;
		
		public function AbstractScalable() {
			if (getQualifiedClassName(this) == CLASS_NAME) {
            	throw new Error("This is an abstract class and is not meant for instantiation; it should only be extended.");
			}
		}
		
		/////////
		
		public function update():void {
			
		}
		
		public function render(bitmapData:BitmapData, x:Number, y:Number, scale:Number):void {
			
		}
		
		public function move(distance:Number = NaN, x:Number = NaN, y:Number = NaN):void {
			
		}
		
		public function updateSeen():void {
			
		}
		
		public function updateUnseen():void {
			
		}
		
		public function collided(against:IScalable, localSide:uint):void {
			
		}
		
		/////////
		
		public function get distance():Number {
			return _distance;
		}
		public function set distance(value:Number):void {
			_distance = value;
		}
		
		public function get x():Number {
			return _x;
		}
		public function set x(value:Number):void {
			_x = value;
		}
		
		public function get y():Number {
			return _y;
		}
		public function set y(value:Number):void {
			_y = value;
		}
		
		public function get prevDistance():Number {
			return 0;
		}
		public function get prevX():Number {
			return 0;
		}
		public function get prevY():Number {
			return 0;
		}
		
		public function get group():String {
			return "";
		}
		public function set group(value:String):void {
			
		}
		
		public function get collidableType():String {
			return "";
		}
		public function set collidableType(value:String):void {
			
		}
		
	}
}