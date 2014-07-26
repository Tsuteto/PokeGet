// TyPokeHelper - É|ÉPÉÇÉìñºÉäÉAÉãÉ^ÉCÉÄì¸óÕï‚äÆ ébíËâpåÍî≈
// (C) MetaLui http://nin10.web.infoseek.co.jp/

var pokes = new Array();
var pokedat = 
"?????,Bulbasaur,Ivysaur,Venusaur,Charmander,Charmeleon,Charizard,Squirtle,Wartortle,Blastoise,Caterpie,Metapod,Butterfree,Weedle,Kakuna,Beedrill,Pidgey,Pidgeotto,Pidgeot,Rattata,Raticate,Spearow,Fearow,Ekans,Arbok,Pikachu,Raichu,Sandshrew,Sandslash,NidoranÅä,Nidorina,Nidoqueen,NidoranÅâ,Nidorino,Nidoking,Clefairy,Clefable,Vulpix,Ninetales,Jigglypuff,Wigglytuff,Zubat,Golbat,Oddish,Gloom,Vileplume,Paras,Parasect,Venonat,Venomoth,Diglett,Dugtrio,Meowth,Persian,Psyduck,Golduck,Mankey,Primeape,Growlithe,Arcanine,Poliwag,Poliwhirl,Poliwrath,Abra,Kadabra,Alakazam,Machop,Machoke,Machamp,Bellsprout,Weepinbell,Victreebel,Tentacool,Tentacruel,Geodude,Graveler,Golem,Ponyta,Rapidash,Slowpoke,Slowbro,Magnemite,Magneton,Farfetch'd,Doduo,Dodrio,Seel,Dewgong,Grimer,Muk,Shellder,Cloyster,Gastly,Haunter,Gengar,Onix,Drowzee,Hypno,Krabby,Kingler,Voltorb,Electrode,Exeggcute,Exeggutor,Cubone,Marowak,Hitmonlee,Hitmonchan,Lickitung,Koffing,Weezing,Rhyhorn,Rhydon,Chansey,Tangela,Kangaskhan,Horsea,Seadra,Goldeen,Seaking,Staryu,Starmie,Mr. Mime,Scyther,Jynx,Electabuzz,Magmar,Pinsir,Tauros,Magikarp,Gyarados,Lapras,Ditto,Eevee,Vaporeon,Jolteon,Flareon,Porygon,Omanyte,Omastar,Kabuto,Kabutops,Aerodactyl,Snorlax,Articuno,Zapdos,Moltres,Dratini,Dragonair,Dragonite,Mewtwo,Mew,Chikorita,Bayleef,Meganium,Cyndaquil,Quilava,Typhlosion,Totodile,Croconaw,Feraligatr,Sentret,Furret,Hoothoot,Noctowl,Ledyba,Ledian,Spinarak,Ariados,Crobat,Chinchou,Lanturn,Pichu,Cleffa,Igglybuff,Togepi,Togetic,Natu,Xatu,Mareep,Flaaffy,Ampharos,Bellossom,Marill,Azumarill,Sudowoodo,Politoed,Hoppip,Skiploom,Jumpluff,Aipom,Sunkern,Sunflora,Yanma,Wooper,Quagsire,Espeon,Umbreon,Murkrow,Slowking,Misdreavus,Unown,Wobbuffet,Girafarig,Pineco,Forretress,Dunsparce,Gligar,Steelix,Snubbull,Granbull,Qwilfish,Scizor,Shuckle,Heracross,Sneasel,Teddiursa,Ursaring,Slugma,Magcargo,Swinub,Piloswine,Corsola,Remoraid,Octillery,Delibird,Mantine,Skarmory,Houndour,Houndoom,Kingdra,Phanpy,Donphan,Porygon2,Stantler,Smeargle,Tyrogue,Hitmontop,Smoochum,Elekid,Magby,Miltank,Blissey,Raikou,Entei,Suicune,Larvitar,Pupitar,Tyranitar,Lugia,Ho-Oh,Celebi,Treecko,Grovyle,Sceptile,Torchic,Combusken,Blaziken,Mudkip,Marshtomp,Swampert,Poochyena,Mightyena,Zigzagoon,Linoone,Wurmple,Silcoon,Beautifly,Cascoon,Dustox,Lotad,Lombre,Ludicolo,Seedot,Nuzleaf,Shiftry,Taillow,Swellow,Wingull,Pelipper,Ralts,Kirlia,Gardevoir,Surskit,Masquerain,Shroomish,Breloom,Slakoth,Vigoroth,Slaking,Nincada,Ninjask,Shedinja,Whismur,Loudred,Exploud,Makuhita,Hariyama,Azurill,Nosepass,Skitty,Delcatty,Sableye,Mawile,Aron,Lairon,Aggron,Meditite,Medicham,Electrike,Manectric,Plusle,Minun,Volbeat,Illumise,Roselia,Gulpin,Swalot,Carvanha,Sharpedo,Wailmer,Wailord,Numel,Camerupt,Torkoal,Spoink,Grumpig,Spinda,Trapinch,Vibrava,Flygon,Cacnea,Cacturne,Swablu,Altaria,Zangoose,Seviper,Lunatone,Solrock,Barboach,Whiscash,Corphish,Crawdaunt,Baltoy,Claydol,Lileep,Cradily,Anorith,Armaldo,Feebas,Milotic,Castform,Kecleon,Shuppet,Banette,Duskull,Dusclops,Tropius,Chimecho,Absol,Wynaut,Snorunt,Glalie,Spheal,Sealeo,Walrein,Clamperl,Huntail,Gorebyss,Relicanth,Luvdisc,Bagon,Shelgon,Salamence,Beldum,Metang,Metagross,Regirock,Regice,Registeel,Latias,Latios,Kyogre,Groudon,Rayquaza,Jirachi,Deoxys,Turtwig,Grotle,Torterra,Chimchar,Monferno,Infernape,Piplup,Prinplup,Empoleon,Starly,Staravia,Staraptor,Bidoof,Bibarel,Kricketot,Kricketune,Shinx,Luxio,Luxray,Budew,Roserade,Cranidos,Rampardos,Shieldon,Bastiodon,Burmy,Wormadam,Mothim,Combee,Vespiquen,Pachirisu,Buizel,Floatzel,Cherubi,Cherrim,Shellos,Gastrodon,Ambipom,Drifloon,Drifblim,Buneary,Lopunny,Mismagius,Honchkrow,Glameow,Purugly,Chingling,Stunky,Skuntank,Bronzor,Bronzong,Bonsly,Mime Jr.,Happiny,Chatot,Spiritomb,Gible,Gabite,Garchomp,Munchlax,Riolu,Lucario,Hippopotas,Hippowdon,Skorupi,Drapion,Croagunk,Toxicroak,Carnivine,Finneon,Lumineon,Mantyke,Snover,Abomasnow,Weavile,Magnezone,Lickilicky,Rhyperior,Tangrowth,Electivire,Magmortar,Togekiss,Yanmega,Leafeon,Glaceon,Gliscor,Mamoswine,Porygon-Z,Gallade,Probopass,Dusknoir,Froslass,Rotom,Uxie,Mesprit,Azelf,Dialga,Palkia,Heatran,Regigigas,Giratina,Cresselia,Phione,Manaphy,Darkrai,Shaymin,Arceus";
pokes = pokedat.split(",");

