import json, time, os, datetime
import pynput.keyboard as Kb
from websockets.sync.server import serve
from websockets.exceptions import ConnectionClosed

os.system("cls")
os.system("title User Input Service")

Queue = []

def Kn(Key):
    if isinstance(Key, Kb.Key):
        return Key.name
    Vk = getattr(Key, "vk", None)
    if Vk is not None:
        if 65 <= Vk <= 90 or 48 <= Vk <= 57:
            return chr(Vk).lower()
        return f"vk_{Vk}"
    return Key.char or str(Key)

def OnPress(Key):
    Queue.append([Kn(Key), 1])

def OnRelease(Key):
    Queue.append([Kn(Key), 0])

def Handler(Websocket):
    global Queue
    Queue = []
    os.system("cls")
    print("Connected at " + datetime.datetime.now().strftime("%H:%M:%S"))

    try:
        while True:
            if len(Queue) > 0:
                SendData = json.dumps(Queue, allow_nan=False, ensure_ascii=False, separators=(",", ":"))
                Queue = []
                Websocket.send(SendData)
            else:
                time.sleep(0.01)
    except ConnectionClosed:
        os.system("cls")
        print("Listening for connections")

Kb.Listener(on_press=OnPress, on_release=OnRelease).start()

with serve(Handler, "localhost", 8765) as Server:
    print("Listening for connections")
    Server.serve_forever()
