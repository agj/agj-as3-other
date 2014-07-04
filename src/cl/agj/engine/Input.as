package cl.agj.engine {
	
	
	public class Input {
		
		private static var _keys:Vector.<uint> = new Vector.<uint>;
		private static var _chars:Vector.<String> = new Vector.<String>;
		
		public static function pressed(key:uint):Boolean {
			return (_keys.indexOf(key) >= 0);
		}
		
		public static function pressedChar(char:String):Boolean {
			return (_chars.indexOf(char) >= 0);
		}
		
		///////
		
		public static function press(key:uint, charCode:String):void {
			if (_keys.indexOf(key) < 0)
				_keys.push(key);
			var char:String = String.fromCharCode(charCode);
			if (_chars.indexOf(char) < 0)
				_chars.push(char);
		}
		
		public static function release(key:uint, charCode:String):void {
			var index:int = _keys.indexOf(key);
			if (index >= 0)
				_keys.splice(index, 1);
			var char:String = String.fromCharCode(charCode);
			index = _chars.indexOf(char);
			if (index >= 0)
				_chars.splice(index, 1);
		}
		
	}
}