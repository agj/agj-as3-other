package cl.agj.extra.mvc {
	import cl.agj.extra.Notifier;
	import cl.agj.core.TidyListenerRegistrar;
	import cl.agj.core.debugging.Logger;
	
	import flash.utils.Dictionary;
	
	public class Command extends TidyListenerRegistrar {
		
		private static var _instances:Dictionary;
		private static var _allowInstantiation:Boolean;
		
		public function Command() {
			if (!_allowInstantiation) {
				throw new Error("Cannot instantiate a singleton class with the 'new' keyword.");
			}
			Notifier.notified.add(onNotified);
			onInitted();
		}
		
		/////
		
		protected function onNotified(message:String, data:Object):void { }
		
		protected function onInitted():void { }
		
		protected static function getInstance(type:Class):Object {
			if (!_instances)
				_instances = new Dictionary;
			if (!_instances[type]) {
				_allowInstantiation = true;
				_instances[type] = new type;
				_allowInstantiation = false;
			}
			return _instances[type];
		}
		
		protected function deleteInstance():void {
			var type:Class = Object(this).constructor;
			Logger.log(this, "Deleting instance:", type, _instances[type]);
			delete _instances[type];
		}
		
		/////
		
		override public function destroy():void {
			super.destroy();
			deleteInstance();
			Notifier.notified.remove(onNotified);
		}
		
	}
}