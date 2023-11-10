import pytest
import requests

BASE_URL = "http://localhost:4000"

@pytest.fixture(scope="module")
def session():
    # Create a session object that will be used for all requests
    session = requests.Session()
    login_url = f"{BASE_URL}/login"
    credentials = {"user": {
        "email": "tester@example.com",
        "password": "strong_password"
    }}
    response = session.post(login_url, json=credentials)
    assert response.status_code == 200
    jwt_token = response.json().get('token')
    session.headers.update({'Authorization': f'Bearer {jwt_token}'})
    yield session  # Tout ce qui précède est exécuté avant les tests, tout ce qui suit après les tests

    # Your code to close the session goes here
    session.close()
def test_request_with_session(session):
    response = session.get(f"{BASE_URL}/api/users")
    assert response.status_code == 200
    

@pytest.fixture(scope="module")
def login_user():
    # Replace with the actual registration URL and payload
    register_url = f"{BASE_URL}/login"
    user_data = {
        "user": {
            "email": "tester@example.com",
            "password": "strong_password"
        }
    }
    response = requests.post(register_url, json=user_data)
    assert response.status_code == 200
    # If the user ID is returned in the response, capture it
    user_id = response.json().get('user').get('id')
    return user_id, user_data['user']['email'], user_data['user']['password']

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
    
    if response.status_code == 201:
        team_id = response.json().get('data').get('id')

    elif response.status_code == 422:
        all_teams_response = session.get(f"{BASE_URL}/api/teams")
        assert all_teams_response.status_code == 200
        teams = all_teams_response.json().get('data', [])
        team = next((team for team in teams if team.get('name') == team_name), None)
        assert team is not None, f"Team with name {team_name} not found."
        team_id = team.get('id')
    else:
        pytest.fail(f"Unexpected status code: {response.status_code}")

    return team_id


def test_add_team_to_user(session, created_team, login_user):
    user_id, _, _ = login_user
    team_id = created_team
    url = f"{BASE_URL}/api/users/{user_id}/teams/{team_id}"
    response = session.post(url)
    assert response.status_code == 200

def test_get_all_team(session):
    url = f"{BASE_URL}/api/teams/"
    response = session.get(url)
    assert response.status_code == 200
    
def test_remove_team_from_user(session, created_team, login_user):
    user_id, _, _ = login_user
    team_id = created_team
    url = f"{BASE_URL}/api/users/{user_id}/teams/{team_id}"
    response = session.delete(url)
    assert response.status_code == 200


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
    url = f"{BASE_URL}/api/workingtimes/{user_id}?start=2001-01-12T12:45:14Z&end=2030-12-12T12:45:14Z"
    response = session.get(url)
    assert response.status_code == 200

def test_update_working_time(session , test_create_working_time):
    working_time_data = {
    "working_time": {
        "start": "2023-07-01 12:12:13",
        "end": "2023-07-12 19:12:13"
    } 
}
    url = f"{BASE_URL}/api/workingtimes/{test_create_working_time}"
    response = session.put(url, json=working_time_data)
    assert response.status_code == 200

def test_delete_working_time(session , test_create_working_time):
    url = f"{BASE_URL}/api/workingtimes/{test_create_working_time}"
    response = session.delete(url)
    assert response.status_code == 204


@pytest.fixture(scope="module")
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
    assert response.status_code == 201
    return response.json().get('user').get('id')

@pytest.fixture(scope="module")
def test_superadmin_create_clock_for_user(session, test_create_user):
    user_id = test_create_user
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

def test_superadmin_get_clock_for_user(session , test_create_user):
    user_id, _, _ = test_create_user
    url = f"{BASE_URL}/api/clocks/{user_id}"
    response = session.get(url)
    assert response.status_code == 200

@pytest.fixture(scope="module")
def test_superadmin_create_working_time_for_user(session, test_create_user):
    user_id = test_create_user
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


def test_superadmin_update_working_time_for_user(session, test_superadmin_create_working_time_for_user):
    working_time_id = test_superadmin_create_working_time_for_user
    update_data = {
        "working_time": {
            "start": "2023-07-01 09:00:00",
            "end": "2023-07-01 18:00:00"
        } 
    }
    url = f"{BASE_URL}/api/workingtimes/{working_time_id}"
    response = session.put(url, json=update_data)
    assert response.status_code == 200

def test_superadmin_delete_working_time_for_user(session, test_superadmin_create_working_time_for_user):
    working_time_id = test_superadmin_create_working_time_for_user
    url = f"{BASE_URL}/api/workingtimes/{working_time_id}"
    response = session.delete(url)
    assert response.status_code == 204



@pytest.fixture(scope="module") 
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
    assert response.status_code == 201
    return response.json().get('user').get('id')

@pytest.fixture(scope="module")
def test_superadmin_create_clock_for_admin(session, test_create_admin):
    user_id = test_create_admin
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

def test_superadmin_get_clock_for_user(session , test_create_admin):
    user_id = test_create_admin
    url = f"{BASE_URL}/api/clocks/{user_id}"
    print(url)
    response = session.get(url)
    assert response.status_code == 200

@pytest.fixture(scope="module")
def test_superadmin_create_working_time_for_admin(session, test_create_admin):
    user_id = test_create_admin
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

def test_superadmin_update_working_time_for_admin(session, test_superadmin_create_working_time_for_admin):
    working_time_id = test_superadmin_create_working_time_for_admin
    update_data = {
        "working_time": {
            "start": "2023-07-01 09:00:00",
            "end": "2023-07-01 18:00:00"
        } 
    }
    url = f"{BASE_URL}/api/workingtimes/{working_time_id}"
    response = session.put(url, json=update_data)
    assert response.status_code == 200

def test_superadmin_delete_working_time_for_admin(session, test_superadmin_create_working_time_for_admin):
    working_time_id = test_superadmin_create_working_time_for_admin
    url = f"{BASE_URL}/api/workingtimes/{working_time_id}"
    response = session.delete(url)
    assert response.status_code == 204