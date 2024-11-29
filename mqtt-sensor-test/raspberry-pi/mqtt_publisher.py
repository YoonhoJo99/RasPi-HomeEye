# mqtt_publisher.py
import time
import paho.mqtt.client as mqtt
from sensors import UltrasonicSensor, HTU21DSensor, LightSensor

def main():
    # MQTT 클라이언트 설정
    client = mqtt.Client()
    client.connect("localhost", 1883, 60)
    
    # 센서 객체 생성
    temp_humid = HTU21DSensor()
    
    try:
        while True:
            # 센서 데이터 읽기
            temp_humid_data = temp_humid.read()
            
            # 센서 데이터 출력
            print("\n=== 센서 데이터 ===")
            print(f"온도: {temp_humid_data['temperature']} °C")
            print(f"습도: {temp_humid_data['humidity']} %")
            print("=================")
            
            # MQTT로 발행
            client.publish("sensors/temperature", str(temp_humid_data["temperature"]))
            client.publish("sensors/humidity", str(temp_humid_data["humidity"]))
            
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
