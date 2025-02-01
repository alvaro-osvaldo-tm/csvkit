from dataclasses import dataclass

@dataclass
class RequestOutputFile:

    filename: str | object | None = None
    insertBom: bool = False
    encoding: str | None = None




