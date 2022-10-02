B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=StaticCode
Version=8.5
@EndOfDesignText@

Sub Process_Globals

End Sub

'Arbeiten mit Maps
'For Each key As String In Map1.Keys
'Dim value As String = Map1.Get(key)
'
'Next
'
public Sub convertiereSabSymbolinSternzeichen(idSab As Int) As Int
	'Sternzeichen beginnen bei 1, gehen bis 12
	'gibt anhand des Sabischen Symbols die ID des Sternzeichens zurück
If idSab = 30 Or idSab = 60 Or idSab = 90 Or idSab = 120 Or idSab = 150 Or idSab = 180 Or idSab = 210 Or idSab = 240 Or idSab = 270 Or idSab = 300 Or idSab = 330 Or idSab = 360 Then
		Dim stznrd As Double =(idSab/30)
	Else
		Dim stznrd As Double =(idSab/30)+1
	End If
	Dim stznr As Int = stznrd.As(Int)
	Return stznr
End Sub

public Sub ColorToHex(clr As Int) As String
	Dim bc As ByteConverter
	Return bc.HexFromBytes(bc.IntsToBytes(Array As Int(clr)))
End Sub

public Sub HexToColor(Hex As String) As Int
	Dim bc As ByteConverter
	If Hex.StartsWith("#") Then
		Hex = Hex.SubString(1)
	Else If Hex.StartsWith("0x") Then
		Hex = Hex.SubString(2)
	End If
	Dim ints() As Int = bc.IntsFromBytes(bc.HexToBytes(Hex))
	Return ints(0)
End Sub

Public Sub ImageToBytes(Image As B4XBitmap) As Byte()
	Dim out As OutputStream
	out.InitializeToBytesArray(0)
	Image.WriteToStream(out, 100, "PNG")
	out.Close
	Return out.ToBytesArray
End Sub

Public Sub BytesToImage(bytes() As Byte) As B4XBitmap
	Dim In As InputStream
	In.InitializeFromBytesArray(bytes, 0, bytes.Length)
#if B4A or B4i
   Dim bmp As Bitmap
   bmp.Initialize2(In)
#else
	Dim bmp As Image
	bmp.Initialize2(In)
#end if
	Return bmp
End Sub

'Sub InsertBlob
'	Dim Buffer() As Byte = File.ReadBytes(File.DirAssets, "smiley.gif")
'	'write the image to the database
'	Main.sql.ExecNonQuery2("INSERT INTO table2 VALUES('smiley', ?)", Array As Object(Buffer))
'End Sub

'Sub ReadBlob
'	Dim cs As Cursor = Main.SQL1.ExecQuery2("SELECT image FROM table2 WHERE name = ?", Array As String("smiley"))
'	Cursor1.Position = 0
'	Dim Buffer() As Byte = Cursor1.GetBlob("image")
'	Dim InputStream1 As InputStream
'	InputStream1.InitializeFromBytesArray(Buffer, 0, Buffer.Length)
'	Dim Bitmap1 As Bitmap
'	Bitmap1.Initialize2(InputStream1)
'	InputStream1.Close
'	Activity.SetBackgroundImage(Bitmap1)
'End Sub

'Key Value Store Bibliothek zum Speichern von Variablen
'xui.SetDataFolder("kvs")
'    kvs.Initialize(xui.DefaultFolder, "kvs.dat")
'    kvs.Put("time", DateTime.Now)
' 
'    'fetch this value
'    Log(DateTime.Time(kvs.Get("time")))
'    Log(kvs.Get("doesn't exist"))
'    Log(kvs.GetDefault("doesn't exist", 10))
'    'put a Bitmap
'    kvs.PutBitmap("bitmap1", xui.LoadBitmap(File.DirAssets, "smiley.gif"))
'    'fetch a bitmap
'    ImageView1.SetBitmap(kvs.GetBitmap("bitmap1"))
'    'remove the bitmap from the store
'    kvs.Remove("bitmap1")
'    'put an array with two custom types
'    kvs.Put("2 custom types", Array(CreateCustomType(1, "one"), CreateCustomType(2, "two")))
'    'get them
'    Dim mytypes() As Object = kvs.Get("2 custom types") 'the array type must be object or bytes

