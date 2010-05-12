package org.ludo.controllers
{
	import org.frest.controllers.FrEventController;
	import org.ludo.commands.*;

	public class EventController extends FrEventController
	{
		public function EventController()
		{
			super();
			initializeCommands();
		}

		private function initializeCommands() : void
		{
			addCommand(EventNames.LOAD_PAGE, LoadPageCommand);
			addCommand(EventNames.LOAD_MAIN, LoadMainCommand);
			addCommand(EventNames.CREATE_DOCUMENT, CreateDocumentCommand);
			addCommand(EventNames.UPDATE_DOCUMENT, UpdateDocumentCommand);
			addCommand(EventNames.DELETE_DOCUMENT, DeleteDocumentCommand);
			addCommand(EventNames.VIEW_DOCUMENT,ViewDocumentCommand);
		}
	}
}
