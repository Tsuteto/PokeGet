package Output;

sub new {
	my $this = shift;
	my $hash = {
		result => shift,
		con => shift,
	};
	
	bless $hash, $this;
}


#
# 結果出力
#

#ステータス表生成
sub makeStatusList {
	my $this = shift;
	my $statsTr = $this->getContext("stats_tr");
	my $rscList;
	$rscList .= sprintf $statsTr, $this->getContext("ver"), $this->outVerName;
	$rscList .= sprintf $statsTr, $this->getContext("poke"), $this->outPname;
	$rscList .= sprintf $statsTr, $this->getContext("cond"), $this->outCondName;
	$rscList .= sprintf $statsTr, $this->getContext("remHp"), $this->outRemHp;
	$rscList .= sprintf $statsTr, $this->getContext("ball"), $this->outBallName;
	
	if($this->poke->getTurn) {
		$rscList .= sprintf($this->getContext("stats_tr"), $this->getContext("turn"), 
			sprintf $this->getContext("turn_s"), $this->poke->getTurn);
	}
	if($this->poke->getLv ne "" || $this->poke->getMylv ne "") {
		$rscList .= sprintf($this->getContext("stats_tr"), $this->getContext("lv"), $this->outLv);
	}
	if($this->poke->getStone ne "" || $this->poke->getFood ne "") {
		$rscList .= sprintf($this->getContext("stats_tr"), $this->getContext("safari"), $this->outSafari);
	}
	
	my($rscChk);
	foreach(keys %{$this->poke->{chk}}) {
		$rscChk .= $this->getContext("chk")->{$_};
	}
	$rscChk  = $this->getContext("chk")->{"none"} if(!$rscChk);
	
	$rscChk = sprintf $this->getContext("rscChk_tr"), $rscChk;
	
	#計算結果URL
	my $hereUrl;
	if(!$PokeGet::OUTSIDE) {
		$hereUrl = sprintf $this->getContext("hereUrl"), $this->makeUrlForLink;
	}
	
	return &{$this->getContext("stats_tbl")}($rscList, $rscChk, $hereUrl);
}

#
#出力メソッド群
#

#捕獲率
sub outGetPer {
	my $this = shift;
	return $this->{con}->outGetPer($this->{result});
}

#タイプ
sub outTypeName {
	my $this = shift;
	return join $this->getContext("sepChar"), 
		map(($_ != -1? $this->{con}->{typeDef}[$_] : $this->{con}->{unknownType}), 
		@{$this->poke->getType});
}
#バージョン名
sub outVerName {
	my $this = shift;
	my $ver = $PokeGet::IN->{ver};
	return $this->{con}->{verName}->{$ver};
}
#ポケモン名
sub outPname {
	my $this = shift;
	return sprintf($this->getContext("pname_s"), $this->poke->getPname);
}
#残りHP率
sub outRemHp {
	my $this = shift;
	if($this->params->isGraph) {
		return $this->getContext("remHp_graph");
	} else {
		return sprintf($this->getContext("remHp_normal"), $this->poke->getHp);
	}
}
#状態
sub outCondName {
	my $this = shift;
	return $this->{con}->{condName}->[$this->poke->getCondChk];
}
#ボール名
sub outBallName {
	my $this = shift;
	return $this->{con}->{ballName}->[$this->poke->getBall];
}
#重さ
sub outWgt {
	my $this = shift;
	return ($this->poke->getWgt != -1? 
		sprintf($this->getContext("wgt_s"), $this->poke->getWgt) : $this->{unknown});
}
#♂♀存在比
sub outSexRatio {
	my $this = shift;
	my $sex = $this->poke->getSex;
	if(!$sex->[0] && !$sex->[1]) {
		return $this->getContext("sexRatio_sexless");
	} elsif($sex->[0] && !$sex->[1]) {
		return $this->getContext("sexRatio_maleOnly");
	} elsif(!$sex->[0] && $sex->[1]) {
		return $this->getContext("sexRatio_femaleOnly");
	} else {
		return sprintf $this->getContext("sexRatio_normal"), @{$sex};
	}
}
#レベル
sub outLv {
	my $this = shift;
	my $mylv = $this->poke->getMylv;
	my $lv = $this->poke->getLv;
	if($mylv eq '') {
		$mylv = $this->getContext("none");
	}
	if($lv eq '') {
		$lv = $this->getContext("none");
	}
	return sprintf $this->getContext("lv_s"), $mylv, $lv;
}

#判定閾値
sub outGt {
	my $this = shift;
	my $val;
	if($this->params->getGc < $this->params->getGtMax) {
		$val = sprintf($this->getContext("Gt_$this->{con}->{ver}"),
			$this->params->getGt, $this->params->getGtMax);
	} else {
		$val = $this->getContext("Gt_disabled");
	}
	return $val;
}

#被捕獲補正
sub outBCor {
	my $this = shift;
	my $val;
	
	$val = sprintf($this->getContext("bCor_$this->{con}->{ver}"), 
		$this->params->getBCor, $this->params->getBAdd);
	return $val;
}

#実残りHP率
sub outRHpEf {
	my $this = shift;
	my $val;
	$val = sprintf($this->getContext("remHpEf"), $this->params->getRHPef);
	return $val;
}

#石・エサ
sub outSafari {
	my $this = shift;
	my $val;
	$val = sprintf($this->getContext("safari_s"), 
		$this->poke->getStone, $this->poke->getFood);
	return $val;
}

#リンク用URL生成
sub makeUrlForLink {
	my $this = shift;
	my @q = ();
	my %in = %{$PokeGet::IN};
	foreach(qw/ver pname ball hp c g/) {
		push @q, "$_=" . $PokeGet::IN->{$_};
		delete $in{$_};
	}
	foreach(keys %in) {
		push @q, "$_=" . $PokeGet::IN->{$_};
	}
	
	$_ = join "&", @q;
	
	s/m=[^&]+&//;
	s/&\w+=(?=&|$)//g;
	s/&hp=\d+(?=&|$)//g if($this->params->isGraph);
	s/&pname=.+?(?=&|$)/"&pno=".$this->poke->getPno/e;
	s/&/&amp;/g;
	
	return $_;
}

#コンテキストを得る
sub getContext {
	my $this = shift;
	my $name = shift;
	return $this->{con}->{context}->{$name};
}

sub params {
	my $this = shift;
	return $this->{result}->{params};
}

sub poke {
	my $this = shift;
	return $this->params->getPoke;
}

1;