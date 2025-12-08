from enum import Enum
import sys
from typing import Any
from workstation1.lib.config import config


class Level(Enum):
    DEBUG = 0
    INFO = 1
    WARNING = 2
    ERROR = 3
    HEADER = 4

class Mode(Enum):
    DIRECT = 0
    BUFFERED = 1

class Colours:
    HEADER = '\033[95m'
    OKBLUE = '\033[94m'
    OKCYAN = '\033[96m'
    OKGREEN = '\033[92m'
    WARNING = '\033[93m'
    FAIL = '\033[91m'
    ENDC = '\033[0m'
    BOLD = '\033[1m'
    UNDERLINE = '\033[4m'


indentation = config['indentation']

# success_symbol = '✔'
# failure_symbol = '✘'
success_symbol = u'\u2714'
failure_symbol = u'\u2718'

success_messages = ['step completed', 'already done']
failure_messages = ['step failed', 'not attempted']


def info(message: str, indent: int = 0):
    print(f"{indentation * (indent + 1)}{message}")

def warn(message: str, indent: int = 0):
    print(f"{indentation * (indent + 1)}{message}")

def error(message: str, indent: int = 0):
    print(f"{indentation * (indent + 1)}{message}")

def debug(message: str, indent: int = 0):
    if config['debug']:
        print(f"{indentation * (indent + 1)}{message}")


class Logger:
    '''
    Buffered mode saves log messages and prints them at the end of the step.
    This makes it possible to indicate success or failure of the step
    by adding an icon to the first message.
    
    Direct mode prints log messages immediately.
    '''
    def __init__(self, indent: int = 0):
        self.indent = indent
        self.mode = Mode.DIRECT
        self.buffer: list[dict[str, Any]] = []

    def set_indent(self, indent: int):
        self.indent = indent

    def show(self, msg: dict[str, Any]):
        if msg['level'] == Level.DEBUG and not config['debug']:
            return
        
        for text in success_messages:
            if text in msg['message'].lower():
                return # Do not print success messages. Success symbol is enough to convey meaning.

        if msg['level'] == Level.HEADER:
            print(f"{indentation * (msg['indent'])}{Colours.OKGREEN}{msg['message']}{Colours.ENDC}")
            return
            
        print(f"{indentation * (msg['indent'])}{msg['message']}")

    def begin(self, message: str):
        self.mode = Mode.BUFFERED
        self.buffer.append({'level': Level.INFO, 'message': message, 'indent': self.indent})

    def end(self, message: str):
        msg = {'level': Level.HEADER, 'message': message, 'indent': self.indent}
        self.mode = Mode.DIRECT
        for text in success_messages:
            if text in msg['message'].lower():
                self.buffer[0]['message'] += f" {success_symbol}"
                break
        for text in failure_messages:
            if text in msg['message'].lower():
                self.buffer[0]['message'] += f" {failure_symbol}"
                break
        
        for saved_msg in self.buffer:
            self.show(saved_msg)
        self.buffer = []
        self.show(msg)

    def info(self, message: str):
        msg = {'level': Level.INFO, 'message': message, 'indent': self.indent + 1}
        if self.mode == Mode.BUFFERED:
            self.buffer.append(msg)
        else:
            self.show(msg)

    def warn(self, message: str):
        msg = {'level': Level.WANRNING, 'message': message, 'indent': self.indent + 1}
        if self.mode == Mode.BUFFERED:
            self.buffer.append(msg)
        else:
            self.show(msg)

    def warning(self, message: str):
        self.warn(message)

    def error(self, message: str):
        msg = {'level': Level.ERROR, 'message': message, 'indent': self.indent + 1}
        if self.mode == Mode.BUFFERED:
            self.end(message)
        else:
            self.show(msg)
        sys.exit(1)

    def debug(self, message: str):
        msg = {'level': Level.DEBUG, 'message': message, 'indent': self.indent + 1}
        if self.mode == Mode.BUFFERED:
            self.buffer.append(msg)
        else:
            self.show(msg)

log = Logger()