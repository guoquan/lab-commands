#!/bin/bash

set -e

docker restart Lab-"$USER"-"$1"
