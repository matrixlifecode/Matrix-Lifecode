B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=8.5
@EndOfDesignText@
Sub Class_Globals
	Private Root As B4XView 'ignore
	Private xui As XUI 'ignore
	#If b4j
		Private fx As JFX
	#end if
	#if b4a
		Private clip As BClipboard
	#End If
	Private homepage As B4XMainPage
	'Private tm As BCToast
	Private dlg As B4XDialog
	Private dlgblob	As PreferencesDialog
	'Table
	Public dbTable As B4XTable
	Private TableData As List          			    'List to add in the dbTable information
	Private RowIDList As List						'Stores the RowList IDs
	Private headers As List							'holds list of headers
	
'	Private OldRow As Long							'Used for colour changes
'	Private SelectionColor As Int = 0xFF009DFF		'Row colour on select
	Private RowIDSelected As Long					'global long value for row selected
	Private ColIDSelected As String					'global stringvalue for name of column selected

'	Private MouseX As Int										'Mouse Click location
'	Private MouseY As Int
	
	Private mcvs As B4XCanvas
	Private alleSpalten As List
	
'	Private AddList As List									'Used for the add row list
	'Move Row buttons
'	Private btnUp As Button
'	Private btnDown As Button
	#If b4j
		Private pnledit As Pane
	#Else
		Private pnledit As B4XView
	#end if
End Sub


'You can add more parameters here.
Public Sub Initialize As Object
	Return Me
End Sub

Private Sub B4XPage_Created (Root1 As B4XView)
	Root = Root1
	#if b4j
		Dim F As Form = B4XPages.GetNativeParent(Me)
		F.WindowWidth = fx.PrimaryScreen.MaxX - fx.PrimaryScreen.MinX           'set the screen to full width/height
		F.WindowLeft = fx.PrimaryScreen.MinX
		F.WindowHeight= fx.PrimaryScreen.MaxY - fx.PrimaryScreen.MinY
		F.WindowTop = fx.PrimaryScreen.MinY
	#end if
	Root.LoadLayout("Zeigen")
	dlg.Initialize(Root)
	homepage = B4XPages.GetPage("MainPage")  'Verweis auf Startseite um dort Label zu aktualisieren
	dlg.Initialize(Root)
	mcvs.Initialize(pnledit) 'Zur Messung der erforderlichen Textbreite
End Sub

private Sub B4XPage_Appear
	dbTable.Clear
	Select True
		Case Main.Mode = "Person":
			B4XPages.SetTitle(Me, "Person auswählen")
		Case Main.Mode = "Auswertung":
			B4XPages.SetTitle(Me, "Auswertung")
		Case Main.Mode = "Tabelle":
			B4XPages.SetTitle(Me, "Tabellen bearbeiten")
	End Select
	headers.Initialize
	CreateDBTable
	LoadB4xTableData(Main.DBName,Main.TotColNumber)     'loads TableData from dbTable
	LoadData																				'loads into b4X table
	StoreRecordIDs																	'rowid in dbtable always stays the same, even if	a line is deleted
	dbTable.NumberOfFrozenColumns=Main.FrozenCols
	dbTable.Refresh
End Sub

Sub B4XPage_Disappear 
	'Informationen auf Hauptseite aktualisieren
	'homepage.AktualisiereHauptseite(homepage.iduser)
	dbTable.SearchField.TextField.Text = ""  'löscht den Inhalt vom Search Feld
End Sub

