B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=8.5
@EndOfDesignText@
Sub Class_Globals
	#if b4j
		Private jfx1 As JFX
	#end if
	Private Root As B4XView 'ignore
	Private xui As XUI 'ignore
	Private clv2 As CustomListView
	Private dlg As B4XDialog
	Private waitmsg As B4XLongTextTemplate
	Private sortorder As B4XComboBox		'0 default(IDTor),1 Zentren, 2 Planet		
	Private sequenz As B4XComboBox
	Private body As B4XView					'bodygraph einblenden nach Click auf Iging
	Private textengine As BCTextEngine
	Private BBCodeView1 As BBCodeView
	Private home As B4XMainPage
	Private PDF As Button
	#if admin
		Private PDFquick As Button
	#End If
	Private pdfmap As Map 					'Speichert alle BBitems mit key=idtor&','&idlinie
	Private sortmap As Map					'speichert die sortierte Liste mit allen Informationen für clv2-Erstellung
	Private lastpdfmapId As String 			'setzt sich aus idtor und idlinie zusammen
	Private BBdialog As BBCodeView
	Private maxPDFheight As Int 
	Private maxZeichen As Int				'max. Zeichen in einer Zeile
	Private pdfZeilenhoehe As Int 
	Private pdfLeft As Int 
	#if b4j
		Private maxPDFwidth As Int = 550
		Private pdfZeichengroesse As Int = 12
	#end if
	
	Private lblthema As B4XView
	'Typen
	Type mapitem (idtor As Int, torname As String, rotschwarz As Char, tortext As String, aspekt As Char, schatten As String, gabe As String, siddhi As String,kanaltext As String, kanalrolle As String, kanalname As String, kanaltor As Int, txtAngst As String,txtDruck As String,txtLiebe As String,txtFrust As String,txtSchubkraft As String,idlinie As Int,textlinie As String,fragelinie1 As String,fragelinie2 As String,fragelinie3 As String,textaffi1 As String,textaffi2 As String,textaffi3 As String, textmp1 As String,bezmp1 As String, textmp2 As String,bezmp2 As String, textmp3 As String,bezmp3 As String, textpdf1 As String,bezpdf1 As String, textpdf2 As String,bezpdf2 As String,textpdf3 As String,bezpdf3 As String, wandelTor As Int,wName As String,ztext As String,txtgabe As String,idsab As Int, txtsab As String)
	Type emaillinkEintrag (bezeichner As String, link As String) 'Für Email- Links zu den Toren
	Type sortitem(Id As Int,Tor As Int,Linie As Int,IdSab As Int, TorName As String, IdZentrum As Int, Planet As String,stz As String,idstz As Int,rotschwarz As Char,PlanetBedeutung As String,t1 As String,t2 As String,hauptmeridian As String)
	Private lfrequenz As B4XView
	Private lAspekt,lIdTor,lLinie,Iging,lTorname,lZentrum,lPlanet,lSternzeichen,lmeridian,checkpdf,ltime1,ltime2 As B4XView
End Sub

'You can add more parameters here.
Public Sub Initialize As Object
	
	Return Me
End Sub

'This event will be called once, before the page becomes visible.
Private Sub B4XPage_Created (Root1 As B4XView)
	Root = Root1
	Root.LoadLayout("clvWichtig")
	home = B4XPages.GetPage("MainPage")
	
	'PDF Parameter festlegen
	maxPDFheight=815
	If home.screensize < 8 Then
		maxZeichen=115
	Else
		maxZeichen=105
	End If
	pdfZeilenhoehe=12
	pdfLeft=20
	
	sortmap.Initialize
	pdfmap.Initialize
	home.emailLinklist.Initialize
	sequenz.mBase.Color=Main.colhintergrund
	clv2.DefaultTextBackgroundColor=Main.colhintergrund
	#if b4j
	Dim F As Form = B4XPages.GetNativeParent(Me)
		F.WindowWidth = 650
		'F.WindowWidth = jfx1.PrimaryScreen.MaxX - jfx1.PrimaryScreen.MinX           'set the screen to full width/height
		'F.WindowLeft = jfx1.PrimaryScreen.MinX
		F.WindowHeight= jfx1.PrimaryScreen.MaxY - jfx1.PrimaryScreen.MinY
		F.WindowTop = jfx1.PrimaryScreen.MinY
	'	F.WindowHeight = 650
		dlg.Initialize(Root)
	#end if
	'Komponenten initialisieren
	dlg.Initialize(Root)
	waitmsg.Initialize
	
	
End Sub

Sub B4XPage_Appear
	
	'Titelzeile kann bei Click auf Person durch Sternzeichen überschrieben werden
	'B4XPages.SetTitle(Me,home.translate(Main.sprache,5)) 'Dein Glückscode
	home.setTitelzeile(home.translate(Main.sprache,5))
	
	'Tagesthema Icon ist nur sichtbar bei Anzeige "mit Transit"
	If home.edtBody.SelectedIndex=4 Then
		lblthema.Visible=True
	Else
		lblthema.Visible=False
	End If
	'Comboboxen befüllen, da sich Sprache geändert haben könnte
	Dim l As List
	l.Initialize
	l.Add(home.translate(Main.sprache,30)) 'Wichtigkeit
	l.Add(home.translate(Main.sprache,31)) 'Tornummer
	l.Add(home.translate(Main.sprache,32)) 'Linie
	l.Add(home.translate(Main.sprache,33)) 'Zentren
	l.Add(home.translate(Main.sprache,79)) 'Zeit
	sortorder.SetItems(l)
	sortorder.SelectedIndex = home.kvs.GetDefault("sortorder",0) 'Einmalig setzen bei erstem APP-Start
	If home.statusTransit=True Then 'Bei Energiebooster-Click
		sortorder.SelectedIndex=4 	'bei Transit immer nach Zeit  
	End If
	l.Initialize
	l.Add(home.translate(Main.sprache,34)) 'Tore Lebensthema
	l.Add(home.translate(Main.sprache,35)) 'Tore mit aktivierten Kanälen
	l.Add(home.translate(Main.sprache,36)) 'Enneagramm Typ
	l.Add(home.translate(Main.sprache,37)) 'Tore der Angst")
	l.Add(home.translate(Main.sprache,38)) 'Tore des Drucks")
	l.Add(home.translate(Main.sprache,39)) 'Tore des Frusts")
	l.Add(home.translate(Main.sprache,40)) 'Tore der Liebe")
	l.Add(home.translate(Main.sprache,41)) 'Tore der Schubkraft")
	
	sequenz.SetItems(l)
	
	sequenz.mBase.Visible=True
	sortorder.mBase.Visible = True
	
	torlisteErstellen
	wait for ListviewReady
End Sub

Sub B4XPage_Disappear
	'Globale Werte wieder rücksetzen
	home.statusTransit = False
	home.idsternzeichen = 0
End Sub


'Erstellt die CustomListview der Auswertungen
Sub torlisteErstellen
	clv2.Clear
	sortmap.clear
	pdfmap.Clear
	'Es wurde auf ein Sternzeichen im Startbild geklickt, wenn idsternzeichen ungleich 0 ist
	If home.idsternzeichen <> 0 Then 	
		sequenz.mBase.Visible = False
		sortorder.mBase.Visible = False
		Dim planeten As List
		planeten.Initialize
		Dim stz As String = Main.sql.ExecQuerySingleResult("Select Sternzeichen from Sternzeichen where IdSternzeichen=" & home.idsternzeichen)
		Dim defstz As String = home.translate(Main.sprache,71)'Sternzeichen
		B4XPages.SetTitle(Me,defstz&" "& stz)
		Dim idplanet As Int = Main.sql.ExecQuerySingleResult("Select IdPlanet from Sternzeichen where IdSternzeichen=" & home.idsternzeichen) 'Normalerweise ist IdSternzeichen und IdPlanet identisch
		Dim herrscherPlanet1 As String = Main.sql.ExecQuerySingleResult("Select Planet from Planeten where IdPlanet=" & idplanet)
		planeten.Add(herrscherPlanet1)
		Dim rs As ResultSet = Main.sql.ExecQuery("Select * from ToreUndDeutung where Planet='" & herrscherPlanet1 & "'" & "and RotSchwarz='s'") 'Alle schwarzen Tore		
		Do While rs.NextRow
			Dim idsab As Int = rs.GetInt("IdSab")
			Dim idstz As Int = Sammlung.convertiereSabSymbolinSternzeichen(idsab)
			Dim idplanet As Int = Main.sql.ExecQuerySingleResult("Select IdPlanet from Sternzeichen where IdSternzeichen=" & idstz) 'Normalerweise ist IdSternzeichen und IdPlanet identisch
			Dim planetX As String = Main.sql.ExecQuerySingleResult("Select Planet from Planeten where IdPlanet=" & idplanet)
			planeten.add(planetX)
		Loop
		'make IN- clouse String
		Dim sb As StringBuilder
		sb.Initialize
		sb.Append( " IN(")
		For i= 0 To planeten.size -1
			Dim f As String =planeten.Get(i)
			If i = planeten.Size-1 Then
				sb.Append($"'${f}')"$)
			Else
				sb.Append($"'${f}',"$)
			End If
		Next
	End If
	
	'Auswertungen bei Click auf bodygraph
	
	Select True
		Case home.idsternzeichen <> 0: Dim Query As String = "Select * from ToreUndDeutung where Planet "& sb.tostring &" and RotSchwarz='s'" '(Planet IN ..)
		Case sortorder.SelectedIndex = 1: Dim Query As String = "SELECT * from ToreUndDeutung order by IdTor ASC"
		Case sortorder.SelectedIndex = 2: Dim Query As String = "SELECT * from ToreUndDeutung order by Linie ASC"
		Case sortorder.SelectedIndex = 3: Dim Query As String = "SELECT * from ToreUndDeutung order by IdZentrum ASC"
		Case  sortorder.SelectedIndex = 4 Or home.statusTransit=True: Dim Query As String ="Select * from ToreNachZeit"
		Case Else: Dim Query As String = "SELECT * from ToreUndDeutung"
	End Select
	

	'Resultset auswerten
	Dim pos As Int = 0	
	Dim rs As ResultSet = Main.sql.ExecQuery(Query)
	Sleep(50) 'Zeit um View anzupassen ?
	Do While rs.NextRow
		Dim rotschwarz As Char
		Dim hauptmeridian, time1, time2 As String
		rotschwarz  = rs.GetString("RotSchwarz")

		Dim ueberspringen As Boolean = False
		If home.statusTransit = False Then 'Bei Click auf PEnergie immer alle Tore anzeigen
			Select True
				Case home.edtBody.Selectedindex = 0 Or home.edtBody.Selectedindex = 3:
					If rotschwarz = "t" Then ueberspringen = True
				Case home.edtBody.Selectedindex = 1:
					If rotschwarz = "s" Or rotschwarz = "t" Then ueberspringen = True
				Case home.edtBody.Selectedindex = 2:
					If rotschwarz = "r" Or rotschwarz = "t" Then ueberspringen = True
				Case home.edtBody.Selectedindex = 5: 'Nur Transit
					If rotschwarz = "s" Or rotschwarz = "r" Then ueberspringen = True
			End Select
		End If
		If ueberspringen = False Then 
			'Sternzeichen ermitteln
			Dim idsab As Int = rs.GetInt("IdSab")
			Dim idstz As Int = Sammlung.convertiereSabSymbolinSternzeichen(idsab)
			Dim stz As String = Main.SQL.ExecQuerySingleResult("select Sternzeichen from Sternzeichen where IdSternzeichen = "&idstz)
		
			If sortorder.SelectedIndex = 4  Or home.statusTransit=True Then'Zeit
				hauptmeridian = rs.GetString("hauptmeridian")
				time1 = rs.GetString("time1")
				time2 = rs.GetString("time2")
			End If
			'Kopiere Informationen in Map sortmap 
			sortmap=addtosortmap(sortmap,pos,rs.GetInt("IdTor"),rs.GetInt("Linie"),rs.GetInt("IdSab"), rs.getstring("TorName"), rs.getstring("IdZentrum"), rs.getstring("Planet"),stz,idstz,rotschwarz,time1,time2,hauptmeridian)
			pos = pos + 1
		End If
	Loop
	
	'Schreiben in clv
	For Each k As Int In sortmap.Keys
		Dim sitem As sortitem = sortmap.Get(k)
		Dim mt As Int = sitem.Tor
		Dim ml As Int = sitem.Linie
		'Dim ms As Int = sitem.IdSab
		Dim mtm As String = sitem.TorName
		Dim mtz As String = sitem.IdZentrum
		Dim mp As String = sitem.Planet
		Dim mz As String = sitem.stz
		Dim mzid As Int = sitem.idstz
		Dim mrs As Char = sitem.rotschwarz
		Dim mpb As String = sitem.PlanetBedeutung
		Dim meridian,t1,t2 As String
		If sortorder.SelectedIndex = 4 Or home.statusTransit Then 'Zeit oder Transitpositionierung
			meridian = sitem.hauptmeridian
			t1 = sitem.t1
			t2 = sitem.t2
		End If
		Dim torbedeutung As String = PositioniereBedeutung(mpb,mtm)

		Dim pnl As B4XView = CreateListItem(mt,torbedeutung, ml, mtm, mtz, mp,mz,mzid,mrs,t1,t2,meridian,clv2.AsView.Width, 70dip)
		pnl.Tag = "n"  'Vorbelegung, nicht aufgeblättert
		If sortorder.SelectedIndex=0 Then clv2.AddTextItem(torbedeutung,"planetenbedeutung")
		clv2.Add(pnl,"tordetails")
	Next
	clv2.ScrollToItem(0)
	Sleep(100)
	'bei Transit zu aktueller Uhrzeit navigieren
	If home.statusTransit = True Then
		'Log("Navigiere zu Eintrag:" & home.rowidTorenachZeit)
		clv2.scrollToItem(home.rowidTorenachZeit-1)								'sonst positioniert es nicht richtig
	End If
	Sleep(100)
	home.statusTransit=False	'Liste erstellen beendet
	'CallSubDelayed(Me, "ListviewReady")
End Sub

Sub PositioniereBedeutung(textausdb As String, torname As String) As String
	Dim ergebnis As String
	ergebnis = textausdb.Replace("NAMEBEZ",torname) 'NAMEBEZ wird nicht übersetzt und bleibt gleich
	Return ergebnis
End Sub

Sub addtosortmap(sm As Map,Pos As Int,Tor As Int,Linie As Int, IdSab As Int, TorName As String, IdZentrum As Int, Planet As String,stz As String,idstz As Int,rotschwarz As Char,t1 As String,t2 As String,meridian As String) As Map
	Dim isort As sortitem
	If rotschwarz="t" Then 'Transit
		Dim query As String = "Select ID,Bedeutung from Planetenbedeutung where Planet='"&Planet&"' and RotSchwarz='t'"
	Else
		Dim query As String = "Select ID,Bedeutung from Planetenbedeutung where Planet='"&Planet&"' and RotSchwarz='"&rotschwarz&"'"
	End If
		Dim rs As ResultSet = Main.sql.ExecQuery(query)
	rs.NextRow 'sollte nur ein Eintrag sein.
	Dim posid As Int = rs.getint("ID")
	Dim bplanet As String = rs.getstring("Bedeutung")
	'Log(posid&Planet&bplanet)
	If sortorder.SelectedIndex = 0 And home.idsternzeichen = 0 And home.iduser <> 0 Then 'Wenn auf Körperteil geklickt wird, ist idsternzeichen ungleich 0
		isort.Id = posid
	Else							'Die anderen Tabellen wurden vorher schon sortiert und sind in der richtigen Reihenfolge
		isort.Id = Pos
	End If
	isort.PlanetBedeutung = bplanet
	isort.Tor=Tor
	isort.Linie=Linie
	isort.IdSab=IdSab
	isort.TorName=TorName
	isort.IdZentrum=IdZentrum
	isort.Planet=Planet
	isort.stz=stz
	isort.idstz=idstz
	isort.rotschwarz=rotschwarz
	isort.t1=t1
	isort.t2=t2
	isort.hauptmeridian=meridian
	sm.Put(isort.id,isort)
	Return sm
End Sub

'Berechnet das gewandelte Tor nach dem WEN-Code und gibt es zurück
Sub berechneWandelTor(tor As Int, linie As Int) As Int
	Dim Query As String = "Select WenCode from Hexagramme where IdTor=" & tor
	Dim wencode As String = Main.sql.ExecQuerySingleResult(Query)
	'Log("Code: "&wencode)
	Dim wandelbit As String = wencode.SubString2(linie - 1,linie)
	If wandelbit = "1" Then 
		wandelbit = "0"
	Else 
		wandelbit = "1"
	End If
	Dim wandlungscode As String = wencode.SubString2(0,linie-1)&wandelbit&wencode.SubString2(linie,wencode.Length)
	'Log("Gewandelter Code: "&wandlungscode)
	Dim Query As String = "Select IdTor from Hexagramme where WenCode='" & wandlungscode &"'"
	Dim wandeltor As Int = Main.sql.ExecQuerySingleResult(Query)
	Return wandeltor
End Sub


'Erzeugt die Listeneinträge
#if b4j 
	Sub CreateListItem(tor As Int, torbedeutung As String, linie As Int, torname As String,idzentrum As String, planet As String,sternzeichen As String,stzfarbe As Int, RotSchwarz As Char,time1 As String, time2 As String,meridian As String, Width As Int, Height As Int) As Pane
#else
	Sub CreateListItem(tor As Int,torbedeutung As String, linie As Int,torname As String,idzentrum As String, planet As String,sternzeichen As String,stzfarbe As Int, RotSchwarz As Char, time1 As String, time2 As String,meridian As String, Width As Int, Height As Int) As Panel
