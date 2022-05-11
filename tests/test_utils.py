from pathlib import Path
from peregrine import utils
from tests import helpers


def test_get_data_path_works_with_meipass(monkeypatch, tmp_path):
    monkeypatch.setattr(utils, 'sys', helpers.FakeSys())
    result = utils.get_data_file_path("fakefolder/fakefile")
    assert result == Path("fakemeipass", "fakefolder", "fakefile")


def test_get_data_path_works_without_meipass(monkeypatch, tmp_path):
    monkeypatch.setattr(utils, 'Path', helpers.FakePath)
    result = utils.get_data_file_path("fakefolder/fakefile")
    assert result == Path("fakecwd", "fakefolder", "fakefile")