' Erstellt die Tabelle zum Bearbeiten
Sub CreateDBTable
'	dbTable.MaximumRowsPerPage=Main.FrozenCols
	dbTable.ArrowsEnabledColor=0xFFD2691E
	
	alleSpalten.Initialize
	For i = 0 To Main.TotColNumber - 1
		Select True
			Case Main.ColDataTypes(i) = "TEXT":
				Dim StateColumn As B4XTableColumn = dbTable.AddColumn(Main.ColNames(i), dbTable.COLUMN_TYPE_TEXT)
				#if b4a	'besser lesbar
					StateColumn.Width = 160dip
				#End If
				alleSpalten.Add(StateColumn)
				'alleSpalten.add(dbTable.AddColumn(Main.ColNames(i), dbTable.COLUMN_TYPE_TEXT))
			Case Main.ColDataTypes(i) = "INT" Or Main.ColDataTypes(i) = "REAL":
				alleSpalten.Add(dbTable.AddColumn(Main.ColNames(i), dbTable.COLUMN_TYPE_NUMBERS))
			Case Main.ColDataTypes(i) = "DATE":
				alleSpalten.add(dbTable.AddColumn(Main.ColNames(i), dbTable.COLUMN_TYPE_DATE))
			Case Else
				Dim StateColumn As B4XTableColumn = dbTable.AddColumn(Main.ColNames(i), dbTable.COLUMN_TYPE_TEXT)
				#if b4a	'besser lesbar
					StateColumn.Width = 160dip
				#End If
				alleSpalten.Add(StateColumn)
				'alleSpalten.add(dbTable.AddColumn(Main.ColNames(i), dbTable.COLUMN_TYPE_TEXT))
		End Select
		
	Next
End Sub
    
Sub SetColumnAlignment(columnID As String, alignmentV As String, alignmentH As String)
	Dim column As B4XTableColumn = dbTable.GetColumn(columnID)
	For i = 1 To column.CellsLayouts.Size - 1        'starts at 1 due to header
		Dim pnl As B4XView = column.CellsLayouts.Get(i)
		pnl.GetView(0).SetTextAlignment(alignmentV, alignmentH)
	Next
End Sub

'Load Tabledata list from SQL database table
Public Sub LoadB4xTableData(DBname As String,TotColNo As Int)
	TableData.Initialize
	Dim rs As ResultSet
	B4XPages.SetTitle(Me, "Bearbeite Tabelle " & DBname)
	Dim Query As String = "SELECT * FROM " & DBname
	rs = Main.SQL.ExecQuery(Query)
	Do While rs.NextRow
		Dim row(TotColNo) As Object
		For i = 0 To TotColNo-1
			row(i) = rs.GetString(Main.ColNames(i))
			If row(i) = Null Then	 
				row(i) = ""					'Null- Wert bringt Suchfunktion zum Absturz
			End If
		Next
		TableData.Add(row)
	Loop
	rs.Close
End Sub

'Loads b4XTable from TableData list
Sub LoadData
	dbTable.SetData(TableData)
	dbTable.Refresh
End Sub

'=======================================================================
'Reads the Database Rowid's into RowIDList
'=======================================================================
Sub StoreRecordIDs
	'Log("---Store Row IDs---")
	RowIDList.Initialize										'initialize the rowID list
	Private rs As ResultSet
	rs = Main.SQL.ExecQuery("SELECT RowID FROM "&Main.DBName)
	Do While rs.NextRow
		RowIDList.Add(rs.GetString2(0))								'add the rowid's to the rowID list
	Loop
	rs.Close															'close the ResultSet, we don't need it anymore
End Sub

'=======================================================================
' b4xTable Recovery to SQL table
'=======================================================================
'Save the B4XTable database back to SQL dbTable file
'Sub SaveB4XTableData(DBName As Object)
'	'Log("Save B4x Table Data")
'	Dim ExistingData As List
'	ExistingData.Initialize
'	'clears old data
'	SQLUtil.DeleteDataSQLTable(Main.SQL,DBName)     ' deletes the old dbtable
'    
'	'loads table data to rowlist
'	Dim o() As Object = dbTable.BuildQuery(False)
'	Dim rs As ResultSet = dbTable.sql1.ExecQuery2(o(0),o(1))
'	Do While rs.NextRow
'		Dim RowList As List
'		RowList.Initialize
'		For i = 1 To Main.TotColNumber          				' Column numbers a 1 to ............
'			Dim Cell As String = rs.GetString2(i)   	 		' returns string of cells in columns
'			RowList.Add(Cell)                       						' adds to the rowlist
'		Next
'		ExistingData.Add(RowList)									' adds on rows
'	Loop
'	'Saves each row to DB
'	For RowNo = 0 To ExistingData.Size-1
'		Dim RowList As List = ExistingData.Get(RowNo)                ' Gets total row information
'		SQLUtil.AddRowValues (Main.SQL,DBName, Main.TotColNumber, RowList)
'	Next
'End Sub

