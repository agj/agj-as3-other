package cl.agj.extra.events {
	
	import org.osflash.signals.Signal;
	
	/**
	 * Extension to the Signal class that automatically returns the 'parent' object as the first value object.
	 * 
	 * @author agj
	 */
	public class ChildSignal extends Signal {
		
		protected var _target:Object;
		
		/**
		 * @param parent The object that has this signal as a property.
		 */
		public function ChildSignal(target:Object, ...valueClasses) {
			if (target) {
				_target = target;
				var parentClass:Class = Class(_target["constructor"]);
				valueClasses.unshift(parentClass)
			}
			
			super(valueClasses);
			
			if (target == null)
				throw new ArgumentError("ChildSignal: 'target' argument must be non-null.");
		}
		
		/////
		
		override public function dispatch(...valueObjects):void {
			valueObjects.unshift(_target);
			super.dispatch.apply(this, valueObjects);
		}
		
		/////
		
		public function get target():Object {
			return _target;
		}
		
	}
}