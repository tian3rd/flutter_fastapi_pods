# Demo to login to SolidPod in a Flutter app

> Clone this repository. Note that this repository contains two parts: FastAPI to run on a local server, and a Flutter app to communicate with the server to login to SolidPod service.

![workflow](https://cdn-std.droplr.net/files/acc_498334/W4bKy3)

## FastAPI

```bash
cd fastapi_config
# recommend to create a local virtual environment
# make sure to install the dependencies:
pip install -r requirements.txt
# run the server
uvicorn main:app --reload
# now the server is running on 127.0.0.1
```

## Flutter

```bash
cd flutter_app
# make sure to install the dependencies:
flutter pub get
# run the app
```

## Demo

![demo0.2](https://cdn-std.droplr.net/files/acc_498334/YN6HvK)

Use the following credentials to login to SolidPod:

> username: `phitest01`
> password: `phitest01!`
