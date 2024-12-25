#!/bin/env bash

find . -name '*.md' -exec grep -l '\.$jpg\|png\|webp$' {} \; | while read -r file; do
    sed -i 's/\.$jpg\|png\|webp$/.avif/g' "$file"
done
