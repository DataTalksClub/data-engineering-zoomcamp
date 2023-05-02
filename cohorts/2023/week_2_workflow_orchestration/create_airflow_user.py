from airflow import settings
from airflow.www.app import create_app
from airflow.www.security import EXISTING_ROLES
from flask_appbuilder.security.sqla.models import User, Role

username = "your_username"
firstname = "your_firstname"
lastname = "your_lastname"
email = "your_email"
password = "your_password"
role_name = "Admin"

app = create_app(config=settings.AIRFLOW_CONFIG)
appbuilder = app.appbuilder
session = settings.Session()

# Check if the user already exists
user = session.query(User).filter(User.username == username).one_or_none()

if user:
    print(f"User '{username}' already exists.")
else:
    # Create the new user
    role = session.query(Role).filter(Role.name == role_name).one_or_none()

    if role is None:
        print(f"Role '{role_name}' not found.")
    else:
        user = User()
        user.username = username
        user.first_name = firstname
        user.last_name = lastname
        user.email = email
        user.password = appbuilder.sm.hash_password(password)
        user.roles = [role]

        session.add(user)
        session.commit()

        print(f"User '{username}' created successfully.")
session.close()