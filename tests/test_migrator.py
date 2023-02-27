# import json
import pytest
from unittest.mock import MagicMock
from peregrine.migrator import Migrator
from peregrine.config import Config
from pathlib import Path


@pytest.mark.skip
def test_migrator_init(monkeypatch, tmp_path):
    mock_v1_to_v2 = MagicMock()
    monkeypatch.setattr(Migrator, "v1_to_v2", mock_v1_to_v2)
    monkeypatch.setattr(Config, "APPDATA_PATH", Path(tmp_path))
    monkeypatch.setattr(
        Config,
        "SETTINGS_PATH",
        Path(tmp_path) / "peregrinelog.json"
    )
    Config.SETTINGS_PATH.write_text(
        # json.dumps(helpers.data['filled_config'])
    )

    Migrator()

    # backup_path = Config.APPDATA_PATH / "peregrinelog-0.5.0.old"
    # assert json.loads(
    #    backup_path.read_text()
    # ) == helpers.data['filled_config']
    mock_v1_to_v2.assert_called_once()
