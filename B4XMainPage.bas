B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=9.9
@EndOfDesignText@
#Region Shared Files
#CustomBuildAction: folders ready, %WINDIR%\System32\Robocopy.exe,"..\..\Shared Files" "..\Files"
'Ctrl + click to sync files: ide://run?file=%WINDIR%\System32\Robocopy.exe&args=..\..\Shared+Files&args=..\Files&FilesSync=True
#End Region

'Varianten
'user -> Alle Themen, nur 1 Person
'Neuinstallation der APP:
'user -Y kommt gleich in die Eingabemaske der Person
'admin -> Vollversion, Startcode- Bildschirm kommt gar nicht.


Sub Class_Globals
	Public const SKU_ID1 As String = "person" 		'jeweils +1 Person zum Anlegen PersCounter=PersCounter+1
	Public const SKU_ID2 As String = "beratung" 	'Beratungsgespräch kaufen
	Public const SKU_ID3 As String = "behandlung" 	'Monatl. Subscription fuer Behandlungen kaufen

	#if b4a
		Public billing As BillingClient '"android.test.purchased" ist z.B. wohl eine TEST-ID von Google
		Public const BILLING_KEY As String = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAnFlHTfMTMXjwfXyz+GbgASp6suhvhwsycNQMZToSPS+QLJmFZ2Q4Cq+/Py0aZAgxmy94R25YWWig5B3DdFXSu9q12DAbsQh0npWWzok4f4mWDJt2CNggqnyGHCa76DSMcEDHasJgRkfb+H3tDtYJ3j2tFW3la/WkWNBTARu59DWkW5NofjqXg4RlJN1c4LMeM9fK+dEinN1POaHOKAQ3eezbBqKk5JdVxzleT2P36Ewcq6JU0tWGZlBCDTeNkSCVCMgBNiOwNFC2zEwBlu8Yx3qxLp1bLnGCKdWq0KNYeJuIHaF1R7m5p64r7ftgP3JUNDJA5ULMkdxVOZrdzSztVQIDAQAB"
		Public hilfe1 As Hilfe
		Public pdfanzeige1 As PDFAnzeige
		Private bbdialog As BBCodeView
		Private toreder1 As Toreder				'Anzeigefenster Tore der Angst ...
		Public storeder As String 				'Welche Überschrift wurde geclickt, wird in Toreder - Seite verwendet
	#end if
	Private Root As B4XView 'ignore
	Private xui As XUI 'ignore
	Public dbname As String 					'aktueller Datenbankname
	Public Zeigen1 As Zeigen
	Public PersonNeu1 As PersonNeu
	Public clvWichtig1 As clvWichtig
	Public meridianBehandlungh As meridianBehandlung
	Public mondBehandlungh As mondBehandlung
	Public stromdetailh As stromdetail
	Public stromspielenh As stromspielen
	Public clvZentren1 As clvZentren
	Public kabinett1 As enneagramm
	Public medien1 As medien
	Public DBladen1 As DBladen
	Public zoomimage1 As zoomimage
	Public iduser As Int        				'aktuell ausgewählter User
	
	'Bei main.lizenz = 1 sind die nachfolgenden 2 Werte nicht wichtig
	Public PersCounter As Int					'max. Anzahl an gekauften Personeneinträgen, jeder Kauf erhöht + 1
	Public subsBehandlung As Boolean			'Subscription fuer Behandlungen gekauft
	
	Public idsternzeichen As Int				'Körperregion mit Sternzeichen wurde angewählt
	Public lblPerson As Label  					'Name der ausgewählten Person
	#if b4j
		Private lblEmail As Label
		Private lbl0Email As Label
	#end if
	Public emailLinklist As List				'Liste mit allen Links für Email
	'Public RowIDList As List					'list containing the rowids of the database
	Public rowidTorenachZeit As Int				'zum Navigieren zu aktuellem Booster Tor in ToreNach Zeit
	Private settingsFile As String = "einstellungen.map"			 'Sicherung der Einstellungen
	Public kvs As KeyValueStore 						 'Speichert den aktuellen Nutzer, damit er sofort geladen werden kann
	Private settingsDialog As PreferencesDialog
	Public settings As Map						'Alles aus der Datei einstellungen.map
	Private dlg As B4XDialog
	Private AuswahlPersonen As B4XSearchTemplate
	'Body zeichnen
	'Private pImg As B4XView
	'Private cvs As B4XCanvas
	#if b4a
		Private body As ImageView
		Private bodydetail As ImageView
		Public screensize As Double  	'Zur Unterscheidung Tablet, Handy
	#end if
	#if b4j
		Private bodygraphexakt As ZoomImageView  'dienen nur zur Ermittlung der Torpunkte in der Grafik
		Private pbodygraphexakt As Pane
	#end if
	Dim bc As BitmapCreator
	Type position (x As Int,y As Int)  	'Koordinaten
	Private lblDesigndatum As Label
	Private lblDesignuhrzeit As Label
	Private lbl0Designdatum As Label

	#if b4J
		Private jfx1 As JFX
		Private fx As JFX
		Private MenuBar1 As MenuBar
		Private pstartbild As Pane
		Private penergie As Pane
	#else
	Public rp As RuntimePermissions
	Public pdfDokument As String     	 		'aktuelles PDF-Dokument zum Betrachten/Drucken (mit Pfadangaben)
	Private clv,clv1 As CustomListView
	Private pstartbild As Panel
	Private textengine As BCTextEngine
	Private penergie As Panel
	#end if 
	Private pbodytore, peinstellungen As B4XView
	Private Root As B4XView 'ignore
		Private xui As XUI 'ignore
	Private headers As List         				'nur für Exportfunktion
	Private lblGeburtsdatum As Label
	Private lblZeit As Label
	Private lblHDAutoritaet As B4XView
	Private lblHDTyp As B4XView
	Private lblInKreuz As B4XView
	Private lblNumWeg As B4XView
	Private lblErnaehrung As B4XView
	Private dlg As B4XDialog
	Public edtBody As B4XComboBox		'Greife in clvWichtig und enneagramm auf Status zu
	Private startbild As ImageView
	Private s1,s2,s3,s3a,s4,s5,s6,s7,s8,s9,s9a,s10,s10a,s11,s11a,s12,s12a As B4XView
	Private lblProfil As Label
	Private lblSzene As Label
	Private lblKognition As Label
	Private lblMotivation As Label
	#if b4a
		Private bodytore As Label
		Private config As Label
	#end if
	Private lbl0Geburt As Label
	Private lbl0Ernaehrung As Label
	Private lbl0HDAutoritaet As Label
	Private lbl0HDTyp As Label
	Private lbl0InKreuz As Label
	Private lbl0Kognition As Label
	Private lbl0Motivation As Label
	Private lbl0NumWeg As Label
	Private lbl0Person As Label
	Private lbl0Profil As Label
	Private lbl0Szene As Label
	Public statusZentrenWerte As statusZentren
	
	'Update Energieuhr
	Public aktuellerMeridian As String 	'Wird bei MerdianBehandlung für Therapie gebraucht, ist Kuerzel wie KI
	Public geklickterMeridian As String
	Public aktuellerMondIn As String   	'Wird in Mondbehandlung gebraucht
	Public aktuellerstrom As String    	'Wird in stromdetail und stromspielen gebraucht
	Public cursordetail As ResultSet	'Wird in stromdetail und stromspielen gebraucht
	Public stromseite As String  		'aktuelle Stromseite
	Public 	statusTransit As Boolean 	'Für Positionierung in clvWichtig
	Private timerMeridianUhr As Timer
	Private lenergie As Label
	'Private clvenergie As CustomListView
	Private lIdTor,lLinie,lTorname As B4XView
	#if b4j
		Private pmondin As Pane
	#Else
		Private pmondin As Panel
	#End If
	Private swe1 As SwissEph
	Private lmondin As Label
	Private bmondin As Button
	Private lmondinTor As Label
	Private lmondinLinie As Label
	Private btherapie As Button
	Private ltime1 As Label
	Private ltime2 As Label
	Private lfrequenz As B4XView 		'nur zum Zeichnen Frequenzstrahl benötigt
	Public	consumeClick As Boolean 	'Click auf z.B. Meridian würde auch Click auf darunterliegendes Panel auslösen
	Private Ersterstart As Boolean		'Wird nur bei erster Installation der USER- App benötigt um die Benutzereinträge zu löschen
	Public myfont7 As B4XFont		'Verwendeter Font bei Ausgaben, damit sie über alle Plattformen gleich erscheinen
	Public myfont12 As B4XFont=CreateB4XFont("Opensans.ttf", 12, 12)
	#if b4a
		Private header As Label
		Private LAktivKanal As Label
		Private LAktivKanalName As Label
		Private LAktivKanalRolle As Label
		Private AktivKanal As Label
		Private AktivKanalName As Label
		Private AktivKanalRolle As Label
	#end if
	
End Sub

Public Sub Initialize
	
End Sub

Private Sub B4XPage_Created (Root1 As B4XView)
	Root = Root1
	Root.LoadLayout("MainForm")
	
	'Set Data Folder
	#if b4j
		xui.SetDataFolder("heilsystem")
	#end If
	'Key Values-Datei initialisieren
	kvs.Initialize(xui.DefaultFolder, "kvs.dat")
	
	#if b4a
		billing.Initialize("billing")
		RestorePurchases
	#end if
	'Alle vorhandenen Seiten initialisieren
	headers.Initialize
	Zeigen1.Initialize
	B4XPages.AddPage("Zeigen", Zeigen1)
	PersonNeu1.Initialize
	B4XPages.AddPage("PersonNeu", PersonNeu1)
	DBladen1.Initialize
	B4XPages.AddPage("DBTransfer", DBladen1)
	clvWichtig1.Initialize
	B4XPages.AddPage("clvWichtig",clvWichtig1)
	meridianBehandlungh.Initialize
	B4XPages.AddPage("meridianBehandlung",meridianBehandlungh)
	mondBehandlungh.Initialize
	B4XPages.AddPage("mondBehandlung",mondBehandlungh)
	kabinett1.Initialize
	B4XPages.AddPage("enneagramm",kabinett1)
	stromdetailh.Initialize
	B4XPages.AddPage("stromdetail",stromdetailh)
	stromspielenh.Initialize
	B4XPages.AddPage("stromspielen",stromspielenh)
	medien1.Initialize
	B4XPages.AddPage("medien",medien1)
	zoomimage1.initialize
	B4XPages.AddPage("zoomimage",zoomimage1)
	clvZentren1.initialize
	B4XPages.AddPage("clvZentren",clvZentren1)
	#if b4a
		hilfe1.Initialize
		B4XPages.AddPage("Hilfe",hilfe1)
		pdfanzeige1.Initialize
		B4XPages.AddPage("PDFAnzeige",pdfanzeige1)
		toreder1.initialize
		B4XPages.AddPage("Toreder",toreder1)
		screensize = GetDeviceLayoutValues.ApproximateScreenSize
	#end if
	'Einstellungen
	settings.Initialize
	settingsDialog.Initialize(Root, "Einstellungen", 300dip, 520dip)
	#if user
		settingsDialog.LoadFromJson(File.ReadString(File.DirAssets, "einstellungenUser.json"))
	#else
		settingsDialog.LoadFromJson(File.ReadString(File.DirAssets, "einstellungen.json"))
	#end if
	If File.Exists(xui.DefaultFolder, settingsFile) Then 'in globale Map settings einlesen
		Dim ser As B4XSerializator
		settings = ser.ConvertBytesToObject(File.ReadBytes(xui.DefaultFolder, settingsFile))
	End If
	
	'Wichtige Voreinstellungen, auch iduser wird dort geladen
	settings=initializeSettings(settings)
	'Sprache auslesen
	Main.sprache = settings.Get("sprache")
	'Datenbankname ermitteln
	dbname = "heilsystem"&Main.sprache&".db"
	'updateDBStruktur 'Update Design-changes in Database
	
	'Alle Sprachvarianten der DB kopieren, falls nicht vorhanden
	If File.Exists(xui.DefaultFolder, "heilsystemdeutsch.db") = False Then File.Copy(File.DirAssets,"heilsystemdeutsch.db",xui.DefaultFolder,"heilsystemdeutsch.db")
	If File.Exists(xui.DefaultFolder, "heilsystemenglish.db") = False Then File.Copy(File.DirAssets,"heilsystemenglish.db",xui.DefaultFolder,"heilsystemenglish.db")
	If File.Exists(xui.DefaultFolder, "heilsystemespanol.db") = False Then File.Copy(File.DirAssets,"heilsystemespanol.db",xui.DefaultFolder,"heilsystemespanol.db")
	If File.Exists(xui.DefaultFolder, "heilsystemfrancais.db") = False Then File.Copy(File.DirAssets,"heilsystemfrancais.db",xui.DefaultFolder,"heilsystemfrancais.db")

	'Datenbank initialisieren mit eingesteller Sprache
	dbinitialisieren
	
	If Ersterstart Then
		 #if user
			Main.SQL.ExecNonQuery("Delete from HD") 'Alle Benutzer zuerst löschen
			Main.SQL.ExecNonQuery("Delete from Benutzer")
			Dim query As String = "UPDATE _variablen SET Wert = -1 where Name = 'IdUser'"
			Main.sql.ExecNonQuery(query)
			Log("Alle Benutzereinträge gelöscht!")
			Ersterstart = False
		#End If
	End If
	
	#if b4j
		Dim img As Image = xui.LoadBitmapResize(File.DirAssets,"startbild.png",320,320,True)
		startbild.SetImage(img)
		SternzeichenPanelVordergrund
		pbodytore.bringtofront
		peinstellungen.bringtofront
	#else
		erstelleB4AMenu
		'clv.Add(CreateListItemEnergieAllgemein,"")
		clv.Add(CreateListItemAllgemein,"")

	#end if
	dlg.Initialize(Root)
	'cvs.Initialize(pImg)  'Für bodygraph
	
	
End Sub


'Private Sub B4XPage_CloseRequest As ResumableSub
'	Dim sf As Object = xui.Msgbox2Async("Close?", "Title", "Yes", "Cancel", "No", Null)
'	Wait For (sf) Msgbox_Result (Result As Int)
'	If Result = xui.DialogResponse_Positive Then
'		Return True
'	End If
'	Return False
'End Sub

Private Sub B4XPage_Appear
'	Log("B4XPage_Appear called!")
	'Time starten
	startMeridianuhr
	#if b4a
		clv1.Clear
		clv1.Add(CreateListItemImg,"")
		clv1.Add(createListItemStartbild,"")
		fillAktivierteKanaele  'Befüllt Tabelle mit aktivierten Kanaelen
		clv1.Add(CreateUeberschrift(translate(Main.sprache,135)),"") 'Tore der Angst
		clv1.Add(CreateUeberschrift(translate(Main.sprache,136)),"")
		clv1.Add(CreateUeberschrift(translate(Main.sprache,137)),"")
		clv1.Add(CreateUeberschrift(translate(Main.sprache,139)),"")
		clv.JumpToItem(0) 'An Anfang scrollen
	#end if
	'Bildschirmtexte Labels aktualisieren 
	BildschirmTexte
	
	idsternzeichen = 0 			'Auswahl bei jedem Laden der Seite erst löschen
	Dim anz As Int = Main.SQL.ExecQuerySingleResult("Select count(*) from Benutzer")
	If anz = 0 Then
		iduser = -1
		kvs.Put("iduser",-1)
	End If
	
	If iduser = -1 Then			'noch nichts ausgewählt oder zwischenzeitlich DB- übertragen
		#if user
			neuePerson_Click
		#else
			If anz=0 Then 'Keine Einträge in Benutzertabelle
				neuePerson_Click
				Return
			Else
				B4XPage_MenuClick("Laden")
				Return
			End If
		#End If
	End If
	'Transite immer aktualisieren wenn Hauptseite gelanden wird
	If edtBody.SelectedIndex=4 Or edtBody.SelectedIndex=5 Then 'Transite
		deleteandaddtransitefuerAktuellePerson
	End If
	updateEnergieBooster
	AktualisiereHauptseite(iduser)
	'Definierte Zentren mit Transit oder nur Transit neu berechnen
	statusZentrenWerte.Initialize
	statusZentrenWerte=PersonNeu1.berechnedefiniertezentren(edtBody.SelectedIndex)
	#if b4j
		pbodytore_MouseClicked(Null)
	#else
		zeichneBody(statusZentrenWerte)		'zeichnet body.png
	#End If
	
End Sub

Public Sub CreateB4XFont(FontFileName As String, FontSize As Float, NativeFontSize As Float) As B4XFont
	#IF B4A
		Return xui.CreateFont(Typeface.LoadFromAssets(FontFileName), FontSize)
	#ELSE IF B4I
		Return xui.CreateFont(Font.CreateNew2(FontFileName, NativeFontSize), FontSize)
	#ELSE ' B4J
		Return xui.CreateFont(fx.LoadFont(File.DirAssets, FontFileName, NativeFontSize), FontSize)
	#END IF
End Sub

private Sub initializeSettings(setting As Map) As Map
	'initialisiert die Basiseinstellungen
	'Starteinstellung für Anzeige edtbody in kvs speichern
	'Log (kvs.ListKeys)
	#if b4j
		Private maxPDFheight As Int = 90	'zählt Richtung 0
		Private maxZeichen As Int = 115 	'max. Zeichen in einer Zeile
	#else
		Private maxPDFheight As Int = 755
		Private maxZeichen As Int = 115
	#end if
	Private pdfZeilenhoehe As Int = 12
	Private pdfLeft As Int = 20

	'Interner KVS-Store
	'sortorder wird noch in clvWichtig gesetzt und gelesen

	If kvs.ContainsKey("lizenz")= False Then 
		kvs.Put("lizenz",0)
	Else
		Main.lizenz = kvs.Get("lizenz")
	End If
	iduser = kvs.GetDefault("iduser","-1") '-1 heisst, es wurde noch nie ein Name gespeichert.
	
	'Bei Lizenz = 1 (Admin und Windows) sind subsbehandlung und perscounter unwichtig

	If kvs.ContainsKey("subsbehandlung") = False Then 
		kvs.Put("subsbehandlung",True) 'Subscription/ABO für Behandlungen kommt erst mal nicht
	End If
	subsBehandlung = True
	
	If kvs.ContainsKey("perscounter")= False Then
		kvs.Put("perscounter",1) 			 'Eine Personen gekauft, weil APP kostenpflichtig ist
		PersCounter=1
		Ersterstart = True					 'Um Benutzereinträge bei erstem Start der App zu löschen
	Else
		PersCounter=kvs.Get("perscounter")
	End If
	
	If kvs.ContainsKey("edtbody")=False Then kvs.Put("edtbody",4) 'Einstellung bei erstem Programmstart
	'Einstellungen.map
	
	#if b4a
	Dim r As Reflector
	Try
		Dim lang As Object
		r.Target = r.RunStaticMethod("java.util.Locale", "getDefault", Null, Null)
		lang= r.RunMethod("getLanguage")
		'Sprache auswerten de-deutsch en-english es-spanisch fr-französisch
		If setting.ContainsKey("sprache")=False	Then'erster Start der APP
			Select True
				Case lang = "de":setting.Put("sprache","deutsch")
				Case lang = "en":setting.Put("sprache","english")
				Case lang = "es":setting.Put("sprache","espanol")
				Case lang = "fr":setting.Put("sprache","francais")
				Case Else: setting.put("sprache","english")
			End Select
		End If
	Catch
		If setting.ContainsKey("sprache")=False	Then'erster Start der APP
			setting.Put("sprache","deutsch")
		End If
	End Try
	#else
		If setting.ContainsKey("sprache")=False Then setting.Put("sprache","deutsch")
	#end if
	If setting.ContainsKey("tdefkanal")=False Then setting.Put("tdefkanal",True)
	If setting.ContainsKey("tfragenaffi")=False Then setting.Put("tfragenaffi",True)
	If setting.ContainsKey("tsabsymbol")=False Then setting.Put("tsabsymbol",True)
	If setting.ContainsKey("tgabewandlung")=False Then setting.Put("tgabewandlung",True)
	If setting.ContainsKey("tzusatzinfo")=False Then setting.Put("tzusatzinfo",False)
	If setting.ContainsKey("Übersicht")=False Then setting.Put("Übersicht",True)
	If setting.ContainsKey("Lebensthema")=False Then setting.Put("Lebensthema",False)
	If setting.ContainsKey("Typ")=False Then setting.Put("Typ",True)
	If setting.ContainsKey("Autoritaet")=False Then setting.Put("Autoritaet",True)
	If setting.ContainsKey("Profil")=False Then setting.Put("Profil",True)
	If setting.ContainsKey("Ernährung")=False Then setting.Put("Ernährung",True)
	If setting.ContainsKey("Numweg")=False Then setting.Put("Numweg",False)
	If setting.ContainsKey("Szene")=False Then setting.Put("Szene",False)
	If setting.ContainsKey("Motivation")=False Then setting.Put("Motivation",False)
	If setting.ContainsKey("Kognition")=False Then setting.Put("Kognition",False)
	If setting.ContainsKey("Fragen")=False Then setting.Put("Fragen",True)
	If setting.ContainsKey("Planetenliste")=False Then setting.Put("Planetenliste",False)
	If setting.ContainsKey("Zentren")=False Then setting.Put("Zentren",True)
	If setting.ContainsKey("Planetbeschreibung")=False Then setting.Put("Planetbeschreibung",True)
	If setting.ContainsKey("Konstellationsbild")=False Then setting.Put("Konstellationsbild",False)
	If setting.ContainsKey("maxPDFheight")=False Then setting.Put("maxPDFheight",maxPDFheight)
	If setting.ContainsKey("maxZeichen")=False Then setting.Put("maxZeichen",maxZeichen)
	If setting.ContainsKey("pdfzeilenhoehe")=False Then setting.Put("pdfzeilenhoehe",pdfZeilenhoehe)
	If setting.ContainsKey("pdfleft")=False Then setting.Put("pdfleft",pdfLeft)

	Return setting
