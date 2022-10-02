B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=8.5
@EndOfDesignText@

Sub Class_Globals
	Private Root As B4XView 'ignore
	Private xui As XUI 'ignore
'	Dim robot As JavaObject
	Private clv1 As CustomListView
	
	#if b4j
		Private fx As JFX
	#else
		Private im As IME							'um Keyboard wieder einzuklappen
	#end if
	'Dim mFtp As SFtp								'Für DB-Upload uses Jsch Bobliothek für SFTP
	Private homepage As B4XMainPage
	Private edtName As B4XFloatTextField
	Private edtVorname As B4XFloatTextField
	Private dGeburt As B4XFloatTextField
	Private edtEmail As B4XFloatTextField
	Private edtMobil As B4XFloatTextField
	Private edtZeit As B4XFloatTextField
	Private Zeitzone As B4XComboBox
	Private designdate,designtime As String
	Private dlg As B4XDialog
	Private tm As BCToast
	Type Planetwerte(ETorR As Int,ELineR As Int,sabR As Int,colorR As Int,toneR As Int,baseR As Int,planet As String,eTorS As Int,ElineS As Int,sabS As Int, farbeS As Int, toneS As Int, baseS As Int)
	Type statusZentren(z1 As String,z2 As String,z3 As String,z4 As String,z5 As String, z6 As String,z7 As String,z8 As String,z9 As String)
	Private btnEsc As Button
	Private btnSave As Button

	'6 Werte je Planet
	Private eSabR,ESabS,ELineR,ElineS,ETorR,eTorS As B4XFloatTextField
	Private textplanet As Label
	Public planet() As Int = Array As Int(5,13,4,14,15,3,2,1,9,10,11,12,8,16) 'IdPlanet aus Tabelle Planeten
	Private planetText() As String 
	Private weiblich As CheckBox
	'Berechnung der Planetenpositionen
	Private tz As Int										'Zeitzone bei Geburt
	'Private jut As Double
	Private tod As Double
	Private jdp, jdd As Double
	Private swe1 As SwissEph
	Private swed As SweDate
	Private Natalp(13)As Double
	Private Natald(13) As Double
	Private tore() As Int = Array As Int (41, 19, 13, 49, 30, 55, 37, 63, 22, 36, 25, 17, 21, 51, 42, 3, 27, 24, 2, 23, 8, 20, 16, 35, 45, 12, 15, 52, 39, 53, 62, 56, 31, 33, 7, 4, 29, 59, 40, 64, 47, 6, 46, 18, 48, 57, 32, 50, 28, 44, 1, 43, 14, 34, 9, 5, 26, 11, 10, 58, 38, 54, 61, 60)
	Public planetEph() As String = Array As String ("Sonne","Mond","Merkur","Venus","Mars","Jupiter","Saturn","Uranus","Neptun","Pluto","","N-Knoten","","","","Chiron") 'Position ist Wert für EPH-Berechnung
	Public hdplanetReihenfolge() As Int = Array As Int(0,1,11,2,3,4,5,6,7,8,9,15) 'Chiron = 15
	
	'Für Anzeige Zeitzonenbild
	Private textengine As BCTextEngine
	Private BBdialog As BBCodeView
	Private helpzeitzone As Label
	
	'Berechnete Werte
	Private numweg As Int
	Private hdcolorS,hdcolorM,hdtoneS,hdtoneM,hdcolorSchwarzS,hdtoneSchwarzS As String
	
	Private dGeburtDatePicker As Button
	Private dZeitPicker As Button
	Private datetemplate As B4XDateTemplate
	Private lbl0Email As Label
	Private lbl0Geburt As Label
	Private lbl0GeburtZeit As Label
	Private lbl0Mobil As Label
	Private lbl0Name As Label
	Private lbl0Vorname As Label
End Sub


'You can add more parameters here.
Public Sub Initialize As Object
	homepage = B4XPages.GetPage("MainPage") 'sonst ist homepage evtl. nicht definiert, wenn von Hauptseite Aktualisierung Transite aufgerufen wird.
	Return Me
End Sub

'This event will be called once, before the page becomes visible.
Private Sub B4XPage_Created (Root1 As B4XView)
	Root = Root1
	Root.LoadLayout("PersonNeu")
	dlg.Initialize(Root)
		homepage.setTitelzeile("Bitte Personendaten eintragen")
	#if b4j
		Dim F As Form = B4XPages.GetNativeParent(Me)
		F.WindowWidth = fx.PrimaryScreen.MaxX - fx.PrimaryScreen.MinX           'set the screen to full width/height
		F.WindowLeft = fx.PrimaryScreen.MinX
		F.WindowHeight= fx.PrimaryScreen.MaxY - fx.PrimaryScreen.MinY
		F.WindowTop = fx.PrimaryScreen.MinY
	#end if
	planetText = Array As String(homepage.translate(Main.sprache,200),homepage.translate(Main.sprache,202),homepage.translate(Main.sprache,203),homepage.translate(Main.sprache,205),homepage.translate(Main.sprache,206),homepage.translate(Main.sprache,207),homepage.translate(Main.sprache,208),homepage.translate(Main.sprache,209),homepage.translate(Main.sprache,210),homepage.translate(Main.sprache,211),homepage.translate(Main.sprache,212),"Chiron") 'Sonne","Mond","Auf Mondk.","Merkur","Venus","Mars","Jupiter","Saturn","Uranus","Neptun","Pluto","Chiron"
	'erzeuge die 13 Reihen mit den Planetwerten nach HD
	fillComboBoxes
End Sub

Sub B4XPage_Appear
	
	B4XPages.SetTitle(Me, homepage.translate(Main.sprache,22))
	'delete old values
	clv1.Clear
	edtName.text = ""
	edtVorname.text = ""
	dGeburt.text = ""
	edtEmail.text = ""
	edtMobil.text = ""
	edtZeit.Text=""
	lbl0Name.Text=homepage.translate(Main.sprache,113)
	lbl0Vorname.Text=homepage.translate(Main.sprache,114)
	edtName.HintText=homepage.translate(Main.sprache,113)
	edtVorname.HintText=homepage.translate(Main.sprache,114)
	weiblich.Text=homepage.translate(Main.sprache,115)
	lbl0Geburt.Text=homepage.translate(Main.sprache,26)
	lbl0GeburtZeit.Text=homepage.translate(Main.sprache,79)
	btnSave.Text=homepage.translate(Main.sprache,116)
	btnEsc.Text=homepage.translate(Main.sprache,102)
	#if b4a
		Dim et As EditText =edtZeit.TextField
		im.SetCustomFilter(et,et.INPUT_TYPE_NUMBERS,"0123456789.:")
		Dim ed As EditText =dGeburt.TextField
		im.SetCustomFilter(ed,ed.INPUT_TYPE_NUMBERS,"0123456789.")
	#end if
	edtVorname.mBase.RequestFocus
End Sub

Sub edtZeit_EnterPressed
	Dim str As String =edtZeit.Text
	If str.length<>5 Then
		edtZeit.RequestFocusAndShowKeyboard
	End If
	str=str.Replace(".",":")
	edtZeit.Text=str
End Sub

Sub edtemail_FocusChanged (HasFocus As Boolean)
	If edtEmail.Text.Contains("@") = False Then
		edtEmail.RequestFocusAndShowKeyboard
	End If
End Sub

'Keine Leerzeichen bei Doppelnamen
Sub edtVorname_FocusChanged (HasFocus As Boolean)
	Dim str As String = edtVorname.Text
	If str.Contains(" ") = True Then
		xui.MsgboxAsync(homepage.translate(Main.sprache,130),homepage.translate(Main.sprache,98)) 'Keine 2. Vornamen
		edtVorname.RequestFocusAndShowKeyboard
	End If
End Sub

Sub dGeburt_EnterPressed
	Dim str As String = dGeburt.Text
	If str.length<>10 Or str.SubString2(2,3)<>"." Or str.SubString2(4,5)<>"." Then
		dGeburt.RequestFocusAndShowKeyboard
	End If
End Sub
Sub btnEsc_Click
	B4XPages.ClosePage(Me)
End Sub

Sub fillComboBoxes
	Dim l As List

	'Zeitzonen
	l.Initialize
	l.Add("UT")
	l.Add("UT+1 (D,A,CH,I,F,ES)")
	l.Add("UT+2")
	l.Add("UT+3")
	l.Add("UT+4")
	l.Add("UT+5")
	l.Add("UT+6")
	l.Add("UT+7")
	l.Add("UT+8")
	l.Add("UT+9")
	l.Add("UT+10")
	l.Add("UT+11")
	l.Add("UT+12")
	l.Add("UT-11")
	l.Add("UT-10")
	l.Add("UT-9")
	l.Add("UT-8")
	l.Add("UT-7")
	l.Add("UT-6")
	l.Add("UT-5")
	l.Add("UT-4")
	l.Add("UT-3")
	l.Add("UT-2")
	l.Add("UT-1")
	Zeitzone.SetItems(l)
	Zeitzone.SelectedIndex=1
End Sub

Sub setzeZeitzone
	If Zeitzone.SelectedIndex = 0 Then tz = 0
	If Zeitzone.SelectedIndex = 1 Then tz = 1
	If Zeitzone.SelectedIndex = 2 Then tz = 2
	If Zeitzone.SelectedIndex = 3 Then tz = 3
	If Zeitzone.SelectedIndex = 4 Then tz = 4
	If Zeitzone.SelectedIndex = 5 Then tz = 5
	If Zeitzone.SelectedIndex = 6 Then tz = 6
	If Zeitzone.SelectedIndex = 7 Then tz = 7
	If Zeitzone.SelectedIndex = 8 Then tz = 8
	If Zeitzone.SelectedIndex = 9 Then tz = 9
	If Zeitzone.SelectedIndex = 10 Then tz = 10
	If Zeitzone.SelectedIndex = 11 Then tz = 11
	If Zeitzone.SelectedIndex = 12 Then tz = 12
	If Zeitzone.SelectedIndex = 13 Then tz = -11
	If Zeitzone.SelectedIndex = 14 Then tz = -10
	If Zeitzone.SelectedIndex = 15 Then tz = -9
	If Zeitzone.SelectedIndex = 16 Then tz = -8
	If Zeitzone.SelectedIndex = 17 Then tz = -7
	If Zeitzone.SelectedIndex = 18 Then tz = -6
	If Zeitzone.SelectedIndex = 19 Then tz = -5
	If Zeitzone.SelectedIndex = 20 Then tz = -4
	If Zeitzone.SelectedIndex = 21 Then tz = -3
	If Zeitzone.SelectedIndex = 22 Then tz = -2
	If Zeitzone.SelectedIndex = 23 Then tz = -1
