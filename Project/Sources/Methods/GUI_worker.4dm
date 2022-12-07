//%attributes = {}
#DECLARE($job : Text; $data : Object)

Case of 
	: ($job="init")
		gui:=cs:C1710.UI.new()
		gui.begin("example UI")
		gui.button("Push Button"; Formula:C1597(ALERT:C41("hello")); 1; "Press")
		
		
		
End case 