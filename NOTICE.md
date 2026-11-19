# NOTICE — third-party components and attributions

This package (`rdtclientdocker`, TOS 7 Docker application) is an independent packaging by
Moechz of the upstream **rdt-client** project.

## 1. Upstream application — rdt-client

- Project: <https://github.com/rogerfar/rdt-client>
- Licence: **MIT**
- Relationship: the upstream application is used **unmodified**, inside the container image.
  No upstream source code is redistributed in this package; the package only pulls the image
  from Docker Hub.

## 2. Container image — `rogerfar/rdtclient:2.0.143`

- Registry: Docker Hub (`rogerfar/rdtclient:2.0.143`)
- Maintainer: rogerfar
- The image is built by its maintainer from the .NET 10 ASP.NET runtime image plus an
  Alpine/s6 userland, and is pulled from Docker Hub at install time; it is not redistributed
  here.

## 3. Components inside the image

The image bundles the .NET 10 ASP.NET Core runtime and the application's own NuGet
dependencies, plus the Alpine userland of its base image. Their licences are documented in
the image's own package metadata and in the upstream repository; they are shipped inside the
image only and are not redistributed as separate files by this package.

## 4. This packaging

The files authored for this package — `docker-compose.yml`, `config.ini`,
`rdtclientdocker.lang`, `rdtclientdocker.svg`, `entrypoint.sh`, the build/verification
scripts and this documentation — are released under the **MIT** licence (see `LICENSE`).

Running the MIT-licensed application from its official image does not make this packaging a
derivative work of it; the packaging contains no upstream code.

## 5. Trademarks

“rdt-client”, “Real-Debrid”, “AllDebrid”, “Premiumize”, “TorBox”, “DebridLink”, “HIGHWAY”,
“TerraMaster” and “TOS” are trademarks or registered trademarks of their respective owners.
Their use here is descriptive only. This package is **not affiliated with, sponsored or
endorsed by** the upstream project, any debrid provider or TerraMaster.

## 6. Icon

The application icon in `src/rdtclientdocker.svg` is an original mark drawn for this package.
It does not reproduce the upstream logo or a real-debrid provider logo.

## 7. Contact

Moechz — moechz@163.com — <https://github.com/Moechz/rdtclient>
