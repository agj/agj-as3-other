package cl.agj.engine {
	import cl.agj.core.IDestroyable;
	
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import org.osflash.signals.Signal;
	
	
	public interface IState extends IBug {
		
		/**
		 * Dispatched when this state is finished.
		 */
		function get finished():Signal;
		/**
		 * Dispatched for menu states and such, when the user makes a selection.
		 * 
		 * Returns: selection:String
		 */
		function get selected():Signal;
		/**
		 * Dispatched when the state wishes to restart itself. The Engine class handles this automatically.
		 */
		function get restarted():Signal;
		
	}
	
}