End Sub

private Sub BildschirmTexte
	'Alle festen Texte in der passenden Sprache schreiben, inkl. edtBody
	Dim titelzeile As String = translate(Main.sprache,5)
	setTitelzeile(titelzeile)
	'B4XPages.SetTitle(Me,titelzeile) 'Chitao Glückscode
	lbl0Geburt.Text=translate(Main.sprache,26)
	lbl0Ernaehrung.Text=translate(Main.sprache,12)
	lbl0HDAutoritaet.Text=translate(Main.sprache,13)
	lbl0Szene.Text=translate(Main.sprache,14)
	lbl0HDTyp.Text=translate(Main.sprache,15)
	lbl0InKreuz.Text=translate(Main.sprache,16)
	lbl0Kognition.Text=translate(Main.sprache,18)
	lbl0NumWeg.Text=translate(Main.sprache,17)
	lbl0Person.Text=translate(Main.sprache,19)
	lbl0Profil.Text=translate(Main.sprache,20)
	lbl0Motivation.Text=translate(Main.sprache,27)
	'Auswahl Bodygrafik
	Dim l As List
	l.Initialize
	l.Add(translate(Main.sprache,1)) 'Design & Persönlichkeit
	l.Add(translate(Main.sprache,2)) 'Nur Design
	l.Add(translate(Main.sprache,3)) 'Nur Persönlichkeit
	l.Add(translate(Main.sprache,4)) 'Sternzeichenfarbe
	l.Add(translate(Main.sprache,82))'Mit Transit
	l.Add(translate(Main.sprache,81))'Nur Transit
	edtBody.SetItems(l)
	edtBody.SelectedIndex = kvs.get("edtbody")
	
End Sub

public Sub translate(lang As String, ind As Int) As String
	Dim query As String = "select "&Main.sprache&" from Sprache where id="&ind
	'Log("Sprache Index:"&ind)
	Dim text As String = Main.SQL.ExecQuerySingleResult(query)
	'Log(ind&","&text)
	Return text
End Sub
public Sub translateMatrixlifecode(lang As String, ind As Int) As String
	Dim query As String = "select "&Main.sprache&" from Matrixlifecode where id="&ind
	Dim text As String = Main.SQL.ExecQuerySingleResult(query)
	'Log(ind&","&text)
	Return text
End Sub

'Sub deleteEintraegemitTag (clvm As CustomListView,tageintrag As String) As CustomListView
'	'Löscht die Panels in der Customlistview mit .tag=tageintrag
'	Dim gesamt As Int = clvm.Size - 1
'	For i=0 To gesamt
'		Dim p As B4XView = clvm.GetPanel(i)
'		Dim t As Object = p.Tag
'		If t <>	Null Then
'			If p.Tag =tageintrag Then 
'				clvm.RemoveAt(i)
'				gesamt = gesamt - 1
'			End If
'		End If
'	Next
'	Return clvm
'End Sub

Sub B4XPage_Disappear
	stopMeridianuhr
	Log("Meridianuhr gestoppt!")
End Sub

Sub startMeridianuhr
	If timerMeridianUhr.IsInitialized = False Then
		'startet den Timer, der die Updates der Meridianuhr triggert
		timerMeridianUhr.Initialize("timerMeridianUhr",60000) '1 min
	End If
	timerMeridianUhr.Enabled=True
End Sub

Sub timerMeridianUhr_tick
	'Merdianuhr wird aktualisiert
	updateEnergieBooster
End Sub

Sub stopMeridianuhr
	'Bei Verlassen der Hauptseite wird die Meridianuhr und der damit gestartete Timer gestoppt.
	timerMeridianUhr.Enabled=False
End Sub

Sub updateEnergieBooster
	'Zeigt die aktivierten Tordetails mit Berücksichtigung von Transiten und den Meridian, wo gerade die Energie verstärkt ist.
	'aktuelle Uhrzeit ermitteln
	Dim sm As Map
	
	If iduser=-1 Then Return
	sm.Initialize
	'Liste erst mal leeren
	
	DateTime.DateFormat="dd.MM.yyyy"
	DateTime.TimeFormat="HH:mm"
	'Dim datum As String=DateTime.Date(DateTime.Now)
	'Dim zeit As String = DateTime.Time(DateTime.Now)
	'Ermitteln der anzuzeigenden Werte
	'Auswertungen bei Click auf bodygraph
	Dim Query As String ="Select * from ToreNachZeit" 'Ist bereits nach Startzeit sortiert
	Dim rs As ResultSet = Main.sql.ExecQuery(Query)
	Dim aktuelleEnergie As Boolean
	Dim schleifeverlassen As Boolean
	Dim count As Int = 0 'Wie viele Einträge sind vorhanden ?
	Dim rowno As Int = 0 'In welcher Zeile ist der Eintrag
	Do While rs.NextRow
		Dim rotschwarz As Char
		Dim mzeit1, mzeit2 As String
		
		'Nächste Energiezeit ermitteln
		mzeit1 = rs.GetString("time1")
		mzeit2 = rs.GetString("time2")
		Dim lzeit1 As Long = DateTime.timeparse(mzeit1)
		Dim lzeit2 As Long = DateTime.timeparse(mzeit2)
		
		If lzeit1 < DateTime.now And lzeit2 < DateTime.now Then 
			rowno = rowno + 1
			Continue 'schon vergangen
		End If
		
		If lzeit1 <= DateTime.Now And lzeit2 >= DateTime.now Then 'innerhalb des Energiefensters
			aktuelleEnergie = True
			count = count + 1
		End If
		If lzeit1 > DateTime.now And lzeit2 > DateTime.now Then 'naechstes Tor des Energiefensters
			aktuelleEnergie = False
			If count > 0 Then 'aktive Tore sind vorhanden, nichts anzeigen
				Exit
			Else			'diesen Eintrag anzeigen
				aktuelleEnergie = False
				schleifeverlassen = True
			End If
		End If
		
		'Werte ermitteln
		rotschwarz  = rs.GetString("RotSchwarz")
		
		'Werte anzeigen	
		Dim senergie As String = "Energie Booster"
		If aktuelleEnergie Then
			lenergie.Text = "Momentaner "&senergie
		Else
			If count = 0 Then lenergie.Text = "Nächster "&senergie
		End If
		
		lIdTor.Text = rs.GetInt("IdTor")
		lLinie.Text = rs.GetInt("Linie")
		lTorname.Text = rs.GetString("TorName")
		If rotschwarz = "s" Then
			lIdTor.TextColor = xui.Color_Black
			lLinie.TextColor = xui.Color_Black
			lTorname.TextColor = xui.Color_Black
		End If
		If rotschwarz = "r" Then
			lIdTor.TextColor = Main.colrot
			lLinie.TextColor = Main.colrot
			lTorname.TextColor = Main.colrot
		End If
		If rotschwarz = "t" Then
			lIdTor.TextColor = xui.Color_blue
			lLinie.TextColor = xui.Color_blue
			lTorname.TextColor = xui.Color_blue
		End If
		ltime1.Text = rs.GetString("time1")
		ltime2.Text = rs.GetString("time2")
		aktuellerMeridian = rs.GetString("hauptmeridian")'aktuellerMerdian ist globale Variable
		'Mondstand ermitteln und in lmondin anzeigen
		'Aktuelle Transite berechnen, damit steht fest wo Mond jetzt ist.
		deleteandaddtransitefuerAktuellePerson
		Dim Query As String ="Select * from ToreNachZeit where IdPlanet=4 and RotSchwarz='t'"
		Dim rs1 As ResultSet = Main.sql.ExecQuery(Query)
		Do While rs1.NextRow	'können mehrere Einträge je nach Uhrzeit sein, nach erstem kann aber verlassen werden
			Dim idt As Int = rs1.GetInt("IdTor")
			Dim idl As Int = rs1.GetInt("Linie")
			Dim idn As String = rs1.Getstring("TorName")
			lmondinTor.Text = idt
			lmondinTor.Tag = idn
			lmondinLinie.Text = idl
'			Query = "Select IDSternzeichen from HDLinien where IdTor=" & idt & " and Linie = " & idl
'			Dim idstz1 As Int = Main.sql.ExecQuerySingleResult(Query)
			Dim idsab As Int = rs1.GetInt("IdSab")
			Dim idstz As Int = Sammlung.convertiereSabSymbolinSternzeichen(idsab)	
			Dim stz As String = Main.SQL.ExecQuerySingleResult("select Sternzeichen from Sternzeichen where IdSternzeichen = "&idstz)
		
			'Bei Mond Transit zusätzlicher die globale Variable aktuellerMondIn setzen
			
			aktuellerMondIn=stz
			Exit	'Sind alles dieselben Tore,Linien
		Loop
		rs1.close
		lmondin.Text = "Mond in "&aktuellerMondIn
		
		rowno=rowno + 1
		If schleifeverlassen = True Then Exit 'Schleife verlassen
	Loop
	rs.Close
	rowidTorenachZeit = rowno 'um bei Click auf Panel zum passenden Eintrag in clvWichtig navigieren zu können.
	
	statusTransit = False 'Aktualisierung beendet
End Sub

Sub dbinitialisieren
		'initialize the database
	#If b4j
	  	Main.SQL.InitializeSQLite(xui.DefaultFolder,dbname, False)      
	#Else
	If Main.SQL.IsInitialized = False Then 'Bei user ist die Datenbank hier bereits initialisiert
		Main.sql.Initialize(xui.DefaultFolder, dbname, False)
	End If
	#End If
End Sub

#if b4j
	Sub peinstellungen_MouseClicked (EventData As MouseEvent)
	EventData.Consume  'Damit bei Windows nicht das darunterliegende Panel triggert
#Else
	Sub config_click
#End If
	Einstellungen
End Sub

#if b4j
	Sub pbodytore_MouseClicked (EventData As MouseEvent)
#Else
	Sub bodytore_Click	'hier kein Panel sondern das Label wird direkt geclickt
		ToastMessageShow("berechne ...", False)
		Sleep(100)
#end if
	zeichneBodyExakt("bodygraphdetail.png","bodygraphexakt.png",statusZentrenWerte,edtBody.SelectedIndex)	'sichert in bodygraphexakt.png
	If edtBody.SelectedIndex = 5 Then
		zeichneToreLinien(iduser,"bodygraphexakt.png",True)'Zeichnet nur Transit
	Else
		zeichneToreLinien(iduser,"bodygraphexakt.png",False)'Zeichnet die Roten und Schwarzen Tore/Linien
	End If
	#if b4j 'Bei Windows die Detailseite öffnen
		If EventData.IsInitialized =True Then		'nicht initialisiert wenn es von Hauptseite zum Zeichnen von bodygraphexakt aufgerufen wird
			EventData.Consume 						'Damit pbodygraphexakt_mouseclicked nicht auslöst.
			B4XPages.ShowPage("zoomimage")
		End If	
	#else	
		B4XPages.ShowPage("zoomimage")
	#end if
End Sub

'Click auf Image öffnet clvWichtig- Seite

 Sub body_Click
	idsternzeichen = 0		'Wird zur Steuerung in clvWichtig verwendet
	statusTransit=False
	B4XPages.ShowPage("clvWichtig")
End Sub
#if b4a
Sub bodydetail_click
	body_Click
End Sub
#end if

#if b4j
	Sub lblPerson_MouseClicked (EventData As MouseEvent)
	PersonLaden
#else
	Sub lblPerson_Click
#end if
	'Wenn mehr als ein Eintrag in Benutzer existiert, dann anzeigen
	Dim Query As String = "Select count(*) from Benutzer"
	Dim anz As Int =  Main.sql.ExecQuerySingleResult(Query)
	If anz > 1 Then
		PersonLaden
	End If
End Sub

#If B4J
	'Delegate the native menu action to B4XPage_MenuClick.
	'Allgemeine Auswahl aus Menü
	Sub MenuBar1_Action
			Dim 	auswahl As MenuItem = Sender
			Dim t As String
			If auswahl.Tag = Null Then t = auswahl.Text.Replace("_", "") Else t = auswahl.Tag
			B4XPage_MenuClick(t)
	End Sub
#end if

'Bearbeitet Menüauswahl
public Sub B4XPage_MenuClick (Tag As String)
	
	#if user
	Select True
		Case Tag = "Neu":
			'User kann nur zusätzliche PersCounter erwerben, Admin und Windows dürfen alles
			Dim Query As String = "Select count(*) from Benutzer"
			Dim anz As Int =  Main.sql.ExecQuerySingleResult(Query)
			If anz >= PersCounter Then
				xui.Msgbox2Async(translate(Main.sprache,93)&PersCounter&CRLF&translate(Main.sprache,94)&anz&CRLF&CRLF&translate(Main.sprache,95),translate(Main.sprache,95),translate(Main.sprache,91), translate(Main.sprache,92), "", Null)
				Wait For Msgbox_Result (ergebnis As Int)
				If ergebnis = xui.DialogResponse_Positive Then
					kaufePersoneneintrag
				End If
				Return
			End If
			B4XPages.ShowPage("PersonNeu")
		Case Tag = "Laden":
			PersonLaden
		Case Tag = "Beratung":
			xui.Msgbox2Async(translate(Main.sprache,87), translate(Main.sprache,88), translate(Main.sprache,91), translate(Main.sprache,92), "", Null)
			Wait For Msgbox_Result (ergebnis As Int)
			If ergebnis = xui.DialogResponse_Positive Then
				kaufeBeratung
			End If
		Case Tag = "Einstellungen"
			Einstellungen
		Case Tag = "freischaltcode":
			freischaltcodePruefen
		Case Tag = "Hilfe":
			Hilfe
	End Select
	Return		'Bei User hier beenden
	#End If
	
	Select True
		Case Tag = "Laden":
			PersonLaden
			Return
		Case Tag = "Neu":
			B4XPages.ShowPage("PersonNeu")
			Return
		Case Tag = "Löschen":
			deleteUser_Click
			Return
		Case Tag = "Hilfe":
			Hilfe
			Return
		Case Tag = "PDFalle":
			#if admin
				Dim clvp As clvWichtig
				clvp = B4XPages.GetPage("clvWichtig")
				clvp.PDFalleToreLinien
			#end if
			Return
		Case Tag = "Bearbeiten":
			StrukturBenutzer
			Main.Mode = "Tabelle"
		Case Tag = "Kanaele":
			StrukturKanaele
			Main.Mode = "Tabelle"
		Case Tag = "Konstellationsbilder":
			StrukturKonstellationsbilder
			Main.Mode = "Tabelle"
		Case Tag = "Hexagramme":
			StrukturHexagramme
			Main.Mode = "Tabelle"
		Case Tag = "Gottheiten":
			StrukturGottheiten
			Main.Mode = "Tabelle"
		Case Tag = "Planeten":
			StrukturPlaneten
			Main.Mode = "Tabelle"
		Case Tag = "PlanetenBedeutung":
			StrukturPlanetenBedeutung
			Main.Mode = "Tabelle"
		Case Tag = "Sternzeichen":
			StrukturSternzeichen
			Main.Mode = "Tabelle"
		Case Tag = "Mp3Inhalte":
			StrukturMp3Inhalte
			Main.Mode = "Tabelle"
		Case Tag = "PdfInhalte":
			StrukturPdfInhalte
			Main.Mode = "Tabelle"
		Case Tag = "TorederAngst":
			StrukturTorederAngst
			Main.Mode = "Tabelle"
		Case Tag = "TorederLiebe":
			StrukturTorederLiebe
			Main.Mode = "Tabelle"
		Case Tag = "ToreDruck":
			StrukturToreDruck
			Main.Mode = "Tabelle"
		Case Tag = "ToreFrust":
			StrukturToreFrust
			Main.Mode = "Tabelle"
		Case Tag = "ToreSchubkraft":
			StrukturToreSchubkraft
			Main.Mode = "Tabelle"
		Case Tag = "NumWeg":
			StrukturNumWeg
			Main.Mode = "Tabelle"
		Case Tag = "Zentren":
			StrukturZentren
			Main.Mode = "Tabelle"
		Case Tag = "HD":
			StrukturHD
			Main.Mode = "Tabelle"
		Case Tag = "HDLinien":
			StrukturHDLinien
			Main.Mode = "Tabelle"
		Case Tag = "Matrixlifecode":
			StrukturMatrixlifecode
			Main.Mode = "Tabelle"
		Case Tag = "Meridiane":
			StrukturMeridiane
			Main.Mode = "Tabelle"
		Case Tag = "MeridianeBehandlung":
			StrukturMeridianeBehandlung
			Main.Mode = "Tabelle"
		Case Tag = "MeridianeBehandlungKategorien":
			StrukturMeridianeBehandlungKategorien
		Case Tag = "MondBehandlung":
			StrukturMondBehandlung
			Main.Mode = "Tabelle"
		Case Tag = "MondBehandlungKategorien":
			StrukturMondBehandlungKategorien
			Main.Mode = "Tabelle"
		Case Tag = "RnaBase":
			StrukturRnaBase
			Main.Mode = "Tabelle"
		Case Tag = "Sprache":
			StrukturSprache
			Main.Mode = "Tabelle"
		Case Tag = "AktivierteKanäle":
			StrukturAktivierteKanaele
			Main.Mode = "Auswertung"
		Case Tag = "GenkeysAktivierung":
			StrukturGenkeys
			Main.Mode = "Auswertung"
		Case Tag = "ToreUndDeutung"
			StrukturToreUndDeutung
			Main.Mode = "Auswertung"
		Case Tag = "ReportZentren"
			B4XPages.ShowPage("clvZentren")
			Return
		Case Tag = "Einstellungen"
			Einstellungen
			Return
		Case Tag ="LadeDatenbank"
			B4XPages.ShowPage("DBTransfer")
			Return
		Case Tag ="Sabische"
			StrukturSabischeSymbole
			Main.Mode="Tabelle"
		Case Tag ="HDTyp"
			StrukturHDTyp
			Main.Mode="Tabelle"
		Case Tag ="InKreuz"
			StrukturInKreuz
			Main.Mode="Tabelle"
		Case Tag ="Rollen"
			StrukturRollen
			Main.Mode="Tabelle"
		Case Tag ="Elemente"
			StrukturElemente	
			Main.Mode="Tabelle"
		Case Tag ="Enneagramm"
			StrukturEnneagramm
			Main.Mode="Tabelle"
		Case Tag ="Beschwerden"
			StrukturBeschwerden
			Main.Mode="Tabelle"
		Case Tag ="Autoritaet"
			StrukturHDAutoritaet
			Main.Mode="Tabelle"
		Case Tag ="HDProfil"
			StrukturHDProfil
			Main.Mode="Tabelle"
		Case Tag = "Haus"
			StrukturHaus
			Main.Mode="Tabelle"
		Case Tag ="HDErnaehrung"
			StrukturHDErnaehrung
			Main.Mode="Tabelle"
		Case Tag ="NumWeg"
			StrukturNumWeg
			Main.Mode="Tabelle"
		Case Tag ="Szene"
			StrukturSzene
			Main.Mode="Tabelle"
		Case Tag ="Motivation"
			StrukturMotivation
			Main.Mode="Tabelle"
		Case Tag ="Kognition"
			StrukturKognition
			Main.Mode="Tabelle"
		Case Else
			Return
	End Select
	B4XPages.ShowPage("Zeigen")
End Sub

