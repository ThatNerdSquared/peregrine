from pathlib import Path


class FakeModel:
    def __init__(self):
        super().__init__()
        self.entries = [{'test': 42}]


class FakeDatetime():
    def __init__(self):
        super().__init__()

    @staticmethod
    def now():
        return FakeDatetimeNow()


class FakeDatetimeNow():
    def __init__(self):
        super().__init__()

    def isoformat(self):
        return "fakeisoformat"


class FakeSys():
    def __init__(self):
        super().__init__()
        self._MEIPASS = "fakemeipass"


class FakePath():
    def __new__(cls, input):
        match input:
            case '.':
                return FakePathResolve()
            case _:
                return Path(input)


class FakePathResolve():
    def __init__(self):
        super().__init__()

    def resolve(self):
        return "fakecwd"
