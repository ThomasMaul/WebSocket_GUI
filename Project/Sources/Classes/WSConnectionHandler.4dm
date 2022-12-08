Class constructor
	This:C1470.UI_Id:=-1
	This:C1470.WS_ID:=-1
	This:C1470.wss:=Null:C1517
	This:C1470.ws:=Null:C1517
	This:C1470.ClientUpdateType:=0
	
Function onOpen($WS : 4D:C1709.WebSocketConnection; $para : Object)
	var $ui : cs:C1710.UI
	This:C1470.wss:=$WS.wss
	$ui:=$WS.wss.handler.UI
	This:C1470.UI_Id:=$ui.onWSEvent($WS.wss; $WS; "open"; $para)
	This:C1470.WS_ID:=$WS.id
	If (This:C1470.verbosity)
		This:C1470.log.writeLine("WS Client Connect ID: "+String:C10(This:C1470.UI_Id))
	End if 
	
	
Function onMessage($WS : 4D:C1709.WebSocketConnection; $para : Object)
	var $msg; $cmd; $value : Text
	var $id : Integer
	$msg:=String:C10($para.data)
	$parts:=Split string:C1554($msg; ":")
	If ($parts.length#3)
		return 
	End if 
	
	$cmd:=$parts[0]
	$value:=$parts[1]
	$id:=Num:C11($parts[3])
	
	If (This:C1470.verbosity)
		This:C1470.log.writeLine("WS msg "+$msg)
		This:C1470.log.writeLine("WS cmd "+$cmd)
		This:C1470.log.writeLine("WS id "+String:C10($id))
		This:C1470.log.writeLine("WS value "+$value)
	End if 
	
	If ($cmd="uiok")
		This:C1470.UI_NotifyClient($id)
		return 
	End if 
	If ($cmd="uiuok")
		return 
	End if 
	var $ui : cs:C1710.UI
	$ui:=$WS.wss.handler.UI
	var $control : cs:C1710.UI_Control
	$control:=$ui.getControl($id)
	If ($control=Null:C1517)
		If (This:C1470.verbosity)
			This:C1470.log.writeLine("Error: WS Event: There is no control with ID: "+String:C10($Id))
		End if 
		return 
	Else 
		$control.onWSEvent($cmd; $value)
	End if 
	
Function onTerminate($WS : 4D:C1709.WebSocketConnection; $para : Object)
	var $ui : cs:C1710.UI
	$ui:=$WS.wss.handler.UI
	$ui.onWSEvent($WS.wss; $WS; "terminate"; $para)
	This:C1470.UI_Id:=-1
	
Function onError($WS : 4D:C1709.WebSocketConnection; $para : Object)
	If (This:C1470.verbosity)
		This:C1470.log.writeLine("Error: WS Connection Error "+String:C10($para.status.HTTPError))
	End if 
	
	/// ######## functions from ESPUIclient.cpp
	
Function UI_canSend()->$response : Boolean
	If (This:C1470.UI_Id>0)
		return True:C214
	End if 
	
Function UI_FillInHeader($json : Object)
	var $ui : cs:C1710.UI
	$ui:=This:C1470.wss.handler.UI
	$json.type:=$ui.controlTypes.ExtendGUI
	$json.sliderContinuous:=$ui.sliderContinuous
	$json.startindex:=0
	$json.totalcontrols:=This:C1470.wss.connections.length
	$json.controls:=New collection:C1472(New object:C1471("type"; $ui.controlTypes.Title; "label"; $ui.ui_title))
	
Function UI_IsSyncronized()->$return : Boolean
	return (This:C1470.ClientUpdateType=0)  //   Synchronized    = 0,
	
Function UI_SendClientNotification($type : Integer)->$return : Boolean
	var $ui : cs:C1710.UI
	$ui:=This:C1470.wss.handler.UI
	
	$json:=New object:C1471
	This:C1470.UI_FillInHeader($json)
	If ($type=$ui.controlTypes.ReloadNeeded)
		$json.type:=$ui.controlTypes.Reload
	End if 
	return This:C1470.UI_SendJsonDocToWebSocket($json)
	
Function UI_NotifyClient($type : Integer)->$return : Boolean
	return This:C1470.UI_SendClientNotification($type)
	
/*
Prepare a chunk of elements as a single JSON string. If the allowed number of elements is greater than the total
number this will represent the entire UI. More likely, it will represent a small section of the UI to be sent. The
client will acknowledge receipt by requesting the next chunk.
 */
	
Function UI_prepareJSONChunk($startindex : Integer; $json : Object; $InUpdateMode : Boolean)->$count : Integer
	var $ui : cs:C1710.UI
	$ui:=This:C1470.wss.handler.UI
	var $control : cs:C1710.UI_Control
	$elementcount:=0
	$currentIndex:=0
	$json:=New object:C1471("controls"; New collection:C1472())
	
	// wir müssen startindex ermitteln, ohne active, nicht mit for each!!!!
	While (($startindex>$currentindex) && ($currentindex<$ui.controls.length))
		$control:=$ui.controls[$currentindex]
		If (Not:C34($control.ToBeDeleted()))
			If ($InUpdateMode)
				// In update mode we only count the controls that have been updated.
				If ($control.IsUpdated())
					$currentIndex+=1
				End if 
			Else 
				// not in update mode. Count all active controls
				$currentIndex+=1
			End if 
		End if 
	End while 
	
	While ($currentindex<$ui.controls.length)
		$control:=$ui.controls[$currentindex]
		
		If ($control.ToBeDeleted())
			$currentindex+=1
			continue
		End if 
		If ($InUpdateMode)
			If (Not:C34($control.IsUpdated()))
				$currentindex+=1
				continue
			End if 
		End if 
		
		$item:=New object:C1471
		$elementcount+=1
		$control.MarshalControl($item; $InUpdateMode)
		$json.controls.push($item)
		$text:=JSON Stringify:C1217($json)
		If (Length:C16($text)>2000)  // overflow, chunk
			If ($elementcount=1)  // first element?
				// just send it
			Else 
				$json.controls.pop()
				$elementcount-=1
			End if 
			break
		Else 
			$currentindex+=1  // next
		End if 
	End while 
	
	return $elementcount
	
/*
Convert & Transfer Arduino elements to JSON elements. This function sends a chunk of
JSON describing the controls of the UI, starting from the control at index startidx.
If startidx is 0 then a UI_INITIAL_GUI message will be sent, else a UI_EXTEND_GUI.
Both message types contain a list of serialised UI elements. Only a portion of the UI
will be sent in order to avoid websocket buffer overflows. The client will acknowledge
receipt of a partial message by requesting the next chunk of UI.
	
The protocol is:
SERVER: SendControlsToClient(0):
    "UI_INITIAL_GUI: n serialised UI elements"
CLIENT: controls.js:handleEvent()
    "uiok:n"
SERVER: SendControlsToClient(n):
    "UI_EXTEND_GUI: n serialised UI elements"
CLIENT: controls.js:handleEvent()
    "uiok:2*n"
etc.
    Returns true if all controls have been sent (aka: Done)
*/
Function UI_SendControlsToClient($startidx : Integer; $TransferMode : Integer)->$response : Boolean
	$response:=False:C215
	var $ui : cs:C1710.UI
	$ui:=This:C1470.wss.handler.UI
	If ($startidx>=$ui.controls.length)
		return True:C214
	End if 
	
	$json:=New object:C1471
	This:C1470.UI_FillInHeader($json)
	$json.startindex:=$startidx
	$json.totalcontrols:=65534
	
	If ($startidx=0)
		$json.type:=($TransferMode=$ui.controlTypes.RebuildNeeded) ? $ui.controlTypes.InitialGui : $ui.controlTypes.ExtendGUI
	End if 
	If (This:C1470.UI_prepareJSONChunk($startidx; $json; $TransferMode=$ui.controlTypes.UpdateNeeded))
		If (This:C1470.verbosity)
			This:C1470.log.writeLine("SendControlsToClient: Sending Elements")
			This:C1470.log.writeLine(JSON Stringify:C1217($json))
		End if 
		This:C1470.UI_SendJsonDocToWebSocket($json)
	Else 
		$response:=True:C214
	End if 
	
Function UI_SendJsonDocToWebSocket($json : Object)->$response : Boolean
	$response:=True:C214
	var $ws : cs:C1710.WSConnectionHandler
	For each ($ws_connection; This:C1470.wss.connections)
		If ($ws_connection.id=This:C1470.WS_ID)
			$ws_connection.send($json)
		End if 
	End for each 
	
	
Function UI_SetState($value : Integer)
	If (This:C1470.ClientUpdateType<$value)
		This:C1470.ClientUpdateType:=$value
	End if 
	