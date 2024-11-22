# sensors/dht11.py
import time
import RPi.GPIO as GPIO
from adafruit_htu21d import HTU21D
import busio
from . import SensorInterface

class HTU21DSensor(SensorInterface):
    def __init__(self, sda=2, scl=3):
        self.sda = sda
        self.scl = scl
        GPIO.setmode(GPIO.BCM)
        GPIO.setwarnings(False)
        self.i2c = busio.I2C(self.scl, self.sda)
        self.sensor = HTU21D(self.i2c)

    def read(self):
        temperature = float(self.sensor.temperature)
        humidity = float(self.sensor.relative_humidity)
        return {
            "temperature": round(temperature, 2),
            "humidity": round(humidity, 2)
        }

    def cleanup(self):
        GPIO.cleanup([self.sda, self.scl])
