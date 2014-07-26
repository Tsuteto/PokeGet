#use utf8;

#
# 捕獲率計算
#

{
	#----
	#共通
	#----
	package PokeGetCalc;
	
	sub new {
		#引数：$_[0]=自身のリファレンス、$_[1]以降=引数
		my $this = shift;
		
		#メンバ定義(ハッシュ形式)
		my $hash = {
			err  => undef, #計算エラーコンテナ
			result => undef, #結果コンテナ
			in => $PokeGet::IN,
		};
		bless $hash, $this;
	}
	
	sub init {
		my $this = shift;
		#結果コンテナ格納
		$this->{result} = shift;
		#計算エラーコンテナ格納
		$this->{err} = shift;
		
		#つきのいし進化ポケモンリスト
		$this->{moon} = [30, 33, 35, 39, 300, 517];
		
		#Poke生成
		$this->poke(
			Poke->new(
				hp   => $this->{in}{'hp'},
				ball => $this->{in}{'ball'},
				lv   => $this->{in}{'lv'},
				mylv => $this->{in}{'mylv'},
				turn => $this->{in}{'turn'},
				condChk => $this->{in}{'c'},
				stone => $this->{in}{'stone'},
				food => $this->{in}{'food'},
			)
		);
		
		@chkList = ("get", "dive", "dive2", "fishing", "same", "oppo", "dark");
		foreach(@chkList) {
			$this->poke->addChk($_) if($this->{in}{$_});
		}
		
		#残りHP設定
		if($this->params->isGraph) {
			$this->setRemHpForGraph;
		} else {
			$this->setRemHpForDetail;
		}
		
		#ポケモンリスト選択
		if($PokeGet::IN->{lang} eq 'en') {
			use pokeDB_en;
			$pList = PokeDB_en;
		} else {
			use pokeDB;
			$pList = PokeDB;
		}
		
		#ポケモン検索
		$this->poke->find($pList, $this->{in}{pname});
		
		if(!$this->poke->getGDeg) {
			$this->{err}->addMsg('poke', $this->{in}{pname});
		}
		
		#入力チェック
		$this->paramCheck;
		$this->{err}->outputHtml if($this->{err}->isError);
	}
	
	sub poke {
		my $this = shift;
		@_? $this->params->setPoke(@_)
		  : return $this->params->getPoke;
	}
	sub params {
		my $this = shift;
		return $this->{result};
	}
	
	#グラフ用 残りHP率
	sub setRemHpForGraph {
		my $this = shift;
		my @HPs = (1);
		for(my $n = 5; $n <= 100; $n += 5) {
			push @HPs, $n;
		}
		$this->params->{remHp} = [@HPs];
	}
	
	#詳細計算用 残りHP率
	sub setRemHpForDetail {
		my $this = shift;
		$this->params->{remHp} = [$this->poke->getHp];
	}
	
	#サファリパークステータス設定
	sub setSafariPark {
		my $this = shift;
		$this->params->setGraph(0);
		$this->params->setRemHp(100);
		$this->poke->setHp(100);
		$this->poke->setCondChk(0);
	}
	
	sub chkHp {
		my $this = shift;
		my $val = shift;
		return ($val eq "" || $val =~ /[^0-9.]/ || $val <= 0 || $val > 100) && !$this->params->isGraph;
	}
	
	sub chkLv {
		my $this = shift;
		my $val = shift;
		return $val eq "" || $val =~ /[^0-9]/ || $val < 1 || $val > 100;
	}
	
	sub chkTurn {
		my $this = shift;
		my $val = shift;
		return $val eq "" || $val =~ /[^0-9]/ || $val < 0;
	}
	
	sub chkIntExMinus {
		my $this = shift;
		my $val = shift;
		return $val eq "" || $val =~ /[^0-9]/ || $val < 0;
	}
}

