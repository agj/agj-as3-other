package cl.agj.ui {
	import cl.agj.core.display.IDisplayObject;
	
	import flash.display.DisplayObject;
	import flash.geom.Point;
	
	
	public interface ITransformable extends IDisplayObject {
		
		function get corners():Vector.<Point>;
		function dragCorner(num:uint, newPos:Point):void;
		function resetCorners():void;
		function addChildCentered(child:DisplayObject):void;
		function centerRegistrationPoint(keepScreenPosition:Boolean = false):void;
		
		function get allowsTransformation():Boolean;
		function set allowsTransformation(value:Boolean):void;
		function get allowsDrag():Boolean;
		function set allowsDrag(value:Boolean):void;
		
		function get minScale():Number;
		function set minScale(value:Number):void;
		function get maxScale():Number;
		function set maxScale(value:Number):void;
		
	}
	
}