Option Explicit
Dim strA, strB
Dim regEx, Matches, Match
Set regEx = New RegExp

strA = "\w+"
strB = "This     is a pen."

RegEx.Pattern = strA
RegEx.Global = True
RegEx.IgnoreCase = False

' RegEx

Set Matches = RegEx.Execute(strB)
For Each Match in Matches
  WScript.Echo Match.FirstIndex & ":'" & Match.value & "'"
Next

strA = "[^,]"
strB = "This,is,a,pen."

RegEx.Pattern = strA
RegEx.Global = True
RegEx.IgnoreCase = False

' RegEx

Set Matches = RegEx.Execute(strB)
For Each Match in Matches
  WScript.Echo Match.FirstIndex & ":'" & Match.value & "'"
Next