#if user
Sub kaufeSubscriptionBehandlungen
	'Monatliche Subscription fuer Behandlungen kaufen
	Dim sku As String = SKU_ID3
	'Shopanbindung testen
	Wait For (billing.ConnectIfNeeded) Billing_Connected (billresult As BillingResult)
	If billresult.IsSuccess Then 'Shop-Anbindung steht
		'get the sku details
		Dim sf As Object = billing.QuerySkuDetails("subs", Array(sku))
		Wait For (sf) Billing_SkuQueryCompleted (billresult As BillingResult, SkuDetails As List)
		If billresult.IsSuccess And SkuDetails.Size = 1 Then
			'LaunchBillingFlow ruft als Ergebnis billing_purchaseupdated in Mainpage auf
			billresult = billing.LaunchBillingFlow(SkuDetails.Get(0))
			If billresult.IsSuccess = True Then Log("Storeanbindung:"&billresult.IsSuccess)
		End If
	Else
		ToastMessageShow("Error starting billing process", True)
	End If
End Sub

Sub kaufeBeratung
	
	Dim sku As String = SKU_ID2 'Beratung kaufen
	'Shopanbindung testen
	Wait For (billing.ConnectIfNeeded) Billing_Connected (billresult As BillingResult)
	If billresult.IsSuccess Then 'Shop-Anbindung steht
		'get the sku details
		Dim sf As Object = billing.QuerySkuDetails("inapp", Array(sku))
		Wait For (sf) Billing_SkuQueryCompleted (billresult As BillingResult, SkuDetails As List)
		If billresult.IsSuccess And SkuDetails.Size = 1 Then
			'LaunchBillingFlow ruft als Ergebnis billing_purchaseupdated in Mainpage auf
			billresult = billing.LaunchBillingFlow(SkuDetails.Get(0))
			If billresult.IsSuccess = True Then Log("Storeanbindung:"&billresult.IsSuccess)
		End If
	Else
		ToastMessageShow("Error starting billing process", True)
	End If
End Sub

Sub kaufePersoneneintrag
	'zusätzliche Person dazukaufen und PersCount erhöhen
	Dim sku As String = SKU_ID1
	'Shopanbindung testen
	Wait For (billing.ConnectIfNeeded) Billing_Connected (billresult As BillingResult)
	If billresult.IsSuccess Then 'Shop-Anbindung steht
		'get the sku details
		Dim sf As Object = billing.QuerySkuDetails("inapp", Array(sku))
		Wait For (sf) Billing_SkuQueryCompleted (billresult As BillingResult, SkuDetails As List)
		If billresult.IsSuccess And SkuDetails.Size = 1 Then
			'LaunchBillingFlow ruft als Ergebnis billing_purchaseupdated in Mainpage auf
			billresult = billing.LaunchBillingFlow(SkuDetails.Get(0))
			If billresult.IsSuccess = True Then Log("Storeanbindung:"&billresult.IsSuccess)
		End If
	Else
		ToastMessageShow("Error starting billing process", True)
	End If
End Sub


Sub freischaltcodePruefen As ResumableSub
	'Codefenster anzeigen
	'Eingabe muss mit einem Wert in Feld 'code' in Tabelle 'freischaltcode' übereinstimmen, wobei benutzt = 0 sein muss.
	Dim codefield As B4XInputTemplate
	codefield.Initialize
	codefield.lblTitle.TextColor=Main.colrosa
	codefield.lblTitle.Text = "Erhaltenen Code eingeben:"
	Wait For (dlg.ShowTemplate(codefield, "OK", "Cancel", "")) Complete (Result As Int)
	If Result = xui.DialogResponse_Positive Then
		Dim inhalt As String = codefield.text
		Dim Query As String = "Select count(*) from direktkauf where code='" & inhalt & "' and benutzt=0"
		Dim res As String =  Main.sql.ExecQuerySingleResult(Query)
		If res <> 0 Then 
			'globale PersCounter erhöhen
			PersCounter = PersCounter + 1
			'speichern in KVS
			kvs.Put("perscounter",PersCounter)
			'Code als benutzt markieren
			Query = "Update direktkauf set benutzt=1 where code='" & inhalt & "'"
			Main.SQL.ExecNonQuery(Query)
			MsgboxAsync(translate(Main.sprache,84),translate(Main.sprache,96))
		Else
			MsgboxAsync(translate(Main.sprache,97),translate(Main.sprache,98))
		End If
	End If
End Sub
#end if   'if user

'Benutzerdatenbank
Sub StrukturBenutzer
	Main.DBName = "Benutzer"
	Main.TotColNumber=31
	Main.FrozenCols=3
	Main.ColNames = Array As String("IdName","Frau","Name","Vorname","Geburtsdatum","Geburtszeit","Designdatum","Designuhrzeit","Email","Mobil","FuerDich","Karteikarte","Haeuser","HDTyp","Autoritaet","Profil","HDInkarnationskreuz","HDErnaehrung","NumWeg","Szene","Motivation","Kognition","Z1","Z2","Z3","Z4","Z5","Z6","Z7","Z8","Z9")
	Main.ColDataTypes=Array As String("INT","TEXT","TEXT", "TEXT","TEXT","TEXT","TEXT", "TEXT", "TEXT", "TEXT", "TEXT", "TEXT", "TEXT","TEXT","TEXT","TEXT","INT", "TEXT", "TEXT", "TEXT", "TEXT", "TEXT", "TEXT", "TEXT", "TEXT","TEXT","TEXT", "TEXT","TEXT", "TEXT", "TEXT")
End Sub
Sub StrukturHexagramme
	Main.DBName = "Hexagramme"
	Main.TotColNumber=19
	Main.FrozenCols=1
	Main.ColNames = Array As String("IdTor","TorName","IdZentrum","ProgPartner","OppTor","Quadrant","Schaltkreis","Element","TorBeschreibung","Schatten","Gabe","Siddhi","GabeBeschreibung","Amino","IdEnneagramm","PHS","WenCode","IdGott","Notiz")
	Main.ColDataTypes = Array As String("INT","TEXT","INT","INT","INT","INT","TEXT","TEXT","TEXT","TEXT","TEXT","TEXT","TEXT","TEXT","INT","TEXT","TEXT","TEXT","TEXT")
End Sub
Sub StrukturAktivierteKanaele
	Main.DBName = "AktivierteKanaeleRotSchwarz" 'Transite werden hier nicht berücksichtigt
	Main.TotColNumber=5
	Main.FrozenCols=0
	Main.ColNames= Array As String("KanalA","KanalB","Kanal", "Name","Rollen")
	Main.ColDataTypes = Array As String("INT","INT","TEXT","TEXT","TEXT")
End Sub
Sub StrukturRnaBase
	Main.DBName = "RnaBase"
	Main.TotColNumber=10
	Main.FrozenCols=1
	Main.ColNames= Array As String("IdTor","time1","time2","hauptmeridian","triplet1","meridian1","triplet2","meridian2","triplet3","meridian3")
	Main.ColDataTypes = Array As String("INT","TEXT","TEXT","TEXT","TEXT","TEXT","TEXT","TEXT","TEXT","TEXT")
End Sub
Sub StrukturMeridiane
	Main.DBName = "Meridiane"
	Main.TotColNumber=3
	Main.FrozenCols=1
	Main.ColNames= Array As String("meridian","name","notiz")
	Main.ColDataTypes = Array As String("TEXT","TEXT","TEXT")
End Sub
Sub StrukturMeridianeBehandlung
	Main.DBName = "MeridianeBehandlung"
	Main.TotColNumber=4
	Main.FrozenCols=1
	Main.ColNames= Array As String("kat","meridian","beschreibung","bild")
	Main.ColDataTypes = Array As String("TEXT","TEXT","TEXT","TEXT")
End Sub
Sub StrukturMeridianeBehandlungKategorien
	Main.DBName = "MeridianeBehandlungKategorien"
	Main.TotColNumber=4
	Main.FrozenCols=0
	Main.ColNames= Array As String("prio","kat","name","notiz")
	Main.ColDataTypes = Array As String("INT","TEXT","TEXT","TEXT")
End Sub
Sub StrukturMondBehandlung
	Main.DBName = "MondBehandlung"
	Main.TotColNumber=4
	Main.FrozenCols=1
	Main.ColNames= Array As String("kat","idSternzeichen","beschreibung","bild")
	Main.ColDataTypes = Array As String("TEXT","INT","TEXT","TEXT")
End Sub
Sub StrukturMondBehandlungKategorien
	Main.DBName = "MondBehandlungKategorien"
	Main.TotColNumber=4
	Main.FrozenCols=0
	Main.ColNames= Array As String("prio","kat","name","notiz")
	Main.ColDataTypes = Array As String("INT","TEXT","TEXT","TEXT")
End Sub
Sub StrukturSprache
	Main.DBName = "Sprache"
	Main.TotColNumber=5
	Main.FrozenCols=1
	Main.ColNames= Array As String("id","deutsch","english","espanol","francais")
	Main.ColDataTypes = Array As String("INT","TEXT","TEXT","TEXT","TEXT")
End Sub
Sub StrukturMatrixlifecode
	Main.DBName = "Matrixlifecode"
	Main.TotColNumber=8
	Main.FrozenCols=2
	Main.ColNames= Array As String("id","ueberschrift","deutsch","english","espanol","francais","bild1","bild2")
	Main.ColDataTypes = Array As String("INT","TEXT","TEXT","TEXT","TEXT","TEXT","TEXT","TEXT")
End Sub
Sub StrukturTorederAngst
	Main.DBName = "TorederAngst"
	Main.TotColNumber=4
	Main.FrozenCols=1
	Main.ColNames= Array As String("IdTor","Angst","Fragen", "Affirmationen")
	Main.ColDataTypes = Array As String("INT","TEXT","TEXT","TEXT")
End Sub
Sub StrukturTorederLiebe
	Main.DBName = "TorederLiebe"
	Main.TotColNumber=4
	Main.FrozenCols=1
	Main.ColNames= Array As String("IdTor","Liebe","Fragen", "Affirmationen")
	Main.ColDataTypes = Array As String("INT","TEXT","TEXT","TEXT")
End Sub
Sub StrukturToreDruck
	Main.DBName = "ToreDruck"
	Main.TotColNumber=4
	Main.FrozenCols=1
	Main.ColNames= Array As String("IdTor","Druck","Fragen", "Affirmationen")
	Main.ColDataTypes = Array As String("INT","TEXT","TEXT","TEXT")
End Sub
Sub StrukturToreFrust
	Main.DBName = "ToreFrust"
	Main.TotColNumber=4
	Main.FrozenCols=1
	Main.ColNames= Array As String("IdTor","FrustPotential","Fragen", "Affirmationen")
	Main.ColDataTypes = Array As String("INT","TEXT","TEXT","TEXT")
End Sub
Sub StrukturToreSchubkraft
	Main.DBName = "ToreSchubkraft"
	Main.TotColNumber=4
	Main.FrozenCols=1
	Main.ColNames= Array As String("IdTor","Turbo","Fragen", "Affirmationen")
	Main.ColDataTypes = Array As String("INT","TEXT","TEXT","TEXT")
End Sub
Sub StrukturToreUndDeutung
	Main.DBName = "ToreUndDeutung"
	Main.TotColNumber=11
	Main.FrozenCols=1
	Main.ColNames = Array As String("IdTor","TorName","Schatten","Gabe", "Siddhi","Linie","RotSchwarz","IdZentrum","Element","ProgPartner", "Planet")
	Main.ColDataTypes = Array As String("INT","TEXT","TEXT","TEXT","TEXT","INT","TEXT","INT","TEXT","INT","TEXT")	
End Sub
Sub StrukturGenkeys
	Main.DBName = "GenkeysAktivierung"
	Main.TotColNumber=11
	Main.FrozenCols=1
	Main.ColNames= Array As String("IdTor","TorName","Schatten","Gabe","Siddhi","Linie","Element","ProgPartner","Zentrum","Planet","RotSchwarz")
	Main.ColDataTypes = Array As String("INT","TEXT","TEXT","TEXT","TEXT","INT","TEXT","INT","TEXT","TEXT","TEXT")
End Sub
Sub StrukturHDTyp
	Main.DBName = "HDTyp"
	Main.TotColNumber=4
	Main.FrozenCols=0
	Main.ColNames=Array As String("Id","HDTyp","BeschreibungHDTyp","Notiz")
	Main.ColDataTypes=Array As String("INT","TEXT","TEXT","TEXT")
End Sub
Sub StrukturHaus
	Main.DBName = "Haus"
	Main.TotColNumber=4
	Main.FrozenCols=0
	Main.ColNames=Array As String("IdHaus","Geschlecht","IdSternzeichen","HausBeschreibung")
	Main.ColDataTypes=Array As String("INT","TEXT","INT","TEXT")
End Sub
Sub StrukturElemente
	Main.DBName = "Elemente"
	Main.TotColNumber=2
	Main.FrozenCols=0
	Main.ColNames=Array As String("Element","ElementBeschreibung")
	Main.ColDataTypes=Array As String("TEXT","TEXT")
End Sub
Sub StrukturEnneagramm
	Main.DBName = "Enneagramm"
	Main.TotColNumber=5
	Main.FrozenCols=0
	Main.ColNames=Array As String("IdEnneagramm","Name","Beschreibung","Bild","Notiz")
	Main.ColDataTypes=Array As String("INT","TEXT","TEXT","TEXT","TEXT","TEXT")
End Sub
Sub StrukturRollen
	Main.DBName = "Rollen"
	Main.TotColNumber=3
	Main.FrozenCols=0
	Main.ColNames=Array As String("Rollen","RollenBeschreibung","Notiz")
	Main.ColDataTypes=Array As String("TEXT","TEXT","TEXT")
End Sub
Sub StrukturHDAutoritaet
	Main.DBName = "HDAutoritaet"
	Main.TotColNumber=4
	Main.FrozenCols=0
	Main.ColNames=Array As String("Id","Autoritaet","BeschreibungAutoritaet","Notiz")
	Main.ColDataTypes=Array As String("INT","TEXT","TEXT","TEXT")
End Sub
Sub StrukturHDProfil
	Main.DBName = "HDProfil"
	Main.TotColNumber=4
	Main.FrozenCols=0
	Main.ColNames=Array As String("Profil","Pos","BeschreibungProfil","Notiz")
	Main.ColDataTypes=Array As String("TEXT","TEXT","TEXT","TEXT")
End Sub
Sub StrukturSzene
	Main.DBName = "Szene"
	Main.TotColNumber=4
	Main.FrozenCols=0
	Main.ColNames=Array As String("Id","Szene","BeschreibungSzene","Notiz")
	Main.ColDataTypes=Array As String("TEXT","TEXT","TEXT","TEXT")
End Sub
Sub StrukturMotivation
	Main.DBName = "Motivation"
	Main.TotColNumber=4
	Main.FrozenCols=0
	Main.ColNames=Array As String("Id","Motivation","BeschreibungMotivation","Notiz")
	Main.ColDataTypes=Array As String("TEXT","TEXT","TEXT","TEXT")
End Sub
Sub StrukturKognition
	Main.DBName = "Kognition"
	Main.TotColNumber=4
	Main.FrozenCols=0
	Main.ColNames=Array As String("Id","Kognition","BeschreibungKognition","Notiz")
	Main.ColDataTypes=Array As String("TEXT","TEXT","TEXT","TEXT")
End Sub
Sub StrukturHDErnaehrung
	Main.DBName = "HDErnaehrung"
	Main.TotColNumber=4
	Main.FrozenCols=0
	Main.ColNames=Array As String("Id","HDErnaehrung","BeschreibungErnaehrung","Notiz")
	Main.ColDataTypes=Array As String("INT","TEXT","TEXT","TEXT")
End Sub
Sub StrukturNumWeg
	Main.DBName = "NumWeg"
	Main.TotColNumber=3
	Main.FrozenCols=0
	Main.ColNames=Array As String("NumWeg","BeschreibungNumWeg","Notiz")
	Main.ColDataTypes=Array As String("INT","TEXT","TEXT")
End Sub
Sub StrukturInKreuz
	Main.DBName = "InKreuz"
	Main.TotColNumber=5
	Main.FrozenCols=1
	Main.ColNames=Array As String("IdIn","IdTor","Pos","InName","InBezeichnung")
	Main.ColDataTypes=Array As String("INT","INT","TEXT","TEXT","TEXT")
End Sub
Sub StrukturBeschwerden
	Main.DBName = "Beschwerden"
	Main.TotColNumber=6
	Main.FrozenCols=1
	Main.ColNames=Array As String("koerperregionnr","koerperregion","bereich","beschwerde","detail","IdPlanet")
	Main.ColDataTypes=Array As String("INT","TEXT","TEXT","TEXT","TEXT","INT")
End Sub
'Sub StrukturSelbsterforschung
'	Main.DBName = "Selbsterforschung"
'	Main.TotColNumber=4
'	Main.FrozenCols=1
'	Main.ColNames=Array As String("IdPlanet","Frage","Tugendfrage","Antwort")
'	Main.ColDataTypes=Array As String("INT","TEXT","TEXT","TEXT")
'End Sub
Sub StrukturHDLinien
	Main.DBName = "HDLinien"
	Main.TotColNumber=17
	Main.FrozenCols=3
	Main.ColNames=Array As String("IdTor","Linie","IdSternzeichen","Bedeutung","Frage1","Frage2","Frage3","Affirmation1","Affirmation2","Affirmation3","Mp3Inhalt1","Mp3Inhalt2","Mp3Inhalt3","PdfInhalt1","PdfInhalt2","PdfInhalt3","Notiz")
	Main.ColDataTypes=Array As String("INT","INT","INT","TEXT","TEXT","TEXT","TEXT","TEXT","TEXT","TEXT","INT","INT","INT","INT","INT","INT","TEXT")
End Sub
Sub StrukturKanaele
	Main.DBName = "Kanaele"
	Main.TotColNumber=10
	Main.FrozenCols=0
	Main.ColNames= Array As String("KanalA", "KanalB","Kanal", "Name", "Rollen","BeschreibungKanal","Notiz","HDTypKennzeichen","ZentrumA","ZentrumB")
	Main.ColDataTypes =  Array As String("INT","INT","TEXT","TEXT","TEXT","TEXT","TEXT","TEXT","INT","INT")
End Sub
Sub StrukturKonstellationsbilder
	Main.DBName = "Konstellationsbilder"
	Main.TotColNumber=6
	Main.FrozenCols=0
	Main.ColNames= Array As String("PlanetA", "PlanetB","Beschreibung","Bachbluete","BlueteNotiz","BlueteBild")
	Main.ColDataTypes =  Array As String("TEXT","TEXT","TEXT","TEXT","TEXT","TEXT")
End Sub
Sub StrukturZentren
	Main.DBName = "Zentren"
	Main.TotColNumber=10
	Main.FrozenCols=1
	Main.ColNames= Array As String("IdZentren", "Zentrum","BeschreibungZentrum","Definiert", "Undefiniert","AffirmationDefiniert","AffirmationUndefiniert","FragenDefiniert","FragenUndefiniert","Notiz")
	Main.ColDataTypes =  Array As String("INT","TEXT","TEXT","TEXT","TEXT","TEXT","TEXT","TEXT","TEXT","TEXT")
End Sub
Sub StrukturSternzeichen
	Main.DBName = "Sternzeichen"
	Main.TotColNumber=10
	Main.FrozenCols=1
	Main.ColNames= Array As String("IdSternzeichen","Sternzeichen","IdPlanet","BeschreibungSternzeichen","Lernbereich","Tugend","Konsonant","Sinn","Schuessler","Notiz")
	Main.ColDataTypes =  Array As String("INT","TEXT","INT","TEXT","TEXT","TEXT","TEXT","TEXT","TEXT","TEXT")
End Sub
Sub StrukturMp3Inhalte
	Main.DBName = "Mp3Inhalte"
	Main.TotColNumber=3
	Main.FrozenCols=1
	Main.ColNames= Array As String("IdMp3","Bezeichnung","Mp3Dateiname")
	Main.ColDataTypes =  Array As String("INT","TEXT","TEXT")
End Sub
Sub StrukturPdfInhalte
	Main.DBName = "PdfInhalte"
	Main.TotColNumber=3
	Main.FrozenCols=1
	Main.ColNames= Array As String("IdPdf","Bezeichnung","PdfDateiname")
	Main.ColDataTypes =  Array As String("INT","TEXT","TEXT")
End Sub
Sub StrukturPlanetenBedeutung
	Main.DBName = "PlanetenBedeutung"
	Main.TotColNumber=4
	Main.FrozenCols=1
	Main.ColNames= Array As String("ID","Planet","RotSchwarz","Bedeutung")
	Main.ColDataTypes =  Array As String("INT","TEXT","TEXT","TEXT")
End Sub
Sub StrukturGottheiten
	Main.DBName = "Gottheiten"
	Main.TotColNumber=4
	Main.FrozenCols=1
	Main.ColNames= Array As String("Id","Gottheit","Beschreibung","Notiz")
	Main.ColDataTypes =  Array As String("INT","TEXT","TEXT","TEXT")
