from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    db_username: str
    db_password: str
    db_host: str
    db_port: str
    db_name: str
    table_trip_name: str
    table_zones_name: str

    model_config = SettingsConfigDict(env_file=".env")