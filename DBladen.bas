B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=8.5
@EndOfDesignText@
Sub Class_Globals
	Private Root As B4XView 'ignore
	Private xui As XUI 'ignore
	Private ser As B4XSerializator
	Private home As B4XMainPage
	Private btnSend As B4XView
	Private btnConnect As B4XView
	Private alledblokal As B4XView
	Private connected As Boolean
	Private working As Boolean = True
	Private client As Socket
	Public server As ServerSocket
	Private astream As AsyncStreams 	
	Private const PORT As Int = 51042
	Private lblStatus As B4XView
	Private lblMyIp As B4XView
	Private txtIP As B4XFloatTextField
	Type MyMessage (Name As String, datei() As Byte)
	#if b4a
		Private rp As RuntimePermissions
	#End If
	#if b4j
		Private fx As JFX
	#end if
End Sub

'You can add more parameters here.
Public Sub Initialize
	server.Initialize(PORT, "server")
	ListenForConnections
End Sub

'This event will be called once, before the page becomes visible.
Private Sub B4XPage_Created (Root1 As B4XView)
	Root = Root1
	home = B4XPages.GetPage("MainPage")
	'load the layout to Root
	Root.LoadLayout("dbladen")
	#if b4j
		Dim F As Form = B4XPages.GetNativeParent(Me)
		F.WindowWidth = fx.PrimaryScreen.MaxX - fx.PrimaryScreen.MinX           'set the screen to full width/height
		F.WindowLeft = fx.PrimaryScreen.MinX
		F.WindowHeight= fx.PrimaryScreen.MaxY - fx.PrimaryScreen.MinY
		F.WindowTop = fx.PrimaryScreen.MinY
	#end if
	B4XPages.SetTitle(Me, "Datenbank übertragen")
	For Each txt As B4XFloatTextField In Array(txtIP)
		txt.LargeLabelTextSize = 15
		txt.SmallLabelTextSize = 12
		txt.Update
	Next
	UpdateState(False)
	txtIP.Text = "192.168.1."            'Vorbelegung

End Sub

Sub B4XPage_Resize (Width As Int, Height As Int)
	
End Sub

Private Sub ListenForConnections
	Do While working
		server.Listen
		Wait For Server_NewConnection (Successful As Boolean, NewSocket As Socket)
		If Successful Then
			CloseExistingConnection
			client = NewSocket
			astream.InitializePrefix(client.InputStream, False, client.OutputStream, "astream")
			UpdateState(True)
		End If
	Loop
End Sub

Sub CloseExistingConnection
	If astream.IsInitialized Then astream.Close
	If client.IsInitialized Then client.Close
	UpdateState (False)
End Sub

Sub AStream_Error
	Log("AStream_Error"&LastException.Message)
	UpdateState(False)
End Sub

Sub AStream_Terminated
	Log("AStream_Terminated"&LastException.Message)
	UpdateState(False)
End Sub

Sub UpdateState (NewState As Boolean)
	connected = NewState
	btnSend.Enabled = connected
	If connected Then
		lblStatus.TextColor = Main.farbe.Get(0)
		lblStatus.Text = "Verbunden mit " & txtIP.Text
	Else
		lblStatus.TextColor = Main.farbe.get(1)
		lblStatus.Text = "Nicht verbunden mit anderem Gerät"
	End If
	lblMyIp.TextSize=12
	lblMyIp.Text = "Meine IP: " & server.GetMyIP
	If server.GetMyip.StartsWith("127.") Then 
		xui.Msgboxasync( "no WIFI !", "start WIFI")
		B4XPages.ClosePage(Me)
	End If
End Sub

