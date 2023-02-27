import json
from peregrine.config import Config
from peregrine.types import OldSchemas
from pydantic import parse_obj_as


class Migrator():

    def __init__(self):
        self.SCHEMA_VERSIONS = {
            '1.0.0': self.v1_to_v2,
            '2.0.0': None
        }
        # I parse the log as a raw dict instead of using a LogSchema class
        # because we're not sure of whether the log format is up-to-date
        self.CURRENT_CONFIG = json.loads(Config.LOG_PATH.read_text())
        try:
            self.CURRENT_SCHEMA_VERSION = self.CURRENT_CONFIG['schema']
        except KeyError:
            self.CURRENT_SCHEMA_VERSION = '1.0.0'

        self.WORKING_CONF = parse_obj_as(
            OldSchemas.OLD_SCHEMA_TABLE[self.CURRENT_SCHEMA_VERSION],
            self.CURRENT_CONFIG
        )
        version_index = int(list(
            self.SCHEMA_VERSIONS.keys()
        ).index(self.CURRENT_SCHEMA_VERSION))
        for item in list(self.SCHEMA_VERSIONS.keys())[version_index:]:
            # item()
            print(item)

    def v1_to_v2(self):
        print('migrating from v1 to v2')
        # modify self.WORKING_CONF here
