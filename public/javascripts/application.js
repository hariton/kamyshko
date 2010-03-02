$.ajaxSetup({
  'beforeSend': function(xhr) { xhr.setRequestHeader('Accept', 'text/javascript') }
});

var today = new Date();
var tomorrow = new Date();
tomorrow.setDate(today.getDate() + 1);

var zoom_options = {
  zoomWidth: 584,
  zoomHeight: 'auto',
  xOffset: 1,
  imgSource: 'rel',
};

var zoomShowFlag = false;

$(document).ready(function() {

  $.fn.dataTableExt.oSort['ru_date-asc']  = function(a, b) {
    var ruDatea = a.replace(/<.*?>/g, '').replace(/[^\d\.]/g, '');
    var ruDateb = b.replace(/<.*?>/g, '').replace(/[^\d\.]/g, '');

    if ( ruDatea == '' && ruDateb == '' )
      return 0;
    if ( ruDatea == '' )
      return -1;
    if ( ruDateb == '' )
      return 1;

    var x = parseInt(ruDatea.split('.').reverse().join(''));
    var y = parseInt(ruDateb.split('.').reverse().join(''));

    return (x < y) ? -1 : ((x > y) ?  1 : 0);
  };

  $.fn.dataTableExt.oSort['ru_date-desc'] = function(a, b) {
    var ruDatea = a.replace(/<.*?>/g, '').replace(/[^\d\.]/g, '');
    var ruDateb = b.replace(/<.*?>/g, '').replace(/[^\d\.]/g, '');

    if ( ruDatea == '' && ruDateb == '' )
      return 0;
    if ( ruDatea == '' )
      return 1;
    if ( ruDateb == '' )
      return -1;

    var x = parseInt(ruDatea.split('.').reverse().join(''));
    var y = parseInt(ruDateb.split('.').reverse().join(''));

    return (x < y) ? 1 : ((x > y) ?  -1 : 0);
  };

  $("table#sources").dataTable({
    "bStateSave": true,
    "bPaginate": true,
    "iDefaultSortIndex": 1,
    "iDisplayStart": 25,
    // "sPaginationType": "full_numbers",
    "sPaginationType": "two_button",
    "bAutoWidth": false,
    "aoColumns": [
       { 'sWidth': '49px', "asSorting": [ "desc", "asc" ] },
       { 'sWidth': '38px', "bSortable": false },
       { 'sWidth': '282px', "sType": "html" },
       { 'sWidth': '90px', "sType": "ru_date", "asSorting": [ "desc", "asc" ] },
       { 'sWidth': '90px', "sType": "ru_date", "asSorting": [ "desc", "asc" ] },
       { 'sWidth': '18px', "bSortable": false }
    ],
    "oLanguage": {
      "sProcessing": "Пожалуйста подождите...",
      "sLengthMenu": "_MENU_ на странице",
      "sZeroRecords": "Нет источников",
      "sInfo": "Из <b>_TOTAL_</b> источников сейчас на странице: <b>_START_</b>-<b>_END_</b>",
      "sInfoEmpty": "Нет источников соответствующих запросу",
      "sInfoFiltered": " (из _MAX_)",
      "sInfoPostFix": "",
      "sSearch": "<label>Быстрый переход:</label>",
      "sUrl": "",
      "oPaginate": {
        "sFirst": "Первая страница",
        "sPrevious": "Предыдущая",
        "sNext": "Следующая",
        "sLast": "Последняя",
      }
    }
  });

  $('#search_query').keypress(function(e){
    if (e.which == 13){
      $("#search_submit").click();
      return false;
    }
  });

  $('#search_query').click(function() {
    $(this).select();
  });

  $('#sources_filter input[type=text]').click(function() {
    $(this).select();
  });

  $('#search_date_start').datepicker({
    numberOfMonths: 3,
    showButtonPanel: true,
    maxDate: tomorrow
    /*
    minDate: new Date(2009, 10 - 1, 26),
    maxDate: new Date(2009, 11 - 1, 26)
    */
  });
  $('#search_date_end').datepicker({
    numberOfMonths: 3,
    showButtonPanel: true,
    maxDate: tomorrow
    /*
    minDate: new Date(2009, 10 - 1, 26),
    maxDate: new Date(2009, 11 - 1, 26)
    */
  });

  $('textarea.resizable:not(.processed)').TextAreaResizer();
  $('iframe.resizable:not(.processed)').TextAreaResizer();

  $('#search_sources').hide();

  $('#selected_search_sources .search_sources_trigger').click(function(){
    with ( $('#search_sources') ) {
      if (css('display') == 'none') {
        slideDown(1300);
        $('#selected_search_sources .icon').removeClass('icon_arrowthickstop-1-s').addClass('icon_arrowthickstop-1-n');
      } else {
        hide();
        $('#selected_search_sources .icon').removeClass('icon_arrowthickstop-1-n').addClass('icon_arrowthickstop-1-s');
      }
    }
  });

  $('#search_sources_buttons a#select_none').click(function(){
    $('#search_sources_columns a').each(function(){
      $(this).children('input').attr('checked', false);
    });
    $('#selected_sources_counter').html('0');
  });

  $('#search_sources_buttons a#select_all').click(function(){
    $('#search_sources_columns a').each(function(){
      $(this).children('input').attr('checked', true);
    });
    $('#selected_sources_counter').html( $('#sources_sum').html() );
  });

  $('#search_sources_buttons a#select_invert').click(function(){
    selected_sources_counter = $('#selected_sources_counter').html();
    $('#search_sources_columns a').each(function(){
      with ( $(this).children('input') ) {
        if ( attr('checked') ) {
          attr('checked', false);
          --selected_sources_counter;
        } else {
          attr('checked', true);
          ++selected_sources_counter;
        }
      };
    });
    $('#selected_sources_counter').html(selected_sources_counter);
  });

  $('#search_sources_columns a').click(function(){
    selected_sources_counter = $('#selected_sources_counter').html();
    with ( $(this).children('input') ) {
      if ( attr('checked') ) {
        attr('checked', false);
        --selected_sources_counter;
      } else {
        attr('checked', true);
        ++selected_sources_counter;
      }
    }
    $('#selected_sources_counter').html(selected_sources_counter);
  });

  $('.zoom').zoom(zoom_options);

  /// закладка выпуска (думаю стоит этот кусок вынести в отдельный js-файл)
  $('input#issue_date').datepicker({
    showButtonPanel: true,
    maxDate: tomorrow
  });

  function parseFileName(filename){
      filename.match(/^(.+?)_(\d+)_([0-3]*\d)_([01]*\d)_((19|20)\d\d).(pdf|txt)$/);
      return [RegExp.$2, ('0' + RegExp.$3).slice(-2), ('0' + RegExp.$4).slice(-2), RegExp.$5, RegExp.$6];
  }

  $("input#issue_pdf_file").change( function() {
    var filename = $(this).val();
    var issue_attributes = parseFileName(filename);
    if (issue_attributes[0]) {
      $("input#issue_number").val(issue_attributes[0]);
    }
    if (issue_attributes[1] && issue_attributes[2] && issue_attributes[3]) {
      $('input#issue_date').val( issue_attributes.slice(1, 4).join('.') );
    }
  });

  $.validator.addMethod( 'regex',
    function(value, element, regex) {
      var check = false;
      var re = new RegExp(regex);
      return this.optional(element) || re.test(value);
    }, 'Неправильное значение'
  );

  $('#issue_form').validate({
    rules: {
      'issue[pdf_file]': {
         required: true,
         accept: 'pdf'
      },
      'issue[txt_file]': {
         required: true,
         accept: 'txt'
      },
      'issue[number]': {
         required: true,
         digits: true
      },
      'issue[date]': {
         required: true,
         regex: '^([0-2]?\\d|3[01])\\.(0?\\d|1[0-2])\\.(19|20)\\d\\d$'
      }
    },
    messages: {
      'issue[pdf_file]': {
        required: 'Укажите PDF-файл для загрузки',
        accept: 'Только для PDF-файлов'
      },
      'issue[txt_file]': {
        required: 'Укажите текстовый файл для загрузки',
        accept: 'Только для текстовых файлов'
      },
      'issue[number]': {
        required: 'Необходимо указать номер выпуска',
        digits: 'Здесь допустимы только цифры'
      },
      'issue[date]': {
        required: 'Нужно указать дату выпуска'
      }
    }
  });

  // $('#draggable').draggable();

  /*
  фиксация
  $("#column2").css("position", "absolute");
  $(window).scroll(function() {
    $("#column2").css("top", $(window).scrollTop() + "px");
  });
  */

  $('.add_page').live('click', function () {
    $.getScript(this.href);
    return false;
  });

  $('.remove_page').live('click', function () {
    $.getScript(this.href);
    return false;
  });


  $('#screen a.zoom').live('click', function (e) {
    if (e.shiftKey) {
      $.setFragment({page: $.querystring(this.rev).page});
      $.getScript(this.rev);
    } else {
      $.setFragment({page: $.querystring(this.href).page});
      $.getScript(this.href);
    };
    return false;
  });

  $('.pagination a').live('click', function () {
    var href = $(this).attr('href');
    $.bbq.pushState($.deparam.querystring(href));
    return false;
  });

  $('#prev_page').live('click', function () {
    var href = $(this).attr('href');
    $.bbq.pushState($.deparam.querystring(href));
    return false;
  });

  $('#next_page').live('click', function () {
    var href = $(this).attr('href');
    $.bbq.pushState($.deparam.querystring(href));
    return false;
  });

  $('#pages .page a').live('click', function () {
    var href = $(this).attr('href');
    $.bbq.pushState($.deparam.querystring(href));
    return false;
  });

  $('#page-navigation .page-title a').live('click', function () {
    var href = $(this).attr('href');
    window.location.href = $.param.fragment(href.split('?')[0], $.deparam.querystring(href));
    return false;
  });

  $('#search-results .page-title a').live('click', function () {
    var href = $(this).attr('href');
    window.location.href = $.param.fragment(href.split('?')[0], $.deparam.querystring(href));
    return false;
  });

  $(window).bind('hashchange', function(e) {
    var href = $.param.querystring(window.location.href, $.param.fragment());
    $.getScript(href);
  });

  $(window).trigger('hashchange');

});

