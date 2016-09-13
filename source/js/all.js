"use strict";
$(document).ready(() => {
  $('.js-player').mediaelementplayer({
    success: function success(mediaElement, originalNode) {}
  });

  $('.js-fancybox').fancybox({
    helpers: {
      overlay: {
        locked: false
      },
      media: {}
    }
  });
});
