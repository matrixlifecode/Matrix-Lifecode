B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=8.5
@EndOfDesignText@
Sub Class_Globals
	Private Root As B4XView 'ignore´
	Private xui As XUI 'ignore
	Private textengine As BCTextEngine
	Private cv As BBCodeView
	Private home As B4XMainPage
	Private dlg As B4XDialog
	#if b4j
		Private jfx As JFX
	#end if
End Sub

'You can add more parameters here.
Public Sub Initialize As Object
	Return Me
End Sub

'This event will be called once, before the page becomes visible.
Private Sub B4XPage_Created (Root1 As B4XView)
	Root = Root1
	Root.LoadLayout("Strategie")
	home = B4XPages.GetPage("MainPage")  'Verweis auf Startseite um auf pdfDokument zuzugreifen
	dlg.Initialize(Root)
End Sub

Sub B4XPage_Appear
	B4XPages.SetTitle(Me, "Strategie")
	textengine.Initialize(Root)
	makeReportStrategie
End Sub

Sub cv_LinkClicked (URL As String)
#if b4a
	Dim p As PhoneIntents
	Try
		StartActivity(p.OpenBrowser(URL))
	Catch
		Log(LastException)
	End Try
#Else
	jfx.ShowExternalDocument(URL) 'Standardanwendung wird geöffnet
#end if
End Sub

private Sub makeReportStrategie
	
	'Zeigt dem Anwender einen Dialog, dass er sich etwas gedulden soll, schliesst automatisch
	Dim delaytext As B4XTimedTemplate
	Dim msg As B4XLongTextTemplate
	msg.Initialize
	msg.Text = "Bitte etwas Geduld, die Ausgabe wird erstellt!"
	delaytext.Initialize(msg)
	delaytext.TimeoutMilliseconds=2000
	dlg.ShowTemplate(delaytext, "", "", "")
	
	'Ermitteln der Daten
	Dim rs As ResultSet = Main.SQL.ExecQuery("select * from Benutzer where IdName = "&home.iduser)
	rs.NextRow
	
	Dim Name As String = rs.GetString("Name")
	Dim Vorname As String = rs.GetString("Vorname")
	Dim Geburtsdatum As String = rs.GetString("Geburtsdatum")
	Dim Geburtszeit As String = rs.GetString("Geburtszeit")
	Dim HDTyp As String = rs.GetString("HDTyp")
	Dim HDAutoritaet As String = rs.GetString("Autoritaet")
	Dim HDProfil As String = rs.GetString("Profil")
	Dim HDInkarnationskreuz As String = rs.GetString("HDInkarnationskreuz")
	Dim Ernaehrung As String = rs.GetString("HDErnaehrung")
	Dim NumWeg As String = rs.GetString("NumWeg")
	

	'Anzeige der Daten
	cv.Text = $"[Alignment=Left][img FileName="logo.png" width=50/][/Alignment]