End Sub


Sub Haus_berechnen
'	double swe_house_pos(
'
'	double armc,        /* ARMC */
'
'	double geolat,      /* geographic latitude, in degrees */
'
'	double eps,              /* ecliptic obliquity, in degrees */
'
'	int hsys,                /* house method, one of the letters PKRCAV */
'
'	double *xpin,       /* Array of 2 doubles: ecl. longitude And latitude of the planet */
'	
'	char *serr);             /* Return area For error Or warning message */
'
'	The variables armc, geolat, eps, And xpin[0] And xpin[1] (ecliptic longitude And latitude of the planet) must be in degrees. serr must, As usually, point To a character Array of 256 byte.
'
'	The function returns a value between 1.0 And 12.999999, indicating in which house a planet Is And how far from its cusp it Is.
'
'	With house system ‘G’ (Gauquelin sectors), a value between 1.0 And 36.9999999 Is returned. Note that, While all other house systems number house cusps in counterclockwise direction, Gauquelin sectors are numbered in clockwise direction.
'
'	With Koch houses, the function sometimes returns 0, If the computation was Not possible. This happens most often in polar regions, but it can happen at latitudes below 66°33’ As well, e.g. if a body has a high declination And falls within the circumpolar sky. With circumpolar fixed stars (Or asteroids) a Koch house position may be impossible at any geographic location except on the equator.
'
'		The user must decide how To deal with this situation.
'
'		You can use the house positions returned by this function For house horoscopes (Or ”mundane” positions). For this, you have To transform it into a value between 0 And 360 degrees. Subtract 1 from the house number And multiply it with 30, Or mund_pos = (hpos – 1) * 30.
'
'		You will realize that house positions computed like this, e.g. for the Koch houses, will Not agree exactly with the ones that you get applying the Huber ”hand calculation” method. If you want a better agreement, set the ecliptic latitude xpin[1] = 0. Remaining differences result from the fact that Huber’s hand calculation Is a simplification, whereas our computation Is geometrically accurate.

End Sub
Sub PlanetenBerechnen_Click
	edtZeit_EnterPressed 'Falls gleich geklickt wurde ohne Zeitfeld zu verlassen
	
	#if b4a
		im.HideKeyboard
	#End If
	If dGeburt.Text="" Or edtZeit.Text = "" Then Return
	'Zeitzone
	setzeZeitzone	
	
	#if b4j
		Dim ephepath As String  = File.DirData("heilsystem")
		If File.Exists(ephepath,"seas_18.se1")=False Then File.Copy(File.DirAssets,"seas_18.se1",ephepath,"seas_18.se1")
		'Dim ephepath = Mypath+";.;C:\ephe;"
		swe1.swe_set_ephe_path(ephepath)
	#else
		If File.Exists(File.dirinternal,"seas_18.se1")=False Then File.Copy(File.DirAssets,"seas_18.se1",File.DirInternal,"seas_18.se1")
		swe1.swe_set_ephe_path(File.DirInternal)
	#End If
	
	Dim h As Int = edtZeit.text.substring2(0,2)
	Dim m As Int = edtZeit.text.substring2(3,5)
	Dim dd As Int = dGeburt.text.substring2(0,2)
	Dim mm As Int = dGeburt.text.substring2(3,5)
	Dim yy As Int = dGeburt.text.substring2(6,10)
	tod = h + m / 60
	Log("Geburtstag: " & dGeburt.text &", "& edtZeit.text)

	'gleich Quersumme aus Geburtsdatum für numweg berechnen
	Dim zahl As Int 
	zahl=dd+mm+yy
	Dim quer As Int = 0 
	Do While zahl <> 0
		quer = quer + zahl Mod 10
		zahl = zahl / 10
	Loop
	Dim quers As String = quer
	If quers.Length=2 Then 'nochmal zusammenzählen
		numweg = quers.SubString2(0,1)+quers.SubString2(1,2)
		If numweg = 10 Then numweg = 1
	Else
		numweg = quer
	End If
	'Log(numweg)
	
	'Julian date Persönlichkeit bzw. Universal Time ermitteln
	jdp = swed.getJulDay(yy, mm, dd, tod)
	
	'Timezone Offset berücksichtigen
	'GettimezoneOffsetat berücksichtigt die Zeitzone des aktuell verwendeten Endgerätes.
	'berücksichtigt auch die Sommerzeit, allerdings unabhängig von der Jahreszahl
	'Gibt z.B. 2 aus auch bei Datumswerten im Sommer vor 1980
	Dim tzo As Int 
	Dim geblong As Long = DateTime.DateTimeParse(dGeburt.text,edtZeit.text)'Ticks ist gleich Millisekunden in B4X
	tzo = DateTime.GetTimeZoneOffsetAt(geblong)
	Select True
		Case yy >= 1980 And tz=1 And (tzo-tz=1): 
			jdp = jdp - (tzo / 24) 'D,CH,F,ES,England
			geblong = geblong - tzo * DateTime.TicksPerHour
		Case yy < 1980 And tz=1 And (tzo-tz=1): 
			jdp = jdp - (tz / 24)
			geblong = geblong - tz * DateTime.TicksPerHour
		Case Else: 
			jdp = jdp - (tz / 24)
			geblong = geblong - tz * DateTime.TicksPerHour
	End Select
	
	'Design Tore sind 88 Grad Sonnenstand vorher, bei den anderen Planeten wird dieser Stand erst wieder in ein Datum umgerechnet mit der Formel
	DateTime.DateFormat = "dd.MM.yyyy"
	DateTime.TimeFormat="HH:mm"
	Dim subtractdaysd As Double = 88 'Fange bei 88 Tagen an
	Dim subtractticks As Double = subtractdaysd * DateTime.TicksPerDay
	Dim gebdesignlong As Long = geblong - subtractticks
	
	'Anpassen Design-Datum, bis 88 Grad weniger Sonnenstand erreicht sind.
	gebdesignlong = DesignDatumAnpassen(jdp,gebdesignlong)
	Dim designyear As String = DateTime.GetYear(gebdesignlong)
	Dim designmonth As String = DateTime.GetMonth(gebdesignlong)
	Dim designday As String = DateTime.GetDayOfMonth(gebdesignlong)
	designdate = DateTime.Date(gebdesignlong)
	designtime= DateTime.Time(gebdesignlong)
	'sichern der Werte, falls
	'Julian date bzw. Universal Time ermitteln
	Dim h As Int = designtime.substring2(0,2)
	Dim m As Int = designtime.substring2(3,5)
	tod = h + m / 60
	jdd = swed.getJulDay(designyear, designmonth, designday, tod)
	jdd = jdd - (tz / 24) 'Zu UT umwandeln
	For i = 0 To 11 'mit Chiron 12 Planetenpositionen zu ermitteln und Sonne und N-Knoten werden hier errechnet
		Dim pw As Planetwerte
		Dim ir As Int = hdplanetReihenfolge(i)
		Natalp(i) = Get_1_Planet(jdp, ir)
		Natald(i) = Get_1_Planet(jdd, ir)
		pw.Initialize
		pw=ermittleHDTor(Natalp(i),Natald(i),planetText(i))
		#if b4a
			clv1.Add(erzeugePlanetwerte(pw,100%y,40dip),pw)
		#else
			clv1.Add(erzeugePlanetwerte(pw,Root.Width,40),pw)
		#End If
		Select True
			Case planetEph(ir) = "Sonne":'Erde 180 Grad		
				pw = ermittleHDTor(Natalp(i)+180,Natald(i)+180,homepage.translate(Main.sprache,201)) 'Erde
				#if b4a
					clv1.Add(erzeugePlanetwerte(pw,100%y,40dip),pw)
				#else
					clv1.Add(erzeugePlanetwerte(pw,Root.Width,40),pw)
				#End If
			Case planetEph(ir) = "N-Knoten": 'S-Knoten 180 Grad
				pw = ermittleHDTor(Natalp(i)+180,Natald(i)+180,homepage.translate(Main.sprache,204)) 'S-Knoten ist absteigender Mondknoten
				#if b4a
					clv1.Add(erzeugePlanetwerte(pw,100%y,40dip),pw)
				#else
				clv1.Add(erzeugePlanetwerte(pw,Root.Width,40),pw)
				#End If
		End Select
	Next
	swe1.swe_close 'Close all resources
End Sub

public Sub Get_1_Planet(jdx As Double, p_num As Int) As Double
	Dim xx(7) As Double
	Dim serr As StringBuilder
	Dim iflag As Int
	Dim ret_flag As Int
	serr.Initialize
'	For i = 1 To 255
		serr.Append("                                                                                                                                                           ")
'	Next
	#If b4j
		swe1.swe_set_ephe_path(File.DirData("heilsystem")) 'ohne das geht die Chiron-Berechnung nicht
	#else
		swe1.swe_set_ephe_path(File.DirInternal) 'ohne das geht die Chiron-Berechnung nicht
	#End If
	iflag = 2 + 256
	ret_flag = swe1.swe_calc_ut(jdx, p_num, iflag, xx, serr)
	If ret_flag < 0 Then
		Log("Fehler bei Planet Nummer "&p_num)
	End If
	Return xx(0)
End Sub

