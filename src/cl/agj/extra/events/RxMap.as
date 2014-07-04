package cl.agj.extra.events {
	
	public class RxMap {
		
		static public function property(name:String):Function {
			return function (v:Object):* {
				return v.hasOwnProperty(name) ? v[name] : null;
			};
		}
		
		static public function value(thing:*):Function {
			return function ():* {
				return thing;
			};
		}
		
		static public function itself(v:*):* {
			return v;
		}
		
	}
}