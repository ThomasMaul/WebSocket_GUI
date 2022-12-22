//%attributes = {}
#DECLARE($job : Text; $data : Object)
var gui : cs:C1710.UI

Case of 
	: ($job="simple")
		
		gui:=cs:C1710.UI.new()
		$id1:=gui.button("Push Button"; Formula:C1597(mycallback))
		$id4:=gui.number("umsatz"; Formula:C1597(mycallback); gui.controlTypes.Sunflower; 50; 1; 100)
		gui.begin("very simple UI")
		
	: ($job="init")
		$log:=New object:C1471
		If (Not:C34(OB Is empty:C1297(gui)))
			gui.end()
			If (gui.log#Null:C1517)
				$log:=gui.log
			End if 
		End if 
		
		gui:=cs:C1710.UI.new($log)  // to allow to continue using an already existing log
		// we could also open our own log file and pass a 4d.FileHandle
		gui.sliderContinuous:=True:C214
		$id1:=gui.button("Push Button"; Formula:C1597(mycallback))
		$id2:=gui.button("Noch ein Button"; Formula:C1597(mycallback); gui.controlTypes.Emerald)
		$id3:=gui.switcher("Switch"; Formula:C1597(mycallback))
		$id4:=gui.number("umsatz"; Formula:C1597(mycallback); gui.controlTypes.Sunflower; 50; 1; 100)
		$id7:=gui.text("text"; Formula:C1597(mycallback); gui.controlTypes.Sunflower; "hallo")
		gui.addControl(gui.controlTypes.Max; ""; "32"; gui.controlTypes.None; $id7)
		
		gui.separator("pads, labels and slider")
		
		$id8:=gui.pad("pad"; Formula:C1597(mycallback))
		gui.label("Example label"; gui.controlTypes.Sunflower; "label text")
		gui.label("picture label"; gui.controlTypes.Sunflower; "<img src='img/4DGeneric.png'>")
		gui.slider("slider"; Formula:C1597(mycallback); gui.controlTypes.Sunflower; 50; 1; 100)
		
		gui.separator("browser controls, design depends on browser")
		$id9:=gui.text("Date example"; Formula:C1597(mycallback); gui.controlTypes.Sunflower; "2022-12-21")
		gui.setInputType($id9; "date")
		$id10:=gui.text("Time example"; Formula:C1597(mycallback); gui.controlTypes.Sunflower; Time string:C180(Current time:C178))
		gui.setInputType($id10; "time")
		$id11:=gui.text("Color example"; Formula:C1597(mycallback); gui.controlTypes.Sunflower; "#00FFFF")
		gui.setInputType($id11; "color")
		$id12:=gui.text("password example"; Formula:C1597(mycallback); gui.controlTypes.Sunflower; "1234")
		gui.setInputType($id12; "password")
		
		gui.separator("selector")
		$select1:=gui.addControl(gui.controlTypes.Select; "Select Title"; "Option 1"; gui.controlTypes.Sunflower; -1; Formula:C1597(mycallback))
		gui.addControl(gui.controlTypes.Option; "Option1"; "Opt1"; gui.controlTypes.Sunflower; $select1)
		gui.addControl(gui.controlTypes.Option; "Option2"; "Opt2"; gui.controlTypes.Sunflower; $select1)
		gui.addControl(gui.controlTypes.Option; "Option3"; "Opt3"; gui.controlTypes.Sunflower; $select1)
		
		gui.begin("example UI")
		
	: ($job="init_with_tabs")
		$log:=New object:C1471
		If (Not:C34(OB Is empty:C1297(gui)))
			gui.end()
			If (gui.log#Null:C1517)
				$log:=gui.log
			End if 
		End if 
		
		gui:=cs:C1710.UI.new($log)  // to allow to continue using an already existing log
		// we could also open our own log file and pass a 4d.FileHandle
		gui.sliderContinuous:=True:C214
		
		$tab1:=gui.addControl(gui.controlTypes.Tab; "Simple Objects"; "tab1")
		$tab2:=gui.addControl(gui.controlTypes.Tab; "pads, labels and slider"; "tab2")
		$tab3:=gui.addControl(gui.controlTypes.Tab; "Browser Controls"; "tab3")
		$tab4:=gui.addControl(gui.controlTypes.Tab; "More"; "tab4")
		
		// tab group 1
		//$id1:=gui.button("Push Button"; Formula(mycallback))
		$id1:=gui.addControl(gui.controlTypes.Button; "Push Button"; ""; gui.controlTypes.Sunflower; $tab1; Formula:C1597(mycallback_generic))
		//$id2:=gui.button("Noch ein Button"; Formula(mycallback); gui.controlTypes.Emerald)
		$id2:=gui.addControl(gui.controlTypes.Button; "Another Button"; ""; gui.controlTypes.Emerald; $tab1; Formula:C1597(mycallback_generic))
		//$id3:=gui.switcher("Switch"; Formula(mycallback))
		$id3:=gui.addControl(gui.controlTypes.Switcher; "Switch"; ""; gui.controlTypes.Emerald; $tab1; Formula:C1597(mycallback_generic); New object:C1471("job"; "hide"; "control"; $id2))
		gui.setPanelStyle($id3; "background-color: blue;")
		
		//$id4:=gui.number("umsatz"; Formula(mycallback); gui.controlTypes.Sunflower; 50; 1; 100)
		$id4:=gui.addControl(gui.controlTypes.Number; "umsatz"; "50"; gui.controlTypes.Sunflower; $tab1; Formula:C1597(mycallback_generic); New object:C1471("job"; "number"))
		gui.addControl(gui.controlTypes.Max; ""; "100"; gui.controlTypes.None; $id4)
		gui.addControl(gui.controlTypes.Min; ""; "1"; gui.controlTypes.None; $id4)
		//$id7:=gui.text("text"; Formula(mycallback); gui.controlTypes.Sunflower; "hallo")
		$id7:=gui.addControl(gui.controlTypes.Text; "text"; "hallo"; gui.controlTypes.Sunflower; $tab1; Formula:C1597(mycallback_generic))
		gui.addControl(gui.controlTypes.Max; ""; "32"; gui.controlTypes.None; $id7)
		
		// tab group 2
		//$id8:=gui.pad("pad"; Formula(mycallback_generic))
		$id8:=gui.addControl(gui.controlTypes.PadWithCenter; "pad"; ""; gui.controlTypes.Emerald; $tab2; Formula:C1597(mycallback_generic); New object:C1471("job"; "pad"; "control"; $id7))
		//gui.label("Example label"; gui.controlTypes.Sunflower; "label text")
		//gui.label("picture label"; gui.controlTypes.Sunflower; "<img src='img/4DGeneric.png'>")
		gui.addControl(gui.controlTypes.Label; "Example label"; "label text"; gui.controlTypes.Sunflower; $tab2; Formula:C1597(mycallback_generic))
		gui.addControl(gui.controlTypes.Label; "picture label"; "<img src='img/4DGeneric.png'>"; gui.controlTypes.Sunflower; $tab2; Formula:C1597(mycallback_generic))
		//gui.slider("slider"; Formula(mycallback_generic); gui.controlTypes.Sunflower; 50; 1; 100)
		$slider:=gui.addControl(gui.controlTypes.Slider; "slider"; ""; gui.controlTypes.Sunflower; $tab2; Formula:C1597(mycallback_generic))
		gui.addControl(gui.controlTypes.Max; ""; "100"; gui.controlTypes.None; $slider)
		gui.addControl(gui.controlTypes.Min; ""; "1"; gui.controlTypes.None; $slider)
		
		
		
		// tab group 3
		//$id9:=gui.text("Date example"; Formula(mycallback_generic); gui.controlTypes.Sunflower; "2022-12-21")
		$id9:=gui.addControl(gui.controlTypes.Text; "Date example"; String:C10(Current date:C33; ISO date:K1:8); gui.controlTypes.Sunflower; $tab3; Formula:C1597(mycallback_generic))
		gui.setInputType($id9; "date")
		//$id10:=gui.text("Time example"; Formula(mycallback_generic); gui.controlTypes.Sunflower; Time string(Current time))
		$id10:=gui.addControl(gui.controlTypes.Text; "Time example"; Time string:C180(Current time:C178); gui.controlTypes.Sunflower; $tab3; Formula:C1597(mycallback_generic))
		gui.setInputType($id10; "time")
		//$id11:=gui.text("Color example"; Formula(mycallback_generic); gui.controlTypes.Sunflower; "#00FFFF")
		$id11:=gui.addControl(gui.controlTypes.Text; "Color example"; "#00FFFF"; gui.controlTypes.Sunflower; $tab3; Formula:C1597(mycallback_generic))
		gui.setInputType($id11; "color")
		//$id12:=gui.text("password example"; Formula(mycallback_generic); gui.controlTypes.Sunflower; "1234")
		$id12:=gui.addControl(gui.controlTypes.Text; "password example"; "1234"; gui.controlTypes.Sunflower; $tab3; Formula:C1597(mycallback_generic))
		gui.setInputType($id12; "password")
		
		// tab group 4
		$select1:=gui.addControl(gui.controlTypes.Select; "Select example"; "Opt2"; gui.controlTypes.Sunflower; $tab4; Formula:C1597(mycallback))
		gui.addControl(gui.controlTypes.Option; "Option 1"; "Opt1"; gui.controlTypes.Sunflower; $select1)
		gui.addControl(gui.controlTypes.Option; "Option 2"; "Opt2"; gui.controlTypes.Sunflower; $select1)
		gui.addControl(gui.controlTypes.Option; "Option 3"; "Opt3"; gui.controlTypes.Sunflower; $select1)
		
		$slider2:=gui.addControl(gui.controlTypes.Slider; "slider group"; ""; gui.controlTypes.Sunflower; $tab4; Formula:C1597(mycallback_generic))
		gui.setVertical($slider2; True:C214)
		gui.addControl(gui.controlTypes.Max; ""; "100"; gui.controlTypes.None; $slider2)
		gui.addControl(gui.controlTypes.Min; ""; "1"; gui.controlTypes.None; $slider2)
		// add this slider to the same group as the above on
		$slider3:=gui.addControl(gui.controlTypes.Slider; "slider3"; ""; gui.controlTypes.Sunflower; $slider2; Formula:C1597(mycallback_generic))
		gui.setVertical($slider3; True:C214)
		gui.addControl(gui.controlTypes.Max; ""; "100"; gui.controlTypes.None; $slider3)
		gui.addControl(gui.controlTypes.Min; ""; "1"; gui.controlTypes.None; $slider3)
		$slider4:=gui.addControl(gui.controlTypes.Slider; "slider4"; ""; gui.controlTypes.Sunflower; $slider2; Formula:C1597(mycallback_generic))
		gui.setVertical($slider4; True:C214)
		gui.addControl(gui.controlTypes.Max; ""; "100"; gui.controlTypes.None; $slider4)
		gui.addControl(gui.controlTypes.Min; ""; "1"; gui.controlTypes.None; $slider4)
		
		thegraph:=gui.graph("graph example"; gui.controlTypes.Sunflower)
		
		gui.begin("tab example")
		gui_graph_counter:=0
		CALL WORKER:C1389("GUI_worker"; "GUI_worker"; "graph")
		
	: ($job="deinit")
		If (Not:C34(OB Is empty:C1297(gui)))
			gui.end()
		End if 
		
		
	: ($job="graph")
		DELAY PROCESS:C323(Current process:C322; 120)
		gui.addGraphPoint(thegraph; Random:C100%100)
		gui_graph_counter+=1
		If (gui_graph_counter<20)
			CALL WORKER:C1389("GUI_worker"; "GUI_worker"; "graph")
		End if 
		
End case 