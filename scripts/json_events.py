from scrape_events import *
import json

def generate_json():
    out = []
    
    for cal_url, cal_id, name, extra in cal_ids:
        events = get_all_events(cal_url, extra)
        for event in events:
            date = event.pop('date')
            time = event.pop('time')
            try:
                d1, d2 = to_datetime_range(date, time)
            except:
                continue

            event['start_at'] = d1.isoformat()
            event['end_at'] = d2.isoformat()
            event['group'] = name

            out.append(event)
            
    print(json.dumps(out))

if __name__ == '__main__':
    generate_json()
