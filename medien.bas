B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=8.5
@EndOfDesignText@
'**********************************************************************************************************
'https://www.b4x.com/android/forum/threads/b4jvlcj-embed-vlc-mediaplayer-in-your-program-app.77098/#content
'B4J example for using the B4JVlcj-wrapper
'The B4JVlcj-wrapper requires 3 additional jars(libraries). See the official thread in the B4X-forum.
'You also need my B4JDragToMe-library to run this demo.
'Note: 
'If you rename this project, you must remember to change the scenegrid.fxml layout
'file accordingly. Open the layout file with Notepad++ and change the following
'line: fx:controller="com.tillekesoft.B4JVlcj.main" with your project name.
'If you create your own fxml layout file, then it should not be needed.
'Read the notes in the code and the IDE-description for further information.
'*********************************************************************************************************** 
Sub Class_Globals
	Private Root As B4XView 'ignore
	Private xui As XUI 'ignore
	
	'Private home As B4XMainPage
	#if b4j
		Private fx As JFX
		Private vlc As B4JVlcj
		Private BasePane As Pane
		Private GridPane1 As Node
		Private btnMute As Button
	#else
		Private pw As PhoneWakeState
		Private mp As SimpleExoPlayer
		Private mpv As SimpleExoPlayerView
		Private wv As WebView
		Private wvsetting As WebViewSettings
	#End If
	Public mediafile As String 'wird in clvwichtig gesetzt
	End Sub

Public Sub Initialize As Object
	Return Me
End Sub

Private Sub B4XPage_Created (Root1 As B4XView)
	Root = Root1
	#if b4j
	'** IMPORTANT - checking if VLC is installed on the computer should be the first thing to execute in your code
		If vlc.IsVLCInstalled = False Then
	'Implement your own code to tell user that VLC must be installed.
	'Note: if VLC has been installed in a non-standard directory, VLC might not be found.
			xui.MsgboxAsync("VLC media Player (64 bit) must be installed on the computer to run this program!","")
			B4XPages.ClosePage(Me)
		End If
	'** OK, VLC was found. We can proceed.
		vlc.Initialize("vlc")
		Root.LoadLayout("media")
		BasePane.LoadLayout("scenegrid")
		SetBorderPaneBackgroundColor(GridPane1, "#000000")
		AddVLCPlayerTo(GridPane1) ' adding VLC to the Gridpane
	#Else
		Root.LoadLayout("medien")
		mp.Initialize("mp")
		mpv.Player=mp
		mpv.ControllerTimeout=-1
		'Hintergrundfarbe Controller wechseln
		Dim r As Reflector
		r.Target = mpv
		Dim controller As B4XView = r.GetField("controller")
		controller.GetView(0).Color = Main.colhintergrund
	#End If

End Sub

private Sub B4XPage_Appear
	If Sammlung.CheckNetConnections = False Then
		xui.MsgboxAsync("no Internet available!","Check Internet")
		Return
	End If
'	home = B4XPages.GetPage("MainPage")
	Dim pos As Int
	pos = mediafile.LastIndexOf("/")
	Dim filename As String = mediafile.SubString(pos+1)
	B4XPages.SetTitle(Me, filename)

	#if b4j
		'MainForm.SetFormStyle("UNDECORATED") 'no windows title
		'FullScreenMode
		vlc.SetVolume(100)
		vlc.Play(mediafile)
	#Else
		SetText(filename)
		pw.KeepAlive(True)
		pw.PartialLock
		mp.Prepare(mp.CreateuriSource(mediafile))
		mp.play
	#End If
	
End Sub

Sub B4XPage_Disappear
	#if b4j
		If vlc.IsPlaying Then
			vlc.Stop
		End If
	#Else
		If mp.IsPlaying Then mp.pause
		pw.ReleaseKeepAlive
		pw.ReleasePartialLock
	#End If
	
End Sub

#if b4j
	Sub AddVLCPlayerTo (TheNode As Node)
		'we are using Javaobject here to expose a method of GridPane added
		'using a layout created with SceneBuilder. As the time of writing,
		'B4J does not include the GridPane control in its designer.
		Dim jo As JavaObject = TheNode
		jo.RunMethodJo("getChildren", Null).RunMethod("add", Array(vlc.player))
	End Sub

