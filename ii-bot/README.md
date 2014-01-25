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
```
