B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=11.2
@EndOfDesignText@
Sub Class_Globals
	#if b4j
		Private jfx1 As JFX
	#end if
	Private Root As B4XView 'ignore
	Private xui As XUI 'ignore
	Private	home As B4XMainPage
	Private clvM As CustomListView
	Private BBCodeView1 As BBCodeView
	Private textengine As BCTextEngine
End Sub

'You can add more parameters here.
Public Sub Initialize As Object
	Return Me
End Sub

'This event will be called once, before the page becomes visible.
Private Sub B4XPage_Created (Root1 As B4XView)
	Root = Root1
	'load the layout to Root
	home = B4XPages.GetPage("MainPage")
	Root.LoadLayout("clvMeridianBehandlung")

	#if b4j
		Dim F As Form = B4XPages.GetNativeParent(Me)
		F.WindowWidth = 650
		F.WindowHeight= jfx1.PrimaryScreen.MaxY - jfx1.PrimaryScreen.MinY
		F.WindowTop = jfx1.PrimaryScreen.MinY
	#end if
	
End Sub

Sub b4xpage_disappear
	B4XPages.SetTitle(Me,"")
End Sub
Sub B4xPage_Appear
	Dim titelzeile As String = "Mond in "&home.aktuellerMondIn
	home.setTitelzeile(titelzeile)
	'Listview leeren und neu aufbauen
	clvM.clear
	'Einstellungen lesen

	Dim query As String
	
	query = "select * from viewMondbehandlung where Sternzeichen = '"& home.aktuellerMondIn & "'"
'	Dim stromkurz As Boolean = home.settings.Get("stromkurz")
'	Dim queryadd As String
'	queryadd = " and ("
'	If stromkurz Then queryadd = queryadd&"kat = 'S' or"
'	Dim fingerstrom As Boolean = home.settings.Get("fingerstrom")
'	If fingerstrom Then queryadd = queryadd&" kat ='F' or"
'	Dim neurovaspunkt As Boolean = home.settings.Get("neurovaspunkt")
'	If neurovaspunkt Then queryadd = queryadd&" kat ='NV' or"
'	Dim neurolymphpunkt As Boolean = home.settings.Get("neurolymphpunkt")
'	If neurolymphpunkt Then queryadd = queryadd&" kat ='NL' or"
'	Dim tao As Boolean = home.settings.Get("tao")
'	If tao Then queryadd = queryadd&" kat ='T' or"
'	Dim meridianmass As Boolean = home.settings.Get("meridianmass")
'	If meridianmass Then queryadd = queryadd&" kat ='M' or"
'	Dim akupress As Boolean = home.settings.Get("akupress")
'	If akupress Then queryadd = queryadd&" kat ='P' or"
'	Dim aroma As Boolean = home.settings.Get("aroma")
'	If aroma Then queryadd = queryadd&" kat ='A' or"
'	Dim anregung As Boolean = home.settings.Get("anregung")
'	If anregung Then queryadd = queryadd&" kat ='AN' or"
'	Dim beruhigung As Boolean = home.settings.Get("beruhigung")
'	If beruhigung Then queryadd = queryadd&" kat ='B' or"
'	'Meditationen hinzufügen
'	queryadd = queryadd&" kat ='ME' or"
'	'letztes or abschneiden und Klammer zu machen
'	queryadd=queryadd.SubString2(0,queryadd.Length-2)
'	queryadd=queryadd&")"
'	query = query & queryadd
	Try
		Dim res As ResultSet = Main.SQL.ExecQuery(query)
	Catch
		Log("Keine Kategorien in Einstellungen ausgewählt")
		Return
	End Try
	Do While res.NextRow
		Dim bes As Object =  res.GetString("beschreibung")
		Dim beschreibung As String
		If bes = Null Then
			beschreibung = ""
		Else
			beschreibung = bes
		End If
		Dim b As Object = res.GetString("bild")
		Dim bild As String
		If b=Null Then
			bild=""
		Else
			bild = b
		End If
		Dim kat As String = res.GetString("kat")
		Dim pnl As B4XView =CreateBBItem(kat,beschreibung,bild)
		clvM.Add(pnl,Null)
	Loop
End Sub

