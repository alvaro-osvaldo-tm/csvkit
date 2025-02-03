from io import TextIOWrapper, BytesIO


class AddBOM:

    @staticmethod
    def _getBOM(encoding:str) -> bytes:

        if encoding == 'UTF-8' or encoding == 'ANSI':
            from codecs import BOM_UTF8
            return BOM_UTF8

        from codecs import getwriter

        stream = BytesIO()
        writer = getwriter(encoding)

        writer = writer(stream=stream)
        writer.write('')

        stream.seek(0, 0)
        BOM = stream.read1()

        return BOM


    @staticmethod
    def add(output:TextIOWrapper,encoding:str|None=None):

        from locale import getencoding

        BOM = AddBOM._getBOM(encoding or getencoding() )
        output.buffer.write(BOM)
        output.buffer.flush()






