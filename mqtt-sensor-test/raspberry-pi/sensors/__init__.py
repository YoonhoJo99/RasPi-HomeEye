# sensors/__init__.py
class SensorInterface:
    def read(self):
        pass
    
    def cleanup(self):
        pass

# 인터페이스 정의 후에 import
from .ultrasonic import UltrasonicSensor
from .dht11 import HTU21DSensor
from .light import LightSensor
