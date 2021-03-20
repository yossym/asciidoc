' VBS用配列ラッパークラス - imihitoのブログ
' https://imihito.hatenablog.jp/entry/2017/05/13/010848

' 実装メンバー
' Clear
' 
' 初期化用。
' Add
' 
' 要素を末尾に追加。
' Item
' 
' 添え字で要素を取得。 上記のコードでは添え字は1からはじまる。 範囲外アクセス時の動作は保証しない。
' Count
' 
' 要素数。1から数えた場合の数。
' Remove
' 
' 指定された添え字の要素を除去する。 除去したらその分自動で詰める。
' InitByArray
' 
' 指定した配列で初期化する。 適当実装。
' ToArray
' 
' 配列化する。 For Eachの場合や配列そのものが欲しい場合なんかに。



' 使用例

Option Explicit
Dim myArray 'As ArrayCol
Set myArray = New ArrayCol

With myArray
    .Add 1
    .Add 3.14
    .Add "文字列"
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
'～


' Class ArrayCol
Class Collection
    '内部格納の配列
    Private clsArray 'As Variant
    
    '現在の要素数
    Private UsedCount 'As Long
    
    Private Sub Class_Initialize()
        Call Me.Clear
    End Sub
    
    Public Sub Clear()
        UsedCount = 0
        ReDim clsArray(4)
    End Sub
    
    '配列の下限
    Private Property Get ARRAY_BASE() 'As Long
        ARRAY_BASE = 1
    End Property
    
    '添え字変換
    Private Function UserIndexToRealIndex(Index) 'As Long
        UserIndexToRealIndex = Index - ARRAY_BASE
    End Function
    
    '要素を追加する。
    Public Sub Add(iItem)
        If UBound(clsArray) = UserIndexToRealIndex(UsedCount) Then Call ArrayExpand
        AssignVal clsArray(UsedCount), iItem
        UsedCount = UsedCount + 1
    End Sub
    
    Private Sub ArrayExpand()
        ReDim Preserve clsArray(UBound(clsArray) * 2)
    End Sub
    
    '代入簡略化処理
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
    
    '既存の配列で初期化する。
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


