from peregrine.data_store import DataStore


class Migrator():

    def __init__(self):
        self.SCHEMA_VERSIONS = {
            '1.0.0': self.migrateFromV1ToV2,
            '2.0.0': None
        }
        self.CURRENT_CONFIG = DataStore().read_data()
        try:
            self.CURRENT_SCHEMA_VERSION = self.CURRENT_CONFIG['schema']
        except KeyError:
            self.CURRENT_SCHEMA_VERSION = '1.0.0'

        version_index = list(self.SCHEMA_VERSIONS.keys()).index(self.CURRENT_SCHEMA_VERSION)
        for item in list(self.SCHEMA_VERSIONS[version_index:]):
            item

