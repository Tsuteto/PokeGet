#charset=UTF-8
#use utf8;
use Jcode;

{
	package HtmlMaker;
	
	sub new {
		my $this = shift;
		my $hash = {
			style => "std",
			httpHeader => {
				"Content-Type" => "text/html;charset=Shift_JIS",
			},
			title => '',
			isManualTitle => 0,
			header => '',
			bodyAttr => '',
			body => '',
			@_
		};
		bless $hash, $this;
	}
	
	sub make {
		my $this = shift;
		my $html;
		
		if($this->getStyle eq 'std') {
			$html = $this->stdFrame;
		} elsif($this->getStyle eq 'none') {
			#なにもしない
		}
		
		#return &Encode::encode("shiftjis", $html);
		#return Jcode::encode("sjis", $html);
		return Jcode::convert($html, "sjis");
		return $html;
	}
	
	sub setStyle {
		my $this = shift;
		$this->{style} = shift;
	}
	sub getStyle {
		my $this = shift;
		return $this->{style};
	}
	
	sub setTitle {
		my $this = shift;
		$this->{title} = shift;
	}
	sub getTitle {
		my $this = shift;
		return $this->{title};
	}
	
	sub setManualTitle {
		my $this = shift;
		$this->{isManualTitle} = shift;
	}
	sub isManualTitle {
		my $this = shift;
		return $this->{isManualTitle};
	}
	
	sub setHeader {
		my $this = shift;
		$this->{header} = shift;
	}
	sub getHeader {
		my $this = shift;
		return $this->{header};
	}
	
	sub setBodyAttr {
		my $this = shift;
		$this->{bodyAttr} = shift;
	}
	sub getBodyAttr {
		my $this = shift;
		return $this->{bodyAttr};
	}
	
	sub setBody {
		my $this = shift;
		$this->{body} = shift;
	}
	sub getBody {
		my $this = shift;
		return $this->{body};
	}
	
	sub setHttpHeader {
		my $this = shift;
		$this->{httpHeader}{shift} = shift;
	}
	sub getHttpHeader {
		my $this = shift;
		my $a = shift;
		return $this->{httpHeader}{$a};
	}
	sub outHttpHeader {
		my $this = shift;
		my $out;
		foreach(keys %{$this->{httpHeader}}) {
			$out .= sprintf "%s: %s", $_, $this->getHttpHeader($_);
		}
		return $out;
	}
	sub outTitleTag {
		my $this = shift;
		my $title = $this->getTitle;
		if($this->isManualTitle) {
			return "<title>$title</title>";
		} else {
			return "<title>$title - $PokeGet::TITLE</title>";
		}
	}
}

{
	package HtmlMakerPC;
	use base (qw/HtmlMaker/);
	
	sub stdFrame {
		my $this = shift;
		$httpHeader = $this->outHttpHeader;
		$title = $this->outTitleTag;
		$header = $this->getHeader;
		$bodyAttr = $this->getBodyAttr;
		$body = $this->getBody;
		
		return <<EOF;
$httpHeader

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html;charset=Shift_JIS">
	<meta http-equiv="Content-Style-Type" content="text/css;charset=Shift_JIS">
	<meta http-equiv="Content-Script-Type" content="text/javascript;charset=Shift_JIS">
	$title
	<link rel="stylesheet" href="pokeGet.css" type="text/css">
	<!--[if IE]><link rel="stylesheet" href="pokeGet_ie.css" type="text/css"><![endif]-->
	<!--<script src="http://www.google-analytics.com/urchin.js" type="text/javascript"></script>
	<script type="text/javascript">
	_uacct = "UA-3108461-1";
	urchinTracker();
	</script>-->
	$header
</head>
<body $bodyAttr>
$body
</body>
</html>
EOF
	}
}

{
	package HtmlMakerPC_en;
	use base (qw/HtmlMaker/);
	
	sub new {
		my $class = shift;
		my $this = $class->SUPER::new(@_);
		
		$this->{httpHeader}{"Content-Type"} = "text/html;charset=Shift_JIS";
		return $this;
	}
	
	sub stdFrame {
		my $this = shift;
		$httpHeader = $this->outHttpHeader;
		$title = $this->outTitleTag;
		$header = $this->getHeader;
		$bodyAttr = $this->getBodyAttr;
		$body = $this->getBody;
		
		return <<EOF;
$httpHeader

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html lang="en">
<head>
	<meta http-equiv="Content-Type" content="text/html;charset=Shift_JIS">
	<meta http-equiv="Content-Style-Type" content="text/css;charset=Shift_JIS">
	<meta http-equiv="Content-Script-Type" content="text/javascript;charset=Shift_JIS">
	$title
	<link rel="stylesheet" href="pokeGet.css" type="text/css">
	<!--[if IE]><link rel="stylesheet" href="pokeGet_ie.css" type="text/css"><![endif]-->
	<link rel="stylesheet" href="pokeGet_en.css" type="text/css">
	<!--<script src="http://www.google-analytics.com/urchin.js" type="text/javascript"></script>
	<script type="text/javascript">
	_uacct = "UA-3108461-1";
	urchinTracker();
	</script>-->
	$header
</head>
<body $bodyAttr>
$body
</body>
</html>
EOF
	}
}

{
	package HtmlMakerK;
	use base (qw/HtmlMaker/);
	
	sub stdFrame {
		my $this = shift;
		my $httpHeader = $this->outHttpHeader;
		my $title = $this->outTitleTag;
		my $header = $this->getHeader;
		my $bodyAttr = $this->getBodyAttr;
		my $body = $this->getBody;
		
		return <<EOF;
$httpHeader

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<body>
<head>
	<meta http-equiv="Content-Type" content="text/html;charset=Shift_JIS">
	<meta http-equiv="Content-Style-Type" content="text/css;charset=Shift_JIS">
	$title
	<link rel="stylesheet" href="pokeGetK.css" type="text/css">
	$header
</head>
<body $bodyAttr>
$body
</body>
</html>
EOF
	}
}

{
	package HtmlMakerI;
	use base (qw/HtmlMaker/);
	
	sub new {
		my $class = shift;
		my $this = $class->SUPER::new(@_);
		
		$this->{httpHeader}{"Content-Type"} = "application/xhtml+xml;charset=Shift_JIS";
		return $this;
	}
	
	sub stdFrame {
		my $this = shift;
		my $httpHeader = $this->outHttpHeader;
		my $title = $this->outTitleTag;
		my $header = $this->getHeader;
		my $bodyAttr = $this->getBodyAttr;
		my $body = $this->getBody;
		
		return <<EOF;
$httpHeader

<?xml version="1.0" encoding="Shift_JIS"?> 
<!DOCTYPE html PUBLIC "-//i-mode group (ja)//DTD XHTML i-XHTML(Locale/Ver.=ja/2.1) 1.0//EN" "i-xhtml_4ja_10.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ja">  
<head>
	<meta http-equiv="Content-Type" content="application/xhtml+xml;charset=Shift_JIS" />
	$title
	$header
</head>
<body $bodyAttr>
$body
EOF

	}
}
1;
