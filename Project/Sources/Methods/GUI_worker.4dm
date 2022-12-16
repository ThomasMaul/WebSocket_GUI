//%attributes = {}
#DECLARE($job : Text; $data : Object)
C_OBJECT:C1216(gui)  // don't use var, as this sets the variable to null

Case of 
	: ($job="init")
		If (Not:C34(OB Is empty:C1297(gui)))
			gui.end()
			DELAY PROCESS:C323(Current process:C322; 60)
		End if 
		gui:=cs:C1710.UI.new()
		gui.begin("example UI")
		gui.button("Push Button"; Formula:C1597(mycallback))
		
		$id2:=gui.button("Noch ein Button"; Formula:C1597(mycallback))
		
	: ($job="deinit")
		If (Not:C34(OB Is empty:C1297(gui)))
			gui.end()
		End if 
		
		
	: ($job="test")
		TRACE:C157
		
		
End case 