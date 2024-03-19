import sys
import os
import json
import time
import webbrowser
import urllib.parse
from datetime import date
import inspect
import logging
import logging.handlers

from .launcher import Launcher

PLUGIN_MANIFEST = 'plugin.json'
FLOW_API = 'Flow.Launcher'
WOX_API = 'Wox'
LOCALAPPDATA = os.getenv('LOCALAPPDATA')
FILE_PATH = os.path.dirname(os.path.abspath(__file__))
CWD = os.getcwd()
APP_DIR = ""

if "UserData" in CWD.split(os.path.sep):
    idx = int(CWD.split(os.path.sep).index("UserData"))
    APP_DIR = os.path.sep.join(CWD.split(os.path.sep)[:idx])
elif "UserData" in FILE_PATH.split(os.path.sep):
    idx = int(FILE_PATH.split(os.path.sep).index("UserData"))
    APP_DIR = os.path.sep.join(FILE_PATH.split(os.path.sep)[:idx])
else:
    _appdirs = os.listdir(os.path.join(LOCALAPPDATA, "FlowLauncher"))
    _versions = []
    for dir in _appdirs:
        if "app-" in dir:
            _version = dir.split("app-")[1]
            _version = tuple(map(int, (_version.split("."))))
            _versions.append(_version)
    _version = ".".join(map(str, max(_versions)))
    _dir = f"app-{_version}"
    APP_DIR = os.path.join(LOCALAPPDATA, "FlowLauncher", _dir )
    

APP_ICONS = os.path.join(APP_DIR, "Images")
ICON_APP = os.path.join(APP_ICONS, 'app.png')
ICON_APP_ERROR = os.path.join(APP_ICONS, 'app_error.png')
ICON_BROWSER = os.path.join(APP_ICONS, 'browser.png')
ICON_CALCULATOR = os.path.join(APP_ICONS, 'calculator.png')
ICON_CANCEL = os.path.join(APP_ICONS, 'cancel.png')
ICON_CLOSE = os.path.join(APP_ICONS, 'close.png')
ICON_CMD = os.path.join(APP_ICONS, 'cmd.png')
ICON_COLOR = os.path.join(APP_ICONS, 'color.png')
ICON_CONTROL_PANEL = os.path.join(APP_ICONS, 'ControlPanel.png')
ICON_COPY = os.path.join(APP_ICONS, 'copy.png')
ICON_DELETE_FILE_FOLDER = os.path.join(APP_ICONS, 'deletefilefolder.png')
ICON_DISABLE = os.path.join(APP_ICONS, 'disable.png')
ICON_DOWN = os.path.join(APP_ICONS, 'down.png')
ICON_EXE = os.path.join(APP_ICONS, 'exe.png')
ICON_FILE = os.path.join(APP_ICONS, 'file.png')
ICON_FIND = os.path.join(APP_ICONS, 'find.png')
ICON_FOLDER = os.path.join(APP_ICONS, 'folder.png')
ICON_HISTORY = os.path.join(APP_ICONS, 'history.png')
ICON_IMAGE = os.path.join(APP_ICONS, 'image.png')
ICON_LOCK = os.path.join(APP_ICONS, 'lock.png')
ICON_LOGOFF = os.path.join(APP_ICONS, 'logoff.png')
ICON_OK = os.path.join(APP_ICONS, 'ok.png')
ICON_OPEN = os.path.join(APP_ICONS, 'open.png')
ICON_PICTURES = os.path.join(APP_ICONS, 'pictures.png')
ICON_PLUGIN = os.path.join(APP_ICONS, 'plugin.png')
ICON_PROGRAM = os.path.join(APP_ICONS, 'program.png')
ICON_RECYCLEBIN = os.path.join(APP_ICONS, 'recyclebin.png')
ICON_RESTART = os.path.join(APP_ICONS, 'restart.png')
ICON_SEARCH = os.path.join(APP_ICONS, 'search.png')
ICON_SETTINGS = os.path.join(APP_ICONS, 'settings.png')
ICON_SHELL = os.path.join(APP_ICONS, 'shell.png')
ICON_SHUTDOWN = os.path.join(APP_ICONS, 'shutdown.png')
ICON_SLEEP = os.path.join(APP_ICONS, 'sleep.png')
ICON_UP = os.path.join(APP_ICONS, 'up.png')
ICON_UPDATE = os.path.join(APP_ICONS, 'update.png')
ICON_URL = os.path.join(APP_ICONS, 'url.png')
ICON_USER = os.path.join(APP_ICONS, 'user.png')
ICON_WARNING = os.path.join(APP_ICONS, 'warning.png')
ICON_WEB_SEARCH = os.path.join(APP_ICONS, 'web_search.png')
ICON_WORK = os.path.join(APP_ICONS, 'work.png')