{
	#-- ダイパ --
	#cDeg=被捕獲度, rHP=残HP率, ball=ボール種, lv=相手のレベル, turn=ターン, cond=状態補正, stone=石ころ, food=エサ
	package CalcDpt;
	use base (qw/PokeGetCalc/);
	
	sub paramCheck {
		my $this = shift;
		my $ball = $this->poke->getBall;
		
		if($ball < 0 || $ball > 16 || $ball == 13) {
			$this->{err}->addMsg('ball');
		}
		
		if(($ball == 7 || $ball == 8) && $this->chkTurn($this->poke->getTurn)) { 
			$this->{err}->addMsg('turn');
		}
		if(($ball == 9 || $ball == 16) && $this->chkLv($this->poke->getLv)) { 
			$this->{err}->addMsg('lv'); 
		}
		if($ball == 16 && $this->chkLv($this->poke->getMylv)) { 
			$this->{err}->addMsg('mylv'); 
		}
		
		if($ball == 10) {
			if($this->chkIntExMinus($this->poke->getStone)) { 
				$this->{err}->addMsg('stone');
			}
			if($this->chkIntExMinus($this->poke->getFood)) { 
				$this->{err}->addMsg('food'); 
			}
		} elsif($this->chkHp($this->poke->getHp)) { 
			$this->{err}->addMsg('hp'); 
		}
	}
	
	sub calc {
		my $this = shift;
		my $cond; #状態異常補正
		my $bCor; #ボール性能
		my $bAdd; #ボール性能ボーナス
		my $g;    #計算用被捕獲度
		my $gIdx; #捕獲指数
		my $Gc; #捕獲係数
		my $Gt; #判定閾値
		my @getPer; #捕獲率
				
		my $gDeg = $this->poke->getGDeg;
		my $ball = $this->poke->getBall;
		my @pokeType = @{$this->poke->getType};
		my $wgt  = $this->poke->getWgt;
		my $turn = $this->poke->getTurn;
		my $mylv = $this->poke->getMylv;
		my $lv   = $this->poke->getLv;
		my @sex  = @{$this->poke->getSex};
		
		#サファリゾーン
		if($ball == 10) {
			$gIdx = int(int(($this->poke->getGDeg * 100) / 1275) 
				* (2**$this->poke->getStone) * (1 / 2**$this->poke->getFood));
			$gIdx = ($gIdx < 3)? 3 : ($gIdx > 20)? 20 : $gIdx;
			$gIdx = int($gIdx * 1275 / 100);
			$gSubs = $gIdx;
			$cond = 1.0;
			$this->setSafariPark;
		} else {
			$gSubs = $gDeg;
			#状態異常定義
			$cond = (1, 1.5, 2.5)[$this->poke->getCondChk];
		}
		
		#ボール性能定義
		if($ball == 0) {
			$bCor = 1.0;
		}
		if($ball == 1 || $ball == 10) {
			$bCor = 1.5;
		}
		if($ball == 2) {
			$bCor = 2.0;
		}
		#リピートボール
		if($ball == 3) { 
			$bCor = ($this->poke->isChk("get"))? 3.0 : 1.0; 
		}
		#ネットボール
		if($ball == 4) {
			$bCor = (grep $_ == 3 || $_ == 12, @pokeType)? 3.0 : 1.0;
			$this->params->{isType} = 1;
		}
		#だいぶボール
		if($ball == 5) { 
			$bCor = ($this->poke->isChk("dive2") || $this->poke->isChk("fishing"))? 3.5 : 1.0;
		}
		#ダークボール
		if($ball == 6) { 
			$bCor = ($this->poke->isChk("dark"))? 4.0 : 1.0;
		}
		#クイックボール
		if($ball == 7) { 
			$bCor = ($turn == 0)? 5.0 : 1.0;
		}
		#タイマーボール
		if($ball == 8) { 
			$bCor = ($turn < 30)? $turn / 10 + 1.0 : 4.0; 
		}
		#ネストボール
		if($ball == 9) { 
			$bCor = ($lv < 30)? (40 - $lv) / 10 : 1.0; 
		}
		
		#ヘビー
		if($ball == 11) {
			$bCor = 1.0;
			$bAdd = ($wgt < 100)? -20
			                    : ($wgt < 200)? 0
			                                  : ($wgt < 300)? 20
			                                                : 30;
			$this->params->{isWgt} = 1;
		} else {
			$bAdd = 0;
		}
		#ルアー
		if($ball == 12) {
			$bCor = (grep($_ == 3, @pokeType) && $this->poke->isChk("fishing"))? 3.0 : 1.0;
			$this->{result}->{isType} = 1;
		}
		#スピード
		if($ball == 13) {
			#TODO 計算式不明（すばやさの種族値により変化・・・ではない）
		}
		#ムーン
		if($ball == 14) {
			$bCor = (grep $_ == $this->poke->getPno, @{$this->{moon}})? 4.0 : 1.0;
		}
		#ラブラブ
		if($ball == 15) {
			$bCor = ($sex[0] && $sex[1] && $this->poke->isChk("oppo"))? 8.0 : 1.0;
			$this->params->{isSex} = 1;
		}
		#レベル
		if($ball == 16) {
			$bCor = ($mylv > $lv * 4)? 8.0
			                         : ($mylv > $lv * 2)? 4.0
			                                            : ($mylv > $lv)? 2.0
			                                                           : 1.0;
		}
		
		#補正被捕獲度
		$corDeg = $gSubs * $bCor + $bAdd;
		#$corDeg = 255 if($corDeg > 255);
		$corDeg = 3   if($corDeg < 3);
		
		foreach $rHP (@{$this->params->getRemHp}) {
			#捕獲係数
			$Gc = int((3 - $rHP / 100 * 2) * $corDeg / 3 * $cond);
			if( $Gc < 0xff ) {
				#判定閾値
				$Gt = int( 0xffff0 / int(sqrt(int(sqrt(int(0xff0000 / $Gc))))) );
				#捕獲率
				push @getPer, (($Gt + 1) / 0x10000) ** 4;
			} else {
				push @getPer, 1;
			}
		}
		
		$this->params->setGetPer(@getPer);
		$this->params->setGDeg($this->poke->getGDeg);
		$this->params->setGIdx($gIdx);
		$this->params->setBCor($bCor);
		$this->params->setGc($Gc);
		$this->params->setGt($Gt);
		$this->params->setGtMax(0xFFFF);
		if($ball == 11) {
			$this->params->setBAdd($bAdd);
		}
	}
}
{
	#-- アドバンス --
	#cDeg=被捕獲度, rHP=残HP率, ball=ボール種, lv=相手のレベル, turn=ターン, cond=状態補正, stone=石ころ, food=エサ
	package CalcAdv;
	use base (qw/PokeGetCalc/);
	
	sub paramCheck {
		my $this = shift;
		my $ball = $this->poke->getBall;
		
		if($ball < 0 || $ball > 8) {
			$this->{err}->addMsg('ball');
		}
		
		if($ball == 6 && $this->chkTurn($this->poke->getTurn)) { 
			$this->{err}->addMsg('turn');
		}
		if($ball == 7 && $this->chkLv($this->poke->getLv)) { 
			$this->{err}->addMsg('lv'); 
		}
		if($ball == 8) {
			if($this->chkIntExMinus($this->poke->getStone)) { 
				$this->{err}->addMsg('stone');
			}
			if($this->chkIntExMinus($this->poke->getFood)) { 
				$this->{err}->addMsg('food'); 
			}
		} elsif($this->chkHp($this->poke->getHp)) { 
			$this->{err}->addMsg('hp'); 
		}
	}
	
	sub calc {
		my $this = shift;
		my $cond; #状態異常補正
		my $bCor; #ボール性能
		my $g;    #計算用被捕獲度
		my $gIdx; #捕獲指数
		my $Gc; #捕獲係数
		my $Gt; #判定閾値
		my @getPer; #捕獲率
		
		my $ball = $this->poke->getBall;
		my @pokeType = @{$this->poke->getType};
		
		#サファリゾーン
		if($ball == 8) {
			$gIdx = int(int(($this->poke->getGDeg * 100) / 1275) 
				* (2**$this->poke->getStone) * (1 / 2**$this->poke->getFood));
			$gIdx = ($gIdx < 3)? 3 : ($gIdx > 20)? 20 : $gIdx;
			$gIdx = int($gIdx * 1275 / 100);
			$g = $gIdx;
			$cond = 1.0;
			$this->setSafariPark;
		} else {
			$g = $this->poke->getGDeg;
			#状態異常定義
			$cond = 1 + $this->poke->getCondChk * 0.5;
		}
		
		#ボール性能定義
		if($ball == 0) {
			$bCor = 1.0;
		}
		if($ball == 1 || $ball == 8) {
			$bCor = 1.5;
		}
		if($ball == 2) {
			$bCor = 2.0;
		}
		#リピートボール
		if($ball == 3) { 
			$bCor = ($this->poke->isChk("get"))? 3.0 : 1.0; 
		}
		#ネットボール
		if($ball == 4) {
			$bCor = (grep $_ == 3 || $_ == 12, @pokeType)? 3.0 : 1.0;
			$this->params->{isType} = 1;
		}
		#ダイブボール
		if($ball == 5) { 
			$bCor = (grep($_ == 3, @pokeType) && $this->poke->isChk("dive"))? 3.5 : 1.0;
			$this->params->{isType} = 1;
		}
		#タイマーボール
		if($ball == 6) { 
			$bCor = ($this->poke->getTurn < 30)? $this->poke->getTurn / 10 + 1.0 : 4.0; 
		}
		#ネストボール
		if($ball == 7) { 
			$bCor = ($this->poke->getLv < 30)? (40 - $this->poke->getLv) / 10 : 1.0; 
		}
		
		foreach $rHP (@{$this->params->getRemHp}) {
			#捕獲係数
			$Gc = int((3 - $rHP / 100 * 2) * $g * $bCor / 3 * $cond);
			if( $Gc < 0xff ) {
				#判定閾値
				$Gt = int( 0xffff0 / int(sqrt(int(sqrt(int(0xff0000 / $Gc))))) );
				#捕獲率
				push @getPer, (($Gt + 1) / 0x10000) ** 4;
			} else {
				push @getPer, 1;
			}
		}
		
		$this->params->setGetPer(@getPer);
		$this->params->setGDeg($this->poke->getGDeg);
		$this->params->setGIdx($gIdx);
		$this->params->setBCor($bCor);
		$this->params->setGc($Gc);
		$this->params->setGt($Gt);
		$this->params->setGtMax(0xFFFF);
	}
}
	

