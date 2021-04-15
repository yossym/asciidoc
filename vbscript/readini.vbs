Function ReadIni(FilePath, Section, Key)

    Const ForReading  = 1
    Const ForWriting = 2
    Const ForAppending = 8

    dim intEqualPos
    dim fso, IniFile
    dim sFilePath, sKey, sLeftString, sLine, sSection

    set fso = CreateObject("Scripting.FileSystemObject")
    ReadIni = ""
    sFilePath = trim( FilePath)
    sSection = trim(Section)
    sKey = trim(Key)
    if fso.FileExists(sFilePath) then
        set IniFile = fso.OpenTextFile(sFilePath, ForReading,  False)

        do while IniFile.AtEndOfStream = false
            sLine = trim (IniFile.ReadLine)
            if LCase(sLine) = "[" & LCase(sSection) & "]" then
                sLine = trim(IniFile.ReadLine)
                do while Left ( sLine, 1) <>  "["
                    intEqualPos = InStr(1, sLine, "=", 1) 

                    if intEqualPos > 0 Then
                        sLeftString = Trim( Left(sLine , intEqualPos - 1) )

                        if LCase(sLeftString) = LCase(sKey) Then
                            ReadIni = Trim(Mid( sLine, intEqualPos +1))
                            if ReadIni = "" Then
                                ReadIni = " "
                            end if

                            exit Do
                        end if
                    End if

                    if IniFile.AtEndOfStream Then 
                        Exit Do
                    end if
                    sLine = Trim(IniFile.readline)
                Loop
            End If
        Loop
        IniFile.Close
    else
        ReadIni = ""
    end if

end Function


sub Main
    dim FilePath , Section, Key
    '	FilePath = "C:\Users\server1\Documents\excelマクロ\vbscript サンプル\ini\readini.ini"
    FilePath = ".\readini.ini"
    Section = "ファイル名"
    '	Key = "fuga"
    msgbox  ReadIni(FilePath, Section, 1)
    msgbox  ReadIni(FilePath, Section, 2)
    msgbox  ReadIni(FilePath, Section, 3)

    Section = "ファイル名"
    '	Key = "fuga"
    Section = "組み合わせ"
    dim msg
    msg = ReadIni(FilePath, Section, 1)
    msg = msg & ReadIni(FilePath, Section, 2)
    msg = msg & ReadIni(FilePath, Section, 3)


    msgbox msg


end sub

call Main
