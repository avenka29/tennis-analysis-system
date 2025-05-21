from dotenv import load_dotenv
import os
import pandas as pd
import psycopg2

def get_connection():
    load_dotenv()
    conn = psycopg2.connect (
        host = os.getenv("host"),
        port = os.getenv("port"),
        dbname = os.getenv("database"),
        user = os.getenv("user"),
        password = os.getenv("password")
    )
    return conn




