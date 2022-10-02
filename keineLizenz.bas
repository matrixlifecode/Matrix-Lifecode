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
	Private dlg As B4XDialog
	#if b4a
		Private video As SimpleExoPlayer
		Private clientVideo As SimpleExoPlayerView
		Private ime As IME
	#end if
	Private btnAccess As Button
	Private clientDatum As B4XFloatTextField
	Private clientName As B4XFloatTextField
	Private clientOrt As B4XFloatTextField
	Private clientVorname As B4XFloatTextField
	Private clientZeit As B4XFloatTextField
	Private lblCode As Button
	Private lblCodeBeratung As Button
	Private clv As CustomListView
End Sub

'You can add more parameters here.
Public Sub Initialize As Object
	Return Me
End Sub

'This event will be called once, before the page becomes visible.
Private Sub B4XPage_Created (Root1 As B4XView)
	Root = Root1
	Root.LoadLayout("StartCode")
	ime.Initialize("ime")
	ime.AddHeightChangedEvent
	home = B4XPages.GetPage("MainPage")
	Dim titelzeile As String = home.translate(Main.sprache,79)' Dein Weg zum Glück
	B4XPages.SetTitle(Me,titelzeile) 
	dlg.Initialize(Root)
	video.Initialize("video")
'	If Sammlung.CheckNetConnections = False Then
'		Dim sf As Object = xui.Msgbox2Async("Bitte Datenverbindung herstellen!", "Kein Internet", "Ok, erledigt", "App verlassen", "", Null)
'		Wait For (sf) Msgbox_Result (Result As Int)
'		If Result <> xui.DialogResponse_Positive Then
'			B4XPages.ClosePage(Me)
'		End If
'	End If
	video.Prepare(video.CreateUriSource("https://heilseminare.com/video/matrixlifecode.mp4"))
	clientVideo.Player=video 'Connect the interface to the engine
	
	clv.Add(CreateListItemAllgemein,"")
End Sub

Private Sub B4XPage_Appear

End Sub
'Wenn der Anwender Back-Taste oder Home betätigt
private Sub B4XPage_CloseRequest
	ExitApplication
End Sub

Sub CreateListItemAllgemein As Panel
	Dim p As B4XView = xui.CreatePanel("")
	p.SetLayoutAnimated(200,0,0,100%x,320dip)
	p.LoadLayout("cellitemStartcode")
	Return p
End Sub
Sub clientZeit_EnterPressed
	Dim str As String = clientZeit.Text
	If str.length<>5 And str.SubString2(2,3)<>":" Then
		clientZeit.RequestFocusAndShowKeyboard
		xui.MsgboxAsync("f.e. 10:00","format error")
	End If
End Sub
Sub clientDatum_EnterPressed
	Dim str As String = clientDatum.Text
	If str.length<>10 And str.SubString2(2,3)<>"." And str.SubString2(5,6)<>"." Then
		clientDatum.RequestFocusAndShowKeyboard
		xui.MsgboxAsync("f.e. 27.11.1965","format error")
	End If
End Sub

Sub checkEingaben(vorname As String, name As String, gebdatum As String,gebzeit As String, gebland As String) As Boolean
	If vorname = "" Or name = "" Or gebdatum = "" Or gebzeit = "" Or gebland="" Then 
		Return False
	Else
	 	Return True
	End If
End Sub



Sub kaufen_click As ResumableSub
	'Code oder CodeBeratung kaufen (ist im Tag gespeichert!)
	Dim sku As String
	Dim o As B4XView = Sender
	Dim t As Int = o.tag
	Select True
		Case t = "1": sku=home.SKU_ID1 	'Person hinzufügen
		Case t = "2": sku=home.SKU_ID2	'Beratung kaufen
	End Select
	
