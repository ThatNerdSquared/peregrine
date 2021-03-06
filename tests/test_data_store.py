import json
from peregrine import data_store
from peregrine.config import Config
from tests import helpers


def test_file_does_not_exist(monkeypatch, tmp_path):
    monkeypatch.setattr(Config, 'LOG_PATH', tmp_path / 'peregrinelog.json')
    assert not Config.LOG_PATH.exists()


def test_correct_return_if_file_not_found(monkeypatch, tmp_path):
    monkeypatch.setattr(Config, 'LOG_PATH', tmp_path / 'peregrinelog.json')
    assert not Config.LOG_PATH.exists()
    DS = data_store.DataStore()
    result = DS.read_data()
    assert result == []


def test_write_data_works_correctly(monkeypatch, tmp_path):
    monkeypatch.setattr(Config, 'LOG_PATH', tmp_path / 'peregrinelog.json')
    DS = data_store.DataStore()
    DS.write_data({'test': 42})
    result = json.loads(Config.LOG_PATH.read_text())
    assert result == {'test': 42}


def test_add_log_item_works_correctly(monkeypatch, tmp_path):
    monkeypatch.setattr(Config, 'LOG_PATH', tmp_path / 'peregrinelog.json')
    monkeypatch.setattr(data_store, 'datetime', helpers.FakeDatetime)
    DS = data_store.DataStore()
    DS.add_log_item('fake_input', helpers.FakeModel())
    result = json.loads(Config.LOG_PATH.read_text())
    assert result == [
        {'test': 42},
        {
            'date': 'fakeisoformat',
            'input': 'fake_input',
            'encrypted': False,
            'tags': []
        }
    ]
