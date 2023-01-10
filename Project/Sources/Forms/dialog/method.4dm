Case of 
	: (FORM Event:C1606.code=On Load:K2:1)
		SET TIMER:C645(180)  // add graph point once per 3 seconds
		// normally we would set values based on current status, but
		// this demo was kept simple, we do not used UserData for every object
		// allowing us to read the values by finding the objects generically
		// so let's simply assign default values
		Form:C1466.switch:=0
		Form:C1466.number:=50
		Form:C1466.slider:=50
		Form:C1466.text:="hello"
		
		
	: (FORM Event:C1606.code=On Timer:K2:25)
		If (Form:C1466.gui=Null:C1517)
			CALL WORKER:C1389("GUI_worker"; "GUI_worker"; "init_with_tabs"; New object:C1471; Current form window:C827)
		End if 
		CALL WORKER:C1389("GUI_worker"; "GUI_worker"; "graphpoint")
End case 