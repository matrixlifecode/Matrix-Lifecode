B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=9.3
@EndOfDesignText@
Sub Class_Globals
	Private Root As B4XView 'ignore
	Private xui As XUI 'ignore
	Private homepage As B4XMainPage
	#if b4j
		Private zimage As ZoomImageView
	#Else
		Private zimage As ScaleImageView
'		Private Panel1 As Panel
'		Private gestures As GestureDetector
	#End If
	
	Private btnback As Button
	Private btnvor As Button
	Private aktuellesbild As Int
	Private imedien() As String = Array As String("sternzeichenchart.png","elementechart.png","hdtore.jpg","zaehneundplaneten.jpg")
	#if b4a
		Private rp As RuntimePermissions
		Private pnlNavigation As Panel
		Dim imagex As Int
		Dim imagey As Int
		Dim dlg As B4XDialog
	#End If
End Sub

'You can add more parameters here.
Public Sub Initialize As Object
	Return Me
End Sub

'This event will be called once, before the page becomes visible.
Private Sub B4XPage_Created (Root1 As B4XView)
	Root = Root1
	'load the layout to Root
	Root.LoadLayout("zoomimage")
	homepage = B4XPages.GetPage("MainPage")  'Verweis auf Startseite um auf edtbody zuzugreifen
	
	#if b4j
		Dim F As Form = B4XPages.GetNativeParent(Me)
		F.WindowWidth = 640
		F.WindowHeight= 800
	#Else
		'gestures.SetOnGestureListener(Panel1, "Panel1") 'Braucht gestures-lib für weitere Möglichkeiten
		zimage.Orientation = zimage.ORIENTATION_0
		zimage.MaxZoom = 5.0
		zimage.SetScaleAndCenter(1,0.5,0.5, 1)
		dlg.Initialize(Root)
	#end if
	
End Sub

private Sub B4XPage_Appear
	homepage.setTitelzeile(homepage.translate(Main.sprache,5))
	aktuellesbild=0
	#if b4j
		zimage.SetBitmap(xui.LoadBitmap(File.DirData("heilsystem"), "bodygraphexakt.png"))
	#else
		zimage.Image = xui.LoadBitmap(rp.GetSafeDirDefaultExternal(""), "bodygraphexakt.png")
	#end if
	If aktuellesbild = 0 Then btnback.Visible = False
	If aktuellesbild <> 0 Then
		#if b4j
			zimage.SetBitmap(xui.LoadBitmap("../files/",imedien(aktuellesbild-1)))
		#else
			zimage.Image = xui.LoadBitmap(File.DirAssets,imedien(aktuellesbild-1))
			'zimage.SetScaleAndCenter(1,0.5, 0.5, 1)
		#end if
	End If
End Sub

#if b4j
Sub zimage_Click
	homepage.idsternzeichen = 0		'Wird zur Steuerung in clvWichtig verwendet
	homepage.statusTransit=False
	B4XPages.ShowPage("clvWichtig")