'Designdatum anpassen, bis exakt 88 Grad Sonnenstandsdifferenz erreicht werden.
Sub DesignDatumAnpassen(jdPerson As Double, gebDlong As Long) As Long
	Dim genauigkeiterreicht As Boolean = False
	Dim winkelP,winkelD,totime,differenz As Double
	Dim designyear,designmonth,designday As String
	Dim jddesign As Double
	Dim designlong As Long
	Dim h,m As Int
	designlong = gebDlong
	winkelP = Get_1_Planet(jdPerson, 0) 'Planet 0 ist Sonne, Winkel Persönlichkeit und Design müssen exakt 88 Grad Differenz haben.
	
	Do While genauigkeiterreicht = False
		designyear = DateTime.GetYear(designlong)
		designmonth = DateTime.GetMonth(designlong)
		designday = DateTime.GetDayOfMonth(designlong)
		designdate = DateTime.Date(designlong)
		designtime = DateTime.Time(designlong)
		'Julian date bzw. Universal Time ermitteln
		h = designtime.substring2(0,2)
		m = designtime.substring2(3,5)
		totime = h + m / 60
		jddesign = swed.getJulDay(designyear, designmonth, designday, totime)
		jddesign = jddesign - (tz / 24) 'Zu UT umwandeln
		winkelD = Get_1_Planet(jddesign, 0)
		differenz = winkelP-winkelD
		If differenz < 0 Then differenz = differenz + 360
		'Log(NumberFormat(winkelP,0,2)&","&NumberFormat(winkelD,0,2)&","&NumberFormat(differenz,0,2))
		Dim diff As Double = Abs(differenz - 88)
		If  diff < 0.001 Then 
			 Exit
		Else
			'Log(differenz & " " & diff)
		End If
		If differenz > 88 Then
			'If designlong < 0 Then 'Alle Datumswerte < 1970
			designlong = designlong + DateTime.TicksPerMinute '1 Minute
		Else
			designlong = designlong - DateTime.TicksPerMinute 
		End If
	Loop
	Return designlong
End Sub


public Sub ermittleHDTor(decimalGradBlack As Double, decimalGradRed As Double,planetstr As String) As Planetwerte
	' Human Design gates start at Gate 41 at 02ยบ00'00" Wassermann, so muss man exakt 58 Grad hinzuzählen.
	Private tl As Planetwerte
	Private decimalGradSab As Double = decimalGradBlack
	decimalGradBlack = decimalGradBlack + 58
	If decimalGradBlack >= 360 Then decimalGradBlack = decimalGradBlack - 360
	If decimalGradSab >= 360 Then decimalGradSab = decimalGradSab - 360
	' Tor
	Dim wert As Double =  (decimalGradBlack / 360) * 64
	Dim toroffset As Int = wert
	Dim tor As Int = tore(toroffset)
	tl.eTorS = tor
	
	'Linie
	Dim exactLine As Double = (decimalGradBlack / 360) * 384
	Dim linie As Int = (exactLine Mod 6) + 1
	tl.eLineS = linie
	
	'Sabisches Symbol
	Dim sabsymbol As Int = berechneSab(decimalGradSab)
	tl.sabS = sabsymbol
	
	'Die schwarzen color,tone,base Werte werden nicht benötigt
	' Color 
	Dim exactColor As Double = (decimalGradBlack / 360) * 2304
	Dim color As Int = (exactColor Mod 6) + 1
	tl.farbeS = color
	' Tone
	Dim exactTone As Double = (decimalGradBlack / 360) * 13824
	Dim tone As Int  = (exactTone Mod 6) + 1
	tl.toneS = tone
	' Base wird nicht verwendet, da zu ungenau
	Dim exactBase As Double = (decimalGradBlack / 360) * 69120
	Dim base As Int = (exactBase Mod 5) + 1
	tl.baseS = base
	'Planet
	tl.planet = planetstr
	If planetstr = homepage.translate(Main.sprache,200) Then 'schwarze Sonne
		hdcolorSchwarzS=color
		hdtoneSchwarzS=tone
'		Log("Schwarze "&planetstr & " ,Color: "&color&" Tone:"&tone&" Base:"&base)
	End If
	
	If decimalGradRed = 0 Then Return tl
	
	'Design-Werte ermitteln
	Private decimalGradSab As Double = decimalGradRed 'Sabisches Symbol wird ohne Offset berechnet
	If decimalGradSab >= 360 Then decimalGradSab = decimalGradSab - 360
	decimalGradRed = decimalGradRed + 58
	If decimalGradRed >= 360 Then decimalGradRed = decimalGradRed - 360
	' Tor
	Dim wert As Double =  (decimalGradRed / 360) * 64
	Dim toroffset As Int = wert
	Dim tor As Int = tore(toroffset)
	tl.eTorR = tor
	
	'Linie
	Dim exactLine As Double = (decimalGradRed / 360) * 384
	Dim linie As Int = (exactLine Mod 6) + 1
	tl.eLineR = linie
	
	'Sabisches Symbol
	
	Dim sabsymbol As Int = berechneSab(decimalGradSab)
	tl.sabR = sabsymbol
	
	' Color
	Dim exactColor As Double = (decimalGradRed / 360) * 2304
	Dim color As Int = (exactColor Mod 6) + 1
	
	tl.colorR = color
	
	' tone
	Dim exactTone As Double = (decimalGradRed / 360) * 13824
	Dim tone As Int  = (exactTone Mod 6) + 1
	tl.toneR = tone

	' Base ist zu ungenau, da muesste Geburtsdatum in Sekunden vorliegen, wird nicht verwendet
	Dim exactBase As Double = (decimalGradRed / 360) * 69120
	Dim base As Int = (exactBase Mod 5) + 1
	tl.baseR = base
	
	If planetstr = homepage.translate(Main.sprache,200) Then 'Color der roten Sonne ist Appetit 
		hdcolorS=color 
		hdtoneS=tone
		Log("Roter "&planetstr & " ,Color: "&color&" Tone:"&tone&" Base:"&base)
	End If
	If planetstr =  homepage.translate(Main.sprache,203) Then 'rote Mondknotenachse
		Log("Roter "&planetstr & " ,Color: "&color&" Tone:"&tone&" Base:"&base)
		hdcolorM=color 
		hdtoneM=tone
	End If

	Return tl
End Sub

'erstellt einen Eintrag eines Planetenwertes
private Sub erzeugePlanetwerte(pw As Planetwerte,weite As Int,hoehe As Int) As B4XView
	Dim p As B4XView = xui.CreatePanel("")
	p.SetLayoutAnimated(0,0,0,weite,hoehe)
	p.LoadLayout("clvitems")
	ETorR.Text = pw.eTorR
	ELineR.Text = pw.eLineR
	eSabR.Text = pw.sabR 
	textplanet.Text = pw.planet
	eTorS.Text = pw.eTorS
	ElineS.Text = pw.eLineS
	ESabS.Text = pw.sabS
    Return p
End Sub

Sub berechneSab(grad As Double) As Int
	'grad ist der Offset ab Start HD bei 2 Grad Wassermann
	'Alle 0,9375 Grad kommt eine neue Linie, beginnend bei Tor 41
	'Sabische Symbole sind immer exakt 1 Grad,
	'd.h. 1 = 0-1 Grad 30 = 29-30 Grad, 360 = 359 - 360 Grad
	'IdSab = der Gradwert ohne Dezimalstellen + 1 ; 0,97 = 0 + 1 = IdSab 1
	Dim sabstr As String = grad.As(String)
	Dim gradint As Int = sabstr				'Nachkommastellen werden abgeschnitten
	Dim sabint As Int = gradint + 1
	Return sabint
	
End Sub
Sub ToreInput_TextChanged (Old As String, New As String)
	Dim o As B4XFloatTextField = Sender
	If Old = "" Then Return
	Try
		Dim num As Int = o.Text
		If num < 1 Or num > 64 Then
			xui.MsgboxAsync(num & " "&homepage.translate(Main.sprache,73),homepage.translate(Main.sprache,74)) 'ist ausserhalb des gültigen Bereiches von 1 - 64
			o.mBase.RequestFocus
		End If
	Catch
		o.mBase.RequestFocus	
		xui.MsgboxAsync(num & " "&homepage.translate(Main.sprache,73),homepage.translate(Main.sprache,74)) 'ist ausserhalb des gültigen Bereiches von 1 - 64
	End Try
End Sub

Sub LinieInput_TextChanged (Old As String, New As String)
	Dim o As B4XFloatTextField = Sender
	If Old = "" Then Return
	Try
		Dim num As Int = o.Text
		If num < 1 Or num > 6 Then
			xui.MsgboxAsync(num & " "&homepage.translate(Main.sprache,75),homepage.translate(Main.sprache,74)) 'ist ausserhalb des gültigen Bereiches von 1 - 6
			o.mBase.RequestFocus
		End If
	Catch
		o.mBase.RequestFocus	
		xui.MsgboxAsync(num & " "&homepage.translate(Main.sprache,75),homepage.translate(Main.sprache,74)) 'ist ausserhalb des gültigen Bereiches von 1 - 6
	End Try
End Sub

'Alle Eingaben speichern und neuen IdName (AUTOINC in _variablen ablegen)
Sub btnSave_Click
	'nachsehen, ob Benutzer schon angelegt ist
	Dim ido As Object
	Dim sb As StringBuilder
	If edtName.Text = "" Or edtVorname.Text = "" Then
		tm.Initialize(Root)
		tm.Show("Bitte Namen und Vornamen eingeben!")
		Return
	End If
	Dim name,vorname As String
	name = edtName.Text.Trim
	vorname = edtVorname.Text.Trim
	
	Dim Query As String = "SELECT IdName from Benutzer where Name='" & name & "' and Vorname= '" & vorname & "'"
	ido = Main.sql.ExecQuerySingleResult(Query)
	If ido <> Null Then
		tm.Initialize(Root)
		tm.Show("Benutzer ist bereits angelegt!")
		Return
	End If

	Dim weiblichWert As Int
	If weiblich.Checked Then weiblichWert = 1
	
	'Emailadresse in Kleinbuchstaben speichern
	Dim emailklein As String = edtEmail.Text.ToLowerCase
	
	'Planetendaten berechnen, werden in clv1 geschrieben
	PlanetenBerechnen_Click
	Sleep(100) 
	'Nochmal die Daten anzeigen
	Dim str As String = homepage.translate(Main.sprache,114) &": "&edtVorname.text&CRLF&homepage.translate(Main.sprache,113)&": "&edtName.text&CRLF& homepage.translate(Main.sprache,26)&": "&dGeburt.Text&CRLF& homepage.translate(Main.sprache,79) &": "&edtZeit.Text&CRLF& homepage.translate(Main.sprache,126) &": "&Zeitzone.SelectedItem
	Dim sf As Object = xui.Msgbox2Async(str, homepage.translate(Main.sprache,5), homepage.translate(Main.sprache,127), homepage.translate(Main.sprache,102), "", Null)
	Wait For (sf) Msgbox_Result (Result As Int)
	If Result <> xui.DialogResponse_Positive Then Return
		
	'Die Basisdaten in Benutzer speichern
	sb.Initialize
	sb.Append("INSERT INTO Benutzer (Frau,Name,Vorname,Geburtsdatum,Geburtszeit,Designdatum,Designuhrzeit,NumWeg,Email,Mobil) VALUES ('")
	sb.Append(weiblichWert).Append("','").Append(name).Append("','").append(vorname).append("','").Append(dGeburt.text).Append("','").Append(edtZeit.Text).Append("','").Append(designdate).Append("','").Append(designtime).append("',").Append(numweg).append(",'").append(emailklein).append("','").append(edtMobil.Text)
	sb.Append("')")
	Main.sql.ExecNonQuery(sb.ToString)
	
	'gleich in allen Sprach-DB's anlegen
