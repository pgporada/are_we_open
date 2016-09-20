#!/usr/bin/env python
import holidays
from datetime import datetime, timedelta, time
from pytz import timezone

BIZ_OPEN    = time(9,0,0)
BIZ_CLOSE   = time(18,0,0)
WEEKEND     = (5, 6)
TIMEZONE    = 'US/Eastern'

def is_gl_open():
    now_time = datetime.now(timezone(TIMEZONE))
    h = sorted(holidays.US(years=now_time.year).items())
    observed_holidays = [date for date, name in h \
                        if 'Martin Luther' not in name and 'Columbus' not in name ]

    thanksgiving = [date for date, name in h if name == 'Thanksgiving'][0]
    observed_holidays.append(thanksgiving + timedelta(days=1))

    # Today is a holiday
    for h in observed_holidays:
        if h == datetime.date(now_time):
            return False

    # Today is the weekend
    if now_time.weekday() in WEEKEND:
        return False
    # Past normal business hours
    elif not BIZ_OPEN <= now_time.time() < BIZ_CLOSE:
        return False
    # We must be open then
    else:
        return True

if __name__ == '__main__':
    print is_gl_open()