'=======================================================================
'ROW SELECTION AND COLOUR CHANGE
'=======================================================================
'Responds to any touch on screen
'Action= 0 = pressed  X and Y are locations
'Sub frm_Touched (Action As Int, X As Float, Y As Float)
''	If Action = 0 Then
'	MouseX=X
'	If MouseX>Root.Width-200dip Then
'		MouseX=Root.Width-220dip          ' Allows editbox to remain on screen
'	End If
'	MouseY=Y
''	End If
'	'Log(MouseX & "   "& MouseY)
'End Sub

'Decides colour change of the row, and deletes colour on previous selected row
'Sub RowChangeColourSelect
'	Dim Index As Int
'	Index=dbTable.VisibleRowIds.IndexOf(RowIDSelected)
'	Select True
'		Case RowIDSelected = OldRow                                 'Same so remove
'			SetRowColor(Index, False)
'		Case RowIDSelected<>OldRow
'			SetRowColor(Index, True)								'change colour
'			Index=dbTable.VisibleRowIds.IndexOf(OldRow)             'remove the old colour
'			SetRowColor(Index, False)
'			OldRow=RowIDSelected
'	End Select
'End Sub

 'Sets the color of the row
'Sub SetRowColor(RowIndex As Int, Selected As Boolean)
'	'Log("Set Row Colour")
'	Dim clr As Int
'	If Selected Then
'		clr = SelectionColor
'	Else If RowIndex Mod 2 = 0 Then
'		clr = dbTable.EvenRowColor
'	Else
'		clr = dbTable.OddRowColor
'	End If
'	If RowIndex>-1 Then
'		For Each c As B4XTableColumn In dbTable.VisibleColumns
'			Dim pnl As B4XView = c.CellsLayouts.Get(RowIndex + 1) '+1 because of the header
'			pnl.Color = clr
'		Next
'	End If
'End Sub

'Clears row highlight colour on each page change
'Index =-1 on page change
'Zeilenbreite anpassen bei Nummernfelder
Sub DBTable_DataUpdated
'	Dim clr As Int
'	Dim Index As Int
'	Index=dbTable.VisibleRowIds.IndexOf(RowIDSelected)
'	If Index =-1 Then
'		For i = 0 To dbTable.VisibleRowIds.Size-1
'			If i Mod 2 = 0 Then
'				clr = dbTable.EvenRowColor
'			Else
'				clr = dbTable.OddRowColor
'			End If
'		Next
'		OldRow=1
'	End If
	
	'Resize Zeilenbreite an benötigte Breite anpassen
	'https://www.b4x.com/android/forum/threads/b4x-b4xtable-resize-columns-based-on-content.102678/#content
	Dim ShouldRefresh As Boolean
	Dim spalte As Int = 0
	For Each column As B4XTableColumn In alleSpalten
		If Main.ColNames(spalte).Contains("Beschreibung") Or Main.ColNames(spalte).Contains("Geburtsdatum") Or Main.ColNames(spalte).Contains("Geburtszeit") Or Main.ColNames(spalte).Contains("Bedeutung") Or Main.ColNames(spalte).Contains("Bezeichnung") Or Main.ColNames(spalte).Contains("Angst") Or Main.ColNames(spalte).Contains("Liebe")Or Main.ColNames(spalte).Contains("Druck") Or Main.ColNames(spalte).Contains("Frust") Or Main.ColNames(spalte).Contains("Turbo")Then
			'Ausrichtung Links ohne Breite messen und anpassen
			SetColumnAlignment(Main.colnames(spalte), "CENTER", "CENTER")
			Continue
		End If
			Dim MaxWidth As Int = 0
			For i = 0 To dbTable.VisibleRowIds.Size - 1
				Dim RowId As Long = dbTable.VisibleRowIds.Get(i)
				If RowId > 0 Then
					Dim pnl As B4XView = column.CellsLayouts.Get(i+1)
					Dim lbl As B4XView = pnl.GetView(0)
					Dim txt As String = dbTable.GetRow(RowId).Get(column.Id)
					Dim r As B4XRect = mcvs.MeasureText(txt, lbl.Font)
					MaxWidth = Max(MaxWidth, r.Width + 20)
				End If
			Next		'Nach der Messung des Maximalwertes der sichtbaren Reihen einer Spalte wird der Wert angepasst
			'das kann bei PC und Android unterschiedlich ausfallen
			If MaxWidth > column.ComputedWidth Or MaxWidth < column.ComputedWidth - 40dip Then
				column.Width = MaxWidth + 4dip
				ShouldRefresh = True
			End If
			spalte = spalte + 1
	Next
	
	If ShouldRefresh Then
		dbTable.Refresh
	End If
