// Fancybox
$('.c-session--content img').each((index, element) => {
  const $img = $(element);
  const url = $img.attr('src');
  $(element).wrap(
    `<a class="js-fancybox" href="${url}" rel="pictures-in-text">`
  );
});
$('.js-fancybox').fancybox({
  helpers: {
    overlay: {
      locked: false,
    },
  },
});

$('.js-player').mediaelementplayer();
