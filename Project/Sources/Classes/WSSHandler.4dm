Class constructor($ui : Object)
	This:C1470.UI:=$ui
	
Function onOpen($WSServer : Object; $param : Object)
	
Function onTerminate($WSServer : Object; $param : Object)
	
Function onError($WSServer : Object; $param : Object)
	
Function onConnection($WSServer : 4D:C1709.WebSocketServer; $param : Object)->$handler : cs:C1710.WSConnectionHandler
	$handler:=cs:C1710.WSConnectionHandler.new()
	
	
	