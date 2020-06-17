extensions = [
    'recommonmark',
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
epub_title = project
epub_author = author
epub_publisher = author
epub_copyright = copyright
epub_exclude_files = ['search.html']

html_context = {
        'display_gitlab': True,
        'theme_vcs_pageview_mode': 'edit/master',
        'gitlab_host': 'gitlab.devops.ifrn.edu.br',
        'gitlab_user': 'coapac.{SIGLA_CAMPUS}',
        'gitlab_repo': 'obs-horario',
        }
