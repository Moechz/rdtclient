# Changelog

All notable user-visible changes to the rdt-client TOS application package.

## 2.0.136-2 — 2026-11-12

### Changed
- Icon: replaced the letter monogram with a functional vector mark that describes what the app does (the upstream project does not publish a compliant SVG).

## 2.0.136-1 — 2026-11-11

### Added
- First release. rdt-client (`rogerfar/rdtclient:2.0.136`, Docker Hub official image, unmodified)
  packaged as a TOS 7 Docker application, published on port 8076 and running
  as a non-root user (1000:1000).
- Persistent data is kept under `/Volume1/DockerAppData/rdtclientdocker/`.