#end if
	Dim p As B4XView = xui.CreatePanel("")
	p.SetLayoutAnimated(0, 0, 0, Width, Height)
	p.LoadLayout("cellitem")
	p.Tag="aktTor"
	lIdTor.Text = tor
	lIdTor.Tag = torbedeutung  'Übersichtstext je Tor bei Sortierung nach Wichtigkeit
	lLinie.Text = linie
	lTorname.Text = torname
	lPlanet.text = planet
	lPlanet.Tag = RotSchwarz  'für Click auf Planet in Liste
	
	If sortorder.SelectedIndex=4 Then
		ltime1.text=time1					
		ltime2.text=time2
		lmeridian.Text=meridian	
	End If

	'Log(lPlanet.Text&" "&lPlanet.Tag)
	lSternzeichen.text = sternzeichen
	lSternzeichen.TextColor = Main.farbe.Get(stzfarbe)
	checkpdf.Tag=checkpdf 'Neue Konvention für CustomViews,wenn man später darauf zugreifen möchte

	Dim igf As String = tor & ".png"
	#if b4j
		Iging.SetBitmap(xui.LoadBitmap("..\files\",igf))
	#else
		Iging.SetBitmap(xui.LoadBitmapResize(File.DirAssets,igf,Iging.Width,Iging.Height,True))
	#End If
	Iging.BringToFront 'zwecks Clickevent
	If RotSchwarz = "s" Then
		lIdTor.TextColor = xui.Color_Black
		lLinie.TextColor = xui.Color_Black
		lTorname.TextColor = xui.Color_Black
	End If
	If RotSchwarz = "r" Then
		lIdTor.TextColor = Main.colrot
		lLinie.TextColor = Main.colrot
		lTorname.TextColor = Main.colrot
	End If
	If RotSchwarz = "t" Then
		lIdTor.TextColor = xui.Color_blue
		lLinie.TextColor = xui.Color_blue
		lTorname.TextColor = xui.Color_blue
	End If
	Dim Query As String = "Select Zentrum from Zentren where IdZentren=" & idzentrum
	lZentrum.Text = Main.SQL.ExecQuerySingleResult(Query)

	Dim res As Int = 0
	If sequenz.IsInitialized = True Then
		Select True
			Case sequenz.SelectedIndex = 0: 'Lebensaufgabe
				If planet = home.translate(Main.sprache,201) Or planet =  home.translate(Main.sprache,200) Then  'Erde oder Sonne = Lebensaufgabe
					lIdTor.Color = Main.colGold
					lLinie.Color = Main.colGold
					lTorname.Color = Main.colGold
					#if b4a
						checkpdf.Color = Main.colGold
					#End If
				End If
			Case sequenz.SelectedIndex = 1: 'Tore von aktivierten Kanäle
				Dim Query As String
				Select True
					Case home.edtBody.SelectedIndex=0:Query = "select count(*) from AktivierteKanaeleRotSchwarz"
					Case home.edtBody.SelectedIndex=1:Query = "select count(*) from AktivierteKanaeleRot"
					Case home.edtBody.SelectedIndex=2:Query = "select count(*) from AktivierteKanaeleSchwarz"
					Case home.edtBody.SelectedIndex=3:Query = "select count(*) from AktivierteKanaeleRotSchwarz"
					Case home.edtBody.SelectedIndex=4:Query = "select count(*) from AktivierteKanaele"
					Case home.edtBody.SelectedIndex=5:Query = "select count(*) from AktivierteKanaeleNurTransit"
				End Select
				res = Main.sql.ExecQuerySingleResult(Query & " where KanalA=" & tor & " Or KanalB=" & tor)	
			Case sequenz.SelectedIndex = 3: 'Tore Angst
				res = Main.sql.ExecQuerySingleResult("Select count(*) from TorederAngst where IdTor=" & tor)
			Case sequenz.SelectedIndex = 4: 'Tore Druck
				res = Main.sql.ExecQuerySingleResult("Select count(*) from ToreDruck where IdTor=" & tor)
			Case sequenz.SelectedIndex = 5: 'Tore Frust
				res = Main.sql.ExecQuerySingleResult("Select count(*) from ToreFrust where IdTor=" & tor)
			Case sequenz.SelectedIndex = 6: 'Liebe
			 	res = Main.sql.ExecQuerySingleResult("Select count(*) from TorederLiebe where IdTor=" & tor)
			Case sequenz.SelectedIndex = 7: 'Tore Schubkraft
				res = Main.sql.ExecQuerySingleResult("Select count(*) from ToreSchubkraft where IdTor=" & tor)
				
		End Select
	End If
	If res <> 0 Then
		lIdTor.Color = xui.Color_LightGray
		lLinie.Color = xui.Color_LightGray
		lAspekt.Color = xui.Color_LightGray
		lTorname.Color = xui.Color_LightGray
		#if b4a
			checkpdf.Color = xui.Color_LightGray
		#End If
	End If

	Return p
End Sub


Sub addtoPDFMap(idtor As Int, torname As String,rotschwarz As Char, tortext As String, schatten As String,gabe As String,siddhi As String,kanaltext As String, kanalrolle As String, kanalname As String, kanaltor As Int, txtAngst As String,txtDruck As String,txtLiebe As String,txtFrust As String,txtSchubkraft As String,idlinie As Int,textlinie As String,fragelinie1 As String,fragelinie2 As String,fragelinie3 As String,textaffi1 As String,textaffi2 As String,textaffi3 As String, textmp1 As String,bezmp1 As String, textmp2 As String,bezmp2 As String, textmp3 As String,bezmp3 As String, textpdf1 As String,bezpdf1 As String, textpdf2 As String,bezpdf2 As String,textpdf3 As String,bezpdf3 As String, wandelTor As Int,wName As String,ztext As String,txtgabe As String, idsab As Int, txtsab As String)
'speichert einen Eintrag in der Map und gibt die neue Map zurück

	Dim identifier As String
	
	identifier = idtor &"," & idlinie
	Dim eintrag As mapitem
	eintrag.Initialize
	eintrag.idtor=idtor
	eintrag.torname=torname
	eintrag.idlinie=idlinie
	eintrag.rotschwarz=rotschwarz
	eintrag.tortext=tortext
	eintrag.schatten=schatten
	eintrag.gabe=gabe
	eintrag.siddhi=siddhi
	eintrag.kanaltext=kanaltext
	eintrag.kanalrolle=kanalrolle
	eintrag.kanalname=kanalname
	eintrag.kanaltor=kanaltor
	eintrag.txtAngst=txtAngst
	eintrag.txtDruck=txtDruck
	eintrag.txtLiebe=txtLiebe
	eintrag.txtFrust=txtFrust
	eintrag.txtSchubkraft=txtSchubkraft
	eintrag.textlinie=textlinie
	eintrag.fragelinie1=fragelinie1
	eintrag.fragelinie2=fragelinie2
	eintrag.fragelinie3=fragelinie3
	eintrag.textaffi1=textaffi1
	eintrag.textaffi2=textaffi2
	eintrag.textaffi3=textaffi3
	eintrag.textmp1=textmp1
	eintrag.textmp2=textmp2
	eintrag.textmp3=textmp3
	eintrag.bezmp1=bezmp1
	eintrag.bezmp2=bezmp2
	eintrag.bezmp3=bezmp3
	eintrag.textpdf1=textpdf1
	eintrag.textpdf2=textpdf2
	eintrag.textpdf3=textpdf3
	eintrag.bezpdf1=bezpdf1
	eintrag.bezpdf2=bezpdf2
	eintrag.bezpdf3=bezpdf3
	eintrag.txtgabe=txtgabe
	eintrag.idsab=idsab
	eintrag.txtsab=txtsab
	eintrag.wandelTor=wandelTor
	eintrag.wName=wName
	eintrag.ztext=ztext
	'zu globaler pdfmap hinzufügen
	pdfmap.Put(identifier,eintrag)
End Sub
#if b4j 
	Sub CreateBBItem(idtor As Int,tortext As String,schatten As String,gabe As String,siddhi As String,kanaltext As String, kanalrolle As String, kanalname As String, kanaltor As Int, txtAngst As String,txtDruck As String,txtLiebe As String,txtFrust As String,txtSchubkraft As String,idlinie As Int,textlinie As String,fragelinie1 As String,fragelinie2 As String,fragelinie3 As String,textaffi1 As String,textaffi2 As String,textaffi3 As String, textmp1 As String,bezmp1 As String, textmp2 As String,bezmp2 As String, textmp3 As String,bezmp3 As String, textpdf1 As String,bezpdf1 As String, textpdf2 As String,bezpdf2 As String,textpdf3 As String,bezpdf3 As String, wandelTor As Int,wName As String,ztext As String,txtgabe As String,idsab As Int,txtsab As String) As Pane
#else
	Sub CreateBBItem(idtor As Int,tortext As String,schatten As String,gabe As String,siddhi As String,kanaltext As String, kanalrolle As String, kanalname As String, kanaltor As Int, txtAngst As String,txtDruck As String,txtLiebe As String,txtFrust As String,txtSchubkraft As String,idlinie As Int,textlinie As String,fragelinie1 As String,fragelinie2 As String,fragelinie3 As String,textaffi1 As String,textaffi2 As String,textaffi3 As String, textmp1 As String,bezmp1 As String, textmp2 As String,bezmp2 As String, textmp3 As String,bezmp3 As String, textpdf1 As String,bezpdf1 As String, textpdf2 As String,bezpdf2 As String,textpdf3 As String,bezpdf3 As String, wandelTor As Int,wName As String,ztext As String,txtgabe As String,idsab As Int,txtsab As String) As Panel
#end if

	Dim urlHeilseminare As String = "https://heilseminare.com/meditationen/"
	Dim p As B4XView = xui.CreatePanel("")
	'derzeit ist als Länge der BBcodeview1 -10000 im Designer angegeben. Sollten Inhalte abgeschnitten werden, muss man diesen Wert vom unteren Rand noch vergrössern
	p.LoadLayout("cellitemBBItem")
	textengine.Initialize(p)
	'textengine.KerningEnabled = True
	BBCodeView1.TextEngine = textengine
	
	#if user
		textengine.SpaceBetweenLines = 16dip
		textengine.MinGapBetweenLines = 2dip
	#end if
	
	Dim btn As Button
	btn.Initialize("btn")
	btn.Text = wandelTor& " - "&wName
	btn.Tag = wandelTor
	btn.SetLayoutAnimated(0, 0, 0, 320dip, 60dip)
	BBCodeView1.Views.Put("btn", btn)
	
	Dim btnsab As Button
	btnsab.Initialize("btnsab")
	btnsab.Text = home.translate(Main.sprache,104)
	btnsab.Tag = "s"&idsab
	btnsab.SetLayoutAnimated(0, 0, 0, 320dip, 60dip)
	BBCodeView1.Views.Put("btnsab", btnsab)
	#if b4a
		Dim btnclose As Button
		btnclose.Initialize("btnclose")
		Dim cs As CSBuilder
		cs.Initialize
		cs.Image(LoadBitmap(File.DirAssets, "arrow_up.png"), 20dip, 20dip, False)
		cs.PopAll
		btnclose.Text = cs
		btnclose.Color=Main.colGabe
		btnclose.SetLayoutAnimated(0, 0, 0, 40dip, 40dip)
		BBCodeView1.Views.Put("btnclose", btnclose)
	#end if
	Dim btnpdf As Button
	btnpdf.Initialize("btnpdf")
	btnpdf.Text = "PDF"
	btnpdf.SetLayoutAnimated(0, 0, 0, 60dip, 40dip)
	BBCodeView1.Views.Put("btnpdf", btnpdf)
	
	BBCodeView1.LazyLoading=True
	Dim a As Object = txtAngst
	If a= Null Then txtAngst = ""
	Dim d As Object = txtDruck
	If d = Null Then txtDruck = ""
	Dim f As Object  = txtFrust
	If f = Null Then txtFrust = ""
	Dim l As Object = txtLiebe
	If l = Null Then txtLiebe = ""
	Dim s As Object = txtSchubkraft
	If s = Null Then txtSchubkraft = ""
	Dim torimg As String = "h"&idtor&".png"
	Dim sabimg As String = idsab&"sab"&".png"
	Dim wandelimg As String = "h"&wandelTor&".png"
	zeichneFrequenzstrahl(schatten,gabe,siddhi)'Erstellt die Datei frequenzstrahl.png im Default- Folder
	Dim imgverzeichnis As String = xui.DefaultFolder
	Dim frequenzstrahl As String = "frequenzstrahl.png"
	Dim defkanal As String = home.translate(Main.sprache,42) 'Definierter Kanal
	Dim defrolle As String = home.translate(Main.sprache,43) 'Rolle
	Dim defzutor As String = home.translate(Main.sprache,44) 'zu Tor
	Dim deflinie As String = home.translate(Main.sprache,32) 'Linie
	Dim deffragen As String = home.translate(Main.sprache,45) 'Fragen
	Dim defaffirmationen As String = home.translate(Main.sprache,46) 'Affirmationen
	Dim defthema As String = home.translate(Main.sprache,47) 'auf welcher Frequenz lebst du dieses Tor ?
	Dim defwandlung As String = home.translate(Main.sprache,48) 'Wandlung
	Dim defsab As String = home.translate(Main.sprache,103) 'Sabisches Symbol
	Dim defgabe As String = home.translate(Main.sprache,49) 'Gabe
	Dim defaudio As String = home.translate(Main.sprache,50) 'Audio
	Dim defzentrum As String = home.translate(Main.sprache,51) 'in Zentrum
	
	'Farben in Liste bei z.B. MP3 [Color=#e0b982]
	Dim code As String
#if b4j
code = code & _
$"[Alignment=center][img FileName=${torimg} width=550/][/Alignment]"$
#else
code = code & _
$"[Alignment=center][img FileName=${torimg} width=320/][/Alignment]"$
#end if
code = code & _
$"
[Alignment=left]${tortext}[/Alignment]
"$


If home.settings.Get("tdefkanal")=True And kanalname <> "" Then
	code = code & _
$"
[Alignment=left][b][u]${defkanal} ${kanalname} (${defrolle}: ${kanalrolle}) ${defzutor} ${kanaltor}:[/u][/b][/Alignment] 
[Alignment=left]${kanaltext}[/Alignment]
"$
End If

If sequenz.SelectedIndex = 3 Or  sequenz.SelectedIndex = 4 Or  sequenz.SelectedIndex = 5 Or  sequenz.SelectedIndex = 6 Or  sequenz.SelectedIndex = 7 Then
	If  txtAngst<>"" Or txtDruck <>"" Or txtFrust<>"" Or txtLiebe<>"" Or txtSchubkraft<>"" Then
		code = code & _
$"[Alignment=left]${txtAngst}${txtDruck}${txtFrust}${txtLiebe}${txtSchubkraft}[/Alignment]
"$
	End If
End If

code = code & _
$"
[Alignment=left][b][u]${deflinie} ${idlinie}:[/u][/b][/Alignment]
[Alignment=left]${textlinie}[/Alignment]
"$

If home.settings.Get("tsabsymbol")=True And idsab<>0 Then
code = code & _
$"
[Alignment=left][b][u]${defsab}:[/u][/b] [/alignment]
[Alignment=left]${txtsab}[/alignment]
"$
#if b4j
	If File.Exists("..\files\",sabimg) Then
#else
	If File.Exists(File.DirAssets,sabimg) Then
#end if

#if b4j
code = code & _
$"[Alignment=center][img FileName=${sabimg} width=550/]
[View=btnsab Vertical=5/][/Alignment]"$
#else
code = code & _
$"[Alignment=center][img FileName=${sabimg} width=320/]"$
#end if
#if admin
code = code & _
$"[View=btnsab Vertical=5/][/Alignment]"$
#End If
	End If
End If
If home.settings.Get("tfragenaffi")=True Then
	code = code & _
$"
[Alignment=left][b][u]${deffragen}:[/u][/b]
"$

		If fragelinie1 <> "" Then code = code & $"${fragelinie1}"$&CRLF
		If fragelinie2 <> "" Then code = code & $"${fragelinie2}"$&CRLF
		If fragelinie3 <> "" Then code = code & $"${fragelinie3}"$

		If textaffi1 <> "" Or textaffi2 <> "" Or textaffi3 <> "" Then
			code = code & _
$"

[b][u]${defaffirmationen}:[/u][/b]
"$
		End If
		If textaffi1 <> "" Then code = code & $"${textaffi1}"$&CRLF
		If textaffi2 <> "" Then code = code & $"${textaffi2}"$&CRLF
		If textaffi3 <> "" Then code = code & $"${textaffi3}"$
		code = code & _
	$"
	[/Alignment]"$
End If
	' Dim Empfehlung As Object = Main.SQL.ExecQuerySingleResult("select Empfehlung from Hexagramme where IdTor = "&idtor)
	' code = code & _
	' $"[Alignment=Left][b][u]Empfehlung:[/u][/b][/Alignment]
	' ${Empfehlung}
	' "$
#if b4j
code = code & _
$"	
[Alignment=Center][b]${defthema}[/b]
[img dir=${imgverzeichnis} FileName=${frequenzstrahl} width=550 height=50/]"$
#else

If home.screensize < 8 Then
	code = code & _
$"
[Alignment=left][b]${defthema}[/b]
[img dir=${imgverzeichnis} FileName=${frequenzstrahl} width=320 height=50/]"$
Else
	code = code & _
	$"
	[Alignment=center][b]${defthema}[/b]
	[img dir=${imgverzeichnis} FileName=${frequenzstrahl} width=640 height=50/]"$
End If
#end if

If textmp1 <> "" Then
	Dim urlkomplett As String = urlHeilseminare & textmp1
	code = code & _
$"

[Alignment=left][b][u]${defaudio}:[/u][/b][list]
[*][url="${urlkomplett}"][color=#FF69B4]${bezmp1}[/color][/url]
"$

	If textmp2  <> "" Then
		Dim urlkomplett As String = urlHeilseminare & textmp2
			code = code & $"[*][url="${urlkomplett}"][color=#FF69B4]${bezmp2}[/color][/url]"$&CRLF
	End If
	If textmp3 <> "" Then
		Dim urlkomplett As String = urlHeilseminare & textmp3
			code = code & $"[*][url="${urlkomplett}"][color=#FF69B4]${bezmp3}[/color][/url]"$
	End If
	code = code & $"[/list][/alignment]"$
End If
If textpdf1 <> "" Then
	Dim urlkomplett As String = urlHeilseminare & textpdf1
	code = code & _
$"
[Alignment=left][b][u]PDF:[/u][/b][list]
[*][url="${urlkomplett}"][color=#FF69B4]${bezpdf1}[/color][/url]"$&CRLF
	
	If textpdf2 <> "" Then
		Dim urlkomplett As String = urlHeilseminare & textpdf2
			code = code & $"[*][url="${urlkomplett}"][color=#FF69B4]${bezpdf2}[/color][/url]"$&CRLF
	End If
	If textpdf3 <> "" Then
		Dim urlkomplett As String = urlHeilseminare & textpdf3
			code = code & $"[*][url="${urlkomplett}"][color=#FF69B4]${bezpdf3}[/color][/url]"$
	End If
	code = code & $"[/list][/alignment]"$
End If
code = code & _
$"
[Alignment=left][b][u]${defwandlung}:[/u][/b][/alignment]
[Alignment=center][img FileName=${wandelimg} width=160 height=160/]
[View=btn Vertical=5/]
${defzentrum}: ${ztext}[/Alignment]
"$

If home.settings.Get("tgabewandlung")=True And txtgabe<>"" Then
	code = code & _
$"
[Alignment=left][b][u]${defgabe}:[/u][/b] [/alignment]
[Alignment=left]${txtgabe}[/alignment]
"$

End If
'Zusatzinformationen anzeigen
#if admin
	If home.settings.Get("tzusatzinfo")=True Then
		Dim	gottheit As String = Main.sql.ExecQuerySingleResult("select Gottheit from Gottheiten JOIN Hexagramme ON Gottheiten.Id = Hexagramme.IdGott where Hexagramme.IdTor="&idtor)
		Dim	gottheittext As String = Main.sql.ExecQuerySingleResult("select Beschreibung from Gottheiten JOIN Hexagramme ON Gottheiten.Id = Hexagramme.IdGott where Hexagramme.IdTor="&idtor)
		Dim element As String = Main.sql.ExecQuerySingleResult("select Element from Hexagramme where IdTor="&idtor)
		Dim amino As String = Main.sql.ExecQuerySingleResult("select Amino from Hexagramme where IdTor="&idtor)
		Dim phs As String = Main.sql.ExecQuerySingleResult("select PHS from Hexagramme where IdTor="&idtor)
		Dim notiz As String = Main.sql.ExecQuerySingleResult("select Notiz from Hexagramme where IdTor="&idtor)
		Dim	enne As String = Main.sql.ExecQuerySingleResult("select Name from Enneagramm JOIN Hexagramme ON Enneagramm.IdEnneagramm = Hexagramme.IdEnneagramm where Hexagramme.IdTor="&idtor)
		Dim progpartner As String = Main.sql.ExecQuerySingleResult("select ProgPartner from Hexagramme where IdTor="&idtor)
		Dim idstz As Int = Main.sql.ExecQuerySingleResult("Select IDSternzeichen from HDLinien where IdTor=" &idtor & " and Linie = " & idlinie)
		Dim lernbereich As String = Main.SQL.ExecQuerySingleResult("select Lernbereich from Sternzeichen where IdSternzeichen='"&idstz&"'")
		Dim tugend As String = Main.SQL.ExecQuerySingleResult("select Tugend from Sternzeichen where IdSternzeichen='"&idstz&"'")
		Dim konsonant As String = Main.SQL.ExecQuerySingleResult("select Konsonant from Sternzeichen where IdSternzeichen='"&idstz&"'")
		Dim sinn As String = Main.SQL.ExecQuerySingleResult("select Sinn from Sternzeichen where IdSternzeichen='"&idstz&"'")
		Dim schuessler As String = Main.SQL.ExecQuerySingleResult("select Schuessler from Sternzeichen where IdSternzeichen='"&idstz&"'")
		Dim notizs As String = Main.SQL.ExecQuerySingleResult("select Notiz from Sternzeichen where IdSternzeichen='"&idstz&"'")

		code = code & _
$"
[Alignment=left][b]Gottheit: [/b]${gottheit}
${gottheittext} [/alignment]
[Alignment=left][b]Element:[/b] ${element}[/alignment]
[Alignment=left][b]Aminosäure:[/b] ${amino}[/alignment]
[Alignment=left][b]Programmierungspartner:[/b] ${progpartner}[/alignment]
[Alignment=left][b]PHS:[/b] ${phs}[/alignment]
[Alignment=left][b]Enneagramm-Typ des Tores:[/b] ${enne}[/alignment]
[Alignment=left][b][u]Notizen:[/u][/b] [/alignment]
[Alignment=left]${notiz}[/alignment]

[Alignment=left][b]Lernbereich:[/b] ${lernbereich}[/alignment]
[Alignment=left][b]Tugend:[/b] ${tugend}[/alignment]
[Alignment=left][b]Konsonant:[/b] ${konsonant}[/alignment]
[Alignment=left][b]Sinn:[/b] ${sinn}[/alignment]
[Alignment=left][b]Schüssler:[/b] ${schuessler}[/alignment]
[Alignment=left][b]Notizen:[/b] ${notizs}[/alignment]
"$	
	End If
#end if
#if admin
	code = code & _
$"
[Alignment=right][View=btnpdf Vertical=5/][/alignment]
"$
#End If
#if b4a                                                                                            
code = code & _
$"
[Alignment=right][View=btnclose Vertical=5/][/alignment]
"$
#end if
	BBCodeView1.Text = code
	#if b4j
		'scrollview ausblenden
		Dim sp As ScrollPane = BBCodeView1.sv
		sp.SetVScrollVisibility("NEVER")
	#end if
	'put BBcodeview1.bottomedgedistance in Designer of cellitemBBItem if the height is cut before the end of the data 
	If BBCodeView1.Paragraph.IsInitialized Then
		Dim ContentHeight As Int = Min(BBCodeView1.Paragraph.Height / textengine.mScale + BBCodeView1.Padding.Top + BBCodeView1.Padding.Bottom, BBCodeView1.mBase.Height)
		BBCodeView1.mBase.Height = ContentHeight
	End If
	BBCodeView1.sv.Height=ContentHeight
	BBCodeView1.sv.ScrollViewContentHeight = ContentHeight	
	p.SetLayoutAnimated(0, 0, 0, clv2.sv.Width, ContentHeight )
	Return p
End Sub

'
'Sub sw_click
'	'Switches bei Status wird geklickt
'	'Progressbar soll auch aktualisiert werden
'	Dim index As Int = clv2.GetItemFromView(Sender)
'	Dim pnl As B4XView = clv2.GetPanel(index)
'	Dim  wert As Float 'Wert wird bei jeder Änderung komplett neu berechnet
'
'	For Each v As B4XView In pnl.GetAllViewsRecursive
'		If v Is CheckBox Then
'			If v.Checked Then
'				'Progressbar um 0,33 erhöhen
'				 wert =  wert + 0.33
'			End If
'		End If
'		If v Is AnotherProgressBar Then
'			Dim prog As AnotherProgressBar = v
'			prog.Value = wert
'		End If
'	Next
'End Sub
#if b4a

public Sub PDFalleToreLinien
	Dim PDFdoc As PrintPdfDocument
	PDFdoc.Initialize
	'PDFdoc = B4Apdferstellen(True,PDFdoc)
	
End Sub
#end if
private Sub zeigeInhalt(nurPDF As Boolean,clv As CustomListView, index As Int, idtor As Int, idlinie As Int, rs As Char) As CustomListView
	'nurPDF = true, es werden alle 284 Tor&Linien ausgegeben
	'index = 0 wenn keine Anzeige in der Listview erfolgt, dann auch kein Rückgabewert

	Dim Query As String = "Select Torname,TorBeschreibung,Schatten,Gabe,Siddhi from Hexagramme where IdTor=" & idtor
	Dim rs3 As ResultSet = Main.sql.ExecQuery(Query)
	Do While rs3.NextRow  'sollte nur eine Zeile sein
		Dim torname As String = rs3.GetString("TorName")
		Dim tortext As String = rs3.GetString("TorBeschreibung")
		Dim schatten As String = rs3.GetString("Schatten")
		Dim gabe As String = rs3.GetString("Gabe")
		Dim siddhi As String = rs3.GetString("Siddhi")
	Loop
	rs3.Close	'wg. Cursor-Allocation Fehler
	
	'Kanäle
	Dim Query As String
	Select True
		Case home.edtBody.SelectedIndex=0:Query = "SELECT KanalA, KanalB, Kanal, Name, Rollen, BeschreibungKanal FROM AktivierteKanaeleRotSchwarz WHERE KanalA ="&idtor&" or KanalB ="&idtor
		Case home.edtBody.SelectedIndex=1:Query = "SELECT KanalA, KanalB, Kanal, Name, Rollen, BeschreibungKanal FROM AktivierteKanaeleRot WHERE KanalA ="&idtor&" or KanalB ="&idtor
		Case home.edtBody.SelectedIndex=2:Query = "SELECT KanalA, KanalB, Kanal, Name, Rollen, BeschreibungKanal FROM AktivierteKanaeleSchwarz WHERE KanalA ="&idtor&" or KanalB ="&idtor
		Case home.edtBody.SelectedIndex=3:Query = "SELECT KanalA, KanalB, Kanal, Name, Rollen, BeschreibungKanal FROM AktivierteKanaeleRotSchwarz WHERE KanalA ="&idtor&" or KanalB ="&idtor
		Case home.edtBody.SelectedIndex=4:Query = "SELECT KanalA, KanalB, Kanal, Name, Rollen, BeschreibungKanal FROM AktivierteKanaele WHERE KanalA ="&idtor&" or KanalB ="&idtor
		Case home.edtBody.SelectedIndex=5:Query = "SELECT KanalA, KanalB, Kanal, Name, Rollen, BeschreibungKanal FROM AktivierteKanaeleNurTransit WHERE KanalA ="&idtor&" or KanalB ="&idtor
		Case Else: Log("Selected Index: "&home.edtbody.selectedIndex)
	End Select
	Dim rs1 As ResultSet = Main.SQL.ExecQuery(Query)
	Dim kanaltext As String = ""
	Dim kanaltor As Int = 0
	Dim kanalname As String = ""
	Dim kanalrolle As String = ""
	Do While rs1.NextRow
		If idtor = rs1.Getint("KanalA") Then 
			kanaltor =  rs1.Getint("KanalB")
			kanaltext = rs1.GetString("BeschreibungKanal")
			kanalname = rs1.GetString("Name")
			kanalrolle = rs1.GetString("Rollen")
		Else
			kanaltor = rs1.Getint("KanalA")
			kanaltext = rs1.GetString("BeschreibungKanal")
			kanalname = rs1.GetString("Name")
			kanalrolle = rs1.GetString("Rollen")
		End If
	Loop
	rs1.close 'wg. Cursor-Allocation Fehler
	
	'Linie
	Dim rs2 As ResultSet = Main.SQL.ExecQuery("select * from HDLinien where IdTor=" &idtor & " and Linie = " & idlinie)
	Do While rs2.NextRow 'sollte nur eine Zeile sein
		Dim textlinie As String = rs2.GetString("Bedeutung")
		Dim fragelinie1 As Object = rs2.GetString("Frage1") 
		If fragelinie1 = Null Then fragelinie1 = ""
		Dim fragelinie2 As Object = rs2.GetString("Frage2") 
		If fragelinie2 = Null Then fragelinie2 = ""
		Dim fragelinie3 As Object = rs2.GetString("Frage3") 
		If fragelinie3 = Null Then fragelinie3= ""
		Dim textaffi1 As Object = rs2.GetString("Affirmation1")  
		If textaffi1 = Null Then textaffi1 = ""
		Dim textaffi2 As Object = rs2.GetString("Affirmation2") 
		If textaffi2 = Null Then textaffi2 = ""
		Dim textaffi3 As Object = rs2.GetString("Affirmation3") 
		If textaffi3 = Null Then textaffi3 = ""

		Dim mp1 As Object = Main.SQL.ExecQuerySingleResult("select Mp3Dateiname from Mp3Inhalte where IdMp3="&rs2.GetString("Mp3Inhalt1"))
		Dim bezmp1 As Object = Main.SQL.ExecQuerySingleResult("select Bezeichnung from Mp3Inhalte where IdMp3="&rs2.GetString("Mp3Inhalt1"))
		If bezmp1 = Null Then bezmp1=""
		If mp1 = Null Then mp1 = ""
		Dim mp2 As Object = Main.SQL.ExecQuerySingleResult("select Mp3Dateiname from Mp3Inhalte where IdMp3="&rs2.GetString("Mp3Inhalt2"))
		Dim bezmp2 As Object = Main.SQL.ExecQuerySingleResult("select Bezeichnung from Mp3Inhalte where IdMp3="&rs2.GetString("Mp3Inhalt2"))
		If mp2 = Null Then mp2 = ""
		If bezmp2=Null Then bezmp2=""
		Dim mp3 As Object = Main.SQL.ExecQuerySingleResult("select Mp3Dateiname from Mp3Inhalte where IdMp3="&rs2.GetString("Mp3Inhalt3"))
		Dim bezmp3 As Object = Main.SQL.ExecQuerySingleResult("select Bezeichnung from Mp3Inhalte where IdMp3="&rs2.GetString("Mp3Inhalt3"))
		If bezmp3=Null Then bezmp3=""
		If mp3 = Null Then mp3 = ""
		Dim pdf1 As Object = Main.SQL.ExecQuerySingleResult("select PdfDateiname from PdfInhalte where IdPdf="&rs2.GetString("PdfInhalt1"))
		Dim bezpdf1 As Object = Main.SQL.ExecQuerySingleResult("select Bezeichnung from PdfInhalte where IdPdf="&rs2.GetString("PdfInhalt1"))
		If pdf1 = Null Then pdf1 = ""
		If bezpdf1=Null Then bezpdf1=""
		Dim pdf2 As Object = Main.SQL.ExecQuerySingleResult("select PdfDateiname from PdfInhalte where IdPdf="&rs2.GetString("PdfInhalt2"))
		Dim bezpdf2 As Object = Main.SQL.ExecQuerySingleResult("select Bezeichnung from PdfInhalte where IdPdf="&rs2.GetString("PdfInhalt2"))
		If pdf2 = Null Then pdf2 = ""
		If bezpdf2=Null Then bezpdf2=""
		Dim pdf3 As Object = Main.SQL.ExecQuerySingleResult("select PdfDateiname from PdfInhalte where IdPdf="&rs2.GetString("PdfInhalt3"))
		Dim bezpdf3 As Object = Main.SQL.ExecQuerySingleResult("select Bezeichnung from PdfInhalte where IdPdf="&rs2.GetString("PdfInhalt3"))
		If pdf3 = Null Then pdf3 = ""
		If bezpdf3=Null Then bezpdf3=""
	Loop
	Dim Query As String = "Select Angst from TorederAngst where IdTor=" & idtor
	Dim txtAngst As String = Main.sql.ExecQuerySingleResult(Query)
	Dim Query As String = "Select Druck from ToreDruck where IdTor=" & idtor
	Dim txtDruck As String = Main.sql.ExecQuerySingleResult(Query)
	Dim Query As String = "Select Liebe from TorederLiebe where IdTor=" & idtor
	Dim txtLiebe As String = Main.sql.ExecQuerySingleResult(Query)
	Dim Query As String = "Select FrustPotential from ToreFrust where IdTor=" & idtor
	Dim txtFrust As String = Main.sql.ExecQuerySingleResult(Query)
	Dim Query As String = "Select Turbo from ToreSchubkraft where IdTor=" & idtor
	Dim txtSchubkraft As String = Main.sql.ExecQuerySingleResult(Query)
	Dim wandelTor As Int = berechneWandelTor(idtor,idlinie)	
	'Zentrum des gewandelten Tores ermitteln
	Dim Query As String = "Select distinct IdZentrum from AlleTore where IdTor=" & wandelTor
	Dim zNeu As Int = Main.sql.ExecQuerySingleResult(Query)
	Dim Query As String = "Select Zentrum from Zentren where IdZentren=" & zNeu
	Dim zText As String = Main.sql.ExecQuerySingleResult(Query)
	Dim Query As String = "Select distinct Torname from AlleTore where IdTor=" & wandelTor
	Dim wName As String = Main.sql.ExecQuerySingleResult(Query)
	Dim Query As String = "Select GabeBeschreibung from Hexagramme where IdTor=" &wandelTor
	Dim txtgabe As Object = Main.sql.ExecQuerySingleResult(Query)
	If txtgabe = Null Then txtgabe = ""
	Dim rotschwarz As Char = rs
	If nurPDF = False Then 'alle Tore/Linien des Users
		Dim Query As String = "Select IdSab from HD where IdUser=" &home.iduser &" and IdTor="& idtor &" and Linie="& idlinie & " and RotSchwarz='"&rotschwarz&"'"
		Dim idsab As Int = Main.SQL.ExecQuerySingleResult(Query)
		Dim Query As String = "Select Beschreibung from SabischeSymbole where IdSab=" &idsab
		Dim txtsab As Object = Main.sql.ExecQuerySingleResult(Query)
		If txtsab = Null Then txtsab = ""
	Else
		rotschwarz="s"
		txtsab=""
	End If
	
	addtoPDFMap(idtor,torname,rotschwarz,tortext,schatten,gabe,siddhi,kanaltext,kanalrolle,kanalname,kanaltor,txtAngst,txtDruck,txtLiebe,txtFrust,txtSchubkraft,idlinie,textlinie,fragelinie1,fragelinie2,fragelinie3,textaffi1,textaffi2,textaffi3,mp1,bezmp1,mp2,bezmp2,mp3,bezmp3,pdf1,bezpdf1,pdf2,bezpdf2,pdf3,bezpdf3,wandelTor,wName,zText,txtgabe,idsab,txtsab) 'Entry for PDF-Print

	If index <> 0 Then
		Dim pnl As B4XView =CreateBBItem(idtor,tortext,schatten,gabe,siddhi,kanaltext,kanalrolle,kanalname,kanaltor,txtAngst,txtDruck,txtLiebe,txtFrust,txtSchubkraft,idlinie,textlinie,fragelinie1,fragelinie2,fragelinie3,textaffi1,textaffi2,textaffi3,mp1,bezmp1,mp2,bezmp2,mp3,bezmp3,pdf1,bezpdf1,pdf2,bezpdf2,pdf3,bezpdf3,wandelTor,wName,zText,txtgabe,idsab,txtsab)
		'Text anzeigen
		pnl.Tag="text"
		clv.InsertAt(index,pnl,"details")
		Return clv
	End If
End Sub

'spielt den Link als MP3 oder MP4 ab oder öffnet PDF- Dokument
Sub BBcodeview1_LinkClicked (URL As String)
	'letzte 3 Buchstaben auswählen ob mp3, mp4 oder pdf
	Dim ext As String = URL.SubString2(URL.Length-3,URL.Length)
	ext = ext.ToLowerCase
	Select True
		Case ext = "mp3" Or ext ="mp4":
				#if b4j
					jfx1.ShowExternalDocument(URL) 'derzeit wird die Lösung bevorzugt im Standardprogramm zu öffnen
				#else
					If home.subsBehandlung = False Then
						home.makeSubscription		'Bei Kauf oder Ablehnung erst mal zurück, bei Kauf wird subsBehandlung gesetzt
						Return
					End If
					home.medien1.mediafile = URL
					B4XPages.ShowPage("medien")
				#end if
		Case ext = "pdf":
				#if b4j
					jfx1.ShowExternalDocument(URL) 'derzeit wird die Lösung bevorzugt im Standardprogramm zu öffnen
				#else
					home.pdfDokument = URL
					B4XPages.ShowPage("PDFAnzeige")
				#End If	
	End Select
		
End Sub

'gibt nur die angewählten Tore in ein PDF aus.
#if b4a
Sub btnpdf_click
	Dim defwarte As String = home.translate(Main.sprache,66)'Bitte etwas Geduld
	Dim defpdf As String = home.translate(Main.sprache,67) 'die PDF-Datei wird erstellt...
	waitmsg.Text = defwarte&CRLF&CRLF&defpdf
	displayWait(waitmsg)
	Sleep(100)
	B4apdfnurausgewaehlteTore
End Sub
#End If

#if b4a
'Schliesst das aktuelle Fenster
Sub btnclose_click
	Dim chkclose As Button = Sender
	Dim index As Int = clv2.GetItemFromView(chkclose)
	clv2.ScrollToItem(index-1)
End Sub
#end if

Sub btn_Click
	'Button Wandeltor in Bbcodeview
	Dim index As Int = clv2.GetItemFromView(Sender)
	Dim pnl As B4XView = clv2.GetPanel(index)
	For Each v As B4XView In pnl.GetAllViewsRecursive
		If v Is Button Then  'https://www.b4x.com/android/forum/threads/getallviewsrecursive-and-is-a-type-of-view.58597/
			Dim stag As String = v.Tag
			If stag.StartsWith("s") Then Continue 'Ist nicht der richtige Button
			Dim Query As String = "Select TorBeschreibung from Hexagramme where IdTor=" & v.tag
			Dim tortext As String = Main.sql.ExecQuerySingleResult(Query)
			xui.MsgboxAsync(tortext, "Tor:"&v.tag)
		End If
	Next
End Sub


Sub btnsab_Click
'Button sabische Symbole
'Zeigt das vorige und folgende sabische Symbol an
'Tag beginnt mit "s", um es vom Button des Wandeltores zu unterscheiden
	Dim index As Int = clv2.GetItemFromView(Sender)
	Dim pnl As B4XView = clv2.GetPanel(index)
	For Each v As B4XView In pnl.GetAllViewsRecursive
		If v Is Button Then  'https://www.b4x.com/android/forum/threads/getallviewsrecursive-and-is-a-type-of-view.58597/
			Dim stag As String = v.Tag
			If stag.StartsWith("s") Then 'Ist der richtige Button
				Dim id1,id2,id3 As Int
				id1 = stag.SubString(1)
				If id1=360 Then 
					id2 = 1
				Else 
					id2 = id1+1
				End If
				If id1=1 Then
					id3 = 360
				Else 
					id3 = id1-1
				End If
				
				Dim img1 As String = id1&"sab.png"
				Dim Query As String = "Select Beschreibung from SabischeSymbole where IdSab=" & id1
				Dim txt1 As String = Main.sql.ExecQuerySingleResult(Query)
				Dim img2 As String = id2&"sab.png"
				Dim Query As String = "Select Beschreibung from SabischeSymbole where IdSab=" & id2
				Dim txt2 As String = Main.sql.ExecQuerySingleResult(Query)
				Dim img3 As String = id3&"sab.png"
				Dim Query As String = "Select Beschreibung from SabischeSymbole where IdSab=" & id3
				Dim txt3 As String = Main.sql.ExecQuerySingleResult(Query)
			
				Dim p As B4XView = xui.CreatePanel("")
				#if b4a
					p.SetLayoutAnimated(0, 0, 0, 100%x, 90%y)
				#else
					p.SetLayoutAnimated(0, 0, 0, 550, 700)
				#End If
				
				p.LoadLayout("bbdialog")
				textengine.Initialize(p)
				textengine.KerningEnabled = True
				Dim code As String = _
$"
[Alignment=center][img FileName=${img3} width=240/]
${txt3}
[Alignment=center][img FileName=${img1} width=240/]
${txt1}
[Alignment=center][img FileName=${img2} width=240/]
${txt2}[/Alignment]
"$
				BBdialog.Text = code
				Dim rs As ResumableSub = dlg.ShowCustom(p, "ok", "", "")
				Wait For (rs) Complete (res As Int)
					
			End If
		End If
	Next
End Sub

#if b4j
	Sub lZentrum_MouseClicked (EventData As MouseEvent)
#else
	Sub lZentrum_Click
#end if
		sortorder.SelectedIndex = 3
		torlisteErstellen
		wait for ListviewReady
End Sub
#if b4j
	Sub lSternzeichen_MouseClicked (EventData As MouseEvent)
#else
	Sub lSternzeichen_Click
#end if	
	#if user
		Return	'Diese Funktion gibt es nicht in user-Verion
	#End If
	Dim index As Int = clv2.GetItemFromView(Sender)
	Dim pnl As B4XView = clv2.GetPanel(index)
	Dim planetA As B4XView = pnl.GetView(4)
	Dim sternzeichen As B4XView = pnl.GetView(5)
	Dim herrscherint As Int = Main.sql.ExecQuerySingleResult("SELECT IdPlanet from Sternzeichen where Sternzeichen ='"&sternzeichen.text&"'")
	Dim planetBString As String = Main.sql.ExecQuerySingleResult("SELECT Planet from Planeten where IdPlanet ="&herrscherint)
	Dim query As String = "SELECT * FROM Konstellationsbilder WHERE PlanetA ='"&planetA.text & "' And planetB ='"& planetBString &"'"
	Dim rs1 As ResultSet = Main.SQL.ExecQuery(query)
	Do While rs1.NextRow
		xui.MsgboxAsync(rs1.GetString("Beschreibung"), home.translate(Main.sprache,69)&": "& planetA.text & " / " & planetBString)
	Loop
End Sub


#if b4j
	Sub lPlanet_MouseClicked (EventData As MouseEvent)
#else
	Sub lPlanet_Click
#end if	
	'Beschreibung und Bild anzeigen
	Dim index As Int = clv2.GetItemFromView(Sender)
	Dim pnl As B4XView = clv2.GetPanel(index)
	Dim planet As B4XView = pnl.GetView(4)
	Dim Cursor As ResultSet
	Cursor = Main.sql.ExecQuery("SELECT BeschreibungS,BeschreibungR,BildS,BildR FROM Planeten where Planet ='"&planet.text&"'")
	Cursor.NextRow
	Dim rotschwarz As Char = planet.tag
	Dim rotschwarzoutput As String
	If rotschwarz="r" Then
		rotschwarzoutput = home.translate(Main.sprache,64) 'rot
	Else
		rotschwarzoutput = home.translate(Main.sprache,63) 'schwarz
	End If
	If rotschwarz = "r" Then
		Dim txt As String = Cursor.Getstring("BeschreibungR")
		Dim img As String = Cursor.Getstring("BildR")
	Else
		Dim txt As String = Cursor.Getstring("BeschreibungS")
		Dim img As String = Cursor.Getstring("BildS")
	End If
	img = img.ToLowerCase
	#if b4j
		xui.Msgbox2Async(txt, planet.Text& " ("&rotschwarzoutput&")", "OK", "", "", xui.LoadBitmap("..\files\",img))
		Wait For Msgbox_Result (Result As Int)
	#else
		Dim p As B4XView = xui.CreatePanel("")
		p.SetLayoutAnimated(0, 0, 0, 100%x, 90%y)
		p.LoadLayout("bbdialog")
		textengine.Initialize(p)
		textengine.KerningEnabled = True
		Dim code As String = _
	$"
[Alignment=Center][img FileName=${img} width=180/]

[b]Planet: ${planet.text} (${rotschwarzoutput})[/b]

[Alignment=Left]${txt}[/Alignment]
	"$
		BBdialog.Text = code
		'p.SetLayoutAnimated(0, 0, 0, BBdialog.mBase.Width, BBdialog.mBase.Height )
		Dim rs As ResumableSub = dlg.ShowCustom(p, "ok", "", "")
		Wait For (rs) Complete (res As Int)
	#End If

End Sub
#If b4a
Private Sub lmeridian_Click
#Else
	Private Sub lmeridian_MouseClicked (EventData As MouseEvent)
#end if	
	home.consumeClick=True			'damit Panel nicht triggert
	Dim was As B4XView = Sender
	home.geklickterMeridian=was.text	
	B4XPages.ShowPage("meridianBehandlung")
End Sub

#if b4j
	Sub lIdtor_MouseClicked (EventData As MouseEvent)
#else
	Sub lIdtor_Click
#end if

	Dim index As Int = clv2.GetItemFromView(Sender)
	Dim pnl As B4XView = clv2.GetPanel(index)
	Dim idtor As B4XView = pnl.GetView(0)
	Dim Cursor As ResultSet
	Cursor = Main.sql.ExecQuery("SELECT TorBeschreibung FROM Hexagramme where IdTor ="& idtor.Text)
	Cursor.NextRow
	Dim txt As String = Cursor.Getstring("TorBeschreibung")
	Dim img As String = "h"&idtor.text&".png"
	img = img.ToLowerCase
	#if b4j
	xui.Msgbox2Async(txt, "Tor "&idtor.text, "OK", "", "", xui.LoadBitmap("..\files\",img))
	Wait For Msgbox_Result (Result As Int)
	#else
		Dim p As B4XView = xui.CreatePanel("")
		p.SetLayoutAnimated(0, 0, 0, 100%x, 90%y)
		p.LoadLayout("bbdialog")
		textengine.Initialize(p)
		textengine.KerningEnabled = True
		Dim code As String = _
	$"
[Alignment=Center][img FileName=${img} width=180/]

[b]Tor: ${idtor.text} [/b]

[Alignment=Left]${txt}[/Alignment]
	"$
		BBdialog.Text = code
	'p.SetLayoutAnimated(0, 0, 0, BBdialog.mBase.Width, BBdialog.mBase.Height )
		Dim rs As ResumableSub = dlg.ShowCustom(p, "ok", "", "")
		Wait For (rs) Complete (res As Int)
	#End If

End Sub

#if b4j
	Sub Iging_MouseClicked (EventData As MouseEvent)
#else
Sub Iging_Click
#end if
	Dim index As Int = clv2.GetItemFromView(Sender)
	Dim pnl As B4XView = clv2.GetPanel(index)
	Dim idtor As B4XView = pnl.GetView(0)
	Dim idlinie As B4XView = pnl.GetView(1)
	Dim igbild As B4XView = pnl.GetView(7) 'Iging
	
	If igbild.tag = "" Then
		'Bild einfügen mit den aktivierten Punkten
		Dim p As B4XView = xui.CreatePanel("")
		#if b4a
		p.SetLayoutAnimated(0, 0, 0, clv2.AsView.Width, 320dip)
		#else
			p.SetLayoutAnimated(0, 0, 0, p.Width, 320)
		#End If
		p.Tag = "iG" 'Um beim Löschen das richtige Bild wieder zu finden
		igbild.Tag="iG"
		p.LoadLayout("cellitemBody")
		#if b4j
		If File.Exists(File.DirData("heilsystem"),"body.png") Then body.SetBitmap(xui.LoadBitmapResize(File.DirData("heilsystem"),"body.png",clv2.AsView.Width,clv2.AsView.Width,True))
		#else
			If File.Exists(home.rp.GetSafeDirDefaultExternal(""),"body.png") Then body.SetBitmap(xui.LoadBitmapResize(home.rp.GetSafeDirDefaultExternal(""),"body.png",clv2.AsView.Width,clv2.AsView.Width,True))
		#end if
	
		Dim wandelTor As Int = berechneWandelTor(idtor.text,idlinie.Text)
		zeichneTorundWandlung(idtor.text,idlinie.Text,wandelTor)
		clv2.InsertAt(index+1,p,"details")
		
	End If
End Sub

''Click Events der Customlistview
''wird derzeit nicht verwendet
'Sub clv2_ItemClick (Index As Int, Value As Object)
'	Select True
'		Case Value = "tordetails":Return  'Click auf Tordetail- Panel
'		Case Value = "text": 'Click auf einen Textbereich
'		Case Value = "Torbild": 'Click auf Torbild
'	End Select
'End Sub

'Es wird nur geladen, was auch sichtbar ist, so brauchen die langen Listen mit allen Toren nur kurze Ladezeiten
Sub clv2_VisibleRangeChanged (FirstIndex As Int, LastIndex As Int)
End Sub

'Zeichnet Schatten, Gabe, Siddhi des Tores auf das Rohbild frequenz.png
Sub zeichneFrequenzstrahl(schatten As String, gabe As String, siddhi As String)
	Dim bmp As B4XBitmap = xui.LoadBitmap(File.DirAssets, "frequenz.png")
	Dim bc As BitmapCreator
	bc.Initialize(640,50)
	bc.CopyPixelsFromBitmap(bmp)
	#if b4j
		Dim bm1 As B4XBitmap = TextToBitmap(150, xui.CreateDefaultFont(18), xui.Color_Black,xui.Color_ARGB(255,204,204,204),schatten)
		Dim bm2 As B4XBitmap = TextToBitmap(150, xui.CreateDefaultFont(18), xui.Color_Black,Main.colGabe,gabe)
		Dim bm3 As B4XBitmap = TextToBitmap(150, xui.CreateDefaultfont(18), xui.Color_Black,Main.colhintergrund,siddhi)
	#else
		If home.screensize < 8 Then
			Dim bm1 As B4XBitmap = TextToBitmap(170, xui.CreateDefaultFont(8), xui.Color_Black,xui.Color_ARGB(255,204,204,204),schatten)
			Dim bm2 As B4XBitmap = TextToBitmap(170, xui.CreateDefaultFont(8), xui.Color_Black,Main.colgabe,gabe)
			Dim bm3 As B4XBitmap = TextToBitmap(170, xui.CreateDefaultfont(8), xui.Color_Black,Main.colhintergrund,siddhi)
		Else
			Dim bm1 As B4XBitmap = TextToBitmap(170, xui.CreateDefaultFont(12), xui.Color_Black,xui.Color_ARGB(255,204,204,204),schatten)
			Dim bm2 As B4XBitmap = TextToBitmap(170, xui.CreateDefaultFont(12), xui.Color_Black,Main.colgabe,gabe)
			Dim bm3 As B4XBitmap = TextToBitmap(170, xui.CreateDefaultfont(12), xui.Color_Black,Main.colhintergrund,siddhi)
		End If
	
	#end if
	lfrequenz.Visible=False 'unsichtbar, nur zur Text- in Bildumwandlung genutzt
	Dim rec As B4XRect
	rec.Initialize(15,8,15+bm1.Width,bm1.Height)
	bc.DrawBitmap(bm1,rec,True)
	rec.Initialize(235,8,235+bm2.Width,bm2.Height)
	bc.DrawBitmap(bm2,rec,True)
	rec.Initialize(450,8,450+bm3.Width,bm3.Height)
	bc.DrawBitmap(bm3,rec,True)
	Dim Out As OutputStream 'abspeichern
	Out = File.OpenOutput(xui.DefaultFolder, "frequenzstrahl.png", False)
	bc.Bitmap.WriteToStream(Out, 100, "PNG")
	Out.Close
End Sub

Sub zeichneTorundWandlung(tor As Int,linie As Int,wandlung As Int)
	'Zeichnet das Ursprungs- und Wandlungstor in das bodygraph
	'Linie des gewandelten Tores wird als identisch angenommen.
	'Über HD-Linien wird IdSternzeichen ermittelt.
	'Die Farbe ist main.farbe(idSternzeichen)
	#if b4j
	Dim bmp As B4XBitmap = xui.LoadBitmap(File.DirData("heilsystem"), "body.png")
	#else
		Dim bmp As B4XBitmap = xui.LoadBitmap(home.rp.GetSafeDirDefaultExternal(""), "body.png")
	#End If

	Dim bc As BitmapCreator
	bc.Initialize(320,300)
	bc.CopyPixelsFromBitmap(bmp)
	'Farben holen
	Dim Query As String = "Select IDSternzeichen from HDLinien where IdTor="& tor & " and Linie = " & linie
	Dim coltor As Int = Main.SQL.ExecQuerySingleResult(Query)
	Dim Query As String = "Select IDSternzeichen from HDLinien where IdTor="& wandlung & " and Linie = " & linie
	Dim colwandlung As Int = Main.SQL.ExecQuerySingleResult(Query)
	'Koordinaten holen
	
	Dim rs1 As ResultSet =Main.sql.ExecQuery("Select * from bodyImage where ROWID="&tor)
	Do While rs1.NextRow
		Dim x As Int = rs1.GetInt("posX")
		Dim xto As Int = rs1.GetInt("posXto")
		Dim y As Int = rs1.GetInt("posY")
		Dim yto As Int = rs1.GetInt("posYto")
		
		bc.DrawLine(x,y,xto,yto,Main.farbe.Get(coltor),8)
	Loop
	'Koordinaten holen Wandlung
	Dim rs1 As ResultSet =Main.sql.ExecQuery("Select * from bodyImage where ROWID="&wandlung)
	Do While rs1.NextRow
		Dim x As Int = rs1.GetInt("posX")
		Dim xto As Int = rs1.GetInt("posXto")
		Dim y As Int = rs1.GetInt("posY")
		Dim yto As Int = rs1.GetInt("posYto")
	
		bc.DrawLine(x,y,xto,yto,Main.farbe.Get(colwandlung),8)
	Loop
	'Legende schreiben
	bc = writeonImage(bc,tor,coltor,wandlung,colwandlung)
	If lastpdfmapId <>"" Then 						'Ausgabe erfolgt in png
		Dim Out As OutputStream
		Out = File.OpenOutput(xui.DefaultFolder, "wandeltor.png", False)
		bc.Bitmap.WriteToStream(Out, 100, "PNG")
		Out.Close
	Else
		body.setBitmap(bc.Bitmap)										'Sets Gravity to CENTER
		'bc.SetBitmapToImageView(bc.Bitmap, body) 		' Alternativ: it sets the Gravity to FILL
	End If
End Sub

Sub writeonImage(bcr As BitmapCreator,tor As String,coltor As Int,wandeltor As String, colWandeltor As Int) As BitmapCreator
	'erstellt Text auf Label und positioniert den Snapshot
#if b4j
	Dim bm As B4XBitmap = TextToBitmap(25, xui.CreateDefaultBoldFont(16), Main.farbe.Get(coltor),xui.Color_White,tor)
#else
	Dim bm As B4XBitmap = TextToBitmap(16dip, xui.CreateDefaultBoldFont(10), Main.farbe.Get(coltor),xui.color_white,tor)
#end if
	Dim rec As B4XRect 
	Dim posX As Int = 220
	Dim posY As Int = 10
	rec.Initialize(posX,posY,posX+bm.Width,posY+bm.Height)
	bcr.DrawBitmap(bm,rec,True)
	posX = posX + bm.Width 
	' -->
	#if b4j
		Dim bm As B4XBitmap = TextToBitmap(25, xui.CreateDefaultBoldFont(16), xui.Color_Black,xui.Color_White,"-->")
	#else
		Dim bm As B4XBitmap = TextToBitmap(15dip, xui.CreateDefaultBoldFont(10), xui.Color_Black,xui.Color_White,"->")
	#end if
	Dim rec As B4XRect
	rec.Initialize(posX,posY,posX+bm.Width,posY+bm.Height)
	bcr.DrawBitmap(bm,rec,True)
	posX = posX + bm.Width 
	' Wandeltor
	#if b4j
		Dim bm As B4XBitmap = TextToBitmap(25, xui.CreateDefaultBoldFont(16), Main.farbe.Get(colWandeltor),xui.Color_White,wandeltor)
	#else
		Dim bm As B4XBitmap = TextToBitmap(15dip, xui.CreateDefaultBoldFont(10), Main.farbe.Get(colWandeltor),xui.Color_White,wandeltor)
	#end if
	Dim rec As B4XRect
	rec.Initialize(posX,posY,posX + bm.Width,posY+bm.Height)
	bcr.DrawBitmap(bm,rec,True)
	
	Return bcr
End Sub
 
 'wird benötigt um auf das Bitmap das Wandlungstor zu schreiben
Sub TextToBitmap (Width As Int, Fnt As B4XFont, Clrtext As Int, clrbackground As Int, Text As Object) As B4XBitmap
	
	Dim x As B4XView  = lfrequenz
	x.Visible = True
	x.Color = clrbackground
	x.Font = Fnt
	x.TextColor = Clrtext
	x.Width = Width
	x.SetLayoutAnimated(0, 0, 0, Width, 70dip)
	#if b4a
		Dim su As StringUtils
		x.Height = su.MeasureMultilineTextHeight(x, Text)
	#else
		x.Height = 40
	#end if
	x.Text = Text
	Return x.Snapshot
End Sub

Sub delIndex(cl As CustomListView, ind As Int)
'löscht alle folgenden Fenster mit Detailinformationen ausser evtl. vorh. planetenbedeutung
'definierte Values: tordetails,details,planetenbedeutung
	Do While ind+1 < clv2.Size
		Log(cl.GetValue(ind+1))
		If cl.GetValue(ind+1) = "details" Then 
			cl.RemoveAt(ind+1)
		Else
			If cl.GetValue(ind+1) = "tordetails" Or cl.GetValue(ind+1)="planetenbedeutung" Then Exit
		End If
	Loop
End Sub

Sub sortorder_SelectedIndexChanged (Index As Int)
	sortorder.SelectedIndex=Index
	home.kvs.Put("sortorder",Index)
	torlisteErstellen
	wait for ListviewReady
End Sub

Sub sequenz_SelectedIndexChanged (Index As Int)
	If Index = 2 Then 'Enneagramm Kabinett
		B4XPages.ShowPage("enneagramm")
	Else
		torlisteErstellen
		wait for ListviewReady
	End If
End Sub

#if b4j
Sub writeTorKopfzeile(p As B4XView, pdfc As pdfBoxCreator,content As JavaObject,font As JavaObject,fontbold As JavaObject,topPos As Float) As Float
'Liest die Views des Panels p aus und
'Schreibt die Tordetails ab der Position posH
'gibt neue Höhenposition zurück
	Dim idtor As B4XView = p.Getview(0)
	Dim idlinie As B4XView = p.GetView(1)
	Dim aspekt As B4XView = p.GetView(2)
	Dim name As B4XView = p.GetView(3)
	Dim planet As B4XView = p.getview(4)
	Dim sternzeichen As B4XView = p.GetView(5)
	Dim zentrum As B4XView = p.GetView(6)
	Dim imgbytes() As Byte =File.ReadBytes("..\files\",idtor.Text&".png")
	Dim mapi As mapitem
	Dim rs As Char
	Dim towrite As List
	
	towrite.Initialize
	
	mapi= pdfmap.Get(lastpdfmapId)
	'Rahmen und Rahmenfarbe andern
	pdfc.setNonStrokingColor(content,239,236,224)
	pdfc.setStrokingColor(content,239,236,224)
	Dim defsonne As String = home.translate(Main.sprache,200)
	Dim deferde As String = home.translate(Main.sprache,201)
	If planet.text = deferde Or planet.text = defsonne And home.iduser <> 0 Then  'Lebensaufgabe
		pdfc.setNonStrokingColor(content,212,176,55)
		pdfc.setStrokingColor(content,212,176,55)
	End If
	pdfc.drawRect(content,pdfLeft,topPos-4,maxPDFwidth-pdfLeft,pdfZeilenhoehe)
	pdfc.fillAndStroke(content)
	rs = mapi.rotschwarz
	If rs = "r" Then 'rot
		pdfc.setNonStrokingColor(content,255,0,0)
	Else
		pdfc.setNonStrokingColor(content,0,0,0)
	End If
	pdfc.drawTextalign(content,fontbold,pdfZeichengroesse,pdfLeft,topPos,idtor.text,20,0,0)
	pdfc.drawTextalign(content,fontbold,pdfZeichengroesse,pdfLeft+25,topPos,idlinie.text,20,0,0)
	pdfc.drawTextalign(content,fontbold,pdfZeichengroesse,pdfLeft+40,topPos,aspekt.text,10,0,0)
	pdfc.drawTextalign(content,fontbold,pdfZeichengroesse,pdfLeft+100,topPos,name.text,300,0,0)
	topPos = topPos - 25
	'change text color back to black
	pdfc.setNonStrokingColor(content,0,0,0)
	pdfc.drawTextalign(content,fontbold,pdfZeichengroesse,pdfLeft+100,topPos,planet.text,90,0,0)
	pdfc.drawTextalign(content,fontbold,pdfZeichengroesse,pdfLeft+170,topPos,sternzeichen.text,90,0,0)
	pdfc.drawTextalign(content,fontbold,pdfZeichengroesse,pdfLeft+260,topPos,zentrum.text,90,0,0)
	pdfc.drawImage(content,imgbytes,"iging",maxPDFwidth-pdfLeft-4,topPos-2,20,20)
	topPos = topPos - 30
	
	If home.settings.Get("Planetbeschreibung")=True Then
		'Planetenbeschreibung dazufügen
		Dim Cursor As ResultSet = Main.sql.ExecQuery("SELECT BeschreibungS,BeschreibungR,BildS,BildR FROM Planeten where Planet ='"&planet.text&"'")
		Cursor.NextRow
		Dim rotschwarz As Char = planet.tag
		If rotschwarz = "r" Then
			Dim txt As String = Cursor.Getstring("BeschreibungR")
			Dim img As String = Cursor.Getstring("BildR")
		Else
			Dim txt As String = Cursor.Getstring("BeschreibungS")
			Dim img As String = Cursor.Getstring("BildS")
		End If
		img = img.ToLowerCase
		Log(img)
		Dim rotschwarzoutput As String
		If rotschwarz="r" Then rotschwarzoutput = home.translate(Main.sprache,64) 'rot
		If rotschwarz="s" Then rotschwarzoutput = home.translate(Main.sprache,63) 'schwarz
		If rotschwarz="t" Then rotschwarzoutput = home.translate(Main.sprache,112)'Transit
		Dim imgbytes() As Byte =File.ReadBytes("..\files\",img)
		Dim bottomBild As Int = topPos - 80
		pdfc.drawImage(content,imgbytes,"",pdfLeft,bottomBild,80,80)
		pdfc.drawTextalign(content,fontbold,pdfZeichengroesse,pdfLeft + 100,topPos,planet.Text& " ("&rotschwarzoutput&")",180,0,0)
		topPos = topPos - pdfZeilenhoehe
		
		towrite.Clear
		towrite = AnpassenAnSeitenbreite(txt,maxZeichen-20) '20 Zeichen weniger wg. Bild links
		For i = 0 To towrite.Size - 1
			Dim txt As String = towrite.Get(i)
			pdfc.drawTextalign(content,font,pdfZeichengroesse,pdfLeft+100,topPos,towrite.Get(i),maxPDFwidth,0,0)
			topPos=topPos-pdfZeilenhoehe
		Next
		If topPos >= bottomBild Then
			topPos = bottomBild - 20 'Neues Bild muss unterhalb des Alten sein.
		Else
			topPos = topPos - 10  'Abstand für neues Bild
		End If
	End If
	
	If home.settings.Get("Konstellationsbild")=True Then
		'Konstellationsbild ermitteln und ausgeben
		Dim defkonst As String = home.translate(Main.sprache,69) 'Konstellationsbild:
		Dim herrscherint As Int = Main.sql.ExecQuerySingleResult("SELECT IdPlanet from Sternzeichen where Sternzeichen ='"&sternzeichen.text&"'")
		Dim planetB As String = Main.sql.ExecQuerySingleResult("SELECT Planet from Planeten where IdPlanet ="&herrscherint)
		Dim query As String = "SELECT * FROM Konstellationsbilder WHERE PlanetA in ('"&planet.text&"','"&planetB&"') and PlanetB in ('"&planet.text&"','"&planetB&"')"
		Dim rs1 As ResultSet = Main.SQL.ExecQuery(query)
		Do While rs1.NextRow  ' sollte nur ein Ergebnis oder kein Ergebnis sein
			pdfc.drawTextalign(content,fontbold,pdfZeichengroesse,pdfLeft,topPos,defkonst&" "& planet.text & " / " & planetB,maxPDFwidth,0,0)
			topPos = topPos - pdfZeilenhoehe
			Dim schreibe As String = rs1.GetString("Beschreibung")
			towrite.Clear
			towrite = AnpassenAnSeitenbreite(schreibe,maxZeichen)
			For i = 0 To towrite.Size - 1
				pdfc.drawTextalign(content,font,pdfZeichengroesse,pdfLeft,topPos,towrite.Get(i),maxPDFwidth,0,0)
				topPos=topPos-pdfZeilenhoehe
			Next
		Loop
	End If
	
	Return topPos
End Sub

Sub writeTorDetails(pdfc As pdfBoxCreator, pages As List, page As JavaObject, content As JavaObject,font As JavaObject,fontbold As JavaObject,topPos As Float) As Float
	'Erstellt Multiline-Text und schreibt diesen
	'Globale pdfmap enthält alle Detail zu diesem TOR/Linie- Eintrag
	Dim mapE As mapitem
	Dim towriteS As String
	Dim towrite As List 'Enthält die Zeilen
	
	towrite.Initialize
	mapE = pdfmap.Get(lastpdfmapId)
	
	'Bedeutung des Tores als Satz formuliert, Zusammenfassung
	Dim idt As Int = mapE.idtor
	Dim idl As Int = mapE.idlinie
	For Each k As Int In sortmap.Keys
		Dim sitem As sortitem = sortmap.Get(k)
		Dim mt As Int = sitem.Tor
		Dim ml As Int = sitem.Linie
		Dim mtm As String = sitem.TorName
		Dim mpb As String = sitem.PlanetBedeutung
		If idt = mt And idl = ml Then
			Dim torbedeutung As String = PositioniereBedeutung(mpb,mtm)
			'Torbedeutung schreiben und exit
			towrite = AnpassenAnSeitenbreite(torbedeutung,maxZeichen)
			For i = 0 To towrite.Size - 1
				pdfc.drawTextalign(content,font,pdfZeichengroesse,pdfLeft,topPos,towrite.Get(i),maxPDFwidth,0,0)
				topPos=topPos-pdfZeilenhoehe
			Next
			Exit
		End If
	Next
	'GrafikTor, Wandelbodygraph, WandeltorGrafik nebeneinander zeichnen
	Dim imgbytes() As Byte =File.ReadBytes("..\files\","h"&mapE.idtor&".png")
	pdfc.drawImage(content,imgbytes,"torgrafik",pdfLeft,topPos-160,160,160)
	Dim imgbytes() As Byte =File.ReadBytes("..\files\","h"&mapE.wandelTor&".png")
	pdfc.drawImage(content,imgbytes,"wandeltor",maxPDFwidth-160,topPos-160,160,160)
	'Wandeltor
	zeichneTorundWandlung(mapE.idtor,mapE.idlinie,mapE.wandelTor)
	Dim imgbytes() As Byte =File.ReadBytes(xui.DefaultFolder,"wandeltor.png")
	pdfc.drawImage(content,imgbytes,"bodygraph",maxPDFwidth/2-80,topPos-160,160,160)
	topPos = topPos - 175
	
	Dim defkanal As String = home.translate(Main.sprache,42) 'Definierter Kanal
	Dim defrolle As String = home.translate(Main.sprache,43) 'Rolle
	Dim defzutor As String = home.translate(Main.sprache,44) 'zu Tor
	Dim deflinie As String = home.translate(Main.sprache,32) 'Linie
	Dim deffragen As String = home.translate(Main.sprache,45) 'Fragen
	Dim defaffirmationen As String = home.translate(Main.sprache,46) 'Affirmationen
	Dim defthema As String = home.translate(Main.sprache,47) 'auf welcher Frequenz lebst du dieses Tor ?
	Dim defwandlung As String = home.translate(Main.sprache,48) 'Wandlung
'	Dim defgabe As String = home.translate(Main.sprache,49) 'Gabe
'	Dim defaudio As String = home.translate(Main.sprache,50) 'Audio
'	Dim defzentrum As String = home.translate(Main.sprache,51) 'in Zentrum
	Dim defsab As String = home.translate(Main.sprache,78) 'Sabische Symbole
	
	'Frequenzstrahl
	pdfc.drawTextalign(content,fontbold,pdfZeichengroesse,pdfLeft,85,defthema,maxPDFwidth,0,0)
	zeichneFrequenzstrahl(mapE.schatten,mapE.gabe,mapE.siddhi)'Erstellt die Datei frequenzstrahl.png im Default- Folder
	Dim imgbytes() As Byte =File.ReadBytes(xui.DefaultFolder,"frequenzstrahl.png")
	pdfc.drawImage(content,imgbytes,"frequenzstrahl",20,30,maxPDFwidth,50)
	'Tortext
	towriteS=mapE.tortext
	towrite = AnpassenAnSeitenbreite(towriteS,maxZeichen)
	'Dim width As Int = MeasureTextWidth(towriteS,xui.CreateDefaultFont(pdfZeilenhoehe))
	For i = 0 To towrite.Size - 1
		pdfc.drawTextalign(content,font,pdfZeichengroesse,pdfLeft,topPos,towrite.Get(i),maxPDFwidth,0,0)
		topPos=topPos-pdfZeilenhoehe
	Next
	pdfc.drawTextalign(content,font,pdfZeichengroesse,pdfLeft,topPos," ",maxPDFwidth,0,0)  'Leerzeile
	topPos=topPos-pdfZeilenhoehe
	
	If mapE.kanaltor<> 0 Then
		'Kanal Header
		topPos=topPos-3 'Kleiner Absatz
		pdfc.drawTextalign(content,fontbold,pdfZeichengroesse,pdfLeft,topPos,defkanal&" "&mapE.kanalname&" "&defzutor&" "&mapE.kanaltor & " ("&defrolle&": "&mapE.kanalrolle&")",maxPDFwidth,0,0)
		topPos=topPos-pdfZeilenhoehe
		'Kanal
		towrite.Clear
		towriteS=mapE.kanaltext
		towrite = AnpassenAnSeitenbreite(towriteS,maxZeichen)
		For i = 0 To towrite.Size - 1
			pdfc.drawTextalign(content,font,pdfZeichengroesse,pdfLeft,topPos,towrite.Get(i),maxPDFwidth,0,0)
			topPos=topPos-pdfZeilenhoehe
		Next
		pdfc.drawTextalign(content,font,pdfZeichengroesse,pdfLeft,topPos," ",maxPDFwidth,0,0)  'Leerzeile
		topPos=topPos-pdfZeilenhoehe
	End If

	'Linientext
	towrite.Clear
	towriteS=mapE.textlinie
	towrite = AnpassenAnSeitenbreite(towriteS,maxZeichen)
	If pdfSeitenichtgenugPlatz(topPos,towrite.Size,pdfZeilenhoehe) Then
		'Neue Seite
		pdfc.closeContent(content)
		page = createNewPage(pdfc,pages)
		content =pdfc.createContent(page,False)
		topPos=pdfc.pageHeight(page)-80
	End If
	'Linientext Header
	topPos=topPos-3 'Kleiner Absatz
	pdfc.drawTextalign(content,fontbold,pdfZeichengroesse,pdfLeft,topPos,deflinie&mapE.idlinie,maxPDFwidth,0,0)
	topPos=topPos-pdfZeilenhoehe
	For i = 0 To towrite.Size - 1
		pdfc.drawTextalign(content,font,pdfZeichengroesse,pdfLeft,topPos,towrite.Get(i),maxPDFwidth,0,0)
		topPos=topPos-pdfZeilenhoehe
	Next
	pdfc.drawTextalign(content,font,pdfZeichengroesse,pdfLeft,topPos," ",maxPDFwidth,0,0)  'Leerzeile
	topPos=topPos-pdfZeilenhoehe
	
'	Dim Empfehlung As Object = Main.SQL.ExecQuerySingleResult("select Empfehlung from Hexagramme where IdTor = "&mapE.idtor)
'	If Empfehlung <> Null And Empfehlung <>"" Then
'		'Empfehlung Header
'		topPos=topPos-3 'Kleiner Absatz
'		pdfc.drawTextalign(content,fontbold,pdfZeichengroesse,pdfLeft,topPos,"Empfehlung: ",maxPDFwidth,0,0)
'		topPos=topPos-pdfZeilenhoehe
'		'Empfehlung
'		towrite.Clear
'		towriteS=Empfehlung
'		towrite = AnpassenAnSeitenbreite(towriteS,maxZeichen)
'		For i = 0 To towrite.Size - 1
'			pdfc.drawTextalign(content,font,pdfZeichengroesse,pdfLeft,topPos,towrite.Get(i),maxPDFwidth,0,0)
'			topPos=topPos-pdfZeilenhoehe
'		Next
'	End If
	If mapE.fragelinie1 <> "" Or mapE.fragelinie2 <>"" Or mapE.fragelinie3 <>"" Then
		'Fragen Header
		topPos=topPos-3 'Kleiner Absatz
		pdfc.drawTextalign(content,fontbold,pdfZeichengroesse,pdfLeft,topPos,deffragen,maxPDFwidth,0,0)
		topPos=topPos-pdfZeilenhoehe
	End If
	If mapE.fragelinie1 <> "" And  mapE.fragelinie1 <>" " Then
		'Frage 1
		towrite.Clear
		towriteS=mapE.fragelinie1
		towrite = AnpassenAnSeitenbreite(towriteS,maxZeichen)
		If pdfSeitenichtgenugPlatz(topPos,towrite.Size,pdfZeilenhoehe) Then
			'Neue Seite
			pdfc.closeContent(content)
			page = createNewPage(pdfc,pages)
			content =pdfc.createContent(page,False)
			topPos=pdfc.pageHeight(page)-80
		End If
		
		For i = 0 To towrite.Size - 1
			pdfc.drawTextalign(content,font,pdfZeichengroesse,pdfLeft,topPos,"¤ "&towrite.Get(i),maxPDFwidth,0,0)
			topPos=topPos-pdfZeilenhoehe
		Next
	End If
	If mapE.fragelinie2 <>"" And mapE.fragelinie2 <>" " Then
		'Frage 2 
		towrite.Clear
		towriteS=mapE.fragelinie2
		towrite = AnpassenAnSeitenbreite(towriteS,maxZeichen)
		If pdfSeitenichtgenugPlatz(topPos,towrite.Size,pdfZeilenhoehe) Then
			'Neue Seite
			pdfc.closeContent(content)
			page = createNewPage(pdfc,pages)
			content =pdfc.createContent(page,False)
			topPos=pdfc.pageHeight(page)-80
		End If
		For i = 0 To towrite.Size - 1
			pdfc.drawTextalign(content,font,pdfZeichengroesse,pdfLeft,topPos,"¤ "&towrite.Get(i),maxPDFwidth,0,0)
			topPos=topPos-pdfZeilenhoehe
		Next
	End If
	If mapE.fragelinie3 <>"" And mapE.fragelinie3 <>" " Then
		'Frage 3
		towrite.Clear
		towriteS=mapE.fragelinie3
		towrite = AnpassenAnSeitenbreite(towriteS,maxZeichen)
		If pdfSeitenichtgenugPlatz(topPos,towrite.Size,pdfZeilenhoehe) Then
			'Neue Seite
			pdfc.closeContent(content)
			page = createNewPage(pdfc,pages)
			content =pdfc.createContent(page,False)
			topPos=pdfc.pageHeight(page)-80
		End If
		For i = 0 To towrite.Size - 1
			pdfc.drawTextalign(content,font,pdfZeichengroesse,pdfLeft,topPos,"¤ "&towrite.Get(i),maxPDFwidth,0,0)
			topPos=topPos-pdfZeilenhoehe
		Next
	End If
	If mapE.textaffi1 <> "" Or mapE.textaffi2 <> "" Or mapE.textaffi3 <> "" Then
		'Affirmationen Header
		topPos=topPos-3 'Kleiner Absatz
		pdfc.drawTextalign(content,fontbold,pdfZeichengroesse,pdfLeft,topPos,defaffirmationen,maxPDFwidth,0,0)
		topPos=topPos-pdfZeilenhoehe
	End If
	If mapE.textaffi1 <> "" Then
		'Affirmationen 1
		towrite.Clear
		towriteS=mapE.textaffi1
		towrite = AnpassenAnSeitenbreite(towriteS,maxZeichen)
		If pdfSeitenichtgenugPlatz(topPos,towrite.Size,pdfZeilenhoehe) Then
			'Neue Seite
			pdfc.closeContent(content)
			page = createNewPage(pdfc,pages)
			content =pdfc.createContent(page,False)
			topPos=pdfc.pageHeight(page)-80
		End If
		For i = 0 To towrite.Size - 1
			pdfc.drawTextalign(content,font,pdfZeichengroesse,pdfLeft,topPos,"¤ "&towrite.Get(i),maxPDFwidth,0,0)
			topPos=topPos-pdfZeilenhoehe
		Next
	End If
	If mapE.textaffi2 <> "" Then
		'Affirmationen 2
		towrite.Clear
		towriteS=mapE.textaffi2
		towrite = AnpassenAnSeitenbreite(towriteS,maxZeichen)
		If pdfSeitenichtgenugPlatz(topPos,towrite.Size,pdfZeilenhoehe) Then
			'Neue Seite
			pdfc.closeContent(content)
			page = createNewPage(pdfc,pages)
			content =pdfc.createContent(page,False)
			topPos=pdfc.pageHeight(page)-80
		End If
		For i = 0 To towrite.Size - 1
			pdfc.drawTextalign(content,font,pdfZeichengroesse,pdfLeft,topPos,"¤ "&towrite.Get(i),maxPDFwidth,0,0)
			topPos=topPos-pdfZeilenhoehe
		Next
	End If
	
	If mapE.textaffi3 <> "" Then
		'Affirmationen 3
		towrite.Clear
		towriteS=mapE.textaffi3
		towrite = AnpassenAnSeitenbreite(towriteS,maxZeichen)
		If pdfSeitenichtgenugPlatz(topPos,towrite.Size,pdfZeilenhoehe) Then
			'Neue Seite
			pdfc.closeContent(content)
			page = createNewPage(pdfc,pages)
			content =pdfc.createContent(page,False)
			topPos=pdfc.pageHeight(page)-80
		End If
		For i = 0 To towrite.Size - 1
			pdfc.drawTextalign(content,font,pdfZeichengroesse,pdfLeft,topPos,"¤ "&towrite.Get(i),maxPDFwidth,0,0)
			topPos=topPos-pdfZeilenhoehe
		Next
	End If
	
	If mapE.txtgabe <>"" Then
		'Gabe nach Wandlung
		topPos=topPos-3 
		towrite.Clear
		towriteS=mapE.txtgabe
		towrite = AnpassenAnSeitenbreite(towriteS,maxZeichen)
		If pdfSeitenichtgenugPlatz(topPos,towrite.Size,pdfZeilenhoehe) Then
			'Neue Seite
			pdfc.closeContent(content)
			page = createNewPage(pdfc,pages)
			content =pdfc.createContent(page,False)
			topPos=pdfc.pageHeight(page)-80
		End If
		pdfc.drawTextalign(content,fontbold,pdfZeichengroesse,pdfLeft,topPos,defwandlung,maxPDFwidth,0,0)
		topPos=topPos-pdfZeilenhoehe
		For i = 0 To towrite.Size - 1
			pdfc.drawTextalign(content,font,pdfZeichengroesse,pdfLeft,topPos,towrite.Get(i),maxPDFwidth,0,0)
			topPos=topPos-pdfZeilenhoehe
		Next
	End If
	
	If mapE.txtsab <>"" Then
		Dim idsab As Int = mapE.idsab
		'Sabisches Symbol
		topPos=topPos-3
		towrite.Clear
		towriteS=mapE.txtsab
		towrite = AnpassenAnSeitenbreite(towriteS,maxZeichen)
		If pdfSeitenichtgenugPlatz(topPos,towrite.Size,pdfZeilenhoehe) Then
			'Neue Seite
			pdfc.closeContent(content)
			page = createNewPage(pdfc,pages)
			content =pdfc.createContent(page,False)
			topPos=pdfc.pageHeight(page)-80
		End If
		pdfc.drawTextalign(content,fontbold,pdfZeichengroesse,pdfLeft,topPos,defsab,maxPDFwidth,0,0)
		topPos=topPos-pdfZeilenhoehe
		For i = 0 To towrite.Size - 1
			pdfc.drawTextalign(content,font,pdfZeichengroesse,pdfLeft,topPos,towrite.Get(i),maxPDFwidth,0,0)
			topPos=topPos-pdfZeilenhoehe
		Next
		
		'Bild sabisches Symbol
		If idsab <> 0 Then
			Dim neuePos As Int = topPos - 240
			If neuePos < maxPDFheight Then
				'Neue Seite
				pdfc.closeContent(content)
				page = createNewPage(pdfc,pages)
				content =pdfc.createContent(page,False)
				topPos=pdfc.pageHeight(page)-80
			End If
			If File.Exists("..\files\",idsab&"sab"&".png") Then
				Dim imgbytes() As Byte =File.ReadBytes("..\files\",idsab&"sab"&".png")
				pdfc.drawImage(content,imgbytes,"sabgrafik",pdfLeft,topPos-240,240,240)
			End If
		End If
	End If
	pdfc.closeContent(content) 'muss sein, sonst Absturz !
	Return topPos
End Sub

'Private Sub MeasureTextWidth (Text As String, Font As B4XFont) As Float
'	Dim lbl As Label
'	lbl.Initialize("")
'	lbl.Text = Text
'	lbl.Font = Font
'	measurePane.AddView(lbl, 0, 0, -1, -1) 'mBase is a B4XView panel.
'	lbl.Snapshot
'	lbl.RemoveNodeFromParent
'	Return lbl.Width
'End Sub

Sub createNewPage(pdfc As pdfBoxCreator,pagelist As List) As JavaObject
	Dim page As JavaObject=pdfc.newPage("A4","P")
	pagelist.Add(page)
	Return page
End Sub

Sub pdfStrategieZentren(pdfc As pdfBoxCreator,pages As List, page As JavaObject, content As JavaObject,font As JavaObject,fontbold As JavaObject,topPos As Float)
	'Schreibt die Strategie des aktuellen Benutzers ins PDF
	Dim towrite As List
	Dim towriteS As String
	towrite.Initialize
	'Ermitteln der Daten
	Dim rs As ResultSet = Main.SQL.ExecQuery("select * from Benutzer where IdName = "&home.iduser)
	rs.NextRow
	Dim z As List
	z.Initialize
	'Dim Name As String = rs.GetString("Name")
	'Dim Vorname As String = rs.GetString("Vorname")
	'Dim Geburtsdatum As String = rs.GetString("Geburtsdatum")
	'Dim Geburtszeit As String = rs.GetString("Geburtszeit")
	Dim HDTyp As String = rs.GetString("HDTyp")
	Dim HDAutoritaet As String = rs.GetString("Autoritaet")
	Dim HDProfil As String = rs.GetString("Profil")
	Dim HDInkarnationskreuz As String = rs.GetString("HDInkarnationskreuz") 'entspricht InName in Tabelle InKreuz
	Dim Ernaehrung As String = rs.GetString("HDErnaehrung")
	Dim NumWeg As String = rs.GetString("NumWeg")
	Dim fuerdich As Object = rs.GetString("FuerDich")
	Dim vSzene As String = rs.GetString("Szene")
	Dim vMotivation As String = rs.GetString("Motivation")
	Dim vKognition As String = rs.GetString("Kognition")
	For i = 0 To 8
		Dim zId As Int = i+1
		If rs.GetString("Z"& zId) = "j" Then
			z.Add(True)
		Else
			z.Add(False)
		End If
	Next
	'Bodygraph
	#if b4j
		Dim imgbytes() As Byte =File.ReadBytes(File.DirData("heilsystem"),"body.png")
	#else
		Dim imgbytes() As Byte =File.ReadBytes(Main.rp.GetSafeDirDefaultExternal(""),"body.png")
	#End If

	pdfc.drawImage(content,imgbytes,"bodygraph",maxPDFwidth/2-80,topPos-160,160,160)
	topPos = topPos - 165
	
	If home.settings.Get("Übersicht")=True Then
		'Bei allen markierten Toren die Torbedeutung ausgeben, die in tor.tag gespeichert wurde
		towrite.Clear
		towriteS = ""
		For eintrag = 0 To clv2.Size-1
			Dim pnl As B4XView = clv2.GetPanel(eintrag)
			If pnl.tag = "j" Then
				Dim tor As B4XView = pnl.GetView(0)  					'Tor
				towriteS=towriteS&tor.Tag&CRLF
				Log(towriteS)
			End If
		Next
		towrite = AnpassenAnSeitenbreite(towriteS,maxZeichen)
		If pdfSeitenichtgenugPlatz(topPos,towrite.Size,pdfZeilenhoehe) Then
			'Neue Seite
			pdfc.closeContent(content)
			page = createNewPage(pdfc,pages)
			content =pdfc.createContent(page,False)
			topPos=pdfc.pageHeight(page)-80
		End If
		Dim defübersicht As String = home.translate(Main.sprache,52)
		pdfc.drawTextalign(content,fontbold,pdfZeichengroesse,pdfLeft,topPos,defübersicht&": ",130,0,0)
		topPos = topPos - pdfZeilenhoehe
		For i = 0 To towrite.Size - 1
			pdfc.drawTextalign(content,font,pdfZeichengroesse,pdfLeft,topPos,towrite.Get(i),maxPDFwidth,0,0)
			topPos=topPos-pdfZeilenhoehe
		Next
		topPos = topPos - pdfZeilenhoehe 'Leerzeile
	End If
	Dim anzeigebasisinfo As Boolean
	anzeigebasisinfo = home.settings.Get("Lebensthema")=True Or home.settings.Get("Typ")=True Or home.settings.Get("Profil")=True Or home.settings.Get("Autoritaet")=True Or home.settings.Get("Ernährung")=True Or home.settings.Get("Numweg") Or home.settings.Get("Szene") Or home.settings.Get("Motivation") Or home.settings.Get("Kognition") Or home.settings.Get("Zentren") Or home.settings.Get("Fragen") Or home.settings.Get("Planetenliste")
	If home.settings.Get("Lebensthema") And anzeigebasisinfo Then 'Auswahlbasisinformation(optionen,1)
		'Inkarnationskreuz, Lebensthema auf eigene Seite
		Dim Beschreibung As Object = Main.SQL.ExecQuerySingleResult("select InBezeichnung from InKreuz where InName = '"&HDInkarnationskreuz&"'")
		If Beschreibung<>Null And Beschreibung<>"" Then
			towrite.Clear
			towriteS=Beschreibung
			towrite = AnpassenAnSeitenbreite(towriteS,maxZeichen)
			If pdfSeitenichtgenugPlatz(topPos,towrite.Size,pdfZeilenhoehe) Then
				'Neue Seite
				pdfc.closeContent(content)
				page = createNewPage(pdfc,pages)
				content =pdfc.createContent(page,False)
				topPos=pdfc.pageHeight(page)-80
			End If
			Dim defthema As String = home.translate(Main.sprache,16)
			pdfc.drawTextalign(content,fontbold,pdfZeichengroesse,pdfLeft,topPos,defthema&": "&HDInkarnationskreuz,130,0,0)
			topPos = topPos - pdfZeilenhoehe
			For i = 0 To towrite.Size - 1
				pdfc.drawTextalign(content,font,pdfZeichengroesse,pdfLeft,topPos,towrite.Get(i),maxPDFwidth,0,0)
				topPos=topPos-pdfZeilenhoehe
			Next
		End If
	End If
	
	'Fuer Dich kommt immer falls in dem Feld in der Tabelle Benutzer was drinnen steht.
	If fuerdich<>Null And fuerdich<>"" Then
		towrite.Clear
		towriteS=fuerdich
		towrite = AnpassenAnSeitenbreite(towriteS,maxZeichen)
		If pdfSeitenichtgenugPlatz(topPos,towrite.Size,pdfZeilenhoehe) Then
			'Neue Seite
			pdfc.closeContent(content)
			page = createNewPage(pdfc,pages)
			content =pdfc.createContent(page,False)
			topPos=pdfc.pageHeight(page)-80
		End If
		For i = 0 To towrite.Size - 1
			pdfc.drawTextalign(content,font,pdfZeichengroesse,pdfLeft,topPos,towrite.Get(i),maxPDFwidth,0,0)
			topPos=topPos-pdfZeilenhoehe
		Next
	End If
	
	'Anzeige Typ
	If home.settings.Get("Typ") And anzeigebasisinfo Then
		topPos=topPos-pdfZeilenhoehe
		'HDTyp
		Dim HDTypBeschreibung As Object = Main.SQL.ExecQuerySingleResult("select  BeschreibungHDTyp from HDTyp where HDTyp = '"&HDTyp&"'")
		If HDTypBeschreibung<>Null And HDTypBeschreibung<>"" Then
			towrite.Clear
			towriteS=HDTypBeschreibung
			towrite = AnpassenAnSeitenbreite(towriteS,maxZeichen)
			If pdfSeitenichtgenugPlatz(topPos,towrite.Size,pdfZeilenhoehe) Then
				'Neue Seite
				pdfc.closeContent(content)
				page = createNewPage(pdfc,pages)
				content =pdfc.createContent(page,False)
				topPos=pdfc.pageHeight(page)-80
			End If
			Dim defdesign As String = home.translate(Main.sprache,53) 'Dein Design:
			pdfc.drawTextalign(content,fontbold,pdfZeichengroesse,pdfLeft,topPos,defdesign&" "&HDTyp,130,0,0)
			topPos = topPos - pdfZeilenhoehe
			For i = 0 To towrite.Size - 1
				pdfc.drawTextalign(content,font,pdfZeichengroesse,pdfLeft,topPos,towrite.Get(i),maxPDFwidth,0,0)
				topPos=topPos-pdfZeilenhoehe
			Next
		End If
	End If
	
	If home.settings.Get("Profil") And anzeigebasisinfo Then
		topPos=topPos-pdfZeilenhoehe
		'HDProfil
		Dim HDProfilBeschreibung As Object = Main.SQL.ExecQuerySingleResult("select BeschreibungProfil from HDProfil where Profil = '"&HDProfil&"'")
		If HDProfilBeschreibung<>Null And HDProfilBeschreibung<>"" Then
			towrite.Clear
			towriteS=HDProfilBeschreibung
			towrite = AnpassenAnSeitenbreite(towriteS,maxZeichen)
			If pdfSeitenichtgenugPlatz(topPos,towrite.Size,pdfZeilenhoehe) Then
				'Neue Seite
				pdfc.closeContent(content)
				page = createNewPage(pdfc,pages)
				content =pdfc.createContent(page,False)
				topPos=pdfc.pageHeight(page)-80
			End If
			Dim deftyp As String = home.translate(Main.sprache,54) 'Dein Typ:
			pdfc.drawTextalign(content,fontbold,pdfZeichengroesse,pdfLeft,topPos,deftyp&" "&HDProfil,130,0,0)
			topPos = topPos - pdfZeilenhoehe
			For i = 0 To towrite.Size - 1
				pdfc.drawTextalign(content,font,pdfZeichengroesse,pdfLeft,topPos,towrite.Get(i),maxPDFwidth,0,0)
				topPos=topPos-pdfZeilenhoehe
			Next
		End If
	End If
	
	If home.settings.Get("Autoritaet") And anzeigebasisinfo Then
		topPos=topPos-pdfZeilenhoehe
		'HDAutoritaet
		Dim Beschreibung As Object = Main.SQL.ExecQuerySingleResult("select BeschreibungAutoritaet  from HDAutoritaet where Autoritaet = '"&HDAutoritaet&"'")
		If Beschreibung<>Null And Beschreibung<>"" Then
			towrite.Clear
			towriteS=Beschreibung
			towrite = AnpassenAnSeitenbreite(towriteS,maxZeichen)
			If pdfSeitenichtgenugPlatz(topPos,towrite.Size,pdfZeilenhoehe) Then
				'Neue Seite
				pdfc.closeContent(content)
				page = createNewPage(pdfc,pages)
				content =pdfc.createContent(page,False)
				topPos=pdfc.pageHeight(page)-80
			End If
			Dim defautorität As String = home.translate(Main.sprache,55) 'Deine Autorität:
			pdfc.drawTextalign(content,fontbold,pdfZeichengroesse,pdfLeft,topPos,defautorität&" "&HDAutoritaet,130,0,0)
			topPos = topPos - pdfZeilenhoehe
			For i = 0 To towrite.Size - 1
				pdfc.drawTextalign(content,font,pdfZeichengroesse,pdfLeft,topPos,towrite.Get(i),maxPDFwidth,0,0)
				topPos=topPos-pdfZeilenhoehe
			Next
		End If
	End If

	If home.settings.Get("Ernährung") And anzeigebasisinfo Then
		topPos=topPos-pdfZeilenhoehe
		'Ernährung
		Dim Beschreibung As Object = Main.SQL.ExecQuerySingleResult("select BeschreibungErnaehrung  from HDErnaehrung where HDErnaehrung = '"&Ernaehrung&"'")
		If Beschreibung<>Null And Beschreibung<>"" Then
			towrite.Clear
			towriteS=Beschreibung
			towrite = AnpassenAnSeitenbreite(towriteS,maxZeichen)
			If pdfSeitenichtgenugPlatz(topPos,towrite.Size,pdfZeilenhoehe) Then
				'Neue Seite
				pdfc.closeContent(content)
				page = createNewPage(pdfc,pages)
				content =pdfc.createContent(page,False)
				topPos=pdfc.pageHeight(page)-80
			End If
			Dim defernährung As String = home.translate(Main.sprache,56) 'Ernährungstyp
			pdfc.drawTextalign(content,fontbold,pdfZeichengroesse,pdfLeft,topPos,defernährung&" "&Ernaehrung,130,0,0)
			topPos = topPos - pdfZeilenhoehe
			For i = 0 To towrite.Size - 1
				pdfc.drawTextalign(content,font,pdfZeichengroesse,pdfLeft,topPos,towrite.Get(i),maxPDFwidth,0,0)
				topPos=topPos-pdfZeilenhoehe
			Next
		End If
	End If
	If home.settings.Get("Numweg") And anzeigebasisinfo Then
		'NumWeg
		Dim Beschreibung As Object = Main.SQL.ExecQuerySingleResult("select BeschreibungNumWeg from NumWeg where NumWeg = "&NumWeg)
		If Beschreibung<>Null And Beschreibung<>"" Then
			towrite.Clear
			towriteS=Beschreibung
			towrite = AnpassenAnSeitenbreite(towriteS,maxZeichen)
			If pdfSeitenichtgenugPlatz(topPos,towrite.Size,pdfZeilenhoehe) Then 
				'Neue Seite
				pdfc.closeContent(content)
				page = createNewPage(pdfc,pages)
				content =pdfc.createContent(page,False)
				topPos=pdfc.pageHeight(page)-80
			End If
			Dim defnumweg As String = home.translate(Main.sprache,57) 'Dein numerlogischer Weg:
			pdfc.drawTextalign(content,fontbold,pdfZeichengroesse,pdfLeft,topPos,defnumweg&" "&NumWeg,130,0,0)
			topPos = topPos - pdfZeilenhoehe
			For i = 0 To towrite.Size - 1
				pdfc.drawTextalign(content,font,pdfZeichengroesse,pdfLeft,topPos,towrite.Get(i),maxPDFwidth,0,0)
				topPos=topPos-pdfZeilenhoehe
			Next
		End If
	End If

	'Szene
	If home.settings.Get("Szene") And anzeigebasisinfo Then
		Dim Beschreibung As Object = Main.SQL.ExecQuerySingleResult("select BeschreibungSzene from Szene where Szene = '"&vSzene&"'")
		If Beschreibung<>Null And Beschreibung<>"" Then
			towrite.Clear
			towriteS=Beschreibung
			towrite = AnpassenAnSeitenbreite(towriteS,maxZeichen)
			If pdfSeitenichtgenugPlatz(topPos,towrite.Size,pdfZeilenhoehe) Then
				'Neue Seite
				pdfc.closeContent(content)
				page = createNewPage(pdfc,pages)
				content =pdfc.createContent(page,False)
				topPos=pdfc.pageHeight(page)-80
			End If
			Dim defszene As String = home.translate(Main.sprache,14) 'Szene
			pdfc.drawTextalign(content,fontbold,pdfZeichengroesse,pdfLeft,topPos,defszene&": "&NumWeg,130,0,0)
			topPos = topPos - pdfZeilenhoehe
			For i = 0 To towrite.Size - 1
				pdfc.drawTextalign(content,font,pdfZeichengroesse,pdfLeft,topPos,towrite.Get(i),maxPDFwidth,0,0)
				topPos=topPos-pdfZeilenhoehe
			Next
		End If
	End If
	
	'Motivation
	If home.settings.Get("Motivation") And anzeigebasisinfo Then
		Dim Beschreibung As Object = Main.SQL.ExecQuerySingleResult("select BeschreibungMotivation from Motivation where Motivation = '"&vMotivation&"'")
		If Beschreibung<>Null And Beschreibung<>"" Then
			towrite.Clear
			towriteS=Beschreibung
			towrite = AnpassenAnSeitenbreite(towriteS,maxZeichen)
			If pdfSeitenichtgenugPlatz(topPos,towrite.Size,pdfZeilenhoehe) Then
				'Neue Seite
				pdfc.closeContent(content)
				page = createNewPage(pdfc,pages)
				content =pdfc.createContent(page,False)
				topPos=pdfc.pageHeight(page)-80
			End If
			Dim defmotivation As String = home.translate(Main.sprache,27) 'Motivation
			pdfc.drawTextalign(content,fontbold,pdfZeichengroesse,pdfLeft,topPos,defmotivation&": "&NumWeg,130,0,0)
			topPos = topPos - pdfZeilenhoehe
			For i = 0 To towrite.Size - 1
				pdfc.drawTextalign(content,font,pdfZeichengroesse,pdfLeft,topPos,towrite.Get(i),maxPDFwidth,0,0)
				topPos=topPos-pdfZeilenhoehe
			Next
		End If
	End If
	
	'Kognition
	If home.settings.Get("Kognition") And anzeigebasisinfo Then
		Dim Beschreibung As Object = Main.SQL.ExecQuerySingleResult("select BeschreibungKognition from Kognition where Kognition = '"&vKognition&"'")
		If Beschreibung<>Null And Beschreibung<>"" Then
			towrite.Clear
			towriteS=Beschreibung
			towrite = AnpassenAnSeitenbreite(towriteS,maxZeichen)
			If pdfSeitenichtgenugPlatz(topPos,towrite.Size,pdfZeilenhoehe) Then
				'Neue Seite
				pdfc.closeContent(content)
				page = createNewPage(pdfc,pages)
				content =pdfc.createContent(page,False)
				topPos=pdfc.pageHeight(page)-80
			End If
			Dim defkognition As String = home.translate(Main.sprache,18) 'Kognition
			pdfc.drawTextalign(content,fontbold,pdfZeichengroesse,pdfLeft,topPos,defkognition&": "&NumWeg,130,0,0)
			topPos = topPos - pdfZeilenhoehe
			For i = 0 To towrite.Size - 1
				pdfc.drawTextalign(content,font,pdfZeichengroesse,pdfLeft,topPos,towrite.Get(i),maxPDFwidth,0,0)
				topPos=topPos-pdfZeilenhoehe
			Next
		End If
	End If
	
	'Zentren
	If home.settings.Get("Zentren") And anzeigebasisinfo Then
		'Zentren immer auf neuer Seite beginnen
		pdfc.closeContent(content)
		page = createNewPage(pdfc,pages)
		content =pdfc.createContent(page,False)
		topPos=pdfc.pageHeight(page)-80
		
		'Zentren
		For i = 0 To 8
			Dim zId As Int = i+1
			Dim rs As ResultSet = Main.SQL.ExecQuery("select * from Zentren where IdZentren ="& zId)
			rs.NextRow
			Dim zentrum As String = rs.getstring("Zentrum")
			Dim beschreibungzentrum As String = rs.getstring("BeschreibungZentrum")
			Dim defJaNein,defJaNeinText,fragen,affi As Object
			If z.Get(i) = True Then
				defJaNein = home.translate(Main.sprache,61) 'DEFINIERT
				defJaNeinText = rs.GetString("Definiert")
				fragen = rs.GetString("FragenDefiniert")
				If fragen = Null Then fragen = ""
				affi = rs.GetString("AffirmationDefiniert") 
				If affi = Null Then affi=""
			Else
				defJaNein = home.translate(Main.sprache,62) 'UNDEFINIERT
				defJaNeinText = rs.GetString("Undefiniert")
				fragen = rs.GetString("FragenUndefiniert")
				If fragen = Null Then fragen=""' Nullwert wird konvertiert in String !
				affi = rs.GetString("AffirmationUndefiniert")
				If affi = Null Then affi=""
			End If
			' Beschreibung Zentren schreiben
			towrite.Clear
			towriteS=beschreibungzentrum
			Log(zentrum&" "&beschreibungzentrum)
			towrite = AnpassenAnSeitenbreite(towriteS,maxZeichen)
			If pdfSeitenichtgenugPlatz(topPos,towrite.Size,pdfZeilenhoehe) Then
				'Neue Seite
				pdfc.closeContent(content)
				page = createNewPage(pdfc,pages)
				content =pdfc.createContent(page,False)
				topPos=pdfc.pageHeight(page)-80
			End If
			Dim defzentrum As String = home.translate(Main.sprache,58) 'Bedeutung des Zentrum 
			pdfc.drawTextalign(content,fontbold,pdfZeichengroesse,pdfLeft,topPos,defzentrum& " "&zentrum&":",maxPDFwidth,0,0)
			topPos=topPos-pdfZeilenhoehe
			For i1 = 0 To towrite.Size - 1
				pdfc.drawTextalign(content,font,pdfZeichengroesse,pdfLeft,topPos,towrite.Get(i1),maxPDFwidth,0,0)
				topPos=topPos-pdfZeilenhoehe
			Next
			pdfc.drawTextalign(content,font,pdfZeichengroesse,pdfLeft,topPos," ",maxPDFwidth,0,0)  'Leerzeile
			topPos=topPos-pdfZeilenhoehe
			'defJaNeinText schreiben
			towrite.Clear
			towriteS=defJaNeinText
			towrite = AnpassenAnSeitenbreite(towriteS,maxZeichen)
			If pdfSeitenichtgenugPlatz(topPos,towrite.Size,pdfZeilenhoehe) Then
				'Neue Seite
				pdfc.closeContent(content)
				page = createNewPage(pdfc,pages)
				content =pdfc.createContent(page,False)
				topPos=pdfc.pageHeight(page)-80
			End If
			Dim defz As String = home.translate(Main.sprache,59) 'Dein Zentrum
			Dim defis As String = home.translate(Main.sprache,60) 'ist
			pdfc.drawTextalign(content,fontbold,pdfZeichengroesse,pdfLeft,topPos,defz&" "&zentrum&" "&defis&" "&defJaNein,maxPDFwidth,0,0)
			topPos=topPos-pdfZeilenhoehe
			For i1 = 0 To towrite.Size - 1
				pdfc.drawTextalign(content,font,pdfZeichengroesse,pdfLeft,topPos,towrite.Get(i1),maxPDFwidth,0,0)
				topPos=topPos-pdfZeilenhoehe
			Next	
			pdfc.drawTextalign(content,font,pdfZeichengroesse,pdfLeft,topPos," ",maxPDFwidth,0,0)  'Leerzeile
			topPos=topPos-pdfZeilenhoehe
			
			'Fragen
			Dim deffragen As String = home.translate(Main.sprache,45) 'Fragen
			If home.settings.Get("Fragen") And anzeigebasisinfo Then
				If fragen <> "" Then
					towrite.Clear
					towriteS=fragen
					towrite = AnpassenAnSeitenbreite(towriteS,maxZeichen)
					If pdfSeitenichtgenugPlatz(topPos,towrite.Size,pdfZeilenhoehe) Then
						'Neue Seite
						pdfc.closeContent(content)
						page = createNewPage(pdfc,pages)
						content =pdfc.createContent(page,False)
						topPos=pdfc.pageHeight(page)-80
					End If
					pdfc.drawTextalign(content,fontbold,pdfZeichengroesse,pdfLeft,topPos,deffragen&":",maxPDFwidth,0,0)
					topPos=topPos-pdfZeilenhoehe
					For i1 = 0 To towrite.Size - 1
						pdfc.drawTextalign(content,font,pdfZeichengroesse,pdfLeft,topPos,towrite.Get(i1),maxPDFwidth,0,0)
						topPos=topPos-pdfZeilenhoehe
					Next
					pdfc.drawTextalign(content,font,pdfZeichengroesse,pdfLeft,topPos," ",maxPDFwidth,0,0)  'Leerzeile
					topPos=topPos-pdfZeilenhoehe
				End If
				
				'Affirmationen
				If affi<>"" Then
					towrite.Clear
					towriteS=affi
					towrite = AnpassenAnSeitenbreite(towriteS,maxZeichen)
					If pdfSeitenichtgenugPlatz(topPos,towrite.Size,pdfZeilenhoehe) Then
						'Neue Seite
						pdfc.closeContent(content)
						page = createNewPage(pdfc,pages)
						content =pdfc.createContent(page,False)
						topPos=pdfc.pageHeight(page)-80
					End If
					Dim defaffi As String = home.translate(Main.sprache,46) 'Affirmationen
					pdfc.drawTextalign(content,fontbold,pdfZeichengroesse,pdfLeft,topPos,defaffi&": ",maxPDFwidth,0,0)
					topPos=topPos-pdfZeilenhoehe
					For i1 = 0 To towrite.Size - 1
						pdfc.drawTextalign(content,font,pdfZeichengroesse,pdfLeft,topPos,towrite.Get(i1),maxPDFwidth,0,0)
						topPos=topPos-pdfZeilenhoehe
					Next
					pdfc.drawTextalign(content,font,pdfZeichengroesse,pdfLeft,topPos," ",maxPDFwidth,0,0)  'Leerzeile
					topPos=topPos-pdfZeilenhoehe
				End If
			End If
		Next
	End If
	
	If home.settings.Get("Planetenliste") And anzeigebasisinfo Then 'pdf Planetenliste
		'Immer neue Seite
		pdfc.closeContent(content)
		page = createNewPage(pdfc,pages)
		content =pdfc.createContent(page,False)
		topPos=pdfc.pageHeight(page)-80
		
		'Planeten
		Dim rs As ResultSet = Main.SQL.ExecQuery("select * from Planeten")
		Do While rs.NextRow
			Dim planet As String = rs.getstring("Planet")
			Dim beschreibungR As String = rs.getstring("BeschreibungR")
			Dim bildR As String = rs.getstring("BildR")
			Dim beschreibungS As String = rs.getstring("BeschreibungS")
			Dim bildS As String = rs.getstring("BildS")
			towrite.Clear
			beschreibungS= beschreibungS.Replace(Chr(10),"") '0a- Werte sicher entfernen
			beschreibungR= beschreibungR.Replace(Chr(10),"") '0a- Werte sicher entfernen
			
			'Ausgabe beginnen Schwarz
			towrite = AnpassenAnSeitenbreite(beschreibungS,maxZeichen-15) '15 Zeichen weniger durch Bild links
			Dim bildgroesse As Int = 100
			Dim zeilenzahl As Int = towrite.Size
			Dim hoehe As Int = pdfZeilenhoehe
			If (zeilenzahl * pdfZeilenhoehe) <= bildgroesse Then 'Bild muss draufpassen
				zeilenzahl = 1
				hoehe = 100
			End If
			If pdfSeitenichtgenugPlatz(topPos,zeilenzahl,hoehe) Then
				'Neue Seite
				pdfc.closeContent(content)
				page = createNewPage(pdfc,pages)
				content =pdfc.createContent(page,False)
				topPos=pdfc.pageHeight(page)-80
			End If
			Dim imgbytes() As Byte =File.ReadBytes("..\files\",bildS)
			Dim bottomBild As Int = topPos - bildgroesse
			pdfc.drawImage(content,imgbytes,"",pdfLeft,bottomBild,bildgroesse,bildgroesse)
			Dim defrs As String = home.translate(Main.sprache,63) 'schwarz
			pdfc.drawTextalign(content,fontbold,pdfZeichengroesse,130,topPos,planet & " ("&defrs&")",180,0,0)
			topPos = topPos - pdfZeilenhoehe
			For i = 0 To towrite.Size - 1
				pdfc.drawTextalign(content,font,pdfZeichengroesse,130,topPos,towrite.Get(i),maxPDFwidth,0,0)
				topPos=topPos-pdfZeilenhoehe
			Next
			If topPos >= bottomBild Then 
				topPos = bottomBild - 20 'Neues Bild muss unterhalb des Alten sein.
			Else
				topPos = topPos - 10  'Abstand für neues Bild
			End If
			
			'Ausgabe beginnen Rot
			towrite = AnpassenAnSeitenbreite(beschreibungR,maxZeichen-15) '15 Zeichen weniger durch Bild links
			Dim bildgroesse As Int = 100
			Dim zeilenzahl As Int = towrite.Size
			Dim hoehe As Int = pdfZeilenhoehe
			If (zeilenzahl * pdfZeilenhoehe) <= bildgroesse Then 'Bild muss draufpassen
				zeilenzahl = 1
				hoehe = 100
			End If
			If pdfSeitenichtgenugPlatz(topPos,zeilenzahl,hoehe) Then
				'Neue Seite
				pdfc.closeContent(content)
				page = createNewPage(pdfc,pages)
				content =pdfc.createContent(page,False)
				topPos=pdfc.pageHeight(page)-80
			End If
			Dim imgbytes() As Byte =File.ReadBytes("..\files\",bildR)
			Dim bottomBild As Int = topPos - bildgroesse
			pdfc.drawImage(content,imgbytes,"",pdfLeft,bottomBild,bildgroesse,bildgroesse)
			Dim defrs As String = home.translate(Main.sprache,64) 'rot
			pdfc.drawTextalign(content,fontbold,pdfZeichengroesse,130,topPos,planet & " ("&defrs&")",180,0,0)
			topPos = topPos - pdfZeilenhoehe
			For i = 0 To towrite.Size - 1
				pdfc.drawTextalign(content,font,pdfZeichengroesse,130,topPos,towrite.Get(i),maxPDFwidth,0,0)
				topPos=topPos-pdfZeilenhoehe
			Next
			If topPos >= bottomBild Then
				topPos = bottomBild - 20 'Neues Bild muss unterhalb des Alten sein.
			Else
				topPos = topPos - 10  'Abstand für neues Bild
			End If
		Loop
	End If
	pdfc.closeContent(content)
End Sub

Sub pdferstellen
	'Schatzkarte PDF den ausgewählten Optionen und den aufgeblätterten Toren anzeigen

	Dim pdfcreator As pdfBoxCreator
	Dim page,content As JavaObject
	Dim pages As List
	Dim font,fontbold As JavaObject
	Dim textzeilen As List
	Dim top As Float
	
	pdfcreator.Initialize("pts")  'nach Bildpunkte intitialisieren
	font=pdfcreator.createFont("TIMES_ROMAN")
	fontbold=pdfcreator.createFont("TIMES_BOLD")
	pages.Initialize
	textzeilen.Initialize
	
	'Erste Seite erstellen
	page = createNewPage(pdfcreator,pages)
	content = pdfcreator.createContent(page,False)
	top=pdfcreator.pageHeight(page)-80
	
	'Strategie und Zentren ausgeben
	pdfStrategieZentren(pdfcreator,pages,page,content,font,fontbold,top)
	pdfcreator.closeContent(content)

	'Alle markierten Tore der CLV ausgeben
	For eintrag = 0 To clv2.Size-1
		Dim pnl As B4XView = clv2.GetPanel(eintrag)
		If pnl.Tag="j" Then 'j = chkbox ist markiert
			'Neue Seite für Tore
			page = createNewPage(pdfcreator,pages)
			content = pdfcreator.createContent(page,False)
			top=pdfcreator.pageHeight(page)-80
			'aktualisiere Index für PDF Erzeugen
			lastpdfmapId = pnl.Getview(0).text & "," & pnl.Getview(1).text
			'Kopfzeile und Tordetails
			top = writeTorKopfzeile(pnl,pdfcreator,content,font,fontbold,top)
			top = writeTorDetails(pdfcreator,pages,page,content,font,fontbold,top)
			pdfcreator.closeContent(content)
		End If
	Next
	
	'load image to byte array
	Dim img As Image=jfx1.LoadImage(File.DirAssets,"logo.png")
	Dim imgbytes() As Byte=Sammlung.ImageToBytes(img)
	
	DateTime.DateFormat="dd.MM.yyyy"
	Dim t As String=DateTime.Date(DateTime.Now)
	Dim n As Int=pages.Size
	
	'loop over each page to add footer
	For i=1 To pages.Size
		Dim page As JavaObject=pages.Get(i-1)
		Dim content As JavaObject=pdfcreator.createContent(page,True)
		pdfcreator.drawText(content,font,8,pdfLeft,10,$"${t}"$)
		pdfcreator.drawText(content,font,8,255,15,Chr(169)&" "&"heilseminare.com")
		pdfcreator.drawTextAlign(content,font,8,pdfLeft,15,$"Seite ${i}/${n}"$,560,2,0)
		pdfcreator.drawImage(content,imgbytes,"logo.png",pdfLeft,790,40,40)
		Dim defschatz As String = home.translate(Main.sprache,65) 'Schatzkarte für
		pdfcreator.drawTextAlign(content,font,18,pdfLeft+100,805,defschatz&" "& home.lblPerson.text,500,0,0)
		pdfcreator.closeContent(content)
		pdfcreator.addPage(page)
	Next
	
	'write pdf to stream (array of byte)
	Dim ost As OutputStream
	ost.InitializeToBytesArray(0)
	pdfcreator.saveToStream(ost)
	pdfcreator.close
	File.WriteBytes(xui.DefaultFolder,home.lblPerson.Text&".pdf",ost.ToBytesArray)
	
	'jfx1.ShowExternalDocument(File.GetUri(xui.DefaultFolder, home.lblPerson.Text&".pdf")) 'Anzeige im externen Standard PDF- Viewer
	'Anzeige mit interner Lösung des PDF-Viewers
	Dim b() As Byte=ost.ToBytesArray
	'prepare preview window
	Dim f As clsFormPDF
	f.Initialize(Me,"pdfpreview",Main.MainForm,b,100,Null)
	'show preview window
	f.Show
End Sub


Sub PDFdoc_CloseComplete(Success As Boolean)
	If Success Then
		jfx1.ShowExternalDocument(File.GetUri(xui.DefaultFolder, home.lblPerson.Text&".pdf"))
	Else
		Log("An error has occurred and creation of the PDF document has failed")
	End If
End Sub
#end if


Sub pdfSeitenichtgenugPlatzBild(topPos As Int,picheight As Int) As Boolean
	
	#if b4j
		Dim platz As Int = picheight
		Dim neuePos As Int = topPos - platz
		If neuePos < maxPDFheight Then
			Log("Resthöhe Seite:"&neuePos)
			 Return True
		End If
	#else
		Dim platz As Int = picheight 
		Dim neuePos As Int = topPos + platz
		If neuePos > maxPDFheight Then 
			Log("Neue Seite weil neuePos="&neuePos&" bei maxPDFheight="&maxPDFheight)
			Return True
		End If
	#end if
	Return False

End Sub

Sub pdfSeitenichtgenugPlatz(topPos As Int,anzZeilen As Int,rowheight As Int) As Boolean
	
	#if b4j
		Dim platz As Int = (anzZeilen+1) * (rowheight+3) 'Angenommen 3 Punkte für Zwischenraum
		Dim neuePos As Int = topPos - platz
		If neuePos < maxPDFheight Then
			Log("Resthöhe Seite:"&neuePos)
			 Return True
		End If
	#else
	Dim platz As Int = (anzZeilen+1) * (rowheight+3) '+1 weil normal immer noch die Überschrift zusätzlich geschrieben wird
		Dim neuePos As Int = topPos + platz
		If neuePos > maxPDFheight Then 
			Log("Neue Seite weil neuePos="&neuePos&" bei maxPDFheight="&maxPDFheight)
			Return True
		End If
	#end if
	Return False

End Sub

Sub displayWait(texta As B4XLongTextTemplate)
	'Zeigt dem Anwender einen Dialog, dass er sich etwas gedulden soll, schliesst automatisch
	If dlg.IsInitialized=False Then dlg.Initialize(Root)
	Dim delaytext As B4XTimedTemplate
	delaytext.Initialize(texta)
	delaytext.TimeoutMilliseconds=1000
	dlg.ShowTemplate(delaytext, "", "", "")
End Sub

#if b4a
Sub PDFquick_CLICK
	Dim defwarte As String = home.translate(Main.sprache,66)'Bitte etwas Geduld
	Dim defpdf As String = home.translate(Main.sprache,67) 'die PDF-Datei wird erstellt...
	Dim PDFdoc As PrintPdfDocument
	waitmsg.Text = defwarte&CRLF&CRLF&defpdf
	displayWait(waitmsg)
	Sleep(100)
	'nochmal die Datei bodygraphexakt.png erzeugen, falls der Vergrösserungs- Button nie gedrückt wurde
	home.statusZentrenWerte=home.PersonNeu1.berechnedefiniertezentren(0)
	home.zeichneBodyExakt("bodygraphdetail.png","bodygraphexakt.png",home.statusZentrenWerte,0)	'sichert in bodygraphexakt.png mit HD-Anzeige
	home.zeichneToreLinien(home.iduser,"bodygraphexakt.png",False)'Zeichnet die Roten und Schwarzen Tore/Linien
	PDFdoc.Initialize
	B4Apdfquick(True,PDFdoc)
	'PDF anzeigen mit PDFIUM
	B4XPages.ShowPage("PDFAnzeige")
End Sub
#end if


Sub PDF_Click
	Dim defwarte As String = home.translate(Main.sprache,66) 'Bitte etwas Geduld
	Dim defpdf As String = home.translate(Main.sprache,67) 'die PDF-Datei wird erstellt...
	#if b4a
		Dim PDFdoc As PrintPdfDocument	'PDFDoc kann auch übergebene Instanz sein, muss nicht zurückgegeben werden, wenn man weiter schreiben will
	#end if
	Dim pages As Int				'Pages müssen zurückgegeben werden, wenn man in offene PDFdoc weiter schreiben will
	waitmsg.Text = defwarte&CRLF&CRLF&defpdf
	displayWait(waitmsg)
	Sleep(100)
	'nochmal die Datei bodygraphexakt.png erzeugen, falls der Vergrösserungs- Button nie gedrückt wurde
	home.statusZentrenWerte=home.PersonNeu1.berechnedefiniertezentren(0)
	home.zeichneBodyExakt("bodygraphdetail.png","bodygraphexakt.png",home.statusZentrenWerte,0)	'sichert in bodygraphexakt.png mit HD-Anzeige
	home.zeichneToreLinien(home.iduser,"bodygraphexakt.png",False)'Zeichnet die Roten und Schwarzen Tore/Linien
	#if b4j
		pdferstellen
	#else
		PDFdoc.Initialize
		pages = B4Apdfquick(False,PDFdoc)
		B4Apdferstellen(False,PDFdoc,pages)
	#End If
	

End Sub


#if b4j
Sub lblthema_MouseClicked (EventData As MouseEvent)
#else
	Sub lblthema_Click
#end if	
	'Diese Funktion soll nur 1 x je Tag ausgeführt werden können
	'das Thema des Tages wird ansonsten wieder angezeigt.
	Dim anz As Int = clv2.Size
	If home.kvs.ContainsKey("indexTagesthema") Then
		Dim indexDatum As Long = home.kvs.get("indexDatum")
		Dim index As Int = home.kvs.Get("indexTagesthema")
	Else
		Dim indexDatum As Long = DateTime.Now
		Dim index As Int = 0
	End If
	If DateTime.GetDayOfYear(indexDatum) <> DateTime.GetDayOfYear(DateTime.now) Or index = 0 Then 'Nur einmal je Tag auswählen
		Dim sf As Object = xui.Msgbox2Async(home.translate(Main.sprache,117),home.translate(Main.sprache,118) ,home.translate(Main.sprache,119), "", home.translate(Main.sprache,102),xui.LoadBitmap(File.DirAssets,"hoeheresselbst.jpg"))
		Wait For (sf) Msgbox_Result (Result As Int)
		If Result <> xui.DialogResponse_Positive Then Return
		Dim index As Int = Rnd(0,anz)
		home.kvs.Put("indexTagesthema",index)
		home.kvs.Put("indexDatum", DateTime.Now)
	End If
	
	Do While True
		Dim pnl As B4XView = clv2.GetPanel(index)
		Log (pnl.numberofviews)
		If pnl.NumberOfViews = 1 Then
			If index < anz Then 
				index = index + 1
			Else
				index = 0
			End If
			Continue
		End If
		
		Dim idlinie As B4XView = pnl.GetView(1)
		Exit
	Loop

	'Checkpdf aendern
	For Each v As B4XView In pnl.GetAllViewsRecursive
		If v Is CheckBox Then
			v.checked=True	'dadurch wird checkpdf_checkedChange Event ausgeführt
		End If
	Next
	'Dim chk As CheckBox = pnl.GetView(9).tag 'Neue Konvention bei Customlistview
	
	idlinie.Tag="text"
	pnl.Tag="j" 
	clv2.ScrollToItem(index) 

End Sub


'Wird durch Betätigung der checkpdf-Checkbox ausgeführt
Sub checkpdf_CheckedChange(Checked As Boolean)
	Dim chk As CheckBox = Sender
	If chk.IsInitialized = False Then Return 'programmtechnisch lblthema_click
	If chk.tag = "progClose" Then Return 'programmtechnisch geschlossen in btnclose_click
	Dim index As Int = clv2.GetItemFromView(chk)
	Dim pnl As B4XView = clv2.GetPanel(index)
	Dim idtor As B4XView = pnl.Getview(0)
	Dim idlinie As B4XView = pnl.GetView(1)
	Dim lPlanet As B4XView = pnl.GetView(4) 'im Tag wurde RotSchwarz gespeichert, was wichtig ist um die richtigen Planetentexte zu ermitteln
	
	If Checked Then
		idlinie.Tag="text"
		pnl.Tag="j" 'wird benoetigt, da man den direkten Status der checkbox in der customlistbox später nicht abfragen kann
		'https://www.b4x.com/android/forum/threads/b4x-how-to-get-custom-view-here-from-clv-or-any-other-container.117992/
		clv2 = zeigeInhalt(False,clv2,index+1,idtor.text,idlinie.text,lPlanet.tag) 
	Else
		pnl.Tag="n"
		Iging.Tag="" 'um Bild bei erneutem Click auf Iging wieder erscheinen zu lassen
		If idlinie.Tag = "text" Then
			delIndex(clv2,index)
			idlinie.Tag = ""
		End If
	End If
End Sub

Sub AnpassenAnSeitenbreite(s As String, anzahlZeichen As Int) As List
	'Passt s an die PDF-Seitenbreite(A4), welche anzahlzeichen Breite hat
	'Ist an der Stelle maxPDFWidth kein Leerzeichen, dann zurück zum letzten Leerzeichen
	'Kommt ein CRLF, dann Zeilenumbruch.
	Dim l As List
	Dim ss As String
	Dim c As Char
	Dim indStart As Int = 0
	Dim indEnd As Int
	
	Dim weitererInhalt As Boolean = True
	l.Initialize
	
	Dim o As Object = s
	If o = Null Then s=""
	If s.Length = 0 Then
		Return l
	End If
	
	'▲ Zeichen ersetzen
	s = s.replace("▲","+")
	s = s.replace("▼","-")
	
	'Bei Zeichenfolge =bild1 oder =bild2, String kuerzen
	Dim ind As Int
	If s.indexof("=bild1")<>-1 Then ind = s.indexof("=bild1")
	If s.indexof("=bild2")<>-1 Then ind = s.indexof("=bild2")
	If ind<>-1 And ind<>0 Then
		s=s.SubString2(0,ind)
	End If
	
	If s.Length <= anzahlZeichen Then
		'Strings kleiner als Zeilenbreite ggfls. aufteilen, wenn ein Chr(10) vorkommt.
		Dim leerzeichen As Char = Chr(10) 'LF \n
		If  (s.Indexof(leerzeichen)<> -1) Then
			Do While (s.IndexOf(leerzeichen)<> -1)
				ss = s.SubString2(0,s.IndexOf(leerzeichen))
				l.Add(ss)
				s = s.SubString2(s.IndexOf(leerzeichen)+1,s.Length)
			Loop
		Else
			l.Add(s)
		End If
		Return l
	End If

	'Längere Strings als Zeilenbreite aufteilen. Bei jedem Chr(10) eine neue Zeile beginnen.
	'Ablauf:
	'String bis max. Breite lesen
	'kommt Chr(10) darin vor ? Wenn ja, dann ersten Teil in Liste schreiben, wenn nein, dann bis zum letzten " " zurück und position merken.
	'Neuen Substring lesen bis max. Breite
	Do While weitererInhalt
		Try
			ss = s.SubString2(indStart,indStart+anzahlZeichen)
			Dim pos As Int = ss.IndexOf(Chr(10))
			If pos <> -1 Then 'In der Zeile ist ein Chr(10)
				indEnd = indStart + pos
				ss = s.SubString2(indStart,indEnd)
			Else
				indEnd = indStart +anzahlZeichen
				c=s.SubString2(indEnd,indEnd+1)
				Do While c <> " "
					indEnd = indEnd - 1
					c=s.SubString2(indEnd,indEnd+1)
				Loop
				ss = s.SubString2(indStart,indEnd)
			End If
			indStart = indEnd + 1
		Catch  'Letzte Zeile
			ss=s.SubString2(indStart,s.Length)
			'Auch in der letzten Zeile noch nach allen Chr(10) Zeichen die Zeile schreiben
			Do While (ss.IndexOf(Chr(10))<> -1)
				Dim ss1 As String = ss.SubString2(0,ss.IndexOf(Chr(10)))
				l.Add(ss1)
				ss = ss.SubString2(ss.IndexOf(Chr(10))+1,ss.Length)
			Loop
			weitererInhalt = False
		End Try
		
		ss = ss.Trim
		l.Add(ss)
	Loop
	Return l	'Liste mit Zeilen zurückgeben
End Sub

#if b4a
Sub B4Apdfquick(nurquick As Boolean,PDFdoc As PrintPdfDocument) As Int
	'erstellt eine Kurzübersicht mit Bodygraph und der Torbedeutungen um Anwender für das Sytem zu interessieren
	'nurquick = true, wenn nur Kurzübersicht erstellt werden soll ausgegeben werden sollen
	'pages (Anzahl bereits geschriebener Seiten) wird zurückgegeben
	Dim rt As RuntimePermissions
	Dim firstpos As Float = 85
	Dim pages As Int = 0
	
	'Erste Seite anlegen
	PDFdoc.StartPage(595, 842)
	pages=pages+1
	B4ApdfwriteKopfFuss(PDFdoc,pages)
	'Strategie und Zentren ausgeben
	pages = B4ApdfStrategieZentren(nurquick,PDFdoc,firstpos,pages)
	
	ToastMessageShow(home.translate(Main.sprache,105),True)
	
	Dim Out As OutputStream
	#if user
		Dim dir As String = File.dirinternal
	#Else
		Dim dir As String = rt.getSafeDirDefaultExternal("")
	#End If
	
	If nurquick = True Then
		home.pdfDokument=home.lblPerson.Text&".pdf"
		Out = File.OpenOutput(dir,home.pdfDokument, False)
		PDFdoc.WriteToStream(Out)
		ToastMessageShow(home.translate(Main.sprache,106),False)
		Log("PDF-Datei erzeugt!")
		Out.Close
		PDFdoc.Close
	End If
	Return pages
End Sub

Sub	B4apdfnurausgewaehlteTore	
	Dim PDFdoc As PrintPdfDocument
	Dim top As Float
	Dim firstpos As Float = 85
	Dim endedetailtext As Boolean = False
	Dim pages As Int = 0
	Dim rt As RuntimePermissions
	
	PDFdoc.Initialize
	home.emailLinklist.Initialize

	'Neue Seite
	PDFdoc.StartPage(595, 842) 'Neue Seite
	top = firstpos
	pages=pages+1
	B4ApdfwriteKopfFuss(PDFdoc,pages)
	
	'Alle gezeigten Tortexte der CLV ausgeben
	For eintrag = 0 To clv2.Size-1
		Dim pnl As B4XView = clv2.GetPanel(eintrag)
		Dim tags As Object = pnl.tag
		If tags = Null Then Continue	'Bei B4a kann Tagwert Null haben
		If pnl.Tag="j" Then 'Checkbox checked
			If endedetailtext Then	'kommt noch eine Seite dazu
				endedetailtext = False
				PDFdoc.FinishPage
				PDFdoc.StartPage(595, 842) 'Neue Seite
				top = firstpos
				pages=pages+1
				B4ApdfwriteKopfFuss(PDFdoc,pages)
			End If
			'			'aktualisiere Index für PDF Erzeugen
			lastpdfmapId = pnl.Getview(0).text & "," & pnl.Getview(1).text
			Dim idt As Int = pnl.Getview(0).text
			Dim idl As Int = pnl.Getview(1).text
			Dim name As B4XView = pnl.GetView(3)
			Dim planet As B4XView = pnl.getview(4)
'			Dim sternzeichen As B4XView = pnl.GetView(5)
			Dim zentrum As B4XView = pnl.GetView(6)
			Dim mapi As mapitem
			Dim rs As Char
			mapi= pdfmap.Get(lastpdfmapId)
			rs = mapi.rotschwarz
			Dim idz As Int = Main.SQL.ExecQuerySingleResult("Select IdZentren from Zentren where Zentrum = '"&zentrum.text&"'")
			Dim Query As String = "Select IdSab from HD where IdUser=" &home.iduser &" and IdTor="& idt &" and Linie="& idl & " and RotSchwarz='"&rs&"'"
			Dim idsab As Int = Main.SQL.ExecQuerySingleResult(Query)

			top = B4AwriteTorKopfzeile(False,PDFdoc,top,idt,idl,rs,name.text,planet.text,idsab,idz)
			top = B4AwriteTorDetails(PDFdoc,firstpos,pages,top)
			endedetailtext = True
		End If
	Next
	'PDF abspeichern
	PDFdoc.FinishPage
	ToastMessageShow(home.translate(Main.sprache,105),True)
	Dim Out As OutputStream
	#if user
		Dim dir As String = file.dirinternal
	#Else
	Dim dir As String = rt.getSafeDirDefaultExternal("")
	#End If
	
	
	home.pdfDokument="aktuelleTorauswahl.pdf"
	Out = File.OpenOutput(dir,home.pdfDokument, False)
	PDFdoc.WriteToStream(Out)
	ToastMessageShow(home.translate(Main.sprache,106),False)
	Log("PDF-Datei erzeugt!")
	Out.Close
	PDFdoc.Close
	'PDF anzeigen mit PDFIUM
	B4XPages.ShowPage("PDFAnzeige")
End Sub

Sub B4Apdferstellen(nurPDF As Boolean,PDFdoc As PrintPdfDocument,pages As Int)  'mit Printing Library
	'nurPDF = true, wenn alle Tore/Linien ausgegeben werden sollen
	'nurPDF = false alle Tore/Linien des jeweiligen Nutzers ausgegeben werden.
	Dim rt As RuntimePermissions
	Dim top As Float
	Dim firstpos As Float = 85
	Dim endedetailtext As Boolean = False
	
	'Dim PDFdoc As PrintPdfDocument
	
	'rt.CheckAndRequest(rt.PERMISSION_WRITE_EXTERNAL_STORAGE)
	'PDFdoc.Initialize
'	If nurPDF=False Then
'		'Erste Seite anlegen
'		PDFdoc.StartPage(595, 842)
'		top = firstpos
'		pages=pages+1
'		B4AwriteKopfFuss(PDFdoc,pages)
'		'Strategie und Zentren ausgeben
'		pages = B4ApdfStrategieZentren(False,PDFdoc,firstpos,pages)
'	End If
	'Neue Seite
	PDFdoc.StartPage(595, 842) 'Neue Seite
	top = firstpos
	pages=pages+1
	B4ApdfwriteKopfFuss(PDFdoc,pages)
	Log("neue Seite geschrieben")
	If nurPDF=False Then
		'Alle Tortexte des aktuellen Nutzers ausgeben
		Dim Query As String = "Select * from ToreUndDeutung where RotSchwarz='r' or RotSchwarz='s'"
		ToastMessageShow("writing ... ",True)
	Else
		Dim Query As String = "Select * from HDLinien"
		ToastMessageShow("Schreibe alle Tor/Linie ",True)
	End If
	Dim rs4 As ResultSet = Main.sql.ExecQuery(Query)	
	Do While rs4.NextRow
		If endedetailtext Then	'kommt noch eine Seite dazu
			endedetailtext = False
			PDFdoc.FinishPage
			PDFdoc.StartPage(595, 842) 'Neue Seite
			top = firstpos
			pages=pages+1
			B4ApdfwriteKopfFuss(PDFdoc,pages)
		End If
		'			'aktualisiere Index für PDF Erzeugen
		Dim idt As Int = rs4.GetString("IdTor")
		Dim idl As Int = rs4.GetString("Linie")
		Dim rs As Char = rs4.GetString("RotSchwarz")
		Dim name As String = rs4.GetString("TorName")
		Dim planet As String = rs4.GetString("Planet")
		Dim idsab As Int = rs4.GetString("IdSab")
		Dim idzentrum As Int = rs4.GetString("IdZentrum")
		'lastdpfmapId wird derzeit noch benötigt in B4aWriteTorDetails
		'In zeigeinhalt wird die Map mit allen Detailinformationen beschrieben.
		'Leider ist DEBUGGER nicht möglich, da die Map im Debug-Mode keine Custom- Typen unterstützt.
		'wird derzeit belassen, ist aber unschön !!!
		lastpdfmapId =  idt &"," & idl
		Log("Schreibe PDF-Eintrag: "&lastpdfmapId)
		zeigeInhalt(nurPDF,clv2,0,idt,idl,rs) 'Index wird nicht gebraucht, da nur globale PDFmap befüllt wird			
		top = B4AwriteTorKopfzeile(nurPDF,PDFdoc,top,idt,idl,rs,name,planet,idsab,idzentrum)
		top = B4AwriteTorDetails(PDFdoc,firstpos,pages,top)
		endedetailtext = True
	Loop
	rs4.close
		'Alle gezeigten Tortexte der CLV ausgeben
'		For eintrag = 0 To clv2.Size-1
'			Dim pnl As B4XView = clv2.GetPanel(eintrag)
'			Dim tags As Object = pnl.tag
'			If tags = Null Then Continue	'Bei B4a kann Tagwert Null haben
'			If pnl.Tag="j" Then 'Checkbox checked
'				If endedetailtext Then	'kommt noch eine Seite dazu
'					endedetailtext = False
'					PDFdoc.FinishPage
'					PDFdoc.StartPage(595, 842) 'Neue Seite
'					top = firstpos
'					pages=pages+1
'					B4AwriteKopfFuss(PDFdoc,pages)
'				End If
'	'			'aktualisiere Index für PDF Erzeugen
'				lastpdfmapId = pnl.Getview(0).text & "," & pnl.Getview(1).text
'				top = B4AwriteTorKopfzeile(PDFdoc,top)
'				top = B4AwriteTorDetails(PDFdoc,firstpos,pages,top)
'				endedetailtext = True
'			End If
'		Next
	
	'PDF abspeichern
	PDFdoc.FinishPage
	ToastMessageShow(home.translate(Main.sprache,105),True)
	Log("Speichere PDF-Datei ...")
	Dim Out As OutputStream
	#if user
		Dim dir As String = file.dirinternal
	#Else
		Dim dir As String = rt.getSafeDirDefaultExternal("")
	#End If
	
	If nurPDF=False Then
		home.pdfDokument=home.lblPerson.Text&".pdf"
		Out = File.OpenOutput(dir,home.pdfDokument, False)
	Else
		home.pdfDokument="MatrixLifecode.pdf"
		Out = File.OpenOutput(dir,"MatrixLifecode.pdf", False)
	End If
	PDFdoc.WriteToStream(Out)
	ToastMessageShow(home.translate(Main.sprache,106),False)
	Log("PDF-Datei erzeugt!")
	Out.Close
	PDFdoc.Close
	'PDF anzeigen mit PDFIUM
	B4XPages.ShowPage("PDFAnzeige")
	
End Sub

Sub B4ApdfwriteKopfFuss(pdfd As PrintPdfDocument,pagenr As Int)
	
	Dim rec As Rect
	DateTime.DateFormat="dd.MM.yyyy"
	Dim t As String=DateTime.Date(DateTime.Now)
	'Kopfzeile
	rec.Initialize(20, 15, 60, 55)
	pdfd.Canvas.DrawBitmap(xui.LoadBitmap(File.DirAssets,"logo.png"), Null, rec)
	Dim defkopf As String = home.translate(Main.sprache,65) 'Schatzkarte für
	pdfd.Canvas.DrawText(defkopf&" "&home.lblPerson.text, pdfLeft+100, 45, Typeface.DEFAULT_BOLD, 18 / GetDeviceLayoutValues.Scale , Colors.Black, "LEFT")

	'Fusszeile
	pdfd.Canvas.DrawText(Chr(169)&" "&"Matrix Lifecode / heilseminare.com", 200, 820, Typeface.DEFAULT, 10 / GetDeviceLayoutValues.Scale , Colors.Black, "LEFT")
	pdfd.Canvas.DrawText($"${t}"$, 20, 820, Typeface.DEFAULT, 8 / GetDeviceLayoutValues.Scale , Colors.Black, "LEFT")
	pdfd.Canvas.DrawText($"${pagenr}"$, 560, 820, Typeface.DEFAULT, 8 / GetDeviceLayoutValues.Scale , Colors.Black, "LEFT")
End Sub

Sub B4AwriteTorDetails(pdfd As PrintPdfDocument,firstpos As Int, pages As Int,topPos As Float) As Float
	'schreibt in die PDF- Datei
	
	'Globale pdfmap enthält alle Detail zu diesem TOR/Linie- Eintrag
	Dim mapE As mapitem
	Dim towriteS As String
	Dim towrite As List 'Enthält die Zeilen
	
	towrite.Initialize
	mapE.Initialize
	If pdfmap.ContainsKey(lastpdfmapId) Then
		mapE = pdfmap.Get(lastpdfmapId)
	Else
		Log(lastpdfmapId & " does not exist in map pdfmap")
		Return topPos
	End If
	'Im Debug-Mode werden die Werte von mapE nicht richtig ausgelesen, deshalb ist Debuggen nicht möglich. Release funktioniert.
	'Bedeutung des Tores als Satz formuliert
	Dim idt As Int = mapE.idtor
	Dim idl As Int = mapE.idlinie
	Dim idrs As Char = mapE.rotschwarz
	'Log("Tordetails:"&idt&" "&idl)
	For Each k As Int In sortmap.Keys
		Dim sitem As sortitem = sortmap.Get(k)
		Dim mt As Int = sitem.Tor
		Dim ml As Int = sitem.Linie
		Dim rs As Char = sitem.rotschwarz
		Dim mtm As String = sitem.TorName
		Dim mpb As String = sitem.PlanetBedeutung
		If idt = mt And idl = ml And idrs = rs Then
			Dim torbedeutung As String = PositioniereBedeutung(mpb,mtm)
			Log("Treffer: "&idt&" "&idl&" "&idrs&" "&torbedeutung)
			'Torbedeutung schreiben und exit
			towrite = AnpassenAnSeitenbreite(torbedeutung,maxZeichen)
			For i = 0 To towrite.Size - 1
				pdfd.Canvas.DrawText(towrite.Get(i), 20, topPos, Typeface.DEFAULT_BOLD, 9 / GetDeviceLayoutValues.Scale , Colors.black, "LEFT")
				topPos=topPos+pdfZeilenhoehe
			Next
			Exit
		End If
	Next
	
	'GrafikTor, Wandelbodygraph, WandeltorGrafik nebeneinander zeichnen
	Dim rec As Rect
	rec.Initialize(20, topPos, 180, topPos+160)
	pdfd.Canvas.DrawBitmap(xui.LoadBitmap(File.DirAssets,"h"&mapE.idtor&".png"), Null, rec)
	'Wandeltor
	zeichneTorundWandlung(mapE.idtor,mapE.idlinie,mapE.wandelTor)
	rec.Initialize(220, topPos, 380, topPos+160)
	pdfd.Canvas.DrawBitmap(xui.LoadBitmap(xui.DefaultFolder,"wandeltor.png"), Null, rec)
	rec.Initialize(420, topPos, 580, topPos+160)
	pdfd.Canvas.DrawBitmap(xui.LoadBitmap(File.DirAssets,"h"&mapE.wandelTor&".png"), Null, rec)
	topPos = topPos + 180
	Log("Wandeltor gezeichnet")
	'Tortext
	towrite.Clear
	towriteS=mapE.tortext
	towrite = AnpassenAnSeitenbreite(towriteS,maxZeichen)
	'Dim width As Int = MeasureTextWidth(towriteS,xui.CreateDefaultFont(pdfZeilenhoehe))
	For i = 0 To towrite.Size - 1
		pdfd.Canvas.DrawText(towrite.Get(i), 20, topPos, Typeface.DEFAULT, 9 / GetDeviceLayoutValues.Scale , Colors.black, "LEFT")
		topPos=topPos+pdfZeilenhoehe
	Next
	Log("Tortext")
	If mapE.kanaltor <> 0 Then
		
		'Kanal Header
		topPos=topPos + 5 'Kleiner Absatz
				
		towrite.Clear
		towriteS=mapE.kanaltext
		towrite = AnpassenAnSeitenbreite(towriteS,maxZeichen)
		If pdfSeitenichtgenugPlatz(topPos,towrite.Size,pdfZeilenhoehe) Then
			'Neue Seite
			pdfd.FinishPage
			pdfd.StartPage(595, 842) 'Neue Seite
			topPos=firstpos
			pages=pages+1
			B4ApdfwriteKopfFuss(pdfd,pages)
		End If
		Dim defkanal As String = home.translate(Main.sprache,42)
		Dim defzutor As String = home.translate(Main.sprache,44)
		Dim defrolle As String = home.translate(Main.sprache,43)
		pdfd.Canvas.DrawText(defkanal&" "&mapE.kanalname&" "&defzutor&" "&mapE.kanaltor & " ("&defrolle&": "&mapE.kanalrolle&")", 20, topPos, Typeface.DEFAULT_BOLD, 9 / GetDeviceLayoutValues.Scale , Colors.black, "LEFT")
		topPos=topPos+20 'Kanal

		For i = 0 To towrite.Size - 1
			pdfd.Canvas.DrawText(towrite.Get(i), 20, topPos, Typeface.DEFAULT, 9 / GetDeviceLayoutValues.Scale , Colors.black, "LEFT")
			topPos=topPos+pdfZeilenhoehe
		Next
	End If
	topPos = topPos+5
	'Linientext
	towrite.Clear
	towriteS=mapE.textlinie
	towrite = AnpassenAnSeitenbreite(towriteS,maxZeichen)
	If pdfSeitenichtgenugPlatz(topPos,towrite.Size,pdfZeilenhoehe) Then
		'Neue Seite
		pdfd.FinishPage
		pdfd.StartPage(595, 842) 'Neue Seite
		topPos=firstpos
		pages=pages+1
		B4ApdfwriteKopfFuss(pdfd,pages)
	End If
	Log("Linientext")
	'Linientext Header
	topPos=topPos+3 'Kleiner Absatz
	Dim deflinie As String = home.translate(Main.sprache,32)
	pdfd.Canvas.DrawText(deflinie&" "&mapE.idlinie, 20, topPos, Typeface.DEFAULT_BOLD, 9 / GetDeviceLayoutValues.Scale , Colors.black, "LEFT")
	topPos=topPos+pdfZeilenhoehe
	For i = 0 To towrite.Size - 1
		pdfd.Canvas.DrawText(towrite.Get(i), 20, topPos, Typeface.DEFAULT, 9 / GetDeviceLayoutValues.Scale , Colors.black, "LEFT")
		topPos=topPos+pdfZeilenhoehe
	Next
	topPos = topPos+10
	
	
	'Sabisches Symbol
	If mapE.txtsab <>"" Then
		towrite.Clear
		towriteS=mapE.txtsab
		towrite = AnpassenAnSeitenbreite(towriteS,maxZeichen)
		
		If pdfSeitenichtgenugPlatz(topPos,towrite.Size+17,pdfZeilenhoehe) Then 'ca. 20 Zeilen Platz für Bild auf gleicher Seite
			'Neue Seite
			pdfd.FinishPage
			pdfd.StartPage(595, 842)
			topPos=firstpos
			pages=pages+1
			B4ApdfwriteKopfFuss(pdfd,pages)
		End If
		Dim defsab As String = home.translate(Main.sprache,78) 'Sabische Symbole
		pdfd.Canvas.DrawText(defsab, 20, topPos, Typeface.DEFAULT_BOLD, 9 / GetDeviceLayoutValues.Scale , Colors.black, "LEFT")
		topPos=topPos+pdfZeilenhoehe
		For i = 0 To towrite.Size - 1
			pdfd.Canvas.DrawText(towrite.Get(i), 20, topPos, Typeface.DEFAULT, 9 / GetDeviceLayoutValues.Scale , Colors.black, "LEFT")
			topPos=topPos+pdfZeilenhoehe
		Next
		
		If File.Exists(File.dirassets,mapE.idsab&"sab.png") Then
			Dim rec As Rect
			rec.Initialize(170, topPos, 410, topPos+240)
			pdfd.Canvas.DrawBitmap(xui.LoadBitmap(File.DirAssets,mapE.idsab&"sab.png"), Null, rec)
			topPos=topPos+240+pdfZeilenhoehe
		End If
	End If
	
	'Fragen
	If mapE.fragelinie1 <> "" Then
		'Frage 1
		towrite.Clear
		towriteS=mapE.fragelinie1
		towrite = AnpassenAnSeitenbreite(towriteS,maxZeichen)
		
		If pdfSeitenichtgenugPlatz(topPos,towrite.Size,pdfZeilenhoehe) Then
			'Neue Seite
			pdfd.FinishPage
			pdfd.StartPage(595, 842) 'Neue Seite
			topPos=firstpos
			pages=pages+1
			B4ApdfwriteKopfFuss(pdfd,pages)
		End If
		
		'Fragen Header
		Dim deffragen As String = home.translate(Main.sprache,45)
		pdfd.Canvas.DrawText(deffragen&": ", 20, topPos, Typeface.DEFAULT_BOLD, 9 / GetDeviceLayoutValues.Scale , Colors.black, "LEFT")
		topPos=topPos+pdfZeilenhoehe
		
		For i = 0 To towrite.Size - 1
			pdfd.Canvas.DrawText(towrite.Get(i), 20, topPos, Typeface.DEFAULT, 9 / GetDeviceLayoutValues.Scale , Colors.black, "LEFT")
			topPos=topPos+pdfZeilenhoehe
		Next
	End If
	If mapE.fragelinie2 <>"" Then
		'Frage 2
		towrite.Clear
		towriteS=mapE.fragelinie2
		towrite = AnpassenAnSeitenbreite(towriteS,maxZeichen)
		If pdfSeitenichtgenugPlatz(topPos,towrite.Size,pdfZeilenhoehe) Then
			'Neue Seite
			pdfd.FinishPage
			pdfd.StartPage(595, 842) 'Neue Seite
			topPos=firstpos
			pages=pages+1
			B4ApdfwriteKopfFuss(pdfd,pages)
		End If
		For i = 0 To towrite.Size - 1
			pdfd.Canvas.DrawText(towrite.Get(i), 20, topPos, Typeface.DEFAULT, 9 / GetDeviceLayoutValues.Scale , Colors.black, "LEFT")
			topPos=topPos+pdfZeilenhoehe
		Next
	End If
	If mapE.fragelinie3 <>"" Then
		'Frage 3
		towrite.Clear
		towriteS=mapE.fragelinie3
		towrite = AnpassenAnSeitenbreite(towriteS,maxZeichen)
		If pdfSeitenichtgenugPlatz(topPos,towrite.Size,pdfZeilenhoehe) Then
			'Neue Seite
			pdfd.FinishPage
			pdfd.StartPage(595, 842) 'Neue Seite
			topPos=firstpos
			pages=pages+1
			B4ApdfwriteKopfFuss(pdfd,pages)
		End If
		For i = 0 To towrite.Size - 1
			pdfd.Canvas.DrawText(towrite.Get(i), 20, topPos, Typeface.DEFAULT, 9 / GetDeviceLayoutValues.Scale , Colors.black, "LEFT")
			topPos=topPos+pdfZeilenhoehe
		Next
	End If
	topPos = topPos+10
	
	If mapE.textaffi1 <> "" Then
		'Affirmationen 1
		towrite.Clear
		towriteS=mapE.textaffi1
		towrite = AnpassenAnSeitenbreite(towriteS,maxZeichen)
		If pdfSeitenichtgenugPlatz(topPos,towrite.Size,pdfZeilenhoehe) Then
			'Neue Seite
			pdfd.FinishPage
			pdfd.StartPage(595, 842) 'Neue Seite
			topPos=firstpos
			pages=pages+1
			B4ApdfwriteKopfFuss(pdfd,pages)
		End If
		'Affirmationen Header
		Dim defaffi As String = home.translate(Main.sprache,46)
		pdfd.Canvas.DrawText(defaffi&": ", 20, topPos, Typeface.DEFAULT_BOLD, 9 / GetDeviceLayoutValues.Scale , Colors.black, "LEFT")
		topPos=topPos+pdfZeilenhoehe
		
		For i = 0 To towrite.Size - 1
			pdfd.Canvas.DrawText(towrite.Get(i), 20, topPos, Typeface.DEFAULT, 9 / GetDeviceLayoutValues.Scale , Colors.black, "LEFT")
			topPos=topPos+pdfZeilenhoehe
		Next
	End If
	If mapE.textaffi2 <> "" Then
		'Affirmationen 2
		towrite.Clear
		towriteS=mapE.textaffi2
		towrite = AnpassenAnSeitenbreite(towriteS,maxZeichen)
		If pdfSeitenichtgenugPlatz(topPos,towrite.Size,pdfZeilenhoehe) Then
			'Neue Seite
			pdfd.FinishPage
			pdfd.StartPage(595, 842) 'Neue Seite
			topPos=firstpos
			pages=pages+1
			B4ApdfwriteKopfFuss(pdfd,pages)
		End If
		For i = 0 To towrite.Size - 1
			pdfd.Canvas.DrawText(towrite.Get(i), 20, topPos, Typeface.DEFAULT, 9 / GetDeviceLayoutValues.Scale , Colors.black, "LEFT")
			topPos=topPos+pdfZeilenhoehe
		Next
	End If
	If mapE.textaffi3 <> "" Then
		'Affirmationen 3
		towrite.Clear
		towriteS=mapE.textaffi3
		towrite = AnpassenAnSeitenbreite(towriteS,maxZeichen)
		If pdfSeitenichtgenugPlatz(topPos,towrite.Size,pdfZeilenhoehe) Then
			'Neue Seite
			pdfd.FinishPage
			pdfd.StartPage(595, 842) 'Neue Seite
			topPos=firstpos
			pages=pages+1
			B4ApdfwriteKopfFuss(pdfd,pages)
		End If
		For i = 0 To towrite.Size - 1
			pdfd.Canvas.DrawText(towrite.Get(i), 20, topPos, Typeface.DEFAULT, 9 / GetDeviceLayoutValues.Scale , Colors.black, "LEFT")
			topPos=topPos+pdfZeilenhoehe
		Next
	End If
	topPos=topPos+10
	
	Dim neuePos As Int=topPos+70  '70 Pixel Platz für Grafik+Überschrift
	If neuePos > maxPDFheight Then
		'Neue Seite
		pdfd.FinishPage
		pdfd.StartPage(595, 842)
		topPos=firstpos
		pages=pages+1
		B4ApdfwriteKopfFuss(pdfd,pages)
	End If
	'Frequenzstrahl 
	zeichneFrequenzstrahl(mapE.schatten,mapE.gabe,mapE.siddhi)'Erstellt die Datei frequenzstrahl.png im Default- Folder
	Dim deffreq As String = home.translate(Main.sprache,47) 'Auf welcher Frequenz ...
	pdfd.Canvas.DrawText(deffreq, 20, topPos, Typeface.DEFAULT_BOLD, 9 / GetDeviceLayoutValues.Scale , Colors.black, "LEFT")
	topPos= topPos+pdfZeilenhoehe
	rec.Initialize(20,topPos,580,topPos+50)
	pdfd.Canvas.DrawBitmap(xui.LoadBitmap(xui.DefaultFolder,"frequenzstrahl.png"), Null, rec)
	topPos=topPos+70
	
	'Gabe
	If mapE.txtgabe <>"" Then
		towrite.Clear
		towriteS=mapE.txtgabe
		towrite = AnpassenAnSeitenbreite(towriteS,maxZeichen)
		If pdfSeitenichtgenugPlatz(topPos,towrite.Size,pdfZeilenhoehe) Then
			'Neue Seite
			pdfd.FinishPage
			pdfd.StartPage(595, 842)
			topPos=firstpos
			pages=pages+1
			B4ApdfwriteKopfFuss(pdfd,pages)
		End If
		Dim defgabe As String = home.translate(Main.sprache,49)
		pdfd.Canvas.DrawText(defgabe, 20, topPos, Typeface.DEFAULT_BOLD, 9 / GetDeviceLayoutValues.Scale , Colors.black, "LEFT")
		topPos=topPos+pdfZeilenhoehe
		For i = 0 To towrite.Size - 1
			pdfd.Canvas.DrawText(towrite.Get(i), 20, topPos, Typeface.DEFAULT, 9 / GetDeviceLayoutValues.Scale , Colors.black, "LEFT")
			topPos=topPos+pdfZeilenhoehe
		Next
	End If
	Log("Gabe")
	topPos= topPos+10
	
	
	Dim eintrag1,eintrag2,eintrag3,eintrag4,eintrag5,eintrag6,eintrag7 As emaillinkEintrag
	'Links für EmailListe
	If mapE.textmp1<> "" Or mapE.textpdf1 <>"" Then
		eintrag1.Initialize
		Dim defausrüstung As String = home.translate(Main.sprache,70)
		eintrag1.bezeichner=defausrüstung&" "& mapE.idtor &deflinie&": "& mapE.idlinie &":"
		eintrag1.link=""
		home.emailLinklist.Add(eintrag1)
	End If
	If mapE.textmp1<> "" Then
		eintrag2.Initialize
		eintrag2.bezeichner=mapE.bezmp1
		eintrag2.link=mapE.textmp1
		home.emailLinklist.Add(eintrag2)
	End If
	If mapE.textmp2<> "" Then
		eintrag3.Initialize
		eintrag3.bezeichner=mapE.bezmp2
		eintrag3.link=mapE.textmp2
		home.emailLinklist.Add(eintrag3)
	End If
	If mapE.textmp3<> "" Then
		eintrag4.Initialize
		eintrag4.bezeichner=mapE.bezmp3
		eintrag4.link=mapE.textmp3
		home.emailLinklist.Add(eintrag4)
	End If
	If mapE.textpdf1<> "" Then
		eintrag5.Initialize
		eintrag5.bezeichner=mapE.bezpdf1
		eintrag5.link=mapE.textpdf1
		home.emailLinklist.Add(eintrag5)
	End If
	If mapE.textpdf2<> "" Then
		eintrag6.Initialize
		eintrag6.bezeichner=mapE.bezpdf2
		eintrag6.link=mapE.textpdf2
		home.emailLinklist.Add(eintrag6)
	End If
	If mapE.textpdf3<> "" Then
		eintrag7.Initialize
		eintrag7.bezeichner=mapE.bezpdf3
		eintrag7.link=mapE.textpdf3
		home.emailLinklist.Add(eintrag7)
	End If
	Log("Mp3 und PDF")
	Return topPos
End Sub

Sub B4AwriteTorKopfzeile(allePDFSeiten As Boolean, pdfd As PrintPdfDocument, topPos As Float, idtor As Int, idlinie As Int, rs As Char, name As String, planet As String, idsab As Int, idzentrum As Int) As Float
	'Schreibt die Kopfzeile zu Beginn jeder Detailseite der Tore und evtl. angewählte Konstellationsbilder und Planetenbeschreibungen
	'allePDFSeiten = True - Sonderfall, wenn alle Tor/Linientexte unabhängig von einer Person als PDF ausgegeben werden sollen.

	If allePDFSeiten Then Return topPos'Nur bei Personen kann die Kopfzeile geschrieben werden
	
	Dim towrite As List
	Dim color As Int = Colors.black
	
	towrite.Initialize
	Dim zentrum As String = Main.SQL.ExecQuerySingleResult("Select Zentrum from Zentren where IdZentren="&idzentrum)
	
	'Sternzeichen ermitteln
	Dim idstz As Int = Sammlung.convertiereSabSymbolinSternzeichen(idsab)
	Dim sternzeichen As String = Main.SQL.ExecQuerySingleResult("select Sternzeichen from Sternzeichen where IdSternzeichen = "&idstz)
	Log(idtor&" "&sternzeichen&" "&zentrum&" "&planet)
	If rs = "r" Then 'rot
		color = Colors.Red
	End If
	If rs = "s" Then
		color = Colors.black
	End If
	If rs = "t" Then
		color = Colors.Blue
	End If
	'Rahmen und Rahmenfarbe andern
	Dim defsonne As String = home.translate(Main.sprache,200)
	Dim deferde As String = home.translate(Main.sprache,201)
	If planet = deferde Or planet = defsonne Then  'Lebensaufgabe
		If home.iduser <> 0 Then color = Main.colGold 'gold
		'If home.iduser <> 0 Then color = Colors.RGB(212,176,55) 'gold
	End If
	
	'Tor
	pdfd.Canvas.DrawText(idtor, pdfLeft+100, topPos, Typeface.DEFAULT_BOLD, 14 / GetDeviceLayoutValues.Scale , color, "LEFT")
	pdfd.Canvas.DrawText(idlinie, 150, topPos, Typeface.DEFAULT_BOLD, 14 / GetDeviceLayoutValues.Scale , color, "LEFT")
	pdfd.Canvas.DrawText(name, 245, topPos, Typeface.DEFAULT_BOLD, 14 / GetDeviceLayoutValues.Scale , color, "LEFT")
	topPos = topPos + 25
	
	'change text color back to black
	color = Colors.Black
	pdfd.Canvas.DrawText(planet, pdfLeft+100, topPos, Typeface.DEFAULT, 14 / GetDeviceLayoutValues.Scale , color, "LEFT")
	pdfd.Canvas.DrawText(sternzeichen, 245, topPos, Typeface.DEFAULT, 14 / GetDeviceLayoutValues.Scale , color, "LEFT")
	pdfd.Canvas.DrawText(zentrum, 390, topPos, Typeface.DEFAULT, 14 / GetDeviceLayoutValues.Scale , color, "LEFT")
	Dim rec As Rect
	rec.Initialize(560, topPos-20, 560+20, topPos)
	pdfd.Canvas.DrawBitmap(xui.LoadBitmap(File.DirAssets,idtor & ".png"), Null, rec)
	topPos = topPos+25
	If home.settings.Get("Planetbeschreibung") Then
		'Planetenbeschreibung dazufügen
		Dim cs1 As ResultSet = Main.sql.ExecQuery("SELECT BeschreibungS,BeschreibungR,BildS,BildR FROM Planeten where Planet ='"&planet&"'")
		cs1.NextRow
		If rs = "r" Then
			Dim txt As String = cs1.Getstring("BeschreibungR")
			Dim img As String = cs1.Getstring("BildR")
		Else
			Dim txt As String = cs1.Getstring("BeschreibungS")
			Dim img As String = cs1.Getstring("BildS")
		End If
		cs1.Close
		Dim rotschwarzoutput As String
		If rs="r" Then
			rotschwarzoutput = home.translate(Main.sprache,64) 'rot
		End If
		If rs="s" Then
			rotschwarzoutput = home.translate(Main.sprache,63) 'schwarz
		End If
		If rs="t" Then
			rotschwarzoutput = home.translate(Main.sprache,63) 'schwarz
		End If
		img = img.ToLowerCase
		Dim bottomBild As Int = topPos+80
		Dim rec As Rect
		rec.Initialize(pdfLeft, topPos, pdfLeft+80, bottomBild)
		pdfd.Canvas.DrawBitmap(xui.LoadBitmap(File.DirAssets,img), Null, rec)
		topPos=topPos+pdfZeilenhoehe
		pdfd.Canvas.DrawText(planet& " ("&rotschwarzoutput&")", pdfLeft+100, topPos, Typeface.DEFAULT_BOLD, 9 / GetDeviceLayoutValues.Scale , color, "LEFT")
		topPos = topPos+pdfZeilenhoehe
		towrite.Clear
		towrite = AnpassenAnSeitenbreite(txt,maxZeichen-15) '15 Zeichen weniger wg. Bild links
		For i = 0 To towrite.Size - 1
			Dim txt As String = towrite.Get(i)
			pdfd.Canvas.DrawText(towrite.Get(i),pdfLeft+100, topPos, Typeface.DEFAULT, 9 / GetDeviceLayoutValues.Scale , Colors.black, "LEFT")
			topPos=topPos+pdfZeilenhoehe
		Next
		If topPos <= bottomBild Then
			topPos = bottomBild+20 'Neues Bild muss unterhalb des Alten sein.
		Else
			topPos = topPos+10  'Abstand für neues Bild
		End If
	End If
	
	If home.settings.Get("Konstellationsbild") Then
		'Konstellationsbild ermitteln und ausgeben
		Dim herrscherint As Int = Main.sql.ExecQuerySingleResult("SELECT IdPlanet from Sternzeichen where Sternzeichen ='"&sternzeichen&"'")
		Dim planetB As String = Main.sql.ExecQuerySingleResult("SELECT Planet from Planeten where IdPlanet ="&herrscherint)
		Dim query As String = "SELECT * FROM Konstellationsbilder WHERE PlanetA ='"&planet&"' and PlanetB ='"&planetB&"'"
		Dim rs1 As ResultSet = Main.SQL.ExecQuery(query)
		Do While rs1.NextRow  ' sollte nur ein Ergebnis oder kein Ergebnis sein
			Dim defkonst As String = home.translate(Main.sprache,69)
			pdfd.Canvas.DrawText(defkonst&": "& planet & " / " & planetB, pdfLeft, topPos, Typeface.DEFAULT_BOLD, 9 / GetDeviceLayoutValues.Scale , Colors.black, "LEFT")
			topPos=topPos+pdfZeilenhoehe
			Dim schreibe As String = rs1.GetString("Beschreibung")
			towrite.Clear
			towrite = AnpassenAnSeitenbreite(schreibe,maxZeichen)
			For i = 0 To towrite.Size - 1
				pdfd.Canvas.DrawText(towrite.Get(i), pdfLeft, topPos, Typeface.DEFAULT, 9 / GetDeviceLayoutValues.Scale , Colors.black, "LEFT")
				topPos=topPos+pdfZeilenhoehe
			Next
		Loop
	End If
	Return topPos + 10
End Sub

Sub B4ApdfStrategieZentren(quickview As Boolean, pdfd As PrintPdfDocument, firstpos As Int, pages As Int) As Int
	'quickview = true, Schnellübersicht um Kunden zu interessieren
	'Wird von pdferstellen aufgerufen und schreibt die Strategie des aktuellen Benutzers
	'toppos ist die Position des Schreibbeginns der Seite
	'Rückgabewert: Letzte geschriebene Seitenzahl
	Dim towrite As List
	Dim towriteS As String
	Dim toppos As Int

	toppos=firstpos
	towrite.Initialize
	'Ermitteln der Daten
	Dim rs As ResultSet = Main.SQL.ExecQuery("select * from Benutzer where IdName = "&home.iduser)
	rs.NextRow
	Dim z As List
	z.Initialize
	
	Dim HDTyp As String = rs.GetString("HDTyp")
	Dim HDAutoritaet As String = rs.GetString("Autoritaet")
	Dim HDProfil As String = rs.GetString("Profil")
	Dim HDInkarnationskreuz As String = rs.GetString("HDInkarnationskreuz")
	Dim Ernaehrung As String = rs.GetString("HDErnaehrung")
	Dim NumWeg As String = rs.GetString("NumWeg")
	Dim vSzene As String = rs.GetString("Szene")
	Dim vMotivation As String = rs.GetString("Motivation")
	Dim vKognition As String = rs.GetString("Kognition")
	'Dim sprache As String = rs.GetString("Sprache")
	Dim zid As Int
	For i = 0 To 8
		zid = i+1
		If rs.GetString("Z"& zid) = "j" Then
			z.Add(True)
		Else
			z.Add(False)
		End If
	Next
	'Bodygraphdetail
	Dim rec As Rect
	rec.Initialize(150, toppos, 470, toppos+515)
	pdfd.Canvas.DrawBitmap(xui.LoadBitmap(home.rp.GetSafeDirDefaultExternal(""),"bodygraphexakt.png"), Null, rec)
	toppos = toppos + 540
	
	'Typ, Profil, Autorität ... ausgeben
	'Dim InName As Object = Main.SQL.ExecQuerySingleResult("select InName from InKreuz where InName = '"&HDInkarnationskreuz&"'")
	Dim InName As String = HDInkarnationskreuz
	Dim defthema As String = home.translate(Main.sprache,16)
	pdfd.Canvas.DrawText(defthema&": "&InName, 20, toppos, Typeface.DEFAULT_BOLD, 9 / GetDeviceLayoutValues.Scale , Colors.black, "LEFT")
	toppos=toppos+pdfZeilenhoehe
	Dim defdesign As String = home.translate(Main.sprache,53)
	pdfd.Canvas.DrawText(defdesign&" "&HDTyp, 20, toppos, Typeface.DEFAULT_BOLD, 9 / GetDeviceLayoutValues.Scale , Colors.black, "LEFT")
	toppos=toppos+pdfZeilenhoehe
	Dim defprofil As String = home.translate(Main.sprache,54)
	pdfd.Canvas.DrawText(defprofil&" "&HDProfil, 20, toppos, Typeface.DEFAULT_BOLD, 9 / GetDeviceLayoutValues.Scale , Colors.black, "LEFT")
	toppos=toppos+pdfZeilenhoehe
	Dim defauto As String = home.translate(Main.sprache,55)
	pdfd.Canvas.DrawText(defauto&" "&HDAutoritaet, 20, toppos, Typeface.DEFAULT_BOLD, 9 / GetDeviceLayoutValues.Scale , Colors.black, "LEFT")
	toppos=toppos+pdfZeilenhoehe
	Dim defernährung As String = home.translate(Main.sprache,56)
	pdfd.Canvas.DrawText(defernährung&" "&Ernaehrung, 20, toppos, Typeface.DEFAULT_BOLD, 9 / GetDeviceLayoutValues.Scale , Colors.black, "LEFT")
	toppos=toppos+pdfZeilenhoehe
	Dim defnumweg As String = home.translate(Main.sprache,57)
	pdfd.Canvas.DrawText(defnumweg&" "&NumWeg, 20, toppos, Typeface.DEFAULT_BOLD, 9 / GetDeviceLayoutValues.Scale , Colors.black, "LEFT")
	toppos=toppos+pdfZeilenhoehe
	Dim defszene As String = home.translate(Main.sprache,14)
	pdfd.Canvas.DrawText(defszene&": "&vSzene, 20, toppos, Typeface.DEFAULT_BOLD, 9 / GetDeviceLayoutValues.Scale , Colors.black, "LEFT")
	toppos=toppos+pdfZeilenhoehe
	Dim defmot As String = home.translate(Main.sprache,27)
	pdfd.Canvas.DrawText(defmot&": "&vMotivation, 20, toppos, Typeface.DEFAULT_BOLD, 9 / GetDeviceLayoutValues.Scale , Colors.black, "LEFT")
	toppos=toppos+pdfZeilenhoehe
	Dim defkog As String = home.translate(Main.sprache,18)
	pdfd.Canvas.DrawText(defkog&": "&vKognition, 20, toppos, Typeface.DEFAULT_BOLD, 9 / GetDeviceLayoutValues.Scale , Colors.black, "LEFT")
	toppos=toppos+pdfZeilenhoehe
	
	'Abschnitt: Wie sind die Informationen zu interpretieren ?
	pdfd.FinishPage
	pdfd.StartPage(595, 842) 'Neue Seite
	toppos=firstpos
	pages=pages+1
	B4ApdfwriteKopfFuss(pdfd,pages)
	
	'Allgemeine Beschreibung der Funktionsweise des Matrix Lifecode
	'Alle Einträge der Tabelle Matrix Lifecode schreiben
	Dim rsm As ResultSet = Main.sql.ExecQuery("Select * from Matrixlifecode")
	Dim id As Int = 0
	Do While rsm.NextRow 
		Dim ueberschrifto As Object = rsm.GetString("ueberschrift")
		If ueberschrifto = Null Then Continue
		Dim ueberschrift As String = ueberschrifto
		Dim id As Int = rsm.GetString("id")
		Dim isbild As Int = 0
		
		If rsm.GetString("bild1") <> Null And rsm.GetString("bild1") <> " " Then isbild = 1
		If rsm.GetString("bild1") <> Null And rsm.GetString("bild1") <> " " And rsm.GetString("bild2") <> Null And rsm.GetString("bild2") <> " " Then isbild = 2
		'Text und ggfls. Bilder schreiben, Überschriften fett
		towriteS = home.translateMatrixlifecode(Main.sprache,id)
		towrite.clear
		towrite = AnpassenAnSeitenbreite(towriteS,maxZeichen)
		
		If pdfSeitenichtgenugPlatz(toppos,towrite.Size,pdfZeilenhoehe) Then
			toppos = firstpos
			pdfd.FinishPage
			pdfd.StartPage(595, 842) 'Neue Seite
			toppos=firstpos
			pages=pages+1
			B4ApdfwriteKopfFuss(pdfd,pages)
		End If
		
		For i = 0 To towrite.Size - 1
			If ueberschrift = "j" Then
				pdfd.Canvas.DrawText(towrite.Get(i), 20, toppos+pdfZeilenhoehe, Typeface.DEFAULT_BOLD, 9 / GetDeviceLayoutValues.Scale , Colors.Black, "LEFT")
			Else
				pdfd.Canvas.DrawText(towrite.Get(i), 20, toppos+pdfZeilenhoehe, Typeface.DEFAULT, 9 / GetDeviceLayoutValues.Scale , Colors.Black, "LEFT")	
			End If
			toppos=toppos+pdfZeilenhoehe
		Next
	
		'Wenn kein Bild enthalten ist, dann naechster Eintrag, Bild 480*480
		If isbild = 0 Then Continue
		
		Dim bild As String = rsm.GetString("bild1")
		If pdfSeitenichtgenugPlatzBild(toppos, 240) Then
			toppos = firstpos
			pdfd.FinishPage
			pdfd.StartPage(595, 842) 'Neue Seite
			toppos=firstpos
			pages=pages+1
			B4ApdfwriteKopfFuss(pdfd,pages)
		End If
		Dim rec As Rect
		rec.Initialize(170, toppos, 410, toppos+240)
		pdfd.Canvas.DrawBitmap(xui.LoadBitmap(File.DirAssets,bild), Null, rec)
		toppos=toppos+240
		'restlichen Text schreiben
		Dim ind As Int = towriteS.IndexOf("=bild1")
		towriteS = towriteS.SubString(ind+6)'Hinter =bild1 weiterlesen
		towrite.clear
		towrite = AnpassenAnSeitenbreite(towriteS,maxZeichen)
		
		If pdfSeitenichtgenugPlatz(toppos,towrite.Size,pdfZeilenhoehe) Then
			toppos = firstpos
			pdfd.FinishPage
			pdfd.StartPage(595, 842) 'Neue Seite
			toppos=firstpos
			pages=pages+1
			B4ApdfwriteKopfFuss(pdfd,pages)
		End If
		
		For i = 0 To towrite.Size - 1
			pdfd.Canvas.DrawText(towrite.Get(i), 20, toppos+pdfZeilenhoehe, Typeface.DEFAULT, 9 / GetDeviceLayoutValues.Scale , Colors.Black, "LEFT")
			toppos=toppos+pdfZeilenhoehe
		Next	
	Loop
	

	'Themenübersicht immer auf neuer Seite beginnen
	toppos = firstpos
	pdfd.FinishPage
	pdfd.StartPage(595, 842) 'Neue Seite
	toppos=firstpos
	pages=pages+1
	B4ApdfwriteKopfFuss(pdfd,pages)
	
	'Übersicht schreiben
'		Dim defsum As String = home.translate(Main.sprache,52)
'		pdfd.Canvas.DrawText(defsum, 20, toppos, Typeface.DEFAULT_BOLD, 9 / GetDeviceLayoutValues.Scale , Colors.black, "LEFT")
'		toppos=toppos+pdfZeilenhoehe

	'Bei allen Toren die Torbedeutung ausgeben, die in idtor.tag gespeichert wurde
	For eintrag = 0 To clv2.Size-1
		Dim pnl As B4XView = clv2.GetPanel(eintrag)
		Dim idtor As B4XView = pnl.GetView(0)  					'Tor
		If idtor.Tag = Null Or idtor.Tag = "" Then Continue
		Dim inhalt As String = idtor.Tag
		Dim transit As String = home.translate(Main.sprache,112)
		transit=transit.ToLowerCase
		Dim inhaltklein As String = inhalt.ToLowerCase
		If inhaltklein.Contains(transit) Then Continue			'Transit nicht ausgeben
		Try
			Dim oplanet As B4XView = pnl.GetView(4)				'Planet
		Catch
			Continue
		End Try
		Dim rotschwarz As Char
		If oplanet.Tag = Null Then 
			rotschwarz = "s"				'wurde in planet.tag gespeichert
		Else
			rotschwarz = oplanet.Tag
		End If		
		towriteS=idtor.Tag
		towrite.clear
		towrite = AnpassenAnSeitenbreite(towriteS,maxZeichen-15) 'geschätzt 15 Zeichen gehen durch Bild verloren
		If toppos + 85 > maxPDFheight Then '85 Pixel Höhe je Eintrag
			'Neue Seite
			pdfd.FinishPage
			pdfd.StartPage(595, 842) 'Neue Seite
			toppos=firstpos
			pages=pages+1
			B4ApdfwriteKopfFuss(pdfd,pages)
		End If
		
		'Torbild ausgeben
		Dim torgraphik As String = "h" & idtor.text & ".png"
		Dim rec As Rect
		rec.Initialize(20, toppos, 100, toppos+80)
		pdfd.Canvas.DrawBitmap(xui.LoadBitmap(File.DirAssets,torgraphik), Null, rec)
		
		'Bedeutung ausgeben, evtl. über mehrere Zeilen
		Dim toppos1 As Int
		toppos1 = toppos
		For i = 0 To towrite.Size - 1
			If rotschwarz = "r" Then
				pdfd.Canvas.DrawText(towrite.Get(i), 120, toppos1+pdfZeilenhoehe, Typeface.DEFAULT, 9 / GetDeviceLayoutValues.Scale , Colors.red, "LEFT")
			Else 'Transit sollte vorher schon abgefangen sein
				pdfd.Canvas.DrawText(towrite.Get(i), 120, toppos1+pdfZeilenhoehe, Typeface.DEFAULT, 9 / GetDeviceLayoutValues.Scale , Colors.black, "LEFT")					
			End If
			toppos1=toppos1+pdfZeilenhoehe
		Next
		'Planetensymbol ausgeben
		Dim idp As Int = Main.sql.ExecQuerySingleResult("select IdPlanet from Planeten where Planet = '"& oplanet.Text & "'")
		Dim bm As B4XBitmap = LoadBitmapResize(File.DirAssets,"planet"&idp&".png",12,12,True)
		'Log("planet"&idp&".png")
		rec.Initialize(104,toppos,104+bm.Width,toppos+bm.Height)
		pdfd.Canvas.DrawBitmap(bm, Null, rec)
		'Frequenzstrahl ausgeben
		Dim Query As String = "Select Schatten,Gabe,Siddhi from Hexagramme where IdTor=" & idtor.text
		Dim rs3 As ResultSet = Main.sql.ExecQuery(Query)
		Do While rs3.NextRow  'sollte nur eine Zeile sein
			Dim schatten As String = rs3.GetString("Schatten")
			Dim gabe As String = rs3.GetString("Gabe")
			Dim siddhi As String = rs3.GetString("Siddhi")
		Loop
		zeichneFrequenzstrahl(schatten,gabe,siddhi)'Erstellt die Datei frequenzstrahl.png im Default- Folder
		'Dim deffreq As String = home.translate(Main.sprache,47) 'Auf welcher Frequenz ...
		'pdfd.Canvas.DrawText(deffreq, 20, 763, Typeface.DEFAULT_BOLD, 9 / GetDeviceLayoutValues.Scale , Colors.black, "LEFT")

		rec.Initialize(120,toppos+30,580,toppos+80)
		pdfd.Canvas.DrawBitmap(xui.LoadBitmap(xui.DefaultFolder,"frequenzstrahl.png"), Null, rec)
		
		toppos = toppos + 85
	Next
	toppos = toppos + 10 'kleiner Absatz
	If quickview Then
		'Abspeichern und zurück
		pdfd.FinishPage
		Return pages
	End If
	
	'quickview=false geht es weiter
	If home.settings.Get("Übersicht") Then
		'Bei allen markierten Toren die Torbedeutung ausgeben, die in tor.tag gespeichert wurde
		towrite.Clear
		towriteS = ""
		For eintrag = 0 To clv2.Size-1
			Dim pnl As B4XView = clv2.GetPanel(eintrag)
			Dim tags As Object = pnl.tag
			If tags = Null Then Continue	'Bei B4a kann Tagwert Null haben
			If tags = "j" Then
				Dim idtor As B4XView = pnl.GetView(0)  					'Tor
				towriteS=towriteS&idtor.Tag&CRLF
				Log(towriteS)
			End If
		Next
		
		towrite = AnpassenAnSeitenbreite(towriteS,maxZeichen)
		If pdfSeitenichtgenugPlatz(toppos,towrite.Size,pdfZeilenhoehe) Then
			'Neue Seite
			pdfd.FinishPage
			pdfd.StartPage(595, 842) 'Neue Seite
			toppos=firstpos
			pages=pages+1
			B4ApdfwriteKopfFuss(pdfd,pages)
		End If
		Dim defsum As String = home.translate(Main.sprache,52)
		pdfd.Canvas.DrawText(defsum, 20, toppos, Typeface.DEFAULT_BOLD, 9 / GetDeviceLayoutValues.Scale , Colors.black, "LEFT")
		toppos=toppos+pdfZeilenhoehe
		For i = 0 To towrite.Size - 1
			pdfd.Canvas.DrawText(towrite.Get(i), 20, toppos, Typeface.DEFAULT, 9 / GetDeviceLayoutValues.Scale , Colors.black, "LEFT")
			toppos=toppos+pdfZeilenhoehe
		Next
	End If
	Dim anzeigebasisinfo As Boolean
	anzeigebasisinfo = home.settings.Get("Lebensthema")=True Or home.settings.Get("Typ")=True Or home.settings.Get("Profil")=True Or home.settings.Get("Autoritaet")=True Or home.settings.Get("Ernährung")=True Or home.settings.Get("Numweg") Or home.settings.Get("Szene") Or home.settings.Get("Motivation") Or home.settings.Get("Kognition") Or home.settings.Get("Zentren") Or home.settings.Get("Fragen") Or home.settings.Get("Planetenliste")
	If home.settings.Get("Lebensthema") And anzeigebasisinfo Then
		'Inkarnationskreuz
		Dim Beschreibung As Object = Main.SQL.ExecQuerySingleResult("select InBezeichnung from InKreuz where InName = '"&HDInkarnationskreuz&"'")
		If Beschreibung<>Null And Beschreibung<>"" Then
			towrite.Clear
			towriteS=Beschreibung
			towrite = AnpassenAnSeitenbreite(towriteS,maxZeichen)
			If pdfSeitenichtgenugPlatz(toppos,towrite.Size,pdfZeilenhoehe) Then
				'Neue Seite
				pdfd.FinishPage
				pdfd.StartPage(595, 842) 'Neue Seite
				toppos=firstpos
				pages=pages+1
				B4ApdfwriteKopfFuss(pdfd,pages)
			End If
			'Dim InName As Object = Main.SQL.ExecQuerySingleResult("select InName from InKreuz where InName = '"&HDInkarnationskreuz&"'")
			Dim InName As String = HDInkarnationskreuz
			Dim defthema As String = home.translate(Main.sprache,16)
			pdfd.Canvas.DrawText(defthema&": "&InName, 20, toppos, Typeface.DEFAULT_BOLD, 9 / GetDeviceLayoutValues.Scale , Colors.black, "LEFT")
			toppos=toppos+pdfZeilenhoehe
			For i = 0 To towrite.Size - 1
				pdfd.Canvas.DrawText(towrite.Get(i), 20, toppos, Typeface.DEFAULT, 9 / GetDeviceLayoutValues.Scale , Colors.black, "LEFT")
				toppos=toppos+pdfZeilenhoehe
			Next
			pdfd.Canvas.DrawText(" ", 20, toppos, Typeface.DEFAULT_BOLD, 9 / GetDeviceLayoutValues.Scale , Colors.black, "LEFT")
			toppos=toppos+pdfZeilenhoehe
		End If
	End If
	'Anzeige der Daten
	If home.settings.Get("Typ") And anzeigebasisinfo Then
		'HDTyp
		Dim HDTypBeschreibung As Object = Main.SQL.ExecQuerySingleResult("select  BeschreibungHDTyp from HDTyp where HDTyp = '"&HDTyp&"'")
		If HDTypBeschreibung<>Null And HDTypBeschreibung<>"" Then
			towrite.Clear
			towriteS=HDTypBeschreibung
			towrite = AnpassenAnSeitenbreite(towriteS,maxZeichen)
			If pdfSeitenichtgenugPlatz(toppos,towrite.Size,pdfZeilenhoehe) Then
				'Neue Seite
				pdfd.FinishPage
				pdfd.StartPage(595, 842) 'Neue Seite
				toppos=firstpos
				pages=pages+1
				B4ApdfwriteKopfFuss(pdfd,pages)
			End If
			Dim defdesign As String = home.translate(Main.sprache,53)
			pdfd.Canvas.DrawText(defdesign&" "&HDTyp, 20, toppos, Typeface.DEFAULT_BOLD, 9 / GetDeviceLayoutValues.Scale , Colors.black, "LEFT")
			toppos=toppos+pdfZeilenhoehe
			For i = 0 To towrite.Size - 1
				pdfd.Canvas.DrawText(towrite.Get(i), 20, toppos, Typeface.DEFAULT, 9 / GetDeviceLayoutValues.Scale , Colors.black, "LEFT")
				toppos=toppos+pdfZeilenhoehe
			Next
		End If
	End If
	
	If home.settings.Get("Profil") And anzeigebasisinfo Then
		'HDProfil
		Dim HDProfilBeschreibung As Object = Main.SQL.ExecQuerySingleResult("select BeschreibungProfil from HDProfil where Profil = '"&HDProfil&"'")
		If HDProfilBeschreibung<>Null And HDProfilBeschreibung<>"" Then
			towrite.Clear
			towriteS=HDProfilBeschreibung
			towrite = AnpassenAnSeitenbreite(towriteS,maxZeichen)
			If pdfSeitenichtgenugPlatz(toppos,towrite.Size,pdfZeilenhoehe) Then
				'Neue Seite
				pdfd.FinishPage
				pdfd.StartPage(595, 842) 'Neue Seite
				toppos=firstpos
				pages=pages+1
				B4ApdfwriteKopfFuss(pdfd,pages)
			End If
			Dim defprofil As String = home.translate(Main.sprache,54)
			pdfd.Canvas.DrawText(defprofil&" "&HDProfil, 20, toppos, Typeface.DEFAULT_BOLD, 9 / GetDeviceLayoutValues.Scale , Colors.black, "LEFT")
			toppos=toppos+pdfZeilenhoehe
			For i = 0 To towrite.Size - 1
				pdfd.Canvas.DrawText(towrite.Get(i), 20, toppos, Typeface.DEFAULT, 9 / GetDeviceLayoutValues.Scale , Colors.black, "LEFT")
				toppos=toppos+pdfZeilenhoehe
			Next
		End If
	End If
	
	If home.settings.Get("Autoritaet") And anzeigebasisinfo Then
		'HDAutoritaet
		Dim Beschreibung As Object = Main.SQL.ExecQuerySingleResult("select BeschreibungAutoritaet  from HDAutoritaet where Autoritaet = '"&HDAutoritaet&"'")
		If Beschreibung<>Null And Beschreibung<>"" Then
			towrite.Clear
			towriteS=Beschreibung
			towrite = AnpassenAnSeitenbreite(towriteS,maxZeichen)
			If pdfSeitenichtgenugPlatz(toppos,towrite.Size,pdfZeilenhoehe) Then
				'Neue Seite
				pdfd.FinishPage
				pdfd.StartPage(595, 842) 'Neue Seite
				toppos=firstpos
				pages=pages+1
				B4ApdfwriteKopfFuss(pdfd,pages)
			End If
			Dim defauto As String = home.translate(Main.sprache,55)
			pdfd.Canvas.DrawText(defauto&" "&HDAutoritaet, 20, toppos, Typeface.DEFAULT_BOLD, 9 / GetDeviceLayoutValues.Scale , Colors.black, "LEFT")
			toppos=toppos+pdfZeilenhoehe
			For i = 0 To towrite.Size - 1
				pdfd.Canvas.DrawText(towrite.Get(i), 20, toppos, Typeface.DEFAULT, 9 / GetDeviceLayoutValues.Scale , Colors.black, "LEFT")
				toppos=toppos+pdfZeilenhoehe
			Next
		End If
	End If
	toppos=toppos+pdfZeilenhoehe 'kleiner Absatz
	
	If home.settings.Get("Ernährung") And anzeigebasisinfo Then
		'Ernährung
		Dim Beschreibung As Object = Main.SQL.ExecQuerySingleResult("select BeschreibungErnaehrung  from HDErnaehrung where HDErnaehrung = '"&Ernaehrung&"'")
		If Beschreibung<>Null And Beschreibung<>"" Then
			towrite.Clear
			towriteS=Beschreibung
			towrite = AnpassenAnSeitenbreite(towriteS,maxZeichen)
			If pdfSeitenichtgenugPlatz(toppos,towrite.Size,pdfZeilenhoehe) Then
				'Neue Seite
				pdfd.FinishPage
				pdfd.StartPage(595, 842) 'Neue Seite
				toppos=firstpos
				pages=pages+1
				B4ApdfwriteKopfFuss(pdfd,pages)
			End If
			Dim defernährung As String = home.translate(Main.sprache,56)
			pdfd.Canvas.DrawText(defernährung&" "&Ernaehrung, 20, toppos, Typeface.DEFAULT_BOLD, 9 / GetDeviceLayoutValues.Scale , Colors.black, "LEFT")
			toppos=toppos+pdfZeilenhoehe
			For i = 0 To towrite.Size - 1
				pdfd.Canvas.DrawText(towrite.Get(i), 20, toppos, Typeface.DEFAULT, 9 / GetDeviceLayoutValues.Scale , Colors.black, "LEFT")
				toppos=toppos+pdfZeilenhoehe
			Next
		End If
	End If
	
	If home.settings.Get("Numweg") And anzeigebasisinfo Then
		'NumWeg
		Dim Beschreibung As Object = Main.SQL.ExecQuerySingleResult("select BeschreibungNumWeg from NumWeg where NumWeg = "&NumWeg)
		If Beschreibung<>Null And Beschreibung<>"" Then
			towrite.Clear
			towriteS=Beschreibung
			towrite = AnpassenAnSeitenbreite(towriteS,maxZeichen)
			If pdfSeitenichtgenugPlatz(toppos,towrite.Size,pdfZeilenhoehe) Then
				'Neue Seite
				pdfd.FinishPage
				pdfd.StartPage(595, 842) 'Neue Seite
				toppos=firstpos
				pages=pages+1
				B4ApdfwriteKopfFuss(pdfd,pages)
				
			End If
			Dim defnumweg As String = home.translate(Main.sprache,57)
			pdfd.Canvas.DrawText(defnumweg&" "&NumWeg, 20, toppos, Typeface.DEFAULT_BOLD, 9 / GetDeviceLayoutValues.Scale , Colors.black, "LEFT")
			toppos=toppos+pdfZeilenhoehe
			For i = 0 To towrite.Size - 1
				pdfd.Canvas.DrawText(towrite.Get(i), 20, toppos, Typeface.DEFAULT, 9 / GetDeviceLayoutValues.Scale , Colors.black, "LEFT")
				toppos=toppos+pdfZeilenhoehe
			Next
		End If
	End If
	
	'Szene ausgeben
	If home.settings.Get("Szene") And anzeigebasisinfo Then
		'Szene
		Dim Beschreibung As Object = Main.SQL.ExecQuerySingleResult("select BeschreibungSzene from Szene where Szene = '"&vSzene&"'")
		If Beschreibung<>Null And Beschreibung<>"" Then
			towrite.Clear
			towriteS=Beschreibung
			towrite = AnpassenAnSeitenbreite(towriteS,maxZeichen)
			If pdfSeitenichtgenugPlatz(toppos,towrite.Size,pdfZeilenhoehe) Then
				'Neue Seite
				pdfd.FinishPage
				pdfd.StartPage(595, 842) 'Neue Seite
				toppos=firstpos
				pages=pages+1
				B4ApdfwriteKopfFuss(pdfd,pages)	
			End If
			Dim defszene As String = home.translate(Main.sprache,14)
			pdfd.Canvas.DrawText(defszene&": "&vSzene, 20, toppos, Typeface.DEFAULT_BOLD, 9 / GetDeviceLayoutValues.Scale , Colors.black, "LEFT")
			toppos=toppos+pdfZeilenhoehe
			For i = 0 To towrite.Size - 1
				pdfd.Canvas.DrawText(towrite.Get(i), 20, toppos, Typeface.DEFAULT, 9 / GetDeviceLayoutValues.Scale , Colors.black, "LEFT")
				toppos=toppos+pdfZeilenhoehe
			Next
			pdfd.Canvas.DrawText(" ", 20, toppos, Typeface.DEFAULT_BOLD, 9 / GetDeviceLayoutValues.Scale , Colors.black, "LEFT")
			toppos=toppos+pdfZeilenhoehe
		End If
	End If
	
	'Motivation ausgeben
	If home.settings.Get("Motivation") And anzeigebasisinfo Then
		'Szene
		Dim Beschreibung As Object = Main.SQL.ExecQuerySingleResult("select BeschreibungMotivation from Motivation where Motivation = '"&vMotivation&"'")
		If Beschreibung<>Null And Beschreibung<>"" Then
			towrite.Clear
			towriteS=Beschreibung
			towrite = AnpassenAnSeitenbreite(towriteS,maxZeichen)
			If pdfSeitenichtgenugPlatz(toppos,towrite.Size,pdfZeilenhoehe) Then
				'Neue Seite
				pdfd.FinishPage
				pdfd.StartPage(595, 842) 'Neue Seite
				toppos=firstpos
				pages=pages+1
				B4ApdfwriteKopfFuss(pdfd,pages)
			End If
			Dim defmot As String = home.translate(Main.sprache,27)
			pdfd.Canvas.DrawText(defmot&": "&vMotivation, 20, toppos, Typeface.DEFAULT_BOLD, 9 / GetDeviceLayoutValues.Scale , Colors.black, "LEFT")
			toppos=toppos+pdfZeilenhoehe
			For i = 0 To towrite.Size - 1
				pdfd.Canvas.DrawText(towrite.Get(i), 20, toppos, Typeface.DEFAULT, 9 / GetDeviceLayoutValues.Scale , Colors.black, "LEFT")
				toppos=toppos+pdfZeilenhoehe
			Next
			pdfd.Canvas.DrawText(" ", 20, toppos, Typeface.DEFAULT_BOLD, 9 / GetDeviceLayoutValues.Scale , Colors.black, "LEFT")
			toppos=toppos+pdfZeilenhoehe
		End If
	End If
	
	'Kognition ausgeben
	If home.settings.Get("Kognition") And anzeigebasisinfo Then
		'Szene
		Dim Beschreibung As Object = Main.SQL.ExecQuerySingleResult("select BeschreibungKognition from Kognition where Kognition = '"&vKognition&"'")
		If Beschreibung<>Null And Beschreibung<>"" Then
			towrite.Clear
			towriteS=Beschreibung
			towrite = AnpassenAnSeitenbreite(towriteS,maxZeichen)
			If pdfSeitenichtgenugPlatz(toppos,towrite.Size,pdfZeilenhoehe) Then
				'Neue Seite
				pdfd.FinishPage
				pdfd.StartPage(595, 842) 'Neue Seite
				toppos=firstpos
				pages=pages+1
				B4ApdfwriteKopfFuss(pdfd,pages)
			End If
			Dim defkog As String = home.translate(Main.sprache,18)
			pdfd.Canvas.DrawText(defkog&": "&vKognition, 20, toppos, Typeface.DEFAULT_BOLD, 9 / GetDeviceLayoutValues.Scale , Colors.black, "LEFT")
			toppos=toppos+pdfZeilenhoehe
			For i = 0 To towrite.Size - 1
				pdfd.Canvas.DrawText(towrite.Get(i), 20, toppos, Typeface.DEFAULT, 9 / GetDeviceLayoutValues.Scale , Colors.black, "LEFT")
				toppos=toppos+pdfZeilenhoehe
			Next
			pdfd.Canvas.DrawText(" ", 20, toppos, Typeface.DEFAULT_BOLD, 9 / GetDeviceLayoutValues.Scale , Colors.black, "LEFT")
			toppos=toppos+pdfZeilenhoehe
		End If
	End If
	
	If home.settings.Get("Zentren") And anzeigebasisinfo Then
		'Zentren immer auf neuer Seite beginnen
		pdfd.FinishPage
		pdfd.StartPage(595, 842) 'Neue Seite
		toppos=firstpos
		pages=pages+1
		B4ApdfwriteKopfFuss(pdfd,pages)
		
		'Zentren in PDF
		Dim zid As Int
		For i = 0 To 8
			zid = i+1
			Dim rs As ResultSet = Main.SQL.ExecQuery("select * from Zentren where IdZentren ="& zid)
			rs.NextRow
			Dim zentrum As String = rs.getstring("Zentrum")
				Dim beschreibungzentrum As String= rs.getstring("BeschreibungZentrum")
			Dim defJaNein,defJaNeinText,fragen,affi As Object
			If z.Get(i) = True Then
				defJaNein = home.translate(Main.sprache,61)
				defJaNeinText = rs.GetString("Definiert")
				fragen = rs.GetString("FragenDefiniert")
				If fragen = Null Then fragen = ""
				affi = rs.GetString("AffirmationDefiniert")
				If affi = Null Then affi=""
			Else
				defJaNein = home.translate(Main.sprache,62)
				defJaNeinText = rs.GetString("Undefiniert")
				fragen = rs.GetString("FragenUndefiniert")
				If fragen = Null Then fragen=""' Nullwert wird konvertiert in String !
				affi = rs.GetString("AffirmationUndefiniert")
				If affi = Null Then affi=""
			End If
		
			'beschreibungzentrum schreiben
			towrite.Clear
			towriteS=beschreibungzentrum
			'Log(zentrum&" "&beschreibungzentrum)
			towrite = AnpassenAnSeitenbreite(towriteS,maxZeichen)
			If pdfSeitenichtgenugPlatz(toppos,towrite.Size,pdfZeilenhoehe) Then
				'Neue Seite
				pdfd.FinishPage
				pdfd.StartPage(595, 842) 'Neue Seite
				toppos=firstpos
				pages=pages+1
				B4ApdfwriteKopfFuss(pdfd,pages)
				
			End If
			Dim defbedeutung As String = home.translate(Main.sprache,58)
			pdfd.Canvas.DrawText(defbedeutung&" "&zentrum&":", 20, toppos, Typeface.DEFAULT_BOLD, 9 / GetDeviceLayoutValues.Scale , Colors.black, "LEFT")
			toppos=toppos+pdfZeilenhoehe
			For i1 = 0 To towrite.Size - 1
				pdfd.Canvas.DrawText(towrite.Get(i1), 20, toppos, Typeface.DEFAULT, 9 / GetDeviceLayoutValues.Scale , Colors.black, "LEFT")
				toppos=toppos+pdfZeilenhoehe
			Next
			toppos=toppos+5
			'defJaNeinText schreiben
			towrite.Clear
			towriteS=defJaNeinText
			towrite = AnpassenAnSeitenbreite(towriteS,maxZeichen)
			If pdfSeitenichtgenugPlatz(toppos,towrite.Size,pdfZeilenhoehe) Then
				'Neue Seite
				pdfd.FinishPage
				pdfd.StartPage(595, 842) 'Neue Seite
				toppos=firstpos
				pages=pages+1
				B4ApdfwriteKopfFuss(pdfd,pages)
				
			End If
			Dim defzentrum As String = home.translate(Main.sprache,59)
			Dim defist As String = home.translate(Main.sprache,60)
			pdfd.Canvas.DrawText(defzentrum&" "&zentrum&" "&defist&" "&defJaNein, 20, toppos, Typeface.DEFAULT_BOLD, 9 / GetDeviceLayoutValues.Scale , Colors.black, "LEFT")
			toppos=toppos+pdfZeilenhoehe
			For i1 = 0 To towrite.Size - 1
				pdfd.Canvas.DrawText(towrite.Get(i1), 20, toppos, Typeface.DEFAULT, 9 / GetDeviceLayoutValues.Scale , Colors.black, "LEFT")
				toppos=toppos+pdfZeilenhoehe
			Next
			toppos=toppos+5
			
			If home.settings.Get("Fragen") And anzeigebasisinfo Then
				'Fragen
				If fragen <> "" Then
					towrite.Clear
					towriteS=fragen
					towrite = AnpassenAnSeitenbreite(towriteS,maxZeichen)
					If pdfSeitenichtgenugPlatz(toppos,towrite.Size,pdfZeilenhoehe) Then
						'Neue Seite
						pdfd.FinishPage
						pdfd.StartPage(595, 842) 
						toppos=firstpos
						pages=pages+1
						B4ApdfwriteKopfFuss(pdfd,pages)
						
					End If
					Dim deffragen As String = home.translate(Main.sprache,45)
					pdfd.Canvas.DrawText(deffragen&":", 20, toppos, Typeface.DEFAULT_BOLD, 9 / GetDeviceLayoutValues.Scale , Colors.black, "LEFT")
					toppos=toppos+pdfZeilenhoehe
					For i1 = 0 To towrite.Size - 1
						pdfd.Canvas.DrawText(towrite.Get(i1), 20, toppos, Typeface.DEFAULT, 9 / GetDeviceLayoutValues.Scale , Colors.black, "LEFT")
						toppos=toppos+pdfZeilenhoehe
					Next
					toppos=toppos+5
				End If
				
				'Affirmationen
				If affi<>"" Then
					towrite.Clear
					towriteS=affi
					towrite = AnpassenAnSeitenbreite(towriteS,maxZeichen)
					If pdfSeitenichtgenugPlatz(toppos,towrite.Size,pdfZeilenhoehe) Then
						'Neue Seite
						pdfd.FinishPage
						pdfd.StartPage(595, 842) 
						toppos=firstpos
						pages=pages+1
						B4ApdfwriteKopfFuss(pdfd,pages)
					End If
					Dim defaffi As String = home.translate(Main.sprache,46) 'Affirmationen
					pdfd.Canvas.DrawText(defaffi&":", 20, toppos, Typeface.DEFAULT_BOLD, 9 / GetDeviceLayoutValues.Scale , Colors.black, "LEFT")
					toppos=toppos+pdfZeilenhoehe
					For i1 = 0 To towrite.Size-1
						pdfd.Canvas.DrawText(towrite.Get(i1), 20, toppos, Typeface.DEFAULT, 9 / GetDeviceLayoutValues.Scale , Colors.black, "LEFT")
						toppos=toppos+pdfZeilenhoehe
					Next
					toppos=toppos+5
				End If
			End If
		Next
	End If
	
	'Planetenliste in PDF
	If home.settings.Get("Planetenliste") And anzeigebasisinfo Then 'pdf Planeten
		'immer neue Seite
		pdfd.FinishPage
		pdfd.StartPage(595, 842) 'Neue Seite
		toppos=firstpos
		pages=pages+1
		B4ApdfwriteKopfFuss(pdfd,pages)
		
		'Planeten
		Dim rs As ResultSet = Main.SQL.ExecQuery("select * from Planeten")
		Do While rs.NextRow
			Dim planet As String = rs.getstring("Planet")
			Dim beschreibungR As String = rs.getstring("BeschreibungR")
			Dim bildR As String = rs.getstring("BildR")
			Dim beschreibungS As String = rs.getstring("BeschreibungS")
			Dim bildS As String = rs.getstring("BildS")
			towrite.Clear
			beschreibungS= beschreibungS.Replace(Chr(10),"") '0a- Werte sicher entfernen
			beschreibungR= beschreibungR.Replace(Chr(10),"") '0a- Werte sicher entfernen
				
			'Ausgabe beginnen Schwarz
			towrite = AnpassenAnSeitenbreite(beschreibungS,maxZeichen-25) 'geschätzt 25 Zeichen weniger durch Bild links
			Dim bildgroesse As Int = 100
			Dim zeilenzahl As Int = towrite.Size
			Dim hoehe As Int = pdfZeilenhoehe
			If (zeilenzahl * pdfZeilenhoehe) <= bildgroesse Then 'Bild muss draufpassen
				zeilenzahl = 0			'Sonst wird pdfSeitennichtgenugPlatz nicht richtig berechnet, da dort zeilenzahl + 1 gesetzt wird
				hoehe = 100
			End If
			If pdfSeitenichtgenugPlatz(toppos,zeilenzahl,hoehe) Then
				pdfd.FinishPage
				pdfd.StartPage(595, 842) 'Neue Seite
				toppos=firstpos
				pages=pages+1
				B4ApdfwriteKopfFuss(pdfd,pages)
			End If
			Dim bottomBild As Int = toppos + bildgroesse
			Dim rec As Rect
			rec.Initialize(20, toppos, 120, toppos+100)
			pdfd.Canvas.DrawBitmap(xui.LoadBitmap(File.DirAssets,bildS), Null, rec)
			Dim schwarz As String = home.translate(Main.sprache,63)
			pdfd.Canvas.DrawText(planet & " ("&schwarz&")", 130, toppos, Typeface.DEFAULT_BOLD, 9 / GetDeviceLayoutValues.Scale , Colors.black, "LEFT")
			toppos = toppos+pdfZeilenhoehe
			For i = 0 To towrite.Size - 1
				pdfd.Canvas.DrawText(towrite.Get(i), 130, toppos, Typeface.DEFAULT, 9 / GetDeviceLayoutValues.Scale , Colors.black, "LEFT")
				toppos=toppos+pdfZeilenhoehe
			Next
			If toppos <= bottomBild Then
				toppos = bottomBild + 20 'Neues Bild muss unterhalb des Alten sein.
			Else
				toppos = toppos + 10  'Abstand für neues Bild
			End If
	
			'Ausgabe beginnen Rot
			towrite = AnpassenAnSeitenbreite(beschreibungR,maxZeichen-15) '15 Zeichen weniger durch Bild links
			Dim bildgroesse As Int = 100
			Dim zeilenzahl As Int = towrite.Size
			Dim hoehe As Int = pdfZeilenhoehe
			If (zeilenzahl * pdfZeilenhoehe) <= bildgroesse Then 'Bild muss draufpassen
				zeilenzahl = 1
				hoehe = 100
			End If
			If pdfSeitenichtgenugPlatz(toppos,zeilenzahl,hoehe) Then
				pdfd.FinishPage
				pdfd.StartPage(595, 842) 'Neue Seite
				toppos=firstpos
				pages=pages+1
				B4ApdfwriteKopfFuss(pdfd,pages)
			End If
			Dim bottomBild As Int = toppos + bildgroesse
			Dim rec As Rect
			rec.Initialize(20, toppos, 120, toppos+100)
			pdfd.Canvas.DrawBitmap(xui.LoadBitmap(File.DirAssets,bildR), Null, rec)
			Dim rot As String = home.translate(Main.sprache,64)
			pdfd.Canvas.DrawText(planet & " ("&rot&")", 130, toppos, Typeface.DEFAULT_BOLD, 9 / GetDeviceLayoutValues.Scale , Colors.black, "LEFT")
			toppos = toppos+pdfZeilenhoehe
			For i = 0 To towrite.Size - 1
				pdfd.Canvas.DrawText(towrite.Get(i), 130, toppos, Typeface.DEFAULT, 9 / GetDeviceLayoutValues.Scale , Colors.black, "LEFT")
				toppos=toppos+pdfZeilenhoehe
			Next
			If toppos <= bottomBild Then
				toppos = bottomBild + 20 'Neues Bild muss unterhalb des Alten sein.
			Else
				toppos = toppos + 10  'Abstand für neues Bild
			End If
		Loop
	End If
	pdfd.FinishPage
	Return pages
End Sub
#end if