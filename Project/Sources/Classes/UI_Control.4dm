Class constructor($control_col : Collection; $ui : Object; $type : Integer; $label : Text; \
$value : Text; $color : Integer; $parentControl : Integer; $callback : 4D:C1709.Function; $userdata : Object)
	This:C1470.type:=$type
	This:C1470.id:=Num:C11($control_col.max("id"))+1
	This:C1470.label:=$label
	This:C1470.callback:=$callback
	This:C1470.user:=$userdata
	This:C1470.value:=$value
	This:C1470.color:=$color  // RGB text?
	This:C1470.parentControl:=$parentControl
	This:C1470.visible:=True:C214
	This:C1470.wide:=False:C215
	This:C1470.vertical:=False:C215
	This:C1470.enabled:=True:C214
	This:C1470.panelStyle:=""
	This:C1470.elementStyle:=""
	This:C1470.inputType:=""
	This:C1470.ControlSyncState:=0
	This:C1470.UI:=$ui
	This:C1470.controlTypes:=This:C1470.UI.controlTypes
	$control_col.push(This:C1470)
	
	
Function SendCallback($type : Integer)
	If (This:C1470.callback#Null:C1517)
		If (This:C1470.user#Null:C1517)
			This:C1470.callback.call(Null:C1517; This:C1470.id; $Type; This:C1470.user)
		Else 
			This:C1470.callback.call(Null:C1517; This:C1470.id; $Type)
		End if 
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
	$item.color:=This:C1470.color
	$item.enabled:=This:C1470.enabled
	If (This:C1470.panelStyle#"")
		$item.panelStyle:=$This.panelStyle
	End if 
	If (This:C1470.elementStyle#"")
		$item.elementStyle:=$This.elementStyle
	End if 
	If (This:C1470.inputType#"")
		$item.inputType:=$This.inputType
	End if 
	If (This:C1470.wide)
		$item.wide:=True:C214
	End if 
	If (This:C1470.vertical)
		$item.vertical:=True:C214
	End if 
	If (This:C1470.parentControl#0)
		$item.parentControl:=($This.parentControl)
	End if 
	
	// special case for selects: to preselect an option, you have to add
	// "selected" to <option>
	If (This:C1470.type=This:C1470.controlTypes.Option)
		$parent:=This:C1470.UI.getControl(This:C1470.parentControl)
		If ($parent=Null:C1517)
			$item.selected:=""
		Else 
			If ($parent.value=This:C1470.value)
				$item.selected:="selected"
			Else 
				$item.selected:=""
			End if 
		End if 
	End if 
	
Function onWSEvent($cmd : Text; $data : Text)
	//This.UI.log.writeLine(Timestamp+Char(9)+"debug: ID: "+String(This.id)+" value "+$data)
	If (Not:C34(This:C1470.HasCallback()))
		If (This:C1470.verbosity)
			This:C1470.UI.log.writeLine(Timestamp:C1445+Char:C90(9)+"Control::onWsEvent:No callback found for ID  "+String:C10(This:C1470.id))
		End if 
		return 
	End if 
	
	Case of 
		: ($cmd="bdown")
			This:C1470.SendCallback(This:C1470.controlTypes.B_DOWN)
		: ($cmd="bup")
			This:C1470.SendCallback(This:C1470.controlTypes.B_UP)
		: ($cmd="pfdown")
			This:C1470.SendCallback(This:C1470.controlTypes.P_FOR_DOWN)
		: ($cmd="pfup")
			This:C1470.SendCallback(This:C1470.controlTypes.P_FOR_UP)
		: ($cmd="pldown")
			This:C1470.SendCallback(This:C1470.controlTypes.P_LEFT_DOWN)
		: ($cmd="plup")
			This:C1470.SendCallback(This:C1470.controlTypes.P_LEFT_UP)
		: ($cmd="prdown")
			This:C1470.SendCallback(This:C1470.controlTypes.P_RIGHT_DOWN)
		: ($cmd="prup")
			This:C1470.SendCallback(This:C1470.controlTypes.P_RIGHT_UP)
		: ($cmd="pbdown")
			This:C1470.SendCallback(This:C1470.controlTypes.P_BACK_DOWN)
		: ($cmd="pbup")
			This:C1470.SendCallback(This:C1470.controlTypes.P_BACK_UP)
		: ($cmd="pcdown")
			This:C1470.SendCallback(This:C1470.controlTypes.P_CENTER_DOWN)
		: ($cmd="pcup")
			This:C1470.SendCallback(This:C1470.controlTypes.P_CENTER_UP)
		: ($cmd="sactive")
			This:C1470.value:="1"
			This:C1470.SendCallback(This:C1470.controlTypes.S_ACTIVE)
		: ($cmd="sinactive")
			This:C1470.value:="0"
			This:C1470.SendCallback(This:C1470.controlTypes.S_INACTIVE)
		: ($cmd="slvalue")
			This:C1470.value:=$data
			This:C1470.SendCallback(This:C1470.controlTypes.SL_VALUE)
		: ($cmd="nvalue")
			This:C1470.value:=$data
			This:C1470.SendCallback(This:C1470.controlTypes.N_VALUE)
		: ($cmd="tvalue")
			This:C1470.value:=$data
			This:C1470.SendCallback(This:C1470.controlTypes.T_VALUE)
		: ($cmd="tabvalue")
			This:C1470.SendCallback(0)
		: ($cmd="svalue")
			This:C1470.value:=$data
			This:C1470.SendCallback(This:C1470.controlTypes.S_VALUE)
		: ($cmd="time")
			This:C1470.value:=$data
			This:C1470.SendCallback(This:C1470.controlTypes.TM_VALUE)
			
		Else 
			If (This:C1470.verbosity)
				This:C1470.UI.log.writeLine(Timestamp:C1445+Char:C90(9)+"Control::onWsEvent:Malformed message from the websocket: "+String:C10($cmd))
			End if 
			
	End case 
	
	