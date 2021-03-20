Option Explicit

Dim w,args
dim fso
Set w    = WScript
Set args = w.Arguments
set fso  = w.CreateObject("Scripting.FileSystemObject")

Const ForReading   = 1
Const ForWriting   = 2
Const ForAppending = 8

sub Usage
    w.echo w.ScriptName  _
    , w.ScriptFullName _
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
    ' if w.Arguments.Count = 0 then
    '     usage
    ' end if
    ' 
    ' dim i
    ' set fso = WScript.CreateObject("Scripting.FileSystemObject")
    ' 
    ' dim arg
    ' for each arg in args
    '     ' w.echo w.scriptFullName _
    '     ' , vbnewline _
    '     ' , w.scriptname _
    '     ' , vbnewline _
    '     ' , arg
    '     rw(arg)
    ' next

    Const advarchar = 200
    Const addouble = 5
    Const adinteger = 3
    dim rs
    Set rs = CreateObject("ADODB.RecordSet")

    'DataTypeEnum
    ' cal rs.Fields.Append("aptime",addouble)
    call rs.Fields.Append("no",adinteger)
    ' •¶Žš—ñ‚Í’·‚³‚àŽw’è‚·‚é'
    call rs.Fields.Append("time",advarchar, 250)

    call rs.Open
    rs.AddNew
    rs.Fields("no")  = 1
    rs.Fields("time")  = "OK"
    dim i

    for i = 0 to 200
        rs.AddNew
        rs("no") = i
        rs("time") = now()
    next

    w.echo rs.recordCount
    w.echo "done"

end sub

Main