'Lesen oder Schreiben von PDF oder sonstige Dateiformate in ein BLOB- Feld der Datenbank
'Mit Chooser Auswählen und das Ergebnis in ein data- Array lesen, das dann in die Tabelle geschrieben wird.	
'Sub chooser_Result ( Success As Boolean, Dir As String, FileName As String)
' 
'	If Success Then
'    
'		Dim data() As Byte = File.ReadBytes(Dir, FileName)
'		SQL.ExecNonQuery2("INSERT INTO table1 VALUES(?)", Array(data))
' 
'	Else
'		ToastMessageShow("No PDF SELECT",True)
'	End If
' 
' 
'End Sub

'Sub ExportTableToCSV
'	Dim data As List
'	data.Initialize
'	Dim rs As ResultSet = Main.sql.ExecQuery("SELECT * FROM data")
'	Do While rs.NextRow
'		Dim row(data.Columns.Size) As String
'		For i = 0 To data.Columns.Size - 1
'			Dim c As B4XTableColumn =data.Columns.Get(i)
'			row(i) = rs.GetString(c.SQLID)
'		Next
'		data.Add(row)
'	Loop
'	rs.Close
'	Dim su As StringUtils
'	#If B4J
'	su.SaveCSV2(xui.DefaultFolder, "TabelleExport.csv", ",", data, headers)
'	#Else
'	  su.SaveCSV2(File.dirdefaultExternal, "TabelleExport.csv", ",", data, headers)
'	#End If
'End Sub

'Sub IntToDIP(Integer As Int) As Int
'	Dim r As Reflector
'	Dim scale As Float
'	r.Target = r.GetContext
'	r.Target = r.RunMethod("getResources")
'	r.Target = r.RunMethod("getDisplayMetrics")
'	scale = r.GetField("density")
'  
'	Dim DIP As Int
'	DIP = Integer * scale + 0.5
'	Return DIP
'End Sub

'Ermittelt die eingestellte Systemsprache B4A, damit kann dann gleich auf die Sprachvariante in der App umgestellt werden.
'Sub GetPhoneLanguage As String
'	Dim Resources As JavaObject
'	Resources = Resources.InitializeStatic("android.content.res.Resources").RunMethodJO("getSystem", Null).RunMethodJO("getConfiguration", Null).RunMethodJO("getLocales", Null)
'	Dim Locale As String = Resources.RunMethod("get", Array(0))
'	Return Locale
'End Sub


Sub CheckNetConnections As Boolean
	'returns false if not connected
	Dim Server As ServerSocket
	Dim connect As Boolean = False
	Dim Network_IP As String

	Server.Initialize(21341,"Net")
	Network_IP = Server.GetMyIP

	#if b4j
	If Network_IP <> "127.0.0.1" Then
		connect = True
	End If
	#else
		Dim WiFi_IP As String
		WiFi_IP = Server.GetMyWifiIP
		If WiFi_IP = "127.0.0.1" Then
		If Network_IP.SubString2(3,4) = "." Or Network_IP.SubString2(2,3) = "." Then 'Adressen mit 10. auch möglich bei Handy
				If Network_IP.substring2(0,3) <> 127 Then connect = True
			End If
		Else
			connect = True
		End If
	#end if
	Server.Close
	Return connect
   
End Sub
'Sub Convert_Longitude(longitude As Double) As String
'	Dim signs(12) As String
'	Dim deg, mn, sec, sign_num As Int
'	Dim full_mn,full_sec, pos_in_sign As Double
' 
'	signs(0) = "Widder"
'	signs(1) = "Stier"
'	signs(2) = "Zwillinge"
'	signs(3) = "Krebs"
'	signs(4) = "Löwe"
'	signs(5) = "Jungfrau"
'	signs(6) = "Waage"
'	signs(7) = "Skorpion"
'	signs(8) = "Schütze"
'	signs(9) = "Steinbock"
'	signs(10) = "Wassermann"
'	signs(11) = "Fische"
'
'	sign_num = Floor(longitude / 30)
'	pos_in_sign = longitude - (sign_num * 30)
'	deg = Floor(pos_in_sign)
'	full_mn = (pos_in_sign - deg) * 60
'	mn = Floor(full_mn)
'	full_sec = Round((full_mn - mn) * 60)
'	sec = Floor(full_sec)
'	Return "'" & signs(sign_num) & NumberFormat(deg, 2, 0) & " " & NumberFormat(mn, 2, 0) & NumberFormat(sec, 2, 0) & "'"
'End Sub