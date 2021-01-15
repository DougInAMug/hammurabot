# hammurabot
A [mastodon bot](https://botsin.space/@hammurabot) which sequentially posts the laws of the [Code of Hammurabi](https://en.wikipedia.org/wiki/Code_of_Hammurabi) at a random time, daily.

![](images/hammurabi_profile.svg.png)

## Motivation
- [Historical fascination](https://www.jstor.org/stable/3141207)
- Homage to the whoever chiselled those rocks
- Interest in ancient governance (despite slavery and deep sexism, the _lex talionis_ and presumption of innocence indicate the Code may have been progressive for its time)
- Test tech skills, first mastodon bot

## Imagery
Avatar and header images are locally included in `images/`
- avatar image, a bust of Hammurabi, adapted from [this wikipedia image](https://li.wikipedia.org/wiki/Plaetje:Hammurabi_Face.jpg)
- header image, a section of the Code, is [this wikimedia image](https://commons.wikimedia.org/wiki/File:Code_of_Hammurabi_75.jpg)

## Text
Text is locally included in `codeOfHammurabi.txt`, sourced from [Yale Law School, The Avalon Project](https://avalon.law.yale.edu/ancient/hamframe.asp)

## 'Install'
```
# Clone this
git clone git@gitlab.com:DougInAMug/hammurabot.git

# Install the only dependency, [toot](https://toot.readthedocs.io/en/latest/) E.g.:
sudo apt install toot

# Login to target account with toot
toot login <your-account-url>

# Add cron job: 0 0 * * * cd <your-path-to>/hammurabot && bash hammurabot.sh
crontab -e

```
