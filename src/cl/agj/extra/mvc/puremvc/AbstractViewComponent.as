package cl.agj.extra.mvc.puremvc {
	
	import cl.agj.core.TidyListenerRegistrar;
	
	import flash.display.DisplayObject;
	
	public class AbstractViewComponent extends TidyListenerRegistrar {
		
		protected var _design:DisplayObject;
		
		public function AbstractViewComponent(design:DisplayObject = null) {
			if (design)
				_design = design;
			super();
		}
		
	}
}