'Erst prüfen, ob Name und Geburtsdatum eingetragen wurden
	Dim raus As Boolean
	Do While raus=False
		If checkEingaben(clientName.Text,clientVorname.Text,clientDatum.Text,clientZeit.Text,clientOrt.Text) = False Then
			Dim sf As Object = xui.Msgbox2Async("Bitte zuerst Vorname,Name,Geburtsdatum,Geburtszeit und Geburtsland befüllen!", "Fehlende Daten", "Ok, erledigt", "Zurück", "", Null)
			Wait For (sf) Msgbox_Result (Result As Int)
			If Result <> xui.DialogResponse_Positive Then
				raus = True
			End If
		End If
	Loop
	If raus Then B4XPages.ClosePage(Me)
	'make sure that the store service is connected
	Wait For (home.billing.ConnectIfNeeded) Billing_Connected (billresult As BillingResult)
	If billresult.IsSuccess Then 'Shop-Anbindung steht
		'get the sku details
		Dim sf As Object = home.billing.QuerySkuDetails("inapp", Array(sku))
		Wait For (sf) Billing_SkuQueryCompleted (billresult As BillingResult, SkuDetails As List)
		If billresult.IsSuccess And SkuDetails.Size = 1 Then
			'LaunchBillingFlow ruft als Ergebnis billing_purchaseupdated in Mainpage auf
			billresult = home.billing.LaunchBillingFlow(SkuDetails.Get(0))
			If billresult.IsSuccess = True Then Log("Storeanbindung:"&billresult.IsSuccess)
		End If
	Else
		ToastMessageShow("Error starting billing process", True)
	End If
End Sub

'Private Sub btnAccess_Click
	'dbkopierenUser 'DB-kopieren, initialisieren und Passwort abfragen
'End Sub


'Sub dbkopierenUser
''Nach Betätigen desBtnAccess Button wird zunächst die neueste Datenbank geladen
''und geprüft ob User dort enthalten ist. Dann werden alle anderen Datensätze der Benutzer-DB gelöscht. Er kann fortan nur noch auf seine Daten zugreifen.
''Lizenz wird auf 1 gesetzt, sobald das richtige Passwort eingegeben wurde	
''Passwort=Email&Geburtsdatum
'
'	'Check Internet
'	If Sammlung.CheckNetConnections = False Then
'		Dim sf As Object = xui.Msgbox2Async("No Internet!", "Check Internet", "Ok, Internet is on", "Cancel", "", Null)
'		Wait For (sf) Msgbox_Result (Result As Int)
'		If Result <> xui.DialogResponse_Positive Then B4XPages.ClosePage(Me)
'	End If
'	'Datenbank vom Server laden
'	wait for (home.datenbankLaden(home.dbname)) Complete (Success As Boolean)
'	If Success = True Then
'		'Passwort Check, iduser wird in checkpasswort gesetzt
'		Dim rs As ResumableSub = checkpasswort
'		Wait For(rs) Complete (Ergebnis As Boolean)
'		If Ergebnis = True Then
'			Log("Passwort war richtig!")
'			Main.lizenz = 1
'			home.kvs.Put("lizenz","1")
'			B4XPages.ClosePage(Me)	'Zurück zur eigentlichen Mainpage, home.iduser wurde in checkpasswort gesetzt
'		Else
'			Dim sf As Object = xui.Msgbox2Async("Wrong password!", "error","Ok, i will try again", "", "exit", Null)
'			Wait For (sf) Msgbox_Result (Result As Int)
'			If Result <> DialogResponse.POSITIVE Then ExitApplication
'		End If
'	Else
'		Dim sf As Object = xui.Msgbox2Async("database download failed!", "error","Ok, i will try again", "", "", Null)
'		Wait For (sf) Msgbox_Result (Result As Int)
'	End If
'End Sub

