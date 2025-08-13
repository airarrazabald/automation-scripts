import os
import yaml
import re
from urllib.parse import urlparse

def find_target_url(data):
    if isinstance(data, dict):
        for key, value in data.items():
            if key == 'target-url':
                return value
            result = find_target_url(value)
            if result:
                return result
    elif isinstance(data, list):
        for item in data:
            result = find_target_url(item)
            if result:
                return result
    return None

def clean_domain(url):
    try:
        parsed = urlparse(url)
        domain = parsed.netloc or parsed.path.split('/')[0]
        # Eliminar puertos y subdominios si es necesario
        domain = re.sub(r'^https?://', '', domain)
        domain = domain.replace(':', '').replace('/', '')
        return domain
    except Exception:
        return url  # Si falla, devuelve el original

def clean_url(url):
    # Eliminar patrones específicos
    for pattern in ['$(target-url)$', '(api.operation.path)', '$(request.search)']:
        url = url.replace(pattern, '')
    
    # Extraer solo el dominio
    parsed = urlparse(url)
    return parsed.netloc


def extract_target_urls_from_yml_files(root_path, output_file):
    target_urls = []

    for dirpath, _, filenames in os.walk(root_path):
        for filename in filenames:
            if filename.endswith(('.yaml', '.yml')):
                file_path = os.path.join(dirpath, filename)
                print(f"Archivo YAML encontrado: {file_path}")
                try:
                    with open(file_path, 'r', encoding='utf-8') as f:
                        data = yaml.safe_load(f)
                        url = find_target_url(data)
                        if url:
                            cleaned = clean_url(url)
                            if cleaned:
                                cleaned = clean_domain(url)
                                target_urls.append(cleaned)
                except Exception as e:
                    print(f"Error leyendo {file_path}: {e}")

    with open(output_file, 'w', encoding='utf-8') as out_file:
        for url in target_urls:
            out_file.write(url + '\n')

if __name__ == "__main__":
    input_folder = "C:\\swagger-datapower\\"
    output_file = "urls-encontradas.txt"
    extract_target_urls_from_yml_files(input_folder, output_file)
