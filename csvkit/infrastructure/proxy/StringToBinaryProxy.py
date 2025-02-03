from io import IOBase,TextIOWrapper

class StringToBinaryProxy(IOBase):

    def __init__(self,stream:TextIOWrapper):
        self._stream = stream


    def write(self, s, length=None):


        if isinstance(s,bytes):
            self._stream.buffer.write(s)
            return

        self._stream.write(s)