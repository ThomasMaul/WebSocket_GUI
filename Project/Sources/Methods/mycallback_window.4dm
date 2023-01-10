//%attributes = {}
#DECLARE($gui : cs:C1710.UI; $control : Integer; $type : Integer; $value : Text; $clientID : Integer; $userdata : Object)

// called via CALL FORM from mycallback_generic for Web Socket Events, if a window is defined

Case of 
	: (String:C10($userdata.job)="number")  // number
		// validate the number, check range, etc, then confirm and set
		$num:=Num:C11($value)
		Case of 
			: ($num<1)
				$num:=1
			: ($num>100)
				$num:=100
		End case 
		Form:C1466.number:=$num
		
	: (String:C10($userdata.name)="slider")  // number
		// validate the number, check range, etc, then confirm and set
		$num:=Num:C11($value)
		Case of 
			: ($num<1)
				$num:=1
			: ($num>100)
				$num:=100
		End case 
		Form:C1466.slider:=$num
		
	: (String:C10($userdata.job)="text")
		Form:C1466.text:=$value
		
	: (String:C10($userdata.job)="hide")  // this is the switch!
		Form:C1466.switch:=Num:C11($type<0)
End case 