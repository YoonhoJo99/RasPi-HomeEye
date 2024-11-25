# 필요한 라이브러리 임포트
import asyncio         # 비동기 프로그래밍을 위한 라이브러리
import websockets     # WebSocket 서버 구현을 위한 라이브러리
import cv2           # OpenCV: 카메라 제어 및 이미지 처리 라이브러리
import numpy as np   # 숫자 계산을 위한 라이브러리

# 비동기 함수 정의: WebSocket 클라이언트와 연결되면 실행되는 함수
async def stream_video(websocket):
    # VideoCapture(0): 기본 카메라(웹캠) 열기
    cap = cv2.VideoCapture(0)
    
    try:
        while True:
            # 카메라에서 프레임 읽기
            ret, frame = cap.read()
            # ret: 프레임 읽기 성공 여부 (True/False)
            # frame: 실제 이미지 데이터
            
            if not ret:
                break  # 프레임 읽기 실패시 종료
            
            # 프레임을 JPEG 형식으로 인코딩
            # imencode() 반환값: (성공여부, 인코딩된 이미지)
            _, buffer = cv2.imencode('.jpg', frame)
            
            # 인코딩된 이미지를 바이트 형식으로 변환하여 전송
            await websocket.send(buffer.tobytes())
            
            # 30fps를 위한 대기 (1초 / 30 ≈ 0.033초)
            await asyncio.sleep(0.033)
            
    finally:
        # 무슨 일이 있어도 카메라는 반드시 해제
        cap.release()

# 메인 비동기 함수
async def main():
    # WebSocket 서버 시작
    # serve(): WebSocket 서버 생성
    # "0.0.0.0": 모든 IP에서의 접속 허용
    # 8080: 사용할 포트 번호
    async with websockets.serve(stream_video, "0.0.0.0", 8080):
        # 서버를 계속 실행하기 위한 코드
        await asyncio.Future()

# 스크립트가 직접 실행될 때만 실행
if __name__ == '__main__':
    # 비동기 이벤트 루프 시작
    asyncio.run(main())
