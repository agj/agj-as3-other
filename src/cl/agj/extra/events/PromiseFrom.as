package cl.agj.extra.events {
	import com.codecatalyst.promise.Deferred;
	import com.codecatalyst.promise.Promise;
	
	import flash.events.IEventDispatcher;

	public class PromiseFrom {
		
		static public function event(emisor:IEventDispatcher, eventos:Array, errores:Array):Promise {
			var diferido:Deferred = new Deferred;
			function triunfar(e:*):void {
				diferido.resolve(e);
			}
			function fallar(e:*):void {
				diferido.reject(e);
			}
			if (eventos) {
				eventos.forEach( function (nombre:String, i, a):void {
					emisor.addEventListener(nombre, triunfar);
				});
			}
			if (errores) {
				errores.forEach( function (nombre:String, i, a):void {
					emisor.addEventListener(nombre, fallar);
				});
			}
			var promesa:Promise = diferido.promise;
			promesa.always( function () {
				if (eventos) {
					eventos.forEach( function (nombre:String, i, a):void {
						emisor.removeEventListener(nombre, triunfar);
					});
				}
				if (errores) {
					errores.forEach( function (nombre:String, i, a):void {
						emisor.removeEventListener(nombre, fallar);
					});
				}
			});
			return promesa;
		}
		
	}
}