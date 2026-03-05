# Iurii's Personal Homelab

This repository contains my configuration for all my self-hosted services using Docker, curated and configured over the course of over two (dating back to late 2024, I think?). Reference this repo to build a few services of your own, and adjust them to your own liking!

## Why I Built It
I believe in retaining privacy ownership of my own files. Using Google or Apple services suites is quick and convenient, but users aren't guaranteed neither privacy nor reliable access, and your accounts can be shut down at any time. Read up on a [man whose Google account got permanently shut down](https://www.techspot.com/news/95729-google-refuses-reinstate-account-man-after-flagged-medical.html) because of AI's misidentification of medical photos.
By using these services, you become responsible for your hosting strategy, hardware, uptime, and most importantly, backups (you should have [backups](https://www.veeam.com/blog/321-backup-rule.html)).

Also, you don't need to make money from these services. So, your homelab is inherently ad-free.

And of course, setting up these services is quick, easy, and free ([*libre*, and *gratis*](https://en.wikipedia.org/wiki/Gratis_versus_libre)).

## Overview
Primarily, I access these services remotely over [Tailscale](https://tailscale.com/) so I don't have to be on the same LAN at any given time. These are all served by one desktop running [Fedora Linux](https://fedoraproject.org/) with [Docker Compose](https://docs.docker.com/compose/install) installed.

### Networking
[Caddy](https://caddyserver.com/): A reverse proxy for HTTPS
- Using a VPN like Tailscale already adds a layer of encryption, but this gets rid of HTTP/insecure webpage browser warnings.
- This also lets you, with your own web domain, set up nice URLs such as `https://homepage.iurii.io/` instead of `http://web-server:3000/`, so you don't have to remember ports your services run on.
- If you use Cloudflare as your domain's DNS, you can sign your certificates with `caddy-cloudflare` ([GitHub](https://github.com/caddy-dns/cloudflare))

[AdGuard Home](https://adguard.com/en/adguard-home/overview.html): DNS Resolver & Sinkhole ([GitHub](https://github.com/AdguardTeam/AdGuardHome/wiki/Docker))
- In conjunction with Caddy, a DNS resolver helps your computer know what IP address `homepage.iurii.io` is located at.
- Blocks ad-serving domains such as Google Adsense
- Blocks tracking domains, NSFW websites, and known malware websites for your entire household

[Tailscale](https://tailscale.com/): Tunneling VPN for remote access
- A homelab is even more awesome when you can use it outside your home
- Tailscale isn't self-hosted, but you can consider [Headscale](https://github.com/juanfont/headscale) if you prefer a local solution.
- Not a full VPN unless you set up one of your devices an 'exit node'
- Offers an awesome free tier of up to 100 devices

### Home Media Automation & Streaming
This stack of services is a whole rabbit hole too long to fully describe here, but certainly worth it for a complete home-theater streaming setup.

If you're interested in a full media stack, there is an awesome repo [here](https://github.com/Wh1rr/ultimate-jellyfin-stack) (though I haven't tested it)

*Only download media you have permission to use!*

[Qbittorrent](https://www.qbittorrent.org/): Torrenting client
- I use a system package to run a headless instance (`qbittorrent-nox`).
- You can add [this linuxserver.io image](https://github.com/linuxserver/docker-qbittorrent) to your `docker-compose.yml` if you prefer.

[Sonarr](https://sonarr.tv/): TV shows indexer ([GitHub](https://github.com/linuxserver/docker-sonarr))

[Radarr](https://radarr.video/): Movies indexer ([GitHub](https://github.com/linuxserver/docker-radarr))

[Lidarr](https://lidarr.audio/): Music indexer ([GitHub](https://github.com/linuxserver/docker-lidarr))
- I don't stream local music, but this solution works if you have a certain few artists/albums you listen to often

[Prowlarr](https://prowlarr.com/): Indexer manager ([GitHub](https://github.com/linuxserver/docker-prowlarr))

[Jellyfin](https://jellyfin.org/): Media Streaming server ([GitHub](https://github.com/linuxserver/docker-jellyfin))
- All your music, shows, and movie files you now have can be streamed here
- Works basically everywhere: Web, iOS, Android, Roku, Xbox, tvOS, iPadOS, Android TV...

### Personal Cloud
[Immich](https://immich.app/): Photo and Video Management
- Funded by FUTO & donations, this is one of the most complete self-hosted solutions I've seen.
- Demo available [here](https://demo.immich.app/auth/login)
- Lightweight but powerful
- GPU recommended for Smart Search, but not required. Fast searches once library is processed, even on a low-specced machine!
- Setup instructions [here](https://docs.immich.app/install/docker-compose/)

[Radicale](https://radicale.org/v3.html): Calendar, Tasks, and Contacts server ([GitHub](https://github.com/tomsquest/docker-radicale))
- CalDAV and CardDAV supported, can import other standard calendars into this one
- For Android, I use [DAVx5](https://www.davx5.com/) as the synchronization tool
- As clients, I use [Fossify calendar](https://github.com/FossifyOrg/Calendar), and [Tasks.org](https://tasks.org/fos). On desktop, I use [Mozilla Thunderbird](https://www.thunderbird.net/en-US/thunderbird/all/).

[Kiwix](https://kiwix.org/en/): Wiki(pedia) Hosting
- Demo available [here](https://library.kiwix.org/#lang=eng)
- World's knowledge, history, biographies, the fall of the Ottoman Empire, and Martial art forms, all on your hard drive
- Multi-platform: iOS, Windows, Linux, and Android clients
- The entirety of Wikipedia is currently 111GB, or 48GB without images

[Overleaf](https://www.overleaf.com/): LaTeX editor
- Edit LaTeX files on the web, with a visual editor available for simplicity.
- Linked above is the hosted version. Local version setup instructions are [here](https://github.com/overleaf/toolkit/)
- Unfortunately, the process is not a simple `docker-compose.yml` file and requires Overleaf's toolkit. However, their setup documentation is sufficient to get a community edition instance running. I left the directory out of this repo.

[Vaultwarden (BitWarden client)](https://www.vaultwarden.net/): Password manager ([GitHub](https://github.com/dani-garcia/vaultwarden))
- Passwords, one-Time codes (TOTP), SSH keys, notes, etc., it stores it all!
- Works with the official BitWarden apps and browser extensions.

[Syncthing](https://syncthing.net/): File Synchronization ([GitHub](https://github.com/syncthing/syncthing))
- One of my most used services, keeping the same copy of files across all my personal devices
- Synchronizes my phone's photos in seconds, enabling Immich to host the most up-to-date library
- Very configurable - file versioning, restoring, ignore patterns...
- I prefer to run this as a system service - simpler to set up!
- available on iOS too

### Observability & Monitoring
[Uptime Kuma](https://uptimekuma.org/): An easy-to-use uptime monitor ([GitHub](https://github.com/louislam/uptime-kuma))
- With all these services, you want to know if one of them goes down. Or your website. Or maybe your Smart Bread Toaster.
- Demo available [here](https://demo.kuma.pet/start-demo)
- Supports HTTP monitoring, device online status, docker container status, DNS, and more...

[Speedtest Tracker](https://docs.speedtest-tracker.dev/): Internet performance monitor ([GitHub](https://github.com/alexjustesen/speedtest-tracker))
- If you're curious on your download/upload or latency over time, this tool is handy for charts
- Supports [cronjobs](https://cronitor.io/guides/cron-jobs) for periodic, scheduled tests
- Connects Ookla's [speedtest.net](speedtest.net) servers for testing

[Ntfy](https://ntfy.sh/): Push notifications ([GitHub](https://github.com/binwiederhier/ntfy))
- Push notifications for Uptime Kuma (originally used Discord, but their [age verification policy](https://redact.dev/blog/discord-age-verification-clarification-what-they-arent-telling-you) is not cool.)
- Works on my android & web notifications. If I remember right, push notifications require SSL (achieved with Caddy), otherwise you're stuck with periodic polling.

### AI & Automation
[Ollama](https://ollama.com/): Open Models running locally ([GitHub](https://github.com/ollama/ollama))
- Many integrations supported: n8n, OpenClaw, Open WebUI, RAG...
- Honorable mentions: [LMstudio](https://lmstudio.ai/),
- Ollama/OpenWebUI [GitHub](https://github.com/open-webui/open-webui)
- Tried out [llama.cpp](https://github.com/ggml-org/llama.cpp), but later realized Ollama already uses llama.cpp as its inference engine, and also, Homeassistant cannot use it as an integration.

[FreshRSS](https://www.freshrss.org/): RSS news aggregator ([GitHub](https://github.com/FreshRSS/FreshRSS))
- In an attempt to escape from curated YouTube feeds, my goal is to migrate to channels' RSS feeds (yes, [YouTube has them](https://chuck.is/yt-rss/))
- As an Android client, I use [FeedMe](https://github.com/seazon/FeedMe/releases)

[Open WebUI](https://docs.openwebui.com/): Frontend Client for LLMs
- Very familiar interface from ChatGPT
- Supports reasoning tags, RAG, Web Search, code execution, chat history
- Integrates with Ollama to request model pulls from [ollama.com/models](ollama.com/models)

[n8n](https://n8n.io/): AI workflow automation
- Currently not in use in my setup...
- Free to get started, but requires a license and online account to operate...
- Integrates with Ollama for ✨Agentic AI✨, Discord/ntfy (etc.) for webhooks, logic/decision making blocks, and lots more functions

### Smart Home
[Home Assistant](https://www.home-assistant.io/): Home Automation
- How else can you possibly control your light bulbs... with a light switch?!
- Control lights, energy usage, set up automations with smart devices
- Both mobile apps & web interface available
- Android app includes a smart assistant
- Many [external integrations](https://www.home-assistant.io/integrations/?brands=featured)

[Piper](https://github.com/linuxserver/docker-piper) & [Whisper](https://github.com/linuxserver/docker-faster-whisper): Text-To-Speech and Speech-To-Text servers (respectively)
- Integrations for HomeAssistant to use your voice and hear responses back

### Homepage
[Homepage](https://gethomepage.dev/): A dashboard for your homelab ([GitHub](https://github.com/gethomepage/homepage))
- With so many services, you want some way to see all of them and their stats at a glance
- Monitoring stats and health of your docker containers
- Weather, search, system resource usage supported
- Bookmarks for frequently visited pages
- Customizable JS and CSS for a unique look!

## How To Get Started
Getting started requires some basic knowledge of `docker compose`. Read [this excellent official guide](https://docs.docker.com/compose/gettingstarted). You can also use [Docker Desktop](https://www.docker.com/products/docker-desktop/) for GUI management.

Clone this repo and their respective `docker-compose.yml` files. For the most part, the web interfaces will be available as specified in the compose file.

## Future Improvements & Honorable Mentions
Going forward, I'd like to configure Wireguard myself and remove dependency on Tailscale's servers to relay connections between my devices using Headscale.

Also, while I have sufficient uptime on just one desktop, I would like to set up a load balancer / high availability (HA) at some point in the future, such that if one server goes down, another one processes requests seamlessly.

## Maintenance
I run [rootless docker](https://docs.docker.com/engine/security/rootless/) for all my containers. You need to run the update script as sudo if you run rootful docker (the default installation).

Updating these services involves a docker compose command to pull any new versions and one to bring the new version up (except you, overleaf). This script will need interaction if overleaf needs an upgrade.

Note: services may introduce breaking changes at any time, so this can be risky to run! Read the release notes for your services or face the risk (like I do) if you prefer scripted updates instead of one-by-one. Run it with
> `./update.sh`

## Notes
**Give a star** to this repo if you found it helpful ❤️

Open an issue for any improvements I can make to this README or the homelab stack.

There are lots of links in this README to the official websites of these services. For the ones you find helpful, **support the authors** with donations!