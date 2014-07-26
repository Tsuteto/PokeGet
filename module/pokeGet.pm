#use utf8;
use Jcode;

use result;
use context;
use output;
use form;
use calc;
use error;
use log;
use graph;

{
	package PokeGet;
	
	$VER   = '5.4.1';
	$NAME  = "pokeGet.cgi";
	$TITLE = 'ポケゲット EX-4G';
	$TITLE_EN = 'PokeCatchem EX-4G';
	$IN = {&PokeGet::decode};
	$OUTSIDE = index($ENV{'HTTP_REFERER'}, "http://$ENV{'SERVER_NAME'}") == -1;
	
	sub new {
		my $this = shift;
		my $hash = {};
		
		$PokeGet::IN->{ver} = "dpt" if(!$PokeGet::IN->{ver});
		
		bless $hash, $this;
	}
	
	sub main {
		my $this = shift;
		my $ver = $PokeGet::IN->{ver};
		my $mode = $PokeGet::IN->{m};
		my $isGraph = $PokeGet::IN->{g};
		my $log = Log->new;
		my $isKeitai = Client->new->isKeitai;
		my $lang = $PokeGet::IN->{lang};
		
		$log->refRecord;
		
		#フォーム表示
		if($mode eq '') {
			my($context, $form);
			if($isKeitai == 1) {
				$context = ContextI->new;
				$form = FormI->new;
			} elsif($isKeitai) {
				$context = ContextK->new;
				$form = FormK->new;
			} else {
				if($lang eq 'en') {
					$context = ContextPC_en->new;
					$form = FormPC_en->new;
				} else {
					$context = ContextPC->new;
					$form = FormPC->new;
				}
			}
			$form->output($context);
			exit;
		}
		
		#Result準備
		my $context;
		if($isKeitai) {
			$err = CalcErrorK->new;
			
			if($isKeitai == 1) {
				$context = ContextI->new;
				$htmlMaker = HtmlMakerI;
			} else {
				$context = ContextK->new;
				$htmlMaker = HtmlMakerK;
			}
		} else {
			if($lang eq 'en') {
				$context = ContextPC_en->new;
				$err = CalcErrorPC_en->new;
				$htmlMaker = HtmlMakerPC_en;
			} else {
				$context = ContextPC->new;
				$err = CalcErrorPC->new;
				$htmlMaker = HtmlMakerPC;
			}
		}
		
		my $result;
		my $params = ResultParams->new;
		
		#計算開始
		$log->cntRecord($PokeGet::IN->{pname}, $isKeitai) if($mode eq "res");
		
		my $calc = ($ver eq "dpt")? CalcDpt->new
		                          : ($ver eq "adv")? CalcAdv->new
		                                           : ($ver eq "gsc")? CalcGSC->new
		                                                            : CalcRGB->new;
		$calc->init($params, $err);
		$calc->calc;
		
		if($params->isGraph) {
			$result = GraphResult->new($params);
		} else {
			$result = DetailResult->new($params);
		}
		
		#結果画面出力
		if($mode eq "res") {
			&outputHtml($result, $context, $htmlMaker);
		}
		
		#グラフ画像生成
		if($mode eq "g") {
			if($isKeitai) {
				$graph = GraphK->new;
			} else {
				if($lang eq 'en') {
					$graph = GraphPC_en->new;
				} else {
					$graph = GraphPC->new;
				}
			}
			$graph->draw($result);
		}
	}
	
	sub decode {
		local %in;
		local @getItems, $postBuf, @postItems;
		
		@getItems = split(/&/, $ENV{'QUERY_STRING'});
		
		read(STDIN, $postBuf, $ENV{'CONTENT_LENGTH'}); 
		@postItems =  split(/&/, $postBuf);
		
		foreach(@getItems, @postItems) {
			my($name, $val) = split(/=/, $_);
			
			$val =~ s/\+/ /g;
			$val =~ s/%([0-9a-fA-F][0-9a-fA-F])/pack("c", hex $1)/eg;
			#$val = pack "U0C*", unpack "C*", $val;
			$val =~ s/\r//g;
			$val =~ s/&/&amp;/g;
			$val =~ s/</&lt;/g;
			$val =~ s/>/&gt;/g;
			
			#$val = Encode::decode("shiftjis", $val);
			#$val = Jcode::decode("sjis", $val);
			$val = Jcode->new($val)->utf8;
			&numJtoA($val);
			&hira2kata($val);
			$in{$name} = $val;
		}
		return %in;
	}
	
	#結果HTML出力
	sub outputHtml {
		my $result = shift;
		my $context = shift;
		my $htmlMaker = shift; #HtmlMaker $_[0]
		
		$output = Output->new($result, $context);
		
		local($head, $resultCont, $statusList, $style, $backto, $rights);
		$head = $output->getContext("head");
		$resultCont = $result->makeResult($output);
		$statusList = $output->makeStatusList;
		$sizeCtl = sprintf $output->getContext("sizeCtl"), $result->{winSize}->{x}, $result->{winSize}->{y};
		
		#外来さんチェック
		if(!$PokeGet::OUTSIDE) {
			$style = $output->getContext('style_user');
			$backto = $output->getContext("backto_btn");
		} else {
			$style = $output->getContext('style_guest');
			$backto = $output->getContext("backto_link");
			$rights = $output->getContext("rights");
		}
		
		my $html = $htmlMaker->new(
			style => $style,
			title =>'計算結果',
			header => $sizeCtl,
			bodyAttr => $output->getContext("bodyAttr"),
			body => &{$output->getContext("htmlBody")}($resultCont, $statusList, $backto, $rights),
		);
		print $html->make;
	}
	
	#全角数字→半角
	sub numJtoA {
		${\$_[0]} =~ s/\xef\xbc([\x90-\x99])/pack "C", ord($1) - 0x60/ge;
	}
	
	#ひらがな→カタカナ
	sub hira2kata {
		${\$_[0]} =~ s/\xe3\x81([\x81-\x9f])/"\xe3\x82".pack("C", ord($1) + 0x20)/ge;
		${\$_[0]} =~ s/\xe3\x81([\xA0-\xbf])/"\xe3\x83".pack("C", ord($1) - 0x20)/ge;
		${\$_[0]} =~ s/\xe3\x82([\x80-\x94])/"\xe3\x83".pack("C", ord($1) + 0x20)/ge;
	}
}

{
	package Client;
	require "module/phone.pl";
	
	sub new {
		my $this = shift;
		my $hash = &phone_info();
		
		bless $hash, $this;
	}
	
	sub isKeitai {
		my $this = shift;
		
		#return 3; #only ketai for debug
		if ( $this->{type} eq "docomo" ) {
			return 1;
		} elsif ( $this->{type} eq "jphone" ) {
			return 2;
		} elsif ( $this->{type} eq "ezweb" ) {
			return 3;
		} else {
			return;
		}
	}
}

{
	package Point;
	
	sub new {
		my $this = shift;
		my $hash = {
			x => shift,
			y => shift,
		};
		bless $hash, $this;
	}
}

1;