var citem = new Array();
var isIE, isSaf, isOpe, isNN, textfld, clist, isDk;

function helperInit() {
	if(navigator.appName.indexOf("Internet Explorer") != -1) {
		isIE = true;
	} else if(navigator.userAgent.indexOf("Safari") != -1) {
		isSaf = true;
	} else if(navigator.userAgent.indexOf("Opera") != -1) {
		isOpe = true;
	} else {
		isNN = true;
	}
	
	textfld = document.getElementById("typInput");
	if(isIE) {
		textfld.onkeydown = function() { main(event); };
	} else {
		textfld.addEventListener("keydown", function(e) { main(e); }, false);
	}
	textfld.onfocus = function() { findWord(); checkInput(); }
	textfld.onblur = function() { hideclist(); clearTimeout(textfld.checkTimer); };
	
	candout = document.getElementById("typHelper");
	clist = document.createElement("div");
	candout.appendChild(clist);
	clist.className = "cand";
	clist.style.display = "none";
	clist.style.opacity = 1;
	clist.style.filter = "alpha(opacity = 100)";
	clist.items = new Array();
	clist.selitem = -1;
	clist.nowH = 0;
	
	clist.ol = document.createElement("ol");
	clist.appendChild(clist.ol);
	clist.note = document.createElement("div");
	clist.appendChild(clist.note);
	
	clist.shade = document.createElement("div");
	candout.appendChild(clist.shade);
	clist.shade.className = "candShade";
	clist.shade.style.display = "none";
	clist.shade.style.opacity = 0.3;
	clist.shade.style.filter = "alpha(opacity = 30)";
	
	clist.defaultOnSubmit = document.mainform.onsubmit;
	
	isDk = true;
}

