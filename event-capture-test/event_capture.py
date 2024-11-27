import asyncio
import websockets
import cv2
import RPi.GPIO as GPIO
import time

# 전역 변수
TRIG = 20
ECHO = 16
camera = None

async def setup_and_measure(websocket):
    # 새로운 연결마다 GPIO 초기화
    GPIO.setmode(GPIO.BCM)
    GPIO.setwarnings(False)
    GPIO.setup(TRIG, GPIO.OUT)
    GPIO.setup(ECHO, GPIO.IN)
    
    global camera
    camera = cv2.VideoCapture(0)
    
    try:
        print("감지 시작...")
        while True:
            try:
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
                distance = round(distance, 2)
                
                print(f"현재 거리: {distance}cm")
                
                if distance <= 20:
                    print("\n🚨 물체 감지! 🚨")
                    print(f"감지된 거리: {distance}cm")
                    print("사진 촬영 중...")
                    
                    ret, frame = camera.read()
                    if ret:
                        _, buffer = cv2.imencode('.jpg', frame)
                        await websocket.send(buffer.tobytes())
                        print("사진 전송 완료!\n")
                        await asyncio.sleep(1)
                
                await asyncio.sleep(0.1)
                
            except Exception as e:
                print(f"측정 오류: {e}")
                break
                
    finally:
        if camera is not None:
            camera.release()
        GPIO.cleanup([TRIG, ECHO])
        print("연결 종료: 리소스 정리 완료")

async def main():
    print("서버 시작 중...")
    async with websockets.serve(setup_and_measure, "0.0.0.0", 8081):
        print("서버 시작! 웹소켓 포트: 8081")
        await asyncio.Future()

if __name__ == '__main__':
    try:
        asyncio.run(main())
    except KeyboardInterrupt:
        print("\n서버 종료 중...")
        if camera is not None:
            camera.release()
        GPIO.cleanup([TRIG, ECHO])
        print("서버가 안전하게 종료되었습니다.")
