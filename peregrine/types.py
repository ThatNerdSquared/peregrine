from datetime import datetime
from pydantic import BaseModel, Field


# Always uses latest format
class LogSchema(BaseModel):
    date: str = Field(
        default_factory=lambda: datetime.now().isoformat()
    )
    input: str
    encrypted: bool = False
    tags: list[str] = []


class OldSchemas:
    # store old formats here for the migrator to load up, as well as a dict to
    # grab the right one

    class Schema_1_0(BaseModel):
        date: str = Field(
            default_factory=lambda: datetime.now().isoformat()
        )
        input: str
        encrypted: bool = False
        tags: list[str] = []

    OLD_SCHEMA_TABLE = {
        '1.0.0': Schema_1_0
    }