function main(e) {
	var key = (e.keyCode != 0) ? e.keyCode : e.charCode
	switch(key) {
	  case 0:
		break;
	  case 38:
	  case 40:
		if(!clist.items.length) break;
		if(clist.selitem != -1) clist.items[clist.selitem].className = "";
		clist.selitem += (key == 40)? 1 : -1;
		if(clist.selitem < 0) clist.selitem = clist.items.length - 1;
		if(clist.selitem >= clist.items.length) clist.selitem = 0;
		clist.items[clist.selitem].className = "sel";
		//textfld.value = clist.pokes[clist.selitem].name;
		break;
	  case 13:
		var ret = pressEnter();
		if(ret) break;
	  default:
		findWord();
	}
}

function checkInput() {
	var input = textfld.value;
	if(input != textfld.prevValue) {
		findWord();
	}
	textfld.prevValue = input;
	textfld.checkTimer = setTimeout("checkInput()", 50);
}

function pressEnter() {
	var doSomething = false;
	if(clist.pokes.length == 1) {
		selItem(0);
		doSomething = true;
	}
	if(clist.selitem != -1) {
		textfld.blur();
		textfld.value = clist.pokes[clist.selitem].name;
		doSomething = true;
	}
	return doSomething;
}

function findWord() {
	var input = textfld.value;
	var i, span, isTail;
	var isPno = false;
	var candCont = '';
	for(i in clist.items) clist.ol.removeChild(clist.items[i]);
	clist.items = [];
	clist.pokes = [];
	clist.style.height = "auto";
	clist.selitem = -1;
	
	isTail = input.match(/^(_|ÅQ)/);
	input = input.replace(/^_|ÅQ/, "");
	input = charEx(input);
	if(input == '') { hideclist(); return; }
	
	if(input.match(/[^0-9-]/)) {
		if(isTail) {
			for(i in pokes) {
				if(pokes[i].slice(-input.length).toUpperCase() == input.toUpperCase()) pushClist(i);
			}
		} else {
			for(i in pokes) {
				if(pokes[i].toUpperCase().indexOf(input.toUpperCase()) == 0) pushClist(i);
			}
		}
	} else if(input.match(/^[0-9]/)){
		if(input.slice(-1) == "-") {
			input = input.replace("-", "");
			input = parseInt(input.replace(/^0*([1-9]*[0-9]+)$/, "$1"));
			for(i = 0; i < 10; i++) pushClist(input+i);
		} else {
			input = parseInt(input.replace(/^0*([1-9]*[0-9]+)$/, "$1"));
			pushClist(input);
			isPno = true;
		}
	}
	for(var i in clist.pokes) {
		clist.items[i] = document.createElement("li");
		clist.items[i].innerHTML = 
			'<span class="pno">'+to3digits(clist.pokes[i].no)+'. </span>'+clist.pokes[i].name;
		clist.items[i].value = i;
		clist.items[i].onclick = function() { selItem(this.value) };
		clist.items[i].onmouseover = function() { this.className = "sel"; clist.selitem = this.value;  };
		clist.items[i].onmouseout = function() { this.className = ""; clist.selitem = -1; };
		clist.ol.appendChild(clist.items[i]);
	}
	if(clist.pokes.length == 0) {
		clist.note.className = "note"
		clist.note.innerHTML = "That Pok&eacute;mon won't<br>be found";
	} else if(clist.pokes.length >= 2) {
		clist.note.className = "note sep";
		clist.note.innerHTML = 'Key control:<br>Å™Å´ to move, Enter to select';
	} else if(isPno) {
		clist.note.className = "note";
		clist.note.innerHTML = '';
	} else {
		clist.note.className = "note sep";
		clist.note.innerHTML = 'Hit Enter to input';
	}
	
	if(clist.hideTimer) clearTimeout(clist.hideTimer);
	clist.style.display = "block";
	clist.style.opacity = 1;
	clist.style.filter = "alpha(opacity = 100)";
	clist.newH = clist.clientHeight - (isIE? 0 : 5);
	clist.shade.style.display = "block";
	clist.shade.style.opacity = 0.3;
	clist.shade.style.filter = "alpha(opacity = 30)";
	document.mainform.onsubmit = function() {
		pressEnter();
		return false;
	};
	optclist();
}

