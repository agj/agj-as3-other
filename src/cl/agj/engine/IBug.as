package cl.agj.engine {
	import cl.agj.core.IDestroyable;
	import cl.agj.core.display.IDisplayObject;
	
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	
	public interface IBug extends ICog, IDisplayObject {
		
		//function onMouseDown(e:MouseEvent, click:Point):void;
		//function onMouseUp(e:MouseEvent, click:Point):void;
		//function onMouseMove(e:MouseEvent):void;
		function onFocusChange(focus:Boolean):void;
		function onStageResized():void;
		
	}
	
}