'	Main.SQL.Close
'	If homepage.dbname <> "heilsystemdeutsch.db" Then
'		#if b4j
'			Main.sql.InitializeSQLite(xui.DefaultFolder, "heilsystemdeutsch.db", False)
'		#else
'		Main.sql.Initialize(xui.DefaultFolder, "heilsystemdeutsch.db", False)
'		#End If
'		Main.sql.ExecNonQuery(sb.ToString)
'		
'		'Neuen IDName ermitteln und in _variablen ablegen
'		Query = "SELECT IdName from Benutzer where Name='" & name & "' and Vorname= '" & vorname & "'"
'		Dim idd As Int = Main.sql.ExecQuerySingleResult(Query)
'		Dim Query As String = "UPDATE _variablen SET Wert =" & idd & " where Name = 'IdUser'"
'		Main.sql.ExecNonQuery(Query)
'		Main.SQL.Close
'	End If
'	
'	If homepage.dbname <> "heilsystemenglish.db" Then
'		#if b4j
'			Main.sql.InitializeSQLite(xui.DefaultFolder, "heilsystemenglish.db", False)
'		#else
'		Main.sql.Initialize(xui.DefaultFolder, "heilsystemenglish.db", False)
'		#End If
'		Main.sql.ExecNonQuery(sb.ToString)
'		
'		'Neuen IDName ermitteln und in _variablen ablegen
'		Query = "SELECT IdName from Benutzer where Name='" & name & "' and Vorname= '" & vorname & "'"
'		Dim ide As Int = Main.sql.ExecQuerySingleResult(Query)
'		Dim Query As String = "UPDATE _variablen SET Wert =" & ide & " where Name = 'IdUser'"
'		Main.sql.ExecNonQuery(Query)
'		Main.SQL.Close
'	End If
'	If homepage.dbname <> "heilsystemespanol.db" Then
'		#if b4j
'			Main.sql.InitializeSQLite(xui.DefaultFolder, "heilsystemespanol.db", False)
'		#else
'		Main.sql.Initialize(xui.DefaultFolder, "heilsystemespanol.db", False)
'		#End If
'		Main.sql.ExecNonQuery(sb.ToString)
'		'Neuen IDName ermitteln und in _variablen ablegen
'		Query = "SELECT IdName from Benutzer where Name='" & name & "' and Vorname= '" & vorname & "'"
'		Dim ides As Int = Main.sql.ExecQuerySingleResult(Query)
'		Dim Query As String = "UPDATE _variablen SET Wert =" & ides & " where Name = 'IdUser'"
'		Main.sql.ExecNonQuery(Query)
'		Main.SQL.Close
'	End If
'	If homepage.dbname <> "heilsystemfrancais.db" Then
'		#if b4j
'		Main.sql.InitializeSQLite(xui.DefaultFolder, "heilsystemfrancais.db", False)
'		#else
'		Main.sql.Initialize(xui.DefaultFolder, "heilsystemfrancais.db", False)
'		#End If
'		Main.sql.ExecNonQuery(sb.ToString)
'		'Neuen IDName ermitteln und in _variablen ablegen
'		Query = "SELECT IdName from Benutzer where Name='" & name & "' and Vorname= '" & vorname & "'"
'		Dim idf As Int = Main.sql.ExecQuerySingleResult(Query)
'		Dim Query As String = "UPDATE _variablen SET Wert =" & idf & " where Name = 'IdUser'"
'		Main.sql.ExecNonQuery(Query)
'		Main.SQL.Close
'	End If
'	
'	'wieder aktuelle Sprachevariante aktivieren
'	#if b4j
'		Main.sql.InitializeSQLite(xui.DefaultFolder, homepage.dbname, False)
'	#else
'	Main.sql.Initialize(xui.DefaultFolder, homepage.dbname, False)
'	#end if

	'Neuen IDName ermitteln und in _variablen ablegen
	Query = "SELECT IdName from Benutzer where Name='" & name & "' and Vorname= '" & vorname & "'"
	Dim id As Int = Main.sql.ExecQuerySingleResult(Query)
	homepage.iduser = id
	homepage.kvs.Put("iduser",id)
	Dim Query As String = "UPDATE _variablen SET Wert =" & id & " where Name = 'IdUser'"
	Main.sql.ExecNonQuery(Query)	
	Dim anz As Int = clv1.Size - 1
	Log("Anzahl berechneter Planeten:"&anz)
	'Die 13 Planetenwerte + Chiron in HD speichern
	For i = 0 To anz
	  	'Dim hditems As Planetwerte = clv1.GetValue(i)
	 	Dim p As B4XView = clv1.GetPanel(i)
	  	Dim ftr,flr,fts,fls As Int
	 	Dim fsr As String
		Dim fss As String

		If IsNumber(p.GetView(0).GetView(0).Text) Then ftr = (p.GetView(0).GetView(0).Text) Else ftr = 0
		If IsNumber(p.GetView(1).GetView(0).Text) Then flr = (p.GetView(1).GetView(0).Text) Else flr = 0
		If IsNumber(p.GetView(2).GetView(0).Text) Then fsr = (p.GetView(2).GetView(0).Text) Else fsr = 1
		
		If IsNumber(p.GetView(4).GetView(0).Text) Then fts = (p.GetView(4).GetView(0).Text) Else fts = 0
		If IsNumber(p.GetView(5).GetView(0).Text) Then fls = (p.GetView(5).GetView(0).Text) Else fls = 0
		If IsNumber(p.GetView(6).GetView(0).Text) Then fss = (p.GetView(6).GetView(0).Text) Else fss = 1 'Sabisches Symbol 1 bei Fehler
		
		Dim sb,sb1 As StringBuilder
		sb.Initialize
		sb.Append("INSERT INTO HD (IdUser,IdTor,Linie,IdSab,IdPlanet,RotSchwarz)")
		sb.Append(" VALUES (").Append(id).append(",").append(ftr).append(",").append(flr).append(",").append(fsr).append(",")
		sb.append(planet(i)).Append(",'r')")
	
		sb1.Initialize
		sb1.Append("INSERT INTO HD (IdUser,IdTor,Linie,IdSab,IdPlanet,RotSchwarz)")
		sb1.Append(" VALUES (").Append(id).append(",").append(fts).append(",").append(fls).append(",").append(fss).append(",")
		sb1.append(planet(i)).Append(",'s')")
		Main.sql.ExecNonQuery(sb.ToString)
		Main.sql.ExecNonQuery(sb1.ToString)
		
		'in alle Sprachvarianten
'		Main.SQL.Close
'		If homepage.dbname <> "heilsystemdeutsch.db" Then
'		#if b4j
'			Main.sql.InitializeSQLite(xui.DefaultFolder, "heilsystemdeutsch.db", False)
'		#else
'			Main.sql.Initialize(xui.DefaultFolder, "heilsystemdeutsch.db", False)
'		#End If
'			Dim sb,sb1 As StringBuilder
'			sb.Initialize
'			sb.Append("INSERT INTO HD (IdUser,IdTor,Linie,IdSab,IdPlanet,RotSchwarz)")
'			sb.Append(" VALUES (").Append(idd).append(",").append(ftr).append(",").append(flr).append(",").append(fsr).append(",")
'			sb.append(planet(i)).Append(",'r')")
'	
'			sb1.Initialize
'			sb1.Append("INSERT INTO HD (IdUser,IdTor,Linie,IdSab,IdPlanet,RotSchwarz)")
'			sb1.Append(" VALUES (").Append(idd).append(",").append(fts).append(",").append(fls).append(",").append(fss).append(",")
'			sb1.append(planet(i)).Append(",'s')")
'			Main.sql.ExecNonQuery(sb.ToString)
'			Main.sql.ExecNonQuery(sb1.ToString)
'			Main.SQL.Close
'		End If
'	
'		If homepage.dbname <> "heilsystemenglish.db" Then
'			#if b4j
'				Main.sql.InitializeSQLite(xui.DefaultFolder, "heilsystemenglish.db", False)
'			#else
'				Main.sql.Initialize(xui.DefaultFolder, "heilsystemenglish.db", False)
'			#End If
'			Dim sb,sb1 As StringBuilder
'			sb.Initialize
'			sb.Append("INSERT INTO HD (IdUser,IdTor,Linie,IdSab,IdPlanet,RotSchwarz)")
'			sb.Append(" VALUES (").Append(ide).append(",").append(ftr).append(",").append(flr).append(",").append(fsr).append(",")
'			sb.append(planet(i)).Append(",'r')")
'	
'			sb1.Initialize
'			sb1.Append("INSERT INTO HD (IdUser,IdTor,Linie,IdSab,IdPlanet,RotSchwarz)")
'			sb1.Append(" VALUES (").Append(ide).append(",").append(fts).append(",").append(fls).append(",").append(fss).append(",")
'			sb1.append(planet(i)).Append(",'s')")
'			Main.sql.ExecNonQuery(sb.ToString)
'			Main.sql.ExecNonQuery(sb1.ToString)
'			Main.SQL.Close
'		End If
'		If homepage.dbname <> "heilsystemespanol.db" Then
'			#if b4j
'				Main.sql.InitializeSQLite(xui.DefaultFolder, "heilsystemespanol.db", False)
'			#else
'				Main.sql.Initialize(xui.DefaultFolder, "heilsystemespanol.db", False)
'			#End If
'			Dim sb,sb1 As StringBuilder
'			sb.Initialize
'			sb.Append("INSERT INTO HD (IdUser,IdTor,Linie,IdSab,IdPlanet,RotSchwarz)")
'			sb.Append(" VALUES (").Append(ides).append(",").append(ftr).append(",").append(flr).append(",").append(fsr).append(",")
'			sb.append(planet(i)).Append(",'r')")
'	
'			sb1.Initialize
'			sb1.Append("INSERT INTO HD (IdUser,IdTor,Linie,IdSab,IdPlanet,RotSchwarz)")
'			sb1.Append(" VALUES (").Append(ides).append(",").append(fts).append(",").append(fls).append(",").append(fss).append(",")
'			sb1.append(planet(i)).Append(",'s')")
'			Main.sql.ExecNonQuery(sb.ToString)
'			Main.sql.ExecNonQuery(sb1.ToString)
'			Main.SQL.Close
'		End If
'		
'		If homepage.dbname <> "heilsystemfrancais.db" Then
'			#if b4j
'				Main.sql.InitializeSQLite(xui.DefaultFolder, "heilsystemfrancais.db", False)
'			#else
'				Main.sql.Initialize(xui.DefaultFolder, "heilsystemfrancais.db", False)
'			#End If
'			Dim sb,sb1 As StringBuilder
'			sb.Initialize
'			sb.Append("INSERT INTO HD (IdUser,IdTor,Linie,IdSab,IdPlanet,RotSchwarz)")
'			sb.Append(" VALUES (").Append(idf).append(",").append(ftr).append(",").append(flr).append(",").append(fsr).append(",")
'			sb.append(planet(i)).Append(",'r')")
'	
'			sb1.Initialize
'			sb1.Append("INSERT INTO HD (IdUser,IdTor,Linie,IdSab,IdPlanet,RotSchwarz)")
'			sb1.Append(" VALUES (").Append(idf).append(",").append(fts).append(",").append(fls).append(",").append(fss).append(",")
'			sb1.append(planet(i)).Append(",'s')")
'			Main.sql.ExecNonQuery(sb.ToString)
'			Main.sql.ExecNonQuery(sb1.ToString)
'			Main.SQL.Close
'		End If
'	
'		'wieder aktuelle Sprachevariante aktivieren
'		#if b4j
'			Main.sql.InitializeSQLite(xui.DefaultFolder, homepage.dbname, False)
'		#else
'			Main.sql.Initialize(xui.DefaultFolder, homepage.dbname, False)
'		#end if
	Next
	
	'Profil und Inkarnationskreuz berechnen und speichern in allen DB
	berechneundspeichereErweiterteBenutzerdaten(id)
	'HDTyp, Zentren berechnen und abspeichern
	berechneweitereFelder(id) 'keine Transitansicht
	#if user
		'Wenn jetzt exakt 2 Einträge vorhanden sind, dann Möglichkeit geben Nutzer vor dem nächsten Restart der APP zu wechseln
		Dim Query As String = "Select count(*) from Benutzer"
		Dim anz As Int =  Main.sql.ExecQuerySingleResult(Query)
		If anz = 2 Then
			Private mi As B4AMenuItem
			mi = B4XPages.AddMenuItem(Me, "Person wechseln")
			mi.Tag = "Laden"
		End If
	#end if
	
	B4XPages.ClosePage(Me)
