#use utf8;
use htmlMaker;

{
	package Form;
	
	sub new {
		my $this = shift;
		my $hash = {
			ver => $PokeGet::IN->{ver},
			in => $PokeGet::IN,
			context => {},
			@_
		};
		bless $hash, $this;
	}
	
	#バージョン切替器
	sub makeVersionSwitch {
		my $this = shift;
		my $verSel = "";
		my($checked, $text);
		foreach(@{$this->{pokeVers}}) {
			if($this->{ver} eq $_->[0]) {
				$checked = $this->{verSel_chkAttr};
				$text = sprintf $this->{verSel_trgt}, $_->[1];
			} else {
				$checked = "";
				$text = sprintf $this->{verSel_dis}, $_->[1];
			}
			$verSel .= &{$this->{verSel_item}}($_->[0], $checked, $text);
		}
		return sprintf $this->{frame}->{verSwitch},
			$this->{frame}->{verSwitch_form}, $verSel;
	}
	
	#ボールの種類 $ballSel, $ballEx
	sub makeBallList {
		my $this = shift;
		return sprintf $this->{frame}->{ballList}, $this->{ballList}->{$this->{ver}};
	}
	#相手の状態 $etcConditon
	sub makeCondition {
		my $this = shift;
		my $html;
		$html = sprintf $this->{frame}->{condition}, $this->{etcCondition}->{$this->{ver}};
		return $html;
	}
	
}

