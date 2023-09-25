from flask import Flask, jsonify
import random

#Flask App Initalisation
app = Flask(__name__)

def generate_random_temperature_celsius():
    # Generate a random temperature between -20°C and 40°C
    temperature = random.uniform(-20, 40)
    return temperature

@app.route('/')
def get_data():
    data = {
        'temperature': generate_random_temperature_celsius()
        'random': random.uniform(0, 10000)
    }
    return jsonify(data)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5500)
