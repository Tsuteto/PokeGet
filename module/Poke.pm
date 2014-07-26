#use utf8;

#---
#ポケモンコンテナ
#---
package Poke;

sub new {
	my $this = shift;
	
	my $hash = {
		pno  => undef,
		pname => undef,
		gDeg => undef,
		wgt  => undef,
		type => [],
		sex  => [],
		
		hp   => undef,
		ball => undef,
		lv   => undef,
		mylv => undef,
		turn => undef,
		condChk => undef,
		stone => undef,
		food => undef,
		chk => {},
		@_,
	};
	bless $hash, $this;
}

#検索
sub find {
	my $this = shift;
	my $pList = shift;
	my $query = shift;
	my $pno = $PokeGet::IN->{pno};
	my @pokeDat = $pList->getList;
	
	if($query ne '') {
		if($query !~ /\D/) {
			#ナンバーで検索
			#&main::numJtoA(\$query);
			$pno = $query;
		} else {
			#名前で検索
			if($PokeGet::IN->{lang} ne 'en') {
				$query =~ s/Z/Ｚ/; $query =~ s/2/２/;
				#$query =~ s/┘/┛/; $query =~ s/”|゛/\"/;
				#&main::hira2kata(\$query);
			}
			for($pno = 0; $pno < @pokeDat; $pno++) {
				last if(uc($query) eq uc($pokeDat[$pno][0]));
			}
		}
	}
	
	#データ格納
	if($pno ne undef) {
		$this->setPname($pokeDat[$pno][0]);
		$this->setGDeg($pokeDat[$pno][1]);
		$this->setHigh($pokeDat[$pno][2]);
		$this->setWgt($pokeDat[$pno][3]);
		$this->setType($pokeDat[$pno][4]);
		$this->setSex($pokeDat[$pno][5]);
	}
	$this->setPno($pno);
}

#setter/getter
sub setPno {
	my $this = shift;
	$this->{pno} = shift;
}
sub getPno {
	my $this = shift;
	return $this->{pno};
}

sub setPname {
	my $this = shift;
	$this->{pname} = shift;
}
sub getPname {
	my $this = shift;
	return $this->{pname};
}

sub setHp {
	my $this = shift;
	$this->{hp} = shift;
}
sub getHp {
	my $this = shift;
	return $this->{hp};
}

sub setGDeg {
	my $this = shift;
	$this->{gDeg} = shift;
}
sub getGDeg {
	my $this = shift;
	return $this->{gDeg};
}

sub setHigh {
	my $this = shift;
	$this->{high} = shift;
}
sub getHigh {
	my $this = shift;
	return $this->{high};
}

sub setWgt {
	my $this = shift;
	$this->{wgt} = shift;
}
sub getWgt {
	my $this = shift;
	return $this->{wgt};
}

sub setType {
	my $this = shift;
	$this->{type} = shift;
}
sub getType {
	my $this = shift;
	return $this->{type};
}

sub setSex {
	my $this = shift;
	$this->{sex} = shift;
}
sub getSex {
	my $this = shift;
	return $this->{sex};
}

sub setCondChk {
	my $this = shift;
	$this->{condChk} = shift;
}
sub getCondChk {
	my $this = shift;
	return $this->{condChk};
}

sub addChk {
	my $this = shift;
	my $kind = shift;
	$this->{chk}->{$kind} = 1;
}
sub isChk {
	my $this = shift;
	my $kind = shift;
	return exists $this->{chk}->{$kind};
}

#getter only
sub getBall {
	my $this = shift;
	return $this->{ball};
}
sub getLv {
	my $this = shift;
	return $this->{lv};
}
sub getMylv {
	my $this = shift;
	return $this->{mylv};
}
sub getTurn {
	my $this = shift;
	return $this->{turn};
}
sub getStone {
	my $this = shift;
	return $this->{stone};
}
sub getFood {
	my $this = shift;
	return $this->{food};
}

1;
