#!/usr/bin/env bash

set -ex

function buildAndPush {
    local version=$1
    local imagename="alexswilliams/arm32v6-telegraf"
    local fromline=$(grep -e '^FROM ' Dockerfile | tail -n -1 | sed 's/^FROM[ \t]*//' | sed 's#.*/##' | sed 's/:/-/' | sed 's/#.*//' | sed -E 's/ +.*//')
    local latest="last-build"
    if [ "$2" == "latest" ]; then latest="latest"; fi

    docker buildx build \
        --platform=linux/arm/v6 \
        --build-arg VERSION=${version} \
        --build-arg BUILD_DATE=$(date -u +"%Y-%m-%dT%H:%M:%SZ") \
        --build-arg VCS_REF=$(git rev-parse --short HEAD) \
        --tag ${imagename}:${version} \
        --tag ${imagename}:${version}-${fromline} \
        --tag ${imagename}:${latest} \
        --push \
        --file Dockerfile .
}

# buildAndPush "1.11.0"
# buildAndPush "1.11.1"
# buildAndPush "1.11.2"
# buildAndPush "1.11.3"
# buildAndPush "1.11.4"
# buildAndPush "1.11.5"
# buildAndPush "1.12.0"
# buildAndPush "1.12.1"
# buildAndPush "1.12.2"
# buildAndPush "1.12.3"
# buildAndPush "1.12.4"
# buildAndPush "1.12.5"
# buildAndPush "1.12.6"
# buildAndPush "1.13.0"
buildAndPush "1.13.1"
buildAndPush "1.13.2"
buildAndPush "1.13.3"
buildAndPush "1.13.4"
buildAndPush "1.14.0"
buildAndPush "1.14.1" latest

curl -X POST "https://hooks.microbadger.com/images/alexswilliams/arm32v6-telegraf/Ne64Ci-WBl59zFoSY3QY7WpuDkk="