#else
Sub zimage_Click 'The user has tapped on the view. Use ClickImage or ClickView for the coordinates.
	If aktuellesbild <> 0 Then Return
	Dim siv As ScaleImageView = Sender
	' Save the view and image coordinates of the point clicked.
	imagex =  siv.ClickImageX
	imagey =  siv.ClickImageY
	siv.Invalidate ' draw the new position
	'Dim msg As String = "imageX=" & imagex & " imageY=" & imagey
	'ToastMessageShow(msg, False)
	Dim linkeSpaltevorhanden As Boolean
	If homepage.edtBody.SelectedIndex = 0 Or homepage.edtBody.SelectedIndex = 3 Or homepage.edtBody.SelectedIndex = 4 Then linkeSpaltevorhanden=True

	Select True
		Case imagex > 249 And imagex < 388 And imagey > 0 And imagey < 124: showDetailZentrum(7)'z7
		Case imagex > 249 And imagex < 388 And imagey > 172 And imagey < 280: showDetailZentrum(6)'z6
		Case imagex > 249 And imagex < 388 And imagey > 320 And imagey < 451: showDetailZentrum(5)'z5
		Case imagex > 375 And imagex < 521 And imagey > 594 And imagey < 674: showDetailZentrum(4)'z4
		Case imagex > 508 And imagex < 752 And imagey > 691 And imagey < 835: showDetailZentrum(3)'z3
		Case imagex > 249 And imagex < 388 And imagey > 745 And imagey < 860: showDetailZentrum(2)'z2
		Case imagex > 249 And imagex < 388 And imagey > 897 And imagey < 1024: showDetailZentrum(1)'z1
		Case imagex > 0 And imagex < 148 And imagey > 693 And imagey < 842: showDetailZentrum(8)'z8
		Case imagex > 249 And imagex < 388 And imagey > 500 And imagey < 649: showDetailZentrum(9)'z9
		Case imagex > 432 And imagex < 635 And imagey >= 10 And imagey < 45: showDetailToreLinien(1,False)
		Case imagex > 432 And imagex < 635 And imagey >= 45 And imagey < 70: showDetailToreLinien(2,False)'Tor 2r
		Case imagex > 432 And imagex < 635 And imagey >= 70 And imagey < 95: showDetailToreLinien(3,False)'Tor 3r
		Case imagex > 432 And imagex < 635 And imagey >= 95 And imagey < 120: showDetailToreLinien(4,False)'4r
		Case imagex > 432 And imagex < 635 And imagey >= 120 And imagey < 145: showDetailToreLinien(5,False)'5r
		Case imagex > 432 And imagex < 635 And imagey >= 145 And imagey < 170: showDetailToreLinien(6,False)'Tor 6r
		Case imagex > 432 And imagex < 635 And imagey >= 170 And imagey < 195: showDetailToreLinien(7,False)'Tor 7r
		Case imagex > 432 And imagex < 635 And imagey >= 195 And imagey < 220: showDetailToreLinien(8,False)'Tor 8r
		Case imagex > 432 And imagex < 635 And imagey >= 220 And imagey < 245: showDetailToreLinien(9,False)'Tor 9r
		Case imagex > 432 And imagex < 635 And imagey >= 245 And imagey < 268: showDetailToreLinien(10,False)'Tor 10r
		Case imagex > 432 And imagex < 635 And imagey >= 270 And imagey < 290: showDetailToreLinien(11,False)'Tor 11r
		Case imagex > 432 And imagex < 635 And imagey >= 290 And imagey < 312: showDetailToreLinien(12,False)'Tor 12r
		Case imagex > 432 And imagex < 635 And imagey >= 312 And imagey < 332: showDetailToreLinien(13,False)'Tor 13r
		Case imagex > 432 And imagex < 635 And imagey >= 332 And imagey < 360: showDetailToreLinien(14,False)'Chiron
			
		Case linkeSpaltevorhanden And imagex > 0 And imagex < 201 And imagey >= 10 And imagey < 45: showDetailToreLinien(1,True)'Tor Sonne links
		Case linkeSpaltevorhanden And imagex > 0 And imagex < 201 And imagey >= 45 And imagey < 70: showDetailToreLinien(2,True)'Tor 2l
		Case linkeSpaltevorhanden And imagex > 0 And imagex < 201 And imagey >= 70 And imagey < 95: showDetailToreLinien(3,True)'Tor 3l
		Case linkeSpaltevorhanden And imagex > 0 And imagex < 201 And imagey >= 95 And imagey < 120: showDetailToreLinien(4,True)'Tor 4l
		Case linkeSpaltevorhanden And imagex > 0 And imagex < 201 And imagey >= 120 And imagey < 145: showDetailToreLinien(5,True)'Tor 5l
		Case linkeSpaltevorhanden And imagex > 0 And imagex < 201 And imagey >= 145 And imagey < 170: showDetailToreLinien(6,True)'Tor 6l
		Case linkeSpaltevorhanden And imagex > 0 And imagex < 201 And imagey >= 170 And imagey < 195: showDetailToreLinien(7,True)'Tor 7l
		Case linkeSpaltevorhanden And imagex > 0 And imagex < 201 And imagey >= 195 And imagey < 220: showDetailToreLinien(8,True)'Tor 8l
		Case linkeSpaltevorhanden And imagex > 0 And imagex < 201 And imagey >= 220 And imagey < 245: showDetailToreLinien(9,True)'Tor 9l
		Case linkeSpaltevorhanden And imagex > 0 And imagex < 201 And imagey >= 245 And imagey < 268: showDetailToreLinien(10,True)'Tor 10l
		Case linkeSpaltevorhanden And imagex > 0 And imagex < 201 And imagey >= 270 And imagey < 290: showDetailToreLinien(11,True)'Tor 11l
		Case linkeSpaltevorhanden And imagex > 0 And imagex < 201 And imagey >= 290 And imagey < 312: showDetailToreLinien(12,True)'Tor 12l
		Case linkeSpaltevorhanden And imagex > 0 And imagex < 201 And imagey >= 312 And imagey < 332: showDetailToreLinien(13,True)'Tor 13l
		Case linkeSpaltevorhanden And imagex > 0 And imagex < 201 And imagey >= 332 And imagey < 360: showDetailToreLinien(14,True)'Chiron
			
		Case Else:
			homepage.idsternzeichen = 0		'Wird zur Steuerung in clvWichtig verwendet
			homepage.statusTransit=False
			B4XPages.ShowPage("clvWichtig")
	End Select
