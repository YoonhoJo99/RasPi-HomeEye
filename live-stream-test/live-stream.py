import asyncio
import websockets
import cv2
import RPi.GPIO as GPIO
import time
import json
import base64

# GPIO 설정
TRIG = 20
ECHO = 16

def setup_gpio():
    GPIO.setmode(GPIO.BCM)
    GPIO.setwarnings(False)
    GPIO.setup(TRIG, GPIO.OUT)
    GPIO.setup(ECHO, GPIO.IN)

def cleanup_gpio():
    GPIO.cleanup([TRIG, ECHO])

def measure_distance():
    time.sleep(0.2)
    GPIO.output(TRIG, 1)
    GPIO.output(TRIG, 0)
    
    while(GPIO.input(ECHO) == 0):
        pass
    pulse_start = time.time()
    
    while(GPIO.input(ECHO) == 1):
        pass
    pulse_end = time.time()
    
    pulse_duration = pulse_end - pulse_start
    distance = pulse_duration * 340 * 100 / 2
    return round(distance, 2)

async def stream_and_capture(websocket):
    try:
        setup_gpio()
        cap = cv2.VideoCapture(0)
        last_check_time = time.time()
        
        print("스트리밍 및 감지 시작...")
        while True:
            ret, frame = cap.read()
            if not ret:
                break
            
            # 스트리밍용 저화질 이미지
            _, stream_buffer = cv2.imencode('.jpg', frame, [cv2.IMWRITE_JPEG_QUALITY, 30])
            stream_data = {
                "type": "stream",
                "data": base64.b64encode(stream_buffer).decode('utf-8')
            }
            await websocket.send(json.dumps(stream_data))
            
            # 1초마다 거리 체크
            current_time = time.time()
            if current_time - last_check_time >= 1:
                distance = measure_distance()
                print(f"현재 거리: {distance}cm")
                
                if distance <= 20:
                    print("\n🚨 물체 감지!")
                    print(f"감지된 거리: {distance}cm")
                    
                    # 이벤트용 고화질 이미지
                    _, event_buffer = cv2.imencode('.jpg', frame, [cv2.IMWRITE_JPEG_QUALITY, 90])
                    event_data = {
                        "type": "event",
                        "data": base64.b64encode(event_buffer).decode('utf-8')
                    }
                    await websocket.send(json.dumps(event_data))
                    print("이벤트 이미지 전송 완료!\n")
                
                last_check_time = current_time
            
            await asyncio.sleep(0.033)  # ~30fps
            
    except Exception as e:
        print(f"Error: {e}")
    finally:
        cap.release()
        cleanup_gpio()
        print("스트리밍 종료")

async def main():
    print("서버 시작 중...")
    async with websockets.serve(stream_and_capture, "0.0.0.0", 8080):
        print("📸 통합 서버가 시작되었습니다! (포트: 8080)")
        await asyncio.Future()

if __name__ == '__main__':
    try:
        asyncio.run(main())
    except KeyboardInterrupt:
        print("\n서버 종료 중...")
        cleanup_gpio()
        print("서버가 안전하게 종료되었습니다.")