[Alignment=Center][TextSize=20][b][u][color=#e2889b]Strategie von ${Vorname} ${Name}[/color][/u][/b][/TextSize]
geboren am: ${Geburtsdatum} um ${Geburtszeit}[/Alignment]

"$
	'HDTyp
	Dim HDTypBeschreibung As Object = Main.SQL.ExecQuerySingleResult("select  BeschreibungHDTyp from HDTyp where HDTyp = '"&HDTyp&"'")
	cv.text = cv.text & _
$"[Alignment=Left][b][u][color=#e2889b]Design: ${HDTyp}[/color][/u][/b][/Alignment]
[Alignment=Left]${HDTypBeschreibung}[/Alignment]

"$
	'HDProfil
	Dim HDProfilBeschreibung As Object = Main.SQL.ExecQuerySingleResult("select BeschreibungProfil from HDProfil where Profil = '"&HDProfil&"'")
	If HDProfilBeschreibung <> Null And HDProfilBeschreibung <>"" Then
		cv.text = cv.text & _
$"[Alignment=Left][b][u][color=#e2889b]Profil: ${HDProfil}[/color][/u][/b][/Alignment]
[Alignment=Left]${HDProfilBeschreibung}[/Alignment]

"$
	End If
	'HDAutoritaet
	Dim Beschreibung As Object = Main.SQL.ExecQuerySingleResult("select BeschreibungAutoritaet  from HDAutoritaet where Autoritaet = '"&HDAutoritaet&"'")
	If Beschreibung <> Null And Beschreibung <>"" Then
		cv.text = cv.text & _
$"[Alignment=Left][b][u][color=#e2889b]Autorität: ${HDAutoritaet}[/color][/u][/b][/Alignment]
[Alignment=Left]${Beschreibung}[/Alignment]

"$
	End If
	'InKreuz
	Dim Beschreibung As Object = Main.SQL.ExecQuerySingleResult("select InBezeichnung from InKreuz where InName = '"&HDInkarnationskreuz&"'")
	If Beschreibung <> Null And Beschreibung <>"" Then
		cv.text = cv.text & _
$"[Alignment=Left][b][u][color=#e2889b]Inkarnationskreuz: ${HDInkarnationskreuz}[/color][/u][/b][/Alignment]
[Alignment=Left]${Beschreibung}[/Alignment]

"$
	End If
	'Ernährung
	Dim Beschreibung As Object = Main.SQL.ExecQuerySingleResult("select BeschreibungErnaehrung  from HDErnaehrung where HDErnaehrung = '"&Ernaehrung&"'")
	If Beschreibung <> Null And Beschreibung <>"" Then
		cv.text = cv.text & _
$"[Alignment=Left][b][u][color=#e2889b]Ernährung: ${Ernaehrung}[/color][/u][/b][/Alignment]
[Alignment=Left]${Beschreibung}[/Alignment]
"$
	End If
	'NumWeg
	Dim Beschreibung As Object = Main.SQL.ExecQuerySingleResult("select BeschreibungNumWeg from NumWeg where NumWeg = "&NumWeg)
	If Beschreibung <> Null And Beschreibung <>"" Then
		cv.text = cv.text & _
$"[Alignment=Left][b][u][color=#e2889b]Numerologischer Weg: ${NumWeg}[/color][/u][/b][/Alignment]
[Alignment=Left]${Beschreibung}[/Alignment]
"$
	End If
	cv.Text = cv.text & _
$"
[Alignment=Center][url="https://heilseminare.com"][color=#FF69B4]heilseminare.com[/color][/url][/Alignment]
"$
dlg.Close(0)
End Sub

'private Sub makeReportZentren
'	Sleep(100)
'	'Zeigt dem Anwender einen Dialog, dass er sich etwas gedulden soll, schliesst automatisch
'	Dim delaytext As B4XTimedTemplate
'	Dim msg As B4XLongTextTemplate
'	msg.Initialize
'	msg.Text = "Bitte etwas Geduld, die Ausgabe wird erstellt!"
'	delaytext.Initialize(msg)
'	delaytext.TimeoutMilliseconds=1000
'	dlg.ShowTemplate(delaytext, "", "", "")
'	
'	Dim z As List
'	z.Initialize
'	'Ermitteln der Daten
'	Dim rs As ResultSet = Main.SQL.ExecQuery("select * from Benutzer where IdName = "&home.iduser)
'	rs.NextRow
'	For i = 0 To 8
'		Dim zId As Int = i+1
'		If rs.GetString("Z"& zId) = "j" Then
'			z.Add(True)
'		Else
'			z.Add(False)
'		End If
'	Next
'	'Zentren
'	For i = 0 To 8
'		Dim zId As Int = i+1
'		Dim rs As ResultSet = Main.SQL.ExecQuery("select * from Zentren where IdZentren ="& zId)
'		rs.NextRow
'		Dim zentrum As String = rs.getstring("Zentrum")
'		Dim beschreibungzentrum As String = rs.getstring("BeschreibungZentrum")
'		Dim defJaNein,defJaNeinText,fragen,affi As Object
'		If z.Get(i) = True Then
'			defJaNein = "DEFINIERT"
'			defJaNeinText = rs.GetString("Definiert")
'			fragen = rs.GetString("FragenDefiniert")
'			affi = rs.GetString("AffirmationDefiniert")
'		Else
'			defJaNein = "UNDEFINIERT"
'			defJaNeinText = rs.GetString("Undefiniert")
'			fragen = rs.GetString("FragenUndefiniert")
'			affi = rs.GetString("AffirmationUndefiniert")
'		End If
'		cv.Text = cv.text & _
'$"[Alignment=Left][b][u][color=#e2889b]
'Bedeutung Zentrum ${zentrum}:[/color][/u][/b][/Alignment]
'[Alignment=Left]${beschreibungzentrum}[/Alignment]
'
'[Alignment=Left][b][u]Zentrum ${zentrum} ist ${defJaNein}[/u][/b][/Alignment]
'[Alignment=Left]${defJaNeinText}[/Alignment]
'"$
'
'		If fragen <> Null And affi<>"null" And fragen <>"" Then
'cv.Text = cv.text & _
'$"[b][u]Fragen:[/u][/b]
'${fragen}
'	
'"$	
'		End If
'		If affi <>Null And affi<>"null" And affi<>"" Then
'			cv.Text = cv.text & _
'$"[b][u]Affirmationen:[/u][/b]
'${affi}"$
'		End If
'	Next
'cv.Text = cv.text & _
'$"
'[Alignment=Center][url="https://heilseminare.com"][color=#FF69B4]heilseminare.com[/color][/url][/Alignment]
'"$
'End Sub