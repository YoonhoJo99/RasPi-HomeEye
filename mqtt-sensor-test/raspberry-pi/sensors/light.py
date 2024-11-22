# sensors/light.py
import time
import RPi.GPIO as GPIO
import Adafruit_MCP3008
from sensors import SensorInterface

class LightSensor(SensorInterface):
    def __init__(self, clk=11, cs=8, miso=9, mosi=10):
        self.clk = clk
        self.cs = cs
        self.miso = miso
        self.mosi = mosi
        GPIO.setmode(GPIO.BCM)
        GPIO.setwarnings(False)
        self.mcp = Adafruit_MCP3008.MCP3008(
            clk=self.clk, 
            cs=self.cs, 
            miso=self.miso, 
            mosi=self.mosi
        )

    def read(self):
        light_value = self.mcp.read_adc(0)
        return {"light": light_value}

    def cleanup(self):
        GPIO.cleanup([self.clk, self.cs, self.miso, self.mosi])
