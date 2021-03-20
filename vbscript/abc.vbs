Option Explicit

Dim w,args
dim fso
Set w    = WScript
Set args = w.Arguments
set fso  = w.CreateObject("Scripting.FileSystemObject")

Const ForReading   = 1
Const ForWriting   = 2
Const ForAppending = 8

sub DebugLogs(msg)
    Const DebugLogsFolder = "Debug_logs"
    dim DebugLogs

    DebugLogs =  fso.getParentFolderName(WScript.ScriptFullName)
    DebugLogs = fso.Buildpath(DebugLogs, DebugLogsFolder)
    if not fso.FolderExists(DebugLogs) then
        exit sub
    end if


    msgbox DebugLogs
end sub


sub Usage
    w.echo w.ScriptName  _
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

    DebugLogs("hoge")

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

