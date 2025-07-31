# %%

import pandas as pd
import sqlite3

df = pd.read_csv('../data/data_encoding.csv', encoding='ISO-8859-1')

with sqlite3.connect('retail.db') as conn:
    df.to_sql('transactions', conn, if_exists='replace', index=False)

conn.close()