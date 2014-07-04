package cl.agj.tedio {
	import flash.display.Sprite;
	
	public class Tedio extends Sprite {
		
		private var _pages:Vector.<TdPage>;
		
		public function Tedio() {
			
		}
		
		protected function start():void {
			_pages[0].start();
		}
		
		////////////////
		
		protected function addPages(... pages):void {
			var newPages:Vector.<TdPage> = Vector.<TdPage>(pages);
			if (!_pages)
				_pages = newPages;
			else
				_pages = _pages.concat(newPages);
		}
		
		
	}
	
}