function selItem(id) {
	textfld.blur();
	textfld.value = clist.pokes[id].name;
	hideclist();
}

function pushClist(no) {
	if(pokes[no] == undefined) return;
	
	var poke = {
		name: pokes[no],
		no: no
	};
	clist.pokes.push(poke);
}

function optclist() {
	if(Math.abs(clist.newH - clist.nowH) < 2) {
		clist.style.height = clist.newH+"px";
		clist.shade.style.height = clist.newH+"px";
		clist.nowH = clist.shade.nowH = clist.newH;
		return;
	}
	clist.nowH += (clist.newH - clist.nowH) / 3.5;
	clist.style.height = clist.shade.style.height = Math.floor(clist.nowH)+"px";
	setTimeout("optclist()", 10);
}

function hideclist() {
	if(clist.style.opacity < 0.1) {
		clist.style.display = "none";
		clist.shade.style.display = "none";
		clist.nowH = 0;
		
		clist.pokes = {};
		document.mainform.onsubmit = clist.defaultOnSubmit;
		return;
	}
	clist.style.opacity /= 1.5;
	clist.style.filter = "alpha(opacity = "+(clist.style.opacity * 100)+")";
	clist.shade.style.opacity /= 2;
	clist.shade.style.filter = "alpha(opacity = "+(clist.shade.style.opacity * 100)+")";
	clist.hideTimer = setTimeout("hideclist()", 50);
}

function getKey(e) {
	if(isIE) {
		return (e.keyCode);
	} else {
		var key = e.which;
		/*
		if(key == 38 || key == 40) {
			if(isDk || isSaf) {
				isDk = false;
				return key;
			} else {
				isDk = true;
				return 0;
			}
		}
		*/
		return key;
	}
}

function charEx(str) {
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
		if(code >= 0xff21 && code <= 0xff5a) {
			continue;
		}
		out += String.fromCharCode(code);
	}
	out = out.replace(/([0-9])(?:Å[|Å|)/, "$1-");
	return out;
}

function to3digits(num) {
	var zero = '';
	var want = 3 - num.length;
	if(want == 0) return num;
	
	while(want--) zero += "0";
	return zero + num;
}
