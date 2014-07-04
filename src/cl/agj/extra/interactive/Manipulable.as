package cl.agj.extra.interactive {
	import cl.agj.core.TidyListenerRegistrar;
	import cl.agj.core.utils.Delay;
	
	import flash.display.InteractiveObject;
	import flash.events.Event;
	
	public class Manipulable extends TidyListenerRegistrar {
		
		public function Manipulable(target:InteractiveObject) {
			_target = target;
			
			if (_target.stage) {
				Delay.tillLater(init);
			} else {
				_target.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			}
		}
		
		private function onAddedToStage(e:Event = null):void {
			_target.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			init();
		}
		
		protected function init():void {
			
		}
		
		/////
		
		protected var _target:InteractiveObject;
		public function get target():InteractiveObject {
			return _target;
		}
		
	}
}