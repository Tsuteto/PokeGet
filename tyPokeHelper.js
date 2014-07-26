// TyPokeHelper - ポケモン名リアルタイム入力補完
// (C) MetaLui http://nin10.web.infoseek.co.jp/

var TyPokeHelper = function() {
	this.citem = new Array();
	this.isIE = false;
	this.isSaf = false;
	this.isOpe = false;
	this.isNN = false;
	this.textfld = null;
	this.clist = null;
	this.isDk = false;
	
	if(navigator.appName.indexOf("Internet Explorer") != -1) {
		this.isIE = true;
	} else if(navigator.userAgent.indexOf("Safari") != -1) {
		this.isSaf = true;
	} else if(navigator.userAgent.indexOf("Opera") != -1) {
		this.isOpe = true;
	} else {
		this.isNN = true;
	}
	
	this.textfld = document.getElementById("typInput");
	if(this.isIE) {
		this.textfld.onkeydown = (function(helper) {
			return function() { helper.main(event); }
		})(this);
		this.textfld.onfocus = (function(helper) {
			return function() { helper.findWord(); helper.checkInput(); }
		})(this);
		this.textfld.onblur = (function(helper) {
			return function() { helper.hideclist(); clearTimeout(helper.textfld.checkTimer); }
		})(this);
	} else {
		this.textfld.addEventListener("keydown",
			(function(helper) {
				return function(e) { helper.main(e); }
			})(this), false);
		this.textfld.addEventListener("focus",
			(function(helper) {
				return function() { helper.findWord(); helper.checkInput(); }
			})(this), false);
		this.textfld.addEventListener("blur",
			(function(helper) {
				return function() { helper.hideclist(); clearTimeout(helper.textfld.checkTimer); }
			})(this), false);
	}
	
	candout = document.getElementById("typHelper");
	this.clist = document.createElement("div");
	candout.appendChild(this.clist);
	this.clist.className = "cand";
	this.clist.style.display = "none";
	this.clist.style.opacity = 1;
	this.clist.style.filter = "alpha(opacity = 100)";
	this.clist.items = new Array();
	this.clist.selitem = -1;
	this.clist.nowH = 0;
	
	this.clist.ol = document.createElement("ol");
	this.clist.appendChild(this.clist.ol);
	this.clist.note = document.createElement("div");
	this.clist.appendChild(this.clist.note);
	
	this.clist.shade = document.createElement("div");
	candout.appendChild(this.clist.shade);
	this.clist.shade.className = "candShade";
	this.clist.shade.style.display = "none";
	this.clist.shade.style.opacity = 0.3;
	this.clist.shade.style.filter = "alpha(opacity = 30)";
	
	this.clist.defaultOnSubmit = document.mainform.onsubmit;
	
	this.isDk = true;
};

