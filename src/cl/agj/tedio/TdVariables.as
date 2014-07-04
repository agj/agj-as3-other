package cl.agj.tedio {
	
	public class TdVariables {
		
		protected var _names:Vector.<String>;
		protected var _values:Object;
		protected var _types:Object;
		
		public function TdVariables() {
			_names = new Vector.<String>;
			_values = new Object;
			_types = new Object;
		}
		
		public function addVar(name:String, initialValue:Object, type:Class = null):void {
			if (_names.indexOf(name) >= 0) {
				throw new Error("Var name already exists");
			} else {
				_names.push(name);
				_values[name] = initialValue;
				if (type)
					_types[name] = type;
			}
		}
		
		public function setVar(name:String, value:Object):void {
			if (_names.indexOf(name) < 0) {
				throw new Error("Var name doesn't exist");
			} else {
				if (_types[name]) {
					var isOfType:Boolean = value is _types[name];
					if (!isOfType)
						throw new Error("Value is not of type " + _types[name]);
				}
			}
			
			_values[name] = value;
		}
		
		public function getVar(name:String):Object {
			if (_names.indexOf(name) < 0)
				throw new Error("Var name doesn't exist");
			
			return _values[name];
		}
		
		public function hasVar(name:String):Boolean {
			return (_names.indexOf(name) >= 0);
		}
		
	}
}