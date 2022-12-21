//%attributes = {}
#DECLARE($control : Integer; $type : Integer; $userdata : Object)
If ($userdata#Null:C1517)
	$data:=JSON Stringify:C1217($userdata)
Else 
	$data:=""
End if 
gui.log.writeLine("WS - Control: "+String:C10($control)+", type: "+String:C10($type)+" "+$data)

If ($control=3)
	gui.updateVisibility(2; $type<0)
End if 