End Sub


'Changes the value to a cell at the record and column selected
'Diese Zelle wird auch gleich in der Datenbank aktualisiert
Sub SaveCellData (Value As String, RowNo As Int, ColName As String)
	Dim column As B4XTableColumn = dbTable.GetColumn(ColName)
	'Mit folgender Zeile wird eine Zelle der internen Tabelle data aktualisiert
	dbTable.sql1.ExecNonQuery2($"UPDATE data SET ${column.SQLID} = ? WHERE rowid = ?"$, Array As String(Value, RowNo))
	Dim x As Int = dbTable.CurrentPage
	dbTable.ClearDataView								 'Updates the rows count.
	dbTable.CurrentPage=x								 'Stays at same page
	'Update des Feldes in der aktuellen Datenbank main.dbname
	'Dim index As Int = RowIDIndex(RowNo)
	Dim index As Int = RowIDList.Get(RowNo-1)
	Main.SQL.ExecnonQuery2($"UPDATE ${Main.DBName} SET ${ColName} = ? WHERE rowid = ?"$, Array As String(Value, index))
End Sub


'Gets CELL data for display on the edit text box
Sub GetCellData(RowNo As Int, ColString As String) As String
    Dim RowData As Map = dbTable.GetRow(RowNo)
	Dim Cell As String = RowData.Get(ColString)
	Return Cell
End Sub

'Seitengroesse wird verändert
Sub B4XPage_Resize (Width As Double, Height As Double)

End Sub

Sub DBTable_HeaderClicked (ColumnId As String)
	ColIDSelected = ColumnId
End Sub

'=======================================================================
' Move Buttons
'=======================================================================
' Returns the index of the RowID in the RowIDlist
'Sub RowIDIndex(RowID As Long) As Long
'	For i=0 To RowIDList.Size-1
'		If RowID = RowIDList.Get(i) Then
'			Return i
'		End If
'	Next
'	Return -1
'End Sub

Sub DeleteRow (tbl As B4XTable, RowId As Long)
	tbl.sql1.ExecNonQuery2("DELETE FROM data WHERE rowid = ?", Array (RowId))
	Dim page As Int = tbl.CurrentPage
	Dim FirstIndex As Int = tbl.FirstRowIndex
	tbl.ClearDataView 'Updates the rows count.
	If FirstIndex + 1 >= tbl.mCurrentCount Then
		page = page - 1
	End If
	tbl.CurrentPage = page
End Sub

