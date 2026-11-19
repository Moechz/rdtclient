# rdtclient-for-tos

> TerraMaster TOS 7 App Center — **Docker application** package for
> [rdt-client](https://github.com/rogerfar/rdt-client).

## What this is

A four-file TOS Docker application archive (`rdtclientdocker.tar.gz`) that installs
rdt-client on TOS 7 through the App Center:

- `config.ini` — TOS application metadata (`application_type: docker`, id `rdtclientdocker`)
- `rdtclientdocker.lang` — 23-language superset (TOS requires 14)
- `rdtclientdocker.svg` — application icon (424 bytes, pure vector)
- `docker-compose.yml` — one service, image `rogerfar/rdtclient:2.0.143`

## How it works

| | |
|---|---|
| Container image | `rogerfar/rdtclient:2.0.143` (Docker Hub, used unmodified) |
| Open | `http://<NAS-IP>:8076/` (container port 6500) |
| Runs as | non-root, `user: "1000:1000"` |
| Persistent data | `/data` → `/Volume1/DockerAppData/rdtclientdocker/data` |
| Logs | `docker logs rdtclientdocker` and `/Volume1/DockerAppData/rdtclientdocker/data/db/rdtclient.log` |
| Health check | `GET /` on container port 6500 |

## First start

Open `http://<NAS-IP>:8076/`, choose your **debrid provider** (Real-Debrid, AllDebrid,
Premiumize, TorBox, DebridLink or HIGHWAY) and paste the provider's **API token**. The app
needs a premium debrid account; it does not download from BitTorrent itself, it asks the
provider to fetch the magnet/torrent/NZB and then downloads the files the provider returns.

Downloads land in `/Volume1/DockerAppData/rdtclientdocker/data/downloads`. Change the path in
Settings if you like, but **keep it under the data folder** — that folder is the only path
that survives a container restart or an app update. Sonarr, Radarr or Couchpotato can be
pointed at the emulated qBittorrent API on port 6500.

## Third-party services (API disclosure)

The developer operates no server in this path and receives no data. The application contacts
only the provider and services **you configure**, plus its own update check and the Docker
registry.

| Service | Endpoint | Data sent | Destination / region |
|---|---|---|---|
| The debrid provider you configure | its REST API, e.g. `api.real-debrid.com`, `api.alldebrid.com`, `www.premiumize.me`, `api.torbox.app`, `api.debrid-link.fr`, `high-way.me` | your API token, the magnet/torrent/NZB you add (hashes, file names), the file selection, the download request | the provider's servers (EU/US, per that provider's policy) |
| The same provider's download hosts | the links returned for each file | your own download's file transfer | the provider's CDN/servers |
| A `.torrent`/NZB URL you paste | that address | the file request | wherever that URL points |
| Update check | `api.github.com` (`/repos/rogerfar/rdt-client/tags`) | the request itself; no user data, no identifier | GitHub, US |
| qBittorrent API emulation / WebDAV | inbound on your own port | operations from Sonarr/Radarr/Couchpotato or your player | your own LAN |
| Image pull at install | `registry-1.docker.io` or your registry mirror | anonymous pull | Docker Hub, US / your mirror |

There is no telemetry, no analytics and no advertising SDK. See `PRIVACY.md` §6 for the same
table with more detail.

## Privacy

The application runs entirely on your NAS and the developer has no access to its data. The
full policy — retention period, user rights (access/export, correction, deletion), security
measures, third-party sharing and the deletion channel — is in [PRIVACY.md](PRIVACY.md). The
package's `help` field opens that policy directly from the App Center entry
(`config.ini` → `help`), and the website version at
<https://www.moechz.com/privacy.html> (section 6) covers all applications by this developer.

| Topic | Detail |
|---|---|
| Data processed | Settings incl. the provider API token, the download list, downloaded files, logs |
| Where | `/Volume1/DockerAppData/rdtclientdocker/data` on your NAS |
| Retention | Until **you** delete it; logs are 5 × 5 MB files; no automatic expiry, no upload |
| Rights | Copy the data folder (export), edit in the web UI (correct), uninstall with “delete data” or remove the folder (delete) |
| Deletion channel | The data folder, or moechz@163.com (answered within 30 days) |

## Licence and attributions

| Component | Licence | Notes |
|---|---|---|
| rdt-client | MIT | upstream application, used unmodified inside the image |
| Container image `rogerfar/rdtclient:2.0.143` | MIT | pulled from Docker Hub at install time |
| This packaging | MIT (see `LICENSE`) | compose file, metadata, translations, icon, wrapper |

“rdt-client”, the debrid provider names, “TerraMaster” and “TOS” are trademarks of their
respective owners. This is an independent community package by Moechz and is not affiliated
with the upstream project, any debrid provider or TerraMaster. Full details:
[NOTICE.md](NOTICE.md).

## Design highlights

- **Non-root by construction.** `user: "1000:1000"`. The image is built to start as root
  (`/init` from s6, then `su-exec`), which TOS does not allow, so the compose file replaces
  the entrypoint with `src/entrypoint.sh`: it creates the data folders, sets
  `ASPNETCORE_URLS=http://0.0.0.0:6500` and `HOME=/data`, then runs the unmodified .NET app
  (`dotnet RdtClient.Web.dll`) directly as uid 1000.
