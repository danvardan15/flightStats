import numpy as np
import pandas as pd
from math import radians, sin, cos, acos

AIRLINES = ('EasyJet', 'RyanAir', 'EuroWings')
airports = pd.read_csv('airport_req.csv')

n_samples = 2000
sample = airports.sample(n_samples, replace=True)

month_of_purchase = np.random.randint(1, 13, n_samples)
year_of_purchase  = np.zeros_like(month_of_purchase) + 2019
months_in_advance = (np.random.gamma(shape=1, scale=3, size=n_samples).astype(np.int64) % 9) + 1
month_of_flight   = (month_of_purchase + months_in_advance - 1) % 12 + 1
year_of_flight    = 2019 + (month_of_purchase + months_in_advance) // 13
airline           = np.random.choice(AIRLINES, n_samples)

slat = sample["lat"]
slon = sample["lng"]
elat = radians(52.55394)
elon = radians(13.291722)
dist = 637.101 * np.arccos(np.sin(slat)*np.sin(elat) + np.cos(slat)*np.cos(elat)*np.cos(slon - elon))
duration = dist // 10+ 15 

sale  = np.zeros((n_samples,) , dtype=bool)
sale[np.random.randint(0, n_samples + 1, n_samples // 25)] = True

price = duration / 3
price = price * np.linspace(2, 1, 12)[months_in_advance]
cond = year_of_flight == 2020
price[cond] = price[cond] * 1.1
cond = np.logical_and(month_of_flight >= 6, month_of_flight <= 8)
price[cond] = price[cond] * 1.3
cond = np.logical_and(month_of_flight >= 11 , month_of_flight <= 12)
price[cond] = price[cond] * 1.7
cond = np.logical_or(sample['countryCode'] == 'CH', sample['countryCode'] == 'NO')
price[cond] = price[cond] * 1.2
price[sale] = price[sale] * np.random.choice((0.75, 0.65, 0.5), len(price[sale]))


sample['month_of_purchase'] = month_of_purchase
sample['year_of_purchase']  = year_of_purchase
sample['months_in_advance'] = months_in_advance
sample['month_of_flight']   = month_of_flight
sample['year_of_flight']    = year_of_flight
sample['airline']           = airline
sample['dist']              = dist.round(2)
sample['duration']          = duration.round(2)
sample['price']             = price.round(2)
sample['sale']              = sale

sample.to_csv('flights.csv', index=False)