End Sub
Sub StrukturPlaneten
	Main.DBName = "Planeten"
	Main.TotColNumber=14
	Main.FrozenCols=1
	Main.ColNames = Array As String("IdPlanet","Planet","BeschreibungS","BildS","BeschreibungR","BildR", "Geschlecht", "Frequenz","Farbe","Organ","Meridian","Hormondruesen","Vokal","Notiz")
	Main.ColDataTypes = Array As String("INT","TEXT","TEXT","TEXT","TEXT","TEXT","TEXT","Real","TEXT","TEXT","TEXT","TEXT","TEXT","Notiz")
End Sub
Sub StrukturHD
	Main.DBName = "HD"
	Main.TotColNumber=6
	Main.FrozenCols=1
	Main.ColNames = Array As String("IdUser","IdTor","Linie","IdSab","IdPlanet","RotSchwarz")
	Main.ColDataTypes =  Array As String("INT","INT","INT","INT","INT","TEXT")
End Sub
Sub StrukturSabischeSymbole
	Main.DBName = "SabischeSymbole"
	Main.TotColNumber=2
	Main.FrozenCols=1
	Main.ColNames = Array As String("IdSab","Beschreibung")
	Main.ColDataTypes = Array As String("INT","TEXT")
End Sub

'Ersetzt die Datenbank durch die Version vom Server /heilseminare.com/meditationen/db/heilsystem"SPRACHE".db
'Tabellen HD und Benutzer werden nicht verändert
'Sub DBServer
'	#if b4a
'		If Sammlung.CheckNetConnections = False Then
'			Dim sf As Object = xui.Msgbox2Async(translate(Main.sprache,76), "Check Internet", "Ok, Internet is on", "Cancel", "", Null)
'			Wait For (sf) Msgbox_Result (Result As Int)
'			If Result <> xui.DialogResponse_Positive Then Return
'		End If
'	#end if
'	Dim sf As Object = xui.Msgbox2Async("Datenbank werden von heilseminare.com geladen!", "Neue Datenbank laden","Ok", "", "Nein, zurück", Null)
'	Wait For (sf) Msgbox_Result (Result As Int)
'	If Result <> xui.DialogResponse_Positive Then Return
'	'Datenbank vom Server laden
'	wait for (datenbankLaden(dbname)) Complete (Success As Boolean)
'	If Success = True Then
'		B4XPage_Appear
'	Else
'		Dim sf As Object = xui.Msgbox2Async("database download failed!", "error","Ok, i will try again", "", "", Null)
'		Wait For (sf) Msgbox_Result (Result As Int)
'	End If
'End Sub

'Wählt eine Person aus dem angezeigten Dialog aus
Sub PersonLaden
	AuswahlPersonen.Initialize
	Dim Items As List
	Items.Initialize
	Dim Query As String = "SELECT Name,Vorname from Benutzer"
	Dim rs As ResultSet = Main.sql.ExecQuery(Query)
	Do While rs.NextRow
		Items.Add(rs.getstring("Vorname") & " " & rs.getstring("Name"))
	Loop
	rs.close
	AuswahlPersonen.SetItems(Items)
	dlg.BackgroundColor = xui.Color_White'0xFFFAEBD7
	dlg.BorderCornersRadius=5
	dlg.ButtonsColor = xui.Color_white
	dlg.BorderColor = 0xFFFF69B4
	dlg.ButtonsTextColor = 0xFFFF69B4
	
	Dim TextColor As Int = 0xFFFF69B4
	AuswahlPersonen.SearchField.TextField.TextColor = xui.Color_Gray
	'AuswahlPersonen.SearchField.HintColor = xui.Color_Gray
	'AuswahlPersonen.SearchField.HintText = "Suche"
	AuswahlPersonen.SearchField.NonFocusedHintColor = TextColor
	AuswahlPersonen.CustomListView1.sv.ScrollViewInnerPanel.Color = 0xFFDFDFDF 'grauer Rand zwischen Einträgen
	AuswahlPersonen.CustomListView1.sv.Color = dlg.BackgroundColor
	AuswahlPersonen.CustomListView1.DefaultTextBackgroundColor = xui.Color_White
	AuswahlPersonen.CustomListView1.DefaultTextColor = TextColor
	AuswahlPersonen.SearchField.mBase.color = xui.Color_White
	'----
	Wait For (dlg.ShowTemplate(AuswahlPersonen, "", "", "Zurück")) Complete (Result As Int)
	
	If Result = xui.DialogResponse_Positive Then ' Bei Auswahl wird dieses Ergebnis aktiviert
		Dim zeile As String = AuswahlPersonen.SelectedItem 'Format: Vorname,Nachname
		Dim Query As String = "SELECT IdName from Benutzer where Name='" & zeile.SubString(zeile.IndexOf(" ")+1) &"' and Vorname ='"& zeile.SubString2(0,zeile.IndexOf(" ")) &"'"
		iduser = Main.sql.ExecQuerySingleResult(Query)
		'Schönere Alternative, die leider bei Android Probleme macht mit CAST- Conversion Object cannot be String
		'Dim Query As String = "Select distinct IdName from Benutzer where Name=? and Vorname=?"
		'Dim name As String = zeile.SubString(zeile.IndexOf(" ")+1)
		'Dim vorname As String = zeile.SubString2(0,zeile.IndexOf(" "))
		'iduser = Main.sql.ExecQuerySingleResult2(Query,Array As Object(name,vorname))
		'IdName für Auswertungen wieder eintragen
	End If
	If Result = xui.DialogResponse_cancel Then 'Zurück ohne Änderung
		'Es kann sein, dass Benutzer gerade vorher gelöscht wurde, daher überprüfen und beenden, falls Nutzer nicht vorhanden ist.
		Dim Query As String = "Select count(*) from Benutzer where IdName=" & iduser
		Dim anz As Int = Main.sql.ExecQuerySingleResult(Query)
		If anz = 0 Then 'Benutzer wurde vorher gelöscht
			B4XPages.ClosePage(Me)
		Else
			Return
		End If
	End If
	Dim Query As String = "UPDATE _variablen SET Wert =" & iduser & " where Name = 'IdUser'"
	Main.sql.ExecNonQuery(Query)
	'ausgewählten Namen bzw. dessen ID speichern
	kvs.Put("iduser",iduser)
	B4XPage_Appear
End Sub

Sub lblGeburtsdatum_Click
	'Gibt das Designdatum aus, das im Tag gespeichert ist und Designzeit von lblZeit.tag
	Dim sf As Object = xui.MsgboxAsync(lblGeburtsdatum.Tag & ", "&lblZeit.tag, translate(Main.sprache,99))
	Wait For (sf) Msgbox_Result (Result As Int)
End Sub

'Aktualisiert die Feldinhalte und Bilder der Mainpage
Sub AktualisiereHauptseite(id As Int)
	Dim Query As String = "SELECT * from Benutzer where IdName=" & id
	Dim rs As ResultSet = Main.sql.ExecQuery(Query)
	Do While rs.NextRow
		lblPerson.Text = rs.getstring("Vorname") & " " & rs.getstring("Name")
		#if b4j
		lblEmail.text = rs.getstring("Email")
		#end if
		lblGeburtsdatum.Text = rs.GetString("Geburtsdatum")
		lblZeit.Text=rs.GetString("Geburtszeit")
		Dim inp As Object = rs.GetString("Designdatum") 'in TAG
		If inp = Null Then
			lblGeburtsdatum.tag = ""
		Else
			lblGeburtsdatum.tag = inp
		End If
		Dim inp As Object = rs.GetString("Designuhrzeit") 'in TAG
		If inp = Null Then 
			lblZeit.Tag = "" 
		Else
			lblZeit.Tag = inp
		End If
		
		Try 
			lblHDAutoritaet.Text = rs.GetString("Autoritaet")
			lblProfil.text = rs.GetString("Profil")
			lblHDTyp.Text = rs.GetString("HDTyp")
			lblKognition.Text = rs.GetString("Kognition")
			lblMotivation.Text = rs.GetString("Motivation")
			lblSzene.Text= rs.GetString("Szene")
			lblInKreuz.text = rs.GetString("HDInkarnationskreuz")
			lblNumWeg.Text = rs.GetInt("NumWeg")
			lblErnaehrung.Text = rs.GetString("HDErnaehrung")
		Catch
			Log("Null- Werte bei Benutzer")
		End Try
	Loop
	rs.close
End Sub

#if b4a
Sub lmondin_click
	pmondin_click
End Sub
#End If

#if B4j 
  Sub pmondin_MouseClicked (EventData As MouseEvent)
#Else
Sub pmondin_click
#End If
	consumeClick=True			'damit darunterliegendes Panel nicht triggert
	
	Dim idt As Int = lmondinTor.Text
	Dim idn As String = lmondinTor.Tag 'Name des Tors
	Dim idl As Int = lmondinLinie.Text
	
	Dim anzeigekopf As String = "Mond in "&aktuellerMondIn&CRLF&"Tor "&idt& "-"&idn &CRLF&CRLF
		
	Dim Query As String = "Select distinct TorBeschreibung from Hexagramme where IdTor=" & idt
	Dim res As String = Main.SQL.ExecQuerySingleResult(Query)
	Dim anzeigetext As String = res & CRLF
	Dim anzeige1kopf As String  = "Linie "&idl&CRLF
	Dim Query As String = "Select distinct Bedeutung from HDLinien where IdTor=" & idt & " and Linie=" & idl
	Dim res As String = Main.SQL.ExecQuerySingleResult(Query)
	Dim anzeige1text As String = res & CRLF
	
	#if b4j
		Dim cs As StringBuilder
		cs.Initialize
		cs.Append(anzeigekopf).append(anzeigetext).Append(anzeige1kopf).append(anzeige1text)
		DetailinformationZeigen(cs.ToString)
	#else
		Dim cs As CSBuilder
		cs.Initialize.Typeface(Typeface.DEFAULT_BOLD).underline.Append(anzeigekopf).pop.Typeface(Typeface.DEFAULT).append(anzeigetext).Typeface(Typeface.DEFAULT_BOLD).underline.Append(anzeige1kopf).pop.Typeface(Typeface.DEFAULT).append(anzeige1text).PopAll
		DetailinformationZeigen(cs)
	#end if
	
End Sub


#if B4j 
  Sub lblNumWeg_MouseClicked (EventData As MouseEvent)
#Else
	Sub lblNumWeg_click
#End If
	Dim Query As String = "Select distinct BeschreibungNumWeg from NumWeg where NumWeg='" & lblNumWeg.Text & "'"
	Dim res As String =  Main.sql.ExecQuerySingleResult(Query)
	#if b4j
		Dim cs As StringBuilder
		Dim neuezeile As String = CRLF
		cs.Initialize
		cs.append("Num. Weg:").Append(lblNumWeg.text).append(neuezeile).append(res)
		DetailinformationZeigen(cs.ToString)
	#else
		Dim cs As CSBuilder
		Dim neuezeile As String = CRLF
		cs.Initialize.Typeface(Typeface.DEFAULT_BOLD).underline.append("Num. Weg:").Append(lblNumWeg.text).pop.Typeface(Typeface.DEFAULT).append(neuezeile).append(res).append(neuezeile).PopAll
		DetailinformationZeigen(cs)
	#end if
	
End Sub

#if B4j 
	Sub lblHDTyp_MouseClicked (EventData As MouseEvent)
#Else
	Sub lblHDTyp_Click
#End If
	Dim Query As String = "Select distinct BeschreibungHDTyp from HDTyp where HDTyp='" & lblHDTyp.Text & "'"
	Dim res As String =  Main.sql.ExecQuerySingleResult(Query)
	
	#if b4j
		Dim cs As StringBuilder
		Dim neuezeile As String = CRLF
		cs.Initialize
		cs.append("Typ: ").Append(lblHDTyp.text).append(neuezeile).append(res)
		DetailinformationZeigen(cs.ToString)
	#else
		Dim cs As CSBuilder
		Dim neuezeile As String = CRLF
		cs.Initialize.Typeface(Typeface.DEFAULT_BOLD).underline.append("Typ: ").Append(lblHDTyp.text).pop.Typeface(Typeface.DEFAULT).append(neuezeile).append(res).append(neuezeile).PopAll
		DetailinformationZeigen(cs)
	#end if

End Sub

#if b4j
	Sub  lblHDAutoritaet_MouseClicked (EventData As MouseEvent)
#else
  Sub lblHDAutoritaet_click
#end if
	Dim Query As String = "Select distinct BeschreibungAutoritaet from HDAutoritaet where Autoritaet='" & lblHDAutoritaet.Text & "'"
	Dim res As String =  Main.sql.ExecQuerySingleResult(Query)
	#if b4j
		Dim cs As StringBuilder
		Dim neuezeile As String = CRLF
		cs.Initialize
		cs.append("Autorität: ").Append(lblHDAutoritaet.text).append(neuezeile).append(res)
		DetailinformationZeigen(cs.ToString)
	#else
		Dim cs As CSBuilder
		Dim neuezeile As String = CRLF
		cs.Initialize.Typeface(Typeface.DEFAULT_BOLD).underline.append("Autorität: ").Append(lblHDAutoritaet.text).pop.Typeface(Typeface.DEFAULT).append(neuezeile).append(res).append(neuezeile).PopAll
		DetailinformationZeigen(cs)
	#end if

End Sub


#if b4j
	Sub  lblProfil_MouseClicked (EventData As MouseEvent)
#else
  Sub lblProfil_click
#end if
	Dim Query As String = "Select distinct BeschreibungProfil from HDProfil where Profil='" & lblProfil.Text & "'"
	Dim res As String =  Main.sql.ExecQuerySingleResult(Query)
	#if b4j
		Dim cs As StringBuilder
		Dim neuezeile As String = CRLF
		cs.Initialize
		cs.append("Profil: ").Append(lblProfil.text).append(neuezeile).append(res)
		DetailinformationZeigen(cs.ToString)
	#else
		Dim cs As CSBuilder
		Dim neuezeile As String = CRLF
		cs.Initialize.Typeface(Typeface.DEFAULT_BOLD).underline.append("Profil: ").Append(lblProfil.text).pop.Typeface(Typeface.DEFAULT).append(neuezeile).append(res).append(neuezeile).PopAll
		DetailinformationZeigen(cs)
	#end if
	
End Sub

#if b4j
	Sub  lblSzene_MouseClicked (EventData As MouseEvent)
#else
  Sub lblSzene_click
#end if
	Dim Query As String = "Select distinct BeschreibungSzene from Szene where Szene='" & lblSzene.Text & "'"
	Dim res As String =  Main.sql.ExecQuerySingleResult(Query)
	
	#if b4j
		Dim cs As StringBuilder
		Dim neuezeile As String = CRLF
		cs.Initialize
		cs.append("Szene: ").Append(lblSzene.text).append(neuezeile).append(res)
		DetailinformationZeigen(cs.ToString)
	#else
		Dim cs As CSBuilder
		Dim neuezeile As String = CRLF
		cs.Initialize.Typeface(Typeface.DEFAULT_BOLD).underline.append("Szene: ").Append(lblSzene.text).pop.Typeface(Typeface.DEFAULT).append(neuezeile).append(res).append(neuezeile).PopAll
		DetailinformationZeigen(cs)
	#end if


End Sub

#if b4j
Sub  lblMotivation_MouseClicked (EventData As MouseEvent)
#else
  Sub lblMotivation_click
#end if
	Dim Query As String = "Select distinct BeschreibungMotivation from Motivation where Motivation='" & lblMotivation.Text & "'"
	Dim res As String =  Main.sql.ExecQuerySingleResult(Query)
	
	#if b4j
		Dim cs As StringBuilder
		Dim neuezeile As String = CRLF
		cs.Initialize
		cs.append("Motivation: ").Append(lblMotivation.text).append(neuezeile).append(res)
		DetailinformationZeigen(cs.ToString)
	#else
		Dim cs As CSBuilder
		Dim neuezeile As String = CRLF
		cs.Initialize.Typeface(Typeface.DEFAULT_BOLD).underline.append("Motivation: ").Append(lblMotivation.text).pop.Typeface(Typeface.DEFAULT).append(neuezeile).append(res).append(neuezeile).PopAll
		DetailinformationZeigen(cs)
	#end if
	
End Sub

#if b4j
	Sub  lblKognition_MouseClicked (EventData As MouseEvent)
#else
  Sub lblKognition_click
#end if
	Dim Query As String = "Select distinct BeschreibungKognition from Kognition where Kognition='" & lblKognition.Text & "'"
	Dim res As String =  Main.sql.ExecQuerySingleResult(Query)
	#if b4j
		Dim cs As StringBuilder
		Dim neuezeile As String = CRLF
		cs.Initialize
		cs.append("Kognition: ").Append(lblKognition.text).append(neuezeile).append(res)
		DetailinformationZeigen(cs.ToString)
	#else
		Dim cs As CSBuilder
		Dim neuezeile As String = CRLF
		cs.Initialize.Typeface(Typeface.DEFAULT_BOLD).underline.append("Kognition: ").Append(lblKognition.text).pop.Typeface(Typeface.DEFAULT).append(neuezeile).append(res).append(neuezeile).PopAll
		DetailinformationZeigen(cs)
	#end if
	
End Sub

#if b4j
	Sub  lblErnaehrung_MouseClicked (EventData As MouseEvent)
#else
  Sub lblErnaehrung_Click
#end if
	Dim Query As String = "Select distinct BeschreibungErnaehrung from HDErnaehrung where HDErnaehrung='" & lblErnaehrung.Text & "'"
	Dim res As String =  Main.sql.ExecQuerySingleResult(Query)
	#if b4j
		Dim cs As StringBuilder
		Dim neuezeile As String = CRLF
		cs.Initialize
		cs.append("Ernährung: ").Append(lblErnaehrung.text).append(neuezeile).append(res)
		DetailinformationZeigen(cs.ToString)
	#else
		Dim cs As CSBuilder
		Dim neuezeile As String = CRLF
		cs.Initialize.Typeface(Typeface.DEFAULT_BOLD).underline.append("Ernährung: ").Append(lblErnaehrung.text).pop.Typeface(Typeface.DEFAULT).append(neuezeile).append(res).append(neuezeile).PopAll
		DetailinformationZeigen(cs)
	#end if
End Sub

#if b4j
Sub lblInKreuz_MouseClicked (EventData As MouseEvent)
#else
  Sub lblInKreuz_click
#end if
	#if user
		Return		'derzeit nicht 
	#End If
	If lblInKreuz.Text="" Then
		'Auswahlliste zeigen und auswählen lassen		
	Else
		Dim Query As String = "Select distinct InBezeichnung from InKreuz where InName='" & lblInKreuz.Text & "'"
		Dim res As String =  Main.sql.ExecQuerySingleResult(Query)
		#if b4j
			Dim cs As StringBuilder
			cs.Initialize
			cs.append("Lebensaufgabe: ").Append(lblInKreuz.Text).Append(CRLF).Append(res)
			DetailinformationZeigen(cs.ToString)
		#else
			Dim cs As CSBuilder
			Dim neuezeile As String = CRLF
			cs.Initialize.Typeface(Typeface.DEFAULT_BOLD).underline.append("Lebensaufgabe: ").Append(lblInKreuz.text).pop.Typeface(Typeface.DEFAULT).append(neuezeile).append(res).append(neuezeile).PopAll
			DetailinformationZeigen(cs)
		#end if
		
		
	End If
End Sub

#if b4j
	Sub DetailinformationZeigen(text As String)
#else
	Sub DetailinformationZeigen(text As CSBuilder)
#End If

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
	#if b4a
		longtext.Resize(0.8 * Root.Width, 0.8 * Root.Height)
	#else
		longtext.resize(0.5 * Root.Width, 0.5 * Root.Height)
	#end if
	Wait For (dlg.ShowTemplate(longtext, "", "", "OK")) Complete (Result As Int)
End Sub

#if b4j
Sub pbodygraphexakt_MouseClicked (EventData As MouseEvent)
	'Click führt bei Windows zu der Detailansicht
	#if b4j
		body_Click
	#End If
'	Dim xstr As String = NumberFormat2(EventData.x, 1, 1, 1, False)
'	Dim ystr As String = NumberFormat2(EventData.y, 1, 1, 1, False)
'	Log("X:"&xstr&","&"Y:"&ystr)
End Sub
#end if

'Sub fillSchattierung(schattierung() As Int, position As Int, farbe As Int) As Int()
'	schattierung(position) = farbe
'	Return schattierung
'End Sub

Sub Zeichenfarbe(rotschwarztransit As Char,sternzeichenfarben As Boolean,idstz As Int) As Int
	Dim farbe As Int
	
	If sternzeichenfarben Then 
		farbe = Main.farbe.get(idstz)
	Else
		If rotschwarztransit="s" Then farbe = xui.Color_Black
		If rotschwarztransit="t" Then farbe = xui.Color_blue
		If rotschwarztransit="r" Then farbe = Main.colrot
	End If
	
	Return farbe
