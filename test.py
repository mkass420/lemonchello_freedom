import pandas as pd
from dataclasses import dataclass

epg_stat = pd.read_csv('data/epg_stat_2024_10.csv', sep=';')

ch_stattime = {};

for row_tuple in epg_stat.itertuples():
    ch_id = row_tuple.ch_id
    duration = row_tuple.duration
    if ch_id not in ch_stattime:
        ch_stattime[ch_id] = 0

    ch_stattime[ch_id] += duration

print(ch_stattime)