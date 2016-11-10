$(function() {
  $.getJSON("languages.json", function(languages) {
    var source   = $("#lang-template").html();
    var template = Handlebars.compile(source);
    var row;
    for (var i = 0; i < languages.length; i++) {
      var language = languages[i];
      var context = {
        langKey: language["key"],
        langName: language["name"],
        escapedLangKey: language["key"],
      };
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
});
