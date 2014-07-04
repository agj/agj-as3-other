package cl.agj.extra.events {
	import cl.agj.core.utils.ListUtil;
	
	import raix.interactive.IEnumerable;
	import raix.interactive.toEnumerable;

	public class EnumFrom {
		
		static public function vector(vector:*):IEnumerable {
			return toEnumerable(ListUtil.toArray(vector));
		}
		
	}
}