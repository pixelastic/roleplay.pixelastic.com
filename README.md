# roleplay.pixelastic.com

Attempt at saving all the archives of all the roleplay games I played.

## Install dependencies

I made this website in 2017, and tried to update it in 2024. Even if I had some
`package.json` and `Gemfile` files, not all versions were locked, and it took me
some time to make it compile again.

Even if the dependencies versions themselves were pinned, the language (Ruby,
Node) and package managers (Bundler, Yarn) were not, so I tried to
reverse-engineer the latest working versions and pinned them in the repo.

### Ruby

```
# Install system dependencies
sudo apt-get install libyaml-dev

# Install ruby 
rbenv install 2.3.8

# Install bundler (it wasn't packaged with Ruby at that time)
gem install bundler:1.16.1

# Install local dependencies
bundle install

```

### Node

```
# First, we need to use python 2.7 to install node
pyenv install 2.7.18
pyenv global 2.7.18
eval "$(pyenv init -)"

# Install node v8.17.0 (latest version at time of creation)
nvm install 8.17.0

# Install yarn globally in that node version
npm install -g yarn@1.18.0




```
npm install
bundle install
npm run serve
```

And then open [http://127.0.0.1:4567/](http://127.0.0.1:4567/).

The website is built using Middleman.