Sub checkpasswort As ResumableSub
	'Passwortabfrage für Anzeige eines einzelnen Datensatzes der Endnutzer
	'Passwortabfrage Email&Geburtsdatum
	Dim input As B4XInputTemplate
	input.Initialize
	input.lblTitle.Text = home.translate(Main.sprache,6) ' Zugangscode: Email&Geburtsdatum
	Wait For (dlg.ShowTemplate(input, "OK", "", "CANCEL")) Complete (Result As Int)
	If Result = xui.DialogResponse_Positive Then
		Dim res As String = input.Text
		If res.Contains("&") = False Then
			xui.MsgboxAsync(home.translate(Main.sprache,8),home.translate(Main.sprache,7)&CRLF&CRLF&"(example: detox.relax@gmail.com&27.11.1965 )")
		Else
			Dim eInput As String = res.SubString2(0,res.IndexOf("&"))
			eInput=eInput.ToLowerCase
			Dim gebInput As String = res.SubString2(res.IndexOf("&")+1,res.Length)
			'Prüfen, ob Eintrag mit Email und Geburtsdatum existiert
			Dim idname As Object = Main.SQL.ExecQuerySingleResult("Select IdName from Benutzer where Email = '"&eInput & "' and Geburtsdatum = '"&gebInput &"'")
			If idname <> Null Then 'Eintrag vorhanden, iduser setzen
				home.iduser=idname
				Dim Query As String = "UPDATE _variablen SET Wert =" & home.iduser & " where Name = 'IdUser'"
				Main.sql.ExecNonQuery(Query)
				'legt den User fest, der sich erfolgreich eingeloggt hat und damit nicht mehr einloggen muss um seine Daten zu sehen.
				home.kvs.put("iduser",home.iduser) 
				'Alle anderen Benutzer löschen
				Main.SQL.ExecNonQuery("Delete from Benutzer where IdName <>"&home.iduser)
				Log("Benutzer "&home.iduser& " verbleibt als einziger Eintrag in Datenbank")
				Return True
			Else
				xui.MsgboxAsync(home.translate(Main.sprache,10),home.translate(Main.sprache,11))
			End If
		End If
	End If
	Return False
End Sub

'Wird nach dem Kauf aufgerufen um die Mail an uns mit dem Standard Clientprogramm senden zu können
'kommt auf pay@heilseminare.com
Sub sendClientData(wasgekauft As String)
	Dim Message As Email
	Message.To.Add("pay@heilseminare.com")
	Message.Subject=home.translate(Main.sprache,5)
	Dim bodytext As String = wasgekauft &CRLF&clientVorname.Text&","&clientName.text&","&clientDatum.text&","&clientZeit.text&","&clientOrt.text
	Message.Body=bodytext
	StartActivity(Message.GetIntent)
End Sub

Public Sub SetFloatTextField(FloatTextField As B4XFloatTextField)
	FloatTextField.SmallLabelTextSize = 10 'Hint Small
	FloatTextField.LargeLabelTextSize = 16 'Hint Large
	FloatTextField.TextField.TextSize = 16 'Text
	FloatTextField.HintColor = Main.colrot
	Dim TextFont As B4XFont = xui.CreateFont2(FloatTextField.HintFont, FloatTextField.SmallLabelTextSize)
	Dim TextWidth As Int = MeasureTextWidth(FloatTextField.HintText, TextFont)
	Dim BorderRadius As Int = 2
	
	FloatTextField.HintLabelSmallOffsetY =  5 'Inside
	FloatTextField.HintLabelSmallOffsetX = (FloatTextField.TextField.Width - TextWidth) - (BorderRadius + 5) 'Right
	FloatTextField.Update
	
	FloatTextField.TextField.SetColorAndBorder(xui.Color_White, DipToCurrent(2), xui.Color_white, BorderRadius)
End Sub

Private Sub MeasureTextWidth(t As String, f As B4XFont) As Float
	Dim cvs As B4XCanvas
	Dim p As B4XView = xui.CreatePanel("")
	p.SetLayoutAnimated(0, 0, 0, 2dip, 2dip)
	cvs.Initialize(p)
	Dim Width As Float = cvs.MeasureText(t, f).Width
	Return Width
End Sub

