package cl.agj.extra.math {
	import flash.errors.IllegalOperationError;
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;
	
	public class Range extends Proxy {
		
		public function Range(start:Number, end:Number, step:Number = 1) {
			_start = start;
			_end = end;
			_step = step;
			
			_length = Math.ceil((_end - _start) / _step);
			// start + step * x < end
			// step * x < end - start
			// x < (end - start) / step
		}
		
		static public function from(start:Number):Range {
			return new Range(start, Infinity);
		}
		
		static public function to(end:Number):Range {
			return new Range(0, end);
		}
		
		/////
		
		protected var _length:uint;
		public function get length():uint {
			return _length;
		}
		
		protected var _start:Number;
		public function get start():Number {
			return _start;
		}
		
		protected var _end:Number;
		public function get end():Number {
			return _end;
		}
		
		protected var _step:Number;
		public function get step():Number {
			return _step;
		}
		
		/////
		
		public function asArray():Array {
			var result:Array = [];
			for each (var num:Number in this) {
				result.push(num);
			}
			return result;
		}
		
		public function asVector():Vector.<Number> {
			var result:Vector.<Number> = new Vector.<Number>(_length);
			var i:int = 0;
			for each (var num:Number in this) {
				result[i] = num;
				i++;
			}
			return result;
		}
		
		/////
		
		override flash_proxy function nextNameIndex(index:int):int {
			return index < _length ? ++index : 0;
		}
		
		override flash_proxy function nextValue(index:int):* {
			return _start + _step * --index;
		}
		
		override flash_proxy function nextName(index:int):String {
			throw new IllegalOperationError("Use 'for each' loops to iterate over arranges.");
		}
		
		/////
		
		public function toString():String {
			return "[" + _start + "~" + _end + "/" + _step + "]";
		}
		
	}
}