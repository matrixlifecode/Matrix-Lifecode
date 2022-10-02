B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=10.7
@EndOfDesignText@
Sub Class_Globals
	
	Private Root As B4XView 'ignore
	Private xui As XUI 'ignore
	Private home As B4XMainPage
	Private video As SimpleExoPlayer
	Private clientVideo As SimpleExoPlayerView
	Private ime As IME
	
	
	Private clv As CustomListView
End Sub

Public Sub Initialize As Object
	Return Me
End Sub

Private Sub B4XPage_Created (Root1 As B4XView)
	Root = Root1
	Root.LoadLayout("Hilfe")
	ime.Initialize("ime")
	ime.AddHeightChangedEvent
	home = B4XPages.GetPage("MainPage")
	home.setTitelzeile("LifeCode Informationen")
'	Dim titelzeile As String = home.translate(Main.sprache,79)' Dein Weg zum Glück
'	B4XPages.SetTitle(Me,titelzeile) 
	video.Initialize("video")
	If Sammlung.CheckNetConnections = False Then
		Dim sf As Object = xui.Msgbox2Async("Bitte Datenverbindung herstellen!", "Kein Internet", "Ok, erledigt", "Zurück", "", Null)
		Wait For (sf) Msgbox_Result (Result As Int)
		If Result <> xui.DialogResponse_Positive Then
			B4XPages.ClosePage(Me)
		End If
	End If
	video.Prepare(video.CreateUriSource("https://heilseminare.com/video/matrixlifecode.mp4"))
	clientVideo.Player=video 'Connect the interface to the engine

End Sub

Private Sub B4XPage_Appear
	clv.Clear
	video.Play
	'clv.Add(CreateListItemAllgemein,"")
End Sub

private Sub b4xpage_disappear
	If video.IsPlaying Then 
		video.Pause
	End If
End Sub

'
'Public Sub SetFloatTextField(FloatTextField As B4XFloatTextField)
'	FloatTextField.SmallLabelTextSize = 10 'Hint Small
'	FloatTextField.LargeLabelTextSize = 16 'Hint Large
'	FloatTextField.TextField.TextSize = 16 'Text
'	FloatTextField.HintColor = Main.colrot
'	Dim TextFont As B4XFont = xui.CreateFont2(FloatTextField.HintFont, FloatTextField.SmallLabelTextSize)
'	Dim TextWidth As Int = MeasureTextWidth(FloatTextField.HintText, TextFont)
'	Dim BorderRadius As Int = 2
'	
'	FloatTextField.HintLabelSmallOffsetY =  5 'Inside
'	FloatTextField.HintLabelSmallOffsetX = (FloatTextField.TextField.Width - TextWidth) - (BorderRadius + 5) 'Right
'	FloatTextField.Update
'	
'	FloatTextField.TextField.SetColorAndBorder(xui.Color_White, DipToCurrent(2), xui.Color_white, BorderRadius)
'End Sub

'Private Sub MeasureTextWidth(t As String, f As B4XFont) As Float
'	Dim cvs As B4XCanvas
'	Dim p As B4XView = xui.CreatePanel("")
'	p.SetLayoutAnimated(0, 0, 0, 2dip, 2dip)
'	cvs.Initialize(p)
'	Dim Width As Float = cvs.MeasureText(t, f).Width
'	Return Width
'End Sub

