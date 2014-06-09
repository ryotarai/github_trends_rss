$(function() {
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
