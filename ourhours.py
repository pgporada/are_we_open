import holidays
from datetime import datetime, timedelta, time
from pytz import timezone

BIZ_OPEN = time(9, 0, 0)
BIZ_CLOSE = time(18, 0, 0)
WEEKEND = (5, 6)
TIMEZONE = 'US/Eastern'

def is_gl_open():
    now_time = datetime.now(timezone(TIMEZONE))
    h = sorted(holidays.US(years=now_time.year).items())

    # Days off come from the employee handbook
    observed_holidays = [date for date, name in h \
                        if 'New Year\'s Day' not in name and \
                        'Memorial Day' not in name and \
                        'Independence Day' not in name and \
                        'Labor Day' not in name and \
                        'Christmas Day' not in name
                        ]

    # Thanksgiving and the day before
    thanksgiving = [date for date, name in h if name == 'Thanksgiving'][0]
    observed_holidays.append(thanksgiving + timedelta(days=1))

    # Check if the current date is a holiday
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


# Lambda will only export one specific function, called a handler
def lambda_handler(event, context):
    return {'are_we_open': is_gl_open()}


if __name__ == '__main__':
    print is_gl_open()

    # We still want to test that our handler is working without running it through AWS
    print lambda_handler("fake event", "fake context")
