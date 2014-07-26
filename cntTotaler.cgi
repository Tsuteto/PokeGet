#!/usr/local/bin/perl -I./module
use Jcode;

$myName = "cntTotaler.cgi";
chdir("cnt");

opendir(DIR, ".");
@f = sort(grep(/^d/, readdir(DIR)));
closedir(DIR);

($mode, $date) = split /&/, $ENV{'QUERY_STRING'};

&preSeq;

   if($mode eq 'ref') { &refList; }
elsif($mode eq 'p')   { &pokeList; }
else { &cntList; }

sub cntList {
	@c = ("eAM", "lAM", "ePM", "lPM");
	$guide = qq{<tr align="center"><th>日付</th>};
	foreach(0..23) {
		$n = int($_ / 6);
		$guide .= sprintf qq{<th class="$c[$n]">%02d</th>}, $_;
	}
	$guide .= qq{<th class="tot">計</th>\n};
	
	&header;
	print <<"EOF";
<body>
<table border="2">
$guide
EOF
	
	foreach $d (reverse @f) {
		open(F, $d) || die qq{"${d}" not found.};
		@dat = split(/\t/, <F>);
		close(F);
		$d =~ s/d([0-9]+).txt/$1/;
		@date = (gmtime($d * 86400))[3, 4, 5];
		$date[1]++; $day_tot = 0;
		($day, $mon, $year) = map(sprintf("%02d", $_ % 100), @date);
		print qq{<tr align="right"><td><a href="$myName?ref&$d">$year/$mon/$day</a></td>};
		foreach(0..23) {
			$n = int($_ / 6);
			print "<td class=\"$c[$n]\">$dat[$_]</td>";
			($pc, $k) = split ":", $dat[$_];
			$day_tot += $pc + $k;
		}
		print "<td class=\"tot\">$day_tot</td>\n";
		$total += $day_tot;
	}
	
	print <<EOF;
$guide
</table>
<p>Total: $total</p>
</body>
</html>
EOF
}

sub refList {
	use pokeDB;
	@pokeDat = pokeDB::getList;
	
	open FILE, "r${date}.txt";
	@ref = <FILE>;
	close FILE;
	shift @ref;
	
	open FILE, "p${date}.txt";
	@poke = <FILE>;
	close FILE;
	
	@d = (gmtime $date * 86400)[5, 4, 3];
	$date = sprintf "%02d/%02d/%02d", $d[0] % 100, $d[1] + 1, $d[2];
	$" = '';
	
	&header;
	print <<EOF;
<body>
<h1>[$date ログ記録]</h1>
<h2>リファラ</h2>
<table border="2">
EOF
	$total = 0;
	$refcnt{$_}++ foreach(@ref);
	foreach $url (keys %refcnt) {
		$urlDesc = $domain = $href = $url;
		$urlDesc =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack("C", hex($1))/eg;
		$urlDesc =~ s/%u([a-fA-F0-9]{2})([a-fA-F0-9]{2})/pack("C", hex($1)).pack("C", hex($2))/eg;
		$href =~ s/%u([a-fA-F0-9]{2})([a-fA-F0-9]{2})/%$1%$2/g;
		$urlDesc = Jcode->new($urlDesc)->utf8;
		if($urlDesc =~ /[?&](?:q|p|search|Text|query)=([^&]+)/) {
			chomp($q = $1);
			$q =~ s/(?:　)+|\+|\s+/ /g;
			$search{$q} += $refcnt{$url};
		}
		
		if($url =~ m!^http://([^/]+)!) {
			$domains{$1} += $refcnt{$url};
		}
		
		print qq{<tr><th>$refcnt{$url}</th><td><font size="-1"><a href="$href">$urlDesc</a></font></td></tr>\n};
		$total += $refcnt{$url};
	}
	print qq{</table>\n<p>Total: $total</p>\n};
	
	print qq{<table border="2">};
	foreach $d (sort { $domains{$b} <=> $domains{$a} } keys %domains) {
		print qq{<tr><th>$domains{$d}</th><td class=ref><a href="http://$d/">$d</a></td></tr>\n};
	}
	print qq{</table>\n};
	
	print "<h2>検索単語</h2>\n";
	print "<table border=2>\n";
	my $i = 0;
	foreach $word (sort { $search{$b} <=> $search{$a} } keys %search) {
		print qq{<tr>\n} if($i % 2 == 0);
		print qq{\t<th>$search{$word}</th><td class=ref>$word</td>\n};
		$i++;
	}
	print "</table>\n";
	
	print qq{<h2>使用ポケモン</h2>\n};
	print qq{<table border="2">\n};
	$total = 0;
	foreach(@poke) {
		($poke, $ip) = split /\t/, $_;
		$pokecnt{$poke}++;
	}
	foreach(sort { $pokecnt{$b} <=> $pokecnt{$a} } keys %pokecnt) {
		print qq{<tr><th>$pokecnt{$_}</th><td><font size="-1">$_</font></td></tr>\n};
		$total += $pokecnt{$_};
	}
	print qq{</table>\n<p>Total: $total</p>\n};
	
	print <<EOF;
<p><a href="$myName">[Back]</a></p>
</body>
</html>
EOF
}

sub preSeq {
	open F, "total.txt";
	$total = <F>;
	close F;
	
	while(@f >= 120) {
		$old = shift @f;
		open F, $old;
		@dat = split /\t/, <F>;
		map { $total += $_ } @dat;
		unlink $old;
	}
	
	open F, ">total.txt";
	print F $total;
	close F;
}

sub header {
print <<EOH;
Content-type: text/html

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>ポケモン捕獲率計算機 利用回数</title>
<link rel="stylesheet" type="text/css" href="cntTotaler.css" media="screen,tv">
</head>
EOH
}