TyPokeHelper.prototype = {
	main: function(e) {
		var key = (e.keyCode != 0) ? e.keyCode : e.charCode
		switch(key) {
		  case 0:
			break;
		  case 38:
		  case 40:
			if(!this.clist.items.length) break;
			if(this.clist.selitem != -1) this.clist.items[this.clist.selitem].className = "";
			this.clist.selitem += (key == 40)? 1 : -1;
			if(this.clist.selitem < 0) this.clist.selitem = this.clist.items.length - 1;
			if(this.clist.selitem >= this.clist.items.length) this.clist.selitem = 0;
			this.clist.items[this.clist.selitem].className = "sel";
			//this.textfld.value = this.clist.pokes[this.clist.selitem].name;
			break;
		  case 13:
			var ret = this.pressEnter();
			if(ret) break;
		  default:
			this.findWord();
		}
	},
	
	checkInput: function() {
		var input = this.textfld.value;
		if(input != this.textfld.prevValue) {
			this.findWord();
		}
		this.textfld.prevValue = input;
		this.textfld.checkTimer = setTimeout((function(timer) {
			return function() { timer.checkInput() }
		})(this), 50);
	},
	
	pressEnter: function() {
		var doSomething = false;
		if(this.clist.pokes.length == 1) {
			this.selItem(0);
			doSomething = true;
		}
		if(this.clist.selitem != -1) {
			this.textfld.blur();
			this.textfld.value = this.clist.pokes[this.clist.selitem].name;
			doSomething = true;
		}
		return doSomething;
	},
	
	findWord: function() {
		var input = this.textfld.value;
		var i, span, isTail;
		var isPno = false;
		var candCont = '';
		for(i in this.clist.items) this.clist.ol.removeChild(this.clist.items[i]);
		this.clist.items = [];
		this.clist.pokes = [];
		this.clist.style.height = "auto";
		this.clist.selitem = -1;
		
		isTail = input.match(/^(_|＿)/);
		input = input.replace(/^_|＿/, "");
		input = this.charEx(input);
		if(input == '') { this.hideclist(); return; }
		
		if(input.match(/[^0-9-]/)) {
			if(isTail) {
				for(i in this.pokes) {
					if(this.pokes[i].slice(-input.length) == input) pushClist(i);
				}
			} else {
				for(i in this.pokes) {
					if(this.pokes[i].indexOf(input) == 0) this.pushClist(i);
				}
			}
		} else if(input.match(/^[0-9]/)){
			if(input.slice(-1) == "-") {
				input = input.replace("-", "");
				input = parseInt(input.replace(/^0*([1-9]*[0-9]+)$/, "$1"));
				for(i = 0; i < 10; i++) this.pushClist(input+i);
			} else {
				input = parseInt(input.replace(/^0*([1-9]*[0-9]+)$/, "$1"));
				this.pushClist(input);
				isPno = true;
			}
		}
		for(var i in this.clist.pokes) {
			this.clist.items[i] = document.createElement("li");
			this.clist.items[i].innerHTML = 
				'<span class="pno">'+this.to3digits(this.clist.pokes[i].no)+'. </span>'+this.clist.pokes[i].name;
			this.clist.items[i].value = i;
			this.clist.items[i].onclick = (function(timer) {
				return function() { timer.selItem(this.value) }
			})(this);
			this.clist.items[i].onmouseover = (function(timer) {
				return function() { this.className = "sel"; timer.clist.selitem = this.value; }
			})(this);
			this.clist.items[i].onmouseout = (function(timer) {
				return function() { this.className = ""; timer.clist.selitem = -1; }
			})(this);
			this.clist.ol.appendChild(this.clist.items[i]);
		}
		if(this.clist.pokes.length == 0) {
			this.clist.note.className = "note"
			this.clist.note.innerHTML = 'そのポケモンは<br>見つかりません';
		} else if(this.clist.pokes.length >= 2) {
			this.clist.note.className = "note sep";
			this.clist.note.innerHTML = '変換確定後キー操作：<br>↑↓選択 , Enter決定';
		} else if(isPno) {
			this.clist.note.className = "note";
			this.clist.note.innerHTML = '';
		} else {
			this.clist.note.className = "note sep";
			this.clist.note.innerHTML = '変換確定して<br>Enterで入力！';
		}
		
		if(this.clist.hideTimer) clearTimeout(this.clist.hideTimer);
		this.clist.style.display = "block";
		this.clist.style.opacity = 1;
		this.clist.style.filter = "alpha(opacity = 100)";
		this.clist.newH = this.clist.clientHeight - (this.isIE? 0 : 5);
		this.clist.shade.style.display = "block";
		this.clist.shade.style.opacity = 0.3;
		this.clist.shade.style.filter = "alpha(opacity = 30)";
		document.mainform.onsubmit = (function(timer) {
			return function() {
				timer.pressEnter();
				return false;
			}
		})(this);
		this.optclist();
	},
	
	selItem: function(id) {
		this.textfld.blur();
		this.textfld.value = this.clist.pokes[id].name;
		this.hideclist();
	},
	
	pushClist: function(no) {
		if(this.pokes[no] == undefined) return;
		
		var poke = {
			name: this.pokes[no],
			no: no
		};
		this.clist.pokes.push(poke);
	},
	
	optclist: function() {
		if(Math.abs(this.clist.newH - this.clist.nowH) < 2) {
			this.clist.style.height = this.clist.newH+"px";
			this.clist.shade.style.height = this.clist.newH+"px";
			this.clist.nowH = this.clist.shade.nowH = this.clist.newH;
			return;
		}
		this.clist.nowH += (this.clist.newH - this.clist.nowH) / 3.5;
		this.clist.style.height = this.clist.shade.style.height = Math.floor(this.clist.nowH)+"px";
		setTimeout((function(obj) {
			return function() { obj.optclist(); };
		})(this), 10);
	},
	
	hideclist: function() {
		if(this.clist.style.opacity < 0.1) {
			this.clist.style.display = "none";
			this.clist.shade.style.display = "none";
			this.clist.nowH = 0;
			
			this.clist.pokes = {};
			document.mainform.onsubmit = this.clist.defaultOnSubmit;
			return;
		}
		this.clist.style.opacity /= 1.5;
		this.clist.style.filter = "alpha(opacity = "+(this.clist.style.opacity * 100)+")";
		this.clist.shade.style.opacity /= 2;
		this.clist.shade.style.filter = "alpha(opacity = "+(this.clist.shade.style.opacity * 100)+")";
		this.clist.hideTimer = setTimeout((function(obj) {
			return function() { obj.hideclist(); };
		})(this), 50);
	},
	
	getKey: function(e) {
		if(this.isIE) {
			return (e.keyCode);
		} else {
			var key = e.which;
			/*
			if(key == 38 || key == 40) {
				if(this.isDk || this.isSaf) {
					this.isDk = false;
					return key;
				} else {
					this.isDk = true;
					return 0;
				}
			}
			*/
			return key;
		}
	},
	
	charEx: function(str) {
		var out = '';
		var code, i;
		for(i = 0; i < str.length; i++) {
			code = parseInt(str.charCodeAt(i));
			if(code >= 0x3041 && code <= 0x3093) {
				code += 0x60;
			}
			if(code >= 0xff10 && code <= 0xff19) {
				code -= 0xfee0;
			}
			if(code >= 0x41 && code <= 0x7a
					|| code >= 0xff21 && code <= 0xff5a) {
				continue;
			}
			out += String.fromCharCode(code);
		}
		out = out.replace(/([0-9])(?:ー|－)/, "$1-");
		return out;
	},
	
	to3digits: function(num) {
		var zero = '';
		var want = 3 - num.length;
		if(want == 0) return num;
		
		while(want--) zero += "0";
		return zero + num;
	},
	
	pokes: '？？？？？ フシギダネ フシギソウ フシギバナ ヒトカゲ リザード リザードン ゼニガメ カメール カメックス キャタピー トランセル バタフリー ビードル コクーン スピアー ポッポ ピジョン ピジョット コラッタ ラッタ オニスズメ オニドリル アーボ アーボック ピカチュウ ライチュウ サンド サンドパン ニドラン♀ ニドリーナ ニドクイン ニドラン♂ ニドリーノ ニドキング ピッピ ピクシー ロコン キュウコン プリン プクリン ズバット ゴルバット ナゾノクサ クサイハナ ラフレシア パラス パラセクト コンパン モルフォン ディグダ ダグトリオ ニャース ペルシアン コダック ゴルダック マンキー オコリザル ガーディ ウインディ ニョロモ ニョロゾ ニョロボン ケーシィ ユンゲラー フーディン ワンリキー ゴーリキー カイリキー マダツボミ ウツドン ウツボット メノクラゲ ドククラゲ イシツブテ ゴローン ゴローニャ ポニータ ギャロップ ヤドン ヤドラン コイル レアコイル カモネギ ドードー ドードリオ パウワウ ジュゴン ベトベター ベトベトン シェルダー パルシェン ゴース ゴースト ゲンガー イワーク スリープ スリーパー クラブ キングラー ビリリダマ マルマイン タマタマ ナッシー カラカラ ガラガラ サワムラー エビワラー ベロリンガ ドガース マタドガス サイホーン サイドン ラッキー モンジャラ ガルーラ タッツー シードラ トサキント アズマオウ ヒトデマン スターミー バリヤード ストライク ルージュラ エレブー ブーバー カイロス ケンタロス コイキング ギャラドス ラプラス メタモン イーブイ シャワーズ サンダース ブースター ポリゴン オムナイト オムスター カブト カブトプス プテラ カビゴン フリーザー サンダー ファイヤー ミニリュウ ハクリュー カイリュー ミュウツー ミュウ チコリータ ベイリーフ メガニウム ヒノアラシ マグマラシ バクフーン ワニノコ アリゲイツ オーダイル オタチ オオタチ ホーホー ヨルノズク レディバ レディアン イトマル アリアドス クロバット チョンチー ランターン ピチュー ピィ ププリン トゲピー トゲチック ネイティ ネイティオ メリープ モココ デンリュウ キレイハナ マリル マリルリ ウソッキー ニョロトノ ハネッコ ポポッコ ワタッコ エイパム ヒマナッツ キマワリ ヤンヤンマ ウパー ヌオー エーフィ ブラッキー ヤミカラス ヤドキング ムウマ アンノーン ソーナンス キリンリキ クヌギダマ フォレトス ノコッチ グライガー ハガネール ブルー グランブル ハリーセン ハッサム ツボツボ ヘラクロス ニューラ ヒメグマ リングマ マグマッグ マグカルゴ ウリムー イノムー サニーゴ テッポウオ オクタン デリバード マンタイン エアームド デルビル ヘルガー キングドラ ゴマゾウ ドンファン ポリゴン2 オドシシ ドーブル バルキー カポエラー ムチュール エレキッド ブビィ ミルタンク ハピナス ライコウ エンテイ スイクン ヨーギラス サナギラス バンギラス ルギア ホウオウ セレビィ キモリ ジュプトル ジュカイン アチャモ ワカシャモ バシャーモ ミズゴロウ ヌマクロー ラグラージ ポチエナ グラエナ ジグザグマ マッスグマ ケムッソ カラサリス アゲハント マユルド ドクケイル ハスボー ハスブレロ ルンパッパ タネボー コノハナ ダーテング スバメ オオスバメ キャモメ ペリッパー ラルトス キルリア サーナイト アメタマ アメモース キノココ キノガッサ ナマケロ ヤルキモノ ケッキング ツチニン テッカニン ヌケニン ゴニョニョ ドゴーム バクオング マクノシタ ハリテヤマ ルリリ ノズパス エネコ エネコロロ ヤミラミ クチート ココドラ コドラ ボスゴドラ アサナン チャーレム ラクライ ライボルト プラスル マイナン バルビート イルミーゼ ロゼリア ゴクリン マルノーム キバニア サメハダー ホエルコ ホエルオー ドンメル バクーダ コータス バネブー ブーピッグ パッチール ナックラー ビブラーバ フライゴン サボネア ノクタス チルット チルタリス ザングース ハブネーク ルナトーン ソルロック ドジョッチ ナマズン ヘイガニ シザリガー ヤジロン ネンドール リリーラ ユレイドル アノプス アーマルド ヒンバス ミロカロス ポワルン カクレオン カゲボウズ ジュペッタ ヨマワル サマヨール トロピウス チリーン アブソル ソーナノ ユキワラシ オニゴーリ タマザラシ トドグラー トドゼルガ パールル ハンテール サクラビス ジーランス ラブカス タツベイ コモルー ボーマンダ ダンバル メタング メタグロス レジロック レジアイス レジスチル ラティアス ラティオス カイオーガ グラードン レックウザ ジラーチ デオキシス ナエトル ハヤシガメ ドダイトス ヒコザル モウカザル ゴウカザル ポッチャマ ポッタイシ エンペルト ムックル ムクバード ムクホーク ビッパ ビーダル コロボーシ コロトック コリンク ルクシオ レントラー スボミー ロズレイド ズガイドス ラムパルド タテトプス トリデプス ミノムッチ ミノマダム ガーメイル ミツハニー ビークイン パチリス ブイゼル フローゼル チェリンボ チェリム カラナクシ トリトドン エテボース フワンテ フワライド ミミロル ミミロップ ムウマージ ドンカラス ニャルマー ブニャット リーシャン スカンプー スカタンク ドーミラー ドータクン ウソハチ マネネ ピンプク ペラップ ミカルゲ フカマル ガバイト ガブリアス ゴンベ リオル ルカリオ ヒポポタス カバルドン スコルピ ドラピオン グレッグル ドクロッグ マスキッパ ケイコウオ ネオラント タマンタ ユキカブリ ユキノオー マニューラ ジバコイル ベロベルト ドサイドン モジャンボ エレキブル ブーバーン トゲキッス メガヤンマ リーフィア グレイシア グライオン マンムー ポリゴンZ エルレイド ダイノーズ ヨノワール ユキメノコ ロトム ユクシー エムリット アグノム ディアルガ パルキア ヒードラン レジギガス ギラティナ クレセリア フィオネ マナフィ ダークライ シェイミ アルセウス ビクティニ ツタージャ ジャノビー ジャローダ ポカブ チャオブー エンブオー ミジュマル フタチマル ダイケンキ ミネズミ ミルホッグ ヨーテリー ハーデリア ムーランド チョロネコ レパルダス ヤナップ ヤナッキー バオップ バオッキー ヒヤップ ヒヤッキー ムンナ ムシャーナ マメパト ハトーボー ケンホロウ シママ ゼブライカ ダンゴロ ガントル ギガイアス コロモリ ココロモリ モグリュー ドリュウズ タブンネ ドッコラー ドテッコツ ローブシン オタマロ ガマガル ガマゲロゲ ナゲキ ダゲキ クルミル クルマユ ハハコモリ フシデ ホイーガ ペンドラー モンメン エルフーン チュリネ ドレディア バスラオ メグロコ ワルビル ワルビアル ダルマッカ ヒヒダルマ マラカッチ イシズマイ イワパレス ズルッグ ズルズキン シンボラー デスマス デスカーン プロトーガ アバゴーラ アーケン アーケオス ヤブクロン ダストダス ゾロア ゾロアーク チラーミィ チラチーノ ゴチム ゴチミル ゴチルゼル ユニラン ダブラン ランクルス コアルヒー スワンナ バニプッチ バニリッチ バイバニラ シキジカ メブキジカ エモンガ カブルモ シュバルゴ タマゲタケ モロバレル プルリル ブルンゲル ママンボウ バチュル デンチュラ テッシード ナットレイ ギアル ギギアル ギギギアル シビシラス シビビール シビルドン リグレー オーベム ヒトモシ ランプラー シャンデラ キバゴ オノンド オノノクス クマシュン ツンベアー フリージオ チョボマキ アギルダー マッギョ コジョフー コジョンド クリムガン ゴビット ゴルーグ コマタナ キリキザン バッフロン ワシボン ウォーグル バルチャイ バルジーナ クイタラン アイアント モノズ ジヘッド サザンドラ メラルバ ウルガモス コバルオン テラキオン ビリジオン トルネロス ボルトロス レシラム ゼクロム ランドロス キュレム ケルディオ メロエッタ ゲノセクト ィ"ゃゾ┛'.split(" ")
};
