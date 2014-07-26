#charset=UTF-8

# 共通グラフ描画
{
	package Graph;
	
	#$NUM_FONT = "Vera.ttf";
	#$TEXT_FONT = "../kochi-gothic.ttf";
	
	sub draw {
		#use Jcode;
		#use Image::Magick;
		
		my $this = shift;
		my $result = shift;
		
		my $g = Image::Magick::new;
		
		
		#$g->Set(size=>"$size->{x}x$size->{y}");
		$g->ReadImage($this->{baseImage});
		
		#y軸補助
		#foreach(0..10) {
		#	$y = $o_y - $s_y / 10 * $_;
		#	if($_) {
		#		$g->Draw(primitive=>'line',
		#		         stroke=>'#ccc', strokewidth=>1,
		#		         points=>"$o_x,$y ".($o_x + $s_x).",$y");
		#	}
		#	if(!($_ % 2)) {
		#		$g->Annotate(text=>$_ * 10,
		#		             fill=>'black', align=>'right',
		#		             font=>$numFont, pointsize=>16, weight=>900,
		#		             x=>$o_x - 7, y=>$y + 6,
		#		             encoding=>'UTF-8');
		#	}
		#}
		
		#メイン
		my @Gp = @{$result->{params}->getGetPer};
		my $o = $this->{o};
		my $s = $this->{s};
		my($p, $prevp);
		for($n = $#Gp; $n >= 0; $n--) {
			$p = Point->new(
				$o->{x} + $s->{x} - $s->{x} * (($n + 1) / (@Gp + 1)),
				$o->{y} - $Gp[$n] * $s->{y}
			);
			
			#x軸補助
			#if(!($n % 2) || $n < 2) {
			#	$g->Draw(primitive=>'line',
			#	         stroke=>'#ccc', strokewidth=>1,
			#	         points=>"$x,$o_y $x,".($o_y - $s_y - 20));
			#	$g->Annotate(text=>$rHPs[$n],
			#	             fill=>'black', align=>'center',
			#	             font=>$numFont, pointsize=>14, weight=>900,
			#	             x=>$x, y=>$o_y + 20,
			#	             encoding=>'UTF-8');
			#}
			
			#点
			$g->Draw(primitive=>'circle',
			         fill=>"blue",
			         stroke=>"blue", strokewidth=>0, antialias=>$this->{antialias},
			         points=>"$p->{x},$p->{y} $p->{x},".($p->{y} - 2)
			);
			#線
			$g->Draw(primitive=>'line',
			         stroke=>'blue', strokewidth=>1, antialias=>$this->{antialias},
			         points=>"$prevp->{x},$prevp->{y} $p->{x},$p->{y}"
			);
			
			#値
			#if($y != $prev_y) {
			#	#位置
			#	$dist = (($x - $prev_x) ** 2 + ($y - $prev_y) ** 2) ** 0.5;
			#	$n_d = $Gp[$n] < 0.05 || (($dist < 25)? !$prev_d : 1);
			#	$n_y = $n_d? $y - 5 : $y + 14;
			#	$n_x = $n_d? $x + 5 : $x - 5;
			#	$n_align = $n_d? 'right' : 'left';
			#	$get = sprintf("%.1f", $Gp[$n] * 100);
			#		$g->Annotate(text=>$get,
			#		             fill=>"blue", align=>$n_align,
			#		             font=>$numFont, pointsize=>16,
			#		             x=>$n_x, y=>$n_y, scale=>0.7,
			#		             encoding=>'UTF-8');
			#}
			
			$prevp = $p; 
			#$prev_d = $n_d;
		}
		print "Content-type: image/$this->{outputType}\n\n";
		print $g->write("$this->{outputType}:-");
	}
}

#端末別
{
	package GraphPC;
	use base qw/Graph/;
	
	sub new {
		my $this = shift;
		my $hash = {
			size => Point->new(600, 445),
			o => Point->new(80, 392),
			s => Point->new(500, 360),
			baseImage => 'graph_base-s.png',
			antialias => 'True',
			outputType => 'png'
		};
		bless $hash, $this;
	}
}

{
	package GraphPC_en;
	use base qw/Graph/;
	
	sub new {
		my $this = shift;
		my $hash = {
			size => Point->new(600, 445),
			o => Point->new(80, 392),
			s => Point->new(500, 360),
			baseImage => 'graph_base-en.png',
			antialias => 'True',
			outputType => 'png'
		};
		bless $hash, $this;
	}
}

{
	package GraphK;
	use base qw/Graph/;
	
	sub new {
		my $this = shift;
		my $hash = {
			size => Point->new(200, 200),
			o => Point->new(30, 170),
			s => Point->new(170, 160),
			baseImage => 'graph_base-k.png',
			antialias => 'False',
			outputType => 'png'
		};
		bless $hash, $this;
	}
}



1;
