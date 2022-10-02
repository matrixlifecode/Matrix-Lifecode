B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=11.2
@EndOfDesignText@
Sub Class_Globals
	Private Root As B4XView 'ignore
	Private xui As XUI 'ignore
	Private printer As Printer
	Dim rt As RuntimePermissions
	Private xui As XUI 'ignore
	Private home As B4XMainPage
	Dim pdf As PdfiumCore
	Private PDFView1 As PDFView
	Private btnPrev As Button
	Private lblPages As Label
	Private btnNext As Button
	Private glPages As Int
	Private btnPrint As Button
	Private btnSend As Button
	Private Provider As FileProvider
	Private dir As String 'Verzeichnis
	Private dir As String 'Save-Dir zum Speichern
	Private filename As String 'Nur Dateiname
End Sub

'You can add more parameters here.
Public Sub Initialize As Object
	Return Me
End Sub

'This event will be called once, before the page becomes visible.
Private Sub B4XPage_Created (Root1 As B4XView)
	Root = Root1
	home=B4XPages.GetPage("MainPage")
	'load the layout to Root
	Root.LoadLayout("pdf")
	pdf.Initialize("PDFium")
	Provider.Initialize
	printer.Initialize("")
	
	#if user
		btnPrint.visible = False
		btnSend.visible = True
		dir = File.dirinternal
	#else
		dir = rt.getSafeDirDefaultExternal("")
	#end if
End Sub

private Sub B4XPage_Appear
	Dim pos As Int
	filename = home.pdfDokument
	pos = filename.LastIndexOf("/")
	If pos <> -1 Then '-1 bei nicht gefunden
		If Sammlung.CheckNetConnections = False Then
			xui.MsgboxAsync("no Internet available!","Check Internet")
			Return
		End If
		filename = home.pdfDokument.SubString(pos+1)
		'Datei runterladen und dann anzeigen
		If File.Exists(dir,filename)=False Then
			Dim rs As ResumableSub = inhaltladen(dir,filename)
			Wait For(rs) Complete (Ergebnis As Boolean)
			If Ergebnis = False Then Return	'Zeigen, wenn Download geklappt hat.
		End If
	End If
	B4XPages.SetTitle(Me, filename)
	Dim cfg As Configurator = PDFView1.fromUri(dir,filename)
	cfg.SetEventname("PDFium")
	cfg.autoSpacing(True).enableSwipe(True).pageSnap(True).swipeHorizontal(False).addOnErrorListener.addOnLoadCompleteListener.addOnPageChangeListener.addOnPageErrorListener.addOnTapListener.load
End Sub

'Lädt die PDF
Sub inhaltladen(sdir As String,sdatei As String) As ResumableSub
	Private j As HttpJob
	Dim url As String
	url = "https://heilseminare.com/meditationen/"
	
	j.Initialize("", Me)
	j.Username = "heilseminare.com@heilseminare.com"
	j.Password="isis2711strato"
	j.JobName=sdatei
	j.Download(url&j.JobName)
	Wait For (j) JobDone(j As HttpJob)
	If j.Success Then
		Dim o As OutputStream
		Log("downloadfiles.download: "&j.jobname&" geladen")
		o = File.OpenOutput(sdir, j.jobname, False)
		File.Copy2(j.GetInputStream, o)
		o.Close
	End If
	j.Release
	ProgressDialogHide  'Sonst wird der Dialog nie beendet
	Return j.Success
End Sub
Sub pdfium_ontap(event As Object)
	Log($"Pdfium_onTap(${event})"$)
End Sub

Sub PDFium_loadComplete(pages As Int)
	Log($"PDFium_loadComplete(${pages})"$)
	glPages = pages
	lblPages.Text = $"${glPages}"$
End Sub

Sub PDFium_onInitiallyRendered(page As Int)
	Log($"PDFium_onInitiallyRendered(${page})"$)
End Sub

Sub PDFium_onPageChanged(page As Int, TotalPages As Int)
	Log($"PDFium_onPageChanged(${page},${TotalPages})"$)
	lblPages.Text = $"${page+1}/${glPages}"$
End Sub

Sub PDFium_PageNum(page As Int)
	Log($"PDFium_PageNum(${page})"$)
End Sub

Sub PDFium_Show()
	Log($"PDFium_Show()"$)
End Sub

Sub btnSend_Click
	If Sammlung.CheckNetConnections = False Then
		xui.MsgboxAsync("no internet !","Check Internet")
		Return
	End If
	'Send Email to Owner of chart
	'copy the shared file to the shared folder
	'Dim share As String = Provider.SharedFolder
	File.Copy(dir, filename, Provider.SharedFolder, filename)
	Dim email As Email
	Dim vornamePerson As String
	Dim weiblichPerson As Int
	Dim emailPerson As String
	Dim Query As String = "SELECT Frau,Name,Vorname,Email from Benutzer where IdName="& home.iduser
	Dim rs As ResultSet = Main.sql.ExecQuery(Query)
	Do While rs.NextRow
		vornamePerson = rs.getstring("Vorname")
		weiblichPerson = rs.GetInt("Frau")
		emailPerson = rs.GetString("Email")
	Loop
	
	email.To.Add(emailPerson)
	email.Subject = home.translate(Main.sprache,111)
	Dim anredew As String = home.translate(Main.sprache,108)
	Dim anredem As String = home.translate(Main.sprache,109)
	Dim text As String = home.translate(Main.sprache,107)
	Dim greeting As String = home.translate(Main.sprache,110)
	If weiblichPerson = 1 Then
		email.Body=$"${anredew} ${vornamePerson},
		${text}
		
		"$
	Else
		email.Body=$"${anredem} ${vornamePerson},
		${text}
		
		"$
	End If
	If home.emailLinklist.Size <> 0 Then
		For i=0 To home.emailLinklist.Size-1
			Dim eintrag As emaillinkEintrag = home.emailLinklist.Get(i)
			email.Body = email.Body & eintrag.bezeichner & CRLF
			If eintrag.link<>"" Then email.Body = email.Body & "* https://heilseminare.com/meditationen/"&eintrag.link & CRLF
		Next
	End If
	email.Body = email.Body & $"
	
	${greeting}
	Christiane & Dieter Baumgartner
	
	https://heilseminare.com
	"$

	email.Attachments.Add(Provider.GetFileUri(filename))
	'email.Body = email.Body.Replace("=","=3D")
	Dim in As Intent = email.GetIntent
	'in.Flags = 1 'FLAG_GRANT_READ_URI_PERMISSION
	StartActivity(in)
End Sub

Sub btnPrint_Click
	If printer.PrintSupported Then
		printer.PrintPdf("Schatzkarte", dir, filename)
	Else
		MsgboxAsync("Evtl. keine Druckerapp installiert ?","Drucken nicht möglich!")
	End If
End Sub

Sub btnPrev_Click
	PDFView1.jumpTo2(PDFView1.CurrentPage-1,False)
End Sub

Sub lblPages_Click
	
End Sub

Sub btnNext_Click
	PDFView1.jumpTo2(PDFView1.CurrentPage+1,False)
	
End Sub