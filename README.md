ii-bot
======

Salt stack formula to deploy an IRC bot based on ii and a combinaison of small tools.

Example pillar
==============

```yaml
ii-bots:
  bot_name:
    servers:
      irc.freenode.net:
        chans:
          - chan1
          - chan2
        rss:
          some_unique_name:
            url: http://www.example.com/rss.xml
            chan: chan1
        twitter_search:
          some_unique_name:
            query: chocolate OR icecream
            chan: chan2
        twitter:
          some_unique_name_like_the_account_one:
            oauth_access_token: <the stuff given by twitter, use ii-twitter-register cli to have it>
            oauth_access_secret: <same>
            chans:
              - chan1
              - chan2
```

Note: everytime you see "some_unique_name*" this mean that you can put as many key as you want.