Sub DBTable_CellLongClicked (ColumnId As String, RowID As Long)
	'Rechtsclick in B4J, Longclick in B4A
	'Zeile löschen oder Inhalte spielen bzw. anzeigen (MP3 oder PDF)
	
	Dim sf As Object = xui.Msgbox2Async("Zeile löschen?", "", "Yes", "Nein, nur Inhalt anzeigen", "Zurück", Null)
	Wait For (sf) Msgbox_Result (Result As Int)
	If Result = xui.DialogResponse_Positive Then
		DeleteRow(dbTable, RowID)
		Return
	End If
	If Result = xui.DialogResponse_Negative Then Return
	
	'Sonst Inhalte anzeigen oder spielen
	If Sammlung.CheckNetConnections = False Then
		xui.MsgboxAsync(homepage.translate(Main.sprache,76),"Check Internet")
		Return
	End If
	
	If ColumnId ="Mp3Dateiname" Then 'Inhalt mit Standardprogramm spielen
		Dim inhalt As String = GetCellData(RowID,"Mp3Dateiname")
	End If
	If ColumnId="PdfDateiname"  Then 'Inhalt mit Standardprogramm anzeigen
		Dim inhalt As String = GetCellData(RowID,"PdfDateiname")
	End If
	If ColumnId.Contains("Mp3Inhalt")  Then
		Dim id As Int = GetCellData(RowID,ColumnId)
		Dim inhalt As String = Main.SQL.ExecQuerySingleResult("Select Mp3Dateiname from Mp3Inhalte where IdMp3="&id)
	End If
	If ColumnId.Contains("PdfInhalt")  Then
		Dim id As Int = GetCellData(RowID,ColumnId)
		Dim inhalt As String = Main.SQL.ExecQuerySingleResult("Select PdfDateiname from PdfInhalte where IdPdf="&id)
	End If
	#if b4j
		fx.ShowExternalDocument("https://heilseminare.com/meditationen/"&inhalt) 'Anzeige im externen Standard PDF- Viewer
	#else
		Dim p As PhoneIntents
		StartActivity(p.OpenBrowser("https://heilseminare.com/meditationen/"&inhalt))
	#end if
End Sub

Sub auswahlListe (query As String,feldname As String)
'Die Auswahlliste wird mit den Ergebnissen der query angezeigt
'Bei query = "" ist die Liste l bereits befüllt
Dim auswahlInhalt As B4XSearchTemplate
Dim inhalt As String
Dim inhalte As List

auswahlInhalt.Initialize
inhalte.Initialize


'Abfrage starten
Dim Cursor As ResultSet
Cursor = Main.sql.ExecQuery(query)
Do While Cursor.NextRow
	'Auswahlliste erzeugen
	If feldname = "" Then 'Identischer Feldname
		inhalte.Add(Cursor.GetString(ColIDSelected))
	Else
		inhalte.Add(Cursor.GetString(feldname))
	End If
Loop
'Auswahlliste anzeigen
auswahlInhalt.SetItems(inhalte)

Wait For (dlg.ShowTemplate(auswahlInhalt, "", "", "Keine")) Complete (Result As Int)
If Result = xui.DialogResponse_Positive Then 
	inhalt = auswahlInhalt.SelectedItem
	SaveCellData(inhalt,RowIDSelected,ColIDSelected) 'Inhalt speichern
End If

End Sub

