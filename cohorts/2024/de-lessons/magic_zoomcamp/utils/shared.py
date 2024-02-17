import re

def camel_to_snake(name):
    # Replace lowercase-uppercase transitions with underscores
    name = re.sub(r'(?<=[a-z])(?=[A-Z])', '_', name)
    return name.lower()
