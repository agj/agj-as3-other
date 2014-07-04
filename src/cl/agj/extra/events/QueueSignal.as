package cl.agj.extra.events {
	
	import org.osflash.signals.ISlot;
	import org.osflash.signals.PrioritySignal;
	
	/**
	 * Extends PrioritySignal and forces the use of default priority through ordinary add() and
	 * addOnce() methods, so that events are dispatched in order of registration.
	 */
	public class QueueSignal extends PrioritySignal {
		
		public function QueueSignal(...valueClasses) {
			super(valueClasses);
		}
		
		override public function add(listener:Function):ISlot {
			return super.addWithPriority(listener);
		}
		
		override public function addOnce(listener:Function):ISlot {
			return super.addOnceWithPriority(listener);
		}
		
	}
}