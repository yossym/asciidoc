Option Explicit
Dim DbName, TableName, TypeStr
Dim FSO, DbPath
Dim CN, ConnStr, CAT, RS, sql

DbName = "test.accdb"
TableName = "TestTable"
TypeStr = "氏名 varchar(20),身長 float, unixtime float"

Set FSO = CreateObject("Scripting.FileSystemObject")

'  こうするとフルパスでファイル名を取得できるみたいだ
DbPath = FSO.GetAbsolutePathName(DbName)
If (FSO.FileExists(DbPath) = True) Then FSO.DeleteFile(DbPath)
Set FSO = Nothing

ConnStr = "Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" & DbPath & ";"
    Set CAT = CreateObject("ADOX.Catalog")
    Set CN = CAT.Create(ConnStr)  ' データベース作成
    Set CAT = Nothing

    sql = "create table " & TableName & " (" & TypeStr & ");"
    CN.Execute(sql)  ' テーブル作成

    Set RS = CreateObject("ADODB.Recordset")
    sql = "select * from " & TableName & ";"
    RS.Open sql,CN,0,2,1
    RS.AddNew
    RS.Fields("氏名").Value = "鈴木accdb"
    RS.Fields("身長").Value = 172.3
    RS.Fields("unixtime").Value = 1612064005.1234
    RS.Update
    RS.AddNew
    RS.Fields(0).Value = "高橋accdb"
    RS.Fields(1).Value = 168.5
    RS.Fields(2).Value = 1612064043.2345
    RS.Update
    RS.AddNew Array("氏名", "身長","unixtime"), Array("田中accdb", 183.6, 1612064284.3456)
    RS.Update
    RS.Close
    CN.Close
    Set RS = Nothing
    Set CN = Nothing
    msgbox "done"
