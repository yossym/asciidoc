Option Explicit
Dim DbName, TableName, TypeStr
Dim FSO, DbPath
Dim CN, ConnStr, CAT, RS, sql

DbName = "test.accdb"
TableName = "TestTable"
TypeStr = "���� varchar(20),�g�� float, unixtime float"

Set FSO = CreateObject("Scripting.FileSystemObject")

'  ��������ƃt���p�X�Ńt�@�C�������擾�ł���݂�����
DbPath = FSO.GetAbsolutePathName(DbName)
If (FSO.FileExists(DbPath) = True) Then FSO.DeleteFile(DbPath)
Set FSO = Nothing

ConnStr = "Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" & DbPath & ";"
    Set CAT = CreateObject("ADOX.Catalog")
    Set CN = CAT.Create(ConnStr)  ' �f�[�^�x�[�X�쐬
    Set CAT = Nothing

    sql = "create table " & TableName & " (" & TypeStr & ");"
    CN.Execute(sql)  ' �e�[�u���쐬

    Set RS = CreateObject("ADODB.Recordset")
    sql = "select * from " & TableName & ";"
    RS.Open sql,CN,0,2,1
    RS.AddNew
    RS.Fields("����").Value = "���accdb"
    RS.Fields("�g��").Value = 172.3
    RS.Fields("unixtime").Value = 1612064005.1234
    RS.Update
    RS.AddNew
    RS.Fields(0).Value = "����accdb"
    RS.Fields(1).Value = 168.5
    RS.Fields(2).Value = 1612064043.2345
    RS.Update
    RS.AddNew Array("����", "�g��","unixtime"), Array("�c��accdb", 183.6, 1612064284.3456)
    RS.Update
    RS.Close
    CN.Close
    Set RS = Nothing
    Set CN = Nothing
    msgbox "done"
