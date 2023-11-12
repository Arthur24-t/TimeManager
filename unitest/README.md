# Time Manager - Unit Test

## Overview

The Time Manager project is a mobile application that helps users manage their time efficiently. It consists of three main components:
1. **Frontend**: The application's user interface built using Flutter.
2. **API**: The backend that processes requests and interacts with the database.
3. **Database**: Stores all the data required by the application.

This section contains unit tests to **ensure** the quality of the API of the project.

## Table of Content

1. [Introduction](#introduction)
2. [Installation](#installation)
3. [Running Tests](#running-tests)
6. [Contributing](#contributing)
7. [Notes](#notes)
8. [License](#license)

## Introduction

Unit tests are crucial for ensuring the robustness and reliability of code. This project utilizes Python's built-in testing module to write and execute unit tests.

## Installation

Before running the tests, make sure to have **Python** installed on your machine. You can install the necessary dependencies by running the following command in your terminal:

```bash
pip install -r requirements.txt
```

## Running Tests

To run all unit tests:
1. Go to the correct directory after cloning the repo:
```bash
cd unitest
```
2. Execute the following command:
```bash
python -m pytest runTest.py
```

## Contributing

Contributions to TimeManager application are welcome! Feel free to open issues and pull requests to improve the project.

## Notes

- Ensure your virtual environment is activated before installing dependencies and running tests.
- Remember to update tests after every significant code modification.
