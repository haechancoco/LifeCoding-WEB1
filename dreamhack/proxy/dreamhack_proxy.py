from flask import Flask, request, Response
import requests

app = Flask(__name__)

# [설정] 본인의 드림핵 문제 주소 (마지막 / 필수)
TARGET_URL = "http://host8.dreamhack.games:22868/"

# 제외할 헤더 (프록시 통신 과정에서 충돌날 수 있는 것들)
EXCLUDED_HEADERS = ['content-encoding', 'content-length', 'transfer-encoding', 'connection']

@app.route('/', defaults={'path': ''}, methods=['GET', 'POST'])
@app.route('/<path:path>', methods=['GET', 'POST'])
def proxy(path):
    # 1. 클라이언트(브라우저)가 보낸 헤더를 그대로 가져옵니다.
    # 단, Host 헤더는 타겟 서버 주소로 바뀌어야 하므로 제외합니다.
    headers = {k: v for k, v in request.headers if k.lower() != 'host'}

    try:
        # 2. 드림핵 서버로 요청 전송 (allow_redirects=False가 핵심!)
        # 리다이렉트를 파이썬이 처리하지 않고, 302 응답 그대로를 받아옵니다.
        resp = requests.request(
            method=request.method,
            url=f"{TARGET_URL}{path}",
            headers=headers,
            data=request.get_data(),
            cookies=request.cookies,
            allow_redirects=False 
        )

        # 3. 드림핵이 준 응답 헤더 중, 문제가 될 수 있는 것을 제외하고 복사합니다.
        response_headers = [
            (k, v) for k, v in resp.headers.items()
            if k.lower() not in EXCLUDED_HEADERS
        ]

        # 4. 내용(content), 상태코드(status_code), 헤더(headers)를 모두 원본 그대로 전달합니다.
        response = Response(resp.content, resp.status_code, response_headers)
        return response

    except Exception as e:
        return f"Proxy Error: {str(e)}"

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)