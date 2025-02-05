from argparse import ArgumentParser, Namespace
from io import TextIOWrapper, BytesIO
from typing import Union


class AddBOM:

    @staticmethod
    def _get_BOM(encoding: str) -> bytes:

        encoding = encoding.upper()

        if encoding == "UTF-8" or encoding == "ANSI":
            from codecs import BOM_UTF8
            return BOM_UTF8

        if encoding == "UTF-16" or encoding == "UTF-16-BE":
            from codecs import BOM_UTF16_BE
            return BOM_UTF16_BE

        if encoding == "UTF-16-LE":
            from codecs import BOM_UTF16_LE
            return BOM_UTF16_LE

        raise TypeError(f"BOM for '{encoding}' is not supported")


    @staticmethod
    def enabled(arguments: Union[Namespace, None] = None) -> bool:

        if isinstance(arguments, Namespace):
            return "add_bom" in arguments and arguments.add_bom

        return True

    @staticmethod
    def argument(argparser: ArgumentParser):

        argparser.add_argument(
            "--add-bom",
            dest="add_bom",
            action="store_true",
            default=False,
            help="Add Byte Order Mark (BOM) to the output",
        )

    @staticmethod
    def run(
        output: TextIOWrapper,
        arguments: Union [ Namespace , None ] = None,
    ):

        if not AddBOM.enabled(arguments):
            return

        BOM = AddBOM._get_BOM(output.encoding)
        output.buffer.write(BOM)
