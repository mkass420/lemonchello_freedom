import pandas as pd
from dataclasses import dataclass
from datetime import datetime
#from typing import List
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

def get_and_sort_key_stats(key, sort_key):
    if key not in {'ch_id', 'epg_name'}:
        print('wrong key')
        return -1
    if sort_key not in {'duration', 'unique_users_number'}:
        print('wrong sort key')
        return -1
    stats = {};
    unique_users = {};

    for row_tuple in epg_stat.itertuples():
        key_val = getattr(row_tuple, key)
        duration = row_tuple.duration
        if key == 'epg_name':
            time_epg = datetime.strptime(row_tuple.time_epg, '%Y-%m-%d %H:%M:%S')
            time_to_epg = datetime.strptime(row_tuple.time_to_epg, '%Y-%m-%d %H:%M:%S')
            timedif = int((time_to_epg-time_epg).total_seconds())
            duration = min(duration, timedif)

        client = row_tuple.client
        if key_val not in stats:
            stats[key_val] = stat(0, 0)
            unique_users[key_val] = set()

        stats[key_val].duration += duration
        unique_users[key_val].add(client)
        stats[key_val].unique_users_number = len(unique_users[key_val])
    sorted_stats = dict(sorted(stats.items(), key=lambda item: getattr(item[1], sort_key), reverse=True))

    res = [f'{key};duration;unique_users_number']
    for k, v in sorted_stats.items():
        res.append(f'{k};{v.duration};{v.unique_users_number}')
    
    return res
    


#print(get_key_stats('ch_id'))
#print(get_key_stats('epg_name'))

#print(get_and_sort_key_stats('ch_id', 'duration'))
