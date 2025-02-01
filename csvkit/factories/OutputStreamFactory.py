from typing_extensions import TextIO

from csvkit.model.dataclasses import RequestOutputFile


class OutputStreamFactory:

    @staticmethod
    def build(request:RequestOutputFile) -> TextIO:

        if request.filename is None:
            from sys import stdout
            return stdout

        return request.filename


