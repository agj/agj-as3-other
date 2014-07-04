package cl.agj.extra.interactive {
	import flash.display.DisplayObject;

	public class VerticalGrid extends AbstractGrid {
		
		public function VerticalGrid() {
			_columns = 5;
		}
		
		/////
		
		public function set columns(value:uint):void {
			_columns = value;
		}
		
		/////
		
		override protected function update():void {
			super.update();
			
			var len:int = _contents ? _contents.length : 0;
			for (var i:int = 0; i < len; i++) {
				var item:DisplayObject = _contents[i];
				item.x = (i % _columns) * (_cellWidth + _cellPadding);
				item.y = Math.floor(i / _columns) * (_cellHeight + _cellPadding);
			}
			
			_rows = Math.ceil(len / _columns);
		}
		
	}
}