from workstation1.lib.config import config


def info(message: str):
    print(f"{message}")

def warn(message: str):
    print(f"{message}")

def error(message: str):
    print(f"{message}")

def debug(message: str):
    if config['debug'] == True:
        print(f"{message}")
