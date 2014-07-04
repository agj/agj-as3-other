package cl.agj.extra.events {
	public class Predicate {
		
		/**
		 * Call passing the name of the property and its expected value.
		 * @returns The predicate function that compares by the passed property name.
		 */
		static public function property(name:String, value:Object):Function {
			return function (v:Object):Boolean {
				return v && v[name] === value;
			};
		}
		
		static public function isTruthy(v:*):Boolean {
			return !!v;
		}
		
		/**
		 * Call passing the type to compare the value to.
		 * @returns The predicate function that compares to the specified type.
		 */
		static public function isA(type:Class):Function {
			return function (v:Object):Boolean {
				return v is type;
			};
		}
		
		static public function equals(value:*):Function {
			return function (v:*):Boolean {
				return v === value;
			};
		}
		
		static public function both(a:*, b:*):Boolean {
			return a && b;
		}
		
		static public function either(a:*, b:*):Boolean {
			return a || b;
		}
		
		static public function neither(a:*, b:*):Boolean {
			return !a && !b;
		}
		
	}
}