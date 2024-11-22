# sensors/ultrasonic.py
import time
import RPi.GPIO as GPIO
from sensors import SensorInterface

class UltrasonicSensor(SensorInterface):
    def __init__(self, trig=20, echo=16):
        self.trig = trig
        self.echo = echo
        GPIO.setmode(GPIO.BCM)
        GPIO.setwarnings(False)
        GPIO.setup(self.trig, GPIO.OUT)
        GPIO.setup(self.echo, GPIO.IN)

    def read(self):
        time.sleep(0.2)
        GPIO.output(self.trig, 1)
        GPIO.output(self.trig, 0)
        
        while(GPIO.input(self.echo) == 0):
            pass
        pulse_start = time.time()
        
        while(GPIO.input(self.echo) == 1):
            pass
        pulse_end = time.time()
        
        pulse_duration = pulse_end - pulse_start
        distance = pulse_duration * 340 * 100 / 2
        
        return {"distance": round(distance, 2)}

    def cleanup(self):
        GPIO.cleanup([self.trig, self.echo])