End Sub
Sub zeichneBodyExakt(quelldatei As String,zieldatei As String, definierteZentren As statusZentren,auswahlIndex As Int)
	'auswahlIndex = aktueller Status von edtbody.selectedindex oder fester Wert, falls bestimmtes Ergebnis erzielt werden soll
	#if b4j
		Dim bmp As B4XBitmap = xui.LoadBitmap("../files/", quelldatei) 'Aspect Ratio True, Bild sollte exakt diese Dimensionen haben
	#else
		Dim bmp As B4XBitmap = xui.LoadBitmap(File.dirassets, quelldatei) 'Aspect Ratio True, Bild sollte exakt diese Dimensionen haben
	#end if
	bc.Initialize(640,1031)
	
	bc.CopyPixelsFromBitmap(bmp)
	
	'Zeichne Aktive Tore
	Dim dicke As Int = 7
	Dim sternzeichenfarben As Boolean
	
	Select True
		Case auswahlIndex=0:
			Dim Query As String = "SELECT * from ToreUndDeutung where IdPlanet<>16 and (RotSchwarz='r' or RotSchwarz='s') order by IdTor asc"
			Dim Query1 As String = "SELECT count(*) from ToreUndDeutung where IdPlanet<>16 and (RotSchwarz='r' or RotSchwarz='s') and IdTor="
			Dim Query2 As String = "select RotSchwarz from ToreUndDeutung where IdPlanet<>16 and (RotSchwarz='r' or RotSchwarz='s') and IdTor="
		Case auswahlIndex=1:
			Dim Query As String = "SELECT * from ToreUndDeutung where IdPlanet<>16 and RotSchwarz='r' order by IdTor asc"
			Dim Query1 As String = "SELECT count(*) from ToreUndDeutung where IdPlanet<>16 and RotSchwarz='r' and IdTor="
			Dim Query2 As String = "SELECT RotSchwarz from ToreUndDeutung where IdPlanet<>16 and RotSchwarz='r' and IdTor="
			sternzeichenfarben = True
		Case auswahlIndex=2:
			Dim Query As String = "SELECT * from ToreUndDeutung where IdPlanet<>16 and RotSchwarz='s' order by IdTor asc"
			Dim Query1 As String = "SELECT count(*) from ToreUndDeutung where IdPlanet<>16 and RotSchwarz='s' and IdTor="
			Dim Query2 As String = "SELECT RotSchwarz from ToreUndDeutung where IdPlanet<>16 and RotSchwarz='s' and IdTor="
			sternzeichenfarben = True
		Case auswahlIndex=3:
			Dim Query As String = "SELECT * from ToreUndDeutung where IdPlanet<>16 and (RotSchwarz='r' or RotSchwarz='s') order by IdTor asc"
			Dim Query1 As String = "SELECT count(*) from ToreUndDeutung where IdPlanet<>16 and (RotSchwarz='r' or RotSchwarz='s') and IdTor="
			Dim Query2 As String = "select RotSchwarz from ToreUndDeutung where IdPlanet<>16 and (RotSchwarz='r' or RotSchwarz='s') and IdTor="
			sternzeichenfarben = True
		Case auswahlIndex=4:
			Dim Query As String = "SELECT * from ToreUndDeutung where IdPlanet<>16 order by IdTor asc"
			Dim Query1 As String = "SELECT count(*) from ToreUndDeutung where IdPlanet<>16 and IdTor="
			Dim Query2 As String = "SELECT RotSchwarz from ToreUndDeutung where IdPlanet<>16 and IdTor="
			'sternzeichenfarben = True
		Case auswahlIndex=5:
			Dim Query As String = "SELECT * from ToreUndDeutung where IdPlanet<>16 and RotSchwarz='t' order by IdTor asc"
			Dim Query1 As String = "SELECT count(*) from ToreUndDeutung where IdPlanet<>16 and RotSchwarz='t' and IdTor="
			Dim Query2 As String = "SELECT RotSchwarz from ToreUndDeutung where IdPlanet<>16 and RotSchwarz='t' and IdTor="

	End Select
	
	'Für Gradient
	Dim bc2 As BitmapCreator
'	Dim farbe As Int
	
	bc2.Initialize(dicke, bc.mHeight)
	
	'Alle Tore zeichnen ausser Chiron
	Dim toralt As Int
	Dim rs As ResultSet = Main.sql.ExecQuery(Query)
	Do While rs.NextRow
		'Sternzeichenfarbe bestimmen
		Dim idsab As Int = rs.GetInt("IdSab")
		Dim idstz As Int = Sammlung.convertiereSabSymbolinSternzeichen(idsab)
		Dim tor As Int = rs.GetInt("IdTor")
	
		Dim q1 As String =Query1 & tor
		Dim q2 As String =Query2 & tor
		If tor = toralt Then Continue   'Schraffierung wird einmal erstellt je Tor
		toralt = tor
		'Wie viele Einträge des Tores existieren ?
		Dim anz As Int = Main.SQL.ExecQuerySingleResult(q1)
		Dim rs2 As ResultSet = Main.SQL.ExecQuery(q2)
		If anz = 0 Then Continue			'Das Tor hat nicht den ausgewählten RotSchwarz - Wert
		If anz = 1 Then 'nur eine Farbe
			rs2.NextRow
			Dim keineSchattierung(2) As Int
			Dim rst As String = rs2.GetString("RotSchwarz")
			keineSchattierung(0) = Zeichenfarbe(rst,sternzeichenfarben,idstz)
			keineSchattierung(1) = Zeichenfarbe(rst,sternzeichenfarben,idstz)
			bc2.FillGradient(keineSchattierung,bc2.TargetRect,"RECTANGLE")
		Else 'alle Schattierungen befüllen
			'Wenn Tor mehrfach vorkommt, dann sollen Farbschattierungen gezeichnet werden
			Dim zeile As Int = 0

			Dim schattierung(anz) As Int
			Do While rs2.NextRow
				Dim rst As String = rs2.GetString("RotSchwarz")
				If rst = "t" Then
					schattierung(zeile) = Zeichenfarbe(rst,False,idstz) 'Transit immer Blau
				Else
					schattierung(zeile) = Zeichenfarbe(rst,sternzeichenfarben,idstz)
				End If
				zeile=zeile+1
			Loop
			bc2.FillGradient(schattierung, bc2.TargetRect,"RECTANGLE")
		End If
		
		Dim Brush2 As BCBrush = bc.CreateBrushFromBitmapCreator(bc2)
		Dim p As BCPath
		Dim rs1 As ResultSet =Main.sql.ExecQuery("Select * from bodyImageExakt where nr="&tor)
		rs1.NextRow	'ist nur ein Eintrag je Tor
		Dim x As Double = rs1.Getdouble("posX")
		Dim xto As Double = rs1.Getdouble("posXto")
		Dim y As Double = rs1.Getdouble("posY")
		Dim yto As Double = rs1.Getdouble("posYto")
			
		'Linie zeichnen
		p.Initialize(x,y).LineTo(xto,yto).LineTo(x,y)
		bc.DrawPath2(p,Brush2,False,dicke)
	Loop
	
	'Zeichne Zentren
	bc  = zeichneZentrenExakt(bc,edtBody.selectedindex,definierteZentren)
	
	'Abspeichern
	Dim b4xb As B4XBitmap = bc.bitmap
	Dim Out As OutputStream
	#if b4j
		Out = File.OpenOutput(File.DirData("heilsystem"), zieldatei, False)
	#else
		Out = File.OpenOutput(rp.GetSafeDirDefaultExternal(""), zieldatei, False)
	#end if
	b4xb.WriteToStream(Out, 100, "PNG")
	Out.Close
	
End Sub

#if b4a
'erstellt das Bodygraph
Sub zeichneBody(definierteZentren As statusZentren)
	If iduser=-1 Then Return
	'Dim bmp As B4XBitmap = xui.LoadBitmapResize(File.DirAssets, "bodygraph.png",320,320,True) 'Aspect Ratio True, Bild sollte exakt diese Dimensionen
	Dim bmp As B4XBitmap = xui.LoadBitmap(File.DirAssets, "bodygraph.png") 'Aspect Ratio True, Bild sollte exakt diese Dimensionen haben
	
	bc.Initialize(320,300)
	
	bc.CopyPixelsFromBitmap(bmp)
	
	'Zeichne Aktive Tore
	
	Dim Query As String = "SELECT * from ToreUndDeutung"
	
	Dim rs As ResultSet = Main.sql.ExecQuery(Query)
	Do While rs.NextRow
		If rs.GetInt("IdPlanet")=16 Then Continue 'Chiron nicht einzeichnen 
		Dim tor As Int = rs.GetInt("IdTor")
		If iduser <> 0 Then 
			Dim rotschwarz As Char = rs.GetString("RotSchwarz")
		End If

		If tor = 0 Then Continue  'Nicht definiert, dann Fehler, nächstes Tor
		'Dim rs1 As ResultSet =Main.sql.ExecQuery("Select * from bodyImage where ROWID="&tor) 'alte DB-Struktur
		Dim rs1 As ResultSet =Main.sql.ExecQuery("Select * from bodyImage where nr="&tor)
		Do While rs1.NextRow
			'evtl. hier skalieren
			Dim x As Int = rs1.GetInt("posX")
			Dim xto As Int = rs1.GetInt("posXto")
			Dim y As Int = rs1.GetInt("posY")
			Dim yto As Int = rs1.GetInt("posYto")
			Select True
				Case edtBody.SelectedIndex = 0:
				Dim rot As Int = Main.colrot
				If rotschwarz="r" Then bc.DrawLine(x,y,xto,yto,rot,3)
				If rotschwarz="s" Then bc.DrawLine(x,y,xto,yto,xui.Color_black,3)
				Case edtBody.SelectedIndex = 1:
					If rotschwarz="r" Then 
						Query = "Select IDSternzeichen from HDLinien where IdTor=" &tor & " and Linie = " & rs.GetInt("Linie")
						Dim idstz As Int = Main.sql.ExecQuerySingleResult(Query)
						bc.DrawLine(x,y,xto,yto,Main.farbe.Get(idstz),3)	
					End If
				Case edtBody.SelectedIndex = 2:
					If rotschwarz="s" Then
						Query = "Select IDSternzeichen from HDLinien where IdTor=" &tor & " and Linie = " & rs.GetInt("Linie")
						Dim idstz As Int = Main.sql.ExecQuerySingleResult(Query)
						bc.DrawLine(x,y,xto,yto,Main.farbe.Get(idstz),3)
						'bc.DrawLine(x,y,xto,yto,xui.Color_black,3)
					End If
				Case edtBody.SelectedIndex = 3:
					Query = "Select IDSternzeichen from HDLinien where IdTor=" &tor & " and Linie = " & rs.GetInt("Linie")
					Dim idstz As Int = Main.sql.ExecQuerySingleResult(Query)
					If rotschwarz="r" Or rotschwarz="s" Then bc.DrawLine(x,y,xto,yto,Main.farbe.Get(idstz),3)
					
				Case edtBody.SelectedIndex = 4: 'Transite mit anzeigen
					Query = "Select IDSternzeichen from HDLinien where IdTor=" &tor & " and Linie = " & rs.GetInt("Linie")
					Dim idstz As Int = Main.sql.ExecQuerySingleResult(Query)
					If rotschwarz="r" Or rotschwarz="s" Then bc.DrawLine(x,y,xto,yto,Main.farbe.Get(idstz),3)
					If rotschwarz = "t" Then bc.DrawLine(x,y,xto,yto,xui.Color_blue,3)
					
				Case edtBody.SelectedIndex = 5: 'Nur Transite anzeigen
					If rotschwarz = "t" Then bc.DrawLine(x,y,xto,yto,xui.Color_blue,3)
			End Select
		Loop
	Loop
	'Zeichne Zentren
	bc  = zeichneZentren(bc,edtBody.selectedindex,definierteZentren)
	
	
	' BC kann derzeit keinen Text zeichnen
	'https://www.b4x.com/android/forum/threads/bitmapcreator-text-and-textrotated.104425/#content

	body.Bitmap = bc.Bitmap
	
	Dim b4xb As B4XBitmap = bc.bitmap
	Dim Out As OutputStream
	#if b4j
		Out = File.OpenOutput(File.DirData("heilsystem"), "body.png", False)
	#else
		Out = File.OpenOutput(rp.GetSafeDirDefaultExternal(""), "body.png", False)
	#end if
	b4xb.WriteToStream(Out, 100, "PNG")
	Out.Close
	#if b4a
		If  screensize < 8 Then
			body.Bitmap=LoadBitmapResize(rp.GetSafeDirDefaultExternal(""),"body.png",640dip,640dip,True)
			myfont7 = CreateB4XFont("Opensans.ttf", 7, 7)
		Else
			myfont7 = CreateB4XFont("Opensans.ttf", 7, 7)
		End If
	#end if
End Sub
#end if

'Zeichnet die 9 Zentren in den exakten Bodygraph, der bei Click auf pbodytore erscheint
'Bei noHD = true werden die definierten Zentren in zentrenstatus übergeben.
'z.B. zentrenstatus.z1="j"
Sub zeichneZentrenExakt(bmc As BitmapCreator,auswahl As Int,zentrenstatus As statusZentren) As BitmapCreator
	
	'auswahl 0=Design&Persönlichkeit, 1=Nur Design, 2=Nur Persoenl., 3=D&P, 4=mit Transit, 5=nur Transit
	
	Dim noHD As Boolean
	If auswahl <> 0 And auswahl <> 3 Then noHD=True

	Dim brush As BCBrush
	Dim p As BCPath
	brush.Initialize
	'brush.BlendAll = True

	Dim Query As String = "SELECT * from Benutzer where IdName =" & iduser
	Dim rs As ResultSet = Main.sql.ExecQuery(Query)
	Do While rs.NextRow
		If noHD=False Then
			Dim z1 As Char= rs.Getstring("Z1")
		Else
			Dim z1 As Char= zentrenstatus.z1
		End If
		brush = bc.DrawLine(0,0,0,0,Main.colrot,0) 'Nur damit der Brush eine Farbe hat, weil ich nicht weiss, wie man sie sonst setzt
		p.Initialize(293,1007).LineTo(345,1007).LineTo(345,935).LineTo(293,935).lineto(293,1007)
		If z1 = "j" Then bmc.DrawPath2(p,brush,True,1) 
		If noHD=False Then
			Dim z2 As Char = rs.Getstring("Z2")
		Else
			Dim z2 As Char= zentrenstatus.z2
		End If
		brush = bc.DrawLine(0,0,0,0,Main.colZentrum2,0) 'Nur damit der Brush eine Farbe hat, weil ich nicht weiss, wie man sie sonst setzt
		p.Initialize(293,829).LineTo(347,829).LineTo(347,774).LineTo(293,774).LineTo(293,829)
		
		If z2 = "j" Then bmc.DrawPath2(p,brush,True,1) 
		If noHD=False Then
			Dim z3 As Char= rs.Getstring("Z3")
		Else
			Dim z3 As Char= zentrenstatus.z3
		End If
		brush = bc.DrawLine(0,0,0,0,Main.colzentrum3,0) 'Nur damit der Brush eine Farbe hat, weil ich nicht weiss, wie man sie sonst setzt
		p.Initialize(558,763).LineTo(616,797).LineTo(616,730)
		If z3 = "j" Then bmc.DrawPath2(p,brush,True,1) 
		If noHD=False Then
			Dim z4 As Char= rs.Getstring("Z4")
		Else
			Dim z4 As Char= zentrenstatus.z4
		End If
		brush = bc.DrawLine(0,0,0,0,Main.colzentrum4,0) 'Nur damit der Brush eine Farbe hat, weil ich nicht weiss, wie man sie sonst setzt
		p.Initialize(420,652).LineTo(470,652).LineTo(445,624).LineTo(420,652)
		
		If z4 = "j" Then bmc.DrawPath2(p,brush,True,1) 
		If noHD=False Then
			Dim z5 As Char= rs.Getstring("Z5")
		Else
			Dim z5 As Char= zentrenstatus.z5
		End If
		brush = bc.DrawLine(0,0,0,0,Main.colZentrum5,0) 'Nur damit der Brush eine Farbe hat, weil ich nicht weiss, wie man sie sonst setzt
		p.Initialize(288,411).LineTo(341,411).LineTo(341,354).LineTo(288,354).LineTo(288,411)
		
		If z5 = "j" Then bmc.DrawPath2(p,brush,True,1) 
		If noHD=False Then
			Dim z6 As Char= rs.Getstring("Z6")
		Else
			Dim z6 As Char= zentrenstatus.z6
		End If
		brush = bc.DrawLine(0,0,0,0,Main.colZentrum6,0) 'Nur damit der Brush eine Farbe hat, weil ich nicht weiss, wie man sie sonst setzt
		p.Initialize(310,226).LineTo(290,196).LineTo(330,196).LineTo(310,226)
		
		If z6 = "j" Then bmc.DrawPath2(p,brush,True,1) 
		If noHD=False Then
			Dim z7 As Char= rs.Getstring("Z7")
		Else
			Dim z7 As Char= zentrenstatus.z7
		End If
		brush = bc.DrawLine(0,0,0,0,Main.colZentrum7,0) 'Nur damit der Brush eine Farbe hat, weil ich nicht weiss, wie man sie sonst setzt
		p.Initialize(275,107).LineTo(345,107).LineTo(310,47).LineTo(275,107)
		If z7 = "j" Then bmc.DrawPath2(p,brush,True,1) 
		If noHD=False Then
			Dim z8 As Char= rs.Getstring("Z8")
		Else
			Dim z8 As Char= zentrenstatus.z8
		End If
		brush = bc.DrawLine(0,0,0,0,Main.colZentrum8,0) 'Nur damit der Brush eine Farbe hat, weil ich nicht weiss, wie man sie sonst setzt
		p.Initialize(32,784).LineTo(32,737).LineTo(75,760).LineTo(32,784)
		If z8 = "j" Then bmc.DrawPath2(p,brush,True,1) 
		If noHD=False Then
			Dim z9 As Char= rs.Getstring("Z9")
		Else
			Dim z9 As Char= zentrenstatus.z9
		End If
		brush = bc.DrawLine(0,0,0,0,Main.colZentrum9,0) 'Nur damit der Brush eine Farbe hat, weil ich nicht weiss, wie man sie sonst setzt
		p.Initialize(319,605).LineTo(284,570).LineTo(319,535).LineTo(354,570).LineTo(319,605)
		If z9 = "j" Then bmc.DrawPath2(p,brush,True,1) 
	Loop
	Return bmc
End Sub

