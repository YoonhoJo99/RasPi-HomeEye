import asyncio
import websockets
import cv2
import base64
import numpy as np

async def stream_video(websocket):
    cap = cv2.VideoCapture(0)
    try:
        while True:
            ret, frame = cap.read()
            if not ret:
                break
                
            _, buffer = cv2.imencode('.jpg', frame)
            await websocket.send(buffer.tobytes())
            await asyncio.sleep(0.033)
            
    finally:
        cap.release()

async def main():
    async with websockets.serve(stream_video, "0.0.0.0", 8080):
        await asyncio.Future()  # run forever

if __name__ == '__main__':
    asyncio.run(main())
