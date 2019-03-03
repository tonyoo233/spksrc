#!/bin/sh

docker run -it --rm -v $(pwd):/spksrc synocommunity/spksrc /bin/bash

## example usage:
# cd spk/nano
# make arch-ipq806x-1.2