#end if
End Sub

#if b4a
Private Sub showDetailZentrum(nummer As Int)
	'ToastMessageShow("Zentrum "&nummer,False)
	
	Dim noHD As Boolean
	If homepage.edtBody.SelectedIndex <> 0 And homepage.edtBody.SelectedIndex <> 3 Then noHD=True

	Dim brush As BCBrush
	Dim p As BCPath
	brush.Initialize
	'brush.BlendAll = True
	Dim Query As String = "SELECT * from Benutzer where IdName =" & homepage.iduser
	Dim rs As ResultSet = Main.sql.ExecQuery(Query)
	Do While rs.NextRow
		If noHD=False Then
			Dim z As Char= rs.Getstring("Z"&nummer)
		Else
			Select nummer
				Case 1:Dim z As Char= homepage.statuszentrenwerte.z1
				Case 2:Dim z As Char= homepage.statuszentrenwerte.z2
				Case 3:Dim z As Char= homepage.statuszentrenwerte.z3
				Case 4:Dim z As Char= homepage.statuszentrenwerte.z4
				Case 5:Dim z As Char= homepage.statuszentrenwerte.z5
				Case 6:Dim z As Char= homepage.statuszentrenwerte.z6
				Case 7:Dim z As Char= homepage.statuszentrenwerte.z7
				Case 8:Dim z As Char= homepage.statuszentrenwerte.z8
				Case 9:Dim z As Char= homepage.statuszentrenwerte.z9
			End Select
		End If
	Loop

	Dim Query As String = "Select * from Zentren where IdZentren=" & nummer
	rs = Main.sql.ExecQuery(Query)
	Do While rs.NextRow
		If z = "j" Then
			Dim anzeigetextkopf As String = rs.GetString("Zentrum") & " ist geschlossen"&CRLF
			Dim anzeigetext As String = anzeigetext & rs.GetString("Definiert")&CRLF
		Else
			Dim anzeigetextkopf As String = rs.GetString("Zentrum") & " ist offen"&CRLF
			Dim anzeigetext As String = rs.GetString("Undefiniert")&CRLF
		End If
		'anzeigetext = anzeigetext & rs.GetString("BeschreibungZentrum")
	Loop
	Dim cs As CSBuilder
	cs.Initialize.Typeface(Typeface.DEFAULT_BOLD).underline.Append(anzeigetextkopf).pop.Typeface(Typeface.DEFAULT).append(anzeigetext).PopAll
	
	DetailinformationZeigen(cs)
