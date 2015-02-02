from __future__ import print_function

from scrape_events import *
import json

def generate_json():
    out = []

    i = 1
    total = len(cal_ids)
    
    for cal_url, cal_id, name, extra in cal_ids:
        print('%02d/%d%30s ' % (i, total, name), end='', file=sys.stderr)
        sys.stderr.flush()
        events = get_all_events(cal_url, extra)
        print('', file=sys.stderr)
        sys.stderr.flush()
        
        for event in events:
            date = event.pop('date')
            time = event.pop('time')
            try:
                d1, d2 = to_datetime_range(date, time)
            except:
                continue

            event['start_at'] = d1.astimezone(pytz.utc).isoformat()
            event['end_at'] = d2.astimezone(pytz.utc).isoformat()
            event['group'] = name

            out.append(event)
        i += 1
            
    print(json.dumps(out))

if __name__ == '__main__':
    generate_json()
