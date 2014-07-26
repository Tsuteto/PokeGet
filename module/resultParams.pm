#計算結果パラメータ
package ResultParams;

sub new {
	my $this = shift;
	my $hash = {
		remHp => [],	#残りHP率（グラフ用）
		getPer => [],	#捕獲率
		gDeg => undef,	#被捕獲度
		gIdx => undef,	#捕獲指数
		Gc => undef,	#捕獲係数
		Gt => undef,	#捕獲判定閾値
		GtMax => undef,	#↑最大値
		bCor => undef,	#被捕獲補正(倍率)
		bAdd => undef,	#被捕獲補正加算
		rHPef => undef,	#実残りHP率
		
		ver => $PokeGet::IN->{ver},
		winSize => undef,
		graph => $PokeGet::IN->{g},
		
		#ポケモンコンテナ
		poke => undef,
		
		#結果表示フラグ
		isWgt => 0,
		isType => 0,
		isSex => 0,
		
		#コンテキスト
		typeDef => [], 
		verName => {}, 
		condList => [], 
		ballList => [],
		context => {},
		@_
	};
	
	bless $hash, $this;
}

#
#setter/getter群
#
#sub setRemHp {
#	my $this = shift;
#	$this->{remHp} = [@_];
#}
sub setRemHp {
	my $this = shift;
	$this->{remHp} = [@_];
}
sub getRemHp {
	my $this = shift;
	return $this->{remHp};
}
sub setGetPer {
	my $this = shift;
	$this->{getPer} = [@_];
}
sub getGetPer {
	my $this = shift;
	return $this->{getPer};
}

sub setGDegType {
	my $this = shift;
	$this->{gDegType} = shift;
}
sub getGDegType {
	my $this = shift;
	return $this->{gDegType};
}

sub setGDeg {
	my $this = shift;
	$this->{gDeg} = shift;
}
sub getGDeg {
	my $this = shift;
	return $this->{gDeg};
}

sub setGIdx {
	my $this = shift;
	$this->{gIdx} = shift;
}
sub getGIdx {
	my $this = shift;
	return $this->{gIdx};
}

sub setGc {
	my $this = shift;
	$this->{Gc} = shift;
}
sub getGc {
	my $this = shift;
	return $this->{Gc};
}

sub setGt {
	my $this = shift;
	$this->{Gt} = shift;
}
sub getGt {
	my $this = shift;
	return $this->{Gt};
}

sub setGtMax {
	my $this = shift;
	$this->{GtMax} = shift;
}
sub getGtMax {
	my $this = shift;
	return $this->{GtMax};
}

sub setBAdd {
	my $this = shift;
	$this->{bAdd} = shift;
}
sub getBAdd {
	my $this = shift;
	return $this->{bAdd};
}

sub setBCor {
	my $this = shift;
	$this->{bCor} = shift;
}
sub getBCor {
	my $this = shift;
	return $this->{bCor};
}

sub setRHpEf {
	my $this = shift;
	$this->{rHPef} = shift;
}
sub getRHpEf {
	my $this = shift;
	return $this->{rHPef};
}

sub setGraph {
	my $this = shift;
	$this->{graph} = shift;
}
sub isGraph {
	my $this = shift;
	return $this->{graph};
}
sub setEtc {
	my $this = shift;
	$this->{etcList}{shift} = shift;
}
sub getEtc {
	my $this = shift;
	return $this->{etcList}{shift};
}
sub getEtcList {
	my $this = shift;
	return $this->{etcList};
}
sub setPoke {
	my $this = shift;
	$this->{poke} = shift;
}
sub getPoke {
	my $this = shift;
	return $this->{poke};
}

1;