End Sub
#end if

#if b4a
Sub DetailinformationZeigen(text As CSBuilder)
	dlg.BackgroundColor = 0xFFFAEBD7
	dlg.BorderCornersRadius=10
	dlg.ButtonsColor = 0xFFFAEBD7
	dlg.BorderColor = 0xFFFF69B4
	dlg.ButtonsTextColor = 0xFFFF69B4
	dlg.OverlayColor=Main.colGabe
	Dim longtext As B4XLongTextTemplate
	longtext.Initialize
	longtext.text = text

	longtext.CustomListView1.DefaultTextBackgroundColor=xui.Color_White
	longtext.CustomListView1.PressedColor=xui.Color_White
	longtext.CustomListView1.GetBase.Color=xui.Color_White
	longtext.CustomListView1.DefaultTextColor=xui.Color_DarkGray
	longtext.Resize(0.8 * Root.Width, 0.8 * Root.Height)
	Wait For (dlg.ShowTemplate(longtext, "", "", "Ok")) Complete (Result As Int)
End Sub
#end if

#if b4a
Private Sub showDetailToreLinien(position As Int,linkeSpalte As Boolean)
'Zeigt die Tor/Linien Details in einer Msgbox
'linkeSpalte = true, dann wurden linke Tore geclickt, sonst rechte Tore
	'ToastMessageShow("Torposition "&position,False)
	Dim i As Int = position - 1
	Dim planetname As String = Main.SQL.ExecQuerySingleResult("select Planet from Planeten where IdPlanet ="&homepage.PersonNeu1.planet(i))
	If linkeSpalte Then
		Dim tor As Int = Main.SQL.ExecQuerySingleResult("select IdTor from HD where IdUser="& homepage.iduser &" and RotSchwarz='r' and IdPlanet="&homepage.PersonNeu1.planet(i))
		Dim linie As Int = Main.SQL.ExecQuerySingleResult("select Linie from HD where IdUser="& homepage.iduser &" and RotSchwarz='r' and IdPlanet="&homepage.PersonNeu1.planet(i))
		Dim planetbedeutung As String = Main.SQL.ExecQuerySingleResult("Select Bedeutung from Planetenbedeutung where Planet='"&planetname&"' and RotSchwarz='r'")
	Else
		If  homepage.edtBody.SelectedIndex = 5 Then 'Nur Transit
			Dim tor As Int = Main.SQL.ExecQuerySingleResult("select IdTor from HD where IdUser="& homepage.iduser &" and RotSchwarz='t' and IdPlanet="&homepage.PersonNeu1.planet(i))
			Dim linie As Int = Main.SQL.ExecQuerySingleResult("select Linie from HD where IdUser="& homepage.iduser &" and RotSchwarz='t' and IdPlanet="&homepage.PersonNeu1.planet(i))
			Dim planetbedeutung As String = ""
		Else
			Dim tor As Int = Main.SQL.ExecQuerySingleResult("select IdTor from HD where IdUser="& homepage.iduser &" and RotSchwarz='s' and IdPlanet="&homepage.PersonNeu1.planet(i))
			Dim linie As Int = Main.SQL.ExecQuerySingleResult("select Linie from HD where IdUser="& homepage.iduser &" and RotSchwarz='s' and IdPlanet="&homepage.PersonNeu1.planet(i))
			Dim planetbedeutung As String = Main.SQL.ExecQuerySingleResult("Select Bedeutung from Planetenbedeutung where Planet='"&planetname&"' and RotSchwarz='s'")
		End If
	End If
	Dim torname As String = Main.SQL.ExecQuerySingleResult("select TorName from Hexagramme where IdTor="& tor)
	Dim torbeschreibung As String = Main.SQL.ExecQuerySingleResult("select TorBeschreibung from Hexagramme where IdTor="& tor)
	Dim linienbedeutung As String = Main.SQL.ExecQuerySingleResult("select Bedeutung from HDLinien where IdTor="& tor &" and Linie="& linie)
	Dim torbild As String = "h" & tor & ".png"
	Dim kopfzeile As String = CRLF&tor & "- "&torname&CRLF
	Dim leerzeichen As String = CRLF
	Dim tortext As String = torbeschreibung&CRLF&CRLF
	Dim headerlinie As String = "Linie "&linie&CRLF
	Dim linientext As String = linienbedeutung
	Dim cs As CSBuilder
	planetbedeutung = planetbedeutung.Replace("NAMEBEZ",torname) 'NAMEBEZ wird nicht übersetzt und bleibt gleich
	If linkeSpalte Then
 		planetbedeutung = planetbedeutung & " (" & planetname & " " & homepage.translate(Main.sprache,64) & ")" & CRLF & CRLF 'rot
		cs.initialize.color(Main.colrot).Typeface(Typeface.DEFAULT_BOLD).Append(planetbedeutung).pop.Image(LoadBitmap(File.DirAssets, torbild), 160dip, 160dip, True).pop.color(Colors.black).append(CRLF).Typeface(Typeface.DEFAULT_BOLD).underline.Append(kopfzeile).pop.Typeface(Typeface.DEFAULT).append(tortext).Typeface(Typeface.DEFAULT_BOLD).underline.append(headerlinie).pop.Typeface(Typeface.DEFAULT).Append(linientext).Append(leerzeichen).PopAll
	Else
		planetbedeutung = planetbedeutung & " (" & planetname & " " & homepage.translate(Main.sprache,63) & ")" & CRLF & CRLF 'schwarz
		cs.initialize.color(Colors.Black).Typeface(Typeface.DEFAULT_BOLD).Append(planetbedeutung).pop.Image(LoadBitmap(File.DirAssets, torbild), 160dip, 160dip, True).append(CRLF).Typeface(Typeface.DEFAULT_BOLD).underline.Append(kopfzeile).pop.Typeface(Typeface.DEFAULT).append(tortext).Typeface(Typeface.DEFAULT_BOLD).underline.append(headerlinie).pop.Typeface(Typeface.DEFAULT).Append(linientext).Append(leerzeichen).PopAll
	End If
	DetailinformationZeigen(cs)
