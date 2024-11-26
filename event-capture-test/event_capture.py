import time
import RPi.GPIO as GPIO
import cv2
import asyncio
import websockets
import os

# GPIO 핀 설정
TRIG = 20
ECHO = 16

# GPIO 모드 설정
GPIO.setmode(GPIO.BCM)
GPIO.setwarnings(False)
GPIO.setup(TRIG, GPIO.OUT)
GPIO.setup(ECHO, GPIO.IN)

# 카메라 초기화
camera = cv2.VideoCapture(0)

def measure_distance():
   """
   초음파 센서로 거리를 측정하는 함수
   returns: float - 측정된 거리(cm)
   """
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

def capture_image():
   """
   카메라로 사진을 촬영하는 함수
   """
   ret, frame = camera.read()
   if ret:
       _, buffer = cv2.imencode('.jpg', frame)
       return buffer.tobytes()
   return None

async def detect_and_send(websocket):
   try:
       while True:
           # 거리 측정
           distance = measure_distance()
           
           # 화면 지우고 현재 거리 출력
           os.system('clear')
           print(f"현재 거리: {distance}cm")
           
           # 20cm 이하 감지시
           if distance <= 20:
               print("\n🚨 물체 감지! 🚨")
               print(f"감지된 거리: {distance}cm")
               print("사진 촬영 중...")
               
               image_data = capture_image()
               if image_data:
                   # 현재 시각 정보 추가
                   current_time = time.strftime("%Y-%m-%d %H:%M:%S", time.localtime())
                   
                   # 사진과 시각 정보를 딕셔너리로 만들어서 전송
                   await websocket.send(image_data)
                   print(f"촬영 시각: {current_time}")
                   print("사진 전송 완료!")
                   print("다음 감지를 위해 대기중...\n")
                   await asyncio.sleep(1)  # 연속 촬영 방지
           
           await asyncio.sleep(0.1)

   except Exception as e:
       print(f"Error: {e}")
   finally:
       camera.release()
       GPIO.cleanup([TRIG, ECHO])

async def main():
   print("서버 시작 중...")
   async with websockets.serve(detect_and_send, "0.0.0.0", 8081):
       print("📸 이벤트 감지 서버가 시작되었습니다! (포트: 8081)")
       await asyncio.Future()

if __name__ == '__main__':
   try:
       asyncio.run(main())
   except KeyboardInterrupt:
       print("\n프로그램을 종료합니다.")
       camera.release()
       GPIO.cleanup([TRIG, ECHO])
