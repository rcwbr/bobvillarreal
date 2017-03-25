=begin
regex to convert old html files

find:
"
replace:
\"

find:
<br />

OR
\n							<br />\n
replace:
<br />

find:
			<a id=\\"showbook.*class=\\"showbook\\">(.+?)&nbsp;<span class=\\"break\\">\|</span>&nbsp;(.+?)</a>
OR
			<a id=\\"showbook.*class=\\"showbook\\">(.+?)&nbsp;<span class=\\"break\\">\|</span>&nbsp;(.+?)</span></a>

replace:
-
  name: "$1 | $2"

find:
.*\s.*\s<div id=\\"book.*\s.*\s.*\s.*\s.*\s<td.*\s.\s+(.*)\n.*</td>
OR
.*\s.*\s<div id=\\"book.*\s.*\s.*\s.*\s.*\s<p>(.*)</p>

replace:
  passages:
    -
      "$1"

find:
						<td.*\s							(.*)\n						</td>
replace:
    -
      "


=end
