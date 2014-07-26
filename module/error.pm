#use utf8;

{
	package CalcError;
	sub new {
		my $this = shift;
		
		my $hash = {
			msgList  => [],
			@_
		};
		
		bless $hash, $this;
	}
	
	sub isError {
		my $this = shift;
		return @{$this->{msgList}} > 0;
	}
	
	sub addMsg {
		my $this = shift;
		my $key = shift;
		my $val = shift;
		
		push @{$this->{msgList}},
			sprintf($this->{errMsg}{$key}, $val);
	}
	sub getMsgList {
		my $this = shift;
		return $this->{msgList};
	}
	
	sub clearMsgList {
		my $this = shift;
		$this->{msgList} = [];
	}
	
}

{
	package CalcErrorPC;
	use base (qw/CalcError/);
	
	sub new {
		my $this = shift;
		my $hash = CalcError->new(
			errMsg => {
				hp => '相手の残りHP率 (0より大きく100以下で)',
				turn => '経過ターン (1以上の整数)',
				food => 'エサだまを投げた回数 (0以上の整数)',
				stone => '石ころを投げた回数 (0以上の整数)',
				lv => '「相手の状態」のレベル (1〜100の整数)',
				mylv => '自分のレベル (1〜100の整数)',
				poke => 'ポケモンの名前または番号(%s)',
				ball => 'ボールの種類'
			},
			backto => qq{<p><a href="$PokeGet::NAME">Go to $PokeGet::TITLE</a></p>},
		);
		bless $hash, $this;
	}
	
	sub outputHtml {
		my $this = shift;
		my $backto = ($PokeGet::OUTSIDE) ? $this->{backto} : "";
		#メッセージリスト生成
		my $msg;
		foreach(@{$this->getMsgList}) {
			$msg .= "<li>$_</li>\n";
		}
		$msg = "<ul>\n$msg</ul>";
		
		#HTML出力
		my $html = HtmlMakerPC->new('std');
		$html->setTitle('エラー');
		$html->setHeader(<<EOF);
<script type="text/javascript"><!--
function setFrameSize() {
	var flm = parent.document.getElementById("resultFrame");
	flm.style.width = document.documentElement.scrollWidth || document.body.offsetWidth;
	flm.style.height = document.documentElement.scrollHeight || document.body.offsetHeight;
}
--></script>
EOF
		$html->setBodyAttr(qq{onLoad="setFrameSize()"});
		$html->setBody(<<EOF);
<h1>エラーですよ。</h1>
<p>以下の項目が入力されていないか、<br>
ちょっとおかしいです。
$msg
</p>
<br>
$backto
EOF
		print $html->make;
		exit;
	}
}

{
	package CalcErrorPC_en;
	use base (qw/CalcError/);
	
	sub new {
		my $this = shift;
		my $hash = CalcError->new(
			errMsg => {
				hp => 'Wild\'s remaining HP% (should be larger than 0, and be 100 or less)',
				turn => 'Elapsed turns (should be 0 or more as an integer)',
				food => 'Thrown baits (should be 0 or more as an integer)',
				stone => 'Thrown rocks/muds (should be 0 or more as an integer)',
				lv => 'Level on the Wild\'s Status (should be between 1 and 100 as an integer)',
				mylv => 'Ally\'s level (should be between 1 and 100 as an integer)',
				poke => 'Name/number of Pok&eacute;mon (%s)',
				ball => 'Type of Pok&eacute;ball'
			},
			backto => qq{<p><a href="$PokeGet::NAME">Go to $PokeGet::TITLE</a></p>},
		);
		bless $hash, $this;
	}
	
	sub outputHtml {
		my $this = shift;
		my $backto = ($PokeGet::OUTSIDE) ? $this->{backto} : "";
		#メッセージリスト生成
		my $msg;
		foreach(@{$this->getMsgList}) {
			$msg .= "<li>$_</li>\n";
		}
		$msg = "<ul>\n$msg</ul>";
		
		#HTML出力
		my $html = HtmlMakerPC_en->new('std');
		$html->setTitle('Error');
		$html->setHeader(<<EOF);
<script type="text/javascript"><!--
function setFrameSize() {
	var flm = parent.document.getElementById("resultFrame");
	flm.style.width = document.documentElement.scrollWidth || document.body.offsetWidth;
	flm.style.height = document.documentElement.scrollHeight || document.body.offsetHeight;
}
--></script>
EOF
		$html->setBodyAttr(qq{onLoad="setFrameSize()"});
		$html->setBody(<<EOF);
<h1>You caught an error.</h1>
<p>Items below are no entered or kinda odd.
$msg
</p>
<br>
$backto
EOF
		print $html->make;
		exit;
	}
}

{
	package CalcErrorK;
	use base (qw/CalcError/);
	
	sub new {
		my $this = shift;
		my $hash = CalcError->new(
			errMsg => {
				hp => '相手の残りHP率 (0より大きく100以下で)',
				turn => '経過ターン (1以上の整数)',
				food => 'エサだまを投げた回数 (0以上の整数)',
				stone => '石ころを投げた回数 (0以上の整数)',
				lv => '相手のレベル (1〜100の整数)',
				mylv => '自分のレベル (1〜100の整数)',
				poke => 'ポケモンの名前または番号(%s)',
			},
			backto => qq{<hr><a href="$PokeGet::NAME">$PokeGet::TITLEへ</a>},
		);
		bless $hash, $this;
	}
	
	sub outputHtml {
		my $this = shift;
		my $backto = ($PokeGet::OUTSIDE) ? $this->{backto} : "";
		#メッセージリスト生成
		my $msg;
		foreach(@{$this->getMsgList}) {
			$msg .= "<li>$_\n";
		}
		$msg = "<ul>$msg</ul>";
		
		#HTML出力
		my $html = HtmlMakerK->new('std');
		$html->setTitle('エラー');
		$html->setBody(<<EOF);
<p>エラーですよ。
<p>以下の項目が入力されていないか、<br>
ちょっとおかしいです。
$msg
$backto
EOF
		print $html->make;
		exit;
	}
}

1;
