package cl.agj.extra.events {
	import cl.agj.core.utils.ListUtil;
	
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
				eventos.forEach( function (nombre:String, ...etc):void {
					emisor.addEventListener(nombre, triunfar);
				});
			}
			if (errores) {
				errores.forEach( function (nombre:String, ...etc):void {
					emisor.addEventListener(nombre, fallar);
				});
			}
			var promesa:Promise = diferido.promise;
			promesa.always( function () {
				if (eventos) {
					eventos.forEach( function (nombre:String, ...etc):void {
						emisor.removeEventListener(nombre, triunfar);
					});
				}
				if (errores) {
					errores.forEach( function (nombre:String, ...etc):void {
						emisor.removeEventListener(nombre, fallar);
					});
				}
			});
			return promesa;
		}
		
		static public function allComplete(promises:Array):Promise {
			var deferred:Deferred = new Deferred;
			var remaining:int = promises.length;
			for each (var p:Promise in promises) {
				p.always( function ():void {
					--remaining;
					if (remaining === 0) deferred.resolve(true);
				});
			}
			return deferred.promise;
		}
		
	}
}