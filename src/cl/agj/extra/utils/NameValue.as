package cl.agj.extra.utils {
	public class NameValue {
		
		public function NameValue(name:String, value:Object) {
			_name = name;
			_value = value;
		}
		
		/////
		
		protected var _name:String;
		public function get name():String {
			return _name;
		}
		
		protected var _value:Object;
		public function get value():Object {
			return _value;
		}
		
	}
}