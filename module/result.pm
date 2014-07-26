use Poke;
use resultParams;

{
	# 詳細結果
	package DetailResult;
	
	sub new {
		my $this = shift;
		my $hash = {
			params => shift
		};
		bless $hash, $this;
	}
	
	sub makeResult {
		my $this = shift;
		my $output = shift;
		
		#ウィンドウサイズ
		$this->{winSize} = $output->getContext("winSize_detail");
		
		my($get, $try, $freq, $params);
		my($cumList, $cumTable);
		
		#捕獲率
		$get = $this->{params}->getGetPer->[0];
		
		#頻度表現 expression by frequency
		if($get < 0.95) {
			my $try = 1 / $get;
			if($try - int $try) {
				$freq = sprintf($output->getContext("freq_normal"), $try);
			} else {
				$freq = sprintf($output->getContext("freq_just"), $try);
			}
		} elsif($get < 1) {
			$freq = $output->getContext("freq_95");
		} else {
			$freq = $output->getContext("freq_100");
		}
		$freq = sprintf($output->getContext("freq_tr"), $freq);
		
		#累積捕獲率 CUMulative Capture Percentage
		foreach(0.1, 0.5, 0.8, 0.95) {
			next if($get > $_);
			my $times = $this->calcTimesOfCumPer($_, $get);
			$cumList .= sprintf $output->getContext("cumPer_tr"), $_ * 100, $times;
		}
		if($cumList) {
			$cumTable = sprintf($output->getContext("cumPer_tbl"), $cumList);
		}
		
		#計算パラメータ
		my @items = qw/gDeg gIdx bCor Gc Gt remHpEf/; #表示順
		my $val;
		foreach(@items) {
			next if(!$this->{params}->{$_});
			if($_ eq 'Gt') { $val = $output->outGt; }
			elsif($_ eq 'bCor') { $val = $output->outBCor; }
			else { $val = $this->{params}->{$_}; }
			
			$params .= sprintf($output->getContext("param_tr"), $output->getContext($_), $val);
		}
		#ポケモンパラメータ
		if($this->{params}->{isType}) {
			$params .= sprintf($output->getContext("param_tr"), 
				$output->getContext("type"), $output->outTypeName);
		}
		if($this->{params}->{isWgt}) { 
			$params .= sprintf($output->getContext("param_tr"), 
				$output->getContext("wgt"), $output->outWgt);
		}
		if($this->{params}->{isSex}) {
			$params .= sprintf($output->getContext("param_tr"), 
				$output->getContext("sex"), $output->outSexRatio);
		}
		
		$get = sprintf($output->getContext("getPer_tr"), $output->outGetPer);
		
		#HTML組み立て
		return sprintf($output->getContext("calcResult"), 
			$get, $freq, $cumTable, $params);
	}
	
	#特定確率に到達する回数を求める
	#引数：任意確率, 捕獲率
	sub calcTimesOfCumPer {
		my($this, $cumPer, $getPer) = @_;
		
		if($getPer == 1) {
			return undef;
		} else {
			my $val = log(1 - $cumPer) / log(1 - $getPer);
			#切り上げして返す
			return ($val - int $val)? int $val + 1 : $val;
		}
	}
}

{
	#グラフ用結果
	package GraphResult;
	
	sub new {
		my $this = shift;
		my $hash = {
			params => shift
		};
		bless $hash, $this;
	}
	
	sub makeResult {
		my $this = shift;
		my $output = shift;
		
		#ウィンドウサイズ
		$this->{winSize} = $output->getContext("winSize_graph");
		
		my $q = $output->makeUrlForLink;
		my $html = qq{<center><img border="0" class="graph" src="$PokeGet::NAME?m=g&amp;$q"></center>\n};
		$html .= $output->{con}->makeGetPerTable($output->{result});
		
		return $html;
	}
	
	#残りHP率
	sub outRemHp {
		my $this = shift;
		return $this->getContext("remHp_graph");
	}
}

1;
