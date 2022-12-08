Class constructor()
	This:C1470.verbosity:=True:C214
	If (This:C1470.verbosity)
		This:C1470.log:=Folder:C1567(fk logs folder:K87:17).file("UIClasslog.txt").open("write")
	End if 
	//This.jsonUpdateDocumentSize:=2000
	//This.jsonInitialDocumentSize:=8000
	This:C1470.sliderContinuous:=False:C215
	This:C1470.controls:=New collection:C1472
	This:C1470.controlTypes:=This:C1470.Constants()
	
	This:C1470.ws:=Null:C1517
	This:C1470.clientcounter:=0
	This:C1470.clients:=New collection:C1472
	This:C1470.ui_title:="4DUI"
	
	
	
Function begin($title : Text)
	If ($title#"")
		This:C1470.ui_title:=$title
	End if 
	var $handler : cs:C1710.WSSHandler
	$handler:=cs:C1710.WSSHandler.new(This:C1470)
	This:C1470.ws:=4D:C1709.WebSocketServer.new($handler; New object:C1471("path"; "/ws"))
	If (This:C1470.verbosity)
		This:C1470.log.writeLine("UI Initialized")
	End if 
	
Function onWSEvent($WS : Object; $client : Object; $event : Text; $arg : Object)->$ID : Integer
	This:C1470.RemoveToBeDeletedControls()
	If ($event="open")
		This:C1470.clientcounter:=This:C1470.clientcounter+1
		$ID:=This:C1470.clientcounter
	End if 
	
Function NotifyClients($state : Integer)
	//TODO:fehlt noch
	ALERT:C41("fehlt")
	
Function addControl($type : Integer; $label : Text; $callback : 4D:C1709.Function; \
$userdata : Object; $value : Text; $color : Integer; $parentControl : Integer; $visible : Boolean)->$controlid : Integer
	
	$control:=cs:C1710.UI_Control.new(This:C1470.controls; This:C1470.controlTypes; Copy parameters:C1790)
	This:C1470.NotifyClients(This:C1470.controlTypes.RebuildNeeded)
	$controlid:=$control.id
	
Function removeControl($controlid : Integer; $forcereload : Boolean)->$bool : Boolean
	$index:=This:C1470.controls.findIndex(Formula:C1597($1.value.id=$2); $controlid)
	If ($index>=0)
		//This.controls.remove($index)
		This:C1470.controls[$index].DeleteControl()
		If ($forcereload)
			//MARK:originally jsonReload, using .second??
			This:C1470.NotifyClients(This:C1470.controlTypes.RebuildNeeded)
		Else 
			This:C1470.NotifyClients(This:C1470.controlTypes.RebuildNeeded)
		End if 
		return True:C214
	Else 
		return False:C215
	End if 
	
Function RemoveToBeDeletedControls()
	var $control : cs:C1710.UI_Control
	For ($index; This:C1470.controls.length-1; 0; -1)
		If (This:C1470.controls[$index].ToBeDeleted())
			This:C1470.controls.remove($index)
		End if 
	End for 
	
	// all the possible controls ...
Function label($label : Text; $color : Integer; $value : Text)->$id : Integer
	return This:C1470.addControl(This:C1470.controlTypes.Label; $label; $value; $color)
	
Function graph($label : Text; $color : Integer)->$id : Integer
	return This:C1470.addControl(This:C1470.controlTypes.Graph; $label; ""; $color)
	
Function slider($label : Text; $callback : 4D:C1709.Function; $color : Integer; $value : Text; $min : Integer; $max : Integer; $userData : Object)->$id : Integer
	$id:=This:C1470.addControl(This:C1470.controlTypes.Slider; $label; $value; $color; -1; $callback; $userData)
	$id2:=This:C1470.addControl(This:C1470.controlTypes.Min; $label; String:C10($Min); 0x00FF; $Id)
	$id2:=This:C1470.addControl(This:C1470.controlTypes.Max; $label; String:C10($max); 0x00FF; $Id)
	return $id
	
Function button($label : Text; $callback : 4D:C1709.Function; $color : Integer; $value : Text; $userData : Object)->$id : Integer
	return This:C1470.addControl(This:C1470.controlTypes.Button; $label; $value; $color; -1; $callback; $userData)
	
Function switcher($label : Text; $callback : 4D:C1709.Function; $color : Integer; $startState : Boolean; $userData : Object)->$id : Integer
	return This:C1470.addControl(This:C1470.controlTypes.Switcher; $label; $startState ? "1" : "0"; $color; -1; $callback; $userData)
	
Function pad($label : Text; $callback : 4D:C1709.Function; $color : Integer; $userData : Object)->$id : Integer
	return This:C1470.addControl(This:C1470.controlTypes.Pad; $label; ""; $color; -1; $callback; $userData)
	
Function padWithCenter($label : Text; $callback : 4D:C1709.Function; $color : Integer; $userData : Object)->$id : Integer
	return This:C1470.addControl(This:C1470.controlTypes.PadWithCenter; $label; ""; $color; -1; $callback; $userData)
	
Function number($label : Text; $callback : 4D:C1709.Function; $color : Integer; $value : Integer; $min : Integer; $max : Integer; $userData : Object)->$id : Integer
	$id:=This:C1470.addControl(This:C1470.controlTypes.Number; $label; String:C10($value); $color; -1; $callback; $userData)
	$id2:=This:C1470.addControl(This:C1470.controlTypes.Min; $label; String:C10($Min); 0x00FF; $Id)
	$id2:=This:C1470.addControl(This:C1470.controlTypes.Max; $label; String:C10($max); 0x00FF; $Id)
	return $id
	
Function gauge($label : Text; $callback : 4D:C1709.Function; $color : Integer; $value : Integer; $min : Integer; $max : Integer; $userData : Object)->$id : Integer
	$id:=This:C1470.addControl(This:C1470.controlTypes.Gauge; $label; String:C10($value); $color; -1; $callback; $userData)
	$id2:=This:C1470.addControl(This:C1470.controlTypes.Min; $label; String:C10($Min); 0x00FF; $Id)
	$id2:=This:C1470.addControl(This:C1470.controlTypes.Max; $label; String:C10($max); 0x00FF; $Id)
	return $id
	
Function separator($label : Text)->$id : Integer
	return This:C1470.addControl(This:C1470.controlTypes.Separator; $label; $value; 7/* Alizarin */; -1)
	
Function accelerometer($label : Text; $callback : 4D:C1709.Function; $color : Integer; $userData : Object)->$id : Integer
	return This:C1470.addControl(This:C1470.controlTypes.Accel; $label; ""; $color; -1; $callback; $userData)
	
Function text($label : Text; $callback : 4D:C1709.Function; $color : Integer; $value : Text; $userData : Object)->$id : Integer
	return This:C1470.addControl(This:C1470.controlTypes.Text; $label; $value; $color; -1; $callback; $userData)
	
	// end control definition
	
Function getControl($id : Integer)->$control : cs:C1710.UI_Control
	This:C1470.controls.query("id=:1"; $id)
	If (This:C1470.controls.length=0)
		return Null:C1517
	Else 
		return This:C1470.controls[0]
	End if 
	
Function updateControl($thecontrol : Variant; $clientId : Integer)
	var $control : cs:C1710.UI_Control
	var $controlid : Integer
	
	Case of 
		: (Value type:C1509($thecontrol)=Is longint:K8:6)
			$controlid:=$thecontrol
			$control:=This:C1470.getControl($controlid)
		: (Value type:C1509($thecontrol)=Is object:K8:27)
			$control:=$thecontrol
		Else 
			If (This:C1470.verbosity)
				This:C1470.log.writeLine("Error: Update Control: There is no control with ID: "+String:C10($clientId))
			End if 
			return 
	End case 
	
	$control.HasBeenUpdated()
	This:C1470.NotifyClients(This:C1470.controlTypes.UpdateNeeded)
	
	
Function setPanelStyle($id : Integer; $style : Text; $clientid : Integer)
	var $control : cs:C1710.UI_Control
	$control:=This:C1470.getControl($id)
	If ($control#Null:C1517)
		$control.panelStyle:=$style
		This:C1470.updateControl($control; $clientid)
	End if 
	
Function setElementStyle($id : Integer; $style : Text; $clientid : Integer)
	var $control : cs:C1710.UI_Control
	$control:=This:C1470.getControl($id)
	If ($control#Null:C1517)
		$control.elementStyle:=$style
		This:C1470.updateControl($control; $clientid)
	End if 
	
Function setInputType($id : Integer; $type : Text; $clientid : Integer)
	var $control : cs:C1710.UI_Control
	$control:=This:C1470.getControl($id)
	If ($control#Null:C1517)
		$control.inputType:=$type
		This:C1470.updateControl($control; $clientid)
	End if 
	
Function setPanelWide($id : Integer; $wide : Boolean)
	var $control : cs:C1710.UI_Control
	$control:=This:C1470.getControl($id)
	If ($control#Null:C1517)
		$control.wide:=$wide
	End if 
	
Function setEnabled($id : Integer; $enabled : Boolean; $clientid : Integer)
	var $control : cs:C1710.UI_Control
	$control:=This:C1470.getControl($id)
	If ($control#Null:C1517)
		$control.enabled:=$enabled
		This:C1470.updateControl($control; $clientid)
	End if 
	
Function setVertical($id : Integer; $vert : Boolean)
	var $control : cs:C1710.UI_Control
	$control:=This:C1470.getControl($id)
	If ($control#Null:C1517)
		$control.vertical:=$vert
	End if 
	
Function updateControlValue($thecontrol : Variant; $value : Text; $clientId : Integer)
	var $control : cs:C1710.UI_Control
	var $controlid : Integer
	
	Case of 
		: (Value type:C1509($thecontrol)=Is longint:K8:6)
			$controlid:=$thecontrol
			$control:=This:C1470.getControl($controlid)
		: (Value type:C1509($thecontrol)=Is object:K8:27)
			$control:=$thecontrol
		Else 
			If (This:C1470.verbosity)
				This:C1470.log.writeLine("Error: updateControlValue Control: There is no control with ID: "+String:C10($clientId))
			End if 
			return 
	End case 
	If ($control#Null:C1517)
		If (Count parameters:C259=2)
			$clientid:=-1
		End if 
		$control.value:=$value
		This:C1470.updateControl($control; $clientid)
	End if 
	
Function updateVisibility($id : Integer; $visibility : Boolean; $clientid : Integer)
	var $control : cs:C1710.UI_Control
	$control:=This:C1470.getControl($id)
	If ($control#Null:C1517)
		$control.visible:=$visibility
		This:C1470.updateControl($control; $clientid)
	End if 
	
Function print($id : Integer; $value : Text)
	This:C1470.updateControlValue($id; $value)
	
Function updateLabel($id : Integer; $value : Text)
	This:C1470.updateControlValue($id; $value)
	
Function updateButton($id : Integer; $value : Text)
	This:C1470.updateControlValue($id; $value)
	
Function updateSlider($id : Integer; $value : Integer; $clientid : Integer)
	This:C1470.updateControlValue($id; String:C10($value); $clientid)
	
Function updateSwitcher($id : Integer; $value : Boolean; $clientid : Integer)
	This:C1470.updateControlValue($id; $value ? "1" : "0"; $clientid)
	
Function updateNumber($id : Integer; $value : Integer; $clientid : Integer)
	This:C1470.updateControlValue($id; String:C10($value); $clientid)
	
Function updateText($id : Integer; $value : Text; $clientid : Integer)
	This:C1470.updateControlValue($id; $value; $clientid)
	
Function updateSelect($id : Integer; $value : Text; $clientid : Integer)
	This:C1470.updateControlValue($id; $value; $clientid)
	
Function updateGauge($id : Integer; $value : Integer; $clientid : Integer)
	This:C1470.updateControlValue($id; String:C10($value); $clientid)
	
Function updateTime($id : Integer; $clientid : Integer)
	This:C1470.updateControl($id; $clientid)
	
Function clearGraph($id : Integer; $clientid : Integer)
	$control:=This:C1470.getControl($controlid)
	
	If (($control=Null:C1517) | (This:C1470.ws=Null:C1517))
		return 
	End if 
	
	$root:=New object:C1471
	$root.type:=This:C1470.controlTypes.Graph+This:C1470.controlTypes.UpdateOffset
	$root.value:=0
	$root.id:=$control.id
	
	This:C1470.SendJsonDocToWebSocket($root; $clientId)
	
	
Function addGraphPoint($id : Integer; $value : Integer; $clientid : Integer)
	$control:=This:C1470.getControl($controlid)
	
	If (($control=Null:C1517) | (This:C1470.ws=Null:C1517))
		return 
	End if 
	
	$root:=New object:C1471
	$root.type:=This:C1470.controlTypes.GraphPoint
	$root.value:=$value
	$root.id:=$control.id
	
	This:C1470.SendJsonDocToWebSocket($root; $clientId)
	
	
Function SendJsonDocToWebSocket($root : Object; $clientid : Integer)->$response : Boolean
	$response:=False:C215
	//TODO:missing
	ALERT:C41("missing")
	
Function jsonDom($startidx : Integer; $client : Object)
	This:C1470.NotifyClients(This:C1470.controlTypes.RebuildNeeded)
	
	
	
	
Function Constants()->$ControlTypes
	$ControlTypes:=New object:C1471
	$controlTypes.Title:=0
	$controlTypes.Pad:=1
	$controlTypes.PadWithCenter:=2
	$controlTypes.Button:=3
	$controlTypes.Label:=4
	$controlTypes.Switcher:=5
	$controlTypes.Slider:=6
	$controlTypes.Number:=7
	$controlTypes.Text:=8
	$controlTypes.Graph:=9
	$controlTypes.GraphPoint:=10
	$controlTypes.Tab:=11
	$controlTypes.Select:=12
	$controlTypes.Option:=13
	$controlTypes.Min:=14
	$controlTypes.Max:=15
	$controlTypes.Step:=16
	$controlTypes.Gauge:=17
	$controlTypes.Accel:=18
	$controlTypes.Separator:=19
	$controlTypes.Time:=20
	
	$controlTypes.UpdateOffset:=100
	
	$controlTypes.UpdatePad:=101
	$controlTypes.UpdatePadWithCenter:=102
	$controlTypes.ButtonButton:=103
	$controlTypes.UpdateLabel:=104
	$controlTypes.UpdateSwitcher:=105
	$controlTypes.UpdateSlider:=106
	$controlTypes.UpdateNumber:=107
	$controlTypes.UpdateText:=108
	$controlTypes.ClearGraph:=109
	$controlTypes.UpdateTab:=110
	$controlTypes.UpdateSelection:=111
	$controlTypes.UpdateOption:=112
	$controlTypes.UpdateMin:=113
	$controlTypes.UpdateMax:=114
	$controlTypes.UpdateStep:=115
	$controlTypes.UpdateGauge:=116
	$controlTypes.UpdateAccel:=117
	$controlTypes.UpdateSeparator:=118
	$controlTypes.UpdateTime:=119
	
	$controlTypes.InitialGui:=200
	$controlTypes.Reload:=201
	$controlTypes.ExtendGUI:=210
	
	$controlTypes.Synchronized:=0
	$controlTypes.UpdateNeeded:=1
	$controlTypes.RebuildNeeded:=2
	$controlTypes.ReloadNeeded:=3
	