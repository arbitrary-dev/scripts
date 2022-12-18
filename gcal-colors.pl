$red="\033[31m";
#$re="\033\\[31m";
$redb="\033[1;91m";
#$reb="\033\\[1;91m";
$rstc="\033[0m";
$rsc="\033\\[0m";

$dim="\033[2m";
$di="\033\\[2m";
$rstd="\033[22m";
$rsd="\033\\[22m";

$inv="\033[7m";
#$in="\033\\[7m";
$rsti="\033[27m";
#$rsi="\033\\[27m";

=debugging
$red="c";
$re=$red;
$redb="rb";
$reb=$redb;
$rstc="RC";
$rsc=$rstc;

$dim="d";
$di=$dim;
$rstd="RD";
$rsd=$rstd;

$inv="i";
$in=$inv;
$rsti="RI";
$rsi=$rsti;
=cut

# Dim passed days
unless ($a) {
    if (s/(.*)(<)/$dim\1$rstd\2/) {
        $a=1;
    } else {
        s/(([ :][ 0-9]{2}){7})/$dim$&$rstd/;
    }
}

# Color weekends
$pfx="[<>: ]";
#$pfx="($in|$di|$reb|)";
$date="(  | [0-9]|[0-9]{2})($rsd|)";
$sfx="[>:]?";
#$sfx="($rsi|$rsd|$rsc|)";
# First month
s/($pfx$date){5}\K(($pfx$date){2}$sfx)/$red$&$rstc/;
#s/(( $pfx$date$sfx){5})(( $pfx$date$sfx){2})/\1$red\5$rstc/;
# Other monthes
$date="(  | [0-9]|[0-9]{2})";
s/( {4,5})($pfx$date){5}\K(($pfx$date){2}$sfx)/$red$&$rstc/g;
#s/( {5})(( $pfx[ \d]{2}$sfx){5})(( $pfx[ \d]{2}$sfx){2})/\1\2$red\6$rstc/g;

# Invert current date
s/<(.+)>/ $inv\1$rsti /;

# Highlight holidays
if (m/^$di.+$rsd/) {
    local $b = $&;
    # Replace preserving dimming
    $b =~ s/:(.+?):/ $red\1$rstc $dim/g;
    s/^$di.+$rsd/$b/;
}
#FIXME preserve weekends
s/(:( [0-9]|[0-9]{2})){1,}:/$redb$&$rstc/g;
s/:/ /g;
