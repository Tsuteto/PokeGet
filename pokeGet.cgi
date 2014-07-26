#!/usr/local/bin/perl -I./module
#/Perl/bin/perl -I./module
#
# ポケゲットEX-G（旧・ポケモン捕獲率計算機 EX-G）
#
# ToDo
# ・グラフで状態異常も一挙に計算

use strict;
use warnings;
use PokeGet;

#-----------------
# 実行処理
#-----------------
PokeGet->new->main;

__END__