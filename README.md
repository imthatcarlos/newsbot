# NewsBot

A News Digest Bot For Facebook Messenger

## Install

```
git clone git@github.com:imthatcarlos/newsbot.git
cd newsbot
bundle install
bundle exec rake db:create db:migrate db:seed
```

* Seeding is important becuase it creates sources that correspond to NewsAPI publications.

## Configure

```
You'll have to have Facebook page and app set up. See article: http://bit.ly/2fwWFrU
```

Now you can message your bot.