'	Sub FullScreenMode
'		'full screen
'		Main.MainForm.WindowWidth = fx.PrimaryScreen.MaxX - fx.PrimaryScreen.MinX
'		Main.MainForm.WindowLeft = fx.PrimaryScreen.MinX
'		Main.mainForm.WindowHeight = fx.PrimaryScreen.MaxY - fx.PrimaryScreen.MinY
'		Main.MainForm.WindowTop = fx.PrimaryScreen.MinY
'	End Sub

	Sub SetBorderPaneBackgroundColor (TheNode As Node, colorhex As String)
		'we are using Javaobject here to expose a method of GridPane added
		'using a layout created with SceneBuilder. As the time of writing,
		'B4J does not include the GridPane control in its designer.
		Dim joBP As JavaObject = TheNode
		joBP.RunMethodJO("setStyle", Array("-fx-background-color: " & colorhex & ";"))
		'for colors values - see http://www.color-hex.com/
	End Sub
	
	Sub vlc_Prepared
		Log("Video is ready")
		GridPane1.SetSize(BasePane.Width,BasePane.Height)
	End Sub

	Sub vlc_Finished
		Log("Video has finished or the format was not playable")
	End Sub

	Sub vlc_Error
		Log("There was an error")
	End Sub

	Sub btnStop_Action
			If vlc.IsPlaying Then
				vlc.stop
			End If
	End Sub

	Sub btnPause_Action
			vlc.pause
	End Sub


	Sub btnMute_Action
		If vlc.GetVolume > 0 Then
			btnMute.Text = ""
			vlc.Mute
		Else
			btnMute.Text = ""
			vlc.Unmute(100)
		End If
	End Sub


	Sub MainForm_Resize (Width As Double, Height As Double)
			GridPane1.SetSize(BasePane.Width,BasePane.Height)
	End Sub

	Sub btnPlay_Action
		If mediafile <> "" Or mediafile.Length > 0 Then
			If vlc.IsPlaying = False Then vlc.Play(mediafile)
		End If
	End Sub
#end if

#if b4a
	Sub mp_Error (Message As String)
		Log("Error: " & Message)
		B4XPages.ClosePage(Me)
	End Sub
	'Nach Beenden der Wiedergabe zurück
Sub mp_Complete
	B4XPages.ClosePage(Me)
End Sub

'laedt Dateibilder bei Toren, ansonsten das Heilseminare Symbol
Sub SetText(datei As String)
	
	If datei.Contains("mp4") Then Return 'Video
	
	Dim s As String
	wv.Visible = True
	wvsetting.setLoadWithOverviewMode(wv,True)
	wvsetting.setsavepassword(wv,True)
	wvsetting.setdomstorageenabled(wv,True)
	wvsetting.setUseWideViewPort(wv,True)
	wvsetting.setLoadsImagesAutomatically(wv,True)
	wvsetting.setDisplayZoomControls(wv,False)
	wvsetting.setAppCacheEnabled(wv,True)
	wvsetting.setPluginState(wv,"ON")
	wv.JavaScriptEnabled=True
	wv.ZoomEnabled = False
	wv.RequestFocus
	
	If datei.SubString2(0,3)="tor" Then 'Torbild zeigen
		If datei.Length=9 Then
			Dim bildname As String = "h" & datei.SubString2(3,5) & ".png"
		End If
		If datei.Length=8 Then
			Dim bildname As String = "h" & datei.SubString2(3,4) & ".png"
		End If
		Log("Bild "&bildname)
	Else
		Dim bildname As String = "meditationmeridianematrix.jpg"
	End If
	s = "<center><img src=" & "File:///android_asset/" & bildname & " width='100%' height='auto'/></br></br></center>"
	
	Dim o As Reflector
	o.Target = wv
	o.RunMethod2("clearCache","True","java.lang.boolean")
	wv.LoadHtml("<html><body topmargin='0' leftmargin='0' matginwidth='0' marginheight='0'>"&s&"</body></html>")
End Sub

#end if


