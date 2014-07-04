package cl.agj.engine {
	import cl.agj.core.IDestroyable;
	
	import flash.events.KeyboardEvent;
	
	
	public interface ICog extends IDestroyable {
		
		function onEnterFrame(elapsed:uint):void;
		function onKeyDown(key:uint, char:String, e:KeyboardEvent):void;
		function onKeyUp(key:uint, char:String, e:KeyboardEvent):void;
		
	}
	
}