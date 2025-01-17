import smtplib
from email.mime.text import MIMEText
from flask import Flask, request, jsonify
from flask_cors import CORS
import mysql.connector
import secrets
from dotenv import load_dotenv
import os

load_dotenv()

app = Flask(__name__)
CORS(app)

# Konfiguracja połączenia z bazą danych
mydb = mysql.connector.connect(
    host="212.127.78.92",
    user="user",
    password="ipz2137",
    database="userDatabase",
    auth_plugin="mysql_native_password"
)

MAIL_USERNAME = "ipezet2025@gmail.com"
MAIL_PASSWORD = "gpky wyzr vkef wzid"

@app.route('/register', methods=['POST'])
def register():
    try:
        data = request.get_json()
        nickname = data['nickname']
        email = data['email']
        password = data['password']

        cursor = mydb.cursor()
        # Generowanie unikalnego tokenu weryfikacyjnego
        verification_token = secrets.token_urlsafe(32)

        sql = """
        INSERT INTO users (nickname, email, password, is_verified, verification_token)
        VALUES (%s, %s, %s, %s, %s)
        """
        val = (nickname, email, password, 0, verification_token)
        cursor.execute(sql, val)
        mydb.commit()

        # Wysyłanie e-maila weryfikacyjnego
        verification_link = f"http://localhost:5000/verify_email?token={verification_token}"
        msg = MIMEText(f"Kliknij poniższy link, aby zweryfikować swój adres e-mail:\n{verification_link}")
        msg['Subject'] = "Weryfikacja adresu e-mail"
        msg['From'] = MAIL_USERNAME
        msg['To'] = email

        try:
            server = smtplib.SMTP('smtp.gmail.com', 587)
            server.starttls()
            server.login(MAIL_USERNAME, MAIL_PASSWORD)
            server.send_message(msg)
            server.quit()
        except Exception as e:
            return jsonify({'error': f"Nie udało się wysłać e-maila: {str(e)}"}), 500

        return jsonify({'message': 'Użytkownik zarejestrowany. Sprawdź swoją skrzynkę e-mail, aby zweryfikować konto.'}), 201
    except mysql.connector.Error as err:
        if err.errno == 1062:  # Duplicate entry error
            return jsonify({'error': 'Taki użytkownik już istnieje'}), 409
        else:
            return jsonify({'error': str(err)}), 500

@app.route('/verify_email', methods=['GET'])
def verify_email():
    token = request.args.get('token')

    if not token:
        return jsonify({'error': 'Brak tokenu weryfikacyjnego'}), 400

    try:
        cursor = mydb.cursor()
        # Weryfikacja tokenu i aktualizacja pola is_verified
        sql = "SELECT id FROM users WHERE verification_token = %s"
        cursor.execute(sql, (token,))
        user = cursor.fetchone()

        if not user:
            return jsonify({'error': 'Nieprawidłowy token weryfikacyjny'}), 400

        update_sql = "UPDATE users SET is_verified = 1, verification_token = NULL WHERE id = %s"
        cursor.execute(update_sql, (user[0],))
        mydb.commit()

        return jsonify({'message': 'E-mail został zweryfikowany pomyślnie'}), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500

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
            if user['is_verified'] == 0:
                return jsonify({'message': 'Adres e-mail nie został zweryfikowany'}), 403
            # Generowanie tokenu dla zalogowanego użytkownika
            token = secrets.token_urlsafe(32)
            update_sql = "UPDATE users SET token = %s WHERE email = %s"
            update_val = (token, user['email'])
            cursor.execute(update_sql, update_val)
            mydb.commit()

            # Zwracamy token w odpowiedzi
            return jsonify({'message': 'Zalogowano pomyślnie', 'user': user, 'token': token}), 200
        else:
            return jsonify({'message': 'Nieprawidłowy email lub hasło'}), 401
    except Exception as e:
        print(e)
        return jsonify({'error': str(e)}), 500

@app.route('/verify_token', methods=['GET'])
def verify_token():
    token = request.headers.get('Authorization')
    if token:
        token = token.split(" ")[1]  # Usuń prefix "Bearer "

        cursor = mydb.cursor(dictionary=True)
        sql = "SELECT * FROM users WHERE token = %s"
        val = (token,)
        cursor.execute(sql, val)
        user = cursor.fetchone()

        if user:
            # Token jest ważny
            return jsonify({'message': 'Token jest ważny'}), 200
        else:
            # Token jest nieważny
            return jsonify({'message': 'Token jest nieważny'}), 401
    else:
        return jsonify({'message': 'Brak tokenu'}), 401

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

@app.route('/delete_account', methods=['DELETE'])
def delete_account():
    token = request.headers.get('Authorization')
    if token:
        token = token.split(" ")[1]  # Usuń prefix "Bearer "
        cursor = mydb.cursor()

        # Pobierz użytkownika na podstawie tokenu
        sql_select = "SELECT id FROM users WHERE token = %s"
        cursor.execute(sql_select, (token,))
        user = cursor.fetchone()

        if user:
            user_id = user[0]
            sql_delete = "DELETE FROM users WHERE id = %s"
            cursor.execute(sql_delete, (user_id,))
            mydb.commit()
            return jsonify({'message': 'Konto zostało usunięte'}), 200
        else:
            return jsonify({'error': 'Nieprawidłowy token'}), 401
    else:
        return jsonify({'error': 'Brak tokenu'}), 401

@app.route('/change_password', methods=['POST'])
def change_password():
    try:
        data = request.get_json()
        email = data['email']
        new_password = data['new_password']

        cursor = mydb.cursor()
        sql_check = "SELECT id FROM users WHERE email = %s"
        cursor.execute(sql_check, (email,))
        user = cursor.fetchone()

        if not user:
            return jsonify({'error': 'Użytkownik o podanym emailu nie istnieje'}), 404

        sql_update = "UPDATE users SET password = %s WHERE email = %s"
        cursor.execute(sql_update, (new_password, email))
        mydb.commit()

        return jsonify({'message': 'Hasło zostało zmienione'}), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/verify_password', methods=['POST'])
def verify_password():
    try:
        token = request.headers.get('Authorization')
        if not token:
            return jsonify({'error': 'Brak tokenu'}), 401

        token = token.split(" ")[1]  # Usuń prefix "Bearer "
        data = request.get_json()
        password = data['password']

        cursor = mydb.cursor(dictionary=True)
        sql = "SELECT password FROM users WHERE token = %s"
        cursor.execute(sql, (token,))
        user = cursor.fetchone()

        if not user or user['password'] != password:
            return jsonify({'error': 'Nieprawidłowe hasło'}), 401

        return jsonify({'message': 'Hasło poprawne'}), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/events', methods=['GET'])
def get_all_events():
    try:
        cursor = mydb.cursor(dictionary=True)
        sql = "SELECT * FROM Events"
        cursor.execute(sql)
        events = cursor.fetchall()

        # Konwersja datetime na string
        for event in events:
            event['start_date'] = event['start_date'].strftime('%Y-%m-%d %H:%M:%S')

        return jsonify(events), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
