#
# pip install requests lxml
# Referências:
#  * Downloading Files from URLs in Python
#     https://www.codementor.io/aviaryan/downloading-files-from-urls-in-python-77q3bs0un
#  * Como fazer webscraping com Python e Beautiful Soup
#     https://medium.com/horadecodar/como-fazer-webscraping-com-python-e-beautiful-soup-28a65eee2efd 

import requests
import re

def pega_arq_disposicao_conteudo(cd):
    if not cd:
        return None
    nome_arq = re.findall('filename="(.+)"', cd)
    if len(nome_arq) == 0:
        return None
    return nome_arq[0]

def principal():
    html = requests.get('http://diatinf.ifrn.edu.br/doku.php?id=comissoes:horarios:2019-2:start')
    from bs4 import BeautifulSoup
    bs = BeautifulSoup(html.text, 'lxml')
    enlaces = bs.find_all('a', href=True)


    for e in enlaces:
        url = e['href']
        if url.endswith('.pdf'):
            req = requests.get('http://diatinf.ifrn.edu.br/'+url, allow_redirects=True)
            nome_arq = pega_arq_disposicao_conteudo(req.headers.get('content-disposition'))
            open(nome_arq, 'wb').write(req.content)

if __name__ == '__main__':
    principal()