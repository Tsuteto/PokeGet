use Jcode;

package Log;

$DATE = int((time + 3600 * 9) / 86400);

$LOG_DIR = "cnt";
$REF_PREFIX = "r";
$LOG_PREFIX = "d";
$POKE_PREFIX = "p";

sub new {
	my $this = shift;
	my $hash = {
		logFile => "${LOG_DIR}/${LOG_PREFIX}${DATE}.txt",
		reflog  => "${LOG_DIR}/${REF_PREFIX}${DATE}.txt",
		pokelog => "${LOG_DIR}/${POKE_PREFIX}${DATE}.txt",
	};
	
	bless $hash, $this;
}

#リファラ記録
sub refRecord {
	my $this = shift;
	my $ref = $ENV{'HTTP_REFERER'};
	
	#掃除
	if(!-e $this->{reflog}) {
		&sweep;
	}
	
	return if(index($ref, $ENV{'SCRIPT_URL'}) != -1);
	
	open FILE, ">>$this->{reflog}";
	flock 2, FILE;
	print FILE "$ref\n";
	flock 8, FILE;
	close FILE;
}

#カウント記録
sub cntRecord {
	my $this = shift;
	my $pname = shift;
	my $isKeitai = shift;
	my $lang = $PokeGet::IN->{lang};
	
	#ログ読み込み
	open FILE, "<", $this->{logFile};
	my $cntDat = <FILE>;
	close FILE;
	
	#カウント
	my @c = split /\t/, $cntDat;
	my $hour = (localtime time)[2];
	($pc, $k, $en) = split ":", $c[$hour];
	if($isKeitai) { $k++; }
	elsif($lang eq 'en') { $en++; }
	else { $pc++; }
	$c[$hour] = "$pc:$k:$en";
	
	#ログ書き込み
	$" = '';
	open FILE, ">", $this->{logFile};
	flock 2, FILE;
	print FILE join("\t", @c);
	flock 8, FILE;
	close FILE;
	
	open FILE, ">>", $this->{pokelog};
	print FILE "$pname\t$ENV{'REMOTE_ADDR'}\n";
	close FILE;
}

sub sweep {
	my $this = shift;
	
	my($entry);
	my $exp = $DATE - 30;
	warn $exp;
	
	opendir DIR, $LOG_DIR;
	while($entry = readdir DIR) {
		if($entry !~ /^(?:${LOG_PREFIX}|${REF_PREFIX}|${POKE_PREFIX})(\d+).txt$/) {
			next;
		}
		if($1 < $exp) {
			unlink "$LOG_DIR/$entry";
		}
	}
}

1;
