# NewsBot

A News Digest Bot For Facebook Messenger

## Install

```
git clone git@github.com:imthatcarlos/newsbot.git
cd newsbot
bundle install
bundle exec rake db:create db:migrate db:seed
```

* Seeding is important because it creates sources that correspond to NewsAPI publications.

## Configure
You'll have to create a Facebook page and app. Check out my configuration article<a href="http://bit.ly/2jBRPYO" target="_blank">here</a>.