End Sub

Sub berechneundspeichereErweiterteBenutzerdaten(id As Int)
	Dim query As String
	'Profil ist Linie schwarze Sonne und rote Sonne
	'InkKreuz ist Tor schwarze Sonne und die Position berechnet sich aus dem Profil
	query = "select IdTor,Linie,RotSchwarz from HD where IdUser ="& id & " and IdPlanet=5" 'Schwarze Sonne
	Dim rs As ResultSet = Main.sql.ExecQuery(query)
	Do While rs.NextRow
		If rs.GetString("RotSchwarz") = "s" Then
			Dim torS As Int = rs.Getint("IdTor")
			Dim linieS As Int =  rs.Getint("Linie")
		Else
			Dim linieR As Int =  rs.Getint("Linie")
		End If
	Loop
	rs.close
	Dim profilkurz As String = linieS & "/" &linieR
	query = "select Profil,Pos from HDProfil where Profil like '"&profilkurz&"%'"
	Dim rs As ResultSet = Main.SQL.ExecQuery(query)
	Dim profil As String
	Dim pos As String
	Do While rs.NextRow
		profil = rs.GetString("Profil")
		pos = rs.Getstring("Pos")
	Loop
	rs.close
	query = "select InName from InKreuz where IdTor="&torS&" and Pos='"&pos&"'"
	Dim inkname As Object = Main.SQL.ExecQuerySingleResult(query)
	If inkname = Null Then inkname=""
	'Profil,InkKreuz,hdtyp abspeichern
	query = "update Benutzer set Profil='"&profil&"',HDInkarnationskreuz='"&inkname&"' where IdName ="&id
	Main.sql.ExecNonQuery(query)

	'in alle Sprachvarianten
'	Main.SQL.Close
'	If homepage.dbname <> "heilsystemdeutsch.db" Then
'		#if b4j
'		Main.sql.InitializeSQLite(xui.DefaultFolder, "heilsystemdeutsch.db", False)
'		#else
'			Main.sql.Initialize(xui.DefaultFolder, "heilsystemdeutsch.db", False)
'		#End If
'		Dim profilkurz As String = linieS & "/" &linieR
'		query = "select Profil,Pos from HDProfil where Profil like '"&profilkurz&"%'"
'		Dim rs As ResultSet = Main.SQL.ExecQuery(query)
'		Dim profil As String
'		Dim pos As String
'		Do While rs.NextRow
'			profil = rs.GetString("Profil")
'			pos = rs.Getstring("Pos")
'		Loop
'		rs.close
'		query = "select InName from InKreuz where IdTor="&torS&" and Pos='"&pos&"'"
'		Dim inkname As Object = Main.SQL.ExecQuerySingleResult(query)
'		If inkname = Null Then inkname=""
'		query = "update Benutzer set Profil='"&profil&"',HDInkarnationskreuz='"&inkname&"' where IdName ="&idd
'		Main.sql.ExecNonQuery(query)
'		Main.SQL.Close
'	End If
'	
'	If homepage.dbname <> "heilsystemenglish.db" Then
'		#if b4j
'		Main.sql.InitializeSQLite(xui.DefaultFolder, "heilsystemenglish.db", False)
'		#else
'			Main.sql.Initialize(xui.DefaultFolder, "heilsystemenglish.db", False)
'		#End If
'		Dim profilkurz As String = linieS & "/" &linieR
'		query = "select Profil,Pos from HDProfil where Profil like '"&profilkurz&"%'"
'		Dim rs As ResultSet = Main.SQL.ExecQuery(query)
'		Dim profil As String
'		Dim pos As String
'		Do While rs.NextRow
'			profil = rs.GetString("Profil")
'			pos = rs.Getstring("Pos")
'		Loop
'		rs.close
'		query = "select InName from InKreuz where IdTor="&torS&" and Pos='"&pos&"'"
'		Dim inkname As Object = Main.SQL.ExecQuerySingleResult(query)
'		If inkname = Null Then inkname=""
'		query = "update Benutzer set Profil='"&profil&"',HDInkarnationskreuz='"&inkname&"' where IdName ="&ide
'		Main.sql.ExecNonQuery(query)
'		Main.SQL.Close
'	End If
'	If homepage.dbname <> "heilsystemespanol.db" Then
'		#if b4j
'		Main.sql.InitializeSQLite(xui.DefaultFolder, "heilsystemespanol.db", False)
'		#else
'			Main.sql.Initialize(xui.DefaultFolder, "heilsystemespanol.db", False)
'		#End If
'		Dim profilkurz As String = linieS & "/" &linieR
'		query = "select Profil,Pos from HDProfil where Profil like '"&profilkurz&"%'"
'		Dim rs As ResultSet = Main.SQL.ExecQuery(query)
'		Dim profil As String
'		Dim pos As String
'		Do While rs.NextRow
'			profil = rs.GetString("Profil")
'			pos = rs.Getstring("Pos")
'		Loop
'		rs.close
'		query = "select InName from InKreuz where IdTor="&torS&" and Pos='"&pos&"'"
'		Dim inkname As Object = Main.SQL.ExecQuerySingleResult(query)
'		If inkname = Null Then inkname=""
'		query = "update Benutzer set Profil='"&profil&"',HDInkarnationskreuz='"&inkname&"' where IdName ="&ides
'		Main.sql.ExecNonQuery(query)
'		Main.SQL.Close
'	End If
'		
'	If homepage.dbname <> "heilsystemfrancais.db" Then
'		#if b4j
'		Main.sql.InitializeSQLite(xui.DefaultFolder, "heilsystemfrancais.db", False)
'		#else
'			Main.sql.Initialize(xui.DefaultFolder, "heilsystemfrancais.db", False)
'		#End If
'		Dim profilkurz As String = linieS & "/" &linieR
'		query = "select Profil,Pos from HDProfil where Profil like '"&profilkurz&"%'"
'		Dim rs As ResultSet = Main.SQL.ExecQuery(query)
'		Dim profil As String
'		Dim pos As String
'		Do While rs.NextRow
'			profil = rs.GetString("Profil")
'			pos = rs.Getstring("Pos")
'		Loop
'		rs.close
'		query = "select InName from InKreuz where IdTor="&torS&" and Pos='"&pos&"'"
'		Dim inkname As Object = Main.SQL.ExecQuerySingleResult(query)
'		If inkname = Null Then inkname=""
'		query = "update Benutzer set Profil='"&profil&"',HDInkarnationskreuz='"&inkname&"' where IdName ="&idf
'		Main.sql.ExecNonQuery(query)
'		Main.SQL.Close
'	End If
'	
'	'wieder aktuelle Sprachevariante aktivieren
'	#if b4j
'	Main.sql.InitializeSQLite(xui.DefaultFolder, homepage.dbname, False)
'	#else
'		Main.sql.Initialize(xui.DefaultFolder, homepage.dbname, False)
'	#End If
	
End Sub

