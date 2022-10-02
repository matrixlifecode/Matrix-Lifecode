B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=11.8
@EndOfDesignText@
Sub Class_Globals
	Private Root As B4XView 'ignore
	Private xui As XUI 'ignore
	Private home As B4XMainPage
	Private spalte1 As Label
	Private spalte2 As Label
	Private clvToreder As CustomListView
	Private dlg As B4XDialog
End Sub

'You can add more parameters here.
Public Sub Initialize As Object
	Return Me
End Sub

'This event will be called once, before the page becomes visible.
Private Sub B4XPage_Created (Root1 As B4XView)
	Root = Root1
	Root.LoadLayout("Toreder")
	home = B4XPages.GetPage("MainPage")
	dlg.Initialize(Root)
End Sub

private Sub B4XPage_Appear
	home.setTitelzeile(home.storeder)
	clvToreder.Clear
	Select True
		Case home.storeder = home.translate(Main.sprache,135):fillAngstTore
		Case home.storeder = home.translate(Main.sprache,136):fillDruckTore
		Case home.storeder = home.translate(Main.sprache,137):fillFrustTore
		Case home.storeder = home.translate(Main.sprache,139):fillSchubkraft
	End Select
End Sub

Private Sub spalte_Click
	'Click auf Spalte einer Tabelle
	'in Tag ist die Information gespeichert
	'Wenn am Ende der ersten Zeile eine Farbkürzel "r,b,s" steht, dann die erste Zeile in dieser Farbe zeigen
	Dim cs As CSBuilder
	Dim o As B4XView = Sender
	Dim res As String = o.tag

	cs.Initialize.Typeface(Typeface.DEFAULT)
	Dim farbchar As Char = res.SubString2(0,2)
	If farbchar = "r." Or farbchar = "s." Or farbchar = "t." Then
		res = res.SubString(2) 'Markierung wieder löschen
		Dim posCR As Int = res.IndexOf(CRLF)
		Dim zeile1 As String = res.SubString2(0,posCR)
		zeile1=zeile1&CRLF
		Dim zeile2 As String =res.SubString(posCR+1)
		Select True
			Case farbchar = "r.":cs.color(0xFFDB7093)
			Case farbchar = "s.":cs.color(0xFF000000)
			Case farbchar = "t.":cs.color(0xFF2E2EFE)
		End Select
		cs.Append(zeile1).popall.color(0xFFA9A9A9).popall.Append(zeile2)
	Else
		cs.append(res).PopAll
	End If
	DetailinformationZeigen(cs)
End Sub

Sub DetailinformationZeigen(text As CSBuilder)
'kann es von home nicht aufrufen, da das Template sonst auf dem Hauptfenster erstellt wird und damit nicht sichtbar ist
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


Sub fillAngstTore
	'Schreibt die aktivierten Angsttore
	Dim rs As ResultSet
	Select True
		Case home.edtBody.SelectedIndex = 0 Or home.edtBody.SelectedIndex = 3: rs = Main.sql.ExecQuery("SELECT * FROM DeineAngst where RotSchwarz<>'t'")
		Case home.edtBody.SelectedIndex = 1: rs = Main.sql.ExecQuery("SELECT * FROM DeineAngst where RotSchwarz='r'")
		Case home.edtBody.SelectedIndex = 2: rs = Main.sql.ExecQuery("SELECT * FROM DeineAngst where RotSchwarz='s'")
		Case home.edtBody.SelectedIndex = 4: rs = Main.sql.ExecQuery("SELECT * FROM DeineAngst")
		Case home.edtBody.SelectedIndex = 5: rs = Main.sql.ExecQuery("SELECT * FROM DeineAngst where RotSchwarz='t'")
		Case Else: rs = Main.sql.ExecQuery("SELECT * FROM DeineAngst") 'Nur bei Aufruf ohne ausgewählten Nutzer
	End Select
	
	Do While rs.NextRow
		Dim farbe As Char = rs.GetString("RotSchwarz")
		Dim sp1 As String = rs.GetInt("IdTor")
		Dim sp1text As String = Main.SQL.ExecQuerySingleResult("Select TorBeschreibung from Hexagramme where IdTor = "&sp1)
		Dim sp2 As String = rs.GetString("Angst")
		Dim planet As String = rs.GetString("Planet")
		Dim sp2text As String = farbe&"."&planet&CRLF&sp2 'z.B. r. Chiron   das wird bei Anzeige der Spalte verwendet um Chiron rot darzustellen.
		clvToreder.Add(Createcellitem2Spalten(farbe,sp1,sp2,sp1text,sp2text),"")
	Loop
	rs.Close
