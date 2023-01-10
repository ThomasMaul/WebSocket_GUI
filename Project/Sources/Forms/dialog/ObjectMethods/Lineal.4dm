// modify control number
// find control by title?
$controls:=Form:C1466.gui.FindControlByUserData("name"; "slider")
For each ($control; $controls)
	CALL WORKER:C1389("GUI_worker"; "GUI_worker"; "updateControl"; New object:C1471("id"; $control.id; "value"; String:C10(Form:C1466.slider)))
End for each 