Sub berechnedefinierteZentren(auswahl As Int) As statusZentren
	'iduser = Benutzernummer
	'auswahl 0=Design&Persönlichkeit, 1=Nur Design, 2=Nur Persoenl., 3=D&P, 4=mit Transit, 5=nur Transit
	Dim statuswerte As statusZentren
	Dim zA,zB As Int
	Dim query As String
	
	statuswerte.Initialize
	'Definierten Zentren setzen
	statuswerte.z1 = "n"
	statuswerte.z2 = "n"
	statuswerte.z3 = "n"
	statuswerte.z4 = "n"
	statuswerte.z5 = "n"
	statuswerte.z6 = "n"
	statuswerte.z7 = "n"
	statuswerte.z8 = "n"
	statuswerte.z9 = "n"
	
	Select True
		Case auswahl=0:query = "select * from AktivierteKanaeleRotSchwarz"
		Case auswahl=1:query = "select * from AktivierteKanaeleRot"
		Case auswahl=2:query = "select * from AktivierteKanaeleSchwarz"
		Case auswahl=3:query = "select * from AktivierteKanaeleRotSchwarz"
		Case auswahl=4:query = "select * from AktivierteKanaele"
		Case auswahl=5:query = "select * from AktivierteKanaeleNurTransit"
	End Select
	
	Dim rs As ResultSet = Main.sql.ExecQuery(query)
	Do While rs.NextRow
		'Zentren Setzen
		zA =  rs.Getint("ZentrumA")
		zB =  rs.Getint("ZentrumB")
		'Log("za:"&zA& " zB:"&zB)
		Select True
			Case zA=1: statuswerte.z1="j"
			Case zA=2: statuswerte.z2="j"
			Case zA=3: statuswerte.z3="j"
			Case zA=4: statuswerte.z4="j"
			Case zA=5: statuswerte.z5="j"
			Case zA=6: statuswerte.z6="j"
			Case zA=7: statuswerte.z7="j"
			Case zA=8: statuswerte.z8="j"
			Case zA=9: statuswerte.z9="j"
		End Select
		Select True
			Case zB=1: statuswerte.z1="j"
			Case zB=2: statuswerte.z2="j"
			Case zB=3: statuswerte.z3="j"
			Case zB=4: statuswerte.z4="j"
			Case zB=5: statuswerte.z5="j"
			Case zB=6: statuswerte.z6="j"
			Case zB=7: statuswerte.z7="j"
			Case zB=8: statuswerte.z8="j"
			Case zB=9: statuswerte.z9="j"
		End Select
	Loop
	Return statuswerte
End Sub

Sub berechneweitereFelder(iduser As Int)
	'Alle diese Felder werden nur für das Geburtsdesign bestimmt und in Benutzer gespeichert
	
	'Motorzentren: 1,2,3,4
	'8 ist kein Motorzentrum
	'HDTypKennzeichen in Tabelle Kanaele, wenn das gesetzt ist, ist es eindeutig.
	'1 = Generator-Kanal
	'2 = Projektor-Kanal
	'3 = Manifestor-Kanal
	'4 = Man. Generator-Kanal
	'5 = Reflektor
	
	'Auswahl:
	'Reflektor: keine Kanaele
	'Generator: Generator Kanaele + Projektor Kanäle
	'Projektor: keine Generator Kanaele + Projektor Kanäle
	'Man. Generator: Generator Kanäle + Manifestor Kanäle + mögliche Projektor Kanäle
	'Manifestor: keine Generator Kanäle + Manifestor Kanäle + mögliche Projektor Kanäle
	
	'Ausnahme: Bei Milzzentrum aktiviert ohne Motorzentren, kann es sich um einen Milz-Manifestor oder Milz-Reflektor handeln.
	
	Dim hdtypId As Int		 		'Index für Eintrag des HDtyps in Tabelle HDTyp
	Dim autoId As Int 				'Index für Autorität
	Dim generatorkanal As Boolean 	'Hat auf alle Fälle schon einen Generatorkanal
	Dim zA,zB As Int
	Dim query As String
	Dim statuswerte As statusZentren
	statuswerte.Initialize
	'Definierten Zentren setzen
	Dim z1 As Char = "n"
	Dim z2 As Char = "n"
	Dim z3 As Char = "n"
	Dim z4 As Char = "n"
	Dim z5 As Char = "n"
	Dim z6 As Char = "n"
	Dim z7 As Char = "n"
	Dim z8 As Char = "n"
	Dim z9 As Char = "n"
	
	query = "select * from AktivierteKanaeleRotSchwarz"
	Dim rs As ResultSet = Main.sql.ExecQuery(query)
	Do While rs.NextRow
		'Zentren Setzen
		zA =  rs.Getint("ZentrumA")
		zB =  rs.Getint("ZentrumB")
		Dim kanal As String = rs.Getstring("Kanal")
		Log("Kanal"&kanal&" za:"&zA& " zB:"&zB)
		Select True
			Case zA=1: z1="j"
			Case zA=2:
				 z2="j"
				 generatorkanal = True
			Case zA=3: z3="j"
			Case zA=4: z4="j"
			Case zA=5: z5="j"
			Case zA=6: z6="j"
			Case zA=7: z7="j"
			Case zA=8: z8="j"
			Case zA=9: z9="j"
		End Select
		Select True
			Case zB=1: z1="j"
			Case zB=2:
				z2="j"
				generatorkanal = True
			Case zB=3: z3="j"
			Case zB=4: z4="j"
			Case zB=5: z5="j"
			Case zB=6: z6="j"
			Case zB=7: z7="j"
			Case zB=8: z8="j"
			Case zB=9: z9="j"
		End Select
		If rs.Getint("HDTypKennzeichen") = 1 Then
			If hdtypId <= 1 Then hdtypId = 1 'Generator
		End If
		If rs.Getint("HDTypKennzeichen") = 2 Then 
			If hdtypId <= 2 Then hdtypId = 2 'Projektor
		End If
		If rs.Getint("HDTypKennzeichen") = 3 Then 
			If hdtypId <= 3 Then hdtypId = 3 'Manifestor
		End If
		If rs.Getint("HDTypKennzeichen") = 4 Then 
			If hdtypId <= 4 Then hdtypId = 4 'Manifestierender Generator
		End If
	Loop

	'Reflektor hat nichts durchlaufen
	If hdtypId = 0 Then hdtypId = 5
	
	If generatorkanal = True Then
		If hdtypId = 2 Then hdtypId = 1 'Generator
		If hdtypId = 3 Then hdtypId = 4 'Man. Generator
	End If
	
	If z8="j" And z2="n" And z3="n" Then 
		'zuletzt nachsehen, ob Manifestoren oder Projektoren durch die Milz vorliegen
		'Milz-Manifestoren sind Menschen, bei denen das Ego oder die Wurzelmotoren zusammen mit oder durch das Milzzentrum zur Kehle hin definiert sind, ohne dass der Sakral- oder Solarplexus definiert ist.
		'Milzprojektoren sind Personen, bei denen das Milzzentrum ohne das Sakral- oder Solarplexuszentrum definiert ist und keine Motoren an der Kehle angeschlossen sind.
		'*** hdtypId
		hdtypId = 2 'Wenn keine der Ausnahmen zutrifft, handelt es sich um einen Projektor
		'Jetzt die Ausnahmen überprüfen, ob er zum Manifestor werden kann.
		Dim anz As Int = Main.SQL.ExecQuerySingleResult("select count(*) from AktivierteKanaeleRotSchwarz where Kanal='18-58' or Kanal='28-38' or Kanal='32-54'") 'Kanal von Zentrum 1 nach 8
		If anz > 0 Then
			Dim anz1 As Int = Main.SQL.ExecQuerySingleResult("select count(*) from AktivierteKanaeleRotSchwarz where Kanal='16-48' or Kanal='20-57'") 'Kanal von Zentrum 8 nach 5 Kehle
			If anz1 > 0 Then
				hdtypId = 3
			End If
		End If
		'Weg von EGO über Milz zur Kehle
		Dim anz As Int = Main.SQL.ExecQuerySingleResult("select count(*) from AktivierteKanaeleRotSchwarz where Kanal='26-44'") 'Kanal von Zentrum 4 nach 8
		If anz > 0 Then
			Dim anz1 As Int = Main.SQL.ExecQuerySingleResult("select count(*) from AktivierteKanaeleRotSchwarz where Kanal='20-57' or Kanal='16-48'") 'Kanal von Zentrum 8 nach 5 Kehle
			If anz1 > 0 Then
				hdtypId = 3
			End If
		End If
	End If
	
	
	If z4="j" And z9="j" And z5="j" And z2="n" Then
		'Weg von EGO über G-Zentrum zur Kehle ist auch Manifestor
		Dim anz As Int = Main.SQL.ExecQuerySingleResult("select count(*) from AktivierteKanaeleRotSchwarz where Kanal='25-51'") 'Kanal von Zentrum 4 nach 9
		If anz > 0 Then
			Dim anz1 As Int = Main.SQL.ExecQuerySingleResult("select count(*) from AktivierteKanaeleRotSchwarz where Kanal='1-8' or Kanal='7-31' or Kanal='13-33'") 'Kanal von Zentrum 9 nach 5 Kehle
			If anz1 > 0 Then
				hdtypId = 3
			End If
		End If
	End If
	
	If z2="j" And z5="j" And hdtypId<>4 Then
		'Weg von EGO über Milz zur Kehle und Z2="j" wäre man. Generator
		Dim anz As Int = Main.SQL.ExecQuerySingleResult("select count(*) from AktivierteKanaeleRotSchwarz where Kanal='26-44'") 'Kanal von Zentrum 4 nach 8
		If anz > 0 Then
			Dim anz1 As Int = Main.SQL.ExecQuerySingleResult("select count(*) from AktivierteKanaeleRotSchwarz where Kanal='20-57' or Kanal='16-48'") 'Kanal von Zentrum 8 nach 5 Kehle
			If anz1 > 0 Then
				hdtypId = 4
			End If
		End If
	End If
	If z2="j" And z5="j" And hdtypId<>4 Then
		Dim anz As Int = Main.SQL.ExecQuerySingleResult("select count(*) from AktivierteKanaeleRotSchwarz where Kanal='25-51'")
		If anz > 0 Then
			Dim anz1 As Int = Main.SQL.ExecQuerySingleResult("select count(*) from AktivierteKanaeleRotSchwarz where Kanal='13-33' or Kanal='1-8' or Kanal='7-31' or Kanal='10-20'")
			If anz1 > 0 Then
				hdtypId = 4
			End If
		End If
	End If
	
	If z2="j" And z5="j" And hdtypId<>4 Then 'Überprüfen ob indirekte Verbindung von Motorzentrum zur Kehle existiert und damit doch noch man. Generator wird.
		Dim anz As Int = Main.SQL.ExecQuerySingleResult("select count(*) from AktivierteKanaeleRotSchwarz where Kanal='21-45'")
		If anz > 0 Then
			hdtypId = 4
		End If
	End If
	
	If z2="j" And z5="j" And hdtypId<>4 Then 'Überprüfen ob indirekte Verbindung von Motorzentrum zur Kehle existiert und damit doch noch man. Generator wird.
		Dim anz As Int = Main.SQL.ExecQuerySingleResult("select count(*) from AktivierteKanaeleRotSchwarz where Kanal='29-46' or Kanal='2-14' or Kanal='5-15' or Kanal='10-34'")
		If anz > 0 Then
			Dim anz1 As Int = Main.SQL.ExecQuerySingleResult("select count(*) from AktivierteKanaeleRotSchwarz where Kanal='13-33' or Kanal='1-8' or Kanal='7-31' or Kanal='10-20'")
			If anz1 > 0 Then
				hdtypId = 4
			End If
		End If
	End If
	If z2="j" And z5="j" And hdtypId<>4 Then 'Überprüfen ob indirekte Verbindung von Motorzentrum zur Kehle existiert und damit doch noch man. Generator wird.
		Dim anz As Int = Main.SQL.ExecQuerySingleResult("select count(*) from AktivierteKanaeleRotSchwarz where Kanal='9-52' or Kanal='3-60' or Kanal='42-53'")
		If anz > 0 Then
			Dim anz1 As Int = Main.SQL.ExecQuerySingleResult("select count(*) from AktivierteKanaeleRotSchwarz where Kanal='18-58' or Kanal='28-38' or Kanal='32-54'")
			If anz1 > 0 Then
				Dim anz2 As Int = Main.SQL.ExecQuerySingleResult("select count(*) from AktivierteKanaeleRotSchwarz where Kanal='16-48' or Kanal='20-57'")
				If anz2 > 0 Then
					hdtypId = 4
				End If
			End If
		End If
	End If
	
	
	query = "select HDTyp from HDTyp where Id="&hdtypId
	Dim hdtyp As String = Main.SQL.ExecQuerySingleResult(query)
	'Log(hdtyp&"Zentren:"&z1&z2&z3&z4&z5&z6&z7&z8&z9)
	
	'Berechne Autorität
	If z3="j" Then autoId=1 'Emotional
	If z8="j" And z2="n" And z3="n" Then autoId=2 'Milz
	If z2="j" And z3="n" Then autoId=3 'Sakral
	If z2="n" And z3="n" And z8="n" And z4="j" And z5="j" Then autoId=4 'EGO	
	If z2="n" And z3="n" And z8="n" And z5="j" And z9="j" Then autoId=5 'Selbst	
	If z2="n" And z3="n" And z4="n" And z8="n" And z9="n" Then autoId=6 'Keine innere Autorität

	'Wenn Kanal 25-51 definiert ist, handelt es sich um EGO Autorität
	If z2="n" And z3="n" And z8="n" And z4="j" And z9="j" Then
		Dim anz As Int = Main.SQL.ExecQuerySingleResult("select count(*) from AktivierteKanaeleRotSchwarz where Kanal='25-51'")
		If anz > 0 Then
			autoId=4  'EGO
		End If
	End If
	query = "select Autoritaet from HDAutoritaet where Id="&autoId
	Dim hdautorität As String = Main.SQL.ExecQuerySingleResult(query)
	
	'Berechne Ernaehrung
	'Wird aus Color und Base Sonne abgeleitet
	Dim idernährung As Int
	If hdcolorS=1 And hdtoneS<=3 Then idernährung=1
	If hdcolorS=1 And hdtoneS>3 Then idernährung=2
	If hdcolorS=2 And hdtoneS<=3 Then idernährung=3
	If hdcolorS=2 And hdtoneS>3 Then idernährung=4
	If hdcolorS=3 And hdtoneS<=3 Then idernährung=5
	If hdcolorS=3 And hdtoneS>3 Then idernährung=6
	If hdcolorS=4 And hdtoneS<=3 Then idernährung=7
	If hdcolorS=4 And hdtoneS>3 Then idernährung=8
	If hdcolorS=5 And hdtoneS<=3 Then idernährung=9
	If hdcolorS=5 And hdtoneS>3 Then idernährung=10
	If hdcolorS=6 And hdtoneS<=3 Then idernährung=11 
	If hdcolorS=6 And hdtoneS>3 Then idernährung=12
	query = "select HDErnaehrung from HDErnaehrung where Id="&idernährung
	Dim hdernährung As String= Main.SQL.ExecQuerySingleResult(query)
	
	'Szene wird aus Color und Tone der roten Mondknotenachse abgeleitet
	Dim idszene As Int
	If hdcolorM=1 And hdtoneM<=3 Then idszene=1
	If hdcolorM=1 And hdtoneM>3 Then idszene=2
	If hdcolorM=2 And hdtoneM<=3 Then idszene=3
	If hdcolorM=2 And hdtoneM>3 Then idszene=4
	If hdcolorM=3 And hdtoneM<=3 Then idszene=5
	If hdcolorM=3 And hdtoneM>3 Then idszene=6
	If hdcolorM=4 And hdtoneM<=3 Then idszene=7
	If hdcolorM=4 And hdtoneM>3 Then idszene=8
	If hdcolorM=5 And hdtoneM<=3 Then idszene=9
	If hdcolorM=5 And hdtoneM>3 Then idszene=10
	If hdcolorM=6 And hdtoneM<=3 Then idszene=11
	If hdcolorM=6 And hdtoneM>3 Then idszene=12
	query = "select Szene from Szene where Id="&idszene
	Dim hdszene As String= Main.SQL.ExecQuerySingleResult(query)
	
	'Motivation ist Color der bewussten schwarzen Sonne-Erde Achse
	query = "select Motivation from Motivation where Id="&hdcolorSchwarzS
	Dim hdmotivation As String = Main.SQL.ExecQuerySingleResult(query)
	
	'Kognition ist Tone der bewussten schwarzen Sonne-Erde Achse
	query = "select Kognition from Kognition where Id="&hdtoneSchwarzS
	Dim hdkognition As String = Main.SQL.ExecQuerySingleResult(query)
	'Abspeichern in Benutzer
	query = "update Benutzer set HDTyp='"&hdtyp&"',Autoritaet='"&hdautorität&"',HDErnaehrung='"&hdernährung&"',Szene='"&hdszene&"',Motivation='"&hdmotivation&"',Kognition='"&hdkognition&"',Z1='"&z1&"',Z2='"&z2&"',Z3='"&z3&"',Z4='"&z4&"',Z5='"&z5&"',Z6='"&z6&"',Z7='"&z7&"',Z8='"&z8&"',Z9='"&z9&"' where IdName ="&iduser
	Main.sql.ExecNonQuery(query)
	
