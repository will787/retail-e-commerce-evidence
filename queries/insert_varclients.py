# %%
import pandas as pd
import sqlite3

def execute_sql_script(script_path, db_name):
    """Executes a SQL script against a SQLite database."""
    try:
        with sqlite3.connect(db_name) as conn:
            with open(script_path, 'r', encoding='utf-8') as f:
                conn.executescript(f.read())
        print(f"Successfully executed {script_path} on {db_name}")
    except sqlite3.Error as e:
        print(f"Database error: {e}")
    except FileNotFoundError:
        print(f"Error: SQL script not found at {script_path}")

execute_sql_script('mostvalue_client.sql', 'retail.db')
# %%

df = pd.read_csv('../data/data_encoding.csv', encoding='ISO-8859-1')

with sqlite3.connect('retail.db') as conn:
    df.to_sql('transactions', conn, if_exists='replace', index=False)

# him insert csv to put on the retail.db it will create in the enviroment