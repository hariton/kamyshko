/* based on bezoom */
(function($) {
  $.fn.zoom = function(options){

    var settings = {
      identifier: 'lens',
      zoomWidth: 200,
      zoomHeight: 200,
      xOffset: 0,
      imgSource: 'href',
    };
    options = options || {};
    $.extend(settings, options);

    this.each( function(i){

      var imgBig = $(this).attr(settings.imgSource);
      var img = $(this).find('img');
      var offset = img.offset();

      $(this).click( function(e){

        if ( e.button == 1 ) {

          var imgSmallHeight = img.height();
          var imgSmallWidth = img.width();

          if (settings.zoomHeight == 'auto') {
            settings.zoomHeight = imgSmallHeight;
          };

          if (zoomShowFlag) {
            $('#' + settings.identifier).remove();
            zoomShowFlag = false;
          } else {
            $('body')
              .append($(document.createElement('div'))
                  .attr('id', settings.identifier)
                  .css({
                    position: 'absolute',
                    'z-index': 5000,
                    top: offset.top,
                    left: settings.xOffset,
                    width: settings.zoomWidth,
                    background: 'white' })
                .append($(document.createElement('div'))
                    .css({
                      width: settings.zoomWidth,
                      height: settings.zoomHeight,
                      overflow: 'hidden',
                      position: 'relative'})
                  .append($(document.createElement('img'))
                      .attr('id', settings.identifier + '_img')
                      .attr('src', imgBig)
                      .css({
                        position: 'relative' })
                  )
                )
            );
            zoomShowFlag = true;
          };

          return false;
        };

      } ).mouseleave(function(){
        $('#' + settings.identifier).remove();
        zoomShowFlag = false;
      } );

      $(this).mousemove( function(e){

        var imgSmallHeight = img.height();
        var imgSmallWidth = img.width();

        if (settings.zoomHeight == 'auto') {
          settings.zoomHeight = imgSmallHeight;
        };

        var imgBigWidth = $('#' + settings.identifier + '_img').width();
        var imgBigHeight = $('#' + settings.identifier + '_img').height();
        var widthRel = imgSmallWidth / imgBigWidth;
        var heightRel = imgSmallHeight / imgBigHeight;

        var mouseX = e.pageX - offset.left;
        var mouseY = e.pageY - offset.top;

        var imgBigX = Math.ceil((mouseX / widthRel) - (settings.zoomWidth / 2)) * (-1);
        imgBigX = Math.max((-1 * imgBigWidth) + settings.zoomWidth, imgBigX);
        imgBigX = Math.min(0, imgBigX);

        var imgBigY = Math.ceil((mouseY / heightRel) - settings.zoomHeight * 0.5) * (-1);
        imgBigY = Math.min(0, imgBigY);
        imgBigY = Math.max((-1 * imgBigHeight) + settings.zoomHeight, imgBigY);

        $('#' + settings.identifier + '_img').css('left', imgBigX);
        $('#' + settings.identifier + '_img').css('top', imgBigY);

      } );
    } );

    return this;
  };
})(jQuery);
