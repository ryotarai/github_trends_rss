$(function() {
  var langsOrder = ['all', 'unknown', 'c', 'javascript', 'objective-c', 'python', 'ruby', 'bash', 'vim', 'abap', 'as3', 'ada', 'apex', 'applescript', 'arc', 'arduino', 'aspx-vb', 'nasm', 'augeas', 'autohotkey', 'awk', 'boo', 'bro', 'csharp', 'cpp', 'ceylon', 'clips', 'clojure', 'coffeescript', 'cfm', 'common-lisp', 'coq', 'css', 'd', 'dart', 'dcpu-16-asm', 'delphi', 'dot', 'dylan', 'ec', 'ecl', 'eiffel', 'elixir', 'emacs-lisp', 'erlang', 'fsharp', 'factor', 'fancy', 'fantom', 'forth', 'fortran', 'go', 'gosu', 'groovy', 'haskell', 'haxe', 'io', 'ioke', 'java', 'julia', 'kotlin', 'lasso', 'livescript', 'logos', 'logtalk', 'lua', 'm', 'matlab', 'max%2Fmsp', 'ruby', 'monkey', 'moonscript', 'nemerle', 'nimrod', 'nu', 'objective-j', 'ocaml', 'omgrofl', 'ooc', 'opa', 'openedge-abl', 'parrot', 'perl', 'php', 'pike', 'pogoscript', 'powershell', 'processing', 'prolog', 'puppet', 'pure-data', 'r', 'racket', 'ragel-in-ruby-host', 'rebol', 'rouge', 'rust', 'scala', 'scheme', 'scilab', 'self', 'slash', 'smalltalk', 'standard-ml', 'supercollider', 'swift', 'tcl', 'turing', 'txl', 'typescript', 'vala', 'verilog', 'vhdl', 'visual-basic', 'wisp', 'xc', 'xml', 'xproc', 'xquery', 'xslt', 'xtend'];

  var langs = {
    'all': 'All Languages',
    'unknown': 'Unknown',
    'abap': 'ABAP',
    'as3': 'ActionScript',
    'ada': 'Ada',
    'apex': 'Apex',
    'applescript': 'AppleScript',
    'arc': 'Arc',
    'arduino': 'Arduino',
    'aspx-vb': 'ASP',
    'nasm': 'Assembly',
    'augeas': 'Augeas',
    'autohotkey': 'AutoHotkey',
    'awk': 'Awk',
    'boo': 'Boo',
    'bro': 'Bro',
    'c': 'C',
    'csharp': 'C#',
    'cpp': 'C++',
    'ceylon': 'Ceylon',
    'clips': 'CLIPS',
    'clojure': 'Clojure',
    'coffeescript': 'CoffeeScript',
    'cfm': 'ColdFusion',
    'common-lisp': 'Common Lisp',
    'coq': 'Coq',
    'css': 'CSS',
    'd': 'D',
    'dart': 'Dart',
    'dcpu-16-asm': 'DCPU-16 ASM',
    'delphi': 'Delphi',
    'dot': 'DOT',
    'dylan': 'Dylan',
    'ec': 'eC',
    'ecl': 'Ecl',
    'eiffel': 'Eiffel',
    'elixir': 'Elixir',
    'emacs-lisp': 'Emacs Lisp',
    'erlang': 'Erlang',
    'fsharp': 'F#',
    'factor': 'Factor',
    'fancy': 'Fancy',
    'fantom': 'Fantom',
    'forth': 'Forth',
    'fortran': 'FORTRAN',
    'go': 'Go',
    'gosu': 'Gosu',
    'groovy': 'Groovy',
    'haskell': 'Haskell',
    'haxe': 'Haxe',
    'io': 'Io',
    'ioke': 'Ioke',
    'java': 'Java',
    'javascript': 'JavaScript',
    'julia': 'Julia',
    'kotlin': 'Kotlin',
    'lasso': 'Lasso',
    'livescript': 'LiveScript',
    'logos': 'Logos',
    'logtalk': 'Logtalk',
    'lua': 'Lua',
    'm': 'M',
    'matlab': 'Matlab',
    'max%2Fmsp': 'Max',
    'ruby': 'Mirah',
    'monkey': 'Monkey',
    'moonscript': 'MoonScript',
    'nemerle': 'Nemerle',
    'nimrod': 'Nimrod',
    'nu': 'Nu',
    'objective-c': 'Objective-C',
    'objective-j': 'Objective-J',
    'ocaml': 'OCaml',
    'omgrofl': 'Omgrofl',
    'ooc': 'ooc',
    'opa': 'Opa',
    'openedge-abl': 'OpenEdge ABL',
    'parrot': 'Parrot',
    'perl': 'Perl',
    'php': 'PHP',
    'pike': 'Pike',
    'pogoscript': 'PogoScript',
    'powershell': 'PowerShell',
    'processing': 'Processing',
    'prolog': 'Prolog',
    'puppet': 'Puppet',
    'pure-data': 'Pure Data',
    'python': 'Python',
    'r': 'R',
    'racket': 'Racket',
    'ragel-in-ruby-host': 'Ragel in Ruby Host',
    'rebol': 'Rebol',
    'rouge': 'Rouge',
    'ruby': 'Ruby',
    'rust': 'Rust',
    'scala': 'Scala',
    'scheme': 'Scheme',
    'scilab': 'Scilab',
    'self': 'Self',
    'bash': 'Shell',
    'slash': 'Slash',
    'smalltalk': 'Smalltalk',
    'standard-ml': 'Standard ML',
    'supercollider': 'SuperCollider',
    'swift': 'Swift',
    'tcl': 'Tcl',
    'turing': 'Turing',
    'txl': 'TXL',
    'typescript': 'TypeScript',
    'vala': 'Vala',
    'verilog': 'Verilog',
    'vhdl': 'VHDL',
    'vim': 'VimL',
    'visual-basic': 'Visual Basic',
    'wisp': 'wisp',
    'xc': 'XC',
    'xml': 'XML',
    'xproc': 'XProc',
    'xquery': 'XQuery',
    'xslt': 'XSLT',
    'xtend': 'Xtend',
  };
  var source   = $("#lang-template").html();
  var template = Handlebars.compile(source);
  var row;
  for (i in langsOrder) {
    lang = langsOrder[i]
    langName = langs[lang]

    var context = {langKey: lang, langName: langs[lang], escapedLangKey: lang.replace('/', '_')}
    var html    = template(context);

    if (i % 4 == 0) {
      row = $('<div class="row"></div>');
    }
    row.append(html);
    if (i % 4 == 3) {
      $('div#content').append(row);
      row = null;
    }
  }

  if (row !== null) {
    $('div#content').append(row);
  }

});
