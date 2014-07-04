package cl.agj.extra.events {
	import cl.agj.core.utils.ListUtil;
	
	import com.codecatalyst.promise.Promise;
	
	import org.osflash.signals.IOnceSignal;
	import org.osflash.signals.ISignal;
	
	import raix.interactive.toEnumerable;
	import raix.reactive.IObservable;
	import raix.reactive.IObserver;
	import raix.reactive.Observable;
	import raix.reactive.scheduling.IScheduler;

	public class RxFrom {
		
		/**
		 * Returns an IObservable that listens to a ISignal via 'add' and emits the values it receives when the signal is dispatched.
		 * If the signal dispatches no arguments, it emits null. If the signal dispatches a single argument, it emits that value.
		 * If the signal dispatches two or more arguments, it emits those arguments as an Array.
		 */
		static public function signal(signal:ISignal):IObservable {
			return Observable.create( function (observer:IObserver):Function {
				var fn:Function = function (...params):void {
					if (params.length === 0)
						observer.onNext(null);
					else if (params.length === 1)
						observer.onNext(params[0]);
					else
						observer.onNext(params);
				};
				signal.add(fn);
				return function cleanup():void {
					signal.remove(fn);
				};
			});
		}
		
		/**
		 * Returns an IObservable that listens to a IOnceSignal via 'addOnce' and emits the value it receives when the signal is dispatched.
		 * If the signal dispatches no arguments, it emits null. If the signal dispatches a single argument, it emits that value.
		 * If the signal dispatches two or more arguments, it emits those arguments as an Array.
		 * Once the value is emitted, the IObservable completes.
		 */
		static public function signalOnce(signal:IOnceSignal):IObservable {
			return Observable.create( function (observer:IObserver):Function {
				var fn:Function = function (...params):void {
					if (params.length === 0)
						observer.onNext(null);
					else if (params.length === 1)
						observer.onNext(params[0]);
					else
						observer.onNext(params);
					observer.onCompleted();
				};
				signal.addOnce(fn);
				return function cleanup():void {
					signal.remove(fn);
				};
			});
		}
		
		/**
		 * Returns an IObservable that emits the received value from the passed promise, then completes, or errors out if
		 * the promise doesn't complete.
		 */
		static public function promise(promise:Promise):IObservable {
			return Observable.create( function (observer:IObserver):Function {
				promise.then(
					function (value:Object):void {
						observer.onNext(value);
						observer.onCompleted();
					}, function (err:* = null):void {
						observer.onError(err);
					}
				);
				return function cleanup():void { };
			});
		}
		
		/**
		 * Returns an IObservable that emits the received value from the passed promise, then completes, and if the promise
		 * doesn't complete successfully, it simply completes (doesn't error out).
		 */
		static public function promiseSkipError(promise:Promise):IObservable {
			return Observable.create( function (observer:IObserver):Function {
				promise.then(
					function (value:Object):void {
						observer.onNext(value);
						observer.onCompleted();
					}, function (err:* = null):void {
						observer.onCompleted();
					}
				);
				return function ():void { };
			});
		}
		
		static public function vector(vector:*, scheduler:IScheduler = null):IObservable {
			return Observable.fromArray(ListUtil.toArray(vector), scheduler);
		}
		
	}
}