# mqtt_publisher.py
import time
import paho.mqtt.client as mqtt
from sensors import UltrasonicSensor, HTU21DSensor, LightSensor

def main():
    # MQTT 클라이언트 설정
    client = mqtt.Client()
    client.connect("localhost", 1883, 60)
    
    # 센서 객체 생성
    ultrasonic = UltrasonicSensor()
    temp_humid = HTU21DSensor()
    light = LightSensor()
    
    try:
        while True:
            # 센서 데이터 읽기
            distance_data = ultrasonic.read()
            temp_humid_data = temp_humid.read()
            light_data = light.read()
            
            # 센서 데이터 출력
            print("\n=== 센서 데이터 ===")
            print(f"거리: {distance_data['distance']} cm")
            print(f"온도: {temp_humid_data['temperature']} °C")
            print(f"습도: {temp_humid_data['humidity']} %")
            print(f"조도: {light_data['light']}")
            print("=================")
            
            # MQTT로 발행
            client.publish("sensors/distance", str(distance_data))
            client.publish("sensors/temperature", str(temp_humid_data["temperature"]))
            client.publish("sensors/humidity", str(temp_humid_data["humidity"]))
            client.publish("sensors/light", str(light_data["light"]))
            
            time.sleep(1)
            
    except KeyboardInterrupt:
        print("\n프로그램 종료")
    finally:
        # 센서 정리
        ultrasonic.cleanup()
        temp_humid.cleanup()
        light.cleanup()
        client.disconnect()

if __name__ == "__main__":
    main()
