# Privacy Policy — rdt-client for TerraMaster TOS (`rdtclientdocker`)

**Last updated:** 19 November 2026
**Data controller / contact:** Moechz — moechz@163.com

This policy covers the TOS application `rdtclientdocker` (the “app”) and its packaging.
The app runs the official `rogerfar/rdtclient` container image, unmodified, on your own
NAS.

## 1. Summary

- The app runs **entirely on your NAS**. The developer does not receive, collect or have
  access to your data, and operates no server that the app talks to.
- No telemetry, no analytics, no advertising, no account with the developer.
- The app contacts the **debrid provider you configure** and, once a day, GitHub for its
  update check; nothing else leaves your NAS apart from the Docker image pull at install
  time.

## 2. What data is processed

| Container path | Stored on the NAS at |
|---|---|
| `/data` | `/Volume1/DockerAppData/rdtclientdocker/data` |

That folder holds the application's own state, written by rdt-client:

- the settings, **including the API token of the debrid provider you configure**, download
  path, qBittorrent-API and WebDAV settings (`/data/db/rdtclient.db`, a SQLite database);
- the list of torrents, magnets and NZB downloads you add, their hashes, status, and the
  file lists returned by the provider;
- the downloaded files themselves (`/data/downloads` by default, configurable in Settings);
- log files (`/data/db/rdtclient.log`, rotated: 5 files of at most 5 MB each). Logs contain
  torrent names/hashes and provider responses, not your provider password.

## 3. Retention period

- **Application data and downloads:** kept until **you** delete them. There is no automatic
  expiry and no upload to the developer. Uninstalling the app keeps the folder unless you
  tick “delete data”.
- **Logs:** 5 rolling files of at most 5 MB each, inside `/data/db/`; delete them at any
  time.
- **Completed items:** the app removes finished torrent records according to the settings
  you choose; the downloaded files stay until you delete them.

## 4. Your rights and the deletion channel

| Right | How |
|---|---|
| Access / export | Copy the folder `/Volume1/DockerAppData/rdtclientdocker/data` — it is the complete state of the app. |
| Correct | Change providers, tokens, paths and download items in the app's own web UI. |
| Delete | Uninstall the app with “delete data”, or stop the container and remove `/Volume1/DockerAppData/rdtclientdocker/`. |
| Assistance | Email **moechz@163.com** with the subject “rdt-client data request”; a reply follows within 30 days. |

The developer holds no copy of your data, so deletion is normally completed by removing the
folder on your own NAS. The e-mail channel exists for questions and for requests about the
website or the publishing records.

## 5. Security measures

- The container runs as **uid 1000**, never root; no `privileged`, no `cap_add`, no host
  network, no Docker socket, and only its own data folder mounted.
- Only one port is published (`8076` on the NAS → `6500` in the container).
- The image tag is **pinned** (`rogerfar/rdtclient:2.0.143`); the package is rebuilt when
  upstream ships fixes.
- The data folder, including the provider API token in the database, is owned by the
  application user. It is only as safe as your NAS: anyone who can read
  `/Volume1/DockerAppData/rdtclientdocker/` can read that token. Keep the folder out of
  shared folders and off backups you do not control.
- The web UI is served over **plain HTTP on your LAN**. Put it behind a TLS reverse proxy
  before exposing it to the internet.

## 6. Third-party sharing and API disclosure

The developer shares nothing and receives nothing. The app contacts only the endpoints
below, and only for the provider and features **you** configure.

| Service | Endpoint | Data sent | Destination / region |
|---|---|---|---|
| The debrid provider you configure (one of Real-Debrid, AllDebrid, Premiumize, TorBox, DebridLink, HIGHWAY) | its REST API, e.g. `api.real-debrid.com`, `api.alldebrid.com`, `www.premiumize.me`, `api.torbox.app`, `api.debrid-link.fr`, `high-way.me` | your API token, the magnet/torrent/NZB you added (hashes and file names), the file selection you ask for, and the download request | the provider's servers (EU/US, per that provider's policy) |
| The same provider's download hosts | the links the provider returns for each file | the file transfer of your own download | the provider's CDN/servers |
| A `.torrent`/NZB URL you paste | that address | the file request | wherever that URL points |
| Update check | `api.github.com` (`/repos/rogerfar/rdt-client/tags`) | the request itself; no user data, no identifier | GitHub, US |
| qBittorrent API emulation / WebDAV | inbound, on your own port | the operations from Sonarr/Radarr/Couchpotato or your player | your own LAN |
| Image pull at install | `registry-1.docker.io` or your registry mirror | anonymous pull | Docker Hub, US / your mirror |

There is no telemetry, no analytics and no advertising SDK. The app does not send your
downloads, file names or provider token anywhere except to the provider you chose.

## 7. Children

The app is a self-hosted download manager and is not directed at children.

## 8. Changes

Material changes are published in this file and reflected in the “Last updated” date.

## 9. Contact

- Moechz — **moechz@163.com**
- Package repository and issues: <https://github.com/Moechz/rdtclient>
- Website privacy page: <https://www.moechz.com/privacy.html>
- Upstream project: <https://github.com/rogerfar/rdt-client>
