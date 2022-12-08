Class constructor($control_col : Collection; $controlTypes : Object; $type : Integer; $label : Text; $callback : 4D:C1709.Function; \
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
	This:C1470.ControlSyncState:=0
	This:C1470.controlTypes:=$controlTypes
	$control.col.push(This:C1470)
	
	
Function SendCallback($type : Integer)
	If (This:C1470.callback#Null:C1517)
		This:C1470.callback.call()
	End if 
	
Function DeleteControl()
	This:C1470.ControlSyncState:=2
	This:C1470.callback:=Null:C1517
	
Function HasCallback()->$yes : Boolean
	return (This:C1470.callback#Null:C1517)
	
Function HasBeenUpdated()->$yes : Boolean
	return (This:C1470.ControlSyncState=1)
	
Function ToBeDeleted()->$delete : Boolean
	return (This:C1470.ControlSyncState=2)
	
	
Function IsUpdated()->$update : Boolean
	return (This:C1470.ControlSyncState=0)
	
	
Function onWSEvent($cmd : Text; $value : Text)
	//TODO: Missing
	ALERT:C41("missing")
	
Function MarshalControl($item : Object; $InUpdateMode : Boolean)
	$item.id:=This:C1470.id
	If ($InUpdateMode)
		$item.type:=This:C1470.type+This:C1470.controlTypes.UpdateOffset
	Else 
		$item.type:=This:C1470.type
	End if 
	$item.label:=This:C1470.label
	$item.value:=This:C1470.value
	$item.visible:=This:C1470.visible
	
	
	