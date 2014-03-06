#!/usr/bin/env python2

from __future__ import print_function

import unicodecsv as csv

from urllib2 import *
#import http.client

from bs4 import BeautifulSoup
import re

from multiprocessing import Pool
import sys

from datetime import datetime, timedelta
import pytz
from dateutil import parser

from pprint import pprint

import colorsys
import random
import json

#import gcal

tz = pytz.timezone('America/Los_Angeles')
now = datetime.now(tz)
yesterday = now + timedelta(days=-1)


neuro_cal = 'http://events.berkeley.edu/index.php/calendar/sn/HWNI.html'
eecs_cal = 'http://events.berkeley.edu/index.php/calendar/sn/eecs.html'
bioe_cal = 'http://events.berkeley.edu/index.php/calendar/sn/bioe.html'
physics_cal = 'http://events.berkeley.edu/index.php/calendar/sn/physics.html'
stats_cal = 'http://events.berkeley.edu/index.php/calendar/sn/stat.html'
nano_cal = 'http://events.berkeley.edu/index.php/calendar/sn/BNNI.html'
econ_cal = 'http://events.berkeley.edu/index.php/calendar/sn/econ.html'

neuro_id = 'rt7dtgpmpts5bj0e46qspp3vbo@group.calendar.google.com'
eecs_id = '19igp4aqm0iou6iguimshqoqe0@group.calendar.google.com'
bioe_id = '2b8ecjbc5c2ian4o03sf58smrg@group.calendar.google.com'
physics_id = 'faqgt82t2n73icve09v32v5mjo@group.calendar.google.com'
stats_id = '63rh1b4enh4r5ek72bhq9tvuq4@group.calendar.google.com'
nano_id = 'hhgf7lsd1uk1iunatdbjgm1lps@group.calendar.google.com'
econ_id = 'kttub11ik5va3br7sqgv86vb44@group.calendar.google.com'

perform_id = 'ub3cmj9ese43rpab10al49k6c4@group.calendar.google.com'
sports_id = '793t6mi5li6k64giod54uo7le0@group.calendar.google.com'
films_id = 'egve6q51jn1gis9okbk8u77n44@group.calendar.google.com'

base_url = 'http://events.berkeley.edu/index.php/'

cal_ids = [
    (neuro_cal, neuro_id, 'Neuroscience', ""),
    (eecs_cal, eecs_id, 'EECS', ''),
    (bioe_cal, bioe_id, 'BioE', ''),
    (physics_cal, physics_id, 'Physics', ''),
    (stats_cal, stats_id, "Statistics", ''),
    (nano_cal, nano_id, "Nanosciences", ''),
    (econ_cal, econ_id, "Economics", ''),

    # ('http://events.berkeley.edu/index.php/calendar/sn/sa.html', None, 'Student Affairs', ''),
    ('http://events.berkeley.edu/index.php/calendar/sn/student.html', None, 'Student Events', ''),
    ('http://events.berkeley.edu/index.php/calendar/sn/its.html', None, 'Transportation Studies', ''),
    ('http://events.berkeley.edu/index.php/calendar/sn/music.html', None, 'Music', ''),
    ('http://events.berkeley.edu/index.php/calendar/sn/chem.html', None, 'Chemistry', ''),
    ('http://events.berkeley.edu/index.php/calendar/sn/classics.html', None, 'Classics', ''),
    ('http://events.berkeley.edu/index.php/calendar/sn/psych.html', None, 'Psychology', ''),
    ('http://events.berkeley.edu/index.php/calendar/sn/astro.html', None, 'Astrophysics', ''),
    ('http://events.berkeley.edu/index.php/calendar/sn/uhs.html', None, 'Tang Center', ''),
    ('http://events.berkeley.edu/index.php/calendar/sn/math.html', None, 'Math', ''),
    ('http://events.berkeley.edu/index.php/calendar/sn/mcb.html', None, 'MCB', ''),
    ('http://events.berkeley.edu/index.php/calendar/sn/bio.html', None, 'International Office', ''),
    ('http://events.berkeley.edu/index.php/calendar/sn/ccb.html', None, 'Comp. Bio', ''),
    ('http://events.berkeley.edu/index.php/calendar/sn/bsa.html', None, 'Study Abroad', ''),
    ('http://events.berkeley.edu/index.php/calendar/sn/coe.html', None, 'Engineering', ''),
    ('http://events.berkeley.edu/index.php/calendar/sn/pubpol.html', None, 'Public Policy', ''),
    ('http://events.berkeley.edu/index.php/calendar/sn/arthistory.html', None, 'Art History', ''),
    ('http://events.berkeley.edu/index.php/calendar/sn/polisci.html', None, 'Political Science', ''),
    
    (base_url, perform_id, "Performances", '&tab=performing_arts'),
    (base_url, sports_id, "Sports", '&tab=sports'),
    (base_url, films_id, "Films", '&tab=films')
    ]

p = re.compile(u'[\s\xa0]+')

CURRENT_YEAR = datetime.now().year