#if b4a
'Zeichnet die 9 Zentren in den einfachen Bodygraph
'Bei noHD = true werden die definierten Zentren in zentrenstatus übergeben.
'z.B. zentrenstatus.z1="j"
Sub zeichneZentren (bmc As BitmapCreator,auswahl As Int,zentrenstatus As statusZentren) As BitmapCreator
	
	'auswahl 0=Design&Persönlichkeit, 1=Nur Design, 2=Nur Persoenl., 3=D&P, 4=mit Transit, 5=nur Transit
	
	Dim noHD As Boolean
	If auswahl <> 0 And auswahl<> 3 Then noHD=True

	Dim brush As BCBrush
	Dim p As BCPath
	brush.Initialize
	'brush.BlendAll = True
	Dim Query As String = "SELECT * from Benutzer where IdName =" & iduser
	Dim rs As ResultSet = Main.sql.ExecQuery(Query)
	Do While rs.NextRow
		If noHD=False Then
			Dim z1 As Char= rs.Getstring("Z1")
		Else
			Dim z1 As Char= zentrenstatus.z1
		End If
		brush = bc.DrawLine(0,0,0,0,Main.colrot,0) 'Nur damit der Brush eine Farbe hat, weil ich nicht weiss, wie man sie sonst setzt
		p.Initialize(146,282).LineTo(173,282).LineTo(173,257).LineTo(146,257).lineto(146,282)
		If z1 = "j" Then bmc.DrawPath2(p,brush,True,1) Else bmc.DrawPath2(p,brush,False,1)
		If noHD=False Then
			Dim z2 As Char = rs.Getstring("Z2")
		Else
			Dim z2 As Char= zentrenstatus.z2
		End If
		brush = bc.DrawLine(0,0,0,0,Main.colZentrum2,0) 'Nur damit der Brush eine Farbe hat, weil ich nicht weiss, wie man sie sonst setzt
		p.Initialize(146,237)
		p.LineTo(173,237)
		p.LineTo(173,210)
		p.LineTo(146,210)
		p.lineto(146,236)
		If z2 = "j" Then bmc.DrawPath2(p,brush,True,1) Else bmc.DrawPath2(p,brush,False,1)
		If noHD=False Then
			Dim z3 As Char= rs.Getstring("Z3")
		Else
			Dim z3 As Char= zentrenstatus.z3
		End If
		brush = bc.DrawLine(0,0,0,0,Main.colzentrum3,0) 'Nur damit der Brush eine Farbe hat, weil ich nicht weiss, wie man sie sonst setzt
		p.Initialize(217,206)
		p.LineTo(246,222)
		p.LineTo(246,190)
		p.LineTo(217,206)
		If z3 = "j" Then bmc.DrawPath2(p,brush,True,1) Else bmc.DrawPath2(p,brush,False,1)
		If noHD=False Then
			Dim z4 As Char= rs.Getstring("Z4")
		Else
			Dim z4 As Char= zentrenstatus.z4
		End If
		brush = bc.DrawLine(0,0,0,0,Main.colzentrum4,0) 'Nur damit der Brush eine Farbe hat, weil ich nicht weiss, wie man sie sonst setzt
		p.Initialize(173,172)
		p.LineTo(206,174)
		p.LineTo(187,158)
		p.LineTo(173,172)
		If z4 = "j" Then bmc.DrawPath2(p,brush,True,1) Else bmc.DrawPath2(p,brush,False,1)
		If noHD=False Then
			Dim z5 As Char= rs.Getstring("Z5")
		Else
			Dim z5 As Char= zentrenstatus.z5
		End If
		brush = bc.DrawLine(0,0,0,0,Main.colZentrum5,0) 'Nur damit der Brush eine Farbe hat, weil ich nicht weiss, wie man sie sonst setzt
		p.Initialize(146,113)
		p.LineTo(173,113)
		p.LineTo(173,86)
		p.LineTo(146,86)
		p.LineTo(146,113)
		If z5 = "j" Then bmc.DrawPath2(p,brush,True,1) Else bmc.DrawPath2(p,brush,False,1)
		If noHD=False Then
			Dim z6 As Char= rs.Getstring("Z6")
		Else
			Dim z6 As Char= zentrenstatus.z6
		End If
		brush = bc.DrawLine(0,0,0,0,Main.colZentrum6,0) 'Nur damit der Brush eine Farbe hat, weil ich nicht weiss, wie man sie sonst setzt
		p.Initialize(159,79)
		p.LineTo(175,54)
		p.LineTo(142,54)
		p.LineTo(159,79)
		If z6 = "j" Then bmc.DrawPath2(p,brush,True,1) Else bmc.DrawPath2(p,brush,False,1)
		If noHD=False Then
			Dim z7 As Char= rs.Getstring("Z7")
		Else
			Dim z7 As Char= zentrenstatus.z7
		End If
		brush = bc.DrawLine(0,0,0,0,Main.colZentrum7,0) 'Nur damit der Brush eine Farbe hat, weil ich nicht weiss, wie man sie sonst setzt
		p.Initialize(142,45)
		p.LineTo(175,45)
		p.LineTo(160,19)
		p.LineTo(142,45)
		If z7 = "j" Then bmc.DrawPath2(p,brush,True,1) Else bmc.DrawPath2(p,brush,False,1)
		If noHD=False Then
			Dim z8 As Char= rs.Getstring("Z8")
		Else
			Dim z8 As Char= zentrenstatus.z8
		End If
		brush = bc.DrawLine(0,0,0,0,Main.colZentrum8,0) 'Nur damit der Brush eine Farbe hat, weil ich nicht weiss, wie man sie sonst setzt
		p.Initialize(74,222)
		p.LineTo(102,206)
		p.LineTo(74,191)
		p.LineTo(74,222)
		If z8 = "j" Then bmc.DrawPath2(p,brush,True,1) Else bmc.DrawPath2(p,brush,False,1)
		If noHD=False Then
			Dim z9 As Char= rs.Getstring("Z9")
		Else
			Dim z9 As Char= zentrenstatus.z9
		End If
		brush = bc.DrawLine(0,0,0,0,Main.colZentrum9,0) 'Nur damit der Brush eine Farbe hat, weil ich nicht weiss, wie man sie sonst setzt
		p.Initialize(159,166)
		p.LineTo(179,147)
		p.LineTo(159,132)
		p.LineTo(140,147)
		p.LineTo(159,165)
		If z9 = "j" Then bmc.DrawPath2(p,brush,True,1) Else bmc.DrawPath2(p,brush,False,1)
	Loop
	Return bmc
End Sub
#end if
Sub edtBody_SelectedIndexChanged (Index As Int)
	'Index=4 ist mit Transite, diese müssen erst anhand des aktuellen Datums berechnet werden und bei 
	'der ausgewählten Person in der HD- Tabelle mit rotschwarz="t" ersetzt oder falls nicht vorhanden hinzugefügt werden
	kvs.Put("edtbody",Index)
	B4XPage_Appear
End Sub


Sub deleteandaddtransitefuerAktuellePerson
	'iduser enthält die aktuell ausgewählte Person
	'mit aktuellem Datum und Uhrzeit die Planetenpositionen bestimmen
	'Evtl. bereits gespeicherte Transite dieser Person löschen
	'aktuell beleuchtete Tore, Linien und Planeten in HD mit RotSchwarz="t" abspeichern
	
	Private tod As Double
	Private swed As SweDate
	Private jdp As Double
	Private transit(12) As Double
	Private transitWerte(14) As Planetwerte
	Private indextransitWerte As Int
	Private planetText() As String
	'aktuelle Uhrzeit ermitteln
	DateTime.DateFormat="dd.MM.yyyy"
	DateTime.TimeFormat="HH:mm"
	Dim t As String=DateTime.Date(DateTime.Now)
	Dim z As String = DateTime.Time(DateTime.Now)

	
	#if b4j
		Dim ephepath As String = File.DirData("heilsystem")
		If File.Exists(ephepath,"seas_18.se1") = False Then
			File.Copy(File.DirAssets,"seas_18.se1",ephepath,"seas_18.se1")
			swe1.swe_set_ephe_path(ephepath)
		End If
	#else
		If File.exists(File.DirInternal,"seas_18.se1")=False Then
			File.Copy(File.DirAssets,"seas_18.se1",File.DirInternal,"seas_18.se1")
			swe1.swe_set_ephe_path(File.DirInternal)
		End If
	#End If
	
	
	If iduser=-1 Then Return 'Solagen kein Nutzer ausgewählt ist, bleibt er auf -1
	'immer Transitwerte dieser Person in HD loeschen
	Main.sql.ExecNonQuery("delete from HD where IdUser="&iduser&" and RotSchwarz='t'")
	planetText = Array As String(translate(Main.sprache,200),translate(Main.sprache,202),translate(Main.sprache,203),translate(Main.sprache,205),translate(Main.sprache,206),translate(Main.sprache,207),translate(Main.sprache,208),translate(Main.sprache,209),translate(Main.sprache,210),translate(Main.sprache,211),translate(Main.sprache,212),translate(Main.sprache,83)) 'Sonne","Mond","Auf Mondk.","Merkur","Venus","Mars","Jupiter","Saturn","Uranus","Neptun","Pluto","Chiron"

	'Die 13 Planetenwerte für die aktuelle Zeit ermitteln
	Dim h As Int = z.substring2(0,2)
	Dim m As Int = z.substring2(3,5)
	Dim dd As Int = t.substring2(0,2)
	Dim mm As Int = t.substring2(3,5)
	Dim yy As Int = t.substring2(6,10)
	tod = h + m / 60
	'Log("Aktueller Zeitpunkt: " & t &", "& z)

	'Julian date Persönlichkeit bzw. Universal Time ermitteln
	jdp = swed.getJulDay(yy, mm, dd, tod)
	Dim tzd As Double = DateTime.TimeZoneOffset 'entspricht nur der aktuellen Zeitzone des Endgerätes, daher unbrauchbar für uns
	'Timezone Offset abziehen
	jdp=jdp-(tzd/24)
	
	indextransitWerte=0
	For i = 0 To 11 'mit Chiron 12 Planetenpositionen zu ermitteln und Sonne und N-Knoten werden hier errechnet
		Dim pw As Planetwerte
		Dim ir As Int = PersonNeu1.hdplanetReihenfolge(i)
		transit(i) = PersonNeu1.Get_1_Planet(jdp, ir)
		pw.Initialize
		pw=PersonNeu1.ermittleHDTor(transit(i),0,planetText(i))
		'Planetwert in Liste speichern
		transitWerte(indextransitWerte).eTorS = pw.ETorS
		transitWerte(indextransitWerte).ElineS = pw.ElineS
		transitWerte(indextransitWerte).planet = pw.planet
		transitWerte(indextransitWerte).sabS = pw.sabS
		Select True
			Case PersonNeu1.planetEph(ir) = "Sonne":'Erde 180 Grad
				pw = PersonNeu1.ermittleHDTor(transit(i)+180,0,translate(Main.sprache,201)) 'Erde
				indextransitWerte=indextransitWerte+1
				transitWerte(indextransitWerte).eTorS = pw.ETorS
				transitWerte(indextransitWerte).ElineS = pw.ElineS
				transitWerte(indextransitWerte).planet = pw.planet
				transitWerte(indextransitWerte).sabS = pw.sabS
			Case PersonNeu1.planetEph(ir) = "N-Knoten": 'S-Knoten 180 Grad
				pw = PersonNeu1.ermittleHDTor(transit(i)+180,0,translate(Main.sprache,204)) 'S-Knoten ist absteigender Mondknoten
				indextransitWerte=indextransitWerte+1
				transitWerte(indextransitWerte).eTorS = pw.ETorS
				transitWerte(indextransitWerte).ElineS = pw.ElineS
				transitWerte(indextransitWerte).planet = pw.planet
				transitWerte(indextransitWerte).sabS = pw.sabS
		End Select
		indextransitWerte=indextransitWerte+1
	Next
	 
	Dim anz As Int = transitWerte.Length - 1
	'dann die 14 Planetenwerte in HD anhaengen 'incl. Chiron
	For i = 0 To  anz
		Dim ftt,flt,fs As Int
		
		If IsNumber(transitWerte(i).eTorS) Then ftt = transitWerte(i).eTorS Else ftt = 0
		If IsNumber(transitWerte(i).ElineS) Then flt = transitWerte(i).ElineS Else flt = 0
		If IsNumber(transitWerte(i).sabS) Then fs = transitWerte(i).sabS Else fs = 1
		Dim sb As StringBuilder
		sb.Initialize
		sb.Append("INSERT INTO HD (IdUser,IdTor,Linie,IdSab,IdPlanet,RotSchwarz)")
		sb.Append(" VALUES (").Append(iduser).append(",").append(ftt).append(",").append(flt).append(",").append(fs).append(",")
		sb.append(PersonNeu1.planet(i)).Append(",'t')")
		Main.sql.ExecNonQuery(sb.ToString)
	Next
	swe1.swe_close
	
End Sub



Sub SternzeichenPanelVordergrund
	#if b4a
	s1.BringToFront
	's1.Color=xui.Color_Transparent
	s2.BringToFront
	s3.BringToFront
	s3a.BringToFront
	s4.BringToFront
	s5.BringToFront
	s6.BringToFront
	s7.BringToFront
	s8.BringToFront
	s9.BringToFront
	s9a.BringToFront
	s10.BringToFront
	s10a.BringToFront
	s11.BringToFront
	s11a.BringToFront
	s12.BringToFront
	s12a.BringToFront
	#end if
End Sub

'Click auf ein Sternzeichen im pstartbild-Panel
#if b4j
Sub sternzeichen_MouseClicked (EventData As MouseEvent)
#else
	Sub sternzeichen_Click
#end if
	'Probleme stammen nur vom EGO, daher bei edtbody="Nur Design" kein Ergebnis
	If edtBody.SelectedIndex = 1 Or edtBody.SelectedIndex= 5 Then edtBody.SelectedIndex=4 'nur möglich bei Persönlichkeit
	Dim o As B4XView = Sender
	Dim t As Int = o.tag
	idsternzeichen = t
	B4XPages.ShowPage("clvWichtig")
End Sub


'Private Sub Strategie_Click
'	B4XPages.ShowPage("clvZentren")
'End Sub

Private Sub FormatLinientext_Click
	Dim res As ResultSet = Main.SQL.ExecQuery("Select Bedeutung from HDLinien")
	Dim neu As String
	Dim alt As String
	Do While res.NextRow
		alt = res.GetString("Bedeutung")
		If alt.Contains("▲") Then
				neu = alt.SubString2(0,alt.IndexOf("▲")) & CRLF & alt.SubString(alt.IndexOf("▲"))
				If neu.Contains("▼") Then neu = neu.SubString2(0,alt.IndexOf("▼")) & CRLF & neu.SubString(alt.IndexOf("▼")+1)
		Else
			If alt.Contains("▼") Then neu = neu.SubString2(0,alt.IndexOf("▼")) & CRLF & neu.SubString(alt.IndexOf("▼")+1)
		End If
	Loop
	res.Close
End Sub


private Sub Einstellungen
	settingsDialog.Dialog.ButtonsTextColor = xui.Color_DarkGray
	settingsDialog.Dialog.OverlayColor = xui.Color_White
	
	Wait For (settingsDialog.ShowDialog(settings, "OK", "CANCEL")) Complete (Result As Int)
	If Result = xui.DialogResponse_Positive Then
		'abspeichern
		Dim ser As B4XSerializator
		File.WriteBytes(xui.DefaultFolder, settingsFile, ser.ConvertObjectToBytes(settings))
		'Sprache setzten, falls Sie geändert wurde
		Dim sprachealt As String = Main.sprache
		Main.sprache = settings.Get("sprache")
		If Main.sprache <> sprachealt Then
			'Nochmal
			Dim Query As String = "SELECT Name,Vorname from Benutzer where IdName="&iduser
			Dim rs As ResultSet = Main.sql.ExecQuery(Query)
			Dim vorname,nachname As String
			Do While rs.NextRow
				vorname = rs.getstring("Vorname")
				nachname = rs.getstring("Name")
			Loop
			'Neue Datenbank aktivieren
			dbname = "heilsystem"&Main.sprache&".db"
			reinitializeDatabase(dbname)
			'iduser kann sich geändert haben oder Nutzer ist gar nicht vorhanden
			iduser = checkiduser(vorname,nachname)
			'Menüeinträge neu erstellen wg. möglichem Sprachwechsel
			
			#if b4a
				B4XPages.GetManager.GetPageInfoFromRoot(Root).Parent.MenuItems.clear
				erstelleB4AMenu
			#end if
			B4XPage_Appear
		End If
	End If
End Sub

Sub reinitializeDatabase(dbbez As String)
	'schliesst aktuelle DB und oeffnet DB dbbez
	'Wenn dbbez sich nicht im Defaultfolder befindet, wird sie von Asset dorthin kopiert
	
	Main.SQL.Close
	If File.Exists(xui.DefaultFolder, dbbez) = False Then
		File.Copy(File.DirAssets, dbbez, xui.DefaultFolder, dbbez)
	End If
		#If b4j
			Main.SQL.InitializeSQLite(xui.DefaultFolder,dbbez, False)
		#Else
			Main.sql.Initialize(xui.DefaultFolder, dbbez, False)
		#end if
End Sub

Sub checkiduser(vorname As String, nachname As String) As Int
	'Prüfen, ob Benutzer in neuer DB existiert. Wenn ja dann IdName (Variable: iduser) zurückgeben. 
	'iduser = -1, wenn Vorname und Name in neuer DB nicht existieren
	If vorname = "" And nachname = "" Then Return -1
	Dim Query As String = "SELECT IdName from Benutzer where Name = '"& nachname &"' and Vorname = '"& vorname & "'"
	Dim idneu As Object = Main.sql.ExecQuerySingleResult(Query)
	If idneu = Null Then
		Return -1  'Beim Laden wird iduser danach in _variablen geschrieben
	Else
		Dim Query As String = "UPDATE _variablen SET Wert =" & iduser & " where Name = 'IdUser'"
		Main.sql.ExecNonQuery(Query)
		'ausgewählten Namen bzw. dessen ID speichern
		kvs.Put("iduser",iduser)
		Return idneu
	End If
End Sub

#if b4a
	Sub erstelleB4AMenu
		Private mi As B4AMenuItem 
		mi.AddToBar = True
		mi = B4XPages.AddMenuItem(Me,translate(Main.sprache,21))
		mi.Tag = "Einstellungen"
		mi = B4XPages.AddMenuItem(Me,translate(Main.sprache,22))
		mi.Tag = "Neu"
		
		#if user
			'Wenn mehr als ein Eintrag in Benutzer existiert, dann anzeigen
			Dim Query As String = "Select count(*) from Benutzer"
			Dim anz As Int =  Main.sql.ExecQuerySingleResult(Query)
			If anz > 1 Then
				mi = B4XPages.AddMenuItem(Me, translate(Main.sprache,24))
				mi.Tag = "Laden"
			End If
			mi = B4XPages.AddMenuItem(Me, translate(Main.sprache,122))
			mi.Tag = "freischaltcode"
			mi = B4XPages.AddMenuItem(Me, translate(Main.sprache,123))
			mi.Tag = "Beratung"
			mi = B4XPages.AddMenuItem(Me, translate(Main.sprache,124))
			mi.Tag = "Hilfe"
			'mi = B4XPages.AddMenuItem(Me, translate(Main.sprache,125))
			'mi.tag = "ReportZentren"
			'mi = B4XPages.AddMenuItem(Me, "Datenbank Update")
			'mi.Tag = "DBServer"		'in späterem Release
			Return						'Bei user hier zurück
		#end if
		mi = B4XPages.AddMenuItem(Me, translate(Main.sprache,24))
		mi.Tag = "Laden"
		mi = B4XPages.AddMenuItem(Me, translate(Main.sprache,120))
		mi.Tag = "Bearbeiten"
		mi = B4XPages.AddMenuItem(Me, translate(Main.sprache,121))
		mi.Tag = "Löschen"
		mi = B4XPages.AddMenuItem(Me, "Datenbank Senden/Empfangen")
		mi.Tag = "LadeDatenbank"
		mi = B4XPages.AddMenuItem(Me, "Aktivierte Kanäle")
		mi.Tag = "AktivierteKanäle"
		mi = B4XPages.AddMenuItem(Me, translate(Main.sprache,125))
		mi.tag = "ReportZentren"
		mi = B4XPages.AddMenuItem(Me, "Beschwerden")
		mi.Tag = "Beschwerden"
		mi = B4XPages.AddMenuItem(Me, "Elemente")
		mi.Tag = "Elemente"
		mi = B4XPages.AddMenuItem(Me, "Enneagramm")
		mi.Tag = "Enneagramm"
		mi = B4XPages.AddMenuItem(Me, "Gottheiten")
		mi.Tag = "Gottheiten"
		mi = B4XPages.AddMenuItem(Me, "Häuser")
		mi.Tag = "Haus"
		mi = B4XPages.AddMenuItem(Me, "Hexagramme")
		mi.Tag = "Hexagramme"
		mi = B4XPages.AddMenuItem(Me, "Hilfe")
		mi.Tag = "Hilfe"
		mi = B4XPages.AddMenuItem(Me, "HD")
		mi.Tag = "HD"
		mi = B4XPages.AddMenuItem(Me, "HD Linien")
		mi.Tag = "HDLinien"
		mi = B4XPages.AddMenuItem(Me, "HDTyp")
		mi.Tag = "HDTyp"
		mi = B4XPages.AddMenuItem(Me, "HD Profil")
		mi.Tag = "HDProfil"
		mi = B4XPages.AddMenuItem(Me, "HD Autoritaet")
		mi.Tag = "Autoritaet"
		mi = B4XPages.AddMenuItem(Me, "HD Ernährung")
		mi.Tag = "HDErnaehrung"
		mi = B4XPages.AddMenuItem(Me, "Inkarnationskreuz")
		mi.Tag = "InKreuz"
		mi = B4XPages.AddMenuItem(Me, "Kanäle")
		mi.Tag = "Kanaele"
		mi = B4XPages.AddMenuItem(Me, "Kognition")
		mi.Tag = "Kognition"
		mi = B4XPages.AddMenuItem(Me, "Konstellationsbilder")
		mi.Tag = "Konstellationsbilder"
		mi = B4XPages.AddMenuItem(Me, "Matrixlifecode")
		mi.Tag = "Matrixlifecode"
		mi = B4XPages.AddMenuItem(Me, "Motivation")
		mi.Tag = "Motivation"
		mi = B4XPages.AddMenuItem(Me, "Meridiane")
		mi.Tag = "Meridiane"
		mi = B4XPages.AddMenuItem(Me, "MeridianeBehandlung")
		mi.Tag = "MeridianeBehandlung"
		mi = B4XPages.AddMenuItem(Me, "MeridianeBehandlungKategorien")
		mi.Tag = "MeridianeBehandlungKategorien"
		mi = B4XPages.AddMenuItem(Me, "MondBehandlung")
		mi.Tag = "MondBehandlung"
		mi = B4XPages.AddMenuItem(Me, "MondBehandlungKategorien")
		mi.Tag = "MondBehandlungKategorien"
		mi = B4XPages.AddMenuItem(Me, "Mp3Inhalte")
		mi.Tag = "Mp3Inhalte"
		mi = B4XPages.AddMenuItem(Me, "Num. Weg")
		mi.Tag = "NumWeg"
		mi = B4XPages.AddMenuItem(Me, "PdfInhalte")
		mi.Tag = "PdfInhalte"
		mi = B4XPages.AddMenuItem(Me, "PDF mit allen Toren/Linien")
		mi.Tag = "PDFalle"
		mi = B4XPages.AddMenuItem(Me, "Planeten")
		mi.Tag = "Planeten"
		mi = B4XPages.AddMenuItem(Me, "Planetenbedeutung")
		mi.Tag = "PlanetenBedeutung"
		mi = B4XPages.AddMenuItem(Me, "Rollen")
		mi.Tag = "Rollen"
		mi = B4XPages.AddMenuItem(Me, "RnaBase")
		mi.Tag = "RnaBase"
		mi = B4XPages.AddMenuItem(Me, "Sabische Symbole")
		mi.Tag = "Sabische"
		mi = B4XPages.AddMenuItem(Me, "Sprache")
		mi.Tag = "Sprache"
		mi = B4XPages.AddMenuItem(Me, "Sternzeichen")
		mi.Tag = "Sternzeichen"
		mi = B4XPages.AddMenuItem(Me, "Szene")
		mi.Tag = "Szene"
		mi = B4XPages.AddMenuItem(Me, "Tore der Angst")
		mi.Tag = "TorederAngst"
		mi = B4XPages.AddMenuItem(Me, "Tore der Liebe")
		mi.Tag = "TorederLiebe"
		mi = B4XPages.AddMenuItem(Me, "Tore des Drucks")
		mi.Tag = "ToreDruck"
		mi = B4XPages.AddMenuItem(Me, "Tore des Frusts")
		mi.Tag = "ToreFrust"
		mi = B4XPages.AddMenuItem(Me, "Tore der Schubkraft")
		mi.Tag = "ToreSchubkraft"
		mi = B4XPages.AddMenuItem(Me, "Übersetzungen")
		mi.Tag = "Übersetzungen"
		mi = B4XPages.AddMenuItem(Me, "Zentren")
		mi.Tag = "Zentren"	
	End Sub
	
