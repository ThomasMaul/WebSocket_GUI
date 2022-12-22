//%attributes = {}
#DECLARE($control : Integer; $type : Integer; $value : Text; $clientID : Integer; $userdata : Object)
If ($userdata#Null:C1517)
	$data:=JSON Stringify:C1217($userdata)
Else 
	$data:=""
End if 

Case of 
	: ($control=3)  // switch, hide button 2
		gui.updateVisibility(2; $type<0)
		
	: ($control=4)  // number
		// validate the number, check range, etc, then confirm and send to all other clients
		$num:=Num:C11($value)
		Case of 
			: ($num<1)
				$num:=1
				gui.updateNumber($control; $num; 0)
			: ($num>100)
				$num:=100
				gui.updateNumber($control; $num; 0)
			Else 
				gui.updateNumber($control; $num; -$clientID)
		End case 
		
	: ($control=10)  // pad
		// any click in the pad goes into the text field - for all clients
		gui.updateText(7; String:C10($type); 0)
		
	: ($type=gui.controlTypes.T_VALUE)  // any text, this includes date, time, color, password
		// accept any entry and send to all other clients
		gui.updateText($control; $value; -$clientID)
		
	: ($type=gui.controlTypes.SL_VALUE)  // slider
		// accept any entry and send to all other clients
		gui.updateSlider($control; Num:C11($value); -$clientID)
		
	: ($type=gui.controlTypes.S_VALUE)  // select
		// accept any entry and send to all other clients
		gui.updateSelect($control; $value; -$clientID)
End case 