def to_datetime_range(date, time_range):
    dt_date = datetime.strptime(date, '%B %d')
    time_range = time_range.replace('.', '').upper()
    L = time_range.split('-')
    L = [x.strip() for x in L]
    
    if len(L) == 1:
        try:
            t1 = datetime.strptime(L[0], '%I:%M %p')
        except ValueError:
            t1 = datetime.strptime(L[0], '%I %p')

        t2 = t1 + timedelta(hours=1)
        
    elif len(L) == 2:
        if L[0].find('M') == -1:
            L[0] += ' ' + L[1][-2:]
        try:
            t1 = datetime.strptime(L[0], '%I:%M %p')
        except ValueError:
            t1 = datetime.strptime(L[0], '%I %p')

        try:
            t2 = datetime.strptime(L[1], '%I:%M %p')
        except ValueError:
            t2 = datetime.strptime(L[1], '%I %p')
                
            
    t1 = t1.replace(year=CURRENT_YEAR, month=dt_date.month, day=dt_date.day)
    t2 = t2.replace(year=CURRENT_YEAR, month=dt_date.month, day=dt_date.day)
    return (t1, t2)
    

def get_event(header, ps, base_url):
    L = map(lambda x: p.sub(' ', x.text.strip()), ps[4:])
    L = list(L)
    title = p.sub(' ', header.text.strip())
    event_type, date, time, location = L[0].split(' | ')
    speaker = L[1].partition(': ')[2]

    sponsor = None
    if len(L) >= 3:
        sponsor = L[2].partition(': ')[2]
        
    details = None
    if len(L) >= 4:
        details = L[3].strip()
        if details.find('More >') != -1:
            link = header.find('a').attrs['href']
            response = urlopen(base_url + link)
            s = BeautifulSoup(response.read())
            details = s.find(attrs={'class': 'event'}).find_all('p')[8].text.strip()
        details = details.replace(' \n\r\n', '\n')
        details = re.sub('(&nbsp;|\s)+', ' ', details)
        details = re.sub(u'[\xa0\xad ]+', ' ', details)
        
    return {
        'title': title,
        'event_type': event_type,
        'date': date,
        'time': time,
        'location': location,
        'speaker': speaker,
        'sponsor': sponsor,
        'details': details
        }

def format_event(event):
    try:
        d1, d2 = to_datetime_range(event['date'], event['time'])
    except:
        return None

    return {
        'summary': event['title'],
        'location': event['location'],
        'start': {
            'dateTime': d1.isoformat(),
            'timeZone': 'America/Los_Angeles'
        },
        'end': {
            'dateTime': d2.isoformat(),
            'timeZone': 'America/Los_Angeles'
        },
        'description': event['details']
        }
    


def get_events(base_url, add='?view=summary'):
    response = urlopen(base_url+add)

    s = BeautifulSoup(response.read())
    
    events = s.find_all(attrs={'class': 'event'})

    out = []

    for e in events:
        ps = e.find_all('p')
        title = e.find('h3')
        try:
            event = get_event(title, ps, base_url)
            out.append(event)
            print(event['title'])
        except ValueError:
            continue

    return out

# get all events in this calendar for current month and next 3 months
def get_all_events(base_url, extra=''):
    print('\nFETCHING EVENTS...')

    dd = datetime.now()

    out = []
    
    for i in range(3):
        add = '?view=summary&timeframe=month&date={0}{1}'.format(
            dd.strftime('%Y-%m-%d'), extra)
        out.extend(get_events(base_url, add))
        month = dd.month
        while dd.month == month:
            dd = dd + timedelta(days=1)

    return out
    
def clear_calendar(id):
    print('\nDELETING EVENTS...')
    page_token = None
    while True:
        events = gcal.service.events().list(calendarId=id,
                                            pageToken=page_token).execute()
        for event in events['items']:
            d = parser.parse(event['start']['dateTime']).replace(tzinfo=tz)
            if d < yesterday:
                continue

            print(event['summary'], '--', event['start']['dateTime'])
            
            gcal.service.events().delete(calendarId=id,
                                        eventId=event['id']).execute()

            
        page_token = events.get('nextPageToken')
        if not page_token:
            break

def add_events(calendar_id, events):
    print('\nADDING EVENTS...')
    for event in events:
        if event == None:
            continue
        
        if event.get('start', {}).get('dateTime', None) == None:
            continue
        
        d = parser.parse(event['start']['dateTime']).replace(tzinfo=tz)
        if d < yesterday:
            continue
        
        print(event['summary'], '--', event['start']['dateTime'])

        gcal.service.events().insert(calendarId=calendar_id, body=event).execute()
    

def reload_events(calendar_id, events):
    clear_calendar(calendar_id)
    print()
    add_events(calendar_id, events)

def reload_calendar(calendar_id, base_url, extra=''):
    events = get_all_events(base_url, extra)
    events = map(format_event, events)
    reload_events(calendar_id, events)

def main():
    for cal_url, cal_id, name, extra in cal_ids:
        print('\n\n','='*100, sep='')
        print(cal_url)
        reload_calendar(cal_id, cal_url, extra)

def generate_csv():
    f_out = open('data/events.csv', 'w')
    writer = csv.DictWriter(f_out,
                            fieldnames=['title', 'event_type', 'start_at',
                                        'end_at', 'location', 'speaker',
                                        'sponsor', 'details', 'group'])

    writer.writeheader()
    
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
            
            writer.writerow(event)
            
    f_out.close()

def generate_group_colors():
    groups = map(lambda x: x[2], cal_ids)
    out = []
    for g in groups:
        h = random.uniform(0, 1)
        s = 1
        v = random.uniform(0.6, 1)

        rgb = colorsys.hsv_to_rgb(h, s, v)
        rgb = tuple(map(lambda x: round(x*255), rgb))
        col = '#%02X%02X%02X' % rgb
        
        out.append( (g, col) )

    f = open('data/group_colors.json', 'w')
    json.dump(out, f)
    f.close()
    
            
if __name__ == '__main__':
    #main()
    generate_csv()
    #generate_group_colors()
    # pass
    


