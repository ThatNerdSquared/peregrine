from datetime import datetime
from pydantic import BaseModel, Field


class LogSchema(BaseModel):
    date: str = Field(
        default_factory=lambda: datetime.now().isoformat()
    )
    input: str
    encrypted: bool = False
    tags: list[str] = []
