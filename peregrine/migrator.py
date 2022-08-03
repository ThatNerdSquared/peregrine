from peregrine.data_store import DataStore


class Migrator():

    def __init__(self):
        self.SCHEMA_VERSIONS = {
            '1.0.0': self.v1_to_v2,
            '2.0.0': None
        }
        self.CURRENT_CONFIG = DataStore().read_data()
        try:
            self.CURRENT_SCHEMA_VERSION = self.CURRENT_CONFIG['schema']
        except KeyError:
            self.CURRENT_SCHEMA_VERSION = '1.0.0'

        version_index = int(list(
            self.SCHEMA_VERSIONS.keys()
        ).index(self.CURRENT_SCHEMA_VERSION))
        for item in list(self.SCHEMA_VERSIONS.keys())[version_index:]:
            print(item)

    def v1_to_v2(self):
        print('migrating from v1 to v2')
