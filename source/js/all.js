"use strict";
$(document).ready(() => {
  $('.js-player').mediaelementplayer({
    success: function success(mediaElement, originalNode) {}
  });

  let fancyboxes = $('.js-fancybox');
  if (fancyboxes) {
    fancyboxes.fancybox({
      helpers: {
        overlay: {
          locked: false
        },
        media: {}
      }
    });
  }
});
