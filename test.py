#!/usr/bin/env python3
# -*- coding: utf-8 -*

import codecs
from io import StringIO, BytesIO
from os import write
from sys import stdout
from locale import getencoding
from traceback import print_tb

coding = 'UTF-16'

coded = codecs.encode(
    '',coding
)


message = coded

writer = codecs.getwriter(
    coding
)

stream = BytesIO()

writer = writer(
    stream=stream
)

writer.write("Abobora")

stream.seek(0,0)

with open('test.txt','wb') as fp:
    fp.write(stream.read())


exit(0)
