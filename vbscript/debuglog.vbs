Option Explicit

Dim w,args
dim fso
Set w    = WScript
Set args = w.Arguments
set fso  = w.CreateObject("Scripting.FileSystemObject")

Const ForReading   = 1
Const ForWriting   = 2
Const ForAppending = 8

sub DegubLog(pre_msg,msg)
    const DEBUG_LOG_FILENAME = "debug.log"
    const DEBUG_LOG_FOLDER = "debug_logs"
    dim path = fso.getParentFolderName(WScript.ScriptFullName)

    path = fso.buildpath(path, DEBUG_LOG_FOLDER)
    if not fso.FolderExists(path) then exit sub
    dim fullname
    fullname = fso.buildpath(path,DEBUG_LOG_FILENAME)

    dim ts
    set ts = fso.OpenTextFile(fullname,ForAppending,true)
        ts.writeline(  now() & " " & pre_msg & " " & msg)
    ts.close
end sub


sub Usage
    w.echo w.ScriptName  _
    , w.ScriptFullName 
    , VBNewLine _
    , " bat arguments"
end sub

sub rw(FileName)

    Dim its
    Set its = fso.OpenTextFile(FileName, ForReading )

    dim  ots, oFileName
    oFileName = FileName & ".csv"
    set ots = fso.OpenTextFile(oFileName, ForWriting, True)

    Do Until its.AtEndOfStream
        Dim line
        line = its.ReadLine
        ots.WriteLine line
    Loop

    its.close
    ots.close

end sub

sub Main
    if w.Arguments.Count = 0 then
        usage
    end if

    dim i
    set fso = WScript.CreateObject("Scripting.FileSystemObject")

    dim arg
    for each arg in args
        ' w.echo w.scriptFullName _
        ' , vbnewline _
        ' , w.scriptname _
        ' , vbnewline _
        ' , arg
        rw(arg)
    next

end sub

Main
