// TyPokeHelper - �|�P���������A���^�C�����͕⊮
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
		
		isTail = input.match(/^(_|�Q)/);
		input = input.replace(/^_|�Q/, "");
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
			this.clist.note.innerHTML = '���̃|�P������<br>������܂���';
		} else if(this.clist.pokes.length >= 2) {
			this.clist.note.className = "note sep";
			this.clist.note.innerHTML = '�ϊ��m���L�[����F<br>�����I�� , Enter����';
		} else if(isPno) {
			this.clist.note.className = "note";
			this.clist.note.innerHTML = '';
		} else {
			this.clist.note.className = "note sep";
			this.clist.note.innerHTML = '�ϊ��m�肵��<br>Enter�œ��́I';
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
		out = out.replace(/([0-9])(?:�[|�|)/, "$1-");
		return out;
	},
	
	to3digits: function(num) {
		var zero = '';
		var want = 3 - num.length;
		if(want == 0) return num;
		
		while(want--) zero += "0";
		return zero + num;
	},
	
	pokes: '�H�H�H�H�H �t�V�M�_�l �t�V�M�\�E �t�V�M�o�i �q�g�J�Q ���U�[�h ���U�[�h�� �[�j�K�� �J���[�� �J���b�N�X �L���^�s�[ �g�����Z�� �o�^�t���[ �r�[�h�� �R�N�[�� �X�s�A�[ �|�b�| �s�W���� �s�W���b�g �R���b�^ ���b�^ �I�j�X�Y�� �I�j�h���� �A�[�{ �A�[�{�b�N �s�J�`���E ���C�`���E �T���h �T���h�p�� �j�h������ �j�h���[�i �j�h�N�C�� �j�h������ �j�h���[�m �j�h�L���O �s�b�s �s�N�V�[ ���R�� �L���E�R�� �v���� �v�N���� �Y�o�b�g �S���o�b�g �i�]�m�N�T �N�T�C�n�i ���t���V�A �p���X �p���Z�N�g �R���p�� �����t�H�� �f�B�O�_ �_�O�g���I �j���[�X �y���V�A�� �R�_�b�N �S���_�b�N �}���L�[ �I�R���U�� �K�[�f�B �E�C���f�B �j������ �j�����] �j�����{�� �P�[�V�B �����Q���[ �t�[�f�B�� �������L�[ �S�[���L�[ �J�C���L�[ �}�_�c�{�~ �E�c�h�� �E�c�{�b�g ���m�N���Q �h�N�N���Q �C�V�c�u�e �S���[�� �S���[�j�� �|�j�[�^ �M�����b�v ���h�� ���h���� �R�C�� ���A�R�C�� �J���l�M �h�[�h�[ �h�[�h���I �p�E���E �W���S�� �x�g�x�^�[ �x�g�x�g�� �V�F���_�[ �p���V�F�� �S�[�X �S�[�X�g �Q���K�[ �C���[�N �X���[�v �X���[�p�[ �N���u �L���O���[ �r�����_�} �}���}�C�� �^�}�^�} �i�b�V�[ �J���J�� �K���K�� �T�������[ �G�r�����[ �x�������K �h�K�[�X �}�^�h�K�X �T�C�z�[�� �T�C�h�� ���b�L�[ �����W���� �K���[�� �^�b�c�[ �V�[�h�� �g�T�L���g �A�Y�}�I�E �q�g�f�}�� �X�^�[�~�[ �o�����[�h �X�g���C�N ���[�W���� �G���u�[ �u�[�o�[ �J�C���X �P���^���X �R�C�L���O �M�����h�X ���v���X ���^���� �C�[�u�C �V�����[�Y �T���_�[�X �u�[�X�^�[ �|���S�� �I���i�C�g �I���X�^�[ �J�u�g �J�u�g�v�X �v�e�� �J�r�S�� �t���[�U�[ �T���_�[ �t�@�C���[ �~�j�����E �n�N�����[ �J�C�����[ �~���E�c�[ �~���E �`�R���[�^ �x�C���[�t ���K�j�E�� �q�m�A���V �}�O�}���V �o�N�t�[�� ���j�m�R �A���Q�C�c �I�[�_�C�� �I�^�` �I�I�^�` �z�[�z�[ �����m�Y�N ���f�B�o ���f�B�A�� �C�g�}�� �A���A�h�X �N���o�b�g �`�����`�[ �����^�[�� �s�`���[ �s�B �v�v���� �g�Q�s�[ �g�Q�`�b�N �l�C�e�B �l�C�e�B�I �����[�v ���R�R �f�������E �L���C�n�i �}���� �}������ �E�\�b�L�[ �j�����g�m �n�l�b�R �|�|�b�R ���^�b�R �G�C�p�� �q�}�i�b�c �L�}���� ���������} �E�p�[ �k�I�[ �G�[�t�B �u���b�L�[ ���~�J���X ���h�L���O ���E�} �A���m�[�� �\�[�i���X �L�������L �N�k�M�_�} �t�H���g�X �m�R�b�` �O���C�K�[ �n�K�l�[�� �u���[ �O�����u�� �n���[�Z�� �n�b�T�� �c�{�c�{ �w���N���X �j���[�� �q���O�} �����O�} �}�O�}�b�O �}�O�J���S �E�����[ �C�m���[ �T�j�[�S �e�b�|�E�I �I�N�^�� �f���o�[�h �}���^�C�� �G�A�[���h �f���r�� �w���K�[ �L���O�h�� �S�}�]�E �h���t�@�� �|���S��2 �I�h�V�V �h�[�u�� �o���L�[ �J�|�G���[ ���`���[�� �G���L�b�h �u�r�B �~���^���N �n�s�i�X ���C�R�E �G���e�C �X�C�N�� ���[�M���X �T�i�M���X �o���M���X ���M�A �z�E�I�E �Z���r�B �L���� �W���v�g�� �W���J�C�� �A�`���� ���J�V���� �o�V���[�� �~�Y�S���E �k�}�N���[ ���O���[�W �|�`�G�i �O���G�i �W�O�U�O�} �}�b�X�O�} �P���b�\ �J���T���X �A�Q�n���g �}�����h �h�N�P�C�� �n�X�{�[ �n�X�u���� �����p�b�p �^�l�{�[ �R�m�n�i �_�[�e���O �X�o�� �I�I�X�o�� �L������ �y���b�p�[ �����g�X �L�����A �T�[�i�C�g �A���^�} �A�����[�X �L�m�R�R �L�m�K�b�T �i�}�P�� �����L���m �P�b�L���O �c�`�j�� �e�b�J�j�� �k�P�j�� �S�j���j�� �h�S�[�� �o�N�I���O �}�N�m�V�^ �n���e���} ������ �m�Y�p�X �G�l�R �G�l�R���� ���~���~ �N�`�[�g �R�R�h�� �R�h�� �{�X�S�h�� �A�T�i�� �`���[���� ���N���C ���C�{���g �v���X�� �}�C�i�� �o���r�[�g �C���~�[�[ ���[���A �S�N���� �}���m�[�� �L�o�j�A �T���n�_�[ �z�G���R �z�G���I�[ �h������ �o�N�[�_ �R�[�^�X �o�l�u�[ �u�[�s�b�O �p�b�`�[�� �i�b�N���[ �r�u���[�o �t���C�S�� �T�{�l�A �m�N�^�X �`���b�g �`���^���X �U���O�[�X �n�u�l�[�N ���i�g�[�� �\�����b�N �h�W���b�` �i�}�Y�� �w�C�K�j �V�U���K�[ ���W���� �l���h�[�� �����[�� �����C�h�� �A�m�v�X �A�[�}���h �q���o�X �~���J���X �|������ �J�N���I�� �J�Q�{�E�Y �W���y�b�^ ���}���� �T�}���[�� �g���s�E�X �`���[�� �A�u�\�� �\�[�i�m ���L�����V �I�j�S�[�� �^�}�U���V �g�h�O���[ �g�h�[���K �p�[���� �n���e�[�� �T�N���r�X �W�[�����X ���u�J�X �^�c�x�C �R�����[ �{�[�}���_ �_���o�� ���^���O ���^�O���X ���W���b�N ���W�A�C�X ���W�X�`�� ���e�B�A�X ���e�B�I�X �J�C�I�[�K �O���[�h�� ���b�N�E�U �W���[�` �f�I�L�V�X �i�G�g�� �n���V�K�� �h�_�C�g�X �q�R�U�� ���E�J�U�� �S�E�J�U�� �|�b�`���} �|�b�^�C�V �G���y���g ���b�N�� ���N�o�[�h ���N�z�[�N �r�b�p �r�[�_�� �R���{�[�V �R���g�b�N �R�����N ���N�V�I �����g���[ �X�{�~�[ ���Y���C�h �Y�K�C�h�X �����p���h �^�e�g�v�X �g���f�v�X �~�m���b�` �~�m�}�_�� �K�[���C�� �~�c�n�j�[ �r�[�N�C�� �p�`���X �u�C�[�� �t���[�[�� �`�F�����{ �`�F���� �J���i�N�V �g���g�h�� �G�e�{�[�X �t�����e �t�����C�h �~�~���� �~�~���b�v ���E�}�[�W �h���J���X �j�����}�[ �u�j���b�g ���[�V���� �X�J���v�[ �X�J�^���N �h�[�~���[ �h�[�^�N�� �E�\�n�` �}�l�l �s���v�N �y���b�v �~�J���Q �t�J�}�� �K�o�C�g �K�u���A�X �S���x ���I�� ���J���I �q�|�|�^�X �J�o���h�� �X�R���s �h���s�I�� �O���b�O�� �h�N���b�O �}�X�L�b�p �P�C�R�E�I �l�I�����g �^�}���^ ���L�J�u�� ���L�m�I�[ �}�j���[�� �W�o�R�C�� �x���x���g �h�T�C�h�� ���W�����{ �G���L�u�� �u�[�o�[�� �g�Q�L�b�X ���K�����} ���[�t�B�A �O���C�V�A �O���C�I�� �}�����[ �|���S��Z �G�����C�h �_�C�m�[�Y ���m���[�� ���L���m�R ���g�� ���N�V�[ �G�����b�g �A�O�m�� �f�B�A���K �p���L�A �q�[�h���� ���W�M�K�X �M���e�B�i �N���Z���A �t�B�I�l �}�i�t�B �_�[�N���C �V�F�C�~ �A���Z�E�X �r�N�e�B�j �c�^�[�W�� �W���m�r�[ �W�����[�_ �|�J�u �`���I�u�[ �G���u�I�[ �~�W���}�� �t�^�`�}�� �_�C�P���L �~�l�Y�~ �~���z�b�O ���[�e���[ �n�[�f���A ���[�����h �`�����l�R ���p���_�X ���i�b�v ���i�b�L�[ �o�I�b�v �o�I�b�L�[ �q���b�v �q���b�L�[ �����i ���V���[�i �}���p�g �n�g�[�{�[ �P���z���E �V�}�} �[�u���C�J �_���S�� �K���g�� �M�K�C�A�X �R������ �R�R������ ���O�����[ �h�����E�Y �^�u���l �h�b�R���[ �h�e�b�R�c ���[�u�V�� �I�^�}�� �K�}�K�� �K�}�Q���Q �i�Q�L �_�Q�L �N���~�� �N���}�� �n�n�R���� �t�V�f �z�C�[�K �y���h���[ �������� �G���t�[�� �`�����l �h���f�B�A �o�X���I ���O���R �����r�� �����r�A�� �_���}�b�J �q�q�_���} �}���J�b�` �C�V�Y�}�C �C���p���X �Y���b�O �Y���Y�L�� �V���{���[ �f�X�}�X �f�X�J�[�� �v���g�[�K �A�o�S�[�� �A�[�P�� �A�[�P�I�X ���u�N���� �_�X�g�_�X �]���A �]���A�[�N �`���[�~�B �`���`�[�m �S�`�� �S�`�~�� �S�`���[�� ���j���� �_�u���� �����N���X �R�A���q�[ �X�����i �o�j�v�b�` �o�j���b�` �o�C�o�j�� �V�L�W�J ���u�L�W�J �G�����K �J�u���� �V���o���S �^�}�Q�^�P �����o���� �v������ �u�����Q�� �}�}���{�E �o�`���� �f���`���� �e�b�V�[�h �i�b�g���C �M�A�� �M�M�A�� �M�M�M�A�� �V�r�V���X �V�r�r�[�� �V�r���h�� ���O���[ �I�[�x�� �q�g���V �����v���[ �V�����f�� �L�o�S �I�m���h �I�m�m�N�X �N�}�V���� �c���x�A�[ �t���[�W�I �`���{�}�L �A�M���_�[ �}�b�M�� �R�W���t�[ �R�W�����h �N�����K�� �S�r�b�g �S���[�O �R�}�^�i �L���L�U�� �o�b�t���� ���V�{�� �E�H�[�O�� �o���`���C �o���W�[�i �N�C�^���� �A�C�A���g ���m�Y �W�w�b�h �T�U���h�� �������o �E���K���X �R�o���I�� �e���L�I�� �r���W�I�� �g���l���X �{���g���X ���V���� �[�N���� �����h���X �L������ �P���f�B�I �����G�b�^ �Q�m�Z�N�g �B"��]��'.split(" ")
};