class Flox(Launcher):

    def __init__(self, lib=None):
        self._start = time.time()
        self._api = None
        self._manifest = None
        self._results = []
        self._plugindir = None
        self._appdata = None
        self.appdir = APP_DIR
        self._app_settings = None
        self._user_keywords = None
        self._appversion = None
        self._logger = None
        self.except_results = False
        self._settings_path = None
        self._settings = None
        if lib:
            lib_path = os.path.join(self.plugindir, lib)
            sys.path.append(lib_path)
        super().__init__()


    def _query(self, query):
        try:
            self.args = query.lower()

            self.query(query)

        except Exception as e:
            if self.except_results:
                self._add_except(e)
            else:
                raise
        return self._results

    def _context_menu(self, data):
        try:

            self.context_menu(data)

        except Exception as e:
            if self.except_results:
                self._add_except(e)
            else:
                raise
        return self._results

    def _add_except(self, e):
        self.add_item(
            title=e.__class__.__name__,
            subtitle=str(e),
            icon=ICON_APP_ERROR,
            method='github_issue',
            parameters=[e.__class__.__name__]
        )

    def github_issue(self, title, log=None):
        url = self.manifest['Website']
        if 'github' in url.lower():
            if log is None:
                with open(self.applog, 'r') as l:
                    log = l.readlines()[-50:]
            error_msg = urllib.parse.quote_plus(''.join(log))
            issue_body = f"Please+type+any+relevant+information+here%0A%0A%0A%0A%0A%0A%3Cdetails%3E%3Csummary%3EError+Log%3C%2Fsummary%3E%0A%3Cp%3E%0A%0A%60%60%60%0A{error_msg}%0A%60%60%60%0A%3C%2Fp%3E%0A%3C%2Fdetails%3E"
            url = f"{url}/issues/new?title={title}&body={issue_body}"
        webbrowser.open(url)

    def add_item(self, title, subtitle='', icon=None, method=None, parameters=None, context=None, hide=False):

        item = {
            "Title": title,
            "SubTitle": subtitle,
            "IcoPath": icon or self.icon,
            "ContextData": context,
            "JsonRPCAction": {}
        }
        if method:
            item['JsonRPCAction']['method'] = getattr(method, "__name__", method)
            item['JsonRPCAction']['parameters'] = parameters or []
        if hide:
            item['JsonRPCAction']['dontHideAfterAction'] = hide        
        self._results.append(item)
        return item

    @property
    def plugindir(self):

        if not self._plugindir:
            potential_paths = [
                os.path.abspath(os.getcwd()),
                os.path.dirname(os.path.abspath(os.path.dirname(__file__)))
            ]

            for path in potential_paths:

                while True:
                    if os.path.exists(os.path.join(path, PLUGIN_MANIFEST)):
                        self._plugindir = path
                        break
                    elif path == '/':
                        break

                    path = os.path.dirname(path)

                if self._plugindir:
                    break

        return self._plugindir

    @property
    def manifest(self):
        if not self._manifest:
            with open(os.path.join(self.plugindir, PLUGIN_MANIFEST), 'r') as f:
                self._manifest = json.load(f)
        return self._manifest

    @property
    def id(self):
        return self.manifest['ID']

    @property
    def icon(self):
        return self.manifest['IcoPath']

    @property
    def action_keyword(self):
        return self.manifest['ActionKeyword']

    @property
    def version(self):
        return self.manifest['Version']

    @property
    def appdata(self):
        if not self._appdata:
            # Userdata should be up two directories from plugin root
            self._appdata = os.path.dirname(os.path.dirname(self.plugindir))
        return self._appdata

    @property
    def app_settings(self):
        if not self._app_settings:
            with open(os.path.join(self.appdata, 'Settings', 'Settings.json'), 'r') as f:
                self._app_settings = json.load(f)
        return self._app_settings

    @property
    def user_keywords(self):
        if not self._user_keywords:
            self._user_keywords = self.app_settings['PluginSettings']['Plugins'][self.id]['ActionKeywords']
        return self._user_keywords

    @property
    def user_keyword(self):
        return self.user_keywords[0]

    def appicon(self, icon):
        return os.path.join(self.appdir, 'images', icon + '.png')

    @property
    def applog(self):
        today = date.today().strftime('%Y-%m-%d')
        file = f"{today}.txt"
        return os.path.join(self.appdata, 'Logs', self.appversion, file)

    
    @property
    def appversion(self):
        if not self._appversion:
            self._appversion = os.path.basename(self.appdir).replace('app-', '')
        return self._appversion

    @property
    def logfile(self):
        file = f"{self.manifest['Name']}.log"
        return os.path.join(self.plugindir, file)

    @property
    def logger(self):
        if not self._logger:
            logger = logging.getLogger('')
            formatter = logging.Formatter(
                '%(asctime)s %(levelname)s (%(filename)s): %(message)s',
                datefmt='%H:%M:%S')
            logfile = logging.handlers.RotatingFileHandler(
                    self.logfile,
                    maxBytes=1024 * 1024,
                    backupCount=1)
            logfile.setFormatter(formatter)
            logger.addHandler(logfile)
            logger.setLevel(logging.DEBUG)
            self._logger = logger
        return self._logger

    @property
    def api(self):
        if not self._api:
            launcher = os.path.basename(os.path.dirname(self.appdir))
            if launcher == 'FlowLauncher':
                self._api = FLOW_API
            else:
                self._api = WOX_API
        return self._api

    @property
    def name(self):
        return self.manifest['Name']

    @property
    def author(self):
        return self.manifest['Author']

    @property
    def settings_path(self):
        if self._settings_path is None:
            dirname = f"Plugin.{self.name.capitalize()}.{self.author.capitalize()}"
            setting_file = "Settings.json"
            self._settings_path = os.path.join(self.appdata, 'Settings', 'Plugins', dirname, setting_file)
        return self._settings_path

    @property
    def settings(self):
        if self._settings is None:

            if not os.path.exists(os.path.dirname(self.settings_path)):
                os.mkdir(os.path.dirname(self.settings_path))
            self._settings = Settings(self.settings_path)
        return self._settings

    def change_query(self, query, requery=False):
        """
        change query
        """
        print(json.dumps({"method": f"{self.api}.ChangeQuery","parameters":[query,requery]}))

    def shell_run(self, cmd):
        """
        run shell commands
        """
        print(json.dumps({"method": f"{self.api}.ShellRun","parameters":[cmd]}))

    def close_app(self):
        """
        close launcher
        """
        print(json.dumps({"method": f"{self.api}.CloseApp","parameters":[]}))

    def hide_app(self):
        """
        hide launcher
        """
        print(json.dumps({"method": f"{self.api}.HideApp","parameters":[]}))

    def show_app(self):
        """
        show launcher
        """
        print(json.dumps({"method": f"{self.api}.ShowApp","parameters":[]}))

    def show_msg(self, title, sub_title, ico_path=""):
        """
        show messagebox
        """
        print(json.dumps({"method": f"{self.api}.ShowMsg","parameters":[title,sub_title,ico_path]}))

    def open_setting_dialog(self):
        """
        open setting dialog
        """
        self.logger.debug(json.dumps({"method": f"{self.api}.OpenSettingDialog","parameters":[]}))
        print(json.dumps({"method": f"{self.api}.OpenSettingDialog","parameters":[]}))

    def start_loadingbar(self):
        """
        start loading animation in wox
        """
        print(json.dumps({"method": f"{self.api}.StartLoadingBar","parameters":[]}))

    def stop_loadingbar(self):
        """
        stop loading animation in wox
        """
        print(json.dumps({"method": f"{self.api}.StopLoadingBar","parameters":[]}))

    def reload_plugins(self):
        """
        reload all launcher plugins
        """
        print(json.dumps({"method": f"{self.api}.ReloadPlugins","parameters":[]}))

class Settings(dict):

    def __init__(self, filepath):
        super(Settings, self).__init__()
        self._filepath = filepath
        self._save = True
        if os.path.exists(self._filepath):
            self._load()
        else:
            data = {}
            self.update(data)
            self.save()

        
    def _load(self):
        data = {}
        with open(self._filepath, 'r') as f:
            try:
                data.update(json.load(f))
            except json.decoder.JSONDecodeError:
                pass

        self._save = False
        self.update(data)
        self._save = True

    def save(self):
        if self._save:
            data = {}
            data.update(self)
            with open(self._filepath, 'w') as f:
                json.dump(data, f, sort_keys=True, indent=4)
        return
    
    def __setitem__(self, key, value):
        super(Settings, self).__setitem__(key, value)
        self.save()

    def __delitem__(self, key):
        super(Settings, self).__delitem__(key)
        self.save()

    def update(self, *args, **kwargs):
        super(Settings, self).update(*args, **kwargs)
        self.save()

    def setdefault(self, key, value=None):
        ret = super(Settings, self).setdefault(key, value)
        self.save()
        return ret