- **Fixed image tag, never `:latest`**, Docker Hub only, no `privileged`, no
  `network_mode: host`, no Docker socket, no `cap_add`.
- **Health check** on the UI itself (`GET /` on 6500) with a 30 s start period.
- **Deterministic build**: GNU tar with uid/gid 0 and zeroed timestamps, gzip without a
  timestamp, plus the review-standards self-check.

## Runtime file manifest

Everything the application writes on the NAS lives inside its own data directory; the
container-internal `/tmp` is discarded with the container. Nothing else is written.

| Path | Purpose | Created when | Growth bound | Lifecycle |
|---|---|---|---|---|
| `data/db/rdtclient.db` | settings, provider API token, download list (SQLite) | first start | grows with the download history | never overwritten; back it up |
| `data/db/rdtclient.log` | application log | first start | 5 files × 5 MB, rotated by the app | safe to delete |
| `data/downloads` | files fetched from the debrid provider | first download | bounded by what you download | managed by you |
| `/Volume1/DockerAppData/rdtclientdocker/data` | everything the container writes outside /tmp | on first start / on demand | bounded by your own data | persistent; kept on uninstall unless you ask to delete it |

## Architectures

The TOS store takes one package per architecture. This release provides both, built from the
same sources by `scripts/build-dual.sh`:

| Architecture | Package | Size | SHA-256 |
|---|---|---|---|
| x86_64 | `rdtclientdocker_x86_64.tar.gz` | 4553 B | `c2d1bf1d5b2a610bb7e5041ba198e867a278908b3f02f7ef1d68731f53271ad2` |
| aarch64 | `rdtclientdocker_aarch64.tar.gz` | 4554 B | `08babf81d748bd4c6482b605520b3ebd4b77bfea9b3b1a32d95b812628a01270` |

Both packages pass the official `TOSAppSelfTestingTool -c` check and the package's own
`tools/verify.py`. The on-device E2E was run for `2.0.136-1`; the `2.0.143` image bump is
pending a fresh on-device run (Docker applications have to be installed with the official
tool's `-i` mode, not through the App Center install page).

## Build

```bash
scripts/build-dual.sh 2.0.143-1   # both architectures + official check
scripts/build.sh 2.0.143-1 x86_64 # one architecture
scripts/build.sh                  # current version from tosapp.json
```

The build stages the four files, substitutes the version/platform placeholders, embeds
`src/entrypoint.sh` into the compose `command:` (escaping every `$` as `$$`), removes
CRLF/BOM/AppleDouble, then runs `tools/verify.py`, a review-standards self-check (archive
layout, JSON validity, required fields, 14+ language coverage, version consistency,
Docker-Hub-only images, fixed tag, reserved/recommended host ports, non-root user,
per-service healthcheck/TZ/restart, data path below the application data root, never the
`/Volume*` wildcard, comment-free sequence blocks, `x-app-meta` position, no literal secrets,
the embedded wrapper matching `src/entrypoint.sh`, and the SVG size/element limits).

## Local verification

```bash
./TOSAppSelfTestingTool -c out/rdtclientdocker_x86_64.tar.gz   # official spec check
./TOSAppSelfTestingTool -i out/rdtclientdocker_x86_64.tar.gz   # install on this machine
bash test/install-and-verify.sh                                # on-device E2E (needs root)
```

> Docker applications cannot be side-loaded through the App Center's manual install page (it
> accepts `.deb` only); the official self-testing tool's `-i` mode or `docker compose` are the
> only ways to install one for testing.

## Store submission checklist

1. Public GitHub repo (code + README + PRIVACY + NOTICE + LICENSE; internal docs and build
   products are ignored).
2. Release **tag `v2.0.143-1`** with four assets: `rdtclientdocker_x86_64.tar.gz` + `.sha256`
   and `rdtclientdocker_aarch64.tar.gz` + `.sha256` (one archive per architecture,
   architecture suffix in the file name).
3. Developer platform: one App record per architecture (`x86_64`, `aarch64`), package type
   Docker, repository URL, version `2.0.143-1`.
4. When resubmitting after a review, put the item-by-item reply in the submission remarks.

## Limitations

- A **premium debrid account** is required; the app bundles no provider subscription and no
  BitTorrent client of its own.
- The emulated qBittorrent API is what Sonarr/Radarr/Couchpotato talk to; it is not a full
  qBittorrent.
- Downloads must stay under `/Volume1/DockerAppData/rdtclientdocker/data` to survive a
  reinstall — Docker applications cannot mount NAS shared folders by default.
- The web UI is plain HTTP on the LAN. Put it behind a TLS reverse proxy before exposing it
  to the internet.
- Docker applications cannot be upgraded in place in the App Center: updating means
  uninstalling and reinstalling, which keeps the data folder.

## Support

- Issues and questions: <https://github.com/Moechz/rdtclient/issues>
- Email: moechz@163.com
- Privacy: [PRIVACY.md](PRIVACY.md) · Licence: [NOTICE.md](NOTICE.md)

---

Packaged for TOS 7 by Moechz. Upstream image used unmodified from Docker Hub.