Sub DBTable_CellClicked (ColumnId As String, RowID As Long)
'Eine Zelle wird geklickt
'Bis auf einige Felder in Tabelle Benutzer werden die anderen Inhalte nach  Abfragen in einer Msgbox angezeigt.
	Dim query As String
	
	RowIDSelected= RowID											' Assigns to global constant
	ColIDSelected= ColumnId
	Dim feldname As String = ""
	Dim l As List
	l.Initialize
	If Main.Mode = "Tabelle" Then 'Beim Editieren von Tabellen kann man nach Click den Inhalt ändern oder bei einigen Feldern auswählen
		Select True
			Case Main.DBName="Benutzer" And ColIDSelected = "HDTyp":	query = "Select HDTyp from HDTyp"
			Case Main.DBName="Benutzer" And ColIDSelected = "Autoritaet": query = "Select Autoritaet from HDAutoritaet"
			Case Main.DBName="Benutzer" And ColIDSelected = "Profil": query = "Select Profil from HDProfil"
			Case Main.DBName="Benutzer" And ColIDSelected = "HDErnaehrung": query = "Select HDErnaehrung from HDErnaehrung"
			Case Main.DBName="Benutzer" And ColIDSelected = "Szene":query = "Select Szene from Szene"
			Case Main.DBName="Benutzer" And ColIDSelected = "Motivation":query = "Select Motivation from Motivation"
			Case Main.DBName="Benutzer" And ColIDSelected = "Kognition":query = "Select Kognition from Kognition"
				
			'Case Main.DBName="MeridianeBehandlung" And ColIDSelected = "meridian":query = "Select meridian from Meridiane"
				'Case Main.DBName="MeridianeBehandlung" And ColIDSelected = "kat":query = "Select kat from MeridianeBehandlungKategorien"
				'Case Main.DBName="MeridianeBehandlung" And ColIDSelected = "kat":query = "Select kat from MeridianeBehandlungKategorien"
			Case Main.DBName="Benutzer" And ColIDSelected = "HDInkarnationskreuz":
				query = "Select InName from InKreuz"
				feldname = "InName"
		End Select
		If query <> "" Then
			 auswahlListe(query,feldname)
		Else
			editTabellenfeld 'Wenn es keine Informationen zum Auswählen sind, dann editieren
		End If
	Else 					'Es werden nur Informationen angezeigt
		Dim query As String
		Dim longtext As B4XLongTextTemplate
		longtext.Initialize
		Dim details As Boolean = True	
		Dim sel As String
		
		sel = GetCellData(RowIDSelected,ColIDSelected)
		Select True
			Case ColIDSelected = "IdTor" Or ColIDSelected = "TorName" Or ColIDSelected = "HarmTor"
				Dim intTor As Int = GetCellData(RowIDSelected,"IdTor")
				query = "Select * from Hexagramme where IdTor=" & intTor
				Dim Cursor As ResultSet
				Cursor = Main.sql.ExecQuery(query)
				Do While Cursor.NextRow
					longtext.Text = "Tor: " & intTor & " "& Cursor.GetString("TorName") & CRLF & CRLF & Cursor.Getstring("TorBeschreibung")
				Loop
			Case ColIDSelected = "Planet":
				Dim charRotSchwarz As Char = GetCellData(RowIDSelected,"RotSchwarz")
				If charRotSchwarz = "r" Then
					query = "Select distinct BeschreibungR from Planeten where Planet='" & sel & "'"
				Else
					query = "Select distinct BeschreibungS from Planeten where Planet='" & sel & "'"
				End If
				longtext.Text = "Planet: " & sel & CRLF & CRLF & Main.sql.ExecQuerySingleResult(query)
			Case ColIDSelected = "HDTyp":
				query = "Select distinct BeschreibungHDTyp from HDTyp where HDTyp='" & sel & "'"
				longtext.Text =  Main.sql.ExecQuerySingleResult(query)
			Case ColIDSelected = "Sternzeichen":
				query = "Select distinct BeschreibungSternzeichen from Sternzeichen where Sternzeichen='" & sel & "'"
				longtext.Text =  Main.sql.ExecQuerySingleResult(query)
			Case ColIDSelected = "Gabe": 'Beschreibung der Gabefrequenz
				Dim intTor As Int = GetCellData(RowIDSelected,"IdTor")
				query = "Select distinct GabeBeschreibung from Hexagramme where  IdTor=" & intTor
				longtext.Text =  Main.sql.ExecQuerySingleResult(query)
			Case ColIDSelected = "Druck": 
				Dim intTor As Int = GetCellData(RowIDSelected,"IdTor")
				query = "Select distinct Druck from ViewToreDruck where  IdTor=" & intTor
				longtext.text = Main.sql.ExecQuerySingleResult(query)
			Case ColIDSelected = "Angst": 
				Dim intTor As Int = GetCellData(RowIDSelected,"IdTor")
				query = "Select distinct Angst from ViewToreAngst where  IdTor=" & intTor
				longtext.text = Main.sql.ExecQuerySingleResult(query)
			Case ColIDSelected = "Liebe": 
				Dim intTor As Int = GetCellData(RowIDSelected,"IdTor")
				query = "Select distinct Liebe from ViewToreLiebe where  IdTor=" & intTor
				longtext.text = Main.sql.ExecQuerySingleResult(query)
				longtext.text = Main.sql.ExecQuerySingleResult(query)
			Case ColIDSelected = "Turbo":
				Dim intTor As Int = GetCellData(RowIDSelected,"IdTor")
				query = "Select distinct Turbo from ViewToreTurbo where  IdTor=" & intTor
				longtext.text = Main.sql.ExecQuerySingleResult(query)
			Case ColIDSelected = "Siddhi": 'Beschreibung derSiddhifrequenz
				Dim intTor As Int = GetCellData(RowIDSelected,"IdTor")
				query = "Select distinct SiddhiBeschreibung from Hexagramme where  IdTor=" & intTor
				longtext.Text =  Main.sql.ExecQuerySingleResult(query)
			Case ColIDSelected = "Rollen":
				query = "Select distinct RollenBeschreibung from Rollen where Rollen='" &sel & "'"
				longtext.Text =  Main.sql.ExecQuerySingleResult(query)
			Case ColIDSelected = "Haus":
				query = "Select distinct HausBeschreibung from Haus where IdHaus='" &sel & "'"
				longtext.Text =  Main.sql.ExecQuerySingleResult(query)
			Case ColIDSelected = "Element":
				query = "Select distinct ElementBeschreibung from Elemente where Element='" &sel & "'"
				longtext.Text =  Main.sql.ExecQuerySingleResult(query)
			Case ColIDSelected = "Zentrum":
				query = "Select distinct BeschreibungZentrum from Zentren where Zentrum='" &sel & "'"
				longtext.Text =  Main.sql.ExecQuerySingleResult(query)
			Case ColIDSelected = "Kanal" Or ColIDSelected = "BeschreibungKanal" Or ColIDSelected = "Name"
				Dim kanalA As Int = GetCellData(RowIDSelected,"KanalA")
				Dim kanalB As Int = GetCellData(RowIDSelected,"KanalB")
				query = "Select distinct BeschreibungKanal from Kanaele where KanalA=" & kanalA & " And kanalB="&kanalB
				longtext.Text =  Main.sql.ExecQuerySingleResult(query)
			Case ColIDSelected = "KanalA" Or ColIDSelected = "KanalB"
				Dim intKanal As Int = sel
				query = "Select * from Hexagramme where IdTor=" & intKanal
				Dim Cursor As ResultSet
				Cursor = Main.sql.ExecQuery(query)
				Do While Cursor.NextRow
					longtext.text = Cursor.GetString("TorName") & " (" & intKanal & ")" & CRLF & CRLF & Cursor.Getstring("TorBeschreibung")
				Loop
			Case ColIDSelected = "ProgPartner":
				Dim intvalue As Int = sel
				query = "Select TorName, TorBeschreibung from Hexagramme where IdTor=" & intvalue
				Dim Cursor As ResultSet
				Cursor = Main.sql.ExecQuery(query)
				Do While Cursor.NextRow
					longtext.text = Cursor.GetString("TorName") & "(" & intvalue & ")" & CRLF & CRLF & Cursor.Getstring("TorBeschreibung")
				Loop
			Case ColIDSelected = "Linie":
				Dim intvalue As Int = sel
				Dim intTor As Int = GetCellData(RowIDSelected,"IdTor")

				query = "Select Bedeutung from HDLinien where IdTor=" &intTor & " and Linie = " & intvalue
				longtext.Text = "Tor:" & intTor & " Linie:" & intvalue & CRLF & Main.sql.ExecQuerySingleResult(query)
			Case Else
				details = False
		End Select
		#if b4a
			dlgblob.Initialize(Root,homepage.translate(Main.sprache,77) & " " & ColIDSelected, 90%x, 40%y)
		#else
			dlgblob.Initialize(Root,homepage.translate(Main.sprache,77) & " " & ColIDSelected,560,400)
		#End If
		If details Then 
			#if b4j
				fx.Clipboard.SetString(longtext.Text)
			#else
				clip.setText(longtext.text)
			#End If
			xui.Msgboxasync(longtext.text, homepage.translate(Main.sprache,77))
		End If
	End If
