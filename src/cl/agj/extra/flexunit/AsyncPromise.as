package cl.agj.extra.flexunit {
	import flash.utils.Dictionary;
	
	import org.flexunit.AssertionError;
	import org.flexunit.async.AsyncLocator;
	import org.flexunit.internals.runners.statements.IAsyncHandlingStatement;
	
	public class AsyncPromise {
		
		static public function handle(testCase:Object, eventHandler:Function, timeout:int, passThroughData:Object = null, timeoutHandler:Function = null):Function {
			var asyncHandlingStatement:IAsyncHandlingStatement = AsyncLocator.getCallableForTest(testCase);
			
			return asyncHandlingStatement.asyncHandler(eventHandler, timeout, passThroughData, timeoutHandler);
		}
		
		/////
		
		static private var asyncHandlerMap:Dictionary = new Dictionary();
		
		static private function getCallableForTest( testCase:Object ):IAsyncHandlingStatement {
			var monitor:StatementDependencyMonitor = getDependencyMonitor( testCase );
			
			//If no handler was obtained from the dictionary, the test case was never marked as asynchronous, throw an AssertionError
			if ( !monitor ) {
				//TODO: Refactor this to some other type of error
				throw new AssertionError("Cannot add asynchronous functionality to methods defined by Test,Before or After that are not marked async");	
			}
			
			var handler:IAsyncHandlingStatement = monitor.statement;
			
			return handler;
		}
		
		static private function getDependencyMonitor(testCase:Object):StatementDependencyMonitor {
			return asyncHandlerMap[testCase];
		}
		
	}
}

import org.flexunit.internals.runners.statements.IAsyncHandlingStatement;

class StatementDependencyMonitor {
	private var dependencyCount:int = 0;
	private var _statement:IAsyncHandlingStatement;
	
	public function StatementDependencyMonitor( statement:IAsyncHandlingStatement ) {
		_statement = statement;
	}
	
	public function addDependency():void {
		dependencyCount++;
	}
	
	public function removeDependency():void {
		dependencyCount--;	
	}
	
	public function get statement():IAsyncHandlingStatement {
		return _statement;
	}
	
	public function get complete():Boolean {
		return ( dependencyCount == 0 );
	}
}
