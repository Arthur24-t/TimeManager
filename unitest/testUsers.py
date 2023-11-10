import pytest
import requests

BASE_URL = "http://localhost:4000"

@pytest.fixture(scope="module")
def session():
    # Create a session object that will be used for all requests
    session = requests.Session()
    login_url = f"{BASE_URL}/login"
    credentials = {"user": {
        "email": "testerUser@example.com",
        "password": "strong_password"
    }}
    response = session.post(login_url, json=credentials)
    assert response.status_code == 200
    jwt_token = response.json().get('token')
    session.headers.update({'Authorization': f'Bearer {jwt_token}'})
    yield session  # Tout ce qui précède est exécuté avant les tests, tout ce qui suit après les tests

    session.close()
def test_request_with_session(session):
    response = session.get(f"{BASE_URL}/api/users")
    assert response.status_code == 200
   
@pytest.fixture(scope="module")
def login_user():
    register_url = f"{BASE_URL}/login"
    user_data = {
        "user": {
            "email": "testerUser@example.com",
            "password": "strong_password"
        }
    }
    response = requests.post(register_url, json=user_data)
    assert response.status_code == 200
    # If the user ID is returned in the response, capture it
    user_id = response.json().get('user').get('id')
    return user_id, user_data['user']['email'], user_data['user']['password']

def test_create_user(session):
    user_data = {
        "user": {
            "username": "testuser",
            "email": "testuser@testuser.com",
            "password": "1234",
            "role" : "user"
        }
    }
    url = f"{BASE_URL}/api/users"
    response = session.post(url, json=user_data)
    assert response.status_code == 403

def test_create_admin(session):
    user_data = {
        "user": {
            "username": "testadmin",
            "email": "testadmin@testadmin.com",
            "password": "1234",
            "role" : "admin"
        }
    }
    url = f"{BASE_URL}/api/users"
    response = session.post(url, json=user_data)
    assert response.status_code == 403

def test_create_superadmin(session):
    user_data = {
        "user": {
            "username": "testsuperadmin",
            "email": "testsuperadmin@testsuperadmin.com",
            "password": "1234",
            "role" : "superadmin"
        }
    }
    url = f"{BASE_URL}/api/users"
    response = session.post(url, json=user_data)
    assert response.status_code == 403

@pytest.fixture(scope="module")
def created_team(session):
    create_team_url = f"{BASE_URL}/api/teams"
    team_name = "testteam"
    team_data = {
        "team": {
            "name": team_name
        }
    }
    response = session.post(create_team_url, json=team_data)
    assert response.status_code == 403

@pytest.fixture(scope="module") 
def test_create_clock(session , login_user):
    user_id, _, _ = login_user
    clock_data = {
        "clock": {
            "time": "2023-10-12 12:13:12",
            "status": True
        }
    }
    url = f"{BASE_URL}/api/clocks/{user_id}"
    response = session.post(url, json=clock_data)
    assert response.status_code == 201
    return response.json().get('data').get('id')


def test_get_clock(session , login_user):
    user_id, _, _ = login_user
    url = f"{BASE_URL}/api/clocks/{user_id}"
    response = session.get(url)
    assert response.status_code == 200
    
@pytest.fixture(scope="module") 
def test_create_working_time(session , login_user):
    user_id, _, _ = login_user
    
    working_time_data = {
        "working_time": {
            "start": "2023-07-01 12:12:12",
            "end": "2023-07-12 19:12:12"
        } 
    }
    url = f"{BASE_URL}/api/workingtimes/{user_id}"
    response = session.post(url, json=working_time_data)
    assert response.status_code == 201
    return response.json().get('data').get('id')


def test_get_working_time(session, login_user):
    user_id, _, _ = login_user
    url = f"{BASE_URL}/api/workingtimes/{user_id}?start=2001-01-12 12:45:14&end=2030-12-12 12:45:14"
    response = session.get(url)
    assert response.status_code == 200

def test_update_working_time(session , test_create_working_time):
    working_time_id = test_create_working_time
    working_time_data = {
    "working_time": {
        "start": "2023-07-01 12:12:13",
        "end": "2023-07-12 19:12:13"
    } 
}
    url = f"{BASE_URL}/api/workingtimes/{working_time_id}"
    response = session.put(url, json=working_time_data)
    assert response.status_code == 200

def test_delete_working_time(session , test_create_working_time):
    working_time_id = test_create_working_time
    url = f"{BASE_URL}/api/workingtimes/{working_time_id}"
    response = session.delete(url)
    assert response.status_code == 204


def test_add_team_to_user(session, created_team, login_user):
    user_id, _, _ = login_user
    team_id = created_team
    url = f"{BASE_URL}/api/users/{user_id}/teams/{team_id}"
    response = session.post(url)
    assert response.status_code == 403

def test_get_all_team(session):
    url = f"{BASE_URL}/api/teams/"
    response = session.get(url)
    assert response.status_code == 403
    
def test_remove_team_from_user(session, created_team, login_user):
    user_id, _, _ = login_user
    team_id = created_team
    url = f"{BASE_URL}/api/users/{user_id}/teams/{team_id}"
    response = session.delete(url)
    assert response.status_code == 403
    
