#!/bin/bash

DATA_DIR="/data"
mkdir -p $DATA_DIR

i=0

while true; do
  FILE="$DATA_DIR/file_$i.log"

  # Append data (disk usage)
  echo "$(date) - writing data $RANDOM" >> $FILE

  # Create many small files (inode exhaustion)
  touch "$DATA_DIR/inode_$i"

  # CPU spike (compression)
  gzip -c $FILE > "$FILE.gz"

  # Memory spike (stress tool)
  stress --vm 1 --vm-bytes 100M --timeout 5

  # Decompression spike
  gunzip -f "$FILE.gz"

  i=$((i+1))

  sleep 10
done
