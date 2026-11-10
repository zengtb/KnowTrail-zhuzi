"""Repository text is UTF-8. Do not follow the Windows ANSI default."""

import pathlib
import sys

if sys.version_info < (3, 9):
    raise SystemExit("需要 Python 3.9+")


def read_text(self, encoding="utf-8", errors=None):
    with self.open(mode="r", encoding=encoding, errors=errors) as stream:
        return stream.read()


def write_text(self, data, encoding="utf-8", errors=None, newline=None):
    if not isinstance(data, str):
        raise TypeError("data must be str, not %s" % data.__class__.__name__)
    with self.open(mode="w", encoding=encoding, errors=errors, newline=newline) as stream:
        return stream.write(data)


pathlib.Path.read_text = read_text
pathlib.Path.write_text = write_text
