# Changelog

All notable user-visible changes to the rdt-client TOS application package.

## 2.0.143-1 — 2026-11-19

### Changed
- Upstream image `rogerfar/rdtclient:2.0.143` (was `2.0.136`, upstream release of
  2026-10-18 — the CVE / component-refresh item T1).
- `auth` corrected to `rogerfar`; the package previously credited `linuxserver.io`, which
  does not maintain this image (item C9).
- `zh-cn`/`zh-hk` descriptions rewritten: they described a plain “torrent/magnet download
  client”. The app is a debrid download manager (Real-Debrid, AllDebrid, Premiumize,
  TorBox, DebridLink, HIGHWAY) with a qBittorrent-compatible API (items C6, C9).
- The English description now states what the app actually does and that a premium debrid
  account is required.
- `help` in `config.ini` now opens the privacy policy (items C3, C5).
- Wrapper: creates `/data/db` and `/data/downloads` and points `HOME` at the data volume,
  so nothing tries to write outside the mounted folder as uid 1000.

### Added
- `PRIVACY.md` (retention, user rights, security measures, third-party sharing, deletion
  channel), `NOTICE.md`, and README sections for privacy, third-party services, licence,
  first start, runtime files and architecture (items C2, C3, C4, C5, C7, C8, C10).

### Removed
- The 6 MB `TOSAppSelfTestingTool` binary is no longer tracked in the public repository.

## 2.0.136-2 — 2026-11-12

### Changed
- Icon: replaced the letter monogram with a functional vector mark that describes what the app does (the upstream project does not publish a compliant SVG).

## 2.0.136-1 — 2026-11-11

### Added
- First release. rdt-client (`rogerfar/rdtclient:2.0.136`, Docker Hub official image, unmodified)
  packaged as a TOS 7 Docker application, published on port 8076 and running
  as a non-root user (1000:1000).
- Persistent data is kept under `/Volume1/DockerAppData/rdtclientdocker/`.
