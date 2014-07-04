package cl.agj.extra {
	import cl.agj.extra.events.QueueSignal;
	
	/**
	 * Class for decoupled communication between objects, such as for implementing the MVC pattern.
	 */
	
	public class Notifier {
		
		private static var _notified:QueueSignal;
		
		/**
		 * Notifies a message (with an optional data object) to all subscribed listeners.
		 * For better decoupling, store the message string at a shared location between
		 * the sender and the receiver, or at the controlled object's end. In an MVC
		 * environment, it is not advisable for the controller to hold the message strings.
		 */
		public static function notify(message:String, data:Object = null):void {
			if (_notified && _notified.numListeners > 0) {
				_notified.dispatch(message, data);
			}
		}
		
		/**
		 * Returns: message:String, data:Object
		 */
		public static function get notified():QueueSignal {
			if (!_notified)
				_notified = new QueueSignal(String, Object);
			return _notified;
		}
		
	}
}