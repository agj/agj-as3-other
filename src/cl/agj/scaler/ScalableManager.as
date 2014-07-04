package cl.agj.scaler {
	
	public class ScalableManager {
		
		protected var _list:Vector.<IScalable>;
		
		public function ScalableManager() {
			
		}
		
		/////////
		
		public function add(scalable:IScalable):void {
			_list.push(scalable);
		}
		
		public function remove(scalable:IScalable):void {
			var index:int = _list.indexOf(scalable);
			if (index >= 0)
				_list.splice(index, 1);
		}
		
		public function getList(distanceFrom:Number, distanceTo:Number, group:String = undefined):Vector.<IScalable> {
			if (distanceTo < distanceFrom) {
				var tempDist:Number = distanceTo;
				distanceTo = distanceFrom;
				distanceFrom = tempDist;
			}
			var result:Vector.<IScalable> = new Vector.<IScalable>;
			var sclb:IScalable;
			var len:uint = _list.length;
			for (var i:int = 0; i < len; i++) {
				sclb = _list[i];
				if (sclb.distance >= distanceFrom && sclb.distance <= distanceTo) {
					result.push(sclb);
				}
			}
			result.sort(sortFunction);
			return result;
		}
		
		/////////
		
		protected function sortFunction(a:IScalable, b:IScalable):Number {
			if (a.distance > b.distance)
				return 1;
			else if (a.distance < b.distance)
				return -1;
			return 0;
		}
		
	}
}