Sub pstartbild_Touch (Action As Int, X As Float, Y As Float)
	Log(X&","&Y)
End Sub
Sub CreateListItemAllgemein As Panel
	Dim p As B4XView = xui.CreatePanel("")
	p.SetLayoutAnimated(0,0,0,100%x,480dip)
	p.LoadLayout("cellitemAllgemein")
	Return p
End Sub

Sub CreateListItemAktivierterKanal(farbe As Char,kanal As String,name As String,beschreibung As String,rolle As String) As Panel
	'Eine Zeile aktivierter Kanal
	Dim p As B4XView = xui.CreatePanel("")
	p.SetLayoutAnimated(0,0,0,100%x,40dip)
	p.LoadLayout("cellitemAktivierterKanal")

	AktivKanal.Text = kanal
	AktivKanal.Tag = beschreibung
	AktivKanalName.text = name
	AktivKanalName.Tag = beschreibung
	AktivKanalRolle.Text = rolle
	Select True
		Case farbe="s": AktivKanal.TextColor = xui.Color_Black
		Case farbe="r": AktivKanal.TextColor = xui.Color_red
		Case farbe="b": AktivKanal.TextColor = xui.color_blue
		Case farbe="g": AktivKanal.TextColor = Main.colgrau
	End Select
	Return p
End Sub

Sub CreateListItemHeaderAktivierterKanal As Panel
	'Überschrift Kanaele
	Dim p As B4XView = xui.CreatePanel("")
	p.SetLayoutAnimated(0,0,0,100%x,40dip)
	p.LoadLayout("cellitemHeaderAktivierterKanal")
	LAktivKanal.Text= translate(Main.sprache,133) 'Kanal
	LAktivKanalName.Text = translate(Main.sprache,113) 'Name
	LAktivKanalRolle.Text = translate(Main.sprache,43) 'Rolle
	Return p
End Sub

Sub CreateUeberschrift(text As String) As Panel
	'Überschrift schreiben
	Dim p As B4XView = xui.CreatePanel("")
	p.SetLayoutAnimated(0,0,0,100%x,40dip)
	p.LoadLayout("Ueberschrift")
	header.Text= text
	header.Tag=text
	header.TextColor=Main.colrosa
	Return p
End Sub


Sub fillAktivierteKanaele
	'Schreibt die aktivierten Kanäle
	Dim rs As ResultSet
	Select True
		Case edtBody.SelectedIndex = 0 Or edtBody.SelectedIndex = 3: rs = Main.sql.ExecQuery("SELECT * FROM AktivierteKanaeleRotSchwarz")
		Case edtBody.SelectedIndex = 1: rs = Main.sql.ExecQuery("SELECT * FROM AktivierteKanaeleRot")
		Case edtBody.SelectedIndex = 2: rs = Main.sql.ExecQuery("SELECT * FROM AktivierteKanaeleSchwarz")
		Case edtBody.SelectedIndex = 4: rs = Main.sql.ExecQuery("SELECT * FROM AktivierteKanaele")
		Case edtBody.SelectedIndex = 5: rs = Main.sql.ExecQuery("SELECT * FROM AktivierteKanaeleNurTransit")
		Case Else: rs = Main.sql.ExecQuery("SELECT * FROM AktivierteKanaele") 'Nur bei Aufruf ohne ausgewählten Nutzer
	End Select
	'Überschriften
	clv1.Add(CreateUeberschrift(translate(Main.sprache,134)),"") 'Aktivierte Kanäle
	clv1.Add(CreateListItemHeaderAktivierterKanal,"")
	
	Do While rs.NextRow
		Dim farbe As Char = "b"
		Dim kanal As String = rs.GetString("Kanal")
		Dim NumberOfMatches As Int
		NumberOfMatches = Main.sql.ExecQuerySingleResult("SELECT count(*) FROM AktivierteKanaeleRotSchwarz WHERE Kanal ='"& kanal &"'")
		If NumberOfMatches = 1 Then farbe = "g"
		clv1.Add(CreateListItemAktivierterKanal(farbe,kanal,rs.GetString("Name"),rs.GetString("BeschreibungKanal"),rs.GetString("Rollen")),"")
	Loop
	rs.Close
End Sub


Sub createListItemStartbild As Panel
	Dim p As B4XView = xui.CreatePanel("")
	If screensize < 8 Then
		p.SetLayoutAnimated(0,0,0,100%x,320dip)
		p.LoadLayout("cellitemStartbild")
		startbild.Bitmap=LoadBitmapResize(File.DirAssets,"startbild.png",p.width,p.height,True)
	Else
		p.SetLayoutAnimated(0,0,0,640dip,680dip)
		p.LoadLayout("cellitemStartbild")
		startbild.Bitmap=LoadBitmap(File.DirAssets,"startbild.png")
	End If
		
	SternzeichenPanelVordergrund
	Return p
End Sub
Sub CreateListItemImg As Panel
	Dim p As B4XView = xui.CreatePanel("")
	If screensize < 8 Then
		p.SetLayoutAnimated(0,0,0,100%x,320dip)
	Else
		p.SetLayoutAnimated(0,0,0,640dip,640dip)
	End If
	p.LoadLayout("cellitembodyzoom")
	Return p
End Sub

'	Sub createListItemBodyToreLinien As Panel
'		Dim p As B4XView = xui.CreatePanel("")
'		p.SetLayoutAnimated(200,0,0,100%x,320dip)
'		p.LoadLayout("cellitembodydetail")
'		Return p
'	End Sub
#end if

'Sub updateDBStruktur
	'Aktualisiert die aktuell gespeicherte Datenbankstruktur
'	Try
'		Main.sql.ExecNonQuery("ALTER TABLE Zentren ADD COLUMN AffirmationDefiniert BLOB")
'	Catch
'		Log("Spalte vorhanden")
'	End Try
	
	'Tabellen hinzufügen, falls sie nicht vorhanden sind
'	Main.sql.ExecNonQuery("ATTACH DATABASE '" & File.Combine(xui.DefaultFolder, "heilsystemAPP.db") & "' AS dbApp")
'	Try
'		Main.sql.ExecNonQuery("CREATE TABLE HDProfil(Profil TEXT,BeschreibungProfil BLOB")
'	Catch
'		Log("Tabelle vorhanden")
'	End Try
'	Try
'		Main.sql.ExecNonQuery("CREATE TABLE HDTyp(HDTyp TEXT,BeschreibungHDTyp BLOB")
'	Catch
'		Log("Tabelle vorhanden")
'	End Try
	
'	Main.sql.ExecNonQuery("INSERT INTO main1.[table1] SELECT * FROM temp1.[table2]")
'End Sub


'Private Sub B4XPage_CloseRequest As ResumableSub
'	Dim sf As Object = xui.Msgbox2Async("Close?", "Title", "Yes", "Cancel", "No", Null)
'	Wait For (sf) Msgbox_Result (Result As Int)
'	If Result = xui.DialogResponse_Positive Then
'		Return True
'	End If
'	Return False
'End Sub

Private Sub deleteUser_Click
	Dim sf As Object = xui.Msgbox2Async(lblPerson.text & " "& translate(Main.sprache,25), translate(Main.sprache,25), translate(Main.sprache,100), "", translate(Main.sprache,101), Null)
	Wait For (sf) Msgbox_Result (Result As Int)
	If Result <> xui.DialogResponse_Positive Then Return
	
	'in allen Datenbanken diesen Namen löschen
'	Dim rs As ResultSet = Main.SQL.ExecQuery("select Name,Vorname from Benutzer where IdName="&iduser)
'	Do While rs.NextRow
'		Dim vorname As String = rs.GetString("Vorname")
'		Dim name As String = rs.GetString("Name")
'		Exit
'	Loop
	
	Dim query As String
	query = "delete from HD where IdUser="&iduser
	Main.SQL.ExecNonQuery(query)
	query = "delete from Benutzer where IdName="&iduser
	Main.SQL.ExecNonQuery(query)
	Dim query As String = "UPDATE _variablen SET Wert = -1 where Name = 'IdUser'"
	Main.sql.ExecNonQuery(query)
	
'	If dbname <> "heilsystemdeutsch.db" Then
'		#if b4j
'		Main.sql.InitializeSQLite(xui.DefaultFolder, "heilsystemdeutsch.db", False)
'		#else
'			Main.sql.Initialize(xui.DefaultFolder, "heilsystemdeutsch.db", False)
'		#End If
'		Dim id As Object = Main.SQL.ExecQuerySingleResult("select IdName from Benutzer where Vorname='"&vorname&"' and Name='"&name&"'")
'		If id <> Null Then
'			query = "delete from HD where IdUser="&id
'			Main.SQL.ExecNonQuery(query)
'			query = "delete from Benutzer where IdName="&id
'			Main.SQL.ExecNonQuery(query)
'		End If
'	End If
'	If dbname <> "heilsystemenglish.db" Then
'		#if b4j
'		Main.sql.InitializeSQLite(xui.DefaultFolder, "heilsystemenglish.db", False)
'		#else
'			Main.sql.Initialize(xui.DefaultFolder, "heilsystemenglish.db", False)
'		#End If
'		Dim id As Object = Main.SQL.ExecQuerySingleResult("select IdName from Benutzer where Vorname='"&vorname&"' and Name='"&name&"'")
'		If id <> Null Then
'			query = "delete from HD where IdUser="&id
'			Main.SQL.ExecNonQuery(query)
'			query = "delete from Benutzer where IdName="&id
'			Main.SQL.ExecNonQuery(query)
'		End If
'	End If
'	If dbname <> "heilsystemespanol.db" Then
'		#if b4j
'		Main.sql.InitializeSQLite(xui.DefaultFolder, "heilsystemespanol.db", False)
'		#else
'			Main.sql.Initialize(xui.DefaultFolder, "heilsystemespanol.db", False)
'		#End If
'		Dim id As Object = Main.SQL.ExecQuerySingleResult("select IdName from Benutzer where Vorname='"&vorname&"' and Name='"&name&"'")
'		If id <> Null Then
'			query = "delete from HD where IdUser="&id
'			Main.SQL.ExecNonQuery(query)
'			query = "delete from Benutzer where IdName="&id
'			Main.SQL.ExecNonQuery(query)
'		End If
'	End If
'	If dbname <> "heilsystemfrancais.db" Then
'		#if b4j
'		Main.sql.InitializeSQLite(xui.DefaultFolder, "heilsystemfrancais.db", False)
'		#else
'			Main.sql.Initialize(xui.DefaultFolder, "heilsystemfrancais.db", False)
'		#End If
'		Dim id As Object = Main.SQL.ExecQuerySingleResult("select IdName from Benutzer where Vorname='"&vorname&"' and Name='"&name&"'")
'		If id <> Null Then
'			query = "delete from HD where IdUser="&id
'			Main.SQL.ExecNonQuery(query)
'			query = "delete from Benutzer where IdName="&id
'			Main.SQL.ExecNonQuery(query)
'		End If
'	End If
'	
'	'wieder aktuelle Sprachevariante aktivieren
'	#if b4j
'		Main.sql.InitializeSQLite(xui.DefaultFolder, dbname, False)
'	#else
'		Main.sql.Initialize(xui.DefaultFolder, dbname, False)
'	#end if
	B4XPage_MenuClick("Laden") 'Person laden

	
End Sub

private Sub Hilfe
	B4XPages.ShowPage("Hilfe")
End Sub

Private Sub neuePerson_Click
	B4XPages.ShowPage("PersonNeu")
End Sub

'Lädt die Datenbank vom Server
'Sub datenbankLaden(db As String) As ResumableSub
'	Private j As HttpJob
'	Dim url As String
'	Dim ret As Boolean
'	url = "https://heilseminare.com/meditationen/db/"
'	j.Initialize("", Me)
'	j.Username = "heilseminare.com@heilseminare.com"
'	j.Password="isis2711strato"
'	j.JobName=db
'	j.Download(url&j.JobName)
'
'	Wait For (j) JobDone(j As HttpJob)
'	ret = j.Success
'	If ret=True Then
'		Dim o As OutputStream
'		Main.SQL.Close
'		o = File.OpenOutput(xui.DefaultFolder, db&"NEU", False)
'		File.Copy2(j.GetInputStream, o)
'		Log("Datenbank "&db&"NEU"&" vom Server erfolgreich geladen und kopiert")
'		o.Close
'		
'		'Vorhandene Tabellen HD und Benutzer in neue DB schreiben und diese dann mit altem Namen speichern
'		#if user
'			dbAbgleichen(db&"Neu",dbname)
'		#end if
'		'DB neu initialisieren
'		#If b4j
'			Main.SQL.InitializeSQLite(xui.DefaultFolder,dbname, False)
'		#Else
'			Main.sql.Initialize(xui.DefaultFolder, dbname, False)
'		#End If
'		Log("Neu empfangene Datenbank "&db&" initialisiert")
'	End If
'	j.Release	'Resource freigeben
'	Return ret
'End Sub

#if b4a
'Sub dbAbgleichen(dbneu As String, dbalt As String)
'	'in dbneu die Tabellen '_variablen','HD','Benutzer','direktkauf' von dbalt übernehmen
'	'danach die Tabelle dbalt löschen und dbneu in dbalt umbenennen
'	
'End Sub

Sub billing_PurchasesUpdated (Result As BillingResult, Purchases As List)
	If Result.IsSuccess Then
		For Each p As Purchase In Purchases
			If p.Sku=SKU_ID1 Or p.Sku=SKU_ID2 Or p.Sku=SKU_ID3 Then HandlePurchase(p)
		Next
	End If
End Sub

Private Sub HandlePurchase (p As Purchase)
	If p.PurchaseState <> p.STATE_PURCHASED Then 
		Return
	End If
	'Verify the purchase signature.
	'This cannot be done with the test id.
	If billing.VerifyPurchase(p, BILLING_KEY) = False Then
		Log("Invalid purchase")
		Return
	End If
	'Kauf wird bestätigt oder konsumiert, wir konsumieren und erhöhen PersCounter
'	If p.IsAcknowledged = False Then
'		'we either acknowledge the product or consume it.
'		Wait For (billing.AcknowledgePurchase(p.PurchaseToken, "")) Billing_AcknowledgeCompleted (Result As BillingResult)
'		Log("Acknowledged: " & Result.IsSuccess)
'	End If
	If p.Sku = SKU_ID3 Then 	'Subscription fuer Behandlungen
		If p.IsAcknowledged = False Then
			Wait For (billing.AcknowledgePurchase(p.PurchaseToken, "")) Billing_AcknowledgeCompleted (Result As BillingResult)
			Log("Subscription Acknowledged and active: " & Result.IsSuccess)
		End If
		subsBehandlung = True
		kvs.Put("subsbehandlung", subsBehandlung)
	Else
		If p.IsAcknowledged = False Then
			Wait For (billing.Consume(p.PurchaseToken, "")) Billing_ConsumeCompleted (Result As BillingResult)
			If Result.IsSuccess Then	'erfolgreich konsumiert
				If p.Sku=SKU_ID1 Then 	'Person wurde dazugekauft
				 	PersCounter = PersCounter + 1
				 	kvs.Put("perscounter", PersCounter)
					Log("Purchase consumed: PersCounter now:"&PersCounter)
					MsgboxAsync(translate(Main.sprache,84),translate(Main.sprache,85))
				End If
				
				If p.Sku=SKU_ID2 Then 	'Beratung wurde dazugekauft
					Log("Beratung wurde soeben gekauft, Christiane benachrichtigen!")
					'Nachricht an Chitao wg. Termin
					MsgboxAsync(translate(Main.sprache,86)&CRLF&translate(Main.sprache,87)&CRLF&"Christiane:+34-663415310, christiane@heilseminare.com",translate(Main.sprache,88))
				End If
			Else
				'Kauf und Konsumieren schlug fehl 
				If Result.ResponseCode = Result.CODE_DEVELOPER_ERROR Then 'oder Sandbox Environment
					Log("Result.ResponseCode = DEVELOPER_ERRROR")
				End If
				If Result.ResponseCode = Result.CODE_ITEM_ALREADY_OWNED Then 
					MsgboxAsync("You have "&p.sku&" already!","No action made!")
				End If
			End If 'consume Product
		End If 'Isacknowledged
	End If
End Sub

Private Sub RestorePurchases
	'Nur Subscription kann restauriert werden, alles andere wird sofort konsumiert
	'Subscription wird zunächst auf false gesetzt und in HandlePurchase gesetzt, falls Zeitraum noch passt
	kvs.Put("subsbehandlung", False)
	Wait For (billing.ConnectIfNeeded) Billing_Connected (Result As BillingResult)
	If Result.IsSuccess Then
		Wait For (billing.QueryPurchases("subs")) Billing_PurchasesQueryCompleted (Result As BillingResult, Purchases As List)
		Log("Query completed: " & Result.IsSuccess)
		If Result.IsSuccess Then
			For Each p As Purchase In Purchases
				If p.sku = SKU_ID3 Then 
					If p.PurchaseState = p.STATE_PURCHASED Then 
						subsBehandlung = True
					End If
				End If
			Next
		End If
	End If
	kvs.Put("subsbehandlung", subsBehandlung)
End Sub
#end if

 'wird benötigt um die Legende Rot&Schwarz zu schreiben
Sub TextToLegende (Width As Int,height As Int, Fnt As B4XFont, Clrtext As Int, clrbackground As Int, Text As Object) As B4XBitmap
	Dim x As B4XView  = lfrequenz
	x.Visible = True
	x.Color = clrbackground
	x.TextColor = Clrtext
	x.Width = Width
	x.Height= height
	x.SetLayoutAnimated(0, 0, 0, Width, height)
	x.Font = Fnt
	#if b4a
'		Dim su As StringUtils
'		x.Height = su.MeasureMultilineTextHeight(x, Text)

	#end if
	
	x.Text = Text
	Return x.Snapshot
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
					If subsBehandlung = False Then
						makeSubscription		'Bei Kauf oder Ablehnung erst mal zurück, bei Kauf wird subsBehandlung gesetzt
						Return
					End If
					medien1.mediafile = URL
					B4XPages.ShowPage("medien")
				#end if
		Case ext = "pdf":
				#if b4j
			jfx1.ShowExternalDocument(URL) 'derzeit wird die Lösung bevorzugt im Standardprogramm zu öffnen
				#else
 					pdfDokument = URL
					B4XPages.ShowPage("PDFAnzeige")
				#End If	
	End Select	
End Sub