'wird im Prefix mode nur dann aktiviert, wenn alles übertragen ist.
Sub AStream_NewData (Buffer() As Byte)
	Main.SQL.Close 'close existing database
	Dim mm As MyMessage = ser.ConvertBytesToObject(Buffer)
	File.WriteBytes(xui.DefaultFolder,mm.Name,mm.datei)
	'initialize the new database
	#If B4J
		Main.SQL.InitializeSQLite(xui.DefaultFolder, mm.Name, False)
	#Else
		Main.sql.Initialize(xui.DefaultFolder, mm.Name, False)
	#end if

	
	Dim sf As Object = xui.Msgbox2Async("Datenbank " & mm.Name & " empfangen und aktiviert!","","OK","","",Null)
	Wait For (sf) Msgbox_Result (Result As Int)
	
	home.iduser = -1  							'Neu laden auf Hauptseite
	'Auf Sprache der übertragenen Datenbank wechseln
	Select True
		Case mm.Name = "heilsystemdeutsch.db": Main.sprache = "deutsch"
		Case mm.Name = "heilsystemenglish.db": Main.sprache = "english"
		Case mm.Name = "heilsystemespanol.db": Main.sprache = "espanol"
		Case mm.Name = "heilsystemfrancais.db": Main.sprache = "francais"
	End Select
	#if b4j 'In B4J das Hauptfenster ist immer geöffnet, appear feuert daher nicht bei Rückkehr
		home.B4XPage_MenuClick("Laden")
	#end if
End Sub
 
Private Sub ConnectToServer(Host As String)
Log("Trying to connect to: " & Host)
CloseExistingConnection
Dim client As Socket
client.Initialize("client")
client.Connect(Host, PORT, 10000)
	Wait For Client_Connected (Successful As Boolean)
	If Successful Then
		astream.InitializePrefix(client.InputStream, False, client.OutputStream, "astream")
		UpdateState (True)
	Else
		Log("Failed to connect: " & LastException)
	End If
End Sub

Private Sub Disconnect
	CloseExistingConnection
End Sub

Sub btnConnect_Click
	If connected = False Then
		If txtIP.Text.Length = 0 Then
			xui.Msgboxasync( "Bitte die Ziel- IP Adresse eingeben !", "")
			Return
		Else
			ConnectToServer(txtIP.Text)
		End If
	Else
		Disconnect
	End If
End Sub


Public Sub SendData (data() As Byte)
	If connected Then astream.Write(data)
End Sub

Sub btnSend_Click
	'If Main.sprache<>"deutsch" Then
	'	Dim sf As Object = xui.Msgbox2Async("Bitte zuerst zur deutschen Sprache in den Einstellungen wechseln!","Sprachvariante erst wechseln", "Ok", "", "",Null)
	'	Wait For (sf) Msgbox_Result (Result As Int)
	'	Return
	'End If
	Dim mm As MyMessage
	mm.Name = "heilsystem"&Main.sprache&".db"
	Dim sf As Object = xui.Msgbox2Async("Es wird die Datenbank "&mm.Name& " dieses Gerätes auf das Zielgerät übertragen und dort aktiviert!" & CRLF & CRLF &"Wollen Sie das wirklich?", "Datenbank übertragen", "Ja", "", "Nein",Null)
	Wait For (sf) Msgbox_Result (Result As Int)
	If Result = xui.DialogResponse_POSITIVE Then
		Dim datei() As Byte
		datei = File.ReadBytes(xui.DefaultFolder,mm.Name)
		mm.datei = datei
		SendData (ser.ConvertObjectToBytes(mm))
	End If
End Sub
#if b4a
Private Sub alledblokal_Click
	Dim sf As Object = xui.Msgbox2Async("Die Datenbanken aller Sprachvarianten werden lokal gesichert!", "Datenbank Backup", "Ja", "", "Nein",Null)
	Wait For (sf) Msgbox_Result (Result As Int)
	If Result = xui.DialogResponse_POSITIVE Then
		File.Copy(xui.DefaultFolder,"heilsystemdeutsch.db",rp.GetSafeDirDefaultExternal(""),"heilsystemdeutsch.db")
		File.Copy(xui.DefaultFolder,"heilsystemenglish.db",rp.GetSafeDirDefaultExternal(""),"heilsystemenglish.db")
		File.Copy(xui.DefaultFolder,"heilsystemespanol.db",rp.GetSafeDirDefaultExternal(""),"heilsystemespanol.db")
		File.Copy(xui.DefaultFolder,"heilsystemfrancais.db",rp.GetSafeDirDefaultExternal(""),"heilsystemfrancais.db")
		ToastMessageShow("Kopieren beendet, Dateien befinden sich im Verzeichnis"&rp.GetSafeDirDefaultExternal(""),True)
	End If
End Sub
#end if