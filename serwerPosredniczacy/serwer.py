from flask import Flask, request, jsonify
from flask_cors import CORS
import mysql.connector

app = Flask(__name__)
CORS(app)

# Konfiguracja połączenia z bazą danych
mydb = mysql.connector.connect(
  host="localhost",
  user="root",
  password="",
  database="projektIPZ"
)

@app.route('/register', methods=['POST'])
def register():
    try:
        data = request.get_json()
        nickname = data['nickname']
        email = data['email']
        password = data['password']

        cursor = mydb.cursor()
        sql = "INSERT INTO users (nickname, email, password) VALUES (%s, %s, %s)"
        val = (nickname, email, password)
        cursor.execute(sql, val)
        mydb.commit()

        return jsonify({'message': 'Użytkownik zarejestrowany'}), 201
    except mysql.connector.Error as err:
        if err.errno == 1062:  # Duplicate entry error
            return jsonify({'error': 'Taki użytkownik już istnieje'}), 409
        else:
            return jsonify({'error': str(err)}), 500

@app.route('/login', methods=['POST'])
def login():
    try:
        data = request.get_json()
        email = data['email']
        password = data['password']

        cursor = mydb.cursor(dictionary=True)
        sql = "SELECT * FROM users WHERE email = %s AND password = %s"
        val = (email, password)
        cursor.execute(sql, val)
        user = cursor.fetchone()

        if user:
            return jsonify({'message': 'Zalogowano pomyślnie', 'user': user}), 200
        else:
            return jsonify({'message': 'Nieprawidłowy email lub hasło'}), 401
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/events', methods=['POST'])
def add_event():
    try:
        data = request.get_json()
        cursor = mydb.cursor()
        sql = """
        INSERT INTO Events (id, name, location, type, start_date, max_participants, registered_participants, image)
        VALUES (%s, %s, %s, %s, %s, %s, %s, %s)
        """
        val = (
            data['id'],
            data['name'],
            data['location'],
            data['type'],
            data['start_date'],
            data['max_participants'],
            data['registered_participants'],
            data['image'],
        )
        cursor.execute(sql, val)
        mydb.commit()
        return jsonify({'message': 'Wydarzenie dodane pomyślnie'}), 201
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/events/<event_id>', methods=['PUT'])
def update_event(event_id):
    try:
        data = request.get_json()
        cursor = mydb.cursor()
        sql = """
        UPDATE Events
        SET name = %s, location = %s, type = %s, start_date = %s, max_participants = %s, registered_participants = %s, image = %s
        WHERE id = %s
        """
        val = (
            data['name'],
            data['location'],
            data['type'],
            data['start_date'],
            data['max_participants'],
            data['registered_participants'],
            data['image'],
            event_id
        )
        cursor.execute(sql, val)
        mydb.commit()
        return jsonify({'message': 'Wydarzenie zaktualizowane pomyślnie'}), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/events/<event_id>', methods=['DELETE'])
def delete_event(event_id):
    try:
        cursor = mydb.cursor()
        sql = "DELETE FROM Events WHERE id = %s"
        cursor.execute(sql, (event_id,))
        mydb.commit()
        return jsonify({'message': 'Wydarzenie usunięte pomyślnie'}), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500

if __name__ == '__main__':
    app.run(debug=True)