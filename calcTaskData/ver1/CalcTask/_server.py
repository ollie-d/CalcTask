import asyncio
import websockets
import base64
import json
import time
from datetime import datetime 
import pytz 

LIMIT = 8 # max seconds server and client can be off by
UTC = pytz.utc;
delay = 3
counter = 0
connected = set()
handshakes = {}
with open('./_handshakes_server.json') as f:
    handshakes = json.load(f)

async def handler(websocket, path):
    global delay
    global counter
    global UTC
    global handshakes
    global LIMIT

    # Register.
    connected.add(websocket)
    key = await websocket.recv()
    key = key.decode('utf-8')
    key = key.strip('"')
    print('Time from client via handshake: ' + handshakes[key])

    # Calculate our time and compute difference
    t_server = datetime.strptime(datetime.now(UTC).strftime('%M%S'), '%M%S')
    t_client = datetime.strptime(handshakes[key], '%M%S')
    delay = t_server - t_client
    if int(delay.seconds) > LIMIT:
        print('Delay was: %d' % int(delay.seconds))
        # Disconnect
        await websocket.send(str('NOPE'))
        connected.remove(websocket)
        await websocket.close()
    else:
        print('Handshake accepted')
        try:	
            await websocket.send(str(delay))
            try:
                data = await websocket.recv()   
                data = json.loads(data.decode('utf-8'))
                print(data['sid'] + ' finished')
                t0 = time.time()
                with open(data['sid']+'.json', 'w') as outfile:
                    json.dump(data, outfile)
                t = time.time()-t0
                print('     JSON dump took %f seconds' % (t))
                # If dumped file was _main, change delay, inc counter
                if '_baseline' in data['sid']:
                    if delay == 3:
                        delay = 5
                    elif delay == 5:
                        delay = 3
                    print('    delay set to %d' % delay)
                elif '_main' in data['sid']:    
                    counter += 1
                    print('%d subjects completed main task!' % counter)
            except:
                print('Connection terminated early')
        finally:
            # Unregister.
            connected.remove(websocket)

start_server = websockets.serve(handler, port= 8765)
asyncio.get_event_loop().run_until_complete(start_server)
asyncio.get_event_loop().run_forever()