End Sub

Sub fillDruckTore
	Dim rs As ResultSet
	Select True
		Case home.edtBody.SelectedIndex = 0 Or home.edtBody.SelectedIndex = 3: rs = Main.sql.ExecQuery("SELECT * FROM DeinDruck where RotSchwarz<>'t'")
		Case home.edtBody.SelectedIndex = 1: rs = Main.sql.ExecQuery("SELECT * FROM DeinDruck where RotSchwarz='r'")
		Case home.edtBody.SelectedIndex = 2: rs = Main.sql.ExecQuery("SELECT * FROM DeinDruck where RotSchwarz='s'")
		Case home.edtBody.SelectedIndex = 4: rs = Main.sql.ExecQuery("SELECT * FROM DeinDruck")
		Case home.edtBody.SelectedIndex = 5: rs = Main.sql.ExecQuery("SELECT * FROM DeinDruck where RotSchwarz='t'")
		Case Else: rs = Main.sql.ExecQuery("SELECT * FROM DeinDruck") 'Nur bei Aufruf ohne ausgewählten Nutzer
	End Select
	
	Do While rs.NextRow
		Dim farbe As Char = rs.GetString("RotSchwarz")
		Dim sp1 As String = rs.GetInt("IdTor")
		Dim sp1text As String = Main.SQL.ExecQuerySingleResult("Select TorBeschreibung from Hexagramme where IdTor = "&sp1)
		Dim sp2 As String = rs.GetString("Druck")
		Dim planet As String = rs.GetString("Planet")
		Dim sp2text As String = farbe&"."&planet&CRLF&sp2 'z.B. r. Chiron   das wird bei Anzeige der Spalte verwendet um Chiron rot darzustellen.
		clvToreder.Add(Createcellitem2Spalten(farbe,sp1,sp2,sp1text,sp2text),"")
	Loop
	rs.Close
End Sub

Sub fillFrustTore
	Dim rs As ResultSet
	Select True
		Case home.edtBody.SelectedIndex = 0 Or home.edtBody.SelectedIndex = 3: rs = Main.sql.ExecQuery("SELECT * FROM DeinFrust where RotSchwarz<>'t'")
		Case home.edtBody.SelectedIndex = 1: rs = Main.sql.ExecQuery("SELECT * FROM DeinFrust where RotSchwarz='r'")
		Case home.edtBody.SelectedIndex = 2: rs = Main.sql.ExecQuery("SELECT * FROM DeinFrust where RotSchwarz='s'")
		Case home.edtBody.SelectedIndex = 4: rs = Main.sql.ExecQuery("SELECT * FROM DeinFrust")
		Case home.edtBody.SelectedIndex = 5: rs = Main.sql.ExecQuery("SELECT * FROM DeinFrust where RotSchwarz='t'")
		Case Else: rs = Main.sql.ExecQuery("SELECT * FROM DeinFrust") 'Nur bei Aufruf ohne ausgewählten Nutzer
	End Select
	
	Do While rs.NextRow
		Dim farbe As Char = rs.GetString("RotSchwarz")
		Dim sp1 As String = rs.GetInt("IdTor")
		Dim sp1text As String = Main.SQL.ExecQuerySingleResult("Select TorBeschreibung from Hexagramme where IdTor = "&sp1)
		Dim sp2 As String = rs.GetString("FrustPotential")
		Dim planet As String = rs.GetString("Planet")
		Dim sp2text As String = farbe&"."&planet&CRLF&sp2 'z.B. r. Chiron   das wird bei Anzeige der Spalte verwendet um Chiron rot darzustellen.
		clvToreder.Add(Createcellitem2Spalten(farbe,sp1,sp2,sp1text,sp2text),"")
	Loop
	rs.Close
End Sub

