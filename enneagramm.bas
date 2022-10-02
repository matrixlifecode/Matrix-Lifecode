B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=10.2
@EndOfDesignText@
Sub Class_Globals
	Private Root As B4XView 'ignore
	Private xui As XUI 'ignore
	Private homepage As B4XMainPage
	Private clv1 As CustomListView
	Private ImageView1 As B4XView
	Private lAnzahl As B4XView
	Private lName As B4XView
	Private lTyp As B4XView
	Private ITeam As ZoomImageView
	Private textengine As BCTextEngine
	Private BBCodeView1 As BBCodeView
End Sub

'You can add more parameters here.
Public Sub Initialize As Object
	Return Me
End Sub

'This event will be called once, before the page becomes visible.
Private Sub B4XPage_Created (Root1 As B4XView)
	Root = Root1
	Root.LoadLayout("kabinett")
	homepage = B4XPages.GetPage("MainPage")  'Verweis auf Startseite um auf edtbody zuzugreifen
	homepage.setTitelzeile(homepage.translate(Main.sprache,5))
End Sub

Sub B4XPage_Appear
	Dim defteam As String = homepage.translate(Main.sprache,68) 'Dein inneres Team
	B4XPages.SetTitle(Me, defteam)
	kabinettErstellen
End Sub


'Erstellt die Listview
Sub kabinettErstellen
	clv1.Clear
	Dim homepage As B4XMainPage = B4XPages.GetPage("MainPage")
	#if b4j
		ITeam.SetBitmap(xui.LoadBitmap("../files/","enneagrammkabinett.png"))
	#else
		ITeam.SetBitmap(xui.LoadBitmap(File.dirassets,"enneagrammkabinett.png"))
	#End If
	Select True
		Case homepage.edtBody.SelectedIndex=1: 'Design
			Dim Query As String = "SELECT * from EnneagrammKabinett where RotSchwarz='r'"
		Case homepage.edtBody.SelectedIndex=2: 'Persönlichkeit
			Dim Query As String = "SELECT * from EnneagrammKabinett where RotSchwarz='s'"
		Case homepage.edtBody.SelectedIndex=0 Or homepage.edtBody.SelectedIndex=3: 'Persönlichkeit & Design
			Dim Query As String = "SELECT * from EnneagrammKabinett where RotSchwarz='s' or RotSchwarz='r'"
		Case Else	'mit Transite
			Dim Query As String = "SELECT * from EnneagrammKabinett"
	End Select
	
		
	Dim rs As ResultSet = Main.sql.ExecQuery(Query)
	Do While rs.NextRow
		Dim idenne As Int = rs.GetInt("IdEnneagramm")
		Dim anzahl As Int = rs.GetInt("Anzahl")
		Dim name As String= Main.SQL.ExecQuerySingleResult("Select Name from Enneagramm where IdEnneagramm=" & idenne)
		
		Dim pnl As B4XView = CreateListItem(idenne ,anzahl, name, clv1.AsView.Width, 50dip)
		clv1.Add(pnl,"Enneagrammtyp")
	Loop
End Sub


#if b4j 
	Sub CreateListItem(id As Int, anzahl As Int, name As String, width As Int, height As Int) As Pane
#else
	Sub CreateListItem(id As Int, anzahl As Int, name As String, width As Int, height As Int) As Panel
#end if
	Dim p As B4XView = xui.CreatePanel("")
	p.SetLayoutAnimated(0, 0, 0, width, height)
	p.LoadLayout("cellitemEnne")

	Select True
		Case id = 1: ImageView1.SetBitmap(xui.LoadBitmapResize(File.Dirassets,"enne1.png",70dip, 50dip, False))
		Case id = 2: ImageView1.SetBitmap(xui.LoadBitmapResize(File.Dirassets,"enne2.png",70dip, 50dip, False))
		Case id = 3: ImageView1.SetBitmap(xui.LoadBitmapResize(File.Dirassets,"enne3.png",70dip, 50dip, False))
		Case id = 4: ImageView1.SetBitmap(xui.LoadBitmapResize(File.Dirassets,"enne4.png",70dip, 50dip, False))
		Case id = 5: ImageView1.SetBitmap(xui.LoadBitmapResize(File.Dirassets,"enne5.png",70dip, 50dip, False))
		Case id = 6: ImageView1.SetBitmap(xui.LoadBitmapResize(File.Dirassets,"enne6.png",70dip, 50dip, False))
		Case id = 7: ImageView1.SetBitmap(xui.LoadBitmapResize(File.Dirassets,"enne7.png",70dip, 50dip, False))
		Case id = 8: ImageView1.SetBitmap(xui.LoadBitmapResize(File.Dirassets,"enne8.png",70dip, 50dip, False))
		Case id = 9: ImageView1.SetBitmap(xui.LoadBitmapResize(File.Dirassets,"enne9.png",70dip, 50dip, False))
	End Select
	lAnzahl.Text = anzahl
	lName.Text = name
	lTyp.Text = id
	Return p
End Sub

#if B4j
	Sub lName_MouseClicked (EventData As MouseEvent)
#else
	Sub	lName_Click
#end if
	Dim index As Int = clv1.GetItemFromView(Sender)
	Dim pnl As B4XView = clv1.GetPanel(index)
	Dim name As B4XView = pnl.GetView(4) 'Name Position in CellitemEnne
	Dim typ As B4XView = pnl.GetView(3) 'Typ Position in CellitemEnne
	Dim Query As String = "Select Beschreibung from Enneagramm where IdEnneagramm=" & typ.text
	Dim etext As String = Main.SQL.ExecQuerySingleResult(Query)
	If name.Tag = "j" Then 'schon eingeblendet -> ausblenden
		clv1.RemoveAt(index+1)
		name.Tag = ""
	Else
		clv1.InsertAt(index+1,CreateBBItem(etext),"-1")
		'clv1.InsertAtTextItem(index+1,etext,"-1")
		name.Tag = "j"
	End If
End Sub

#if b4j 
	Sub CreateBBItem(code As String) As Pane
#else
	Sub CreateBBItem(code As String) As Panel
#end if
	Dim p As B4XView = xui.CreatePanel("")
	p.LoadLayout("cellitemBBItem")
	textengine.Initialize(p)
	textengine.KerningEnabled = True
	BBCodeView1.TextEngine.WordBoundaries= "&*+-/<>=\' :{}" & TAB & CRLF & Chr(13)
	code = code.Replace(Chr(194),"").Replace(Chr(173),"") 'c2 ad kommt unsichtbar aus der Datenbank
	Dim codestr As String = $"[Alignment=left]${code}[/alignment]"$
	BBCodeView1.Text = codestr

	If BBCodeView1.Paragraph.IsInitialized Then
		Dim ContentHeight As Int = Min(BBCodeView1.Paragraph.Height / textengine.mScale + BBCodeView1.Padding.Top + BBCodeView1.Padding.Bottom, BBCodeView1.mBase.Height)
		BBCodeView1.mBase.Height = ContentHeight
		BBCodeView1.sv.ScrollViewContentHeight = ContentHeight
		BBCodeView1.UpdateVisibleRegion(0,ContentHeight)
	End If
	p.SetLayoutAnimated(0, 0, 0, clv1.sv.width, ContentHeight )
	Return p
End Sub