End Sub

'Lässt im Dialog einen neuen Wert eingeben an der Position RowIDSelected und ColIDSelected
Sub editTabellenfeld
	Dim inhalt As String
	Dim inhaltalt As String = GetCellData(RowIDSelected,ColIDSelected)
    'dbtable kennt keine INT-Werte, darum erscheinen Sie als Number mit .0, .0 wegschneiden
	If ColIDSelected <> "Geburtsdatum"  Then
		Dim ind As Int = inhaltalt.IndexOf(".0")
		If inhaltalt.Contains(".0") Then inhaltalt = inhaltalt.SubString2(0,ind)
	End If 
	Dim datadlg As Map = CreateMap()
	datadlg.Initialize
	datadlg.Put("inhalt",inhaltalt)
	#if b4a
		dlgblob.Initialize(Root,ColIDSelected,90%x,40%y)
	#else
		dlgblob.Initialize(Root,ColIDSelected,560,360)
	#End If

	dlgblob.LoadFromJson(File.ReadString(File.DirAssets, "editieren.json"))
	'Buttons im Multiline Edit Feld ausblenden gemäss Forum, funktioniert nur bei B4A
	'https://www.b4x.com/android/forum/threads/solved-b4x-prefdialog-multiline-edittext-properties.110049/#content
	Dim sf As Object = dlgblob.ShowDialog(datadlg, "OK", "Cancel")
	For i = 0 To dlgblob.PrefItems.Size - 1
		Dim pi As B4XPrefItem = dlgblob.PrefItems.Get(i)
		If pi.ItemType = dlgblob.TYPE_MULTILINETEXT Then
			Dim ft As B4XFloatTextField = dlgblob.CustomListView1.GetPanel(i).GetView(0).Tag
			ft.lblClear.Enabled =False
			ft.lblV.Enabled = False
			ft.lblV.Visible = False
			ft.lblClear.Left = -100dip
			ft.lblV.Left = -100dip
			'https://www.b4x.com/android/forum/threads/preferencesdialog-requestfocus.119207/#post-745436
			ft.RequestFocusAndShowKeyboard    'Springt gleich zum Eingabefeld
		End If
	Next
	Wait For (sf) Complete (Result As Int)
	If Result = xui.DialogResponse_Positive Then
		inhalt = datadlg.Get("inhalt")
		'***Bug, Inhalt kann nicht komplett gelöscht werden, sonst bleibt der vorige Wert
		SaveCellData(inhalt,RowIDSelected,ColIDSelected)
		If inhalt <> inhaltalt Then
			checkAuswirkungenFeldaenderungen(inhalt, inhaltalt)
		End If
	End If