{
	package FormPC;
	use base qw/Form/;
	
	sub new {
		my $class = shift;
		my $this = $class->SUPER::new(
			#バージョンセレクト
			verSel_chkAttr => " checked",
			verSel_trgt => "<b>%s</b>",
			verSel_dis => qq{<font color=\"gray\">%s</font>},
			verSel_item => sub {
				my($ver, $checked, $name) = @_;
				return qq{\t<label><input type="radio" name="ver" value="$ver"$checked>$name</label><br>\n}
			},
			
			ballList => {
				dpt => <<EOF,
		<table class="balls twoCols">
		<tr><td colspan="2"><label><input type="radio" name="ball" value="0" checked style="vertical-align: middle">モンスターボール { <span class="etcBalls">ヒールボール・ゴージャスボール<br>プレミアボール・フレンドボール</span></label><br>
		<tr><td><label><input type="radio" name="ball" value="1">スーパーボール</label></td>
			<td><label><input type="radio" name="ball" value="2">ハイパーボール</label></td></tr>
		<tr><td><label><input type="radio" name="ball" value="3">リピートボール</label></td>
			<td><label><input type="radio" name="ball" value="4">ネットボール</label></td></tr>
		<tr><td><label><input type="radio" name="ball" value="5">ダイブボール</label></td>
			<td><label><input type="radio" name="ball" value="6">ダークボール</label></td></tr>
		</table>
		<table class="balls">
		<tr><td><label><input type="radio" name="ball" value="7">クイックボール</label></td>
		<td rowspan="2">&nbsp;&nbsp;} …&nbsp;</td>
		<td rowspan="2">経過ターン：<input type="text" name="turn" value="$t" size="2" maxlength="2" class="num">
			<div style="text-align: right" class="note">(最初のターンは0)</div>
		</td></tr>
		<tr><td><label><input type="radio" name="ball" value="8">タイマーボール</label></td></tr>
		<tr><td colspan="2"><label><input type="radio" name="ball" value="9">ネストボール</label></td></tr>
		</table>
	</td></tr>
	<tr><td class="topLine">
		<span class="note">ハートゴールド・ソウルシルバーのみ</span>
		<table class="balls twoCols">
		<tr><td><label><input type="radio" name="ball" value="11">ヘビーボール</label></td>
			<td><label><input type="radio" name="ball" value="12">ルアーボール</label></td></tr>
		<tr><td><label><input type="radio" name="ball" value="13" disabled><font color=\"gray\">スピードボール</font></label></td>
			<td><label><input type="radio" name="ball" value="14">ムーンボール</label></td></tr>
		<tr><td><label><input type="radio" name="ball" value="15">ラブラブボール</label></td></tr>
		<tr><td colspan="2"><label><input type="radio" name="ball" value="16" id="b16">レベルボール</label> … 自分のLv: <input type="text" name="mylv" value="$lv" size="2" maxlength="3" class="num" onclick="mainform.b16.checked = true"></td></tr>
		</table>
	</td></tr>
	<tr><td class="topLine">
		<label><input type="radio" name="ball" value="10" id="b10">サファリボール</label> … どろ：<input type="text" name="stone" size="2" value="$stone" maxlength="2" class="num" onclick="mainform.b10.checked = true">回 ／ エサ：<input type="text" name="food" size="2" value="$food" maxlength="2" class="num" onclick="mainform.b10.checked = true">回<br>
		<div style="text-align: right"><span class="note">※「相手の状態」に入力する必要はありません。</span></div>
EOF
				adv => <<EOF,
		<label><input type="radio" name="ball" value="0" checked>モンスターボール<font size="-1">・ゴージャスボール・プレミアボール</font></label><br>
		<label><input type="radio" name="ball" value="1">スーパーボール<font size="-1">・サファリボール (ルビー・サファイア)</font></label><br>
		<label><input type="radio" name="ball" value="2">ハイパーボール</label><br>
		<label><input type="radio" name="ball" value="3">リピートボール</label><br>
		<label><input type="radio" name="ball" value="4">ネットボール</label><br>
		<label><input type="radio" name="ball" value="5">ダイブボール</label><br>
		<label><input type="radio" name="ball" value="6" id="b6">タイマーボール</label> 
			… 経過ターン：<input type="text" name="turn" value="$t" size="2" maxlength="2" class="num" onclick="mainform.b6.checked = true"><span class="note">(最初は0)</span><br>
		<label><input type="radio" name="ball" value="7">ネストボール</label>
	</td></tr>
	<tr><td class="topLine">
		<label><input type="radio" name="ball" value="8" id="b8">サファリボール<font size="-1"> (ファイアレッド・リーフグリーン)</font></label><br>
		<div style="text-align: right">… いしころ：<input type="text" name="stone" size="3" value="$stone" maxlength="2" class="num" onclick="mainform.b8.checked = true">回 ／ エサだま：<input type="text" name="food" size="3" value="$food" maxlength="2" class="num" onclick="mainform.b8.checked = true">回<br>
		<span class="note">※「相手の状態」に入力する必要はありません。</span></div>
EOF
				gsc => <<EOF,
		<label><input type="radio" name="ball" value="0" checked>モンスターボール・ムーンボール<font size="-1">・フレンドボール</font></label><br>
		<label><input type="radio" name="ball" value="1">スーパーボール<font size="-1">・パークボール</font></label><br>
		<label><input type="radio" name="ball" value="2">ハイパーボール</label><br>
		<label><input type="radio" name="ball" value="3">ヘビーボール</label><br>
		<label><input type="radio" name="ball" value="4">ルアーボール</label><br>
		<label><input type="radio" name="ball" value="5">スピードボール</label><br>
		<label><input type="radio" name="ball" value="6">ラブラブボール</label><br>
		<label><input type="radio" name="ball" value="7" id="b7">レベルボール</label> … 自分のLv: <input type="text" name="mylv" value="$mylv" size="2" maxlength="3" class="num" onclick="mainform.b7.checked = true">
EOF
				rgb => <<EOF,
		<label><input type="radio" name="ball" value="0" checked>モンスターボール</label><br>
		<label><input type="radio" name="ball" value="1">スーパーボール</label><br>
		<label><input type="radio" name="ball" value="2">ハイパーボール</label>
EOF
			},
			
			etcCondition => {
				dpt => <<'EOF',
		<table class="condition">
			<tr><td class="item2">レベル</td>
			<td class="val"><input type="text" name="lv" value="" size="3" maxlength="3" class="num"><span class="note"> (ネストボール・レベルボール)</span></td></tr>
		</table>
		<table class="condition">
			<tr><td class="item2">その他</td>
				<td class="val etc"><label><input type="checkbox" name="get" value="1">図鑑に登録されている<span class="note"> (リピートボール)</span></label></td></tr>
			<tr><td>&nbsp;</td><td class="val etc"><label><input type="checkbox" name="dive2" value="1">水上で出現<span class="note"> (ダイブボール)</span></label></td></tr>
			<tr><td>&nbsp;</td><td class="val etc"><label><input type="checkbox" name="dark" value="1">夜か暗闇で出現<span class="note"> (ダークボール)</span></label></td></tr>
			<tr><td>&nbsp;</td><td class="val etc"><label><input type="checkbox" name="fishing" value="1">つり上げたポケモン<span class="note">(ルアーボール・ダイブボール)</span></label></td></tr>
			<tr><td>&nbsp;</td><td class="val etc"><label><input type="checkbox" name="oppo" value="1">自分と同じ種類で異性<br>
				&nbsp;&nbsp;&nbsp;&nbsp;または「へんしん」して異性<span class="note"> (ラブラブボール)</span></label></td></tr>
		</table>
EOF
				adv => <<'EOF',
		<table class="condition">
			<tr><td class="item2">レベル</td>
			<td class="val"><input type="text" name="lv" value="" size="3" maxlength="3" class="num"><span class="note"> (ネストボール)</span></td></tr>
		</table>
		<table class="condition">
			<tr><td class="item2">その他</td>
				<td class="val etc"><label><input type="checkbox" name="get" value="1">図鑑に登録されている<span class="note"> (リピートボール)</span></label></td></tr>
			<tr><td>&nbsp;</td><td class="val etc"><label><input type="checkbox" name="dive" value="1">海底のポケモン<span class="note"> (ダイブボール)</span></label></td></tr>
		</table>
EOF
				gsc => <<'EOF',
		<table class="condition">
			<tr><td class="item2">レベル</td>
			<td class="val"><input type="text" name="lv" value="" size="3" maxlength="3" class="num"><span class="note"> (レベルボール)</span></td></tr>
		</table>
		<table class="condition">
			<tr><td class="item2">その他</td>
				<td class="val etc"><label><input type="checkbox" name="fishing" value="1">つり上げたポケモン<span class="note"> (ルアーボール)</span></label></td></tr>
			<tr><td>&nbsp;</td><td class="val etc"><label><input type="checkbox" name="same" value="1">自分と同じ種類で同じ性別<span class="note"> (ラブラブボール)</span></label></td></tr>
		</table>
EOF
			},

			frame => {
				verSwitch_form => qq{	<form action="$PokeGet::NAME" method="GET">},
				verSwitch => <<'EOF',
<tr><th class="ver" colspan="2">バージョン</th></tr>
<tr><td class="val versel" colspan="2">
%s
%s
	<input type="submit" value="切り替え" class="ch"><span class="note"> ◇まず、ここでモードを選ぼう。</span>
	</form>
	</td>
</tr>
EOF
				poke => <<'EOF',
<tr>
	<td class="val">
	<table class="sep">
		<tr><th>ポケモン</th></tr>
		<tr><td>
			<table style="border-collapse: collapse; border: 0"><tr>
			<td><input type="text" name="pname" value="" size="10" autocomplete="off" id="typInput"><div id="typHelper"></div></td>
			<td class="note" id="typokeDesc">◇名前か全国ナンバーで</td>
			</tr>
			</table>
			<script type="text/javascript"><!--
			var desc = document.getElementById("typokeDesc");
			if(navigator.userAgent.indexOf("Nintendo Wii") != -1) {
				desc.innerHTML = "◇名前か全国ナンバーで<br>←頭文字入力後&#9312;ボタンを押してリスト表示";
			}
			--></script>
		</td>
	</tr></table>
	</td>
</tr>
EOF
				ballList => <<'EOF',
<tr><td class="val">
	<table class="sep">
	<tr><th>ボールの種類</th></tr>
	<tr><td>
%s
	</td></tr></table>
</td></tr>
EOF
				condition => <<'EOF',
<tr>
	<td>
	<table class="sep">
		<tr><th>相手の状態</th></tr>
		<tr><td>
			<table class="condition">
				<tr><td class="item2" valign="top">残りＨＰ率</td>
					<td class="val"><label><input type="radio" name="g" value="1" checked>グラフ<span class="note"> (５％間隔でかんたん計算)</span></label></td></tr>
				<tr><td>&nbsp;</td><td><input type="radio" name="g" value="0" id="chk_graph"><input type="text" name="hp" value="100" size="4" class="num" onclick="mainform.chk_graph.checked = true">％<span class="note"> (ピンポイントにくわしく計算)</span></td></tr>
			</table>
			<table class="condition">
				<tr><td class="item2">状態異常</td>
					<td class="val"><label><input type="radio" name="c" value="0" checked>なし</label></td></tr>
				<tr><td>&nbsp;</td><td><label><input type="radio" name="c" value="1">どく・まひ・やけど</label></td></tr>
				<tr><td>&nbsp;</td><td><label><input type="radio" name="c" value="2">ねむり・こおり</label></td></tr>
			</table>
			%s
		</td></tr>
	</table>
</td></tr>
EOF
				submit => <<'EOF',
<tr><td colspan="2" class="bottom">
	<table class="st" border="0" align="center"><tr>
		<td><font size="-1"><a href="help.html">［ご説明］</a></font></td>
		<td><input type="submit" value="計算！" class="calc"></td>
	</tr></table>
	</td></tr>
EOF
				rights => <<'EOF',
<table border="0" class="footer">
<tr><td class="right">
プログラム・管理：<a href="mailto:midis.cube@gmail.com">つてと(MetaLui)</a><br>
データ提供：<br>
&nbsp;&nbsp;ねんネン様@<a href="http://www.pic.bz/">ポケットモンスター情報センター</a><br>
&nbsp;&nbsp;SUN様@<a href="http://trainer.geo.jp/">トレーナー天国</a><br>
&nbsp;&nbsp;<a href="http://wiki.xn--rckteqa2e.com/">ポケモンWiki</a><br>
<font size="-2">このコンテンツはリンクフリーです。</font>
</td>
</tr>
</table>
EOF
			},
			
			#バージョン名
			pokeVers => [
				['dpt', 'ダイヤモンド・パール・プラチナ・ハートゴールド・ソウルシルバー'],
				['adv', 'ルビー・サファイア・エメラルド・ファイアレッド・リーフグリーン'],
				['gsc', '金・銀・クリスタル'],
				['rgb', '赤・緑・青・ピカチュウ']
			],
		);
		return $this;
	}
	
	sub output {
		my $this = shift;
		
		$verSwitch = $this->makeVersionSwitch;
		$poke = $this->{frame}->{poke};
		$ballList = $this->makeBallList;
		$condition = $this->makeCondition;
		$submit = $this->{frame}->{submit};
		$rights = $this->{frame}->{rights};
		
		#フォーム出力
		$html = HtmlMakerPC->new(
			isManualTitle => 1,
			title => $PokeGet::TITLE.' - ポケモン捕獲率計算機');
		$html->setHeader(<<'EOF');
<meta name="description" content="パッと捕獲率（ゲット率）を計算して、たくさんポケモンゲットだぜ！グラフ機能付きで、赤緑〜ダイパに対応。BWポケモンも追加。">
<meta name="keywords" content="捕捉率,ブラック・ホワイト,ファイアーレッド,ファイアレッド">
<script type="text/javascript" src="tyPokeHelper.js"></script>
EOF
		$html->setBodyAttr(qq{onload="new TyPokeHelper()"});
		$html->setBody(<<EOF);
<table border="0" cellspacing="0" cellpadding="0" class="headFrame">
<tr><td>
<table border="0" cellspacing="0" cellpadding="0" class="head_left">
	<tr>
	<td class="title"><font size="+2"><b>$PokeGet::TITLE</b></font><span style="font-size: 0.8em">　ver. $PokeGet::VER（BWポケモン追加）</span></td>
	<td class="qr"><img src="keitai_qr_s.png"></td>
	<td class="keitaiMsg">ケータイに対応！<br>おでかけ先でもポケモンゲット。</td>
	<td class="lang"><a href="$PokeGet::NAME?lang=en">Switch to English</a></td>
	</tr>
</table>
</td>
</tr>
</table>
<table align="left" border="0" class="frame">
$verSwitch
<form action="$PokeGet::NAME" method="POST" name="mainform" target="resultFrame">
<tr>
<td colspan="2">
	<hr size="1">
	<input type="hidden" name="m" value="res">
	<input type="hidden" name="ver" value="$this->{ver}"></td>
</tr>
<tr><td class="formFrame">
<table class="inputs">
$poke
$ballList
$condition
$submit
</table>
</td>
<td class="result" id="resultTd">
<iframe name="resultFrame" id="resultFrame" src="result_initial.html" frameborder="0"></iframe>
</td>
</tr>
</table>
</form>
$rights
</body>
</html>
EOF
		print $html->make;
		exit;
	}
}

{
	package FormPC_en;
	use base qw/Form/;
	
	sub new {
		my $class = shift;
		my $this = $class->SUPER::new(
			#バージョンセレクト
			verSel_chkAttr => " checked",
			verSel_trgt => "<b>%s</b>",
			verSel_dis => qq{<font color=\"gray\">%s</font>},
			verSel_item => sub {
				my($ver, $checked, $name) = @_;
				return qq{\t<label><input type="radio" name="ver" value="$ver"$checked>$name</label><br>\n}
			},
			
			ballList => {
				dpt => <<EOF,
		<table class="balls twoCols">
		<tr><td colspan="2"><label><input type="radio" name="ball" value="0" checked style="vertical-align: middle">Pok&eacute; Ball { <span class="etcBalls">Heal Ball, Luxury Ball<br>Premier Ball, Friend Ball</span></label><br>
		<tr><td><label><input type="radio" name="ball" value="1">Great Ball</label></td>
			<td><label><input type="radio" name="ball" value="2">Ultra Ball</label></td></tr>
		<tr><td><label><input type="radio" name="ball" value="3">Repeat Ball</label></td>
			<td><label><input type="radio" name="ball" value="4">Net Ball</label></td></tr>
		<tr><td><label><input type="radio" name="ball" value="5">Dive Ball</label></td>
			<td><label><input type="radio" name="ball" value="6">Dusk Ball</label></td></tr>
		</table>
		<table class="balls">
		<tr><td><label><input type="radio" name="ball" value="7">Quick Ball</label></td>
		<td rowspan="2">&nbsp;&nbsp;} &mdash;&nbsp;</td>
		<td rowspan="2">Elapsed turns: <input type="text" name="turn" value="$t" size="2" maxlength="2" class="num"><br>
			<div style="text-align: right" class="note">(The first turn is 0)</div>
		</td></tr>
		<tr><td><label><input type="radio" name="ball" value="8">Timer Ball</label></td></tr>
		<tr><td colspan="3"><label><input type="radio" name="ball" value="9">Nest Ball</label></td></tr>
		</table>
	</td></tr>
	<tr><td class="topLine">
		<span class="note">Only for Heart Gold/Soul Silver</span>
		<table class="balls twoCols">
		<tr><td><label><input type="radio" name="ball" value="11">Heavy Ball</label></td>
			<td><label><input type="radio" name="ball" value="12">Lure Ball</label></td></tr>
		<tr><td><label><input type="radio" name="ball" value="13" disabled><font color=\"gray\">Fast Ball</font></label></td>
			<td><label><input type="radio" name="ball" value="14">Moon Ball</label></td></tr>
		<tr><td><label><input type="radio" name="ball" value="15">Love Ball</label></td></tr>
		<tr><td colspan="2"><label><input type="radio" name="ball" value="16" id="b16">Level Ball</label> &mdash; Ally\'s level: <input type="text" name="mylv" value="$lv" size="2" maxlength="3" class="num" onclick="mainform.b16.checked = true"></td></tr>
		</table>
	</td></tr>
	<tr><td class="topLine">
		<label><input type="radio" name="ball" value="10" id="b10">Safari Ball</label> &mdash; Muds: <input type="text" name="stone" size="2" value="$stone" maxlength="2" class="num" onclick="mainform.b10.checked = true"> / Baits: <input type="text" name="food" size="2" value="$food" maxlength="2" class="num" onclick="mainform.b10.checked = true"><br>
		<div style="text-align: right"><span class="note">* No need to input into the Wild's Status</span></div>
EOF
				adv => <<EOF,
		<label><input type="radio" name="ball" value="0" checked>Pok&eacute; Ball<font size="-1">, Luxury Ball, Premier Ball</font></label><br>
		<label><input type="radio" name="ball" value="1">Great Ball</label><br>
		<label><input type="radio" name="ball" value="2">Ultra Ball</label><br>
		<label><input type="radio" name="ball" value="3">Repeat Ball</label><br>
		<label><input type="radio" name="ball" value="4">Net Ball</label><br>
		<label><input type="radio" name="ball" value="5">Dive Ball</label><br>
		<label><input type="radio" name="ball" value="6" id="b6">Timer Ball</label>
			&mdash; Elapsed turns: <input type="text" name="turn" value="$t" size="2" maxlength="2" class="num" onclick="mainform.b6.checked = true">
			<span class="note">(The first turn is 0)</span>
		<label><input type="radio" name="ball" value="7">Nest Ball</label>
	</td></tr>
	<tr><td class="topLine">
		<label><input type="radio" name="ball" value="8" id="b8">Safari Ball<font size="-1"> (Fire Red/Leaf Green)</font></label><br>
		<div style="text-align: right">&mdash; Rocks: <input type="text" name="stone" size="3" value="$stone" maxlength="2" class="num" onclick="mainform.b8.checked = true"> / Baits: <input type="text" name="food" size="3" value="$food" maxlength="2" class="num" onclick="mainform.b8.checked = true"><br>
		<span class="note">* No need to input into "Wild's Status"</span></div>
EOF
				gsc => <<EOF,
		<label><input type="radio" name="ball" value="0" checked>Pok&eacute; Ball, Moon Ball<font size="-1">, Friend Ball</font></label><br>
		<label><input type="radio" name="ball" value="1">Great Ball<font size="-1">, Park Ball</font></label><br>
		<label><input type="radio" name="ball" value="2">Ultra Ball</label><br>
		<label><input type="radio" name="ball" value="3">Heavy Ball</label><br>
		<label><input type="radio" name="ball" value="4">Lure Ball</label><br>
		<label><input type="radio" name="ball" value="5">Fast Ball</label><br>
		<label><input type="radio" name="ball" value="6">Love Ball</label><br>
		<label><input type="radio" name="ball" value="7" id="b7">Level Ball</label> &mdash; Ally's lvl.: <input type="text" name="mylv" value="$mylv" size="2" maxlength="3" class="num" onclick="mainform.b7.checked = true">
EOF
				rgb => <<EOF,
		<label><input type="radio" name="ball" value="0" checked>Pok&eacute; Ball</label><br>
		<label><input type="radio" name="ball" value="1">Great Ball</label><br>
		<label><input type="radio" name="ball" value="2">Ultra Ball</label>
EOF
			},
			
			etcCondition => {
				dpt => <<'EOF',
		<table class="condition">
			<tr><td class="item2">Level</td>
			<td class="val"><input type="text" name="lv" value="" size="3" maxlength="3" class="num"><span class="note"> (Nest Ball/Level Ball)</span></td></tr>
		</table>
		<table class="condition">
			<tr><td class="item2">Misc.</td>
				<td class="val etc"><label><input type="checkbox" name="get" value="1">Caught before<span class="note"> (Repeat Ball)</span></label></td></tr>
			<tr><td>&nbsp;</td><td class="val etc"><label><input type="checkbox" name="dive2" value="1">On the water<span class="note"> (Dive Ball)</span></label></td></tr>
			<tr><td>&nbsp;</td><td class="val etc"><label><input type="checkbox" name="dark" value="1">In the night or darkness<span class="note"> (Dusk Ball)</span></label></td></tr>
			<tr><td>&nbsp;</td><td class="val etc"><label><input type="checkbox" name="fishing" value="1">Hooked by a rod<span class="note"> (Lure Ball/Dive Ball)</span></label></td></tr>
			<tr><td>&nbsp;</td><td class="val etc"><label><input type="checkbox" name="oppo" value="1">Being the other gender and the same species or the other gender with 'Transform'<span class="note"> (Love Ball)</span></label></td></tr>
		</table>
EOF
				adv => <<'EOF',
		<table class="condition">
			<tr><td class="item2">Level</td>
			<td class="val"><input type="text" name="lv" value="" size="3" maxlength="3" class="num"><span class="note"> (Nest Ball)</span></td></tr>
		</table>
		<table class="condition">
			<tr><td class="item2">Misc.</td>
				<td class="val etc"><label><input type="checkbox" name="get" value="1">Caught before<span class="note"> (Repeat Ball)</span></label></td></tr>
			<tr><td>&nbsp;</td><td class="val etc"><label><input type="checkbox" name="dive" value="1">Underwater<span class="note"> (Dive Ball)</span></label></td></tr>
		</table>
EOF
				gsc => <<'EOF',
		<table class="condition">
			<tr><td class="item2">Level</td>
			<td class="val"><input type="text" name="lv" value="" size="3" maxlength="3" class="num"><span class="note"> (Level Ball)</span></td></tr>
		</table>
		<table class="condition">
			<tr><td class="item2">Misc.</td>
				<td class="val etc"><label><input type="checkbox" name="fishing" value="1">Hooked by a rod<span class="note"> (Lure Ball)</span></label></td></tr>
			<tr><td>&nbsp;</td><td class="val etc"><label><input type="checkbox" name="same" value="1">the same gender and spacies<span class="note"> (Love Ball)</span></label></td></tr>
		</table>
EOF
			},

			frame => {
				verSwitch_form => qq{	<form action="$PokeGet::NAME" method="GET">},
				verSwitch => <<'EOF',
<tr><th class="ver" colspan="2">Version</th></tr>
<tr><td class="val versel" colspan="2">
%s
	<input type="hidden" name="lang" value="en">
%s
	<input type="submit" value="Switch" class="ch"><span class="note"> *First, let's choose a version.</span>
	</form>
	</td>
</tr>
EOF
				poke => <<'EOF',
<tr>
	<td class="val">
	<table class="sep">
		<tr><th>Pok&eacute;mon</th></tr>
		<tr><td>
			<table style="border-collapse: collapse; border: 0"><tr>
			<td><input type="text" name="pname" value="" size="10" autocomplete="off" id="typInput"><div id="typHelper"></div></td>
			<td class="note" id="typokeDesc">*Name or national number</td>
			</tr>
			</table>
			<script type="text/javascript"><!--
			var desc = document.getElementById("typokeDesc");
			if(navigator.userAgent.indexOf("Nintendo Wii") != -1) {
				desc.innerHTML = "*Name or National Number<br>After putting the initial, push &#9312; to display list";
			}
			--></script>
		</td>
	</tr></table>
	</td>
</tr>
EOF
				ballList => <<'EOF',
<tr><td class="val">
	<table class="sep">
	<tr><th>Type of Pok&eacute; Ball</th></tr>
	<tr><td>
%s
	</td></tr></table>
</td></tr>
EOF
				condition => <<EOF,
<tr>
	<td>
	<table class="sep">
		<tr><th>Wild\'s Status</th></tr>
		<tr><td>
			<table class="condition">
				<tr><td class="item2" rowspan="2" style="vertical-align: top">Remaining HP %</td>
					<td class="val"><label><input type="radio" name="g" value="1" checked>Graph<span class="note"> (Easily calculating per 5%)</span></label></td></tr>
				<tr><td><input type="radio" name="g" value="0" id="chk_graph"><input type="text" name="hp" value="100" size="4" class="num" onclick="mainform.chk_graph.checked = true">％<span class="note"> (Detailedly calculating)</span></td></tr>
			</table>
			<table class="condition">
				<tr><td class="item2">Ailment</td>
					<td class="val"><label><input type="radio" name="c" value="0" checked>None</label></td></tr>
				<tr><td>&nbsp;</td><td><label><input type="radio" name="c" value="1">Poison/Paralysis/Burn</label></td></tr>
				<tr><td>&nbsp;</td><td><label><input type="radio" name="c" value="2">Sleep/Freeze</label></td></tr>
			</table>
			%s
		</td></tr>
	</table>
</td></tr>
EOF
				submit => <<'EOF',
<tr><td colspan="2" class="bottom">
	<table class="st" border="0" align="center"><tr>
		<td><font size="-1"><a href="help_en.html">Description</a></font></td>
		<td><input type="submit" value="Calculate" class="calc"></td>
	</tr></table>
	</td></tr>
EOF
				rights => <<'EOF',
<table border="0" class="footer">
<tr><td class="right">
Programed and managed by <a href="mailto:midis.cube@gmail.com">つてと(MetaLui)</a><br>
Data provided by<br>
&nbsp;&nbsp;ねんネン様 (nen-nen)@<a href="http://www.pic.bz/">ポケットモンスター情報センター</a>(Pokemon Information Center), <br>
&nbsp;&nbsp;SUN様@<a href="http://trainer.geo.jp/">トレーナー天国</a>(Trainers Heaven), <br>
&nbsp;&nbsp;<a href="http://wiki.xn--rckteqa2e.com/">ポケモンWiki</a>(Pokemon Wiki), <a href="http://bulbapedia.bulbagarden.net/wiki/">Burubapedia</a>
</td>
</tr>
</table>
EOF
			},
			
			#バージョン名
			pokeVers => [
				['dpt', 'Diamond, Pearl, Platinum, HeartGold, SoulSilver'],
				['adv', 'Ruby, Sapphire, Emerald, FireRed, LeafGreen'],
				['gsc', 'Gold, Silver, Crystal'],
				['rgb', 'Red, Green, Yellow']
			],
		);
		return $this;
	}
	
	sub output {
		my $this = shift;
		
		$verSwitch = $this->makeVersionSwitch;
		$poke = $this->{frame}->{poke};
		$ballList = $this->makeBallList;
		$condition = $this->makeCondition;
		$submit = $this->{frame}->{submit};
		$rights = $this->{frame}->{rights};
		
		#フォーム出力
		$html = HtmlMakerPC_en->new(
			isManualTitle => 1,
			title => "$PokeGet::TITLE_EN - A Pok&eacute;mon catch rate calculator");
		$html->setHeader(<<'EOF');
<meta name="description" content="Calculate in a flash, catch 'em a lot! Graph drawing and versions from Red/Green to DPT/HGSS are available.">

<script type="text/javascript" src="tyPokeHelper_en.js"></script>
EOF
		$html->setBodyAttr(qq{onload="new TyPokeHelper()"});
		$html->setBody(<<EOF);
<table border="0" cellspacing="0" cellpadding="0" class="headFrame">
<tr><td>
<table border="0" cellspacing="0" cellpadding="0" class="head_left">
	<tr>
	<td class="title" valign="bottom"><font size="+2"><b>$PokeGet::TITLE_EN</b></font><span style="font-size: 0.8em">　ver. $PokeGet::VER</span></td>
	</tr>
</table>
</td>
<td style="text-align: right">
<table border="0" cellspacing="0" cellpadding="0" class="head_right">
	<tr>
	<td align="right" valign="bottom">
	<font size="-1"><a href="$PokeGet::NAME">日本語に切り替え</a></font>
	</td></tr>
</table>
</td>
</tr>
</table>
<table align="left" border="0" class="frame">
$verSwitch
<form action="$PokeGet::NAME" method="POST" name="mainform" target="resultFrame">
<tr>
<td colspan="2">
	<hr size="1">
	<input type="hidden" name="m" value="res">
	<input type="hidden" name="lang" value="en">
	<input type="hidden" name="ver" value="$this->{ver}"></td>
</tr>
<tr><td class="formFrame">
<table class="inputs">
$poke
$ballList
$condition
$submit
</table>
</td>
<td class="result" id="resultTd">
<iframe name="resultFrame" id="resultFrame" src="result_initial-en.html" frameborder="0"></iframe>
</td>
</tr>
</table>
</form>
$rights
</body>
</html>
EOF
		print $html->make;
		exit;
	}
}

{
	package FormK;
	use base qw/Form/;
	
	sub new {
		my $class = shift;
		my $this = $class->SUPER::new(
			#バージョンセレクト
			verSel_chkAttr => qq{ checked="checked"},
			verSel_trgt => "<font color=\"blue\">◆</font>%s",
			verSel_dis => qq{%s},
			verSel_item => sub {
				my($ver, $checked, $name) = @_;
				return qq{&nbsp;<input type="radio" name="ver" value="$ver"$checked />$name<br />\n}
			},
			
			ballList => {
				dpt => <<'EOF',
<table>
<tr>
<td><input type="radio" name="ball" value="0" checked="checked" />ﾓﾝｽﾀｰ</td>
<td><input type="radio" name="ball" value="1" />ｽｰﾊﾟｰ</td>
<td><input type="radio" name="ball" value="2" />ﾊｲﾊﾟｰ</td>
</tr>
<tr>
<td><input type="radio" name="ball" value="3" />ﾘﾋﾟｰﾄ</td>
<td><input type="radio" name="ball" value="4" />ﾈｯﾄ</td>
<td><input type="radio" name="ball" value="5" />ﾀﾞｲﾌﾞ</td>
</tr>
<tr>
<td><input type="radio" name="ball" value="6" />ﾀﾞｰｸ</td><td><input type="radio" name="ball" value="9" />ﾈｽﾄ</td><td></td>
</tr>
</table>
<table><tr>
<td><input type="radio" name="ball" value="7" />ｸｲｯｸ<br /><input type="radio" name="ball" value="8" />ﾀｲﾏｰ</td>
<td rowspan="2">}…ﾀｰﾝ:<input type="text" name="turn" value="" size="2" maxlength="2" istyle="4" mode="numeric" /></td>
</tr></table>
<!--<span class="note">HGSSのみ</span><br />-->
<input type="radio" name="ball" value="11">ﾍﾋﾞｰ
<input type="radio" name="ball" value="12">ﾙｱｰ
<input type="radio" name="ball" value="13" disabled>ｽﾋﾟｰﾄﾞ<br />
<input type="radio" name="ball" value="14">ﾑｰﾝ <input type="radio" name="ball" value="15">ﾗﾌﾞﾗﾌﾞ<br />
<input type="radio" name="ball" value="16">ﾚﾍﾞﾙ …自分Lv:<input type="text" name="mylv" value="" size="3" maxlength="3" istyle="4" mode="numeric" /><br />
<input type="radio" name="ball" value="10" />ｻﾌｧﾘ …石:<input type="text" name="stone" size="2" value="" maxlength="2" istyle="4" mode="numeric" />/ｴｻ:<input type="text" name="food" size="2" value="" maxlength="2" istyle="3" mode="numeric" /><br />
<span class="note">&nbsp;*｢相手の状態｣は無視します</span><br />
EOF
				adv => <<'EOF',
<table>
<tr>
<td><input type="radio" name="ball" value="0" checked="checked" />ﾓﾝｽﾀｰ</td>
<td><input type="radio" name="ball" value="1" />ｽｰﾊﾟｰ<br />&nbsp;&nbsp;/ｻﾌｧﾘ(RS)</td>
</tr>
<tr>
<td><input type="radio" name="ball" value="2" />ﾊｲﾊﾟｰ</td>
<td><input type="radio" name="ball" value="3" />ﾘﾋﾟｰﾄ</td>
</tr>
<tr>
<td><input type="radio" name="ball" value="4" />ﾈｯﾄ</td>
<td><input type="radio" name="ball" value="5" />ﾀﾞｲﾌﾞ</td>
</tr>
<tr>
<td colspan="2"><input type="radio" name="ball" value="6" />ﾀｲﾏｰ …ﾀｰﾝ:<input type="text" name="turn" value="" size="2" maxlength="2" istyle="4" mode="numeric" /></td>
</tr>
<tr>
<td colspan="2"><input type="radio" name="ball" value="7" />ﾈｽﾄ …相手Lv:<input type="text" name="lv" value="" size="3" maxlength="3" istyle="4" mode="numeric" /></td>
</tr>
<tr>
<td colspan="2"><input type="radio" name="ball" value="8" />ｻﾌｧﾘ(FR/LG)<br />
&nbsp;&nbsp;…石:<input type="text" name="stone" size="3" value="" maxlength="2" istyle="4" mode="numeric" />/ｴｻ:<input type="text" name="food" size="3" value="" maxlength="2" istyle="4" mode="numeric" /><br />
<span class="note">*｢相手の状態｣は無視します</span></td>
</tr>
</table>
EOF
				gsc => <<'EOF',
<table width="100%">
<tr>
<td><input type="radio" name="ball" value="0" checked="checked" />ﾓﾝｽﾀｰ<br />&nbsp;&nbsp;/ﾑｰﾝ</td>
<td><input type="radio" name="ball" value="1" />ｽｰﾊﾟｰ<br />&nbsp;&nbsp;/ﾊﾟｰｸ</td>
</tr>
<tr>
<td><input type="radio" name="ball" value="2" />ﾊｲﾊﾟｰ</td>
<td><input type="radio" name="ball" value="3" />ﾍﾋﾞｰ</td>
</tr>
<tr>
<td><input type="radio" name="ball" value="6" />ﾗﾌﾞﾗﾌﾞ</td>
<td><input type="radio" name="ball" value="4" />ﾙｱｰ</td>
</tr>
<tr>
<td><input type="radio" name="ball" value="5" />ｽﾋﾟｰﾄﾞ</td>
</tr>
<tr>
<td colspan="3"><input type="radio" name="ball" value="7" />ﾚﾍﾞﾙ<br />
&nbsp;…自分Lv<input type="text" name="mylv" value="" size="2" maxlength="3" istyle="4" mode="numeric" />/相手Lv<input type="text" name="lv" value="" size="2" maxlength="3" istyle="4" mode="numeric" /></td>
</tr>
</table>
EOF
				rgb => <<'EOF',
<table><tr>
	<td><input type="radio" name="ball" value="0" checked="checked" />ﾓﾝｽﾀｰ</td>
	<td><input type="radio" name="ball" value="1" />ｽｰﾊﾟｰ</td>
	<td><input type="radio" name="ball" value="2" />ﾊｲﾊﾟｰ</td>
</tr></table>
EOF
			},
			
			etcCondition => {
				dpt => <<'EOF',
ﾚﾍﾞﾙ:<input type="text" name="lv" value="" size="3" maxlength="3" istyle="4" mode="numeric" /><span class="note">(ﾈｽﾄ/ﾚﾍﾞﾙ)</span><br />
その他:<br />
&nbsp;<input type="checkbox" name="get" value="1" />図鑑に登録済<span class="note">(ﾘﾋﾟｰﾄ)</span><br />
&nbsp;<input type="checkbox" name="dive2" value="1" />水上/水中で出現<span class="note">(ﾀﾞｲﾌﾞ)</span><br />
&nbsp;<input type="checkbox" name="dark" value="1" />夜/暗闇で出現<span class="note">(ﾀﾞｰｸ)</span><br />
&nbsp;<input type="checkbox" name="fishing" value="1" />釣り<span class="note">(ﾙｱｰ)</span><br />
&nbsp;<input type="checkbox" name="oppo" value="1" />自分と同種で異性or"へんしん"で異性<span class="note">(ﾗﾌﾞﾗﾌﾞ)</span><br />
EOF
				adv => <<'EOF',
ﾚﾍﾞﾙ:<input type="text" name="lv" value="" size="3" maxlength="3" istyle="4" mode="numeric" /><span class="note">(ﾈｽﾄ)</span><br />
その他:<br />
&nbsp;<input type="checkbox" name="get" value="1" />図鑑に登録済<span class="note">(ﾘﾋﾟｰﾄ)</span><br />
&nbsp;<input type="checkbox" name="dive" value="1" />海底のﾎﾟｹﾓﾝ<span class="note">(ﾀﾞｲﾌﾞ)</span><br />
EOF
				gsc => <<'EOF',
ﾚﾍﾞﾙ:<input type="text" name="lv" value="" size="3" maxlength="3" istyle="4" mode="numeric" /><span class="note">(ﾚﾍﾞﾙ)</span><br />
その他:<br />
&nbsp;<input type="checkbox" name="fishing" value="1" />釣り<span class="note">(ﾙｱｰ)</span><br />
&nbsp;<input type="checkbox" name="same" value="1" />自分と同種で同性<span class="note">(ﾗﾌﾞﾗﾌﾞ)</span><br />
EOF
			},

			frame => {
				verSwitch_form => qq{<form action="$PokeGet::NAME" method="GET">},
				verSwitch => <<'EOF',
%s
[ﾊﾞｰｼﾞｮﾝ]<br />
%s
<input type="submit" value="切替" class="ch" /><span class="note"> *まずこれを選択</span>
</form>
EOF
				poke => <<'EOF',
ﾎﾟｹﾓﾝ:<input type="text" name="pname" value="" size="10" /><br />
<span class="note">*名前か全国ナンバー</span>
EOF
				ballList => <<'EOF',
[ﾎﾞｰﾙ]<br />
%s
EOF
				condition => <<'EOF',
[相手の状態]<br />
残りHP率:<br />
&nbsp;<input type="radio" name="g" value="1" checked="checked" />ｸﾞﾗﾌ<span class="note">(5%間隔)</span><br />
&nbsp;<input type="radio" name="g" value="0" /><input type="text" name="hp" value="100" size="3" istyle="4" mode="numeric" />%<span class="note">(くわしく)</span><br />
状態異常:<br />
&nbsp;<input type="radio" name="c" value="0" checked="checked" />なし<br />
&nbsp;<input type="radio" name="c" value="1" />毒/ﾏﾋ/ﾔｹﾄﾞ<br />
&nbsp;<input type="radio" name="c" value="2" />眠り/氷<br />
%s
EOF
				submit => <<'EOF',
<input type="submit" value="計算！" /> <font size="-1"><a href="help_k.html">[ご説明]</a></font>
EOF
				rights => <<'EOF',
ﾌﾟﾛｸﾞﾗﾑ/管理:<a href="mailto:midis.cube@gmail.com">つてと(MetaLui)</a><br />
ﾃﾞｰﾀ提供:<br />
ねんネン様@<a href="http://www.pic.bz/">ﾎﾟｹｯﾄﾓﾝｽﾀｰ情報ｾﾝﾀｰ</a><br />
SUN様@<a href="http://trainer.geo.jp/">ﾄﾚｰﾅｰ天国</a><br />
<a href="http://wiki.xn--rckteqa2e.com/">ﾎﾟｹﾓﾝWiki</a><br />
このｺﾝﾃﾝﾂはﾘﾝｸﾌﾘｰです
EOF
			},
			
			#バージョン名
			pokeVers => [
				['dpt', 'ﾀﾞｲﾊﾟ/HGSS'],
				['adv', 'ﾙﾋﾞｻﾌｧ/FRLG'],
				['gsc', '金銀'],
				['rgb', '赤緑']
			],
		);
		return $this;
	}
	
	sub output {
		my $this = shift;
		
		$verSwitch = $this->makeVersionSwitch;
		$poke = $this->{frame}->{poke};
		$ballList = $this->makeBallList;
		$condition = $this->makeCondition;
		$submit = $this->{frame}->{submit};
		$rights = $this->{frame}->{rights};
		
		#フォーム出力
		$html = HtmlMakerK->new(
			isManualTitle => 1,
			title => $PokeGet::TITLE.'@ｹｰﾀｲ');
		$html->setHeader(<<'EOF');
<meta name="description" content="ﾎﾟｹﾓﾝの捕獲率を計算します｡ｹｰﾀｲ対応､ｸﾞﾗﾌ機能付きで赤緑〜ﾀﾞｲﾊﾟHGSSまで" />
EOF
		#$html->setBodyAttr();
		$html->setBody(<<EOF);
$PokeGet::TITLE <font size="-2">ver. $PokeGet::VER</font>
<hr />
$verSwitch
<hr />
<form action="$PokeGet::NAME" method="GET" name="mainform">
<input type="hidden" name="m" value="res" />
<input type="hidden" name="ver" value="$this->{ver}" />
<p>$poke</p>
$ballList
<p>$condition</p>
<p>$submit</p>
<hr />
<p>$rights</p>
</body>
</html>
EOF
		
		print STDOUT $html->make;
		exit;
	}
}

{
	package FormI;
	use base qw/FormK/;
	
	sub new {
		my $class = shift;
		my $this = $class->SUPER::new(@_);
		&FormI::replaceSrc($this);
		
		$this->{verSel_trgt} = qq{<span style="color:blue">◆</span>%s};
		
		return $this;
	}
	
	sub replaceSrc {
		$trgt = shift;
		foreach(keys %{$trgt}) {
			if(ref($trgt->{$_}) eq "HASH") {
				&FormI::replaceSrc($trgt->{$_});
			}
			$trgt->{$_} =~ s/class="note"/style="font-size:small;color:#906060"/g;
		}
	}
	
	sub output {
		my $this = shift;
		
		$verSwitch = $this->makeVersionSwitch;
		$poke = $this->{frame}->{poke};
		$ballList = $this->makeBallList;
		$condition = $this->makeCondition;
		$submit = $this->{frame}->{submit};
		$rights = $this->{frame}->{rights};
		
		#フォーム出力
		$html = HtmlMakerI->new(
			isManualTitle => 1,
			title => $PokeGet::TITLE.'@ｹｰﾀｲ');
		$html->setHeader(<<'EOF');
<meta name="description" content="ﾎﾟｹﾓﾝの捕獲率を計算します｡ｹｰﾀｲ対応､ｸﾞﾗﾌ機能付きで赤緑〜ﾀﾞｲﾊﾟHGSSまで" />
EOF
		#$html->setBodyAttr();
		$html->setBody(<<EOF);
$PokeGet::TITLE <span style="font-size: small">ver.$PokeGet::VER</span>
<hr />
$verSwitch
<hr />
<form action="$PokeGet::NAME" method="GET" name="mainform">
<input type="hidden" name="m" value="res" />
<input type="hidden" name="ver" value="$this->{ver}" />
$poke<br />
$ballList
$condition<br />
$submit
</form>
<hr />
$rights
</body>
</html>
EOF
		
		print STDOUT $html->make;
		exit;
	}
}

1;
