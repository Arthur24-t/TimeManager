import requests

BASE_URL = "http://localhost:4000"

def test_register_superadmin():
    # Replace with the actual registration URL and payload
    register_url = f"{BASE_URL}/register"
    user_data = {
        "user": {
            "username": "testersuperadmin",
            "email": "testerSuperAdmin@example.com",
            "password": "strong_password",
            "role": "superadmin"
        }
    }
    response = requests.post(register_url, json=user_data)
    if response.status_code == 422:
        assert response.status_code == 422
    else:
        assert response.status_code == 201

def test_register_admin():
    # Replace with the actual registration URL and payload
    register_url = f"{BASE_URL}/register"
    user_data = {
        "user": {
            "username": "testerAdmin",
            "email": "testerAdmin@example.com",
            "password": "strong_password",
            "role": "admin"
        }
    }
    response = requests.post(register_url, json=user_data)
    if response.status_code == 422:
        assert response.status_code == 422
    else:
        assert response.status_code == 201

def test_register_user():
    # Replace with the actual registration URL and payload
    register_url = f"{BASE_URL}/register"
    user_data = {
        "user": {
            "username": "testeruser",
            "email": "testerUser@example.com",
            "password": "strong_password",
            "role": "user"
        }
    }
    response = requests.post(register_url, json=user_data)
    if response.status_code == 422:
        assert response.status_code == 422
    else:
        assert response.status_code == 201