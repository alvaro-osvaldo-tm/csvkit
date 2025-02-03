from io import TextIOBase

from typing_extensions import TextIO

from csvkit.infrastructure.proxy import StringToBinaryProxy
from csvkit.model.dataclasses import RequestOutputFile
from tests.utils import stderr_as_stdout


class OutputStreamFactory:

    @staticmethod
    def build(request:RequestOutputFile) -> TextIOBase:

        if request.filename is None:

            from sys import stdout

            if request.insertBom:
                return StringToBinaryProxy(
                    stream=stdout
                )

            return stdout

        if isinstance(request.filename, str):

            if request.insertBom:
                return StringToBinaryProxy(
                    stream=open(request.filename,'wb')
                )

            return open(request.filename,'wt')


        return request.filename