#if b4j
Sub CreateBBItem(kat As String,beschreibung As String, bild As String) As Pane
#else
Sub CreateBBItem(kat As String,beschreibung As String, bild As String) As Panel
#end if
	'kuerzelMeridian z.B. LR
	'bild muss als Datei im Assets-Folder vorhanden sein.
	Dim code As String
	Dim p As B4XView = xui.CreatePanel("")
	p.LoadLayout("cellitemBBItem")
	textengine.Initialize(p)
	textengine.KerningEnabled = True
	bild = bild.Trim
	#if b4j
		Dim fileexistsAsset As Boolean = File.Exists("..\files\",bild)
		Dim fileexistsDatafolder As Boolean = File.Exists(xui.DefaultFolder,bild)
	#end if
	
	Log(bild)
	
	If bild.Contains(".mp3") Then
		Dim urlkomplett As String = "https://heilseminare.com/meditationen/" & bild
		code = code & _
$"
[*][url="${urlkomplett}"][color=#FF69B4]${beschreibung}[/color][/url]
"$
	End If
	If kat="ST" Then
		Dim urlkomplett As String ="ST" & beschreibung
		code = code & _
$"
[*][url="${urlkomplett}"][color=#FF69B4]${beschreibung}[/color][/url]
"$
	End If
	#if b4j
	If bild <> "" And bild.Contains(".mp3")=False And kat<>("ST") Then
			If fileexistsAsset Then
				code = code & _
$"[Alignment=left][img FileName=${bild} width=550/][/Alignment]"$
			End If
			If fileexistsDatafolder Then
				code = code & _
$"[Alignment=left][img dir="${xui.DefaultFolder}"img FileName=${bild} width=550/][/Alignment]"$
			End If
		End If
		If beschreibung <> "" And bild.Contains(".mp3")=False And kat<>("ST") Then
			code = code & _
$"[Alignment=left]${beschreibung}[/Alignment]"$
		End If		
	#end if
	#if b4a
	If bild <> "" And bild.Contains(".mp3")=False And kat<>("ST") Then
		If File.Exists(File.DirAssets,bild) Then
			code = code & _
			$"[Alignment=center][img FileName=${bild} width=320/]
[/Alignment]"$
		Else
			xui.Msgbox2Async("Datei "&bild&" fehlt!", "Bitte Datei dem Entwickler geben!", "Ok", "", "", Null)
		End If
	End If
	If beschreibung <> "" And bild.Contains(".mp3")=False And kat<>("ST") Then
		code = code & _
			$"[Alignment=left]${beschreibung}[/Alignment]"$
	End If
	#end if
	
	BBCodeView1.Text = code
	#if b4j
	'scrollview ausblenden
	Dim sp As ScrollPane = BBCodeView1.sv
	sp.SetVScrollVisibility("NEVER")
	#end if
	If BBCodeView1.Paragraph.IsInitialized Then
		Dim ContentHeight As Int = Min(BBCodeView1.Paragraph.Height / textengine.mScale + BBCodeView1.Padding.Top + 				BBCodeView1.Padding.Bottom, BBCodeView1.mBase.Height)
		BBCodeView1.mBase.Height = ContentHeight
		BBCodeView1.sv.ScrollViewContentHeight = ContentHeight
	End If
	p.SetLayoutAnimated(0, 0, 0, clvM.sv.Width, BBCodeView1.mBase.Height )
	Return p
End Sub

Private Sub clvM_ItemClick (Index As Int, Value As Object)
	
End Sub
'spielt den Link als MP3 oder MP4 ab oder öffnet PDF- Dokument
Sub BBcodeview1_LinkClicked (URL As String)
	'letzte 3 Buchstaben auswählen ob mp3, mp4 oder pdf
	Dim ext As String = URL.SubString2(URL.Length-3,URL.Length)
	ext = ext.ToLowerCase
	If URL.StartsWith("ST") Then 'Heilstroemen
		home.aktuellerstrom=URL.SubString(2) 	'PREFIX abschneiden
		B4XPages.ShowPage("stromdetail")
	End If
	If ext = "mp3" Or ext ="mp4" Then
		#if b4j
			jfx1.ShowExternalDocument(URL) 'derzeit wird die Lösung bevorzugt im Standardprogramm zu öffnen
		#else
			If home.subsBehandlung = False Then	'Bei Admin ist subsBehandlung immer true
				home.makeSubscription		'Bei Kauf oder Ablehnung erst mal zurück, bei Kauf wird subsBehandlung gesetzt
				Return
			End If
			home.medien1.mediafile = URL
			B4XPages.ShowPage("medien")
		#end if
	End If
	
End Sub