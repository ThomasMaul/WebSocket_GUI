//%attributes = {}
#DECLARE($job : Text; $data : Object)
var gui : cs:C1710.UI

Case of 
	: ($job="init")
		$log:=New object:C1471
		If (Not:C34(OB Is empty:C1297(gui)))
			gui.end()
			If (gui.log#Null:C1517)
				$log:=gui.log
			End if 
		End if 
		
		gui:=cs:C1710.UI.new($log)  // to allow to continue using an already existing log
		// we could also open our own log file and pass a 4d.FileHandle
		gui.begin("example UI")
		$id1:=gui.button("Push Button"; Formula:C1597(mycallback))
		$id2:=gui.button("Noch ein Button"; Formula:C1597(mycallback); color RGB aqua)
		$id3:=gui.switcher("Switch"; Formula:C1597(mycallback))
		$id3:=gui.number("umsatz"; Formula:C1597(mycallback); color RGB blue; 50)
		
	: ($job="deinit")
		If (Not:C34(OB Is empty:C1297(gui)))
			gui.end()
		End if 
		
		
	: ($job="test")
		TRACE:C157
		
		
End case 