# sensors/__init__.py
from .ultrasonic import UltrasonicSensor
from .dht11 import HTU21DSensor
from .light import LightSensor

class SensorInterface:
    def read(self):
        pass
    
    def cleanup(self):
        pass
