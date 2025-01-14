from flask import Flask, request, jsonify
from flask_cors import CORS
import mysql.connector

app = Flask(__name__)
CORS(app)

# Konfiguracja połączenia z bazą danych
mydb = mysql.connector.connect(
  host="localhost",  # Zmień na adres IP komputera, jeśli to konieczne
  user="root",
  password="",
  database="projektIPZ"
)

@app.route('/register', methods=['POST'])
def register():
    try:
        data = request.get_json()
        email = data['email']
        password = data['password']

        cursor = mydb.cursor()
        sql = "INSERT INTO users (email, password) VALUES (%s, %s)"
        val = (email, password)
        cursor.execute(sql, val)
        mydb.commit()

        return jsonify({'message': 'Użytkownik zarejestrowany'}), 201
    except mysql.connector.Error as err:
        if err.errno == 1062:  # Duplicate entry error
            return jsonify({'error': 'Użytkownik o podanym adresie email już istnieje'}), 409
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

if __name__ == '__main__':
    app.run(debug=True)