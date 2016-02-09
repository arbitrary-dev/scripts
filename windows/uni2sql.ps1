$out_file = "out.sql"
$tmp_file = "out.tmp"

if (!$args) {
	[int[]]$range = ([string](Read-Host "Type range")).Split(' ')
	[int]$start = $range[0]
	[int]$end = $range[1]
	if (!$end) {
		$end = $range[0]
	}

	rm $tmp_file -ea ig

	for ($i=$start; $i -le $end; $i++) {
		$out += [char]$i
	}

	$out | Out-File $tmp_file -encoding utf8

	"Done! Check and edit: $tmp_file"
} else {
	rm $out_file -ea ig

	$arr = [char[]](Get-Content $tmp_file -encoding utf8)

	foreach ($a in $arr) {
		$bb = Read-Host "${a} "
		if (!$bb) {
			continue
		}

		$out = "INSERT INTO kanji (symbol) VALUES ('$a');`r`n"
		foreach ($b in $bb.Split(' ')) {
			$out += "INSERT INTO k2kun VALUES (`r`n"
			$out += "	(SELECT id FROM kanji WHERE symbol = '$a'),`r`n"
			$out += "	'$b');`r`n"
		}
		$out | Add-Content $out_file -encoding utf8
	}

	"SQL script is ready: $out_file"

	rm $tmp_file -ea ig
}
