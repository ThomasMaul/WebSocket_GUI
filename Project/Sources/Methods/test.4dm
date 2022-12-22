//%attributes = {}
// execute in a worker, so the process stays alive and the global variable refering to
// the web socket server will stay alive and so the server itself will keep running/be active

CALL WORKER:C1389("GUI_worker"; "GUI_worker"; "simple")  // init and starts web socket server on "/ws"
//CALL WORKER("GUI_worker"; "GUI_worker"; "init")  // init and starts web socket server on "/ws"
//CALL WORKER("GUI_worker"; "GUI_worker"; "init_with_tabs")  // init and starts web socket server on "/ws"


//CALL WORKER("GUI_worker"; "GUI_worker"; "graph")  // init and starts web socket server on "/ws"
