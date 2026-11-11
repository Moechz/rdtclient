#!/bin/sh
# TOS wrapper: the upstream image uses s6 as root (chown + su-exec) and binds
# through its own init. Run the unmodified .NET web app directly as uid 1000.
set -u
set -e
mkdir -p /data
export ASPNETCORE_URLS=http://0.0.0.0:6500
cd /app
exec dotnet RdtClient.Web.dll
