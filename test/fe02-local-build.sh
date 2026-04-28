#!/bin/bash
set -e

usage() {
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  -d, --desktop   Desktop environment: kde, cosmic (default: kde)"
    echo "  -g, --gaming    Enable gaming packages (default: false)"
    echo "  -h, --help      Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0"
    echo "  $0 --desktop cosmic"
    echo "  $0 --desktop kde --gaming"
}

DESKTOP_ENV="kde"
GAMING="false"

while [[ $# -gt 0 ]]; do
    case "$1" in
        -d|--desktop)
            DESKTOP_ENV="$2"
            shift 2
            ;;
        -g|--gaming)
            GAMING="true"
            shift
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        *)
            echo "Error: Unknown option '$1'"
            usage
            exit 1
            ;;
    esac
done

case "$DESKTOP_ENV" in
    kde)       BASE_IMAGE="kinoite" ;;
    cosmic)    BASE_IMAGE="cosmic-atomic" ;;
    *)
        echo "Error: Unknown desktop environment '$DESKTOP_ENV'. Must be one of: kde, cosmic"
        exit 1
        ;;
esac

TAG="fe02-os:${DESKTOP_ENV}${GAMING:+"-gaming"}"
if [[ "$GAMING" == "true" ]]; then
    TAG="fe02-os:${DESKTOP_ENV}-gaming"
fi

echo "Building Fe02-OS locally..."
echo "  Desktop : $DESKTOP_ENV (base image: $BASE_IMAGE)"
echo "  Gaming  : $GAMING"
echo "  Tag     : $TAG"
echo ""

podman build \
  --build-arg BASE_IMAGE_NAME="$BASE_IMAGE" \
  --build-arg DESKTOP_ENV="$DESKTOP_ENV" \
  --build-arg GAMING="$GAMING" \
  -t "$TAG" .

echo "Build completed successfully! Image tagged as: $TAG"