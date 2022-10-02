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
	Private countStep,schrittmax As Int          'schrittmax entsprechend der Anzahl Schritte 
	Dim bildLinks As ImageView
	Dim bildrechts As ImageView
	Dim lbllinks,lblrechts As Label
	Dim btnvor,btnback As Button
	#if b4a
		Dim ph As Phone
		Dim pw As PhoneWakeState
		Dim panel As Panel
	#else
'		Private jfx1 As JFX
	#end if
	Dim tm As BCToast
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
	Root.LoadLayout("stromspielen")
	#if b4j
		Dim F As Form = B4XPages.GetNativeParent(Me)
		F.WindowWidth = 600
		F.WindowHeight= 800
		
	#end if
End Sub

Sub B4xPage_Appear
	Dim titelzeile As String = home.aktuellerstrom
	B4XPages.SetTitle(Me,titelzeile)
	countStep = 1

	#if b4a
		pw.KeepAlive(False)
		pw.PartialLock
	#end if
	ladeStep(countStep)
End Sub

Sub B4xPage_Disappear
	#if b4a
		pw.ReleaseKeepAlive
		pw.ReleasePartialLock
	#end if
End Sub


Sub ladeStep(Schritt As Int)         'laedt den Bildschirm mit den Bildern gemaess starter.cursordetail
 
	Dim nummer As Int
	
	#if b4j
	'Abfrage muss nochmal durchgeführt werden, weil Resultset nicht mehrmals durchlaufen werden kann !
	'Unterschied bei B4A, wo dies möglich ist
	Dim sqlstring As StringBuilder
	sqlstring.Initialize
	sqlstring.Append("select strom.sitze,strom.Stromseite,strom.bildwechsel,strom.step,strom.hand,strom.seite,strom.nummer,strom.position,punkte.grafik,punkte.bezeichnung from strom,punkte where strom.bezeichnung='").Append(home.aktuellerstrom.trim).Append("' and strom.Stromseite = '").Append(home.stromseite).Append("' and strom.nummer = punkte.nummer")
	sqlstring.Append(" and strom.hand = punkte.hand and strom.seite = punkte.seite and strom.position = punkte.position order by strom.bildwechsel asc")
	home.cursordetail = Main.sql.ExecQuery(sqlstring.ToString)
	Do While home.cursordetail.NextRow
		If home.cursordetail.getint("bildwechsel") > schrittmax Then schrittmax = schrittmax + 1 'Da Resultset in B4J nicht eine Anzahl Reihen Funktion hat, muss ich selbst die max. Reihenzahl ermitteln
		If home.cursordetail.GetString("Stromseite") = home.stromseite Then
			Dim bildschritt As Int = home.cursordetail.Getint("bildwechsel")
			If  bildschritt = Schritt Then 'nur die Bilder aktualisieren
				Dim grafik As String = home.cursordetail.getstring("grafik").trim
				grafik = grafik.ToLowerCase
				If home.cursordetail.Getstring("hand").trim = "R" Then
					If File.Exists("..\files\",grafik) Then
						bildrechts.SetImage(xui.LoadBitmapResize("..\files\",grafik,bildrechts.Width,bildrechts.Height,True))
					Else
						bildrechts.SetImage(xui.LoadBitmap("..\files\","smiley.png"))
					End If
					
					nummer = home.cursordetail.getstring("nummer").trim
					If nummer <= 26 Then
						lblrechts.Text = home.cursordetail.getstring("hand")&" "&home.cursordetail.getstring("seite")&" "&home.cursordetail.getstring("nummer")&" "&home.cursordetail.getstring("position")
					Else
						lblrechts.Text = home.cursordetail.getstring("hand")&" "&home.cursordetail.getstring("seite")&" "&home.cursordetail.getstring("bezeichnung")&" "&home.cursordetail.getstring("position")
					End If
				
				Else    'Bild links
					If File.Exists("..\files\",grafik) Then
						bildLinks.SetImage(xui.LoadBitmapResize("..\files\",grafik,bildLinks.Width,bildLinks.Height,True))
					Else
						bildLinks.SetImage(xui.LoadBitmap("..\files\","smiley.png"))
					End If
				
					nummer = home.cursordetail.getstring("nummer").trim
			
					If nummer <= 26 Then
						lbllinks.Text = home.cursordetail.getstring("hand")&" "&home.cursordetail.getstring("seite")&" "&home.cursordetail.getstring("nummer")&" "&home.cursordetail.getstring("position")
					Else
						lbllinks.Text = home.cursordetail.getstring("hand")&" "&home.cursordetail.getstring("seite")&" "&home.cursordetail.getstring("bezeichnung")&" "&home.cursordetail.getstring("position")
					End If
					
				End If
		
			End If  'nur beim richtigen Schritt handeln
		End If    'nur richtige Stromseite behandeln
	Loop
	#else
	Dim anzahl As Int = home.cursordetail.RowCount 'nicht Columncount, sonst wird Spaltenanzahl gezählt !
	For i = 0 To anzahl - 1
		home.cursordetail.Position = i
		If home.cursordetail.GetString("Stromseite") = home.stromseite Then
			Dim bildschritt As Int = home.cursordetail.Getint("bildwechsel")
			If  bildschritt = Schritt Then 'nur die Bilder aktualisieren
				Dim grafik As String = home.cursordetail.getstring("grafik").trim
				grafik = grafik.ToLowerCase
				If home.cursordetail.Getstring("hand").trim = "R" Then
					If File.Exists(File.Dirassets,grafik) Then
						bildrechts.Bitmap=LoadBitmapResize(File.Dirassets,grafik,bildrechts.Width,bildrechts.Height,True)
					Else
						bildrechts.Bitmap=LoadBitmap(File.Dirassets,"smiley.png")
					End If
					
					nummer = home.cursordetail.getstring("nummer").trim
					If nummer <= 26 Then
						lblrechts.Text = home.cursordetail.getstring("hand")&" "&home.cursordetail.getstring("seite")&" "&home.cursordetail.getstring("nummer")&" "&home.cursordetail.getstring("position")
					Else
						lblrechts.Text = home.cursordetail.getstring("hand")&" "&home.cursordetail.getstring("seite")&" "&home.cursordetail.getstring("bezeichnung")&" "&home.cursordetail.getstring("position")
					End If
				
					lblrechts.BringToFront
					
				Else    'Bild links
					If File.Exists(File.Dirassets,grafik) Then
						bildLinks.Bitmap=LoadBitmapResize(File.Dirassets,grafik,bildLinks.Width,bildLinks.Height,True)
					Else
						bildLinks.Bitmap=LoadBitmap(File.Dirassets,"smiley.png")
					End If
				
					nummer = home.cursordetail.getstring("nummer").trim
			
					If nummer <= 26 Then
						lbllinks.Text = home.cursordetail.getstring("hand")&" "&home.cursordetail.getstring("seite")&" "&home.cursordetail.getstring("nummer")&" "&home.cursordetail.getstring("position")
					Else
						lbllinks.Text = home.cursordetail.getstring("hand")&" "&home.cursordetail.getstring("seite")&" "&home.cursordetail.getstring("bezeichnung")&" "&home.cursordetail.getstring("position")
					End If
					
					lbllinks.BringToFront
				End If
		
			End If  'nur beim richtigen Schritt handeln
		End If    'nur richtige Stromseite behandeln
	Next
	#End If
End Sub

#if b4j
Sub btnback_MouseClicked (EventData As MouseEvent)
	btnback_click
End Sub
#end if

Sub btnback_click     'eine Folge rueckwaerts
	If countStep > 1 Then
		countStep = countStep - 1
		ladeStep(countStep)
	Else
		tm.Initialize(Root)
		tm.Show("Schritt 1 erreicht !")
	End If	
End Sub

#if b4j
Sub bildlinks_MouseClicked (EventData As MouseEvent)
	bildlinks_Click
End Sub
#end if
	
Sub bildlinks_Click
	'spielt alle weiteren Bildfolgen, die im Resultset gespeichert sind, ab Position 1
	
	#if b4j
		countStep = countStep + 1
		If countStep > schrittmax Then
			tm.Initialize(Root)
			tm.Show("Ende der Stromsequenz !")
		Else
			ladeStep(countStep)
		End If
	#Else
		Dim anzahl As Int
		anzahl = home.cursordetail.rowcount
		Log("Anzahl "&anzahl& " schrittmax: "&schrittmax& " countstep:"&countStep)
		For i = 0 To anzahl - 1
			home.cursordetail.Position = i
			If home.cursordetail.getint("bildwechsel") > schrittmax Then schrittmax = schrittmax + 1
		Next
		countStep = countStep + 1
		If countStep > schrittmax Then
			tm.Initialize(Root)
			tm.Show("Ende der Stromsequenz !")
			
		Else
			ladeStep(countStep)
		End If
	#end if	

	
End Sub

#if b4j
Sub bildrechts_MouseClicked (EventData As MouseEvent)
	bildlinks_Click	
End Sub
#end if

Sub bildrechts_click
	bildlinks_Click	'egal wo man auf den Bildschirm klickt
End Sub

#if b4j
Sub btnvor_MouseClicked (EventData As MouseEvent)
	bildlinks_Click
End Sub
#End If
Sub btnvor_click
	bildlinks_Click	'egal wo man auf den Bildschirm klickt
End Sub