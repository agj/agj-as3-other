package cl.agj.scaler {
	
	import cl.agj.core.IDestroyable;
	
	import flash.display.BitmapData;
	import flash.display.IBitmapDrawable;
	
	/**
	 * Interface for scalable items compatible with Scaler.
	 */
	public interface IScalable extends IDestroyable {
		
		function get distance():Number;
		function get x():Number;
		function get y():Number;
		
		function get prevDistance():Number;
		function get prevX():Number;
		function get prevY():Number;
		
		function get group():String;
		function set group(value:String):void;
		
		function get collidableType():String;
		function set collidableType(value:String):void;
		
		function move(distance:Number = NaN, x:Number = NaN, y:Number = NaN):void;
		
		/**
		 * Called by Scaler when this item is within view distance.
		 */
		function updateSeen():void;
		
		function updateUnseen():void;
		
		function collided(against:IScalable, localSide:uint):void;
		
		/**
		 * Called by Scaler when it's time to render this item.
		 */
		function render(bitmapData:BitmapData, x:Number, y:Number, scale:Number):void;
		
	}
	
}