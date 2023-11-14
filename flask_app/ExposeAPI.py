from flask import Flask, jsonify
import random
import time
import sys
import json

#Flask App Initalisation
app = Flask(__name__)

def read_latest_data(file_name):
    try:
        with open(file_name, 'r') as file:
            # Read all lines from the file
            lines = file.readlines()

            # If there are lines in the file, extract the latest data point
            if lines:
                latest_data = lines[-1].strip().split(',')
                headers = lines[0].strip().split(',')

                # Create a JSON object with headers and values
                latest_json = {headers[i]: int(latest_data[i]) for i in range(len(headers))}

                return json.dumps(latest_json, indent=2)
            else:
                return json.dumps({"message": "No data available"}, indent=2)
    except Exception as e:
        return json.dumps({"error": str(e)}, indent=2)

def read_all_data(file_name):
    try:
        with open(file_name, 'r') as file:
            # Read all lines from the file
            lines = file.readlines()

            # Extract headers from the first line
            headers = lines[0].strip().split(',')

            # Initialize an empty list to store JSON objects
            data_list = []

            # Iterate through lines starting from the second line
            for line in lines[1:]:
                data_values = line.strip().split(',')
                # Create a JSON object with headers and values
                data_json = {headers[i]: int(data_values[i]) for i in range(len(headers))}
                data_list.append(data_json)

            return json.dumps(data_list, indent=2)
    except Exception as e:
        return json.dumps({"error": str(e)}, indent=2)



@app.route('/')
def get_data():
    return read_latest_data(file_name)

@app.route('/all')
def get_all_data():
    return read_all_data(file_name)

if __name__ == '__main__':
    if len(sys.argv) != 2:
            print("Usage: python script_name.py <file_name>")
            sys.exit(1)
    file_name = sys.argv[1]
    app.run(host='0.0.0.0', port=5500)

