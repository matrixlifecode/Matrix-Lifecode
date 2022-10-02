B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=11.2
@EndOfDesignText@
Sub Class_Globals
	Private Root As B4XView 'ignore
	Private xui As XUI 'ignore
	Private	home As B4XMainPage
	
	'Views
	Dim btnstart As Button
	Dim btnstromseitelinks,btnstromseiterechts As Button
	Dim detailStrom As WebView
	#if b4j
		Private jfx1 As JFX
	#else
		Dim svStrom As ScrollView
		Dim pnlStrom As Panel
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
	home = B4XPages.GetPage("MainPage")
	Root.LoadLayout("stromdetail")
	#if b4a
		svStrom.Panel.LoadLayout("strompanel")
		svStrom.Panel.Height = pnlStrom.Height
	#end if
	#if b4j
		Dim F As Form = B4XPages.GetNativeParent(Me)
		F.WindowWidth = 650
		F.WindowHeight= jfx1.PrimaryScreen.MaxY - jfx1.PrimaryScreen.MinY
		F.WindowTop = jfx1.PrimaryScreen.MinY
	#end if
End Sub

Sub B4xPage_Appear
	Dim titelzeile As String = home.aktuellerstrom
	B4XPages.SetTitle(Me,titelzeile)
	zeigeReihe
End Sub

Sub zeigeReihe                       'zeigt den Strom dessen Name unter home.aktuellerstrom gespeichert ist.
Dim s,sqlstring As StringBuilder
Dim nummer As Int
	
If btnstromseiterechts.Tag = "L" Then
	home.stromseite = "b"
	btnstromseiterechts.Visible = True
	btnstromseitelinks.Visible = False
Else
	home.stromseite = "a"           'rechter Strom
	btnstromseiterechts.Visible = False
	btnstromseitelinks.Visible = True
End If
	
sqlstring.Initialize
	
sqlstring.Append("select strom.sitze,strom.Stromseite,strom.bildwechsel,strom.step,strom.hand,strom.seite,strom.nummer,strom.position,punkte.grafik,punkte.bezeichnung from strom,punkte where strom.bezeichnung='").Append(home.aktuellerstrom.trim).Append("' and strom.Stromseite = '").Append(home.stromseite).Append("' and strom.nummer = punkte.nummer")
sqlstring.Append(" and strom.hand = punkte.hand and strom.seite = punkte.seite and strom.position = punkte.position order by strom.bildwechsel asc")
	
home.cursordetail = Main.sql.ExecQuery(sqlstring.ToString)
'	Dim Senderfilter As Object = code.sql1.ExecQueryAsync("SQL",sqlstring, Null)
'	Wait For (Senderfilter) SQL_QueryComplete (Success As Boolean, Starter.cursordetail As Cursor)

sqlstring.initialize
sqlstring.append("select text from strombezeichnungen where bezeichnung='").append(home.aktuellerstrom.trim).append("'")
Dim beschreibung As String = Main.sql.ExecQuerySingleResult(sqlstring.tostring)
  	
s.Initialize
If btnstromseiterechts.Tag = "L" Then
	s.Append("<html><body>Linker Strom</br>")
Else
	s.Append("<html><body>Rechter Strom</br>")
End If
s.Append("<table border=&quot;1&quot;><tr><th>Schritt</th><th>Hand</th><th>Seite</th><th>Tor</th><th>Position</th></tr>")

Do While home.cursordetail.NextRow
	
	
'		Dim anzahl = home.cursordetail.RowCount
'		For i = 0 To anzahl - 1
'		home.cursordetail.Position = i
	
	If home.cursordetail.getstring("Stromseite")=home.stromseite Then
		s.Append("<tr><td>").Append(home.cursordetail.GetString("step")).append("</td><td>").append(home.cursordetail.GetString("hand"))
		nummer = home.cursordetail.getstring("nummer")
		If nummer <= 26 Then
			Log("Zeigen Hand:"&home.cursordetail.GetString("hand")&"Seite:"&home.cursordetail.GetString("seite")&"Nummer:"&home.cursordetail.GetString("nummer")&home.cursordetail.GetString("position"))
			s.Append("</td><td>").Append(home.cursordetail.GetString("seite")).append("</td><td>").append(home.cursordetail.GetString("nummer")).append("</td><td>").append(home.cursordetail.GetString("position")).append("</td></tr>")
		Else
			s.Append("</td><td>").Append(home.cursordetail.GetString("seite")).append("</td><td>").append(home.cursordetail.GetString("bezeichnung")).append("</td><td>").append(home.cursordetail.GetString("position")).append("</td></tr>")
		End If
	End If
	'Next
Loop
s.Append(CRLF).append(CRLF).Append("</table></html></body>")
	
If beschreibung=Null Then beschreibung="DetailVorlage.html"
	
#if b4j
	If File.Exists("..\files\",beschreibung) Then
		s.append(File.ReadString("..\files\",beschreibung))
	End If
#else
	If File.Exists(File.dirassets,beschreibung) Then
	 	 s.append(File.GetText(File.Dirassets,beschreibung))
	End If
#End If

detailStrom.loadhtml(s)
End Sub

Sub btnstromseiterechts_click
	btnstromseiterechts.tag = ""
	zeigeReihe
End Sub

Sub btnstromseitelinks_click
	btnstromseiterechts.tag = "L"
	zeigeReihe
End Sub

'startet die Bilderfolge des aktuellen Stromes
Sub btnStart_Click
	B4XPages.ShowPage("stromspielen")
End Sub
