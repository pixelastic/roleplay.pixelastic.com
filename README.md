# roleplay.pixelastic.com

This project is using both Brunch and Jekyll.

## Build process explained

Jekyll sources are in `app/jekyll` and gets built in `app/assets`. Brunch
listens to this dir and copy and change to `public`. It also listens for `css`
and `js` files changes in `app/styles` and `app/scripts` to send them in
`public`.

