import time
import RPi.GPIO as GPIO

# GPIO 핀 설정
TRIG = 20
ECHO = 16

# GPIO 모드 설정
GPIO.setmode(GPIO.BCM)
GPIO.setwarnings(False)
GPIO.setup(TRIG, GPIO.OUT)
GPIO.setup(ECHO, GPIO.IN)

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

try:
   print("초음파 센서 거리 측정 시작...")
   while True:
       distance = measure_distance()
       print(f"현재 거리: {distance}cm")
       time.sleep(0.1)  # 0.1초 간격으로 측정

except KeyboardInterrupt:
   print("\n프로그램을 종료합니다.")
   GPIO.cleanup([TRIG, ECHO])
