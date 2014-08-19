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
		
		static public function from(start:Number, step:Number = 1):Range {
			return new Range(start, Infinity, step);
		}
		
		static public function to(end:Number, step:Number = 1):Range {
			return new Range(0, end, step);
		}
		
		static public function between(start:Number, end:Number, step:Number = 1):Range {
			return new Range(start, end, step);
		}
		
		/////
		
		protected var _length:Number;
		public function get length():Number {
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
		
		/**
		 * Allows for iteration on the Range's values with the passed callback function.
		 * 
		 * @param callback  Takes signature ´callback(value, index, range)´. Return the false value from it in order to break.
		 * @return          The same Range object, unmodified.
		 */
		public function forEach(callback:Function):Range {
			var argsNum:int = Math.max(callback.length, 1);
			var i:int = 0;
			for each (var v:Number in this) {
				if (callback.apply(null, [v, i, this].slice(0, argsNum)) === false) break;
				i++;
			}
			return this;
		}
		
		/////
		
		override flash_proxy function nextNameIndex(index:int):int {
			return index < _length ? ++index : 0;
		}
		
		override flash_proxy function nextValue(index:int):* {
			return _start + _step * --index;
		}
		
		override flash_proxy function nextName(index:int):String {
			throw new IllegalOperationError("Use 'for each..in' loops to iterate over Ranges.");
		}
		
		/////
		
		public function toString():String {
			return "[" + _start + "~" + _end + "/" + _step + "]";
		}
		
	}
}