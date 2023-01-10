//%attributes = {}
// execute in a worker, so the process stays alive and the global variable refering to
// the web socket server will stay alive and so the server itself will keep running/be active

//CALL WORKER("GUI_worker"; "GUI_worker"; "simple")  // init and starts web socket server on "/ws"
//CALL WORKER("GUI_worker"; "GUI_worker"; "init") 

//CALL WORKER("GUI_worker"; "GUI_worker"; "init_with_tabs")  // when you test that, also enable graph
//CALL WORKER("GUI_worker"; "GUI_worker"; "graph")  // push some graph points




If (True:C214)
	$win:=Open form window:C675("dialog")
	CALL WORKER:C1389("GUI_worker"; "GUI_worker"; "init_with_tabs"; New object:C1471; $win)
	DIALOG:C40("dialog")
	CLOSE WINDOW:C154($win)
	// dialog includes Graph points
End if 


