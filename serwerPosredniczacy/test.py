import smtplib
from email.mime.text import MIMEText

MAIL_USERNAME = "ipezet2025@gmail.com"
MAIL_PASSWORD = "gpky wyzr vkef wzid"

msg = MIMEText("Test wiadomości")
msg['Subject'] = "Test"
msg['From'] = MAIL_USERNAME
msg['To'] = "nivemof571@citdaca.com"

try:
    server = smtplib.SMTP('smtp.gmail.com', 587)
    server.starttls()
    server.login(MAIL_USERNAME, MAIL_PASSWORD)
    server.send_message(msg)
    server.quit()
    print("E-mail wysłany pomyślnie")
except Exception as e:
    print("Błąd:", e)
