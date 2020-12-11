Option Explicit

Dim w,args
Set w = WScript
Set args = w.Arguments
dim fso 

Const ForReading  = 1
Const ForWriting = 2
Const ForAppending = 8

sub Usage
	w.echo w.ScriptName  _
	, VBNewLine _
	, " bat arguments"
end sub

sub Main
  if w.Arguments.Count = 0 then
  	usage
  end if

  dim i
    set fso = WScript.CreateObject("Scripting.FileSystemObject")

  dim arg
  for each arg in args
  	w.echo w.scriptFullName _
  	, vbnewline _
  	, w.scriptname _
  	, vbnewline _
  	, arg
    rw(arg)
  next

end sub

sub rw(arg)

    Dim its
    Set its = fso.OpenTextFile(arg, ForReading, False, 0)

    dim p
    p  = fso.GetParentFolderName( w.ScriptFullName)
    msgbox p
    dim  ots 
    set ots = fso.OpenTextFile(fso.buildpath(p,"output.txt"),ForWriting,True)

    Do Until its.AtEndOfStream
        Dim lineStr
        lineStr = its.ReadLine
        ots.WriteLine lineStr
    Loop

    its.close
    ots.close

end sub


Main
