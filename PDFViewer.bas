B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Activity
Version=10.45
@EndOfDesignText@
#Region  Activity Attributes 
	#FullScreen: true
	#IncludeTitle: True
#End Region
'Achtung Printing.xml wurde verändert, da PDFIUM auch PDFDocument als Typ verwendet.
'In Printing.xml wurde PDFDocument auf PrintPdfDocument geändert.
'https://www.b4x.com/android/forum/threads/pdfdocument-in-pdfium-and-printing-libraries.115745/
'Screen orientation is set in Manifest
'https://www.b4x.com/android/forum/threads/how-to-freeze-the-orientation-of-an-activity-reflection.52169/#post-326665
Sub Process_Globals
End Sub

Sub Globals
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
End Sub

Sub Activity_Create(FirstTime As Boolean)
	home=B4XPages.GetPage("MainPage")
	If home.settings.GetDefault("pdfquer",False) Then
		phone1.SetScreenOrientation(0)	'Querformat
	End If
	Activity.LoadLayout("pdf")
	pdf.Initialize("PDFium")
	Provider.Initialize
	printer.Initialize("")
	Dim dir As String = rt.getSafeDirDefaultExternal("")
	Dim cfg As Configurator = PDFView1.fromUri(dir,home.lblPerson.Text&".pdf")
	Activity.Title=home.lblPerson.Text&".pdf"
	cfg.SetEventname("PDFium")
	cfg.autoSpacing(True).enableSwipe(True).pageSnap(True).swipeHorizontal(False).addOnErrorListener.addOnLoadCompleteListener.addOnPageChangeListener.addOnPageErrorListener.addOnTapListener.load
	
End Sub

Sub Activity_Resume

End Sub

Sub Activity_Pause (UserClosed As Boolean)

End Sub


'Sub btnLast_Click
'	PDFView1.jumpTo2(glPages-1,False)
'End Sub