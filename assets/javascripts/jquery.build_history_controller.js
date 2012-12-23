(function(jQuery) {
  jQuery.fn.buildHistoryController = function(options){
    function showBuildHistory(icon, text) {
      var target = jQuery("#build-history");
      target.html(text);
      target.css("top", icon.position().top + icon.height() + 5 + "px");
      target.css("left", icon.position().left + 2 + "px");
      target.fadeIn("normal");
    }

    var options = jQuery.extend({
      url: ''
    }, options);

    $("body").click(function() {
      if ( jQuery(this).parent("#build-history").length > 0 ) {
        return;
      }

      jQuery("#build-history").fadeOut("fast");
    });

    return this.each(function(i, elem) {
      jQuery(elem).click(function() {
        jQuery("#build-histroy").text("");
        jQuery("#build-history").hide();

        jobName = jQuery(this).attr("id").substring("build-history-".length);

        jQuery.ajax({
          type: "GET",
          url: options.url,
          data: "name=" + jobName,
          cache: false,
          success: function(data, dataType) {
            showBuildHistory(jQuery(elem), data);
          },
          error: function(request, status, ex) {
            showBuildHistory(jQuery(elem), "<span>Can't get build history. http-status: " + request.text_status) + "</span>";
          },
        });
      });
    });

  };
})(jQuery);
