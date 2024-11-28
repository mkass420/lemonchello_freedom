import pandas as pd
from dataclasses import dataclass, field
from typing import Set
#from typing import List
#from datetime import datetime
#
#
#@dataclass
#class ch_stat_big:
#    client: str
#    device: str
#    time_ch: datetime
#    epg_name: str
#    time_epg: datetime
#    time_to_epg: datetime
#    duration: int
#    category: str
#    subcategory: List[str] = field(default_factory=list)

@dataclass
class stat:
    duration: int
    unique_users_number: int

epg_stat = pd.read_csv('data/epg_stat_2024_10.csv', sep=';')

def get_key_stats(key):
    if key not in {'ch_id', 'epg_name'}:
        print('wrong key')
        return 
    stats = {};
    unique_users = {};

    for row_tuple in epg_stat.itertuples():
        key_val = getattr(row_tuple, key)
        duration = row_tuple.duration
        client = row_tuple.client
        if key_val not in stats:
            stats[key_val] = stat(0, 0)
            unique_users[key_val] = set()

        stats[key_val].duration += duration
        unique_users[key_val].add(client)
        stats[key_val].unique_users_number = len(unique_users[key_val])
    return stats
    


print(get_key_stats('ch_id'))
print(get_key_stats('epg_name'))