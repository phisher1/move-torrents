#!/usr/bin/python

import libtorrent as lt
import sys

ti = lt.torrent_info(sys.argv[1])
if ti.num_files() > 1:
    print(ti.name())