Sub zeichneToreLinien(user As Int,grafikdatei As String,transit As Boolean)
	'Zeichnet alle Tore und Linien und sichert in grafikdatei
	'links die roten unbewussten Tore
	'rechts die schwarzen bewussten Tore
	'Über HD-Linien wird IdSternzeichen ermittelt.
	'Die Farbe ist main.farbe(idSternzeichen)
	'planet() enthält die Planeten in der richtigen Reihenfolge
	#if b4j
		Dim bmp As B4XBitmap = xui.LoadBitmap(File.DirData("heilsystem"), grafikdatei)
	#else
	Dim bmp As B4XBitmap = xui.LoadBitmap(rp.GetSafeDirDefaultExternal(""), grafikdatei)
	#End If

	Dim bc As BitmapCreator
	bc.Initialize(640,1031)
	
	'bodygraphexakt.SetBitmap(bmp)
	bc.CopyPixelsFromBitmap(bmp)
	#if b4j
		Dim zeilenhoehe As Int = 24
		Dim offsetY As Int = 80
	#else
		Dim zeilenhoehe As Int = 24
		Dim offsetY As Int = 24
	#end if

	'Allgemeine Daten schreiben, Name, Geburtsdatum ...
'	#if b4j
'	Dim bm As B4XBitmap = TextToLegende(200,zeilenhoehe, xui.CreateDefaultBoldFont(14), xui.Color_black,xui.Color_White,lblPerson.text)
'	#else
'		Dim bm As B4XBitmap = TextToLegende(200dip,zeilenhoehe, xui.CreateDefaultFont(7), xui.Color_Black,xui.color_white,lblperson.text)
'	#end if
'	Dim rec As B4XRect
'	Dim posX As Int = 20
'	Dim posY As Int = 20
'	rec.Initialize(posX,posY,posX+bm.Width,posY+bm.Height)
'	bc.DrawBitmap(bm,rec,True)
'	'Typ
'	#if b4j
'	Dim bm As B4XBitmap = TextToLegende(150,zeilenhoehe, xui.CreateDefaultBoldFont(14), xui.Color_black,xui.Color_White,lbl0HDTyp.text)
'	#else
'		Dim bm As B4XBitmap = TextToLegende(150dip,zeilenhoehe, xui.CreateDefaultFont(7), xui.Color_Black,xui.color_white,lblHDTyp.text)
'	#end if
'	Dim rec As B4XRect
'	Dim posX As Int = 430
'	rec.Initialize(posX,posY,posX+bm.Width,posY+bm.Height)
'	bc.DrawBitmap(bm,rec,True)
'	posY = 20 + zeilenhoehe
	
	If transit = False Then
		
		'Rote Legende schreiben
		Dim anz As Int = PersonNeu1.planet.Length
		For i = 0 To  anz - 1
			Dim tor As Int = Main.SQL.ExecQuerySingleResult("select IdTor from HD where IdUser="& user &" and RotSchwarz='r' and IdPlanet="&PersonNeu1.planet(i))
			Dim linie As Int = Main.SQL.ExecQuerySingleResult("select Linie from HD where IdUser="& user &" and RotSchwarz='r' and IdPlanet="&PersonNeu1.planet(i))
			Dim torname As String = Main.SQL.ExecQuerySingleResult("select TorName from Hexagramme where IdTor="& tor)
			Dim rec As B4XRect
			Dim posX As Int = 20
			Dim posY As Int = offsetY+i*zeilenhoehe
			
			
			'Planetenbild dranhängen
			#if b4j
				Dim bm As B4XBitmap = xui.LoadBitmapResize(File.DirAssets,"planet"&PersonNeu1.planet(i)&".png",14,14,True)
				rec.Initialize(posX,posY+7,posX+bm.Width,posY+7+bm.Height)
			#else
				Dim bm As B4XBitmap = LoadBitmapResize(File.DirAssets,"planet"&PersonNeu1.planet(i)&".png",14,14,True)
				If  screensize < 8 Then
					rec.Initialize(posX,posY+4,posX+bm.Width,posY+4+bm.Height)
				Else
					rec.Initialize(posX,posY+6,posX+bm.Width,posY+6+bm.Height)
				End If
			#end if
			
			bc.DrawBitmap(bm,rec,False)
			posX = posX + 20
			'Tor
			#if b4j
				Dim bm As B4XBitmap = TextToLegende(20,zeilenhoehe, xui.CreateDefaultBoldFont(14), Main.colrot,xui.Color_White,tor)
			#else
				If  screensize < 8 Then
					Dim bm As B4XBitmap = TextToLegende(20,zeilenhoehe, myfont7, Main.colrot,xui.color_white,tor)
				Else
					Dim bm As B4XBitmap = TextToLegende(25,zeilenhoehe, myfont7, Main.colrot,xui.color_white,tor)
				End If
			#end if
			rec.Initialize(posX,posY,posX+bm.Width,posY+bm.Height)
			bc.DrawBitmap(bm,rec,True)
			posX = posX + bm.Width + 2
			'Linie
			#if b4j
				Dim bm As B4XBitmap = TextToLegende(20,zeilenhoehe, xui.CreateDefaultBoldFont(14), Main.colrot,xui.Color_White,linie)
			#else
				Dim bm As B4XBitmap = TextToLegende(14,zeilenhoehe, myfont7, Main.colrot,xui.color_white,linie)
			#end if
			rec.Initialize(posX,posY,posX+bm.Width,posY+bm.Height)
			bc.DrawBitmap(bm,rec,True)
			posX = posX + bm.Width
			'Torname
			#if b4j
				Dim bm As B4XBitmap = TextToLegende(140,zeilenhoehe, xui.CreateDefaultBoldFont(14), Main.colrot,xui.Color_White,torname)
			#else
				Dim bm As B4XBitmap = TextToLegende(160,zeilenhoehe, myfont7, Main.colrot,xui.color_white,torname)
			#end if
			rec.Initialize(posX,posY,posX+bm.Width,posY+bm.Height)
			bc.DrawBitmap(bm,rec,True)
		Next
		
		'Schwarze Legende schreiben
		
		Dim anz As Int = PersonNeu1.planet.Length
		For i = 0 To  anz - 1
			Dim tor As Int = Main.SQL.ExecQuerySingleResult("select IdTor from HD where IdUser="& user &" and RotSchwarz='s' and IdPlanet="&PersonNeu1.planet(i))
			Dim linie As Int = Main.SQL.ExecQuerySingleResult("select Linie from HD where IdUser="& user &" and RotSchwarz='s' and IdPlanet="&PersonNeu1.planet(i))
			Dim torname As String = Main.SQL.ExecQuerySingleResult("select TorName from Hexagramme where IdTor="& tor)
			Dim rec As B4XRect
			Dim posX As Int = 420
			Dim posY As Int = offsetY+i*zeilenhoehe
			
			'Planetenbild dranhängen
			#if b4j
				Dim bm As B4XBitmap = xui.LoadBitmapResize(File.DirAssets,"planet"&PersonNeu1.planet(i)&".png",14,14,True)
				rec.Initialize(posX,posY+7,posX+bm.Width,posY+7+bm.Height)
			#else
				Dim bm As B4XBitmap = LoadBitmapResize(File.DirAssets,"planet"&PersonNeu1.planet(i)&".png",14,14,True)
				If  screensize < 8 Then
					rec.Initialize(posX,posY+4,posX+bm.Width,posY+4+bm.Height)
				Else
					rec.Initialize(posX,posY+6,posX+bm.Width,posY+6+bm.Height)
				End If
			#end if
			
			bc.DrawBitmap(bm,rec,False)
			posX = posX + 20
			'Tor
			#if b4j
				Dim bm As B4XBitmap = TextToLegende(20,zeilenhoehe, xui.CreateDefaultBoldFont(14), xui.Color_Black,xui.Color_White,tor)
			#else
				If  screensize < 8 Then
					Dim bm As B4XBitmap = TextToLegende(20,zeilenhoehe, myfont7, xui.Color_Black,xui.color_white,tor)
				Else
					Dim bm As B4XBitmap = TextToLegende(25,zeilenhoehe, myfont7, xui.Color_Black,xui.color_white,tor)
				End If
			#end if
			rec.Initialize(posX,posY,posX+bm.Width,posY+bm.Height)
			bc.DrawBitmap(bm,rec,True)
			posX = posX + bm.Width + 2
			'Linie
			#if b4j
				Dim bm As B4XBitmap = TextToLegende(20,zeilenhoehe, xui.CreateDefaultBoldFont(14), xui.Color_Black,xui.Color_White,linie)
			#else
				Dim bm As B4XBitmap = TextToLegende(14,zeilenhoehe, myfont7, xui.Color_Black,xui.color_white,linie)
			#end if
			rec.Initialize(posX,posY,posX+bm.Width,posY+bm.Height)
			bc.DrawBitmap(bm,rec,True)
			posX = posX + bm.Width
			'Torname
			#if b4j
				Dim bm As B4XBitmap = TextToLegende(150,zeilenhoehe, xui.CreateDefaultBoldFont(14), xui.Color_black,xui.Color_White,torname)
			#else
			Dim bm As B4XBitmap = TextToLegende(160,zeilenhoehe, myfont7, xui.Color_Black,xui.color_white,torname)
			#end if
			rec.Initialize(posX,posY,posX+bm.Width,posY+bm.Height)
			bc.DrawBitmap(bm,rec,True)
		Next
	Else	'Nur Transit schreiben, auch Chiron reinschreiben
		Dim anz As Int = PersonNeu1.planet.Length
		For i = 0 To  anz - 1
			Dim tor As Int = Main.SQL.ExecQuerySingleResult("select IdTor from HD where IdUser="& user &" and RotSchwarz='t' and IdPlanet="&PersonNeu1.planet(i))
			Dim linie As Int = Main.SQL.ExecQuerySingleResult("select Linie from HD where IdUser="& user &" and RotSchwarz='t' and IdPlanet="&PersonNeu1.planet(i))
			Dim torname As String = Main.SQL.ExecQuerySingleResult("select TorName from Hexagramme where IdTor="& tor)
			Dim rec As B4XRect
			Dim posX As Int = 430
			Dim posY As Int = offsetY+i*zeilenhoehe
			
			'Planetenbild dranhängen
			#if b4j
				Dim bm As B4XBitmap = xui.LoadBitmapResize(File.DirAssets,"planet"&PersonNeu1.planet(i)&".png",14,14,True)
				rec.Initialize(posX,posY+7,posX+bm.Width,posY+7+bm.Height)
			#else
				Dim bm As B4XBitmap = LoadBitmapResize(File.DirAssets,"planet"&PersonNeu1.planet(i)&".png",14,14,True)
				If  screensize < 8 Then
					rec.Initialize(posX,posY+4,posX+bm.Width,posY+4+bm.Height)
				Else
					rec.Initialize(posX,posY+7,posX+bm.Width,posY+6+bm.Height)
				End If
			#end if
			
				
			bc.DrawBitmap(bm,rec,False)
			posX = posX + 20
			'Tor
			#if b4j
				Dim bm As B4XBitmap = TextToLegende(20,zeilenhoehe, xui.CreateDefaultBoldFont(14), xui.Color_blue,xui.Color_White,tor)
			#else
				If  screensize < 8 Then
					Dim bm As B4XBitmap = TextToLegende(20,zeilenhoehe, myfont7, xui.Color_blue,xui.color_white,tor)
				Else
					Dim bm As B4XBitmap = TextToLegende(25,zeilenhoehe, myfont7, xui.Color_blue,xui.color_white,tor)
				End If	
			#end if
			rec.Initialize(posX,posY,posX+bm.Width,posY+bm.Height)
			bc.DrawBitmap(bm,rec,True)
			posX = posX + bm.Width + 2
			'Linie
			#if b4j
				Dim bm As B4XBitmap = TextToLegende(20,zeilenhoehe, xui.CreateDefaultBoldFont(14), xui.Color_blue,xui.Color_White,linie)
			#else
				Dim bm As B4XBitmap = TextToLegende(14,zeilenhoehe, myfont7, xui.Color_Blue,xui.color_white,linie)
			#end if
			rec.Initialize(posX,posY,posX+bm.Width,posY+bm.Height)
			bc.DrawBitmap(bm,rec,True)
			posX = posX + bm.Width
			'Torname
			#if b4j
				Dim bm As B4XBitmap = TextToLegende(150,zeilenhoehe, xui.CreateDefaultBoldFont(14), xui.Color_blue,xui.Color_White,torname)
			#else
				Dim bm As B4XBitmap = TextToLegende(160,zeilenhoehe, myfont7, xui.Color_blue,xui.color_white,torname)
			#end if
			rec.Initialize(posX,posY,posX+bm.Width,posY+bm.Height)
			bc.DrawBitmap(bm,rec,True)
		Next
	End If
	
	Dim Out As OutputStream
	#if b4j
		Out = File.OpenOutput(File.DirData("heilsystem"), grafikdatei, False)
	#else
		Out = File.OpenOutput(rp.GetSafeDirDefaultExternal(""), grafikdatei, False)
	#end if
	bc.Bitmap.WriteToStream(Out, 100, "PNG")
	Out.Close
	#if b4j
		bodygraphexakt.SetBitmap(bc.bitmap)
	#end if
	lfrequenz.Visible = False 'da es bei Texttolegende verwendet wird um das Image zu erzeugen
End Sub


'Sub writeonImage(bcr As BitmapCreator,tor As String,coltor As Int,wandeltor As String, colWandeltor As Int) As BitmapCreator
'	'erstellt Text auf Label und positioniert den Snapshot
'#if b4j
'	Dim bm As B4XBitmap = TextToBitmap(25, xui.CreateDefaultBoldFont(16), Main.farbe.Get(coltor),xui.Color_White,tor)
'#else
'	Dim bm As B4XBitmap = TextToBitmap(14dip, xui.CreateDefaultFont(10), Main.farbe.Get(coltor),xui.color_white,tor)
'#end if
'	Dim rec As B4XRect
'	Dim posX As Int = 220
'	Dim posY As Int = 10
'	rec.Initialize(posX,posY,posX+bm.Width,posY+bm.Height)
'	bcr.DrawBitmap(bm,rec,True)
'	posX = posX + bm.Width
'	' -->
'	#if b4j
'	Dim bm As B4XBitmap = TextToBitmap(25, xui.CreateDefaultBoldFont(16), xui.Color_Black,xui.Color_White,"-->")
'	#else
'		Dim bm As B4XBitmap = TextToBitmap(16dip, xui.CreateDefaultFont(10), xui.Color_Black,xui.Color_White,"->")
'	#end if
'	Dim rec As B4XRect
'	rec.Initialize(posX,posY,posX+bm.Width,posY+bm.Height)
'	bcr.DrawBitmap(bm,rec,True)
'	posX = posX + bm.Width
'	' Wandeltor
'	#if b4j
'	Dim bm As B4XBitmap = TextToBitmap(25, xui.CreateDefaultBoldFont(16), Main.farbe.Get(colWandeltor),xui.Color_White,wandeltor)
'	#else
'		Dim bm As B4XBitmap = TextToBitmap(16dip, xui.CreateDefaultFont(10), Main.farbe.Get(colWandeltor),xui.Color_White,wandeltor)
'	#end if
'	Dim rec As B4XRect
'	rec.Initialize(posX,posY,posX + bm.Width,posY+bm.Height)
'	bcr.DrawBitmap(bm,rec,True)
'	
'	Return bcr
'End Sub

#if b4j
	Private Sub penergie_MouseClicked (EventData As MouseEvent)
#else
	private Sub penergie_Click
#End If
	'startet clvWichtig nach Sortierung Zeit und mit Berücksichtigung der Transite und navigiert zur Zeile
	' mit der Zeilennummer die in rowidTorenachZeit gespeichert ist.
	
	'Falls auf Meridian geklickt wurde wird Click-Event hier nicht verarbeitet

	If consumeClick Then 		'wurde z.B. auf Meridian geclickt
		consumeClick = False
		Return				 'consume click
	End If
	
	statusTransit=True	
	B4XPages.ShowPage("clvWichtig")
End Sub

#If b4a
Private Sub btherapie_Click
#Else
	Private Sub btherapie_MouseClicked (EventData As MouseEvent)
#end if	
	consumeClick=True			' damit Panel nicht triggert
	If subsBehandlung = False Then
		makeSubscription		' Bei Kauf oder Ablehnung erst mal zurück, bei Kauf wird subsBehandlung gesetzt
		Return
	End If
	B4XPages.ShowPage("meridianBehandlung")
End Sub

Sub makeSubscription
	' Überprüft, ob Subscription fuer Behandlungen noch aktiviert ist
	#if user	
		If subsBehandlung = False Then 'Subscription Behandlung muss aktiviert sein
			xui.Msgbox2Async("Behandlungen der Meridiane bzw. nach Mondstand sowie Heilströmen und die Meditationen können nur mit monatl. Gebühr genutzt werden.", "Behandlungen kaufen", "Ja,zu Google In-App", "Nein,jetzt nicht", "", Null)
			Wait For Msgbox_Result (ergebnis As Int)
			If ergebnis = xui.DialogResponse_Positive Then 
				kaufeSubscriptionBehandlungen
			End If
		End If
	#end if
End Sub

#If b4a
	Private Sub bmondin_Click
#Else
	Private Sub bmondin_MouseClicked (EventData As MouseEvent)
#end if	

	'Zeigt die Behandlungen in eigenem Fenster
	consumeClick=True			'damit Panel nicht triggert
	
	If subsBehandlung = False Then 
		makeSubscription		'Bei Kauf oder Ablehnung erst mal zurück, bei Kauf wird subsBehandlung gesetzt
		Return	
	End If
	'Aktuelle Transite berechnen, damit steht fest wo Mond ist.
	deleteandaddtransitefuerAktuellePerson
	Dim Query As String ="Select * from ToreNachZeit where IdPlanet=4 and RotSchwarz='t'"
	Dim rs As ResultSet = Main.sql.ExecQuery(Query)
	Do While rs.NextRow	'können mehrere Einträge je nach Uhrzeit sein, nach erstem kann aber verlassen werden
'		Query = "Select IDSternzeichen from HDLinien where IdTor=" &rs.GetInt("IdTor") & " and Linie = " & rs.GetInt("Linie")
'		Dim idstz As Int = Main.sql.ExecQuerySingleResult(Query)
		Dim idsab As Int = rs.GetInt("IdSab")
		Dim idstz As Int = Sammlung.convertiereSabSymbolinSternzeichen(idsab)
		Dim stz As String = Main.SQL.ExecQuerySingleResult("select Sternzeichen from Sternzeichen where IdSternzeichen = "&idstz)
		'Bei Mond Transit zusätzlicher die globale Variable aktuellerMondIn setzen
		aktuellerMondIn=stz
		Exit	'Sind alles dieselben Tore,Linien
	Loop
	rs.close
	B4XPages.ShowPage("mondBehandlung")
End Sub

public Sub setTitelzeile(titel As String)
	#if b4a
		Dim cs As CSBuilder
		cs.Initialize
		cs.Color(Main.colrosa)
		cs.Image(LoadBitmap(File.DirAssets, "logo.png"), 32dip, 32dip, False)
		cs.Append(Chr(160)).Append(Chr(160))
		cs.Append(titel)
		cs.PopAll
		B4XPages.SetTitle(Me, cs)
	#else
		B4XPages.SetTitle(Me, titel)
	#end if
End Sub

#if b4a
'Click auf Name zeigt die Beschreibung des Kanals
Private Sub AktivKanalName_Click
	Dim cs As CSBuilder
	Dim o As B4XView = Sender
	Dim res As String = o.tag
	cs.Initialize.Typeface(Typeface.DEFAULT).append(res).PopAll
	DetailinformationZeigen(cs)
End Sub
#end if

#if b4a
Private Sub header_Click
	'Click auf Überschriften Tore der Angst, Tore des Frusts usw. öffnet neue Seite zur Ansicht
	'in Tag ist die Information gespeichert
	Dim o As B4XView = Sender
	storeder = o.tag
	B4XPages.ShowPage("Toreder")
End Sub
#end if

#if b4a
Sub FontToBitmap (Text As String, FontSize As Float) As B4XBitmap
	Dim xui As XUI
	Dim p As Panel = xui.CreatePanel("")
	p.SetLayoutAnimated(0, 0, 0, 32dip, 32dip)
	Dim cvs1 As B4XCanvas
	cvs1.Initialize(p)
	Dim fnt As B4XFont = xui.CreateFontAwesome(FontSize)
	Dim r As B4XRect = cvs1.MeasureText(Text, fnt)
	Dim BaseLine As Int = cvs1.TargetRect.CenterY - r.Height / 2 - r.Top
	cvs1.DrawText(Text, cvs1.TargetRect.CenterX, BaseLine, fnt, xui.Color_Black, "CENTER")
	Dim b As B4XBitmap = cvs1.CreateBitmap
	cvs1.Release
	Return b
End Sub

#End If