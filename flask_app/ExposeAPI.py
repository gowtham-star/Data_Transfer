from flask import Flask, jsonify
import random

app = Flask(__name__)

@app.route('/')
def hello_world():
    return 'Hello, Raspberry Pi!'

def generate_random_temperature_celsius():
    # Generate a random temperature between -20°C and 40°C
    temperature = random.uniform(-20, 40)
    return temperature

@app.route('/api/data')
def get_data():
    data = {
        'temperature': generate_random_temperature_celsius()
    }
    return jsonify(data)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5001)
