' VBS�p�z�񃉃b�p�[�N���X - imihito�̃u���O
' https://imihito.hatenablog.jp/entry/2017/05/13/010848

' ���������o�[
' Clear
' 
' �������p�B
' Add
' 
' �v�f�𖖔��ɒǉ��B
' Item
' 
' �Y�����ŗv�f���擾�B ��L�̃R�[�h�ł͓Y������1����͂��܂�B �͈͊O�A�N�Z�X���̓���͕ۏ؂��Ȃ��B
' Count
' 
' �v�f���B1���琔�����ꍇ�̐��B
' Remove
' 
' �w�肳�ꂽ�Y�����̗v�f����������B ���������炻�̕������ŋl�߂�B
' InitByArray
' 
' �w�肵���z��ŏ���������B �K�������B
' ToArray
' 
' �z�񉻂���B For Each�̏ꍇ��z�񂻂̂��̂��~�����ꍇ�Ȃ񂩂ɁB



' �g�p��

Option Explicit
Dim myArray 'As ArrayCol
Set myArray = New ArrayCol

With myArray
    .Add 1
    .Add 3.14
    .Add "������"
    .Add Now()
    .Add WScript.ScriptFullName
    .Add New ArrayCol
End With    'myArray
MsgBox myArray(1)
Dim buf: buf = ""
Dim tmp
For Each tmp In myArray.ToArray()
    If IsObject(tmp) Then
        buf = buf & TypeName(tmp) & vbCrLf
    Else
        buf = buf & tmp & vbCrLf
    End If
Next 'tmp

MsgBox buf

'Class ArrayCol
'�`


' Class ArrayCol
Class Collection
    '�����i�[�̔z��
    Private clsArray 'As Variant
    
    '���݂̗v�f��
    Private UsedCount 'As Long
    
    Private Sub Class_Initialize()
        Call Me.Clear
    End Sub
    
    Public Sub Clear()
        UsedCount = 0
        ReDim clsArray(4)
    End Sub
    
    '�z��̉���
    Private Property Get ARRAY_BASE() 'As Long
        ARRAY_BASE = 1
    End Property
    
    '�Y�����ϊ�
    Private Function UserIndexToRealIndex(Index) 'As Long
        UserIndexToRealIndex = Index - ARRAY_BASE
    End Function
    
    '�v�f��ǉ�����B
    Public Sub Add(iItem)
        If UBound(clsArray) = UserIndexToRealIndex(UsedCount) Then Call ArrayExpand
        AssignVal clsArray(UsedCount), iItem
        UsedCount = UsedCount + 1
    End Sub
    
    Private Sub ArrayExpand()
        ReDim Preserve clsArray(UBound(clsArray) * 2)
    End Sub
    
    '����ȗ�������
    Private Sub AssignVal(ByRef o, i)
        If IsObject(i) Then
            Set o = i
        Else
            o = i
        End If
    End Sub
    
    Public Default Property Get Item(ByVal Index) 'As Variant
        AssignVal Item, clsArray(UserIndexToRealIndex(Index))
    End Property
    
    Public Property Let Item(ByVal Index, Value)
        clsArray(UserIndexToRealIndex(Index)) = Value
    End Property
    
    Public Property Set Item(ByVal Index, Value)
        Set clsArray(UserIndexToRealIndex(Index)) = Value
    End Property
    
    Public Property Get Count() 'As Long
        Count = UsedCount
    End Property
    
    Public Sub Remove(ByVal Index)
        Dim i
        For i = UserIndexToRealIndex(Index) To UserIndexToRealIndex(UsedCount - 1)
            AssignVal clsArray(i), clsArray(i + 1)
        Next 'i
        clsArray(UserIndexToRealIndex(UsedCount)) = Empty
        UsedCount = UsedCount - 1
    End Sub
    
    '�����̔z��ŏ���������B
    Public Sub InitByArray(BaseArray)
        If Not IsArray(BaseArray) Then Err.Raise 5
        
        Me.Clear
        Dim tmp
        For Each tmp In BaseArray
            Me.Add tmp
        Next 'tmp
    End Sub
    
    Public Function ToArray() 'As Variant
        Dim buf:    buf = clsArray
        ReDim Preserve buf(UserIndexToRealIndex(UsedCount))
        ToArray = buf
    End Function
End Class


