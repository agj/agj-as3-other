package cl.agj.extra.interactive {
	import flash.display.DisplayObject;
	
	import cl.agj.core.display.TidyGraphic;
	
	public class AbstractGrid extends TidyGraphic {
		
		public function AbstractGrid() {
			
		}
		
		/////
		
		protected var _contents:Vector.<DisplayObject>;
		public function get contents():Vector.<DisplayObject> {
			return _contents ? _contents.concat() : null;
		}
		public function set contents(value:Vector.<DisplayObject>):void {
			_contents = value;
			
			for each (var item:DisplayObject in _contents) {
				addChild(item);
			}
			
			update();
		}
		
		protected var _columns:uint;
		public function get columns():uint {
			return _columns;
		}
		
		protected var _rows:uint;
		public function get rows():uint {
			return _rows;
		}
		
		protected var _cellWidth:Number = 50;
		public function get cellWidth():Number {
			return _cellWidth;
		}
		public function set cellWidth(value:Number):void {
			_cellWidth = value;
			update();
		}
		
		protected var _cellHeight:Number = 50;
		public function get cellHeight():Number {
			return _cellHeight;
		}
		public function set cellHeight(value:Number):void {
			_cellHeight = value;
			update();
		}
		
		protected var _cellPadding:Number = 10;
		public function get cellPadding():Number {
			return _cellPadding;
		}
		public function set cellPadding(value:Number):void {
			_cellPadding = value;
		}
		
		override public function get width():Number {
			return (_cellWidth + _cellPadding) * _columns - _cellPadding;
		}
		
		override public function get height():Number {
			return (_cellHeight + _cellPadding) * _rows - _cellPadding;
		}
		
		/////
		
		protected function update():void {
			
		}
		
	}
}