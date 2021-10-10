# This used to be the .ipynb equivalent (check previous versions)

# Lazy attempt at security
from datetime import datetime, timedelta
import pytz 
import random
import numpy as np
import json

c = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'

# Iterate through every date time in seconds
#H = [x for x in range(0, 24)]
M = [x for x in range(0, 60)]
S = [x for x in range(0, 60, 4)]
handshakes_client = {}
handshakes_server = {}
#for _, h in enumerate(H):
    #h = str(h)
    #if len(h) == 1:
        #h = '0'+h
for _, m in enumerate(M):
    m = str(m)
    if len(m) == 1:
        m = '0'+m
    for _, s in enumerate(S):
        s = str(s)
        if len(s) == 1:
            s = '0'+s
        ix = [x for x in range(36)]
        random.seed()
        random.shuffle(ix)
        sid = ''
        for i in range(8):
            sid += c[ix[i]]
        # Add to handshakes
        handshakes_client[m+s] = sid
        handshakes_server[sid] = m+s
        #handshakes_client[h+m+s] = sid
        #handshakes_server[sid] = h+m+s
            
if len(np.unique(np.array(list(handshakes_client.values())))) == len(handshakes_client):
    # Save as a JSON if all handshakes are unique
    with open('handshakes_client.json', 'w') as outfile:
                json.dump(handshakes_client, outfile)
    with open('handshakes_server.json', 'w') as outfile:
                json.dump(handshakes_server, outfile)
    print('JSONs saved.')
else:
    print('Damn, the odds of that were absolutely tiny. Run this again and admire your luck.')
    
for x in range(60):
    x_ = np.floor(x/4)*4
    print('%d: %f' % (x, x_))
    
UTC = pytz.utc
datetime.strptime(datetime.now(UTC).strftime('%M%S'), '%M%S')

t_server = datetime.strptime(datetime.now(UTC).strftime('%M%S'), '%M%S')
t_client = datetime.strptime('1440', '%M%S')
x = t_server - t_client
print(x.seconds)

rounder = 4
for m_ in range(60):
    m = str(m_)
    for s_ in range(60):
        s = int(np.floor(s_/rounder)*rounder)
        s = str(s)
        for x in [m, s]:
            if len(x) == 1:
                x = '0' + x
        print(m+s)