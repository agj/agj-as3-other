package cl.agj.transitions {
	import cl.agj.core.IDestroyable;
	
	import org.osflash.signals.Signal;
	
	public interface ITransition extends IDestroyable {
		
		function get finished():Signal;
		
		function update(elapsed:uint):void;
		
	}
	
}