'	'in alle Sprachvarianten
'	Main.SQL.close
'	If homepage.dbname <> "heilsystemdeutsch.db" Then
'		#if b4j
'			Main.sql.InitializeSQLite(xui.DefaultFolder, "heilsystemdeutsch.db", False)
'		#else
'			Main.sql.Initialize(xui.DefaultFolder, "heilsystemdeutsch.db", False)
'		#End If
'		'Alle Texte in der passenden Sprache ermitteln
'		query = "select HDTyp from HDTyp where Id="&hdtypId
'		Dim hdtyp As String = Main.SQL.ExecQuerySingleResult(query)
'		query = "select Autoritaet from HDAutoritaet where Id="&autoId
'		Dim hdautorität As String = Main.SQL.ExecQuerySingleResult(query)
'		query = "select HDErnaehrung from HDErnaehrung where Id="&idernährung
'		Dim hdernährung As String= Main.SQL.ExecQuerySingleResult(query)
'		query = "select Szene from Szene where Id="&idszene
'		Dim hdszene As String= Main.SQL.ExecQuerySingleResult(query)
'		query = "select Motivation from Motivation where Id="&hdcolorSchwarzS
'		Dim hdmotivation As String = Main.SQL.ExecQuerySingleResult(query)
'		query = "select Kognition from Kognition where Id="&hdtoneSchwarzS
'		Dim hdkognition As String = Main.SQL.ExecQuerySingleResult(query)
'		
'		query = "update Benutzer set HDTyp='"&hdtyp&"',Autoritaet='"&hdautorität&"',HDErnaehrung='"&hdernährung&"',Szene='"&hdszene&"',Motivation='"&hdmotivation&"',Kognition='"&hdkognition&"',Z1='"&z1&"',Z2='"&z2&"',Z3='"&z3&"',Z4='"&z4&"',Z5='"&z5&"',Z6='"&z6&"',Z7='"&z7&"',Z8='"&z8&"',Z9='"&z9&"' where IdName ="&idd
'		Main.sql.ExecNonQuery(query)
'		Main.SQL.Close
'	End If
'	
'	If homepage.dbname <> "heilsystemenglish.db" Then
'		#if b4j
'			Main.sql.InitializeSQLite(xui.DefaultFolder, "heilsystemenglish.db", False)
'		#else
'			Main.sql.Initialize(xui.DefaultFolder, "heilsystemenglish.db", False)
'		#End If
'		
'		'Alle Texte in der passenden Sprache ermitteln
'		query = "select HDTyp from HDTyp where Id="&hdtypId
'		Dim hdtyp As String = Main.SQL.ExecQuerySingleResult(query)
'		query = "select Autoritaet from HDAutoritaet where Id="&autoId
'		Dim hdautorität As String = Main.SQL.ExecQuerySingleResult(query)
'		query = "select HDErnaehrung from HDErnaehrung where Id="&idernährung
'		Dim hdernährung As String= Main.SQL.ExecQuerySingleResult(query)
'		query = "select Szene from Szene where Id="&idszene
'		Dim hdszene As String= Main.SQL.ExecQuerySingleResult(query)
'		query = "select Motivation from Motivation where Id="&hdcolorSchwarzS
'		Dim hdmotivation As String = Main.SQL.ExecQuerySingleResult(query)
'		query = "select Kognition from Kognition where Id="&hdtoneSchwarzS
'		Dim hdkognition As String = Main.SQL.ExecQuerySingleResult(query)
'		
'		query = "update Benutzer set HDTyp='"&hdtyp&"',Autoritaet='"&hdautorität&"',HDErnaehrung='"&hdernährung&"',Szene='"&hdszene&"',Motivation='"&hdmotivation&"',Kognition='"&hdkognition&"',Z1='"&z1&"',Z2='"&z2&"',Z3='"&z3&"',Z4='"&z4&"',Z5='"&z5&"',Z6='"&z6&"',Z7='"&z7&"',Z8='"&z8&"',Z9='"&z9&"' where IdName ="&ide
'		Main.sql.ExecNonQuery(query)
'		Main.SQL.Close
'	End If
'	If homepage.dbname <> "heilsystemespanol.db" Then
'		#if b4j
'			Main.sql.InitializeSQLite(xui.DefaultFolder, "heilsystemespanol.db", False)
'		#else
'			Main.sql.Initialize(xui.DefaultFolder, "heilsystemespanol.db", False)
'		#End If
'		
'		'Alle Texte in der passenden Sprache ermitteln
'		query = "select HDTyp from HDTyp where Id="&hdtypId
'		Dim hdtyp As String = Main.SQL.ExecQuerySingleResult(query)
'		query = "select Autoritaet from HDAutoritaet where Id="&autoId
'		Dim hdautorität As String = Main.SQL.ExecQuerySingleResult(query)
'		query = "select HDErnaehrung from HDErnaehrung where Id="&idernährung
'		Dim hdernährung As String= Main.SQL.ExecQuerySingleResult(query)
'		query = "select Szene from Szene where Id="&idszene
'		Dim hdszene As String= Main.SQL.ExecQuerySingleResult(query)
'		query = "select Motivation from Motivation where Id="&hdcolorSchwarzS
'		Dim hdmotivation As String = Main.SQL.ExecQuerySingleResult(query)
'		query = "select Kognition from Kognition where Id="&hdtoneSchwarzS
'		Dim hdkognition As String = Main.SQL.ExecQuerySingleResult(query)
'		
'		query = "update Benutzer set HDTyp='"&hdtyp&"',Autoritaet='"&hdautorität&"',HDErnaehrung='"&hdernährung&"',Szene='"&hdszene&"',Motivation='"&hdmotivation&"',Kognition='"&hdkognition&"',Z1='"&z1&"',Z2='"&z2&"',Z3='"&z3&"',Z4='"&z4&"',Z5='"&z5&"',Z6='"&z6&"',Z7='"&z7&"',Z8='"&z8&"',Z9='"&z9&"' where IdName ="&ides
'		Main.sql.ExecNonQuery(query)
'		Main.SQL.Close
'	End If
'		
'	If homepage.dbname <> "heilsystemfrancais.db" Then
'		#if b4j
'			Main.sql.InitializeSQLite(xui.DefaultFolder, "heilsystemfrancais.db", False)
'		#else
'			Main.sql.Initialize(xui.DefaultFolder, "heilsystemfrancais.db", False)
'		#End If
'		
'		'Alle Texte in der passenden Sprache ermitteln
'		query = "select HDTyp from HDTyp where Id="&hdtypId
'		Dim hdtyp As String = Main.SQL.ExecQuerySingleResult(query)
'		query = "select Autoritaet from HDAutoritaet where Id="&autoId
'		Dim hdautorität As String = Main.SQL.ExecQuerySingleResult(query)
'		query = "select HDErnaehrung from HDErnaehrung where Id="&idernährung
'		Dim hdernährung As String= Main.SQL.ExecQuerySingleResult(query)
'		query = "select Szene from Szene where Id="&idszene
'		Dim hdszene As String= Main.SQL.ExecQuerySingleResult(query)
'		query = "select Motivation from Motivation where Id="&hdcolorSchwarzS
'		Dim hdmotivation As String = Main.SQL.ExecQuerySingleResult(query)
'		query = "select Kognition from Kognition where Id="&hdtoneSchwarzS
'		Dim hdkognition As String = Main.SQL.ExecQuerySingleResult(query)
'		
'		query = "update Benutzer set HDTyp='"&hdtyp&"',Autoritaet='"&hdautorität&"',HDErnaehrung='"&hdernährung&"',Szene='"&hdszene&"',Motivation='"&hdmotivation&"',Kognition='"&hdkognition&"',Z1='"&z1&"',Z2='"&z2&"',Z3='"&z3&"',Z4='"&z4&"',Z5='"&z5&"',Z6='"&z6&"',Z7='"&z7&"',Z8='"&z8&"',Z9='"&z9&"' where IdName ="&idf
'		Main.sql.ExecNonQuery(query)
'		Main.SQL.Close
'	End If
'	
'	'wieder aktuelle Sprachevariante aktivieren
'	#if b4j
'		Main.sql.InitializeSQLite(xui.DefaultFolder, homepage.dbname, False)
'	#else
'		Main.sql.Initialize(xui.DefaultFolder, homepage.dbname, False)
'	#end if
End Sub

