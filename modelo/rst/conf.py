from recommonmark.parser import CommonMarkParser
source_parsers = {
    '.md': CommonMarkParser,
}
source_suffix = ['.rst', '.md']
import sys
import os
extensions = [
    'sphinx.ext.mathjax',
]
templates_path = ['_templates']
master_doc = 'index'
project = 'Horário {SIGLA_INSTITUICAO}/{SIGLA_CAMPUS} {ANO}.{PERIODO}'
copyright = '{ANO}, {COLABORADOR} em colaboração com Jurandy Soares'
author = 'Jurandy Soares'
version = '{ANO}.{PERIODO}'
release = '{ANO}.{PERIODO}'
language = 'pt_BR'
exclude_patterns = ['_build']
pygments_style = 'sphinx'
todo_include_todos = False
html_theme = 'sphinx_rtd_theme'
html_static_path = ['_static']
html_last_updated_fmt = '%d/%b/%Y'
html_show_sourcelink = False
html_search_language = 'pt'
htmlhelp_basename = 'Horario-{SIGLA_INSTITUICAO}-{SIGLA_CAMPUS}-{ANO}-{PERIODO}'
latex_elements = {
}
latex_documents = [
    (master_doc, 'Horario-{SIGLA_INSTITUICAO}-{SIGLA_CAMPUS}-{ANO}-{PERIODO}.tex', 'Horário {SIGLA_INSTITUICAO}/{SIGLA_CAMPUS} {ANO}.{PERIODO}',
     'Jurandy Soares', 'manual'),
]
man_pages = [
    (master_doc, 'Horario-{SIGLA_INSTITUICAO}-{SIGLA_CAMPUS}-{ANO}-{PERIODO}', 'Horário {SIGLA_INSTITUICAO}/{SIGLA_CAMPUS} {ANO}.{PERIODO}',
     [author], 1)
]
texinfo_documents = [
    (master_doc, 'Horario-{SIGLA_INSTITUICAO}-{SIGLA_CAMPUS}-{ANO}-{PERIODO}', 'Horário {SIGLA_INSTITUICAO}/{SIGLA_CAMPUS} {ANO}.{PERIODO}',
     author, 'Horario-{SIGLA_INSTITUICAO}-{SIGLA_CAMPUS}-{ANO}-{PERIODO}', 'Horário {SIGLA_INSTITUICAO}/{SIGLA_CAMPUS} {ANO}.{PERIODO}.',
     'Miscellaneous'),
]
epub_title = project
epub_author = author
epub_publisher = author
epub_copyright = copyright
epub_exclude_files = ['search.html']
