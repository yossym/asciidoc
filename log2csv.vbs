Option Explicit

const ForWriting  =2

Dim w,args
Set w = WScript
Set args = w.Arguments

sub Usage
        w.echo w.ScriptName  _
        , VBNewLine _
        , " bat arguments"
end sub

sub Process(iFileName)

    Dim fso
    Set fso = WScript.CreateObject("Scripting.FileSystemObject")
    dim its
    dim ots, oFileName
    oFilename = iFileName & ".csv"
    w.echo iFilename,oFileName
    set its = fso.OpenTextFile(iFileName)
    set ots = fso.OpenTextFile(oFileName,ForWriting,true)
    dim line
    dim aptime,ant,result,v
    dim sample()
    dim sample_cnt : sample_cnt = 0
    dim i
    dim t

    Do While its.AtEndOfStream <> True

        line = its.ReadLine
        if instr(line,"aptime") > 0 then
            v = split(line,vbtab)
            aptime= v(1)
            for i = 0 to ubound(sample) -1
                t = aptime & vbtab & ant & vbtab &  sample(i) & vbtab & result
                ots.writeline t
                ' w.echo aptime,ant,sample(i),result
            next
            redim sample(0)
            sample_cnt = 0
        end if
        if instr(line,"result") > 0 then
            v = split(line,vbtab)
            result = v(1)
        end if
        if instr(line,"ant") > 0 then
            v = split(line,vbtab)
            ant = v(1)
        end if
        if instr(line,"sample") > 0 then
            redim Preserve sample(sample_cnt)
            ' w.echo ubound(sample)
            sample(sample_cnt)   = line
            sample_cnt = sample_cnt +1
        end if
    Loop

            for i = 0 to ubound(sample) -1
                t = aptime & vbtab & ant & vbtab &  sample(i) & vbtab & result
                ots.writeline t
            next

    its.close
    ots.close
end sub


sub Main
    if w.Arguments.Count = 0 then
        usage
    end if

    dim i


    dim arg
    for each arg in args
        ' w.echo w.scriptFullName _
        ' , vbnewline _
        ' , w.scriptname _
        ' , vbnewline _
        ' , arg

        Process(arg)
    next

    ' w.echo args(0) &  args(1)
end sub

Main


