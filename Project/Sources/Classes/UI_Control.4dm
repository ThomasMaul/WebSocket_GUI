Class constructor($control_col : Collection; $type : Integer; $label : Text; $callback : 4D:C1709.Function; \
$userdata : Object; $value : Text; $color : Text; $parentControl : Integer; $visible : Boolean)
	This:C1470.type:=$type
	This:C1470.id:=$control_col.max("id")+1
	This:C1470.label:=$label
	This:C1470.callback:=$callback
	This:C1470.user:=$userdata
	This:C1470.value:=$value
	This:C1470.color:=$color  // RGB text?
	This:C1470.parentControl:=$parentControl
	This:C1470.visible:=$visible
	This:C1470.wide:=False:C215
	This:C1470.vertical:=False:C215
	This:C1470.enabled:=True:C214
	This:C1470.panelStyle:=""
	This:C1470.elementStyle:=""
	This:C1470.inputType:=""
	$control.col.push(This:C1470)
	
	
Function SendCallback($type : Integer)
	If (This:C1470.callback#Null:C1517)
		If (This:C1470.user#Null:C1517)
			This:C1470.callback.call(This:C1470.user)
		Else 
			This:C1470.callback.call()
		End if 
	End if 
	
Function DeleteControl()
	//TODO: Missing
	ALERT:C41("missing")
	
Function HasCallback()->$yes : Boolean
	return (This:C1470.callback#Null:C1517)
	
Function HasBeenUpdated()
	//TODO: Missing
	ALERT:C41("missing")
	
Function ToBeDeleted()->$delete : Boolean
	//TODO: Missing
	ALERT:C41("missing")
	
Function IsUpdated()->$update : Boolean
	//TODO: Missing
	ALERT:C41("missing")
	
Function onWSEvent($cmd : Text; $value : Text)
	//TODO: Missing
	ALERT:C41("missing")
	
Function MarshalControl($item : Object; $InUpdateMode : Boolean)
	//TODO: Missing
	ALERT:C41("missing")
	