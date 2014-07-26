#use utf8;

#コンテキストコンテナ
{
	package Context;
	
	sub new {
		my $this = shift;
		my $hash = {
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
}

{
	#---
	#計算パラメータ for PC
	#(継承:Result)
	#---
	package ContextPC;
	use base (qw/Context/); 
	
	sub new {
		my $this = shift;
		my $ver = $PokeGet::IN->{ver};
		$hash = ResultParams->new(@_);
		
		#タイプ
		$hash->{"typeDef"} = [undef, 'ノーマル', 'ほのお', 'みず', 'でんき', 'くさ', 'こおり',
			'かくとう', 'どく', 'じめん', 'ひこう', 'エスパー',
			'むし', 'いわ', 'ゴースト', 'ドラゴン', 'あく', 'はがね'];
		#バージョン
		$hash->{"verName"} = {'dpt'=>'ダイパ・HG・SS', 'adv'=>'R・S・FR・LG', 'gsc'=>'金・銀・クリスタル', 'rgb'=>'赤・緑・青'};
		#状態名
		$hash->{"condName"} = ['けんこう', 'どく・まひ・やけど', 'ねむり・こおり'];
		#ボール名
		if($ver eq 'dpt') {
			$hash->{"ballName"} = ['モンスターボール', 'スーパーボール', 'ハイパーボール', 'リピートボール',
				'ネットボール', 'ダイブボール', 'ダークボール', 'クイックボール', 'タイマーボール', 'ネストボール', 'サファリボール',
				'ヘビーボール', 'ルアーボール', 'スピードボール', 'ムーンボール', 'ラブラブボール', 'レベルボール'];
		}
		if($ver eq 'adv') {
			$hash->{"ballName"} = ['モンスターボール', 'スーパーボール', 'ハイパーボール', 'リピートボール',
				'ネットボール', 'ダイブボール', 'タイマーボール', 'ネストボール', 'サファリボール'];
		}
		if($ver eq 'gsc') {
			$hash->{"ballName"} = ['モンスターボール', 'スーパーボール', 'ハイパーボール', 'ヘビーボール',
				'ルアーボール', 'スピードボール', 'ラブラブボール', 'レベルボール'];
		}
		if($ver eq 'rgb') {
			$hash->{"ballName"} = ['モンスターボール', 'スーパーボール', 'ハイパーボール'];
		}
		
		#定数
		$hash->{context} = {
			sepChar => "・",
			unknown => "不明",
			none    => "&mdash;",
			
			#項目名
			gDeg  => '被捕獲度', 
			gIdx  => '捕獲指数', 
			Gc    => '捕獲係数', 
			Gt    => '判定閾値', 
			bCor  => '被捕獲補正',
			remHpEf => '実残りHP率',
			type  => 'タイプ',
			sex   => '♂♀存在比',
			wgt   => 'おもさ',
			
			ver  => 'バージョン',
			poke => 'ポケモン',
			cond => '状態',
			remHp=> '残りＨＰ率',
			ball => 'ボール',
			turn => '経過ターン',
			lv => '自分/相手のLv',
			safari => '石/エサの回数',
			
			#♂♀存在比
			sexRatio_normal => "%d : %d",
			sexRatio_sexless => "性別なし",
			sexRatio_maleOnly => "♂のみ",
			sexRatio_femaleOnly => "♀のみ",
			
			#判定閾値
			Gt_dpt => "0x%4X<font size=\"-1\">/0x%4X</font>",
			Gt_adv => "0x%4X<font size=\"-1\">/0x%4X</font>",
			Gt_rgb => "%d<font size=\"-1\">/%d</font>",
			Gt_disabled => "&mdash;",
			
			#ポケモン名
			pname_s => "<b>%s</b>",
			
			#被捕獲補正
			bCor_dpt => "×%.1f%+d",
			bCor_adv => "×%.1f",
			bCor_gsc => "×%.1f%+d",
			bCor_rgb => "÷%d",
			
			#実残りHP率
			remHpEf_s => "%.1f％",
			
			#残りHP率
			remHp_normal => "%s％",
			remHp_graph => qq{<font color="gray">グラフ</font>},
			
			#おもさ
			wgt_s => "%.1fkg",
			
			#食べ物/石ころ
			safari_s => "%s / %s",
			
			#レベル
			lv_s => "%s / %s",
			
			#ターン
			turn_s => "%s",
			
			#ウィンドウサイズ
			winSize_detail => Point->new(350, 600),
			winSize_graph => Point->new(625, 800),
			
			#計算結果の部
			calcResult => <<EOF,
<table class="res" align="center" border="0" cellpadding="0" cellspacing="0">
%s%s%s%s
</table>
EOF
			
			#捕獲率
			getPer_tr => qq{<tr><td class="getPer" colspan="2">捕獲率： <span style="font-size: 24pt" lang="en">%s</span></td></tr>},
			
			#頻度表記確率
			freq_tr => qq{<tr><td colspan="2" class="cmt">%s</td></tr>},
			
			freq_normal => "約<b>%.1f回</b>に１回ゲットできる確率",
			freq_just   => "<b>%d回</b>に１回ゲットできる確率",
			freq_95     => "<b>ほぼ１回</b><br>でゲットできる確率",
			freq_100    => "<b>一発</b>でゲット成功！",
			
			#特定累積捕獲率到達回数
			cumPer_tbl => <<EOF,
	<tr><td colspan="2" class="cmt">
		<table border="0" cellpadding="0" cellspacing="0" align="center" class="cumPer"><tr>
		<td>累積捕獲率</td>
		<td><table border="0" style="font-size: 1em; text-align: right">%s</table></td>
		<td>で到達</td></tr>
		</table></td>
	</tr>
EOF
			cumPer_tr => "<tr><td>%d% には</td><td>%d回</td></tr>",
			
			#パラメータ
			param_tr => qq{\t<tr><td class="item3">%s =</td><td class="val">%s</td></tr>\n},
			
			#ステータス情報
			stats_tr => qq{<tr><td class="item3">%s：</td><td>%s</td></tr>},
			rscChk_tr => qq{<tr><td colspan="2" class="exChk"><ul style="margin: 0">%s</ul></td></tr>},
			stats_tbl => sub {
				my($rscList, $rscChk, $hereUrl) = @_;
				return <<EOF;
<table class="resSrc" align="center" border="0" cellpadding="2" cellspacing="0">
$rscList
$rscChk
$hereUrl
</table>
EOF
			},
			
			#チェック項目
			chk => {
				get => "<li>図鑑に登録されている</li>",
				dive => "<li>海底のポケモン</li>",
				dive2 => "<li>水上のポケモン</li>",
				fishing => "<li>つり上げたポケモン</li>",
				same => "<li>自分と同種で同性</li>",
				oppo => "<li>自分と同種で異性</li>",
				dark => "<li>夜か暗闇で出現</li>",
				none => "<li><font color=\"gray\">チェックなし</font></li>",
			},
			
			#計算結果のURL
			hereUrl  => <<EOF,
<tr><td colspan="2" class="hereUrl">計算結果のURL <span class="note">（クリックで全選択できます）</span><br>
<textarea col="50" readonly onclick="this.focus();this.select();">
$ENV{'SCRIPT_URI'}?m=res&amp;%s
</textarea></td></tr>
EOF
			
			#ウィンドウサイズ
			sizeCtl  => <<EOF,
<script type="text/javascript">
//var isIE = navigator.appName.indexOf("Internet Explorer") != -1;

var frame = parent.document.getElementById("resultFrame");
//resultFrame.style.width = (isIE? document.body.offsetWidth : document.documentElement.scrollWidth) + "px";
//resultFrame.style.height = (isIE? document.body.offsetHeight : document.documentElement.scrollHeight) + "px";
frame.style.width = "%spx";
frame.style.height = "%spx";
</script>
EOF
			
			bodyAttr => undef,
			
			#閉じボタン
			backto_btn => undef, #qq{<br>\n<center><input type="button" value="閉じる" onClick="window.close();"></center>},
			
			#フッター(外来さん用)
			backto_link => qq{<br>\n<center><a href="$PokeGet::NAME">Go to $PokeGet::TITLE</a></center>},
			rights => <<EOF,
<div class="right" id="res"><strong>［$PokeGet::TITLE］ ver. $PokeGet::VER</strong><br>
プログラム・管理：<a href="mailto:midis.cube@gmail.com">めたルイ</a>@<a href="http://nin10.web.infoseek.co.jp/" target="_blank">ニンテンドー特攻隊</a><br>
データ提供：<br>
&nbsp;&nbsp;ねんネン様@<a href="http://www.pic.biz/" target="_blank">ポケットモンスター情報センター</a><br>
&nbsp;&nbsp;SUN様@<a href="http://trainer.geo.jp/">トレーナー天国</a><br>
&nbsp;&nbsp;<a href="http://wiki.xn--rckteqa2e.com/">ポケモンWiki</a></div>
EOF
			
			#BODY
			htmlBody => sub {
				my($result, $statusList, $backto, $rights) = @_;
				return <<EOF;
<h1>計算結果</h1>
$result
$statusList
$backto
$rights
EOF
			},
			
			#結果ページスタイル
			style_user => 'std',
			style_guest => 'std',
		};
				
		bless $hash, $this;
	}
	
	#捕獲率
	sub outGetPer {
		my $this = shift;
		my $result = shift;
		my $val = sprintf("%.4f", $result->{params}->getGetPer->[0] * 100);
		$val =~ s/(?<=\.\d{1})(\d+)/<span style="font-size: 0.6em;">$1<\/span>%/;
		return $val;
	}
	
	# グラフ用捕獲率リスト
	sub makeGetPerTable {
		my $this = shift;
		my $result = shift;
		my($out, $n);
		
		$out .= qq{<table border="0" cellspacing="1" cellpadding="3" align="center" class="perList">\n};
		$out .= qq{<tr>};
		#HP
		$out .= qq{<th>HP%</th>};
		$n = 0;
		foreach(reverse @{$result->{params}->getRemHp}) {
			$out .= qq{<td>$_</td>} if($n ^= 1);
		}
		
		$out .= qq{</tr>\n<tr>};
		
		#捕獲率
		$out .= qq{<th>捕獲率</th>};
		$n = 0;
		foreach(reverse @{$result->{params}->getGetPer}) {
			$out .= sprintf qq{<td class="per">%.1f</td>}, $_ * 100 if($n ^= 1);
		}
		
		$out .= qq{</tr>\n</table>\n<br>};
		
		return $out;
	}
	
}

{
	#---
	#計算パラメータ for PC
	#(継承:Result)
	#---
	package ContextPC_en;
	use base (qw/Context/); 
	
	sub new {
		my $this = shift;
		my $ver = $PokeGet::IN->{ver};
		$hash = ResultParams->new(@_);
		
		#タイプ
#		$hash->{"typeDef"} = [undef, 'ノーマル', 'ほのお', 'みず', 'でんき', 'くさ', 'こおり',
#			'かくとう', 'どく', 'じめん', 'ひこう', 'エスパー',
#			'むし', 'いわ', 'ゴースト', 'ドラゴン', 'あく', 'はがね'];
		$hash->{"typeDef"} = [undef, 'Normal', 'Fire', 'Water', 'Electric', 'Grass', 'Ice',
			'Fighting', 'Poison', 'Ground', 'Flying', 'Psychic',
			'Bug', 'Rock', 'Ghost', 'Dragon', 'Dark', 'Steel'];
		#バージョン
		$hash->{"verName"} = {'dpt'=>'4th gen.', 'adv'=>'3rd gen.', 'gsc'=>'2nd gen.', 'rgb'=>'1st gen.'};
		#状態名
		$hash->{"condName"} = ['Fine', 'Poison/Paralysis/Burn', 'Sleep/Freeze'];
		#ボール名
		if($ver eq 'dpt') {
			$hash->{"ballName"} = ['Pok&eacute; Ball', 'Great Ball', 'Ultra Ball', 'Repeat Ball',
				'Net Ball', 'Dive Ball', 'Dusk Ball', 'Quick Ball', 'Timer Ball', 'Nest Ball', 'Safari Ball',
				'Heavy Ball', 'Lure Ball', 'Fast Ball', 'Moon Ball', 'Love Ball', 'Level Ball'];
		}
		if($ver eq 'adv') {
			$hash->{"ballName"} = ['Pok&eacute; Ball', 'Great Ball', 'Ultra Ball', 'Repeat Ball',
				'Net Ball', 'Dive Ball', 'Timer Ball', 'Nest Ball', 'Safari Ball'];
		}
		if($ver eq 'gsc') {
			$hash->{"ballName"} = ['Pok&eacute; Ball', 'Great Ball', 'Ultra Ball', 'Heavy Ball',
				'Lure Ball', 'Fast Ball', 'Love Ball', 'Level Ball'];
		}
		if($ver eq 'rgb') {
			$hash->{"ballName"} = ['Pok&eacute; Ball', 'Great Ball', 'Ultra Ball'];
		}
		
		#定数
		$hash->{context} = {
			sepChar => "/",
			unknown => "?",
			none    => "&mdash;",
			
			#項目名
			gDeg  => 'Catch rate', 
			gIdx  => 'Catch index', 
			Gc    => 'Catch coef.', 
			Gt    => 'Decision thrsh.', 
			bCor  => 'C.R. bonus',
			remHpEf => 'Actual rem. HP %',
			type  => 'Type',
			sex   => '♂♀ ratio',
			wgt   => 'Weight',
			
			ver  => 'Version',
			poke => 'Pok&eacute;mon',
			cond => 'Condition',
			remHp=> 'Rem. HP %',
			ball => 'Ball',
			turn => 'Elapsed turns',
			lv => "Ally/Wild\'s Lv",
			safari => 'Rocks/Baits',
			
			#♂♀存在比
			sexRatio_normal => "%d : %d",
			sexRatio_sexless => "Unknown",
			sexRatio_maleOnly => "Only ♂",
			sexRatio_femaleOnly => "Only ♀",
			
			#判定閾値
			Gt_dpt => "0x%4X<font size=\"-1\">/0x%4X</font>",
			Gt_adv => "0x%4X<font size=\"-1\">/0x%4X</font>",
			Gt_rgb => "%d<font size=\"-1\">/%d</font>",
			Gt_disabled => "&mdash;",
			
			#ポケモン名
			pname_s => "<b>%s</b>",
			
			#被捕獲補正
			bCor_dpt => "×%.1f%+d",
			bCor_adv => "×%.1f",
			bCor_gsc => "×%.1f%+d",
			bCor_rgb => "÷%d",
			
			#実残りHP率
			remHpEf_s => "%.1f%",
			
			#残りHP率
			remHp_normal => "%s%",
			remHp_graph => qq{<font color="gray">Graph</font>},
			
			#おもさ
			wgt_s => "%.1fkg",
			
			#食べ物/石ころ
			safari_s => "%s / %s",
			
			#レベル
			lv_s => "%s / %s",
			
			#ターン
			turn_s => "%s",
			
			#ウィンドウサイズ
			winSize_detail => Point->new(350, 600),
			winSize_graph => Point->new(625, 800),
			
			#計算結果の部
			calcResult => <<EOF,
<table class="res" align="center" border="0" cellpadding="0" cellspacing="0">
%s%s%s%s
</table>
EOF
			
			#捕獲率
			getPer_tr => qq{<tr><td class="getPer" colspan="2">Catch prob.: <span style="font-size: 24pt" lang="en">%s</span></td></tr>},
			
			#頻度表記確率
			freq_tr => qq{<tr><td colspan="2" class="cmt">%s</td></tr>},
			
			freq_normal => "Probability of one in about <b>%.1f</b>",
			freq_just   => "Probability of one in <b>%d</b>",
			freq_95     => "Probability of one in <b>nearly one</b>",
			freq_100    => "You'll catch <b>on the first try</b>!",
			
			#特定累積捕獲率到達回数
			cumPer_tbl => <<EOF,
	<tr><td colspan="2" class="cmt">
		<table border="0" cellpadding="0" cellspacing="0" align="center" class="cumPer"><tr>
		<td>Cumulative<br>catch prob. </td>
		<td><table border="0" style="font-size: 1em; text-align: right">%s</table></td>
		<td>&nbsp;</td></tr>
		</table></td>
	</tr>
EOF
			cumPer_tr => "<tr><td>&nbsp;For %d%%, </td><td>%d times</td></tr>",
			
			#パラメータ
			param_tr => qq{\t<tr><td class="item3">%s =</td><td class="val">%s</td></tr>\n},
			
			#ステータス情報
			stats_tr => qq{<tr><td class="item3">%s:&nbsp;</td><td>%s</td></tr>},
			rscChk_tr => qq{<tr><td colspan="2" class="exChk"><ul style="margin: 0">%s</ul></td></tr>},
			stats_tbl => sub {
				my($rscList, $rscChk, $hereUrl) = @_;
				return <<EOF;
<table class="resSrc" align="center" border="0" cellpadding="2" cellspacing="0">
$rscList
$rscChk
$hereUrl
</table>
EOF
			},
			
			#チェック項目
			chk => {
				get => "<li>Caught before</li>",
				dive => "<li>Underwater</li>",
				dive2 => "<li>On the water</li>",
				fishing => "<li>Hocked by a rod</li>",
				same => "<li>Same gender and species</li>",
				oppo => "<li>Opposite gender, same species</li>",
				dark => "<li>In the night or darkness</li>",
				none => "<li><font color=\"gray\">No checked</font></li>",
			},
			
			#計算結果のURL
			hereUrl  => <<EOF,
<tr><td colspan="2" class="hereUrl">Result\'s URL <span class="note">(All select to click)</span><br>
<textarea col="50" readonly onclick="this.focus();this.select();">
$ENV{'SCRIPT_URI'}?m=res&amp;%s
</textarea></td></tr>
EOF
			
			#ウィンドウサイズ
			sizeCtl  => <<EOF,
<script type="text/javascript">
//var isIE = navigator.appName.indexOf("Internet Explorer") != -1;

var frame = parent.document.getElementById("resultFrame");
//resultFrame.style.width = (isIE? document.body.offsetWidth : document.documentElement.scrollWidth) + "px";
//resultFrame.style.height = (isIE? document.body.offsetHeight : document.documentElement.scrollHeight) + "px";
frame.style.width = "%spx";
frame.style.height = "%spx";
</script>
EOF
			
			bodyAttr => undef,
			
			#閉じボタン
			backto_btn => undef, #qq{<br>\n<center><input type="button" value="閉じる" onClick="window.close();"></center>},
			
			#フッター(外来さん用)
			backto_link => qq{<br>\n<center><a href="$PokeGet::NAME?lang=en">Go to $PokeGet::TITLE_EN</a></center>},
			rights => <<EOF,
<div class="right" id="res"><strong>［$PokeGet::TITLE_EN］ ver. $PokeGet::VER</strong><br>
Programed and managed by <a href="mailto:midis.cube@gmail.com">MetaLui</a>@<a href="http://nin10.web.infoseek.co.jp/" target="_blank">ニンテンドー特攻隊</a>(Nintendo S.A.P.)
Data provided by<br>
&nbsp;&nbsp;ねんネン様 (Nen-nen)@<a href="http://www.pic.biz/" target="_blank">ポケットモンスター情報センター</a>(Pokemon Infomation Center), <br>
&nbsp;&nbsp;SUN様@<a href="http://trainer.geo.jp/">ﾄﾚｰﾅｰ天国</a>(Trainers Heaven), <br>
&nbsp;&nbsp;<a href="http://wiki.xn--rckteqa2e.com/">ポケモンWiki</a>(Pok&eacute;mon Wiki), <a href="http://bulbapedia.bulbagarden.net/wiki/">Burubapedia</a></div>
EOF
			
			#BODY
			htmlBody => sub {
				my($result, $statusList, $backto, $rights) = @_;
				return <<EOF;
<h1>Calculation Result</h1>
$result
$statusList
$backto
$rights
EOF
			},
			
			#結果ページスタイル
			style_user => 'std',
			style_guest => 'std',
		};
				
		bless $hash, $this;
	}
	
	#捕獲率
	sub outGetPer {
		my $this = shift;
		my $result = shift;
		my $val = sprintf("%.4f", $result->{params}->getGetPer->[0] * 100);
		$val =~ s/(?<=\.\d{1})(\d+)/<span style="font-size: 0.6em;">$1<\/span>%/;
		return $val;
	}
	
	# グラフ用捕獲率リスト
	sub makeGetPerTable {
		my $this = shift;
		my $result = shift;
		my($out, $n);
		
		$out .= qq{<table border="0" cellspacing="1" cellpadding="3" align="center" class="perList">\n};
		$out .= qq{<tr>};
		#HP
		$out .= qq{<th>HP%</th>};
		$n = 0;
		foreach(reverse @{$result->{params}->getRemHp}) {
			$out .= qq{<td>$_</td>} if($n ^= 1);
		}
		
		$out .= qq{</tr>\n<tr>};
		
		#捕獲率
		$out .= qq{<th>Catch%</th>};
		$n = 0;
		foreach(reverse @{$result->{params}->getGetPer}) {
			$out .= sprintf qq{<td class="per">%.1f</td>}, $_ * 100 if($n ^= 1);
		}
		
		$out .= qq{</tr>\n</table>\n<br>};
		
		return $out;
	}
	
}

{
	#---
	#計算パラメータ for ケータイ
	#(継承:Result)
	#---
	package ContextK;
	use base (qw/Context/); 
	
	sub new {
		my $this = shift;
		my $ver = $PokeGet::IN->{ver};
		$hash = ResultParams->new(@_);
		
		#タイプ
		$hash->{"typeDef"} = [undef, 'ﾉｰﾏﾙ', 'ほのお', 'みず', 'でんき', 'くさ', 'こおり',
			'かくとう', 'どく', 'じめん', 'ひこう', 'ｴｽﾊﾟｰ',
			'むし', 'いわ', 'ｺﾞｰｽﾄ', 'ﾄﾞﾗｺﾞﾝ', 'あく', 'はがね'];
		#バージョン
		$hash->{"verName"} = {'dpt'=>'D/P/HG/SS', 'adv'=>'R/S/FR/LG', 'gsc'=>'金/銀', 'rgb'=>'赤/緑'};
		#状態名
		$hash->{"condName"} = ['けんこう', '毒/ﾏﾋ/ﾔｹﾄﾞ', '眠り/氷'];
		#ボール名
		if($ver eq 'dpt') {
			$hash->{"ballName"} = ['ﾓﾝｽﾀｰ', 'ｽｰﾊﾟｰ', 'ﾊｲﾊﾟｰ', 'ﾘﾋﾟｰﾄ',
				'ﾈｯﾄ', 'ﾀﾞｲﾌﾞ', 'ﾀﾞｰｸ', 'ｸｲｯｸ', 'ﾀｲﾏｰ', 'ﾈｽﾄ', 'ｻﾌｧﾘ',
				'ﾍﾋﾞｰ', 'ﾙｱｰ', 'ｽﾋﾟｰﾄﾞ', 'ﾑｰﾝ', 'ﾗﾌﾞﾗﾌﾞ', 'ﾚﾍﾞﾙ'];
		}
		if($ver eq 'adv') {
			$hash->{"ballName"} = ['ﾓﾝｽﾀｰ', 'ｽｰﾊﾟｰ', 'ﾊｲﾊﾟｰ', 'ﾘﾋﾟｰﾄ',
				'ﾈｯﾄ', 'ﾀﾞｲﾌﾞ', 'ﾀｲﾏｰ', 'ﾈｽﾄ', 'ｻﾌｧﾘ'];
		}
		if($ver eq 'gsc') {
			$hash->{"ballName"} = ['ﾓﾝｽﾀｰ', 'ｽｰﾊﾟｰ', 'ﾊｲﾊﾟｰ', 'ﾍﾋﾞｰ',
				'ﾙｱｰ', 'ｽﾋﾟｰﾄﾞ', 'ﾗﾌﾞﾗﾌﾞ', 'ﾚﾍﾞﾙ'];
		}
		if($ver eq 'rgb') {
			$hash->{"ballName"} = ['ﾓﾝｽﾀｰ', 'ｽｰﾊﾟｰ', 'ﾊｲﾊﾟｰ'];
		}
		
		#定数
		$hash->{context} = {
			sepChar => "/",
			unknown => "不明",
			none    => "&mdash;",
			
			#項目名
			gDeg  => '被捕獲度', 
			gIdx  => '捕獲指数', 
			Gc    => '捕獲係数', 
			Gt    => '判定閾値', 
			bCor  => '被捕獲補正',
			remHpEf => '実残りHP率',
			type  => 'ﾀｲﾌﾟ',
			sex   => '♂♀存在比',
			wgt   => 'おもさ',
			
			ver  => 'ﾊﾞｰｼﾞｮﾝ',
			poke => 'ﾎﾟｹﾓﾝ',
			cond => '状態',
			remHp=> '残りHP率',
			ball => 'ﾎﾞｰﾙ',
			turn => '経過ﾀｰﾝ',
			lv => '自分/野生のLv',
			safari => '石/ｴｻの回数',
			
			#♂♀存在比
			sexRatio_normal => "%d : %d",
			sexRatio_sexless => "性別なし",
			sexRatio_maleOnly => "♂のみ",
			sexRatio_femaleOnly => "♀のみ",
			
			#判定閾値
			Gt_dpt => qq{0x%4X<font size="-1">/0x%4X</font>},
			Gt_adv => qq{0x%4X<font size="-1">/0x%4X</font>},
			Gt_rgb => qq{%d<font size="-1">/%d</font>},
			Gt_disabled => "&mdash;",
			
			#ポケモン名
			pname_s => "<b>%s</b>",
			
			#被捕獲補正
			bCor_dpt => "×%.1f",
			bCor_adv => "×%.1f",
			bCor_gsc => "×%.1f%+d",
			bCor_rgb => "÷%d",
			
			#実残りHP率
			remHpEf_s => "%.1f％",
			
			#残りHP率
			remHp_normal => "%s％",
			remHp_graph => qq{<font color="gray">グラフ</font>},
			
			#おもさ
			wgt_s => "%.1fkg",
			
			#食べ物/石ころ
			safari_s => "%s/%s",
			
			#レベル
			lv_s => "%s/%s",
			
			#ターン
			turn_s => "%s",
			
			#ウィンドウサイズ
			winSize_detail => undef,
			winSize_graph => undef,
			
			#計算結果の部
			calcResult => qq{%s<br>\n%s<br>\n%s\n%s\n},
			
			#捕獲率
			getPer_tr => qq{捕獲率: <font size="+4">%s</font>},
			
			#頻度表記確率
			freq_tr => qq{>%s},
			
			freq_normal => qq{約%.1f回<font size="-1">でｹﾞｯﾄの確率</font>},
			freq_just   => qq{%d回<font size="-1">でｹﾞｯﾄの確率</font>},
			freq_95     => qq{ほぼ1回<font size="-1">でｹﾞｯﾄの確率</font>},
			freq_100    => qq{一発<font size="-1">でｹﾞｯﾄ成功!</font>},
			
			#特定累積捕獲率到達回数
			cumPer_tbl => <<EOF,
		<table><tr>
		<td>累積<br>捕獲率</td>
		<td>%s</td>
		<td>で到達</td></tr>
		</table>
EOF
			cumPer_tr => "%d%=%d回<br>\n",
			
			#パラメータ
			param_tr => qq{%s=%s<br>\n},
			
			#ステータス情報
			stats_tr => qq{%s：%s<br>},
			rscChk_tr => qq{<ul style="margin: 0">%s</ul>},
			stats_tbl => sub {
				my($rscList, $rscChk, $hereUrl) = @_;
				return <<EOF;
$rscList
$rscChk
$hereUrl
EOF
			},
			
			#チェック項目
			chk => {
				get => "<li>図鑑に登録済</li>",
				dive => "<li>海底のﾎﾟｹﾓﾝ</li>",
				dive2 => "<li>水上/水中のﾎﾟｹﾓﾝ</li>",
				fishing => "<li>つり上げたﾎﾟｹﾓﾝ</li>",
				same => "<li>自分と同種で同性</li>",
				oppo => "<li>自分と同種で異性</li>",
				dark => "<li>夜/暗闇で出現</li>",
				none => "<li><font color=\"gray\">(ﾁｪｯｸなし)</font></li>"
			},
			
			#計算結果のURL
			hereUrl  => <<EOF,
<hr>計算結果のURL<br><textarea col="50">$ENV{'SCRIPT_URI'}?m=res&amp;%s</textarea>
EOF
			
			#ウィンドウサイズ
			sizeCtl  => undef,
			
			#閉じボタン
			backto_btn => qq{<center><a href="./$PokeGet::NAME">戻る</a></center>},
			
			#フッター(外来さん用)
			backto_link => qq{<center><a href="./$PokeGet::NAME">$PokeGet::TITLEへ</a></center>},
			rights => <<EOF,
<div class="right" id="res"><strong>[$PokeGet::TITLE] ver.$PokeGet::VER</strong><br>
ﾌﾟﾛｸﾞﾗﾑ/管理:<a href="mailto:midis.cube@gmail.com">めたルイ</a>@<a href="http://nin10.web.infoseek.co.jp/" target="_blank">ﾆﾝﾃﾝﾄﾞｰ特攻隊</a>(ｹｰﾀｲ非対応)<br>
ﾃﾞｰﾀ提供:<br>
ねんネン様@<a href="http://www.pic.biz/" target="_blank">ﾎﾟｹｯﾄﾓﾝｽﾀｰ情報ｾﾝﾀｰ</a><br>
SUN様@<a href="http://trainer.geo.jp/">ﾄﾚｰﾅｰ天国</a><br>
<a href="http://wiki.xn--rckteqa2e.com/">ﾎﾟｹﾓﾝWiki</a></div>
EOF
			
			#BODY
			htmlBody => sub {
				my($result, $statusList, $backto, $rights) = @_;
				return <<EOF;
<h2>計算結果</h2>
<hr>
$result
<hr>
$statusList
<hr>
$backto
<hr>
$rights
EOF
			},
			
			#結果ページスタイル
			style_user => 'std',
			style_guest => 'std',
		};
		bless $hash, $this;
	}
	
	#捕獲率
	sub outGetPer {
		my $this = shift;
		my $result = shift;
		my $val = sprintf("%.4f", $result->{params}->getGetPer->[0] * 100);
		$val =~ s/(?<=\.\d{1})(\d+)/<span style="font-size: small;">$1<\/span>%/;
		return $val;
	}
	
	# グラフ用捕獲率リスト
	sub makeGetPerTable {
		my $this = shift;
		my $result = shift;
		my($out, $n);
		
		my @remHps = @{$result->{params}->getRemHp};
		my @pers = @{$result->{params}->getGetPer};
		
		#---１行目---
		$out .= qq{<table class="perList" border="1">\n};
		$out .= qq{<tr>};
		#HP
		$out .= qq{<th>HP%</th>};
		$n = 0;
		while(@remHps > 12) {
			$out .= sprintf qq{<td>%d</td>}, pop(@remHps);
			pop @remHps;
		}
		
		$out .= qq{</tr>\n<tr>};
		
		#捕獲率
		$out .= qq{<th>捕獲%</th>};
		$n = 0;
		while(@pers > 12) {
			$out .= sprintf qq{<td class="per">%.1f</td>}, pop(@pers) * 100;
			pop @pers;
		}
		
		$out .= qq{</tr>\n</table>\n};
		
		#---２行目---
		$out .= qq{<table class="perList" border="1">\n};
		$out .= qq{<tr>};
		#HP
		$n = 0;
		while(@remHps > 0) {
			$out .= sprintf qq{<td>%d</td>}, pop(@remHps);
			pop @remHps;
		}
		
		$out .= qq{</tr>\n<tr>};
		
		#捕獲率
		$n = 0;
		while(@pers > 0) {
			$out .= sprintf qq{<td class="per">%.1f</td>}, pop(@pers) * 100;
			pop @pers;
		}
		
		$out .= qq{</tr>\n</table>\n<br>};
		
		return $out;
	}
	
}

{
	#---
	#計算パラメータ for imode
	#(継承:Result)
	#---
	package ContextI;
	use base (qw/ContextK/); 
	
	sub new {
		my $class = shift;
		my $this = $class->SUPER::new(@_);
		
		#定数
		my %context_add = (
			#判定閾値
			Gt_adv => qq{0x%4X<span style="font-size: small;">/0x%4X</span>},
			Gt_rgb => qq{%d<span style="font-size: small;">/%d</span>},
			Gt_disabled => "&mdash;",
			
			#残りHP率
			remHp_graph => qq{<span style="color:gray">グラフ</span>},
			
			#捕獲率
			getPer_tr => qq{捕獲率: <span style="font-size: large">%s</span>},
			
			#頻度表記確率
			freq_normal => qq{約%.1f回<span style="font-size: small">でｹﾞｯﾄの確率</span>},
			freq_just   => qq{%d回<span style="font-size: small">でｹﾞｯﾄの確率</span>},
			freq_95     => qq{ほぼ1回<span style="font-size: small">でｹﾞｯﾄの確率</span>},
			freq_100    => qq{一発<span style="font-size: small">でｹﾞｯﾄ成功!</span>},
			
			#特定累積捕獲率到達回数
			cumPer_tbl => <<EOF,
		<table><tr>
		<td>累積<br />捕獲率</td>
		<td>%s</td>
		<td>で到達</td></tr>
		</table>
EOF
			cumPer_tr => "%d%=%d回<br />\n",
			
			#チェック項目
			chk_none => qq{<li><span style="color:gray">(ﾁｪｯｸなし)</span></li>},
			
			#フッター(外来さん用)
			backto_link => qq{<div style="text-align:center"><a href="./$PokeGet::NAME">ﾎﾟｹｹﾞｯﾄへ戻る</a></div>},
			rights => <<EOF,
<div class="right" id="res"><strong>[$PokeGet::TITLE] ver.$PokeGet::VER</strong><br />
ﾌﾟﾛｸﾞﾗﾑ/管理：<a href="mailto:midis.cube@gmail.com">めたルイ</a>@<a href="http://nin10.web.infoseek.co.jp/" target="_blank">ﾆﾝﾃﾝﾄﾞｰ特攻隊</a>(ｹｰﾀｲ非対応)<br />
ﾃﾞｰﾀ提供：<br />
ねんネン様@<a href="http://www.pic.biz/" target="_blank">ﾎﾟｹｯﾄﾓﾝｽﾀｰ情報ｾﾝﾀｰ</a><br />
SUN様@<a href="http://trainer.geo.jp/">ﾄﾚｰﾅｰ天国</a><br />
<a href="http://wiki.xn--rckteqa2e.com/">ポケモンWiki</a></div>
EOF
			
			#BODY
			htmlBody => sub {
				my($result, $statusList, $backto, $rights) = @_;
				return <<EOF;
<h2>計算結果</h2>
<hr>
$result
<hr>
$statusList
<hr>
$backto
<hr>
$rights
EOF
			},
		);
		
		#context要素追加
		$this->{context} = {%{$this->{context}}, %context_add};
		return $this;
	}
	
	#捕獲率
	sub outGetPer {
		my $this = shift;
		my $result = shift;
		my $val = sprintf("%.4f", $result->{params}->getGetPer->[0] * 100);
		$val =~ s/(?<=\.\d{1})(\d+)/<span style="font-size: small;">$1<\/span>%/;
		return $val;
	}
	
	# グラフ用捕獲率リスト
	sub makeGetPerTable {
		my $this = shift;
		my $result = shift;
		my($out, $n);
		
		my @remHps = @{$result->{params}->getRemHp};
		my @pers = @{$result->{params}->getGetPer};
		
		#---１行目---
		$out .= qq{<table border="1">\n};
		$out .= qq{<tr style="text-align:center">};
		#HP
		$out .= qq{<th><span style="font-size:small">HP%</span></th>};
		$n = 0;
		while(@remHps > 12) {
			$out .= sprintf qq{<td><span style="font-size:small">%d</span></td>}, pop(@remHps);
			pop @remHps;
		}
		
		$out .= qq{</tr>\n<tr style="background-color:#cfc;text-align:center">};
		
		#捕獲率
		$out .= qq{<th><span style="font-size:small">捕獲%</span></th>};
		$n = 0;
		while(@pers > 12) {
			$out .= sprintf qq{<td><span style="font-size:small">%.1f</style></td>}, pop(@pers) * 100;
			pop @pers;
		}
		
		$out .= qq{</tr>\n</table>\n};
		
		#---２行目---
		$out .= qq{<table border="1">\n};
		$out .= qq{<tr style="text-align:center">};
		#HP
		$n = 0;
		while(@remHps > 0) {
			$out .= sprintf qq{<td><span style="font-size:small">%d</span></td>}, pop(@remHps);
			pop @remHps;
		}
		
		$out .= qq{</tr>\n<tr style="background-color:#cfc;text-align:center">};
		
		#捕獲率
		$n = 0;
		while(@pers > 0) {
			$out .= sprintf qq{<td><span style="font-size:small">%.1f</span></td>}, pop(@pers) * 100;
			pop @pers;
		}
		
		$out .= qq{</tr>\n</table>\n<br />};
		
		return $out;
	}
	
}

1;