End Sub
#end if

Private Sub btnvor_Click
	
	Dim size As Int = imedien.Length
	If aktuellesbild < size Then
		btnback.Visible = True
		#if b4j
			zimage.SetBitmap(xui.LoadBitmap("../files/",imedien(aktuellesbild)))
		#else
			zimage.Image = xui.LoadBitmap(File.DirAssets,imedien(aktuellesbild))
			'zimage.SetScaleAndCenter(1,0.5, 0.5, 1)
		#end if
		aktuellesbild = aktuellesbild + 1
	Else
	 	btnvor.visible = False
	End If
	
End Sub

Private Sub btnback_Click
	If aktuellesbild-1 >= 0 Then
		btnvor.Visible = True
		aktuellesbild=aktuellesbild - 1
		If aktuellesbild = 0 Then
			#if b4j
				zimage.SetBitmap(xui.LoadBitmap(File.DirData("heilsystem"), "bodygraphexakt.png"))
			#else
				zimage.Image = xui.LoadBitmap(rp.GetSafeDirDefaultExternal(""), "bodygraphexakt.png")
				'zimage.SetScaleAndCenter(1,0.5, 0.5, 1)
			#end if
		Else
			#if b4j
				zimage.SetBitmap(xui.LoadBitmap("../files/",imedien(aktuellesbild-1)))
			#else
				zimage.Image = xui.LoadBitmap(File.DirAssets,imedien(aktuellesbild-1))
				'zimage.SetScaleAndCenter(1,0.5, 0.5, 1)
			#end if
		End If
		
	Else
		btnback.visible = False
	End If
	
End Sub