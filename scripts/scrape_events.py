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

from data import *

#import gcal

tz = pytz.timezone('America/Los_Angeles')
now = datetime.now(tz)
yesterday = now + timedelta(days=-1)


p = re.compile(u'[\s\xa0\xad]+')

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
    title = p.sub(' ', header.text.strip())

    good = False

    index = 4
    while not good:
        L = [p.sub(' ', x.text.strip()) for x in ps[index:]]
        try:
            event_type, date, time, location = L[0].split(' | ')
            good = True
        except ValueError:
            good = False
            index -= 1

            if index < 0:
                return None

        
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
        details = p.sub(' ', details.strip())
        
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
            if event == None:
                continue
            
            out.append(event)
            print(event['title'], file=sys.stderr)
        except ValueError:
            continue

    return out

# get all events in this calendar for current month and next 3 months
def get_all_events(base_url, extra=''):
    print('\nFETCHING EVENTS: {0}{1}'.format(base_url, extra), file=sys.stderr)
    print('='*100, sep='', file=sys.stderr)


    dd = datetime.now()

    out = []
    
    for i in range(4):
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


if __name__ == '__main__':
    #main()
    generate_csv()
    #generate_group_colors()
    #pass
    


