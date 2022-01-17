import os
import json
from peregrine.add_item import add_log_item
# from peregrine.config import Config


def test_file_does_not_exist_initially(monkeypatch, tmp_path):
    # monkeypatch.setattr(Config, 'LOG_PATH', tmp_path)
    # path = os.path.join(Config.LOG_PATH, 'peregrinelog.json')
    monkeypatch.setattr(os.path, 'expanduser', lambda x: tmp_path)
    path = os.path.join(os.path.expanduser('~'), 'peregrinelog.json')
    assert not os.path.exists(path)


def test_file_creates_if_not_exist(monkeypatch, tmp_path):
    # monkeypatch.setattr(Config, 'LOG_PATH', tmp_path)
    # path = os.path.join(Config.LOG_PATH, 'peregrinelog.json')
    monkeypatch.setattr(os.path, 'expanduser', lambda x: tmp_path)
    path = os.path.join(os.path.expanduser('~'), 'peregrinelog.json')
    add_log_item('test_string')
    assert os.path.exists(path)


def test_file_creates_with_correct_data(monkeypatch, tmp_path):
    # monkeypatch.setattr(Config, 'LOG_PATH', tmp_path)
    # path = os.path.join(Config.LOG_PATH, 'peregrinelog.json')
    monkeypatch.setattr(os.path, 'expanduser', lambda x: tmp_path)
    path = os.path.join(os.path.expanduser('~'), 'peregrinelog.json')
    add_log_item('test string')

    with open(path, 'r', encoding='UTF-8') as log_file:
        entries = json.load(log_file)

    # Ideally we'd test the full entries array against a mock one
    # but the date value ends up being a bit off.
    assert entries[0]['input'] == 'test string'
