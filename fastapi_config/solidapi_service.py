from solid.solid_api import SolidAPI
from solid.auth import Auth
from getpass import getpass
import io


class TestSolidAPI2(object):
    def __init__(self, endpoint = None) -> None:
        self.auth = Auth()
        self.api = SolidAPI(self.auth)
        self.idp = "https://solidcommunity.net"
        self.endpoint = endpoint
        self.is_login = False

    
    def login(self, username: str, password: str) -> bool:
        '''
        Login to Solid server, limited to solidcommunity.net
        Parameters:
            username: str - username in plain text (not encrypted), e.g. phitest01
            password: str - password in plain text (not encrypted), e.g. phitest01!
        Returns:
            bool - True if login is successful, False otherwise
        '''
        try:
            self.auth.login(self.idp, username, password)
            print(f'Cookeies info: {self.auth.client.cookies}')
            print(f'Headers: {self.auth.client.headers}')
            print(f'Login status: {self.auth.is_login}')
            # double check login status
            self.is_login = self.auth.is_login
            # set up endpoint if user can login
            if self.is_login:
                self.endpoint = f'https://{username}.solidcommunity.net/'
            return self.is_login
        except Exception as e:
            print(f'Error occurred when logging in: {e}')
            self.is_login = False
            return self.is_login

    def list_items_in_folder(self, folder_url: str) -> dict:
        '''
        List all items (folders and files) in a folder
        Parameters:
            folder_url: str - url of the folder, e.g. https://phitest01.solidcommunity.net/public/phipub/
        Returns:
            dict - a dictionary of items in the folder
        '''
        if self.is_login:
            folder = self.api.read_folder(folder_url)
            subfolders = folder.folders
            subfiles = folder.files
            return {'folders': subfolders, 'files': subfiles}
        else:
            return {'folders': [], 'files': []}


    def read_single_file(self, file_url) -> str:
        '''
        Read a private file from the server
        Parameters:
            file_url: str - url of the file, e.g. https://phitest01.solidcommunity.net/private/phi_private_dir01/phi_private_file01.md
        '''
        if self.is_login:
            try:
                content = self.api.get(file_url).text
                return content
            except Exception as e:
                print(f'Error occurred when reading file: {e}')
        return ''