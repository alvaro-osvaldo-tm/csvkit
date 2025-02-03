from argparse import ArgumentParser, Namespace
from io import TextIOWrapper, BytesIO


class AddBOM:

    @staticmethod
    def _get_BOM(encoding: str) -> bytes:

        if encoding == "UTF-8" or encoding == "ANSI":
            from codecs import BOM_UTF8

            return BOM_UTF8

        from codecs import getwriter

        stream = BytesIO()
        writer = getwriter(encoding)

        writer = writer(stream=stream)
        writer.write("")

        stream.seek(0, 0)
        BOM = stream.read1()

        return BOM

    @staticmethod
    def argument(argparser: ArgumentParser):

        argparser.add_argument(
            "--add-bom",
            dest="add_bom",
            action="store_true",
            default=False,
            help="Add the byte order mark to the output",
        )

    @staticmethod
    def run(
        output: TextIOWrapper,
        encoding: str | None = None,
        arguments: Namespace | None = None,
    ):

        if isinstance(arguments, Namespace) and (
            not "add_bom" in arguments and arguments.add_bom
        ):
            return

        from locale import getencoding

        BOM = AddBOM._get_BOM(encoding or getencoding())
        output.buffer.write(BOM)
        output.buffer.flush()
