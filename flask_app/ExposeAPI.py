from flask import Flask, jsonify
import random
import time

#Flask App Initalisation
app = Flask(__name__)

def generate_random_temperature_celsius():
    # Generate a random temperature between -20°C and 40°C
    return random.uniform(-20, 40)

def generate_random_attribute():
    return random.randint(1, 100)

@app.route('/')
def get_data():
    data = {
        'timeStamp': int(time.time()),
        'temperature': generate_random_temperature_celsius(),
        'random': generate_random_attribute()
    }
    return jsonify(data)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5500)
