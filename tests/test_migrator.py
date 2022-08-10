import json
import pytest
from unittest.mock import MagicMock
from peregrine.migrator import Migrator
from peregrine.config import Config
from pathlib import Path

@pytest.mark.skip
def test_migrator_init(monkeypatch, tmp_path):
    mock_road_to_v1 = MagicMock()
    monkeypatch.setattr(Migrator, "road_to_v1", mock_road_to_v1)
    monkeypatch.setattr(Config, "APPDATA_PATH", Path(tmp_path))
    monkeypatch.setattr(
        Config,
        "SETTINGS_PATH",
        Path(tmp_path) / "lentosettings.json"
    )
    Config.SETTINGS_PATH.write_text(
        json.dumps(helpers.data['filled_config'])
    )

    Migrator()

    backup_path = Config.APPDATA_PATH / "lentosettings-0.5.0.old"
    assert json.loads(backup_path.read_text()) == helpers.data['filled_config']
    mock_road_to_v1.assert_called_once()