'Sichert Nutzer und lädt Datenbank auf Server
'Sub btnSaveUpload_Click
'	#if b4a
'		If Sammlung.CheckNetConnections = False Then
'			xui.MsgboxAsync(homepage.translate(Main.sprache,76),"Check Internet")
'			Return
'		End If
'	#end if
'	btnSave_Click
'	datenbankUpload(xui.DefaultFolder,homepage.dbname)
'End Sub
'
'Sub convertTickstoString(t As Long) As String
'	DateTime.DateFormat="dd.MM.yyyy"
'	Dim ret As String = DateUtils.TicksToString(t) 'Format von dateutils dd.mm.yyyy hh.mm.ss daher wird Zeit abgeschnitten
'	ret = ret.SubString2(0,ret.IndexOf(" "))
'	Return ret
'End Sub
'
'Sub GetPanelBasedOnId (list As CustomListView, value As String) As B4XView
'	For i = 0 To list.Size - 1
'		If list.GetValue(i) = value Then Return list.GetPanel(i)
'	Next
'	Return Null
'End Sub


'Sub AutomatischeEingabePunkt
'	robot.InitializeNewInstance("javafx.scene.robot.Robot", Null)
'	Dim KeyCode As JavaObject
'	KeyCode.InitializeStatic("javafx.scene.input.KeyCode")
'	robot.RunMethod("keyPress", Array(KeyCode.GetField("PERIOD")))
'	robot.RunMethod("keyRelease", Array(KeyCode.GetField("PERIOD")))
'End Sub

Sub dgeburt_TextChanged (Old As String, New As String)
#if b4j
	If New.Length = 2 Or New.Length = 5 Then
		'AutomatischeEingabePunkt ' Punkt senden
	End If
#end if
End Sub

Private Sub dGeburt_FocusChanged (HasFocus As Boolean) As Boolean
	'Format überprüfen
	If HasFocus = False Then
		Dim pt As String ="[0-9]{2}\.[0-9]{2}\.[0-9]{4}"
		'Dim pt As String ="\d\d\.\d\d\.\d\d\d\d"  'Ein Punkt wird nur mit vorantehendem \ akzeptiert !
		Dim d As String = dGeburt.Text
  		If Regex.IsMatch(pt,d) Then 
			Return True
		Else
			dGeburt.RequestFocusAndShowKeyboard
			tm.Initialize(Root)
			tm.DurationMs=2000
			tm.Show("Bitte Datum im Format dd.mm.yyyy eigeben!")
		End If
	End If
	Return False
End Sub

#if b4j
Sub helpzeitzone_MouseClicked (EventData As MouseEvent)
#Else
	Sub helpzeitzone_Click	
#End If
	Dim p As B4XView = xui.CreatePanel("")
	#if b4j
	p.SetLayoutAnimated(0, 0, 0, 680, 400)
	#else
		p.SetLayoutAnimated(0, 0, 0, 100%x, 90%y)
	#End If	
	p.LoadLayout("bbdialog")
	textengine.Initialize(p)
	textengine.KerningEnabled = True
	Dim img As String = "zeitzonen.png"
	Dim code As String = _
	$"
[Alignment=center][img FileName=${img} width=640/]
Bitte verändern sie die Zeitzone nur, wenn Sie ihr Geburtsland nicht Deutschland,Österreich,Schweiz,Italien,Frankreich oder Spanien war.
[/Alignment]
	"$
	BBdialog.Text = code
	Dim rs As ResumableSub = dlg.ShowCustom(p, "ok", "", "")
	Wait For (rs) Complete (res As Int)
End Sub

'
'Sub datenbankUpload(verzeichnis As String,db As String)
'	'Lädt die Datenbank auf den Server, database upload
'	mFtp.Initialize("mFtp","heilseminare.com@heilseminare.com","isis2711strato","ssh.strato.de",22)
'	Dim serverfile As String =  "/WordPress_02/meditationen/db/" & db
'	mFtp.UploadFile(verzeichnis, db, serverfile)
'	Log("start upload von "&verzeichnis&"/"&db&" nach "&serverfile)
'End Sub

'Sub mFtp_UploadCompleted (ServerPath As String, Success As Boolean)
'	Log($"miFTP_UploadCompleted (${ServerPath}, ${Success})"$)
'	If Success = False Then
'		xui.MsgboxAsync(LastException.message,"Fehler beim Upload der Datenbank")
'	End If
'End Sub
'
'Sub mFtp_PromptYesNo (Message As String)
'	mFtp.SetPromptResult(True)
'End Sub


#if b4j
	Sub dGeburtDatePicker_MouseClicked (EventData As MouseEvent)
#else
	Private Sub dGeburtDatePicker_Click
#end if	
	datetemplate.Initialize
	datetemplate.MinYear = 1930
	datetemplate.MaxYear = 2060
	Wait For (dlg.ShowTemplate(datetemplate, "", "", "Abbrechen")) Complete (Result As Int)
	If Result = xui.DialogResponse_Positive Then
		dGeburt.Text = DateTime.Date(datetemplate.Date)
	End If
End Sub

#if b4j
	Sub dZeitPicker_MouseClicked (EventData As MouseEvent)
#else
	Private Sub dZeitPicker_Click
#end if
	Private settingsdialog As PreferencesDialog
	Private set As Map
	Dim p As Period
	set.Initialize
	settingsdialog.Initialize(Root, "Uhrzeit der Geburt", 300dip, 200dip)
	settingsdialog.LoadFromJson(File.ReadString(File.DirAssets, "geburtzeit.json"))
	p.Hours=12
	set.Put("geburtZeit",p)
	Wait For (settingsdialog.ShowDialog(set, "OK", "Abbruch")) Complete (Result As Int)
	If Result = xui.DialogResponse_Positive Then 
		p = set.Get("geburtZeit")
		edtZeit.text =  $"$2{p.Hours}:$2{p.Minutes}"$
	End If
End Sub