End Sub

Sub checkAuswirkungenFeldaenderungen(inhalt As String, inhaltalt As String)
	' Wenn Inhalte in Tabellen geändert wurden, müssen ggfls. Werte in der Tabelle Benutzer angepasst werden.
	' Main.dbname enthält die aktuelle Tabelle
	Dim query As String
	
	Select True
		Case Main.DBName = "HDTyp" And ColIDSelected = "HDTyp":
			query = "Update Benutzer set HDTyp='"&inhalt&"' where HDTyp='"&inhaltalt&"'"
		Case Main.DBName = "HDAutoritaet" And ColIDSelected = "Autoritaet"
			query = "Update Benutzer set Autoritaet='"&inhalt&"' where Autoritaet='"&inhaltalt&"'"
		Case Main.DBName = "HDProfil" And ColIDSelected = "Profil": query = "Update Benutzer set Profil='"&inhalt&"' where Profil='"&inhaltalt&"'"
		Case Main.DBName = "InKreuz" And ColIDSelected = "InName": query = "Update Benutzer set HDInkarnationskreuz='"&inhalt&"' where HDInkarnationskreuz='"&inhaltalt&"'"
		Case Main.DBName = "HDErnaehrung" And ColIDSelected = "HDErnaehrung": query = "Update Benutzer set HDErnaehrung='"&inhalt&"' where HDErnaehrung='"&inhaltalt&"'"
		Case Main.DBName = "Szene" And ColIDSelected = "Szene":	query = "Update Benutzer set Szene='"&inhalt&"' where Szene='"&inhaltalt&"'"
		Case Main.DBName = "Motivation" And ColIDSelected = "Motivation":	query = "Update Benutzer set Motivation='"&inhalt&"' where Motivation='"&inhaltalt&"'"
		Case Main.DBName = "Kognition" And ColIDSelected = "Kognition":	query = "Update Benutzer set Kognition='"&inhalt&"' where Kognition='"&inhaltalt&"'"
		Case Else: 'keine Auswirkung
			Return
	End Select
	Main.SQL.ExecNonQuery(query)
End Sub