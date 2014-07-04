package cl.agj.extra.utils {
	import cl.agj.core.utils.ListUtil;
	
	/**
	 * This thing is worth crap.
	 * 
	 * @deprecated
	 */
	public class FluentArray extends Array {
		
		static public function take(list:Object):FluentArray {
			return new FluentArray(list);
		}
		
		public function FluentArray(list:Object = null) {
			if (list is Array)
				concat(list);
			else if (ListUtil.isList(list))
				concat(ListUtil.toArray(list));
		}
		
		public function map(fnOrProperty:Object, scope:* = null):FluentArray {
			var len:int = length, index:int = 0, result:FluentArray = new FluentArray;
			while (index < length) {
				if (index in this) {
					result[index] = transformArgument(this[index], fnOrProperty, scope, [this[index], index, this]);
					//result[index] = fnOrProperty.call(scope, this[index], index, this);
				}
				index++;
			}
			return result;
			
			//var index:int = 0;
			//return reduce( function(result:FluentArray, item) {
			//	result[index] = transformArgument(item, fnOrProperty, this, [item, index, this]);
			//	return result;
			//}, new FluentArray);
		}
		
		public function indices():FluentArray {
			return new FluentArray;
		}
		
		public function reduce(fn:Function, init):FluentArray {
			var result:FluentArray = new FluentArray;
//			for (var i:int = 0) {
//				
//			}
			return result;
		}
		
		/*
		public function getLowest(property:String = null):Object {
			var best:Object;
			if (property)
				var path:Array = property.split(".");
			for each (var o:Object in this) {
				if (!best ||
					(!path && o < best) ||
					(path && getFromPath(best, path) < getFromPath(o, path))
				)
					best = o;
			}
			return best;
		}
		
		public function asVector(type:Class):Object {
			return Vector.<type>(this);
		}
		//*/
		
		/////
		
		protected function transformArgument(el, map, context = null, mapArgs:Array = null):Object {
			if (!map) {
				return el;
			} else if (map is Function) {
				return map.apply(context, mapArgs ? mapArgs : []);
			} else if (el[map] is Function) {
				return el[map].call(el);
			} else {
				return el[map];
			}
		}
		
	}
}