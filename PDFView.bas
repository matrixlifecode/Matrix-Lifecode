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
	Private Provider As FileProvider
	Private dir As String 'Verzeichnis
	Private phone1 As Phone
	Private dir As String 'Save-Dir zum Speichern
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
	dir = rt.getSafeDirDefaultExternal("")
End Sub

private Sub B4XPage_Appear
	If Sammlung.CheckNetConnections = False Then
		xui.MsgboxAsync("no Internet available!","Check Internet")
		Return
	End If
	Dim pos As Int
	pos = home.pdfDokument.LastIndexOf("/")
	Dim filename As String = home.pdfDokument.SubString(pos+1)
	'Datei runterladen und dann anzeigen
	Dim rs As ResumableSub = inhaltladen(dir,filename)
	Wait For(rs) Complete (Ergebnis As Boolean)
	If Ergebnis = True Then 'Zeigen, wenn Download geklappt hat.
		B4XPages.SetTitle(Me, filename)
		
		Dim cfg As Configurator = PDFView1.fromUri(dir,filename)
		cfg.SetEventname("PDFium")
		cfg.autoSpacing(True).enableSwipe(True).pageSnap(True).swipeHorizontal(False).addOnErrorListener.addOnLoadCompleteListener.addOnPageChangeListener.addOnPageErrorListener.addOnTapListener.load
	End If
	
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
		xui.MsgboxAsync("Keine Netzverbindung !","Check Internet")
		Return
	End If
	'Send Email to Owner of chart
	Dim FileName As String = home.lblPerson.text&".pdf"
	'copy the shared file to the shared folder
	'Dim share As String = Provider.SharedFolder
	File.Copy(dir, FileName, Provider.SharedFolder, FileName)
	Dim email As Email

	email.To.Add(home.emailPerson)
	email.Subject = "Nur für dich (heilseminare.com)"
	If home.weiblichPerson = 1 Then
		email.Body=$"Liebe ${home.vornamePerson},
		Im Anhang findest du deine persönliche Schatzkarte und deine individuelle Expeditions-Ausrüstung für den Weg.
		
		"$
	Else
		email.Body=$"Lieber ${home.vornamePerson},
		Im Anhang findest du deine persönliche Schatzkarte und deine individuelle Expeditions-Ausrüstung für den Weg.
		
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
	
	Herzliche Grüsse vom Team ChiTao
	Christiane und Dieter Baumgartner
	
	https://heilseminare.com
	"$

	email.Attachments.Add(Provider.GetFileUri(FileName))
	'email.Body = email.Body.Replace("=","=3D")
	Dim in As Intent = email.GetIntent
	'in.Flags = 1 'FLAG_GRANT_READ_URI_PERMISSION
	StartActivity(in)
End Sub

Sub btnPrint_Click
	If printer.PrintSupported Then
		printer.PrintPdf("Schatzkarte", dir, home.lblPerson.Text&".pdf")
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