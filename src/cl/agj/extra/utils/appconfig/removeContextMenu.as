package cl.agj.extra.utils.appconfig {
	import flash.display.InteractiveObject;
	import flash.ui.ContextMenu;
	
	public function removeContextMenu(object:InteractiveObject):void {
		var cm:ContextMenu = new ContextMenu();
		cm.hideBuiltInItems();
		object.contextMenu = cm;
	}
	
}