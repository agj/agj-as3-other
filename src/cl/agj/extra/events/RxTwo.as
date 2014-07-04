package cl.agj.extra.events {
	public class RxTwo {
		
		static public function larger(a:*, b:*):* {
			return a < b ? b : a;
		}
		
		static public function smaller(a:*, b:*):* {
			return a > b ? b : a;
		}
		
	}
}