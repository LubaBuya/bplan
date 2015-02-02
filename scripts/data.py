
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
    # ('http://events.berkeley.edu/index.php/calendar/sn/student.html', None, 'Student Events', ''),
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

# cal_ids = cal_ids[0:2]
# cal_ids = cal_ids[-1:]

# chem and engineering, for testing
# cal_ids = [cal_ids[10], cal_ids[20]]
