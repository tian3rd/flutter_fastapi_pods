from fastapi import Body, FastAPI, Response, status

from solidapi_service import SolidAPIService

app = FastAPI()

# config
solid_api_service = SolidAPIService()
is_login = False


@app.get("/")
def root():
    return {"message": "Hello World!"}


@app.post('/login')
def login(body: dict, response: Response) -> dict:
    '''
    Login to Solid server, limited to solidcommunity.net
    Parameters:
        body: dict - username and password in plain text (not encrypted)
    Returns:
        dict - login status with files and folders in the root folder
    '''
    print(f'You sent: \n{body}')
    username = body['email']
    password = body['password']
    if not solid_api_service.login(username, password):
        response.status_code = status.HTTP_401_UNAUTHORIZED
        return {"message": "Login failed.",
                "items": {}}
    response.status_code = status.HTTP_200_OK
    global is_login
    is_login = True
    public_folder_url = solid_api_service.endpoint + 'public/'
    private_folder_url = solid_api_service.endpoint + 'private/'
    items_in_public = solid_api_service.list_items_in_folder(public_folder_url)
    items_in_private = solid_api_service.list_items_in_folder(private_folder_url)
    return {"message": "Login successful.",
            "items_public": items_in_public,
            "items_private": items_in_private}


@app.post('/logout')
def logout(response: Response) -> dict:
    '''
    Logout from Solid server
    Parameters:
        None
    Returns:
        dict - logout status
    '''
    global is_login
    if not is_login:
        response.status_code = status.HTTP_401_UNAUTHORIZED
        return {"message": "You are not logged in."}
    is_login = False
    response.status_code = status.HTTP_200_OK
    return {"message": "Logout successful."}


@app.get("/samplefile")
def get_sample_file_content() -> dict:
    '''
    Read a public/private sample file from the server
    Parameters:
        None
    Returns:
        dict - content of the sample file
    '''
    if not is_login:
        return {"message": "Login first."}
    sample_file_url = "https://phitest01.solidcommunity.net/private/phi_private_dir01/phi_private_file01.md"
    return {"content": solid_api_service.read_single_file(sample_file_url)}