Sub fillToreLiebe
	Dim rs As ResultSet
	Select True
		Case home.edtBody.SelectedIndex = 0 Or home.edtBody.SelectedIndex = 3: rs = Main.sql.ExecQuery("SELECT * FROM DeinLiebestore where RotSchwarz<>'t'")
		Case home.edtBody.SelectedIndex = 1: rs = Main.sql.ExecQuery("SELECT * FROM DeineLiebestore where RotSchwarz='r'")
		Case home.edtBody.SelectedIndex = 2: rs = Main.sql.ExecQuery("SELECT * FROM DeineLiebestore where RotSchwarz='s'")
		Case home.edtBody.SelectedIndex = 4: rs = Main.sql.ExecQuery("SELECT * FROM DeineLiebestore")
		Case home.edtBody.SelectedIndex = 5: rs = Main.sql.ExecQuery("SELECT * FROM DeineLiebestore where RotSchwarz='t'")
		Case Else: rs = Main.sql.ExecQuery("SELECT * FROM DeineLiebestore") 'Nur bei Aufruf ohne ausgewählten Nutzer
	End Select
	'Überschriften
	'clvToreder.Add(CreateUeberschrift(translate(Main.sprache,138)),"")
	
	Do While rs.NextRow
		Dim farbe As Char = rs.GetString("RotSchwarz")
		Dim sp1 As String = rs.GetInt("IdTor")
		Dim sp1text As String = Main.SQL.ExecQuerySingleResult("Select TorBeschreibung from Hexagramme where IdTor = "&sp1)
		Dim sp2 As String = rs.GetString("Liebe")
		Dim planet As String = rs.GetString("Planet")
		Dim sp2text As String = farbe&"."&planet&CRLF&sp2 'z.B. r. Chiron   das wird bei Anzeige der Spalte verwendet um Chiron rot darzustellen.
		
		clvToreder.Add(Createcellitem2Spalten(farbe,sp1,sp2,sp1text,sp2text),"")
	Loop
	rs.Close
End Sub

Sub fillSchubkraft
	Dim rs As ResultSet
	Select True
		Case home.edtBody.SelectedIndex = 0 Or home.edtBody.SelectedIndex = 3: rs = Main.sql.ExecQuery("SELECT * FROM DeineSchubkraft where RotSchwarz<>'t'")
		Case home.edtBody.SelectedIndex = 1: rs = Main.sql.ExecQuery("SELECT * FROM DeineSchubkraft where RotSchwarz='r'")
		Case home.edtBody.SelectedIndex = 2: rs = Main.sql.ExecQuery("SELECT * FROM DeineSchubkraft where RotSchwarz='s'")
		Case home.edtBody.SelectedIndex = 4: rs = Main.sql.ExecQuery("SELECT * FROM DeineSchubkraft")
		Case home.edtBody.SelectedIndex = 5: rs = Main.sql.ExecQuery("SELECT * FROM DeineSchubkraft where RotSchwarz='t'")
		Case Else: rs = Main.sql.ExecQuery("SELECT * FROM DeineSchubkraft") 'Nur bei Aufruf ohne ausgewählten Nutzer
	End Select
	
	Do While rs.NextRow
		Dim farbe As Char = rs.GetString("RotSchwarz")
		Dim sp1 As String = rs.GetInt("IdTor")
		Dim sp1text As String = Main.SQL.ExecQuerySingleResult("Select TorBeschreibung from Hexagramme where IdTor = "&sp1)
		Dim sp2 As String = rs.GetString("Turbo")
		Dim planet As String = rs.GetString("Planet")
		Dim sp2text As String = farbe&"."&planet&CRLF&sp2 'z.B. r. Chiron   das wird bei Anzeige der Spalte verwendet um Chiron rot darzustellen.
		clvToreder.Add(Createcellitem2Spalten(farbe,sp1,sp2,sp1text,sp2text),"")
	Loop
	rs.Close
End Sub

Sub Createcellitem2Spalten(farbe As Char,sp1 As String,sp2 As String,sp1text As String, sp2text As String) As Panel
	'2 Spalten zum Anzeigen
	Dim p As B4XView = xui.CreatePanel("")
	p.SetLayoutAnimated(0,0,0,100%x,40dip)
	p.LoadLayout("cellitem2Spalten")
	Select True
		Case farbe="s": spalte1.TextColor = xui.Color_black
		Case farbe="r": spalte1.TextColor = xui.Color_red
		Case farbe="t": spalte1.TextColor = xui.color_blue
	End Select
	spalte1.Text= sp1
	spalte1.Tag=sp1text
	spalte2.Text= sp2
	spalte2.Tag=sp2text
	Return p
End Sub