#-- 金銀 --
{
	package CalcGSC;
	use base (qw/PokeGetCalc/);
	
	sub paramCheck {
		my $this = shift;
		my $ball = $this->poke->getBall;
		
		if($ball < 0 || $ball > 7) {
			$this->{err}->addMsg('ball');
		}
		
		if($this->chkHp($this->poke->getHp)) { 
			$this->{err}->addMsg('hp');
		}
		if($ball == 7 && $this->chkLv($this->poke->getLv)) { 
			$this->{err}->addMsg('lv'); 
		}
		if($ball == 7 && $this->chkLv($this->poke->getMylv)) { 
			$this->{err}->addMsg('mylv'); 
		}
	}
	
	sub calc {
		my $this = shift;
		my $cond;
		my $gDeg;
		my $bCor;
		my $bAdd;
		my $corDeg;
		my @edge; #特定ポケモンNo.
		my @getPer;
		
		my $gDeg = $this->poke->getGDeg;
		my $ball = $this->poke->getBall;
		my $wgt  = $this->poke->getWgt;
		my @type = @{$this->poke->getType};
		my $mylv = $this->poke->getMylv;
		my $lv   = $this->poke->getLv;
		my @sex  = @{$this->poke->getSex};
		
		#状態異常定義
		$cond = $this->poke->getCondChk * 5;
		
		#ボール性能定義
		$bCor = 1.0	if($ball == 0);
		$bCor = 1.5	if($ball == 1);
		$bCor = 2.0	if($ball == 2);
		#ヘビーボール
		if($ball == 3) {
			$bCor = 1.0;
			$bAdd = ($wgt < 100)? -20
			                    : ($wgt < 200)? 0
			                                  : ($wgt < 300)? 20
			                                                : 30;
			$this->params->{isWgt} = 1;
		} else {
			$bAdd = 0;
		}
		#ルアーボール
		if($ball == 4) {
			$bCor = (grep($_ == 3, @type) && $this->poke->isChk("fishing"))? 3.0 : 1.0;
			$this->{result}->{isType} = 1;
		}
		
		#スピードボール
		if($ball == 5) {
			@edge = (80, 87, 113);
			$bCor = (grep $_ == $this->poke->getPno, @edge)? 4.0 : 1.0;
		}
		#ラブラブボール
		if($ball == 6) {
			$bCor = ($sex[0] && $sex[1] && $this->poke->isChk("same"))? 8.0 : 1.0;
			$this->params->{isSex} = 1;
		}
		#レベルボール
		if($ball == 7) {
			$bCor = ($mylv > $lv * 4)? 8.0
			                         : ($mylv > $lv * 2)? 4.0
			                                            : ($mylv > $lv)? 2.0
			                                                           : 1.0;
		}
		
		#補正被捕獲度
		$corDeg = $gDeg * $bCor + $bAdd;
		#$corDeg = 255 if($corDeg > 255);
		$corDeg = 0   if($corDeg < 0);
		
		#捕獲率
		foreach $rHP (@{$this->params->getRemHp}) {
			push @getPer, (int((1 - $rHP / 200) * $corDeg) + $cond + 1) / 256;
			$getPer[$#getPer] = 1	if($getPer[$#getPer] > 1);
		}
		
		#出力
		$this->params->setGetPer(@getPer);
		$this->params->setGDeg($gDeg);
		$this->params->setBCor($bCor);
		$this->params->setBAdd($bAdd);
	}
}

#-- 赤緑 --
{
	package CalcRGB;
	use base (qw/PokeGetCalc/);
	
	sub paramCheck {
		my $this = shift;
		my $pokeHp = $this->poke->getHp;
		
		if($ball < 0 || $ball > 2) {
			$this->{err}->addMsg('ball');
		}
		
		if($this->chkHp($pokeHp)) {
			$this->{err}->addMsg('hp');
		}
	}
	
	sub calc {
		my $this = shift;
		my($cond, $bCor, $up, $rHP_ef, $up_g, $Gt, @getPer);
		
		my $condChk = $this->poke->getCondChk;
		my $ball = $this->poke->getBall;
		my $gDeg = $this->poke->getGDeg;
		
		#状態異常定義
		$cond = ($condChk == 1)? 12 : ($condChk == 2)? 25 : 0;
		
		#ボール性能定義
		$bCor = 256 if($ball == 0);
		$bCor = 201 if($ball == 1);
		$bCor = 151 if($ball == 2);
		$up = ($ball == 1)? 2 : 3;
		
		foreach $rHP (@{$this->params->getRemHp}) {
			#実質残りHP率
			$rHP_ef = $rHP;
			if($rHP_ef < 100 / $up) { $rHP_ef = 100 / $up };
			
			#捕獲率
			if($gDeg < $cond) {
				push @getPer, $cond / $bCor;
				$rHP_ef = undef;
			} else {
				push @getPer,
					(($gDeg + 1) * (1 / ($up * $rHP_ef / 100) 
					- $cond / 256) + $cond) / $bCor;
			}
			#判定閾値
			$up_g = ($ball == 1)? 8 : 12;
			$Gt = int(255 / $up_g / ($rHP / 400));
			$Gt = 255 if($Gt > 255);
			$getPer[$#getPer] = 1	if($getPer[$#getPer] > 1);
		}
		
		#結果
		$this->params->setGetPer(@getPer);
		$this->params->setGDeg($gDeg);
		$this->params->setRHpEf($rHP_ef);
		$this->params->setBCor($bCor);
		$this->params->setGt($Gt);
		$this->params->setGtMax(0xFF);
	}
}

1;
