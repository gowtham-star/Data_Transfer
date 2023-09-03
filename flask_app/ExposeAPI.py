from flask import Flask, jsonify

app = Flask(__name__)

@app.route('/')
def hello_world():
    return 'Hello, Raspberry Pi!'

@app.route('/api/data')
def get_data():
    data = {
        'temperature': 25.5,
        'humidity': 60.2
    }
    return jsonify(data)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5001)
